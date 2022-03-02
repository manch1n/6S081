### LAB Copy On Write (2021 MIT6S081)
[官网实验地址](https://pdos.csail.mit.edu/6.828/2021/labs/cow.html)
[我的lab地址](https://github.com/manch1n/6S081lab/tree/mycow)

这个实验其实是前面两个实验的综合,既要理解虚拟内存机制又要理解中断机制.
这个实验要求我们优化fork时使用的内存,原始fork的策略是原样复制父进程的所有页面,造成了浪费,然而对一些只读页面可以共享而不是复制,等到写时才分配新的物理页,这就是写是复制.
```c
    //uvmcopy 原始方案
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0) //直接分配内存
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }
  }
```

解决方案实验页面已经写的很清楚了:
>Here's a reasonable plan of attack.
Modify uvmcopy() to map the parent's physical pages into the child, instead of allocating new pages. **Clear PTE_W in the PTEs of both child and parent.**
**Modify usertrap() to recognize page faults. When a page-fault occurs on a COW page, allocate a new page with kalloc(), copy the old page to the new page, and install the new page in the PTE with PTE_W set.**
Ensure that each physical page is freed when the last PTE reference to it goes away -- but not before. A good way to do this is to keep, for each physical page, a "reference count" of the number of user page tables that refer to that page. Set a page's reference count to one when kalloc() allocates it. Increment a page's reference count when fork causes a child to share the page, and decrement a page's count each time any process drops the page from its page table. kfree() should only place a page back on the free list if its reference count is zero. It's OK to to keep these counts in a fixed-size array of integers. You'll have to work out a scheme for how to index the array and how to choose its size. For example, **you could index the array with the page's physical address divided by 4096, and give the array a number of elements equal to highest physical address of any page placed on the free list by kinit() in kalloc.c.**
Modify copyout() to use the same scheme as page faults when it encounters a COW page.
Some hints:
The lazy page allocation lab has likely made you familiar with much of the xv6 kernel code that's relevant for copy-on-write. However, you should not base this lab on your lazy allocation solution; instead, please start with a fresh copy of xv6 as directed above.
It may be useful to have a way to record, for each PTE, whether it is a COW mapping. **You can use the RSW (reserved for software) bits in the RISC-V PTE for this.**
usertests explores scenarios that cowtest does not test, so don't forget to check that all tests pass for both.
Some helpful macros and definitions for page table flags are at the end of kernel/riscv.h.
If a COW page fault occurs and there's no free memory, the process should be killed.

##### 总结下来:
* 利用PTE的保留位,设计一个用于标记该页面是写时复制的PTE_C位.
![20220302141727](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220302141727.png)
```c
//risv.h
#define PTE_C (1L << 8)
#define PTE_CLEAR_W(pte) ((pte) & (~PTE_W))
```
* 分配一些索引页面用来记录页面引用数,这里我直接在可用的物理内存的高位占用了8个物理页.8=(0x88000000-0x80000000)/4096/4096,被除数是可用物理内存,第一个除4096的结果是可用物理内存的页面数,第二个是每个索引占用1个字节,也即每个页面有4096个索引.
```c
//memorylayout.h
#define COWBASE (PHYSTOP - 8 * PGSIZE)
//kallo.c
void kinit()
{
    initlock(&kmem.lock, "kmem");
    freerange(end, (void *)COWBASE);
    memset((void *)COWBASE, 0, 8 * PGSIZE);
}
//riscv.h
#define PTCOWIDX(pa) (((pa)&0x7FFFFFF) / 4096)
```
* 修改uvmcopy函数,根据页面是否置PTE_位,记录COW的引用数.
```c
// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;
  //  clear the W flag instead of malloc a new page
  for (i = 0; i < sz; i += PGSIZE)
  {
    if ((pte = walk(old, i, 0)) == 0)
    {
      panic("uvmcopy: pte should exist");
    }
    if ((*pte & PTE_V) == 0)
    {
      panic("uvmcopy: page not present");
    }
    pa = PTE2PA(*pte);
    uint8 *cow_base = (uint8 *)COWBASE;
    if ((*pte & PTE_C) == 0) //未置位
    {
      *pte = PTE_CLEAR_W(*pte);
      *pte |= PTE_C;
      flags = PTE_FLAGS(*pte);
      cow_base[PTCOWIDX(pa)] = 2; //父子进程均引用这个页面
      // printf("ucpy: %p pa:%p idx:%d \n", *pte, pa, PTCOWIDX(pa));
    }
    else
    {
      // printf("no map\n");
      flags = PTE_FLAGS(*pte);
      cow_base[PTCOWIDX(pa)] += 1;//已置位则直接加1
    }
    if (mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    {
      goto err;
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}
```
* xv6的写page fault的trap号为15,在usertrap中识别这个trap并复制导致fault的页面.
![20220302144547](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220302144547.png)
>1. The VA that caused the fault? 导致page fault的虚拟地址
• STVAL, or r_stval() in xv6
```c
//trap.c
  //  write page fault
  else if (r_scause() == 15) //识别该trap类型
  {
    uint64 va = r_stval(); //导致报错的虚拟地址
    if (va >= MAXVA)
    {
      p->killed = 1;
      exit(-1);
    }
    uint64 pa = walkaddr(p->pagetable, va);

    pte_t *pte;
    if ((pte = walk(p->pagetable, va, 0)) == 0)
    {
      panic("page fault walk\n");
    }
    if ((*pte & PTE_C) == 0)
    {
      printf("%p %p\n", *pte, pa);
      panic("no cow flag\n");
    }

    char *mem;
    if ((mem = kalloc()) == 0)
    {
      printf("page fault malloc phy fail\n");
      p->killed = 1;
      exit(-1);
    }
    memmove(mem, (char *)pa, PGSIZE);
    uvmunmap(p->pagetable, PGROUNDDOWN(va), 1, 0);
    if ((mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U)) != 0)
    {
      panic("page fault unable to map\n");
    }

    { // free the cow page if mapped count == 0
      uint8 *cow_base = (uint8 *)COWBASE;
      cow_base[PTCOWIDX(pa)] -= 1;
      if (cow_base[PTCOWIDX(pa)] == 0)
      {
        kfree((void *)PGROUNDDOWN(pa));
      }
    }
  }
```
* 同时在进程退出时也要进行减小PTE_C页面的引用数量,并在为0时释放页面.
```c
//vm.c
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;
  uint8 *cow_base = (uint8 *)COWBASE;
  if ((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    uint64 pa = PTE2PA(*pte);
    if (do_free) 
    {
      if ((PTE_FLAGS(*pte) & PTE_C) != 0)
      {
        cow_base[PTCOWIDX(pa)] -= 1;
        if (cow_base[PTCOWIDX(pa)] == 0) 
        {
          kfree((void *)pa);
        }
      }
      else
      {
        kfree((void *)pa);
      }
    }
    *pte = 0;
  }
}
```