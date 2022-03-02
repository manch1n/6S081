
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	90013103          	ld	sp,-1792(sp) # 80008900 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0c3050ef          	jal	ra,800058d8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	148080e7          	jalr	328(ra) # 80000190 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	278080e7          	jalr	632(ra) # 800062d2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	318080e7          	jalr	792(ra) # 80006386 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	cfe080e7          	jalr	-770(ra) # 80005d88 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1101                	addi	sp,sp,-32
    800000de:	ec06                	sd	ra,24(sp)
    800000e0:	e822                	sd	s0,16(sp)
    800000e2:	e426                	sd	s1,8(sp)
    800000e4:	1000                	addi	s0,sp,32
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	14c080e7          	jalr	332(ra) # 80006242 <initlock>
  freerange(end, (void *)COWBASE);
    800000fe:	10fff4b7          	lui	s1,0x10fff
    80000102:	00349593          	slli	a1,s1,0x3
    80000106:	00026517          	auipc	a0,0x26
    8000010a:	13a50513          	addi	a0,a0,314 # 80026240 <end>
    8000010e:	00000097          	auipc	ra,0x0
    80000112:	f84080e7          	jalr	-124(ra) # 80000092 <freerange>
  memset((void *)COWBASE, 0, 8 * PGSIZE);
    80000116:	6621                	lui	a2,0x8
    80000118:	4581                	li	a1,0
    8000011a:	00349513          	slli	a0,s1,0x3
    8000011e:	00000097          	auipc	ra,0x0
    80000122:	072080e7          	jalr	114(ra) # 80000190 <memset>
}
    80000126:	60e2                	ld	ra,24(sp)
    80000128:	6442                	ld	s0,16(sp)
    8000012a:	64a2                	ld	s1,8(sp)
    8000012c:	6105                	addi	sp,sp,32
    8000012e:	8082                	ret

0000000080000130 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000130:	1101                	addi	sp,sp,-32
    80000132:	ec06                	sd	ra,24(sp)
    80000134:	e822                	sd	s0,16(sp)
    80000136:	e426                	sd	s1,8(sp)
    80000138:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000013a:	00009497          	auipc	s1,0x9
    8000013e:	ef648493          	addi	s1,s1,-266 # 80009030 <kmem>
    80000142:	8526                	mv	a0,s1
    80000144:	00006097          	auipc	ra,0x6
    80000148:	18e080e7          	jalr	398(ra) # 800062d2 <acquire>
  r = kmem.freelist;
    8000014c:	6c84                	ld	s1,24(s1)
  if (r)
    8000014e:	c885                	beqz	s1,8000017e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000150:	609c                	ld	a5,0(s1)
    80000152:	00009517          	auipc	a0,0x9
    80000156:	ede50513          	addi	a0,a0,-290 # 80009030 <kmem>
    8000015a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000015c:	00006097          	auipc	ra,0x6
    80000160:	22a080e7          	jalr	554(ra) # 80006386 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000164:	6605                	lui	a2,0x1
    80000166:	4595                	li	a1,5
    80000168:	8526                	mv	a0,s1
    8000016a:	00000097          	auipc	ra,0x0
    8000016e:	026080e7          	jalr	38(ra) # 80000190 <memset>
  return (void *)r;
}
    80000172:	8526                	mv	a0,s1
    80000174:	60e2                	ld	ra,24(sp)
    80000176:	6442                	ld	s0,16(sp)
    80000178:	64a2                	ld	s1,8(sp)
    8000017a:	6105                	addi	sp,sp,32
    8000017c:	8082                	ret
  release(&kmem.lock);
    8000017e:	00009517          	auipc	a0,0x9
    80000182:	eb250513          	addi	a0,a0,-334 # 80009030 <kmem>
    80000186:	00006097          	auipc	ra,0x6
    8000018a:	200080e7          	jalr	512(ra) # 80006386 <release>
  if (r)
    8000018e:	b7d5                	j	80000172 <kalloc+0x42>

0000000080000190 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000196:	ce09                	beqz	a2,800001b0 <memset+0x20>
    80000198:	87aa                	mv	a5,a0
    8000019a:	fff6071b          	addiw	a4,a2,-1
    8000019e:	1702                	slli	a4,a4,0x20
    800001a0:	9301                	srli	a4,a4,0x20
    800001a2:	0705                	addi	a4,a4,1
    800001a4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001aa:	0785                	addi	a5,a5,1
    800001ac:	fee79de3          	bne	a5,a4,800001a6 <memset+0x16>
  }
  return dst;
}
    800001b0:	6422                	ld	s0,8(sp)
    800001b2:	0141                	addi	sp,sp,16
    800001b4:	8082                	ret

00000000800001b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001b6:	1141                	addi	sp,sp,-16
    800001b8:	e422                	sd	s0,8(sp)
    800001ba:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001bc:	ca05                	beqz	a2,800001ec <memcmp+0x36>
    800001be:	fff6069b          	addiw	a3,a2,-1
    800001c2:	1682                	slli	a3,a3,0x20
    800001c4:	9281                	srli	a3,a3,0x20
    800001c6:	0685                	addi	a3,a3,1
    800001c8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ca:	00054783          	lbu	a5,0(a0)
    800001ce:	0005c703          	lbu	a4,0(a1)
    800001d2:	00e79863          	bne	a5,a4,800001e2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001d6:	0505                	addi	a0,a0,1
    800001d8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001da:	fed518e3          	bne	a0,a3,800001ca <memcmp+0x14>
  }

  return 0;
    800001de:	4501                	li	a0,0
    800001e0:	a019                	j	800001e6 <memcmp+0x30>
      return *s1 - *s2;
    800001e2:	40e7853b          	subw	a0,a5,a4
}
    800001e6:	6422                	ld	s0,8(sp)
    800001e8:	0141                	addi	sp,sp,16
    800001ea:	8082                	ret
  return 0;
    800001ec:	4501                	li	a0,0
    800001ee:	bfe5                	j	800001e6 <memcmp+0x30>

00000000800001f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001f0:	1141                	addi	sp,sp,-16
    800001f2:	e422                	sd	s0,8(sp)
    800001f4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001f6:	ca0d                	beqz	a2,80000228 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001f8:	00a5f963          	bgeu	a1,a0,8000020a <memmove+0x1a>
    800001fc:	02061693          	slli	a3,a2,0x20
    80000200:	9281                	srli	a3,a3,0x20
    80000202:	00d58733          	add	a4,a1,a3
    80000206:	02e56463          	bltu	a0,a4,8000022e <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000020a:	fff6079b          	addiw	a5,a2,-1
    8000020e:	1782                	slli	a5,a5,0x20
    80000210:	9381                	srli	a5,a5,0x20
    80000212:	0785                	addi	a5,a5,1
    80000214:	97ae                	add	a5,a5,a1
    80000216:	872a                	mv	a4,a0
      *d++ = *s++;
    80000218:	0585                	addi	a1,a1,1
    8000021a:	0705                	addi	a4,a4,1
    8000021c:	fff5c683          	lbu	a3,-1(a1)
    80000220:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000224:	fef59ae3          	bne	a1,a5,80000218 <memmove+0x28>

  return dst;
}
    80000228:	6422                	ld	s0,8(sp)
    8000022a:	0141                	addi	sp,sp,16
    8000022c:	8082                	ret
    d += n;
    8000022e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000230:	fff6079b          	addiw	a5,a2,-1
    80000234:	1782                	slli	a5,a5,0x20
    80000236:	9381                	srli	a5,a5,0x20
    80000238:	fff7c793          	not	a5,a5
    8000023c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000023e:	177d                	addi	a4,a4,-1
    80000240:	16fd                	addi	a3,a3,-1
    80000242:	00074603          	lbu	a2,0(a4)
    80000246:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000024a:	fef71ae3          	bne	a4,a5,8000023e <memmove+0x4e>
    8000024e:	bfe9                	j	80000228 <memmove+0x38>

0000000080000250 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e406                	sd	ra,8(sp)
    80000254:	e022                	sd	s0,0(sp)
    80000256:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000258:	00000097          	auipc	ra,0x0
    8000025c:	f98080e7          	jalr	-104(ra) # 800001f0 <memmove>
}
    80000260:	60a2                	ld	ra,8(sp)
    80000262:	6402                	ld	s0,0(sp)
    80000264:	0141                	addi	sp,sp,16
    80000266:	8082                	ret

0000000080000268 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e422                	sd	s0,8(sp)
    8000026c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000026e:	ce11                	beqz	a2,8000028a <strncmp+0x22>
    80000270:	00054783          	lbu	a5,0(a0)
    80000274:	cf89                	beqz	a5,8000028e <strncmp+0x26>
    80000276:	0005c703          	lbu	a4,0(a1)
    8000027a:	00f71a63          	bne	a4,a5,8000028e <strncmp+0x26>
    n--, p++, q++;
    8000027e:	367d                	addiw	a2,a2,-1
    80000280:	0505                	addi	a0,a0,1
    80000282:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000284:	f675                	bnez	a2,80000270 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000286:	4501                	li	a0,0
    80000288:	a809                	j	8000029a <strncmp+0x32>
    8000028a:	4501                	li	a0,0
    8000028c:	a039                	j	8000029a <strncmp+0x32>
  if(n == 0)
    8000028e:	ca09                	beqz	a2,800002a0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000290:	00054503          	lbu	a0,0(a0)
    80000294:	0005c783          	lbu	a5,0(a1)
    80000298:	9d1d                	subw	a0,a0,a5
}
    8000029a:	6422                	ld	s0,8(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret
    return 0;
    800002a0:	4501                	li	a0,0
    800002a2:	bfe5                	j	8000029a <strncmp+0x32>

00000000800002a4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e422                	sd	s0,8(sp)
    800002a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002aa:	872a                	mv	a4,a0
    800002ac:	8832                	mv	a6,a2
    800002ae:	367d                	addiw	a2,a2,-1
    800002b0:	01005963          	blez	a6,800002c2 <strncpy+0x1e>
    800002b4:	0705                	addi	a4,a4,1
    800002b6:	0005c783          	lbu	a5,0(a1)
    800002ba:	fef70fa3          	sb	a5,-1(a4)
    800002be:	0585                	addi	a1,a1,1
    800002c0:	f7f5                	bnez	a5,800002ac <strncpy+0x8>
    ;
  while(n-- > 0)
    800002c2:	00c05d63          	blez	a2,800002dc <strncpy+0x38>
    800002c6:	86ba                	mv	a3,a4
    *s++ = 0;
    800002c8:	0685                	addi	a3,a3,1
    800002ca:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ce:	fff6c793          	not	a5,a3
    800002d2:	9fb9                	addw	a5,a5,a4
    800002d4:	010787bb          	addw	a5,a5,a6
    800002d8:	fef048e3          	bgtz	a5,800002c8 <strncpy+0x24>
  return os;
}
    800002dc:	6422                	ld	s0,8(sp)
    800002de:	0141                	addi	sp,sp,16
    800002e0:	8082                	ret

00000000800002e2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002e2:	1141                	addi	sp,sp,-16
    800002e4:	e422                	sd	s0,8(sp)
    800002e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002e8:	02c05363          	blez	a2,8000030e <safestrcpy+0x2c>
    800002ec:	fff6069b          	addiw	a3,a2,-1
    800002f0:	1682                	slli	a3,a3,0x20
    800002f2:	9281                	srli	a3,a3,0x20
    800002f4:	96ae                	add	a3,a3,a1
    800002f6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002f8:	00d58963          	beq	a1,a3,8000030a <safestrcpy+0x28>
    800002fc:	0585                	addi	a1,a1,1
    800002fe:	0785                	addi	a5,a5,1
    80000300:	fff5c703          	lbu	a4,-1(a1)
    80000304:	fee78fa3          	sb	a4,-1(a5)
    80000308:	fb65                	bnez	a4,800002f8 <safestrcpy+0x16>
    ;
  *s = 0;
    8000030a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <strlen>:

int
strlen(const char *s)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000031a:	00054783          	lbu	a5,0(a0)
    8000031e:	cf91                	beqz	a5,8000033a <strlen+0x26>
    80000320:	0505                	addi	a0,a0,1
    80000322:	87aa                	mv	a5,a0
    80000324:	4685                	li	a3,1
    80000326:	9e89                	subw	a3,a3,a0
    80000328:	00f6853b          	addw	a0,a3,a5
    8000032c:	0785                	addi	a5,a5,1
    8000032e:	fff7c703          	lbu	a4,-1(a5)
    80000332:	fb7d                	bnez	a4,80000328 <strlen+0x14>
    ;
  return n;
}
    80000334:	6422                	ld	s0,8(sp)
    80000336:	0141                	addi	sp,sp,16
    80000338:	8082                	ret
  for(n = 0; s[n]; n++)
    8000033a:	4501                	li	a0,0
    8000033c:	bfe5                	j	80000334 <strlen+0x20>

000000008000033e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000033e:	1141                	addi	sp,sp,-16
    80000340:	e406                	sd	ra,8(sp)
    80000342:	e022                	sd	s0,0(sp)
    80000344:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000346:	00001097          	auipc	ra,0x1
    8000034a:	c20080e7          	jalr	-992(ra) # 80000f66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000034e:	00009717          	auipc	a4,0x9
    80000352:	cb270713          	addi	a4,a4,-846 # 80009000 <started>
  if(cpuid() == 0){
    80000356:	c139                	beqz	a0,8000039c <main+0x5e>
    while(started == 0)
    80000358:	431c                	lw	a5,0(a4)
    8000035a:	2781                	sext.w	a5,a5
    8000035c:	dff5                	beqz	a5,80000358 <main+0x1a>
      ;
    __sync_synchronize();
    8000035e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000362:	00001097          	auipc	ra,0x1
    80000366:	c04080e7          	jalr	-1020(ra) # 80000f66 <cpuid>
    8000036a:	85aa                	mv	a1,a0
    8000036c:	00008517          	auipc	a0,0x8
    80000370:	ccc50513          	addi	a0,a0,-820 # 80008038 <etext+0x38>
    80000374:	00006097          	auipc	ra,0x6
    80000378:	a5e080e7          	jalr	-1442(ra) # 80005dd2 <printf>
    kvminithart();    // turn on paging
    8000037c:	00000097          	auipc	ra,0x0
    80000380:	0d8080e7          	jalr	216(ra) # 80000454 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000384:	00002097          	auipc	ra,0x2
    80000388:	85a080e7          	jalr	-1958(ra) # 80001bde <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000038c:	00005097          	auipc	ra,0x5
    80000390:	ed4080e7          	jalr	-300(ra) # 80005260 <plicinithart>
  }

  scheduler();        
    80000394:	00001097          	auipc	ra,0x1
    80000398:	108080e7          	jalr	264(ra) # 8000149c <scheduler>
    consoleinit();
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	8fe080e7          	jalr	-1794(ra) # 80005c9a <consoleinit>
    printfinit();
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	c14080e7          	jalr	-1004(ra) # 80005fb8 <printfinit>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	a1e080e7          	jalr	-1506(ra) # 80005dd2 <printf>
    printf("xv6 kernel is booting\n");
    800003bc:	00008517          	auipc	a0,0x8
    800003c0:	c6450513          	addi	a0,a0,-924 # 80008020 <etext+0x20>
    800003c4:	00006097          	auipc	ra,0x6
    800003c8:	a0e080e7          	jalr	-1522(ra) # 80005dd2 <printf>
    printf("\n");
    800003cc:	00008517          	auipc	a0,0x8
    800003d0:	c7c50513          	addi	a0,a0,-900 # 80008048 <etext+0x48>
    800003d4:	00006097          	auipc	ra,0x6
    800003d8:	9fe080e7          	jalr	-1538(ra) # 80005dd2 <printf>
    kinit();         // physical page allocator
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	d00080e7          	jalr	-768(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	322080e7          	jalr	802(ra) # 80000706 <kvminit>
    kvminithart();   // turn on paging
    800003ec:	00000097          	auipc	ra,0x0
    800003f0:	068080e7          	jalr	104(ra) # 80000454 <kvminithart>
    procinit();      // process table
    800003f4:	00001097          	auipc	ra,0x1
    800003f8:	ac2080e7          	jalr	-1342(ra) # 80000eb6 <procinit>
    trapinit();      // trap vectors
    800003fc:	00001097          	auipc	ra,0x1
    80000400:	7ba080e7          	jalr	1978(ra) # 80001bb6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000404:	00001097          	auipc	ra,0x1
    80000408:	7da080e7          	jalr	2010(ra) # 80001bde <trapinithart>
    plicinit();      // set up interrupt controller
    8000040c:	00005097          	auipc	ra,0x5
    80000410:	e3e080e7          	jalr	-450(ra) # 8000524a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e4c080e7          	jalr	-436(ra) # 80005260 <plicinithart>
    binit();         // buffer cache
    8000041c:	00002097          	auipc	ra,0x2
    80000420:	02e080e7          	jalr	46(ra) # 8000244a <binit>
    iinit();         // inode table
    80000424:	00002097          	auipc	ra,0x2
    80000428:	6be080e7          	jalr	1726(ra) # 80002ae2 <iinit>
    fileinit();      // file table
    8000042c:	00003097          	auipc	ra,0x3
    80000430:	668080e7          	jalr	1640(ra) # 80003a94 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000434:	00005097          	auipc	ra,0x5
    80000438:	f4e080e7          	jalr	-178(ra) # 80005382 <virtio_disk_init>
    userinit();      // first user process
    8000043c:	00001097          	auipc	ra,0x1
    80000440:	e2e080e7          	jalr	-466(ra) # 8000126a <userinit>
    __sync_synchronize();
    80000444:	0ff0000f          	fence
    started = 1;
    80000448:	4785                	li	a5,1
    8000044a:	00009717          	auipc	a4,0x9
    8000044e:	baf72b23          	sw	a5,-1098(a4) # 80009000 <started>
    80000452:	b789                	j	80000394 <main+0x56>

0000000080000454 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000454:	1141                	addi	sp,sp,-16
    80000456:	e422                	sd	s0,8(sp)
    80000458:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000045a:	00009797          	auipc	a5,0x9
    8000045e:	bae7b783          	ld	a5,-1106(a5) # 80009008 <kernel_pagetable>
    80000462:	83b1                	srli	a5,a5,0xc
    80000464:	577d                	li	a4,-1
    80000466:	177e                	slli	a4,a4,0x3f
    80000468:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0"
    8000046a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000046e:	12000073          	sfence.vma
  sfence_vma();
}
    80000472:	6422                	ld	s0,8(sp)
    80000474:	0141                	addi	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000478:	7139                	addi	sp,sp,-64
    8000047a:	fc06                	sd	ra,56(sp)
    8000047c:	f822                	sd	s0,48(sp)
    8000047e:	f426                	sd	s1,40(sp)
    80000480:	f04a                	sd	s2,32(sp)
    80000482:	ec4e                	sd	s3,24(sp)
    80000484:	e852                	sd	s4,16(sp)
    80000486:	e456                	sd	s5,8(sp)
    80000488:	e05a                	sd	s6,0(sp)
    8000048a:	0080                	addi	s0,sp,64
    8000048c:	84aa                	mv	s1,a0
    8000048e:	89ae                	mv	s3,a1
    80000490:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000492:	57fd                	li	a5,-1
    80000494:	83e9                	srli	a5,a5,0x1a
    80000496:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    80000498:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000049a:	04b7f263          	bgeu	a5,a1,800004de <walk+0x66>
    panic("walk");
    8000049e:	00008517          	auipc	a0,0x8
    800004a2:	bb250513          	addi	a0,a0,-1102 # 80008050 <etext+0x50>
    800004a6:	00006097          	auipc	ra,0x6
    800004aa:	8e2080e7          	jalr	-1822(ra) # 80005d88 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800004ae:	060a8663          	beqz	s5,8000051a <walk+0xa2>
    800004b2:	00000097          	auipc	ra,0x0
    800004b6:	c7e080e7          	jalr	-898(ra) # 80000130 <kalloc>
    800004ba:	84aa                	mv	s1,a0
    800004bc:	c529                	beqz	a0,80000506 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004be:	6605                	lui	a2,0x1
    800004c0:	4581                	li	a1,0
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	cce080e7          	jalr	-818(ra) # 80000190 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ca:	00c4d793          	srli	a5,s1,0xc
    800004ce:	07aa                	slli	a5,a5,0xa
    800004d0:	0017e793          	ori	a5,a5,1
    800004d4:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800004d8:	3a5d                	addiw	s4,s4,-9
    800004da:	036a0063          	beq	s4,s6,800004fa <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004de:	0149d933          	srl	s2,s3,s4
    800004e2:	1ff97913          	andi	s2,s2,511
    800004e6:	090e                	slli	s2,s2,0x3
    800004e8:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800004ea:	00093483          	ld	s1,0(s2)
    800004ee:	0014f793          	andi	a5,s1,1
    800004f2:	dfd5                	beqz	a5,800004ae <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f4:	80a9                	srli	s1,s1,0xa
    800004f6:	04b2                	slli	s1,s1,0xc
    800004f8:	b7c5                	j	800004d8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004fa:	00c9d513          	srli	a0,s3,0xc
    800004fe:	1ff57513          	andi	a0,a0,511
    80000502:	050e                	slli	a0,a0,0x3
    80000504:	9526                	add	a0,a0,s1
}
    80000506:	70e2                	ld	ra,56(sp)
    80000508:	7442                	ld	s0,48(sp)
    8000050a:	74a2                	ld	s1,40(sp)
    8000050c:	7902                	ld	s2,32(sp)
    8000050e:	69e2                	ld	s3,24(sp)
    80000510:	6a42                	ld	s4,16(sp)
    80000512:	6aa2                	ld	s5,8(sp)
    80000514:	6b02                	ld	s6,0(sp)
    80000516:	6121                	addi	sp,sp,64
    80000518:	8082                	ret
        return 0;
    8000051a:	4501                	li	a0,0
    8000051c:	b7ed                	j	80000506 <walk+0x8e>

000000008000051e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    8000051e:	57fd                	li	a5,-1
    80000520:	83e9                	srli	a5,a5,0x1a
    80000522:	00b7f463          	bgeu	a5,a1,8000052a <walkaddr+0xc>
    return 0;
    80000526:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000528:	8082                	ret
{
    8000052a:	1141                	addi	sp,sp,-16
    8000052c:	e406                	sd	ra,8(sp)
    8000052e:	e022                	sd	s0,0(sp)
    80000530:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000532:	4601                	li	a2,0
    80000534:	00000097          	auipc	ra,0x0
    80000538:	f44080e7          	jalr	-188(ra) # 80000478 <walk>
  if (pte == 0)
    8000053c:	c105                	beqz	a0,8000055c <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    8000053e:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000540:	0117f693          	andi	a3,a5,17
    80000544:	4745                	li	a4,17
    return 0;
    80000546:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000548:	00e68663          	beq	a3,a4,80000554 <walkaddr+0x36>
}
    8000054c:	60a2                	ld	ra,8(sp)
    8000054e:	6402                	ld	s0,0(sp)
    80000550:	0141                	addi	sp,sp,16
    80000552:	8082                	ret
  pa = PTE2PA(*pte);
    80000554:	00a7d513          	srli	a0,a5,0xa
    80000558:	0532                	slli	a0,a0,0xc
  return pa;
    8000055a:	bfcd                	j	8000054c <walkaddr+0x2e>
    return 0;
    8000055c:	4501                	li	a0,0
    8000055e:	b7fd                	j	8000054c <walkaddr+0x2e>

0000000080000560 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000560:	715d                	addi	sp,sp,-80
    80000562:	e486                	sd	ra,72(sp)
    80000564:	e0a2                	sd	s0,64(sp)
    80000566:	fc26                	sd	s1,56(sp)
    80000568:	f84a                	sd	s2,48(sp)
    8000056a:	f44e                	sd	s3,40(sp)
    8000056c:	f052                	sd	s4,32(sp)
    8000056e:	ec56                	sd	s5,24(sp)
    80000570:	e85a                	sd	s6,16(sp)
    80000572:	e45e                	sd	s7,8(sp)
    80000574:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    80000576:	c205                	beqz	a2,80000596 <mappages+0x36>
    80000578:	8aaa                	mv	s5,a0
    8000057a:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    8000057c:	77fd                	lui	a5,0xfffff
    8000057e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000582:	15fd                	addi	a1,a1,-1
    80000584:	00c589b3          	add	s3,a1,a2
    80000588:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000058c:	8952                	mv	s2,s4
    8000058e:	41468a33          	sub	s4,a3,s4
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000592:	6b85                	lui	s7,0x1
    80000594:	a015                	j	800005b8 <mappages+0x58>
    panic("mappages: size");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ac250513          	addi	a0,a0,-1342 # 80008058 <etext+0x58>
    8000059e:	00005097          	auipc	ra,0x5
    800005a2:	7ea080e7          	jalr	2026(ra) # 80005d88 <panic>
      panic("mappages: remap");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ac250513          	addi	a0,a0,-1342 # 80008068 <etext+0x68>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	7da080e7          	jalr	2010(ra) # 80005d88 <panic>
    a += PGSIZE;
    800005b6:	995e                	add	s2,s2,s7
  for (;;)
    800005b8:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	4605                	li	a2,1
    800005be:	85ca                	mv	a1,s2
    800005c0:	8556                	mv	a0,s5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	eb6080e7          	jalr	-330(ra) # 80000478 <walk>
    800005ca:	cd19                	beqz	a0,800005e8 <mappages+0x88>
    if (*pte & PTE_V)
    800005cc:	611c                	ld	a5,0(a0)
    800005ce:	8b85                	andi	a5,a5,1
    800005d0:	fbf9                	bnez	a5,800005a6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d2:	80b1                	srli	s1,s1,0xc
    800005d4:	04aa                	slli	s1,s1,0xa
    800005d6:	0164e4b3          	or	s1,s1,s6
    800005da:	0014e493          	ori	s1,s1,1
    800005de:	e104                	sd	s1,0(a0)
    if (a == last)
    800005e0:	fd391be3          	bne	s2,s3,800005b6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005e4:	4501                	li	a0,0
    800005e6:	a011                	j	800005ea <mappages+0x8a>
      return -1;
    800005e8:	557d                	li	a0,-1
}
    800005ea:	60a6                	ld	ra,72(sp)
    800005ec:	6406                	ld	s0,64(sp)
    800005ee:	74e2                	ld	s1,56(sp)
    800005f0:	7942                	ld	s2,48(sp)
    800005f2:	79a2                	ld	s3,40(sp)
    800005f4:	7a02                	ld	s4,32(sp)
    800005f6:	6ae2                	ld	s5,24(sp)
    800005f8:	6b42                	ld	s6,16(sp)
    800005fa:	6ba2                	ld	s7,8(sp)
    800005fc:	6161                	addi	sp,sp,80
    800005fe:	8082                	ret

0000000080000600 <kvmmap>:
{
    80000600:	1141                	addi	sp,sp,-16
    80000602:	e406                	sd	ra,8(sp)
    80000604:	e022                	sd	s0,0(sp)
    80000606:	0800                	addi	s0,sp,16
    80000608:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060a:	86b2                	mv	a3,a2
    8000060c:	863e                	mv	a2,a5
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f52080e7          	jalr	-174(ra) # 80000560 <mappages>
    80000616:	e509                	bnez	a0,80000620 <kvmmap+0x20>
}
    80000618:	60a2                	ld	ra,8(sp)
    8000061a:	6402                	ld	s0,0(sp)
    8000061c:	0141                	addi	sp,sp,16
    8000061e:	8082                	ret
    panic("kvmmap");
    80000620:	00008517          	auipc	a0,0x8
    80000624:	a5850513          	addi	a0,a0,-1448 # 80008078 <etext+0x78>
    80000628:	00005097          	auipc	ra,0x5
    8000062c:	760080e7          	jalr	1888(ra) # 80005d88 <panic>

0000000080000630 <kvmmake>:
{
    80000630:	1101                	addi	sp,sp,-32
    80000632:	ec06                	sd	ra,24(sp)
    80000634:	e822                	sd	s0,16(sp)
    80000636:	e426                	sd	s1,8(sp)
    80000638:	e04a                	sd	s2,0(sp)
    8000063a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	af4080e7          	jalr	-1292(ra) # 80000130 <kalloc>
    80000644:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000646:	6605                	lui	a2,0x1
    80000648:	4581                	li	a1,0
    8000064a:	00000097          	auipc	ra,0x0
    8000064e:	b46080e7          	jalr	-1210(ra) # 80000190 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000652:	4719                	li	a4,6
    80000654:	6685                	lui	a3,0x1
    80000656:	10000637          	lui	a2,0x10000
    8000065a:	100005b7          	lui	a1,0x10000
    8000065e:	8526                	mv	a0,s1
    80000660:	00000097          	auipc	ra,0x0
    80000664:	fa0080e7          	jalr	-96(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000668:	4719                	li	a4,6
    8000066a:	6685                	lui	a3,0x1
    8000066c:	10001637          	lui	a2,0x10001
    80000670:	100015b7          	lui	a1,0x10001
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f8a080e7          	jalr	-118(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000067e:	4719                	li	a4,6
    80000680:	004006b7          	lui	a3,0x400
    80000684:	0c000637          	lui	a2,0xc000
    80000688:	0c0005b7          	lui	a1,0xc000
    8000068c:	8526                	mv	a0,s1
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	f72080e7          	jalr	-142(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000696:	00008917          	auipc	s2,0x8
    8000069a:	96a90913          	addi	s2,s2,-1686 # 80008000 <etext>
    8000069e:	4729                	li	a4,10
    800006a0:	80008697          	auipc	a3,0x80008
    800006a4:	96068693          	addi	a3,a3,-1696 # 8000 <_entry-0x7fff8000>
    800006a8:	4605                	li	a2,1
    800006aa:	067e                	slli	a2,a2,0x1f
    800006ac:	85b2                	mv	a1,a2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f50080e7          	jalr	-176(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800006b8:	4719                	li	a4,6
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	slli	a3,a3,0x1b
    800006be:	412686b3          	sub	a3,a3,s2
    800006c2:	864a                	mv	a2,s2
    800006c4:	85ca                	mv	a1,s2
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f38080e7          	jalr	-200(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d0:	4729                	li	a4,10
    800006d2:	6685                	lui	a3,0x1
    800006d4:	00007617          	auipc	a2,0x7
    800006d8:	92c60613          	addi	a2,a2,-1748 # 80007000 <_trampoline>
    800006dc:	040005b7          	lui	a1,0x4000
    800006e0:	15fd                	addi	a1,a1,-1
    800006e2:	05b2                	slli	a1,a1,0xc
    800006e4:	8526                	mv	a0,s1
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	f1a080e7          	jalr	-230(ra) # 80000600 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006ee:	8526                	mv	a0,s1
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	730080e7          	jalr	1840(ra) # 80000e20 <proc_mapstacks>
}
    800006f8:	8526                	mv	a0,s1
    800006fa:	60e2                	ld	ra,24(sp)
    800006fc:	6442                	ld	s0,16(sp)
    800006fe:	64a2                	ld	s1,8(sp)
    80000700:	6902                	ld	s2,0(sp)
    80000702:	6105                	addi	sp,sp,32
    80000704:	8082                	ret

0000000080000706 <kvminit>:
{
    80000706:	1141                	addi	sp,sp,-16
    80000708:	e406                	sd	ra,8(sp)
    8000070a:	e022                	sd	s0,0(sp)
    8000070c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000070e:	00000097          	auipc	ra,0x0
    80000712:	f22080e7          	jalr	-222(ra) # 80000630 <kvmmake>
    80000716:	00009797          	auipc	a5,0x9
    8000071a:	8ea7b923          	sd	a0,-1806(a5) # 80009008 <kernel_pagetable>
}
    8000071e:	60a2                	ld	ra,8(sp)
    80000720:	6402                	ld	s0,0(sp)
    80000722:	0141                	addi	sp,sp,16
    80000724:	8082                	ret

0000000080000726 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000726:	711d                	addi	sp,sp,-96
    80000728:	ec86                	sd	ra,88(sp)
    8000072a:	e8a2                	sd	s0,80(sp)
    8000072c:	e4a6                	sd	s1,72(sp)
    8000072e:	e0ca                	sd	s2,64(sp)
    80000730:	fc4e                	sd	s3,56(sp)
    80000732:	f852                	sd	s4,48(sp)
    80000734:	f456                	sd	s5,40(sp)
    80000736:	f05a                	sd	s6,32(sp)
    80000738:	ec5e                	sd	s7,24(sp)
    8000073a:	e862                	sd	s8,16(sp)
    8000073c:	e466                	sd	s9,8(sp)
    8000073e:	1080                	addi	s0,sp,96
  uint64 a;
  pte_t *pte;
  uint8 *cow_base = (uint8 *)COWBASE;
  if ((va % PGSIZE) != 0)
    80000740:	03459793          	slli	a5,a1,0x34
    80000744:	e395                	bnez	a5,80000768 <uvmunmap+0x42>
    80000746:	8a2a                	mv	s4,a0
    80000748:	892e                	mv	s2,a1
    8000074a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000074c:	0632                	slli	a2,a2,0xc
    8000074e:	00b609b3          	add	s3,a2,a1
    80000752:	0b35fe63          	bgeu	a1,s3,8000080e <uvmunmap+0xe8>
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000756:	4b85                	li	s7,1
    uint64 pa = PTE2PA(*pte);
    if (do_free) //#3 do not free the COW PAGE
    {
      if ((PTE_FLAGS(*pte) & PTE_C) != 0)
      {
        cow_base[PTCOWIDX(pa)] -= 1;
    80000758:	08000cb7          	lui	s9,0x8000
    8000075c:	1cfd                	addi	s9,s9,-1
    8000075e:	10fffc37          	lui	s8,0x10fff
    80000762:	0c0e                	slli	s8,s8,0x3
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000764:	6b05                	lui	s6,0x1
    80000766:	a891                	j	800007ba <uvmunmap+0x94>
    panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	91850513          	addi	a0,a0,-1768 # 80008080 <etext+0x80>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	618080e7          	jalr	1560(ra) # 80005d88 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	92050513          	addi	a0,a0,-1760 # 80008098 <etext+0x98>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	608080e7          	jalr	1544(ra) # 80005d88 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	92050513          	addi	a0,a0,-1760 # 800080a8 <etext+0xa8>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	5f8080e7          	jalr	1528(ra) # 80005d88 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	92850513          	addi	a0,a0,-1752 # 800080c0 <etext+0xc0>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	5e8080e7          	jalr	1512(ra) # 80005d88 <panic>
          kfree((void *)pa);
        }
      }
      else
      {
        kfree((void *)pa);
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	874080e7          	jalr	-1932(ra) # 8000001c <kfree>
      }
    }
    *pte = 0;
    800007b0:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800007b4:	995a                	add	s2,s2,s6
    800007b6:	05397c63          	bgeu	s2,s3,8000080e <uvmunmap+0xe8>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800007ba:	4601                	li	a2,0
    800007bc:	85ca                	mv	a1,s2
    800007be:	8552                	mv	a0,s4
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	cb8080e7          	jalr	-840(ra) # 80000478 <walk>
    800007c8:	84aa                	mv	s1,a0
    800007ca:	d55d                	beqz	a0,80000778 <uvmunmap+0x52>
    if ((*pte & PTE_V) == 0)
    800007cc:	611c                	ld	a5,0(a0)
    800007ce:	0017f713          	andi	a4,a5,1
    800007d2:	db5d                	beqz	a4,80000788 <uvmunmap+0x62>
    if (PTE_FLAGS(*pte) == PTE_V)
    800007d4:	3ff7f713          	andi	a4,a5,1023
    800007d8:	fd7700e3          	beq	a4,s7,80000798 <uvmunmap+0x72>
    if (do_free) //#3 do not free the COW PAGE
    800007dc:	fc0a8ae3          	beqz	s5,800007b0 <uvmunmap+0x8a>
    uint64 pa = PTE2PA(*pte);
    800007e0:	00a7d513          	srli	a0,a5,0xa
    800007e4:	0532                	slli	a0,a0,0xc
      if ((PTE_FLAGS(*pte) & PTE_C) != 0)
    800007e6:	1007f793          	andi	a5,a5,256
    800007ea:	dfdd                	beqz	a5,800007a8 <uvmunmap+0x82>
        cow_base[PTCOWIDX(pa)] -= 1;
    800007ec:	01957733          	and	a4,a0,s9
    800007f0:	8331                	srli	a4,a4,0xc
    800007f2:	9762                	add	a4,a4,s8
    800007f4:	00074783          	lbu	a5,0(a4)
    800007f8:	37fd                	addiw	a5,a5,-1
    800007fa:	0ff7f793          	andi	a5,a5,255
    800007fe:	00f70023          	sb	a5,0(a4)
        if (cow_base[PTCOWIDX(pa)] == 0) //#3 do not free the COW PAGE
    80000802:	f7dd                	bnez	a5,800007b0 <uvmunmap+0x8a>
          kfree((void *)pa);
    80000804:	00000097          	auipc	ra,0x0
    80000808:	818080e7          	jalr	-2024(ra) # 8000001c <kfree>
    8000080c:	b755                	j	800007b0 <uvmunmap+0x8a>
  }
}
    8000080e:	60e6                	ld	ra,88(sp)
    80000810:	6446                	ld	s0,80(sp)
    80000812:	64a6                	ld	s1,72(sp)
    80000814:	6906                	ld	s2,64(sp)
    80000816:	79e2                	ld	s3,56(sp)
    80000818:	7a42                	ld	s4,48(sp)
    8000081a:	7aa2                	ld	s5,40(sp)
    8000081c:	7b02                	ld	s6,32(sp)
    8000081e:	6be2                	ld	s7,24(sp)
    80000820:	6c42                	ld	s8,16(sp)
    80000822:	6ca2                	ld	s9,8(sp)
    80000824:	6125                	addi	sp,sp,96
    80000826:	8082                	ret

0000000080000828 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000828:	1101                	addi	sp,sp,-32
    8000082a:	ec06                	sd	ra,24(sp)
    8000082c:	e822                	sd	s0,16(sp)
    8000082e:	e426                	sd	s1,8(sp)
    80000830:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000832:	00000097          	auipc	ra,0x0
    80000836:	8fe080e7          	jalr	-1794(ra) # 80000130 <kalloc>
    8000083a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000083c:	c519                	beqz	a0,8000084a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000083e:	6605                	lui	a2,0x1
    80000840:	4581                	li	a1,0
    80000842:	00000097          	auipc	ra,0x0
    80000846:	94e080e7          	jalr	-1714(ra) # 80000190 <memset>
  return pagetable;
}
    8000084a:	8526                	mv	a0,s1
    8000084c:	60e2                	ld	ra,24(sp)
    8000084e:	6442                	ld	s0,16(sp)
    80000850:	64a2                	ld	s1,8(sp)
    80000852:	6105                	addi	sp,sp,32
    80000854:	8082                	ret

0000000080000856 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000856:	7179                	addi	sp,sp,-48
    80000858:	f406                	sd	ra,40(sp)
    8000085a:	f022                	sd	s0,32(sp)
    8000085c:	ec26                	sd	s1,24(sp)
    8000085e:	e84a                	sd	s2,16(sp)
    80000860:	e44e                	sd	s3,8(sp)
    80000862:	e052                	sd	s4,0(sp)
    80000864:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    80000866:	6785                	lui	a5,0x1
    80000868:	04f67863          	bgeu	a2,a5,800008b8 <uvminit+0x62>
    8000086c:	8a2a                	mv	s4,a0
    8000086e:	89ae                	mv	s3,a1
    80000870:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000872:	00000097          	auipc	ra,0x0
    80000876:	8be080e7          	jalr	-1858(ra) # 80000130 <kalloc>
    8000087a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4581                	li	a1,0
    80000880:	00000097          	auipc	ra,0x0
    80000884:	910080e7          	jalr	-1776(ra) # 80000190 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000888:	4779                	li	a4,30
    8000088a:	86ca                	mv	a3,s2
    8000088c:	6605                	lui	a2,0x1
    8000088e:	4581                	li	a1,0
    80000890:	8552                	mv	a0,s4
    80000892:	00000097          	auipc	ra,0x0
    80000896:	cce080e7          	jalr	-818(ra) # 80000560 <mappages>
  memmove(mem, src, sz);
    8000089a:	8626                	mv	a2,s1
    8000089c:	85ce                	mv	a1,s3
    8000089e:	854a                	mv	a0,s2
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	950080e7          	jalr	-1712(ra) # 800001f0 <memmove>
}
    800008a8:	70a2                	ld	ra,40(sp)
    800008aa:	7402                	ld	s0,32(sp)
    800008ac:	64e2                	ld	s1,24(sp)
    800008ae:	6942                	ld	s2,16(sp)
    800008b0:	69a2                	ld	s3,8(sp)
    800008b2:	6a02                	ld	s4,0(sp)
    800008b4:	6145                	addi	sp,sp,48
    800008b6:	8082                	ret
    panic("inituvm: more than a page");
    800008b8:	00008517          	auipc	a0,0x8
    800008bc:	82050513          	addi	a0,a0,-2016 # 800080d8 <etext+0xd8>
    800008c0:	00005097          	auipc	ra,0x5
    800008c4:	4c8080e7          	jalr	1224(ra) # 80005d88 <panic>

00000000800008c8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c8:	1101                	addi	sp,sp,-32
    800008ca:	ec06                	sd	ra,24(sp)
    800008cc:	e822                	sd	s0,16(sp)
    800008ce:	e426                	sd	s1,8(sp)
    800008d0:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800008d2:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800008d4:	00b67d63          	bgeu	a2,a1,800008ee <uvmdealloc+0x26>
    800008d8:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800008da:	6785                	lui	a5,0x1
    800008dc:	17fd                	addi	a5,a5,-1
    800008de:	00f60733          	add	a4,a2,a5
    800008e2:	767d                	lui	a2,0xfffff
    800008e4:	8f71                	and	a4,a4,a2
    800008e6:	97ae                	add	a5,a5,a1
    800008e8:	8ff1                	and	a5,a5,a2
    800008ea:	00f76863          	bltu	a4,a5,800008fa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ee:	8526                	mv	a0,s1
    800008f0:	60e2                	ld	ra,24(sp)
    800008f2:	6442                	ld	s0,16(sp)
    800008f4:	64a2                	ld	s1,8(sp)
    800008f6:	6105                	addi	sp,sp,32
    800008f8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008fa:	8f99                	sub	a5,a5,a4
    800008fc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008fe:	4685                	li	a3,1
    80000900:	0007861b          	sext.w	a2,a5
    80000904:	85ba                	mv	a1,a4
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	e20080e7          	jalr	-480(ra) # 80000726 <uvmunmap>
    8000090e:	b7c5                	j	800008ee <uvmdealloc+0x26>

0000000080000910 <uvmalloc>:
  if (newsz < oldsz)
    80000910:	0ab66163          	bltu	a2,a1,800009b2 <uvmalloc+0xa2>
{
    80000914:	7139                	addi	sp,sp,-64
    80000916:	fc06                	sd	ra,56(sp)
    80000918:	f822                	sd	s0,48(sp)
    8000091a:	f426                	sd	s1,40(sp)
    8000091c:	f04a                	sd	s2,32(sp)
    8000091e:	ec4e                	sd	s3,24(sp)
    80000920:	e852                	sd	s4,16(sp)
    80000922:	e456                	sd	s5,8(sp)
    80000924:	0080                	addi	s0,sp,64
    80000926:	8aaa                	mv	s5,a0
    80000928:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000092a:	6985                	lui	s3,0x1
    8000092c:	19fd                	addi	s3,s3,-1
    8000092e:	95ce                	add	a1,a1,s3
    80000930:	79fd                	lui	s3,0xfffff
    80000932:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000936:	08c9f063          	bgeu	s3,a2,800009b6 <uvmalloc+0xa6>
    8000093a:	894e                	mv	s2,s3
    mem = kalloc();
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	7f4080e7          	jalr	2036(ra) # 80000130 <kalloc>
    80000944:	84aa                	mv	s1,a0
    if (mem == 0)
    80000946:	c51d                	beqz	a0,80000974 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000948:	6605                	lui	a2,0x1
    8000094a:	4581                	li	a1,0
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	844080e7          	jalr	-1980(ra) # 80000190 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000954:	4779                	li	a4,30
    80000956:	86a6                	mv	a3,s1
    80000958:	6605                	lui	a2,0x1
    8000095a:	85ca                	mv	a1,s2
    8000095c:	8556                	mv	a0,s5
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	c02080e7          	jalr	-1022(ra) # 80000560 <mappages>
    80000966:	e905                	bnez	a0,80000996 <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000968:	6785                	lui	a5,0x1
    8000096a:	993e                	add	s2,s2,a5
    8000096c:	fd4968e3          	bltu	s2,s4,8000093c <uvmalloc+0x2c>
  return newsz;
    80000970:	8552                	mv	a0,s4
    80000972:	a809                	j	80000984 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000974:	864e                	mv	a2,s3
    80000976:	85ca                	mv	a1,s2
    80000978:	8556                	mv	a0,s5
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	f4e080e7          	jalr	-178(ra) # 800008c8 <uvmdealloc>
      return 0;
    80000982:	4501                	li	a0,0
}
    80000984:	70e2                	ld	ra,56(sp)
    80000986:	7442                	ld	s0,48(sp)
    80000988:	74a2                	ld	s1,40(sp)
    8000098a:	7902                	ld	s2,32(sp)
    8000098c:	69e2                	ld	s3,24(sp)
    8000098e:	6a42                	ld	s4,16(sp)
    80000990:	6aa2                	ld	s5,8(sp)
    80000992:	6121                	addi	sp,sp,64
    80000994:	8082                	ret
      kfree(mem);
    80000996:	8526                	mv	a0,s1
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	684080e7          	jalr	1668(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009a0:	864e                	mv	a2,s3
    800009a2:	85ca                	mv	a1,s2
    800009a4:	8556                	mv	a0,s5
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	f22080e7          	jalr	-222(ra) # 800008c8 <uvmdealloc>
      return 0;
    800009ae:	4501                	li	a0,0
    800009b0:	bfd1                	j	80000984 <uvmalloc+0x74>
    return oldsz;
    800009b2:	852e                	mv	a0,a1
}
    800009b4:	8082                	ret
  return newsz;
    800009b6:	8532                	mv	a0,a2
    800009b8:	b7f1                	j	80000984 <uvmalloc+0x74>

00000000800009ba <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    800009ba:	7179                	addi	sp,sp,-48
    800009bc:	f406                	sd	ra,40(sp)
    800009be:	f022                	sd	s0,32(sp)
    800009c0:	ec26                	sd	s1,24(sp)
    800009c2:	e84a                	sd	s2,16(sp)
    800009c4:	e44e                	sd	s3,8(sp)
    800009c6:	e052                	sd	s4,0(sp)
    800009c8:	1800                	addi	s0,sp,48
    800009ca:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    800009cc:	84aa                	mv	s1,a0
    800009ce:	6905                	lui	s2,0x1
    800009d0:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800009d2:	4985                	li	s3,1
    800009d4:	a821                	j	800009ec <freewalk+0x32>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d8:	0532                	slli	a0,a0,0xc
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fe0080e7          	jalr	-32(ra) # 800009ba <freewalk>
      pagetable[i] = 0;
    800009e2:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    800009e6:	04a1                	addi	s1,s1,8
    800009e8:	03248163          	beq	s1,s2,80000a0a <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009ec:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800009ee:	00f57793          	andi	a5,a0,15
    800009f2:	ff3782e3          	beq	a5,s3,800009d6 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    800009f6:	8905                	andi	a0,a0,1
    800009f8:	d57d                	beqz	a0,800009e6 <freewalk+0x2c>
    {
      panic("freewalk: leaf");
    800009fa:	00007517          	auipc	a0,0x7
    800009fe:	6fe50513          	addi	a0,a0,1790 # 800080f8 <etext+0xf8>
    80000a02:	00005097          	auipc	ra,0x5
    80000a06:	386080e7          	jalr	902(ra) # 80005d88 <panic>
    }
  }
  kfree((void *)pagetable);
    80000a0a:	8552                	mv	a0,s4
    80000a0c:	fffff097          	auipc	ra,0xfffff
    80000a10:	610080e7          	jalr	1552(ra) # 8000001c <kfree>
}
    80000a14:	70a2                	ld	ra,40(sp)
    80000a16:	7402                	ld	s0,32(sp)
    80000a18:	64e2                	ld	s1,24(sp)
    80000a1a:	6942                	ld	s2,16(sp)
    80000a1c:	69a2                	ld	s3,8(sp)
    80000a1e:	6a02                	ld	s4,0(sp)
    80000a20:	6145                	addi	sp,sp,48
    80000a22:	8082                	ret

0000000080000a24 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	1000                	addi	s0,sp,32
    80000a2e:	84aa                	mv	s1,a0
  if (sz > 0)
    80000a30:	e999                	bnez	a1,80000a46 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000a32:	8526                	mv	a0,s1
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f86080e7          	jalr	-122(ra) # 800009ba <freewalk>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a46:	6605                	lui	a2,0x1
    80000a48:	167d                	addi	a2,a2,-1
    80000a4a:	962e                	add	a2,a2,a1
    80000a4c:	4685                	li	a3,1
    80000a4e:	8231                	srli	a2,a2,0xc
    80000a50:	4581                	li	a1,0
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	cd4080e7          	jalr	-812(ra) # 80000726 <uvmunmap>
    80000a5a:	bfe1                	j	80000a32 <uvmfree+0xe>

0000000080000a5c <uvmcopy>:
  //     goto err;
  //   }
  // }

  // #1: clear the W flag instead of malloc a new page
  for (i = 0; i < sz; i += PGSIZE)
    80000a5c:	c27d                	beqz	a2,80000b42 <uvmcopy+0xe6>
{
    80000a5e:	715d                	addi	sp,sp,-80
    80000a60:	e486                	sd	ra,72(sp)
    80000a62:	e0a2                	sd	s0,64(sp)
    80000a64:	fc26                	sd	s1,56(sp)
    80000a66:	f84a                	sd	s2,48(sp)
    80000a68:	f44e                	sd	s3,40(sp)
    80000a6a:	f052                	sd	s4,32(sp)
    80000a6c:	ec56                	sd	s5,24(sp)
    80000a6e:	e85a                	sd	s6,16(sp)
    80000a70:	e45e                	sd	s7,8(sp)
    80000a72:	0880                	addi	s0,sp,80
    80000a74:	8a2a                	mv	s4,a0
    80000a76:	89ae                	mv	s3,a1
    80000a78:	8932                	mv	s2,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000a7a:	4481                	li	s1,0
    }
    else
    {
      // printf("no map\n");
      flags = PTE_FLAGS(*pte);
      cow_base[PTCOWIDX(pa)] += 1;
    80000a7c:	08000b37          	lui	s6,0x8000
    80000a80:	1b7d                	addi	s6,s6,-1
    80000a82:	10fffab7          	lui	s5,0x10fff
    80000a86:	0a8e                	slli	s5,s5,0x3
      cow_base[PTCOWIDX(pa)] = 2;
    80000a88:	4b89                	li	s7,2
    80000a8a:	a881                	j	80000ada <uvmcopy+0x7e>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	2f4080e7          	jalr	756(ra) # 80005d88 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	2e4080e7          	jalr	740(ra) # 80005d88 <panic>
      flags = PTE_FLAGS(*pte);
    80000aac:	3ff77713          	andi	a4,a4,1023
      cow_base[PTCOWIDX(pa)] += 1;
    80000ab0:	0166f7b3          	and	a5,a3,s6
    80000ab4:	83b1                	srli	a5,a5,0xc
    80000ab6:	97d6                	add	a5,a5,s5
    80000ab8:	0007c603          	lbu	a2,0(a5) # 1000 <_entry-0x7ffff000>
    80000abc:	2605                	addiw	a2,a2,1
    80000abe:	00c78023          	sb	a2,0(a5)
    }
    if (mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    80000ac2:	6605                	lui	a2,0x1
    80000ac4:	85a6                	mv	a1,s1
    80000ac6:	854e                	mv	a0,s3
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	a98080e7          	jalr	-1384(ra) # 80000560 <mappages>
    80000ad0:	e521                	bnez	a0,80000b18 <uvmcopy+0xbc>
  for (i = 0; i < sz; i += PGSIZE)
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	94be                	add	s1,s1,a5
    80000ad6:	0524fb63          	bgeu	s1,s2,80000b2c <uvmcopy+0xd0>
    if ((pte = walk(old, i, 0)) == 0)
    80000ada:	4601                	li	a2,0
    80000adc:	85a6                	mv	a1,s1
    80000ade:	8552                	mv	a0,s4
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	998080e7          	jalr	-1640(ra) # 80000478 <walk>
    80000ae8:	d155                	beqz	a0,80000a8c <uvmcopy+0x30>
    if ((*pte & PTE_V) == 0)
    80000aea:	6118                	ld	a4,0(a0)
    80000aec:	00177793          	andi	a5,a4,1
    80000af0:	d7d5                	beqz	a5,80000a9c <uvmcopy+0x40>
    pa = PTE2PA(*pte);
    80000af2:	00a75693          	srli	a3,a4,0xa
    80000af6:	06b2                	slli	a3,a3,0xc
    if ((*pte & PTE_C) == 0)
    80000af8:	10077793          	andi	a5,a4,256
    80000afc:	fbc5                	bnez	a5,80000aac <uvmcopy+0x50>
      *pte = PTE_CLEAR_W(*pte);
    80000afe:	9b6d                	andi	a4,a4,-5
      *pte |= PTE_C;
    80000b00:	10076713          	ori	a4,a4,256
    80000b04:	e118                	sd	a4,0(a0)
      flags = PTE_FLAGS(*pte);
    80000b06:	3fb77713          	andi	a4,a4,1019
      cow_base[PTCOWIDX(pa)] = 2;
    80000b0a:	0166f7b3          	and	a5,a3,s6
    80000b0e:	83b1                	srli	a5,a5,0xc
    80000b10:	97d6                	add	a5,a5,s5
    80000b12:	01778023          	sb	s7,0(a5) # 1000 <_entry-0x7ffff000>
    80000b16:	b775                	j	80000ac2 <uvmcopy+0x66>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b18:	4685                	li	a3,1
    80000b1a:	00c4d613          	srli	a2,s1,0xc
    80000b1e:	4581                	li	a1,0
    80000b20:	854e                	mv	a0,s3
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	c04080e7          	jalr	-1020(ra) # 80000726 <uvmunmap>
  return -1;
    80000b2a:	557d                	li	a0,-1
}
    80000b2c:	60a6                	ld	ra,72(sp)
    80000b2e:	6406                	ld	s0,64(sp)
    80000b30:	74e2                	ld	s1,56(sp)
    80000b32:	7942                	ld	s2,48(sp)
    80000b34:	79a2                	ld	s3,40(sp)
    80000b36:	7a02                	ld	s4,32(sp)
    80000b38:	6ae2                	ld	s5,24(sp)
    80000b3a:	6b42                	ld	s6,16(sp)
    80000b3c:	6ba2                	ld	s7,8(sp)
    80000b3e:	6161                	addi	sp,sp,80
    80000b40:	8082                	ret
  return 0;
    80000b42:	4501                	li	a0,0
}
    80000b44:	8082                	ret

0000000080000b46 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e406                	sd	ra,8(sp)
    80000b4a:	e022                	sd	s0,0(sp)
    80000b4c:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000b4e:	4601                	li	a2,0
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	928080e7          	jalr	-1752(ra) # 80000478 <walk>
  if (pte == 0)
    80000b58:	c901                	beqz	a0,80000b68 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b5a:	611c                	ld	a5,0(a0)
    80000b5c:	9bbd                	andi	a5,a5,-17
    80000b5e:	e11c                	sd	a5,0(a0)
}
    80000b60:	60a2                	ld	ra,8(sp)
    80000b62:	6402                	ld	s0,0(sp)
    80000b64:	0141                	addi	sp,sp,16
    80000b66:	8082                	ret
    panic("uvmclear");
    80000b68:	00007517          	auipc	a0,0x7
    80000b6c:	5e050513          	addi	a0,a0,1504 # 80008148 <etext+0x148>
    80000b70:	00005097          	auipc	ra,0x5
    80000b74:	218080e7          	jalr	536(ra) # 80005d88 <panic>

0000000080000b78 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n = 0, va0, pa0;

  while (len > 0)
    80000b78:	12068c63          	beqz	a3,80000cb0 <copyout+0x138>
{
    80000b7c:	7159                	addi	sp,sp,-112
    80000b7e:	f486                	sd	ra,104(sp)
    80000b80:	f0a2                	sd	s0,96(sp)
    80000b82:	eca6                	sd	s1,88(sp)
    80000b84:	e8ca                	sd	s2,80(sp)
    80000b86:	e4ce                	sd	s3,72(sp)
    80000b88:	e0d2                	sd	s4,64(sp)
    80000b8a:	fc56                	sd	s5,56(sp)
    80000b8c:	f85a                	sd	s6,48(sp)
    80000b8e:	f45e                	sd	s7,40(sp)
    80000b90:	f062                	sd	s8,32(sp)
    80000b92:	ec66                	sd	s9,24(sp)
    80000b94:	e86a                	sd	s10,16(sp)
    80000b96:	e46e                	sd	s11,8(sp)
    80000b98:	1880                	addi	s0,sp,112
    80000b9a:	8c2a                	mv	s8,a0
    80000b9c:	8b2e                	mv	s6,a1
    80000b9e:	8bb2                	mv	s7,a2
    80000ba0:	8ab6                	mv	s5,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000ba2:	74fd                	lui	s1,0xfffff
    80000ba4:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000ba6:	57fd                	li	a5,-1
    80000ba8:	83e9                	srli	a5,a5,0x1a
    80000baa:	1097e563          	bltu	a5,s1,80000cb4 <copyout+0x13c>
      {
        panic("unable to map\n");
      }
      { // free the cow page if mapped count == 0
        uint8 *cow_base = (uint8 *)COWBASE;
        cow_base[PTCOWIDX(pa0)] -= 1;
    80000bae:	08000db7          	lui	s11,0x8000
    80000bb2:	1dfd                	addi	s11,s11,-1
    80000bb4:	10fffd37          	lui	s10,0x10fff
    80000bb8:	0d0e                	slli	s10,s10,0x3
    if (va0 >= MAXVA)
    80000bba:	8cbe                	mv	s9,a5
    80000bbc:	a855                	j	80000c70 <copyout+0xf8>
      if ((mem = kalloc()) == 0)
    80000bbe:	fffff097          	auipc	ra,0xfffff
    80000bc2:	572080e7          	jalr	1394(ra) # 80000130 <kalloc>
    80000bc6:	892a                	mv	s2,a0
    80000bc8:	c539                	beqz	a0,80000c16 <copyout+0x9e>
      memmove(mem, (char *)pa0, PGSIZE);
    80000bca:	6605                	lui	a2,0x1
    80000bcc:	85ce                	mv	a1,s3
    80000bce:	fffff097          	auipc	ra,0xfffff
    80000bd2:	622080e7          	jalr	1570(ra) # 800001f0 <memmove>
      uvmunmap(pagetable, PGROUNDDOWN(va0), 1, 0);
    80000bd6:	4681                	li	a3,0
    80000bd8:	4605                	li	a2,1
    80000bda:	85a6                	mv	a1,s1
    80000bdc:	8562                	mv	a0,s8
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	b48080e7          	jalr	-1208(ra) # 80000726 <uvmunmap>
      if (mappages(pagetable, PGROUNDDOWN(va0), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000be6:	4779                	li	a4,30
    80000be8:	86ca                	mv	a3,s2
    80000bea:	6605                	lui	a2,0x1
    80000bec:	85a6                	mv	a1,s1
    80000bee:	8562                	mv	a0,s8
    80000bf0:	00000097          	auipc	ra,0x0
    80000bf4:	970080e7          	jalr	-1680(ra) # 80000560 <mappages>
    80000bf8:	e90d                	bnez	a0,80000c2a <copyout+0xb2>
        cow_base[PTCOWIDX(pa0)] -= 1;
    80000bfa:	01b9f733          	and	a4,s3,s11
    80000bfe:	8331                	srli	a4,a4,0xc
    80000c00:	976a                	add	a4,a4,s10
    80000c02:	00074783          	lbu	a5,0(a4)
    80000c06:	37fd                	addiw	a5,a5,-1
    80000c08:	0ff7f793          	andi	a5,a5,255
    80000c0c:	00f70023          	sb	a5,0(a4)
        if (cow_base[PTCOWIDX(pa0)] == 0)
    80000c10:	c78d                	beqz	a5,80000c3a <copyout+0xc2>
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
    80000c12:	89ca                	mv	s3,s2
    80000c14:	a061                	j	80000c9c <copyout+0x124>
        printf("malloc phy fail\n");
    80000c16:	00007517          	auipc	a0,0x7
    80000c1a:	54250513          	addi	a0,a0,1346 # 80008158 <etext+0x158>
    80000c1e:	00005097          	auipc	ra,0x5
    80000c22:	1b4080e7          	jalr	436(ra) # 80005dd2 <printf>
        return -1;
    80000c26:	557d                	li	a0,-1
    80000c28:	a859                	j	80000cbe <copyout+0x146>
        panic("unable to map\n");
    80000c2a:	00007517          	auipc	a0,0x7
    80000c2e:	54650513          	addi	a0,a0,1350 # 80008170 <etext+0x170>
    80000c32:	00005097          	auipc	ra,0x5
    80000c36:	156080e7          	jalr	342(ra) # 80005d88 <panic>
          kfree((void *)PGROUNDDOWN(pa0));
    80000c3a:	77fd                	lui	a5,0xfffff
    80000c3c:	00f9f533          	and	a0,s3,a5
    80000c40:	fffff097          	auipc	ra,0xfffff
    80000c44:	3dc080e7          	jalr	988(ra) # 8000001c <kfree>
    80000c48:	b7e9                	j	80000c12 <copyout+0x9a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c4a:	409b0533          	sub	a0,s6,s1
    80000c4e:	000a061b          	sext.w	a2,s4
    80000c52:	85de                	mv	a1,s7
    80000c54:	954e                	add	a0,a0,s3
    80000c56:	fffff097          	auipc	ra,0xfffff
    80000c5a:	59a080e7          	jalr	1434(ra) # 800001f0 <memmove>
    len -= n;
    80000c5e:	414a8ab3          	sub	s5,s5,s4
    src += n;
    80000c62:	9bd2                	add	s7,s7,s4
  while (len > 0)
    80000c64:	040a8463          	beqz	s5,80000cac <copyout+0x134>
    if (va0 >= MAXVA)
    80000c68:	052ce863          	bltu	s9,s2,80000cb8 <copyout+0x140>
    va0 = PGROUNDDOWN(dstva);
    80000c6c:	84ca                	mv	s1,s2
    dstva = va0 + PGSIZE;
    80000c6e:	8b4a                	mv	s6,s2
    pte_t *pte = walk(pagetable, va0, 0);
    80000c70:	4601                	li	a2,0
    80000c72:	85a6                	mv	a1,s1
    80000c74:	8562                	mv	a0,s8
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	802080e7          	jalr	-2046(ra) # 80000478 <walk>
    80000c7e:	892a                	mv	s2,a0
    if (pte == 0)
    80000c80:	cd15                	beqz	a0,80000cbc <copyout+0x144>
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85a6                	mv	a1,s1
    80000c84:	8562                	mv	a0,s8
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	898080e7          	jalr	-1896(ra) # 8000051e <walkaddr>
    80000c8e:	89aa                	mv	s3,a0
    if ((*pte & PTE_C) != 0)
    80000c90:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000c94:	1007f793          	andi	a5,a5,256
    80000c98:	f39d                	bnez	a5,80000bbe <copyout+0x46>
    if (pa0 == 0)
    80000c9a:	c129                	beqz	a0,80000cdc <copyout+0x164>
    n = PGSIZE - (dstva - va0);
    80000c9c:	6905                	lui	s2,0x1
    80000c9e:	9926                	add	s2,s2,s1
    80000ca0:	41690a33          	sub	s4,s2,s6
    if (n > len)
    80000ca4:	fb4af3e3          	bgeu	s5,s4,80000c4a <copyout+0xd2>
    80000ca8:	8a56                	mv	s4,s5
    80000caa:	b745                	j	80000c4a <copyout+0xd2>
  }
  return 0;
    80000cac:	4501                	li	a0,0
    80000cae:	a801                	j	80000cbe <copyout+0x146>
    80000cb0:	4501                	li	a0,0
}
    80000cb2:	8082                	ret
      return -1;
    80000cb4:	557d                	li	a0,-1
    80000cb6:	a021                	j	80000cbe <copyout+0x146>
    80000cb8:	557d                	li	a0,-1
    80000cba:	a011                	j	80000cbe <copyout+0x146>
      return -1;
    80000cbc:	557d                	li	a0,-1
}
    80000cbe:	70a6                	ld	ra,104(sp)
    80000cc0:	7406                	ld	s0,96(sp)
    80000cc2:	64e6                	ld	s1,88(sp)
    80000cc4:	6946                	ld	s2,80(sp)
    80000cc6:	69a6                	ld	s3,72(sp)
    80000cc8:	6a06                	ld	s4,64(sp)
    80000cca:	7ae2                	ld	s5,56(sp)
    80000ccc:	7b42                	ld	s6,48(sp)
    80000cce:	7ba2                	ld	s7,40(sp)
    80000cd0:	7c02                	ld	s8,32(sp)
    80000cd2:	6ce2                	ld	s9,24(sp)
    80000cd4:	6d42                	ld	s10,16(sp)
    80000cd6:	6da2                	ld	s11,8(sp)
    80000cd8:	6165                	addi	sp,sp,112
    80000cda:	8082                	ret
      return -1;
    80000cdc:	557d                	li	a0,-1
    80000cde:	b7c5                	j	80000cbe <copyout+0x146>

0000000080000ce0 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000ce0:	c6bd                	beqz	a3,80000d4e <copyin+0x6e>
{
    80000ce2:	715d                	addi	sp,sp,-80
    80000ce4:	e486                	sd	ra,72(sp)
    80000ce6:	e0a2                	sd	s0,64(sp)
    80000ce8:	fc26                	sd	s1,56(sp)
    80000cea:	f84a                	sd	s2,48(sp)
    80000cec:	f44e                	sd	s3,40(sp)
    80000cee:	f052                	sd	s4,32(sp)
    80000cf0:	ec56                	sd	s5,24(sp)
    80000cf2:	e85a                	sd	s6,16(sp)
    80000cf4:	e45e                	sd	s7,8(sp)
    80000cf6:	e062                	sd	s8,0(sp)
    80000cf8:	0880                	addi	s0,sp,80
    80000cfa:	8b2a                	mv	s6,a0
    80000cfc:	8a2e                	mv	s4,a1
    80000cfe:	8c32                	mv	s8,a2
    80000d00:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d04:	6a85                	lui	s5,0x1
    80000d06:	a015                	j	80000d2a <copyin+0x4a>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d08:	9562                	add	a0,a0,s8
    80000d0a:	0004861b          	sext.w	a2,s1
    80000d0e:	412505b3          	sub	a1,a0,s2
    80000d12:	8552                	mv	a0,s4
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	4dc080e7          	jalr	1244(ra) # 800001f0 <memmove>

    len -= n;
    80000d1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d22:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000d26:	02098263          	beqz	s3,80000d4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d2e:	85ca                	mv	a1,s2
    80000d30:	855a                	mv	a0,s6
    80000d32:	fffff097          	auipc	ra,0xfffff
    80000d36:	7ec080e7          	jalr	2028(ra) # 8000051e <walkaddr>
    if (pa0 == 0)
    80000d3a:	cd01                	beqz	a0,80000d52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d3c:	418904b3          	sub	s1,s2,s8
    80000d40:	94d6                	add	s1,s1,s5
    if (n > len)
    80000d42:	fc99f3e3          	bgeu	s3,s1,80000d08 <copyin+0x28>
    80000d46:	84ce                	mv	s1,s3
    80000d48:	b7c1                	j	80000d08 <copyin+0x28>
  }
  return 0;
    80000d4a:	4501                	li	a0,0
    80000d4c:	a021                	j	80000d54 <copyin+0x74>
    80000d4e:	4501                	li	a0,0
}
    80000d50:	8082                	ret
      return -1;
    80000d52:	557d                	li	a0,-1
}
    80000d54:	60a6                	ld	ra,72(sp)
    80000d56:	6406                	ld	s0,64(sp)
    80000d58:	74e2                	ld	s1,56(sp)
    80000d5a:	7942                	ld	s2,48(sp)
    80000d5c:	79a2                	ld	s3,40(sp)
    80000d5e:	7a02                	ld	s4,32(sp)
    80000d60:	6ae2                	ld	s5,24(sp)
    80000d62:	6b42                	ld	s6,16(sp)
    80000d64:	6ba2                	ld	s7,8(sp)
    80000d66:	6c02                	ld	s8,0(sp)
    80000d68:	6161                	addi	sp,sp,80
    80000d6a:	8082                	ret

0000000080000d6c <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80000d6c:	c6c5                	beqz	a3,80000e14 <copyinstr+0xa8>
{
    80000d6e:	715d                	addi	sp,sp,-80
    80000d70:	e486                	sd	ra,72(sp)
    80000d72:	e0a2                	sd	s0,64(sp)
    80000d74:	fc26                	sd	s1,56(sp)
    80000d76:	f84a                	sd	s2,48(sp)
    80000d78:	f44e                	sd	s3,40(sp)
    80000d7a:	f052                	sd	s4,32(sp)
    80000d7c:	ec56                	sd	s5,24(sp)
    80000d7e:	e85a                	sd	s6,16(sp)
    80000d80:	e45e                	sd	s7,8(sp)
    80000d82:	0880                	addi	s0,sp,80
    80000d84:	8a2a                	mv	s4,a0
    80000d86:	8b2e                	mv	s6,a1
    80000d88:	8bb2                	mv	s7,a2
    80000d8a:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d8e:	6985                	lui	s3,0x1
    80000d90:	a035                	j	80000dbc <copyinstr+0x50>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000d92:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000d96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000d98:	0017b793          	seqz	a5,a5
    80000d9c:	40f00533          	neg	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000da0:	60a6                	ld	ra,72(sp)
    80000da2:	6406                	ld	s0,64(sp)
    80000da4:	74e2                	ld	s1,56(sp)
    80000da6:	7942                	ld	s2,48(sp)
    80000da8:	79a2                	ld	s3,40(sp)
    80000daa:	7a02                	ld	s4,32(sp)
    80000dac:	6ae2                	ld	s5,24(sp)
    80000dae:	6b42                	ld	s6,16(sp)
    80000db0:	6ba2                	ld	s7,8(sp)
    80000db2:	6161                	addi	sp,sp,80
    80000db4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000db6:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80000dba:	c8a9                	beqz	s1,80000e0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dc0:	85ca                	mv	a1,s2
    80000dc2:	8552                	mv	a0,s4
    80000dc4:	fffff097          	auipc	ra,0xfffff
    80000dc8:	75a080e7          	jalr	1882(ra) # 8000051e <walkaddr>
    if (pa0 == 0)
    80000dcc:	c131                	beqz	a0,80000e10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000dce:	41790833          	sub	a6,s2,s7
    80000dd2:	984e                	add	a6,a6,s3
    if (n > max)
    80000dd4:	0104f363          	bgeu	s1,a6,80000dda <copyinstr+0x6e>
    80000dd8:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000dda:	955e                	add	a0,a0,s7
    80000ddc:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80000de0:	fc080be3          	beqz	a6,80000db6 <copyinstr+0x4a>
    80000de4:	985a                	add	a6,a6,s6
    80000de6:	87da                	mv	a5,s6
      if (*p == '\0')
    80000de8:	41650633          	sub	a2,a0,s6
    80000dec:	14fd                	addi	s1,s1,-1
    80000dee:	9b26                	add	s6,s6,s1
    80000df0:	00f60733          	add	a4,a2,a5
    80000df4:	00074703          	lbu	a4,0(a4)
    80000df8:	df49                	beqz	a4,80000d92 <copyinstr+0x26>
        *dst = *p;
    80000dfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000dfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e02:	0785                	addi	a5,a5,1
    while (n > 0)
    80000e04:	ff0796e3          	bne	a5,a6,80000df0 <copyinstr+0x84>
      dst++;
    80000e08:	8b42                	mv	s6,a6
    80000e0a:	b775                	j	80000db6 <copyinstr+0x4a>
    80000e0c:	4781                	li	a5,0
    80000e0e:	b769                	j	80000d98 <copyinstr+0x2c>
      return -1;
    80000e10:	557d                	li	a0,-1
    80000e12:	b779                	j	80000da0 <copyinstr+0x34>
  int got_null = 0;
    80000e14:	4781                	li	a5,0
  if (got_null)
    80000e16:	0017b793          	seqz	a5,a5
    80000e1a:	40f00533          	neg	a0,a5
}
    80000e1e:	8082                	ret

0000000080000e20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000e20:	7139                	addi	sp,sp,-64
    80000e22:	fc06                	sd	ra,56(sp)
    80000e24:	f822                	sd	s0,48(sp)
    80000e26:	f426                	sd	s1,40(sp)
    80000e28:	f04a                	sd	s2,32(sp)
    80000e2a:	ec4e                	sd	s3,24(sp)
    80000e2c:	e852                	sd	s4,16(sp)
    80000e2e:	e456                	sd	s5,8(sp)
    80000e30:	e05a                	sd	s6,0(sp)
    80000e32:	0080                	addi	s0,sp,64
    80000e34:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000e36:	00008497          	auipc	s1,0x8
    80000e3a:	64a48493          	addi	s1,s1,1610 # 80009480 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000e3e:	8b26                	mv	s6,s1
    80000e40:	00007a97          	auipc	s5,0x7
    80000e44:	1c0a8a93          	addi	s5,s5,448 # 80008000 <etext>
    80000e48:	04000937          	lui	s2,0x4000
    80000e4c:	197d                	addi	s2,s2,-1
    80000e4e:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000e50:	0000ea17          	auipc	s4,0xe
    80000e54:	030a0a13          	addi	s4,s4,48 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000e58:	fffff097          	auipc	ra,0xfffff
    80000e5c:	2d8080e7          	jalr	728(ra) # 80000130 <kalloc>
    80000e60:	862a                	mv	a2,a0
    if (pa == 0)
    80000e62:	c131                	beqz	a0,80000ea6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000e64:	416485b3          	sub	a1,s1,s6
    80000e68:	858d                	srai	a1,a1,0x3
    80000e6a:	000ab783          	ld	a5,0(s5)
    80000e6e:	02f585b3          	mul	a1,a1,a5
    80000e72:	2585                	addiw	a1,a1,1
    80000e74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e78:	4719                	li	a4,6
    80000e7a:	6685                	lui	a3,0x1
    80000e7c:	40b905b3          	sub	a1,s2,a1
    80000e80:	854e                	mv	a0,s3
    80000e82:	fffff097          	auipc	ra,0xfffff
    80000e86:	77e080e7          	jalr	1918(ra) # 80000600 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000e8a:	16848493          	addi	s1,s1,360
    80000e8e:	fd4495e3          	bne	s1,s4,80000e58 <proc_mapstacks+0x38>
  }
}
    80000e92:	70e2                	ld	ra,56(sp)
    80000e94:	7442                	ld	s0,48(sp)
    80000e96:	74a2                	ld	s1,40(sp)
    80000e98:	7902                	ld	s2,32(sp)
    80000e9a:	69e2                	ld	s3,24(sp)
    80000e9c:	6a42                	ld	s4,16(sp)
    80000e9e:	6aa2                	ld	s5,8(sp)
    80000ea0:	6b02                	ld	s6,0(sp)
    80000ea2:	6121                	addi	sp,sp,64
    80000ea4:	8082                	ret
      panic("kalloc");
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	2da50513          	addi	a0,a0,730 # 80008180 <etext+0x180>
    80000eae:	00005097          	auipc	ra,0x5
    80000eb2:	eda080e7          	jalr	-294(ra) # 80005d88 <panic>

0000000080000eb6 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000eb6:	7139                	addi	sp,sp,-64
    80000eb8:	fc06                	sd	ra,56(sp)
    80000eba:	f822                	sd	s0,48(sp)
    80000ebc:	f426                	sd	s1,40(sp)
    80000ebe:	f04a                	sd	s2,32(sp)
    80000ec0:	ec4e                	sd	s3,24(sp)
    80000ec2:	e852                	sd	s4,16(sp)
    80000ec4:	e456                	sd	s5,8(sp)
    80000ec6:	e05a                	sd	s6,0(sp)
    80000ec8:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000eca:	00007597          	auipc	a1,0x7
    80000ece:	2be58593          	addi	a1,a1,702 # 80008188 <etext+0x188>
    80000ed2:	00008517          	auipc	a0,0x8
    80000ed6:	17e50513          	addi	a0,a0,382 # 80009050 <pid_lock>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	368080e7          	jalr	872(ra) # 80006242 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ee2:	00007597          	auipc	a1,0x7
    80000ee6:	2ae58593          	addi	a1,a1,686 # 80008190 <etext+0x190>
    80000eea:	00008517          	auipc	a0,0x8
    80000eee:	17e50513          	addi	a0,a0,382 # 80009068 <wait_lock>
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	350080e7          	jalr	848(ra) # 80006242 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000efa:	00008497          	auipc	s1,0x8
    80000efe:	58648493          	addi	s1,s1,1414 # 80009480 <proc>
  {
    initlock(&p->lock, "proc");
    80000f02:	00007b17          	auipc	s6,0x7
    80000f06:	29eb0b13          	addi	s6,s6,670 # 800081a0 <etext+0x1a0>
    p->kstack = KSTACK((int)(p - proc));
    80000f0a:	8aa6                	mv	s5,s1
    80000f0c:	00007a17          	auipc	s4,0x7
    80000f10:	0f4a0a13          	addi	s4,s4,244 # 80008000 <etext>
    80000f14:	04000937          	lui	s2,0x4000
    80000f18:	197d                	addi	s2,s2,-1
    80000f1a:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000f1c:	0000e997          	auipc	s3,0xe
    80000f20:	f6498993          	addi	s3,s3,-156 # 8000ee80 <tickslock>
    initlock(&p->lock, "proc");
    80000f24:	85da                	mv	a1,s6
    80000f26:	8526                	mv	a0,s1
    80000f28:	00005097          	auipc	ra,0x5
    80000f2c:	31a080e7          	jalr	794(ra) # 80006242 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000f30:	415487b3          	sub	a5,s1,s5
    80000f34:	878d                	srai	a5,a5,0x3
    80000f36:	000a3703          	ld	a4,0(s4)
    80000f3a:	02e787b3          	mul	a5,a5,a4
    80000f3e:	2785                	addiw	a5,a5,1
    80000f40:	00d7979b          	slliw	a5,a5,0xd
    80000f44:	40f907b3          	sub	a5,s2,a5
    80000f48:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000f4a:	16848493          	addi	s1,s1,360
    80000f4e:	fd349be3          	bne	s1,s3,80000f24 <procinit+0x6e>
  }
}
    80000f52:	70e2                	ld	ra,56(sp)
    80000f54:	7442                	ld	s0,48(sp)
    80000f56:	74a2                	ld	s1,40(sp)
    80000f58:	7902                	ld	s2,32(sp)
    80000f5a:	69e2                	ld	s3,24(sp)
    80000f5c:	6a42                	ld	s4,16(sp)
    80000f5e:	6aa2                	ld	s5,8(sp)
    80000f60:	6b02                	ld	s6,0(sp)
    80000f62:	6121                	addi	sp,sp,64
    80000f64:	8082                	ret

0000000080000f66 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000f66:	1141                	addi	sp,sp,-16
    80000f68:	e422                	sd	s0,8(sp)
    80000f6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp"
    80000f6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f6e:	2501                	sext.w	a0,a0
    80000f70:	6422                	ld	s0,8(sp)
    80000f72:	0141                	addi	sp,sp,16
    80000f74:	8082                	ret

0000000080000f76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e422                	sd	s0,8(sp)
    80000f7a:	0800                	addi	s0,sp,16
    80000f7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f7e:	2781                	sext.w	a5,a5
    80000f80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f82:	00008517          	auipc	a0,0x8
    80000f86:	0fe50513          	addi	a0,a0,254 # 80009080 <cpus>
    80000f8a:	953e                	add	a0,a0,a5
    80000f8c:	6422                	ld	s0,8(sp)
    80000f8e:	0141                	addi	sp,sp,16
    80000f90:	8082                	ret

0000000080000f92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000f92:	1101                	addi	sp,sp,-32
    80000f94:	ec06                	sd	ra,24(sp)
    80000f96:	e822                	sd	s0,16(sp)
    80000f98:	e426                	sd	s1,8(sp)
    80000f9a:	1000                	addi	s0,sp,32
  push_off();
    80000f9c:	00005097          	auipc	ra,0x5
    80000fa0:	2ea080e7          	jalr	746(ra) # 80006286 <push_off>
    80000fa4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fa6:	2781                	sext.w	a5,a5
    80000fa8:	079e                	slli	a5,a5,0x7
    80000faa:	00008717          	auipc	a4,0x8
    80000fae:	0a670713          	addi	a4,a4,166 # 80009050 <pid_lock>
    80000fb2:	97ba                	add	a5,a5,a4
    80000fb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fb6:	00005097          	auipc	ra,0x5
    80000fba:	370080e7          	jalr	880(ra) # 80006326 <pop_off>
  return p;
}
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	60e2                	ld	ra,24(sp)
    80000fc2:	6442                	ld	s0,16(sp)
    80000fc4:	64a2                	ld	s1,8(sp)
    80000fc6:	6105                	addi	sp,sp,32
    80000fc8:	8082                	ret

0000000080000fca <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000fca:	1141                	addi	sp,sp,-16
    80000fcc:	e406                	sd	ra,8(sp)
    80000fce:	e022                	sd	s0,0(sp)
    80000fd0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	fc0080e7          	jalr	-64(ra) # 80000f92 <myproc>
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	3ac080e7          	jalr	940(ra) # 80006386 <release>

  if (first)
    80000fe2:	00008797          	auipc	a5,0x8
    80000fe6:	8ce7a783          	lw	a5,-1842(a5) # 800088b0 <first.1676>
    80000fea:	eb89                	bnez	a5,80000ffc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fec:	00001097          	auipc	ra,0x1
    80000ff0:	c0a080e7          	jalr	-1014(ra) # 80001bf6 <usertrapret>
}
    80000ff4:	60a2                	ld	ra,8(sp)
    80000ff6:	6402                	ld	s0,0(sp)
    80000ff8:	0141                	addi	sp,sp,16
    80000ffa:	8082                	ret
    first = 0;
    80000ffc:	00008797          	auipc	a5,0x8
    80001000:	8a07aa23          	sw	zero,-1868(a5) # 800088b0 <first.1676>
    fsinit(ROOTDEV);
    80001004:	4505                	li	a0,1
    80001006:	00002097          	auipc	ra,0x2
    8000100a:	a5c080e7          	jalr	-1444(ra) # 80002a62 <fsinit>
    8000100e:	bff9                	j	80000fec <forkret+0x22>

0000000080001010 <allocpid>:
{
    80001010:	1101                	addi	sp,sp,-32
    80001012:	ec06                	sd	ra,24(sp)
    80001014:	e822                	sd	s0,16(sp)
    80001016:	e426                	sd	s1,8(sp)
    80001018:	e04a                	sd	s2,0(sp)
    8000101a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000101c:	00008917          	auipc	s2,0x8
    80001020:	03490913          	addi	s2,s2,52 # 80009050 <pid_lock>
    80001024:	854a                	mv	a0,s2
    80001026:	00005097          	auipc	ra,0x5
    8000102a:	2ac080e7          	jalr	684(ra) # 800062d2 <acquire>
  pid = nextpid;
    8000102e:	00008797          	auipc	a5,0x8
    80001032:	88678793          	addi	a5,a5,-1914 # 800088b4 <nextpid>
    80001036:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001038:	0014871b          	addiw	a4,s1,1
    8000103c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000103e:	854a                	mv	a0,s2
    80001040:	00005097          	auipc	ra,0x5
    80001044:	346080e7          	jalr	838(ra) # 80006386 <release>
}
    80001048:	8526                	mv	a0,s1
    8000104a:	60e2                	ld	ra,24(sp)
    8000104c:	6442                	ld	s0,16(sp)
    8000104e:	64a2                	ld	s1,8(sp)
    80001050:	6902                	ld	s2,0(sp)
    80001052:	6105                	addi	sp,sp,32
    80001054:	8082                	ret

0000000080001056 <proc_pagetable>:
{
    80001056:	1101                	addi	sp,sp,-32
    80001058:	ec06                	sd	ra,24(sp)
    8000105a:	e822                	sd	s0,16(sp)
    8000105c:	e426                	sd	s1,8(sp)
    8000105e:	e04a                	sd	s2,0(sp)
    80001060:	1000                	addi	s0,sp,32
    80001062:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001064:	fffff097          	auipc	ra,0xfffff
    80001068:	7c4080e7          	jalr	1988(ra) # 80000828 <uvmcreate>
    8000106c:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000106e:	c121                	beqz	a0,800010ae <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001070:	4729                	li	a4,10
    80001072:	00006697          	auipc	a3,0x6
    80001076:	f8e68693          	addi	a3,a3,-114 # 80007000 <_trampoline>
    8000107a:	6605                	lui	a2,0x1
    8000107c:	040005b7          	lui	a1,0x4000
    80001080:	15fd                	addi	a1,a1,-1
    80001082:	05b2                	slli	a1,a1,0xc
    80001084:	fffff097          	auipc	ra,0xfffff
    80001088:	4dc080e7          	jalr	1244(ra) # 80000560 <mappages>
    8000108c:	02054863          	bltz	a0,800010bc <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001090:	4719                	li	a4,6
    80001092:	05893683          	ld	a3,88(s2)
    80001096:	6605                	lui	a2,0x1
    80001098:	020005b7          	lui	a1,0x2000
    8000109c:	15fd                	addi	a1,a1,-1
    8000109e:	05b6                	slli	a1,a1,0xd
    800010a0:	8526                	mv	a0,s1
    800010a2:	fffff097          	auipc	ra,0xfffff
    800010a6:	4be080e7          	jalr	1214(ra) # 80000560 <mappages>
    800010aa:	02054163          	bltz	a0,800010cc <proc_pagetable+0x76>
}
    800010ae:	8526                	mv	a0,s1
    800010b0:	60e2                	ld	ra,24(sp)
    800010b2:	6442                	ld	s0,16(sp)
    800010b4:	64a2                	ld	s1,8(sp)
    800010b6:	6902                	ld	s2,0(sp)
    800010b8:	6105                	addi	sp,sp,32
    800010ba:	8082                	ret
    uvmfree(pagetable, 0);
    800010bc:	4581                	li	a1,0
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	964080e7          	jalr	-1692(ra) # 80000a24 <uvmfree>
    return 0;
    800010c8:	4481                	li	s1,0
    800010ca:	b7d5                	j	800010ae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010cc:	4681                	li	a3,0
    800010ce:	4605                	li	a2,1
    800010d0:	040005b7          	lui	a1,0x4000
    800010d4:	15fd                	addi	a1,a1,-1
    800010d6:	05b2                	slli	a1,a1,0xc
    800010d8:	8526                	mv	a0,s1
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	64c080e7          	jalr	1612(ra) # 80000726 <uvmunmap>
    uvmfree(pagetable, 0);
    800010e2:	4581                	li	a1,0
    800010e4:	8526                	mv	a0,s1
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	93e080e7          	jalr	-1730(ra) # 80000a24 <uvmfree>
    return 0;
    800010ee:	4481                	li	s1,0
    800010f0:	bf7d                	j	800010ae <proc_pagetable+0x58>

00000000800010f2 <proc_freepagetable>:
{
    800010f2:	1101                	addi	sp,sp,-32
    800010f4:	ec06                	sd	ra,24(sp)
    800010f6:	e822                	sd	s0,16(sp)
    800010f8:	e426                	sd	s1,8(sp)
    800010fa:	e04a                	sd	s2,0(sp)
    800010fc:	1000                	addi	s0,sp,32
    800010fe:	84aa                	mv	s1,a0
    80001100:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001102:	4681                	li	a3,0
    80001104:	4605                	li	a2,1
    80001106:	040005b7          	lui	a1,0x4000
    8000110a:	15fd                	addi	a1,a1,-1
    8000110c:	05b2                	slli	a1,a1,0xc
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	618080e7          	jalr	1560(ra) # 80000726 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	020005b7          	lui	a1,0x2000
    8000111e:	15fd                	addi	a1,a1,-1
    80001120:	05b6                	slli	a1,a1,0xd
    80001122:	8526                	mv	a0,s1
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	602080e7          	jalr	1538(ra) # 80000726 <uvmunmap>
  uvmfree(pagetable, sz);
    8000112c:	85ca                	mv	a1,s2
    8000112e:	8526                	mv	a0,s1
    80001130:	00000097          	auipc	ra,0x0
    80001134:	8f4080e7          	jalr	-1804(ra) # 80000a24 <uvmfree>
}
    80001138:	60e2                	ld	ra,24(sp)
    8000113a:	6442                	ld	s0,16(sp)
    8000113c:	64a2                	ld	s1,8(sp)
    8000113e:	6902                	ld	s2,0(sp)
    80001140:	6105                	addi	sp,sp,32
    80001142:	8082                	ret

0000000080001144 <freeproc>:
{
    80001144:	1101                	addi	sp,sp,-32
    80001146:	ec06                	sd	ra,24(sp)
    80001148:	e822                	sd	s0,16(sp)
    8000114a:	e426                	sd	s1,8(sp)
    8000114c:	1000                	addi	s0,sp,32
    8000114e:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001150:	6d28                	ld	a0,88(a0)
    80001152:	c509                	beqz	a0,8000115c <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	ec8080e7          	jalr	-312(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000115c:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001160:	68a8                	ld	a0,80(s1)
    80001162:	c511                	beqz	a0,8000116e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001164:	64ac                	ld	a1,72(s1)
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	f8c080e7          	jalr	-116(ra) # 800010f2 <proc_freepagetable>
  p->pagetable = 0;
    8000116e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001172:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001176:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000117a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000117e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001182:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001186:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000118a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000118e:	0004ac23          	sw	zero,24(s1)
}
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret

000000008000119c <allocproc>:
{
    8000119c:	1101                	addi	sp,sp,-32
    8000119e:	ec06                	sd	ra,24(sp)
    800011a0:	e822                	sd	s0,16(sp)
    800011a2:	e426                	sd	s1,8(sp)
    800011a4:	e04a                	sd	s2,0(sp)
    800011a6:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    800011a8:	00008497          	auipc	s1,0x8
    800011ac:	2d848493          	addi	s1,s1,728 # 80009480 <proc>
    800011b0:	0000e917          	auipc	s2,0xe
    800011b4:	cd090913          	addi	s2,s2,-816 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800011b8:	8526                	mv	a0,s1
    800011ba:	00005097          	auipc	ra,0x5
    800011be:	118080e7          	jalr	280(ra) # 800062d2 <acquire>
    if (p->state == UNUSED)
    800011c2:	4c9c                	lw	a5,24(s1)
    800011c4:	cf81                	beqz	a5,800011dc <allocproc+0x40>
      release(&p->lock);
    800011c6:	8526                	mv	a0,s1
    800011c8:	00005097          	auipc	ra,0x5
    800011cc:	1be080e7          	jalr	446(ra) # 80006386 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800011d0:	16848493          	addi	s1,s1,360
    800011d4:	ff2492e3          	bne	s1,s2,800011b8 <allocproc+0x1c>
  return 0;
    800011d8:	4481                	li	s1,0
    800011da:	a889                	j	8000122c <allocproc+0x90>
  p->pid = allocpid();
    800011dc:	00000097          	auipc	ra,0x0
    800011e0:	e34080e7          	jalr	-460(ra) # 80001010 <allocpid>
    800011e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011e6:	4785                	li	a5,1
    800011e8:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	f46080e7          	jalr	-186(ra) # 80000130 <kalloc>
    800011f2:	892a                	mv	s2,a0
    800011f4:	eca8                	sd	a0,88(s1)
    800011f6:	c131                	beqz	a0,8000123a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011f8:	8526                	mv	a0,s1
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	e5c080e7          	jalr	-420(ra) # 80001056 <proc_pagetable>
    80001202:	892a                	mv	s2,a0
    80001204:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001206:	c531                	beqz	a0,80001252 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001208:	07000613          	li	a2,112
    8000120c:	4581                	li	a1,0
    8000120e:	06048513          	addi	a0,s1,96
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	f7e080e7          	jalr	-130(ra) # 80000190 <memset>
  p->context.ra = (uint64)forkret;
    8000121a:	00000797          	auipc	a5,0x0
    8000121e:	db078793          	addi	a5,a5,-592 # 80000fca <forkret>
    80001222:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001224:	60bc                	ld	a5,64(s1)
    80001226:	6705                	lui	a4,0x1
    80001228:	97ba                	add	a5,a5,a4
    8000122a:	f4bc                	sd	a5,104(s1)
}
    8000122c:	8526                	mv	a0,s1
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret
    freeproc(p);
    8000123a:	8526                	mv	a0,s1
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	f08080e7          	jalr	-248(ra) # 80001144 <freeproc>
    release(&p->lock);
    80001244:	8526                	mv	a0,s1
    80001246:	00005097          	auipc	ra,0x5
    8000124a:	140080e7          	jalr	320(ra) # 80006386 <release>
    return 0;
    8000124e:	84ca                	mv	s1,s2
    80001250:	bff1                	j	8000122c <allocproc+0x90>
    freeproc(p);
    80001252:	8526                	mv	a0,s1
    80001254:	00000097          	auipc	ra,0x0
    80001258:	ef0080e7          	jalr	-272(ra) # 80001144 <freeproc>
    release(&p->lock);
    8000125c:	8526                	mv	a0,s1
    8000125e:	00005097          	auipc	ra,0x5
    80001262:	128080e7          	jalr	296(ra) # 80006386 <release>
    return 0;
    80001266:	84ca                	mv	s1,s2
    80001268:	b7d1                	j	8000122c <allocproc+0x90>

000000008000126a <userinit>:
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	1000                	addi	s0,sp,32
  p = allocproc();
    80001274:	00000097          	auipc	ra,0x0
    80001278:	f28080e7          	jalr	-216(ra) # 8000119c <allocproc>
    8000127c:	84aa                	mv	s1,a0
  initproc = p;
    8000127e:	00008797          	auipc	a5,0x8
    80001282:	d8a7b923          	sd	a0,-622(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001286:	03400613          	li	a2,52
    8000128a:	00007597          	auipc	a1,0x7
    8000128e:	63658593          	addi	a1,a1,1590 # 800088c0 <initcode>
    80001292:	6928                	ld	a0,80(a0)
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	5c2080e7          	jalr	1474(ra) # 80000856 <uvminit>
  p->sz = PGSIZE;
    8000129c:	6785                	lui	a5,0x1
    8000129e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    800012a0:	6cb8                	ld	a4,88(s1)
    800012a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    800012a6:	6cb8                	ld	a4,88(s1)
    800012a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012aa:	4641                	li	a2,16
    800012ac:	00007597          	auipc	a1,0x7
    800012b0:	efc58593          	addi	a1,a1,-260 # 800081a8 <etext+0x1a8>
    800012b4:	15848513          	addi	a0,s1,344
    800012b8:	fffff097          	auipc	ra,0xfffff
    800012bc:	02a080e7          	jalr	42(ra) # 800002e2 <safestrcpy>
  p->cwd = namei("/");
    800012c0:	00007517          	auipc	a0,0x7
    800012c4:	ef850513          	addi	a0,a0,-264 # 800081b8 <etext+0x1b8>
    800012c8:	00002097          	auipc	ra,0x2
    800012cc:	1c8080e7          	jalr	456(ra) # 80003490 <namei>
    800012d0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012d4:	478d                	li	a5,3
    800012d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012d8:	8526                	mv	a0,s1
    800012da:	00005097          	auipc	ra,0x5
    800012de:	0ac080e7          	jalr	172(ra) # 80006386 <release>
}
    800012e2:	60e2                	ld	ra,24(sp)
    800012e4:	6442                	ld	s0,16(sp)
    800012e6:	64a2                	ld	s1,8(sp)
    800012e8:	6105                	addi	sp,sp,32
    800012ea:	8082                	ret

00000000800012ec <growproc>:
{
    800012ec:	1101                	addi	sp,sp,-32
    800012ee:	ec06                	sd	ra,24(sp)
    800012f0:	e822                	sd	s0,16(sp)
    800012f2:	e426                	sd	s1,8(sp)
    800012f4:	e04a                	sd	s2,0(sp)
    800012f6:	1000                	addi	s0,sp,32
    800012f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	c98080e7          	jalr	-872(ra) # 80000f92 <myproc>
    80001302:	892a                	mv	s2,a0
  sz = p->sz;
    80001304:	652c                	ld	a1,72(a0)
    80001306:	0005861b          	sext.w	a2,a1
  if (n > 0)
    8000130a:	00904f63          	bgtz	s1,80001328 <growproc+0x3c>
  else if (n < 0)
    8000130e:	0204cc63          	bltz	s1,80001346 <growproc+0x5a>
  p->sz = sz;
    80001312:	1602                	slli	a2,a2,0x20
    80001314:	9201                	srli	a2,a2,0x20
    80001316:	04c93423          	sd	a2,72(s2)
  return 0;
    8000131a:	4501                	li	a0,0
}
    8000131c:	60e2                	ld	ra,24(sp)
    8000131e:	6442                	ld	s0,16(sp)
    80001320:	64a2                	ld	s1,8(sp)
    80001322:	6902                	ld	s2,0(sp)
    80001324:	6105                	addi	sp,sp,32
    80001326:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    80001328:	9e25                	addw	a2,a2,s1
    8000132a:	1602                	slli	a2,a2,0x20
    8000132c:	9201                	srli	a2,a2,0x20
    8000132e:	1582                	slli	a1,a1,0x20
    80001330:	9181                	srli	a1,a1,0x20
    80001332:	6928                	ld	a0,80(a0)
    80001334:	fffff097          	auipc	ra,0xfffff
    80001338:	5dc080e7          	jalr	1500(ra) # 80000910 <uvmalloc>
    8000133c:	0005061b          	sext.w	a2,a0
    80001340:	fa69                	bnez	a2,80001312 <growproc+0x26>
      return -1;
    80001342:	557d                	li	a0,-1
    80001344:	bfe1                	j	8000131c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001346:	9e25                	addw	a2,a2,s1
    80001348:	1602                	slli	a2,a2,0x20
    8000134a:	9201                	srli	a2,a2,0x20
    8000134c:	1582                	slli	a1,a1,0x20
    8000134e:	9181                	srli	a1,a1,0x20
    80001350:	6928                	ld	a0,80(a0)
    80001352:	fffff097          	auipc	ra,0xfffff
    80001356:	576080e7          	jalr	1398(ra) # 800008c8 <uvmdealloc>
    8000135a:	0005061b          	sext.w	a2,a0
    8000135e:	bf55                	j	80001312 <growproc+0x26>

0000000080001360 <fork>:
{
    80001360:	7179                	addi	sp,sp,-48
    80001362:	f406                	sd	ra,40(sp)
    80001364:	f022                	sd	s0,32(sp)
    80001366:	ec26                	sd	s1,24(sp)
    80001368:	e84a                	sd	s2,16(sp)
    8000136a:	e44e                	sd	s3,8(sp)
    8000136c:	e052                	sd	s4,0(sp)
    8000136e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001370:	00000097          	auipc	ra,0x0
    80001374:	c22080e7          	jalr	-990(ra) # 80000f92 <myproc>
    80001378:	892a                	mv	s2,a0
  if ((np = allocproc()) == 0)
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	e22080e7          	jalr	-478(ra) # 8000119c <allocproc>
    80001382:	10050b63          	beqz	a0,80001498 <fork+0x138>
    80001386:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001388:	04893603          	ld	a2,72(s2)
    8000138c:	692c                	ld	a1,80(a0)
    8000138e:	05093503          	ld	a0,80(s2)
    80001392:	fffff097          	auipc	ra,0xfffff
    80001396:	6ca080e7          	jalr	1738(ra) # 80000a5c <uvmcopy>
    8000139a:	04054663          	bltz	a0,800013e6 <fork+0x86>
  np->sz = p->sz;
    8000139e:	04893783          	ld	a5,72(s2)
    800013a2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013a6:	05893683          	ld	a3,88(s2)
    800013aa:	87b6                	mv	a5,a3
    800013ac:	0589b703          	ld	a4,88(s3)
    800013b0:	12068693          	addi	a3,a3,288
    800013b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013b8:	6788                	ld	a0,8(a5)
    800013ba:	6b8c                	ld	a1,16(a5)
    800013bc:	6f90                	ld	a2,24(a5)
    800013be:	01073023          	sd	a6,0(a4)
    800013c2:	e708                	sd	a0,8(a4)
    800013c4:	eb0c                	sd	a1,16(a4)
    800013c6:	ef10                	sd	a2,24(a4)
    800013c8:	02078793          	addi	a5,a5,32
    800013cc:	02070713          	addi	a4,a4,32
    800013d0:	fed792e3          	bne	a5,a3,800013b4 <fork+0x54>
  np->trapframe->a0 = 0;
    800013d4:	0589b783          	ld	a5,88(s3)
    800013d8:	0607b823          	sd	zero,112(a5)
    800013dc:	0d000493          	li	s1,208
  for (i = 0; i < NOFILE; i++)
    800013e0:	15000a13          	li	s4,336
    800013e4:	a03d                	j	80001412 <fork+0xb2>
    freeproc(np);
    800013e6:	854e                	mv	a0,s3
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	d5c080e7          	jalr	-676(ra) # 80001144 <freeproc>
    release(&np->lock);
    800013f0:	854e                	mv	a0,s3
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	f94080e7          	jalr	-108(ra) # 80006386 <release>
    return -1;
    800013fa:	5a7d                	li	s4,-1
    800013fc:	a069                	j	80001486 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800013fe:	00002097          	auipc	ra,0x2
    80001402:	728080e7          	jalr	1832(ra) # 80003b26 <filedup>
    80001406:	009987b3          	add	a5,s3,s1
    8000140a:	e388                	sd	a0,0(a5)
  for (i = 0; i < NOFILE; i++)
    8000140c:	04a1                	addi	s1,s1,8
    8000140e:	01448763          	beq	s1,s4,8000141c <fork+0xbc>
    if (p->ofile[i])
    80001412:	009907b3          	add	a5,s2,s1
    80001416:	6388                	ld	a0,0(a5)
    80001418:	f17d                	bnez	a0,800013fe <fork+0x9e>
    8000141a:	bfcd                	j	8000140c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000141c:	15093503          	ld	a0,336(s2)
    80001420:	00002097          	auipc	ra,0x2
    80001424:	87c080e7          	jalr	-1924(ra) # 80002c9c <idup>
    80001428:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000142c:	4641                	li	a2,16
    8000142e:	15890593          	addi	a1,s2,344
    80001432:	15898513          	addi	a0,s3,344
    80001436:	fffff097          	auipc	ra,0xfffff
    8000143a:	eac080e7          	jalr	-340(ra) # 800002e2 <safestrcpy>
  pid = np->pid;
    8000143e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001442:	854e                	mv	a0,s3
    80001444:	00005097          	auipc	ra,0x5
    80001448:	f42080e7          	jalr	-190(ra) # 80006386 <release>
  acquire(&wait_lock);
    8000144c:	00008497          	auipc	s1,0x8
    80001450:	c1c48493          	addi	s1,s1,-996 # 80009068 <wait_lock>
    80001454:	8526                	mv	a0,s1
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	e7c080e7          	jalr	-388(ra) # 800062d2 <acquire>
  np->parent = p;
    8000145e:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001462:	8526                	mv	a0,s1
    80001464:	00005097          	auipc	ra,0x5
    80001468:	f22080e7          	jalr	-222(ra) # 80006386 <release>
  acquire(&np->lock);
    8000146c:	854e                	mv	a0,s3
    8000146e:	00005097          	auipc	ra,0x5
    80001472:	e64080e7          	jalr	-412(ra) # 800062d2 <acquire>
  np->state = RUNNABLE;
    80001476:	478d                	li	a5,3
    80001478:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000147c:	854e                	mv	a0,s3
    8000147e:	00005097          	auipc	ra,0x5
    80001482:	f08080e7          	jalr	-248(ra) # 80006386 <release>
}
    80001486:	8552                	mv	a0,s4
    80001488:	70a2                	ld	ra,40(sp)
    8000148a:	7402                	ld	s0,32(sp)
    8000148c:	64e2                	ld	s1,24(sp)
    8000148e:	6942                	ld	s2,16(sp)
    80001490:	69a2                	ld	s3,8(sp)
    80001492:	6a02                	ld	s4,0(sp)
    80001494:	6145                	addi	sp,sp,48
    80001496:	8082                	ret
    return -1;
    80001498:	5a7d                	li	s4,-1
    8000149a:	b7f5                	j	80001486 <fork+0x126>

000000008000149c <scheduler>:
{
    8000149c:	7139                	addi	sp,sp,-64
    8000149e:	fc06                	sd	ra,56(sp)
    800014a0:	f822                	sd	s0,48(sp)
    800014a2:	f426                	sd	s1,40(sp)
    800014a4:	f04a                	sd	s2,32(sp)
    800014a6:	ec4e                	sd	s3,24(sp)
    800014a8:	e852                	sd	s4,16(sp)
    800014aa:	e456                	sd	s5,8(sp)
    800014ac:	e05a                	sd	s6,0(sp)
    800014ae:	0080                	addi	s0,sp,64
    800014b0:	8792                	mv	a5,tp
  int id = r_tp();
    800014b2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014b4:	00779a93          	slli	s5,a5,0x7
    800014b8:	00008717          	auipc	a4,0x8
    800014bc:	b9870713          	addi	a4,a4,-1128 # 80009050 <pid_lock>
    800014c0:	9756                	add	a4,a4,s5
    800014c2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014c6:	00008717          	auipc	a4,0x8
    800014ca:	bc270713          	addi	a4,a4,-1086 # 80009088 <cpus+0x8>
    800014ce:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800014d0:	498d                	li	s3,3
        p->state = RUNNING;
    800014d2:	4b11                	li	s6,4
        c->proc = p;
    800014d4:	079e                	slli	a5,a5,0x7
    800014d6:	00008a17          	auipc	s4,0x8
    800014da:	b7aa0a13          	addi	s4,s4,-1158 # 80009050 <pid_lock>
    800014de:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800014e0:	0000e917          	auipc	s2,0xe
    800014e4:	9a090913          	addi	s2,s2,-1632 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus"
    800014e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014ec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    800014f0:	10079073          	csrw	sstatus,a5
    800014f4:	00008497          	auipc	s1,0x8
    800014f8:	f8c48493          	addi	s1,s1,-116 # 80009480 <proc>
    800014fc:	a03d                	j	8000152a <scheduler+0x8e>
        p->state = RUNNING;
    800014fe:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001502:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001506:	06048593          	addi	a1,s1,96
    8000150a:	8556                	mv	a0,s5
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	640080e7          	jalr	1600(ra) # 80001b4c <swtch>
        c->proc = 0;
    80001514:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001518:	8526                	mv	a0,s1
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	e6c080e7          	jalr	-404(ra) # 80006386 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001522:	16848493          	addi	s1,s1,360
    80001526:	fd2481e3          	beq	s1,s2,800014e8 <scheduler+0x4c>
      acquire(&p->lock);
    8000152a:	8526                	mv	a0,s1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	da6080e7          	jalr	-602(ra) # 800062d2 <acquire>
      if (p->state == RUNNABLE)
    80001534:	4c9c                	lw	a5,24(s1)
    80001536:	ff3791e3          	bne	a5,s3,80001518 <scheduler+0x7c>
    8000153a:	b7d1                	j	800014fe <scheduler+0x62>

000000008000153c <sched>:
{
    8000153c:	7179                	addi	sp,sp,-48
    8000153e:	f406                	sd	ra,40(sp)
    80001540:	f022                	sd	s0,32(sp)
    80001542:	ec26                	sd	s1,24(sp)
    80001544:	e84a                	sd	s2,16(sp)
    80001546:	e44e                	sd	s3,8(sp)
    80001548:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	a48080e7          	jalr	-1464(ra) # 80000f92 <myproc>
    80001552:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001554:	00005097          	auipc	ra,0x5
    80001558:	d04080e7          	jalr	-764(ra) # 80006258 <holding>
    8000155c:	c93d                	beqz	a0,800015d2 <sched+0x96>
  asm volatile("mv %0, tp"
    8000155e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001560:	2781                	sext.w	a5,a5
    80001562:	079e                	slli	a5,a5,0x7
    80001564:	00008717          	auipc	a4,0x8
    80001568:	aec70713          	addi	a4,a4,-1300 # 80009050 <pid_lock>
    8000156c:	97ba                	add	a5,a5,a4
    8000156e:	0a87a703          	lw	a4,168(a5)
    80001572:	4785                	li	a5,1
    80001574:	06f71763          	bne	a4,a5,800015e2 <sched+0xa6>
  if (p->state == RUNNING)
    80001578:	4c98                	lw	a4,24(s1)
    8000157a:	4791                	li	a5,4
    8000157c:	06f70b63          	beq	a4,a5,800015f2 <sched+0xb6>
  asm volatile("csrr %0, sstatus"
    80001580:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001584:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001586:	efb5                	bnez	a5,80001602 <sched+0xc6>
  asm volatile("mv %0, tp"
    80001588:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000158a:	00008917          	auipc	s2,0x8
    8000158e:	ac690913          	addi	s2,s2,-1338 # 80009050 <pid_lock>
    80001592:	2781                	sext.w	a5,a5
    80001594:	079e                	slli	a5,a5,0x7
    80001596:	97ca                	add	a5,a5,s2
    80001598:	0ac7a983          	lw	s3,172(a5)
    8000159c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000159e:	2781                	sext.w	a5,a5
    800015a0:	079e                	slli	a5,a5,0x7
    800015a2:	00008597          	auipc	a1,0x8
    800015a6:	ae658593          	addi	a1,a1,-1306 # 80009088 <cpus+0x8>
    800015aa:	95be                	add	a1,a1,a5
    800015ac:	06048513          	addi	a0,s1,96
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	59c080e7          	jalr	1436(ra) # 80001b4c <swtch>
    800015b8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015ba:	2781                	sext.w	a5,a5
    800015bc:	079e                	slli	a5,a5,0x7
    800015be:	97ca                	add	a5,a5,s2
    800015c0:	0b37a623          	sw	s3,172(a5)
}
    800015c4:	70a2                	ld	ra,40(sp)
    800015c6:	7402                	ld	s0,32(sp)
    800015c8:	64e2                	ld	s1,24(sp)
    800015ca:	6942                	ld	s2,16(sp)
    800015cc:	69a2                	ld	s3,8(sp)
    800015ce:	6145                	addi	sp,sp,48
    800015d0:	8082                	ret
    panic("sched p->lock");
    800015d2:	00007517          	auipc	a0,0x7
    800015d6:	bee50513          	addi	a0,a0,-1042 # 800081c0 <etext+0x1c0>
    800015da:	00004097          	auipc	ra,0x4
    800015de:	7ae080e7          	jalr	1966(ra) # 80005d88 <panic>
    panic("sched locks");
    800015e2:	00007517          	auipc	a0,0x7
    800015e6:	bee50513          	addi	a0,a0,-1042 # 800081d0 <etext+0x1d0>
    800015ea:	00004097          	auipc	ra,0x4
    800015ee:	79e080e7          	jalr	1950(ra) # 80005d88 <panic>
    panic("sched running");
    800015f2:	00007517          	auipc	a0,0x7
    800015f6:	bee50513          	addi	a0,a0,-1042 # 800081e0 <etext+0x1e0>
    800015fa:	00004097          	auipc	ra,0x4
    800015fe:	78e080e7          	jalr	1934(ra) # 80005d88 <panic>
    panic("sched interruptible");
    80001602:	00007517          	auipc	a0,0x7
    80001606:	bee50513          	addi	a0,a0,-1042 # 800081f0 <etext+0x1f0>
    8000160a:	00004097          	auipc	ra,0x4
    8000160e:	77e080e7          	jalr	1918(ra) # 80005d88 <panic>

0000000080001612 <yield>:
{
    80001612:	1101                	addi	sp,sp,-32
    80001614:	ec06                	sd	ra,24(sp)
    80001616:	e822                	sd	s0,16(sp)
    80001618:	e426                	sd	s1,8(sp)
    8000161a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	976080e7          	jalr	-1674(ra) # 80000f92 <myproc>
    80001624:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	cac080e7          	jalr	-852(ra) # 800062d2 <acquire>
  p->state = RUNNABLE;
    8000162e:	478d                	li	a5,3
    80001630:	cc9c                	sw	a5,24(s1)
  sched();
    80001632:	00000097          	auipc	ra,0x0
    80001636:	f0a080e7          	jalr	-246(ra) # 8000153c <sched>
  release(&p->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	d4a080e7          	jalr	-694(ra) # 80006386 <release>
}
    80001644:	60e2                	ld	ra,24(sp)
    80001646:	6442                	ld	s0,16(sp)
    80001648:	64a2                	ld	s1,8(sp)
    8000164a:	6105                	addi	sp,sp,32
    8000164c:	8082                	ret

000000008000164e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000164e:	7179                	addi	sp,sp,-48
    80001650:	f406                	sd	ra,40(sp)
    80001652:	f022                	sd	s0,32(sp)
    80001654:	ec26                	sd	s1,24(sp)
    80001656:	e84a                	sd	s2,16(sp)
    80001658:	e44e                	sd	s3,8(sp)
    8000165a:	1800                	addi	s0,sp,48
    8000165c:	89aa                	mv	s3,a0
    8000165e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001660:	00000097          	auipc	ra,0x0
    80001664:	932080e7          	jalr	-1742(ra) # 80000f92 <myproc>
    80001668:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	c68080e7          	jalr	-920(ra) # 800062d2 <acquire>
  release(lk);
    80001672:	854a                	mv	a0,s2
    80001674:	00005097          	auipc	ra,0x5
    80001678:	d12080e7          	jalr	-750(ra) # 80006386 <release>

  // Go to sleep.
  p->chan = chan;
    8000167c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001680:	4789                	li	a5,2
    80001682:	cc9c                	sw	a5,24(s1)

  sched();
    80001684:	00000097          	auipc	ra,0x0
    80001688:	eb8080e7          	jalr	-328(ra) # 8000153c <sched>

  // Tidy up.
  p->chan = 0;
    8000168c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001690:	8526                	mv	a0,s1
    80001692:	00005097          	auipc	ra,0x5
    80001696:	cf4080e7          	jalr	-780(ra) # 80006386 <release>
  acquire(lk);
    8000169a:	854a                	mv	a0,s2
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	c36080e7          	jalr	-970(ra) # 800062d2 <acquire>
}
    800016a4:	70a2                	ld	ra,40(sp)
    800016a6:	7402                	ld	s0,32(sp)
    800016a8:	64e2                	ld	s1,24(sp)
    800016aa:	6942                	ld	s2,16(sp)
    800016ac:	69a2                	ld	s3,8(sp)
    800016ae:	6145                	addi	sp,sp,48
    800016b0:	8082                	ret

00000000800016b2 <wait>:
{
    800016b2:	715d                	addi	sp,sp,-80
    800016b4:	e486                	sd	ra,72(sp)
    800016b6:	e0a2                	sd	s0,64(sp)
    800016b8:	fc26                	sd	s1,56(sp)
    800016ba:	f84a                	sd	s2,48(sp)
    800016bc:	f44e                	sd	s3,40(sp)
    800016be:	f052                	sd	s4,32(sp)
    800016c0:	ec56                	sd	s5,24(sp)
    800016c2:	e85a                	sd	s6,16(sp)
    800016c4:	e45e                	sd	s7,8(sp)
    800016c6:	e062                	sd	s8,0(sp)
    800016c8:	0880                	addi	s0,sp,80
    800016ca:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016cc:	00000097          	auipc	ra,0x0
    800016d0:	8c6080e7          	jalr	-1850(ra) # 80000f92 <myproc>
    800016d4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016d6:	00008517          	auipc	a0,0x8
    800016da:	99250513          	addi	a0,a0,-1646 # 80009068 <wait_lock>
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	bf4080e7          	jalr	-1036(ra) # 800062d2 <acquire>
    havekids = 0;
    800016e6:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    800016e8:	4a15                	li	s4,5
    for (np = proc; np < &proc[NPROC]; np++)
    800016ea:	0000d997          	auipc	s3,0xd
    800016ee:	79698993          	addi	s3,s3,1942 # 8000ee80 <tickslock>
        havekids = 1;
    800016f2:	4a85                	li	s5,1
    sleep(p, &wait_lock); // DOC: wait-sleep
    800016f4:	00008c17          	auipc	s8,0x8
    800016f8:	974c0c13          	addi	s8,s8,-1676 # 80009068 <wait_lock>
    havekids = 0;
    800016fc:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    800016fe:	00008497          	auipc	s1,0x8
    80001702:	d8248493          	addi	s1,s1,-638 # 80009480 <proc>
    80001706:	a0bd                	j	80001774 <wait+0xc2>
          pid = np->pid;
    80001708:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000170c:	000b0e63          	beqz	s6,80001728 <wait+0x76>
    80001710:	4691                	li	a3,4
    80001712:	02c48613          	addi	a2,s1,44
    80001716:	85da                	mv	a1,s6
    80001718:	05093503          	ld	a0,80(s2)
    8000171c:	fffff097          	auipc	ra,0xfffff
    80001720:	45c080e7          	jalr	1116(ra) # 80000b78 <copyout>
    80001724:	02054563          	bltz	a0,8000174e <wait+0x9c>
          freeproc(np);
    80001728:	8526                	mv	a0,s1
    8000172a:	00000097          	auipc	ra,0x0
    8000172e:	a1a080e7          	jalr	-1510(ra) # 80001144 <freeproc>
          release(&np->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	c52080e7          	jalr	-942(ra) # 80006386 <release>
          release(&wait_lock);
    8000173c:	00008517          	auipc	a0,0x8
    80001740:	92c50513          	addi	a0,a0,-1748 # 80009068 <wait_lock>
    80001744:	00005097          	auipc	ra,0x5
    80001748:	c42080e7          	jalr	-958(ra) # 80006386 <release>
          return pid;
    8000174c:	a09d                	j	800017b2 <wait+0x100>
            release(&np->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	c36080e7          	jalr	-970(ra) # 80006386 <release>
            release(&wait_lock);
    80001758:	00008517          	auipc	a0,0x8
    8000175c:	91050513          	addi	a0,a0,-1776 # 80009068 <wait_lock>
    80001760:	00005097          	auipc	ra,0x5
    80001764:	c26080e7          	jalr	-986(ra) # 80006386 <release>
            return -1;
    80001768:	59fd                	li	s3,-1
    8000176a:	a0a1                	j	800017b2 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++)
    8000176c:	16848493          	addi	s1,s1,360
    80001770:	03348463          	beq	s1,s3,80001798 <wait+0xe6>
      if (np->parent == p)
    80001774:	7c9c                	ld	a5,56(s1)
    80001776:	ff279be3          	bne	a5,s2,8000176c <wait+0xba>
        acquire(&np->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	b56080e7          	jalr	-1194(ra) # 800062d2 <acquire>
        if (np->state == ZOMBIE)
    80001784:	4c9c                	lw	a5,24(s1)
    80001786:	f94781e3          	beq	a5,s4,80001708 <wait+0x56>
        release(&np->lock);
    8000178a:	8526                	mv	a0,s1
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	bfa080e7          	jalr	-1030(ra) # 80006386 <release>
        havekids = 1;
    80001794:	8756                	mv	a4,s5
    80001796:	bfd9                	j	8000176c <wait+0xba>
    if (!havekids || p->killed)
    80001798:	c701                	beqz	a4,800017a0 <wait+0xee>
    8000179a:	02892783          	lw	a5,40(s2)
    8000179e:	c79d                	beqz	a5,800017cc <wait+0x11a>
      release(&wait_lock);
    800017a0:	00008517          	auipc	a0,0x8
    800017a4:	8c850513          	addi	a0,a0,-1848 # 80009068 <wait_lock>
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	bde080e7          	jalr	-1058(ra) # 80006386 <release>
      return -1;
    800017b0:	59fd                	li	s3,-1
}
    800017b2:	854e                	mv	a0,s3
    800017b4:	60a6                	ld	ra,72(sp)
    800017b6:	6406                	ld	s0,64(sp)
    800017b8:	74e2                	ld	s1,56(sp)
    800017ba:	7942                	ld	s2,48(sp)
    800017bc:	79a2                	ld	s3,40(sp)
    800017be:	7a02                	ld	s4,32(sp)
    800017c0:	6ae2                	ld	s5,24(sp)
    800017c2:	6b42                	ld	s6,16(sp)
    800017c4:	6ba2                	ld	s7,8(sp)
    800017c6:	6c02                	ld	s8,0(sp)
    800017c8:	6161                	addi	sp,sp,80
    800017ca:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800017cc:	85e2                	mv	a1,s8
    800017ce:	854a                	mv	a0,s2
    800017d0:	00000097          	auipc	ra,0x0
    800017d4:	e7e080e7          	jalr	-386(ra) # 8000164e <sleep>
    havekids = 0;
    800017d8:	b715                	j	800016fc <wait+0x4a>

00000000800017da <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800017da:	7139                	addi	sp,sp,-64
    800017dc:	fc06                	sd	ra,56(sp)
    800017de:	f822                	sd	s0,48(sp)
    800017e0:	f426                	sd	s1,40(sp)
    800017e2:	f04a                	sd	s2,32(sp)
    800017e4:	ec4e                	sd	s3,24(sp)
    800017e6:	e852                	sd	s4,16(sp)
    800017e8:	e456                	sd	s5,8(sp)
    800017ea:	0080                	addi	s0,sp,64
    800017ec:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800017ee:	00008497          	auipc	s1,0x8
    800017f2:	c9248493          	addi	s1,s1,-878 # 80009480 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    800017f6:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800017f8:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800017fa:	0000d917          	auipc	s2,0xd
    800017fe:	68690913          	addi	s2,s2,1670 # 8000ee80 <tickslock>
    80001802:	a821                	j	8000181a <wakeup+0x40>
        p->state = RUNNABLE;
    80001804:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001808:	8526                	mv	a0,s1
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	b7c080e7          	jalr	-1156(ra) # 80006386 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001812:	16848493          	addi	s1,s1,360
    80001816:	03248463          	beq	s1,s2,8000183e <wakeup+0x64>
    if (p != myproc())
    8000181a:	fffff097          	auipc	ra,0xfffff
    8000181e:	778080e7          	jalr	1912(ra) # 80000f92 <myproc>
    80001822:	fea488e3          	beq	s1,a0,80001812 <wakeup+0x38>
      acquire(&p->lock);
    80001826:	8526                	mv	a0,s1
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	aaa080e7          	jalr	-1366(ra) # 800062d2 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80001830:	4c9c                	lw	a5,24(s1)
    80001832:	fd379be3          	bne	a5,s3,80001808 <wakeup+0x2e>
    80001836:	709c                	ld	a5,32(s1)
    80001838:	fd4798e3          	bne	a5,s4,80001808 <wakeup+0x2e>
    8000183c:	b7e1                	j	80001804 <wakeup+0x2a>
    }
  }
}
    8000183e:	70e2                	ld	ra,56(sp)
    80001840:	7442                	ld	s0,48(sp)
    80001842:	74a2                	ld	s1,40(sp)
    80001844:	7902                	ld	s2,32(sp)
    80001846:	69e2                	ld	s3,24(sp)
    80001848:	6a42                	ld	s4,16(sp)
    8000184a:	6aa2                	ld	s5,8(sp)
    8000184c:	6121                	addi	sp,sp,64
    8000184e:	8082                	ret

0000000080001850 <reparent>:
{
    80001850:	7179                	addi	sp,sp,-48
    80001852:	f406                	sd	ra,40(sp)
    80001854:	f022                	sd	s0,32(sp)
    80001856:	ec26                	sd	s1,24(sp)
    80001858:	e84a                	sd	s2,16(sp)
    8000185a:	e44e                	sd	s3,8(sp)
    8000185c:	e052                	sd	s4,0(sp)
    8000185e:	1800                	addi	s0,sp,48
    80001860:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001862:	00008497          	auipc	s1,0x8
    80001866:	c1e48493          	addi	s1,s1,-994 # 80009480 <proc>
      pp->parent = initproc;
    8000186a:	00007a17          	auipc	s4,0x7
    8000186e:	7a6a0a13          	addi	s4,s4,1958 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001872:	0000d997          	auipc	s3,0xd
    80001876:	60e98993          	addi	s3,s3,1550 # 8000ee80 <tickslock>
    8000187a:	a029                	j	80001884 <reparent+0x34>
    8000187c:	16848493          	addi	s1,s1,360
    80001880:	01348d63          	beq	s1,s3,8000189a <reparent+0x4a>
    if (pp->parent == p)
    80001884:	7c9c                	ld	a5,56(s1)
    80001886:	ff279be3          	bne	a5,s2,8000187c <reparent+0x2c>
      pp->parent = initproc;
    8000188a:	000a3503          	ld	a0,0(s4)
    8000188e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001890:	00000097          	auipc	ra,0x0
    80001894:	f4a080e7          	jalr	-182(ra) # 800017da <wakeup>
    80001898:	b7d5                	j	8000187c <reparent+0x2c>
}
    8000189a:	70a2                	ld	ra,40(sp)
    8000189c:	7402                	ld	s0,32(sp)
    8000189e:	64e2                	ld	s1,24(sp)
    800018a0:	6942                	ld	s2,16(sp)
    800018a2:	69a2                	ld	s3,8(sp)
    800018a4:	6a02                	ld	s4,0(sp)
    800018a6:	6145                	addi	sp,sp,48
    800018a8:	8082                	ret

00000000800018aa <exit>:
{
    800018aa:	7179                	addi	sp,sp,-48
    800018ac:	f406                	sd	ra,40(sp)
    800018ae:	f022                	sd	s0,32(sp)
    800018b0:	ec26                	sd	s1,24(sp)
    800018b2:	e84a                	sd	s2,16(sp)
    800018b4:	e44e                	sd	s3,8(sp)
    800018b6:	e052                	sd	s4,0(sp)
    800018b8:	1800                	addi	s0,sp,48
    800018ba:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018bc:	fffff097          	auipc	ra,0xfffff
    800018c0:	6d6080e7          	jalr	1750(ra) # 80000f92 <myproc>
    800018c4:	89aa                	mv	s3,a0
  if (p == initproc)
    800018c6:	00007797          	auipc	a5,0x7
    800018ca:	74a7b783          	ld	a5,1866(a5) # 80009010 <initproc>
    800018ce:	0d050493          	addi	s1,a0,208
    800018d2:	15050913          	addi	s2,a0,336
    800018d6:	02a79363          	bne	a5,a0,800018fc <exit+0x52>
    panic("init exiting");
    800018da:	00007517          	auipc	a0,0x7
    800018de:	92e50513          	addi	a0,a0,-1746 # 80008208 <etext+0x208>
    800018e2:	00004097          	auipc	ra,0x4
    800018e6:	4a6080e7          	jalr	1190(ra) # 80005d88 <panic>
      fileclose(f);
    800018ea:	00002097          	auipc	ra,0x2
    800018ee:	28e080e7          	jalr	654(ra) # 80003b78 <fileclose>
      p->ofile[fd] = 0;
    800018f2:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    800018f6:	04a1                	addi	s1,s1,8
    800018f8:	01248563          	beq	s1,s2,80001902 <exit+0x58>
    if (p->ofile[fd])
    800018fc:	6088                	ld	a0,0(s1)
    800018fe:	f575                	bnez	a0,800018ea <exit+0x40>
    80001900:	bfdd                	j	800018f6 <exit+0x4c>
  begin_op();
    80001902:	00002097          	auipc	ra,0x2
    80001906:	daa080e7          	jalr	-598(ra) # 800036ac <begin_op>
  iput(p->cwd);
    8000190a:	1509b503          	ld	a0,336(s3)
    8000190e:	00001097          	auipc	ra,0x1
    80001912:	586080e7          	jalr	1414(ra) # 80002e94 <iput>
  end_op();
    80001916:	00002097          	auipc	ra,0x2
    8000191a:	e16080e7          	jalr	-490(ra) # 8000372c <end_op>
  p->cwd = 0;
    8000191e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001922:	00007497          	auipc	s1,0x7
    80001926:	74648493          	addi	s1,s1,1862 # 80009068 <wait_lock>
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	9a6080e7          	jalr	-1626(ra) # 800062d2 <acquire>
  reparent(p);
    80001934:	854e                	mv	a0,s3
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	f1a080e7          	jalr	-230(ra) # 80001850 <reparent>
  wakeup(p->parent);
    8000193e:	0389b503          	ld	a0,56(s3)
    80001942:	00000097          	auipc	ra,0x0
    80001946:	e98080e7          	jalr	-360(ra) # 800017da <wakeup>
  acquire(&p->lock);
    8000194a:	854e                	mv	a0,s3
    8000194c:	00005097          	auipc	ra,0x5
    80001950:	986080e7          	jalr	-1658(ra) # 800062d2 <acquire>
  p->xstate = status;
    80001954:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001958:	4795                	li	a5,5
    8000195a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000195e:	8526                	mv	a0,s1
    80001960:	00005097          	auipc	ra,0x5
    80001964:	a26080e7          	jalr	-1498(ra) # 80006386 <release>
  sched();
    80001968:	00000097          	auipc	ra,0x0
    8000196c:	bd4080e7          	jalr	-1068(ra) # 8000153c <sched>
  panic("zombie exit");
    80001970:	00007517          	auipc	a0,0x7
    80001974:	8a850513          	addi	a0,a0,-1880 # 80008218 <etext+0x218>
    80001978:	00004097          	auipc	ra,0x4
    8000197c:	410080e7          	jalr	1040(ra) # 80005d88 <panic>

0000000080001980 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001980:	7179                	addi	sp,sp,-48
    80001982:	f406                	sd	ra,40(sp)
    80001984:	f022                	sd	s0,32(sp)
    80001986:	ec26                	sd	s1,24(sp)
    80001988:	e84a                	sd	s2,16(sp)
    8000198a:	e44e                	sd	s3,8(sp)
    8000198c:	1800                	addi	s0,sp,48
    8000198e:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001990:	00008497          	auipc	s1,0x8
    80001994:	af048493          	addi	s1,s1,-1296 # 80009480 <proc>
    80001998:	0000d997          	auipc	s3,0xd
    8000199c:	4e898993          	addi	s3,s3,1256 # 8000ee80 <tickslock>
  {
    acquire(&p->lock);
    800019a0:	8526                	mv	a0,s1
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	930080e7          	jalr	-1744(ra) # 800062d2 <acquire>
    if (p->pid == pid)
    800019aa:	589c                	lw	a5,48(s1)
    800019ac:	01278d63          	beq	a5,s2,800019c6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019b0:	8526                	mv	a0,s1
    800019b2:	00005097          	auipc	ra,0x5
    800019b6:	9d4080e7          	jalr	-1580(ra) # 80006386 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800019ba:	16848493          	addi	s1,s1,360
    800019be:	ff3491e3          	bne	s1,s3,800019a0 <kill+0x20>
  }
  return -1;
    800019c2:	557d                	li	a0,-1
    800019c4:	a829                	j	800019de <kill+0x5e>
      p->killed = 1;
    800019c6:	4785                	li	a5,1
    800019c8:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800019ca:	4c98                	lw	a4,24(s1)
    800019cc:	4789                	li	a5,2
    800019ce:	00f70f63          	beq	a4,a5,800019ec <kill+0x6c>
      release(&p->lock);
    800019d2:	8526                	mv	a0,s1
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	9b2080e7          	jalr	-1614(ra) # 80006386 <release>
      return 0;
    800019dc:	4501                	li	a0,0
}
    800019de:	70a2                	ld	ra,40(sp)
    800019e0:	7402                	ld	s0,32(sp)
    800019e2:	64e2                	ld	s1,24(sp)
    800019e4:	6942                	ld	s2,16(sp)
    800019e6:	69a2                	ld	s3,8(sp)
    800019e8:	6145                	addi	sp,sp,48
    800019ea:	8082                	ret
        p->state = RUNNABLE;
    800019ec:	478d                	li	a5,3
    800019ee:	cc9c                	sw	a5,24(s1)
    800019f0:	b7cd                	j	800019d2 <kill+0x52>

00000000800019f2 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019f2:	7179                	addi	sp,sp,-48
    800019f4:	f406                	sd	ra,40(sp)
    800019f6:	f022                	sd	s0,32(sp)
    800019f8:	ec26                	sd	s1,24(sp)
    800019fa:	e84a                	sd	s2,16(sp)
    800019fc:	e44e                	sd	s3,8(sp)
    800019fe:	e052                	sd	s4,0(sp)
    80001a00:	1800                	addi	s0,sp,48
    80001a02:	84aa                	mv	s1,a0
    80001a04:	892e                	mv	s2,a1
    80001a06:	89b2                	mv	s3,a2
    80001a08:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a0a:	fffff097          	auipc	ra,0xfffff
    80001a0e:	588080e7          	jalr	1416(ra) # 80000f92 <myproc>
  if (user_dst)
    80001a12:	c08d                	beqz	s1,80001a34 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80001a14:	86d2                	mv	a3,s4
    80001a16:	864e                	mv	a2,s3
    80001a18:	85ca                	mv	a1,s2
    80001a1a:	6928                	ld	a0,80(a0)
    80001a1c:	fffff097          	auipc	ra,0xfffff
    80001a20:	15c080e7          	jalr	348(ra) # 80000b78 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a24:	70a2                	ld	ra,40(sp)
    80001a26:	7402                	ld	s0,32(sp)
    80001a28:	64e2                	ld	s1,24(sp)
    80001a2a:	6942                	ld	s2,16(sp)
    80001a2c:	69a2                	ld	s3,8(sp)
    80001a2e:	6a02                	ld	s4,0(sp)
    80001a30:	6145                	addi	sp,sp,48
    80001a32:	8082                	ret
    memmove((char *)dst, src, len);
    80001a34:	000a061b          	sext.w	a2,s4
    80001a38:	85ce                	mv	a1,s3
    80001a3a:	854a                	mv	a0,s2
    80001a3c:	ffffe097          	auipc	ra,0xffffe
    80001a40:	7b4080e7          	jalr	1972(ra) # 800001f0 <memmove>
    return 0;
    80001a44:	8526                	mv	a0,s1
    80001a46:	bff9                	j	80001a24 <either_copyout+0x32>

0000000080001a48 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a48:	7179                	addi	sp,sp,-48
    80001a4a:	f406                	sd	ra,40(sp)
    80001a4c:	f022                	sd	s0,32(sp)
    80001a4e:	ec26                	sd	s1,24(sp)
    80001a50:	e84a                	sd	s2,16(sp)
    80001a52:	e44e                	sd	s3,8(sp)
    80001a54:	e052                	sd	s4,0(sp)
    80001a56:	1800                	addi	s0,sp,48
    80001a58:	892a                	mv	s2,a0
    80001a5a:	84ae                	mv	s1,a1
    80001a5c:	89b2                	mv	s3,a2
    80001a5e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	532080e7          	jalr	1330(ra) # 80000f92 <myproc>
  if (user_src)
    80001a68:	c08d                	beqz	s1,80001a8a <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80001a6a:	86d2                	mv	a3,s4
    80001a6c:	864e                	mv	a2,s3
    80001a6e:	85ca                	mv	a1,s2
    80001a70:	6928                	ld	a0,80(a0)
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	26e080e7          	jalr	622(ra) # 80000ce0 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001a7a:	70a2                	ld	ra,40(sp)
    80001a7c:	7402                	ld	s0,32(sp)
    80001a7e:	64e2                	ld	s1,24(sp)
    80001a80:	6942                	ld	s2,16(sp)
    80001a82:	69a2                	ld	s3,8(sp)
    80001a84:	6a02                	ld	s4,0(sp)
    80001a86:	6145                	addi	sp,sp,48
    80001a88:	8082                	ret
    memmove(dst, (char *)src, len);
    80001a8a:	000a061b          	sext.w	a2,s4
    80001a8e:	85ce                	mv	a1,s3
    80001a90:	854a                	mv	a0,s2
    80001a92:	ffffe097          	auipc	ra,0xffffe
    80001a96:	75e080e7          	jalr	1886(ra) # 800001f0 <memmove>
    return 0;
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	bff9                	j	80001a7a <either_copyin+0x32>

0000000080001a9e <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001a9e:	715d                	addi	sp,sp,-80
    80001aa0:	e486                	sd	ra,72(sp)
    80001aa2:	e0a2                	sd	s0,64(sp)
    80001aa4:	fc26                	sd	s1,56(sp)
    80001aa6:	f84a                	sd	s2,48(sp)
    80001aa8:	f44e                	sd	s3,40(sp)
    80001aaa:	f052                	sd	s4,32(sp)
    80001aac:	ec56                	sd	s5,24(sp)
    80001aae:	e85a                	sd	s6,16(sp)
    80001ab0:	e45e                	sd	s7,8(sp)
    80001ab2:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001ab4:	00006517          	auipc	a0,0x6
    80001ab8:	59450513          	addi	a0,a0,1428 # 80008048 <etext+0x48>
    80001abc:	00004097          	auipc	ra,0x4
    80001ac0:	316080e7          	jalr	790(ra) # 80005dd2 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ac4:	00008497          	auipc	s1,0x8
    80001ac8:	b1448493          	addi	s1,s1,-1260 # 800095d8 <proc+0x158>
    80001acc:	0000d917          	auipc	s2,0xd
    80001ad0:	50c90913          	addi	s2,s2,1292 # 8000efd8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ad6:	00006997          	auipc	s3,0x6
    80001ada:	75298993          	addi	s3,s3,1874 # 80008228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80001ade:	00006a97          	auipc	s5,0x6
    80001ae2:	752a8a93          	addi	s5,s5,1874 # 80008230 <etext+0x230>
    printf("\n");
    80001ae6:	00006a17          	auipc	s4,0x6
    80001aea:	562a0a13          	addi	s4,s4,1378 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aee:	00006b97          	auipc	s7,0x6
    80001af2:	77ab8b93          	addi	s7,s7,1914 # 80008268 <states.1713>
    80001af6:	a00d                	j	80001b18 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001af8:	ed86a583          	lw	a1,-296(a3)
    80001afc:	8556                	mv	a0,s5
    80001afe:	00004097          	auipc	ra,0x4
    80001b02:	2d4080e7          	jalr	724(ra) # 80005dd2 <printf>
    printf("\n");
    80001b06:	8552                	mv	a0,s4
    80001b08:	00004097          	auipc	ra,0x4
    80001b0c:	2ca080e7          	jalr	714(ra) # 80005dd2 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b10:	16848493          	addi	s1,s1,360
    80001b14:	03248163          	beq	s1,s2,80001b36 <procdump+0x98>
    if (p->state == UNUSED)
    80001b18:	86a6                	mv	a3,s1
    80001b1a:	ec04a783          	lw	a5,-320(s1)
    80001b1e:	dbed                	beqz	a5,80001b10 <procdump+0x72>
      state = "???";
    80001b20:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b22:	fcfb6be3          	bltu	s6,a5,80001af8 <procdump+0x5a>
    80001b26:	1782                	slli	a5,a5,0x20
    80001b28:	9381                	srli	a5,a5,0x20
    80001b2a:	078e                	slli	a5,a5,0x3
    80001b2c:	97de                	add	a5,a5,s7
    80001b2e:	6390                	ld	a2,0(a5)
    80001b30:	f661                	bnez	a2,80001af8 <procdump+0x5a>
      state = "???";
    80001b32:	864e                	mv	a2,s3
    80001b34:	b7d1                	j	80001af8 <procdump+0x5a>
  }
}
    80001b36:	60a6                	ld	ra,72(sp)
    80001b38:	6406                	ld	s0,64(sp)
    80001b3a:	74e2                	ld	s1,56(sp)
    80001b3c:	7942                	ld	s2,48(sp)
    80001b3e:	79a2                	ld	s3,40(sp)
    80001b40:	7a02                	ld	s4,32(sp)
    80001b42:	6ae2                	ld	s5,24(sp)
    80001b44:	6b42                	ld	s6,16(sp)
    80001b46:	6ba2                	ld	s7,8(sp)
    80001b48:	6161                	addi	sp,sp,80
    80001b4a:	8082                	ret

0000000080001b4c <swtch>:
    80001b4c:	00153023          	sd	ra,0(a0)
    80001b50:	00253423          	sd	sp,8(a0)
    80001b54:	e900                	sd	s0,16(a0)
    80001b56:	ed04                	sd	s1,24(a0)
    80001b58:	03253023          	sd	s2,32(a0)
    80001b5c:	03353423          	sd	s3,40(a0)
    80001b60:	03453823          	sd	s4,48(a0)
    80001b64:	03553c23          	sd	s5,56(a0)
    80001b68:	05653023          	sd	s6,64(a0)
    80001b6c:	05753423          	sd	s7,72(a0)
    80001b70:	05853823          	sd	s8,80(a0)
    80001b74:	05953c23          	sd	s9,88(a0)
    80001b78:	07a53023          	sd	s10,96(a0)
    80001b7c:	07b53423          	sd	s11,104(a0)
    80001b80:	0005b083          	ld	ra,0(a1)
    80001b84:	0085b103          	ld	sp,8(a1)
    80001b88:	6980                	ld	s0,16(a1)
    80001b8a:	6d84                	ld	s1,24(a1)
    80001b8c:	0205b903          	ld	s2,32(a1)
    80001b90:	0285b983          	ld	s3,40(a1)
    80001b94:	0305ba03          	ld	s4,48(a1)
    80001b98:	0385ba83          	ld	s5,56(a1)
    80001b9c:	0405bb03          	ld	s6,64(a1)
    80001ba0:	0485bb83          	ld	s7,72(a1)
    80001ba4:	0505bc03          	ld	s8,80(a1)
    80001ba8:	0585bc83          	ld	s9,88(a1)
    80001bac:	0605bd03          	ld	s10,96(a1)
    80001bb0:	0685bd83          	ld	s11,104(a1)
    80001bb4:	8082                	ret

0000000080001bb6 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001bb6:	1141                	addi	sp,sp,-16
    80001bb8:	e406                	sd	ra,8(sp)
    80001bba:	e022                	sd	s0,0(sp)
    80001bbc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bbe:	00006597          	auipc	a1,0x6
    80001bc2:	6da58593          	addi	a1,a1,1754 # 80008298 <states.1713+0x30>
    80001bc6:	0000d517          	auipc	a0,0xd
    80001bca:	2ba50513          	addi	a0,a0,698 # 8000ee80 <tickslock>
    80001bce:	00004097          	auipc	ra,0x4
    80001bd2:	674080e7          	jalr	1652(ra) # 80006242 <initlock>
}
    80001bd6:	60a2                	ld	ra,8(sp)
    80001bd8:	6402                	ld	s0,0(sp)
    80001bda:	0141                	addi	sp,sp,16
    80001bdc:	8082                	ret

0000000080001bde <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001bde:	1141                	addi	sp,sp,-16
    80001be0:	e422                	sd	s0,8(sp)
    80001be2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0"
    80001be4:	00003797          	auipc	a5,0x3
    80001be8:	5ac78793          	addi	a5,a5,1452 # 80005190 <kernelvec>
    80001bec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bf0:	6422                	ld	s0,8(sp)
    80001bf2:	0141                	addi	sp,sp,16
    80001bf4:	8082                	ret

0000000080001bf6 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001bf6:	1141                	addi	sp,sp,-16
    80001bf8:	e406                	sd	ra,8(sp)
    80001bfa:	e022                	sd	s0,0(sp)
    80001bfc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	394080e7          	jalr	916(ra) # 80000f92 <myproc>
  asm volatile("csrr %0, sstatus"
    80001c06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c0a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80001c0c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c10:	00005617          	auipc	a2,0x5
    80001c14:	3f060613          	addi	a2,a2,1008 # 80007000 <_trampoline>
    80001c18:	00005697          	auipc	a3,0x5
    80001c1c:	3e868693          	addi	a3,a3,1000 # 80007000 <_trampoline>
    80001c20:	8e91                	sub	a3,a3,a2
    80001c22:	040007b7          	lui	a5,0x4000
    80001c26:	17fd                	addi	a5,a5,-1
    80001c28:	07b2                	slli	a5,a5,0xc
    80001c2a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0"
    80001c2c:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c30:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp"
    80001c32:	180026f3          	csrr	a3,satp
    80001c36:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c38:	6d38                	ld	a4,88(a0)
    80001c3a:	6134                	ld	a3,64(a0)
    80001c3c:	6585                	lui	a1,0x1
    80001c3e:	96ae                	add	a3,a3,a1
    80001c40:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c42:	6d38                	ld	a4,88(a0)
    80001c44:	00000697          	auipc	a3,0x0
    80001c48:	13868693          	addi	a3,a3,312 # 80001d7c <usertrap>
    80001c4c:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001c4e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp"
    80001c50:	8692                	mv	a3,tp
    80001c52:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus"
    80001c54:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c58:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c5c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0"
    80001c60:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c64:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0"
    80001c66:	6f18                	ld	a4,24(a4)
    80001c68:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c6c:	692c                	ld	a1,80(a0)
    80001c6e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c70:	00005717          	auipc	a4,0x5
    80001c74:	42070713          	addi	a4,a4,1056 # 80007090 <userret>
    80001c78:	8f11                	sub	a4,a4,a2
    80001c7a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001c7c:	577d                	li	a4,-1
    80001c7e:	177e                	slli	a4,a4,0x3f
    80001c80:	8dd9                	or	a1,a1,a4
    80001c82:	02000537          	lui	a0,0x2000
    80001c86:	157d                	addi	a0,a0,-1
    80001c88:	0536                	slli	a0,a0,0xd
    80001c8a:	9782                	jalr	a5
}
    80001c8c:	60a2                	ld	ra,8(sp)
    80001c8e:	6402                	ld	s0,0(sp)
    80001c90:	0141                	addi	sp,sp,16
    80001c92:	8082                	ret

0000000080001c94 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c9e:	0000d497          	auipc	s1,0xd
    80001ca2:	1e248493          	addi	s1,s1,482 # 8000ee80 <tickslock>
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	62a080e7          	jalr	1578(ra) # 800062d2 <acquire>
  ticks++;
    80001cb0:	00007517          	auipc	a0,0x7
    80001cb4:	36850513          	addi	a0,a0,872 # 80009018 <ticks>
    80001cb8:	411c                	lw	a5,0(a0)
    80001cba:	2785                	addiw	a5,a5,1
    80001cbc:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cbe:	00000097          	auipc	ra,0x0
    80001cc2:	b1c080e7          	jalr	-1252(ra) # 800017da <wakeup>
  release(&tickslock);
    80001cc6:	8526                	mv	a0,s1
    80001cc8:	00004097          	auipc	ra,0x4
    80001ccc:	6be080e7          	jalr	1726(ra) # 80006386 <release>
}
    80001cd0:	60e2                	ld	ra,24(sp)
    80001cd2:	6442                	ld	s0,16(sp)
    80001cd4:	64a2                	ld	s1,8(sp)
    80001cd6:	6105                	addi	sp,sp,32
    80001cd8:	8082                	ret

0000000080001cda <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001cda:	1101                	addi	sp,sp,-32
    80001cdc:	ec06                	sd	ra,24(sp)
    80001cde:	e822                	sd	s0,16(sp)
    80001ce0:	e426                	sd	s1,8(sp)
    80001ce2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause"
    80001ce4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001ce8:	00074d63          	bltz	a4,80001d02 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001cec:	57fd                	li	a5,-1
    80001cee:	17fe                	slli	a5,a5,0x3f
    80001cf0:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001cf2:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001cf4:	06f70363          	beq	a4,a5,80001d5a <devintr+0x80>
  }
}
    80001cf8:	60e2                	ld	ra,24(sp)
    80001cfa:	6442                	ld	s0,16(sp)
    80001cfc:	64a2                	ld	s1,8(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret
      (scause & 0xff) == 9)
    80001d02:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80001d06:	46a5                	li	a3,9
    80001d08:	fed792e3          	bne	a5,a3,80001cec <devintr+0x12>
    int irq = plic_claim();
    80001d0c:	00003097          	auipc	ra,0x3
    80001d10:	58c080e7          	jalr	1420(ra) # 80005298 <plic_claim>
    80001d14:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001d16:	47a9                	li	a5,10
    80001d18:	02f50763          	beq	a0,a5,80001d46 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001d1c:	4785                	li	a5,1
    80001d1e:	02f50963          	beq	a0,a5,80001d50 <devintr+0x76>
    return 1;
    80001d22:	4505                	li	a0,1
    else if (irq)
    80001d24:	d8f1                	beqz	s1,80001cf8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d26:	85a6                	mv	a1,s1
    80001d28:	00006517          	auipc	a0,0x6
    80001d2c:	57850513          	addi	a0,a0,1400 # 800082a0 <states.1713+0x38>
    80001d30:	00004097          	auipc	ra,0x4
    80001d34:	0a2080e7          	jalr	162(ra) # 80005dd2 <printf>
      plic_complete(irq);
    80001d38:	8526                	mv	a0,s1
    80001d3a:	00003097          	auipc	ra,0x3
    80001d3e:	582080e7          	jalr	1410(ra) # 800052bc <plic_complete>
    return 1;
    80001d42:	4505                	li	a0,1
    80001d44:	bf55                	j	80001cf8 <devintr+0x1e>
      uartintr();
    80001d46:	00004097          	auipc	ra,0x4
    80001d4a:	4ac080e7          	jalr	1196(ra) # 800061f2 <uartintr>
    80001d4e:	b7ed                	j	80001d38 <devintr+0x5e>
      virtio_disk_intr();
    80001d50:	00004097          	auipc	ra,0x4
    80001d54:	a4c080e7          	jalr	-1460(ra) # 8000579c <virtio_disk_intr>
    80001d58:	b7c5                	j	80001d38 <devintr+0x5e>
    if (cpuid() == 0)
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	20c080e7          	jalr	524(ra) # 80000f66 <cpuid>
    80001d62:	c901                	beqz	a0,80001d72 <devintr+0x98>
  asm volatile("csrr %0, sip"
    80001d64:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d68:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0"
    80001d6a:	14479073          	csrw	sip,a5
    return 2;
    80001d6e:	4509                	li	a0,2
    80001d70:	b761                	j	80001cf8 <devintr+0x1e>
      clockintr();
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	f22080e7          	jalr	-222(ra) # 80001c94 <clockintr>
    80001d7a:	b7ed                	j	80001d64 <devintr+0x8a>

0000000080001d7c <usertrap>:
{
    80001d7c:	7179                	addi	sp,sp,-48
    80001d7e:	f406                	sd	ra,40(sp)
    80001d80:	f022                	sd	s0,32(sp)
    80001d82:	ec26                	sd	s1,24(sp)
    80001d84:	e84a                	sd	s2,16(sp)
    80001d86:	e44e                	sd	s3,8(sp)
    80001d88:	e052                	sd	s4,0(sp)
    80001d8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus"
    80001d8c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001d90:	1007f793          	andi	a5,a5,256
    80001d94:	efe9                	bnez	a5,80001e6e <usertrap+0xf2>
  asm volatile("csrw stvec, %0"
    80001d96:	00003797          	auipc	a5,0x3
    80001d9a:	3fa78793          	addi	a5,a5,1018 # 80005190 <kernelvec>
    80001d9e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001da2:	fffff097          	auipc	ra,0xfffff
    80001da6:	1f0080e7          	jalr	496(ra) # 80000f92 <myproc>
    80001daa:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dac:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc"
    80001dae:	14102773          	csrr	a4,sepc
    80001db2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause"
    80001db4:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001db8:	47a1                	li	a5,8
    80001dba:	0cf70263          	beq	a4,a5,80001e7e <usertrap+0x102>
    80001dbe:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80001dc2:	47bd                	li	a5,15
    80001dc4:	16f71a63          	bne	a4,a5,80001f38 <usertrap+0x1bc>
  asm volatile("csrr %0, stval"
    80001dc8:	14302973          	csrr	s2,stval
    if (va >= MAXVA)
    80001dcc:	57fd                	li	a5,-1
    80001dce:	83e9                	srli	a5,a5,0x1a
    80001dd0:	0f27eb63          	bltu	a5,s2,80001ec6 <usertrap+0x14a>
    uint64 pa = walkaddr(p->pagetable, va);
    80001dd4:	85ca                	mv	a1,s2
    80001dd6:	68a8                	ld	a0,80(s1)
    80001dd8:	ffffe097          	auipc	ra,0xffffe
    80001ddc:	746080e7          	jalr	1862(ra) # 8000051e <walkaddr>
    80001de0:	8a2a                	mv	s4,a0
    if ((pte = walk(p->pagetable, va, 0)) == 0)
    80001de2:	4601                	li	a2,0
    80001de4:	85ca                	mv	a1,s2
    80001de6:	68a8                	ld	a0,80(s1)
    80001de8:	ffffe097          	auipc	ra,0xffffe
    80001dec:	690080e7          	jalr	1680(ra) # 80000478 <walk>
    80001df0:	c17d                	beqz	a0,80001ed6 <usertrap+0x15a>
    if ((*pte & PTE_C) == 0)
    80001df2:	610c                	ld	a1,0(a0)
    80001df4:	1005f793          	andi	a5,a1,256
    80001df8:	c7fd                	beqz	a5,80001ee6 <usertrap+0x16a>
    if ((mem = kalloc()) == 0)
    80001dfa:	ffffe097          	auipc	ra,0xffffe
    80001dfe:	336080e7          	jalr	822(ra) # 80000130 <kalloc>
    80001e02:	89aa                	mv	s3,a0
    80001e04:	10050263          	beqz	a0,80001f08 <usertrap+0x18c>
    memmove(mem, (char *)pa, PGSIZE);
    80001e08:	6605                	lui	a2,0x1
    80001e0a:	85d2                	mv	a1,s4
    80001e0c:	854e                	mv	a0,s3
    80001e0e:	ffffe097          	auipc	ra,0xffffe
    80001e12:	3e2080e7          	jalr	994(ra) # 800001f0 <memmove>
    uvmunmap(p->pagetable, PGROUNDDOWN(va), 1, 0);
    80001e16:	77fd                	lui	a5,0xfffff
    80001e18:	00f97933          	and	s2,s2,a5
    80001e1c:	4681                	li	a3,0
    80001e1e:	4605                	li	a2,1
    80001e20:	85ca                	mv	a1,s2
    80001e22:	68a8                	ld	a0,80(s1)
    80001e24:	fffff097          	auipc	ra,0xfffff
    80001e28:	902080e7          	jalr	-1790(ra) # 80000726 <uvmunmap>
    if ((mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U)) != 0)
    80001e2c:	4779                	li	a4,30
    80001e2e:	86ce                	mv	a3,s3
    80001e30:	6605                	lui	a2,0x1
    80001e32:	85ca                	mv	a1,s2
    80001e34:	68a8                	ld	a0,80(s1)
    80001e36:	ffffe097          	auipc	ra,0xffffe
    80001e3a:	72a080e7          	jalr	1834(ra) # 80000560 <mappages>
    80001e3e:	e56d                	bnez	a0,80001f28 <usertrap+0x1ac>
      cow_base[PTCOWIDX(pa)] -= 1;
    80001e40:	025a1713          	slli	a4,s4,0x25
    80001e44:	9345                	srli	a4,a4,0x31
    80001e46:	10fff7b7          	lui	a5,0x10fff
    80001e4a:	078e                	slli	a5,a5,0x3
    80001e4c:	973e                	add	a4,a4,a5
    80001e4e:	00074783          	lbu	a5,0(a4)
    80001e52:	37fd                	addiw	a5,a5,-1
    80001e54:	0ff7f793          	andi	a5,a5,255
    80001e58:	00f70023          	sb	a5,0(a4)
      if (cow_base[PTCOWIDX(pa)] == 0)
    80001e5c:	e3a9                	bnez	a5,80001e9e <usertrap+0x122>
        kfree((void *)PGROUNDDOWN(pa));
    80001e5e:	757d                	lui	a0,0xfffff
    80001e60:	00aa7533          	and	a0,s4,a0
    80001e64:	ffffe097          	auipc	ra,0xffffe
    80001e68:	1b8080e7          	jalr	440(ra) # 8000001c <kfree>
    80001e6c:	a80d                	j	80001e9e <usertrap+0x122>
    panic("usertrap: not from user mode");
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	45250513          	addi	a0,a0,1106 # 800082c0 <states.1713+0x58>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	f12080e7          	jalr	-238(ra) # 80005d88 <panic>
    if (p->killed)
    80001e7e:	551c                	lw	a5,40(a0)
    80001e80:	ef8d                	bnez	a5,80001eba <usertrap+0x13e>
    p->trapframe->epc += 4;
    80001e82:	6cb8                	ld	a4,88(s1)
    80001e84:	6f1c                	ld	a5,24(a4)
    80001e86:	0791                	addi	a5,a5,4
    80001e88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus"
    80001e8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80001e92:	10079073          	csrw	sstatus,a5
    syscall();
    80001e96:	00000097          	auipc	ra,0x0
    80001e9a:	346080e7          	jalr	838(ra) # 800021dc <syscall>
  if (p->killed)
    80001e9e:	549c                	lw	a5,40(s1)
    80001ea0:	eff9                	bnez	a5,80001f7e <usertrap+0x202>
  usertrapret();
    80001ea2:	00000097          	auipc	ra,0x0
    80001ea6:	d54080e7          	jalr	-684(ra) # 80001bf6 <usertrapret>
}
    80001eaa:	70a2                	ld	ra,40(sp)
    80001eac:	7402                	ld	s0,32(sp)
    80001eae:	64e2                	ld	s1,24(sp)
    80001eb0:	6942                	ld	s2,16(sp)
    80001eb2:	69a2                	ld	s3,8(sp)
    80001eb4:	6a02                	ld	s4,0(sp)
    80001eb6:	6145                	addi	sp,sp,48
    80001eb8:	8082                	ret
      exit(-1);
    80001eba:	557d                	li	a0,-1
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	9ee080e7          	jalr	-1554(ra) # 800018aa <exit>
    80001ec4:	bf7d                	j	80001e82 <usertrap+0x106>
      p->killed = 1;
    80001ec6:	4785                	li	a5,1
    80001ec8:	d51c                	sw	a5,40(a0)
      exit(-1);
    80001eca:	557d                	li	a0,-1
    80001ecc:	00000097          	auipc	ra,0x0
    80001ed0:	9de080e7          	jalr	-1570(ra) # 800018aa <exit>
    80001ed4:	b701                	j	80001dd4 <usertrap+0x58>
      panic("page fault walk\n");
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	40a50513          	addi	a0,a0,1034 # 800082e0 <states.1713+0x78>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	eaa080e7          	jalr	-342(ra) # 80005d88 <panic>
      printf("%p %p\n", *pte, pa);
    80001ee6:	8652                	mv	a2,s4
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	41050513          	addi	a0,a0,1040 # 800082f8 <states.1713+0x90>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	ee2080e7          	jalr	-286(ra) # 80005dd2 <printf>
      panic("no cow flag\n");
    80001ef8:	00006517          	auipc	a0,0x6
    80001efc:	40850513          	addi	a0,a0,1032 # 80008300 <states.1713+0x98>
    80001f00:	00004097          	auipc	ra,0x4
    80001f04:	e88080e7          	jalr	-376(ra) # 80005d88 <panic>
      printf("page fault malloc phy fail\n");
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	40850513          	addi	a0,a0,1032 # 80008310 <states.1713+0xa8>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	ec2080e7          	jalr	-318(ra) # 80005dd2 <printf>
      p->killed = 1;
    80001f18:	4785                	li	a5,1
    80001f1a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f1c:	557d                	li	a0,-1
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	98c080e7          	jalr	-1652(ra) # 800018aa <exit>
    80001f26:	b5cd                	j	80001e08 <usertrap+0x8c>
      panic("page fault unable to map\n");
    80001f28:	00006517          	auipc	a0,0x6
    80001f2c:	40850513          	addi	a0,a0,1032 # 80008330 <states.1713+0xc8>
    80001f30:	00004097          	auipc	ra,0x4
    80001f34:	e58080e7          	jalr	-424(ra) # 80005d88 <panic>
  else if ((which_dev = devintr()) != 0)
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	da2080e7          	jalr	-606(ra) # 80001cda <devintr>
    80001f40:	892a                	mv	s2,a0
    80001f42:	c501                	beqz	a0,80001f4a <usertrap+0x1ce>
  if (p->killed)
    80001f44:	549c                	lw	a5,40(s1)
    80001f46:	c3b1                	beqz	a5,80001f8a <usertrap+0x20e>
    80001f48:	a825                	j	80001f80 <usertrap+0x204>
  asm volatile("csrr %0, scause"
    80001f4a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f4e:	5890                	lw	a2,48(s1)
    80001f50:	00006517          	auipc	a0,0x6
    80001f54:	40050513          	addi	a0,a0,1024 # 80008350 <states.1713+0xe8>
    80001f58:	00004097          	auipc	ra,0x4
    80001f5c:	e7a080e7          	jalr	-390(ra) # 80005dd2 <printf>
  asm volatile("csrr %0, sepc"
    80001f60:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80001f64:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f68:	00006517          	auipc	a0,0x6
    80001f6c:	41850513          	addi	a0,a0,1048 # 80008380 <states.1713+0x118>
    80001f70:	00004097          	auipc	ra,0x4
    80001f74:	e62080e7          	jalr	-414(ra) # 80005dd2 <printf>
    p->killed = 1;
    80001f78:	4785                	li	a5,1
    80001f7a:	d49c                	sw	a5,40(s1)
  if (p->killed)
    80001f7c:	a011                	j	80001f80 <usertrap+0x204>
    80001f7e:	4901                	li	s2,0
    exit(-1);
    80001f80:	557d                	li	a0,-1
    80001f82:	00000097          	auipc	ra,0x0
    80001f86:	928080e7          	jalr	-1752(ra) # 800018aa <exit>
  if (which_dev == 2)
    80001f8a:	4789                	li	a5,2
    80001f8c:	f0f91be3          	bne	s2,a5,80001ea2 <usertrap+0x126>
    yield();
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	682080e7          	jalr	1666(ra) # 80001612 <yield>
    80001f98:	b729                	j	80001ea2 <usertrap+0x126>

0000000080001f9a <kerneltrap>:
{
    80001f9a:	7179                	addi	sp,sp,-48
    80001f9c:	f406                	sd	ra,40(sp)
    80001f9e:	f022                	sd	s0,32(sp)
    80001fa0:	ec26                	sd	s1,24(sp)
    80001fa2:	e84a                	sd	s2,16(sp)
    80001fa4:	e44e                	sd	s3,8(sp)
    80001fa6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc"
    80001fa8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus"
    80001fac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause"
    80001fb0:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001fb4:	1004f793          	andi	a5,s1,256
    80001fb8:	cb85                	beqz	a5,80001fe8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus"
    80001fba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fbe:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001fc0:	ef85                	bnez	a5,80001ff8 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001fc2:	00000097          	auipc	ra,0x0
    80001fc6:	d18080e7          	jalr	-744(ra) # 80001cda <devintr>
    80001fca:	cd1d                	beqz	a0,80002008 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fcc:	4789                	li	a5,2
    80001fce:	06f50a63          	beq	a0,a5,80002042 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0"
    80001fd2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0"
    80001fd6:	10049073          	csrw	sstatus,s1
}
    80001fda:	70a2                	ld	ra,40(sp)
    80001fdc:	7402                	ld	s0,32(sp)
    80001fde:	64e2                	ld	s1,24(sp)
    80001fe0:	6942                	ld	s2,16(sp)
    80001fe2:	69a2                	ld	s3,8(sp)
    80001fe4:	6145                	addi	sp,sp,48
    80001fe6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	3b850513          	addi	a0,a0,952 # 800083a0 <states.1713+0x138>
    80001ff0:	00004097          	auipc	ra,0x4
    80001ff4:	d98080e7          	jalr	-616(ra) # 80005d88 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	3d050513          	addi	a0,a0,976 # 800083c8 <states.1713+0x160>
    80002000:	00004097          	auipc	ra,0x4
    80002004:	d88080e7          	jalr	-632(ra) # 80005d88 <panic>
    printf("scause %p\n", scause);
    80002008:	85ce                	mv	a1,s3
    8000200a:	00006517          	auipc	a0,0x6
    8000200e:	3de50513          	addi	a0,a0,990 # 800083e8 <states.1713+0x180>
    80002012:	00004097          	auipc	ra,0x4
    80002016:	dc0080e7          	jalr	-576(ra) # 80005dd2 <printf>
  asm volatile("csrr %0, sepc"
    8000201a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    8000201e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002022:	00006517          	auipc	a0,0x6
    80002026:	3d650513          	addi	a0,a0,982 # 800083f8 <states.1713+0x190>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	da8080e7          	jalr	-600(ra) # 80005dd2 <printf>
    panic("kerneltrap");
    80002032:	00006517          	auipc	a0,0x6
    80002036:	3de50513          	addi	a0,a0,990 # 80008410 <states.1713+0x1a8>
    8000203a:	00004097          	auipc	ra,0x4
    8000203e:	d4e080e7          	jalr	-690(ra) # 80005d88 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	f50080e7          	jalr	-176(ra) # 80000f92 <myproc>
    8000204a:	d541                	beqz	a0,80001fd2 <kerneltrap+0x38>
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	f46080e7          	jalr	-186(ra) # 80000f92 <myproc>
    80002054:	4d18                	lw	a4,24(a0)
    80002056:	4791                	li	a5,4
    80002058:	f6f71de3          	bne	a4,a5,80001fd2 <kerneltrap+0x38>
    yield();
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	5b6080e7          	jalr	1462(ra) # 80001612 <yield>
    80002064:	b7bd                	j	80001fd2 <kerneltrap+0x38>

0000000080002066 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002066:	1101                	addi	sp,sp,-32
    80002068:	ec06                	sd	ra,24(sp)
    8000206a:	e822                	sd	s0,16(sp)
    8000206c:	e426                	sd	s1,8(sp)
    8000206e:	1000                	addi	s0,sp,32
    80002070:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	f20080e7          	jalr	-224(ra) # 80000f92 <myproc>
  switch (n) {
    8000207a:	4795                	li	a5,5
    8000207c:	0497e163          	bltu	a5,s1,800020be <argraw+0x58>
    80002080:	048a                	slli	s1,s1,0x2
    80002082:	00006717          	auipc	a4,0x6
    80002086:	3c670713          	addi	a4,a4,966 # 80008448 <states.1713+0x1e0>
    8000208a:	94ba                	add	s1,s1,a4
    8000208c:	409c                	lw	a5,0(s1)
    8000208e:	97ba                	add	a5,a5,a4
    80002090:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002092:	6d3c                	ld	a5,88(a0)
    80002094:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002096:	60e2                	ld	ra,24(sp)
    80002098:	6442                	ld	s0,16(sp)
    8000209a:	64a2                	ld	s1,8(sp)
    8000209c:	6105                	addi	sp,sp,32
    8000209e:	8082                	ret
    return p->trapframe->a1;
    800020a0:	6d3c                	ld	a5,88(a0)
    800020a2:	7fa8                	ld	a0,120(a5)
    800020a4:	bfcd                	j	80002096 <argraw+0x30>
    return p->trapframe->a2;
    800020a6:	6d3c                	ld	a5,88(a0)
    800020a8:	63c8                	ld	a0,128(a5)
    800020aa:	b7f5                	j	80002096 <argraw+0x30>
    return p->trapframe->a3;
    800020ac:	6d3c                	ld	a5,88(a0)
    800020ae:	67c8                	ld	a0,136(a5)
    800020b0:	b7dd                	j	80002096 <argraw+0x30>
    return p->trapframe->a4;
    800020b2:	6d3c                	ld	a5,88(a0)
    800020b4:	6bc8                	ld	a0,144(a5)
    800020b6:	b7c5                	j	80002096 <argraw+0x30>
    return p->trapframe->a5;
    800020b8:	6d3c                	ld	a5,88(a0)
    800020ba:	6fc8                	ld	a0,152(a5)
    800020bc:	bfe9                	j	80002096 <argraw+0x30>
  panic("argraw");
    800020be:	00006517          	auipc	a0,0x6
    800020c2:	36250513          	addi	a0,a0,866 # 80008420 <states.1713+0x1b8>
    800020c6:	00004097          	auipc	ra,0x4
    800020ca:	cc2080e7          	jalr	-830(ra) # 80005d88 <panic>

00000000800020ce <fetchaddr>:
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	e04a                	sd	s2,0(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84aa                	mv	s1,a0
    800020dc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	eb4080e7          	jalr	-332(ra) # 80000f92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020e6:	653c                	ld	a5,72(a0)
    800020e8:	02f4f863          	bgeu	s1,a5,80002118 <fetchaddr+0x4a>
    800020ec:	00848713          	addi	a4,s1,8
    800020f0:	02e7e663          	bltu	a5,a4,8000211c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020f4:	46a1                	li	a3,8
    800020f6:	8626                	mv	a2,s1
    800020f8:	85ca                	mv	a1,s2
    800020fa:	6928                	ld	a0,80(a0)
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	be4080e7          	jalr	-1052(ra) # 80000ce0 <copyin>
    80002104:	00a03533          	snez	a0,a0
    80002108:	40a00533          	neg	a0,a0
}
    8000210c:	60e2                	ld	ra,24(sp)
    8000210e:	6442                	ld	s0,16(sp)
    80002110:	64a2                	ld	s1,8(sp)
    80002112:	6902                	ld	s2,0(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret
    return -1;
    80002118:	557d                	li	a0,-1
    8000211a:	bfcd                	j	8000210c <fetchaddr+0x3e>
    8000211c:	557d                	li	a0,-1
    8000211e:	b7fd                	j	8000210c <fetchaddr+0x3e>

0000000080002120 <fetchstr>:
{
    80002120:	7179                	addi	sp,sp,-48
    80002122:	f406                	sd	ra,40(sp)
    80002124:	f022                	sd	s0,32(sp)
    80002126:	ec26                	sd	s1,24(sp)
    80002128:	e84a                	sd	s2,16(sp)
    8000212a:	e44e                	sd	s3,8(sp)
    8000212c:	1800                	addi	s0,sp,48
    8000212e:	892a                	mv	s2,a0
    80002130:	84ae                	mv	s1,a1
    80002132:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	e5e080e7          	jalr	-418(ra) # 80000f92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000213c:	86ce                	mv	a3,s3
    8000213e:	864a                	mv	a2,s2
    80002140:	85a6                	mv	a1,s1
    80002142:	6928                	ld	a0,80(a0)
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	c28080e7          	jalr	-984(ra) # 80000d6c <copyinstr>
  if(err < 0)
    8000214c:	00054763          	bltz	a0,8000215a <fetchstr+0x3a>
  return strlen(buf);
    80002150:	8526                	mv	a0,s1
    80002152:	ffffe097          	auipc	ra,0xffffe
    80002156:	1c2080e7          	jalr	450(ra) # 80000314 <strlen>
}
    8000215a:	70a2                	ld	ra,40(sp)
    8000215c:	7402                	ld	s0,32(sp)
    8000215e:	64e2                	ld	s1,24(sp)
    80002160:	6942                	ld	s2,16(sp)
    80002162:	69a2                	ld	s3,8(sp)
    80002164:	6145                	addi	sp,sp,48
    80002166:	8082                	ret

0000000080002168 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	e426                	sd	s1,8(sp)
    80002170:	1000                	addi	s0,sp,32
    80002172:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002174:	00000097          	auipc	ra,0x0
    80002178:	ef2080e7          	jalr	-270(ra) # 80002066 <argraw>
    8000217c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000217e:	4501                	li	a0,0
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	64a2                	ld	s1,8(sp)
    80002186:	6105                	addi	sp,sp,32
    80002188:	8082                	ret

000000008000218a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	e426                	sd	s1,8(sp)
    80002192:	1000                	addi	s0,sp,32
    80002194:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	ed0080e7          	jalr	-304(ra) # 80002066 <argraw>
    8000219e:	e088                	sd	a0,0(s1)
  return 0;
}
    800021a0:	4501                	li	a0,0
    800021a2:	60e2                	ld	ra,24(sp)
    800021a4:	6442                	ld	s0,16(sp)
    800021a6:	64a2                	ld	s1,8(sp)
    800021a8:	6105                	addi	sp,sp,32
    800021aa:	8082                	ret

00000000800021ac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	e426                	sd	s1,8(sp)
    800021b4:	e04a                	sd	s2,0(sp)
    800021b6:	1000                	addi	s0,sp,32
    800021b8:	84ae                	mv	s1,a1
    800021ba:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	eaa080e7          	jalr	-342(ra) # 80002066 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021c4:	864a                	mv	a2,s2
    800021c6:	85a6                	mv	a1,s1
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	f58080e7          	jalr	-168(ra) # 80002120 <fetchstr>
}
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	64a2                	ld	s1,8(sp)
    800021d6:	6902                	ld	s2,0(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	e426                	sd	s1,8(sp)
    800021e4:	e04a                	sd	s2,0(sp)
    800021e6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	daa080e7          	jalr	-598(ra) # 80000f92 <myproc>
    800021f0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021f2:	05853903          	ld	s2,88(a0)
    800021f6:	0a893783          	ld	a5,168(s2)
    800021fa:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021fe:	37fd                	addiw	a5,a5,-1
    80002200:	4751                	li	a4,20
    80002202:	00f76f63          	bltu	a4,a5,80002220 <syscall+0x44>
    80002206:	00369713          	slli	a4,a3,0x3
    8000220a:	00006797          	auipc	a5,0x6
    8000220e:	25678793          	addi	a5,a5,598 # 80008460 <syscalls>
    80002212:	97ba                	add	a5,a5,a4
    80002214:	639c                	ld	a5,0(a5)
    80002216:	c789                	beqz	a5,80002220 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002218:	9782                	jalr	a5
    8000221a:	06a93823          	sd	a0,112(s2)
    8000221e:	a839                	j	8000223c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002220:	15848613          	addi	a2,s1,344
    80002224:	588c                	lw	a1,48(s1)
    80002226:	00006517          	auipc	a0,0x6
    8000222a:	20250513          	addi	a0,a0,514 # 80008428 <states.1713+0x1c0>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	ba4080e7          	jalr	-1116(ra) # 80005dd2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002236:	6cbc                	ld	a5,88(s1)
    80002238:	577d                	li	a4,-1
    8000223a:	fbb8                	sd	a4,112(a5)
  }
}
    8000223c:	60e2                	ld	ra,24(sp)
    8000223e:	6442                	ld	s0,16(sp)
    80002240:	64a2                	ld	s1,8(sp)
    80002242:	6902                	ld	s2,0(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002248:	1101                	addi	sp,sp,-32
    8000224a:	ec06                	sd	ra,24(sp)
    8000224c:	e822                	sd	s0,16(sp)
    8000224e:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80002250:	fec40593          	addi	a1,s0,-20
    80002254:	4501                	li	a0,0
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	f12080e7          	jalr	-238(ra) # 80002168 <argint>
    return -1;
    8000225e:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002260:	00054963          	bltz	a0,80002272 <sys_exit+0x2a>
  exit(n);
    80002264:	fec42503          	lw	a0,-20(s0)
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	642080e7          	jalr	1602(ra) # 800018aa <exit>
  return 0; // not reached
    80002270:	4781                	li	a5,0
}
    80002272:	853e                	mv	a0,a5
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000227c:	1141                	addi	sp,sp,-16
    8000227e:	e406                	sd	ra,8(sp)
    80002280:	e022                	sd	s0,0(sp)
    80002282:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	d0e080e7          	jalr	-754(ra) # 80000f92 <myproc>
}
    8000228c:	5908                	lw	a0,48(a0)
    8000228e:	60a2                	ld	ra,8(sp)
    80002290:	6402                	ld	s0,0(sp)
    80002292:	0141                	addi	sp,sp,16
    80002294:	8082                	ret

0000000080002296 <sys_fork>:

uint64
sys_fork(void)
{
    80002296:	1141                	addi	sp,sp,-16
    80002298:	e406                	sd	ra,8(sp)
    8000229a:	e022                	sd	s0,0(sp)
    8000229c:	0800                	addi	s0,sp,16
  return fork();
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	0c2080e7          	jalr	194(ra) # 80001360 <fork>
}
    800022a6:	60a2                	ld	ra,8(sp)
    800022a8:	6402                	ld	s0,0(sp)
    800022aa:	0141                	addi	sp,sp,16
    800022ac:	8082                	ret

00000000800022ae <sys_wait>:

uint64
sys_wait(void)
{
    800022ae:	1101                	addi	sp,sp,-32
    800022b0:	ec06                	sd	ra,24(sp)
    800022b2:	e822                	sd	s0,16(sp)
    800022b4:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    800022b6:	fe840593          	addi	a1,s0,-24
    800022ba:	4501                	li	a0,0
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	ece080e7          	jalr	-306(ra) # 8000218a <argaddr>
    800022c4:	87aa                	mv	a5,a0
    return -1;
    800022c6:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    800022c8:	0007c863          	bltz	a5,800022d8 <sys_wait+0x2a>
  return wait(p);
    800022cc:	fe843503          	ld	a0,-24(s0)
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	3e2080e7          	jalr	994(ra) # 800016b2 <wait>
}
    800022d8:	60e2                	ld	ra,24(sp)
    800022da:	6442                	ld	s0,16(sp)
    800022dc:	6105                	addi	sp,sp,32
    800022de:	8082                	ret

00000000800022e0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022e0:	7179                	addi	sp,sp,-48
    800022e2:	f406                	sd	ra,40(sp)
    800022e4:	f022                	sd	s0,32(sp)
    800022e6:	ec26                	sd	s1,24(sp)
    800022e8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    800022ea:	fdc40593          	addi	a1,s0,-36
    800022ee:	4501                	li	a0,0
    800022f0:	00000097          	auipc	ra,0x0
    800022f4:	e78080e7          	jalr	-392(ra) # 80002168 <argint>
    800022f8:	87aa                	mv	a5,a0
    return -1;
    800022fa:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    800022fc:	0207c063          	bltz	a5,8000231c <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	c92080e7          	jalr	-878(ra) # 80000f92 <myproc>
    80002308:	4524                	lw	s1,72(a0)
  if (growproc(n) < 0)
    8000230a:	fdc42503          	lw	a0,-36(s0)
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	fde080e7          	jalr	-34(ra) # 800012ec <growproc>
    80002316:	00054863          	bltz	a0,80002326 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000231a:	8526                	mv	a0,s1
}
    8000231c:	70a2                	ld	ra,40(sp)
    8000231e:	7402                	ld	s0,32(sp)
    80002320:	64e2                	ld	s1,24(sp)
    80002322:	6145                	addi	sp,sp,48
    80002324:	8082                	ret
    return -1;
    80002326:	557d                	li	a0,-1
    80002328:	bfd5                	j	8000231c <sys_sbrk+0x3c>

000000008000232a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000232a:	7139                	addi	sp,sp,-64
    8000232c:	fc06                	sd	ra,56(sp)
    8000232e:	f822                	sd	s0,48(sp)
    80002330:	f426                	sd	s1,40(sp)
    80002332:	f04a                	sd	s2,32(sp)
    80002334:	ec4e                	sd	s3,24(sp)
    80002336:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80002338:	fcc40593          	addi	a1,s0,-52
    8000233c:	4501                	li	a0,0
    8000233e:	00000097          	auipc	ra,0x0
    80002342:	e2a080e7          	jalr	-470(ra) # 80002168 <argint>
    return -1;
    80002346:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002348:	06054563          	bltz	a0,800023b2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000234c:	0000d517          	auipc	a0,0xd
    80002350:	b3450513          	addi	a0,a0,-1228 # 8000ee80 <tickslock>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	f7e080e7          	jalr	-130(ra) # 800062d2 <acquire>
  ticks0 = ticks;
    8000235c:	00007917          	auipc	s2,0x7
    80002360:	cbc92903          	lw	s2,-836(s2) # 80009018 <ticks>
  while (ticks - ticks0 < n)
    80002364:	fcc42783          	lw	a5,-52(s0)
    80002368:	cf85                	beqz	a5,800023a0 <sys_sleep+0x76>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000236a:	0000d997          	auipc	s3,0xd
    8000236e:	b1698993          	addi	s3,s3,-1258 # 8000ee80 <tickslock>
    80002372:	00007497          	auipc	s1,0x7
    80002376:	ca648493          	addi	s1,s1,-858 # 80009018 <ticks>
    if (myproc()->killed)
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	c18080e7          	jalr	-1000(ra) # 80000f92 <myproc>
    80002382:	551c                	lw	a5,40(a0)
    80002384:	ef9d                	bnez	a5,800023c2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002386:	85ce                	mv	a1,s3
    80002388:	8526                	mv	a0,s1
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	2c4080e7          	jalr	708(ra) # 8000164e <sleep>
  while (ticks - ticks0 < n)
    80002392:	409c                	lw	a5,0(s1)
    80002394:	412787bb          	subw	a5,a5,s2
    80002398:	fcc42703          	lw	a4,-52(s0)
    8000239c:	fce7efe3          	bltu	a5,a4,8000237a <sys_sleep+0x50>
  }
  release(&tickslock);
    800023a0:	0000d517          	auipc	a0,0xd
    800023a4:	ae050513          	addi	a0,a0,-1312 # 8000ee80 <tickslock>
    800023a8:	00004097          	auipc	ra,0x4
    800023ac:	fde080e7          	jalr	-34(ra) # 80006386 <release>
  return 0;
    800023b0:	4781                	li	a5,0
}
    800023b2:	853e                	mv	a0,a5
    800023b4:	70e2                	ld	ra,56(sp)
    800023b6:	7442                	ld	s0,48(sp)
    800023b8:	74a2                	ld	s1,40(sp)
    800023ba:	7902                	ld	s2,32(sp)
    800023bc:	69e2                	ld	s3,24(sp)
    800023be:	6121                	addi	sp,sp,64
    800023c0:	8082                	ret
      release(&tickslock);
    800023c2:	0000d517          	auipc	a0,0xd
    800023c6:	abe50513          	addi	a0,a0,-1346 # 8000ee80 <tickslock>
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	fbc080e7          	jalr	-68(ra) # 80006386 <release>
      return -1;
    800023d2:	57fd                	li	a5,-1
    800023d4:	bff9                	j	800023b2 <sys_sleep+0x88>

00000000800023d6 <sys_kill>:

uint64
sys_kill(void)
{
    800023d6:	1101                	addi	sp,sp,-32
    800023d8:	ec06                	sd	ra,24(sp)
    800023da:	e822                	sd	s0,16(sp)
    800023dc:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800023de:	fec40593          	addi	a1,s0,-20
    800023e2:	4501                	li	a0,0
    800023e4:	00000097          	auipc	ra,0x0
    800023e8:	d84080e7          	jalr	-636(ra) # 80002168 <argint>
    800023ec:	87aa                	mv	a5,a0
    return -1;
    800023ee:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800023f0:	0007c863          	bltz	a5,80002400 <sys_kill+0x2a>
  return kill(pid);
    800023f4:	fec42503          	lw	a0,-20(s0)
    800023f8:	fffff097          	auipc	ra,0xfffff
    800023fc:	588080e7          	jalr	1416(ra) # 80001980 <kill>
}
    80002400:	60e2                	ld	ra,24(sp)
    80002402:	6442                	ld	s0,16(sp)
    80002404:	6105                	addi	sp,sp,32
    80002406:	8082                	ret

0000000080002408 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002408:	1101                	addi	sp,sp,-32
    8000240a:	ec06                	sd	ra,24(sp)
    8000240c:	e822                	sd	s0,16(sp)
    8000240e:	e426                	sd	s1,8(sp)
    80002410:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002412:	0000d517          	auipc	a0,0xd
    80002416:	a6e50513          	addi	a0,a0,-1426 # 8000ee80 <tickslock>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	eb8080e7          	jalr	-328(ra) # 800062d2 <acquire>
  xticks = ticks;
    80002422:	00007497          	auipc	s1,0x7
    80002426:	bf64a483          	lw	s1,-1034(s1) # 80009018 <ticks>
  release(&tickslock);
    8000242a:	0000d517          	auipc	a0,0xd
    8000242e:	a5650513          	addi	a0,a0,-1450 # 8000ee80 <tickslock>
    80002432:	00004097          	auipc	ra,0x4
    80002436:	f54080e7          	jalr	-172(ra) # 80006386 <release>
  return xticks;
}
    8000243a:	02049513          	slli	a0,s1,0x20
    8000243e:	9101                	srli	a0,a0,0x20
    80002440:	60e2                	ld	ra,24(sp)
    80002442:	6442                	ld	s0,16(sp)
    80002444:	64a2                	ld	s1,8(sp)
    80002446:	6105                	addi	sp,sp,32
    80002448:	8082                	ret

000000008000244a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000244a:	7179                	addi	sp,sp,-48
    8000244c:	f406                	sd	ra,40(sp)
    8000244e:	f022                	sd	s0,32(sp)
    80002450:	ec26                	sd	s1,24(sp)
    80002452:	e84a                	sd	s2,16(sp)
    80002454:	e44e                	sd	s3,8(sp)
    80002456:	e052                	sd	s4,0(sp)
    80002458:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000245a:	00006597          	auipc	a1,0x6
    8000245e:	0b658593          	addi	a1,a1,182 # 80008510 <syscalls+0xb0>
    80002462:	0000d517          	auipc	a0,0xd
    80002466:	a3650513          	addi	a0,a0,-1482 # 8000ee98 <bcache>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	dd8080e7          	jalr	-552(ra) # 80006242 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002472:	00015797          	auipc	a5,0x15
    80002476:	a2678793          	addi	a5,a5,-1498 # 80016e98 <bcache+0x8000>
    8000247a:	00015717          	auipc	a4,0x15
    8000247e:	c8670713          	addi	a4,a4,-890 # 80017100 <bcache+0x8268>
    80002482:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002486:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000248a:	0000d497          	auipc	s1,0xd
    8000248e:	a2648493          	addi	s1,s1,-1498 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002492:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002494:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002496:	00006a17          	auipc	s4,0x6
    8000249a:	082a0a13          	addi	s4,s4,130 # 80008518 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000249e:	2b893783          	ld	a5,696(s2)
    800024a2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024a4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024a8:	85d2                	mv	a1,s4
    800024aa:	01048513          	addi	a0,s1,16
    800024ae:	00001097          	auipc	ra,0x1
    800024b2:	4bc080e7          	jalr	1212(ra) # 8000396a <initsleeplock>
    bcache.head.next->prev = b;
    800024b6:	2b893783          	ld	a5,696(s2)
    800024ba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024bc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024c0:	45848493          	addi	s1,s1,1112
    800024c4:	fd349de3          	bne	s1,s3,8000249e <binit+0x54>
  }
}
    800024c8:	70a2                	ld	ra,40(sp)
    800024ca:	7402                	ld	s0,32(sp)
    800024cc:	64e2                	ld	s1,24(sp)
    800024ce:	6942                	ld	s2,16(sp)
    800024d0:	69a2                	ld	s3,8(sp)
    800024d2:	6a02                	ld	s4,0(sp)
    800024d4:	6145                	addi	sp,sp,48
    800024d6:	8082                	ret

00000000800024d8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024d8:	7179                	addi	sp,sp,-48
    800024da:	f406                	sd	ra,40(sp)
    800024dc:	f022                	sd	s0,32(sp)
    800024de:	ec26                	sd	s1,24(sp)
    800024e0:	e84a                	sd	s2,16(sp)
    800024e2:	e44e                	sd	s3,8(sp)
    800024e4:	1800                	addi	s0,sp,48
    800024e6:	89aa                	mv	s3,a0
    800024e8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024ea:	0000d517          	auipc	a0,0xd
    800024ee:	9ae50513          	addi	a0,a0,-1618 # 8000ee98 <bcache>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	de0080e7          	jalr	-544(ra) # 800062d2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024fa:	00015497          	auipc	s1,0x15
    800024fe:	c564b483          	ld	s1,-938(s1) # 80017150 <bcache+0x82b8>
    80002502:	00015797          	auipc	a5,0x15
    80002506:	bfe78793          	addi	a5,a5,-1026 # 80017100 <bcache+0x8268>
    8000250a:	02f48f63          	beq	s1,a5,80002548 <bread+0x70>
    8000250e:	873e                	mv	a4,a5
    80002510:	a021                	j	80002518 <bread+0x40>
    80002512:	68a4                	ld	s1,80(s1)
    80002514:	02e48a63          	beq	s1,a4,80002548 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002518:	449c                	lw	a5,8(s1)
    8000251a:	ff379ce3          	bne	a5,s3,80002512 <bread+0x3a>
    8000251e:	44dc                	lw	a5,12(s1)
    80002520:	ff2799e3          	bne	a5,s2,80002512 <bread+0x3a>
      b->refcnt++;
    80002524:	40bc                	lw	a5,64(s1)
    80002526:	2785                	addiw	a5,a5,1
    80002528:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000252a:	0000d517          	auipc	a0,0xd
    8000252e:	96e50513          	addi	a0,a0,-1682 # 8000ee98 <bcache>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	e54080e7          	jalr	-428(ra) # 80006386 <release>
      acquiresleep(&b->lock);
    8000253a:	01048513          	addi	a0,s1,16
    8000253e:	00001097          	auipc	ra,0x1
    80002542:	466080e7          	jalr	1126(ra) # 800039a4 <acquiresleep>
      return b;
    80002546:	a8b9                	j	800025a4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002548:	00015497          	auipc	s1,0x15
    8000254c:	c004b483          	ld	s1,-1024(s1) # 80017148 <bcache+0x82b0>
    80002550:	00015797          	auipc	a5,0x15
    80002554:	bb078793          	addi	a5,a5,-1104 # 80017100 <bcache+0x8268>
    80002558:	00f48863          	beq	s1,a5,80002568 <bread+0x90>
    8000255c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000255e:	40bc                	lw	a5,64(s1)
    80002560:	cf81                	beqz	a5,80002578 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002562:	64a4                	ld	s1,72(s1)
    80002564:	fee49de3          	bne	s1,a4,8000255e <bread+0x86>
  panic("bget: no buffers");
    80002568:	00006517          	auipc	a0,0x6
    8000256c:	fb850513          	addi	a0,a0,-72 # 80008520 <syscalls+0xc0>
    80002570:	00004097          	auipc	ra,0x4
    80002574:	818080e7          	jalr	-2024(ra) # 80005d88 <panic>
      b->dev = dev;
    80002578:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000257c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002580:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002584:	4785                	li	a5,1
    80002586:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002588:	0000d517          	auipc	a0,0xd
    8000258c:	91050513          	addi	a0,a0,-1776 # 8000ee98 <bcache>
    80002590:	00004097          	auipc	ra,0x4
    80002594:	df6080e7          	jalr	-522(ra) # 80006386 <release>
      acquiresleep(&b->lock);
    80002598:	01048513          	addi	a0,s1,16
    8000259c:	00001097          	auipc	ra,0x1
    800025a0:	408080e7          	jalr	1032(ra) # 800039a4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025a4:	409c                	lw	a5,0(s1)
    800025a6:	cb89                	beqz	a5,800025b8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025a8:	8526                	mv	a0,s1
    800025aa:	70a2                	ld	ra,40(sp)
    800025ac:	7402                	ld	s0,32(sp)
    800025ae:	64e2                	ld	s1,24(sp)
    800025b0:	6942                	ld	s2,16(sp)
    800025b2:	69a2                	ld	s3,8(sp)
    800025b4:	6145                	addi	sp,sp,48
    800025b6:	8082                	ret
    virtio_disk_rw(b, 0);
    800025b8:	4581                	li	a1,0
    800025ba:	8526                	mv	a0,s1
    800025bc:	00003097          	auipc	ra,0x3
    800025c0:	f0a080e7          	jalr	-246(ra) # 800054c6 <virtio_disk_rw>
    b->valid = 1;
    800025c4:	4785                	li	a5,1
    800025c6:	c09c                	sw	a5,0(s1)
  return b;
    800025c8:	b7c5                	j	800025a8 <bread+0xd0>

00000000800025ca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025ca:	1101                	addi	sp,sp,-32
    800025cc:	ec06                	sd	ra,24(sp)
    800025ce:	e822                	sd	s0,16(sp)
    800025d0:	e426                	sd	s1,8(sp)
    800025d2:	1000                	addi	s0,sp,32
    800025d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025d6:	0541                	addi	a0,a0,16
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	466080e7          	jalr	1126(ra) # 80003a3e <holdingsleep>
    800025e0:	cd01                	beqz	a0,800025f8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025e2:	4585                	li	a1,1
    800025e4:	8526                	mv	a0,s1
    800025e6:	00003097          	auipc	ra,0x3
    800025ea:	ee0080e7          	jalr	-288(ra) # 800054c6 <virtio_disk_rw>
}
    800025ee:	60e2                	ld	ra,24(sp)
    800025f0:	6442                	ld	s0,16(sp)
    800025f2:	64a2                	ld	s1,8(sp)
    800025f4:	6105                	addi	sp,sp,32
    800025f6:	8082                	ret
    panic("bwrite");
    800025f8:	00006517          	auipc	a0,0x6
    800025fc:	f4050513          	addi	a0,a0,-192 # 80008538 <syscalls+0xd8>
    80002600:	00003097          	auipc	ra,0x3
    80002604:	788080e7          	jalr	1928(ra) # 80005d88 <panic>

0000000080002608 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002608:	1101                	addi	sp,sp,-32
    8000260a:	ec06                	sd	ra,24(sp)
    8000260c:	e822                	sd	s0,16(sp)
    8000260e:	e426                	sd	s1,8(sp)
    80002610:	e04a                	sd	s2,0(sp)
    80002612:	1000                	addi	s0,sp,32
    80002614:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002616:	01050913          	addi	s2,a0,16
    8000261a:	854a                	mv	a0,s2
    8000261c:	00001097          	auipc	ra,0x1
    80002620:	422080e7          	jalr	1058(ra) # 80003a3e <holdingsleep>
    80002624:	c92d                	beqz	a0,80002696 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002626:	854a                	mv	a0,s2
    80002628:	00001097          	auipc	ra,0x1
    8000262c:	3d2080e7          	jalr	978(ra) # 800039fa <releasesleep>

  acquire(&bcache.lock);
    80002630:	0000d517          	auipc	a0,0xd
    80002634:	86850513          	addi	a0,a0,-1944 # 8000ee98 <bcache>
    80002638:	00004097          	auipc	ra,0x4
    8000263c:	c9a080e7          	jalr	-870(ra) # 800062d2 <acquire>
  b->refcnt--;
    80002640:	40bc                	lw	a5,64(s1)
    80002642:	37fd                	addiw	a5,a5,-1
    80002644:	0007871b          	sext.w	a4,a5
    80002648:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000264a:	eb05                	bnez	a4,8000267a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000264c:	68bc                	ld	a5,80(s1)
    8000264e:	64b8                	ld	a4,72(s1)
    80002650:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002652:	64bc                	ld	a5,72(s1)
    80002654:	68b8                	ld	a4,80(s1)
    80002656:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002658:	00015797          	auipc	a5,0x15
    8000265c:	84078793          	addi	a5,a5,-1984 # 80016e98 <bcache+0x8000>
    80002660:	2b87b703          	ld	a4,696(a5)
    80002664:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002666:	00015717          	auipc	a4,0x15
    8000266a:	a9a70713          	addi	a4,a4,-1382 # 80017100 <bcache+0x8268>
    8000266e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002670:	2b87b703          	ld	a4,696(a5)
    80002674:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002676:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000267a:	0000d517          	auipc	a0,0xd
    8000267e:	81e50513          	addi	a0,a0,-2018 # 8000ee98 <bcache>
    80002682:	00004097          	auipc	ra,0x4
    80002686:	d04080e7          	jalr	-764(ra) # 80006386 <release>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6902                	ld	s2,0(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret
    panic("brelse");
    80002696:	00006517          	auipc	a0,0x6
    8000269a:	eaa50513          	addi	a0,a0,-342 # 80008540 <syscalls+0xe0>
    8000269e:	00003097          	auipc	ra,0x3
    800026a2:	6ea080e7          	jalr	1770(ra) # 80005d88 <panic>

00000000800026a6 <bpin>:

void
bpin(struct buf *b) {
    800026a6:	1101                	addi	sp,sp,-32
    800026a8:	ec06                	sd	ra,24(sp)
    800026aa:	e822                	sd	s0,16(sp)
    800026ac:	e426                	sd	s1,8(sp)
    800026ae:	1000                	addi	s0,sp,32
    800026b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026b2:	0000c517          	auipc	a0,0xc
    800026b6:	7e650513          	addi	a0,a0,2022 # 8000ee98 <bcache>
    800026ba:	00004097          	auipc	ra,0x4
    800026be:	c18080e7          	jalr	-1000(ra) # 800062d2 <acquire>
  b->refcnt++;
    800026c2:	40bc                	lw	a5,64(s1)
    800026c4:	2785                	addiw	a5,a5,1
    800026c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026c8:	0000c517          	auipc	a0,0xc
    800026cc:	7d050513          	addi	a0,a0,2000 # 8000ee98 <bcache>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	cb6080e7          	jalr	-842(ra) # 80006386 <release>
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6105                	addi	sp,sp,32
    800026e0:	8082                	ret

00000000800026e2 <bunpin>:

void
bunpin(struct buf *b) {
    800026e2:	1101                	addi	sp,sp,-32
    800026e4:	ec06                	sd	ra,24(sp)
    800026e6:	e822                	sd	s0,16(sp)
    800026e8:	e426                	sd	s1,8(sp)
    800026ea:	1000                	addi	s0,sp,32
    800026ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026ee:	0000c517          	auipc	a0,0xc
    800026f2:	7aa50513          	addi	a0,a0,1962 # 8000ee98 <bcache>
    800026f6:	00004097          	auipc	ra,0x4
    800026fa:	bdc080e7          	jalr	-1060(ra) # 800062d2 <acquire>
  b->refcnt--;
    800026fe:	40bc                	lw	a5,64(s1)
    80002700:	37fd                	addiw	a5,a5,-1
    80002702:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002704:	0000c517          	auipc	a0,0xc
    80002708:	79450513          	addi	a0,a0,1940 # 8000ee98 <bcache>
    8000270c:	00004097          	auipc	ra,0x4
    80002710:	c7a080e7          	jalr	-902(ra) # 80006386 <release>
}
    80002714:	60e2                	ld	ra,24(sp)
    80002716:	6442                	ld	s0,16(sp)
    80002718:	64a2                	ld	s1,8(sp)
    8000271a:	6105                	addi	sp,sp,32
    8000271c:	8082                	ret

000000008000271e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000271e:	1101                	addi	sp,sp,-32
    80002720:	ec06                	sd	ra,24(sp)
    80002722:	e822                	sd	s0,16(sp)
    80002724:	e426                	sd	s1,8(sp)
    80002726:	e04a                	sd	s2,0(sp)
    80002728:	1000                	addi	s0,sp,32
    8000272a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000272c:	00d5d59b          	srliw	a1,a1,0xd
    80002730:	00015797          	auipc	a5,0x15
    80002734:	e447a783          	lw	a5,-444(a5) # 80017574 <sb+0x1c>
    80002738:	9dbd                	addw	a1,a1,a5
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	d9e080e7          	jalr	-610(ra) # 800024d8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002742:	0074f713          	andi	a4,s1,7
    80002746:	4785                	li	a5,1
    80002748:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000274c:	14ce                	slli	s1,s1,0x33
    8000274e:	90d9                	srli	s1,s1,0x36
    80002750:	00950733          	add	a4,a0,s1
    80002754:	05874703          	lbu	a4,88(a4)
    80002758:	00e7f6b3          	and	a3,a5,a4
    8000275c:	c69d                	beqz	a3,8000278a <bfree+0x6c>
    8000275e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002760:	94aa                	add	s1,s1,a0
    80002762:	fff7c793          	not	a5,a5
    80002766:	8ff9                	and	a5,a5,a4
    80002768:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000276c:	00001097          	auipc	ra,0x1
    80002770:	118080e7          	jalr	280(ra) # 80003884 <log_write>
  brelse(bp);
    80002774:	854a                	mv	a0,s2
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	e92080e7          	jalr	-366(ra) # 80002608 <brelse>
}
    8000277e:	60e2                	ld	ra,24(sp)
    80002780:	6442                	ld	s0,16(sp)
    80002782:	64a2                	ld	s1,8(sp)
    80002784:	6902                	ld	s2,0(sp)
    80002786:	6105                	addi	sp,sp,32
    80002788:	8082                	ret
    panic("freeing free block");
    8000278a:	00006517          	auipc	a0,0x6
    8000278e:	dbe50513          	addi	a0,a0,-578 # 80008548 <syscalls+0xe8>
    80002792:	00003097          	auipc	ra,0x3
    80002796:	5f6080e7          	jalr	1526(ra) # 80005d88 <panic>

000000008000279a <balloc>:
{
    8000279a:	711d                	addi	sp,sp,-96
    8000279c:	ec86                	sd	ra,88(sp)
    8000279e:	e8a2                	sd	s0,80(sp)
    800027a0:	e4a6                	sd	s1,72(sp)
    800027a2:	e0ca                	sd	s2,64(sp)
    800027a4:	fc4e                	sd	s3,56(sp)
    800027a6:	f852                	sd	s4,48(sp)
    800027a8:	f456                	sd	s5,40(sp)
    800027aa:	f05a                	sd	s6,32(sp)
    800027ac:	ec5e                	sd	s7,24(sp)
    800027ae:	e862                	sd	s8,16(sp)
    800027b0:	e466                	sd	s9,8(sp)
    800027b2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027b4:	00015797          	auipc	a5,0x15
    800027b8:	da87a783          	lw	a5,-600(a5) # 8001755c <sb+0x4>
    800027bc:	cbd1                	beqz	a5,80002850 <balloc+0xb6>
    800027be:	8baa                	mv	s7,a0
    800027c0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027c2:	00015b17          	auipc	s6,0x15
    800027c6:	d96b0b13          	addi	s6,s6,-618 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ca:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027cc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ce:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027d0:	6c89                	lui	s9,0x2
    800027d2:	a831                	j	800027ee <balloc+0x54>
    brelse(bp);
    800027d4:	854a                	mv	a0,s2
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	e32080e7          	jalr	-462(ra) # 80002608 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027de:	015c87bb          	addw	a5,s9,s5
    800027e2:	00078a9b          	sext.w	s5,a5
    800027e6:	004b2703          	lw	a4,4(s6)
    800027ea:	06eaf363          	bgeu	s5,a4,80002850 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027ee:	41fad79b          	sraiw	a5,s5,0x1f
    800027f2:	0137d79b          	srliw	a5,a5,0x13
    800027f6:	015787bb          	addw	a5,a5,s5
    800027fa:	40d7d79b          	sraiw	a5,a5,0xd
    800027fe:	01cb2583          	lw	a1,28(s6)
    80002802:	9dbd                	addw	a1,a1,a5
    80002804:	855e                	mv	a0,s7
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	cd2080e7          	jalr	-814(ra) # 800024d8 <bread>
    8000280e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002810:	004b2503          	lw	a0,4(s6)
    80002814:	000a849b          	sext.w	s1,s5
    80002818:	8662                	mv	a2,s8
    8000281a:	faa4fde3          	bgeu	s1,a0,800027d4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000281e:	41f6579b          	sraiw	a5,a2,0x1f
    80002822:	01d7d69b          	srliw	a3,a5,0x1d
    80002826:	00c6873b          	addw	a4,a3,a2
    8000282a:	00777793          	andi	a5,a4,7
    8000282e:	9f95                	subw	a5,a5,a3
    80002830:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002834:	4037571b          	sraiw	a4,a4,0x3
    80002838:	00e906b3          	add	a3,s2,a4
    8000283c:	0586c683          	lbu	a3,88(a3)
    80002840:	00d7f5b3          	and	a1,a5,a3
    80002844:	cd91                	beqz	a1,80002860 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002846:	2605                	addiw	a2,a2,1
    80002848:	2485                	addiw	s1,s1,1
    8000284a:	fd4618e3          	bne	a2,s4,8000281a <balloc+0x80>
    8000284e:	b759                	j	800027d4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002850:	00006517          	auipc	a0,0x6
    80002854:	d1050513          	addi	a0,a0,-752 # 80008560 <syscalls+0x100>
    80002858:	00003097          	auipc	ra,0x3
    8000285c:	530080e7          	jalr	1328(ra) # 80005d88 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002860:	974a                	add	a4,a4,s2
    80002862:	8fd5                	or	a5,a5,a3
    80002864:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002868:	854a                	mv	a0,s2
    8000286a:	00001097          	auipc	ra,0x1
    8000286e:	01a080e7          	jalr	26(ra) # 80003884 <log_write>
        brelse(bp);
    80002872:	854a                	mv	a0,s2
    80002874:	00000097          	auipc	ra,0x0
    80002878:	d94080e7          	jalr	-620(ra) # 80002608 <brelse>
  bp = bread(dev, bno);
    8000287c:	85a6                	mv	a1,s1
    8000287e:	855e                	mv	a0,s7
    80002880:	00000097          	auipc	ra,0x0
    80002884:	c58080e7          	jalr	-936(ra) # 800024d8 <bread>
    80002888:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000288a:	40000613          	li	a2,1024
    8000288e:	4581                	li	a1,0
    80002890:	05850513          	addi	a0,a0,88
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	8fc080e7          	jalr	-1796(ra) # 80000190 <memset>
  log_write(bp);
    8000289c:	854a                	mv	a0,s2
    8000289e:	00001097          	auipc	ra,0x1
    800028a2:	fe6080e7          	jalr	-26(ra) # 80003884 <log_write>
  brelse(bp);
    800028a6:	854a                	mv	a0,s2
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	d60080e7          	jalr	-672(ra) # 80002608 <brelse>
}
    800028b0:	8526                	mv	a0,s1
    800028b2:	60e6                	ld	ra,88(sp)
    800028b4:	6446                	ld	s0,80(sp)
    800028b6:	64a6                	ld	s1,72(sp)
    800028b8:	6906                	ld	s2,64(sp)
    800028ba:	79e2                	ld	s3,56(sp)
    800028bc:	7a42                	ld	s4,48(sp)
    800028be:	7aa2                	ld	s5,40(sp)
    800028c0:	7b02                	ld	s6,32(sp)
    800028c2:	6be2                	ld	s7,24(sp)
    800028c4:	6c42                	ld	s8,16(sp)
    800028c6:	6ca2                	ld	s9,8(sp)
    800028c8:	6125                	addi	sp,sp,96
    800028ca:	8082                	ret

00000000800028cc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028cc:	7179                	addi	sp,sp,-48
    800028ce:	f406                	sd	ra,40(sp)
    800028d0:	f022                	sd	s0,32(sp)
    800028d2:	ec26                	sd	s1,24(sp)
    800028d4:	e84a                	sd	s2,16(sp)
    800028d6:	e44e                	sd	s3,8(sp)
    800028d8:	e052                	sd	s4,0(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028de:	47ad                	li	a5,11
    800028e0:	04b7fe63          	bgeu	a5,a1,8000293c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028e4:	ff45849b          	addiw	s1,a1,-12
    800028e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028ec:	0ff00793          	li	a5,255
    800028f0:	0ae7e363          	bltu	a5,a4,80002996 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028f4:	08052583          	lw	a1,128(a0)
    800028f8:	c5ad                	beqz	a1,80002962 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028fa:	00092503          	lw	a0,0(s2)
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	bda080e7          	jalr	-1062(ra) # 800024d8 <bread>
    80002906:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002908:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000290c:	02049593          	slli	a1,s1,0x20
    80002910:	9181                	srli	a1,a1,0x20
    80002912:	058a                	slli	a1,a1,0x2
    80002914:	00b784b3          	add	s1,a5,a1
    80002918:	0004a983          	lw	s3,0(s1)
    8000291c:	04098d63          	beqz	s3,80002976 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002920:	8552                	mv	a0,s4
    80002922:	00000097          	auipc	ra,0x0
    80002926:	ce6080e7          	jalr	-794(ra) # 80002608 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000292a:	854e                	mv	a0,s3
    8000292c:	70a2                	ld	ra,40(sp)
    8000292e:	7402                	ld	s0,32(sp)
    80002930:	64e2                	ld	s1,24(sp)
    80002932:	6942                	ld	s2,16(sp)
    80002934:	69a2                	ld	s3,8(sp)
    80002936:	6a02                	ld	s4,0(sp)
    80002938:	6145                	addi	sp,sp,48
    8000293a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000293c:	02059493          	slli	s1,a1,0x20
    80002940:	9081                	srli	s1,s1,0x20
    80002942:	048a                	slli	s1,s1,0x2
    80002944:	94aa                	add	s1,s1,a0
    80002946:	0504a983          	lw	s3,80(s1)
    8000294a:	fe0990e3          	bnez	s3,8000292a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000294e:	4108                	lw	a0,0(a0)
    80002950:	00000097          	auipc	ra,0x0
    80002954:	e4a080e7          	jalr	-438(ra) # 8000279a <balloc>
    80002958:	0005099b          	sext.w	s3,a0
    8000295c:	0534a823          	sw	s3,80(s1)
    80002960:	b7e9                	j	8000292a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002962:	4108                	lw	a0,0(a0)
    80002964:	00000097          	auipc	ra,0x0
    80002968:	e36080e7          	jalr	-458(ra) # 8000279a <balloc>
    8000296c:	0005059b          	sext.w	a1,a0
    80002970:	08b92023          	sw	a1,128(s2)
    80002974:	b759                	j	800028fa <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002976:	00092503          	lw	a0,0(s2)
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	e20080e7          	jalr	-480(ra) # 8000279a <balloc>
    80002982:	0005099b          	sext.w	s3,a0
    80002986:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000298a:	8552                	mv	a0,s4
    8000298c:	00001097          	auipc	ra,0x1
    80002990:	ef8080e7          	jalr	-264(ra) # 80003884 <log_write>
    80002994:	b771                	j	80002920 <bmap+0x54>
  panic("bmap: out of range");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	be250513          	addi	a0,a0,-1054 # 80008578 <syscalls+0x118>
    8000299e:	00003097          	auipc	ra,0x3
    800029a2:	3ea080e7          	jalr	1002(ra) # 80005d88 <panic>

00000000800029a6 <iget>:
{
    800029a6:	7179                	addi	sp,sp,-48
    800029a8:	f406                	sd	ra,40(sp)
    800029aa:	f022                	sd	s0,32(sp)
    800029ac:	ec26                	sd	s1,24(sp)
    800029ae:	e84a                	sd	s2,16(sp)
    800029b0:	e44e                	sd	s3,8(sp)
    800029b2:	e052                	sd	s4,0(sp)
    800029b4:	1800                	addi	s0,sp,48
    800029b6:	89aa                	mv	s3,a0
    800029b8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ba:	00015517          	auipc	a0,0x15
    800029be:	bbe50513          	addi	a0,a0,-1090 # 80017578 <itable>
    800029c2:	00004097          	auipc	ra,0x4
    800029c6:	910080e7          	jalr	-1776(ra) # 800062d2 <acquire>
  empty = 0;
    800029ca:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029cc:	00015497          	auipc	s1,0x15
    800029d0:	bc448493          	addi	s1,s1,-1084 # 80017590 <itable+0x18>
    800029d4:	00016697          	auipc	a3,0x16
    800029d8:	64c68693          	addi	a3,a3,1612 # 80019020 <log>
    800029dc:	a039                	j	800029ea <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029de:	02090b63          	beqz	s2,80002a14 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029e2:	08848493          	addi	s1,s1,136
    800029e6:	02d48a63          	beq	s1,a3,80002a1a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029ea:	449c                	lw	a5,8(s1)
    800029ec:	fef059e3          	blez	a5,800029de <iget+0x38>
    800029f0:	4098                	lw	a4,0(s1)
    800029f2:	ff3716e3          	bne	a4,s3,800029de <iget+0x38>
    800029f6:	40d8                	lw	a4,4(s1)
    800029f8:	ff4713e3          	bne	a4,s4,800029de <iget+0x38>
      ip->ref++;
    800029fc:	2785                	addiw	a5,a5,1
    800029fe:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a00:	00015517          	auipc	a0,0x15
    80002a04:	b7850513          	addi	a0,a0,-1160 # 80017578 <itable>
    80002a08:	00004097          	auipc	ra,0x4
    80002a0c:	97e080e7          	jalr	-1666(ra) # 80006386 <release>
      return ip;
    80002a10:	8926                	mv	s2,s1
    80002a12:	a03d                	j	80002a40 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a14:	f7f9                	bnez	a5,800029e2 <iget+0x3c>
    80002a16:	8926                	mv	s2,s1
    80002a18:	b7e9                	j	800029e2 <iget+0x3c>
  if(empty == 0)
    80002a1a:	02090c63          	beqz	s2,80002a52 <iget+0xac>
  ip->dev = dev;
    80002a1e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a22:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a26:	4785                	li	a5,1
    80002a28:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a2c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a30:	00015517          	auipc	a0,0x15
    80002a34:	b4850513          	addi	a0,a0,-1208 # 80017578 <itable>
    80002a38:	00004097          	auipc	ra,0x4
    80002a3c:	94e080e7          	jalr	-1714(ra) # 80006386 <release>
}
    80002a40:	854a                	mv	a0,s2
    80002a42:	70a2                	ld	ra,40(sp)
    80002a44:	7402                	ld	s0,32(sp)
    80002a46:	64e2                	ld	s1,24(sp)
    80002a48:	6942                	ld	s2,16(sp)
    80002a4a:	69a2                	ld	s3,8(sp)
    80002a4c:	6a02                	ld	s4,0(sp)
    80002a4e:	6145                	addi	sp,sp,48
    80002a50:	8082                	ret
    panic("iget: no inodes");
    80002a52:	00006517          	auipc	a0,0x6
    80002a56:	b3e50513          	addi	a0,a0,-1218 # 80008590 <syscalls+0x130>
    80002a5a:	00003097          	auipc	ra,0x3
    80002a5e:	32e080e7          	jalr	814(ra) # 80005d88 <panic>

0000000080002a62 <fsinit>:
fsinit(int dev) {
    80002a62:	7179                	addi	sp,sp,-48
    80002a64:	f406                	sd	ra,40(sp)
    80002a66:	f022                	sd	s0,32(sp)
    80002a68:	ec26                	sd	s1,24(sp)
    80002a6a:	e84a                	sd	s2,16(sp)
    80002a6c:	e44e                	sd	s3,8(sp)
    80002a6e:	1800                	addi	s0,sp,48
    80002a70:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a72:	4585                	li	a1,1
    80002a74:	00000097          	auipc	ra,0x0
    80002a78:	a64080e7          	jalr	-1436(ra) # 800024d8 <bread>
    80002a7c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a7e:	00015997          	auipc	s3,0x15
    80002a82:	ada98993          	addi	s3,s3,-1318 # 80017558 <sb>
    80002a86:	02000613          	li	a2,32
    80002a8a:	05850593          	addi	a1,a0,88
    80002a8e:	854e                	mv	a0,s3
    80002a90:	ffffd097          	auipc	ra,0xffffd
    80002a94:	760080e7          	jalr	1888(ra) # 800001f0 <memmove>
  brelse(bp);
    80002a98:	8526                	mv	a0,s1
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	b6e080e7          	jalr	-1170(ra) # 80002608 <brelse>
  if(sb.magic != FSMAGIC)
    80002aa2:	0009a703          	lw	a4,0(s3)
    80002aa6:	102037b7          	lui	a5,0x10203
    80002aaa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002aae:	02f71263          	bne	a4,a5,80002ad2 <fsinit+0x70>
  initlog(dev, &sb);
    80002ab2:	00015597          	auipc	a1,0x15
    80002ab6:	aa658593          	addi	a1,a1,-1370 # 80017558 <sb>
    80002aba:	854a                	mv	a0,s2
    80002abc:	00001097          	auipc	ra,0x1
    80002ac0:	b4c080e7          	jalr	-1204(ra) # 80003608 <initlog>
}
    80002ac4:	70a2                	ld	ra,40(sp)
    80002ac6:	7402                	ld	s0,32(sp)
    80002ac8:	64e2                	ld	s1,24(sp)
    80002aca:	6942                	ld	s2,16(sp)
    80002acc:	69a2                	ld	s3,8(sp)
    80002ace:	6145                	addi	sp,sp,48
    80002ad0:	8082                	ret
    panic("invalid file system");
    80002ad2:	00006517          	auipc	a0,0x6
    80002ad6:	ace50513          	addi	a0,a0,-1330 # 800085a0 <syscalls+0x140>
    80002ada:	00003097          	auipc	ra,0x3
    80002ade:	2ae080e7          	jalr	686(ra) # 80005d88 <panic>

0000000080002ae2 <iinit>:
{
    80002ae2:	7179                	addi	sp,sp,-48
    80002ae4:	f406                	sd	ra,40(sp)
    80002ae6:	f022                	sd	s0,32(sp)
    80002ae8:	ec26                	sd	s1,24(sp)
    80002aea:	e84a                	sd	s2,16(sp)
    80002aec:	e44e                	sd	s3,8(sp)
    80002aee:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002af0:	00006597          	auipc	a1,0x6
    80002af4:	ac858593          	addi	a1,a1,-1336 # 800085b8 <syscalls+0x158>
    80002af8:	00015517          	auipc	a0,0x15
    80002afc:	a8050513          	addi	a0,a0,-1408 # 80017578 <itable>
    80002b00:	00003097          	auipc	ra,0x3
    80002b04:	742080e7          	jalr	1858(ra) # 80006242 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b08:	00015497          	auipc	s1,0x15
    80002b0c:	a9848493          	addi	s1,s1,-1384 # 800175a0 <itable+0x28>
    80002b10:	00016997          	auipc	s3,0x16
    80002b14:	52098993          	addi	s3,s3,1312 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b18:	00006917          	auipc	s2,0x6
    80002b1c:	aa890913          	addi	s2,s2,-1368 # 800085c0 <syscalls+0x160>
    80002b20:	85ca                	mv	a1,s2
    80002b22:	8526                	mv	a0,s1
    80002b24:	00001097          	auipc	ra,0x1
    80002b28:	e46080e7          	jalr	-442(ra) # 8000396a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b2c:	08848493          	addi	s1,s1,136
    80002b30:	ff3498e3          	bne	s1,s3,80002b20 <iinit+0x3e>
}
    80002b34:	70a2                	ld	ra,40(sp)
    80002b36:	7402                	ld	s0,32(sp)
    80002b38:	64e2                	ld	s1,24(sp)
    80002b3a:	6942                	ld	s2,16(sp)
    80002b3c:	69a2                	ld	s3,8(sp)
    80002b3e:	6145                	addi	sp,sp,48
    80002b40:	8082                	ret

0000000080002b42 <ialloc>:
{
    80002b42:	715d                	addi	sp,sp,-80
    80002b44:	e486                	sd	ra,72(sp)
    80002b46:	e0a2                	sd	s0,64(sp)
    80002b48:	fc26                	sd	s1,56(sp)
    80002b4a:	f84a                	sd	s2,48(sp)
    80002b4c:	f44e                	sd	s3,40(sp)
    80002b4e:	f052                	sd	s4,32(sp)
    80002b50:	ec56                	sd	s5,24(sp)
    80002b52:	e85a                	sd	s6,16(sp)
    80002b54:	e45e                	sd	s7,8(sp)
    80002b56:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b58:	00015717          	auipc	a4,0x15
    80002b5c:	a0c72703          	lw	a4,-1524(a4) # 80017564 <sb+0xc>
    80002b60:	4785                	li	a5,1
    80002b62:	04e7fa63          	bgeu	a5,a4,80002bb6 <ialloc+0x74>
    80002b66:	8aaa                	mv	s5,a0
    80002b68:	8bae                	mv	s7,a1
    80002b6a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b6c:	00015a17          	auipc	s4,0x15
    80002b70:	9eca0a13          	addi	s4,s4,-1556 # 80017558 <sb>
    80002b74:	00048b1b          	sext.w	s6,s1
    80002b78:	0044d593          	srli	a1,s1,0x4
    80002b7c:	018a2783          	lw	a5,24(s4)
    80002b80:	9dbd                	addw	a1,a1,a5
    80002b82:	8556                	mv	a0,s5
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	954080e7          	jalr	-1708(ra) # 800024d8 <bread>
    80002b8c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b8e:	05850993          	addi	s3,a0,88
    80002b92:	00f4f793          	andi	a5,s1,15
    80002b96:	079a                	slli	a5,a5,0x6
    80002b98:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b9a:	00099783          	lh	a5,0(s3)
    80002b9e:	c785                	beqz	a5,80002bc6 <ialloc+0x84>
    brelse(bp);
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	a68080e7          	jalr	-1432(ra) # 80002608 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba8:	0485                	addi	s1,s1,1
    80002baa:	00ca2703          	lw	a4,12(s4)
    80002bae:	0004879b          	sext.w	a5,s1
    80002bb2:	fce7e1e3          	bltu	a5,a4,80002b74 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bb6:	00006517          	auipc	a0,0x6
    80002bba:	a1250513          	addi	a0,a0,-1518 # 800085c8 <syscalls+0x168>
    80002bbe:	00003097          	auipc	ra,0x3
    80002bc2:	1ca080e7          	jalr	458(ra) # 80005d88 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bc6:	04000613          	li	a2,64
    80002bca:	4581                	li	a1,0
    80002bcc:	854e                	mv	a0,s3
    80002bce:	ffffd097          	auipc	ra,0xffffd
    80002bd2:	5c2080e7          	jalr	1474(ra) # 80000190 <memset>
      dip->type = type;
    80002bd6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bda:	854a                	mv	a0,s2
    80002bdc:	00001097          	auipc	ra,0x1
    80002be0:	ca8080e7          	jalr	-856(ra) # 80003884 <log_write>
      brelse(bp);
    80002be4:	854a                	mv	a0,s2
    80002be6:	00000097          	auipc	ra,0x0
    80002bea:	a22080e7          	jalr	-1502(ra) # 80002608 <brelse>
      return iget(dev, inum);
    80002bee:	85da                	mv	a1,s6
    80002bf0:	8556                	mv	a0,s5
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	db4080e7          	jalr	-588(ra) # 800029a6 <iget>
}
    80002bfa:	60a6                	ld	ra,72(sp)
    80002bfc:	6406                	ld	s0,64(sp)
    80002bfe:	74e2                	ld	s1,56(sp)
    80002c00:	7942                	ld	s2,48(sp)
    80002c02:	79a2                	ld	s3,40(sp)
    80002c04:	7a02                	ld	s4,32(sp)
    80002c06:	6ae2                	ld	s5,24(sp)
    80002c08:	6b42                	ld	s6,16(sp)
    80002c0a:	6ba2                	ld	s7,8(sp)
    80002c0c:	6161                	addi	sp,sp,80
    80002c0e:	8082                	ret

0000000080002c10 <iupdate>:
{
    80002c10:	1101                	addi	sp,sp,-32
    80002c12:	ec06                	sd	ra,24(sp)
    80002c14:	e822                	sd	s0,16(sp)
    80002c16:	e426                	sd	s1,8(sp)
    80002c18:	e04a                	sd	s2,0(sp)
    80002c1a:	1000                	addi	s0,sp,32
    80002c1c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c1e:	415c                	lw	a5,4(a0)
    80002c20:	0047d79b          	srliw	a5,a5,0x4
    80002c24:	00015597          	auipc	a1,0x15
    80002c28:	94c5a583          	lw	a1,-1716(a1) # 80017570 <sb+0x18>
    80002c2c:	9dbd                	addw	a1,a1,a5
    80002c2e:	4108                	lw	a0,0(a0)
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	8a8080e7          	jalr	-1880(ra) # 800024d8 <bread>
    80002c38:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c3a:	05850793          	addi	a5,a0,88
    80002c3e:	40c8                	lw	a0,4(s1)
    80002c40:	893d                	andi	a0,a0,15
    80002c42:	051a                	slli	a0,a0,0x6
    80002c44:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c46:	04449703          	lh	a4,68(s1)
    80002c4a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c4e:	04649703          	lh	a4,70(s1)
    80002c52:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c56:	04849703          	lh	a4,72(s1)
    80002c5a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c5e:	04a49703          	lh	a4,74(s1)
    80002c62:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c66:	44f8                	lw	a4,76(s1)
    80002c68:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c6a:	03400613          	li	a2,52
    80002c6e:	05048593          	addi	a1,s1,80
    80002c72:	0531                	addi	a0,a0,12
    80002c74:	ffffd097          	auipc	ra,0xffffd
    80002c78:	57c080e7          	jalr	1404(ra) # 800001f0 <memmove>
  log_write(bp);
    80002c7c:	854a                	mv	a0,s2
    80002c7e:	00001097          	auipc	ra,0x1
    80002c82:	c06080e7          	jalr	-1018(ra) # 80003884 <log_write>
  brelse(bp);
    80002c86:	854a                	mv	a0,s2
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	980080e7          	jalr	-1664(ra) # 80002608 <brelse>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret

0000000080002c9c <idup>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	1000                	addi	s0,sp,32
    80002ca6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca8:	00015517          	auipc	a0,0x15
    80002cac:	8d050513          	addi	a0,a0,-1840 # 80017578 <itable>
    80002cb0:	00003097          	auipc	ra,0x3
    80002cb4:	622080e7          	jalr	1570(ra) # 800062d2 <acquire>
  ip->ref++;
    80002cb8:	449c                	lw	a5,8(s1)
    80002cba:	2785                	addiw	a5,a5,1
    80002cbc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cbe:	00015517          	auipc	a0,0x15
    80002cc2:	8ba50513          	addi	a0,a0,-1862 # 80017578 <itable>
    80002cc6:	00003097          	auipc	ra,0x3
    80002cca:	6c0080e7          	jalr	1728(ra) # 80006386 <release>
}
    80002cce:	8526                	mv	a0,s1
    80002cd0:	60e2                	ld	ra,24(sp)
    80002cd2:	6442                	ld	s0,16(sp)
    80002cd4:	64a2                	ld	s1,8(sp)
    80002cd6:	6105                	addi	sp,sp,32
    80002cd8:	8082                	ret

0000000080002cda <ilock>:
{
    80002cda:	1101                	addi	sp,sp,-32
    80002cdc:	ec06                	sd	ra,24(sp)
    80002cde:	e822                	sd	s0,16(sp)
    80002ce0:	e426                	sd	s1,8(sp)
    80002ce2:	e04a                	sd	s2,0(sp)
    80002ce4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ce6:	c115                	beqz	a0,80002d0a <ilock+0x30>
    80002ce8:	84aa                	mv	s1,a0
    80002cea:	451c                	lw	a5,8(a0)
    80002cec:	00f05f63          	blez	a5,80002d0a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cf0:	0541                	addi	a0,a0,16
    80002cf2:	00001097          	auipc	ra,0x1
    80002cf6:	cb2080e7          	jalr	-846(ra) # 800039a4 <acquiresleep>
  if(ip->valid == 0){
    80002cfa:	40bc                	lw	a5,64(s1)
    80002cfc:	cf99                	beqz	a5,80002d1a <ilock+0x40>
}
    80002cfe:	60e2                	ld	ra,24(sp)
    80002d00:	6442                	ld	s0,16(sp)
    80002d02:	64a2                	ld	s1,8(sp)
    80002d04:	6902                	ld	s2,0(sp)
    80002d06:	6105                	addi	sp,sp,32
    80002d08:	8082                	ret
    panic("ilock");
    80002d0a:	00006517          	auipc	a0,0x6
    80002d0e:	8d650513          	addi	a0,a0,-1834 # 800085e0 <syscalls+0x180>
    80002d12:	00003097          	auipc	ra,0x3
    80002d16:	076080e7          	jalr	118(ra) # 80005d88 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d1a:	40dc                	lw	a5,4(s1)
    80002d1c:	0047d79b          	srliw	a5,a5,0x4
    80002d20:	00015597          	auipc	a1,0x15
    80002d24:	8505a583          	lw	a1,-1968(a1) # 80017570 <sb+0x18>
    80002d28:	9dbd                	addw	a1,a1,a5
    80002d2a:	4088                	lw	a0,0(s1)
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	7ac080e7          	jalr	1964(ra) # 800024d8 <bread>
    80002d34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d36:	05850593          	addi	a1,a0,88
    80002d3a:	40dc                	lw	a5,4(s1)
    80002d3c:	8bbd                	andi	a5,a5,15
    80002d3e:	079a                	slli	a5,a5,0x6
    80002d40:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d42:	00059783          	lh	a5,0(a1)
    80002d46:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d4a:	00259783          	lh	a5,2(a1)
    80002d4e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d52:	00459783          	lh	a5,4(a1)
    80002d56:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d5a:	00659783          	lh	a5,6(a1)
    80002d5e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d62:	459c                	lw	a5,8(a1)
    80002d64:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d66:	03400613          	li	a2,52
    80002d6a:	05b1                	addi	a1,a1,12
    80002d6c:	05048513          	addi	a0,s1,80
    80002d70:	ffffd097          	auipc	ra,0xffffd
    80002d74:	480080e7          	jalr	1152(ra) # 800001f0 <memmove>
    brelse(bp);
    80002d78:	854a                	mv	a0,s2
    80002d7a:	00000097          	auipc	ra,0x0
    80002d7e:	88e080e7          	jalr	-1906(ra) # 80002608 <brelse>
    ip->valid = 1;
    80002d82:	4785                	li	a5,1
    80002d84:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d86:	04449783          	lh	a5,68(s1)
    80002d8a:	fbb5                	bnez	a5,80002cfe <ilock+0x24>
      panic("ilock: no type");
    80002d8c:	00006517          	auipc	a0,0x6
    80002d90:	85c50513          	addi	a0,a0,-1956 # 800085e8 <syscalls+0x188>
    80002d94:	00003097          	auipc	ra,0x3
    80002d98:	ff4080e7          	jalr	-12(ra) # 80005d88 <panic>

0000000080002d9c <iunlock>:
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	e04a                	sd	s2,0(sp)
    80002da6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002da8:	c905                	beqz	a0,80002dd8 <iunlock+0x3c>
    80002daa:	84aa                	mv	s1,a0
    80002dac:	01050913          	addi	s2,a0,16
    80002db0:	854a                	mv	a0,s2
    80002db2:	00001097          	auipc	ra,0x1
    80002db6:	c8c080e7          	jalr	-884(ra) # 80003a3e <holdingsleep>
    80002dba:	cd19                	beqz	a0,80002dd8 <iunlock+0x3c>
    80002dbc:	449c                	lw	a5,8(s1)
    80002dbe:	00f05d63          	blez	a5,80002dd8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dc2:	854a                	mv	a0,s2
    80002dc4:	00001097          	auipc	ra,0x1
    80002dc8:	c36080e7          	jalr	-970(ra) # 800039fa <releasesleep>
}
    80002dcc:	60e2                	ld	ra,24(sp)
    80002dce:	6442                	ld	s0,16(sp)
    80002dd0:	64a2                	ld	s1,8(sp)
    80002dd2:	6902                	ld	s2,0(sp)
    80002dd4:	6105                	addi	sp,sp,32
    80002dd6:	8082                	ret
    panic("iunlock");
    80002dd8:	00006517          	auipc	a0,0x6
    80002ddc:	82050513          	addi	a0,a0,-2016 # 800085f8 <syscalls+0x198>
    80002de0:	00003097          	auipc	ra,0x3
    80002de4:	fa8080e7          	jalr	-88(ra) # 80005d88 <panic>

0000000080002de8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002de8:	7179                	addi	sp,sp,-48
    80002dea:	f406                	sd	ra,40(sp)
    80002dec:	f022                	sd	s0,32(sp)
    80002dee:	ec26                	sd	s1,24(sp)
    80002df0:	e84a                	sd	s2,16(sp)
    80002df2:	e44e                	sd	s3,8(sp)
    80002df4:	e052                	sd	s4,0(sp)
    80002df6:	1800                	addi	s0,sp,48
    80002df8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dfa:	05050493          	addi	s1,a0,80
    80002dfe:	08050913          	addi	s2,a0,128
    80002e02:	a021                	j	80002e0a <itrunc+0x22>
    80002e04:	0491                	addi	s1,s1,4
    80002e06:	01248d63          	beq	s1,s2,80002e20 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e0a:	408c                	lw	a1,0(s1)
    80002e0c:	dde5                	beqz	a1,80002e04 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	90c080e7          	jalr	-1780(ra) # 8000271e <bfree>
      ip->addrs[i] = 0;
    80002e1a:	0004a023          	sw	zero,0(s1)
    80002e1e:	b7dd                	j	80002e04 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e20:	0809a583          	lw	a1,128(s3)
    80002e24:	e185                	bnez	a1,80002e44 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e26:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e2a:	854e                	mv	a0,s3
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	de4080e7          	jalr	-540(ra) # 80002c10 <iupdate>
}
    80002e34:	70a2                	ld	ra,40(sp)
    80002e36:	7402                	ld	s0,32(sp)
    80002e38:	64e2                	ld	s1,24(sp)
    80002e3a:	6942                	ld	s2,16(sp)
    80002e3c:	69a2                	ld	s3,8(sp)
    80002e3e:	6a02                	ld	s4,0(sp)
    80002e40:	6145                	addi	sp,sp,48
    80002e42:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e44:	0009a503          	lw	a0,0(s3)
    80002e48:	fffff097          	auipc	ra,0xfffff
    80002e4c:	690080e7          	jalr	1680(ra) # 800024d8 <bread>
    80002e50:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e52:	05850493          	addi	s1,a0,88
    80002e56:	45850913          	addi	s2,a0,1112
    80002e5a:	a811                	j	80002e6e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e5c:	0009a503          	lw	a0,0(s3)
    80002e60:	00000097          	auipc	ra,0x0
    80002e64:	8be080e7          	jalr	-1858(ra) # 8000271e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e68:	0491                	addi	s1,s1,4
    80002e6a:	01248563          	beq	s1,s2,80002e74 <itrunc+0x8c>
      if(a[j])
    80002e6e:	408c                	lw	a1,0(s1)
    80002e70:	dde5                	beqz	a1,80002e68 <itrunc+0x80>
    80002e72:	b7ed                	j	80002e5c <itrunc+0x74>
    brelse(bp);
    80002e74:	8552                	mv	a0,s4
    80002e76:	fffff097          	auipc	ra,0xfffff
    80002e7a:	792080e7          	jalr	1938(ra) # 80002608 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e7e:	0809a583          	lw	a1,128(s3)
    80002e82:	0009a503          	lw	a0,0(s3)
    80002e86:	00000097          	auipc	ra,0x0
    80002e8a:	898080e7          	jalr	-1896(ra) # 8000271e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e8e:	0809a023          	sw	zero,128(s3)
    80002e92:	bf51                	j	80002e26 <itrunc+0x3e>

0000000080002e94 <iput>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	e04a                	sd	s2,0(sp)
    80002e9e:	1000                	addi	s0,sp,32
    80002ea0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ea2:	00014517          	auipc	a0,0x14
    80002ea6:	6d650513          	addi	a0,a0,1750 # 80017578 <itable>
    80002eaa:	00003097          	auipc	ra,0x3
    80002eae:	428080e7          	jalr	1064(ra) # 800062d2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eb2:	4498                	lw	a4,8(s1)
    80002eb4:	4785                	li	a5,1
    80002eb6:	02f70363          	beq	a4,a5,80002edc <iput+0x48>
  ip->ref--;
    80002eba:	449c                	lw	a5,8(s1)
    80002ebc:	37fd                	addiw	a5,a5,-1
    80002ebe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ec0:	00014517          	auipc	a0,0x14
    80002ec4:	6b850513          	addi	a0,a0,1720 # 80017578 <itable>
    80002ec8:	00003097          	auipc	ra,0x3
    80002ecc:	4be080e7          	jalr	1214(ra) # 80006386 <release>
}
    80002ed0:	60e2                	ld	ra,24(sp)
    80002ed2:	6442                	ld	s0,16(sp)
    80002ed4:	64a2                	ld	s1,8(sp)
    80002ed6:	6902                	ld	s2,0(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002edc:	40bc                	lw	a5,64(s1)
    80002ede:	dff1                	beqz	a5,80002eba <iput+0x26>
    80002ee0:	04a49783          	lh	a5,74(s1)
    80002ee4:	fbf9                	bnez	a5,80002eba <iput+0x26>
    acquiresleep(&ip->lock);
    80002ee6:	01048913          	addi	s2,s1,16
    80002eea:	854a                	mv	a0,s2
    80002eec:	00001097          	auipc	ra,0x1
    80002ef0:	ab8080e7          	jalr	-1352(ra) # 800039a4 <acquiresleep>
    release(&itable.lock);
    80002ef4:	00014517          	auipc	a0,0x14
    80002ef8:	68450513          	addi	a0,a0,1668 # 80017578 <itable>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	48a080e7          	jalr	1162(ra) # 80006386 <release>
    itrunc(ip);
    80002f04:	8526                	mv	a0,s1
    80002f06:	00000097          	auipc	ra,0x0
    80002f0a:	ee2080e7          	jalr	-286(ra) # 80002de8 <itrunc>
    ip->type = 0;
    80002f0e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f12:	8526                	mv	a0,s1
    80002f14:	00000097          	auipc	ra,0x0
    80002f18:	cfc080e7          	jalr	-772(ra) # 80002c10 <iupdate>
    ip->valid = 0;
    80002f1c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f20:	854a                	mv	a0,s2
    80002f22:	00001097          	auipc	ra,0x1
    80002f26:	ad8080e7          	jalr	-1320(ra) # 800039fa <releasesleep>
    acquire(&itable.lock);
    80002f2a:	00014517          	auipc	a0,0x14
    80002f2e:	64e50513          	addi	a0,a0,1614 # 80017578 <itable>
    80002f32:	00003097          	auipc	ra,0x3
    80002f36:	3a0080e7          	jalr	928(ra) # 800062d2 <acquire>
    80002f3a:	b741                	j	80002eba <iput+0x26>

0000000080002f3c <iunlockput>:
{
    80002f3c:	1101                	addi	sp,sp,-32
    80002f3e:	ec06                	sd	ra,24(sp)
    80002f40:	e822                	sd	s0,16(sp)
    80002f42:	e426                	sd	s1,8(sp)
    80002f44:	1000                	addi	s0,sp,32
    80002f46:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	e54080e7          	jalr	-428(ra) # 80002d9c <iunlock>
  iput(ip);
    80002f50:	8526                	mv	a0,s1
    80002f52:	00000097          	auipc	ra,0x0
    80002f56:	f42080e7          	jalr	-190(ra) # 80002e94 <iput>
}
    80002f5a:	60e2                	ld	ra,24(sp)
    80002f5c:	6442                	ld	s0,16(sp)
    80002f5e:	64a2                	ld	s1,8(sp)
    80002f60:	6105                	addi	sp,sp,32
    80002f62:	8082                	ret

0000000080002f64 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f64:	1141                	addi	sp,sp,-16
    80002f66:	e422                	sd	s0,8(sp)
    80002f68:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f6a:	411c                	lw	a5,0(a0)
    80002f6c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f6e:	415c                	lw	a5,4(a0)
    80002f70:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f72:	04451783          	lh	a5,68(a0)
    80002f76:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f7a:	04a51783          	lh	a5,74(a0)
    80002f7e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f82:	04c56783          	lwu	a5,76(a0)
    80002f86:	e99c                	sd	a5,16(a1)
}
    80002f88:	6422                	ld	s0,8(sp)
    80002f8a:	0141                	addi	sp,sp,16
    80002f8c:	8082                	ret

0000000080002f8e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f8e:	457c                	lw	a5,76(a0)
    80002f90:	0ed7e963          	bltu	a5,a3,80003082 <readi+0xf4>
{
    80002f94:	7159                	addi	sp,sp,-112
    80002f96:	f486                	sd	ra,104(sp)
    80002f98:	f0a2                	sd	s0,96(sp)
    80002f9a:	eca6                	sd	s1,88(sp)
    80002f9c:	e8ca                	sd	s2,80(sp)
    80002f9e:	e4ce                	sd	s3,72(sp)
    80002fa0:	e0d2                	sd	s4,64(sp)
    80002fa2:	fc56                	sd	s5,56(sp)
    80002fa4:	f85a                	sd	s6,48(sp)
    80002fa6:	f45e                	sd	s7,40(sp)
    80002fa8:	f062                	sd	s8,32(sp)
    80002faa:	ec66                	sd	s9,24(sp)
    80002fac:	e86a                	sd	s10,16(sp)
    80002fae:	e46e                	sd	s11,8(sp)
    80002fb0:	1880                	addi	s0,sp,112
    80002fb2:	8baa                	mv	s7,a0
    80002fb4:	8c2e                	mv	s8,a1
    80002fb6:	8ab2                	mv	s5,a2
    80002fb8:	84b6                	mv	s1,a3
    80002fba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fbc:	9f35                	addw	a4,a4,a3
    return 0;
    80002fbe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fc0:	0ad76063          	bltu	a4,a3,80003060 <readi+0xd2>
  if(off + n > ip->size)
    80002fc4:	00e7f463          	bgeu	a5,a4,80002fcc <readi+0x3e>
    n = ip->size - off;
    80002fc8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fcc:	0a0b0963          	beqz	s6,8000307e <readi+0xf0>
    80002fd0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fd6:	5cfd                	li	s9,-1
    80002fd8:	a82d                	j	80003012 <readi+0x84>
    80002fda:	020a1d93          	slli	s11,s4,0x20
    80002fde:	020ddd93          	srli	s11,s11,0x20
    80002fe2:	05890613          	addi	a2,s2,88
    80002fe6:	86ee                	mv	a3,s11
    80002fe8:	963a                	add	a2,a2,a4
    80002fea:	85d6                	mv	a1,s5
    80002fec:	8562                	mv	a0,s8
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	a04080e7          	jalr	-1532(ra) # 800019f2 <either_copyout>
    80002ff6:	05950d63          	beq	a0,s9,80003050 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	60c080e7          	jalr	1548(ra) # 80002608 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003004:	013a09bb          	addw	s3,s4,s3
    80003008:	009a04bb          	addw	s1,s4,s1
    8000300c:	9aee                	add	s5,s5,s11
    8000300e:	0569f763          	bgeu	s3,s6,8000305c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003012:	000ba903          	lw	s2,0(s7)
    80003016:	00a4d59b          	srliw	a1,s1,0xa
    8000301a:	855e                	mv	a0,s7
    8000301c:	00000097          	auipc	ra,0x0
    80003020:	8b0080e7          	jalr	-1872(ra) # 800028cc <bmap>
    80003024:	0005059b          	sext.w	a1,a0
    80003028:	854a                	mv	a0,s2
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	4ae080e7          	jalr	1198(ra) # 800024d8 <bread>
    80003032:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003034:	3ff4f713          	andi	a4,s1,1023
    80003038:	40ed07bb          	subw	a5,s10,a4
    8000303c:	413b06bb          	subw	a3,s6,s3
    80003040:	8a3e                	mv	s4,a5
    80003042:	2781                	sext.w	a5,a5
    80003044:	0006861b          	sext.w	a2,a3
    80003048:	f8f679e3          	bgeu	a2,a5,80002fda <readi+0x4c>
    8000304c:	8a36                	mv	s4,a3
    8000304e:	b771                	j	80002fda <readi+0x4c>
      brelse(bp);
    80003050:	854a                	mv	a0,s2
    80003052:	fffff097          	auipc	ra,0xfffff
    80003056:	5b6080e7          	jalr	1462(ra) # 80002608 <brelse>
      tot = -1;
    8000305a:	59fd                	li	s3,-1
  }
  return tot;
    8000305c:	0009851b          	sext.w	a0,s3
}
    80003060:	70a6                	ld	ra,104(sp)
    80003062:	7406                	ld	s0,96(sp)
    80003064:	64e6                	ld	s1,88(sp)
    80003066:	6946                	ld	s2,80(sp)
    80003068:	69a6                	ld	s3,72(sp)
    8000306a:	6a06                	ld	s4,64(sp)
    8000306c:	7ae2                	ld	s5,56(sp)
    8000306e:	7b42                	ld	s6,48(sp)
    80003070:	7ba2                	ld	s7,40(sp)
    80003072:	7c02                	ld	s8,32(sp)
    80003074:	6ce2                	ld	s9,24(sp)
    80003076:	6d42                	ld	s10,16(sp)
    80003078:	6da2                	ld	s11,8(sp)
    8000307a:	6165                	addi	sp,sp,112
    8000307c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000307e:	89da                	mv	s3,s6
    80003080:	bff1                	j	8000305c <readi+0xce>
    return 0;
    80003082:	4501                	li	a0,0
}
    80003084:	8082                	ret

0000000080003086 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003086:	457c                	lw	a5,76(a0)
    80003088:	10d7e863          	bltu	a5,a3,80003198 <writei+0x112>
{
    8000308c:	7159                	addi	sp,sp,-112
    8000308e:	f486                	sd	ra,104(sp)
    80003090:	f0a2                	sd	s0,96(sp)
    80003092:	eca6                	sd	s1,88(sp)
    80003094:	e8ca                	sd	s2,80(sp)
    80003096:	e4ce                	sd	s3,72(sp)
    80003098:	e0d2                	sd	s4,64(sp)
    8000309a:	fc56                	sd	s5,56(sp)
    8000309c:	f85a                	sd	s6,48(sp)
    8000309e:	f45e                	sd	s7,40(sp)
    800030a0:	f062                	sd	s8,32(sp)
    800030a2:	ec66                	sd	s9,24(sp)
    800030a4:	e86a                	sd	s10,16(sp)
    800030a6:	e46e                	sd	s11,8(sp)
    800030a8:	1880                	addi	s0,sp,112
    800030aa:	8b2a                	mv	s6,a0
    800030ac:	8c2e                	mv	s8,a1
    800030ae:	8ab2                	mv	s5,a2
    800030b0:	8936                	mv	s2,a3
    800030b2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030b4:	00e687bb          	addw	a5,a3,a4
    800030b8:	0ed7e263          	bltu	a5,a3,8000319c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030bc:	00043737          	lui	a4,0x43
    800030c0:	0ef76063          	bltu	a4,a5,800031a0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c4:	0c0b8863          	beqz	s7,80003194 <writei+0x10e>
    800030c8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ca:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030ce:	5cfd                	li	s9,-1
    800030d0:	a091                	j	80003114 <writei+0x8e>
    800030d2:	02099d93          	slli	s11,s3,0x20
    800030d6:	020ddd93          	srli	s11,s11,0x20
    800030da:	05848513          	addi	a0,s1,88
    800030de:	86ee                	mv	a3,s11
    800030e0:	8656                	mv	a2,s5
    800030e2:	85e2                	mv	a1,s8
    800030e4:	953a                	add	a0,a0,a4
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	962080e7          	jalr	-1694(ra) # 80001a48 <either_copyin>
    800030ee:	07950263          	beq	a0,s9,80003152 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030f2:	8526                	mv	a0,s1
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	790080e7          	jalr	1936(ra) # 80003884 <log_write>
    brelse(bp);
    800030fc:	8526                	mv	a0,s1
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	50a080e7          	jalr	1290(ra) # 80002608 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003106:	01498a3b          	addw	s4,s3,s4
    8000310a:	0129893b          	addw	s2,s3,s2
    8000310e:	9aee                	add	s5,s5,s11
    80003110:	057a7663          	bgeu	s4,s7,8000315c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003114:	000b2483          	lw	s1,0(s6)
    80003118:	00a9559b          	srliw	a1,s2,0xa
    8000311c:	855a                	mv	a0,s6
    8000311e:	fffff097          	auipc	ra,0xfffff
    80003122:	7ae080e7          	jalr	1966(ra) # 800028cc <bmap>
    80003126:	0005059b          	sext.w	a1,a0
    8000312a:	8526                	mv	a0,s1
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	3ac080e7          	jalr	940(ra) # 800024d8 <bread>
    80003134:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003136:	3ff97713          	andi	a4,s2,1023
    8000313a:	40ed07bb          	subw	a5,s10,a4
    8000313e:	414b86bb          	subw	a3,s7,s4
    80003142:	89be                	mv	s3,a5
    80003144:	2781                	sext.w	a5,a5
    80003146:	0006861b          	sext.w	a2,a3
    8000314a:	f8f674e3          	bgeu	a2,a5,800030d2 <writei+0x4c>
    8000314e:	89b6                	mv	s3,a3
    80003150:	b749                	j	800030d2 <writei+0x4c>
      brelse(bp);
    80003152:	8526                	mv	a0,s1
    80003154:	fffff097          	auipc	ra,0xfffff
    80003158:	4b4080e7          	jalr	1204(ra) # 80002608 <brelse>
  }

  if(off > ip->size)
    8000315c:	04cb2783          	lw	a5,76(s6)
    80003160:	0127f463          	bgeu	a5,s2,80003168 <writei+0xe2>
    ip->size = off;
    80003164:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003168:	855a                	mv	a0,s6
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	aa6080e7          	jalr	-1370(ra) # 80002c10 <iupdate>

  return tot;
    80003172:	000a051b          	sext.w	a0,s4
}
    80003176:	70a6                	ld	ra,104(sp)
    80003178:	7406                	ld	s0,96(sp)
    8000317a:	64e6                	ld	s1,88(sp)
    8000317c:	6946                	ld	s2,80(sp)
    8000317e:	69a6                	ld	s3,72(sp)
    80003180:	6a06                	ld	s4,64(sp)
    80003182:	7ae2                	ld	s5,56(sp)
    80003184:	7b42                	ld	s6,48(sp)
    80003186:	7ba2                	ld	s7,40(sp)
    80003188:	7c02                	ld	s8,32(sp)
    8000318a:	6ce2                	ld	s9,24(sp)
    8000318c:	6d42                	ld	s10,16(sp)
    8000318e:	6da2                	ld	s11,8(sp)
    80003190:	6165                	addi	sp,sp,112
    80003192:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003194:	8a5e                	mv	s4,s7
    80003196:	bfc9                	j	80003168 <writei+0xe2>
    return -1;
    80003198:	557d                	li	a0,-1
}
    8000319a:	8082                	ret
    return -1;
    8000319c:	557d                	li	a0,-1
    8000319e:	bfe1                	j	80003176 <writei+0xf0>
    return -1;
    800031a0:	557d                	li	a0,-1
    800031a2:	bfd1                	j	80003176 <writei+0xf0>

00000000800031a4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031a4:	1141                	addi	sp,sp,-16
    800031a6:	e406                	sd	ra,8(sp)
    800031a8:	e022                	sd	s0,0(sp)
    800031aa:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031ac:	4639                	li	a2,14
    800031ae:	ffffd097          	auipc	ra,0xffffd
    800031b2:	0ba080e7          	jalr	186(ra) # 80000268 <strncmp>
}
    800031b6:	60a2                	ld	ra,8(sp)
    800031b8:	6402                	ld	s0,0(sp)
    800031ba:	0141                	addi	sp,sp,16
    800031bc:	8082                	ret

00000000800031be <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031be:	7139                	addi	sp,sp,-64
    800031c0:	fc06                	sd	ra,56(sp)
    800031c2:	f822                	sd	s0,48(sp)
    800031c4:	f426                	sd	s1,40(sp)
    800031c6:	f04a                	sd	s2,32(sp)
    800031c8:	ec4e                	sd	s3,24(sp)
    800031ca:	e852                	sd	s4,16(sp)
    800031cc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031ce:	04451703          	lh	a4,68(a0)
    800031d2:	4785                	li	a5,1
    800031d4:	00f71a63          	bne	a4,a5,800031e8 <dirlookup+0x2a>
    800031d8:	892a                	mv	s2,a0
    800031da:	89ae                	mv	s3,a1
    800031dc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031de:	457c                	lw	a5,76(a0)
    800031e0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031e2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e4:	e79d                	bnez	a5,80003212 <dirlookup+0x54>
    800031e6:	a8a5                	j	8000325e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031e8:	00005517          	auipc	a0,0x5
    800031ec:	41850513          	addi	a0,a0,1048 # 80008600 <syscalls+0x1a0>
    800031f0:	00003097          	auipc	ra,0x3
    800031f4:	b98080e7          	jalr	-1128(ra) # 80005d88 <panic>
      panic("dirlookup read");
    800031f8:	00005517          	auipc	a0,0x5
    800031fc:	42050513          	addi	a0,a0,1056 # 80008618 <syscalls+0x1b8>
    80003200:	00003097          	auipc	ra,0x3
    80003204:	b88080e7          	jalr	-1144(ra) # 80005d88 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003208:	24c1                	addiw	s1,s1,16
    8000320a:	04c92783          	lw	a5,76(s2)
    8000320e:	04f4f763          	bgeu	s1,a5,8000325c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003212:	4741                	li	a4,16
    80003214:	86a6                	mv	a3,s1
    80003216:	fc040613          	addi	a2,s0,-64
    8000321a:	4581                	li	a1,0
    8000321c:	854a                	mv	a0,s2
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	d70080e7          	jalr	-656(ra) # 80002f8e <readi>
    80003226:	47c1                	li	a5,16
    80003228:	fcf518e3          	bne	a0,a5,800031f8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000322c:	fc045783          	lhu	a5,-64(s0)
    80003230:	dfe1                	beqz	a5,80003208 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003232:	fc240593          	addi	a1,s0,-62
    80003236:	854e                	mv	a0,s3
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	f6c080e7          	jalr	-148(ra) # 800031a4 <namecmp>
    80003240:	f561                	bnez	a0,80003208 <dirlookup+0x4a>
      if(poff)
    80003242:	000a0463          	beqz	s4,8000324a <dirlookup+0x8c>
        *poff = off;
    80003246:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000324a:	fc045583          	lhu	a1,-64(s0)
    8000324e:	00092503          	lw	a0,0(s2)
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	754080e7          	jalr	1876(ra) # 800029a6 <iget>
    8000325a:	a011                	j	8000325e <dirlookup+0xa0>
  return 0;
    8000325c:	4501                	li	a0,0
}
    8000325e:	70e2                	ld	ra,56(sp)
    80003260:	7442                	ld	s0,48(sp)
    80003262:	74a2                	ld	s1,40(sp)
    80003264:	7902                	ld	s2,32(sp)
    80003266:	69e2                	ld	s3,24(sp)
    80003268:	6a42                	ld	s4,16(sp)
    8000326a:	6121                	addi	sp,sp,64
    8000326c:	8082                	ret

000000008000326e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000326e:	711d                	addi	sp,sp,-96
    80003270:	ec86                	sd	ra,88(sp)
    80003272:	e8a2                	sd	s0,80(sp)
    80003274:	e4a6                	sd	s1,72(sp)
    80003276:	e0ca                	sd	s2,64(sp)
    80003278:	fc4e                	sd	s3,56(sp)
    8000327a:	f852                	sd	s4,48(sp)
    8000327c:	f456                	sd	s5,40(sp)
    8000327e:	f05a                	sd	s6,32(sp)
    80003280:	ec5e                	sd	s7,24(sp)
    80003282:	e862                	sd	s8,16(sp)
    80003284:	e466                	sd	s9,8(sp)
    80003286:	1080                	addi	s0,sp,96
    80003288:	84aa                	mv	s1,a0
    8000328a:	8b2e                	mv	s6,a1
    8000328c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000328e:	00054703          	lbu	a4,0(a0)
    80003292:	02f00793          	li	a5,47
    80003296:	02f70363          	beq	a4,a5,800032bc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000329a:	ffffe097          	auipc	ra,0xffffe
    8000329e:	cf8080e7          	jalr	-776(ra) # 80000f92 <myproc>
    800032a2:	15053503          	ld	a0,336(a0)
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	9f6080e7          	jalr	-1546(ra) # 80002c9c <idup>
    800032ae:	89aa                	mv	s3,a0
  while(*path == '/')
    800032b0:	02f00913          	li	s2,47
  len = path - s;
    800032b4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032b6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032b8:	4c05                	li	s8,1
    800032ba:	a865                	j	80003372 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032bc:	4585                	li	a1,1
    800032be:	4505                	li	a0,1
    800032c0:	fffff097          	auipc	ra,0xfffff
    800032c4:	6e6080e7          	jalr	1766(ra) # 800029a6 <iget>
    800032c8:	89aa                	mv	s3,a0
    800032ca:	b7dd                	j	800032b0 <namex+0x42>
      iunlockput(ip);
    800032cc:	854e                	mv	a0,s3
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	c6e080e7          	jalr	-914(ra) # 80002f3c <iunlockput>
      return 0;
    800032d6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032d8:	854e                	mv	a0,s3
    800032da:	60e6                	ld	ra,88(sp)
    800032dc:	6446                	ld	s0,80(sp)
    800032de:	64a6                	ld	s1,72(sp)
    800032e0:	6906                	ld	s2,64(sp)
    800032e2:	79e2                	ld	s3,56(sp)
    800032e4:	7a42                	ld	s4,48(sp)
    800032e6:	7aa2                	ld	s5,40(sp)
    800032e8:	7b02                	ld	s6,32(sp)
    800032ea:	6be2                	ld	s7,24(sp)
    800032ec:	6c42                	ld	s8,16(sp)
    800032ee:	6ca2                	ld	s9,8(sp)
    800032f0:	6125                	addi	sp,sp,96
    800032f2:	8082                	ret
      iunlock(ip);
    800032f4:	854e                	mv	a0,s3
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	aa6080e7          	jalr	-1370(ra) # 80002d9c <iunlock>
      return ip;
    800032fe:	bfe9                	j	800032d8 <namex+0x6a>
      iunlockput(ip);
    80003300:	854e                	mv	a0,s3
    80003302:	00000097          	auipc	ra,0x0
    80003306:	c3a080e7          	jalr	-966(ra) # 80002f3c <iunlockput>
      return 0;
    8000330a:	89d2                	mv	s3,s4
    8000330c:	b7f1                	j	800032d8 <namex+0x6a>
  len = path - s;
    8000330e:	40b48633          	sub	a2,s1,a1
    80003312:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003316:	094cd463          	bge	s9,s4,8000339e <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000331a:	4639                	li	a2,14
    8000331c:	8556                	mv	a0,s5
    8000331e:	ffffd097          	auipc	ra,0xffffd
    80003322:	ed2080e7          	jalr	-302(ra) # 800001f0 <memmove>
  while(*path == '/')
    80003326:	0004c783          	lbu	a5,0(s1)
    8000332a:	01279763          	bne	a5,s2,80003338 <namex+0xca>
    path++;
    8000332e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003330:	0004c783          	lbu	a5,0(s1)
    80003334:	ff278de3          	beq	a5,s2,8000332e <namex+0xc0>
    ilock(ip);
    80003338:	854e                	mv	a0,s3
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	9a0080e7          	jalr	-1632(ra) # 80002cda <ilock>
    if(ip->type != T_DIR){
    80003342:	04499783          	lh	a5,68(s3)
    80003346:	f98793e3          	bne	a5,s8,800032cc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000334a:	000b0563          	beqz	s6,80003354 <namex+0xe6>
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	d3cd                	beqz	a5,800032f4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003354:	865e                	mv	a2,s7
    80003356:	85d6                	mv	a1,s5
    80003358:	854e                	mv	a0,s3
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	e64080e7          	jalr	-412(ra) # 800031be <dirlookup>
    80003362:	8a2a                	mv	s4,a0
    80003364:	dd51                	beqz	a0,80003300 <namex+0x92>
    iunlockput(ip);
    80003366:	854e                	mv	a0,s3
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	bd4080e7          	jalr	-1068(ra) # 80002f3c <iunlockput>
    ip = next;
    80003370:	89d2                	mv	s3,s4
  while(*path == '/')
    80003372:	0004c783          	lbu	a5,0(s1)
    80003376:	05279763          	bne	a5,s2,800033c4 <namex+0x156>
    path++;
    8000337a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000337c:	0004c783          	lbu	a5,0(s1)
    80003380:	ff278de3          	beq	a5,s2,8000337a <namex+0x10c>
  if(*path == 0)
    80003384:	c79d                	beqz	a5,800033b2 <namex+0x144>
    path++;
    80003386:	85a6                	mv	a1,s1
  len = path - s;
    80003388:	8a5e                	mv	s4,s7
    8000338a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000338c:	01278963          	beq	a5,s2,8000339e <namex+0x130>
    80003390:	dfbd                	beqz	a5,8000330e <namex+0xa0>
    path++;
    80003392:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003394:	0004c783          	lbu	a5,0(s1)
    80003398:	ff279ce3          	bne	a5,s2,80003390 <namex+0x122>
    8000339c:	bf8d                	j	8000330e <namex+0xa0>
    memmove(name, s, len);
    8000339e:	2601                	sext.w	a2,a2
    800033a0:	8556                	mv	a0,s5
    800033a2:	ffffd097          	auipc	ra,0xffffd
    800033a6:	e4e080e7          	jalr	-434(ra) # 800001f0 <memmove>
    name[len] = 0;
    800033aa:	9a56                	add	s4,s4,s5
    800033ac:	000a0023          	sb	zero,0(s4)
    800033b0:	bf9d                	j	80003326 <namex+0xb8>
  if(nameiparent){
    800033b2:	f20b03e3          	beqz	s6,800032d8 <namex+0x6a>
    iput(ip);
    800033b6:	854e                	mv	a0,s3
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	adc080e7          	jalr	-1316(ra) # 80002e94 <iput>
    return 0;
    800033c0:	4981                	li	s3,0
    800033c2:	bf19                	j	800032d8 <namex+0x6a>
  if(*path == 0)
    800033c4:	d7fd                	beqz	a5,800033b2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	85a6                	mv	a1,s1
    800033cc:	b7d1                	j	80003390 <namex+0x122>

00000000800033ce <dirlink>:
{
    800033ce:	7139                	addi	sp,sp,-64
    800033d0:	fc06                	sd	ra,56(sp)
    800033d2:	f822                	sd	s0,48(sp)
    800033d4:	f426                	sd	s1,40(sp)
    800033d6:	f04a                	sd	s2,32(sp)
    800033d8:	ec4e                	sd	s3,24(sp)
    800033da:	e852                	sd	s4,16(sp)
    800033dc:	0080                	addi	s0,sp,64
    800033de:	892a                	mv	s2,a0
    800033e0:	8a2e                	mv	s4,a1
    800033e2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033e4:	4601                	li	a2,0
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	dd8080e7          	jalr	-552(ra) # 800031be <dirlookup>
    800033ee:	e93d                	bnez	a0,80003464 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f0:	04c92483          	lw	s1,76(s2)
    800033f4:	c49d                	beqz	s1,80003422 <dirlink+0x54>
    800033f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033f8:	4741                	li	a4,16
    800033fa:	86a6                	mv	a3,s1
    800033fc:	fc040613          	addi	a2,s0,-64
    80003400:	4581                	li	a1,0
    80003402:	854a                	mv	a0,s2
    80003404:	00000097          	auipc	ra,0x0
    80003408:	b8a080e7          	jalr	-1142(ra) # 80002f8e <readi>
    8000340c:	47c1                	li	a5,16
    8000340e:	06f51163          	bne	a0,a5,80003470 <dirlink+0xa2>
    if(de.inum == 0)
    80003412:	fc045783          	lhu	a5,-64(s0)
    80003416:	c791                	beqz	a5,80003422 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003418:	24c1                	addiw	s1,s1,16
    8000341a:	04c92783          	lw	a5,76(s2)
    8000341e:	fcf4ede3          	bltu	s1,a5,800033f8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003422:	4639                	li	a2,14
    80003424:	85d2                	mv	a1,s4
    80003426:	fc240513          	addi	a0,s0,-62
    8000342a:	ffffd097          	auipc	ra,0xffffd
    8000342e:	e7a080e7          	jalr	-390(ra) # 800002a4 <strncpy>
  de.inum = inum;
    80003432:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003436:	4741                	li	a4,16
    80003438:	86a6                	mv	a3,s1
    8000343a:	fc040613          	addi	a2,s0,-64
    8000343e:	4581                	li	a1,0
    80003440:	854a                	mv	a0,s2
    80003442:	00000097          	auipc	ra,0x0
    80003446:	c44080e7          	jalr	-956(ra) # 80003086 <writei>
    8000344a:	872a                	mv	a4,a0
    8000344c:	47c1                	li	a5,16
  return 0;
    8000344e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003450:	02f71863          	bne	a4,a5,80003480 <dirlink+0xb2>
}
    80003454:	70e2                	ld	ra,56(sp)
    80003456:	7442                	ld	s0,48(sp)
    80003458:	74a2                	ld	s1,40(sp)
    8000345a:	7902                	ld	s2,32(sp)
    8000345c:	69e2                	ld	s3,24(sp)
    8000345e:	6a42                	ld	s4,16(sp)
    80003460:	6121                	addi	sp,sp,64
    80003462:	8082                	ret
    iput(ip);
    80003464:	00000097          	auipc	ra,0x0
    80003468:	a30080e7          	jalr	-1488(ra) # 80002e94 <iput>
    return -1;
    8000346c:	557d                	li	a0,-1
    8000346e:	b7dd                	j	80003454 <dirlink+0x86>
      panic("dirlink read");
    80003470:	00005517          	auipc	a0,0x5
    80003474:	1b850513          	addi	a0,a0,440 # 80008628 <syscalls+0x1c8>
    80003478:	00003097          	auipc	ra,0x3
    8000347c:	910080e7          	jalr	-1776(ra) # 80005d88 <panic>
    panic("dirlink");
    80003480:	00005517          	auipc	a0,0x5
    80003484:	2b850513          	addi	a0,a0,696 # 80008738 <syscalls+0x2d8>
    80003488:	00003097          	auipc	ra,0x3
    8000348c:	900080e7          	jalr	-1792(ra) # 80005d88 <panic>

0000000080003490 <namei>:

struct inode*
namei(char *path)
{
    80003490:	1101                	addi	sp,sp,-32
    80003492:	ec06                	sd	ra,24(sp)
    80003494:	e822                	sd	s0,16(sp)
    80003496:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003498:	fe040613          	addi	a2,s0,-32
    8000349c:	4581                	li	a1,0
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	dd0080e7          	jalr	-560(ra) # 8000326e <namex>
}
    800034a6:	60e2                	ld	ra,24(sp)
    800034a8:	6442                	ld	s0,16(sp)
    800034aa:	6105                	addi	sp,sp,32
    800034ac:	8082                	ret

00000000800034ae <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034ae:	1141                	addi	sp,sp,-16
    800034b0:	e406                	sd	ra,8(sp)
    800034b2:	e022                	sd	s0,0(sp)
    800034b4:	0800                	addi	s0,sp,16
    800034b6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034b8:	4585                	li	a1,1
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	db4080e7          	jalr	-588(ra) # 8000326e <namex>
}
    800034c2:	60a2                	ld	ra,8(sp)
    800034c4:	6402                	ld	s0,0(sp)
    800034c6:	0141                	addi	sp,sp,16
    800034c8:	8082                	ret

00000000800034ca <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	e426                	sd	s1,8(sp)
    800034d2:	e04a                	sd	s2,0(sp)
    800034d4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034d6:	00016917          	auipc	s2,0x16
    800034da:	b4a90913          	addi	s2,s2,-1206 # 80019020 <log>
    800034de:	01892583          	lw	a1,24(s2)
    800034e2:	02892503          	lw	a0,40(s2)
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	ff2080e7          	jalr	-14(ra) # 800024d8 <bread>
    800034ee:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034f0:	02c92683          	lw	a3,44(s2)
    800034f4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034f6:	02d05763          	blez	a3,80003524 <write_head+0x5a>
    800034fa:	00016797          	auipc	a5,0x16
    800034fe:	b5678793          	addi	a5,a5,-1194 # 80019050 <log+0x30>
    80003502:	05c50713          	addi	a4,a0,92
    80003506:	36fd                	addiw	a3,a3,-1
    80003508:	1682                	slli	a3,a3,0x20
    8000350a:	9281                	srli	a3,a3,0x20
    8000350c:	068a                	slli	a3,a3,0x2
    8000350e:	00016617          	auipc	a2,0x16
    80003512:	b4660613          	addi	a2,a2,-1210 # 80019054 <log+0x34>
    80003516:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003518:	4390                	lw	a2,0(a5)
    8000351a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000351c:	0791                	addi	a5,a5,4
    8000351e:	0711                	addi	a4,a4,4
    80003520:	fed79ce3          	bne	a5,a3,80003518 <write_head+0x4e>
  }
  bwrite(buf);
    80003524:	8526                	mv	a0,s1
    80003526:	fffff097          	auipc	ra,0xfffff
    8000352a:	0a4080e7          	jalr	164(ra) # 800025ca <bwrite>
  brelse(buf);
    8000352e:	8526                	mv	a0,s1
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	0d8080e7          	jalr	216(ra) # 80002608 <brelse>
}
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6902                	ld	s2,0(sp)
    80003540:	6105                	addi	sp,sp,32
    80003542:	8082                	ret

0000000080003544 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003544:	00016797          	auipc	a5,0x16
    80003548:	b087a783          	lw	a5,-1272(a5) # 8001904c <log+0x2c>
    8000354c:	0af05d63          	blez	a5,80003606 <install_trans+0xc2>
{
    80003550:	7139                	addi	sp,sp,-64
    80003552:	fc06                	sd	ra,56(sp)
    80003554:	f822                	sd	s0,48(sp)
    80003556:	f426                	sd	s1,40(sp)
    80003558:	f04a                	sd	s2,32(sp)
    8000355a:	ec4e                	sd	s3,24(sp)
    8000355c:	e852                	sd	s4,16(sp)
    8000355e:	e456                	sd	s5,8(sp)
    80003560:	e05a                	sd	s6,0(sp)
    80003562:	0080                	addi	s0,sp,64
    80003564:	8b2a                	mv	s6,a0
    80003566:	00016a97          	auipc	s5,0x16
    8000356a:	aeaa8a93          	addi	s5,s5,-1302 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000356e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003570:	00016997          	auipc	s3,0x16
    80003574:	ab098993          	addi	s3,s3,-1360 # 80019020 <log>
    80003578:	a035                	j	800035a4 <install_trans+0x60>
      bunpin(dbuf);
    8000357a:	8526                	mv	a0,s1
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	166080e7          	jalr	358(ra) # 800026e2 <bunpin>
    brelse(lbuf);
    80003584:	854a                	mv	a0,s2
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	082080e7          	jalr	130(ra) # 80002608 <brelse>
    brelse(dbuf);
    8000358e:	8526                	mv	a0,s1
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	078080e7          	jalr	120(ra) # 80002608 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003598:	2a05                	addiw	s4,s4,1
    8000359a:	0a91                	addi	s5,s5,4
    8000359c:	02c9a783          	lw	a5,44(s3)
    800035a0:	04fa5963          	bge	s4,a5,800035f2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a4:	0189a583          	lw	a1,24(s3)
    800035a8:	014585bb          	addw	a1,a1,s4
    800035ac:	2585                	addiw	a1,a1,1
    800035ae:	0289a503          	lw	a0,40(s3)
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	f26080e7          	jalr	-218(ra) # 800024d8 <bread>
    800035ba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035bc:	000aa583          	lw	a1,0(s5)
    800035c0:	0289a503          	lw	a0,40(s3)
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	f14080e7          	jalr	-236(ra) # 800024d8 <bread>
    800035cc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035ce:	40000613          	li	a2,1024
    800035d2:	05890593          	addi	a1,s2,88
    800035d6:	05850513          	addi	a0,a0,88
    800035da:	ffffd097          	auipc	ra,0xffffd
    800035de:	c16080e7          	jalr	-1002(ra) # 800001f0 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035e2:	8526                	mv	a0,s1
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	fe6080e7          	jalr	-26(ra) # 800025ca <bwrite>
    if(recovering == 0)
    800035ec:	f80b1ce3          	bnez	s6,80003584 <install_trans+0x40>
    800035f0:	b769                	j	8000357a <install_trans+0x36>
}
    800035f2:	70e2                	ld	ra,56(sp)
    800035f4:	7442                	ld	s0,48(sp)
    800035f6:	74a2                	ld	s1,40(sp)
    800035f8:	7902                	ld	s2,32(sp)
    800035fa:	69e2                	ld	s3,24(sp)
    800035fc:	6a42                	ld	s4,16(sp)
    800035fe:	6aa2                	ld	s5,8(sp)
    80003600:	6b02                	ld	s6,0(sp)
    80003602:	6121                	addi	sp,sp,64
    80003604:	8082                	ret
    80003606:	8082                	ret

0000000080003608 <initlog>:
{
    80003608:	7179                	addi	sp,sp,-48
    8000360a:	f406                	sd	ra,40(sp)
    8000360c:	f022                	sd	s0,32(sp)
    8000360e:	ec26                	sd	s1,24(sp)
    80003610:	e84a                	sd	s2,16(sp)
    80003612:	e44e                	sd	s3,8(sp)
    80003614:	1800                	addi	s0,sp,48
    80003616:	892a                	mv	s2,a0
    80003618:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000361a:	00016497          	auipc	s1,0x16
    8000361e:	a0648493          	addi	s1,s1,-1530 # 80019020 <log>
    80003622:	00005597          	auipc	a1,0x5
    80003626:	01658593          	addi	a1,a1,22 # 80008638 <syscalls+0x1d8>
    8000362a:	8526                	mv	a0,s1
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	c16080e7          	jalr	-1002(ra) # 80006242 <initlock>
  log.start = sb->logstart;
    80003634:	0149a583          	lw	a1,20(s3)
    80003638:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000363a:	0109a783          	lw	a5,16(s3)
    8000363e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003640:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003644:	854a                	mv	a0,s2
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	e92080e7          	jalr	-366(ra) # 800024d8 <bread>
  log.lh.n = lh->n;
    8000364e:	4d3c                	lw	a5,88(a0)
    80003650:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003652:	02f05563          	blez	a5,8000367c <initlog+0x74>
    80003656:	05c50713          	addi	a4,a0,92
    8000365a:	00016697          	auipc	a3,0x16
    8000365e:	9f668693          	addi	a3,a3,-1546 # 80019050 <log+0x30>
    80003662:	37fd                	addiw	a5,a5,-1
    80003664:	1782                	slli	a5,a5,0x20
    80003666:	9381                	srli	a5,a5,0x20
    80003668:	078a                	slli	a5,a5,0x2
    8000366a:	06050613          	addi	a2,a0,96
    8000366e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003670:	4310                	lw	a2,0(a4)
    80003672:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003674:	0711                	addi	a4,a4,4
    80003676:	0691                	addi	a3,a3,4
    80003678:	fef71ce3          	bne	a4,a5,80003670 <initlog+0x68>
  brelse(buf);
    8000367c:	fffff097          	auipc	ra,0xfffff
    80003680:	f8c080e7          	jalr	-116(ra) # 80002608 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003684:	4505                	li	a0,1
    80003686:	00000097          	auipc	ra,0x0
    8000368a:	ebe080e7          	jalr	-322(ra) # 80003544 <install_trans>
  log.lh.n = 0;
    8000368e:	00016797          	auipc	a5,0x16
    80003692:	9a07af23          	sw	zero,-1602(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	e34080e7          	jalr	-460(ra) # 800034ca <write_head>
}
    8000369e:	70a2                	ld	ra,40(sp)
    800036a0:	7402                	ld	s0,32(sp)
    800036a2:	64e2                	ld	s1,24(sp)
    800036a4:	6942                	ld	s2,16(sp)
    800036a6:	69a2                	ld	s3,8(sp)
    800036a8:	6145                	addi	sp,sp,48
    800036aa:	8082                	ret

00000000800036ac <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036ac:	1101                	addi	sp,sp,-32
    800036ae:	ec06                	sd	ra,24(sp)
    800036b0:	e822                	sd	s0,16(sp)
    800036b2:	e426                	sd	s1,8(sp)
    800036b4:	e04a                	sd	s2,0(sp)
    800036b6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036b8:	00016517          	auipc	a0,0x16
    800036bc:	96850513          	addi	a0,a0,-1688 # 80019020 <log>
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	c12080e7          	jalr	-1006(ra) # 800062d2 <acquire>
  while(1){
    if(log.committing){
    800036c8:	00016497          	auipc	s1,0x16
    800036cc:	95848493          	addi	s1,s1,-1704 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036d0:	4979                	li	s2,30
    800036d2:	a039                	j	800036e0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036d4:	85a6                	mv	a1,s1
    800036d6:	8526                	mv	a0,s1
    800036d8:	ffffe097          	auipc	ra,0xffffe
    800036dc:	f76080e7          	jalr	-138(ra) # 8000164e <sleep>
    if(log.committing){
    800036e0:	50dc                	lw	a5,36(s1)
    800036e2:	fbed                	bnez	a5,800036d4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036e4:	509c                	lw	a5,32(s1)
    800036e6:	0017871b          	addiw	a4,a5,1
    800036ea:	0007069b          	sext.w	a3,a4
    800036ee:	0027179b          	slliw	a5,a4,0x2
    800036f2:	9fb9                	addw	a5,a5,a4
    800036f4:	0017979b          	slliw	a5,a5,0x1
    800036f8:	54d8                	lw	a4,44(s1)
    800036fa:	9fb9                	addw	a5,a5,a4
    800036fc:	00f95963          	bge	s2,a5,8000370e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003700:	85a6                	mv	a1,s1
    80003702:	8526                	mv	a0,s1
    80003704:	ffffe097          	auipc	ra,0xffffe
    80003708:	f4a080e7          	jalr	-182(ra) # 8000164e <sleep>
    8000370c:	bfd1                	j	800036e0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000370e:	00016517          	auipc	a0,0x16
    80003712:	91250513          	addi	a0,a0,-1774 # 80019020 <log>
    80003716:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003718:	00003097          	auipc	ra,0x3
    8000371c:	c6e080e7          	jalr	-914(ra) # 80006386 <release>
      break;
    }
  }
}
    80003720:	60e2                	ld	ra,24(sp)
    80003722:	6442                	ld	s0,16(sp)
    80003724:	64a2                	ld	s1,8(sp)
    80003726:	6902                	ld	s2,0(sp)
    80003728:	6105                	addi	sp,sp,32
    8000372a:	8082                	ret

000000008000372c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000372c:	7139                	addi	sp,sp,-64
    8000372e:	fc06                	sd	ra,56(sp)
    80003730:	f822                	sd	s0,48(sp)
    80003732:	f426                	sd	s1,40(sp)
    80003734:	f04a                	sd	s2,32(sp)
    80003736:	ec4e                	sd	s3,24(sp)
    80003738:	e852                	sd	s4,16(sp)
    8000373a:	e456                	sd	s5,8(sp)
    8000373c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000373e:	00016497          	auipc	s1,0x16
    80003742:	8e248493          	addi	s1,s1,-1822 # 80019020 <log>
    80003746:	8526                	mv	a0,s1
    80003748:	00003097          	auipc	ra,0x3
    8000374c:	b8a080e7          	jalr	-1142(ra) # 800062d2 <acquire>
  log.outstanding -= 1;
    80003750:	509c                	lw	a5,32(s1)
    80003752:	37fd                	addiw	a5,a5,-1
    80003754:	0007891b          	sext.w	s2,a5
    80003758:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000375a:	50dc                	lw	a5,36(s1)
    8000375c:	efb9                	bnez	a5,800037ba <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000375e:	06091663          	bnez	s2,800037ca <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003762:	00016497          	auipc	s1,0x16
    80003766:	8be48493          	addi	s1,s1,-1858 # 80019020 <log>
    8000376a:	4785                	li	a5,1
    8000376c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000376e:	8526                	mv	a0,s1
    80003770:	00003097          	auipc	ra,0x3
    80003774:	c16080e7          	jalr	-1002(ra) # 80006386 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003778:	54dc                	lw	a5,44(s1)
    8000377a:	06f04763          	bgtz	a5,800037e8 <end_op+0xbc>
    acquire(&log.lock);
    8000377e:	00016497          	auipc	s1,0x16
    80003782:	8a248493          	addi	s1,s1,-1886 # 80019020 <log>
    80003786:	8526                	mv	a0,s1
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	b4a080e7          	jalr	-1206(ra) # 800062d2 <acquire>
    log.committing = 0;
    80003790:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003794:	8526                	mv	a0,s1
    80003796:	ffffe097          	auipc	ra,0xffffe
    8000379a:	044080e7          	jalr	68(ra) # 800017da <wakeup>
    release(&log.lock);
    8000379e:	8526                	mv	a0,s1
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	be6080e7          	jalr	-1050(ra) # 80006386 <release>
}
    800037a8:	70e2                	ld	ra,56(sp)
    800037aa:	7442                	ld	s0,48(sp)
    800037ac:	74a2                	ld	s1,40(sp)
    800037ae:	7902                	ld	s2,32(sp)
    800037b0:	69e2                	ld	s3,24(sp)
    800037b2:	6a42                	ld	s4,16(sp)
    800037b4:	6aa2                	ld	s5,8(sp)
    800037b6:	6121                	addi	sp,sp,64
    800037b8:	8082                	ret
    panic("log.committing");
    800037ba:	00005517          	auipc	a0,0x5
    800037be:	e8650513          	addi	a0,a0,-378 # 80008640 <syscalls+0x1e0>
    800037c2:	00002097          	auipc	ra,0x2
    800037c6:	5c6080e7          	jalr	1478(ra) # 80005d88 <panic>
    wakeup(&log);
    800037ca:	00016497          	auipc	s1,0x16
    800037ce:	85648493          	addi	s1,s1,-1962 # 80019020 <log>
    800037d2:	8526                	mv	a0,s1
    800037d4:	ffffe097          	auipc	ra,0xffffe
    800037d8:	006080e7          	jalr	6(ra) # 800017da <wakeup>
  release(&log.lock);
    800037dc:	8526                	mv	a0,s1
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	ba8080e7          	jalr	-1112(ra) # 80006386 <release>
  if(do_commit){
    800037e6:	b7c9                	j	800037a8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037e8:	00016a97          	auipc	s5,0x16
    800037ec:	868a8a93          	addi	s5,s5,-1944 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037f0:	00016a17          	auipc	s4,0x16
    800037f4:	830a0a13          	addi	s4,s4,-2000 # 80019020 <log>
    800037f8:	018a2583          	lw	a1,24(s4)
    800037fc:	012585bb          	addw	a1,a1,s2
    80003800:	2585                	addiw	a1,a1,1
    80003802:	028a2503          	lw	a0,40(s4)
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	cd2080e7          	jalr	-814(ra) # 800024d8 <bread>
    8000380e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003810:	000aa583          	lw	a1,0(s5)
    80003814:	028a2503          	lw	a0,40(s4)
    80003818:	fffff097          	auipc	ra,0xfffff
    8000381c:	cc0080e7          	jalr	-832(ra) # 800024d8 <bread>
    80003820:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003822:	40000613          	li	a2,1024
    80003826:	05850593          	addi	a1,a0,88
    8000382a:	05848513          	addi	a0,s1,88
    8000382e:	ffffd097          	auipc	ra,0xffffd
    80003832:	9c2080e7          	jalr	-1598(ra) # 800001f0 <memmove>
    bwrite(to);  // write the log
    80003836:	8526                	mv	a0,s1
    80003838:	fffff097          	auipc	ra,0xfffff
    8000383c:	d92080e7          	jalr	-622(ra) # 800025ca <bwrite>
    brelse(from);
    80003840:	854e                	mv	a0,s3
    80003842:	fffff097          	auipc	ra,0xfffff
    80003846:	dc6080e7          	jalr	-570(ra) # 80002608 <brelse>
    brelse(to);
    8000384a:	8526                	mv	a0,s1
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	dbc080e7          	jalr	-580(ra) # 80002608 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003854:	2905                	addiw	s2,s2,1
    80003856:	0a91                	addi	s5,s5,4
    80003858:	02ca2783          	lw	a5,44(s4)
    8000385c:	f8f94ee3          	blt	s2,a5,800037f8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003860:	00000097          	auipc	ra,0x0
    80003864:	c6a080e7          	jalr	-918(ra) # 800034ca <write_head>
    install_trans(0); // Now install writes to home locations
    80003868:	4501                	li	a0,0
    8000386a:	00000097          	auipc	ra,0x0
    8000386e:	cda080e7          	jalr	-806(ra) # 80003544 <install_trans>
    log.lh.n = 0;
    80003872:	00015797          	auipc	a5,0x15
    80003876:	7c07ad23          	sw	zero,2010(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000387a:	00000097          	auipc	ra,0x0
    8000387e:	c50080e7          	jalr	-944(ra) # 800034ca <write_head>
    80003882:	bdf5                	j	8000377e <end_op+0x52>

0000000080003884 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003884:	1101                	addi	sp,sp,-32
    80003886:	ec06                	sd	ra,24(sp)
    80003888:	e822                	sd	s0,16(sp)
    8000388a:	e426                	sd	s1,8(sp)
    8000388c:	e04a                	sd	s2,0(sp)
    8000388e:	1000                	addi	s0,sp,32
    80003890:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003892:	00015917          	auipc	s2,0x15
    80003896:	78e90913          	addi	s2,s2,1934 # 80019020 <log>
    8000389a:	854a                	mv	a0,s2
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	a36080e7          	jalr	-1482(ra) # 800062d2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038a4:	02c92603          	lw	a2,44(s2)
    800038a8:	47f5                	li	a5,29
    800038aa:	06c7c563          	blt	a5,a2,80003914 <log_write+0x90>
    800038ae:	00015797          	auipc	a5,0x15
    800038b2:	78e7a783          	lw	a5,1934(a5) # 8001903c <log+0x1c>
    800038b6:	37fd                	addiw	a5,a5,-1
    800038b8:	04f65e63          	bge	a2,a5,80003914 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038bc:	00015797          	auipc	a5,0x15
    800038c0:	7847a783          	lw	a5,1924(a5) # 80019040 <log+0x20>
    800038c4:	06f05063          	blez	a5,80003924 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038c8:	4781                	li	a5,0
    800038ca:	06c05563          	blez	a2,80003934 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ce:	44cc                	lw	a1,12(s1)
    800038d0:	00015717          	auipc	a4,0x15
    800038d4:	78070713          	addi	a4,a4,1920 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038d8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038da:	4314                	lw	a3,0(a4)
    800038dc:	04b68c63          	beq	a3,a1,80003934 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038e0:	2785                	addiw	a5,a5,1
    800038e2:	0711                	addi	a4,a4,4
    800038e4:	fef61be3          	bne	a2,a5,800038da <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038e8:	0621                	addi	a2,a2,8
    800038ea:	060a                	slli	a2,a2,0x2
    800038ec:	00015797          	auipc	a5,0x15
    800038f0:	73478793          	addi	a5,a5,1844 # 80019020 <log>
    800038f4:	963e                	add	a2,a2,a5
    800038f6:	44dc                	lw	a5,12(s1)
    800038f8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038fa:	8526                	mv	a0,s1
    800038fc:	fffff097          	auipc	ra,0xfffff
    80003900:	daa080e7          	jalr	-598(ra) # 800026a6 <bpin>
    log.lh.n++;
    80003904:	00015717          	auipc	a4,0x15
    80003908:	71c70713          	addi	a4,a4,1820 # 80019020 <log>
    8000390c:	575c                	lw	a5,44(a4)
    8000390e:	2785                	addiw	a5,a5,1
    80003910:	d75c                	sw	a5,44(a4)
    80003912:	a835                	j	8000394e <log_write+0xca>
    panic("too big a transaction");
    80003914:	00005517          	auipc	a0,0x5
    80003918:	d3c50513          	addi	a0,a0,-708 # 80008650 <syscalls+0x1f0>
    8000391c:	00002097          	auipc	ra,0x2
    80003920:	46c080e7          	jalr	1132(ra) # 80005d88 <panic>
    panic("log_write outside of trans");
    80003924:	00005517          	auipc	a0,0x5
    80003928:	d4450513          	addi	a0,a0,-700 # 80008668 <syscalls+0x208>
    8000392c:	00002097          	auipc	ra,0x2
    80003930:	45c080e7          	jalr	1116(ra) # 80005d88 <panic>
  log.lh.block[i] = b->blockno;
    80003934:	00878713          	addi	a4,a5,8
    80003938:	00271693          	slli	a3,a4,0x2
    8000393c:	00015717          	auipc	a4,0x15
    80003940:	6e470713          	addi	a4,a4,1764 # 80019020 <log>
    80003944:	9736                	add	a4,a4,a3
    80003946:	44d4                	lw	a3,12(s1)
    80003948:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000394a:	faf608e3          	beq	a2,a5,800038fa <log_write+0x76>
  }
  release(&log.lock);
    8000394e:	00015517          	auipc	a0,0x15
    80003952:	6d250513          	addi	a0,a0,1746 # 80019020 <log>
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	a30080e7          	jalr	-1488(ra) # 80006386 <release>
}
    8000395e:	60e2                	ld	ra,24(sp)
    80003960:	6442                	ld	s0,16(sp)
    80003962:	64a2                	ld	s1,8(sp)
    80003964:	6902                	ld	s2,0(sp)
    80003966:	6105                	addi	sp,sp,32
    80003968:	8082                	ret

000000008000396a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000396a:	1101                	addi	sp,sp,-32
    8000396c:	ec06                	sd	ra,24(sp)
    8000396e:	e822                	sd	s0,16(sp)
    80003970:	e426                	sd	s1,8(sp)
    80003972:	e04a                	sd	s2,0(sp)
    80003974:	1000                	addi	s0,sp,32
    80003976:	84aa                	mv	s1,a0
    80003978:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000397a:	00005597          	auipc	a1,0x5
    8000397e:	d0e58593          	addi	a1,a1,-754 # 80008688 <syscalls+0x228>
    80003982:	0521                	addi	a0,a0,8
    80003984:	00003097          	auipc	ra,0x3
    80003988:	8be080e7          	jalr	-1858(ra) # 80006242 <initlock>
  lk->name = name;
    8000398c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003990:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003994:	0204a423          	sw	zero,40(s1)
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6902                	ld	s2,0(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039a4:	1101                	addi	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	e04a                	sd	s2,0(sp)
    800039ae:	1000                	addi	s0,sp,32
    800039b0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039b2:	00850913          	addi	s2,a0,8
    800039b6:	854a                	mv	a0,s2
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	91a080e7          	jalr	-1766(ra) # 800062d2 <acquire>
  while (lk->locked) {
    800039c0:	409c                	lw	a5,0(s1)
    800039c2:	cb89                	beqz	a5,800039d4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039c4:	85ca                	mv	a1,s2
    800039c6:	8526                	mv	a0,s1
    800039c8:	ffffe097          	auipc	ra,0xffffe
    800039cc:	c86080e7          	jalr	-890(ra) # 8000164e <sleep>
  while (lk->locked) {
    800039d0:	409c                	lw	a5,0(s1)
    800039d2:	fbed                	bnez	a5,800039c4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039d4:	4785                	li	a5,1
    800039d6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039d8:	ffffd097          	auipc	ra,0xffffd
    800039dc:	5ba080e7          	jalr	1466(ra) # 80000f92 <myproc>
    800039e0:	591c                	lw	a5,48(a0)
    800039e2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039e4:	854a                	mv	a0,s2
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	9a0080e7          	jalr	-1632(ra) # 80006386 <release>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6902                	ld	s2,0(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039fa:	1101                	addi	sp,sp,-32
    800039fc:	ec06                	sd	ra,24(sp)
    800039fe:	e822                	sd	s0,16(sp)
    80003a00:	e426                	sd	s1,8(sp)
    80003a02:	e04a                	sd	s2,0(sp)
    80003a04:	1000                	addi	s0,sp,32
    80003a06:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a08:	00850913          	addi	s2,a0,8
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	8c4080e7          	jalr	-1852(ra) # 800062d2 <acquire>
  lk->locked = 0;
    80003a16:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a1e:	8526                	mv	a0,s1
    80003a20:	ffffe097          	auipc	ra,0xffffe
    80003a24:	dba080e7          	jalr	-582(ra) # 800017da <wakeup>
  release(&lk->lk);
    80003a28:	854a                	mv	a0,s2
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	95c080e7          	jalr	-1700(ra) # 80006386 <release>
}
    80003a32:	60e2                	ld	ra,24(sp)
    80003a34:	6442                	ld	s0,16(sp)
    80003a36:	64a2                	ld	s1,8(sp)
    80003a38:	6902                	ld	s2,0(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a3e:	7179                	addi	sp,sp,-48
    80003a40:	f406                	sd	ra,40(sp)
    80003a42:	f022                	sd	s0,32(sp)
    80003a44:	ec26                	sd	s1,24(sp)
    80003a46:	e84a                	sd	s2,16(sp)
    80003a48:	e44e                	sd	s3,8(sp)
    80003a4a:	1800                	addi	s0,sp,48
    80003a4c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a4e:	00850913          	addi	s2,a0,8
    80003a52:	854a                	mv	a0,s2
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	87e080e7          	jalr	-1922(ra) # 800062d2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a5c:	409c                	lw	a5,0(s1)
    80003a5e:	ef99                	bnez	a5,80003a7c <holdingsleep+0x3e>
    80003a60:	4481                	li	s1,0
  release(&lk->lk);
    80003a62:	854a                	mv	a0,s2
    80003a64:	00003097          	auipc	ra,0x3
    80003a68:	922080e7          	jalr	-1758(ra) # 80006386 <release>
  return r;
}
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	70a2                	ld	ra,40(sp)
    80003a70:	7402                	ld	s0,32(sp)
    80003a72:	64e2                	ld	s1,24(sp)
    80003a74:	6942                	ld	s2,16(sp)
    80003a76:	69a2                	ld	s3,8(sp)
    80003a78:	6145                	addi	sp,sp,48
    80003a7a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a7c:	0284a983          	lw	s3,40(s1)
    80003a80:	ffffd097          	auipc	ra,0xffffd
    80003a84:	512080e7          	jalr	1298(ra) # 80000f92 <myproc>
    80003a88:	5904                	lw	s1,48(a0)
    80003a8a:	413484b3          	sub	s1,s1,s3
    80003a8e:	0014b493          	seqz	s1,s1
    80003a92:	bfc1                	j	80003a62 <holdingsleep+0x24>

0000000080003a94 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a94:	1141                	addi	sp,sp,-16
    80003a96:	e406                	sd	ra,8(sp)
    80003a98:	e022                	sd	s0,0(sp)
    80003a9a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a9c:	00005597          	auipc	a1,0x5
    80003aa0:	bfc58593          	addi	a1,a1,-1028 # 80008698 <syscalls+0x238>
    80003aa4:	00015517          	auipc	a0,0x15
    80003aa8:	6c450513          	addi	a0,a0,1732 # 80019168 <ftable>
    80003aac:	00002097          	auipc	ra,0x2
    80003ab0:	796080e7          	jalr	1942(ra) # 80006242 <initlock>
}
    80003ab4:	60a2                	ld	ra,8(sp)
    80003ab6:	6402                	ld	s0,0(sp)
    80003ab8:	0141                	addi	sp,sp,16
    80003aba:	8082                	ret

0000000080003abc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003abc:	1101                	addi	sp,sp,-32
    80003abe:	ec06                	sd	ra,24(sp)
    80003ac0:	e822                	sd	s0,16(sp)
    80003ac2:	e426                	sd	s1,8(sp)
    80003ac4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ac6:	00015517          	auipc	a0,0x15
    80003aca:	6a250513          	addi	a0,a0,1698 # 80019168 <ftable>
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	804080e7          	jalr	-2044(ra) # 800062d2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ad6:	00015497          	auipc	s1,0x15
    80003ada:	6aa48493          	addi	s1,s1,1706 # 80019180 <ftable+0x18>
    80003ade:	00016717          	auipc	a4,0x16
    80003ae2:	64270713          	addi	a4,a4,1602 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003ae6:	40dc                	lw	a5,4(s1)
    80003ae8:	cf99                	beqz	a5,80003b06 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aea:	02848493          	addi	s1,s1,40
    80003aee:	fee49ce3          	bne	s1,a4,80003ae6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003af2:	00015517          	auipc	a0,0x15
    80003af6:	67650513          	addi	a0,a0,1654 # 80019168 <ftable>
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	88c080e7          	jalr	-1908(ra) # 80006386 <release>
  return 0;
    80003b02:	4481                	li	s1,0
    80003b04:	a819                	j	80003b1a <filealloc+0x5e>
      f->ref = 1;
    80003b06:	4785                	li	a5,1
    80003b08:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b0a:	00015517          	auipc	a0,0x15
    80003b0e:	65e50513          	addi	a0,a0,1630 # 80019168 <ftable>
    80003b12:	00003097          	auipc	ra,0x3
    80003b16:	874080e7          	jalr	-1932(ra) # 80006386 <release>
}
    80003b1a:	8526                	mv	a0,s1
    80003b1c:	60e2                	ld	ra,24(sp)
    80003b1e:	6442                	ld	s0,16(sp)
    80003b20:	64a2                	ld	s1,8(sp)
    80003b22:	6105                	addi	sp,sp,32
    80003b24:	8082                	ret

0000000080003b26 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b26:	1101                	addi	sp,sp,-32
    80003b28:	ec06                	sd	ra,24(sp)
    80003b2a:	e822                	sd	s0,16(sp)
    80003b2c:	e426                	sd	s1,8(sp)
    80003b2e:	1000                	addi	s0,sp,32
    80003b30:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b32:	00015517          	auipc	a0,0x15
    80003b36:	63650513          	addi	a0,a0,1590 # 80019168 <ftable>
    80003b3a:	00002097          	auipc	ra,0x2
    80003b3e:	798080e7          	jalr	1944(ra) # 800062d2 <acquire>
  if(f->ref < 1)
    80003b42:	40dc                	lw	a5,4(s1)
    80003b44:	02f05263          	blez	a5,80003b68 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b48:	2785                	addiw	a5,a5,1
    80003b4a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b4c:	00015517          	auipc	a0,0x15
    80003b50:	61c50513          	addi	a0,a0,1564 # 80019168 <ftable>
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	832080e7          	jalr	-1998(ra) # 80006386 <release>
  return f;
}
    80003b5c:	8526                	mv	a0,s1
    80003b5e:	60e2                	ld	ra,24(sp)
    80003b60:	6442                	ld	s0,16(sp)
    80003b62:	64a2                	ld	s1,8(sp)
    80003b64:	6105                	addi	sp,sp,32
    80003b66:	8082                	ret
    panic("filedup");
    80003b68:	00005517          	auipc	a0,0x5
    80003b6c:	b3850513          	addi	a0,a0,-1224 # 800086a0 <syscalls+0x240>
    80003b70:	00002097          	auipc	ra,0x2
    80003b74:	218080e7          	jalr	536(ra) # 80005d88 <panic>

0000000080003b78 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b78:	7139                	addi	sp,sp,-64
    80003b7a:	fc06                	sd	ra,56(sp)
    80003b7c:	f822                	sd	s0,48(sp)
    80003b7e:	f426                	sd	s1,40(sp)
    80003b80:	f04a                	sd	s2,32(sp)
    80003b82:	ec4e                	sd	s3,24(sp)
    80003b84:	e852                	sd	s4,16(sp)
    80003b86:	e456                	sd	s5,8(sp)
    80003b88:	0080                	addi	s0,sp,64
    80003b8a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b8c:	00015517          	auipc	a0,0x15
    80003b90:	5dc50513          	addi	a0,a0,1500 # 80019168 <ftable>
    80003b94:	00002097          	auipc	ra,0x2
    80003b98:	73e080e7          	jalr	1854(ra) # 800062d2 <acquire>
  if(f->ref < 1)
    80003b9c:	40dc                	lw	a5,4(s1)
    80003b9e:	06f05163          	blez	a5,80003c00 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ba2:	37fd                	addiw	a5,a5,-1
    80003ba4:	0007871b          	sext.w	a4,a5
    80003ba8:	c0dc                	sw	a5,4(s1)
    80003baa:	06e04363          	bgtz	a4,80003c10 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bae:	0004a903          	lw	s2,0(s1)
    80003bb2:	0094ca83          	lbu	s5,9(s1)
    80003bb6:	0104ba03          	ld	s4,16(s1)
    80003bba:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bbe:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bc2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bc6:	00015517          	auipc	a0,0x15
    80003bca:	5a250513          	addi	a0,a0,1442 # 80019168 <ftable>
    80003bce:	00002097          	auipc	ra,0x2
    80003bd2:	7b8080e7          	jalr	1976(ra) # 80006386 <release>

  if(ff.type == FD_PIPE){
    80003bd6:	4785                	li	a5,1
    80003bd8:	04f90d63          	beq	s2,a5,80003c32 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bdc:	3979                	addiw	s2,s2,-2
    80003bde:	4785                	li	a5,1
    80003be0:	0527e063          	bltu	a5,s2,80003c20 <fileclose+0xa8>
    begin_op();
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	ac8080e7          	jalr	-1336(ra) # 800036ac <begin_op>
    iput(ff.ip);
    80003bec:	854e                	mv	a0,s3
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	2a6080e7          	jalr	678(ra) # 80002e94 <iput>
    end_op();
    80003bf6:	00000097          	auipc	ra,0x0
    80003bfa:	b36080e7          	jalr	-1226(ra) # 8000372c <end_op>
    80003bfe:	a00d                	j	80003c20 <fileclose+0xa8>
    panic("fileclose");
    80003c00:	00005517          	auipc	a0,0x5
    80003c04:	aa850513          	addi	a0,a0,-1368 # 800086a8 <syscalls+0x248>
    80003c08:	00002097          	auipc	ra,0x2
    80003c0c:	180080e7          	jalr	384(ra) # 80005d88 <panic>
    release(&ftable.lock);
    80003c10:	00015517          	auipc	a0,0x15
    80003c14:	55850513          	addi	a0,a0,1368 # 80019168 <ftable>
    80003c18:	00002097          	auipc	ra,0x2
    80003c1c:	76e080e7          	jalr	1902(ra) # 80006386 <release>
  }
}
    80003c20:	70e2                	ld	ra,56(sp)
    80003c22:	7442                	ld	s0,48(sp)
    80003c24:	74a2                	ld	s1,40(sp)
    80003c26:	7902                	ld	s2,32(sp)
    80003c28:	69e2                	ld	s3,24(sp)
    80003c2a:	6a42                	ld	s4,16(sp)
    80003c2c:	6aa2                	ld	s5,8(sp)
    80003c2e:	6121                	addi	sp,sp,64
    80003c30:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c32:	85d6                	mv	a1,s5
    80003c34:	8552                	mv	a0,s4
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	34c080e7          	jalr	844(ra) # 80003f82 <pipeclose>
    80003c3e:	b7cd                	j	80003c20 <fileclose+0xa8>

0000000080003c40 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c40:	715d                	addi	sp,sp,-80
    80003c42:	e486                	sd	ra,72(sp)
    80003c44:	e0a2                	sd	s0,64(sp)
    80003c46:	fc26                	sd	s1,56(sp)
    80003c48:	f84a                	sd	s2,48(sp)
    80003c4a:	f44e                	sd	s3,40(sp)
    80003c4c:	0880                	addi	s0,sp,80
    80003c4e:	84aa                	mv	s1,a0
    80003c50:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c52:	ffffd097          	auipc	ra,0xffffd
    80003c56:	340080e7          	jalr	832(ra) # 80000f92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c5a:	409c                	lw	a5,0(s1)
    80003c5c:	37f9                	addiw	a5,a5,-2
    80003c5e:	4705                	li	a4,1
    80003c60:	04f76763          	bltu	a4,a5,80003cae <filestat+0x6e>
    80003c64:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c66:	6c88                	ld	a0,24(s1)
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	072080e7          	jalr	114(ra) # 80002cda <ilock>
    stati(f->ip, &st);
    80003c70:	fb840593          	addi	a1,s0,-72
    80003c74:	6c88                	ld	a0,24(s1)
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	2ee080e7          	jalr	750(ra) # 80002f64 <stati>
    iunlock(f->ip);
    80003c7e:	6c88                	ld	a0,24(s1)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	11c080e7          	jalr	284(ra) # 80002d9c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c88:	46e1                	li	a3,24
    80003c8a:	fb840613          	addi	a2,s0,-72
    80003c8e:	85ce                	mv	a1,s3
    80003c90:	05093503          	ld	a0,80(s2)
    80003c94:	ffffd097          	auipc	ra,0xffffd
    80003c98:	ee4080e7          	jalr	-284(ra) # 80000b78 <copyout>
    80003c9c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ca0:	60a6                	ld	ra,72(sp)
    80003ca2:	6406                	ld	s0,64(sp)
    80003ca4:	74e2                	ld	s1,56(sp)
    80003ca6:	7942                	ld	s2,48(sp)
    80003ca8:	79a2                	ld	s3,40(sp)
    80003caa:	6161                	addi	sp,sp,80
    80003cac:	8082                	ret
  return -1;
    80003cae:	557d                	li	a0,-1
    80003cb0:	bfc5                	j	80003ca0 <filestat+0x60>

0000000080003cb2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cb2:	7179                	addi	sp,sp,-48
    80003cb4:	f406                	sd	ra,40(sp)
    80003cb6:	f022                	sd	s0,32(sp)
    80003cb8:	ec26                	sd	s1,24(sp)
    80003cba:	e84a                	sd	s2,16(sp)
    80003cbc:	e44e                	sd	s3,8(sp)
    80003cbe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cc0:	00854783          	lbu	a5,8(a0)
    80003cc4:	c3d5                	beqz	a5,80003d68 <fileread+0xb6>
    80003cc6:	84aa                	mv	s1,a0
    80003cc8:	89ae                	mv	s3,a1
    80003cca:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ccc:	411c                	lw	a5,0(a0)
    80003cce:	4705                	li	a4,1
    80003cd0:	04e78963          	beq	a5,a4,80003d22 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cd4:	470d                	li	a4,3
    80003cd6:	04e78d63          	beq	a5,a4,80003d30 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cda:	4709                	li	a4,2
    80003cdc:	06e79e63          	bne	a5,a4,80003d58 <fileread+0xa6>
    ilock(f->ip);
    80003ce0:	6d08                	ld	a0,24(a0)
    80003ce2:	fffff097          	auipc	ra,0xfffff
    80003ce6:	ff8080e7          	jalr	-8(ra) # 80002cda <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cea:	874a                	mv	a4,s2
    80003cec:	5094                	lw	a3,32(s1)
    80003cee:	864e                	mv	a2,s3
    80003cf0:	4585                	li	a1,1
    80003cf2:	6c88                	ld	a0,24(s1)
    80003cf4:	fffff097          	auipc	ra,0xfffff
    80003cf8:	29a080e7          	jalr	666(ra) # 80002f8e <readi>
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	00a05563          	blez	a0,80003d08 <fileread+0x56>
      f->off += r;
    80003d02:	509c                	lw	a5,32(s1)
    80003d04:	9fa9                	addw	a5,a5,a0
    80003d06:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d08:	6c88                	ld	a0,24(s1)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	092080e7          	jalr	146(ra) # 80002d9c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d12:	854a                	mv	a0,s2
    80003d14:	70a2                	ld	ra,40(sp)
    80003d16:	7402                	ld	s0,32(sp)
    80003d18:	64e2                	ld	s1,24(sp)
    80003d1a:	6942                	ld	s2,16(sp)
    80003d1c:	69a2                	ld	s3,8(sp)
    80003d1e:	6145                	addi	sp,sp,48
    80003d20:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d22:	6908                	ld	a0,16(a0)
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	3c8080e7          	jalr	968(ra) # 800040ec <piperead>
    80003d2c:	892a                	mv	s2,a0
    80003d2e:	b7d5                	j	80003d12 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d30:	02451783          	lh	a5,36(a0)
    80003d34:	03079693          	slli	a3,a5,0x30
    80003d38:	92c1                	srli	a3,a3,0x30
    80003d3a:	4725                	li	a4,9
    80003d3c:	02d76863          	bltu	a4,a3,80003d6c <fileread+0xba>
    80003d40:	0792                	slli	a5,a5,0x4
    80003d42:	00015717          	auipc	a4,0x15
    80003d46:	38670713          	addi	a4,a4,902 # 800190c8 <devsw>
    80003d4a:	97ba                	add	a5,a5,a4
    80003d4c:	639c                	ld	a5,0(a5)
    80003d4e:	c38d                	beqz	a5,80003d70 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d50:	4505                	li	a0,1
    80003d52:	9782                	jalr	a5
    80003d54:	892a                	mv	s2,a0
    80003d56:	bf75                	j	80003d12 <fileread+0x60>
    panic("fileread");
    80003d58:	00005517          	auipc	a0,0x5
    80003d5c:	96050513          	addi	a0,a0,-1696 # 800086b8 <syscalls+0x258>
    80003d60:	00002097          	auipc	ra,0x2
    80003d64:	028080e7          	jalr	40(ra) # 80005d88 <panic>
    return -1;
    80003d68:	597d                	li	s2,-1
    80003d6a:	b765                	j	80003d12 <fileread+0x60>
      return -1;
    80003d6c:	597d                	li	s2,-1
    80003d6e:	b755                	j	80003d12 <fileread+0x60>
    80003d70:	597d                	li	s2,-1
    80003d72:	b745                	j	80003d12 <fileread+0x60>

0000000080003d74 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d74:	715d                	addi	sp,sp,-80
    80003d76:	e486                	sd	ra,72(sp)
    80003d78:	e0a2                	sd	s0,64(sp)
    80003d7a:	fc26                	sd	s1,56(sp)
    80003d7c:	f84a                	sd	s2,48(sp)
    80003d7e:	f44e                	sd	s3,40(sp)
    80003d80:	f052                	sd	s4,32(sp)
    80003d82:	ec56                	sd	s5,24(sp)
    80003d84:	e85a                	sd	s6,16(sp)
    80003d86:	e45e                	sd	s7,8(sp)
    80003d88:	e062                	sd	s8,0(sp)
    80003d8a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d8c:	00954783          	lbu	a5,9(a0)
    80003d90:	10078663          	beqz	a5,80003e9c <filewrite+0x128>
    80003d94:	892a                	mv	s2,a0
    80003d96:	8aae                	mv	s5,a1
    80003d98:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d9a:	411c                	lw	a5,0(a0)
    80003d9c:	4705                	li	a4,1
    80003d9e:	02e78263          	beq	a5,a4,80003dc2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003da2:	470d                	li	a4,3
    80003da4:	02e78663          	beq	a5,a4,80003dd0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003da8:	4709                	li	a4,2
    80003daa:	0ee79163          	bne	a5,a4,80003e8c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dae:	0ac05d63          	blez	a2,80003e68 <filewrite+0xf4>
    int i = 0;
    80003db2:	4981                	li	s3,0
    80003db4:	6b05                	lui	s6,0x1
    80003db6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dba:	6b85                	lui	s7,0x1
    80003dbc:	c00b8b9b          	addiw	s7,s7,-1024
    80003dc0:	a861                	j	80003e58 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dc2:	6908                	ld	a0,16(a0)
    80003dc4:	00000097          	auipc	ra,0x0
    80003dc8:	22e080e7          	jalr	558(ra) # 80003ff2 <pipewrite>
    80003dcc:	8a2a                	mv	s4,a0
    80003dce:	a045                	j	80003e6e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dd0:	02451783          	lh	a5,36(a0)
    80003dd4:	03079693          	slli	a3,a5,0x30
    80003dd8:	92c1                	srli	a3,a3,0x30
    80003dda:	4725                	li	a4,9
    80003ddc:	0cd76263          	bltu	a4,a3,80003ea0 <filewrite+0x12c>
    80003de0:	0792                	slli	a5,a5,0x4
    80003de2:	00015717          	auipc	a4,0x15
    80003de6:	2e670713          	addi	a4,a4,742 # 800190c8 <devsw>
    80003dea:	97ba                	add	a5,a5,a4
    80003dec:	679c                	ld	a5,8(a5)
    80003dee:	cbdd                	beqz	a5,80003ea4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003df0:	4505                	li	a0,1
    80003df2:	9782                	jalr	a5
    80003df4:	8a2a                	mv	s4,a0
    80003df6:	a8a5                	j	80003e6e <filewrite+0xfa>
    80003df8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	8b0080e7          	jalr	-1872(ra) # 800036ac <begin_op>
      ilock(f->ip);
    80003e04:	01893503          	ld	a0,24(s2)
    80003e08:	fffff097          	auipc	ra,0xfffff
    80003e0c:	ed2080e7          	jalr	-302(ra) # 80002cda <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e10:	8762                	mv	a4,s8
    80003e12:	02092683          	lw	a3,32(s2)
    80003e16:	01598633          	add	a2,s3,s5
    80003e1a:	4585                	li	a1,1
    80003e1c:	01893503          	ld	a0,24(s2)
    80003e20:	fffff097          	auipc	ra,0xfffff
    80003e24:	266080e7          	jalr	614(ra) # 80003086 <writei>
    80003e28:	84aa                	mv	s1,a0
    80003e2a:	00a05763          	blez	a0,80003e38 <filewrite+0xc4>
        f->off += r;
    80003e2e:	02092783          	lw	a5,32(s2)
    80003e32:	9fa9                	addw	a5,a5,a0
    80003e34:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e38:	01893503          	ld	a0,24(s2)
    80003e3c:	fffff097          	auipc	ra,0xfffff
    80003e40:	f60080e7          	jalr	-160(ra) # 80002d9c <iunlock>
      end_op();
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	8e8080e7          	jalr	-1816(ra) # 8000372c <end_op>

      if(r != n1){
    80003e4c:	009c1f63          	bne	s8,s1,80003e6a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e50:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e54:	0149db63          	bge	s3,s4,80003e6a <filewrite+0xf6>
      int n1 = n - i;
    80003e58:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e5c:	84be                	mv	s1,a5
    80003e5e:	2781                	sext.w	a5,a5
    80003e60:	f8fb5ce3          	bge	s6,a5,80003df8 <filewrite+0x84>
    80003e64:	84de                	mv	s1,s7
    80003e66:	bf49                	j	80003df8 <filewrite+0x84>
    int i = 0;
    80003e68:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e6a:	013a1f63          	bne	s4,s3,80003e88 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e6e:	8552                	mv	a0,s4
    80003e70:	60a6                	ld	ra,72(sp)
    80003e72:	6406                	ld	s0,64(sp)
    80003e74:	74e2                	ld	s1,56(sp)
    80003e76:	7942                	ld	s2,48(sp)
    80003e78:	79a2                	ld	s3,40(sp)
    80003e7a:	7a02                	ld	s4,32(sp)
    80003e7c:	6ae2                	ld	s5,24(sp)
    80003e7e:	6b42                	ld	s6,16(sp)
    80003e80:	6ba2                	ld	s7,8(sp)
    80003e82:	6c02                	ld	s8,0(sp)
    80003e84:	6161                	addi	sp,sp,80
    80003e86:	8082                	ret
    ret = (i == n ? n : -1);
    80003e88:	5a7d                	li	s4,-1
    80003e8a:	b7d5                	j	80003e6e <filewrite+0xfa>
    panic("filewrite");
    80003e8c:	00005517          	auipc	a0,0x5
    80003e90:	83c50513          	addi	a0,a0,-1988 # 800086c8 <syscalls+0x268>
    80003e94:	00002097          	auipc	ra,0x2
    80003e98:	ef4080e7          	jalr	-268(ra) # 80005d88 <panic>
    return -1;
    80003e9c:	5a7d                	li	s4,-1
    80003e9e:	bfc1                	j	80003e6e <filewrite+0xfa>
      return -1;
    80003ea0:	5a7d                	li	s4,-1
    80003ea2:	b7f1                	j	80003e6e <filewrite+0xfa>
    80003ea4:	5a7d                	li	s4,-1
    80003ea6:	b7e1                	j	80003e6e <filewrite+0xfa>

0000000080003ea8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ea8:	7179                	addi	sp,sp,-48
    80003eaa:	f406                	sd	ra,40(sp)
    80003eac:	f022                	sd	s0,32(sp)
    80003eae:	ec26                	sd	s1,24(sp)
    80003eb0:	e84a                	sd	s2,16(sp)
    80003eb2:	e44e                	sd	s3,8(sp)
    80003eb4:	e052                	sd	s4,0(sp)
    80003eb6:	1800                	addi	s0,sp,48
    80003eb8:	84aa                	mv	s1,a0
    80003eba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ebc:	0005b023          	sd	zero,0(a1)
    80003ec0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ec4:	00000097          	auipc	ra,0x0
    80003ec8:	bf8080e7          	jalr	-1032(ra) # 80003abc <filealloc>
    80003ecc:	e088                	sd	a0,0(s1)
    80003ece:	c551                	beqz	a0,80003f5a <pipealloc+0xb2>
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	bec080e7          	jalr	-1044(ra) # 80003abc <filealloc>
    80003ed8:	00aa3023          	sd	a0,0(s4)
    80003edc:	c92d                	beqz	a0,80003f4e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ede:	ffffc097          	auipc	ra,0xffffc
    80003ee2:	252080e7          	jalr	594(ra) # 80000130 <kalloc>
    80003ee6:	892a                	mv	s2,a0
    80003ee8:	c125                	beqz	a0,80003f48 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003eea:	4985                	li	s3,1
    80003eec:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ef0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ef4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ef8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003efc:	00004597          	auipc	a1,0x4
    80003f00:	7dc58593          	addi	a1,a1,2012 # 800086d8 <syscalls+0x278>
    80003f04:	00002097          	auipc	ra,0x2
    80003f08:	33e080e7          	jalr	830(ra) # 80006242 <initlock>
  (*f0)->type = FD_PIPE;
    80003f0c:	609c                	ld	a5,0(s1)
    80003f0e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f12:	609c                	ld	a5,0(s1)
    80003f14:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f18:	609c                	ld	a5,0(s1)
    80003f1a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f1e:	609c                	ld	a5,0(s1)
    80003f20:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f24:	000a3783          	ld	a5,0(s4)
    80003f28:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f2c:	000a3783          	ld	a5,0(s4)
    80003f30:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f34:	000a3783          	ld	a5,0(s4)
    80003f38:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f3c:	000a3783          	ld	a5,0(s4)
    80003f40:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f44:	4501                	li	a0,0
    80003f46:	a025                	j	80003f6e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f48:	6088                	ld	a0,0(s1)
    80003f4a:	e501                	bnez	a0,80003f52 <pipealloc+0xaa>
    80003f4c:	a039                	j	80003f5a <pipealloc+0xb2>
    80003f4e:	6088                	ld	a0,0(s1)
    80003f50:	c51d                	beqz	a0,80003f7e <pipealloc+0xd6>
    fileclose(*f0);
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	c26080e7          	jalr	-986(ra) # 80003b78 <fileclose>
  if(*f1)
    80003f5a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f5e:	557d                	li	a0,-1
  if(*f1)
    80003f60:	c799                	beqz	a5,80003f6e <pipealloc+0xc6>
    fileclose(*f1);
    80003f62:	853e                	mv	a0,a5
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	c14080e7          	jalr	-1004(ra) # 80003b78 <fileclose>
  return -1;
    80003f6c:	557d                	li	a0,-1
}
    80003f6e:	70a2                	ld	ra,40(sp)
    80003f70:	7402                	ld	s0,32(sp)
    80003f72:	64e2                	ld	s1,24(sp)
    80003f74:	6942                	ld	s2,16(sp)
    80003f76:	69a2                	ld	s3,8(sp)
    80003f78:	6a02                	ld	s4,0(sp)
    80003f7a:	6145                	addi	sp,sp,48
    80003f7c:	8082                	ret
  return -1;
    80003f7e:	557d                	li	a0,-1
    80003f80:	b7fd                	j	80003f6e <pipealloc+0xc6>

0000000080003f82 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f82:	1101                	addi	sp,sp,-32
    80003f84:	ec06                	sd	ra,24(sp)
    80003f86:	e822                	sd	s0,16(sp)
    80003f88:	e426                	sd	s1,8(sp)
    80003f8a:	e04a                	sd	s2,0(sp)
    80003f8c:	1000                	addi	s0,sp,32
    80003f8e:	84aa                	mv	s1,a0
    80003f90:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	340080e7          	jalr	832(ra) # 800062d2 <acquire>
  if(writable){
    80003f9a:	02090d63          	beqz	s2,80003fd4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f9e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fa2:	21848513          	addi	a0,s1,536
    80003fa6:	ffffe097          	auipc	ra,0xffffe
    80003faa:	834080e7          	jalr	-1996(ra) # 800017da <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fae:	2204b783          	ld	a5,544(s1)
    80003fb2:	eb95                	bnez	a5,80003fe6 <pipeclose+0x64>
    release(&pi->lock);
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	00002097          	auipc	ra,0x2
    80003fba:	3d0080e7          	jalr	976(ra) # 80006386 <release>
    kfree((char*)pi);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	ffffc097          	auipc	ra,0xffffc
    80003fc4:	05c080e7          	jalr	92(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fc8:	60e2                	ld	ra,24(sp)
    80003fca:	6442                	ld	s0,16(sp)
    80003fcc:	64a2                	ld	s1,8(sp)
    80003fce:	6902                	ld	s2,0(sp)
    80003fd0:	6105                	addi	sp,sp,32
    80003fd2:	8082                	ret
    pi->readopen = 0;
    80003fd4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fd8:	21c48513          	addi	a0,s1,540
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	7fe080e7          	jalr	2046(ra) # 800017da <wakeup>
    80003fe4:	b7e9                	j	80003fae <pipeclose+0x2c>
    release(&pi->lock);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	00002097          	auipc	ra,0x2
    80003fec:	39e080e7          	jalr	926(ra) # 80006386 <release>
}
    80003ff0:	bfe1                	j	80003fc8 <pipeclose+0x46>

0000000080003ff2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ff2:	7159                	addi	sp,sp,-112
    80003ff4:	f486                	sd	ra,104(sp)
    80003ff6:	f0a2                	sd	s0,96(sp)
    80003ff8:	eca6                	sd	s1,88(sp)
    80003ffa:	e8ca                	sd	s2,80(sp)
    80003ffc:	e4ce                	sd	s3,72(sp)
    80003ffe:	e0d2                	sd	s4,64(sp)
    80004000:	fc56                	sd	s5,56(sp)
    80004002:	f85a                	sd	s6,48(sp)
    80004004:	f45e                	sd	s7,40(sp)
    80004006:	f062                	sd	s8,32(sp)
    80004008:	ec66                	sd	s9,24(sp)
    8000400a:	1880                	addi	s0,sp,112
    8000400c:	84aa                	mv	s1,a0
    8000400e:	8aae                	mv	s5,a1
    80004010:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004012:	ffffd097          	auipc	ra,0xffffd
    80004016:	f80080e7          	jalr	-128(ra) # 80000f92 <myproc>
    8000401a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000401c:	8526                	mv	a0,s1
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	2b4080e7          	jalr	692(ra) # 800062d2 <acquire>
  while(i < n){
    80004026:	0d405163          	blez	s4,800040e8 <pipewrite+0xf6>
    8000402a:	8ba6                	mv	s7,s1
  int i = 0;
    8000402c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000402e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004030:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004034:	21c48c13          	addi	s8,s1,540
    80004038:	a08d                	j	8000409a <pipewrite+0xa8>
      release(&pi->lock);
    8000403a:	8526                	mv	a0,s1
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	34a080e7          	jalr	842(ra) # 80006386 <release>
      return -1;
    80004044:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004046:	854a                	mv	a0,s2
    80004048:	70a6                	ld	ra,104(sp)
    8000404a:	7406                	ld	s0,96(sp)
    8000404c:	64e6                	ld	s1,88(sp)
    8000404e:	6946                	ld	s2,80(sp)
    80004050:	69a6                	ld	s3,72(sp)
    80004052:	6a06                	ld	s4,64(sp)
    80004054:	7ae2                	ld	s5,56(sp)
    80004056:	7b42                	ld	s6,48(sp)
    80004058:	7ba2                	ld	s7,40(sp)
    8000405a:	7c02                	ld	s8,32(sp)
    8000405c:	6ce2                	ld	s9,24(sp)
    8000405e:	6165                	addi	sp,sp,112
    80004060:	8082                	ret
      wakeup(&pi->nread);
    80004062:	8566                	mv	a0,s9
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	776080e7          	jalr	1910(ra) # 800017da <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000406c:	85de                	mv	a1,s7
    8000406e:	8562                	mv	a0,s8
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	5de080e7          	jalr	1502(ra) # 8000164e <sleep>
    80004078:	a839                	j	80004096 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000407a:	21c4a783          	lw	a5,540(s1)
    8000407e:	0017871b          	addiw	a4,a5,1
    80004082:	20e4ae23          	sw	a4,540(s1)
    80004086:	1ff7f793          	andi	a5,a5,511
    8000408a:	97a6                	add	a5,a5,s1
    8000408c:	f9f44703          	lbu	a4,-97(s0)
    80004090:	00e78c23          	sb	a4,24(a5)
      i++;
    80004094:	2905                	addiw	s2,s2,1
  while(i < n){
    80004096:	03495d63          	bge	s2,s4,800040d0 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000409a:	2204a783          	lw	a5,544(s1)
    8000409e:	dfd1                	beqz	a5,8000403a <pipewrite+0x48>
    800040a0:	0289a783          	lw	a5,40(s3)
    800040a4:	fbd9                	bnez	a5,8000403a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040a6:	2184a783          	lw	a5,536(s1)
    800040aa:	21c4a703          	lw	a4,540(s1)
    800040ae:	2007879b          	addiw	a5,a5,512
    800040b2:	faf708e3          	beq	a4,a5,80004062 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b6:	4685                	li	a3,1
    800040b8:	01590633          	add	a2,s2,s5
    800040bc:	f9f40593          	addi	a1,s0,-97
    800040c0:	0509b503          	ld	a0,80(s3)
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	c1c080e7          	jalr	-996(ra) # 80000ce0 <copyin>
    800040cc:	fb6517e3          	bne	a0,s6,8000407a <pipewrite+0x88>
  wakeup(&pi->nread);
    800040d0:	21848513          	addi	a0,s1,536
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	706080e7          	jalr	1798(ra) # 800017da <wakeup>
  release(&pi->lock);
    800040dc:	8526                	mv	a0,s1
    800040de:	00002097          	auipc	ra,0x2
    800040e2:	2a8080e7          	jalr	680(ra) # 80006386 <release>
  return i;
    800040e6:	b785                	j	80004046 <pipewrite+0x54>
  int i = 0;
    800040e8:	4901                	li	s2,0
    800040ea:	b7dd                	j	800040d0 <pipewrite+0xde>

00000000800040ec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040ec:	715d                	addi	sp,sp,-80
    800040ee:	e486                	sd	ra,72(sp)
    800040f0:	e0a2                	sd	s0,64(sp)
    800040f2:	fc26                	sd	s1,56(sp)
    800040f4:	f84a                	sd	s2,48(sp)
    800040f6:	f44e                	sd	s3,40(sp)
    800040f8:	f052                	sd	s4,32(sp)
    800040fa:	ec56                	sd	s5,24(sp)
    800040fc:	e85a                	sd	s6,16(sp)
    800040fe:	0880                	addi	s0,sp,80
    80004100:	84aa                	mv	s1,a0
    80004102:	892e                	mv	s2,a1
    80004104:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	e8c080e7          	jalr	-372(ra) # 80000f92 <myproc>
    8000410e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004110:	8b26                	mv	s6,s1
    80004112:	8526                	mv	a0,s1
    80004114:	00002097          	auipc	ra,0x2
    80004118:	1be080e7          	jalr	446(ra) # 800062d2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000411c:	2184a703          	lw	a4,536(s1)
    80004120:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004124:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004128:	02f71463          	bne	a4,a5,80004150 <piperead+0x64>
    8000412c:	2244a783          	lw	a5,548(s1)
    80004130:	c385                	beqz	a5,80004150 <piperead+0x64>
    if(pr->killed){
    80004132:	028a2783          	lw	a5,40(s4)
    80004136:	ebc1                	bnez	a5,800041c6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004138:	85da                	mv	a1,s6
    8000413a:	854e                	mv	a0,s3
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	512080e7          	jalr	1298(ra) # 8000164e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004144:	2184a703          	lw	a4,536(s1)
    80004148:	21c4a783          	lw	a5,540(s1)
    8000414c:	fef700e3          	beq	a4,a5,8000412c <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004150:	09505263          	blez	s5,800041d4 <piperead+0xe8>
    80004154:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004156:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004158:	2184a783          	lw	a5,536(s1)
    8000415c:	21c4a703          	lw	a4,540(s1)
    80004160:	02f70d63          	beq	a4,a5,8000419a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004164:	0017871b          	addiw	a4,a5,1
    80004168:	20e4ac23          	sw	a4,536(s1)
    8000416c:	1ff7f793          	andi	a5,a5,511
    80004170:	97a6                	add	a5,a5,s1
    80004172:	0187c783          	lbu	a5,24(a5)
    80004176:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000417a:	4685                	li	a3,1
    8000417c:	fbf40613          	addi	a2,s0,-65
    80004180:	85ca                	mv	a1,s2
    80004182:	050a3503          	ld	a0,80(s4)
    80004186:	ffffd097          	auipc	ra,0xffffd
    8000418a:	9f2080e7          	jalr	-1550(ra) # 80000b78 <copyout>
    8000418e:	01650663          	beq	a0,s6,8000419a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004192:	2985                	addiw	s3,s3,1
    80004194:	0905                	addi	s2,s2,1
    80004196:	fd3a91e3          	bne	s5,s3,80004158 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000419a:	21c48513          	addi	a0,s1,540
    8000419e:	ffffd097          	auipc	ra,0xffffd
    800041a2:	63c080e7          	jalr	1596(ra) # 800017da <wakeup>
  release(&pi->lock);
    800041a6:	8526                	mv	a0,s1
    800041a8:	00002097          	auipc	ra,0x2
    800041ac:	1de080e7          	jalr	478(ra) # 80006386 <release>
  return i;
}
    800041b0:	854e                	mv	a0,s3
    800041b2:	60a6                	ld	ra,72(sp)
    800041b4:	6406                	ld	s0,64(sp)
    800041b6:	74e2                	ld	s1,56(sp)
    800041b8:	7942                	ld	s2,48(sp)
    800041ba:	79a2                	ld	s3,40(sp)
    800041bc:	7a02                	ld	s4,32(sp)
    800041be:	6ae2                	ld	s5,24(sp)
    800041c0:	6b42                	ld	s6,16(sp)
    800041c2:	6161                	addi	sp,sp,80
    800041c4:	8082                	ret
      release(&pi->lock);
    800041c6:	8526                	mv	a0,s1
    800041c8:	00002097          	auipc	ra,0x2
    800041cc:	1be080e7          	jalr	446(ra) # 80006386 <release>
      return -1;
    800041d0:	59fd                	li	s3,-1
    800041d2:	bff9                	j	800041b0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041d4:	4981                	li	s3,0
    800041d6:	b7d1                	j	8000419a <piperead+0xae>

00000000800041d8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041d8:	df010113          	addi	sp,sp,-528
    800041dc:	20113423          	sd	ra,520(sp)
    800041e0:	20813023          	sd	s0,512(sp)
    800041e4:	ffa6                	sd	s1,504(sp)
    800041e6:	fbca                	sd	s2,496(sp)
    800041e8:	f7ce                	sd	s3,488(sp)
    800041ea:	f3d2                	sd	s4,480(sp)
    800041ec:	efd6                	sd	s5,472(sp)
    800041ee:	ebda                	sd	s6,464(sp)
    800041f0:	e7de                	sd	s7,456(sp)
    800041f2:	e3e2                	sd	s8,448(sp)
    800041f4:	ff66                	sd	s9,440(sp)
    800041f6:	fb6a                	sd	s10,432(sp)
    800041f8:	f76e                	sd	s11,424(sp)
    800041fa:	0c00                	addi	s0,sp,528
    800041fc:	84aa                	mv	s1,a0
    800041fe:	dea43c23          	sd	a0,-520(s0)
    80004202:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	d8c080e7          	jalr	-628(ra) # 80000f92 <myproc>
    8000420e:	892a                	mv	s2,a0

  begin_op();
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	49c080e7          	jalr	1180(ra) # 800036ac <begin_op>

  if((ip = namei(path)) == 0){
    80004218:	8526                	mv	a0,s1
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	276080e7          	jalr	630(ra) # 80003490 <namei>
    80004222:	c92d                	beqz	a0,80004294 <exec+0xbc>
    80004224:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	ab4080e7          	jalr	-1356(ra) # 80002cda <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000422e:	04000713          	li	a4,64
    80004232:	4681                	li	a3,0
    80004234:	e5040613          	addi	a2,s0,-432
    80004238:	4581                	li	a1,0
    8000423a:	8526                	mv	a0,s1
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	d52080e7          	jalr	-686(ra) # 80002f8e <readi>
    80004244:	04000793          	li	a5,64
    80004248:	00f51a63          	bne	a0,a5,8000425c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000424c:	e5042703          	lw	a4,-432(s0)
    80004250:	464c47b7          	lui	a5,0x464c4
    80004254:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004258:	04f70463          	beq	a4,a5,800042a0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000425c:	8526                	mv	a0,s1
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	cde080e7          	jalr	-802(ra) # 80002f3c <iunlockput>
    end_op();
    80004266:	fffff097          	auipc	ra,0xfffff
    8000426a:	4c6080e7          	jalr	1222(ra) # 8000372c <end_op>
  }
  return -1;
    8000426e:	557d                	li	a0,-1
}
    80004270:	20813083          	ld	ra,520(sp)
    80004274:	20013403          	ld	s0,512(sp)
    80004278:	74fe                	ld	s1,504(sp)
    8000427a:	795e                	ld	s2,496(sp)
    8000427c:	79be                	ld	s3,488(sp)
    8000427e:	7a1e                	ld	s4,480(sp)
    80004280:	6afe                	ld	s5,472(sp)
    80004282:	6b5e                	ld	s6,464(sp)
    80004284:	6bbe                	ld	s7,456(sp)
    80004286:	6c1e                	ld	s8,448(sp)
    80004288:	7cfa                	ld	s9,440(sp)
    8000428a:	7d5a                	ld	s10,432(sp)
    8000428c:	7dba                	ld	s11,424(sp)
    8000428e:	21010113          	addi	sp,sp,528
    80004292:	8082                	ret
    end_op();
    80004294:	fffff097          	auipc	ra,0xfffff
    80004298:	498080e7          	jalr	1176(ra) # 8000372c <end_op>
    return -1;
    8000429c:	557d                	li	a0,-1
    8000429e:	bfc9                	j	80004270 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042a0:	854a                	mv	a0,s2
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	db4080e7          	jalr	-588(ra) # 80001056 <proc_pagetable>
    800042aa:	8baa                	mv	s7,a0
    800042ac:	d945                	beqz	a0,8000425c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ae:	e7042983          	lw	s3,-400(s0)
    800042b2:	e8845783          	lhu	a5,-376(s0)
    800042b6:	c7ad                	beqz	a5,80004320 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042b8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ba:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042bc:	6c85                	lui	s9,0x1
    800042be:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042c2:	def43823          	sd	a5,-528(s0)
    800042c6:	a42d                	j	800044f0 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042c8:	00004517          	auipc	a0,0x4
    800042cc:	41850513          	addi	a0,a0,1048 # 800086e0 <syscalls+0x280>
    800042d0:	00002097          	auipc	ra,0x2
    800042d4:	ab8080e7          	jalr	-1352(ra) # 80005d88 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042d8:	8756                	mv	a4,s5
    800042da:	012d86bb          	addw	a3,s11,s2
    800042de:	4581                	li	a1,0
    800042e0:	8526                	mv	a0,s1
    800042e2:	fffff097          	auipc	ra,0xfffff
    800042e6:	cac080e7          	jalr	-852(ra) # 80002f8e <readi>
    800042ea:	2501                	sext.w	a0,a0
    800042ec:	1aaa9963          	bne	s5,a0,8000449e <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042f0:	6785                	lui	a5,0x1
    800042f2:	0127893b          	addw	s2,a5,s2
    800042f6:	77fd                	lui	a5,0xfffff
    800042f8:	01478a3b          	addw	s4,a5,s4
    800042fc:	1f897163          	bgeu	s2,s8,800044de <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004300:	02091593          	slli	a1,s2,0x20
    80004304:	9181                	srli	a1,a1,0x20
    80004306:	95ea                	add	a1,a1,s10
    80004308:	855e                	mv	a0,s7
    8000430a:	ffffc097          	auipc	ra,0xffffc
    8000430e:	214080e7          	jalr	532(ra) # 8000051e <walkaddr>
    80004312:	862a                	mv	a2,a0
    if(pa == 0)
    80004314:	d955                	beqz	a0,800042c8 <exec+0xf0>
      n = PGSIZE;
    80004316:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004318:	fd9a70e3          	bgeu	s4,s9,800042d8 <exec+0x100>
      n = sz - i;
    8000431c:	8ad2                	mv	s5,s4
    8000431e:	bf6d                	j	800042d8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004320:	4901                	li	s2,0
  iunlockput(ip);
    80004322:	8526                	mv	a0,s1
    80004324:	fffff097          	auipc	ra,0xfffff
    80004328:	c18080e7          	jalr	-1000(ra) # 80002f3c <iunlockput>
  end_op();
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	400080e7          	jalr	1024(ra) # 8000372c <end_op>
  p = myproc();
    80004334:	ffffd097          	auipc	ra,0xffffd
    80004338:	c5e080e7          	jalr	-930(ra) # 80000f92 <myproc>
    8000433c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000433e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004342:	6785                	lui	a5,0x1
    80004344:	17fd                	addi	a5,a5,-1
    80004346:	993e                	add	s2,s2,a5
    80004348:	757d                	lui	a0,0xfffff
    8000434a:	00a977b3          	and	a5,s2,a0
    8000434e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004352:	6609                	lui	a2,0x2
    80004354:	963e                	add	a2,a2,a5
    80004356:	85be                	mv	a1,a5
    80004358:	855e                	mv	a0,s7
    8000435a:	ffffc097          	auipc	ra,0xffffc
    8000435e:	5b6080e7          	jalr	1462(ra) # 80000910 <uvmalloc>
    80004362:	8b2a                	mv	s6,a0
  ip = 0;
    80004364:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004366:	12050c63          	beqz	a0,8000449e <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000436a:	75f9                	lui	a1,0xffffe
    8000436c:	95aa                	add	a1,a1,a0
    8000436e:	855e                	mv	a0,s7
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	7d6080e7          	jalr	2006(ra) # 80000b46 <uvmclear>
  stackbase = sp - PGSIZE;
    80004378:	7c7d                	lui	s8,0xfffff
    8000437a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000437c:	e0043783          	ld	a5,-512(s0)
    80004380:	6388                	ld	a0,0(a5)
    80004382:	c535                	beqz	a0,800043ee <exec+0x216>
    80004384:	e9040993          	addi	s3,s0,-368
    80004388:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000438c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	f86080e7          	jalr	-122(ra) # 80000314 <strlen>
    80004396:	2505                	addiw	a0,a0,1
    80004398:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000439c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043a0:	13896363          	bltu	s2,s8,800044c6 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043a4:	e0043d83          	ld	s11,-512(s0)
    800043a8:	000dba03          	ld	s4,0(s11) # 8000000 <_entry-0x78000000>
    800043ac:	8552                	mv	a0,s4
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	f66080e7          	jalr	-154(ra) # 80000314 <strlen>
    800043b6:	0015069b          	addiw	a3,a0,1
    800043ba:	8652                	mv	a2,s4
    800043bc:	85ca                	mv	a1,s2
    800043be:	855e                	mv	a0,s7
    800043c0:	ffffc097          	auipc	ra,0xffffc
    800043c4:	7b8080e7          	jalr	1976(ra) # 80000b78 <copyout>
    800043c8:	10054363          	bltz	a0,800044ce <exec+0x2f6>
    ustack[argc] = sp;
    800043cc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043d0:	0485                	addi	s1,s1,1
    800043d2:	008d8793          	addi	a5,s11,8
    800043d6:	e0f43023          	sd	a5,-512(s0)
    800043da:	008db503          	ld	a0,8(s11)
    800043de:	c911                	beqz	a0,800043f2 <exec+0x21a>
    if(argc >= MAXARG)
    800043e0:	09a1                	addi	s3,s3,8
    800043e2:	fb3c96e3          	bne	s9,s3,8000438e <exec+0x1b6>
  sz = sz1;
    800043e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ea:	4481                	li	s1,0
    800043ec:	a84d                	j	8000449e <exec+0x2c6>
  sp = sz;
    800043ee:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043f0:	4481                	li	s1,0
  ustack[argc] = 0;
    800043f2:	00349793          	slli	a5,s1,0x3
    800043f6:	f9040713          	addi	a4,s0,-112
    800043fa:	97ba                	add	a5,a5,a4
    800043fc:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004400:	00148693          	addi	a3,s1,1
    80004404:	068e                	slli	a3,a3,0x3
    80004406:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000440a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000440e:	01897663          	bgeu	s2,s8,8000441a <exec+0x242>
  sz = sz1;
    80004412:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004416:	4481                	li	s1,0
    80004418:	a059                	j	8000449e <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000441a:	e9040613          	addi	a2,s0,-368
    8000441e:	85ca                	mv	a1,s2
    80004420:	855e                	mv	a0,s7
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	756080e7          	jalr	1878(ra) # 80000b78 <copyout>
    8000442a:	0a054663          	bltz	a0,800044d6 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000442e:	058ab783          	ld	a5,88(s5)
    80004432:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004436:	df843783          	ld	a5,-520(s0)
    8000443a:	0007c703          	lbu	a4,0(a5)
    8000443e:	cf11                	beqz	a4,8000445a <exec+0x282>
    80004440:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004442:	02f00693          	li	a3,47
    80004446:	a039                	j	80004454 <exec+0x27c>
      last = s+1;
    80004448:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000444c:	0785                	addi	a5,a5,1
    8000444e:	fff7c703          	lbu	a4,-1(a5)
    80004452:	c701                	beqz	a4,8000445a <exec+0x282>
    if(*s == '/')
    80004454:	fed71ce3          	bne	a4,a3,8000444c <exec+0x274>
    80004458:	bfc5                	j	80004448 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000445a:	4641                	li	a2,16
    8000445c:	df843583          	ld	a1,-520(s0)
    80004460:	158a8513          	addi	a0,s5,344
    80004464:	ffffc097          	auipc	ra,0xffffc
    80004468:	e7e080e7          	jalr	-386(ra) # 800002e2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000446c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004470:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004474:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004478:	058ab783          	ld	a5,88(s5)
    8000447c:	e6843703          	ld	a4,-408(s0)
    80004480:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004482:	058ab783          	ld	a5,88(s5)
    80004486:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000448a:	85ea                	mv	a1,s10
    8000448c:	ffffd097          	auipc	ra,0xffffd
    80004490:	c66080e7          	jalr	-922(ra) # 800010f2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004494:	0004851b          	sext.w	a0,s1
    80004498:	bbe1                	j	80004270 <exec+0x98>
    8000449a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000449e:	e0843583          	ld	a1,-504(s0)
    800044a2:	855e                	mv	a0,s7
    800044a4:	ffffd097          	auipc	ra,0xffffd
    800044a8:	c4e080e7          	jalr	-946(ra) # 800010f2 <proc_freepagetable>
  if(ip){
    800044ac:	da0498e3          	bnez	s1,8000425c <exec+0x84>
  return -1;
    800044b0:	557d                	li	a0,-1
    800044b2:	bb7d                	j	80004270 <exec+0x98>
    800044b4:	e1243423          	sd	s2,-504(s0)
    800044b8:	b7dd                	j	8000449e <exec+0x2c6>
    800044ba:	e1243423          	sd	s2,-504(s0)
    800044be:	b7c5                	j	8000449e <exec+0x2c6>
    800044c0:	e1243423          	sd	s2,-504(s0)
    800044c4:	bfe9                	j	8000449e <exec+0x2c6>
  sz = sz1;
    800044c6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ca:	4481                	li	s1,0
    800044cc:	bfc9                	j	8000449e <exec+0x2c6>
  sz = sz1;
    800044ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044d2:	4481                	li	s1,0
    800044d4:	b7e9                	j	8000449e <exec+0x2c6>
  sz = sz1;
    800044d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044da:	4481                	li	s1,0
    800044dc:	b7c9                	j	8000449e <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044de:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044e2:	2b05                	addiw	s6,s6,1
    800044e4:	0389899b          	addiw	s3,s3,56
    800044e8:	e8845783          	lhu	a5,-376(s0)
    800044ec:	e2fb5be3          	bge	s6,a5,80004322 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044f0:	2981                	sext.w	s3,s3
    800044f2:	03800713          	li	a4,56
    800044f6:	86ce                	mv	a3,s3
    800044f8:	e1840613          	addi	a2,s0,-488
    800044fc:	4581                	li	a1,0
    800044fe:	8526                	mv	a0,s1
    80004500:	fffff097          	auipc	ra,0xfffff
    80004504:	a8e080e7          	jalr	-1394(ra) # 80002f8e <readi>
    80004508:	03800793          	li	a5,56
    8000450c:	f8f517e3          	bne	a0,a5,8000449a <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004510:	e1842783          	lw	a5,-488(s0)
    80004514:	4705                	li	a4,1
    80004516:	fce796e3          	bne	a5,a4,800044e2 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000451a:	e4043603          	ld	a2,-448(s0)
    8000451e:	e3843783          	ld	a5,-456(s0)
    80004522:	f8f669e3          	bltu	a2,a5,800044b4 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004526:	e2843783          	ld	a5,-472(s0)
    8000452a:	963e                	add	a2,a2,a5
    8000452c:	f8f667e3          	bltu	a2,a5,800044ba <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004530:	85ca                	mv	a1,s2
    80004532:	855e                	mv	a0,s7
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	3dc080e7          	jalr	988(ra) # 80000910 <uvmalloc>
    8000453c:	e0a43423          	sd	a0,-504(s0)
    80004540:	d141                	beqz	a0,800044c0 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004542:	e2843d03          	ld	s10,-472(s0)
    80004546:	df043783          	ld	a5,-528(s0)
    8000454a:	00fd77b3          	and	a5,s10,a5
    8000454e:	fba1                	bnez	a5,8000449e <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004550:	e2042d83          	lw	s11,-480(s0)
    80004554:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004558:	f80c03e3          	beqz	s8,800044de <exec+0x306>
    8000455c:	8a62                	mv	s4,s8
    8000455e:	4901                	li	s2,0
    80004560:	b345                	j	80004300 <exec+0x128>

0000000080004562 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004562:	7179                	addi	sp,sp,-48
    80004564:	f406                	sd	ra,40(sp)
    80004566:	f022                	sd	s0,32(sp)
    80004568:	ec26                	sd	s1,24(sp)
    8000456a:	e84a                	sd	s2,16(sp)
    8000456c:	1800                	addi	s0,sp,48
    8000456e:	892e                	mv	s2,a1
    80004570:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004572:	fdc40593          	addi	a1,s0,-36
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	bf2080e7          	jalr	-1038(ra) # 80002168 <argint>
    8000457e:	04054063          	bltz	a0,800045be <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004582:	fdc42703          	lw	a4,-36(s0)
    80004586:	47bd                	li	a5,15
    80004588:	02e7ed63          	bltu	a5,a4,800045c2 <argfd+0x60>
    8000458c:	ffffd097          	auipc	ra,0xffffd
    80004590:	a06080e7          	jalr	-1530(ra) # 80000f92 <myproc>
    80004594:	fdc42703          	lw	a4,-36(s0)
    80004598:	01a70793          	addi	a5,a4,26
    8000459c:	078e                	slli	a5,a5,0x3
    8000459e:	953e                	add	a0,a0,a5
    800045a0:	611c                	ld	a5,0(a0)
    800045a2:	c395                	beqz	a5,800045c6 <argfd+0x64>
    return -1;
  if(pfd)
    800045a4:	00090463          	beqz	s2,800045ac <argfd+0x4a>
    *pfd = fd;
    800045a8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045ac:	4501                	li	a0,0
  if(pf)
    800045ae:	c091                	beqz	s1,800045b2 <argfd+0x50>
    *pf = f;
    800045b0:	e09c                	sd	a5,0(s1)
}
    800045b2:	70a2                	ld	ra,40(sp)
    800045b4:	7402                	ld	s0,32(sp)
    800045b6:	64e2                	ld	s1,24(sp)
    800045b8:	6942                	ld	s2,16(sp)
    800045ba:	6145                	addi	sp,sp,48
    800045bc:	8082                	ret
    return -1;
    800045be:	557d                	li	a0,-1
    800045c0:	bfcd                	j	800045b2 <argfd+0x50>
    return -1;
    800045c2:	557d                	li	a0,-1
    800045c4:	b7fd                	j	800045b2 <argfd+0x50>
    800045c6:	557d                	li	a0,-1
    800045c8:	b7ed                	j	800045b2 <argfd+0x50>

00000000800045ca <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045ca:	1101                	addi	sp,sp,-32
    800045cc:	ec06                	sd	ra,24(sp)
    800045ce:	e822                	sd	s0,16(sp)
    800045d0:	e426                	sd	s1,8(sp)
    800045d2:	1000                	addi	s0,sp,32
    800045d4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045d6:	ffffd097          	auipc	ra,0xffffd
    800045da:	9bc080e7          	jalr	-1604(ra) # 80000f92 <myproc>
    800045de:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045e0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800045e4:	4501                	li	a0,0
    800045e6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045e8:	6398                	ld	a4,0(a5)
    800045ea:	cb19                	beqz	a4,80004600 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045ec:	2505                	addiw	a0,a0,1
    800045ee:	07a1                	addi	a5,a5,8
    800045f0:	fed51ce3          	bne	a0,a3,800045e8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045f4:	557d                	li	a0,-1
}
    800045f6:	60e2                	ld	ra,24(sp)
    800045f8:	6442                	ld	s0,16(sp)
    800045fa:	64a2                	ld	s1,8(sp)
    800045fc:	6105                	addi	sp,sp,32
    800045fe:	8082                	ret
      p->ofile[fd] = f;
    80004600:	01a50793          	addi	a5,a0,26
    80004604:	078e                	slli	a5,a5,0x3
    80004606:	963e                	add	a2,a2,a5
    80004608:	e204                	sd	s1,0(a2)
      return fd;
    8000460a:	b7f5                	j	800045f6 <fdalloc+0x2c>

000000008000460c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000460c:	715d                	addi	sp,sp,-80
    8000460e:	e486                	sd	ra,72(sp)
    80004610:	e0a2                	sd	s0,64(sp)
    80004612:	fc26                	sd	s1,56(sp)
    80004614:	f84a                	sd	s2,48(sp)
    80004616:	f44e                	sd	s3,40(sp)
    80004618:	f052                	sd	s4,32(sp)
    8000461a:	ec56                	sd	s5,24(sp)
    8000461c:	0880                	addi	s0,sp,80
    8000461e:	89ae                	mv	s3,a1
    80004620:	8ab2                	mv	s5,a2
    80004622:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004624:	fb040593          	addi	a1,s0,-80
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	e86080e7          	jalr	-378(ra) # 800034ae <nameiparent>
    80004630:	892a                	mv	s2,a0
    80004632:	12050f63          	beqz	a0,80004770 <create+0x164>
    return 0;

  ilock(dp);
    80004636:	ffffe097          	auipc	ra,0xffffe
    8000463a:	6a4080e7          	jalr	1700(ra) # 80002cda <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000463e:	4601                	li	a2,0
    80004640:	fb040593          	addi	a1,s0,-80
    80004644:	854a                	mv	a0,s2
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	b78080e7          	jalr	-1160(ra) # 800031be <dirlookup>
    8000464e:	84aa                	mv	s1,a0
    80004650:	c921                	beqz	a0,800046a0 <create+0x94>
    iunlockput(dp);
    80004652:	854a                	mv	a0,s2
    80004654:	fffff097          	auipc	ra,0xfffff
    80004658:	8e8080e7          	jalr	-1816(ra) # 80002f3c <iunlockput>
    ilock(ip);
    8000465c:	8526                	mv	a0,s1
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	67c080e7          	jalr	1660(ra) # 80002cda <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004666:	2981                	sext.w	s3,s3
    80004668:	4789                	li	a5,2
    8000466a:	02f99463          	bne	s3,a5,80004692 <create+0x86>
    8000466e:	0444d783          	lhu	a5,68(s1)
    80004672:	37f9                	addiw	a5,a5,-2
    80004674:	17c2                	slli	a5,a5,0x30
    80004676:	93c1                	srli	a5,a5,0x30
    80004678:	4705                	li	a4,1
    8000467a:	00f76c63          	bltu	a4,a5,80004692 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000467e:	8526                	mv	a0,s1
    80004680:	60a6                	ld	ra,72(sp)
    80004682:	6406                	ld	s0,64(sp)
    80004684:	74e2                	ld	s1,56(sp)
    80004686:	7942                	ld	s2,48(sp)
    80004688:	79a2                	ld	s3,40(sp)
    8000468a:	7a02                	ld	s4,32(sp)
    8000468c:	6ae2                	ld	s5,24(sp)
    8000468e:	6161                	addi	sp,sp,80
    80004690:	8082                	ret
    iunlockput(ip);
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	8a8080e7          	jalr	-1880(ra) # 80002f3c <iunlockput>
    return 0;
    8000469c:	4481                	li	s1,0
    8000469e:	b7c5                	j	8000467e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046a0:	85ce                	mv	a1,s3
    800046a2:	00092503          	lw	a0,0(s2)
    800046a6:	ffffe097          	auipc	ra,0xffffe
    800046aa:	49c080e7          	jalr	1180(ra) # 80002b42 <ialloc>
    800046ae:	84aa                	mv	s1,a0
    800046b0:	c529                	beqz	a0,800046fa <create+0xee>
  ilock(ip);
    800046b2:	ffffe097          	auipc	ra,0xffffe
    800046b6:	628080e7          	jalr	1576(ra) # 80002cda <ilock>
  ip->major = major;
    800046ba:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046be:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046c2:	4785                	li	a5,1
    800046c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800046c8:	8526                	mv	a0,s1
    800046ca:	ffffe097          	auipc	ra,0xffffe
    800046ce:	546080e7          	jalr	1350(ra) # 80002c10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046d2:	2981                	sext.w	s3,s3
    800046d4:	4785                	li	a5,1
    800046d6:	02f98a63          	beq	s3,a5,8000470a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046da:	40d0                	lw	a2,4(s1)
    800046dc:	fb040593          	addi	a1,s0,-80
    800046e0:	854a                	mv	a0,s2
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	cec080e7          	jalr	-788(ra) # 800033ce <dirlink>
    800046ea:	06054b63          	bltz	a0,80004760 <create+0x154>
  iunlockput(dp);
    800046ee:	854a                	mv	a0,s2
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	84c080e7          	jalr	-1972(ra) # 80002f3c <iunlockput>
  return ip;
    800046f8:	b759                	j	8000467e <create+0x72>
    panic("create: ialloc");
    800046fa:	00004517          	auipc	a0,0x4
    800046fe:	00650513          	addi	a0,a0,6 # 80008700 <syscalls+0x2a0>
    80004702:	00001097          	auipc	ra,0x1
    80004706:	686080e7          	jalr	1670(ra) # 80005d88 <panic>
    dp->nlink++;  // for ".."
    8000470a:	04a95783          	lhu	a5,74(s2)
    8000470e:	2785                	addiw	a5,a5,1
    80004710:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004714:	854a                	mv	a0,s2
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	4fa080e7          	jalr	1274(ra) # 80002c10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000471e:	40d0                	lw	a2,4(s1)
    80004720:	00004597          	auipc	a1,0x4
    80004724:	ff058593          	addi	a1,a1,-16 # 80008710 <syscalls+0x2b0>
    80004728:	8526                	mv	a0,s1
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	ca4080e7          	jalr	-860(ra) # 800033ce <dirlink>
    80004732:	00054f63          	bltz	a0,80004750 <create+0x144>
    80004736:	00492603          	lw	a2,4(s2)
    8000473a:	00004597          	auipc	a1,0x4
    8000473e:	fde58593          	addi	a1,a1,-34 # 80008718 <syscalls+0x2b8>
    80004742:	8526                	mv	a0,s1
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	c8a080e7          	jalr	-886(ra) # 800033ce <dirlink>
    8000474c:	f80557e3          	bgez	a0,800046da <create+0xce>
      panic("create dots");
    80004750:	00004517          	auipc	a0,0x4
    80004754:	fd050513          	addi	a0,a0,-48 # 80008720 <syscalls+0x2c0>
    80004758:	00001097          	auipc	ra,0x1
    8000475c:	630080e7          	jalr	1584(ra) # 80005d88 <panic>
    panic("create: dirlink");
    80004760:	00004517          	auipc	a0,0x4
    80004764:	fd050513          	addi	a0,a0,-48 # 80008730 <syscalls+0x2d0>
    80004768:	00001097          	auipc	ra,0x1
    8000476c:	620080e7          	jalr	1568(ra) # 80005d88 <panic>
    return 0;
    80004770:	84aa                	mv	s1,a0
    80004772:	b731                	j	8000467e <create+0x72>

0000000080004774 <sys_dup>:
{
    80004774:	7179                	addi	sp,sp,-48
    80004776:	f406                	sd	ra,40(sp)
    80004778:	f022                	sd	s0,32(sp)
    8000477a:	ec26                	sd	s1,24(sp)
    8000477c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000477e:	fd840613          	addi	a2,s0,-40
    80004782:	4581                	li	a1,0
    80004784:	4501                	li	a0,0
    80004786:	00000097          	auipc	ra,0x0
    8000478a:	ddc080e7          	jalr	-548(ra) # 80004562 <argfd>
    return -1;
    8000478e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004790:	02054363          	bltz	a0,800047b6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004794:	fd843503          	ld	a0,-40(s0)
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	e32080e7          	jalr	-462(ra) # 800045ca <fdalloc>
    800047a0:	84aa                	mv	s1,a0
    return -1;
    800047a2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047a4:	00054963          	bltz	a0,800047b6 <sys_dup+0x42>
  filedup(f);
    800047a8:	fd843503          	ld	a0,-40(s0)
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	37a080e7          	jalr	890(ra) # 80003b26 <filedup>
  return fd;
    800047b4:	87a6                	mv	a5,s1
}
    800047b6:	853e                	mv	a0,a5
    800047b8:	70a2                	ld	ra,40(sp)
    800047ba:	7402                	ld	s0,32(sp)
    800047bc:	64e2                	ld	s1,24(sp)
    800047be:	6145                	addi	sp,sp,48
    800047c0:	8082                	ret

00000000800047c2 <sys_read>:
{
    800047c2:	7179                	addi	sp,sp,-48
    800047c4:	f406                	sd	ra,40(sp)
    800047c6:	f022                	sd	s0,32(sp)
    800047c8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ca:	fe840613          	addi	a2,s0,-24
    800047ce:	4581                	li	a1,0
    800047d0:	4501                	li	a0,0
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	d90080e7          	jalr	-624(ra) # 80004562 <argfd>
    return -1;
    800047da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047dc:	04054163          	bltz	a0,8000481e <sys_read+0x5c>
    800047e0:	fe440593          	addi	a1,s0,-28
    800047e4:	4509                	li	a0,2
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	982080e7          	jalr	-1662(ra) # 80002168 <argint>
    return -1;
    800047ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f0:	02054763          	bltz	a0,8000481e <sys_read+0x5c>
    800047f4:	fd840593          	addi	a1,s0,-40
    800047f8:	4505                	li	a0,1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	990080e7          	jalr	-1648(ra) # 8000218a <argaddr>
    return -1;
    80004802:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004804:	00054d63          	bltz	a0,8000481e <sys_read+0x5c>
  return fileread(f, p, n);
    80004808:	fe442603          	lw	a2,-28(s0)
    8000480c:	fd843583          	ld	a1,-40(s0)
    80004810:	fe843503          	ld	a0,-24(s0)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	49e080e7          	jalr	1182(ra) # 80003cb2 <fileread>
    8000481c:	87aa                	mv	a5,a0
}
    8000481e:	853e                	mv	a0,a5
    80004820:	70a2                	ld	ra,40(sp)
    80004822:	7402                	ld	s0,32(sp)
    80004824:	6145                	addi	sp,sp,48
    80004826:	8082                	ret

0000000080004828 <sys_write>:
{
    80004828:	7179                	addi	sp,sp,-48
    8000482a:	f406                	sd	ra,40(sp)
    8000482c:	f022                	sd	s0,32(sp)
    8000482e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004830:	fe840613          	addi	a2,s0,-24
    80004834:	4581                	li	a1,0
    80004836:	4501                	li	a0,0
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	d2a080e7          	jalr	-726(ra) # 80004562 <argfd>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004842:	04054163          	bltz	a0,80004884 <sys_write+0x5c>
    80004846:	fe440593          	addi	a1,s0,-28
    8000484a:	4509                	li	a0,2
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	91c080e7          	jalr	-1764(ra) # 80002168 <argint>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004856:	02054763          	bltz	a0,80004884 <sys_write+0x5c>
    8000485a:	fd840593          	addi	a1,s0,-40
    8000485e:	4505                	li	a0,1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	92a080e7          	jalr	-1750(ra) # 8000218a <argaddr>
    return -1;
    80004868:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	00054d63          	bltz	a0,80004884 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000486e:	fe442603          	lw	a2,-28(s0)
    80004872:	fd843583          	ld	a1,-40(s0)
    80004876:	fe843503          	ld	a0,-24(s0)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	4fa080e7          	jalr	1274(ra) # 80003d74 <filewrite>
    80004882:	87aa                	mv	a5,a0
}
    80004884:	853e                	mv	a0,a5
    80004886:	70a2                	ld	ra,40(sp)
    80004888:	7402                	ld	s0,32(sp)
    8000488a:	6145                	addi	sp,sp,48
    8000488c:	8082                	ret

000000008000488e <sys_close>:
{
    8000488e:	1101                	addi	sp,sp,-32
    80004890:	ec06                	sd	ra,24(sp)
    80004892:	e822                	sd	s0,16(sp)
    80004894:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004896:	fe040613          	addi	a2,s0,-32
    8000489a:	fec40593          	addi	a1,s0,-20
    8000489e:	4501                	li	a0,0
    800048a0:	00000097          	auipc	ra,0x0
    800048a4:	cc2080e7          	jalr	-830(ra) # 80004562 <argfd>
    return -1;
    800048a8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048aa:	02054463          	bltz	a0,800048d2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048ae:	ffffc097          	auipc	ra,0xffffc
    800048b2:	6e4080e7          	jalr	1764(ra) # 80000f92 <myproc>
    800048b6:	fec42783          	lw	a5,-20(s0)
    800048ba:	07e9                	addi	a5,a5,26
    800048bc:	078e                	slli	a5,a5,0x3
    800048be:	97aa                	add	a5,a5,a0
    800048c0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048c4:	fe043503          	ld	a0,-32(s0)
    800048c8:	fffff097          	auipc	ra,0xfffff
    800048cc:	2b0080e7          	jalr	688(ra) # 80003b78 <fileclose>
  return 0;
    800048d0:	4781                	li	a5,0
}
    800048d2:	853e                	mv	a0,a5
    800048d4:	60e2                	ld	ra,24(sp)
    800048d6:	6442                	ld	s0,16(sp)
    800048d8:	6105                	addi	sp,sp,32
    800048da:	8082                	ret

00000000800048dc <sys_fstat>:
{
    800048dc:	1101                	addi	sp,sp,-32
    800048de:	ec06                	sd	ra,24(sp)
    800048e0:	e822                	sd	s0,16(sp)
    800048e2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048e4:	fe840613          	addi	a2,s0,-24
    800048e8:	4581                	li	a1,0
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	c76080e7          	jalr	-906(ra) # 80004562 <argfd>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048f6:	02054563          	bltz	a0,80004920 <sys_fstat+0x44>
    800048fa:	fe040593          	addi	a1,s0,-32
    800048fe:	4505                	li	a0,1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	88a080e7          	jalr	-1910(ra) # 8000218a <argaddr>
    return -1;
    80004908:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000490a:	00054b63          	bltz	a0,80004920 <sys_fstat+0x44>
  return filestat(f, st);
    8000490e:	fe043583          	ld	a1,-32(s0)
    80004912:	fe843503          	ld	a0,-24(s0)
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	32a080e7          	jalr	810(ra) # 80003c40 <filestat>
    8000491e:	87aa                	mv	a5,a0
}
    80004920:	853e                	mv	a0,a5
    80004922:	60e2                	ld	ra,24(sp)
    80004924:	6442                	ld	s0,16(sp)
    80004926:	6105                	addi	sp,sp,32
    80004928:	8082                	ret

000000008000492a <sys_link>:
{
    8000492a:	7169                	addi	sp,sp,-304
    8000492c:	f606                	sd	ra,296(sp)
    8000492e:	f222                	sd	s0,288(sp)
    80004930:	ee26                	sd	s1,280(sp)
    80004932:	ea4a                	sd	s2,272(sp)
    80004934:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004936:	08000613          	li	a2,128
    8000493a:	ed040593          	addi	a1,s0,-304
    8000493e:	4501                	li	a0,0
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	86c080e7          	jalr	-1940(ra) # 800021ac <argstr>
    return -1;
    80004948:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494a:	10054e63          	bltz	a0,80004a66 <sys_link+0x13c>
    8000494e:	08000613          	li	a2,128
    80004952:	f5040593          	addi	a1,s0,-176
    80004956:	4505                	li	a0,1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	854080e7          	jalr	-1964(ra) # 800021ac <argstr>
    return -1;
    80004960:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004962:	10054263          	bltz	a0,80004a66 <sys_link+0x13c>
  begin_op();
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	d46080e7          	jalr	-698(ra) # 800036ac <begin_op>
  if((ip = namei(old)) == 0){
    8000496e:	ed040513          	addi	a0,s0,-304
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	b1e080e7          	jalr	-1250(ra) # 80003490 <namei>
    8000497a:	84aa                	mv	s1,a0
    8000497c:	c551                	beqz	a0,80004a08 <sys_link+0xde>
  ilock(ip);
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	35c080e7          	jalr	860(ra) # 80002cda <ilock>
  if(ip->type == T_DIR){
    80004986:	04449703          	lh	a4,68(s1)
    8000498a:	4785                	li	a5,1
    8000498c:	08f70463          	beq	a4,a5,80004a14 <sys_link+0xea>
  ip->nlink++;
    80004990:	04a4d783          	lhu	a5,74(s1)
    80004994:	2785                	addiw	a5,a5,1
    80004996:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	274080e7          	jalr	628(ra) # 80002c10 <iupdate>
  iunlock(ip);
    800049a4:	8526                	mv	a0,s1
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	3f6080e7          	jalr	1014(ra) # 80002d9c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049ae:	fd040593          	addi	a1,s0,-48
    800049b2:	f5040513          	addi	a0,s0,-176
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	af8080e7          	jalr	-1288(ra) # 800034ae <nameiparent>
    800049be:	892a                	mv	s2,a0
    800049c0:	c935                	beqz	a0,80004a34 <sys_link+0x10a>
  ilock(dp);
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	318080e7          	jalr	792(ra) # 80002cda <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049ca:	00092703          	lw	a4,0(s2)
    800049ce:	409c                	lw	a5,0(s1)
    800049d0:	04f71d63          	bne	a4,a5,80004a2a <sys_link+0x100>
    800049d4:	40d0                	lw	a2,4(s1)
    800049d6:	fd040593          	addi	a1,s0,-48
    800049da:	854a                	mv	a0,s2
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	9f2080e7          	jalr	-1550(ra) # 800033ce <dirlink>
    800049e4:	04054363          	bltz	a0,80004a2a <sys_link+0x100>
  iunlockput(dp);
    800049e8:	854a                	mv	a0,s2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	552080e7          	jalr	1362(ra) # 80002f3c <iunlockput>
  iput(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	4a0080e7          	jalr	1184(ra) # 80002e94 <iput>
  end_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	d30080e7          	jalr	-720(ra) # 8000372c <end_op>
  return 0;
    80004a04:	4781                	li	a5,0
    80004a06:	a085                	j	80004a66 <sys_link+0x13c>
    end_op();
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	d24080e7          	jalr	-732(ra) # 8000372c <end_op>
    return -1;
    80004a10:	57fd                	li	a5,-1
    80004a12:	a891                	j	80004a66 <sys_link+0x13c>
    iunlockput(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	526080e7          	jalr	1318(ra) # 80002f3c <iunlockput>
    end_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	d0e080e7          	jalr	-754(ra) # 8000372c <end_op>
    return -1;
    80004a26:	57fd                	li	a5,-1
    80004a28:	a83d                	j	80004a66 <sys_link+0x13c>
    iunlockput(dp);
    80004a2a:	854a                	mv	a0,s2
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	510080e7          	jalr	1296(ra) # 80002f3c <iunlockput>
  ilock(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	2a4080e7          	jalr	676(ra) # 80002cda <ilock>
  ip->nlink--;
    80004a3e:	04a4d783          	lhu	a5,74(s1)
    80004a42:	37fd                	addiw	a5,a5,-1
    80004a44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	1c6080e7          	jalr	454(ra) # 80002c10 <iupdate>
  iunlockput(ip);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	4e8080e7          	jalr	1256(ra) # 80002f3c <iunlockput>
  end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	cd0080e7          	jalr	-816(ra) # 8000372c <end_op>
  return -1;
    80004a64:	57fd                	li	a5,-1
}
    80004a66:	853e                	mv	a0,a5
    80004a68:	70b2                	ld	ra,296(sp)
    80004a6a:	7412                	ld	s0,288(sp)
    80004a6c:	64f2                	ld	s1,280(sp)
    80004a6e:	6952                	ld	s2,272(sp)
    80004a70:	6155                	addi	sp,sp,304
    80004a72:	8082                	ret

0000000080004a74 <sys_unlink>:
{
    80004a74:	7151                	addi	sp,sp,-240
    80004a76:	f586                	sd	ra,232(sp)
    80004a78:	f1a2                	sd	s0,224(sp)
    80004a7a:	eda6                	sd	s1,216(sp)
    80004a7c:	e9ca                	sd	s2,208(sp)
    80004a7e:	e5ce                	sd	s3,200(sp)
    80004a80:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a82:	08000613          	li	a2,128
    80004a86:	f3040593          	addi	a1,s0,-208
    80004a8a:	4501                	li	a0,0
    80004a8c:	ffffd097          	auipc	ra,0xffffd
    80004a90:	720080e7          	jalr	1824(ra) # 800021ac <argstr>
    80004a94:	18054163          	bltz	a0,80004c16 <sys_unlink+0x1a2>
  begin_op();
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	c14080e7          	jalr	-1004(ra) # 800036ac <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aa0:	fb040593          	addi	a1,s0,-80
    80004aa4:	f3040513          	addi	a0,s0,-208
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	a06080e7          	jalr	-1530(ra) # 800034ae <nameiparent>
    80004ab0:	84aa                	mv	s1,a0
    80004ab2:	c979                	beqz	a0,80004b88 <sys_unlink+0x114>
  ilock(dp);
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	226080e7          	jalr	550(ra) # 80002cda <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004abc:	00004597          	auipc	a1,0x4
    80004ac0:	c5458593          	addi	a1,a1,-940 # 80008710 <syscalls+0x2b0>
    80004ac4:	fb040513          	addi	a0,s0,-80
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	6dc080e7          	jalr	1756(ra) # 800031a4 <namecmp>
    80004ad0:	14050a63          	beqz	a0,80004c24 <sys_unlink+0x1b0>
    80004ad4:	00004597          	auipc	a1,0x4
    80004ad8:	c4458593          	addi	a1,a1,-956 # 80008718 <syscalls+0x2b8>
    80004adc:	fb040513          	addi	a0,s0,-80
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	6c4080e7          	jalr	1732(ra) # 800031a4 <namecmp>
    80004ae8:	12050e63          	beqz	a0,80004c24 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aec:	f2c40613          	addi	a2,s0,-212
    80004af0:	fb040593          	addi	a1,s0,-80
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	6c8080e7          	jalr	1736(ra) # 800031be <dirlookup>
    80004afe:	892a                	mv	s2,a0
    80004b00:	12050263          	beqz	a0,80004c24 <sys_unlink+0x1b0>
  ilock(ip);
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	1d6080e7          	jalr	470(ra) # 80002cda <ilock>
  if(ip->nlink < 1)
    80004b0c:	04a91783          	lh	a5,74(s2)
    80004b10:	08f05263          	blez	a5,80004b94 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b14:	04491703          	lh	a4,68(s2)
    80004b18:	4785                	li	a5,1
    80004b1a:	08f70563          	beq	a4,a5,80004ba4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b1e:	4641                	li	a2,16
    80004b20:	4581                	li	a1,0
    80004b22:	fc040513          	addi	a0,s0,-64
    80004b26:	ffffb097          	auipc	ra,0xffffb
    80004b2a:	66a080e7          	jalr	1642(ra) # 80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b2e:	4741                	li	a4,16
    80004b30:	f2c42683          	lw	a3,-212(s0)
    80004b34:	fc040613          	addi	a2,s0,-64
    80004b38:	4581                	li	a1,0
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	54a080e7          	jalr	1354(ra) # 80003086 <writei>
    80004b44:	47c1                	li	a5,16
    80004b46:	0af51563          	bne	a0,a5,80004bf0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b4a:	04491703          	lh	a4,68(s2)
    80004b4e:	4785                	li	a5,1
    80004b50:	0af70863          	beq	a4,a5,80004c00 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	3e6080e7          	jalr	998(ra) # 80002f3c <iunlockput>
  ip->nlink--;
    80004b5e:	04a95783          	lhu	a5,74(s2)
    80004b62:	37fd                	addiw	a5,a5,-1
    80004b64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	0a6080e7          	jalr	166(ra) # 80002c10 <iupdate>
  iunlockput(ip);
    80004b72:	854a                	mv	a0,s2
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	3c8080e7          	jalr	968(ra) # 80002f3c <iunlockput>
  end_op();
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	bb0080e7          	jalr	-1104(ra) # 8000372c <end_op>
  return 0;
    80004b84:	4501                	li	a0,0
    80004b86:	a84d                	j	80004c38 <sys_unlink+0x1c4>
    end_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	ba4080e7          	jalr	-1116(ra) # 8000372c <end_op>
    return -1;
    80004b90:	557d                	li	a0,-1
    80004b92:	a05d                	j	80004c38 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b94:	00004517          	auipc	a0,0x4
    80004b98:	bac50513          	addi	a0,a0,-1108 # 80008740 <syscalls+0x2e0>
    80004b9c:	00001097          	auipc	ra,0x1
    80004ba0:	1ec080e7          	jalr	492(ra) # 80005d88 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ba4:	04c92703          	lw	a4,76(s2)
    80004ba8:	02000793          	li	a5,32
    80004bac:	f6e7f9e3          	bgeu	a5,a4,80004b1e <sys_unlink+0xaa>
    80004bb0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bb4:	4741                	li	a4,16
    80004bb6:	86ce                	mv	a3,s3
    80004bb8:	f1840613          	addi	a2,s0,-232
    80004bbc:	4581                	li	a1,0
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	3ce080e7          	jalr	974(ra) # 80002f8e <readi>
    80004bc8:	47c1                	li	a5,16
    80004bca:	00f51b63          	bne	a0,a5,80004be0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bce:	f1845783          	lhu	a5,-232(s0)
    80004bd2:	e7a1                	bnez	a5,80004c1a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bd4:	29c1                	addiw	s3,s3,16
    80004bd6:	04c92783          	lw	a5,76(s2)
    80004bda:	fcf9ede3          	bltu	s3,a5,80004bb4 <sys_unlink+0x140>
    80004bde:	b781                	j	80004b1e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	b7850513          	addi	a0,a0,-1160 # 80008758 <syscalls+0x2f8>
    80004be8:	00001097          	auipc	ra,0x1
    80004bec:	1a0080e7          	jalr	416(ra) # 80005d88 <panic>
    panic("unlink: writei");
    80004bf0:	00004517          	auipc	a0,0x4
    80004bf4:	b8050513          	addi	a0,a0,-1152 # 80008770 <syscalls+0x310>
    80004bf8:	00001097          	auipc	ra,0x1
    80004bfc:	190080e7          	jalr	400(ra) # 80005d88 <panic>
    dp->nlink--;
    80004c00:	04a4d783          	lhu	a5,74(s1)
    80004c04:	37fd                	addiw	a5,a5,-1
    80004c06:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	004080e7          	jalr	4(ra) # 80002c10 <iupdate>
    80004c14:	b781                	j	80004b54 <sys_unlink+0xe0>
    return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	a005                	j	80004c38 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c1a:	854a                	mv	a0,s2
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	320080e7          	jalr	800(ra) # 80002f3c <iunlockput>
  iunlockput(dp);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	316080e7          	jalr	790(ra) # 80002f3c <iunlockput>
  end_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	afe080e7          	jalr	-1282(ra) # 8000372c <end_op>
  return -1;
    80004c36:	557d                	li	a0,-1
}
    80004c38:	70ae                	ld	ra,232(sp)
    80004c3a:	740e                	ld	s0,224(sp)
    80004c3c:	64ee                	ld	s1,216(sp)
    80004c3e:	694e                	ld	s2,208(sp)
    80004c40:	69ae                	ld	s3,200(sp)
    80004c42:	616d                	addi	sp,sp,240
    80004c44:	8082                	ret

0000000080004c46 <sys_open>:

uint64
sys_open(void)
{
    80004c46:	7131                	addi	sp,sp,-192
    80004c48:	fd06                	sd	ra,184(sp)
    80004c4a:	f922                	sd	s0,176(sp)
    80004c4c:	f526                	sd	s1,168(sp)
    80004c4e:	f14a                	sd	s2,160(sp)
    80004c50:	ed4e                	sd	s3,152(sp)
    80004c52:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c54:	08000613          	li	a2,128
    80004c58:	f5040593          	addi	a1,s0,-176
    80004c5c:	4501                	li	a0,0
    80004c5e:	ffffd097          	auipc	ra,0xffffd
    80004c62:	54e080e7          	jalr	1358(ra) # 800021ac <argstr>
    return -1;
    80004c66:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c68:	0c054163          	bltz	a0,80004d2a <sys_open+0xe4>
    80004c6c:	f4c40593          	addi	a1,s0,-180
    80004c70:	4505                	li	a0,1
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	4f6080e7          	jalr	1270(ra) # 80002168 <argint>
    80004c7a:	0a054863          	bltz	a0,80004d2a <sys_open+0xe4>

  begin_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	a2e080e7          	jalr	-1490(ra) # 800036ac <begin_op>

  if(omode & O_CREATE){
    80004c86:	f4c42783          	lw	a5,-180(s0)
    80004c8a:	2007f793          	andi	a5,a5,512
    80004c8e:	cbdd                	beqz	a5,80004d44 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c90:	4681                	li	a3,0
    80004c92:	4601                	li	a2,0
    80004c94:	4589                	li	a1,2
    80004c96:	f5040513          	addi	a0,s0,-176
    80004c9a:	00000097          	auipc	ra,0x0
    80004c9e:	972080e7          	jalr	-1678(ra) # 8000460c <create>
    80004ca2:	892a                	mv	s2,a0
    if(ip == 0){
    80004ca4:	c959                	beqz	a0,80004d3a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ca6:	04491703          	lh	a4,68(s2)
    80004caa:	478d                	li	a5,3
    80004cac:	00f71763          	bne	a4,a5,80004cba <sys_open+0x74>
    80004cb0:	04695703          	lhu	a4,70(s2)
    80004cb4:	47a5                	li	a5,9
    80004cb6:	0ce7ec63          	bltu	a5,a4,80004d8e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	e02080e7          	jalr	-510(ra) # 80003abc <filealloc>
    80004cc2:	89aa                	mv	s3,a0
    80004cc4:	10050263          	beqz	a0,80004dc8 <sys_open+0x182>
    80004cc8:	00000097          	auipc	ra,0x0
    80004ccc:	902080e7          	jalr	-1790(ra) # 800045ca <fdalloc>
    80004cd0:	84aa                	mv	s1,a0
    80004cd2:	0e054663          	bltz	a0,80004dbe <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cd6:	04491703          	lh	a4,68(s2)
    80004cda:	478d                	li	a5,3
    80004cdc:	0cf70463          	beq	a4,a5,80004da4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ce0:	4789                	li	a5,2
    80004ce2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ce6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cea:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cee:	f4c42783          	lw	a5,-180(s0)
    80004cf2:	0017c713          	xori	a4,a5,1
    80004cf6:	8b05                	andi	a4,a4,1
    80004cf8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cfc:	0037f713          	andi	a4,a5,3
    80004d00:	00e03733          	snez	a4,a4
    80004d04:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d08:	4007f793          	andi	a5,a5,1024
    80004d0c:	c791                	beqz	a5,80004d18 <sys_open+0xd2>
    80004d0e:	04491703          	lh	a4,68(s2)
    80004d12:	4789                	li	a5,2
    80004d14:	08f70f63          	beq	a4,a5,80004db2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d18:	854a                	mv	a0,s2
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	082080e7          	jalr	130(ra) # 80002d9c <iunlock>
  end_op();
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	a0a080e7          	jalr	-1526(ra) # 8000372c <end_op>

  return fd;
}
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	70ea                	ld	ra,184(sp)
    80004d2e:	744a                	ld	s0,176(sp)
    80004d30:	74aa                	ld	s1,168(sp)
    80004d32:	790a                	ld	s2,160(sp)
    80004d34:	69ea                	ld	s3,152(sp)
    80004d36:	6129                	addi	sp,sp,192
    80004d38:	8082                	ret
      end_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	9f2080e7          	jalr	-1550(ra) # 8000372c <end_op>
      return -1;
    80004d42:	b7e5                	j	80004d2a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d44:	f5040513          	addi	a0,s0,-176
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	748080e7          	jalr	1864(ra) # 80003490 <namei>
    80004d50:	892a                	mv	s2,a0
    80004d52:	c905                	beqz	a0,80004d82 <sys_open+0x13c>
    ilock(ip);
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	f86080e7          	jalr	-122(ra) # 80002cda <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d5c:	04491703          	lh	a4,68(s2)
    80004d60:	4785                	li	a5,1
    80004d62:	f4f712e3          	bne	a4,a5,80004ca6 <sys_open+0x60>
    80004d66:	f4c42783          	lw	a5,-180(s0)
    80004d6a:	dba1                	beqz	a5,80004cba <sys_open+0x74>
      iunlockput(ip);
    80004d6c:	854a                	mv	a0,s2
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	1ce080e7          	jalr	462(ra) # 80002f3c <iunlockput>
      end_op();
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	9b6080e7          	jalr	-1610(ra) # 8000372c <end_op>
      return -1;
    80004d7e:	54fd                	li	s1,-1
    80004d80:	b76d                	j	80004d2a <sys_open+0xe4>
      end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	9aa080e7          	jalr	-1622(ra) # 8000372c <end_op>
      return -1;
    80004d8a:	54fd                	li	s1,-1
    80004d8c:	bf79                	j	80004d2a <sys_open+0xe4>
    iunlockput(ip);
    80004d8e:	854a                	mv	a0,s2
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	1ac080e7          	jalr	428(ra) # 80002f3c <iunlockput>
    end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	994080e7          	jalr	-1644(ra) # 8000372c <end_op>
    return -1;
    80004da0:	54fd                	li	s1,-1
    80004da2:	b761                	j	80004d2a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004da4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004da8:	04691783          	lh	a5,70(s2)
    80004dac:	02f99223          	sh	a5,36(s3)
    80004db0:	bf2d                	j	80004cea <sys_open+0xa4>
    itrunc(ip);
    80004db2:	854a                	mv	a0,s2
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	034080e7          	jalr	52(ra) # 80002de8 <itrunc>
    80004dbc:	bfb1                	j	80004d18 <sys_open+0xd2>
      fileclose(f);
    80004dbe:	854e                	mv	a0,s3
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	db8080e7          	jalr	-584(ra) # 80003b78 <fileclose>
    iunlockput(ip);
    80004dc8:	854a                	mv	a0,s2
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	172080e7          	jalr	370(ra) # 80002f3c <iunlockput>
    end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	95a080e7          	jalr	-1702(ra) # 8000372c <end_op>
    return -1;
    80004dda:	54fd                	li	s1,-1
    80004ddc:	b7b9                	j	80004d2a <sys_open+0xe4>

0000000080004dde <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dde:	7175                	addi	sp,sp,-144
    80004de0:	e506                	sd	ra,136(sp)
    80004de2:	e122                	sd	s0,128(sp)
    80004de4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	8c6080e7          	jalr	-1850(ra) # 800036ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dee:	08000613          	li	a2,128
    80004df2:	f7040593          	addi	a1,s0,-144
    80004df6:	4501                	li	a0,0
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	3b4080e7          	jalr	948(ra) # 800021ac <argstr>
    80004e00:	02054963          	bltz	a0,80004e32 <sys_mkdir+0x54>
    80004e04:	4681                	li	a3,0
    80004e06:	4601                	li	a2,0
    80004e08:	4585                	li	a1,1
    80004e0a:	f7040513          	addi	a0,s0,-144
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	7fe080e7          	jalr	2046(ra) # 8000460c <create>
    80004e16:	cd11                	beqz	a0,80004e32 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	124080e7          	jalr	292(ra) # 80002f3c <iunlockput>
  end_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	90c080e7          	jalr	-1780(ra) # 8000372c <end_op>
  return 0;
    80004e28:	4501                	li	a0,0
}
    80004e2a:	60aa                	ld	ra,136(sp)
    80004e2c:	640a                	ld	s0,128(sp)
    80004e2e:	6149                	addi	sp,sp,144
    80004e30:	8082                	ret
    end_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	8fa080e7          	jalr	-1798(ra) # 8000372c <end_op>
    return -1;
    80004e3a:	557d                	li	a0,-1
    80004e3c:	b7fd                	j	80004e2a <sys_mkdir+0x4c>

0000000080004e3e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e3e:	7135                	addi	sp,sp,-160
    80004e40:	ed06                	sd	ra,152(sp)
    80004e42:	e922                	sd	s0,144(sp)
    80004e44:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	866080e7          	jalr	-1946(ra) # 800036ac <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e4e:	08000613          	li	a2,128
    80004e52:	f7040593          	addi	a1,s0,-144
    80004e56:	4501                	li	a0,0
    80004e58:	ffffd097          	auipc	ra,0xffffd
    80004e5c:	354080e7          	jalr	852(ra) # 800021ac <argstr>
    80004e60:	04054a63          	bltz	a0,80004eb4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e64:	f6c40593          	addi	a1,s0,-148
    80004e68:	4505                	li	a0,1
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	2fe080e7          	jalr	766(ra) # 80002168 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e72:	04054163          	bltz	a0,80004eb4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e76:	f6840593          	addi	a1,s0,-152
    80004e7a:	4509                	li	a0,2
    80004e7c:	ffffd097          	auipc	ra,0xffffd
    80004e80:	2ec080e7          	jalr	748(ra) # 80002168 <argint>
     argint(1, &major) < 0 ||
    80004e84:	02054863          	bltz	a0,80004eb4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e88:	f6841683          	lh	a3,-152(s0)
    80004e8c:	f6c41603          	lh	a2,-148(s0)
    80004e90:	458d                	li	a1,3
    80004e92:	f7040513          	addi	a0,s0,-144
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	776080e7          	jalr	1910(ra) # 8000460c <create>
     argint(2, &minor) < 0 ||
    80004e9e:	c919                	beqz	a0,80004eb4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	09c080e7          	jalr	156(ra) # 80002f3c <iunlockput>
  end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	884080e7          	jalr	-1916(ra) # 8000372c <end_op>
  return 0;
    80004eb0:	4501                	li	a0,0
    80004eb2:	a031                	j	80004ebe <sys_mknod+0x80>
    end_op();
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	878080e7          	jalr	-1928(ra) # 8000372c <end_op>
    return -1;
    80004ebc:	557d                	li	a0,-1
}
    80004ebe:	60ea                	ld	ra,152(sp)
    80004ec0:	644a                	ld	s0,144(sp)
    80004ec2:	610d                	addi	sp,sp,160
    80004ec4:	8082                	ret

0000000080004ec6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ec6:	7135                	addi	sp,sp,-160
    80004ec8:	ed06                	sd	ra,152(sp)
    80004eca:	e922                	sd	s0,144(sp)
    80004ecc:	e526                	sd	s1,136(sp)
    80004ece:	e14a                	sd	s2,128(sp)
    80004ed0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ed2:	ffffc097          	auipc	ra,0xffffc
    80004ed6:	0c0080e7          	jalr	192(ra) # 80000f92 <myproc>
    80004eda:	892a                	mv	s2,a0
  
  begin_op();
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	7d0080e7          	jalr	2000(ra) # 800036ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ee4:	08000613          	li	a2,128
    80004ee8:	f6040593          	addi	a1,s0,-160
    80004eec:	4501                	li	a0,0
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	2be080e7          	jalr	702(ra) # 800021ac <argstr>
    80004ef6:	04054b63          	bltz	a0,80004f4c <sys_chdir+0x86>
    80004efa:	f6040513          	addi	a0,s0,-160
    80004efe:	ffffe097          	auipc	ra,0xffffe
    80004f02:	592080e7          	jalr	1426(ra) # 80003490 <namei>
    80004f06:	84aa                	mv	s1,a0
    80004f08:	c131                	beqz	a0,80004f4c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	dd0080e7          	jalr	-560(ra) # 80002cda <ilock>
  if(ip->type != T_DIR){
    80004f12:	04449703          	lh	a4,68(s1)
    80004f16:	4785                	li	a5,1
    80004f18:	04f71063          	bne	a4,a5,80004f58 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	e7e080e7          	jalr	-386(ra) # 80002d9c <iunlock>
  iput(p->cwd);
    80004f26:	15093503          	ld	a0,336(s2)
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	f6a080e7          	jalr	-150(ra) # 80002e94 <iput>
  end_op();
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	7fa080e7          	jalr	2042(ra) # 8000372c <end_op>
  p->cwd = ip;
    80004f3a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f3e:	4501                	li	a0,0
}
    80004f40:	60ea                	ld	ra,152(sp)
    80004f42:	644a                	ld	s0,144(sp)
    80004f44:	64aa                	ld	s1,136(sp)
    80004f46:	690a                	ld	s2,128(sp)
    80004f48:	610d                	addi	sp,sp,160
    80004f4a:	8082                	ret
    end_op();
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	7e0080e7          	jalr	2016(ra) # 8000372c <end_op>
    return -1;
    80004f54:	557d                	li	a0,-1
    80004f56:	b7ed                	j	80004f40 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f58:	8526                	mv	a0,s1
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	fe2080e7          	jalr	-30(ra) # 80002f3c <iunlockput>
    end_op();
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	7ca080e7          	jalr	1994(ra) # 8000372c <end_op>
    return -1;
    80004f6a:	557d                	li	a0,-1
    80004f6c:	bfd1                	j	80004f40 <sys_chdir+0x7a>

0000000080004f6e <sys_exec>:

uint64
sys_exec(void)
{
    80004f6e:	7145                	addi	sp,sp,-464
    80004f70:	e786                	sd	ra,456(sp)
    80004f72:	e3a2                	sd	s0,448(sp)
    80004f74:	ff26                	sd	s1,440(sp)
    80004f76:	fb4a                	sd	s2,432(sp)
    80004f78:	f74e                	sd	s3,424(sp)
    80004f7a:	f352                	sd	s4,416(sp)
    80004f7c:	ef56                	sd	s5,408(sp)
    80004f7e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f80:	08000613          	li	a2,128
    80004f84:	f4040593          	addi	a1,s0,-192
    80004f88:	4501                	li	a0,0
    80004f8a:	ffffd097          	auipc	ra,0xffffd
    80004f8e:	222080e7          	jalr	546(ra) # 800021ac <argstr>
    return -1;
    80004f92:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f94:	0c054a63          	bltz	a0,80005068 <sys_exec+0xfa>
    80004f98:	e3840593          	addi	a1,s0,-456
    80004f9c:	4505                	li	a0,1
    80004f9e:	ffffd097          	auipc	ra,0xffffd
    80004fa2:	1ec080e7          	jalr	492(ra) # 8000218a <argaddr>
    80004fa6:	0c054163          	bltz	a0,80005068 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004faa:	10000613          	li	a2,256
    80004fae:	4581                	li	a1,0
    80004fb0:	e4040513          	addi	a0,s0,-448
    80004fb4:	ffffb097          	auipc	ra,0xffffb
    80004fb8:	1dc080e7          	jalr	476(ra) # 80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fbc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fc0:	89a6                	mv	s3,s1
    80004fc2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fc4:	02000a13          	li	s4,32
    80004fc8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fcc:	00391513          	slli	a0,s2,0x3
    80004fd0:	e3040593          	addi	a1,s0,-464
    80004fd4:	e3843783          	ld	a5,-456(s0)
    80004fd8:	953e                	add	a0,a0,a5
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	0f4080e7          	jalr	244(ra) # 800020ce <fetchaddr>
    80004fe2:	02054a63          	bltz	a0,80005016 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fe6:	e3043783          	ld	a5,-464(s0)
    80004fea:	c3b9                	beqz	a5,80005030 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fec:	ffffb097          	auipc	ra,0xffffb
    80004ff0:	144080e7          	jalr	324(ra) # 80000130 <kalloc>
    80004ff4:	85aa                	mv	a1,a0
    80004ff6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ffa:	cd11                	beqz	a0,80005016 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ffc:	6605                	lui	a2,0x1
    80004ffe:	e3043503          	ld	a0,-464(s0)
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	11e080e7          	jalr	286(ra) # 80002120 <fetchstr>
    8000500a:	00054663          	bltz	a0,80005016 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000500e:	0905                	addi	s2,s2,1
    80005010:	09a1                	addi	s3,s3,8
    80005012:	fb491be3          	bne	s2,s4,80004fc8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005016:	10048913          	addi	s2,s1,256
    8000501a:	6088                	ld	a0,0(s1)
    8000501c:	c529                	beqz	a0,80005066 <sys_exec+0xf8>
    kfree(argv[i]);
    8000501e:	ffffb097          	auipc	ra,0xffffb
    80005022:	ffe080e7          	jalr	-2(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005026:	04a1                	addi	s1,s1,8
    80005028:	ff2499e3          	bne	s1,s2,8000501a <sys_exec+0xac>
  return -1;
    8000502c:	597d                	li	s2,-1
    8000502e:	a82d                	j	80005068 <sys_exec+0xfa>
      argv[i] = 0;
    80005030:	0a8e                	slli	s5,s5,0x3
    80005032:	fc040793          	addi	a5,s0,-64
    80005036:	9abe                	add	s5,s5,a5
    80005038:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000503c:	e4040593          	addi	a1,s0,-448
    80005040:	f4040513          	addi	a0,s0,-192
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	194080e7          	jalr	404(ra) # 800041d8 <exec>
    8000504c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504e:	10048993          	addi	s3,s1,256
    80005052:	6088                	ld	a0,0(s1)
    80005054:	c911                	beqz	a0,80005068 <sys_exec+0xfa>
    kfree(argv[i]);
    80005056:	ffffb097          	auipc	ra,0xffffb
    8000505a:	fc6080e7          	jalr	-58(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505e:	04a1                	addi	s1,s1,8
    80005060:	ff3499e3          	bne	s1,s3,80005052 <sys_exec+0xe4>
    80005064:	a011                	j	80005068 <sys_exec+0xfa>
  return -1;
    80005066:	597d                	li	s2,-1
}
    80005068:	854a                	mv	a0,s2
    8000506a:	60be                	ld	ra,456(sp)
    8000506c:	641e                	ld	s0,448(sp)
    8000506e:	74fa                	ld	s1,440(sp)
    80005070:	795a                	ld	s2,432(sp)
    80005072:	79ba                	ld	s3,424(sp)
    80005074:	7a1a                	ld	s4,416(sp)
    80005076:	6afa                	ld	s5,408(sp)
    80005078:	6179                	addi	sp,sp,464
    8000507a:	8082                	ret

000000008000507c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000507c:	7139                	addi	sp,sp,-64
    8000507e:	fc06                	sd	ra,56(sp)
    80005080:	f822                	sd	s0,48(sp)
    80005082:	f426                	sd	s1,40(sp)
    80005084:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005086:	ffffc097          	auipc	ra,0xffffc
    8000508a:	f0c080e7          	jalr	-244(ra) # 80000f92 <myproc>
    8000508e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005090:	fd840593          	addi	a1,s0,-40
    80005094:	4501                	li	a0,0
    80005096:	ffffd097          	auipc	ra,0xffffd
    8000509a:	0f4080e7          	jalr	244(ra) # 8000218a <argaddr>
    return -1;
    8000509e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050a0:	0e054063          	bltz	a0,80005180 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050a4:	fc840593          	addi	a1,s0,-56
    800050a8:	fd040513          	addi	a0,s0,-48
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	dfc080e7          	jalr	-516(ra) # 80003ea8 <pipealloc>
    return -1;
    800050b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050b6:	0c054563          	bltz	a0,80005180 <sys_pipe+0x104>
  fd0 = -1;
    800050ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050be:	fd043503          	ld	a0,-48(s0)
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	508080e7          	jalr	1288(ra) # 800045ca <fdalloc>
    800050ca:	fca42223          	sw	a0,-60(s0)
    800050ce:	08054c63          	bltz	a0,80005166 <sys_pipe+0xea>
    800050d2:	fc843503          	ld	a0,-56(s0)
    800050d6:	fffff097          	auipc	ra,0xfffff
    800050da:	4f4080e7          	jalr	1268(ra) # 800045ca <fdalloc>
    800050de:	fca42023          	sw	a0,-64(s0)
    800050e2:	06054863          	bltz	a0,80005152 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050e6:	4691                	li	a3,4
    800050e8:	fc440613          	addi	a2,s0,-60
    800050ec:	fd843583          	ld	a1,-40(s0)
    800050f0:	68a8                	ld	a0,80(s1)
    800050f2:	ffffc097          	auipc	ra,0xffffc
    800050f6:	a86080e7          	jalr	-1402(ra) # 80000b78 <copyout>
    800050fa:	02054063          	bltz	a0,8000511a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050fe:	4691                	li	a3,4
    80005100:	fc040613          	addi	a2,s0,-64
    80005104:	fd843583          	ld	a1,-40(s0)
    80005108:	0591                	addi	a1,a1,4
    8000510a:	68a8                	ld	a0,80(s1)
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	a6c080e7          	jalr	-1428(ra) # 80000b78 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005114:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005116:	06055563          	bgez	a0,80005180 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000511a:	fc442783          	lw	a5,-60(s0)
    8000511e:	07e9                	addi	a5,a5,26
    80005120:	078e                	slli	a5,a5,0x3
    80005122:	97a6                	add	a5,a5,s1
    80005124:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005128:	fc042503          	lw	a0,-64(s0)
    8000512c:	0569                	addi	a0,a0,26
    8000512e:	050e                	slli	a0,a0,0x3
    80005130:	9526                	add	a0,a0,s1
    80005132:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005136:	fd043503          	ld	a0,-48(s0)
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	a3e080e7          	jalr	-1474(ra) # 80003b78 <fileclose>
    fileclose(wf);
    80005142:	fc843503          	ld	a0,-56(s0)
    80005146:	fffff097          	auipc	ra,0xfffff
    8000514a:	a32080e7          	jalr	-1486(ra) # 80003b78 <fileclose>
    return -1;
    8000514e:	57fd                	li	a5,-1
    80005150:	a805                	j	80005180 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005152:	fc442783          	lw	a5,-60(s0)
    80005156:	0007c863          	bltz	a5,80005166 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000515a:	01a78513          	addi	a0,a5,26
    8000515e:	050e                	slli	a0,a0,0x3
    80005160:	9526                	add	a0,a0,s1
    80005162:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005166:	fd043503          	ld	a0,-48(s0)
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	a0e080e7          	jalr	-1522(ra) # 80003b78 <fileclose>
    fileclose(wf);
    80005172:	fc843503          	ld	a0,-56(s0)
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	a02080e7          	jalr	-1534(ra) # 80003b78 <fileclose>
    return -1;
    8000517e:	57fd                	li	a5,-1
}
    80005180:	853e                	mv	a0,a5
    80005182:	70e2                	ld	ra,56(sp)
    80005184:	7442                	ld	s0,48(sp)
    80005186:	74a2                	ld	s1,40(sp)
    80005188:	6121                	addi	sp,sp,64
    8000518a:	8082                	ret
    8000518c:	0000                	unimp
	...

0000000080005190 <kernelvec>:
    80005190:	7111                	addi	sp,sp,-256
    80005192:	e006                	sd	ra,0(sp)
    80005194:	e40a                	sd	sp,8(sp)
    80005196:	e80e                	sd	gp,16(sp)
    80005198:	ec12                	sd	tp,24(sp)
    8000519a:	f016                	sd	t0,32(sp)
    8000519c:	f41a                	sd	t1,40(sp)
    8000519e:	f81e                	sd	t2,48(sp)
    800051a0:	fc22                	sd	s0,56(sp)
    800051a2:	e0a6                	sd	s1,64(sp)
    800051a4:	e4aa                	sd	a0,72(sp)
    800051a6:	e8ae                	sd	a1,80(sp)
    800051a8:	ecb2                	sd	a2,88(sp)
    800051aa:	f0b6                	sd	a3,96(sp)
    800051ac:	f4ba                	sd	a4,104(sp)
    800051ae:	f8be                	sd	a5,112(sp)
    800051b0:	fcc2                	sd	a6,120(sp)
    800051b2:	e146                	sd	a7,128(sp)
    800051b4:	e54a                	sd	s2,136(sp)
    800051b6:	e94e                	sd	s3,144(sp)
    800051b8:	ed52                	sd	s4,152(sp)
    800051ba:	f156                	sd	s5,160(sp)
    800051bc:	f55a                	sd	s6,168(sp)
    800051be:	f95e                	sd	s7,176(sp)
    800051c0:	fd62                	sd	s8,184(sp)
    800051c2:	e1e6                	sd	s9,192(sp)
    800051c4:	e5ea                	sd	s10,200(sp)
    800051c6:	e9ee                	sd	s11,208(sp)
    800051c8:	edf2                	sd	t3,216(sp)
    800051ca:	f1f6                	sd	t4,224(sp)
    800051cc:	f5fa                	sd	t5,232(sp)
    800051ce:	f9fe                	sd	t6,240(sp)
    800051d0:	dcbfc0ef          	jal	ra,80001f9a <kerneltrap>
    800051d4:	6082                	ld	ra,0(sp)
    800051d6:	6122                	ld	sp,8(sp)
    800051d8:	61c2                	ld	gp,16(sp)
    800051da:	7282                	ld	t0,32(sp)
    800051dc:	7322                	ld	t1,40(sp)
    800051de:	73c2                	ld	t2,48(sp)
    800051e0:	7462                	ld	s0,56(sp)
    800051e2:	6486                	ld	s1,64(sp)
    800051e4:	6526                	ld	a0,72(sp)
    800051e6:	65c6                	ld	a1,80(sp)
    800051e8:	6666                	ld	a2,88(sp)
    800051ea:	7686                	ld	a3,96(sp)
    800051ec:	7726                	ld	a4,104(sp)
    800051ee:	77c6                	ld	a5,112(sp)
    800051f0:	7866                	ld	a6,120(sp)
    800051f2:	688a                	ld	a7,128(sp)
    800051f4:	692a                	ld	s2,136(sp)
    800051f6:	69ca                	ld	s3,144(sp)
    800051f8:	6a6a                	ld	s4,152(sp)
    800051fa:	7a8a                	ld	s5,160(sp)
    800051fc:	7b2a                	ld	s6,168(sp)
    800051fe:	7bca                	ld	s7,176(sp)
    80005200:	7c6a                	ld	s8,184(sp)
    80005202:	6c8e                	ld	s9,192(sp)
    80005204:	6d2e                	ld	s10,200(sp)
    80005206:	6dce                	ld	s11,208(sp)
    80005208:	6e6e                	ld	t3,216(sp)
    8000520a:	7e8e                	ld	t4,224(sp)
    8000520c:	7f2e                	ld	t5,232(sp)
    8000520e:	7fce                	ld	t6,240(sp)
    80005210:	6111                	addi	sp,sp,256
    80005212:	10200073          	sret
    80005216:	00000013          	nop
    8000521a:	00000013          	nop
    8000521e:	0001                	nop

0000000080005220 <timervec>:
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	e10c                	sd	a1,0(a0)
    80005226:	e510                	sd	a2,8(a0)
    80005228:	e914                	sd	a3,16(a0)
    8000522a:	6d0c                	ld	a1,24(a0)
    8000522c:	7110                	ld	a2,32(a0)
    8000522e:	6194                	ld	a3,0(a1)
    80005230:	96b2                	add	a3,a3,a2
    80005232:	e194                	sd	a3,0(a1)
    80005234:	4589                	li	a1,2
    80005236:	14459073          	csrw	sip,a1
    8000523a:	6914                	ld	a3,16(a0)
    8000523c:	6510                	ld	a2,8(a0)
    8000523e:	610c                	ld	a1,0(a0)
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	30200073          	mret
	...

000000008000524a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000524a:	1141                	addi	sp,sp,-16
    8000524c:	e422                	sd	s0,8(sp)
    8000524e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005250:	0c0007b7          	lui	a5,0xc000
    80005254:	4705                	li	a4,1
    80005256:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005258:	c3d8                	sw	a4,4(a5)
}
    8000525a:	6422                	ld	s0,8(sp)
    8000525c:	0141                	addi	sp,sp,16
    8000525e:	8082                	ret

0000000080005260 <plicinithart>:

void
plicinithart(void)
{
    80005260:	1141                	addi	sp,sp,-16
    80005262:	e406                	sd	ra,8(sp)
    80005264:	e022                	sd	s0,0(sp)
    80005266:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	cfe080e7          	jalr	-770(ra) # 80000f66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005270:	0085171b          	slliw	a4,a0,0x8
    80005274:	0c0027b7          	lui	a5,0xc002
    80005278:	97ba                	add	a5,a5,a4
    8000527a:	40200713          	li	a4,1026
    8000527e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005282:	00d5151b          	slliw	a0,a0,0xd
    80005286:	0c2017b7          	lui	a5,0xc201
    8000528a:	953e                	add	a0,a0,a5
    8000528c:	00052023          	sw	zero,0(a0)
}
    80005290:	60a2                	ld	ra,8(sp)
    80005292:	6402                	ld	s0,0(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret

0000000080005298 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005298:	1141                	addi	sp,sp,-16
    8000529a:	e406                	sd	ra,8(sp)
    8000529c:	e022                	sd	s0,0(sp)
    8000529e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	cc6080e7          	jalr	-826(ra) # 80000f66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052a8:	00d5179b          	slliw	a5,a0,0xd
    800052ac:	0c201537          	lui	a0,0xc201
    800052b0:	953e                	add	a0,a0,a5
  return irq;
}
    800052b2:	4148                	lw	a0,4(a0)
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052bc:	1101                	addi	sp,sp,-32
    800052be:	ec06                	sd	ra,24(sp)
    800052c0:	e822                	sd	s0,16(sp)
    800052c2:	e426                	sd	s1,8(sp)
    800052c4:	1000                	addi	s0,sp,32
    800052c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	c9e080e7          	jalr	-866(ra) # 80000f66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052d0:	00d5151b          	slliw	a0,a0,0xd
    800052d4:	0c2017b7          	lui	a5,0xc201
    800052d8:	97aa                	add	a5,a5,a0
    800052da:	c3c4                	sw	s1,4(a5)
}
    800052dc:	60e2                	ld	ra,24(sp)
    800052de:	6442                	ld	s0,16(sp)
    800052e0:	64a2                	ld	s1,8(sp)
    800052e2:	6105                	addi	sp,sp,32
    800052e4:	8082                	ret

00000000800052e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052e6:	1141                	addi	sp,sp,-16
    800052e8:	e406                	sd	ra,8(sp)
    800052ea:	e022                	sd	s0,0(sp)
    800052ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ee:	479d                	li	a5,7
    800052f0:	06a7c963          	blt	a5,a0,80005362 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052f4:	00016797          	auipc	a5,0x16
    800052f8:	d0c78793          	addi	a5,a5,-756 # 8001b000 <disk>
    800052fc:	00a78733          	add	a4,a5,a0
    80005300:	6789                	lui	a5,0x2
    80005302:	97ba                	add	a5,a5,a4
    80005304:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005308:	e7ad                	bnez	a5,80005372 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000530a:	00451793          	slli	a5,a0,0x4
    8000530e:	00018717          	auipc	a4,0x18
    80005312:	cf270713          	addi	a4,a4,-782 # 8001d000 <disk+0x2000>
    80005316:	6314                	ld	a3,0(a4)
    80005318:	96be                	add	a3,a3,a5
    8000531a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000531e:	6314                	ld	a3,0(a4)
    80005320:	96be                	add	a3,a3,a5
    80005322:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005326:	6314                	ld	a3,0(a4)
    80005328:	96be                	add	a3,a3,a5
    8000532a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000532e:	6318                	ld	a4,0(a4)
    80005330:	97ba                	add	a5,a5,a4
    80005332:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005336:	00016797          	auipc	a5,0x16
    8000533a:	cca78793          	addi	a5,a5,-822 # 8001b000 <disk>
    8000533e:	97aa                	add	a5,a5,a0
    80005340:	6509                	lui	a0,0x2
    80005342:	953e                	add	a0,a0,a5
    80005344:	4785                	li	a5,1
    80005346:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000534a:	00018517          	auipc	a0,0x18
    8000534e:	cce50513          	addi	a0,a0,-818 # 8001d018 <disk+0x2018>
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	488080e7          	jalr	1160(ra) # 800017da <wakeup>
}
    8000535a:	60a2                	ld	ra,8(sp)
    8000535c:	6402                	ld	s0,0(sp)
    8000535e:	0141                	addi	sp,sp,16
    80005360:	8082                	ret
    panic("free_desc 1");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	41e50513          	addi	a0,a0,1054 # 80008780 <syscalls+0x320>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	a1e080e7          	jalr	-1506(ra) # 80005d88 <panic>
    panic("free_desc 2");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	41e50513          	addi	a0,a0,1054 # 80008790 <syscalls+0x330>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	a0e080e7          	jalr	-1522(ra) # 80005d88 <panic>

0000000080005382 <virtio_disk_init>:
{
    80005382:	1101                	addi	sp,sp,-32
    80005384:	ec06                	sd	ra,24(sp)
    80005386:	e822                	sd	s0,16(sp)
    80005388:	e426                	sd	s1,8(sp)
    8000538a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000538c:	00003597          	auipc	a1,0x3
    80005390:	41458593          	addi	a1,a1,1044 # 800087a0 <syscalls+0x340>
    80005394:	00018517          	auipc	a0,0x18
    80005398:	d9450513          	addi	a0,a0,-620 # 8001d128 <disk+0x2128>
    8000539c:	00001097          	auipc	ra,0x1
    800053a0:	ea6080e7          	jalr	-346(ra) # 80006242 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	4398                	lw	a4,0(a5)
    800053aa:	2701                	sext.w	a4,a4
    800053ac:	747277b7          	lui	a5,0x74727
    800053b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053b4:	0ef71163          	bne	a4,a5,80005496 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	43dc                	lw	a5,4(a5)
    800053be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c0:	4705                	li	a4,1
    800053c2:	0ce79a63          	bne	a5,a4,80005496 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053c6:	100017b7          	lui	a5,0x10001
    800053ca:	479c                	lw	a5,8(a5)
    800053cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ce:	4709                	li	a4,2
    800053d0:	0ce79363          	bne	a5,a4,80005496 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053d4:	100017b7          	lui	a5,0x10001
    800053d8:	47d8                	lw	a4,12(a5)
    800053da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053dc:	554d47b7          	lui	a5,0x554d4
    800053e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053e4:	0af71963          	bne	a4,a5,80005496 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	4705                	li	a4,1
    800053ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f0:	470d                	li	a4,3
    800053f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053f6:	c7ffe737          	lui	a4,0xc7ffe
    800053fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800053fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005400:	2701                	sext.w	a4,a4
    80005402:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005404:	472d                	li	a4,11
    80005406:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005408:	473d                	li	a4,15
    8000540a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000540c:	6705                	lui	a4,0x1
    8000540e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005410:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005414:	5bdc                	lw	a5,52(a5)
    80005416:	2781                	sext.w	a5,a5
  if(max == 0)
    80005418:	c7d9                	beqz	a5,800054a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000541a:	471d                	li	a4,7
    8000541c:	08f77d63          	bgeu	a4,a5,800054b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005420:	100014b7          	lui	s1,0x10001
    80005424:	47a1                	li	a5,8
    80005426:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005428:	6609                	lui	a2,0x2
    8000542a:	4581                	li	a1,0
    8000542c:	00016517          	auipc	a0,0x16
    80005430:	bd450513          	addi	a0,a0,-1068 # 8001b000 <disk>
    80005434:	ffffb097          	auipc	ra,0xffffb
    80005438:	d5c080e7          	jalr	-676(ra) # 80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000543c:	00016717          	auipc	a4,0x16
    80005440:	bc470713          	addi	a4,a4,-1084 # 8001b000 <disk>
    80005444:	00c75793          	srli	a5,a4,0xc
    80005448:	2781                	sext.w	a5,a5
    8000544a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000544c:	00018797          	auipc	a5,0x18
    80005450:	bb478793          	addi	a5,a5,-1100 # 8001d000 <disk+0x2000>
    80005454:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005456:	00016717          	auipc	a4,0x16
    8000545a:	c2a70713          	addi	a4,a4,-982 # 8001b080 <disk+0x80>
    8000545e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005460:	00017717          	auipc	a4,0x17
    80005464:	ba070713          	addi	a4,a4,-1120 # 8001c000 <disk+0x1000>
    80005468:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000546a:	4705                	li	a4,1
    8000546c:	00e78c23          	sb	a4,24(a5)
    80005470:	00e78ca3          	sb	a4,25(a5)
    80005474:	00e78d23          	sb	a4,26(a5)
    80005478:	00e78da3          	sb	a4,27(a5)
    8000547c:	00e78e23          	sb	a4,28(a5)
    80005480:	00e78ea3          	sb	a4,29(a5)
    80005484:	00e78f23          	sb	a4,30(a5)
    80005488:	00e78fa3          	sb	a4,31(a5)
}
    8000548c:	60e2                	ld	ra,24(sp)
    8000548e:	6442                	ld	s0,16(sp)
    80005490:	64a2                	ld	s1,8(sp)
    80005492:	6105                	addi	sp,sp,32
    80005494:	8082                	ret
    panic("could not find virtio disk");
    80005496:	00003517          	auipc	a0,0x3
    8000549a:	31a50513          	addi	a0,a0,794 # 800087b0 <syscalls+0x350>
    8000549e:	00001097          	auipc	ra,0x1
    800054a2:	8ea080e7          	jalr	-1814(ra) # 80005d88 <panic>
    panic("virtio disk has no queue 0");
    800054a6:	00003517          	auipc	a0,0x3
    800054aa:	32a50513          	addi	a0,a0,810 # 800087d0 <syscalls+0x370>
    800054ae:	00001097          	auipc	ra,0x1
    800054b2:	8da080e7          	jalr	-1830(ra) # 80005d88 <panic>
    panic("virtio disk max queue too short");
    800054b6:	00003517          	auipc	a0,0x3
    800054ba:	33a50513          	addi	a0,a0,826 # 800087f0 <syscalls+0x390>
    800054be:	00001097          	auipc	ra,0x1
    800054c2:	8ca080e7          	jalr	-1846(ra) # 80005d88 <panic>

00000000800054c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054c6:	7159                	addi	sp,sp,-112
    800054c8:	f486                	sd	ra,104(sp)
    800054ca:	f0a2                	sd	s0,96(sp)
    800054cc:	eca6                	sd	s1,88(sp)
    800054ce:	e8ca                	sd	s2,80(sp)
    800054d0:	e4ce                	sd	s3,72(sp)
    800054d2:	e0d2                	sd	s4,64(sp)
    800054d4:	fc56                	sd	s5,56(sp)
    800054d6:	f85a                	sd	s6,48(sp)
    800054d8:	f45e                	sd	s7,40(sp)
    800054da:	f062                	sd	s8,32(sp)
    800054dc:	ec66                	sd	s9,24(sp)
    800054de:	e86a                	sd	s10,16(sp)
    800054e0:	1880                	addi	s0,sp,112
    800054e2:	892a                	mv	s2,a0
    800054e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054e6:	00c52c83          	lw	s9,12(a0)
    800054ea:	001c9c9b          	slliw	s9,s9,0x1
    800054ee:	1c82                	slli	s9,s9,0x20
    800054f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054f4:	00018517          	auipc	a0,0x18
    800054f8:	c3450513          	addi	a0,a0,-972 # 8001d128 <disk+0x2128>
    800054fc:	00001097          	auipc	ra,0x1
    80005500:	dd6080e7          	jalr	-554(ra) # 800062d2 <acquire>
  for(int i = 0; i < 3; i++){
    80005504:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005506:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005508:	00016b97          	auipc	s7,0x16
    8000550c:	af8b8b93          	addi	s7,s7,-1288 # 8001b000 <disk>
    80005510:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005512:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005514:	8a4e                	mv	s4,s3
    80005516:	a051                	j	8000559a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005518:	00fb86b3          	add	a3,s7,a5
    8000551c:	96da                	add	a3,a3,s6
    8000551e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005522:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005524:	0207c563          	bltz	a5,8000554e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005528:	2485                	addiw	s1,s1,1
    8000552a:	0711                	addi	a4,a4,4
    8000552c:	25548063          	beq	s1,s5,8000576c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005530:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005532:	00018697          	auipc	a3,0x18
    80005536:	ae668693          	addi	a3,a3,-1306 # 8001d018 <disk+0x2018>
    8000553a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000553c:	0006c583          	lbu	a1,0(a3)
    80005540:	fde1                	bnez	a1,80005518 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005542:	2785                	addiw	a5,a5,1
    80005544:	0685                	addi	a3,a3,1
    80005546:	ff879be3          	bne	a5,s8,8000553c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000554a:	57fd                	li	a5,-1
    8000554c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000554e:	02905a63          	blez	s1,80005582 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005552:	f9042503          	lw	a0,-112(s0)
    80005556:	00000097          	auipc	ra,0x0
    8000555a:	d90080e7          	jalr	-624(ra) # 800052e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000555e:	4785                	li	a5,1
    80005560:	0297d163          	bge	a5,s1,80005582 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005564:	f9442503          	lw	a0,-108(s0)
    80005568:	00000097          	auipc	ra,0x0
    8000556c:	d7e080e7          	jalr	-642(ra) # 800052e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005570:	4789                	li	a5,2
    80005572:	0097d863          	bge	a5,s1,80005582 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005576:	f9842503          	lw	a0,-104(s0)
    8000557a:	00000097          	auipc	ra,0x0
    8000557e:	d6c080e7          	jalr	-660(ra) # 800052e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005582:	00018597          	auipc	a1,0x18
    80005586:	ba658593          	addi	a1,a1,-1114 # 8001d128 <disk+0x2128>
    8000558a:	00018517          	auipc	a0,0x18
    8000558e:	a8e50513          	addi	a0,a0,-1394 # 8001d018 <disk+0x2018>
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	0bc080e7          	jalr	188(ra) # 8000164e <sleep>
  for(int i = 0; i < 3; i++){
    8000559a:	f9040713          	addi	a4,s0,-112
    8000559e:	84ce                	mv	s1,s3
    800055a0:	bf41                	j	80005530 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055a2:	20058713          	addi	a4,a1,512
    800055a6:	00471693          	slli	a3,a4,0x4
    800055aa:	00016717          	auipc	a4,0x16
    800055ae:	a5670713          	addi	a4,a4,-1450 # 8001b000 <disk>
    800055b2:	9736                	add	a4,a4,a3
    800055b4:	4685                	li	a3,1
    800055b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055ba:	20058713          	addi	a4,a1,512
    800055be:	00471693          	slli	a3,a4,0x4
    800055c2:	00016717          	auipc	a4,0x16
    800055c6:	a3e70713          	addi	a4,a4,-1474 # 8001b000 <disk>
    800055ca:	9736                	add	a4,a4,a3
    800055cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d4:	7679                	lui	a2,0xffffe
    800055d6:	963e                	add	a2,a2,a5
    800055d8:	00018697          	auipc	a3,0x18
    800055dc:	a2868693          	addi	a3,a3,-1496 # 8001d000 <disk+0x2000>
    800055e0:	6298                	ld	a4,0(a3)
    800055e2:	9732                	add	a4,a4,a2
    800055e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055e6:	6298                	ld	a4,0(a3)
    800055e8:	9732                	add	a4,a4,a2
    800055ea:	4541                	li	a0,16
    800055ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ee:	6298                	ld	a4,0(a3)
    800055f0:	9732                	add	a4,a4,a2
    800055f2:	4505                	li	a0,1
    800055f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055f8:	f9442703          	lw	a4,-108(s0)
    800055fc:	6288                	ld	a0,0(a3)
    800055fe:	962a                	add	a2,a2,a0
    80005600:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005604:	0712                	slli	a4,a4,0x4
    80005606:	6290                	ld	a2,0(a3)
    80005608:	963a                	add	a2,a2,a4
    8000560a:	05890513          	addi	a0,s2,88
    8000560e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005610:	6294                	ld	a3,0(a3)
    80005612:	96ba                	add	a3,a3,a4
    80005614:	40000613          	li	a2,1024
    80005618:	c690                	sw	a2,8(a3)
  if(write)
    8000561a:	140d0063          	beqz	s10,8000575a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000561e:	00018697          	auipc	a3,0x18
    80005622:	9e26b683          	ld	a3,-1566(a3) # 8001d000 <disk+0x2000>
    80005626:	96ba                	add	a3,a3,a4
    80005628:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000562c:	00016817          	auipc	a6,0x16
    80005630:	9d480813          	addi	a6,a6,-1580 # 8001b000 <disk>
    80005634:	00018517          	auipc	a0,0x18
    80005638:	9cc50513          	addi	a0,a0,-1588 # 8001d000 <disk+0x2000>
    8000563c:	6114                	ld	a3,0(a0)
    8000563e:	96ba                	add	a3,a3,a4
    80005640:	00c6d603          	lhu	a2,12(a3)
    80005644:	00166613          	ori	a2,a2,1
    80005648:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000564c:	f9842683          	lw	a3,-104(s0)
    80005650:	6110                	ld	a2,0(a0)
    80005652:	9732                	add	a4,a4,a2
    80005654:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005658:	20058613          	addi	a2,a1,512
    8000565c:	0612                	slli	a2,a2,0x4
    8000565e:	9642                	add	a2,a2,a6
    80005660:	577d                	li	a4,-1
    80005662:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005666:	00469713          	slli	a4,a3,0x4
    8000566a:	6114                	ld	a3,0(a0)
    8000566c:	96ba                	add	a3,a3,a4
    8000566e:	03078793          	addi	a5,a5,48
    80005672:	97c2                	add	a5,a5,a6
    80005674:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005676:	611c                	ld	a5,0(a0)
    80005678:	97ba                	add	a5,a5,a4
    8000567a:	4685                	li	a3,1
    8000567c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000567e:	611c                	ld	a5,0(a0)
    80005680:	97ba                	add	a5,a5,a4
    80005682:	4809                	li	a6,2
    80005684:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005688:	611c                	ld	a5,0(a0)
    8000568a:	973e                	add	a4,a4,a5
    8000568c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005690:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005694:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005698:	6518                	ld	a4,8(a0)
    8000569a:	00275783          	lhu	a5,2(a4)
    8000569e:	8b9d                	andi	a5,a5,7
    800056a0:	0786                	slli	a5,a5,0x1
    800056a2:	97ba                	add	a5,a5,a4
    800056a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ac:	6518                	ld	a4,8(a0)
    800056ae:	00275783          	lhu	a5,2(a4)
    800056b2:	2785                	addiw	a5,a5,1
    800056b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056bc:	100017b7          	lui	a5,0x10001
    800056c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056c4:	00492703          	lw	a4,4(s2)
    800056c8:	4785                	li	a5,1
    800056ca:	02f71163          	bne	a4,a5,800056ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056ce:	00018997          	auipc	s3,0x18
    800056d2:	a5a98993          	addi	s3,s3,-1446 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056d8:	85ce                	mv	a1,s3
    800056da:	854a                	mv	a0,s2
    800056dc:	ffffc097          	auipc	ra,0xffffc
    800056e0:	f72080e7          	jalr	-142(ra) # 8000164e <sleep>
  while(b->disk == 1) {
    800056e4:	00492783          	lw	a5,4(s2)
    800056e8:	fe9788e3          	beq	a5,s1,800056d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056ec:	f9042903          	lw	s2,-112(s0)
    800056f0:	20090793          	addi	a5,s2,512
    800056f4:	00479713          	slli	a4,a5,0x4
    800056f8:	00016797          	auipc	a5,0x16
    800056fc:	90878793          	addi	a5,a5,-1784 # 8001b000 <disk>
    80005700:	97ba                	add	a5,a5,a4
    80005702:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005706:	00018997          	auipc	s3,0x18
    8000570a:	8fa98993          	addi	s3,s3,-1798 # 8001d000 <disk+0x2000>
    8000570e:	00491713          	slli	a4,s2,0x4
    80005712:	0009b783          	ld	a5,0(s3)
    80005716:	97ba                	add	a5,a5,a4
    80005718:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000571c:	854a                	mv	a0,s2
    8000571e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005722:	00000097          	auipc	ra,0x0
    80005726:	bc4080e7          	jalr	-1084(ra) # 800052e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000572a:	8885                	andi	s1,s1,1
    8000572c:	f0ed                	bnez	s1,8000570e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000572e:	00018517          	auipc	a0,0x18
    80005732:	9fa50513          	addi	a0,a0,-1542 # 8001d128 <disk+0x2128>
    80005736:	00001097          	auipc	ra,0x1
    8000573a:	c50080e7          	jalr	-944(ra) # 80006386 <release>
}
    8000573e:	70a6                	ld	ra,104(sp)
    80005740:	7406                	ld	s0,96(sp)
    80005742:	64e6                	ld	s1,88(sp)
    80005744:	6946                	ld	s2,80(sp)
    80005746:	69a6                	ld	s3,72(sp)
    80005748:	6a06                	ld	s4,64(sp)
    8000574a:	7ae2                	ld	s5,56(sp)
    8000574c:	7b42                	ld	s6,48(sp)
    8000574e:	7ba2                	ld	s7,40(sp)
    80005750:	7c02                	ld	s8,32(sp)
    80005752:	6ce2                	ld	s9,24(sp)
    80005754:	6d42                	ld	s10,16(sp)
    80005756:	6165                	addi	sp,sp,112
    80005758:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000575a:	00018697          	auipc	a3,0x18
    8000575e:	8a66b683          	ld	a3,-1882(a3) # 8001d000 <disk+0x2000>
    80005762:	96ba                	add	a3,a3,a4
    80005764:	4609                	li	a2,2
    80005766:	00c69623          	sh	a2,12(a3)
    8000576a:	b5c9                	j	8000562c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000576c:	f9042583          	lw	a1,-112(s0)
    80005770:	20058793          	addi	a5,a1,512
    80005774:	0792                	slli	a5,a5,0x4
    80005776:	00016517          	auipc	a0,0x16
    8000577a:	93250513          	addi	a0,a0,-1742 # 8001b0a8 <disk+0xa8>
    8000577e:	953e                	add	a0,a0,a5
  if(write)
    80005780:	e20d11e3          	bnez	s10,800055a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005784:	20058713          	addi	a4,a1,512
    80005788:	00471693          	slli	a3,a4,0x4
    8000578c:	00016717          	auipc	a4,0x16
    80005790:	87470713          	addi	a4,a4,-1932 # 8001b000 <disk>
    80005794:	9736                	add	a4,a4,a3
    80005796:	0a072423          	sw	zero,168(a4)
    8000579a:	b505                	j	800055ba <virtio_disk_rw+0xf4>

000000008000579c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000579c:	1101                	addi	sp,sp,-32
    8000579e:	ec06                	sd	ra,24(sp)
    800057a0:	e822                	sd	s0,16(sp)
    800057a2:	e426                	sd	s1,8(sp)
    800057a4:	e04a                	sd	s2,0(sp)
    800057a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a8:	00018517          	auipc	a0,0x18
    800057ac:	98050513          	addi	a0,a0,-1664 # 8001d128 <disk+0x2128>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	b22080e7          	jalr	-1246(ra) # 800062d2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b8:	10001737          	lui	a4,0x10001
    800057bc:	533c                	lw	a5,96(a4)
    800057be:	8b8d                	andi	a5,a5,3
    800057c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c6:	00018797          	auipc	a5,0x18
    800057ca:	83a78793          	addi	a5,a5,-1990 # 8001d000 <disk+0x2000>
    800057ce:	6b94                	ld	a3,16(a5)
    800057d0:	0207d703          	lhu	a4,32(a5)
    800057d4:	0026d783          	lhu	a5,2(a3)
    800057d8:	06f70163          	beq	a4,a5,8000583a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057dc:	00016917          	auipc	s2,0x16
    800057e0:	82490913          	addi	s2,s2,-2012 # 8001b000 <disk>
    800057e4:	00018497          	auipc	s1,0x18
    800057e8:	81c48493          	addi	s1,s1,-2020 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057f0:	6898                	ld	a4,16(s1)
    800057f2:	0204d783          	lhu	a5,32(s1)
    800057f6:	8b9d                	andi	a5,a5,7
    800057f8:	078e                	slli	a5,a5,0x3
    800057fa:	97ba                	add	a5,a5,a4
    800057fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057fe:	20078713          	addi	a4,a5,512
    80005802:	0712                	slli	a4,a4,0x4
    80005804:	974a                	add	a4,a4,s2
    80005806:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000580a:	e731                	bnez	a4,80005856 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000580c:	20078793          	addi	a5,a5,512
    80005810:	0792                	slli	a5,a5,0x4
    80005812:	97ca                	add	a5,a5,s2
    80005814:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005816:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000581a:	ffffc097          	auipc	ra,0xffffc
    8000581e:	fc0080e7          	jalr	-64(ra) # 800017da <wakeup>

    disk.used_idx += 1;
    80005822:	0204d783          	lhu	a5,32(s1)
    80005826:	2785                	addiw	a5,a5,1
    80005828:	17c2                	slli	a5,a5,0x30
    8000582a:	93c1                	srli	a5,a5,0x30
    8000582c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005830:	6898                	ld	a4,16(s1)
    80005832:	00275703          	lhu	a4,2(a4)
    80005836:	faf71be3          	bne	a4,a5,800057ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000583a:	00018517          	auipc	a0,0x18
    8000583e:	8ee50513          	addi	a0,a0,-1810 # 8001d128 <disk+0x2128>
    80005842:	00001097          	auipc	ra,0x1
    80005846:	b44080e7          	jalr	-1212(ra) # 80006386 <release>
}
    8000584a:	60e2                	ld	ra,24(sp)
    8000584c:	6442                	ld	s0,16(sp)
    8000584e:	64a2                	ld	s1,8(sp)
    80005850:	6902                	ld	s2,0(sp)
    80005852:	6105                	addi	sp,sp,32
    80005854:	8082                	ret
      panic("virtio_disk_intr status");
    80005856:	00003517          	auipc	a0,0x3
    8000585a:	fba50513          	addi	a0,a0,-70 # 80008810 <syscalls+0x3b0>
    8000585e:	00000097          	auipc	ra,0x0
    80005862:	52a080e7          	jalr	1322(ra) # 80005d88 <panic>

0000000080005866 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005866:	1141                	addi	sp,sp,-16
    80005868:	e422                	sd	s0,8(sp)
    8000586a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid"
    8000586c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005870:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005874:	0037979b          	slliw	a5,a5,0x3
    80005878:	02004737          	lui	a4,0x2004
    8000587c:	97ba                	add	a5,a5,a4
    8000587e:	0200c737          	lui	a4,0x200c
    80005882:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005886:	000f4637          	lui	a2,0xf4
    8000588a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000588e:	95b2                	add	a1,a1,a2
    80005890:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005892:	00269713          	slli	a4,a3,0x2
    80005896:	9736                	add	a4,a4,a3
    80005898:	00371693          	slli	a3,a4,0x3
    8000589c:	00018717          	auipc	a4,0x18
    800058a0:	76470713          	addi	a4,a4,1892 # 8001e000 <timer_scratch>
    800058a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058a8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0"
    800058aa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0"
    800058ae:	00000797          	auipc	a5,0x0
    800058b2:	97278793          	addi	a5,a5,-1678 # 80005220 <timervec>
    800058b6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus"
    800058ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058be:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0"
    800058c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie"
    800058c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058ca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0"
    800058ce:	30479073          	csrw	mie,a5
}
    800058d2:	6422                	ld	s0,8(sp)
    800058d4:	0141                	addi	sp,sp,16
    800058d6:	8082                	ret

00000000800058d8 <start>:
{
    800058d8:	1141                	addi	sp,sp,-16
    800058da:	e406                	sd	ra,8(sp)
    800058dc:	e022                	sd	s0,0(sp)
    800058de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus"
    800058e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058e4:	7779                	lui	a4,0xffffe
    800058e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058ec:	6705                	lui	a4,0x1
    800058ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058f2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0"
    800058f4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0"
    800058f8:	ffffb797          	auipc	a5,0xffffb
    800058fc:	a4678793          	addi	a5,a5,-1466 # 8000033e <main>
    80005900:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0"
    80005904:	4781                	li	a5,0
    80005906:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0"
    8000590a:	67c1                	lui	a5,0x10
    8000590c:	17fd                	addi	a5,a5,-1
    8000590e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0"
    80005912:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie"
    80005916:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000591a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0"
    8000591e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0"
    80005922:	57fd                	li	a5,-1
    80005924:	83a9                	srli	a5,a5,0xa
    80005926:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0"
    8000592a:	47bd                	li	a5,15
    8000592c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005930:	00000097          	auipc	ra,0x0
    80005934:	f36080e7          	jalr	-202(ra) # 80005866 <timerinit>
  asm volatile("csrr %0, mhartid"
    80005938:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000593c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0"
    8000593e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005940:	30200073          	mret
}
    80005944:	60a2                	ld	ra,8(sp)
    80005946:	6402                	ld	s0,0(sp)
    80005948:	0141                	addi	sp,sp,16
    8000594a:	8082                	ret

000000008000594c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000594c:	715d                	addi	sp,sp,-80
    8000594e:	e486                	sd	ra,72(sp)
    80005950:	e0a2                	sd	s0,64(sp)
    80005952:	fc26                	sd	s1,56(sp)
    80005954:	f84a                	sd	s2,48(sp)
    80005956:	f44e                	sd	s3,40(sp)
    80005958:	f052                	sd	s4,32(sp)
    8000595a:	ec56                	sd	s5,24(sp)
    8000595c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000595e:	04c05663          	blez	a2,800059aa <consolewrite+0x5e>
    80005962:	8a2a                	mv	s4,a0
    80005964:	84ae                	mv	s1,a1
    80005966:	89b2                	mv	s3,a2
    80005968:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000596a:	5afd                	li	s5,-1
    8000596c:	4685                	li	a3,1
    8000596e:	8626                	mv	a2,s1
    80005970:	85d2                	mv	a1,s4
    80005972:	fbf40513          	addi	a0,s0,-65
    80005976:	ffffc097          	auipc	ra,0xffffc
    8000597a:	0d2080e7          	jalr	210(ra) # 80001a48 <either_copyin>
    8000597e:	01550c63          	beq	a0,s5,80005996 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005982:	fbf44503          	lbu	a0,-65(s0)
    80005986:	00000097          	auipc	ra,0x0
    8000598a:	78e080e7          	jalr	1934(ra) # 80006114 <uartputc>
  for(i = 0; i < n; i++){
    8000598e:	2905                	addiw	s2,s2,1
    80005990:	0485                	addi	s1,s1,1
    80005992:	fd299de3          	bne	s3,s2,8000596c <consolewrite+0x20>
  }

  return i;
}
    80005996:	854a                	mv	a0,s2
    80005998:	60a6                	ld	ra,72(sp)
    8000599a:	6406                	ld	s0,64(sp)
    8000599c:	74e2                	ld	s1,56(sp)
    8000599e:	7942                	ld	s2,48(sp)
    800059a0:	79a2                	ld	s3,40(sp)
    800059a2:	7a02                	ld	s4,32(sp)
    800059a4:	6ae2                	ld	s5,24(sp)
    800059a6:	6161                	addi	sp,sp,80
    800059a8:	8082                	ret
  for(i = 0; i < n; i++){
    800059aa:	4901                	li	s2,0
    800059ac:	b7ed                	j	80005996 <consolewrite+0x4a>

00000000800059ae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ae:	7119                	addi	sp,sp,-128
    800059b0:	fc86                	sd	ra,120(sp)
    800059b2:	f8a2                	sd	s0,112(sp)
    800059b4:	f4a6                	sd	s1,104(sp)
    800059b6:	f0ca                	sd	s2,96(sp)
    800059b8:	ecce                	sd	s3,88(sp)
    800059ba:	e8d2                	sd	s4,80(sp)
    800059bc:	e4d6                	sd	s5,72(sp)
    800059be:	e0da                	sd	s6,64(sp)
    800059c0:	fc5e                	sd	s7,56(sp)
    800059c2:	f862                	sd	s8,48(sp)
    800059c4:	f466                	sd	s9,40(sp)
    800059c6:	f06a                	sd	s10,32(sp)
    800059c8:	ec6e                	sd	s11,24(sp)
    800059ca:	0100                	addi	s0,sp,128
    800059cc:	8b2a                	mv	s6,a0
    800059ce:	8aae                	mv	s5,a1
    800059d0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059d2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059d6:	00020517          	auipc	a0,0x20
    800059da:	76a50513          	addi	a0,a0,1898 # 80026140 <cons>
    800059de:	00001097          	auipc	ra,0x1
    800059e2:	8f4080e7          	jalr	-1804(ra) # 800062d2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059e6:	00020497          	auipc	s1,0x20
    800059ea:	75a48493          	addi	s1,s1,1882 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059ee:	89a6                	mv	s3,s1
    800059f0:	00020917          	auipc	s2,0x20
    800059f4:	7e890913          	addi	s2,s2,2024 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059f8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059fa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059fc:	4da9                	li	s11,10
  while(n > 0){
    800059fe:	07405863          	blez	s4,80005a6e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a02:	0984a783          	lw	a5,152(s1)
    80005a06:	09c4a703          	lw	a4,156(s1)
    80005a0a:	02f71463          	bne	a4,a5,80005a32 <consoleread+0x84>
      if(myproc()->killed){
    80005a0e:	ffffb097          	auipc	ra,0xffffb
    80005a12:	584080e7          	jalr	1412(ra) # 80000f92 <myproc>
    80005a16:	551c                	lw	a5,40(a0)
    80005a18:	e7b5                	bnez	a5,80005a84 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a1a:	85ce                	mv	a1,s3
    80005a1c:	854a                	mv	a0,s2
    80005a1e:	ffffc097          	auipc	ra,0xffffc
    80005a22:	c30080e7          	jalr	-976(ra) # 8000164e <sleep>
    while(cons.r == cons.w){
    80005a26:	0984a783          	lw	a5,152(s1)
    80005a2a:	09c4a703          	lw	a4,156(s1)
    80005a2e:	fef700e3          	beq	a4,a5,80005a0e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a32:	0017871b          	addiw	a4,a5,1
    80005a36:	08e4ac23          	sw	a4,152(s1)
    80005a3a:	07f7f713          	andi	a4,a5,127
    80005a3e:	9726                	add	a4,a4,s1
    80005a40:	01874703          	lbu	a4,24(a4)
    80005a44:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a48:	079c0663          	beq	s8,s9,80005ab4 <consoleread+0x106>
    cbuf = c;
    80005a4c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a50:	4685                	li	a3,1
    80005a52:	f8f40613          	addi	a2,s0,-113
    80005a56:	85d6                	mv	a1,s5
    80005a58:	855a                	mv	a0,s6
    80005a5a:	ffffc097          	auipc	ra,0xffffc
    80005a5e:	f98080e7          	jalr	-104(ra) # 800019f2 <either_copyout>
    80005a62:	01a50663          	beq	a0,s10,80005a6e <consoleread+0xc0>
    dst++;
    80005a66:	0a85                	addi	s5,s5,1
    --n;
    80005a68:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a6a:	f9bc1ae3          	bne	s8,s11,800059fe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a6e:	00020517          	auipc	a0,0x20
    80005a72:	6d250513          	addi	a0,a0,1746 # 80026140 <cons>
    80005a76:	00001097          	auipc	ra,0x1
    80005a7a:	910080e7          	jalr	-1776(ra) # 80006386 <release>

  return target - n;
    80005a7e:	414b853b          	subw	a0,s7,s4
    80005a82:	a811                	j	80005a96 <consoleread+0xe8>
        release(&cons.lock);
    80005a84:	00020517          	auipc	a0,0x20
    80005a88:	6bc50513          	addi	a0,a0,1724 # 80026140 <cons>
    80005a8c:	00001097          	auipc	ra,0x1
    80005a90:	8fa080e7          	jalr	-1798(ra) # 80006386 <release>
        return -1;
    80005a94:	557d                	li	a0,-1
}
    80005a96:	70e6                	ld	ra,120(sp)
    80005a98:	7446                	ld	s0,112(sp)
    80005a9a:	74a6                	ld	s1,104(sp)
    80005a9c:	7906                	ld	s2,96(sp)
    80005a9e:	69e6                	ld	s3,88(sp)
    80005aa0:	6a46                	ld	s4,80(sp)
    80005aa2:	6aa6                	ld	s5,72(sp)
    80005aa4:	6b06                	ld	s6,64(sp)
    80005aa6:	7be2                	ld	s7,56(sp)
    80005aa8:	7c42                	ld	s8,48(sp)
    80005aaa:	7ca2                	ld	s9,40(sp)
    80005aac:	7d02                	ld	s10,32(sp)
    80005aae:	6de2                	ld	s11,24(sp)
    80005ab0:	6109                	addi	sp,sp,128
    80005ab2:	8082                	ret
      if(n < target){
    80005ab4:	000a071b          	sext.w	a4,s4
    80005ab8:	fb777be3          	bgeu	a4,s7,80005a6e <consoleread+0xc0>
        cons.r--;
    80005abc:	00020717          	auipc	a4,0x20
    80005ac0:	70f72e23          	sw	a5,1820(a4) # 800261d8 <cons+0x98>
    80005ac4:	b76d                	j	80005a6e <consoleread+0xc0>

0000000080005ac6 <consputc>:
{
    80005ac6:	1141                	addi	sp,sp,-16
    80005ac8:	e406                	sd	ra,8(sp)
    80005aca:	e022                	sd	s0,0(sp)
    80005acc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ace:	10000793          	li	a5,256
    80005ad2:	00f50a63          	beq	a0,a5,80005ae6 <consputc+0x20>
    uartputc_sync(c);
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	564080e7          	jalr	1380(ra) # 8000603a <uartputc_sync>
}
    80005ade:	60a2                	ld	ra,8(sp)
    80005ae0:	6402                	ld	s0,0(sp)
    80005ae2:	0141                	addi	sp,sp,16
    80005ae4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae6:	4521                	li	a0,8
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	552080e7          	jalr	1362(ra) # 8000603a <uartputc_sync>
    80005af0:	02000513          	li	a0,32
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	546080e7          	jalr	1350(ra) # 8000603a <uartputc_sync>
    80005afc:	4521                	li	a0,8
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	53c080e7          	jalr	1340(ra) # 8000603a <uartputc_sync>
    80005b06:	bfe1                	j	80005ade <consputc+0x18>

0000000080005b08 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b08:	1101                	addi	sp,sp,-32
    80005b0a:	ec06                	sd	ra,24(sp)
    80005b0c:	e822                	sd	s0,16(sp)
    80005b0e:	e426                	sd	s1,8(sp)
    80005b10:	e04a                	sd	s2,0(sp)
    80005b12:	1000                	addi	s0,sp,32
    80005b14:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b16:	00020517          	auipc	a0,0x20
    80005b1a:	62a50513          	addi	a0,a0,1578 # 80026140 <cons>
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	7b4080e7          	jalr	1972(ra) # 800062d2 <acquire>

  switch(c){
    80005b26:	47d5                	li	a5,21
    80005b28:	0af48663          	beq	s1,a5,80005bd4 <consoleintr+0xcc>
    80005b2c:	0297ca63          	blt	a5,s1,80005b60 <consoleintr+0x58>
    80005b30:	47a1                	li	a5,8
    80005b32:	0ef48763          	beq	s1,a5,80005c20 <consoleintr+0x118>
    80005b36:	47c1                	li	a5,16
    80005b38:	10f49a63          	bne	s1,a5,80005c4c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b3c:	ffffc097          	auipc	ra,0xffffc
    80005b40:	f62080e7          	jalr	-158(ra) # 80001a9e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b44:	00020517          	auipc	a0,0x20
    80005b48:	5fc50513          	addi	a0,a0,1532 # 80026140 <cons>
    80005b4c:	00001097          	auipc	ra,0x1
    80005b50:	83a080e7          	jalr	-1990(ra) # 80006386 <release>
}
    80005b54:	60e2                	ld	ra,24(sp)
    80005b56:	6442                	ld	s0,16(sp)
    80005b58:	64a2                	ld	s1,8(sp)
    80005b5a:	6902                	ld	s2,0(sp)
    80005b5c:	6105                	addi	sp,sp,32
    80005b5e:	8082                	ret
  switch(c){
    80005b60:	07f00793          	li	a5,127
    80005b64:	0af48e63          	beq	s1,a5,80005c20 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b68:	00020717          	auipc	a4,0x20
    80005b6c:	5d870713          	addi	a4,a4,1496 # 80026140 <cons>
    80005b70:	0a072783          	lw	a5,160(a4)
    80005b74:	09872703          	lw	a4,152(a4)
    80005b78:	9f99                	subw	a5,a5,a4
    80005b7a:	07f00713          	li	a4,127
    80005b7e:	fcf763e3          	bltu	a4,a5,80005b44 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b82:	47b5                	li	a5,13
    80005b84:	0cf48763          	beq	s1,a5,80005c52 <consoleintr+0x14a>
      consputc(c);
    80005b88:	8526                	mv	a0,s1
    80005b8a:	00000097          	auipc	ra,0x0
    80005b8e:	f3c080e7          	jalr	-196(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b92:	00020797          	auipc	a5,0x20
    80005b96:	5ae78793          	addi	a5,a5,1454 # 80026140 <cons>
    80005b9a:	0a07a703          	lw	a4,160(a5)
    80005b9e:	0017069b          	addiw	a3,a4,1
    80005ba2:	0006861b          	sext.w	a2,a3
    80005ba6:	0ad7a023          	sw	a3,160(a5)
    80005baa:	07f77713          	andi	a4,a4,127
    80005bae:	97ba                	add	a5,a5,a4
    80005bb0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bb4:	47a9                	li	a5,10
    80005bb6:	0cf48563          	beq	s1,a5,80005c80 <consoleintr+0x178>
    80005bba:	4791                	li	a5,4
    80005bbc:	0cf48263          	beq	s1,a5,80005c80 <consoleintr+0x178>
    80005bc0:	00020797          	auipc	a5,0x20
    80005bc4:	6187a783          	lw	a5,1560(a5) # 800261d8 <cons+0x98>
    80005bc8:	0807879b          	addiw	a5,a5,128
    80005bcc:	f6f61ce3          	bne	a2,a5,80005b44 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd0:	863e                	mv	a2,a5
    80005bd2:	a07d                	j	80005c80 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bd4:	00020717          	auipc	a4,0x20
    80005bd8:	56c70713          	addi	a4,a4,1388 # 80026140 <cons>
    80005bdc:	0a072783          	lw	a5,160(a4)
    80005be0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005be4:	00020497          	auipc	s1,0x20
    80005be8:	55c48493          	addi	s1,s1,1372 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bec:	4929                	li	s2,10
    80005bee:	f4f70be3          	beq	a4,a5,80005b44 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bf2:	37fd                	addiw	a5,a5,-1
    80005bf4:	07f7f713          	andi	a4,a5,127
    80005bf8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bfa:	01874703          	lbu	a4,24(a4)
    80005bfe:	f52703e3          	beq	a4,s2,80005b44 <consoleintr+0x3c>
      cons.e--;
    80005c02:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c06:	10000513          	li	a0,256
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	ebc080e7          	jalr	-324(ra) # 80005ac6 <consputc>
    while(cons.e != cons.w &&
    80005c12:	0a04a783          	lw	a5,160(s1)
    80005c16:	09c4a703          	lw	a4,156(s1)
    80005c1a:	fcf71ce3          	bne	a4,a5,80005bf2 <consoleintr+0xea>
    80005c1e:	b71d                	j	80005b44 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c20:	00020717          	auipc	a4,0x20
    80005c24:	52070713          	addi	a4,a4,1312 # 80026140 <cons>
    80005c28:	0a072783          	lw	a5,160(a4)
    80005c2c:	09c72703          	lw	a4,156(a4)
    80005c30:	f0f70ae3          	beq	a4,a5,80005b44 <consoleintr+0x3c>
      cons.e--;
    80005c34:	37fd                	addiw	a5,a5,-1
    80005c36:	00020717          	auipc	a4,0x20
    80005c3a:	5af72523          	sw	a5,1450(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c3e:	10000513          	li	a0,256
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	e84080e7          	jalr	-380(ra) # 80005ac6 <consputc>
    80005c4a:	bded                	j	80005b44 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c4c:	ee048ce3          	beqz	s1,80005b44 <consoleintr+0x3c>
    80005c50:	bf21                	j	80005b68 <consoleintr+0x60>
      consputc(c);
    80005c52:	4529                	li	a0,10
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	e72080e7          	jalr	-398(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c5c:	00020797          	auipc	a5,0x20
    80005c60:	4e478793          	addi	a5,a5,1252 # 80026140 <cons>
    80005c64:	0a07a703          	lw	a4,160(a5)
    80005c68:	0017069b          	addiw	a3,a4,1
    80005c6c:	0006861b          	sext.w	a2,a3
    80005c70:	0ad7a023          	sw	a3,160(a5)
    80005c74:	07f77713          	andi	a4,a4,127
    80005c78:	97ba                	add	a5,a5,a4
    80005c7a:	4729                	li	a4,10
    80005c7c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c80:	00020797          	auipc	a5,0x20
    80005c84:	54c7ae23          	sw	a2,1372(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c88:	00020517          	auipc	a0,0x20
    80005c8c:	55050513          	addi	a0,a0,1360 # 800261d8 <cons+0x98>
    80005c90:	ffffc097          	auipc	ra,0xffffc
    80005c94:	b4a080e7          	jalr	-1206(ra) # 800017da <wakeup>
    80005c98:	b575                	j	80005b44 <consoleintr+0x3c>

0000000080005c9a <consoleinit>:

void
consoleinit(void)
{
    80005c9a:	1141                	addi	sp,sp,-16
    80005c9c:	e406                	sd	ra,8(sp)
    80005c9e:	e022                	sd	s0,0(sp)
    80005ca0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ca2:	00003597          	auipc	a1,0x3
    80005ca6:	b8658593          	addi	a1,a1,-1146 # 80008828 <syscalls+0x3c8>
    80005caa:	00020517          	auipc	a0,0x20
    80005cae:	49650513          	addi	a0,a0,1174 # 80026140 <cons>
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	590080e7          	jalr	1424(ra) # 80006242 <initlock>

  uartinit();
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	330080e7          	jalr	816(ra) # 80005fea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cc2:	00013797          	auipc	a5,0x13
    80005cc6:	40678793          	addi	a5,a5,1030 # 800190c8 <devsw>
    80005cca:	00000717          	auipc	a4,0x0
    80005cce:	ce470713          	addi	a4,a4,-796 # 800059ae <consoleread>
    80005cd2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cd4:	00000717          	auipc	a4,0x0
    80005cd8:	c7870713          	addi	a4,a4,-904 # 8000594c <consolewrite>
    80005cdc:	ef98                	sd	a4,24(a5)
}
    80005cde:	60a2                	ld	ra,8(sp)
    80005ce0:	6402                	ld	s0,0(sp)
    80005ce2:	0141                	addi	sp,sp,16
    80005ce4:	8082                	ret

0000000080005ce6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ce6:	7179                	addi	sp,sp,-48
    80005ce8:	f406                	sd	ra,40(sp)
    80005cea:	f022                	sd	s0,32(sp)
    80005cec:	ec26                	sd	s1,24(sp)
    80005cee:	e84a                	sd	s2,16(sp)
    80005cf0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cf2:	c219                	beqz	a2,80005cf8 <printint+0x12>
    80005cf4:	08054663          	bltz	a0,80005d80 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cf8:	2501                	sext.w	a0,a0
    80005cfa:	4881                	li	a7,0
    80005cfc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d00:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d02:	2581                	sext.w	a1,a1
    80005d04:	00003617          	auipc	a2,0x3
    80005d08:	b5460613          	addi	a2,a2,-1196 # 80008858 <digits>
    80005d0c:	883a                	mv	a6,a4
    80005d0e:	2705                	addiw	a4,a4,1
    80005d10:	02b577bb          	remuw	a5,a0,a1
    80005d14:	1782                	slli	a5,a5,0x20
    80005d16:	9381                	srli	a5,a5,0x20
    80005d18:	97b2                	add	a5,a5,a2
    80005d1a:	0007c783          	lbu	a5,0(a5)
    80005d1e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d22:	0005079b          	sext.w	a5,a0
    80005d26:	02b5553b          	divuw	a0,a0,a1
    80005d2a:	0685                	addi	a3,a3,1
    80005d2c:	feb7f0e3          	bgeu	a5,a1,80005d0c <printint+0x26>

  if(sign)
    80005d30:	00088b63          	beqz	a7,80005d46 <printint+0x60>
    buf[i++] = '-';
    80005d34:	fe040793          	addi	a5,s0,-32
    80005d38:	973e                	add	a4,a4,a5
    80005d3a:	02d00793          	li	a5,45
    80005d3e:	fef70823          	sb	a5,-16(a4)
    80005d42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d46:	02e05763          	blez	a4,80005d74 <printint+0x8e>
    80005d4a:	fd040793          	addi	a5,s0,-48
    80005d4e:	00e784b3          	add	s1,a5,a4
    80005d52:	fff78913          	addi	s2,a5,-1
    80005d56:	993a                	add	s2,s2,a4
    80005d58:	377d                	addiw	a4,a4,-1
    80005d5a:	1702                	slli	a4,a4,0x20
    80005d5c:	9301                	srli	a4,a4,0x20
    80005d5e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d62:	fff4c503          	lbu	a0,-1(s1)
    80005d66:	00000097          	auipc	ra,0x0
    80005d6a:	d60080e7          	jalr	-672(ra) # 80005ac6 <consputc>
  while(--i >= 0)
    80005d6e:	14fd                	addi	s1,s1,-1
    80005d70:	ff2499e3          	bne	s1,s2,80005d62 <printint+0x7c>
}
    80005d74:	70a2                	ld	ra,40(sp)
    80005d76:	7402                	ld	s0,32(sp)
    80005d78:	64e2                	ld	s1,24(sp)
    80005d7a:	6942                	ld	s2,16(sp)
    80005d7c:	6145                	addi	sp,sp,48
    80005d7e:	8082                	ret
    x = -xx;
    80005d80:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d84:	4885                	li	a7,1
    x = -xx;
    80005d86:	bf9d                	j	80005cfc <printint+0x16>

0000000080005d88 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d88:	1101                	addi	sp,sp,-32
    80005d8a:	ec06                	sd	ra,24(sp)
    80005d8c:	e822                	sd	s0,16(sp)
    80005d8e:	e426                	sd	s1,8(sp)
    80005d90:	1000                	addi	s0,sp,32
    80005d92:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d94:	00020797          	auipc	a5,0x20
    80005d98:	4607a623          	sw	zero,1132(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d9c:	00003517          	auipc	a0,0x3
    80005da0:	a9450513          	addi	a0,a0,-1388 # 80008830 <syscalls+0x3d0>
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	02e080e7          	jalr	46(ra) # 80005dd2 <printf>
  printf(s);
    80005dac:	8526                	mv	a0,s1
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	024080e7          	jalr	36(ra) # 80005dd2 <printf>
  printf("\n");
    80005db6:	00002517          	auipc	a0,0x2
    80005dba:	29250513          	addi	a0,a0,658 # 80008048 <etext+0x48>
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	014080e7          	jalr	20(ra) # 80005dd2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dc6:	4785                	li	a5,1
    80005dc8:	00003717          	auipc	a4,0x3
    80005dcc:	24f72a23          	sw	a5,596(a4) # 8000901c <panicked>
  for(;;)
    80005dd0:	a001                	j	80005dd0 <panic+0x48>

0000000080005dd2 <printf>:
{
    80005dd2:	7131                	addi	sp,sp,-192
    80005dd4:	fc86                	sd	ra,120(sp)
    80005dd6:	f8a2                	sd	s0,112(sp)
    80005dd8:	f4a6                	sd	s1,104(sp)
    80005dda:	f0ca                	sd	s2,96(sp)
    80005ddc:	ecce                	sd	s3,88(sp)
    80005dde:	e8d2                	sd	s4,80(sp)
    80005de0:	e4d6                	sd	s5,72(sp)
    80005de2:	e0da                	sd	s6,64(sp)
    80005de4:	fc5e                	sd	s7,56(sp)
    80005de6:	f862                	sd	s8,48(sp)
    80005de8:	f466                	sd	s9,40(sp)
    80005dea:	f06a                	sd	s10,32(sp)
    80005dec:	ec6e                	sd	s11,24(sp)
    80005dee:	0100                	addi	s0,sp,128
    80005df0:	8a2a                	mv	s4,a0
    80005df2:	e40c                	sd	a1,8(s0)
    80005df4:	e810                	sd	a2,16(s0)
    80005df6:	ec14                	sd	a3,24(s0)
    80005df8:	f018                	sd	a4,32(s0)
    80005dfa:	f41c                	sd	a5,40(s0)
    80005dfc:	03043823          	sd	a6,48(s0)
    80005e00:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e04:	00020d97          	auipc	s11,0x20
    80005e08:	3fcdad83          	lw	s11,1020(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e0c:	020d9b63          	bnez	s11,80005e42 <printf+0x70>
  if (fmt == 0)
    80005e10:	040a0263          	beqz	s4,80005e54 <printf+0x82>
  va_start(ap, fmt);
    80005e14:	00840793          	addi	a5,s0,8
    80005e18:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e1c:	000a4503          	lbu	a0,0(s4)
    80005e20:	16050263          	beqz	a0,80005f84 <printf+0x1b2>
    80005e24:	4481                	li	s1,0
    if(c != '%'){
    80005e26:	02500a93          	li	s5,37
    switch(c){
    80005e2a:	07000b13          	li	s6,112
  consputc('x');
    80005e2e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e30:	00003b97          	auipc	s7,0x3
    80005e34:	a28b8b93          	addi	s7,s7,-1496 # 80008858 <digits>
    switch(c){
    80005e38:	07300c93          	li	s9,115
    80005e3c:	06400c13          	li	s8,100
    80005e40:	a82d                	j	80005e7a <printf+0xa8>
    acquire(&pr.lock);
    80005e42:	00020517          	auipc	a0,0x20
    80005e46:	3a650513          	addi	a0,a0,934 # 800261e8 <pr>
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	488080e7          	jalr	1160(ra) # 800062d2 <acquire>
    80005e52:	bf7d                	j	80005e10 <printf+0x3e>
    panic("null fmt");
    80005e54:	00003517          	auipc	a0,0x3
    80005e58:	9ec50513          	addi	a0,a0,-1556 # 80008840 <syscalls+0x3e0>
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	f2c080e7          	jalr	-212(ra) # 80005d88 <panic>
      consputc(c);
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	c62080e7          	jalr	-926(ra) # 80005ac6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e6c:	2485                	addiw	s1,s1,1
    80005e6e:	009a07b3          	add	a5,s4,s1
    80005e72:	0007c503          	lbu	a0,0(a5)
    80005e76:	10050763          	beqz	a0,80005f84 <printf+0x1b2>
    if(c != '%'){
    80005e7a:	ff5515e3          	bne	a0,s5,80005e64 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e7e:	2485                	addiw	s1,s1,1
    80005e80:	009a07b3          	add	a5,s4,s1
    80005e84:	0007c783          	lbu	a5,0(a5)
    80005e88:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e8c:	cfe5                	beqz	a5,80005f84 <printf+0x1b2>
    switch(c){
    80005e8e:	05678a63          	beq	a5,s6,80005ee2 <printf+0x110>
    80005e92:	02fb7663          	bgeu	s6,a5,80005ebe <printf+0xec>
    80005e96:	09978963          	beq	a5,s9,80005f28 <printf+0x156>
    80005e9a:	07800713          	li	a4,120
    80005e9e:	0ce79863          	bne	a5,a4,80005f6e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ea2:	f8843783          	ld	a5,-120(s0)
    80005ea6:	00878713          	addi	a4,a5,8
    80005eaa:	f8e43423          	sd	a4,-120(s0)
    80005eae:	4605                	li	a2,1
    80005eb0:	85ea                	mv	a1,s10
    80005eb2:	4388                	lw	a0,0(a5)
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	e32080e7          	jalr	-462(ra) # 80005ce6 <printint>
      break;
    80005ebc:	bf45                	j	80005e6c <printf+0x9a>
    switch(c){
    80005ebe:	0b578263          	beq	a5,s5,80005f62 <printf+0x190>
    80005ec2:	0b879663          	bne	a5,s8,80005f6e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ec6:	f8843783          	ld	a5,-120(s0)
    80005eca:	00878713          	addi	a4,a5,8
    80005ece:	f8e43423          	sd	a4,-120(s0)
    80005ed2:	4605                	li	a2,1
    80005ed4:	45a9                	li	a1,10
    80005ed6:	4388                	lw	a0,0(a5)
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	e0e080e7          	jalr	-498(ra) # 80005ce6 <printint>
      break;
    80005ee0:	b771                	j	80005e6c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ef2:	03000513          	li	a0,48
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	bd0080e7          	jalr	-1072(ra) # 80005ac6 <consputc>
  consputc('x');
    80005efe:	07800513          	li	a0,120
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	bc4080e7          	jalr	-1084(ra) # 80005ac6 <consputc>
    80005f0a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f0c:	03c9d793          	srli	a5,s3,0x3c
    80005f10:	97de                	add	a5,a5,s7
    80005f12:	0007c503          	lbu	a0,0(a5)
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	bb0080e7          	jalr	-1104(ra) # 80005ac6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f1e:	0992                	slli	s3,s3,0x4
    80005f20:	397d                	addiw	s2,s2,-1
    80005f22:	fe0915e3          	bnez	s2,80005f0c <printf+0x13a>
    80005f26:	b799                	j	80005e6c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f28:	f8843783          	ld	a5,-120(s0)
    80005f2c:	00878713          	addi	a4,a5,8
    80005f30:	f8e43423          	sd	a4,-120(s0)
    80005f34:	0007b903          	ld	s2,0(a5)
    80005f38:	00090e63          	beqz	s2,80005f54 <printf+0x182>
      for(; *s; s++)
    80005f3c:	00094503          	lbu	a0,0(s2)
    80005f40:	d515                	beqz	a0,80005e6c <printf+0x9a>
        consputc(*s);
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	b84080e7          	jalr	-1148(ra) # 80005ac6 <consputc>
      for(; *s; s++)
    80005f4a:	0905                	addi	s2,s2,1
    80005f4c:	00094503          	lbu	a0,0(s2)
    80005f50:	f96d                	bnez	a0,80005f42 <printf+0x170>
    80005f52:	bf29                	j	80005e6c <printf+0x9a>
        s = "(null)";
    80005f54:	00003917          	auipc	s2,0x3
    80005f58:	8e490913          	addi	s2,s2,-1820 # 80008838 <syscalls+0x3d8>
      for(; *s; s++)
    80005f5c:	02800513          	li	a0,40
    80005f60:	b7cd                	j	80005f42 <printf+0x170>
      consputc('%');
    80005f62:	8556                	mv	a0,s5
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	b62080e7          	jalr	-1182(ra) # 80005ac6 <consputc>
      break;
    80005f6c:	b701                	j	80005e6c <printf+0x9a>
      consputc('%');
    80005f6e:	8556                	mv	a0,s5
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	b56080e7          	jalr	-1194(ra) # 80005ac6 <consputc>
      consputc(c);
    80005f78:	854a                	mv	a0,s2
    80005f7a:	00000097          	auipc	ra,0x0
    80005f7e:	b4c080e7          	jalr	-1204(ra) # 80005ac6 <consputc>
      break;
    80005f82:	b5ed                	j	80005e6c <printf+0x9a>
  if(locking)
    80005f84:	020d9163          	bnez	s11,80005fa6 <printf+0x1d4>
}
    80005f88:	70e6                	ld	ra,120(sp)
    80005f8a:	7446                	ld	s0,112(sp)
    80005f8c:	74a6                	ld	s1,104(sp)
    80005f8e:	7906                	ld	s2,96(sp)
    80005f90:	69e6                	ld	s3,88(sp)
    80005f92:	6a46                	ld	s4,80(sp)
    80005f94:	6aa6                	ld	s5,72(sp)
    80005f96:	6b06                	ld	s6,64(sp)
    80005f98:	7be2                	ld	s7,56(sp)
    80005f9a:	7c42                	ld	s8,48(sp)
    80005f9c:	7ca2                	ld	s9,40(sp)
    80005f9e:	7d02                	ld	s10,32(sp)
    80005fa0:	6de2                	ld	s11,24(sp)
    80005fa2:	6129                	addi	sp,sp,192
    80005fa4:	8082                	ret
    release(&pr.lock);
    80005fa6:	00020517          	auipc	a0,0x20
    80005faa:	24250513          	addi	a0,a0,578 # 800261e8 <pr>
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	3d8080e7          	jalr	984(ra) # 80006386 <release>
}
    80005fb6:	bfc9                	j	80005f88 <printf+0x1b6>

0000000080005fb8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fb8:	1101                	addi	sp,sp,-32
    80005fba:	ec06                	sd	ra,24(sp)
    80005fbc:	e822                	sd	s0,16(sp)
    80005fbe:	e426                	sd	s1,8(sp)
    80005fc0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fc2:	00020497          	auipc	s1,0x20
    80005fc6:	22648493          	addi	s1,s1,550 # 800261e8 <pr>
    80005fca:	00003597          	auipc	a1,0x3
    80005fce:	88658593          	addi	a1,a1,-1914 # 80008850 <syscalls+0x3f0>
    80005fd2:	8526                	mv	a0,s1
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	26e080e7          	jalr	622(ra) # 80006242 <initlock>
  pr.locking = 1;
    80005fdc:	4785                	li	a5,1
    80005fde:	cc9c                	sw	a5,24(s1)
}
    80005fe0:	60e2                	ld	ra,24(sp)
    80005fe2:	6442                	ld	s0,16(sp)
    80005fe4:	64a2                	ld	s1,8(sp)
    80005fe6:	6105                	addi	sp,sp,32
    80005fe8:	8082                	ret

0000000080005fea <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fea:	1141                	addi	sp,sp,-16
    80005fec:	e406                	sd	ra,8(sp)
    80005fee:	e022                	sd	s0,0(sp)
    80005ff0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ff2:	100007b7          	lui	a5,0x10000
    80005ff6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ffa:	f8000713          	li	a4,-128
    80005ffe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006002:	470d                	li	a4,3
    80006004:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006008:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000600c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006010:	469d                	li	a3,7
    80006012:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006016:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000601a:	00003597          	auipc	a1,0x3
    8000601e:	85658593          	addi	a1,a1,-1962 # 80008870 <digits+0x18>
    80006022:	00020517          	auipc	a0,0x20
    80006026:	1e650513          	addi	a0,a0,486 # 80026208 <uart_tx_lock>
    8000602a:	00000097          	auipc	ra,0x0
    8000602e:	218080e7          	jalr	536(ra) # 80006242 <initlock>
}
    80006032:	60a2                	ld	ra,8(sp)
    80006034:	6402                	ld	s0,0(sp)
    80006036:	0141                	addi	sp,sp,16
    80006038:	8082                	ret

000000008000603a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000603a:	1101                	addi	sp,sp,-32
    8000603c:	ec06                	sd	ra,24(sp)
    8000603e:	e822                	sd	s0,16(sp)
    80006040:	e426                	sd	s1,8(sp)
    80006042:	1000                	addi	s0,sp,32
    80006044:	84aa                	mv	s1,a0
  push_off();
    80006046:	00000097          	auipc	ra,0x0
    8000604a:	240080e7          	jalr	576(ra) # 80006286 <push_off>

  if(panicked){
    8000604e:	00003797          	auipc	a5,0x3
    80006052:	fce7a783          	lw	a5,-50(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006056:	10000737          	lui	a4,0x10000
  if(panicked){
    8000605a:	c391                	beqz	a5,8000605e <uartputc_sync+0x24>
    for(;;)
    8000605c:	a001                	j	8000605c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000605e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006062:	0ff7f793          	andi	a5,a5,255
    80006066:	0207f793          	andi	a5,a5,32
    8000606a:	dbf5                	beqz	a5,8000605e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000606c:	0ff4f793          	andi	a5,s1,255
    80006070:	10000737          	lui	a4,0x10000
    80006074:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	2ae080e7          	jalr	686(ra) # 80006326 <pop_off>
}
    80006080:	60e2                	ld	ra,24(sp)
    80006082:	6442                	ld	s0,16(sp)
    80006084:	64a2                	ld	s1,8(sp)
    80006086:	6105                	addi	sp,sp,32
    80006088:	8082                	ret

000000008000608a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000608a:	00003717          	auipc	a4,0x3
    8000608e:	f9673703          	ld	a4,-106(a4) # 80009020 <uart_tx_r>
    80006092:	00003797          	auipc	a5,0x3
    80006096:	f967b783          	ld	a5,-106(a5) # 80009028 <uart_tx_w>
    8000609a:	06e78c63          	beq	a5,a4,80006112 <uartstart+0x88>
{
    8000609e:	7139                	addi	sp,sp,-64
    800060a0:	fc06                	sd	ra,56(sp)
    800060a2:	f822                	sd	s0,48(sp)
    800060a4:	f426                	sd	s1,40(sp)
    800060a6:	f04a                	sd	s2,32(sp)
    800060a8:	ec4e                	sd	s3,24(sp)
    800060aa:	e852                	sd	s4,16(sp)
    800060ac:	e456                	sd	s5,8(sp)
    800060ae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060b0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060b4:	00020a17          	auipc	s4,0x20
    800060b8:	154a0a13          	addi	s4,s4,340 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060bc:	00003497          	auipc	s1,0x3
    800060c0:	f6448493          	addi	s1,s1,-156 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060c4:	00003997          	auipc	s3,0x3
    800060c8:	f6498993          	addi	s3,s3,-156 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060cc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060d0:	0ff7f793          	andi	a5,a5,255
    800060d4:	0207f793          	andi	a5,a5,32
    800060d8:	c785                	beqz	a5,80006100 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060da:	01f77793          	andi	a5,a4,31
    800060de:	97d2                	add	a5,a5,s4
    800060e0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060e4:	0705                	addi	a4,a4,1
    800060e6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060e8:	8526                	mv	a0,s1
    800060ea:	ffffb097          	auipc	ra,0xffffb
    800060ee:	6f0080e7          	jalr	1776(ra) # 800017da <wakeup>
    
    WriteReg(THR, c);
    800060f2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060f6:	6098                	ld	a4,0(s1)
    800060f8:	0009b783          	ld	a5,0(s3)
    800060fc:	fce798e3          	bne	a5,a4,800060cc <uartstart+0x42>
  }
}
    80006100:	70e2                	ld	ra,56(sp)
    80006102:	7442                	ld	s0,48(sp)
    80006104:	74a2                	ld	s1,40(sp)
    80006106:	7902                	ld	s2,32(sp)
    80006108:	69e2                	ld	s3,24(sp)
    8000610a:	6a42                	ld	s4,16(sp)
    8000610c:	6aa2                	ld	s5,8(sp)
    8000610e:	6121                	addi	sp,sp,64
    80006110:	8082                	ret
    80006112:	8082                	ret

0000000080006114 <uartputc>:
{
    80006114:	7179                	addi	sp,sp,-48
    80006116:	f406                	sd	ra,40(sp)
    80006118:	f022                	sd	s0,32(sp)
    8000611a:	ec26                	sd	s1,24(sp)
    8000611c:	e84a                	sd	s2,16(sp)
    8000611e:	e44e                	sd	s3,8(sp)
    80006120:	e052                	sd	s4,0(sp)
    80006122:	1800                	addi	s0,sp,48
    80006124:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006126:	00020517          	auipc	a0,0x20
    8000612a:	0e250513          	addi	a0,a0,226 # 80026208 <uart_tx_lock>
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	1a4080e7          	jalr	420(ra) # 800062d2 <acquire>
  if(panicked){
    80006136:	00003797          	auipc	a5,0x3
    8000613a:	ee67a783          	lw	a5,-282(a5) # 8000901c <panicked>
    8000613e:	c391                	beqz	a5,80006142 <uartputc+0x2e>
    for(;;)
    80006140:	a001                	j	80006140 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006142:	00003797          	auipc	a5,0x3
    80006146:	ee67b783          	ld	a5,-282(a5) # 80009028 <uart_tx_w>
    8000614a:	00003717          	auipc	a4,0x3
    8000614e:	ed673703          	ld	a4,-298(a4) # 80009020 <uart_tx_r>
    80006152:	02070713          	addi	a4,a4,32
    80006156:	02f71b63          	bne	a4,a5,8000618c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000615a:	00020a17          	auipc	s4,0x20
    8000615e:	0aea0a13          	addi	s4,s4,174 # 80026208 <uart_tx_lock>
    80006162:	00003497          	auipc	s1,0x3
    80006166:	ebe48493          	addi	s1,s1,-322 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000616a:	00003917          	auipc	s2,0x3
    8000616e:	ebe90913          	addi	s2,s2,-322 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006172:	85d2                	mv	a1,s4
    80006174:	8526                	mv	a0,s1
    80006176:	ffffb097          	auipc	ra,0xffffb
    8000617a:	4d8080e7          	jalr	1240(ra) # 8000164e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000617e:	00093783          	ld	a5,0(s2)
    80006182:	6098                	ld	a4,0(s1)
    80006184:	02070713          	addi	a4,a4,32
    80006188:	fef705e3          	beq	a4,a5,80006172 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000618c:	00020497          	auipc	s1,0x20
    80006190:	07c48493          	addi	s1,s1,124 # 80026208 <uart_tx_lock>
    80006194:	01f7f713          	andi	a4,a5,31
    80006198:	9726                	add	a4,a4,s1
    8000619a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000619e:	0785                	addi	a5,a5,1
    800061a0:	00003717          	auipc	a4,0x3
    800061a4:	e8f73423          	sd	a5,-376(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	ee2080e7          	jalr	-286(ra) # 8000608a <uartstart>
      release(&uart_tx_lock);
    800061b0:	8526                	mv	a0,s1
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	1d4080e7          	jalr	468(ra) # 80006386 <release>
}
    800061ba:	70a2                	ld	ra,40(sp)
    800061bc:	7402                	ld	s0,32(sp)
    800061be:	64e2                	ld	s1,24(sp)
    800061c0:	6942                	ld	s2,16(sp)
    800061c2:	69a2                	ld	s3,8(sp)
    800061c4:	6a02                	ld	s4,0(sp)
    800061c6:	6145                	addi	sp,sp,48
    800061c8:	8082                	ret

00000000800061ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061ca:	1141                	addi	sp,sp,-16
    800061cc:	e422                	sd	s0,8(sp)
    800061ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061d0:	100007b7          	lui	a5,0x10000
    800061d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061d8:	8b85                	andi	a5,a5,1
    800061da:	cb91                	beqz	a5,800061ee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061dc:	100007b7          	lui	a5,0x10000
    800061e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061e4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061e8:	6422                	ld	s0,8(sp)
    800061ea:	0141                	addi	sp,sp,16
    800061ec:	8082                	ret
    return -1;
    800061ee:	557d                	li	a0,-1
    800061f0:	bfe5                	j	800061e8 <uartgetc+0x1e>

00000000800061f2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061f2:	1101                	addi	sp,sp,-32
    800061f4:	ec06                	sd	ra,24(sp)
    800061f6:	e822                	sd	s0,16(sp)
    800061f8:	e426                	sd	s1,8(sp)
    800061fa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061fc:	54fd                	li	s1,-1
    int c = uartgetc();
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	fcc080e7          	jalr	-52(ra) # 800061ca <uartgetc>
    if(c == -1)
    80006206:	00950763          	beq	a0,s1,80006214 <uartintr+0x22>
      break;
    consoleintr(c);
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	8fe080e7          	jalr	-1794(ra) # 80005b08 <consoleintr>
  while(1){
    80006212:	b7f5                	j	800061fe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006214:	00020497          	auipc	s1,0x20
    80006218:	ff448493          	addi	s1,s1,-12 # 80026208 <uart_tx_lock>
    8000621c:	8526                	mv	a0,s1
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	0b4080e7          	jalr	180(ra) # 800062d2 <acquire>
  uartstart();
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	e64080e7          	jalr	-412(ra) # 8000608a <uartstart>
  release(&uart_tx_lock);
    8000622e:	8526                	mv	a0,s1
    80006230:	00000097          	auipc	ra,0x0
    80006234:	156080e7          	jalr	342(ra) # 80006386 <release>
}
    80006238:	60e2                	ld	ra,24(sp)
    8000623a:	6442                	ld	s0,16(sp)
    8000623c:	64a2                	ld	s1,8(sp)
    8000623e:	6105                	addi	sp,sp,32
    80006240:	8082                	ret

0000000080006242 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006242:	1141                	addi	sp,sp,-16
    80006244:	e422                	sd	s0,8(sp)
    80006246:	0800                	addi	s0,sp,16
  lk->name = name;
    80006248:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000624a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000624e:	00053823          	sd	zero,16(a0)
}
    80006252:	6422                	ld	s0,8(sp)
    80006254:	0141                	addi	sp,sp,16
    80006256:	8082                	ret

0000000080006258 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006258:	411c                	lw	a5,0(a0)
    8000625a:	e399                	bnez	a5,80006260 <holding+0x8>
    8000625c:	4501                	li	a0,0
  return r;
}
    8000625e:	8082                	ret
{
    80006260:	1101                	addi	sp,sp,-32
    80006262:	ec06                	sd	ra,24(sp)
    80006264:	e822                	sd	s0,16(sp)
    80006266:	e426                	sd	s1,8(sp)
    80006268:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000626a:	6904                	ld	s1,16(a0)
    8000626c:	ffffb097          	auipc	ra,0xffffb
    80006270:	d0a080e7          	jalr	-758(ra) # 80000f76 <mycpu>
    80006274:	40a48533          	sub	a0,s1,a0
    80006278:	00153513          	seqz	a0,a0
}
    8000627c:	60e2                	ld	ra,24(sp)
    8000627e:	6442                	ld	s0,16(sp)
    80006280:	64a2                	ld	s1,8(sp)
    80006282:	6105                	addi	sp,sp,32
    80006284:	8082                	ret

0000000080006286 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006286:	1101                	addi	sp,sp,-32
    80006288:	ec06                	sd	ra,24(sp)
    8000628a:	e822                	sd	s0,16(sp)
    8000628c:	e426                	sd	s1,8(sp)
    8000628e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    80006290:	100024f3          	csrr	s1,sstatus
    80006294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006298:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    8000629a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	cd8080e7          	jalr	-808(ra) # 80000f76 <mycpu>
    800062a6:	5d3c                	lw	a5,120(a0)
    800062a8:	cf89                	beqz	a5,800062c2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062aa:	ffffb097          	auipc	ra,0xffffb
    800062ae:	ccc080e7          	jalr	-820(ra) # 80000f76 <mycpu>
    800062b2:	5d3c                	lw	a5,120(a0)
    800062b4:	2785                	addiw	a5,a5,1
    800062b6:	dd3c                	sw	a5,120(a0)
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	addi	sp,sp,32
    800062c0:	8082                	ret
    mycpu()->intena = old;
    800062c2:	ffffb097          	auipc	ra,0xffffb
    800062c6:	cb4080e7          	jalr	-844(ra) # 80000f76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062ca:	8085                	srli	s1,s1,0x1
    800062cc:	8885                	andi	s1,s1,1
    800062ce:	dd64                	sw	s1,124(a0)
    800062d0:	bfe9                	j	800062aa <push_off+0x24>

00000000800062d2 <acquire>:
{
    800062d2:	1101                	addi	sp,sp,-32
    800062d4:	ec06                	sd	ra,24(sp)
    800062d6:	e822                	sd	s0,16(sp)
    800062d8:	e426                	sd	s1,8(sp)
    800062da:	1000                	addi	s0,sp,32
    800062dc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	fa8080e7          	jalr	-88(ra) # 80006286 <push_off>
  if(holding(lk))
    800062e6:	8526                	mv	a0,s1
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	f70080e7          	jalr	-144(ra) # 80006258 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f0:	4705                	li	a4,1
  if(holding(lk))
    800062f2:	e115                	bnez	a0,80006316 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f4:	87ba                	mv	a5,a4
    800062f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062fa:	2781                	sext.w	a5,a5
    800062fc:	ffe5                	bnez	a5,800062f4 <acquire+0x22>
  __sync_synchronize();
    800062fe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	c74080e7          	jalr	-908(ra) # 80000f76 <mycpu>
    8000630a:	e888                	sd	a0,16(s1)
}
    8000630c:	60e2                	ld	ra,24(sp)
    8000630e:	6442                	ld	s0,16(sp)
    80006310:	64a2                	ld	s1,8(sp)
    80006312:	6105                	addi	sp,sp,32
    80006314:	8082                	ret
    panic("acquire");
    80006316:	00002517          	auipc	a0,0x2
    8000631a:	56250513          	addi	a0,a0,1378 # 80008878 <digits+0x20>
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	a6a080e7          	jalr	-1430(ra) # 80005d88 <panic>

0000000080006326 <pop_off>:

void
pop_off(void)
{
    80006326:	1141                	addi	sp,sp,-16
    80006328:	e406                	sd	ra,8(sp)
    8000632a:	e022                	sd	s0,0(sp)
    8000632c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000632e:	ffffb097          	auipc	ra,0xffffb
    80006332:	c48080e7          	jalr	-952(ra) # 80000f76 <mycpu>
  asm volatile("csrr %0, sstatus"
    80006336:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000633a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000633c:	e78d                	bnez	a5,80006366 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000633e:	5d3c                	lw	a5,120(a0)
    80006340:	02f05b63          	blez	a5,80006376 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006344:	37fd                	addiw	a5,a5,-1
    80006346:	0007871b          	sext.w	a4,a5
    8000634a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000634c:	eb09                	bnez	a4,8000635e <pop_off+0x38>
    8000634e:	5d7c                	lw	a5,124(a0)
    80006350:	c799                	beqz	a5,8000635e <pop_off+0x38>
  asm volatile("csrr %0, sstatus"
    80006352:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006356:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    8000635a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000635e:	60a2                	ld	ra,8(sp)
    80006360:	6402                	ld	s0,0(sp)
    80006362:	0141                	addi	sp,sp,16
    80006364:	8082                	ret
    panic("pop_off - interruptible");
    80006366:	00002517          	auipc	a0,0x2
    8000636a:	51a50513          	addi	a0,a0,1306 # 80008880 <digits+0x28>
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	a1a080e7          	jalr	-1510(ra) # 80005d88 <panic>
    panic("pop_off");
    80006376:	00002517          	auipc	a0,0x2
    8000637a:	52250513          	addi	a0,a0,1314 # 80008898 <digits+0x40>
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	a0a080e7          	jalr	-1526(ra) # 80005d88 <panic>

0000000080006386 <release>:
{
    80006386:	1101                	addi	sp,sp,-32
    80006388:	ec06                	sd	ra,24(sp)
    8000638a:	e822                	sd	s0,16(sp)
    8000638c:	e426                	sd	s1,8(sp)
    8000638e:	1000                	addi	s0,sp,32
    80006390:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006392:	00000097          	auipc	ra,0x0
    80006396:	ec6080e7          	jalr	-314(ra) # 80006258 <holding>
    8000639a:	c115                	beqz	a0,800063be <release+0x38>
  lk->cpu = 0;
    8000639c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063a4:	0f50000f          	fence	iorw,ow
    800063a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	f7a080e7          	jalr	-134(ra) # 80006326 <pop_off>
}
    800063b4:	60e2                	ld	ra,24(sp)
    800063b6:	6442                	ld	s0,16(sp)
    800063b8:	64a2                	ld	s1,8(sp)
    800063ba:	6105                	addi	sp,sp,32
    800063bc:	8082                	ret
    panic("release");
    800063be:	00002517          	auipc	a0,0x2
    800063c2:	4e250513          	addi	a0,a0,1250 # 800088a0 <digits+0x48>
    800063c6:	00000097          	auipc	ra,0x0
    800063ca:	9c2080e7          	jalr	-1598(ra) # 80005d88 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
