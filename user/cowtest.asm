
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:

// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	c7250513          	addi	a0,a0,-910 # c80 <malloc+0xe8>
  16:	00001097          	auipc	ra,0x1
  1a:	ac4080e7          	jalr	-1340(ra) # ada <printf>

  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x5550764>
  26:	00000097          	auipc	ra,0x0
  2a:	7c4080e7          	jalr	1988(ra) # 7ea <sbrk>
  if (p == (char *)0xffffffffffffffffL)
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
  {
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for (char *q = p; q < p + sz; q += 4096)
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
  {
    *(int *)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	7a4080e7          	jalr	1956(ra) # 7e2 <getpid>
  46:	c088                	sw	a0,0(s1)
  for (char *q = p; q < p + sz; q += 4096)
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	70c080e7          	jalr	1804(ra) # 75a <fork>
  if (pid < 0)
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
  {
    printf("fork() failed\n");
    exit(-1);
  }

  if (pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	70c080e7          	jalr	1804(ra) # 76a <wait>

  if (sbrk(-sz) == (char *)0xffffffffffffffffL)
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5cbc>
  6e:	00000097          	auipc	ra,0x0
  72:	77c080e7          	jalr	1916(ra) # 7ea <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
  {
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	c5450513          	addi	a0,a0,-940 # cd0 <malloc+0x138>
  84:	00001097          	auipc	ra,0x1
  88:	a56080e7          	jalr	-1450(ra) # ada <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x5550764>
  a2:	00001517          	auipc	a0,0x1
  a6:	bee50513          	addi	a0,a0,-1042 # c90 <malloc+0xf8>
  aa:	00001097          	auipc	ra,0x1
  ae:	a30080e7          	jalr	-1488(ra) # ada <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	6ae080e7          	jalr	1710(ra) # 762 <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	bec50513          	addi	a0,a0,-1044 # ca8 <malloc+0x110>
  c4:	00001097          	auipc	ra,0x1
  c8:	a16080e7          	jalr	-1514(ra) # ada <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	694080e7          	jalr	1684(ra) # 762 <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	68c080e7          	jalr	1676(ra) # 762 <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x5550764>
  e6:	00001517          	auipc	a0,0x1
  ea:	bd250513          	addi	a0,a0,-1070 # cb8 <malloc+0x120>
  ee:	00001097          	auipc	ra,0x1
  f2:	9ec080e7          	jalr	-1556(ra) # ada <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	66a080e7          	jalr	1642(ra) # 762 <exit>

0000000000000100 <threetest>:
// three processes all write COW memory.
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	bc850513          	addi	a0,a0,-1080 # cd8 <malloc+0x140>
 118:	00001097          	auipc	ra,0x1
 11c:	9c2080e7          	jalr	-1598(ra) # ada <printf>

  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	6c6080e7          	jalr	1734(ra) # 7ea <sbrk>
  if (p == (char *)0xffffffffffffffffL)
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
  {
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	626080e7          	jalr	1574(ra) # 75a <fork>
  if (pid1 < 0)
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
  {
    printf("fork failed\n");
    exit(-1);
  }
  if (pid1 == 0)
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int *)q = 9999;
    }
    exit(0);
  }

  for (char *q = p; q < p + sz; q += 4096)
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
  {
    *(int *)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	696080e7          	jalr	1686(ra) # 7e2 <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x5551210>
  for (char *q = p; q < p + sz; q += 4096)
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	60a080e7          	jalr	1546(ra) # 76a <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	688080e7          	jalr	1672(ra) # 7f2 <sleep>

  for (char *q = p; q < p + sz; q += 4096)
 172:	6a05                	lui	s4,0x1
  {
    if (*(int *)q != getpid())
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	66a080e7          	jalr	1642(ra) # 7e2 <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for (char *q = p; q < p + sz; q += 4096)
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if (sbrk(-sz) == (char *)0xffffffffffffffffL)
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	65c080e7          	jalr	1628(ra) # 7ea <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
  {
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b3450513          	addi	a0,a0,-1228 # cd0 <malloc+0x138>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	936080e7          	jalr	-1738(ra) # ada <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	ad050513          	addi	a0,a0,-1328 # c90 <malloc+0xf8>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	912080e7          	jalr	-1774(ra) # ada <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	590080e7          	jalr	1424(ra) # 762 <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	b0650513          	addi	a0,a0,-1274 # ce0 <malloc+0x148>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	8f8080e7          	jalr	-1800(ra) # ada <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	576080e7          	jalr	1398(ra) # 762 <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	566080e7          	jalr	1382(ra) # 75a <fork>
    if (pid2 < 0)
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if (pid2 == 0)
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int *)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	5d6080e7          	jalr	1494(ra) # 7e2 <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 21e:	6a05                	lui	s4,0x1
        if (*(int *)q != getpid())
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	5be080e7          	jalr	1470(ra) # 7e2 <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096)
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	52a080e7          	jalr	1322(ra) # 762 <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	ab050513          	addi	a0,a0,-1360 # cf0 <malloc+0x158>
 248:	00001097          	auipc	ra,0x1
 24c:	892080e7          	jalr	-1902(ra) # ada <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	510080e7          	jalr	1296(ra) # 762 <exit>
    for (char *q = p; q < p + (sz / 2); q += 4096)
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int *)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f7879b          	addiw	a5,a5,1807
    for (char *q = p; q < p + (sz / 2); q += 4096)
 266:	6685                	lui	a3,0x1
      *(int *)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for (char *q = p; q < p + (sz / 2); q += 4096)
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	4f0080e7          	jalr	1264(ra) # 762 <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a8650513          	addi	a0,a0,-1402 # d00 <malloc+0x168>
 282:	00001097          	auipc	ra,0x1
 286:	858080e7          	jalr	-1960(ra) # ada <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	4d6080e7          	jalr	1238(ra) # 762 <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	a6c50513          	addi	a0,a0,-1428 # d00 <malloc+0x168>
 29c:	00001097          	auipc	ra,0x1
 2a0:	83e080e7          	jalr	-1986(ra) # ada <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	4bc080e7          	jalr	1212(ra) # 762 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	a0650513          	addi	a0,a0,-1530 # cb8 <malloc+0x120>
 2ba:	00001097          	auipc	ra,0x1
 2be:	820080e7          	jalr	-2016(ra) # ada <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	49e080e7          	jalr	1182(ra) # 762 <exit>

00000000000002cc <filetest>:
char buf[4096];
char junk3[4096];

// test whether copyout() simulates COW faults.
void filetest()
{
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	addi	s0,sp,48
  printf("file: ");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	a3850513          	addi	a0,a0,-1480 # d10 <malloc+0x178>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	7fa080e7          	jalr	2042(ra) # ada <printf>

  buf[0] = 99;
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	aef70a23          	sb	a5,-1292(a4) # 1de0 <buf>

  for (int i = 0; i < 4; i++)
 2f4:	fc042c23          	sw	zero,-40(s0)
  {
    if (pipe(fds) != 0)
 2f8:	00001497          	auipc	s1,0x1
 2fc:	ad848493          	addi	s1,s1,-1320 # dd0 <fds>
  for (int i = 0; i < 4; i++)
 300:	490d                	li	s2,3
    if (pipe(fds) != 0)
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	46e080e7          	jalr	1134(ra) # 772 <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
    {
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 30e:	00000097          	auipc	ra,0x0
 312:	44c080e7          	jalr	1100(ra) # 75a <fork>
    if (pid < 0)
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
    {
      printf("fork failed\n");
      exit(-1);
    }
    if (pid == 0)
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if (write(fds[1], &i, sizeof(i)) != sizeof(i))
 31c:	4611                	li	a2,4
 31e:	fd840593          	addi	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	45e080e7          	jalr	1118(ra) # 782 <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
  for (int i = 0; i < 4; i++)
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addiw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
  for (int i = 0; i < 4; i++)
  {
    wait(&xstatus);
 34a:	fdc40513          	addi	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	41c080e7          	jalr	1052(ra) # 76a <wait>
    if (xstatus != 0)
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
  for (int i = 0; i < 4; i++)
 35e:	34fd                	addiw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
    {
      exit(1);
    }
  }

  if (buf[0] != 99)
 362:	00002717          	auipc	a4,0x2
 366:	a7e74703          	lbu	a4,-1410(a4) # 1de0 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
  {
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 372:	00001517          	auipc	a0,0x1
 376:	95e50513          	addi	a0,a0,-1698 # cd0 <malloc+0x138>
 37a:	00000097          	auipc	ra,0x0
 37e:	760080e7          	jalr	1888(ra) # ada <printf>
}
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	addi	sp,sp,48
 38c:	8082                	ret
      printf("pipe() failed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	98a50513          	addi	a0,a0,-1654 # d18 <malloc+0x180>
 396:	00000097          	auipc	ra,0x0
 39a:	744080e7          	jalr	1860(ra) # ada <printf>
      exit(-1);
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	3c2080e7          	jalr	962(ra) # 762 <exit>
      printf("fork failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	93850513          	addi	a0,a0,-1736 # ce0 <malloc+0x148>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	72a080e7          	jalr	1834(ra) # ada <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	3a8080e7          	jalr	936(ra) # 762 <exit>
      sleep(1);
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	42e080e7          	jalr	1070(ra) # 7f2 <sleep>
      if (read(fds[0], buf, sizeof(i)) != sizeof(i))
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	a1258593          	addi	a1,a1,-1518 # 1de0 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	9fa52503          	lw	a0,-1542(a0) # dd0 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	39c080e7          	jalr	924(ra) # 77a <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
      sleep(1);
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	404080e7          	jalr	1028(ra) # 7f2 <sleep>
      if (j != i)
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	9e67a783          	lw	a5,-1562(a5) # 1de0 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
        printf("error: read the wrong value\n");
 406:	00001517          	auipc	a0,0x1
 40a:	93a50513          	addi	a0,a0,-1734 # d40 <malloc+0x1a8>
 40e:	00000097          	auipc	ra,0x0
 412:	6cc080e7          	jalr	1740(ra) # ada <printf>
        exit(1);
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	34a080e7          	jalr	842(ra) # 762 <exit>
        printf("error: read failed\n");
 420:	00001517          	auipc	a0,0x1
 424:	90850513          	addi	a0,a0,-1784 # d28 <malloc+0x190>
 428:	00000097          	auipc	ra,0x0
 42c:	6b2080e7          	jalr	1714(ra) # ada <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	330080e7          	jalr	816(ra) # 762 <exit>
      exit(0);
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	326080e7          	jalr	806(ra) # 762 <exit>
      printf("error: write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	91c50513          	addi	a0,a0,-1764 # d60 <malloc+0x1c8>
 44c:	00000097          	auipc	ra,0x0
 450:	68e080e7          	jalr	1678(ra) # ada <printf>
      exit(-1);
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	30c080e7          	jalr	780(ra) # 762 <exit>
      exit(1);
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	302080e7          	jalr	770(ra) # 762 <exit>
    printf("error: child overwrote parent\n");
 468:	00001517          	auipc	a0,0x1
 46c:	91050513          	addi	a0,a0,-1776 # d78 <malloc+0x1e0>
 470:	00000097          	auipc	ra,0x0
 474:	66a080e7          	jalr	1642(ra) # ada <printf>
    exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	2e8080e7          	jalr	744(ra) # 762 <exit>

0000000000000482 <main>:

int main(int argc, char *argv[])
{
 482:	1141                	addi	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	addi	s0,sp,16
  simpletest();
 48a:	00000097          	auipc	ra,0x0
 48e:	b76080e7          	jalr	-1162(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 492:	00000097          	auipc	ra,0x0
 496:	b6e080e7          	jalr	-1170(ra) # 0 <simpletest>
  simpletest();
 49a:	00000097          	auipc	ra,0x0
 49e:	b66080e7          	jalr	-1178(ra) # 0 <simpletest>
  simpletest();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	b5e080e7          	jalr	-1186(ra) # 0 <simpletest>
  simpletest();
 4aa:	00000097          	auipc	ra,0x0
 4ae:	b56080e7          	jalr	-1194(ra) # 0 <simpletest>

  threetest();
 4b2:	00000097          	auipc	ra,0x0
 4b6:	c4e080e7          	jalr	-946(ra) # 100 <threetest>
  threetest();
 4ba:	00000097          	auipc	ra,0x0
 4be:	c46080e7          	jalr	-954(ra) # 100 <threetest>
  threetest();
 4c2:	00000097          	auipc	ra,0x0
 4c6:	c3e080e7          	jalr	-962(ra) # 100 <threetest>

  filetest();
 4ca:	00000097          	auipc	ra,0x0
 4ce:	e02080e7          	jalr	-510(ra) # 2cc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4d2:	00001517          	auipc	a0,0x1
 4d6:	8c650513          	addi	a0,a0,-1850 # d98 <malloc+0x200>
 4da:	00000097          	auipc	ra,0x0
 4de:	600080e7          	jalr	1536(ra) # ada <printf>

  exit(0);
 4e2:	4501                	li	a0,0
 4e4:	00000097          	auipc	ra,0x0
 4e8:	27e080e7          	jalr	638(ra) # 762 <exit>

00000000000004ec <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e422                	sd	s0,8(sp)
 4f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4f2:	87aa                	mv	a5,a0
 4f4:	0585                	addi	a1,a1,1
 4f6:	0785                	addi	a5,a5,1
 4f8:	fff5c703          	lbu	a4,-1(a1)
 4fc:	fee78fa3          	sb	a4,-1(a5)
 500:	fb75                	bnez	a4,4f4 <strcpy+0x8>
    ;
  return os;
}
 502:	6422                	ld	s0,8(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 50e:	00054783          	lbu	a5,0(a0)
 512:	cb91                	beqz	a5,526 <strcmp+0x1e>
 514:	0005c703          	lbu	a4,0(a1)
 518:	00f71763          	bne	a4,a5,526 <strcmp+0x1e>
    p++, q++;
 51c:	0505                	addi	a0,a0,1
 51e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 520:	00054783          	lbu	a5,0(a0)
 524:	fbe5                	bnez	a5,514 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 526:	0005c503          	lbu	a0,0(a1)
}
 52a:	40a7853b          	subw	a0,a5,a0
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret

0000000000000534 <strlen>:

uint
strlen(const char *s)
{
 534:	1141                	addi	sp,sp,-16
 536:	e422                	sd	s0,8(sp)
 538:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 53a:	00054783          	lbu	a5,0(a0)
 53e:	cf91                	beqz	a5,55a <strlen+0x26>
 540:	0505                	addi	a0,a0,1
 542:	87aa                	mv	a5,a0
 544:	4685                	li	a3,1
 546:	9e89                	subw	a3,a3,a0
 548:	00f6853b          	addw	a0,a3,a5
 54c:	0785                	addi	a5,a5,1
 54e:	fff7c703          	lbu	a4,-1(a5)
 552:	fb7d                	bnez	a4,548 <strlen+0x14>
    ;
  return n;
}
 554:	6422                	ld	s0,8(sp)
 556:	0141                	addi	sp,sp,16
 558:	8082                	ret
  for(n = 0; s[n]; n++)
 55a:	4501                	li	a0,0
 55c:	bfe5                	j	554 <strlen+0x20>

000000000000055e <memset>:

void*
memset(void *dst, int c, uint n)
{
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 564:	ce09                	beqz	a2,57e <memset+0x20>
 566:	87aa                	mv	a5,a0
 568:	fff6071b          	addiw	a4,a2,-1
 56c:	1702                	slli	a4,a4,0x20
 56e:	9301                	srli	a4,a4,0x20
 570:	0705                	addi	a4,a4,1
 572:	972a                	add	a4,a4,a0
    cdst[i] = c;
 574:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 578:	0785                	addi	a5,a5,1
 57a:	fee79de3          	bne	a5,a4,574 <memset+0x16>
  }
  return dst;
}
 57e:	6422                	ld	s0,8(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret

0000000000000584 <strchr>:

char*
strchr(const char *s, char c)
{
 584:	1141                	addi	sp,sp,-16
 586:	e422                	sd	s0,8(sp)
 588:	0800                	addi	s0,sp,16
  for(; *s; s++)
 58a:	00054783          	lbu	a5,0(a0)
 58e:	cb99                	beqz	a5,5a4 <strchr+0x20>
    if(*s == c)
 590:	00f58763          	beq	a1,a5,59e <strchr+0x1a>
  for(; *s; s++)
 594:	0505                	addi	a0,a0,1
 596:	00054783          	lbu	a5,0(a0)
 59a:	fbfd                	bnez	a5,590 <strchr+0xc>
      return (char*)s;
  return 0;
 59c:	4501                	li	a0,0
}
 59e:	6422                	ld	s0,8(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret
  return 0;
 5a4:	4501                	li	a0,0
 5a6:	bfe5                	j	59e <strchr+0x1a>

00000000000005a8 <gets>:

char*
gets(char *buf, int max)
{
 5a8:	711d                	addi	sp,sp,-96
 5aa:	ec86                	sd	ra,88(sp)
 5ac:	e8a2                	sd	s0,80(sp)
 5ae:	e4a6                	sd	s1,72(sp)
 5b0:	e0ca                	sd	s2,64(sp)
 5b2:	fc4e                	sd	s3,56(sp)
 5b4:	f852                	sd	s4,48(sp)
 5b6:	f456                	sd	s5,40(sp)
 5b8:	f05a                	sd	s6,32(sp)
 5ba:	ec5e                	sd	s7,24(sp)
 5bc:	1080                	addi	s0,sp,96
 5be:	8baa                	mv	s7,a0
 5c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c2:	892a                	mv	s2,a0
 5c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5c6:	4aa9                	li	s5,10
 5c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5ca:	89a6                	mv	s3,s1
 5cc:	2485                	addiw	s1,s1,1
 5ce:	0344d863          	bge	s1,s4,5fe <gets+0x56>
    cc = read(0, &c, 1);
 5d2:	4605                	li	a2,1
 5d4:	faf40593          	addi	a1,s0,-81
 5d8:	4501                	li	a0,0
 5da:	00000097          	auipc	ra,0x0
 5de:	1a0080e7          	jalr	416(ra) # 77a <read>
    if(cc < 1)
 5e2:	00a05e63          	blez	a0,5fe <gets+0x56>
    buf[i++] = c;
 5e6:	faf44783          	lbu	a5,-81(s0)
 5ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5ee:	01578763          	beq	a5,s5,5fc <gets+0x54>
 5f2:	0905                	addi	s2,s2,1
 5f4:	fd679be3          	bne	a5,s6,5ca <gets+0x22>
  for(i=0; i+1 < max; ){
 5f8:	89a6                	mv	s3,s1
 5fa:	a011                	j	5fe <gets+0x56>
 5fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5fe:	99de                	add	s3,s3,s7
 600:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x1995210>
  return buf;
}
 604:	855e                	mv	a0,s7
 606:	60e6                	ld	ra,88(sp)
 608:	6446                	ld	s0,80(sp)
 60a:	64a6                	ld	s1,72(sp)
 60c:	6906                	ld	s2,64(sp)
 60e:	79e2                	ld	s3,56(sp)
 610:	7a42                	ld	s4,48(sp)
 612:	7aa2                	ld	s5,40(sp)
 614:	7b02                	ld	s6,32(sp)
 616:	6be2                	ld	s7,24(sp)
 618:	6125                	addi	sp,sp,96
 61a:	8082                	ret

000000000000061c <stat>:

int
stat(const char *n, struct stat *st)
{
 61c:	1101                	addi	sp,sp,-32
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	e426                	sd	s1,8(sp)
 624:	e04a                	sd	s2,0(sp)
 626:	1000                	addi	s0,sp,32
 628:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 62a:	4581                	li	a1,0
 62c:	00000097          	auipc	ra,0x0
 630:	176080e7          	jalr	374(ra) # 7a2 <open>
  if(fd < 0)
 634:	02054563          	bltz	a0,65e <stat+0x42>
 638:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 63a:	85ca                	mv	a1,s2
 63c:	00000097          	auipc	ra,0x0
 640:	17e080e7          	jalr	382(ra) # 7ba <fstat>
 644:	892a                	mv	s2,a0
  close(fd);
 646:	8526                	mv	a0,s1
 648:	00000097          	auipc	ra,0x0
 64c:	142080e7          	jalr	322(ra) # 78a <close>
  return r;
}
 650:	854a                	mv	a0,s2
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	64a2                	ld	s1,8(sp)
 658:	6902                	ld	s2,0(sp)
 65a:	6105                	addi	sp,sp,32
 65c:	8082                	ret
    return -1;
 65e:	597d                	li	s2,-1
 660:	bfc5                	j	650 <stat+0x34>

0000000000000662 <atoi>:

int
atoi(const char *s)
{
 662:	1141                	addi	sp,sp,-16
 664:	e422                	sd	s0,8(sp)
 666:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 668:	00054603          	lbu	a2,0(a0)
 66c:	fd06079b          	addiw	a5,a2,-48
 670:	0ff7f793          	andi	a5,a5,255
 674:	4725                	li	a4,9
 676:	02f76963          	bltu	a4,a5,6a8 <atoi+0x46>
 67a:	86aa                	mv	a3,a0
  n = 0;
 67c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 67e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 680:	0685                	addi	a3,a3,1
 682:	0025179b          	slliw	a5,a0,0x2
 686:	9fa9                	addw	a5,a5,a0
 688:	0017979b          	slliw	a5,a5,0x1
 68c:	9fb1                	addw	a5,a5,a2
 68e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 692:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x220>
 696:	fd06071b          	addiw	a4,a2,-48
 69a:	0ff77713          	andi	a4,a4,255
 69e:	fee5f1e3          	bgeu	a1,a4,680 <atoi+0x1e>
  return n;
}
 6a2:	6422                	ld	s0,8(sp)
 6a4:	0141                	addi	sp,sp,16
 6a6:	8082                	ret
  n = 0;
 6a8:	4501                	li	a0,0
 6aa:	bfe5                	j	6a2 <atoi+0x40>

00000000000006ac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6ac:	1141                	addi	sp,sp,-16
 6ae:	e422                	sd	s0,8(sp)
 6b0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6b2:	02b57663          	bgeu	a0,a1,6de <memmove+0x32>
    while(n-- > 0)
 6b6:	02c05163          	blez	a2,6d8 <memmove+0x2c>
 6ba:	fff6079b          	addiw	a5,a2,-1
 6be:	1782                	slli	a5,a5,0x20
 6c0:	9381                	srli	a5,a5,0x20
 6c2:	0785                	addi	a5,a5,1
 6c4:	97aa                	add	a5,a5,a0
  dst = vdst;
 6c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 6c8:	0585                	addi	a1,a1,1
 6ca:	0705                	addi	a4,a4,1
 6cc:	fff5c683          	lbu	a3,-1(a1)
 6d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6d4:	fee79ae3          	bne	a5,a4,6c8 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	addi	sp,sp,16
 6dc:	8082                	ret
    dst += n;
 6de:	00c50733          	add	a4,a0,a2
    src += n;
 6e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6e4:	fec05ae3          	blez	a2,6d8 <memmove+0x2c>
 6e8:	fff6079b          	addiw	a5,a2,-1
 6ec:	1782                	slli	a5,a5,0x20
 6ee:	9381                	srli	a5,a5,0x20
 6f0:	fff7c793          	not	a5,a5
 6f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6f6:	15fd                	addi	a1,a1,-1
 6f8:	177d                	addi	a4,a4,-1
 6fa:	0005c683          	lbu	a3,0(a1)
 6fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 702:	fee79ae3          	bne	a5,a4,6f6 <memmove+0x4a>
 706:	bfc9                	j	6d8 <memmove+0x2c>

0000000000000708 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 708:	1141                	addi	sp,sp,-16
 70a:	e422                	sd	s0,8(sp)
 70c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 70e:	ca05                	beqz	a2,73e <memcmp+0x36>
 710:	fff6069b          	addiw	a3,a2,-1
 714:	1682                	slli	a3,a3,0x20
 716:	9281                	srli	a3,a3,0x20
 718:	0685                	addi	a3,a3,1
 71a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 71c:	00054783          	lbu	a5,0(a0)
 720:	0005c703          	lbu	a4,0(a1)
 724:	00e79863          	bne	a5,a4,734 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 728:	0505                	addi	a0,a0,1
    p2++;
 72a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 72c:	fed518e3          	bne	a0,a3,71c <memcmp+0x14>
  }
  return 0;
 730:	4501                	li	a0,0
 732:	a019                	j	738 <memcmp+0x30>
      return *p1 - *p2;
 734:	40e7853b          	subw	a0,a5,a4
}
 738:	6422                	ld	s0,8(sp)
 73a:	0141                	addi	sp,sp,16
 73c:	8082                	ret
  return 0;
 73e:	4501                	li	a0,0
 740:	bfe5                	j	738 <memcmp+0x30>

0000000000000742 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 742:	1141                	addi	sp,sp,-16
 744:	e406                	sd	ra,8(sp)
 746:	e022                	sd	s0,0(sp)
 748:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 74a:	00000097          	auipc	ra,0x0
 74e:	f62080e7          	jalr	-158(ra) # 6ac <memmove>
}
 752:	60a2                	ld	ra,8(sp)
 754:	6402                	ld	s0,0(sp)
 756:	0141                	addi	sp,sp,16
 758:	8082                	ret

000000000000075a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 75a:	4885                	li	a7,1
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <exit>:
.global exit
exit:
 li a7, SYS_exit
 762:	4889                	li	a7,2
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <wait>:
.global wait
wait:
 li a7, SYS_wait
 76a:	488d                	li	a7,3
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 772:	4891                	li	a7,4
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <read>:
.global read
read:
 li a7, SYS_read
 77a:	4895                	li	a7,5
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <write>:
.global write
write:
 li a7, SYS_write
 782:	48c1                	li	a7,16
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <close>:
.global close
close:
 li a7, SYS_close
 78a:	48d5                	li	a7,21
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <kill>:
.global kill
kill:
 li a7, SYS_kill
 792:	4899                	li	a7,6
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <exec>:
.global exec
exec:
 li a7, SYS_exec
 79a:	489d                	li	a7,7
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <open>:
.global open
open:
 li a7, SYS_open
 7a2:	48bd                	li	a7,15
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7aa:	48c5                	li	a7,17
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7b2:	48c9                	li	a7,18
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7ba:	48a1                	li	a7,8
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <link>:
.global link
link:
 li a7, SYS_link
 7c2:	48cd                	li	a7,19
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7ca:	48d1                	li	a7,20
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7d2:	48a5                	li	a7,9
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <dup>:
.global dup
dup:
 li a7, SYS_dup
 7da:	48a9                	li	a7,10
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7e2:	48ad                	li	a7,11
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7ea:	48b1                	li	a7,12
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7f2:	48b5                	li	a7,13
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7fa:	48b9                	li	a7,14
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 802:	1101                	addi	sp,sp,-32
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 80e:	4605                	li	a2,1
 810:	fef40593          	addi	a1,s0,-17
 814:	00000097          	auipc	ra,0x0
 818:	f6e080e7          	jalr	-146(ra) # 782 <write>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6105                	addi	sp,sp,32
 822:	8082                	ret

0000000000000824 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 824:	7139                	addi	sp,sp,-64
 826:	fc06                	sd	ra,56(sp)
 828:	f822                	sd	s0,48(sp)
 82a:	f426                	sd	s1,40(sp)
 82c:	f04a                	sd	s2,32(sp)
 82e:	ec4e                	sd	s3,24(sp)
 830:	0080                	addi	s0,sp,64
 832:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 834:	c299                	beqz	a3,83a <printint+0x16>
 836:	0805c863          	bltz	a1,8c6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 83a:	2581                	sext.w	a1,a1
  neg = 0;
 83c:	4881                	li	a7,0
 83e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 842:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 844:	2601                	sext.w	a2,a2
 846:	00000517          	auipc	a0,0x0
 84a:	57250513          	addi	a0,a0,1394 # db8 <digits>
 84e:	883a                	mv	a6,a4
 850:	2705                	addiw	a4,a4,1
 852:	02c5f7bb          	remuw	a5,a1,a2
 856:	1782                	slli	a5,a5,0x20
 858:	9381                	srli	a5,a5,0x20
 85a:	97aa                	add	a5,a5,a0
 85c:	0007c783          	lbu	a5,0(a5)
 860:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 864:	0005879b          	sext.w	a5,a1
 868:	02c5d5bb          	divuw	a1,a1,a2
 86c:	0685                	addi	a3,a3,1
 86e:	fec7f0e3          	bgeu	a5,a2,84e <printint+0x2a>
  if(neg)
 872:	00088b63          	beqz	a7,888 <printint+0x64>
    buf[i++] = '-';
 876:	fd040793          	addi	a5,s0,-48
 87a:	973e                	add	a4,a4,a5
 87c:	02d00793          	li	a5,45
 880:	fef70823          	sb	a5,-16(a4)
 884:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 888:	02e05863          	blez	a4,8b8 <printint+0x94>
 88c:	fc040793          	addi	a5,s0,-64
 890:	00e78933          	add	s2,a5,a4
 894:	fff78993          	addi	s3,a5,-1
 898:	99ba                	add	s3,s3,a4
 89a:	377d                	addiw	a4,a4,-1
 89c:	1702                	slli	a4,a4,0x20
 89e:	9301                	srli	a4,a4,0x20
 8a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8a4:	fff94583          	lbu	a1,-1(s2)
 8a8:	8526                	mv	a0,s1
 8aa:	00000097          	auipc	ra,0x0
 8ae:	f58080e7          	jalr	-168(ra) # 802 <putc>
  while(--i >= 0)
 8b2:	197d                	addi	s2,s2,-1
 8b4:	ff3918e3          	bne	s2,s3,8a4 <printint+0x80>
}
 8b8:	70e2                	ld	ra,56(sp)
 8ba:	7442                	ld	s0,48(sp)
 8bc:	74a2                	ld	s1,40(sp)
 8be:	7902                	ld	s2,32(sp)
 8c0:	69e2                	ld	s3,24(sp)
 8c2:	6121                	addi	sp,sp,64
 8c4:	8082                	ret
    x = -xx;
 8c6:	40b005bb          	negw	a1,a1
    neg = 1;
 8ca:	4885                	li	a7,1
    x = -xx;
 8cc:	bf8d                	j	83e <printint+0x1a>

00000000000008ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8ce:	7119                	addi	sp,sp,-128
 8d0:	fc86                	sd	ra,120(sp)
 8d2:	f8a2                	sd	s0,112(sp)
 8d4:	f4a6                	sd	s1,104(sp)
 8d6:	f0ca                	sd	s2,96(sp)
 8d8:	ecce                	sd	s3,88(sp)
 8da:	e8d2                	sd	s4,80(sp)
 8dc:	e4d6                	sd	s5,72(sp)
 8de:	e0da                	sd	s6,64(sp)
 8e0:	fc5e                	sd	s7,56(sp)
 8e2:	f862                	sd	s8,48(sp)
 8e4:	f466                	sd	s9,40(sp)
 8e6:	f06a                	sd	s10,32(sp)
 8e8:	ec6e                	sd	s11,24(sp)
 8ea:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8ec:	0005c903          	lbu	s2,0(a1)
 8f0:	18090f63          	beqz	s2,a8e <vprintf+0x1c0>
 8f4:	8aaa                	mv	s5,a0
 8f6:	8b32                	mv	s6,a2
 8f8:	00158493          	addi	s1,a1,1
  state = 0;
 8fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8fe:	02500a13          	li	s4,37
      if(c == 'd'){
 902:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 906:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 90a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 90e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 912:	00000b97          	auipc	s7,0x0
 916:	4a6b8b93          	addi	s7,s7,1190 # db8 <digits>
 91a:	a839                	j	938 <vprintf+0x6a>
        putc(fd, c);
 91c:	85ca                	mv	a1,s2
 91e:	8556                	mv	a0,s5
 920:	00000097          	auipc	ra,0x0
 924:	ee2080e7          	jalr	-286(ra) # 802 <putc>
 928:	a019                	j	92e <vprintf+0x60>
    } else if(state == '%'){
 92a:	01498f63          	beq	s3,s4,948 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 92e:	0485                	addi	s1,s1,1
 930:	fff4c903          	lbu	s2,-1(s1)
 934:	14090d63          	beqz	s2,a8e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 938:	0009079b          	sext.w	a5,s2
    if(state == 0){
 93c:	fe0997e3          	bnez	s3,92a <vprintf+0x5c>
      if(c == '%'){
 940:	fd479ee3          	bne	a5,s4,91c <vprintf+0x4e>
        state = '%';
 944:	89be                	mv	s3,a5
 946:	b7e5                	j	92e <vprintf+0x60>
      if(c == 'd'){
 948:	05878063          	beq	a5,s8,988 <vprintf+0xba>
      } else if(c == 'l') {
 94c:	05978c63          	beq	a5,s9,9a4 <vprintf+0xd6>
      } else if(c == 'x') {
 950:	07a78863          	beq	a5,s10,9c0 <vprintf+0xf2>
      } else if(c == 'p') {
 954:	09b78463          	beq	a5,s11,9dc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 958:	07300713          	li	a4,115
 95c:	0ce78663          	beq	a5,a4,a28 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 960:	06300713          	li	a4,99
 964:	0ee78e63          	beq	a5,a4,a60 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 968:	11478863          	beq	a5,s4,a78 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 96c:	85d2                	mv	a1,s4
 96e:	8556                	mv	a0,s5
 970:	00000097          	auipc	ra,0x0
 974:	e92080e7          	jalr	-366(ra) # 802 <putc>
        putc(fd, c);
 978:	85ca                	mv	a1,s2
 97a:	8556                	mv	a0,s5
 97c:	00000097          	auipc	ra,0x0
 980:	e86080e7          	jalr	-378(ra) # 802 <putc>
      }
      state = 0;
 984:	4981                	li	s3,0
 986:	b765                	j	92e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 988:	008b0913          	addi	s2,s6,8
 98c:	4685                	li	a3,1
 98e:	4629                	li	a2,10
 990:	000b2583          	lw	a1,0(s6)
 994:	8556                	mv	a0,s5
 996:	00000097          	auipc	ra,0x0
 99a:	e8e080e7          	jalr	-370(ra) # 824 <printint>
 99e:	8b4a                	mv	s6,s2
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	b771                	j	92e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9a4:	008b0913          	addi	s2,s6,8
 9a8:	4681                	li	a3,0
 9aa:	4629                	li	a2,10
 9ac:	000b2583          	lw	a1,0(s6)
 9b0:	8556                	mv	a0,s5
 9b2:	00000097          	auipc	ra,0x0
 9b6:	e72080e7          	jalr	-398(ra) # 824 <printint>
 9ba:	8b4a                	mv	s6,s2
      state = 0;
 9bc:	4981                	li	s3,0
 9be:	bf85                	j	92e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 9c0:	008b0913          	addi	s2,s6,8
 9c4:	4681                	li	a3,0
 9c6:	4641                	li	a2,16
 9c8:	000b2583          	lw	a1,0(s6)
 9cc:	8556                	mv	a0,s5
 9ce:	00000097          	auipc	ra,0x0
 9d2:	e56080e7          	jalr	-426(ra) # 824 <printint>
 9d6:	8b4a                	mv	s6,s2
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	bf91                	j	92e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9dc:	008b0793          	addi	a5,s6,8
 9e0:	f8f43423          	sd	a5,-120(s0)
 9e4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9e8:	03000593          	li	a1,48
 9ec:	8556                	mv	a0,s5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	e14080e7          	jalr	-492(ra) # 802 <putc>
  putc(fd, 'x');
 9f6:	85ea                	mv	a1,s10
 9f8:	8556                	mv	a0,s5
 9fa:	00000097          	auipc	ra,0x0
 9fe:	e08080e7          	jalr	-504(ra) # 802 <putc>
 a02:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a04:	03c9d793          	srli	a5,s3,0x3c
 a08:	97de                	add	a5,a5,s7
 a0a:	0007c583          	lbu	a1,0(a5)
 a0e:	8556                	mv	a0,s5
 a10:	00000097          	auipc	ra,0x0
 a14:	df2080e7          	jalr	-526(ra) # 802 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a18:	0992                	slli	s3,s3,0x4
 a1a:	397d                	addiw	s2,s2,-1
 a1c:	fe0914e3          	bnez	s2,a04 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 a20:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a24:	4981                	li	s3,0
 a26:	b721                	j	92e <vprintf+0x60>
        s = va_arg(ap, char*);
 a28:	008b0993          	addi	s3,s6,8
 a2c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 a30:	02090163          	beqz	s2,a52 <vprintf+0x184>
        while(*s != 0){
 a34:	00094583          	lbu	a1,0(s2)
 a38:	c9a1                	beqz	a1,a88 <vprintf+0x1ba>
          putc(fd, *s);
 a3a:	8556                	mv	a0,s5
 a3c:	00000097          	auipc	ra,0x0
 a40:	dc6080e7          	jalr	-570(ra) # 802 <putc>
          s++;
 a44:	0905                	addi	s2,s2,1
        while(*s != 0){
 a46:	00094583          	lbu	a1,0(s2)
 a4a:	f9e5                	bnez	a1,a3a <vprintf+0x16c>
        s = va_arg(ap, char*);
 a4c:	8b4e                	mv	s6,s3
      state = 0;
 a4e:	4981                	li	s3,0
 a50:	bdf9                	j	92e <vprintf+0x60>
          s = "(null)";
 a52:	00000917          	auipc	s2,0x0
 a56:	35e90913          	addi	s2,s2,862 # db0 <malloc+0x218>
        while(*s != 0){
 a5a:	02800593          	li	a1,40
 a5e:	bff1                	j	a3a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a60:	008b0913          	addi	s2,s6,8
 a64:	000b4583          	lbu	a1,0(s6)
 a68:	8556                	mv	a0,s5
 a6a:	00000097          	auipc	ra,0x0
 a6e:	d98080e7          	jalr	-616(ra) # 802 <putc>
 a72:	8b4a                	mv	s6,s2
      state = 0;
 a74:	4981                	li	s3,0
 a76:	bd65                	j	92e <vprintf+0x60>
        putc(fd, c);
 a78:	85d2                	mv	a1,s4
 a7a:	8556                	mv	a0,s5
 a7c:	00000097          	auipc	ra,0x0
 a80:	d86080e7          	jalr	-634(ra) # 802 <putc>
      state = 0;
 a84:	4981                	li	s3,0
 a86:	b565                	j	92e <vprintf+0x60>
        s = va_arg(ap, char*);
 a88:	8b4e                	mv	s6,s3
      state = 0;
 a8a:	4981                	li	s3,0
 a8c:	b54d                	j	92e <vprintf+0x60>
    }
  }
}
 a8e:	70e6                	ld	ra,120(sp)
 a90:	7446                	ld	s0,112(sp)
 a92:	74a6                	ld	s1,104(sp)
 a94:	7906                	ld	s2,96(sp)
 a96:	69e6                	ld	s3,88(sp)
 a98:	6a46                	ld	s4,80(sp)
 a9a:	6aa6                	ld	s5,72(sp)
 a9c:	6b06                	ld	s6,64(sp)
 a9e:	7be2                	ld	s7,56(sp)
 aa0:	7c42                	ld	s8,48(sp)
 aa2:	7ca2                	ld	s9,40(sp)
 aa4:	7d02                	ld	s10,32(sp)
 aa6:	6de2                	ld	s11,24(sp)
 aa8:	6109                	addi	sp,sp,128
 aaa:	8082                	ret

0000000000000aac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 aac:	715d                	addi	sp,sp,-80
 aae:	ec06                	sd	ra,24(sp)
 ab0:	e822                	sd	s0,16(sp)
 ab2:	1000                	addi	s0,sp,32
 ab4:	e010                	sd	a2,0(s0)
 ab6:	e414                	sd	a3,8(s0)
 ab8:	e818                	sd	a4,16(s0)
 aba:	ec1c                	sd	a5,24(s0)
 abc:	03043023          	sd	a6,32(s0)
 ac0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ac4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ac8:	8622                	mv	a2,s0
 aca:	00000097          	auipc	ra,0x0
 ace:	e04080e7          	jalr	-508(ra) # 8ce <vprintf>
}
 ad2:	60e2                	ld	ra,24(sp)
 ad4:	6442                	ld	s0,16(sp)
 ad6:	6161                	addi	sp,sp,80
 ad8:	8082                	ret

0000000000000ada <printf>:

void
printf(const char *fmt, ...)
{
 ada:	711d                	addi	sp,sp,-96
 adc:	ec06                	sd	ra,24(sp)
 ade:	e822                	sd	s0,16(sp)
 ae0:	1000                	addi	s0,sp,32
 ae2:	e40c                	sd	a1,8(s0)
 ae4:	e810                	sd	a2,16(s0)
 ae6:	ec14                	sd	a3,24(s0)
 ae8:	f018                	sd	a4,32(s0)
 aea:	f41c                	sd	a5,40(s0)
 aec:	03043823          	sd	a6,48(s0)
 af0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 af4:	00840613          	addi	a2,s0,8
 af8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 afc:	85aa                	mv	a1,a0
 afe:	4505                	li	a0,1
 b00:	00000097          	auipc	ra,0x0
 b04:	dce080e7          	jalr	-562(ra) # 8ce <vprintf>
}
 b08:	60e2                	ld	ra,24(sp)
 b0a:	6442                	ld	s0,16(sp)
 b0c:	6125                	addi	sp,sp,96
 b0e:	8082                	ret

0000000000000b10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b10:	1141                	addi	sp,sp,-16
 b12:	e422                	sd	s0,8(sp)
 b14:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b16:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1a:	00000797          	auipc	a5,0x0
 b1e:	2be7b783          	ld	a5,702(a5) # dd8 <freep>
 b22:	a805                	j	b52 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b24:	4618                	lw	a4,8(a2)
 b26:	9db9                	addw	a1,a1,a4
 b28:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b2c:	6398                	ld	a4,0(a5)
 b2e:	6318                	ld	a4,0(a4)
 b30:	fee53823          	sd	a4,-16(a0)
 b34:	a091                	j	b78 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b36:	ff852703          	lw	a4,-8(a0)
 b3a:	9e39                	addw	a2,a2,a4
 b3c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 b3e:	ff053703          	ld	a4,-16(a0)
 b42:	e398                	sd	a4,0(a5)
 b44:	a099                	j	b8a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b46:	6398                	ld	a4,0(a5)
 b48:	00e7e463          	bltu	a5,a4,b50 <free+0x40>
 b4c:	00e6ea63          	bltu	a3,a4,b60 <free+0x50>
{
 b50:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b52:	fed7fae3          	bgeu	a5,a3,b46 <free+0x36>
 b56:	6398                	ld	a4,0(a5)
 b58:	00e6e463          	bltu	a3,a4,b60 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b5c:	fee7eae3          	bltu	a5,a4,b50 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b60:	ff852583          	lw	a1,-8(a0)
 b64:	6390                	ld	a2,0(a5)
 b66:	02059713          	slli	a4,a1,0x20
 b6a:	9301                	srli	a4,a4,0x20
 b6c:	0712                	slli	a4,a4,0x4
 b6e:	9736                	add	a4,a4,a3
 b70:	fae60ae3          	beq	a2,a4,b24 <free+0x14>
    bp->s.ptr = p->s.ptr;
 b74:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b78:	4790                	lw	a2,8(a5)
 b7a:	02061713          	slli	a4,a2,0x20
 b7e:	9301                	srli	a4,a4,0x20
 b80:	0712                	slli	a4,a4,0x4
 b82:	973e                	add	a4,a4,a5
 b84:	fae689e3          	beq	a3,a4,b36 <free+0x26>
  } else
    p->s.ptr = bp;
 b88:	e394                	sd	a3,0(a5)
  freep = p;
 b8a:	00000717          	auipc	a4,0x0
 b8e:	24f73723          	sd	a5,590(a4) # dd8 <freep>
}
 b92:	6422                	ld	s0,8(sp)
 b94:	0141                	addi	sp,sp,16
 b96:	8082                	ret

0000000000000b98 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b98:	7139                	addi	sp,sp,-64
 b9a:	fc06                	sd	ra,56(sp)
 b9c:	f822                	sd	s0,48(sp)
 b9e:	f426                	sd	s1,40(sp)
 ba0:	f04a                	sd	s2,32(sp)
 ba2:	ec4e                	sd	s3,24(sp)
 ba4:	e852                	sd	s4,16(sp)
 ba6:	e456                	sd	s5,8(sp)
 ba8:	e05a                	sd	s6,0(sp)
 baa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bac:	02051493          	slli	s1,a0,0x20
 bb0:	9081                	srli	s1,s1,0x20
 bb2:	04bd                	addi	s1,s1,15
 bb4:	8091                	srli	s1,s1,0x4
 bb6:	0014899b          	addiw	s3,s1,1
 bba:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 bbc:	00000517          	auipc	a0,0x0
 bc0:	21c53503          	ld	a0,540(a0) # dd8 <freep>
 bc4:	c515                	beqz	a0,bf0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bc8:	4798                	lw	a4,8(a5)
 bca:	02977f63          	bgeu	a4,s1,c08 <malloc+0x70>
 bce:	8a4e                	mv	s4,s3
 bd0:	0009871b          	sext.w	a4,s3
 bd4:	6685                	lui	a3,0x1
 bd6:	00d77363          	bgeu	a4,a3,bdc <malloc+0x44>
 bda:	6a05                	lui	s4,0x1
 bdc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 be0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 be4:	00000917          	auipc	s2,0x0
 be8:	1f490913          	addi	s2,s2,500 # dd8 <freep>
  if(p == (char*)-1)
 bec:	5afd                	li	s5,-1
 bee:	a88d                	j	c60 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 bf0:	00004797          	auipc	a5,0x4
 bf4:	1f078793          	addi	a5,a5,496 # 4de0 <base>
 bf8:	00000717          	auipc	a4,0x0
 bfc:	1ef73023          	sd	a5,480(a4) # dd8 <freep>
 c00:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c02:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c06:	b7e1                	j	bce <malloc+0x36>
      if(p->s.size == nunits)
 c08:	02e48b63          	beq	s1,a4,c3e <malloc+0xa6>
        p->s.size -= nunits;
 c0c:	4137073b          	subw	a4,a4,s3
 c10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c12:	1702                	slli	a4,a4,0x20
 c14:	9301                	srli	a4,a4,0x20
 c16:	0712                	slli	a4,a4,0x4
 c18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c1e:	00000717          	auipc	a4,0x0
 c22:	1aa73d23          	sd	a0,442(a4) # dd8 <freep>
      return (void*)(p + 1);
 c26:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c2a:	70e2                	ld	ra,56(sp)
 c2c:	7442                	ld	s0,48(sp)
 c2e:	74a2                	ld	s1,40(sp)
 c30:	7902                	ld	s2,32(sp)
 c32:	69e2                	ld	s3,24(sp)
 c34:	6a42                	ld	s4,16(sp)
 c36:	6aa2                	ld	s5,8(sp)
 c38:	6b02                	ld	s6,0(sp)
 c3a:	6121                	addi	sp,sp,64
 c3c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c3e:	6398                	ld	a4,0(a5)
 c40:	e118                	sd	a4,0(a0)
 c42:	bff1                	j	c1e <malloc+0x86>
  hp->s.size = nu;
 c44:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c48:	0541                	addi	a0,a0,16
 c4a:	00000097          	auipc	ra,0x0
 c4e:	ec6080e7          	jalr	-314(ra) # b10 <free>
  return freep;
 c52:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c56:	d971                	beqz	a0,c2a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c58:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c5a:	4798                	lw	a4,8(a5)
 c5c:	fa9776e3          	bgeu	a4,s1,c08 <malloc+0x70>
    if(p == freep)
 c60:	00093703          	ld	a4,0(s2)
 c64:	853e                	mv	a0,a5
 c66:	fef719e3          	bne	a4,a5,c58 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c6a:	8552                	mv	a0,s4
 c6c:	00000097          	auipc	ra,0x0
 c70:	b7e080e7          	jalr	-1154(ra) # 7ea <sbrk>
  if(p == (char*)-1)
 c74:	fd5518e3          	bne	a0,s5,c44 <malloc+0xac>
        return 0;
 c78:	4501                	li	a0,0
 c7a:	bf45                	j	c2a <malloc+0x92>
