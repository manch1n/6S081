### LAB TRAPS (2021 MIT6S018)
[官网实验地址](https://pdos.csail.mit.edu/6.828/2021/labs/traps.html)
[我的lab地址](https://github.com/manch1n/6S081lab/tree/mytraps)

理解这个实验,首先要理解XV6处理trap(异常 中断 系统调用)的相关寄存器和调用链
##### 相关寄存器
* **stvec** trap的处理地址,通常是uservec与kernalvec
* **sepc** trap处理后返回用户执行的指令地址,如果是系统调用,那么这个值需要+=4
* **scause** 描述了导致trap的原因
* **sscratch** 由于需要保存寄存器上下文,需要多余一个寄存器来充当基址来索引保存的作用
* **sstatus** 其中的SIE位控制是否可中断,SPP位指明从用户trap还是内核trap.

##### 调用过程
* 如果是系统调用,首先要进行ecall,比如write的系统调用:
```
…
.global write
write:
li a7, SYS_write
ecall
ret
…
```
&emsp;&emsp;这里的a7寄存器指明了系统调用的索引.ecall做两件事,改变处理器的执行权限为supervisor,跳跃到stvec(一般情况下是uservec)所指的trap处理地址.
* trampoline,保存着user的trap的处理指令uservec与userret.这里把寄存器上下文保存到进程的trapframe当中,然后恢复kernal的栈,页表,寄存器上下文,然后执行处理具体trap的代码,这在trap.c
* usertrap,判断导致trap的原因,并且根据不同情况来处理trap
* 如果是系统调用,那么则执行系统调用的具体代码,比如write执行sys_write()

具体可以参考[XV6的官方详细详解](https://pdos.csail.mit.edu/6.828/2021/xv6/book-riscv-rev2.pdf)与[ppt](https://pdos.csail.mit.edu/6.828/2021/slides/6s081-lec-syscall.pdf)
返回过程做着相反的事情.

#### RISC-V assembly (easy)
```assembly
int g(int x) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  return x+3;
}
   6:	250d                	addiw	a0,a0,3
   8:	6422                	ld	s0,8(sp)
   a:	0141                	addi	sp,sp,16
   c:	8082                	ret

000000000000000e <f>:

int f(int x) {
   e:	1141                	addi	sp,sp,-16
  10:	e422                	sd	s0,8(sp)
  12:	0800                	addi	s0,sp,16
  return g(x);
}
  14:	250d                	addiw	a0,a0,3
  16:	6422                	ld	s0,8(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <main>:

void main(void) {
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  printf("%d %d\n", f(8)+1, 13);
  24:	4635                	li	a2,13
  26:	45b1                	li	a1,12
  28:	00000517          	auipc	a0,0x0
  2c:	7c050513          	addi	a0,a0,1984 # 7e8 <malloc+0xea>
  30:	00000097          	auipc	ra,0x0
  34:	610080e7          	jalr	1552(ra) # 640 <printf>
  exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	27e080e7          	jalr	638(ra) # 2b8 <exit>
```
>Which registers contain arguments to functions? For example, which register holds 13 in main's call to printf?

查看源码显然是a1

>Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)

在0x26地址处可以看到f的调用被优化掉了.

>At what address is the function printf located?

0x640

>What value is in the register ra just after the jalr to printf in main?

这个汇编说实话也看不太懂,auipc与jalr这个通常是配对使用用来指令跳转用的,我猜应该是printf的地址,即0x640

>Run the following code.
>
>	unsigned int i = 0x00646c72;
>	printf("H%x Wo%s", 57616, &i);
>      
>What is the output? Here's an ASCII table that maps bytes to characters.
The output depends on that fact that the RISC-V is little-endian. If the RISC-V were instead big-endian what would you set i to in order to yield the same output? Would you need to change 57616 to a different value?

显然是He110 World

>In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?
>
>	printf("x=%d y=%d", 3);

由源码可知,printf会使用a2寄存器处的值做为第二个参数,a2不确定自然输出的是个无定义的值.

#### Backtrace (moderate)
这里需要理解的是程序的调用栈.这个提示很重要:
>Note that the return address lives at a fixed offset (-8) from the frame pointer of a stackframe, and that the saved frame pointer lives at fixed offset (-16) from the frame pointer.
![20220122144714](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220122144714.png)
```c
void backtrace(void)
{
  uint64 fp = r_fp();
  printf("backtrace:\n");
  uint64 stackpage = PGROUNDDOWN(fp);
  while (1)
  {
    printf("%p\n", *(uint64 *)((char *)fp - 8)); //return address
    uint64 savefp = *(uint64 *)((char *)fp - 16);
    //printf("%p\n", (void *)savefp);
    fp = savefp;
    if (PGROUNDDOWN(fp) != stackpage)
    {
      break;
    }
  }
}
```
一直遍历到当前的保存的栈帧指针不属于这个栈为止.

#### Alarm (hard)
##### test0: invoke handler
```c
  // in trap.c usertrapret()
  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
```
这里需要理解的是处理完trap的返回用户执行的地址,在trapret阶段会将pc值设置为trapframe的epc值.如果是系统调用,那么epc自增4.如果是其他则另外考虑,比如这里的alarm,显然需要跳转到handler的处理地址.
```c
    //in trap.c usertrap()
  else if ((which_dev = devintr()) != 0)
  {
    if (which_dev == 2 && p->alarminternal != 0)
    {
      p->ntickssincelast += 1;
      if (p->ntickssincelast == p->alarminternal)
      {
        p->trapframe->epc = (uint64)p->alarmhandler;
        p->ntickssincelast = 0;
      }
    }
  }
```
##### test1/test2(): resume interrupted code
这里应该可以说是本次实验最难的部分了,需要彻底理解这个调用过程.先来看已完成的部分:
![20220122151208](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220122151208.png)
这里执行到某处时,alarm信号发出,如果刚好等于设定的internal,则设置pc执行为handler,此时恢复完中断的上下文后才执行handler,执行完后此时的寄存器上下文与将要执行的下一个指令地址无从得知.
所以要在trap阶段保存中断处的寄存器上下文,并且在sigreturn时将其恢复.
![20220122152540](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220122152540.png)
解释一下为什么要sigreturn手动恢复中断处寄存器的上下文,因为不加修改时,sigreturn恢复的是handler处的寄存器上下文,而不是中断处的上下文.
要使handler不可重入,添加一个标志位即可.
要保存恢复的寄存器值为调用者与被调用者保存的寄存器:
![20220122152122](https://raw.githubusercontent.com/manch1n/picbed/master/images/20220122152122.png)
具体实现的懒人做法可以在trap处直接复制一整个trapframe.
```c
  else if ((which_dev = devintr()) != 0)
  {
    if (which_dev == 2 && p->alarminternal != 0)
    {
      p->ntickssincelast += 1;
      if (p->ntickssincelast == p->alarminternal)
      {
        if (p->insighandler == 0)
        {
          memmove(&p->savesigalarm, p->trapframe, sizeof(struct trapframe));
          p->trapframe->epc = (uint64)p->alarmhandler;
          p->insighandler = 1;
        }
        p->ntickssincelast = 0;
      }
    }
  }
```
在sigreturn处恢复:
```c
uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();
  struct trapframe *tf = p->trapframe;
  struct trapframe *stf = &p->savesigalarm;
  tf->epc = stf->epc;
  tf->ra = stf->ra;
  tf->sp = stf->sp;
  tf->t0 = stf->t0;
  tf->t1 = stf->t1;
  tf->t2 = stf->t2;
  tf->s0 = stf->s0;
  tf->s1 = stf->s1;
  tf->a0 = stf->a0;
  tf->a1 = stf->a1;
  tf->a2 = stf->a2;
  tf->a3 = stf->a3;
  tf->a4 = stf->a4;
  tf->a5 = stf->a5;
  tf->a6 = stf->a6;
  tf->a7 = stf->a7;
  tf->s2 = stf->s2;
  tf->s3 = stf->s3;
  tf->s4 = stf->s4;
  tf->s5 = stf->s5;
  tf->s6 = stf->s6;
  tf->s7 = stf->s7;
  tf->s8 = stf->s8;
  tf->s9 = stf->s9;
  tf->s10 = stf->s10;
  tf->s11 = stf->s11;
  tf->t3 = stf->t3;
  tf->t4 = stf->t4;
  tf->t5 = stf->t5;
  tf->t6 = stf->t6;

  p->insighandler = 0;
  return 0;
}

```
