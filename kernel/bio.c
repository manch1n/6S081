// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.

#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13
struct
{
  struct spinlock lock;
  struct buf buf[NBUF];
  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  // struct buf head;
  struct spinlock bucket_locks[NBUCKET];
  struct buf bucket_head[NBUCKET];
} bcache;

void binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  // bcache.head.prev = &bcache.head;
  // bcache.head.next = &bcache.head;
  for (int i = 0; i < NBUCKET; ++i)
  {
    bcache.bucket_head[i].prev = &bcache.bucket_head[i];
    bcache.bucket_head[i].next = &bcache.bucket_head[i];
    initlock(&bcache.bucket_locks[i], "bcache.lock");
  }
  //平均分配
  int idx = 0;
  for (b = bcache.buf; b < bcache.buf + NBUF; b++)
  {
    // b->next = bcache.head.next;
    // b->prev = &bcache.head;
    b->next = bcache.bucket_head[idx % NBUCKET].next;
    b->prev = &bcache.bucket_head[idx % NBUCKET];
    initsleeplock(&b->lock, "buffer");
    // bcache.head.next->prev = b;
    // bcache.head.next = b;
    bcache.bucket_head[idx % NBUCKET].next->prev = b;
    bcache.bucket_head[idx % NBUCKET].next = b;
    idx++;
  }
}

static struct buf *_recycle(int buci, int device, int blockno)
{
  // already acquire(locks[hash])
  int hash = blockno % NBUCKET;
  struct buf *b = 0;
  if (buci != hash)
  {
    acquire(&bcache.bucket_locks[buci]);
  }
  for (b = bcache.bucket_head[buci].prev; b != &bcache.bucket_head[buci]; b = b->prev)
  {
    if (b->refcnt == 0)
    {
      b->dev = device;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      acquiresleep(&b->lock);
      break;
    }
  }
  if (b == &bcache.bucket_head[buci])
  {
    if (buci != hash)
    {
      release(&bcache.bucket_locks[hash]);
    }
    return (void *)0;
  }
  if (buci != hash)
  {
    // delete
    b->prev->next = b->next;
    b->next->prev = b->prev;
    release(&bcache.bucket_locks[buci]);
    // insert
    // acquire(&bcache.bucket_locks[hash]);
    b->prev = bcache.bucket_head[hash].prev;
    b->next = &bcache.bucket_head[hash];
    bcache.bucket_head[hash].prev->next = b;
    bcache.bucket_head[hash].prev = b;
  }
  return b;
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf *
bget(uint dev, uint blockno)
{
  struct buf *b;
  // acquire(&bcache.lock);
  int hash = blockno % NBUCKET;
  acquire(&bcache.bucket_locks[hash]);

  // Is the block already cached?
  // for (b = bcache.head.next; b != &bcache.head; b = b->next)
  // {
  //   if (b->dev == dev && b->blockno == blockno)
  //   {
  //     b->refcnt++;
  //     release(&bcache.lock);
  //     acquiresleep(&b->lock);
  //     return b;
  //   }
  // }
  for (b = bcache.bucket_head[hash].next; b != &bcache.bucket_head[hash]; b = b->next)
  {
    if (b->dev == dev && b->blockno == blockno)
    {
      b->refcnt++;
      release(&bcache.bucket_locks[hash]);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.//优先遍历本地bucket,若找不到则到其他bucket找,并把该block移动到此bucket

  // for (b = bcache.head.prev; b != &bcache.head; b = b->prev)
  // {
  //   if (b->refcnt == 0)
  //   {
  //     b->dev = dev;
  //     b->blockno = blockno;
  //     b->valid = 0;
  //     b->refcnt = 1;
  //     release(&bcache.lock);
  //     acquiresleep(&b->lock);
  //     return b;
  //   }
  // }
  b = _recycle(hash, dev, blockno);
  if (b == 0)
  {
    for (int i = 0; i < NBUCKET; ++i)
    {
      if (i == hash)
        continue;
      b = _recycle(i, dev, blockno);
      if (b != 0)
        break;
    }
  }
  release(&bcache.bucket_locks[hash]);
  if (b != 0)
  {
    return b;
  }
  else
    panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid)
  {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
  if (!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
  if (!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);
  int hash = b->blockno % NBUCKET;
  // acquire(&bcache.lock);
  acquire(&bcache.bucket_locks[hash]);
  b->refcnt--;
  if (b->refcnt == 0)
  {
    // no one is waiting for it.
    // b->next->prev = b->prev;
    // b->prev->next = b->next;
    // b->next = bcache.head.next;
    // b->prev = &bcache.head;
    // bcache.head.next->prev = b;
    // bcache.head.next = b;
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.bucket_head[hash].next;
    b->prev = &bcache.bucket_head[hash];
    bcache.bucket_head[hash].next->prev = b;
    bcache.bucket_head[hash].next = b;
  }

  // release(&bcache.lock);
  release(&bcache.bucket_locks[hash]);
}

void bpin(struct buf *b)
{
  int hash = b->blockno % NBUCKET;
  acquire(&bcache.bucket_locks[hash]);
  b->refcnt++;
  release(&bcache.bucket_locks[hash]);
}

void bunpin(struct buf *b)
{
  int hash = b->blockno % NBUCKET;
  acquire(&bcache.bucket_locks[hash]);
  b->refcnt--;
  release(&bcache.bucket_locks[hash]);
}
