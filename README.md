#### LAB PGTBL （2021 MIT6S018）
[官网实验地址](https://pdos.csail.mit.edu/6.828/2021/labs/pgtbl.html)
这个实验帮助理解页表及其怎么将虚拟地址转换为物理地址。
![XV6的PTE](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220103134110.png)
![XV6的虚地址](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220103134159.png)

**首先需要彻底理解vm.c下的walkaddr函数**
```c
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc) {
  if(va >= MAXVA)
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)]; //取得level的PTE，PX得到该va的level索引
    if(*pte & PTE_V) {                        //如果该PTE有效
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {                                //否则新分配一个物理页作为该level的table
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];         //返回va的level0的PTE
}
```
![通过这张图就能很清楚的明白](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220103135607.png)

##### Speed up system calls (easy)
分配一个物理页给只读的系统调用加速，并且将其映射在虚拟地址USYSCALL上。
* 在proc.h添加一个usyscall的结构体
```c
struct proc
{
    struct usyscall *usyscall;
};
```
* 在proc.c处的分配和释放进程添加相应的代码
```c
void allocproc()
{
found:
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0)//分配一个物理页给usyscall结构体
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }
  memset(p->usyscall, 0, PGSIZE);
  p->usyscall->pid = p->pid;    
}

//进行虚实地址映射
pagetable_t
proc_pagetable(struct proc *p)
{
  if (mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usyscall), PTE_R | PTE_U) < 0)
  {
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }
}

//释放进程时要进行解除映射
void proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
    uvmunmap(pagetable, USYSCALL, 1, 0);
}
//并释放该物理页
static void
freeproc(struct proc *p)
{
    if (p->usyscall)
    kfree((void *)p->usyscall);
    p->usyscall = 0;
}
```
##### Print a page table (easy)
递归调用即可
```c
const static char _vmprintprefix[][10] = {" ..", " .. ..", " .. .. .."};

static void _vmprint(pagetable_t ptbl, int depth)
{
  for (int i = 0; i < 512; ++i)
  {
    pte_t pte = ptbl[i];
    if (pte & PTE_V)
    {
      printf("%s%d: pte %p pa %p\n", _vmprintprefix[depth], i, pte, PTE2PA(pte));
      if (depth < 2)
      {
        _vmprint((pagetable_t)(PTE2PA(pte)), depth + 1);
      }
    }
  }
}

void vmprint(pagetable_t ptbl)
{
  printf("page table %p\n", ptbl);
  _vmprint(ptbl, 0);
}
```
>Explain the output of vmprint in terms of Fig 3-4 from the text. What does page 0 contain? What is in page 2? When running in user mode, could the process read/write the memory mapped by page 1? What does the third to last page contain?
![20220103141448](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220103141448.png)

根据这个图还有打印出来的地址值（可以在分配页面时打印出text stack trampoline的地址）显然可以得出page0是程序的text和data段，page2是程序的stack段，page1是guard段,在exec中查代码发现其连续分配两个page，高地址page用作stack，低地址page用作guard，并且对guard进行clear，也就是其PTE的U为0，所以不能进行读写。剩下的都是高地址段：依次是自己定义的usyscall，trapframe，trampoline
```c
  //exec.c
  // Allocate two pages at the next page boundary.
  // Use the second as the user stack.
  sz = PGROUNDUP(sz);
  uint64 sz1;
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    goto bad;
  sz = sz1;
  uvmclear(pagetable, sz - 2 * PGSIZE);
  sp = sz;
  stackbase = sp - PGSIZE;
```
##### Detecting which pages have been accessed (hard)
vm.c中walkaddr显然是用来进行用户访存的，针对该函数下手。
* 首先在risv.h定义一些宏，很显而易见的含义
```c
#define PTE_A (1L << 6)

#define SET_PTE_A(pte) ((pte) | (PTE_A))
#define CLEAR_PTE_A(pte) ((pte) & (~PTE_A))
```
* 在vm.c的walkaddr中每当有访问那么就将该PTE的A位置位
```c
walkaddr(pagetable_t pagetable, uint64 va)
{
  pa = PTE2PA(*pte);
  *pte = SET_PTE_A(*pte);
}
```
* 在sysproc.c中将实现该函数
```c
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 base, mask;
  int len;
  if (argaddr(0, &base) < 0)
  {
    return -1;
  }
  if (argint(1, &len) < 0)
  {
    return -1;
  }
  if (argaddr(2, &mask) < 0)
  {
    return -1;
  }
  struct proc *myp = myproc();
  uint64 va = PGROUNDDOWN((uint64)base);
  char kernalbuf[256] = {0};
  if (len > 256 * 8)
  {
    return -1;
  }
  for (int i = 0; i < len; ++i)
  {
    pte_t *pte = walk(myp->pagetable, va, 0);
    if (pte == 0)
    {
      return -1;
    }
    if ((*pte & PTE_A))
    {
      //printf("va: %p i: %d\n", va, i);
      kernalbuf[i / 8] |= (1 << (i % 8));
      *pte = CLEAR_PTE_A(*pte);
    }
    va += PGSIZE;
  }
  int clen = len / 8;
  if (len % 8 != 0)
  {
    clen += 1;
  }
  if (copyout(myp->pagetable, mask, kernalbuf, clen) < 0)
  {
    return -1;
  }
  return 0;
}
```

#### Challenge
只写一些想法，因为也没有测试可以check
* **Use super-pages to reduce the number of PTEs in page tables.**
对于trampoline，tranframe，usys等固定占页的，可以对每个进程都分配一个super page，该page的PTE下标是这些固定page的后9位，直接指向了这些固定页的物理页，可以减少level1和level2的pagetable。简而言之就是对一些特殊的地址减少页表的级数。
* **Unmap the first page of a user process so that dereferencing a null pointer will result in a fault. You will have to start the user text segment at, for example, 4096, instead of 0.**
对于C语言来说，NULL其实就是0，在这个版本的实现中，程序的text段是从地址0开始的，也就是指向虚拟地址0的PTE的V位为1，所以如果用户解引用虚拟地址0，那么不会得到段错误。
* **Add a system call that reports dirty pages (modified pages) using PTE_D.**
与实现PTE_A类似，但是找不到一种机制可以通知内核该页已修改，一种想法是给walkaddr多加一个参数，指示是否修改该页，但是显然行不通。猜测该系统访存的调用栈是：pa=walkaddr(va) -> modify(pa)，但是搜索了全文件都找不到这个调用。 