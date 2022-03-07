// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
  struct run *next;
};

struct
{
  struct spinlock locks[NCPU];
  struct run *freelist[NCPU];
} kmem;

void kinit()
{
  for (int i = 0; i < NCPU; ++i)
  {
    initlock(&kmem.locks[i], "kmem");
    kmem.freelist[i] = 0;
  }
  // initlock(&kmem.lock, "kmem");
  freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
  push_off();
  int mycpuid = cpuid();
  pop_off();

  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run *)pa;

  acquire(&kmem.locks[mycpuid]);
  r->next = kmem.freelist[mycpuid];
  kmem.freelist[mycpuid] = r;
  release(&kmem.locks[mycpuid]);
}

void *_kalloc(struct spinlock *lock, int id)
{
  struct run *r;

  acquire(lock);
  r = kmem.freelist[id];
  if (r)
    kmem.freelist[id] = r->next;
  release(lock);

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
  return (void *)r;
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  push_off();
  int mycpuid = cpuid();
  pop_off();
  // struct run *r;

  // acquire(&kmem.lock);
  // r = kmem.freelist;
  // if (r)
  //   kmem.freelist = r->next;
  // release(&kmem.lock);

  // if (r)
  //   memset((char *)r, 5, PGSIZE); // fill with junk
  // return (void *)r;
  void *r = 0;
  r = _kalloc(&kmem.locks[mycpuid], mycpuid);
  if (r != 0)
  {
    return r;
  }
  for (int i = 0; i < NCPU; ++i)
  {
    if (i != mycpuid)
    {
      r = _kalloc(&kmem.locks[i], i);
      if (r != 0)
      {
        return r;
      }
    }
  }
  return r;
}
