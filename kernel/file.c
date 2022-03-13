//
// Support functions for system calls that involve file descriptors.
//

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "stat.h"
#include "proc.h"
#include "fcntl.h"
#include "memlayout.h"
struct devsw devsw[NDEV];
struct
{
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

// FIXME:在进程退出时释放没有写
struct
{
  struct mmap mmap[MMAPMAX];
  struct spinlock lock;
} mmaptable;

struct mmap *mmapret[MMAPMAX];

void fileinit(void)
{
  initlock(&ftable.lock, "ftable");

  // init mmap
  initlock(&mmaptable.lock, "mmap");
  for (int i = 0; i < MMAPMAX; ++i)
  {
    mmaptable.mmap[i].used = 0;
  }
}

// should hold the lock
uint64 mmapbase(int pid)
{
  uint64 max = MMAPBASE;
  for (int i = 0; i < MMAPMAX; ++i)
  {
    struct mmap *m = &mmaptable.mmap[i];
    if (m->used)
    {
      for (int p = 0; p < m->nref; ++p)
      {
        if (m->pid[p] == pid)
        {
          uint64 mm = m->start + m->length;
          if (mm > max)
          {
            max = PGROUNDUP(mm);
          }
        }
      }
    }
  }
  return max;
}

// should hold the lock
struct mmap *vammap(uint64 addr, int pid)
{
  struct mmap *m = 0;
  for (int i = 0; i < MMAPMAX; ++i)
  {
    m = &mmaptable.mmap[i];
    if (m->used)
    {
      for (int p = 0; p < m->nref; ++p)
      {
        if (m->pid[p] == pid && addr >= m->begin[p] && addr < m->end[p])
        {
          return m;
        }
      }
    }
  }
  return 0;
}

struct mmap *getmmapbyfile(struct file *f, int pid)
{
  for (int i = 0; i < MMAPMAX; ++i)
  {
    struct mmap *m = &mmaptable.mmap[i];
    if (m->used && m->file == f)
    {
      for (int j = 0; j < m->nref; ++j)
      {
        if (m->pid[j] == pid)
        {
          return m;
        }
      }
    }
  }
  return 0;
}

// for simplicity len must be page-aligned
uint64 allocmmap(int fd, int perm, int mflags, uint64 len)
{
  if (len % PGSIZE != 0)
  {
    return -1;
  }
  acquire(&mmaptable.lock);
  struct proc *p = myproc();
  struct mmap *m = 0;
  m = getmmapbyfile(p->ofile[fd], p->pid);
  if (m != 0) // already mapped
  {
    if (len > m->length)
    {
      for (uint64 va = m->start + m->length; va < m->start + len; va += PGSIZE)
      {
        if (mappages(p->pagetable, va, PGSIZE, (uint64)p->mmapfakepage, PTE_M | PTE_U) < 0)
        {
          panic("mmap mappages");
        }
      }
      m->length = len;
    }
    release(&mmaptable.lock);
    return m->start;
  }
  for (int i = 0; i < MMAPMAX; ++i)
  {
    if (mmaptable.mmap[i].used == 0)
    {
      m = &mmaptable.mmap[i];
      break;
    }
  }
  if (m == 0)
  {
    release(&mmaptable.lock);
    return -1;
  }
  m->file = p->ofile[fd];
  if (m->file->writable == 0 && (perm & PROT_WRITE) && !(mflags & MAP_PRIVATE))
  {
    release(&mmaptable.lock);
    return -1;
  }
  filedup(m->file);
  m->pid[0] = p->pid;
  m->length = len;
  m->nref = 1;
  uint64 vastart = mmapbase(p->pid);
  m->start = vastart;
  m->begin[0] = m->start;
  m->end[0] = m->start + len;
  for (uint64 i = 0; i < len; i += PGSIZE)
  {
    if (mappages(p->pagetable, vastart + i, PGSIZE, (uint64)p->mmapfakepage, PTE_M | PTE_U) < 0)
    {
      panic("mmap mappages");
    }
  }
  int flags = 0;
  if (perm & PROT_EXEC)
  {
    flags |= PTE_X;
  }
  if (perm & PROT_READ)
  {
    flags |= PTE_R;
  }
  if (perm & PROT_WRITE)
  {
    flags |= PTE_W;
  }
  flags |= PTE_U;
  flags |= PTE_M;
  m->flags = flags;
  m->used = 1;
  m->mflag = mflags;
  release(&mmaptable.lock);
  return vastart;
}

uint64 readmmap(uint64 va, int write)
{
  struct proc *p = myproc();
  struct mmap *mm = vammap(va, p->pid);
  if (write && !(mm->flags & PTE_W))
  {
    return -1;
  }
  if (mm == 0)
  {
    panic("no vaddr");
  }
  begin_op();
  ilock(mm->file->ip);
  for (uint64 a = PGROUNDDOWN(va); a <= va; a += PGSIZE)
  {
    void *newmem = kalloc();
    if (newmem == 0)
    {
      panic("no memory");
    }
    int nread = readi(mm->file->ip, 0, (uint64)newmem, a - mm->start, PGSIZE);
    if (nread < PGSIZE)
    {
      memset((char *)newmem + nread, 0, (PGSIZE - nread));
    }
    uvmunmap(p->pagetable, a, 1, 0);
    if (mappages(p->pagetable, a, PGSIZE, (uint64)newmem, mm->flags) < 0)
    {
      panic("trap mmap");
    }
  }
  iunlock(mm->file->ip);
  end_op();
  return 0;
}

// should hold the lock
int getmmap(int pid)
{
  int tot = 0;
  for (int i = 0; i < MMAPMAX; ++i)
  {
    struct mmap *m = &mmaptable.mmap[i];
    if (m->used)
    {
      for (int j = 0; j < m->nref; ++j)
      {
        if (m->pid[j] == pid)
        {
          mmapret[tot] = m;
          tot++;
        }
      }
    }
  }
  return tot;
}

int mmapidx(struct mmap *m, int pid)
{
  for (int i = 0; i < m->nref; ++i)
  {
    if (m->used && m->pid[i] == pid)
    {
      return i;
    }
  }
  return -1;
}

void mmapcopy(struct proc *old, struct proc *new)
{
  acquire(&mmaptable.lock);
  int tot = getmmap(old->pid);
  for (int i = 0; i < tot; ++i)
  {
    struct mmap *mm = mmapret[i];
    if (mm->nref == MMAPMAX)
    {
      panic("no room for mmapcopy");
    }
    mm->pid[mm->nref] = new->pid;
    mm->begin[mm->nref] = mm->begin[mm->nref - 1];
    mm->end[mm->nref] = mm->end[mm->nref - 1];
    mm->nref++;
    // copy the map vm to new vm
    int idx = mmapidx(mm, old->pid);
    for (uint64 va = mm->begin[idx]; va < mm->end[idx]; va += PGSIZE)
    {
      pte_t *pte = walk(old->pagetable, va, 1);
      if (pte == 0)
      {
        panic("mmapcopy");
      }
      uint64 pa = PTE2PA(*pte);
      int flags = PTE_FLAGS(*pte);
      if (mappages(new->pagetable, va, PGSIZE, pa, flags) < 0)
      {
        panic("mmapcopy:could not map");
      }
    }
  }
  release(&mmaptable.lock);
}

void _freemapped(struct file *f, uint64 start, int len, int mflags, int flags, int free)
{
  struct proc *p = myproc();
  for (uint64 va = start; va < start + len; va += PGSIZE)
  {
    uint64 pa = walkaddr(p->pagetable, va);
    if (pa != (uint64)p->mmapfakepage && (mflags & MAP_SHARED) && (flags & PTE_W))
    {
      int nwrite = -1;
      if ((nwrite = filewrite(f, va, PGSIZE)) != PGSIZE)
      {
        printf("nwrite:%d\n", nwrite);
        panic("freemap filewrite");
      }
      uvmunmap(p->pagetable, va, 1, free);
    }
    else
    {
      uvmunmap(p->pagetable, va, 1, 0); // do not free the fake page
    }
  }
}

// for simplicity,addr and len must be page-aligned
uint64 freemmap(uint64 addr, int len)
{
  if (addr % PGSIZE != 0 || len % PGSIZE != 0)
  {
    return -1;
  }
  struct proc *p = myproc();
  acquire(&mmaptable.lock);
  struct mmap *mm = vammap(addr, p->pid);
  if (mm == 0)
  {
    release(&mmaptable.lock);
    return -1;
  }
  int idx = mmapidx(mm, p->pid);
  if (mm->begin[idx] + len == mm->end[idx])
  {
    int idx = -1;
    for (int i = 0; i < mm->nref; ++i)
    {
      if (mm->pid[i] == p->pid)
      {
        idx = i;
        break;
      }
    }
    for (int i = idx; i < mm->nref - 1; ++i)
    {
      mm->pid[idx] = mm->pid[idx + 1];
      mm->begin[idx] = mm->begin[idx + 1];
      mm->end[idx] = mm->end[idx + 1];
    }
    mm->nref -= 1;
  }
  else if (mm->begin[idx] == addr)
  {
    mm->begin[idx] += len;
  }
  else if (mm->begin[idx] != addr)
  {
    mm->end[idx] -= len;
  }
  if (mm->nref == 0)
  {
    mm->used = 0;
  }
  int mflag = mm->mflag;
  int flags = mm->flags;
  int used = mm->used;
  struct file *f = mm->file;
  release(&mmaptable.lock);
  _freemapped(f, addr, len, mflag, flags, used == 0 ? 1 : 0);
  if (used == 0)
  {
    fileclose(f);
  }
  return 0;
}

// Allocate a file structure.
struct file *
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for (f = ftable.file; f < ftable.file + NFILE; f++)
  {
    if (f->ref == 0)
    {
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if (f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
  struct file ff;

  acquire(&ftable.lock);
  if (f->ref < 1)
    panic("fileclose");
  if (--f->ref > 0)
  {
    release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if (ff.type == FD_PIPE)
  {
    pipeclose(ff.pipe, ff.writable);
  }
  else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
  {
    begin_op();
    iput(ff.ip);
    end_op();
  }
}

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
  struct proc *p = myproc();
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE)
  {
    ilock(f->ip);
    stati(f->ip, &st);
    iunlock(f->ip);
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
      return -1;
    return 0;
  }
  return -1;
}

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
  int r = 0;

  if (f->readable == 0)
    return -1;

  if (f->type == FD_PIPE)
  {
    r = piperead(f->pipe, addr, n);
  }
  else if (f->type == FD_DEVICE)
  {
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  }
  else if (f->type == FD_INODE)
  {
    ilock(f->ip);
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
  else
  {
    panic("fileread");
  }

  return r;
}

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0)
    return -1;

  if (f->type == FD_PIPE)
  {
    ret = pipewrite(f->pipe, addr, n);
  }
  else if (f->type == FD_DEVICE)
  {
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  }
  else if (f->type == FD_INODE)
  {
    // write a few blocks at a time to avoid exceeding
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n)
    {
      int n1 = n - i;
      if (n1 > max)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
      end_op();

      if (r != n1)
      {
        // error from writei
        break;
      }
      i += r;
    }
    ret = (i == n ? n : -1);
  }
  else
  {
    panic("filewrite");
  }

  return ret;
}
