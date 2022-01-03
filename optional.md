* **Use super-pages to reduce the number of PTEs in page tables.**
对于trampoline，tranframe，usys等固定占页的，可以对每个进程都分配一个super page，该page的PTE下标是这些固定page的后9位，直接指向了这些固定页的物理页，可以减少level1和level2的pagetable。简而言之就是对一些特殊的地址减少页表的级数。
* **Unmap the first page of a user process so that dereferencing a null pointer will result in a fault. You will have to start the user text segment at, for example, 4096, instead of 0.**
对于C语言来说，NULL其实就是0，在这个版本的实现中，程序的text段是从地址0开始的，也就是指向虚拟地址0的PTE的V位为1，所以如果用户解引用虚拟地址0，那么不会得到段错误。
* **Add a system call that reports dirty pages (modified pages) using PTE_D.**
与实现PTE_A类似，但是找不到一种机制可以通知内核该页已修改，一种想法是给walkaddr多加一个参数，指示是否修改该页，但是显然行不通。猜测该系统访存的调用栈是：pa=walkaddr(va) -> modify(pa)，但是搜索了全文件都找不到这个调用。 