
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
  }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16

  for (int ai = 0; ai < 2; ai++)
  {
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	862080e7          	jalr	-1950(ra) # 5872 <open>
    if (fd >= 0)
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	850080e7          	jalr	-1968(ra) # 5872 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if (fd >= 0)
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
    {
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	05250513          	addi	a0,a0,82 # 6090 <malloc+0x428>
      46:	00006097          	auipc	ra,0x6
      4a:	b64080e7          	jalr	-1180(ra) # 5baa <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	7e2080e7          	jalr	2018(ra) # 5832 <exit>

0000000000000058 <bsstest>:
char uninit[10000];
void bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++)
      58:	00009797          	auipc	a5,0x9
      5c:	5b878793          	addi	a5,a5,1464 # 9610 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	cc068693          	addi	a3,a3,-832 # bd20 <buf>
  {
    if (uninit[i] != '\0')
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++)
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
    {
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	03050513          	addi	a0,a0,48 # 60b0 <malloc+0x448>
      88:	00006097          	auipc	ra,0x6
      8c:	b22080e7          	jalr	-1246(ra) # 5baa <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	7a0080e7          	jalr	1952(ra) # 5832 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	02050513          	addi	a0,a0,32 # 60c8 <malloc+0x460>
      b0:	00005097          	auipc	ra,0x5
      b4:	7c2080e7          	jalr	1986(ra) # 5872 <open>
  if (fd < 0)
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	79e080e7          	jalr	1950(ra) # 585a <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	02250513          	addi	a0,a0,34 # 60e8 <malloc+0x480>
      ce:	00005097          	auipc	ra,0x5
      d2:	7a4080e7          	jalr	1956(ra) # 5872 <open>
  if (fd >= 0)
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	fea50513          	addi	a0,a0,-22 # 60d0 <malloc+0x468>
      ee:	00006097          	auipc	ra,0x6
      f2:	abc080e7          	jalr	-1348(ra) # 5baa <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	73a080e7          	jalr	1850(ra) # 5832 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	ff650513          	addi	a0,a0,-10 # 60f8 <malloc+0x490>
     10a:	00006097          	auipc	ra,0x6
     10e:	aa0080e7          	jalr	-1376(ra) # 5baa <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	71e080e7          	jalr	1822(ra) # 5832 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	ff450513          	addi	a0,a0,-12 # 6120 <malloc+0x4b8>
     134:	00005097          	auipc	ra,0x5
     138:	74e080e7          	jalr	1870(ra) # 5882 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	fe050513          	addi	a0,a0,-32 # 6120 <malloc+0x4b8>
     148:	00005097          	auipc	ra,0x5
     14c:	72a080e7          	jalr	1834(ra) # 5872 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	fdc58593          	addi	a1,a1,-36 # 6130 <malloc+0x4c8>
     15c:	00005097          	auipc	ra,0x5
     160:	6f6080e7          	jalr	1782(ra) # 5852 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	fb850513          	addi	a0,a0,-72 # 6120 <malloc+0x4b8>
     170:	00005097          	auipc	ra,0x5
     174:	702080e7          	jalr	1794(ra) # 5872 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	fbc58593          	addi	a1,a1,-68 # 6138 <malloc+0x4d0>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	6cc080e7          	jalr	1740(ra) # 5852 <write>
  if (n != -1)
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	f8c50513          	addi	a0,a0,-116 # 6120 <malloc+0x4b8>
     19c:	00005097          	auipc	ra,0x5
     1a0:	6e6080e7          	jalr	1766(ra) # 5882 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	6b4080e7          	jalr	1716(ra) # 585a <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	6aa080e7          	jalr	1706(ra) # 585a <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	f7650513          	addi	a0,a0,-138 # 6140 <malloc+0x4d8>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	9d8080e7          	jalr	-1576(ra) # 5baa <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	656080e7          	jalr	1622(ra) # 5832 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for (i = 0; i < N; i++)
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE | O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	662080e7          	jalr	1634(ra) # 5872 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	642080e7          	jalr	1602(ra) # 585a <close>
  for (i = 0; i < N; i++)
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for (i = 0; i < N; i++)
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	63c080e7          	jalr	1596(ra) # 5882 <unlink>
  for (i = 0; i < N; i++)
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	c9c50513          	addi	a0,a0,-868 # 5f18 <malloc+0x2b0>
     284:	00005097          	auipc	ra,0x5
     288:	5fe080e7          	jalr	1534(ra) # 5882 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	c88a8a93          	addi	s5,s5,-888 # 5f18 <malloc+0x2b0>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	a88a0a13          	addi	s4,s4,-1400 # bd20 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x117>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	5c6080e7          	jalr	1478(ra) # 5872 <open>
     2b4:	892a                	mv	s2,a0
    if (fd < 0)
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	594080e7          	jalr	1428(ra) # 5852 <write>
     2c6:	89aa                	mv	s3,a0
      if (cc != sz)
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	580080e7          	jalr	1408(ra) # 5852 <write>
      if (cc != sz)
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	57a080e7          	jalr	1402(ra) # 585a <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	598080e7          	jalr	1432(ra) # 5882 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	e5650513          	addi	a0,a0,-426 # 6168 <malloc+0x500>
     31a:	00006097          	auipc	ra,0x6
     31e:	890080e7          	jalr	-1904(ra) # 5baa <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	50e080e7          	jalr	1294(ra) # 5832 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	e5250513          	addi	a0,a0,-430 # 6188 <malloc+0x520>
     33e:	00006097          	auipc	ra,0x6
     342:	86c080e7          	jalr	-1940(ra) # 5baa <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	4ea080e7          	jalr	1258(ra) # 5832 <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for (int ai = 0; ai < 2; ai++)
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	e2ea0a13          	addi	s4,s4,-466 # 61a0 <malloc+0x538>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	4ee080e7          	jalr	1262(ra) # 5872 <open>
     38c:	84aa                	mv	s1,a0
    if (fd < 0)
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	4bc080e7          	jalr	1212(ra) # 5852 <write>
    if (n >= 0)
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	4b6080e7          	jalr	1206(ra) # 585a <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	4d4080e7          	jalr	1236(ra) # 5882 <unlink>
    n = write(1, (char *)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	496080e7          	jalr	1174(ra) # 5852 <write>
    if (n > 0)
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if (pipe(fds) < 0)
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	476080e7          	jalr	1142(ra) # 5842 <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	472080e7          	jalr	1138(ra) # 5852 <write>
    if (n > 0)
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	46a080e7          	jalr	1130(ra) # 585a <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	45e080e7          	jalr	1118(ra) # 585a <close>
  for (int ai = 0; ai < 2; ai++)
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	d8a50513          	addi	a0,a0,-630 # 61a8 <malloc+0x540>
     426:	00005097          	auipc	ra,0x5
     42a:	784080e7          	jalr	1924(ra) # 5baa <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	402080e7          	jalr	1026(ra) # 5832 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	d8450513          	addi	a0,a0,-636 # 61c0 <malloc+0x558>
     444:	00005097          	auipc	ra,0x5
     448:	766080e7          	jalr	1894(ra) # 5baa <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	3e4080e7          	jalr	996(ra) # 5832 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	d9650513          	addi	a0,a0,-618 # 61f0 <malloc+0x588>
     462:	00005097          	auipc	ra,0x5
     466:	748080e7          	jalr	1864(ra) # 5baa <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	3c6080e7          	jalr	966(ra) # 5832 <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	dac50513          	addi	a0,a0,-596 # 6220 <malloc+0x5b8>
     47c:	00005097          	auipc	ra,0x5
     480:	72e080e7          	jalr	1838(ra) # 5baa <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	3ac080e7          	jalr	940(ra) # 5832 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	d9e50513          	addi	a0,a0,-610 # 6230 <malloc+0x5c8>
     49a:	00005097          	auipc	ra,0x5
     49e:	710080e7          	jalr	1808(ra) # 5baa <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	38e080e7          	jalr	910(ra) # 5832 <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < 2; ai++)
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	d90a0a13          	addi	s4,s4,-624 # 6260 <malloc+0x5f8>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	c60a8a93          	addi	s5,s5,-928 # 6138 <malloc+0x4d0>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	38a080e7          	jalr	906(ra) # 5872 <open>
     4f0:	84aa                	mv	s1,a0
    if (fd < 0)
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void *)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	350080e7          	jalr	848(ra) # 584a <read>
    if (n > 0)
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	352080e7          	jalr	850(ra) # 585a <close>
    if (pipe(fds) < 0)
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	32e080e7          	jalr	814(ra) # 5842 <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	32a080e7          	jalr	810(ra) # 5852 <write>
    if (n != 1)
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void *)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	30c080e7          	jalr	780(ra) # 584a <read>
    if (n > 0)
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	30c080e7          	jalr	780(ra) # 585a <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	300080e7          	jalr	768(ra) # 585a <close>
  for (int ai = 0; ai < 2; ai++)
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	cea50513          	addi	a0,a0,-790 # 6268 <malloc+0x600>
     586:	00005097          	auipc	ra,0x5
     58a:	624080e7          	jalr	1572(ra) # 5baa <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	2a2080e7          	jalr	674(ra) # 5832 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	ce450513          	addi	a0,a0,-796 # 6280 <malloc+0x618>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	606080e7          	jalr	1542(ra) # 5baa <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	284080e7          	jalr	644(ra) # 5832 <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	c6a50513          	addi	a0,a0,-918 # 6220 <malloc+0x5b8>
     5be:	00005097          	auipc	ra,0x5
     5c2:	5ec080e7          	jalr	1516(ra) # 5baa <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	26a080e7          	jalr	618(ra) # 5832 <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	ce050513          	addi	a0,a0,-800 # 62b0 <malloc+0x648>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	5d2080e7          	jalr	1490(ra) # 5baa <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	250080e7          	jalr	592(ra) # 5832 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	cda50513          	addi	a0,a0,-806 # 62c8 <malloc+0x660>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	5b4080e7          	jalr	1460(ra) # 5baa <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	232080e7          	jalr	562(ra) # 5832 <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	b0450513          	addi	a0,a0,-1276 # 6120 <malloc+0x4b8>
     624:	00005097          	auipc	ra,0x5
     628:	25e080e7          	jalr	606(ra) # 5882 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	af050513          	addi	a0,a0,-1296 # 6120 <malloc+0x4b8>
     638:	00005097          	auipc	ra,0x5
     63c:	23a080e7          	jalr	570(ra) # 5872 <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	aec58593          	addi	a1,a1,-1300 # 6130 <malloc+0x4c8>
     64c:	00005097          	auipc	ra,0x5
     650:	206080e7          	jalr	518(ra) # 5852 <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	204080e7          	jalr	516(ra) # 585a <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	ac050513          	addi	a0,a0,-1344 # 6120 <malloc+0x4b8>
     668:	00005097          	auipc	ra,0x5
     66c:	20a080e7          	jalr	522(ra) # 5872 <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	1d0080e7          	jalr	464(ra) # 584a <read>
  if (n != 4)
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	a9450513          	addi	a0,a0,-1388 # 6120 <malloc+0x4b8>
     694:	00005097          	auipc	ra,0x5
     698:	1de080e7          	jalr	478(ra) # 5872 <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	a8050513          	addi	a0,a0,-1408 # 6120 <malloc+0x4b8>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	1ca080e7          	jalr	458(ra) # 5872 <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	190080e7          	jalr	400(ra) # 584a <read>
     6c2:	8a2a                	mv	s4,a0
  if (n != 0)
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	17a080e7          	jalr	378(ra) # 584a <read>
     6d8:	8a2a                	mv	s4,a0
  if (n != 0)
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	c7a58593          	addi	a1,a1,-902 # 6358 <malloc+0x6f0>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	16a080e7          	jalr	362(ra) # 5852 <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	150080e7          	jalr	336(ra) # 584a <read>
  if (n != 6)
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	138080e7          	jalr	312(ra) # 584a <read>
  if (n != 2)
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	a0050513          	addi	a0,a0,-1536 # 6120 <malloc+0x4b8>
     728:	00005097          	auipc	ra,0x5
     72c:	15a080e7          	jalr	346(ra) # 5882 <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	128080e7          	jalr	296(ra) # 585a <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	11e080e7          	jalr	286(ra) # 585a <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	114080e7          	jalr	276(ra) # 585a <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	b9450513          	addi	a0,a0,-1132 # 62f8 <malloc+0x690>
     76c:	00005097          	auipc	ra,0x5
     770:	43e080e7          	jalr	1086(ra) # 5baa <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	0bc080e7          	jalr	188(ra) # 5832 <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	b9850513          	addi	a0,a0,-1128 # 6318 <malloc+0x6b0>
     788:	00005097          	auipc	ra,0x5
     78c:	422080e7          	jalr	1058(ra) # 5baa <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	b9450513          	addi	a0,a0,-1132 # 6328 <malloc+0x6c0>
     79c:	00005097          	auipc	ra,0x5
     7a0:	40e080e7          	jalr	1038(ra) # 5baa <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	08c080e7          	jalr	140(ra) # 5832 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	b9850513          	addi	a0,a0,-1128 # 6348 <malloc+0x6e0>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	3f2080e7          	jalr	1010(ra) # 5baa <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	b6450513          	addi	a0,a0,-1180 # 6328 <malloc+0x6c0>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	3de080e7          	jalr	990(ra) # 5baa <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	05c080e7          	jalr	92(ra) # 5832 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	b7e50513          	addi	a0,a0,-1154 # 6360 <malloc+0x6f8>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	3c0080e7          	jalr	960(ra) # 5baa <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	03e080e7          	jalr	62(ra) # 5832 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	b8050513          	addi	a0,a0,-1152 # 6380 <malloc+0x718>
     808:	00005097          	auipc	ra,0x5
     80c:	3a2080e7          	jalr	930(ra) # 5baa <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	020080e7          	jalr	32(ra) # 5832 <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	b6c50513          	addi	a0,a0,-1172 # 63a0 <malloc+0x738>
     83c:	00005097          	auipc	ra,0x5
     840:	036080e7          	jalr	54(ra) # 5872 <open>
  if (fd < 0)
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ)
     84c:	00006997          	auipc	s3,0x6
     850:	b7c98993          	addi	s3,s3,-1156 # 63c8 <malloc+0x760>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ)
     854:	00006a97          	auipc	s5,0x6
     858:	baca8a93          	addi	s5,s5,-1108 # 6400 <malloc+0x798>
  for (i = 0; i < N; i++)
     85c:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ)
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	fec080e7          	jalr	-20(ra) # 5852 <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ)
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	fd8080e7          	jalr	-40(ra) # 5852 <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for (i = 0; i < N; i++)
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	fca080e7          	jalr	-54(ra) # 585a <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	b0650513          	addi	a0,a0,-1274 # 63a0 <malloc+0x738>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	fd0080e7          	jalr	-48(ra) # 5872 <open>
     8aa:	84aa                	mv	s1,a0
  if (fd < 0)
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N * SZ * 2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	46c58593          	addi	a1,a1,1132 # bd20 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	f8e080e7          	jalr	-114(ra) # 584a <read>
  if (i != N * SZ * 2)
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	f8c080e7          	jalr	-116(ra) # 585a <close>
  if (unlink("small") < 0)
     8d6:	00006517          	auipc	a0,0x6
     8da:	aca50513          	addi	a0,a0,-1334 # 63a0 <malloc+0x738>
     8de:	00005097          	auipc	ra,0x5
     8e2:	fa4080e7          	jalr	-92(ra) # 5882 <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	aa850513          	addi	a0,a0,-1368 # 63a8 <malloc+0x740>
     908:	00005097          	auipc	ra,0x5
     90c:	2a2080e7          	jalr	674(ra) # 5baa <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	f20080e7          	jalr	-224(ra) # 5832 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	aba50513          	addi	a0,a0,-1350 # 63d8 <malloc+0x770>
     926:	00005097          	auipc	ra,0x5
     92a:	284080e7          	jalr	644(ra) # 5baa <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	f02080e7          	jalr	-254(ra) # 5832 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	ad450513          	addi	a0,a0,-1324 # 6410 <malloc+0x7a8>
     944:	00005097          	auipc	ra,0x5
     948:	266080e7          	jalr	614(ra) # 5baa <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	ee4080e7          	jalr	-284(ra) # 5832 <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	ae050513          	addi	a0,a0,-1312 # 6438 <malloc+0x7d0>
     960:	00005097          	auipc	ra,0x5
     964:	24a080e7          	jalr	586(ra) # 5baa <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	ec8080e7          	jalr	-312(ra) # 5832 <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	ae450513          	addi	a0,a0,-1308 # 6458 <malloc+0x7f0>
     97c:	00005097          	auipc	ra,0x5
     980:	22e080e7          	jalr	558(ra) # 5baa <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	eac080e7          	jalr	-340(ra) # 5832 <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	ae050513          	addi	a0,a0,-1312 # 6470 <malloc+0x808>
     998:	00005097          	auipc	ra,0x5
     99c:	212080e7          	jalr	530(ra) # 5baa <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	e90080e7          	jalr	-368(ra) # 5832 <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	ace50513          	addi	a0,a0,-1330 # 6490 <malloc+0x828>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	ea8080e7          	jalr	-344(ra) # 5872 <open>
     9d2:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++)
     9d4:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	34a90913          	addi	s2,s2,842 # bd20 <buf>
  for (i = 0; i < MAXFILE; i++)
     9de:	10c00a13          	li	s4,268
  if (fd < 0)
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int *)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE)
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	e60080e7          	jalr	-416(ra) # 5852 <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++)
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	e50080e7          	jalr	-432(ra) # 585a <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	a7c50513          	addi	a0,a0,-1412 # 6490 <malloc+0x828>
     a1c:	00005097          	auipc	ra,0x5
     a20:	e56080e7          	jalr	-426(ra) # 5872 <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	2f890913          	addi	s2,s2,760 # bd20 <buf>
  if (fd < 0)
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	e0e080e7          	jalr	-498(ra) # 584a <read>
    if (i == 0)
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    else if (i != BSIZE)
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if (((int *)buf)[0] != n)
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	a3c50513          	addi	a0,a0,-1476 # 6498 <malloc+0x830>
     a64:	00005097          	auipc	ra,0x5
     a68:	146080e7          	jalr	326(ra) # 5baa <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	dc4080e7          	jalr	-572(ra) # 5832 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a3e50513          	addi	a0,a0,-1474 # 64b8 <malloc+0x850>
     a82:	00005097          	auipc	ra,0x5
     a86:	128080e7          	jalr	296(ra) # 5baa <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	da6080e7          	jalr	-602(ra) # 5832 <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	a4a50513          	addi	a0,a0,-1462 # 64e0 <malloc+0x878>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	10c080e7          	jalr	268(ra) # 5baa <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	d8a080e7          	jalr	-630(ra) # 5832 <exit>
      if (n == MAXFILE - 1)
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	da0080e7          	jalr	-608(ra) # 585a <close>
  if (unlink("big") < 0)
     ac2:	00006517          	auipc	a0,0x6
     ac6:	9ce50513          	addi	a0,a0,-1586 # 6490 <malloc+0x828>
     aca:	00005097          	auipc	ra,0x5
     ace:	db8080e7          	jalr	-584(ra) # 5882 <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	a1250513          	addi	a0,a0,-1518 # 6500 <malloc+0x898>
     af6:	00005097          	auipc	ra,0x5
     afa:	0b4080e7          	jalr	180(ra) # 5baa <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	d32080e7          	jalr	-718(ra) # 5832 <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	a1c50513          	addi	a0,a0,-1508 # 6528 <malloc+0x8c0>
     b14:	00005097          	auipc	ra,0x5
     b18:	096080e7          	jalr	150(ra) # 5baa <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	d14080e7          	jalr	-748(ra) # 5832 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	a1650513          	addi	a0,a0,-1514 # 6540 <malloc+0x8d8>
     b32:	00005097          	auipc	ra,0x5
     b36:	078080e7          	jalr	120(ra) # 5baa <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	cf6080e7          	jalr	-778(ra) # 5832 <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	a2250513          	addi	a0,a0,-1502 # 6568 <malloc+0x900>
     b4e:	00005097          	auipc	ra,0x5
     b52:	05c080e7          	jalr	92(ra) # 5baa <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	cda080e7          	jalr	-806(ra) # 5832 <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	33450513          	addi	a0,a0,820 # 5ea8 <malloc+0x240>
     b7c:	00005097          	auipc	ra,0x5
     b80:	cf6080e7          	jalr	-778(ra) # 5872 <open>
  if (fd < 0)
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	a1458593          	addi	a1,a1,-1516 # 65a0 <malloc+0x938>
     b94:	00005097          	auipc	ra,0x5
     b98:	cbe080e7          	jalr	-834(ra) # 5852 <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	cbc080e7          	jalr	-836(ra) # 585a <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	30050513          	addi	a0,a0,768 # 5ea8 <malloc+0x240>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	cc2080e7          	jalr	-830(ra) # 5872 <open>
     bb8:	84aa                	mv	s1,a0
  if (fd < 0)
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if (unlink("unlinkread") != 0)
     bbe:	00005517          	auipc	a0,0x5
     bc2:	2ea50513          	addi	a0,a0,746 # 5ea8 <malloc+0x240>
     bc6:	00005097          	auipc	ra,0x5
     bca:	cbc080e7          	jalr	-836(ra) # 5882 <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	2d450513          	addi	a0,a0,724 # 5ea8 <malloc+0x240>
     bdc:	00005097          	auipc	ra,0x5
     be0:	c96080e7          	jalr	-874(ra) # 5872 <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	a0058593          	addi	a1,a1,-1536 # 65e8 <malloc+0x980>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	c62080e7          	jalr	-926(ra) # 5852 <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	c60080e7          	jalr	-928(ra) # 585a <close>
  if (read(fd, buf, sizeof(buf)) != SZ)
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	11c58593          	addi	a1,a1,284 # bd20 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	c3c080e7          	jalr	-964(ra) # 584a <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if (buf[0] != 'h')
     c1c:	0000b717          	auipc	a4,0xb
     c20:	10474703          	lbu	a4,260(a4) # bd20 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10)
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	0f258593          	addi	a1,a1,242 # bd20 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	c1a080e7          	jalr	-998(ra) # 5852 <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	c12080e7          	jalr	-1006(ra) # 585a <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	25850513          	addi	a0,a0,600 # 5ea8 <malloc+0x240>
     c58:	00005097          	auipc	ra,0x5
     c5c:	c2a080e7          	jalr	-982(ra) # 5882 <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00006517          	auipc	a0,0x6
     c74:	91050513          	addi	a0,a0,-1776 # 6580 <malloc+0x918>
     c78:	00005097          	auipc	ra,0x5
     c7c:	f32080e7          	jalr	-206(ra) # 5baa <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	bb0080e7          	jalr	-1104(ra) # 5832 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00006517          	auipc	a0,0x6
     c90:	91c50513          	addi	a0,a0,-1764 # 65a8 <malloc+0x940>
     c94:	00005097          	auipc	ra,0x5
     c98:	f16080e7          	jalr	-234(ra) # 5baa <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	b94080e7          	jalr	-1132(ra) # 5832 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00006517          	auipc	a0,0x6
     cac:	92050513          	addi	a0,a0,-1760 # 65c8 <malloc+0x960>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	efa080e7          	jalr	-262(ra) # 5baa <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	b78080e7          	jalr	-1160(ra) # 5832 <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00006517          	auipc	a0,0x6
     cc8:	92c50513          	addi	a0,a0,-1748 # 65f0 <malloc+0x988>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	ede080e7          	jalr	-290(ra) # 5baa <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	b5c080e7          	jalr	-1188(ra) # 5832 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00006517          	auipc	a0,0x6
     ce4:	93050513          	addi	a0,a0,-1744 # 6610 <malloc+0x9a8>
     ce8:	00005097          	auipc	ra,0x5
     cec:	ec2080e7          	jalr	-318(ra) # 5baa <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	b40080e7          	jalr	-1216(ra) # 5832 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00006517          	auipc	a0,0x6
     d00:	93450513          	addi	a0,a0,-1740 # 6630 <malloc+0x9c8>
     d04:	00005097          	auipc	ra,0x5
     d08:	ea6080e7          	jalr	-346(ra) # 5baa <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	b24080e7          	jalr	-1244(ra) # 5832 <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00006517          	auipc	a0,0x6
     d28:	92c50513          	addi	a0,a0,-1748 # 6650 <malloc+0x9e8>
     d2c:	00005097          	auipc	ra,0x5
     d30:	b56080e7          	jalr	-1194(ra) # 5882 <unlink>
  unlink("lf2");
     d34:	00006517          	auipc	a0,0x6
     d38:	92450513          	addi	a0,a0,-1756 # 6658 <malloc+0x9f0>
     d3c:	00005097          	auipc	ra,0x5
     d40:	b46080e7          	jalr	-1210(ra) # 5882 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00006517          	auipc	a0,0x6
     d4c:	90850513          	addi	a0,a0,-1784 # 6650 <malloc+0x9e8>
     d50:	00005097          	auipc	ra,0x5
     d54:	b22080e7          	jalr	-1246(ra) # 5872 <open>
  if (fd < 0)
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ)
     d5e:	4615                	li	a2,5
     d60:	00006597          	auipc	a1,0x6
     d64:	84058593          	addi	a1,a1,-1984 # 65a0 <malloc+0x938>
     d68:	00005097          	auipc	ra,0x5
     d6c:	aea080e7          	jalr	-1302(ra) # 5852 <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	ae2080e7          	jalr	-1310(ra) # 585a <close>
  if (link("lf1", "lf2") < 0)
     d80:	00006597          	auipc	a1,0x6
     d84:	8d858593          	addi	a1,a1,-1832 # 6658 <malloc+0x9f0>
     d88:	00006517          	auipc	a0,0x6
     d8c:	8c850513          	addi	a0,a0,-1848 # 6650 <malloc+0x9e8>
     d90:	00005097          	auipc	ra,0x5
     d94:	b02080e7          	jalr	-1278(ra) # 5892 <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00006517          	auipc	a0,0x6
     da0:	8b450513          	addi	a0,a0,-1868 # 6650 <malloc+0x9e8>
     da4:	00005097          	auipc	ra,0x5
     da8:	ade080e7          	jalr	-1314(ra) # 5882 <unlink>
  if (open("lf1", 0) >= 0)
     dac:	4581                	li	a1,0
     dae:	00006517          	auipc	a0,0x6
     db2:	8a250513          	addi	a0,a0,-1886 # 6650 <malloc+0x9e8>
     db6:	00005097          	auipc	ra,0x5
     dba:	abc080e7          	jalr	-1348(ra) # 5872 <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00006517          	auipc	a0,0x6
     dc8:	89450513          	addi	a0,a0,-1900 # 6658 <malloc+0x9f0>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	aa6080e7          	jalr	-1370(ra) # 5872 <open>
     dd4:	84aa                	mv	s1,a0
  if (fd < 0)
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ)
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	f4458593          	addi	a1,a1,-188 # bd20 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	a66080e7          	jalr	-1434(ra) # 584a <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	a66080e7          	jalr	-1434(ra) # 585a <close>
  if (link("lf2", "lf2") >= 0)
     dfc:	00006597          	auipc	a1,0x6
     e00:	85c58593          	addi	a1,a1,-1956 # 6658 <malloc+0x9f0>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	a8c080e7          	jalr	-1396(ra) # 5892 <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00006517          	auipc	a0,0x6
     e16:	84650513          	addi	a0,a0,-1978 # 6658 <malloc+0x9f0>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	a68080e7          	jalr	-1432(ra) # 5882 <unlink>
  if (link("lf2", "lf1") >= 0)
     e22:	00006597          	auipc	a1,0x6
     e26:	82e58593          	addi	a1,a1,-2002 # 6650 <malloc+0x9e8>
     e2a:	00006517          	auipc	a0,0x6
     e2e:	82e50513          	addi	a0,a0,-2002 # 6658 <malloc+0x9f0>
     e32:	00005097          	auipc	ra,0x5
     e36:	a60080e7          	jalr	-1440(ra) # 5892 <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if (link(".", "lf1") >= 0)
     e3e:	00006597          	auipc	a1,0x6
     e42:	81258593          	addi	a1,a1,-2030 # 6650 <malloc+0x9e8>
     e46:	00006517          	auipc	a0,0x6
     e4a:	91a50513          	addi	a0,a0,-1766 # 6760 <malloc+0xaf8>
     e4e:	00005097          	auipc	ra,0x5
     e52:	a44080e7          	jalr	-1468(ra) # 5892 <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	7f850513          	addi	a0,a0,2040 # 6660 <malloc+0x9f8>
     e70:	00005097          	auipc	ra,0x5
     e74:	d3a080e7          	jalr	-710(ra) # 5baa <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00005097          	auipc	ra,0x5
     e7e:	9b8080e7          	jalr	-1608(ra) # 5832 <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	7f450513          	addi	a0,a0,2036 # 6678 <malloc+0xa10>
     e8c:	00005097          	auipc	ra,0x5
     e90:	d1e080e7          	jalr	-738(ra) # 5baa <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00005097          	auipc	ra,0x5
     e9a:	99c080e7          	jalr	-1636(ra) # 5832 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	7f050513          	addi	a0,a0,2032 # 6690 <malloc+0xa28>
     ea8:	00005097          	auipc	ra,0x5
     eac:	d02080e7          	jalr	-766(ra) # 5baa <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00005097          	auipc	ra,0x5
     eb6:	980080e7          	jalr	-1664(ra) # 5832 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	7f450513          	addi	a0,a0,2036 # 66b0 <malloc+0xa48>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	ce6080e7          	jalr	-794(ra) # 5baa <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00005097          	auipc	ra,0x5
     ed2:	964080e7          	jalr	-1692(ra) # 5832 <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00006517          	auipc	a0,0x6
     edc:	80850513          	addi	a0,a0,-2040 # 66e0 <malloc+0xa78>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	cca080e7          	jalr	-822(ra) # 5baa <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00005097          	auipc	ra,0x5
     eee:	948080e7          	jalr	-1720(ra) # 5832 <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00006517          	auipc	a0,0x6
     ef8:	80450513          	addi	a0,a0,-2044 # 66f8 <malloc+0xa90>
     efc:	00005097          	auipc	ra,0x5
     f00:	cae080e7          	jalr	-850(ra) # 5baa <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00005097          	auipc	ra,0x5
     f0a:	92c080e7          	jalr	-1748(ra) # 5832 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00006517          	auipc	a0,0x6
     f14:	80050513          	addi	a0,a0,-2048 # 6710 <malloc+0xaa8>
     f18:	00005097          	auipc	ra,0x5
     f1c:	c92080e7          	jalr	-878(ra) # 5baa <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00005097          	auipc	ra,0x5
     f26:	910080e7          	jalr	-1776(ra) # 5832 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00006517          	auipc	a0,0x6
     f30:	80c50513          	addi	a0,a0,-2036 # 6738 <malloc+0xad0>
     f34:	00005097          	auipc	ra,0x5
     f38:	c76080e7          	jalr	-906(ra) # 5baa <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00005097          	auipc	ra,0x5
     f42:	8f4080e7          	jalr	-1804(ra) # 5832 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00006517          	auipc	a0,0x6
     f4c:	82050513          	addi	a0,a0,-2016 # 6768 <malloc+0xb00>
     f50:	00005097          	auipc	ra,0x5
     f54:	c5a080e7          	jalr	-934(ra) # 5baa <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00005097          	auipc	ra,0x5
     f5e:	8d8080e7          	jalr	-1832(ra) # 5832 <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00006517          	auipc	a0,0x6
     f7c:	81050513          	addi	a0,a0,-2032 # 6788 <malloc+0xb20>
     f80:	00005097          	auipc	ra,0x5
     f84:	902080e7          	jalr	-1790(ra) # 5882 <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	7fc50513          	addi	a0,a0,2044 # 6788 <malloc+0xb20>
     f94:	00005097          	auipc	ra,0x5
     f98:	8de080e7          	jalr	-1826(ra) # 5872 <open>
  if (fd < 0)
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00005097          	auipc	ra,0x5
     fa4:	8ba080e7          	jalr	-1862(ra) # 585a <close>
  for (i = 0; i < N; i++)
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if (link("bd", name) != 0)
     fae:	00005a17          	auipc	s4,0x5
     fb2:	7daa0a13          	addi	s4,s4,2010 # 6788 <malloc+0xb20>
  for (i = 0; i < N; i++)
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9579b          	sraiw	a5,s2,0x1f
     fc2:	01a7d71b          	srliw	a4,a5,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0)
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00005097          	auipc	ra,0x5
     ff2:	8a4080e7          	jalr	-1884(ra) # 5892 <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for (i = 0; i < N; i++)
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	78850513          	addi	a0,a0,1928 # 6788 <malloc+0xb20>
    1008:	00005097          	auipc	ra,0x5
    100c:	87a080e7          	jalr	-1926(ra) # 5882 <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for (i = 0; i < N; i++)
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d79b          	sraiw	a5,s1,0x1f
    1020:	01a7d71b          	srliw	a4,a5,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0)
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00005097          	auipc	ra,0x5
    104e:	838080e7          	jalr	-1992(ra) # 5882 <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for (i = 0; i < N; i++)
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	72050513          	addi	a0,a0,1824 # 6790 <malloc+0xb28>
    1078:	00005097          	auipc	ra,0x5
    107c:	b32080e7          	jalr	-1230(ra) # 5baa <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	7b0080e7          	jalr	1968(ra) # 5832 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	72050513          	addi	a0,a0,1824 # 67b0 <malloc+0xb48>
    1098:	00005097          	auipc	ra,0x5
    109c:	b12080e7          	jalr	-1262(ra) # 5baa <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	790080e7          	jalr	1936(ra) # 5832 <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	72450513          	addi	a0,a0,1828 # 67d0 <malloc+0xb68>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	af6080e7          	jalr	-1290(ra) # 5baa <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	774080e7          	jalr	1908(ra) # 5832 <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    10dc:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1)
    10de:	00005997          	auipc	s3,0x5
    10e2:	71298993          	addi	s3,s3,1810 # 67f0 <malloc+0xb88>
    10e6:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1)
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	7a0080e7          	jalr	1952(ra) # 5892 <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	6e650513          	addi	a0,a0,1766 # 6800 <malloc+0xb98>
    1122:	00005097          	auipc	ra,0x5
    1126:	a88080e7          	jalr	-1400(ra) # 5baa <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	706080e7          	jalr	1798(ra) # 5832 <exit>

0000000000001134 <pgbug>:

// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char *)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	3b64b483          	ld	s1,950(s1) # 84f8 <__SDATA_BEGIN__>
    114a:	fd840593          	addi	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	71a080e7          	jalr	1818(ra) # 586a <exec>

  pipe((int *)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	6e8080e7          	jalr	1768(ra) # 5842 <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	6ce080e7          	jalr	1742(ra) # 5832 <exit>

000000000000116c <copyinstr2>:
{
    116c:	7155                	addi	sp,sp,-208
    116e:	e586                	sd	ra,200(sp)
    1170:	e1a2                	sd	s0,192(sp)
    1172:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    1174:	f6840793          	addi	a5,s0,-152
    1178:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    117c:	07800713          	li	a4,120
    1180:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    1184:	0785                	addi	a5,a5,1
    1186:	fed79de3          	bne	a5,a3,1180 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    118a:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    118e:	f6840513          	addi	a0,s0,-152
    1192:	00004097          	auipc	ra,0x4
    1196:	6f0080e7          	jalr	1776(ra) # 5882 <unlink>
  if (ret != -1)
    119a:	57fd                	li	a5,-1
    119c:	0ef51063          	bne	a0,a5,127c <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11a0:	20100593          	li	a1,513
    11a4:	f6840513          	addi	a0,s0,-152
    11a8:	00004097          	auipc	ra,0x4
    11ac:	6ca080e7          	jalr	1738(ra) # 5872 <open>
  if (fd != -1)
    11b0:	57fd                	li	a5,-1
    11b2:	0ef51563          	bne	a0,a5,129c <copyinstr2+0x130>
  ret = link(b, b);
    11b6:	f6840593          	addi	a1,s0,-152
    11ba:	852e                	mv	a0,a1
    11bc:	00004097          	auipc	ra,0x4
    11c0:	6d6080e7          	jalr	1750(ra) # 5892 <link>
  if (ret != -1)
    11c4:	57fd                	li	a5,-1
    11c6:	0ef51b63          	bne	a0,a5,12bc <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    11ca:	00007797          	auipc	a5,0x7
    11ce:	81e78793          	addi	a5,a5,-2018 # 79e8 <malloc+0x1d80>
    11d2:	f4f43c23          	sd	a5,-168(s0)
    11d6:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    11da:	f5840593          	addi	a1,s0,-168
    11de:	f6840513          	addi	a0,s0,-152
    11e2:	00004097          	auipc	ra,0x4
    11e6:	688080e7          	jalr	1672(ra) # 586a <exec>
  if (ret != -1)
    11ea:	57fd                	li	a5,-1
    11ec:	0ef51963          	bne	a0,a5,12de <copyinstr2+0x172>
  int pid = fork();
    11f0:	00004097          	auipc	ra,0x4
    11f4:	63a080e7          	jalr	1594(ra) # 582a <fork>
  if (pid < 0)
    11f8:	10054363          	bltz	a0,12fe <copyinstr2+0x192>
  if (pid == 0)
    11fc:	12051463          	bnez	a0,1324 <copyinstr2+0x1b8>
    1200:	00007797          	auipc	a5,0x7
    1204:	40878793          	addi	a5,a5,1032 # 8608 <big.1270>
    1208:	00008697          	auipc	a3,0x8
    120c:	40068693          	addi	a3,a3,1024 # 9608 <__global_pointer$+0x910>
      big[i] = 'x';
    1210:	07800713          	li	a4,120
    1214:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1218:	0785                	addi	a5,a5,1
    121a:	fed79de3          	bne	a5,a3,1214 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    121e:	00008797          	auipc	a5,0x8
    1222:	3e078523          	sb	zero,1002(a5) # 9608 <__global_pointer$+0x910>
    char *args2[] = {big, big, big, 0};
    1226:	00007797          	auipc	a5,0x7
    122a:	ed278793          	addi	a5,a5,-302 # 80f8 <malloc+0x2490>
    122e:	6390                	ld	a2,0(a5)
    1230:	6794                	ld	a3,8(a5)
    1232:	6b98                	ld	a4,16(a5)
    1234:	6f9c                	ld	a5,24(a5)
    1236:	f2c43823          	sd	a2,-208(s0)
    123a:	f2d43c23          	sd	a3,-200(s0)
    123e:	f4e43023          	sd	a4,-192(s0)
    1242:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1246:	f3040593          	addi	a1,s0,-208
    124a:	00005517          	auipc	a0,0x5
    124e:	e7e50513          	addi	a0,a0,-386 # 60c8 <malloc+0x460>
    1252:	00004097          	auipc	ra,0x4
    1256:	618080e7          	jalr	1560(ra) # 586a <exec>
    if (ret != -1)
    125a:	57fd                	li	a5,-1
    125c:	0af50e63          	beq	a0,a5,1318 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1260:	55fd                	li	a1,-1
    1262:	00005517          	auipc	a0,0x5
    1266:	64650513          	addi	a0,a0,1606 # 68a8 <malloc+0xc40>
    126a:	00005097          	auipc	ra,0x5
    126e:	940080e7          	jalr	-1728(ra) # 5baa <printf>
      exit(1);
    1272:	4505                	li	a0,1
    1274:	00004097          	auipc	ra,0x4
    1278:	5be080e7          	jalr	1470(ra) # 5832 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    127c:	862a                	mv	a2,a0
    127e:	f6840593          	addi	a1,s0,-152
    1282:	00005517          	auipc	a0,0x5
    1286:	59e50513          	addi	a0,a0,1438 # 6820 <malloc+0xbb8>
    128a:	00005097          	auipc	ra,0x5
    128e:	920080e7          	jalr	-1760(ra) # 5baa <printf>
    exit(1);
    1292:	4505                	li	a0,1
    1294:	00004097          	auipc	ra,0x4
    1298:	59e080e7          	jalr	1438(ra) # 5832 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    129c:	862a                	mv	a2,a0
    129e:	f6840593          	addi	a1,s0,-152
    12a2:	00005517          	auipc	a0,0x5
    12a6:	59e50513          	addi	a0,a0,1438 # 6840 <malloc+0xbd8>
    12aa:	00005097          	auipc	ra,0x5
    12ae:	900080e7          	jalr	-1792(ra) # 5baa <printf>
    exit(1);
    12b2:	4505                	li	a0,1
    12b4:	00004097          	auipc	ra,0x4
    12b8:	57e080e7          	jalr	1406(ra) # 5832 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    12bc:	86aa                	mv	a3,a0
    12be:	f6840613          	addi	a2,s0,-152
    12c2:	85b2                	mv	a1,a2
    12c4:	00005517          	auipc	a0,0x5
    12c8:	59c50513          	addi	a0,a0,1436 # 6860 <malloc+0xbf8>
    12cc:	00005097          	auipc	ra,0x5
    12d0:	8de080e7          	jalr	-1826(ra) # 5baa <printf>
    exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00004097          	auipc	ra,0x4
    12da:	55c080e7          	jalr	1372(ra) # 5832 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    12de:	567d                	li	a2,-1
    12e0:	f6840593          	addi	a1,s0,-152
    12e4:	00005517          	auipc	a0,0x5
    12e8:	5a450513          	addi	a0,a0,1444 # 6888 <malloc+0xc20>
    12ec:	00005097          	auipc	ra,0x5
    12f0:	8be080e7          	jalr	-1858(ra) # 5baa <printf>
    exit(1);
    12f4:	4505                	li	a0,1
    12f6:	00004097          	auipc	ra,0x4
    12fa:	53c080e7          	jalr	1340(ra) # 5832 <exit>
    printf("fork failed\n");
    12fe:	00006517          	auipc	a0,0x6
    1302:	a2250513          	addi	a0,a0,-1502 # 6d20 <malloc+0x10b8>
    1306:	00005097          	auipc	ra,0x5
    130a:	8a4080e7          	jalr	-1884(ra) # 5baa <printf>
    exit(1);
    130e:	4505                	li	a0,1
    1310:	00004097          	auipc	ra,0x4
    1314:	522080e7          	jalr	1314(ra) # 5832 <exit>
    exit(747); // OK
    1318:	2eb00513          	li	a0,747
    131c:	00004097          	auipc	ra,0x4
    1320:	516080e7          	jalr	1302(ra) # 5832 <exit>
  int st = 0;
    1324:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1328:	f5440513          	addi	a0,s0,-172
    132c:	00004097          	auipc	ra,0x4
    1330:	50e080e7          	jalr	1294(ra) # 583a <wait>
  if (st != 747)
    1334:	f5442703          	lw	a4,-172(s0)
    1338:	2eb00793          	li	a5,747
    133c:	00f71663          	bne	a4,a5,1348 <copyinstr2+0x1dc>
}
    1340:	60ae                	ld	ra,200(sp)
    1342:	640e                	ld	s0,192(sp)
    1344:	6169                	addi	sp,sp,208
    1346:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1348:	00005517          	auipc	a0,0x5
    134c:	58850513          	addi	a0,a0,1416 # 68d0 <malloc+0xc68>
    1350:	00005097          	auipc	ra,0x5
    1354:	85a080e7          	jalr	-1958(ra) # 5baa <printf>
    exit(1);
    1358:	4505                	li	a0,1
    135a:	00004097          	auipc	ra,0x4
    135e:	4d8080e7          	jalr	1240(ra) # 5832 <exit>

0000000000001362 <truncate3>:
{
    1362:	7159                	addi	sp,sp,-112
    1364:	f486                	sd	ra,104(sp)
    1366:	f0a2                	sd	s0,96(sp)
    1368:	eca6                	sd	s1,88(sp)
    136a:	e8ca                	sd	s2,80(sp)
    136c:	e4ce                	sd	s3,72(sp)
    136e:	e0d2                	sd	s4,64(sp)
    1370:	fc56                	sd	s5,56(sp)
    1372:	1880                	addi	s0,sp,112
    1374:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    1376:	60100593          	li	a1,1537
    137a:	00005517          	auipc	a0,0x5
    137e:	da650513          	addi	a0,a0,-602 # 6120 <malloc+0x4b8>
    1382:	00004097          	auipc	ra,0x4
    1386:	4f0080e7          	jalr	1264(ra) # 5872 <open>
    138a:	00004097          	auipc	ra,0x4
    138e:	4d0080e7          	jalr	1232(ra) # 585a <close>
  pid = fork();
    1392:	00004097          	auipc	ra,0x4
    1396:	498080e7          	jalr	1176(ra) # 582a <fork>
  if (pid < 0)
    139a:	08054063          	bltz	a0,141a <truncate3+0xb8>
  if (pid == 0)
    139e:	e969                	bnez	a0,1470 <truncate3+0x10e>
    13a0:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13a4:	00005a17          	auipc	s4,0x5
    13a8:	d7ca0a13          	addi	s4,s4,-644 # 6120 <malloc+0x4b8>
      int n = write(fd, "1234567890", 10);
    13ac:	00005a97          	auipc	s5,0x5
    13b0:	584a8a93          	addi	s5,s5,1412 # 6930 <malloc+0xcc8>
      int fd = open("truncfile", O_WRONLY);
    13b4:	4585                	li	a1,1
    13b6:	8552                	mv	a0,s4
    13b8:	00004097          	auipc	ra,0x4
    13bc:	4ba080e7          	jalr	1210(ra) # 5872 <open>
    13c0:	84aa                	mv	s1,a0
      if (fd < 0)
    13c2:	06054a63          	bltz	a0,1436 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    13c6:	4629                	li	a2,10
    13c8:	85d6                	mv	a1,s5
    13ca:	00004097          	auipc	ra,0x4
    13ce:	488080e7          	jalr	1160(ra) # 5852 <write>
      if (n != 10)
    13d2:	47a9                	li	a5,10
    13d4:	06f51f63          	bne	a0,a5,1452 <truncate3+0xf0>
      close(fd);
    13d8:	8526                	mv	a0,s1
    13da:	00004097          	auipc	ra,0x4
    13de:	480080e7          	jalr	1152(ra) # 585a <close>
      fd = open("truncfile", O_RDONLY);
    13e2:	4581                	li	a1,0
    13e4:	8552                	mv	a0,s4
    13e6:	00004097          	auipc	ra,0x4
    13ea:	48c080e7          	jalr	1164(ra) # 5872 <open>
    13ee:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    13f0:	02000613          	li	a2,32
    13f4:	f9840593          	addi	a1,s0,-104
    13f8:	00004097          	auipc	ra,0x4
    13fc:	452080e7          	jalr	1106(ra) # 584a <read>
      close(fd);
    1400:	8526                	mv	a0,s1
    1402:	00004097          	auipc	ra,0x4
    1406:	458080e7          	jalr	1112(ra) # 585a <close>
    for (int i = 0; i < 100; i++)
    140a:	39fd                	addiw	s3,s3,-1
    140c:	fa0994e3          	bnez	s3,13b4 <truncate3+0x52>
    exit(0);
    1410:	4501                	li	a0,0
    1412:	00004097          	auipc	ra,0x4
    1416:	420080e7          	jalr	1056(ra) # 5832 <exit>
    printf("%s: fork failed\n", s);
    141a:	85ca                	mv	a1,s2
    141c:	00005517          	auipc	a0,0x5
    1420:	4e450513          	addi	a0,a0,1252 # 6900 <malloc+0xc98>
    1424:	00004097          	auipc	ra,0x4
    1428:	786080e7          	jalr	1926(ra) # 5baa <printf>
    exit(1);
    142c:	4505                	li	a0,1
    142e:	00004097          	auipc	ra,0x4
    1432:	404080e7          	jalr	1028(ra) # 5832 <exit>
        printf("%s: open failed\n", s);
    1436:	85ca                	mv	a1,s2
    1438:	00005517          	auipc	a0,0x5
    143c:	4e050513          	addi	a0,a0,1248 # 6918 <malloc+0xcb0>
    1440:	00004097          	auipc	ra,0x4
    1444:	76a080e7          	jalr	1898(ra) # 5baa <printf>
        exit(1);
    1448:	4505                	li	a0,1
    144a:	00004097          	auipc	ra,0x4
    144e:	3e8080e7          	jalr	1000(ra) # 5832 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1452:	862a                	mv	a2,a0
    1454:	85ca                	mv	a1,s2
    1456:	00005517          	auipc	a0,0x5
    145a:	4ea50513          	addi	a0,a0,1258 # 6940 <malloc+0xcd8>
    145e:	00004097          	auipc	ra,0x4
    1462:	74c080e7          	jalr	1868(ra) # 5baa <printf>
        exit(1);
    1466:	4505                	li	a0,1
    1468:	00004097          	auipc	ra,0x4
    146c:	3ca080e7          	jalr	970(ra) # 5832 <exit>
    1470:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1474:	00005a17          	auipc	s4,0x5
    1478:	caca0a13          	addi	s4,s4,-852 # 6120 <malloc+0x4b8>
    int n = write(fd, "xxx", 3);
    147c:	00005a97          	auipc	s5,0x5
    1480:	4e4a8a93          	addi	s5,s5,1252 # 6960 <malloc+0xcf8>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1484:	60100593          	li	a1,1537
    1488:	8552                	mv	a0,s4
    148a:	00004097          	auipc	ra,0x4
    148e:	3e8080e7          	jalr	1000(ra) # 5872 <open>
    1492:	84aa                	mv	s1,a0
    if (fd < 0)
    1494:	04054763          	bltz	a0,14e2 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    1498:	460d                	li	a2,3
    149a:	85d6                	mv	a1,s5
    149c:	00004097          	auipc	ra,0x4
    14a0:	3b6080e7          	jalr	950(ra) # 5852 <write>
    if (n != 3)
    14a4:	478d                	li	a5,3
    14a6:	04f51c63          	bne	a0,a5,14fe <truncate3+0x19c>
    close(fd);
    14aa:	8526                	mv	a0,s1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	3ae080e7          	jalr	942(ra) # 585a <close>
  for (int i = 0; i < 150; i++)
    14b4:	39fd                	addiw	s3,s3,-1
    14b6:	fc0997e3          	bnez	s3,1484 <truncate3+0x122>
  wait(&xstatus);
    14ba:	fbc40513          	addi	a0,s0,-68
    14be:	00004097          	auipc	ra,0x4
    14c2:	37c080e7          	jalr	892(ra) # 583a <wait>
  unlink("truncfile");
    14c6:	00005517          	auipc	a0,0x5
    14ca:	c5a50513          	addi	a0,a0,-934 # 6120 <malloc+0x4b8>
    14ce:	00004097          	auipc	ra,0x4
    14d2:	3b4080e7          	jalr	948(ra) # 5882 <unlink>
  exit(xstatus);
    14d6:	fbc42503          	lw	a0,-68(s0)
    14da:	00004097          	auipc	ra,0x4
    14de:	358080e7          	jalr	856(ra) # 5832 <exit>
      printf("%s: open failed\n", s);
    14e2:	85ca                	mv	a1,s2
    14e4:	00005517          	auipc	a0,0x5
    14e8:	43450513          	addi	a0,a0,1076 # 6918 <malloc+0xcb0>
    14ec:	00004097          	auipc	ra,0x4
    14f0:	6be080e7          	jalr	1726(ra) # 5baa <printf>
      exit(1);
    14f4:	4505                	li	a0,1
    14f6:	00004097          	auipc	ra,0x4
    14fa:	33c080e7          	jalr	828(ra) # 5832 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    14fe:	862a                	mv	a2,a0
    1500:	85ca                	mv	a1,s2
    1502:	00005517          	auipc	a0,0x5
    1506:	46650513          	addi	a0,a0,1126 # 6968 <malloc+0xd00>
    150a:	00004097          	auipc	ra,0x4
    150e:	6a0080e7          	jalr	1696(ra) # 5baa <printf>
      exit(1);
    1512:	4505                	li	a0,1
    1514:	00004097          	auipc	ra,0x4
    1518:	31e080e7          	jalr	798(ra) # 5832 <exit>

000000000000151c <exectest>:
{
    151c:	715d                	addi	sp,sp,-80
    151e:	e486                	sd	ra,72(sp)
    1520:	e0a2                	sd	s0,64(sp)
    1522:	fc26                	sd	s1,56(sp)
    1524:	f84a                	sd	s2,48(sp)
    1526:	0880                	addi	s0,sp,80
    1528:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    152a:	00005797          	auipc	a5,0x5
    152e:	b9e78793          	addi	a5,a5,-1122 # 60c8 <malloc+0x460>
    1532:	fcf43023          	sd	a5,-64(s0)
    1536:	00005797          	auipc	a5,0x5
    153a:	45278793          	addi	a5,a5,1106 # 6988 <malloc+0xd20>
    153e:	fcf43423          	sd	a5,-56(s0)
    1542:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1546:	00005517          	auipc	a0,0x5
    154a:	44a50513          	addi	a0,a0,1098 # 6990 <malloc+0xd28>
    154e:	00004097          	auipc	ra,0x4
    1552:	334080e7          	jalr	820(ra) # 5882 <unlink>
  pid = fork();
    1556:	00004097          	auipc	ra,0x4
    155a:	2d4080e7          	jalr	724(ra) # 582a <fork>
  if (pid < 0)
    155e:	04054663          	bltz	a0,15aa <exectest+0x8e>
    1562:	84aa                	mv	s1,a0
  if (pid == 0)
    1564:	e959                	bnez	a0,15fa <exectest+0xde>
    close(1);
    1566:	4505                	li	a0,1
    1568:	00004097          	auipc	ra,0x4
    156c:	2f2080e7          	jalr	754(ra) # 585a <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    1570:	20100593          	li	a1,513
    1574:	00005517          	auipc	a0,0x5
    1578:	41c50513          	addi	a0,a0,1052 # 6990 <malloc+0xd28>
    157c:	00004097          	auipc	ra,0x4
    1580:	2f6080e7          	jalr	758(ra) # 5872 <open>
    if (fd < 0)
    1584:	04054163          	bltz	a0,15c6 <exectest+0xaa>
    if (fd != 1)
    1588:	4785                	li	a5,1
    158a:	04f50c63          	beq	a0,a5,15e2 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    158e:	85ca                	mv	a1,s2
    1590:	00005517          	auipc	a0,0x5
    1594:	42050513          	addi	a0,a0,1056 # 69b0 <malloc+0xd48>
    1598:	00004097          	auipc	ra,0x4
    159c:	612080e7          	jalr	1554(ra) # 5baa <printf>
      exit(1);
    15a0:	4505                	li	a0,1
    15a2:	00004097          	auipc	ra,0x4
    15a6:	290080e7          	jalr	656(ra) # 5832 <exit>
    printf("%s: fork failed\n", s);
    15aa:	85ca                	mv	a1,s2
    15ac:	00005517          	auipc	a0,0x5
    15b0:	35450513          	addi	a0,a0,852 # 6900 <malloc+0xc98>
    15b4:	00004097          	auipc	ra,0x4
    15b8:	5f6080e7          	jalr	1526(ra) # 5baa <printf>
    exit(1);
    15bc:	4505                	li	a0,1
    15be:	00004097          	auipc	ra,0x4
    15c2:	274080e7          	jalr	628(ra) # 5832 <exit>
      printf("%s: create failed\n", s);
    15c6:	85ca                	mv	a1,s2
    15c8:	00005517          	auipc	a0,0x5
    15cc:	3d050513          	addi	a0,a0,976 # 6998 <malloc+0xd30>
    15d0:	00004097          	auipc	ra,0x4
    15d4:	5da080e7          	jalr	1498(ra) # 5baa <printf>
      exit(1);
    15d8:	4505                	li	a0,1
    15da:	00004097          	auipc	ra,0x4
    15de:	258080e7          	jalr	600(ra) # 5832 <exit>
    if (exec("echo", echoargv) < 0)
    15e2:	fc040593          	addi	a1,s0,-64
    15e6:	00005517          	auipc	a0,0x5
    15ea:	ae250513          	addi	a0,a0,-1310 # 60c8 <malloc+0x460>
    15ee:	00004097          	auipc	ra,0x4
    15f2:	27c080e7          	jalr	636(ra) # 586a <exec>
    15f6:	02054163          	bltz	a0,1618 <exectest+0xfc>
  if (wait(&xstatus) != pid)
    15fa:	fdc40513          	addi	a0,s0,-36
    15fe:	00004097          	auipc	ra,0x4
    1602:	23c080e7          	jalr	572(ra) # 583a <wait>
    1606:	02951763          	bne	a0,s1,1634 <exectest+0x118>
  if (xstatus != 0)
    160a:	fdc42503          	lw	a0,-36(s0)
    160e:	cd0d                	beqz	a0,1648 <exectest+0x12c>
    exit(xstatus);
    1610:	00004097          	auipc	ra,0x4
    1614:	222080e7          	jalr	546(ra) # 5832 <exit>
      printf("%s: exec echo failed\n", s);
    1618:	85ca                	mv	a1,s2
    161a:	00005517          	auipc	a0,0x5
    161e:	3a650513          	addi	a0,a0,934 # 69c0 <malloc+0xd58>
    1622:	00004097          	auipc	ra,0x4
    1626:	588080e7          	jalr	1416(ra) # 5baa <printf>
      exit(1);
    162a:	4505                	li	a0,1
    162c:	00004097          	auipc	ra,0x4
    1630:	206080e7          	jalr	518(ra) # 5832 <exit>
    printf("%s: wait failed!\n", s);
    1634:	85ca                	mv	a1,s2
    1636:	00005517          	auipc	a0,0x5
    163a:	3a250513          	addi	a0,a0,930 # 69d8 <malloc+0xd70>
    163e:	00004097          	auipc	ra,0x4
    1642:	56c080e7          	jalr	1388(ra) # 5baa <printf>
    1646:	b7d1                	j	160a <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1648:	4581                	li	a1,0
    164a:	00005517          	auipc	a0,0x5
    164e:	34650513          	addi	a0,a0,838 # 6990 <malloc+0xd28>
    1652:	00004097          	auipc	ra,0x4
    1656:	220080e7          	jalr	544(ra) # 5872 <open>
  if (fd < 0)
    165a:	02054a63          	bltz	a0,168e <exectest+0x172>
  if (read(fd, buf, 2) != 2)
    165e:	4609                	li	a2,2
    1660:	fb840593          	addi	a1,s0,-72
    1664:	00004097          	auipc	ra,0x4
    1668:	1e6080e7          	jalr	486(ra) # 584a <read>
    166c:	4789                	li	a5,2
    166e:	02f50e63          	beq	a0,a5,16aa <exectest+0x18e>
    printf("%s: read failed\n", s);
    1672:	85ca                	mv	a1,s2
    1674:	00005517          	auipc	a0,0x5
    1678:	de450513          	addi	a0,a0,-540 # 6458 <malloc+0x7f0>
    167c:	00004097          	auipc	ra,0x4
    1680:	52e080e7          	jalr	1326(ra) # 5baa <printf>
    exit(1);
    1684:	4505                	li	a0,1
    1686:	00004097          	auipc	ra,0x4
    168a:	1ac080e7          	jalr	428(ra) # 5832 <exit>
    printf("%s: open failed\n", s);
    168e:	85ca                	mv	a1,s2
    1690:	00005517          	auipc	a0,0x5
    1694:	28850513          	addi	a0,a0,648 # 6918 <malloc+0xcb0>
    1698:	00004097          	auipc	ra,0x4
    169c:	512080e7          	jalr	1298(ra) # 5baa <printf>
    exit(1);
    16a0:	4505                	li	a0,1
    16a2:	00004097          	auipc	ra,0x4
    16a6:	190080e7          	jalr	400(ra) # 5832 <exit>
  unlink("echo-ok");
    16aa:	00005517          	auipc	a0,0x5
    16ae:	2e650513          	addi	a0,a0,742 # 6990 <malloc+0xd28>
    16b2:	00004097          	auipc	ra,0x4
    16b6:	1d0080e7          	jalr	464(ra) # 5882 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    16ba:	fb844703          	lbu	a4,-72(s0)
    16be:	04f00793          	li	a5,79
    16c2:	00f71863          	bne	a4,a5,16d2 <exectest+0x1b6>
    16c6:	fb944703          	lbu	a4,-71(s0)
    16ca:	04b00793          	li	a5,75
    16ce:	02f70063          	beq	a4,a5,16ee <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    16d2:	85ca                	mv	a1,s2
    16d4:	00005517          	auipc	a0,0x5
    16d8:	31c50513          	addi	a0,a0,796 # 69f0 <malloc+0xd88>
    16dc:	00004097          	auipc	ra,0x4
    16e0:	4ce080e7          	jalr	1230(ra) # 5baa <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00004097          	auipc	ra,0x4
    16ea:	14c080e7          	jalr	332(ra) # 5832 <exit>
    exit(0);
    16ee:	4501                	li	a0,0
    16f0:	00004097          	auipc	ra,0x4
    16f4:	142080e7          	jalr	322(ra) # 5832 <exit>

00000000000016f8 <pipe1>:
{
    16f8:	711d                	addi	sp,sp,-96
    16fa:	ec86                	sd	ra,88(sp)
    16fc:	e8a2                	sd	s0,80(sp)
    16fe:	e4a6                	sd	s1,72(sp)
    1700:	e0ca                	sd	s2,64(sp)
    1702:	fc4e                	sd	s3,56(sp)
    1704:	f852                	sd	s4,48(sp)
    1706:	f456                	sd	s5,40(sp)
    1708:	f05a                	sd	s6,32(sp)
    170a:	ec5e                	sd	s7,24(sp)
    170c:	1080                	addi	s0,sp,96
    170e:	892a                	mv	s2,a0
  if (pipe(fds) != 0)
    1710:	fa840513          	addi	a0,s0,-88
    1714:	00004097          	auipc	ra,0x4
    1718:	12e080e7          	jalr	302(ra) # 5842 <pipe>
    171c:	ed25                	bnez	a0,1794 <pipe1+0x9c>
    171e:	84aa                	mv	s1,a0
  pid = fork();
    1720:	00004097          	auipc	ra,0x4
    1724:	10a080e7          	jalr	266(ra) # 582a <fork>
    1728:	8a2a                	mv	s4,a0
  if (pid == 0)
    172a:	c159                	beqz	a0,17b0 <pipe1+0xb8>
  else if (pid > 0)
    172c:	16a05e63          	blez	a0,18a8 <pipe1+0x1b0>
    close(fds[1]);
    1730:	fac42503          	lw	a0,-84(s0)
    1734:	00004097          	auipc	ra,0x4
    1738:	126080e7          	jalr	294(ra) # 585a <close>
    total = 0;
    173c:	8a26                	mv	s4,s1
    cc = 1;
    173e:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0)
    1740:	0000aa97          	auipc	s5,0xa
    1744:	5e0a8a93          	addi	s5,s5,1504 # bd20 <buf>
      if (cc > sizeof(buf))
    1748:	6b0d                	lui	s6,0x3
    while ((n = read(fds[0], buf, cc)) > 0)
    174a:	864e                	mv	a2,s3
    174c:	85d6                	mv	a1,s5
    174e:	fa842503          	lw	a0,-88(s0)
    1752:	00004097          	auipc	ra,0x4
    1756:	0f8080e7          	jalr	248(ra) # 584a <read>
    175a:	10a05263          	blez	a0,185e <pipe1+0x166>
      for (i = 0; i < n; i++)
    175e:	0000a717          	auipc	a4,0xa
    1762:	5c270713          	addi	a4,a4,1474 # bd20 <buf>
    1766:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff))
    176a:	00074683          	lbu	a3,0(a4)
    176e:	0ff4f793          	andi	a5,s1,255
    1772:	2485                	addiw	s1,s1,1
    1774:	0cf69163          	bne	a3,a5,1836 <pipe1+0x13e>
      for (i = 0; i < n; i++)
    1778:	0705                	addi	a4,a4,1
    177a:	fec498e3          	bne	s1,a2,176a <pipe1+0x72>
      total += n;
    177e:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1782:	0019979b          	slliw	a5,s3,0x1
    1786:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf))
    178a:	013b7363          	bgeu	s6,s3,1790 <pipe1+0x98>
        cc = sizeof(buf);
    178e:	89da                	mv	s3,s6
        if ((buf[i] & 0xff) != (seq++ & 0xff))
    1790:	84b2                	mv	s1,a2
    1792:	bf65                	j	174a <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    1794:	85ca                	mv	a1,s2
    1796:	00005517          	auipc	a0,0x5
    179a:	27250513          	addi	a0,a0,626 # 6a08 <malloc+0xda0>
    179e:	00004097          	auipc	ra,0x4
    17a2:	40c080e7          	jalr	1036(ra) # 5baa <printf>
    exit(1);
    17a6:	4505                	li	a0,1
    17a8:	00004097          	auipc	ra,0x4
    17ac:	08a080e7          	jalr	138(ra) # 5832 <exit>
    close(fds[0]);
    17b0:	fa842503          	lw	a0,-88(s0)
    17b4:	00004097          	auipc	ra,0x4
    17b8:	0a6080e7          	jalr	166(ra) # 585a <close>
    for (n = 0; n < N; n++)
    17bc:	0000ab17          	auipc	s6,0xa
    17c0:	564b0b13          	addi	s6,s6,1380 # bd20 <buf>
    17c4:	416004bb          	negw	s1,s6
    17c8:	0ff4f493          	andi	s1,s1,255
    17cc:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ)
    17d0:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++)
    17d2:	6a85                	lui	s5,0x1
    17d4:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0xcb>
{
    17d8:	87da                	mv	a5,s6
        buf[i] = seq++;
    17da:	0097873b          	addw	a4,a5,s1
    17de:	00e78023          	sb	a4,0(a5)
      for (i = 0; i < SZ; i++)
    17e2:	0785                	addi	a5,a5,1
    17e4:	fef99be3          	bne	s3,a5,17da <pipe1+0xe2>
    17e8:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ)
    17ec:	40900613          	li	a2,1033
    17f0:	85de                	mv	a1,s7
    17f2:	fac42503          	lw	a0,-84(s0)
    17f6:	00004097          	auipc	ra,0x4
    17fa:	05c080e7          	jalr	92(ra) # 5852 <write>
    17fe:	40900793          	li	a5,1033
    1802:	00f51c63          	bne	a0,a5,181a <pipe1+0x122>
    for (n = 0; n < N; n++)
    1806:	24a5                	addiw	s1,s1,9
    1808:	0ff4f493          	andi	s1,s1,255
    180c:	fd5a16e3          	bne	s4,s5,17d8 <pipe1+0xe0>
    exit(0);
    1810:	4501                	li	a0,0
    1812:	00004097          	auipc	ra,0x4
    1816:	020080e7          	jalr	32(ra) # 5832 <exit>
        printf("%s: pipe1 oops 1\n", s);
    181a:	85ca                	mv	a1,s2
    181c:	00005517          	auipc	a0,0x5
    1820:	20450513          	addi	a0,a0,516 # 6a20 <malloc+0xdb8>
    1824:	00004097          	auipc	ra,0x4
    1828:	386080e7          	jalr	902(ra) # 5baa <printf>
        exit(1);
    182c:	4505                	li	a0,1
    182e:	00004097          	auipc	ra,0x4
    1832:	004080e7          	jalr	4(ra) # 5832 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1836:	85ca                	mv	a1,s2
    1838:	00005517          	auipc	a0,0x5
    183c:	20050513          	addi	a0,a0,512 # 6a38 <malloc+0xdd0>
    1840:	00004097          	auipc	ra,0x4
    1844:	36a080e7          	jalr	874(ra) # 5baa <printf>
}
    1848:	60e6                	ld	ra,88(sp)
    184a:	6446                	ld	s0,80(sp)
    184c:	64a6                	ld	s1,72(sp)
    184e:	6906                	ld	s2,64(sp)
    1850:	79e2                	ld	s3,56(sp)
    1852:	7a42                	ld	s4,48(sp)
    1854:	7aa2                	ld	s5,40(sp)
    1856:	7b02                	ld	s6,32(sp)
    1858:	6be2                	ld	s7,24(sp)
    185a:	6125                	addi	sp,sp,96
    185c:	8082                	ret
    if (total != N * SZ)
    185e:	6785                	lui	a5,0x1
    1860:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0xcb>
    1864:	02fa0063          	beq	s4,a5,1884 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1868:	85d2                	mv	a1,s4
    186a:	00005517          	auipc	a0,0x5
    186e:	1e650513          	addi	a0,a0,486 # 6a50 <malloc+0xde8>
    1872:	00004097          	auipc	ra,0x4
    1876:	338080e7          	jalr	824(ra) # 5baa <printf>
      exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	fb6080e7          	jalr	-74(ra) # 5832 <exit>
    close(fds[0]);
    1884:	fa842503          	lw	a0,-88(s0)
    1888:	00004097          	auipc	ra,0x4
    188c:	fd2080e7          	jalr	-46(ra) # 585a <close>
    wait(&xstatus);
    1890:	fa440513          	addi	a0,s0,-92
    1894:	00004097          	auipc	ra,0x4
    1898:	fa6080e7          	jalr	-90(ra) # 583a <wait>
    exit(xstatus);
    189c:	fa442503          	lw	a0,-92(s0)
    18a0:	00004097          	auipc	ra,0x4
    18a4:	f92080e7          	jalr	-110(ra) # 5832 <exit>
    printf("%s: fork() failed\n", s);
    18a8:	85ca                	mv	a1,s2
    18aa:	00005517          	auipc	a0,0x5
    18ae:	1c650513          	addi	a0,a0,454 # 6a70 <malloc+0xe08>
    18b2:	00004097          	auipc	ra,0x4
    18b6:	2f8080e7          	jalr	760(ra) # 5baa <printf>
    exit(1);
    18ba:	4505                	li	a0,1
    18bc:	00004097          	auipc	ra,0x4
    18c0:	f76080e7          	jalr	-138(ra) # 5832 <exit>

00000000000018c4 <exitwait>:
{
    18c4:	7139                	addi	sp,sp,-64
    18c6:	fc06                	sd	ra,56(sp)
    18c8:	f822                	sd	s0,48(sp)
    18ca:	f426                	sd	s1,40(sp)
    18cc:	f04a                	sd	s2,32(sp)
    18ce:	ec4e                	sd	s3,24(sp)
    18d0:	e852                	sd	s4,16(sp)
    18d2:	0080                	addi	s0,sp,64
    18d4:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++)
    18d6:	4901                	li	s2,0
    18d8:	06400993          	li	s3,100
    pid = fork();
    18dc:	00004097          	auipc	ra,0x4
    18e0:	f4e080e7          	jalr	-178(ra) # 582a <fork>
    18e4:	84aa                	mv	s1,a0
    if (pid < 0)
    18e6:	02054a63          	bltz	a0,191a <exitwait+0x56>
    if (pid)
    18ea:	c151                	beqz	a0,196e <exitwait+0xaa>
      if (wait(&xstate) != pid)
    18ec:	fcc40513          	addi	a0,s0,-52
    18f0:	00004097          	auipc	ra,0x4
    18f4:	f4a080e7          	jalr	-182(ra) # 583a <wait>
    18f8:	02951f63          	bne	a0,s1,1936 <exitwait+0x72>
      if (i != xstate)
    18fc:	fcc42783          	lw	a5,-52(s0)
    1900:	05279963          	bne	a5,s2,1952 <exitwait+0x8e>
  for (i = 0; i < 100; i++)
    1904:	2905                	addiw	s2,s2,1
    1906:	fd391be3          	bne	s2,s3,18dc <exitwait+0x18>
}
    190a:	70e2                	ld	ra,56(sp)
    190c:	7442                	ld	s0,48(sp)
    190e:	74a2                	ld	s1,40(sp)
    1910:	7902                	ld	s2,32(sp)
    1912:	69e2                	ld	s3,24(sp)
    1914:	6a42                	ld	s4,16(sp)
    1916:	6121                	addi	sp,sp,64
    1918:	8082                	ret
      printf("%s: fork failed\n", s);
    191a:	85d2                	mv	a1,s4
    191c:	00005517          	auipc	a0,0x5
    1920:	fe450513          	addi	a0,a0,-28 # 6900 <malloc+0xc98>
    1924:	00004097          	auipc	ra,0x4
    1928:	286080e7          	jalr	646(ra) # 5baa <printf>
      exit(1);
    192c:	4505                	li	a0,1
    192e:	00004097          	auipc	ra,0x4
    1932:	f04080e7          	jalr	-252(ra) # 5832 <exit>
        printf("%s: wait wrong pid\n", s);
    1936:	85d2                	mv	a1,s4
    1938:	00005517          	auipc	a0,0x5
    193c:	15050513          	addi	a0,a0,336 # 6a88 <malloc+0xe20>
    1940:	00004097          	auipc	ra,0x4
    1944:	26a080e7          	jalr	618(ra) # 5baa <printf>
        exit(1);
    1948:	4505                	li	a0,1
    194a:	00004097          	auipc	ra,0x4
    194e:	ee8080e7          	jalr	-280(ra) # 5832 <exit>
        printf("%s: wait wrong exit status\n", s);
    1952:	85d2                	mv	a1,s4
    1954:	00005517          	auipc	a0,0x5
    1958:	14c50513          	addi	a0,a0,332 # 6aa0 <malloc+0xe38>
    195c:	00004097          	auipc	ra,0x4
    1960:	24e080e7          	jalr	590(ra) # 5baa <printf>
        exit(1);
    1964:	4505                	li	a0,1
    1966:	00004097          	auipc	ra,0x4
    196a:	ecc080e7          	jalr	-308(ra) # 5832 <exit>
      exit(i);
    196e:	854a                	mv	a0,s2
    1970:	00004097          	auipc	ra,0x4
    1974:	ec2080e7          	jalr	-318(ra) # 5832 <exit>

0000000000001978 <twochildren>:
{
    1978:	1101                	addi	sp,sp,-32
    197a:	ec06                	sd	ra,24(sp)
    197c:	e822                	sd	s0,16(sp)
    197e:	e426                	sd	s1,8(sp)
    1980:	e04a                	sd	s2,0(sp)
    1982:	1000                	addi	s0,sp,32
    1984:	892a                	mv	s2,a0
    1986:	3e800493          	li	s1,1000
    int pid1 = fork();
    198a:	00004097          	auipc	ra,0x4
    198e:	ea0080e7          	jalr	-352(ra) # 582a <fork>
    if (pid1 < 0)
    1992:	02054c63          	bltz	a0,19ca <twochildren+0x52>
    if (pid1 == 0)
    1996:	c921                	beqz	a0,19e6 <twochildren+0x6e>
      int pid2 = fork();
    1998:	00004097          	auipc	ra,0x4
    199c:	e92080e7          	jalr	-366(ra) # 582a <fork>
      if (pid2 < 0)
    19a0:	04054763          	bltz	a0,19ee <twochildren+0x76>
      if (pid2 == 0)
    19a4:	c13d                	beqz	a0,1a0a <twochildren+0x92>
        wait(0);
    19a6:	4501                	li	a0,0
    19a8:	00004097          	auipc	ra,0x4
    19ac:	e92080e7          	jalr	-366(ra) # 583a <wait>
        wait(0);
    19b0:	4501                	li	a0,0
    19b2:	00004097          	auipc	ra,0x4
    19b6:	e88080e7          	jalr	-376(ra) # 583a <wait>
  for (int i = 0; i < 1000; i++)
    19ba:	34fd                	addiw	s1,s1,-1
    19bc:	f4f9                	bnez	s1,198a <twochildren+0x12>
}
    19be:	60e2                	ld	ra,24(sp)
    19c0:	6442                	ld	s0,16(sp)
    19c2:	64a2                	ld	s1,8(sp)
    19c4:	6902                	ld	s2,0(sp)
    19c6:	6105                	addi	sp,sp,32
    19c8:	8082                	ret
      printf("%s: fork failed\n", s);
    19ca:	85ca                	mv	a1,s2
    19cc:	00005517          	auipc	a0,0x5
    19d0:	f3450513          	addi	a0,a0,-204 # 6900 <malloc+0xc98>
    19d4:	00004097          	auipc	ra,0x4
    19d8:	1d6080e7          	jalr	470(ra) # 5baa <printf>
      exit(1);
    19dc:	4505                	li	a0,1
    19de:	00004097          	auipc	ra,0x4
    19e2:	e54080e7          	jalr	-428(ra) # 5832 <exit>
      exit(0);
    19e6:	00004097          	auipc	ra,0x4
    19ea:	e4c080e7          	jalr	-436(ra) # 5832 <exit>
        printf("%s: fork failed\n", s);
    19ee:	85ca                	mv	a1,s2
    19f0:	00005517          	auipc	a0,0x5
    19f4:	f1050513          	addi	a0,a0,-240 # 6900 <malloc+0xc98>
    19f8:	00004097          	auipc	ra,0x4
    19fc:	1b2080e7          	jalr	434(ra) # 5baa <printf>
        exit(1);
    1a00:	4505                	li	a0,1
    1a02:	00004097          	auipc	ra,0x4
    1a06:	e30080e7          	jalr	-464(ra) # 5832 <exit>
        exit(0);
    1a0a:	00004097          	auipc	ra,0x4
    1a0e:	e28080e7          	jalr	-472(ra) # 5832 <exit>

0000000000001a12 <forkfork>:
{
    1a12:	7179                	addi	sp,sp,-48
    1a14:	f406                	sd	ra,40(sp)
    1a16:	f022                	sd	s0,32(sp)
    1a18:	ec26                	sd	s1,24(sp)
    1a1a:	1800                	addi	s0,sp,48
    1a1c:	84aa                	mv	s1,a0
    int pid = fork();
    1a1e:	00004097          	auipc	ra,0x4
    1a22:	e0c080e7          	jalr	-500(ra) # 582a <fork>
    if (pid < 0)
    1a26:	04054163          	bltz	a0,1a68 <forkfork+0x56>
    if (pid == 0)
    1a2a:	cd29                	beqz	a0,1a84 <forkfork+0x72>
    int pid = fork();
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	dfe080e7          	jalr	-514(ra) # 582a <fork>
    if (pid < 0)
    1a34:	02054a63          	bltz	a0,1a68 <forkfork+0x56>
    if (pid == 0)
    1a38:	c531                	beqz	a0,1a84 <forkfork+0x72>
    wait(&xstatus);
    1a3a:	fdc40513          	addi	a0,s0,-36
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	dfc080e7          	jalr	-516(ra) # 583a <wait>
    if (xstatus != 0)
    1a46:	fdc42783          	lw	a5,-36(s0)
    1a4a:	ebbd                	bnez	a5,1ac0 <forkfork+0xae>
    wait(&xstatus);
    1a4c:	fdc40513          	addi	a0,s0,-36
    1a50:	00004097          	auipc	ra,0x4
    1a54:	dea080e7          	jalr	-534(ra) # 583a <wait>
    if (xstatus != 0)
    1a58:	fdc42783          	lw	a5,-36(s0)
    1a5c:	e3b5                	bnez	a5,1ac0 <forkfork+0xae>
}
    1a5e:	70a2                	ld	ra,40(sp)
    1a60:	7402                	ld	s0,32(sp)
    1a62:	64e2                	ld	s1,24(sp)
    1a64:	6145                	addi	sp,sp,48
    1a66:	8082                	ret
      printf("%s: fork failed", s);
    1a68:	85a6                	mv	a1,s1
    1a6a:	00005517          	auipc	a0,0x5
    1a6e:	05650513          	addi	a0,a0,86 # 6ac0 <malloc+0xe58>
    1a72:	00004097          	auipc	ra,0x4
    1a76:	138080e7          	jalr	312(ra) # 5baa <printf>
      exit(1);
    1a7a:	4505                	li	a0,1
    1a7c:	00004097          	auipc	ra,0x4
    1a80:	db6080e7          	jalr	-586(ra) # 5832 <exit>
{
    1a84:	0c800493          	li	s1,200
        int pid1 = fork();
    1a88:	00004097          	auipc	ra,0x4
    1a8c:	da2080e7          	jalr	-606(ra) # 582a <fork>
        if (pid1 < 0)
    1a90:	00054f63          	bltz	a0,1aae <forkfork+0x9c>
        if (pid1 == 0)
    1a94:	c115                	beqz	a0,1ab8 <forkfork+0xa6>
        wait(0);
    1a96:	4501                	li	a0,0
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	da2080e7          	jalr	-606(ra) # 583a <wait>
      for (int j = 0; j < 200; j++)
    1aa0:	34fd                	addiw	s1,s1,-1
    1aa2:	f0fd                	bnez	s1,1a88 <forkfork+0x76>
      exit(0);
    1aa4:	4501                	li	a0,0
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	d8c080e7          	jalr	-628(ra) # 5832 <exit>
          exit(1);
    1aae:	4505                	li	a0,1
    1ab0:	00004097          	auipc	ra,0x4
    1ab4:	d82080e7          	jalr	-638(ra) # 5832 <exit>
          exit(0);
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	d7a080e7          	jalr	-646(ra) # 5832 <exit>
      printf("%s: fork in child failed", s);
    1ac0:	85a6                	mv	a1,s1
    1ac2:	00005517          	auipc	a0,0x5
    1ac6:	00e50513          	addi	a0,a0,14 # 6ad0 <malloc+0xe68>
    1aca:	00004097          	auipc	ra,0x4
    1ace:	0e0080e7          	jalr	224(ra) # 5baa <printf>
      exit(1);
    1ad2:	4505                	li	a0,1
    1ad4:	00004097          	auipc	ra,0x4
    1ad8:	d5e080e7          	jalr	-674(ra) # 5832 <exit>

0000000000001adc <reparent2>:
{
    1adc:	1101                	addi	sp,sp,-32
    1ade:	ec06                	sd	ra,24(sp)
    1ae0:	e822                	sd	s0,16(sp)
    1ae2:	e426                	sd	s1,8(sp)
    1ae4:	1000                	addi	s0,sp,32
    1ae6:	32000493          	li	s1,800
    int pid1 = fork();
    1aea:	00004097          	auipc	ra,0x4
    1aee:	d40080e7          	jalr	-704(ra) # 582a <fork>
    if (pid1 < 0)
    1af2:	00054f63          	bltz	a0,1b10 <reparent2+0x34>
    if (pid1 == 0)
    1af6:	c915                	beqz	a0,1b2a <reparent2+0x4e>
    wait(0);
    1af8:	4501                	li	a0,0
    1afa:	00004097          	auipc	ra,0x4
    1afe:	d40080e7          	jalr	-704(ra) # 583a <wait>
  for (int i = 0; i < 800; i++)
    1b02:	34fd                	addiw	s1,s1,-1
    1b04:	f0fd                	bnez	s1,1aea <reparent2+0xe>
  exit(0);
    1b06:	4501                	li	a0,0
    1b08:	00004097          	auipc	ra,0x4
    1b0c:	d2a080e7          	jalr	-726(ra) # 5832 <exit>
      printf("fork failed\n");
    1b10:	00005517          	auipc	a0,0x5
    1b14:	21050513          	addi	a0,a0,528 # 6d20 <malloc+0x10b8>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	092080e7          	jalr	146(ra) # 5baa <printf>
      exit(1);
    1b20:	4505                	li	a0,1
    1b22:	00004097          	auipc	ra,0x4
    1b26:	d10080e7          	jalr	-752(ra) # 5832 <exit>
      fork();
    1b2a:	00004097          	auipc	ra,0x4
    1b2e:	d00080e7          	jalr	-768(ra) # 582a <fork>
      fork();
    1b32:	00004097          	auipc	ra,0x4
    1b36:	cf8080e7          	jalr	-776(ra) # 582a <fork>
      exit(0);
    1b3a:	4501                	li	a0,0
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	cf6080e7          	jalr	-778(ra) # 5832 <exit>

0000000000001b44 <createdelete>:
{
    1b44:	7175                	addi	sp,sp,-144
    1b46:	e506                	sd	ra,136(sp)
    1b48:	e122                	sd	s0,128(sp)
    1b4a:	fca6                	sd	s1,120(sp)
    1b4c:	f8ca                	sd	s2,112(sp)
    1b4e:	f4ce                	sd	s3,104(sp)
    1b50:	f0d2                	sd	s4,96(sp)
    1b52:	ecd6                	sd	s5,88(sp)
    1b54:	e8da                	sd	s6,80(sp)
    1b56:	e4de                	sd	s7,72(sp)
    1b58:	e0e2                	sd	s8,64(sp)
    1b5a:	fc66                	sd	s9,56(sp)
    1b5c:	0900                	addi	s0,sp,144
    1b5e:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++)
    1b60:	4901                	li	s2,0
    1b62:	4991                	li	s3,4
    pid = fork();
    1b64:	00004097          	auipc	ra,0x4
    1b68:	cc6080e7          	jalr	-826(ra) # 582a <fork>
    1b6c:	84aa                	mv	s1,a0
    if (pid < 0)
    1b6e:	02054f63          	bltz	a0,1bac <createdelete+0x68>
    if (pid == 0)
    1b72:	c939                	beqz	a0,1bc8 <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++)
    1b74:	2905                	addiw	s2,s2,1
    1b76:	ff3917e3          	bne	s2,s3,1b64 <createdelete+0x20>
    1b7a:	4491                	li	s1,4
    wait(&xstatus);
    1b7c:	f7c40513          	addi	a0,s0,-132
    1b80:	00004097          	auipc	ra,0x4
    1b84:	cba080e7          	jalr	-838(ra) # 583a <wait>
    if (xstatus != 0)
    1b88:	f7c42903          	lw	s2,-132(s0)
    1b8c:	0e091263          	bnez	s2,1c70 <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++)
    1b90:	34fd                	addiw	s1,s1,-1
    1b92:	f4ed                	bnez	s1,1b7c <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1b94:	f8040123          	sb	zero,-126(s0)
    1b98:	03000993          	li	s3,48
    1b9c:	5a7d                	li	s4,-1
    1b9e:	07000c13          	li	s8,112
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1ba2:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0)
    1ba4:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++)
    1ba6:	07400a93          	li	s5,116
    1baa:	a29d                	j	1d10 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bac:	85e6                	mv	a1,s9
    1bae:	00005517          	auipc	a0,0x5
    1bb2:	17250513          	addi	a0,a0,370 # 6d20 <malloc+0x10b8>
    1bb6:	00004097          	auipc	ra,0x4
    1bba:	ff4080e7          	jalr	-12(ra) # 5baa <printf>
      exit(1);
    1bbe:	4505                	li	a0,1
    1bc0:	00004097          	auipc	ra,0x4
    1bc4:	c72080e7          	jalr	-910(ra) # 5832 <exit>
      name[0] = 'p' + pi;
    1bc8:	0709091b          	addiw	s2,s2,112
    1bcc:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1bd0:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++)
    1bd4:	4951                	li	s2,20
    1bd6:	a015                	j	1bfa <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1bd8:	85e6                	mv	a1,s9
    1bda:	00005517          	auipc	a0,0x5
    1bde:	dbe50513          	addi	a0,a0,-578 # 6998 <malloc+0xd30>
    1be2:	00004097          	auipc	ra,0x4
    1be6:	fc8080e7          	jalr	-56(ra) # 5baa <printf>
          exit(1);
    1bea:	4505                	li	a0,1
    1bec:	00004097          	auipc	ra,0x4
    1bf0:	c46080e7          	jalr	-954(ra) # 5832 <exit>
      for (i = 0; i < N; i++)
    1bf4:	2485                	addiw	s1,s1,1
    1bf6:	07248863          	beq	s1,s2,1c66 <createdelete+0x122>
        name[1] = '0' + i;
    1bfa:	0304879b          	addiw	a5,s1,48
    1bfe:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c02:	20200593          	li	a1,514
    1c06:	f8040513          	addi	a0,s0,-128
    1c0a:	00004097          	auipc	ra,0x4
    1c0e:	c68080e7          	jalr	-920(ra) # 5872 <open>
        if (fd < 0)
    1c12:	fc0543e3          	bltz	a0,1bd8 <createdelete+0x94>
        close(fd);
    1c16:	00004097          	auipc	ra,0x4
    1c1a:	c44080e7          	jalr	-956(ra) # 585a <close>
        if (i > 0 && (i % 2) == 0)
    1c1e:	fc905be3          	blez	s1,1bf4 <createdelete+0xb0>
    1c22:	0014f793          	andi	a5,s1,1
    1c26:	f7f9                	bnez	a5,1bf4 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c28:	01f4d79b          	srliw	a5,s1,0x1f
    1c2c:	9fa5                	addw	a5,a5,s1
    1c2e:	4017d79b          	sraiw	a5,a5,0x1
    1c32:	0307879b          	addiw	a5,a5,48
    1c36:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0)
    1c3a:	f8040513          	addi	a0,s0,-128
    1c3e:	00004097          	auipc	ra,0x4
    1c42:	c44080e7          	jalr	-956(ra) # 5882 <unlink>
    1c46:	fa0557e3          	bgez	a0,1bf4 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c4a:	85e6                	mv	a1,s9
    1c4c:	00005517          	auipc	a0,0x5
    1c50:	ea450513          	addi	a0,a0,-348 # 6af0 <malloc+0xe88>
    1c54:	00004097          	auipc	ra,0x4
    1c58:	f56080e7          	jalr	-170(ra) # 5baa <printf>
            exit(1);
    1c5c:	4505                	li	a0,1
    1c5e:	00004097          	auipc	ra,0x4
    1c62:	bd4080e7          	jalr	-1068(ra) # 5832 <exit>
      exit(0);
    1c66:	4501                	li	a0,0
    1c68:	00004097          	auipc	ra,0x4
    1c6c:	bca080e7          	jalr	-1078(ra) # 5832 <exit>
      exit(1);
    1c70:	4505                	li	a0,1
    1c72:	00004097          	auipc	ra,0x4
    1c76:	bc0080e7          	jalr	-1088(ra) # 5832 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1c7a:	f8040613          	addi	a2,s0,-128
    1c7e:	85e6                	mv	a1,s9
    1c80:	00005517          	auipc	a0,0x5
    1c84:	e8850513          	addi	a0,a0,-376 # 6b08 <malloc+0xea0>
    1c88:	00004097          	auipc	ra,0x4
    1c8c:	f22080e7          	jalr	-222(ra) # 5baa <printf>
        exit(1);
    1c90:	4505                	li	a0,1
    1c92:	00004097          	auipc	ra,0x4
    1c96:	ba0080e7          	jalr	-1120(ra) # 5832 <exit>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1c9a:	054b7163          	bgeu	s6,s4,1cdc <createdelete+0x198>
      if (fd >= 0)
    1c9e:	02055a63          	bgez	a0,1cd2 <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++)
    1ca2:	2485                	addiw	s1,s1,1
    1ca4:	0ff4f493          	andi	s1,s1,255
    1ca8:	05548c63          	beq	s1,s5,1d00 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cac:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cb0:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cb4:	4581                	li	a1,0
    1cb6:	f8040513          	addi	a0,s0,-128
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	bb8080e7          	jalr	-1096(ra) # 5872 <open>
      if ((i == 0 || i >= N / 2) && fd < 0)
    1cc2:	00090463          	beqz	s2,1cca <createdelete+0x186>
    1cc6:	fd2bdae3          	bge	s7,s2,1c9a <createdelete+0x156>
    1cca:	fa0548e3          	bltz	a0,1c7a <createdelete+0x136>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1cce:	014b7963          	bgeu	s6,s4,1ce0 <createdelete+0x19c>
        close(fd);
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	b88080e7          	jalr	-1144(ra) # 585a <close>
    1cda:	b7e1                	j	1ca2 <createdelete+0x15e>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1cdc:	fc0543e3          	bltz	a0,1ca2 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1ce0:	f8040613          	addi	a2,s0,-128
    1ce4:	85e6                	mv	a1,s9
    1ce6:	00005517          	auipc	a0,0x5
    1cea:	e4a50513          	addi	a0,a0,-438 # 6b30 <malloc+0xec8>
    1cee:	00004097          	auipc	ra,0x4
    1cf2:	ebc080e7          	jalr	-324(ra) # 5baa <printf>
        exit(1);
    1cf6:	4505                	li	a0,1
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	b3a080e7          	jalr	-1222(ra) # 5832 <exit>
  for (i = 0; i < N; i++)
    1d00:	2905                	addiw	s2,s2,1
    1d02:	2a05                	addiw	s4,s4,1
    1d04:	2985                	addiw	s3,s3,1
    1d06:	0ff9f993          	andi	s3,s3,255
    1d0a:	47d1                	li	a5,20
    1d0c:	02f90a63          	beq	s2,a5,1d40 <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++)
    1d10:	84e2                	mv	s1,s8
    1d12:	bf69                	j	1cac <createdelete+0x168>
  for (i = 0; i < N; i++)
    1d14:	2905                	addiw	s2,s2,1
    1d16:	0ff97913          	andi	s2,s2,255
    1d1a:	2985                	addiw	s3,s3,1
    1d1c:	0ff9f993          	andi	s3,s3,255
    1d20:	03490863          	beq	s2,s4,1d50 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d24:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d26:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d2a:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d2e:	f8040513          	addi	a0,s0,-128
    1d32:	00004097          	auipc	ra,0x4
    1d36:	b50080e7          	jalr	-1200(ra) # 5882 <unlink>
    for (pi = 0; pi < NCHILD; pi++)
    1d3a:	34fd                	addiw	s1,s1,-1
    1d3c:	f4ed                	bnez	s1,1d26 <createdelete+0x1e2>
    1d3e:	bfd9                	j	1d14 <createdelete+0x1d0>
    1d40:	03000993          	li	s3,48
    1d44:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d48:	4a91                	li	s5,4
  for (i = 0; i < N; i++)
    1d4a:	08400a13          	li	s4,132
    1d4e:	bfd9                	j	1d24 <createdelete+0x1e0>
}
    1d50:	60aa                	ld	ra,136(sp)
    1d52:	640a                	ld	s0,128(sp)
    1d54:	74e6                	ld	s1,120(sp)
    1d56:	7946                	ld	s2,112(sp)
    1d58:	79a6                	ld	s3,104(sp)
    1d5a:	7a06                	ld	s4,96(sp)
    1d5c:	6ae6                	ld	s5,88(sp)
    1d5e:	6b46                	ld	s6,80(sp)
    1d60:	6ba6                	ld	s7,72(sp)
    1d62:	6c06                	ld	s8,64(sp)
    1d64:	7ce2                	ld	s9,56(sp)
    1d66:	6149                	addi	sp,sp,144
    1d68:	8082                	ret

0000000000001d6a <linkunlink>:
{
    1d6a:	711d                	addi	sp,sp,-96
    1d6c:	ec86                	sd	ra,88(sp)
    1d6e:	e8a2                	sd	s0,80(sp)
    1d70:	e4a6                	sd	s1,72(sp)
    1d72:	e0ca                	sd	s2,64(sp)
    1d74:	fc4e                	sd	s3,56(sp)
    1d76:	f852                	sd	s4,48(sp)
    1d78:	f456                	sd	s5,40(sp)
    1d7a:	f05a                	sd	s6,32(sp)
    1d7c:	ec5e                	sd	s7,24(sp)
    1d7e:	e862                	sd	s8,16(sp)
    1d80:	e466                	sd	s9,8(sp)
    1d82:	1080                	addi	s0,sp,96
    1d84:	84aa                	mv	s1,a0
  unlink("x");
    1d86:	00004517          	auipc	a0,0x4
    1d8a:	3b250513          	addi	a0,a0,946 # 6138 <malloc+0x4d0>
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	af4080e7          	jalr	-1292(ra) # 5882 <unlink>
  pid = fork();
    1d96:	00004097          	auipc	ra,0x4
    1d9a:	a94080e7          	jalr	-1388(ra) # 582a <fork>
  if (pid < 0)
    1d9e:	02054b63          	bltz	a0,1dd4 <linkunlink+0x6a>
    1da2:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1da4:	4c85                	li	s9,1
    1da6:	e119                	bnez	a0,1dac <linkunlink+0x42>
    1da8:	06100c93          	li	s9,97
    1dac:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1db0:	41c659b7          	lui	s3,0x41c65
    1db4:	e6d9899b          	addiw	s3,s3,-403
    1db8:	690d                	lui	s2,0x3
    1dba:	0399091b          	addiw	s2,s2,57
    if ((x % 3) == 0)
    1dbe:	4a0d                	li	s4,3
    else if ((x % 3) == 1)
    1dc0:	4b05                	li	s6,1
      unlink("x");
    1dc2:	00004a97          	auipc	s5,0x4
    1dc6:	376a8a93          	addi	s5,s5,886 # 6138 <malloc+0x4d0>
      link("cat", "x");
    1dca:	00005b97          	auipc	s7,0x5
    1dce:	d8eb8b93          	addi	s7,s7,-626 # 6b58 <malloc+0xef0>
    1dd2:	a091                	j	1e16 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1dd4:	85a6                	mv	a1,s1
    1dd6:	00005517          	auipc	a0,0x5
    1dda:	b2a50513          	addi	a0,a0,-1238 # 6900 <malloc+0xc98>
    1dde:	00004097          	auipc	ra,0x4
    1de2:	dcc080e7          	jalr	-564(ra) # 5baa <printf>
    exit(1);
    1de6:	4505                	li	a0,1
    1de8:	00004097          	auipc	ra,0x4
    1dec:	a4a080e7          	jalr	-1462(ra) # 5832 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1df0:	20200593          	li	a1,514
    1df4:	8556                	mv	a0,s5
    1df6:	00004097          	auipc	ra,0x4
    1dfa:	a7c080e7          	jalr	-1412(ra) # 5872 <open>
    1dfe:	00004097          	auipc	ra,0x4
    1e02:	a5c080e7          	jalr	-1444(ra) # 585a <close>
    1e06:	a031                	j	1e12 <linkunlink+0xa8>
      unlink("x");
    1e08:	8556                	mv	a0,s5
    1e0a:	00004097          	auipc	ra,0x4
    1e0e:	a78080e7          	jalr	-1416(ra) # 5882 <unlink>
  for (i = 0; i < 100; i++)
    1e12:	34fd                	addiw	s1,s1,-1
    1e14:	c09d                	beqz	s1,1e3a <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e16:	033c87bb          	mulw	a5,s9,s3
    1e1a:	012787bb          	addw	a5,a5,s2
    1e1e:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0)
    1e22:	0347f7bb          	remuw	a5,a5,s4
    1e26:	d7e9                	beqz	a5,1df0 <linkunlink+0x86>
    else if ((x % 3) == 1)
    1e28:	ff6790e3          	bne	a5,s6,1e08 <linkunlink+0x9e>
      link("cat", "x");
    1e2c:	85d6                	mv	a1,s5
    1e2e:	855e                	mv	a0,s7
    1e30:	00004097          	auipc	ra,0x4
    1e34:	a62080e7          	jalr	-1438(ra) # 5892 <link>
    1e38:	bfe9                	j	1e12 <linkunlink+0xa8>
  if (pid)
    1e3a:	020c0463          	beqz	s8,1e62 <linkunlink+0xf8>
    wait(0);
    1e3e:	4501                	li	a0,0
    1e40:	00004097          	auipc	ra,0x4
    1e44:	9fa080e7          	jalr	-1542(ra) # 583a <wait>
}
    1e48:	60e6                	ld	ra,88(sp)
    1e4a:	6446                	ld	s0,80(sp)
    1e4c:	64a6                	ld	s1,72(sp)
    1e4e:	6906                	ld	s2,64(sp)
    1e50:	79e2                	ld	s3,56(sp)
    1e52:	7a42                	ld	s4,48(sp)
    1e54:	7aa2                	ld	s5,40(sp)
    1e56:	7b02                	ld	s6,32(sp)
    1e58:	6be2                	ld	s7,24(sp)
    1e5a:	6c42                	ld	s8,16(sp)
    1e5c:	6ca2                	ld	s9,8(sp)
    1e5e:	6125                	addi	sp,sp,96
    1e60:	8082                	ret
    exit(0);
    1e62:	4501                	li	a0,0
    1e64:	00004097          	auipc	ra,0x4
    1e68:	9ce080e7          	jalr	-1586(ra) # 5832 <exit>

0000000000001e6c <manywrites>:
{
    1e6c:	711d                	addi	sp,sp,-96
    1e6e:	ec86                	sd	ra,88(sp)
    1e70:	e8a2                	sd	s0,80(sp)
    1e72:	e4a6                	sd	s1,72(sp)
    1e74:	e0ca                	sd	s2,64(sp)
    1e76:	fc4e                	sd	s3,56(sp)
    1e78:	f852                	sd	s4,48(sp)
    1e7a:	f456                	sd	s5,40(sp)
    1e7c:	f05a                	sd	s6,32(sp)
    1e7e:	ec5e                	sd	s7,24(sp)
    1e80:	1080                	addi	s0,sp,96
    1e82:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++)
    1e84:	4901                	li	s2,0
    1e86:	4991                	li	s3,4
    int pid = fork();
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	9a2080e7          	jalr	-1630(ra) # 582a <fork>
    1e90:	84aa                	mv	s1,a0
    if (pid < 0)
    1e92:	02054963          	bltz	a0,1ec4 <manywrites+0x58>
    if (pid == 0)
    1e96:	c521                	beqz	a0,1ede <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++)
    1e98:	2905                	addiw	s2,s2,1
    1e9a:	ff3917e3          	bne	s2,s3,1e88 <manywrites+0x1c>
    1e9e:	4491                	li	s1,4
    int st = 0;
    1ea0:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1ea4:	fa840513          	addi	a0,s0,-88
    1ea8:	00004097          	auipc	ra,0x4
    1eac:	992080e7          	jalr	-1646(ra) # 583a <wait>
    if (st != 0)
    1eb0:	fa842503          	lw	a0,-88(s0)
    1eb4:	ed6d                	bnez	a0,1fae <manywrites+0x142>
  for (int ci = 0; ci < nchildren; ci++)
    1eb6:	34fd                	addiw	s1,s1,-1
    1eb8:	f4e5                	bnez	s1,1ea0 <manywrites+0x34>
  exit(0);
    1eba:	4501                	li	a0,0
    1ebc:	00004097          	auipc	ra,0x4
    1ec0:	976080e7          	jalr	-1674(ra) # 5832 <exit>
      printf("fork failed\n");
    1ec4:	00005517          	auipc	a0,0x5
    1ec8:	e5c50513          	addi	a0,a0,-420 # 6d20 <malloc+0x10b8>
    1ecc:	00004097          	auipc	ra,0x4
    1ed0:	cde080e7          	jalr	-802(ra) # 5baa <printf>
      exit(1);
    1ed4:	4505                	li	a0,1
    1ed6:	00004097          	auipc	ra,0x4
    1eda:	95c080e7          	jalr	-1700(ra) # 5832 <exit>
      name[0] = 'b';
    1ede:	06200793          	li	a5,98
    1ee2:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1ee6:	0619079b          	addiw	a5,s2,97
    1eea:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1eee:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1ef2:	fa840513          	addi	a0,s0,-88
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	98c080e7          	jalr	-1652(ra) # 5882 <unlink>
    1efe:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1f00:	0000ab97          	auipc	s7,0xa
    1f04:	e20b8b93          	addi	s7,s7,-480 # bd20 <buf>
        for (int i = 0; i < ci + 1; i++)
    1f08:	8a26                	mv	s4,s1
    1f0a:	02094e63          	bltz	s2,1f46 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f0e:	20200593          	li	a1,514
    1f12:	fa840513          	addi	a0,s0,-88
    1f16:	00004097          	auipc	ra,0x4
    1f1a:	95c080e7          	jalr	-1700(ra) # 5872 <open>
    1f1e:	89aa                	mv	s3,a0
          if (fd < 0)
    1f20:	04054763          	bltz	a0,1f6e <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f24:	660d                	lui	a2,0x3
    1f26:	85de                	mv	a1,s7
    1f28:	00004097          	auipc	ra,0x4
    1f2c:	92a080e7          	jalr	-1750(ra) # 5852 <write>
          if (cc != sz)
    1f30:	678d                	lui	a5,0x3
    1f32:	04f51e63          	bne	a0,a5,1f8e <manywrites+0x122>
          close(fd);
    1f36:	854e                	mv	a0,s3
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	922080e7          	jalr	-1758(ra) # 585a <close>
        for (int i = 0; i < ci + 1; i++)
    1f40:	2a05                	addiw	s4,s4,1
    1f42:	fd4956e3          	bge	s2,s4,1f0e <manywrites+0xa2>
        unlink(name);
    1f46:	fa840513          	addi	a0,s0,-88
    1f4a:	00004097          	auipc	ra,0x4
    1f4e:	938080e7          	jalr	-1736(ra) # 5882 <unlink>
      for (int iters = 0; iters < howmany; iters++)
    1f52:	3b7d                	addiw	s6,s6,-1
    1f54:	fa0b1ae3          	bnez	s6,1f08 <manywrites+0x9c>
      unlink(name);
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	926080e7          	jalr	-1754(ra) # 5882 <unlink>
      exit(0);
    1f64:	4501                	li	a0,0
    1f66:	00004097          	auipc	ra,0x4
    1f6a:	8cc080e7          	jalr	-1844(ra) # 5832 <exit>
            printf("%s: cannot create %s\n", s, name);
    1f6e:	fa840613          	addi	a2,s0,-88
    1f72:	85d6                	mv	a1,s5
    1f74:	00005517          	auipc	a0,0x5
    1f78:	bec50513          	addi	a0,a0,-1044 # 6b60 <malloc+0xef8>
    1f7c:	00004097          	auipc	ra,0x4
    1f80:	c2e080e7          	jalr	-978(ra) # 5baa <printf>
            exit(1);
    1f84:	4505                	li	a0,1
    1f86:	00004097          	auipc	ra,0x4
    1f8a:	8ac080e7          	jalr	-1876(ra) # 5832 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1f8e:	86aa                	mv	a3,a0
    1f90:	660d                	lui	a2,0x3
    1f92:	85d6                	mv	a1,s5
    1f94:	00004517          	auipc	a0,0x4
    1f98:	1f450513          	addi	a0,a0,500 # 6188 <malloc+0x520>
    1f9c:	00004097          	auipc	ra,0x4
    1fa0:	c0e080e7          	jalr	-1010(ra) # 5baa <printf>
            exit(1);
    1fa4:	4505                	li	a0,1
    1fa6:	00004097          	auipc	ra,0x4
    1faa:	88c080e7          	jalr	-1908(ra) # 5832 <exit>
      exit(st);
    1fae:	00004097          	auipc	ra,0x4
    1fb2:	884080e7          	jalr	-1916(ra) # 5832 <exit>

0000000000001fb6 <forktest>:
{
    1fb6:	7179                	addi	sp,sp,-48
    1fb8:	f406                	sd	ra,40(sp)
    1fba:	f022                	sd	s0,32(sp)
    1fbc:	ec26                	sd	s1,24(sp)
    1fbe:	e84a                	sd	s2,16(sp)
    1fc0:	e44e                	sd	s3,8(sp)
    1fc2:	1800                	addi	s0,sp,48
    1fc4:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++)
    1fc6:	4481                	li	s1,0
    1fc8:	3e800913          	li	s2,1000
    pid = fork();
    1fcc:	00004097          	auipc	ra,0x4
    1fd0:	85e080e7          	jalr	-1954(ra) # 582a <fork>
    if (pid < 0)
    1fd4:	02054863          	bltz	a0,2004 <forktest+0x4e>
    if (pid == 0)
    1fd8:	c115                	beqz	a0,1ffc <forktest+0x46>
  for (n = 0; n < N; n++)
    1fda:	2485                	addiw	s1,s1,1
    1fdc:	ff2498e3          	bne	s1,s2,1fcc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1fe0:	85ce                	mv	a1,s3
    1fe2:	00005517          	auipc	a0,0x5
    1fe6:	bae50513          	addi	a0,a0,-1106 # 6b90 <malloc+0xf28>
    1fea:	00004097          	auipc	ra,0x4
    1fee:	bc0080e7          	jalr	-1088(ra) # 5baa <printf>
    exit(1);
    1ff2:	4505                	li	a0,1
    1ff4:	00004097          	auipc	ra,0x4
    1ff8:	83e080e7          	jalr	-1986(ra) # 5832 <exit>
      exit(0);
    1ffc:	00004097          	auipc	ra,0x4
    2000:	836080e7          	jalr	-1994(ra) # 5832 <exit>
  if (n == 0)
    2004:	cc9d                	beqz	s1,2042 <forktest+0x8c>
  if (n == N)
    2006:	3e800793          	li	a5,1000
    200a:	fcf48be3          	beq	s1,a5,1fe0 <forktest+0x2a>
  for (; n > 0; n--)
    200e:	00905b63          	blez	s1,2024 <forktest+0x6e>
    if (wait(0) < 0)
    2012:	4501                	li	a0,0
    2014:	00004097          	auipc	ra,0x4
    2018:	826080e7          	jalr	-2010(ra) # 583a <wait>
    201c:	04054163          	bltz	a0,205e <forktest+0xa8>
  for (; n > 0; n--)
    2020:	34fd                	addiw	s1,s1,-1
    2022:	f8e5                	bnez	s1,2012 <forktest+0x5c>
  if (wait(0) != -1)
    2024:	4501                	li	a0,0
    2026:	00004097          	auipc	ra,0x4
    202a:	814080e7          	jalr	-2028(ra) # 583a <wait>
    202e:	57fd                	li	a5,-1
    2030:	04f51563          	bne	a0,a5,207a <forktest+0xc4>
}
    2034:	70a2                	ld	ra,40(sp)
    2036:	7402                	ld	s0,32(sp)
    2038:	64e2                	ld	s1,24(sp)
    203a:	6942                	ld	s2,16(sp)
    203c:	69a2                	ld	s3,8(sp)
    203e:	6145                	addi	sp,sp,48
    2040:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2042:	85ce                	mv	a1,s3
    2044:	00005517          	auipc	a0,0x5
    2048:	b3450513          	addi	a0,a0,-1228 # 6b78 <malloc+0xf10>
    204c:	00004097          	auipc	ra,0x4
    2050:	b5e080e7          	jalr	-1186(ra) # 5baa <printf>
    exit(1);
    2054:	4505                	li	a0,1
    2056:	00003097          	auipc	ra,0x3
    205a:	7dc080e7          	jalr	2012(ra) # 5832 <exit>
      printf("%s: wait stopped early\n", s);
    205e:	85ce                	mv	a1,s3
    2060:	00005517          	auipc	a0,0x5
    2064:	b5850513          	addi	a0,a0,-1192 # 6bb8 <malloc+0xf50>
    2068:	00004097          	auipc	ra,0x4
    206c:	b42080e7          	jalr	-1214(ra) # 5baa <printf>
      exit(1);
    2070:	4505                	li	a0,1
    2072:	00003097          	auipc	ra,0x3
    2076:	7c0080e7          	jalr	1984(ra) # 5832 <exit>
    printf("%s: wait got too many\n", s);
    207a:	85ce                	mv	a1,s3
    207c:	00005517          	auipc	a0,0x5
    2080:	b5450513          	addi	a0,a0,-1196 # 6bd0 <malloc+0xf68>
    2084:	00004097          	auipc	ra,0x4
    2088:	b26080e7          	jalr	-1242(ra) # 5baa <printf>
    exit(1);
    208c:	4505                	li	a0,1
    208e:	00003097          	auipc	ra,0x3
    2092:	7a4080e7          	jalr	1956(ra) # 5832 <exit>

0000000000002096 <kernmem>:
{
    2096:	715d                	addi	sp,sp,-80
    2098:	e486                	sd	ra,72(sp)
    209a:	e0a2                	sd	s0,64(sp)
    209c:	fc26                	sd	s1,56(sp)
    209e:	f84a                	sd	s2,48(sp)
    20a0:	f44e                	sd	s3,40(sp)
    20a2:	f052                	sd	s4,32(sp)
    20a4:	ec56                	sd	s5,24(sp)
    20a6:	0880                	addi	s0,sp,80
    20a8:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    20aa:	4485                	li	s1,1
    20ac:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1) // did kernel kill child?
    20ae:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    20b0:	69b1                	lui	s3,0xc
    20b2:	35098993          	addi	s3,s3,848 # c350 <buf+0x630>
    20b6:	1003d937          	lui	s2,0x1003d
    20ba:	090e                	slli	s2,s2,0x3
    20bc:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e750>
    pid = fork();
    20c0:	00003097          	auipc	ra,0x3
    20c4:	76a080e7          	jalr	1898(ra) # 582a <fork>
    if (pid < 0)
    20c8:	02054963          	bltz	a0,20fa <kernmem+0x64>
    if (pid == 0)
    20cc:	c529                	beqz	a0,2116 <kernmem+0x80>
    wait(&xstatus);
    20ce:	fbc40513          	addi	a0,s0,-68
    20d2:	00003097          	auipc	ra,0x3
    20d6:	768080e7          	jalr	1896(ra) # 583a <wait>
    if (xstatus != -1) // did kernel kill child?
    20da:	fbc42783          	lw	a5,-68(s0)
    20de:	05579d63          	bne	a5,s5,2138 <kernmem+0xa2>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    20e2:	94ce                	add	s1,s1,s3
    20e4:	fd249ee3          	bne	s1,s2,20c0 <kernmem+0x2a>
}
    20e8:	60a6                	ld	ra,72(sp)
    20ea:	6406                	ld	s0,64(sp)
    20ec:	74e2                	ld	s1,56(sp)
    20ee:	7942                	ld	s2,48(sp)
    20f0:	79a2                	ld	s3,40(sp)
    20f2:	7a02                	ld	s4,32(sp)
    20f4:	6ae2                	ld	s5,24(sp)
    20f6:	6161                	addi	sp,sp,80
    20f8:	8082                	ret
      printf("%s: fork failed\n", s);
    20fa:	85d2                	mv	a1,s4
    20fc:	00005517          	auipc	a0,0x5
    2100:	80450513          	addi	a0,a0,-2044 # 6900 <malloc+0xc98>
    2104:	00004097          	auipc	ra,0x4
    2108:	aa6080e7          	jalr	-1370(ra) # 5baa <printf>
      exit(1);
    210c:	4505                	li	a0,1
    210e:	00003097          	auipc	ra,0x3
    2112:	724080e7          	jalr	1828(ra) # 5832 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2116:	0004c683          	lbu	a3,0(s1)
    211a:	8626                	mv	a2,s1
    211c:	85d2                	mv	a1,s4
    211e:	00005517          	auipc	a0,0x5
    2122:	aca50513          	addi	a0,a0,-1334 # 6be8 <malloc+0xf80>
    2126:	00004097          	auipc	ra,0x4
    212a:	a84080e7          	jalr	-1404(ra) # 5baa <printf>
      exit(1);
    212e:	4505                	li	a0,1
    2130:	00003097          	auipc	ra,0x3
    2134:	702080e7          	jalr	1794(ra) # 5832 <exit>
      exit(1);
    2138:	4505                	li	a0,1
    213a:	00003097          	auipc	ra,0x3
    213e:	6f8080e7          	jalr	1784(ra) # 5832 <exit>

0000000000002142 <MAXVAplus>:
{
    2142:	7179                	addi	sp,sp,-48
    2144:	f406                	sd	ra,40(sp)
    2146:	f022                	sd	s0,32(sp)
    2148:	ec26                	sd	s1,24(sp)
    214a:	e84a                	sd	s2,16(sp)
    214c:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    214e:	4785                	li	a5,1
    2150:	179a                	slli	a5,a5,0x26
    2152:	fcf43c23          	sd	a5,-40(s0)
  for (; a != 0; a <<= 1)
    2156:	fd843783          	ld	a5,-40(s0)
    215a:	cf85                	beqz	a5,2192 <MAXVAplus+0x50>
    215c:	892a                	mv	s2,a0
    if (xstatus != -1) // did kernel kill child?
    215e:	54fd                	li	s1,-1
    pid = fork();
    2160:	00003097          	auipc	ra,0x3
    2164:	6ca080e7          	jalr	1738(ra) # 582a <fork>
    if (pid < 0)
    2168:	02054b63          	bltz	a0,219e <MAXVAplus+0x5c>
    if (pid == 0)
    216c:	c539                	beqz	a0,21ba <MAXVAplus+0x78>
    wait(&xstatus);
    216e:	fd440513          	addi	a0,s0,-44
    2172:	00003097          	auipc	ra,0x3
    2176:	6c8080e7          	jalr	1736(ra) # 583a <wait>
    if (xstatus != -1) // did kernel kill child?
    217a:	fd442783          	lw	a5,-44(s0)
    217e:	06979463          	bne	a5,s1,21e6 <MAXVAplus+0xa4>
  for (; a != 0; a <<= 1)
    2182:	fd843783          	ld	a5,-40(s0)
    2186:	0786                	slli	a5,a5,0x1
    2188:	fcf43c23          	sd	a5,-40(s0)
    218c:	fd843783          	ld	a5,-40(s0)
    2190:	fbe1                	bnez	a5,2160 <MAXVAplus+0x1e>
}
    2192:	70a2                	ld	ra,40(sp)
    2194:	7402                	ld	s0,32(sp)
    2196:	64e2                	ld	s1,24(sp)
    2198:	6942                	ld	s2,16(sp)
    219a:	6145                	addi	sp,sp,48
    219c:	8082                	ret
      printf("%s: fork failed\n", s);
    219e:	85ca                	mv	a1,s2
    21a0:	00004517          	auipc	a0,0x4
    21a4:	76050513          	addi	a0,a0,1888 # 6900 <malloc+0xc98>
    21a8:	00004097          	auipc	ra,0x4
    21ac:	a02080e7          	jalr	-1534(ra) # 5baa <printf>
      exit(1);
    21b0:	4505                	li	a0,1
    21b2:	00003097          	auipc	ra,0x3
    21b6:	680080e7          	jalr	1664(ra) # 5832 <exit>
      *(char *)a = 99;
    21ba:	fd843783          	ld	a5,-40(s0)
    21be:	06300713          	li	a4,99
    21c2:	00e78023          	sb	a4,0(a5) # 3000 <dirtest+0x24>
      printf("%s: oops wrote %x\n", s, a);
    21c6:	fd843603          	ld	a2,-40(s0)
    21ca:	85ca                	mv	a1,s2
    21cc:	00005517          	auipc	a0,0x5
    21d0:	a3c50513          	addi	a0,a0,-1476 # 6c08 <malloc+0xfa0>
    21d4:	00004097          	auipc	ra,0x4
    21d8:	9d6080e7          	jalr	-1578(ra) # 5baa <printf>
      exit(1);
    21dc:	4505                	li	a0,1
    21de:	00003097          	auipc	ra,0x3
    21e2:	654080e7          	jalr	1620(ra) # 5832 <exit>
      exit(1);
    21e6:	4505                	li	a0,1
    21e8:	00003097          	auipc	ra,0x3
    21ec:	64a080e7          	jalr	1610(ra) # 5832 <exit>

00000000000021f0 <bigargtest>:
{
    21f0:	7179                	addi	sp,sp,-48
    21f2:	f406                	sd	ra,40(sp)
    21f4:	f022                	sd	s0,32(sp)
    21f6:	ec26                	sd	s1,24(sp)
    21f8:	1800                	addi	s0,sp,48
    21fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    21fc:	00005517          	auipc	a0,0x5
    2200:	a2450513          	addi	a0,a0,-1500 # 6c20 <malloc+0xfb8>
    2204:	00003097          	auipc	ra,0x3
    2208:	67e080e7          	jalr	1662(ra) # 5882 <unlink>
  pid = fork();
    220c:	00003097          	auipc	ra,0x3
    2210:	61e080e7          	jalr	1566(ra) # 582a <fork>
  if (pid == 0)
    2214:	c121                	beqz	a0,2254 <bigargtest+0x64>
  else if (pid < 0)
    2216:	0a054063          	bltz	a0,22b6 <bigargtest+0xc6>
  wait(&xstatus);
    221a:	fdc40513          	addi	a0,s0,-36
    221e:	00003097          	auipc	ra,0x3
    2222:	61c080e7          	jalr	1564(ra) # 583a <wait>
  if (xstatus != 0)
    2226:	fdc42503          	lw	a0,-36(s0)
    222a:	e545                	bnez	a0,22d2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    222c:	4581                	li	a1,0
    222e:	00005517          	auipc	a0,0x5
    2232:	9f250513          	addi	a0,a0,-1550 # 6c20 <malloc+0xfb8>
    2236:	00003097          	auipc	ra,0x3
    223a:	63c080e7          	jalr	1596(ra) # 5872 <open>
  if (fd < 0)
    223e:	08054e63          	bltz	a0,22da <bigargtest+0xea>
  close(fd);
    2242:	00003097          	auipc	ra,0x3
    2246:	618080e7          	jalr	1560(ra) # 585a <close>
}
    224a:	70a2                	ld	ra,40(sp)
    224c:	7402                	ld	s0,32(sp)
    224e:	64e2                	ld	s1,24(sp)
    2250:	6145                	addi	sp,sp,48
    2252:	8082                	ret
    2254:	00006797          	auipc	a5,0x6
    2258:	2b478793          	addi	a5,a5,692 # 8508 <args.1859>
    225c:	00006697          	auipc	a3,0x6
    2260:	3a468693          	addi	a3,a3,932 # 8600 <args.1859+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2264:	00005717          	auipc	a4,0x5
    2268:	9cc70713          	addi	a4,a4,-1588 # 6c30 <malloc+0xfc8>
    226c:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    226e:	07a1                	addi	a5,a5,8
    2270:	fed79ee3          	bne	a5,a3,226c <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    2274:	00006597          	auipc	a1,0x6
    2278:	29458593          	addi	a1,a1,660 # 8508 <args.1859>
    227c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2280:	00004517          	auipc	a0,0x4
    2284:	e4850513          	addi	a0,a0,-440 # 60c8 <malloc+0x460>
    2288:	00003097          	auipc	ra,0x3
    228c:	5e2080e7          	jalr	1506(ra) # 586a <exec>
    fd = open("bigarg-ok", O_CREATE);
    2290:	20000593          	li	a1,512
    2294:	00005517          	auipc	a0,0x5
    2298:	98c50513          	addi	a0,a0,-1652 # 6c20 <malloc+0xfb8>
    229c:	00003097          	auipc	ra,0x3
    22a0:	5d6080e7          	jalr	1494(ra) # 5872 <open>
    close(fd);
    22a4:	00003097          	auipc	ra,0x3
    22a8:	5b6080e7          	jalr	1462(ra) # 585a <close>
    exit(0);
    22ac:	4501                	li	a0,0
    22ae:	00003097          	auipc	ra,0x3
    22b2:	584080e7          	jalr	1412(ra) # 5832 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22b6:	85a6                	mv	a1,s1
    22b8:	00005517          	auipc	a0,0x5
    22bc:	a5850513          	addi	a0,a0,-1448 # 6d10 <malloc+0x10a8>
    22c0:	00004097          	auipc	ra,0x4
    22c4:	8ea080e7          	jalr	-1814(ra) # 5baa <printf>
    exit(1);
    22c8:	4505                	li	a0,1
    22ca:	00003097          	auipc	ra,0x3
    22ce:	568080e7          	jalr	1384(ra) # 5832 <exit>
    exit(xstatus);
    22d2:	00003097          	auipc	ra,0x3
    22d6:	560080e7          	jalr	1376(ra) # 5832 <exit>
    printf("%s: bigarg test failed!\n", s);
    22da:	85a6                	mv	a1,s1
    22dc:	00005517          	auipc	a0,0x5
    22e0:	a5450513          	addi	a0,a0,-1452 # 6d30 <malloc+0x10c8>
    22e4:	00004097          	auipc	ra,0x4
    22e8:	8c6080e7          	jalr	-1850(ra) # 5baa <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	00003097          	auipc	ra,0x3
    22f2:	544080e7          	jalr	1348(ra) # 5832 <exit>

00000000000022f6 <stacktest>:
{
    22f6:	7179                	addi	sp,sp,-48
    22f8:	f406                	sd	ra,40(sp)
    22fa:	f022                	sd	s0,32(sp)
    22fc:	ec26                	sd	s1,24(sp)
    22fe:	1800                	addi	s0,sp,48
    2300:	84aa                	mv	s1,a0
  pid = fork();
    2302:	00003097          	auipc	ra,0x3
    2306:	528080e7          	jalr	1320(ra) # 582a <fork>
  if (pid == 0)
    230a:	c115                	beqz	a0,232e <stacktest+0x38>
  else if (pid < 0)
    230c:	04054463          	bltz	a0,2354 <stacktest+0x5e>
  wait(&xstatus);
    2310:	fdc40513          	addi	a0,s0,-36
    2314:	00003097          	auipc	ra,0x3
    2318:	526080e7          	jalr	1318(ra) # 583a <wait>
  if (xstatus == -1) // kernel killed child?
    231c:	fdc42503          	lw	a0,-36(s0)
    2320:	57fd                	li	a5,-1
    2322:	04f50763          	beq	a0,a5,2370 <stacktest+0x7a>
    exit(xstatus);
    2326:	00003097          	auipc	ra,0x3
    232a:	50c080e7          	jalr	1292(ra) # 5832 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp"
    232e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2330:	77fd                	lui	a5,0xfffff
    2332:	97ba                	add	a5,a5,a4
    2334:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff02d0>
    2338:	85a6                	mv	a1,s1
    233a:	00005517          	auipc	a0,0x5
    233e:	a1650513          	addi	a0,a0,-1514 # 6d50 <malloc+0x10e8>
    2342:	00004097          	auipc	ra,0x4
    2346:	868080e7          	jalr	-1944(ra) # 5baa <printf>
    exit(1);
    234a:	4505                	li	a0,1
    234c:	00003097          	auipc	ra,0x3
    2350:	4e6080e7          	jalr	1254(ra) # 5832 <exit>
    printf("%s: fork failed\n", s);
    2354:	85a6                	mv	a1,s1
    2356:	00004517          	auipc	a0,0x4
    235a:	5aa50513          	addi	a0,a0,1450 # 6900 <malloc+0xc98>
    235e:	00004097          	auipc	ra,0x4
    2362:	84c080e7          	jalr	-1972(ra) # 5baa <printf>
    exit(1);
    2366:	4505                	li	a0,1
    2368:	00003097          	auipc	ra,0x3
    236c:	4ca080e7          	jalr	1226(ra) # 5832 <exit>
    exit(0);
    2370:	4501                	li	a0,0
    2372:	00003097          	auipc	ra,0x3
    2376:	4c0080e7          	jalr	1216(ra) # 5832 <exit>

000000000000237a <copyinstr3>:
{
    237a:	7179                	addi	sp,sp,-48
    237c:	f406                	sd	ra,40(sp)
    237e:	f022                	sd	s0,32(sp)
    2380:	ec26                	sd	s1,24(sp)
    2382:	1800                	addi	s0,sp,48
  sbrk(8192);
    2384:	6509                	lui	a0,0x2
    2386:	00003097          	auipc	ra,0x3
    238a:	534080e7          	jalr	1332(ra) # 58ba <sbrk>
  uint64 top = (uint64)sbrk(0);
    238e:	4501                	li	a0,0
    2390:	00003097          	auipc	ra,0x3
    2394:	52a080e7          	jalr	1322(ra) # 58ba <sbrk>
  if ((top % PGSIZE) != 0)
    2398:	03451793          	slli	a5,a0,0x34
    239c:	e3c9                	bnez	a5,241e <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    239e:	4501                	li	a0,0
    23a0:	00003097          	auipc	ra,0x3
    23a4:	51a080e7          	jalr	1306(ra) # 58ba <sbrk>
  if (top % PGSIZE)
    23a8:	03451793          	slli	a5,a0,0x34
    23ac:	e3d9                	bnez	a5,2432 <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    23ae:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x49>
  *b = 'x';
    23b2:	07800793          	li	a5,120
    23b6:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    23ba:	8526                	mv	a0,s1
    23bc:	00003097          	auipc	ra,0x3
    23c0:	4c6080e7          	jalr	1222(ra) # 5882 <unlink>
  if (ret != -1)
    23c4:	57fd                	li	a5,-1
    23c6:	08f51363          	bne	a0,a5,244c <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    23ca:	20100593          	li	a1,513
    23ce:	8526                	mv	a0,s1
    23d0:	00003097          	auipc	ra,0x3
    23d4:	4a2080e7          	jalr	1186(ra) # 5872 <open>
  if (fd != -1)
    23d8:	57fd                	li	a5,-1
    23da:	08f51863          	bne	a0,a5,246a <copyinstr3+0xf0>
  ret = link(b, b);
    23de:	85a6                	mv	a1,s1
    23e0:	8526                	mv	a0,s1
    23e2:	00003097          	auipc	ra,0x3
    23e6:	4b0080e7          	jalr	1200(ra) # 5892 <link>
  if (ret != -1)
    23ea:	57fd                	li	a5,-1
    23ec:	08f51e63          	bne	a0,a5,2488 <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    23f0:	00005797          	auipc	a5,0x5
    23f4:	5f878793          	addi	a5,a5,1528 # 79e8 <malloc+0x1d80>
    23f8:	fcf43823          	sd	a5,-48(s0)
    23fc:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2400:	fd040593          	addi	a1,s0,-48
    2404:	8526                	mv	a0,s1
    2406:	00003097          	auipc	ra,0x3
    240a:	464080e7          	jalr	1124(ra) # 586a <exec>
  if (ret != -1)
    240e:	57fd                	li	a5,-1
    2410:	08f51c63          	bne	a0,a5,24a8 <copyinstr3+0x12e>
}
    2414:	70a2                	ld	ra,40(sp)
    2416:	7402                	ld	s0,32(sp)
    2418:	64e2                	ld	s1,24(sp)
    241a:	6145                	addi	sp,sp,48
    241c:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    241e:	0347d513          	srli	a0,a5,0x34
    2422:	6785                	lui	a5,0x1
    2424:	40a7853b          	subw	a0,a5,a0
    2428:	00003097          	auipc	ra,0x3
    242c:	492080e7          	jalr	1170(ra) # 58ba <sbrk>
    2430:	b7bd                	j	239e <copyinstr3+0x24>
    printf("oops\n");
    2432:	00005517          	auipc	a0,0x5
    2436:	94650513          	addi	a0,a0,-1722 # 6d78 <malloc+0x1110>
    243a:	00003097          	auipc	ra,0x3
    243e:	770080e7          	jalr	1904(ra) # 5baa <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	00003097          	auipc	ra,0x3
    2448:	3ee080e7          	jalr	1006(ra) # 5832 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    244c:	862a                	mv	a2,a0
    244e:	85a6                	mv	a1,s1
    2450:	00004517          	auipc	a0,0x4
    2454:	3d050513          	addi	a0,a0,976 # 6820 <malloc+0xbb8>
    2458:	00003097          	auipc	ra,0x3
    245c:	752080e7          	jalr	1874(ra) # 5baa <printf>
    exit(1);
    2460:	4505                	li	a0,1
    2462:	00003097          	auipc	ra,0x3
    2466:	3d0080e7          	jalr	976(ra) # 5832 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    246a:	862a                	mv	a2,a0
    246c:	85a6                	mv	a1,s1
    246e:	00004517          	auipc	a0,0x4
    2472:	3d250513          	addi	a0,a0,978 # 6840 <malloc+0xbd8>
    2476:	00003097          	auipc	ra,0x3
    247a:	734080e7          	jalr	1844(ra) # 5baa <printf>
    exit(1);
    247e:	4505                	li	a0,1
    2480:	00003097          	auipc	ra,0x3
    2484:	3b2080e7          	jalr	946(ra) # 5832 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2488:	86aa                	mv	a3,a0
    248a:	8626                	mv	a2,s1
    248c:	85a6                	mv	a1,s1
    248e:	00004517          	auipc	a0,0x4
    2492:	3d250513          	addi	a0,a0,978 # 6860 <malloc+0xbf8>
    2496:	00003097          	auipc	ra,0x3
    249a:	714080e7          	jalr	1812(ra) # 5baa <printf>
    exit(1);
    249e:	4505                	li	a0,1
    24a0:	00003097          	auipc	ra,0x3
    24a4:	392080e7          	jalr	914(ra) # 5832 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    24a8:	567d                	li	a2,-1
    24aa:	85a6                	mv	a1,s1
    24ac:	00004517          	auipc	a0,0x4
    24b0:	3dc50513          	addi	a0,a0,988 # 6888 <malloc+0xc20>
    24b4:	00003097          	auipc	ra,0x3
    24b8:	6f6080e7          	jalr	1782(ra) # 5baa <printf>
    exit(1);
    24bc:	4505                	li	a0,1
    24be:	00003097          	auipc	ra,0x3
    24c2:	374080e7          	jalr	884(ra) # 5832 <exit>

00000000000024c6 <rwsbrk>:
{
    24c6:	1101                	addi	sp,sp,-32
    24c8:	ec06                	sd	ra,24(sp)
    24ca:	e822                	sd	s0,16(sp)
    24cc:	e426                	sd	s1,8(sp)
    24ce:	e04a                	sd	s2,0(sp)
    24d0:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    24d2:	6509                	lui	a0,0x2
    24d4:	00003097          	auipc	ra,0x3
    24d8:	3e6080e7          	jalr	998(ra) # 58ba <sbrk>
  if (a == 0xffffffffffffffffLL)
    24dc:	57fd                	li	a5,-1
    24de:	06f50363          	beq	a0,a5,2544 <rwsbrk+0x7e>
    24e2:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL)
    24e4:	7579                	lui	a0,0xffffe
    24e6:	00003097          	auipc	ra,0x3
    24ea:	3d4080e7          	jalr	980(ra) # 58ba <sbrk>
    24ee:	57fd                	li	a5,-1
    24f0:	06f50763          	beq	a0,a5,255e <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    24f4:	20100593          	li	a1,513
    24f8:	00004517          	auipc	a0,0x4
    24fc:	8e050513          	addi	a0,a0,-1824 # 5dd8 <malloc+0x170>
    2500:	00003097          	auipc	ra,0x3
    2504:	372080e7          	jalr	882(ra) # 5872 <open>
    2508:	892a                	mv	s2,a0
  if (fd < 0)
    250a:	06054763          	bltz	a0,2578 <rwsbrk+0xb2>
  n = write(fd, (void *)(a + 4096), 1024);
    250e:	6505                	lui	a0,0x1
    2510:	94aa                	add	s1,s1,a0
    2512:	40000613          	li	a2,1024
    2516:	85a6                	mv	a1,s1
    2518:	854a                	mv	a0,s2
    251a:	00003097          	auipc	ra,0x3
    251e:	338080e7          	jalr	824(ra) # 5852 <write>
    2522:	862a                	mv	a2,a0
  if (n >= 0)
    2524:	06054763          	bltz	a0,2592 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    2528:	85a6                	mv	a1,s1
    252a:	00005517          	auipc	a0,0x5
    252e:	8a650513          	addi	a0,a0,-1882 # 6dd0 <malloc+0x1168>
    2532:	00003097          	auipc	ra,0x3
    2536:	678080e7          	jalr	1656(ra) # 5baa <printf>
    exit(1);
    253a:	4505                	li	a0,1
    253c:	00003097          	auipc	ra,0x3
    2540:	2f6080e7          	jalr	758(ra) # 5832 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2544:	00005517          	auipc	a0,0x5
    2548:	83c50513          	addi	a0,a0,-1988 # 6d80 <malloc+0x1118>
    254c:	00003097          	auipc	ra,0x3
    2550:	65e080e7          	jalr	1630(ra) # 5baa <printf>
    exit(1);
    2554:	4505                	li	a0,1
    2556:	00003097          	auipc	ra,0x3
    255a:	2dc080e7          	jalr	732(ra) # 5832 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    255e:	00005517          	auipc	a0,0x5
    2562:	83a50513          	addi	a0,a0,-1990 # 6d98 <malloc+0x1130>
    2566:	00003097          	auipc	ra,0x3
    256a:	644080e7          	jalr	1604(ra) # 5baa <printf>
    exit(1);
    256e:	4505                	li	a0,1
    2570:	00003097          	auipc	ra,0x3
    2574:	2c2080e7          	jalr	706(ra) # 5832 <exit>
    printf("open(rwsbrk) failed\n");
    2578:	00005517          	auipc	a0,0x5
    257c:	84050513          	addi	a0,a0,-1984 # 6db8 <malloc+0x1150>
    2580:	00003097          	auipc	ra,0x3
    2584:	62a080e7          	jalr	1578(ra) # 5baa <printf>
    exit(1);
    2588:	4505                	li	a0,1
    258a:	00003097          	auipc	ra,0x3
    258e:	2a8080e7          	jalr	680(ra) # 5832 <exit>
  close(fd);
    2592:	854a                	mv	a0,s2
    2594:	00003097          	auipc	ra,0x3
    2598:	2c6080e7          	jalr	710(ra) # 585a <close>
  unlink("rwsbrk");
    259c:	00004517          	auipc	a0,0x4
    25a0:	83c50513          	addi	a0,a0,-1988 # 5dd8 <malloc+0x170>
    25a4:	00003097          	auipc	ra,0x3
    25a8:	2de080e7          	jalr	734(ra) # 5882 <unlink>
  fd = open("README", O_RDONLY);
    25ac:	4581                	li	a1,0
    25ae:	00004517          	auipc	a0,0x4
    25b2:	cb250513          	addi	a0,a0,-846 # 6260 <malloc+0x5f8>
    25b6:	00003097          	auipc	ra,0x3
    25ba:	2bc080e7          	jalr	700(ra) # 5872 <open>
    25be:	892a                	mv	s2,a0
  if (fd < 0)
    25c0:	02054963          	bltz	a0,25f2 <rwsbrk+0x12c>
  n = read(fd, (void *)(a + 4096), 10);
    25c4:	4629                	li	a2,10
    25c6:	85a6                	mv	a1,s1
    25c8:	00003097          	auipc	ra,0x3
    25cc:	282080e7          	jalr	642(ra) # 584a <read>
    25d0:	862a                	mv	a2,a0
  if (n >= 0)
    25d2:	02054d63          	bltz	a0,260c <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    25d6:	85a6                	mv	a1,s1
    25d8:	00005517          	auipc	a0,0x5
    25dc:	82850513          	addi	a0,a0,-2008 # 6e00 <malloc+0x1198>
    25e0:	00003097          	auipc	ra,0x3
    25e4:	5ca080e7          	jalr	1482(ra) # 5baa <printf>
    exit(1);
    25e8:	4505                	li	a0,1
    25ea:	00003097          	auipc	ra,0x3
    25ee:	248080e7          	jalr	584(ra) # 5832 <exit>
    printf("open(rwsbrk) failed\n");
    25f2:	00004517          	auipc	a0,0x4
    25f6:	7c650513          	addi	a0,a0,1990 # 6db8 <malloc+0x1150>
    25fa:	00003097          	auipc	ra,0x3
    25fe:	5b0080e7          	jalr	1456(ra) # 5baa <printf>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	22e080e7          	jalr	558(ra) # 5832 <exit>
  close(fd);
    260c:	854a                	mv	a0,s2
    260e:	00003097          	auipc	ra,0x3
    2612:	24c080e7          	jalr	588(ra) # 585a <close>
  exit(0);
    2616:	4501                	li	a0,0
    2618:	00003097          	auipc	ra,0x3
    261c:	21a080e7          	jalr	538(ra) # 5832 <exit>

0000000000002620 <sbrkbasic>:
{
    2620:	715d                	addi	sp,sp,-80
    2622:	e486                	sd	ra,72(sp)
    2624:	e0a2                	sd	s0,64(sp)
    2626:	fc26                	sd	s1,56(sp)
    2628:	f84a                	sd	s2,48(sp)
    262a:	f44e                	sd	s3,40(sp)
    262c:	f052                	sd	s4,32(sp)
    262e:	ec56                	sd	s5,24(sp)
    2630:	0880                	addi	s0,sp,80
    2632:	8a2a                	mv	s4,a0
  pid = fork();
    2634:	00003097          	auipc	ra,0x3
    2638:	1f6080e7          	jalr	502(ra) # 582a <fork>
  if (pid < 0)
    263c:	02054c63          	bltz	a0,2674 <sbrkbasic+0x54>
  if (pid == 0)
    2640:	ed21                	bnez	a0,2698 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    2642:	40000537          	lui	a0,0x40000
    2646:	00003097          	auipc	ra,0x3
    264a:	274080e7          	jalr	628(ra) # 58ba <sbrk>
    if (a == (char *)0xffffffffffffffffL)
    264e:	57fd                	li	a5,-1
    2650:	02f50f63          	beq	a0,a5,268e <sbrkbasic+0x6e>
    for (b = a; b < a + TOOMUCH; b += 4096)
    2654:	400007b7          	lui	a5,0x40000
    2658:	97aa                	add	a5,a5,a0
      *b = 99;
    265a:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096)
    265e:	6705                	lui	a4,0x1
      *b = 99;
    2660:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff12d0>
    for (b = a; b < a + TOOMUCH; b += 4096)
    2664:	953a                	add	a0,a0,a4
    2666:	fef51de3          	bne	a0,a5,2660 <sbrkbasic+0x40>
    exit(1);
    266a:	4505                	li	a0,1
    266c:	00003097          	auipc	ra,0x3
    2670:	1c6080e7          	jalr	454(ra) # 5832 <exit>
    printf("fork failed in sbrkbasic\n");
    2674:	00004517          	auipc	a0,0x4
    2678:	7b450513          	addi	a0,a0,1972 # 6e28 <malloc+0x11c0>
    267c:	00003097          	auipc	ra,0x3
    2680:	52e080e7          	jalr	1326(ra) # 5baa <printf>
    exit(1);
    2684:	4505                	li	a0,1
    2686:	00003097          	auipc	ra,0x3
    268a:	1ac080e7          	jalr	428(ra) # 5832 <exit>
      exit(0);
    268e:	4501                	li	a0,0
    2690:	00003097          	auipc	ra,0x3
    2694:	1a2080e7          	jalr	418(ra) # 5832 <exit>
  wait(&xstatus);
    2698:	fbc40513          	addi	a0,s0,-68
    269c:	00003097          	auipc	ra,0x3
    26a0:	19e080e7          	jalr	414(ra) # 583a <wait>
  if (xstatus == 1)
    26a4:	fbc42703          	lw	a4,-68(s0)
    26a8:	4785                	li	a5,1
    26aa:	00f70e63          	beq	a4,a5,26c6 <sbrkbasic+0xa6>
  a = sbrk(0);
    26ae:	4501                	li	a0,0
    26b0:	00003097          	auipc	ra,0x3
    26b4:	20a080e7          	jalr	522(ra) # 58ba <sbrk>
    26b8:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++)
    26ba:	4901                	li	s2,0
    *b = 1;
    26bc:	4a85                	li	s5,1
  for (i = 0; i < 5000; i++)
    26be:	6985                	lui	s3,0x1
    26c0:	38898993          	addi	s3,s3,904 # 1388 <truncate3+0x26>
    26c4:	a005                	j	26e4 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    26c6:	85d2                	mv	a1,s4
    26c8:	00004517          	auipc	a0,0x4
    26cc:	78050513          	addi	a0,a0,1920 # 6e48 <malloc+0x11e0>
    26d0:	00003097          	auipc	ra,0x3
    26d4:	4da080e7          	jalr	1242(ra) # 5baa <printf>
    exit(1);
    26d8:	4505                	li	a0,1
    26da:	00003097          	auipc	ra,0x3
    26de:	158080e7          	jalr	344(ra) # 5832 <exit>
    a = b + 1;
    26e2:	84be                	mv	s1,a5
    b = sbrk(1);
    26e4:	4505                	li	a0,1
    26e6:	00003097          	auipc	ra,0x3
    26ea:	1d4080e7          	jalr	468(ra) # 58ba <sbrk>
    if (b != a)
    26ee:	04951b63          	bne	a0,s1,2744 <sbrkbasic+0x124>
    *b = 1;
    26f2:	01548023          	sb	s5,0(s1)
    a = b + 1;
    26f6:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++)
    26fa:	2905                	addiw	s2,s2,1
    26fc:	ff3913e3          	bne	s2,s3,26e2 <sbrkbasic+0xc2>
  pid = fork();
    2700:	00003097          	auipc	ra,0x3
    2704:	12a080e7          	jalr	298(ra) # 582a <fork>
    2708:	892a                	mv	s2,a0
  if (pid < 0)
    270a:	04054e63          	bltz	a0,2766 <sbrkbasic+0x146>
  c = sbrk(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	1aa080e7          	jalr	426(ra) # 58ba <sbrk>
  c = sbrk(1);
    2718:	4505                	li	a0,1
    271a:	00003097          	auipc	ra,0x3
    271e:	1a0080e7          	jalr	416(ra) # 58ba <sbrk>
  if (c != a + 1)
    2722:	0489                	addi	s1,s1,2
    2724:	04a48f63          	beq	s1,a0,2782 <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    2728:	85d2                	mv	a1,s4
    272a:	00004517          	auipc	a0,0x4
    272e:	77e50513          	addi	a0,a0,1918 # 6ea8 <malloc+0x1240>
    2732:	00003097          	auipc	ra,0x3
    2736:	478080e7          	jalr	1144(ra) # 5baa <printf>
    exit(1);
    273a:	4505                	li	a0,1
    273c:	00003097          	auipc	ra,0x3
    2740:	0f6080e7          	jalr	246(ra) # 5832 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2744:	872a                	mv	a4,a0
    2746:	86a6                	mv	a3,s1
    2748:	864a                	mv	a2,s2
    274a:	85d2                	mv	a1,s4
    274c:	00004517          	auipc	a0,0x4
    2750:	71c50513          	addi	a0,a0,1820 # 6e68 <malloc+0x1200>
    2754:	00003097          	auipc	ra,0x3
    2758:	456080e7          	jalr	1110(ra) # 5baa <printf>
      exit(1);
    275c:	4505                	li	a0,1
    275e:	00003097          	auipc	ra,0x3
    2762:	0d4080e7          	jalr	212(ra) # 5832 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2766:	85d2                	mv	a1,s4
    2768:	00004517          	auipc	a0,0x4
    276c:	72050513          	addi	a0,a0,1824 # 6e88 <malloc+0x1220>
    2770:	00003097          	auipc	ra,0x3
    2774:	43a080e7          	jalr	1082(ra) # 5baa <printf>
    exit(1);
    2778:	4505                	li	a0,1
    277a:	00003097          	auipc	ra,0x3
    277e:	0b8080e7          	jalr	184(ra) # 5832 <exit>
  if (pid == 0)
    2782:	00091763          	bnez	s2,2790 <sbrkbasic+0x170>
    exit(0);
    2786:	4501                	li	a0,0
    2788:	00003097          	auipc	ra,0x3
    278c:	0aa080e7          	jalr	170(ra) # 5832 <exit>
  wait(&xstatus);
    2790:	fbc40513          	addi	a0,s0,-68
    2794:	00003097          	auipc	ra,0x3
    2798:	0a6080e7          	jalr	166(ra) # 583a <wait>
  exit(xstatus);
    279c:	fbc42503          	lw	a0,-68(s0)
    27a0:	00003097          	auipc	ra,0x3
    27a4:	092080e7          	jalr	146(ra) # 5832 <exit>

00000000000027a8 <sbrkmuch>:
{
    27a8:	7179                	addi	sp,sp,-48
    27aa:	f406                	sd	ra,40(sp)
    27ac:	f022                	sd	s0,32(sp)
    27ae:	ec26                	sd	s1,24(sp)
    27b0:	e84a                	sd	s2,16(sp)
    27b2:	e44e                	sd	s3,8(sp)
    27b4:	e052                	sd	s4,0(sp)
    27b6:	1800                	addi	s0,sp,48
    27b8:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    27ba:	4501                	li	a0,0
    27bc:	00003097          	auipc	ra,0x3
    27c0:	0fe080e7          	jalr	254(ra) # 58ba <sbrk>
    27c4:	892a                	mv	s2,a0
  a = sbrk(0);
    27c6:	4501                	li	a0,0
    27c8:	00003097          	auipc	ra,0x3
    27cc:	0f2080e7          	jalr	242(ra) # 58ba <sbrk>
    27d0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    27d2:	06400537          	lui	a0,0x6400
    27d6:	9d05                	subw	a0,a0,s1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	0e2080e7          	jalr	226(ra) # 58ba <sbrk>
  if (p != a)
    27e0:	0ca49863          	bne	s1,a0,28b0 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    27e4:	4501                	li	a0,0
    27e6:	00003097          	auipc	ra,0x3
    27ea:	0d4080e7          	jalr	212(ra) # 58ba <sbrk>
    27ee:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096)
    27f0:	00a4f963          	bgeu	s1,a0,2802 <sbrkmuch+0x5a>
    *pp = 1;
    27f4:	4685                	li	a3,1
  for (char *pp = a; pp < eee; pp += 4096)
    27f6:	6705                	lui	a4,0x1
    *pp = 1;
    27f8:	00d48023          	sb	a3,0(s1)
  for (char *pp = a; pp < eee; pp += 4096)
    27fc:	94ba                	add	s1,s1,a4
    27fe:	fef4ede3          	bltu	s1,a5,27f8 <sbrkmuch+0x50>
  *lastaddr = 99;
    2802:	064007b7          	lui	a5,0x6400
    2806:	06300713          	li	a4,99
    280a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f12cf>
  a = sbrk(0);
    280e:	4501                	li	a0,0
    2810:	00003097          	auipc	ra,0x3
    2814:	0aa080e7          	jalr	170(ra) # 58ba <sbrk>
    2818:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    281a:	757d                	lui	a0,0xfffff
    281c:	00003097          	auipc	ra,0x3
    2820:	09e080e7          	jalr	158(ra) # 58ba <sbrk>
  if (c == (char *)0xffffffffffffffffL)
    2824:	57fd                	li	a5,-1
    2826:	0af50363          	beq	a0,a5,28cc <sbrkmuch+0x124>
  c = sbrk(0);
    282a:	4501                	li	a0,0
    282c:	00003097          	auipc	ra,0x3
    2830:	08e080e7          	jalr	142(ra) # 58ba <sbrk>
  if (c != a - PGSIZE)
    2834:	77fd                	lui	a5,0xfffff
    2836:	97a6                	add	a5,a5,s1
    2838:	0af51863          	bne	a0,a5,28e8 <sbrkmuch+0x140>
  a = sbrk(0);
    283c:	4501                	li	a0,0
    283e:	00003097          	auipc	ra,0x3
    2842:	07c080e7          	jalr	124(ra) # 58ba <sbrk>
    2846:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2848:	6505                	lui	a0,0x1
    284a:	00003097          	auipc	ra,0x3
    284e:	070080e7          	jalr	112(ra) # 58ba <sbrk>
    2852:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE)
    2854:	0aa49a63          	bne	s1,a0,2908 <sbrkmuch+0x160>
    2858:	4501                	li	a0,0
    285a:	00003097          	auipc	ra,0x3
    285e:	060080e7          	jalr	96(ra) # 58ba <sbrk>
    2862:	6785                	lui	a5,0x1
    2864:	97a6                	add	a5,a5,s1
    2866:	0af51163          	bne	a0,a5,2908 <sbrkmuch+0x160>
  if (*lastaddr == 99)
    286a:	064007b7          	lui	a5,0x6400
    286e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f12cf>
    2872:	06300793          	li	a5,99
    2876:	0af70963          	beq	a4,a5,2928 <sbrkmuch+0x180>
  a = sbrk(0);
    287a:	4501                	li	a0,0
    287c:	00003097          	auipc	ra,0x3
    2880:	03e080e7          	jalr	62(ra) # 58ba <sbrk>
    2884:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2886:	4501                	li	a0,0
    2888:	00003097          	auipc	ra,0x3
    288c:	032080e7          	jalr	50(ra) # 58ba <sbrk>
    2890:	40a9053b          	subw	a0,s2,a0
    2894:	00003097          	auipc	ra,0x3
    2898:	026080e7          	jalr	38(ra) # 58ba <sbrk>
  if (c != a)
    289c:	0aa49463          	bne	s1,a0,2944 <sbrkmuch+0x19c>
}
    28a0:	70a2                	ld	ra,40(sp)
    28a2:	7402                	ld	s0,32(sp)
    28a4:	64e2                	ld	s1,24(sp)
    28a6:	6942                	ld	s2,16(sp)
    28a8:	69a2                	ld	s3,8(sp)
    28aa:	6a02                	ld	s4,0(sp)
    28ac:	6145                	addi	sp,sp,48
    28ae:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    28b0:	85ce                	mv	a1,s3
    28b2:	00004517          	auipc	a0,0x4
    28b6:	61650513          	addi	a0,a0,1558 # 6ec8 <malloc+0x1260>
    28ba:	00003097          	auipc	ra,0x3
    28be:	2f0080e7          	jalr	752(ra) # 5baa <printf>
    exit(1);
    28c2:	4505                	li	a0,1
    28c4:	00003097          	auipc	ra,0x3
    28c8:	f6e080e7          	jalr	-146(ra) # 5832 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    28cc:	85ce                	mv	a1,s3
    28ce:	00004517          	auipc	a0,0x4
    28d2:	64250513          	addi	a0,a0,1602 # 6f10 <malloc+0x12a8>
    28d6:	00003097          	auipc	ra,0x3
    28da:	2d4080e7          	jalr	724(ra) # 5baa <printf>
    exit(1);
    28de:	4505                	li	a0,1
    28e0:	00003097          	auipc	ra,0x3
    28e4:	f52080e7          	jalr	-174(ra) # 5832 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    28e8:	86aa                	mv	a3,a0
    28ea:	8626                	mv	a2,s1
    28ec:	85ce                	mv	a1,s3
    28ee:	00004517          	auipc	a0,0x4
    28f2:	64250513          	addi	a0,a0,1602 # 6f30 <malloc+0x12c8>
    28f6:	00003097          	auipc	ra,0x3
    28fa:	2b4080e7          	jalr	692(ra) # 5baa <printf>
    exit(1);
    28fe:	4505                	li	a0,1
    2900:	00003097          	auipc	ra,0x3
    2904:	f32080e7          	jalr	-206(ra) # 5832 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2908:	86d2                	mv	a3,s4
    290a:	8626                	mv	a2,s1
    290c:	85ce                	mv	a1,s3
    290e:	00004517          	auipc	a0,0x4
    2912:	66250513          	addi	a0,a0,1634 # 6f70 <malloc+0x1308>
    2916:	00003097          	auipc	ra,0x3
    291a:	294080e7          	jalr	660(ra) # 5baa <printf>
    exit(1);
    291e:	4505                	li	a0,1
    2920:	00003097          	auipc	ra,0x3
    2924:	f12080e7          	jalr	-238(ra) # 5832 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2928:	85ce                	mv	a1,s3
    292a:	00004517          	auipc	a0,0x4
    292e:	67650513          	addi	a0,a0,1654 # 6fa0 <malloc+0x1338>
    2932:	00003097          	auipc	ra,0x3
    2936:	278080e7          	jalr	632(ra) # 5baa <printf>
    exit(1);
    293a:	4505                	li	a0,1
    293c:	00003097          	auipc	ra,0x3
    2940:	ef6080e7          	jalr	-266(ra) # 5832 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2944:	86aa                	mv	a3,a0
    2946:	8626                	mv	a2,s1
    2948:	85ce                	mv	a1,s3
    294a:	00004517          	auipc	a0,0x4
    294e:	68e50513          	addi	a0,a0,1678 # 6fd8 <malloc+0x1370>
    2952:	00003097          	auipc	ra,0x3
    2956:	258080e7          	jalr	600(ra) # 5baa <printf>
    exit(1);
    295a:	4505                	li	a0,1
    295c:	00003097          	auipc	ra,0x3
    2960:	ed6080e7          	jalr	-298(ra) # 5832 <exit>

0000000000002964 <sbrkarg>:
{
    2964:	7179                	addi	sp,sp,-48
    2966:	f406                	sd	ra,40(sp)
    2968:	f022                	sd	s0,32(sp)
    296a:	ec26                	sd	s1,24(sp)
    296c:	e84a                	sd	s2,16(sp)
    296e:	e44e                	sd	s3,8(sp)
    2970:	1800                	addi	s0,sp,48
    2972:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2974:	6505                	lui	a0,0x1
    2976:	00003097          	auipc	ra,0x3
    297a:	f44080e7          	jalr	-188(ra) # 58ba <sbrk>
    297e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2980:	20100593          	li	a1,513
    2984:	00004517          	auipc	a0,0x4
    2988:	67c50513          	addi	a0,a0,1660 # 7000 <malloc+0x1398>
    298c:	00003097          	auipc	ra,0x3
    2990:	ee6080e7          	jalr	-282(ra) # 5872 <open>
    2994:	84aa                	mv	s1,a0
  unlink("sbrk");
    2996:	00004517          	auipc	a0,0x4
    299a:	66a50513          	addi	a0,a0,1642 # 7000 <malloc+0x1398>
    299e:	00003097          	auipc	ra,0x3
    29a2:	ee4080e7          	jalr	-284(ra) # 5882 <unlink>
  if (fd < 0)
    29a6:	0404c163          	bltz	s1,29e8 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0)
    29aa:	6605                	lui	a2,0x1
    29ac:	85ca                	mv	a1,s2
    29ae:	8526                	mv	a0,s1
    29b0:	00003097          	auipc	ra,0x3
    29b4:	ea2080e7          	jalr	-350(ra) # 5852 <write>
    29b8:	04054663          	bltz	a0,2a04 <sbrkarg+0xa0>
  close(fd);
    29bc:	8526                	mv	a0,s1
    29be:	00003097          	auipc	ra,0x3
    29c2:	e9c080e7          	jalr	-356(ra) # 585a <close>
  a = sbrk(PGSIZE);
    29c6:	6505                	lui	a0,0x1
    29c8:	00003097          	auipc	ra,0x3
    29cc:	ef2080e7          	jalr	-270(ra) # 58ba <sbrk>
  if (pipe((int *)a) != 0)
    29d0:	00003097          	auipc	ra,0x3
    29d4:	e72080e7          	jalr	-398(ra) # 5842 <pipe>
    29d8:	e521                	bnez	a0,2a20 <sbrkarg+0xbc>
}
    29da:	70a2                	ld	ra,40(sp)
    29dc:	7402                	ld	s0,32(sp)
    29de:	64e2                	ld	s1,24(sp)
    29e0:	6942                	ld	s2,16(sp)
    29e2:	69a2                	ld	s3,8(sp)
    29e4:	6145                	addi	sp,sp,48
    29e6:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    29e8:	85ce                	mv	a1,s3
    29ea:	00004517          	auipc	a0,0x4
    29ee:	61e50513          	addi	a0,a0,1566 # 7008 <malloc+0x13a0>
    29f2:	00003097          	auipc	ra,0x3
    29f6:	1b8080e7          	jalr	440(ra) # 5baa <printf>
    exit(1);
    29fa:	4505                	li	a0,1
    29fc:	00003097          	auipc	ra,0x3
    2a00:	e36080e7          	jalr	-458(ra) # 5832 <exit>
    printf("%s: write sbrk failed\n", s);
    2a04:	85ce                	mv	a1,s3
    2a06:	00004517          	auipc	a0,0x4
    2a0a:	61a50513          	addi	a0,a0,1562 # 7020 <malloc+0x13b8>
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	19c080e7          	jalr	412(ra) # 5baa <printf>
    exit(1);
    2a16:	4505                	li	a0,1
    2a18:	00003097          	auipc	ra,0x3
    2a1c:	e1a080e7          	jalr	-486(ra) # 5832 <exit>
    printf("%s: pipe() failed\n", s);
    2a20:	85ce                	mv	a1,s3
    2a22:	00004517          	auipc	a0,0x4
    2a26:	fe650513          	addi	a0,a0,-26 # 6a08 <malloc+0xda0>
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	180080e7          	jalr	384(ra) # 5baa <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	00003097          	auipc	ra,0x3
    2a38:	dfe080e7          	jalr	-514(ra) # 5832 <exit>

0000000000002a3c <argptest>:
{
    2a3c:	1101                	addi	sp,sp,-32
    2a3e:	ec06                	sd	ra,24(sp)
    2a40:	e822                	sd	s0,16(sp)
    2a42:	e426                	sd	s1,8(sp)
    2a44:	e04a                	sd	s2,0(sp)
    2a46:	1000                	addi	s0,sp,32
    2a48:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2a4a:	4581                	li	a1,0
    2a4c:	00004517          	auipc	a0,0x4
    2a50:	5ec50513          	addi	a0,a0,1516 # 7038 <malloc+0x13d0>
    2a54:	00003097          	auipc	ra,0x3
    2a58:	e1e080e7          	jalr	-482(ra) # 5872 <open>
  if (fd < 0)
    2a5c:	02054b63          	bltz	a0,2a92 <argptest+0x56>
    2a60:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2a62:	4501                	li	a0,0
    2a64:	00003097          	auipc	ra,0x3
    2a68:	e56080e7          	jalr	-426(ra) # 58ba <sbrk>
    2a6c:	567d                	li	a2,-1
    2a6e:	fff50593          	addi	a1,a0,-1
    2a72:	8526                	mv	a0,s1
    2a74:	00003097          	auipc	ra,0x3
    2a78:	dd6080e7          	jalr	-554(ra) # 584a <read>
  close(fd);
    2a7c:	8526                	mv	a0,s1
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	ddc080e7          	jalr	-548(ra) # 585a <close>
}
    2a86:	60e2                	ld	ra,24(sp)
    2a88:	6442                	ld	s0,16(sp)
    2a8a:	64a2                	ld	s1,8(sp)
    2a8c:	6902                	ld	s2,0(sp)
    2a8e:	6105                	addi	sp,sp,32
    2a90:	8082                	ret
    printf("%s: open failed\n", s);
    2a92:	85ca                	mv	a1,s2
    2a94:	00004517          	auipc	a0,0x4
    2a98:	e8450513          	addi	a0,a0,-380 # 6918 <malloc+0xcb0>
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	10e080e7          	jalr	270(ra) # 5baa <printf>
    exit(1);
    2aa4:	4505                	li	a0,1
    2aa6:	00003097          	auipc	ra,0x3
    2aaa:	d8c080e7          	jalr	-628(ra) # 5832 <exit>

0000000000002aae <sbrklast>:

// if process size was somewhat more than a page boundary, and then
// shrunk to be somewhat less than that page boundary, can the kernel
// still copyin() from addresses in the last page?
void sbrklast(char *s)
{
    2aae:	7179                	addi	sp,sp,-48
    2ab0:	f406                	sd	ra,40(sp)
    2ab2:	f022                	sd	s0,32(sp)
    2ab4:	ec26                	sd	s1,24(sp)
    2ab6:	e84a                	sd	s2,16(sp)
    2ab8:	e44e                	sd	s3,8(sp)
    2aba:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    2abc:	4501                	li	a0,0
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	dfc080e7          	jalr	-516(ra) # 58ba <sbrk>
  if ((top % 4096) != 0)
    2ac6:	03451793          	slli	a5,a0,0x34
    2aca:	efc1                	bnez	a5,2b62 <sbrklast+0xb4>
    sbrk(4096 - (top % 4096));
  sbrk(4096);
    2acc:	6505                	lui	a0,0x1
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	dec080e7          	jalr	-532(ra) # 58ba <sbrk>
  sbrk(10);
    2ad6:	4529                	li	a0,10
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	de2080e7          	jalr	-542(ra) # 58ba <sbrk>
  sbrk(-20);
    2ae0:	5531                	li	a0,-20
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	dd8080e7          	jalr	-552(ra) # 58ba <sbrk>
  top = (uint64)sbrk(0);
    2aea:	4501                	li	a0,0
    2aec:	00003097          	auipc	ra,0x3
    2af0:	dce080e7          	jalr	-562(ra) # 58ba <sbrk>
    2af4:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    2af6:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x5e>
  p[0] = 'x';
    2afa:	07800793          	li	a5,120
    2afe:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2b02:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    2b06:	20200593          	li	a1,514
    2b0a:	854a                	mv	a0,s2
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	d66080e7          	jalr	-666(ra) # 5872 <open>
    2b14:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2b16:	4605                	li	a2,1
    2b18:	85ca                	mv	a1,s2
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	d38080e7          	jalr	-712(ra) # 5852 <write>
  close(fd);
    2b22:	854e                	mv	a0,s3
    2b24:	00003097          	auipc	ra,0x3
    2b28:	d36080e7          	jalr	-714(ra) # 585a <close>
  fd = open(p, O_RDWR);
    2b2c:	4589                	li	a1,2
    2b2e:	854a                	mv	a0,s2
    2b30:	00003097          	auipc	ra,0x3
    2b34:	d42080e7          	jalr	-702(ra) # 5872 <open>
  p[0] = '\0';
    2b38:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2b3c:	4605                	li	a2,1
    2b3e:	85ca                	mv	a1,s2
    2b40:	00003097          	auipc	ra,0x3
    2b44:	d0a080e7          	jalr	-758(ra) # 584a <read>
  if (p[0] != 'x')
    2b48:	fc04c703          	lbu	a4,-64(s1)
    2b4c:	07800793          	li	a5,120
    2b50:	02f71363          	bne	a4,a5,2b76 <sbrklast+0xc8>
    exit(1);
}
    2b54:	70a2                	ld	ra,40(sp)
    2b56:	7402                	ld	s0,32(sp)
    2b58:	64e2                	ld	s1,24(sp)
    2b5a:	6942                	ld	s2,16(sp)
    2b5c:	69a2                	ld	s3,8(sp)
    2b5e:	6145                	addi	sp,sp,48
    2b60:	8082                	ret
    sbrk(4096 - (top % 4096));
    2b62:	0347d513          	srli	a0,a5,0x34
    2b66:	6785                	lui	a5,0x1
    2b68:	40a7853b          	subw	a0,a5,a0
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	d4e080e7          	jalr	-690(ra) # 58ba <sbrk>
    2b74:	bfa1                	j	2acc <sbrklast+0x1e>
    exit(1);
    2b76:	4505                	li	a0,1
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	cba080e7          	jalr	-838(ra) # 5832 <exit>

0000000000002b80 <sbrk8000>:

// does sbrk handle signed int32 wrap-around with
// negative arguments?
void sbrk8000(char *s)
{
    2b80:	1141                	addi	sp,sp,-16
    2b82:	e406                	sd	ra,8(sp)
    2b84:	e022                	sd	s0,0(sp)
    2b86:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2b88:	80000537          	lui	a0,0x80000
    2b8c:	0511                	addi	a0,a0,4
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	d2c080e7          	jalr	-724(ra) # 58ba <sbrk>
  volatile char *top = sbrk(0);
    2b96:	4501                	li	a0,0
    2b98:	00003097          	auipc	ra,0x3
    2b9c:	d22080e7          	jalr	-734(ra) # 58ba <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2ba0:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff12cf>
    2ba4:	0785                	addi	a5,a5,1
    2ba6:	0ff7f793          	andi	a5,a5,255
    2baa:	fef50fa3          	sb	a5,-1(a0)
}
    2bae:	60a2                	ld	ra,8(sp)
    2bb0:	6402                	ld	s0,0(sp)
    2bb2:	0141                	addi	sp,sp,16
    2bb4:	8082                	ret

0000000000002bb6 <execout>:

// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void execout(char *s)
{
    2bb6:	715d                	addi	sp,sp,-80
    2bb8:	e486                	sd	ra,72(sp)
    2bba:	e0a2                	sd	s0,64(sp)
    2bbc:	fc26                	sd	s1,56(sp)
    2bbe:	f84a                	sd	s2,48(sp)
    2bc0:	f44e                	sd	s3,40(sp)
    2bc2:	f052                	sd	s4,32(sp)
    2bc4:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++)
    2bc6:	4901                	li	s2,0
    2bc8:	49bd                	li	s3,15
  {
    int pid = fork();
    2bca:	00003097          	auipc	ra,0x3
    2bce:	c60080e7          	jalr	-928(ra) # 582a <fork>
    2bd2:	84aa                	mv	s1,a0
    if (pid < 0)
    2bd4:	02054063          	bltz	a0,2bf4 <execout+0x3e>
    {
      printf("fork failed\n");
      exit(1);
    }
    else if (pid == 0)
    2bd8:	c91d                	beqz	a0,2c0e <execout+0x58>
      exec("echo", args);
      exit(0);
    }
    else
    {
      wait((int *)0);
    2bda:	4501                	li	a0,0
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	c5e080e7          	jalr	-930(ra) # 583a <wait>
  for (int avail = 0; avail < 15; avail++)
    2be4:	2905                	addiw	s2,s2,1
    2be6:	ff3912e3          	bne	s2,s3,2bca <execout+0x14>
    }
  }

  exit(0);
    2bea:	4501                	li	a0,0
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	c46080e7          	jalr	-954(ra) # 5832 <exit>
      printf("fork failed\n");
    2bf4:	00004517          	auipc	a0,0x4
    2bf8:	12c50513          	addi	a0,a0,300 # 6d20 <malloc+0x10b8>
    2bfc:	00003097          	auipc	ra,0x3
    2c00:	fae080e7          	jalr	-82(ra) # 5baa <printf>
      exit(1);
    2c04:	4505                	li	a0,1
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	c2c080e7          	jalr	-980(ra) # 5832 <exit>
        if (a == 0xffffffffffffffffLL)
    2c0e:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    2c10:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    2c12:	6505                	lui	a0,0x1
    2c14:	00003097          	auipc	ra,0x3
    2c18:	ca6080e7          	jalr	-858(ra) # 58ba <sbrk>
        if (a == 0xffffffffffffffffLL)
    2c1c:	01350763          	beq	a0,s3,2c2a <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2c20:	6785                	lui	a5,0x1
    2c22:	953e                	add	a0,a0,a5
    2c24:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9d>
      {
    2c28:	b7ed                	j	2c12 <execout+0x5c>
      for (int i = 0; i < avail; i++)
    2c2a:	01205a63          	blez	s2,2c3e <execout+0x88>
        sbrk(-4096);
    2c2e:	757d                	lui	a0,0xfffff
    2c30:	00003097          	auipc	ra,0x3
    2c34:	c8a080e7          	jalr	-886(ra) # 58ba <sbrk>
      for (int i = 0; i < avail; i++)
    2c38:	2485                	addiw	s1,s1,1
    2c3a:	ff249ae3          	bne	s1,s2,2c2e <execout+0x78>
      close(1);
    2c3e:	4505                	li	a0,1
    2c40:	00003097          	auipc	ra,0x3
    2c44:	c1a080e7          	jalr	-998(ra) # 585a <close>
      char *args[] = {"echo", "x", 0};
    2c48:	00003517          	auipc	a0,0x3
    2c4c:	48050513          	addi	a0,a0,1152 # 60c8 <malloc+0x460>
    2c50:	faa43c23          	sd	a0,-72(s0)
    2c54:	00003797          	auipc	a5,0x3
    2c58:	4e478793          	addi	a5,a5,1252 # 6138 <malloc+0x4d0>
    2c5c:	fcf43023          	sd	a5,-64(s0)
    2c60:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c64:	fb840593          	addi	a1,s0,-72
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	c02080e7          	jalr	-1022(ra) # 586a <exec>
      exit(0);
    2c70:	4501                	li	a0,0
    2c72:	00003097          	auipc	ra,0x3
    2c76:	bc0080e7          	jalr	-1088(ra) # 5832 <exit>

0000000000002c7a <fourteen>:
{
    2c7a:	1101                	addi	sp,sp,-32
    2c7c:	ec06                	sd	ra,24(sp)
    2c7e:	e822                	sd	s0,16(sp)
    2c80:	e426                	sd	s1,8(sp)
    2c82:	1000                	addi	s0,sp,32
    2c84:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0)
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	58a50513          	addi	a0,a0,1418 # 7210 <malloc+0x15a8>
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	c0c080e7          	jalr	-1012(ra) # 589a <mkdir>
    2c96:	e165                	bnez	a0,2d76 <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0)
    2c98:	00004517          	auipc	a0,0x4
    2c9c:	3d050513          	addi	a0,a0,976 # 7068 <malloc+0x1400>
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	bfa080e7          	jalr	-1030(ra) # 589a <mkdir>
    2ca8:	e56d                	bnez	a0,2d92 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2caa:	20000593          	li	a1,512
    2cae:	00004517          	auipc	a0,0x4
    2cb2:	41250513          	addi	a0,a0,1042 # 70c0 <malloc+0x1458>
    2cb6:	00003097          	auipc	ra,0x3
    2cba:	bbc080e7          	jalr	-1092(ra) # 5872 <open>
  if (fd < 0)
    2cbe:	0e054863          	bltz	a0,2dae <fourteen+0x134>
  close(fd);
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	b98080e7          	jalr	-1128(ra) # 585a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2cca:	4581                	li	a1,0
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	46c50513          	addi	a0,a0,1132 # 7138 <malloc+0x14d0>
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	b9e080e7          	jalr	-1122(ra) # 5872 <open>
  if (fd < 0)
    2cdc:	0e054763          	bltz	a0,2dca <fourteen+0x150>
  close(fd);
    2ce0:	00003097          	auipc	ra,0x3
    2ce4:	b7a080e7          	jalr	-1158(ra) # 585a <close>
  if (mkdir("12345678901234/12345678901234") == 0)
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	4c050513          	addi	a0,a0,1216 # 71a8 <malloc+0x1540>
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	baa080e7          	jalr	-1110(ra) # 589a <mkdir>
    2cf8:	c57d                	beqz	a0,2de6 <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0)
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	50650513          	addi	a0,a0,1286 # 7200 <malloc+0x1598>
    2d02:	00003097          	auipc	ra,0x3
    2d06:	b98080e7          	jalr	-1128(ra) # 589a <mkdir>
    2d0a:	cd65                	beqz	a0,2e02 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	4f450513          	addi	a0,a0,1268 # 7200 <malloc+0x1598>
    2d14:	00003097          	auipc	ra,0x3
    2d18:	b6e080e7          	jalr	-1170(ra) # 5882 <unlink>
  unlink("12345678901234/12345678901234");
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	48c50513          	addi	a0,a0,1164 # 71a8 <malloc+0x1540>
    2d24:	00003097          	auipc	ra,0x3
    2d28:	b5e080e7          	jalr	-1186(ra) # 5882 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2d2c:	00004517          	auipc	a0,0x4
    2d30:	40c50513          	addi	a0,a0,1036 # 7138 <malloc+0x14d0>
    2d34:	00003097          	auipc	ra,0x3
    2d38:	b4e080e7          	jalr	-1202(ra) # 5882 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2d3c:	00004517          	auipc	a0,0x4
    2d40:	38450513          	addi	a0,a0,900 # 70c0 <malloc+0x1458>
    2d44:	00003097          	auipc	ra,0x3
    2d48:	b3e080e7          	jalr	-1218(ra) # 5882 <unlink>
  unlink("12345678901234/123456789012345");
    2d4c:	00004517          	auipc	a0,0x4
    2d50:	31c50513          	addi	a0,a0,796 # 7068 <malloc+0x1400>
    2d54:	00003097          	auipc	ra,0x3
    2d58:	b2e080e7          	jalr	-1234(ra) # 5882 <unlink>
  unlink("12345678901234");
    2d5c:	00004517          	auipc	a0,0x4
    2d60:	4b450513          	addi	a0,a0,1204 # 7210 <malloc+0x15a8>
    2d64:	00003097          	auipc	ra,0x3
    2d68:	b1e080e7          	jalr	-1250(ra) # 5882 <unlink>
}
    2d6c:	60e2                	ld	ra,24(sp)
    2d6e:	6442                	ld	s0,16(sp)
    2d70:	64a2                	ld	s1,8(sp)
    2d72:	6105                	addi	sp,sp,32
    2d74:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d76:	85a6                	mv	a1,s1
    2d78:	00004517          	auipc	a0,0x4
    2d7c:	2c850513          	addi	a0,a0,712 # 7040 <malloc+0x13d8>
    2d80:	00003097          	auipc	ra,0x3
    2d84:	e2a080e7          	jalr	-470(ra) # 5baa <printf>
    exit(1);
    2d88:	4505                	li	a0,1
    2d8a:	00003097          	auipc	ra,0x3
    2d8e:	aa8080e7          	jalr	-1368(ra) # 5832 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d92:	85a6                	mv	a1,s1
    2d94:	00004517          	auipc	a0,0x4
    2d98:	2f450513          	addi	a0,a0,756 # 7088 <malloc+0x1420>
    2d9c:	00003097          	auipc	ra,0x3
    2da0:	e0e080e7          	jalr	-498(ra) # 5baa <printf>
    exit(1);
    2da4:	4505                	li	a0,1
    2da6:	00003097          	auipc	ra,0x3
    2daa:	a8c080e7          	jalr	-1396(ra) # 5832 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2dae:	85a6                	mv	a1,s1
    2db0:	00004517          	auipc	a0,0x4
    2db4:	34050513          	addi	a0,a0,832 # 70f0 <malloc+0x1488>
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	df2080e7          	jalr	-526(ra) # 5baa <printf>
    exit(1);
    2dc0:	4505                	li	a0,1
    2dc2:	00003097          	auipc	ra,0x3
    2dc6:	a70080e7          	jalr	-1424(ra) # 5832 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2dca:	85a6                	mv	a1,s1
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	39c50513          	addi	a0,a0,924 # 7168 <malloc+0x1500>
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	dd6080e7          	jalr	-554(ra) # 5baa <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00003097          	auipc	ra,0x3
    2de2:	a54080e7          	jalr	-1452(ra) # 5832 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2de6:	85a6                	mv	a1,s1
    2de8:	00004517          	auipc	a0,0x4
    2dec:	3e050513          	addi	a0,a0,992 # 71c8 <malloc+0x1560>
    2df0:	00003097          	auipc	ra,0x3
    2df4:	dba080e7          	jalr	-582(ra) # 5baa <printf>
    exit(1);
    2df8:	4505                	li	a0,1
    2dfa:	00003097          	auipc	ra,0x3
    2dfe:	a38080e7          	jalr	-1480(ra) # 5832 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2e02:	85a6                	mv	a1,s1
    2e04:	00004517          	auipc	a0,0x4
    2e08:	41c50513          	addi	a0,a0,1052 # 7220 <malloc+0x15b8>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	d9e080e7          	jalr	-610(ra) # 5baa <printf>
    exit(1);
    2e14:	4505                	li	a0,1
    2e16:	00003097          	auipc	ra,0x3
    2e1a:	a1c080e7          	jalr	-1508(ra) # 5832 <exit>

0000000000002e1e <iputtest>:
{
    2e1e:	1101                	addi	sp,sp,-32
    2e20:	ec06                	sd	ra,24(sp)
    2e22:	e822                	sd	s0,16(sp)
    2e24:	e426                	sd	s1,8(sp)
    2e26:	1000                	addi	s0,sp,32
    2e28:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0)
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	42e50513          	addi	a0,a0,1070 # 7258 <malloc+0x15f0>
    2e32:	00003097          	auipc	ra,0x3
    2e36:	a68080e7          	jalr	-1432(ra) # 589a <mkdir>
    2e3a:	04054563          	bltz	a0,2e84 <iputtest+0x66>
  if (chdir("iputdir") < 0)
    2e3e:	00004517          	auipc	a0,0x4
    2e42:	41a50513          	addi	a0,a0,1050 # 7258 <malloc+0x15f0>
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	a5c080e7          	jalr	-1444(ra) # 58a2 <chdir>
    2e4e:	04054963          	bltz	a0,2ea0 <iputtest+0x82>
  if (unlink("../iputdir") < 0)
    2e52:	00004517          	auipc	a0,0x4
    2e56:	44650513          	addi	a0,a0,1094 # 7298 <malloc+0x1630>
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	a28080e7          	jalr	-1496(ra) # 5882 <unlink>
    2e62:	04054d63          	bltz	a0,2ebc <iputtest+0x9e>
  if (chdir("/") < 0)
    2e66:	00004517          	auipc	a0,0x4
    2e6a:	46250513          	addi	a0,a0,1122 # 72c8 <malloc+0x1660>
    2e6e:	00003097          	auipc	ra,0x3
    2e72:	a34080e7          	jalr	-1484(ra) # 58a2 <chdir>
    2e76:	06054163          	bltz	a0,2ed8 <iputtest+0xba>
}
    2e7a:	60e2                	ld	ra,24(sp)
    2e7c:	6442                	ld	s0,16(sp)
    2e7e:	64a2                	ld	s1,8(sp)
    2e80:	6105                	addi	sp,sp,32
    2e82:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e84:	85a6                	mv	a1,s1
    2e86:	00004517          	auipc	a0,0x4
    2e8a:	3da50513          	addi	a0,a0,986 # 7260 <malloc+0x15f8>
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	d1c080e7          	jalr	-740(ra) # 5baa <printf>
    exit(1);
    2e96:	4505                	li	a0,1
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	99a080e7          	jalr	-1638(ra) # 5832 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2ea0:	85a6                	mv	a1,s1
    2ea2:	00004517          	auipc	a0,0x4
    2ea6:	3d650513          	addi	a0,a0,982 # 7278 <malloc+0x1610>
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	d00080e7          	jalr	-768(ra) # 5baa <printf>
    exit(1);
    2eb2:	4505                	li	a0,1
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	97e080e7          	jalr	-1666(ra) # 5832 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2ebc:	85a6                	mv	a1,s1
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	3ea50513          	addi	a0,a0,1002 # 72a8 <malloc+0x1640>
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	ce4080e7          	jalr	-796(ra) # 5baa <printf>
    exit(1);
    2ece:	4505                	li	a0,1
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	962080e7          	jalr	-1694(ra) # 5832 <exit>
    printf("%s: chdir / failed\n", s);
    2ed8:	85a6                	mv	a1,s1
    2eda:	00004517          	auipc	a0,0x4
    2ede:	3f650513          	addi	a0,a0,1014 # 72d0 <malloc+0x1668>
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	cc8080e7          	jalr	-824(ra) # 5baa <printf>
    exit(1);
    2eea:	4505                	li	a0,1
    2eec:	00003097          	auipc	ra,0x3
    2ef0:	946080e7          	jalr	-1722(ra) # 5832 <exit>

0000000000002ef4 <exitiputtest>:
{
    2ef4:	7179                	addi	sp,sp,-48
    2ef6:	f406                	sd	ra,40(sp)
    2ef8:	f022                	sd	s0,32(sp)
    2efa:	ec26                	sd	s1,24(sp)
    2efc:	1800                	addi	s0,sp,48
    2efe:	84aa                	mv	s1,a0
  pid = fork();
    2f00:	00003097          	auipc	ra,0x3
    2f04:	92a080e7          	jalr	-1750(ra) # 582a <fork>
  if (pid < 0)
    2f08:	04054663          	bltz	a0,2f54 <exitiputtest+0x60>
  if (pid == 0)
    2f0c:	ed45                	bnez	a0,2fc4 <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0)
    2f0e:	00004517          	auipc	a0,0x4
    2f12:	34a50513          	addi	a0,a0,842 # 7258 <malloc+0x15f0>
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	984080e7          	jalr	-1660(ra) # 589a <mkdir>
    2f1e:	04054963          	bltz	a0,2f70 <exitiputtest+0x7c>
    if (chdir("iputdir") < 0)
    2f22:	00004517          	auipc	a0,0x4
    2f26:	33650513          	addi	a0,a0,822 # 7258 <malloc+0x15f0>
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	978080e7          	jalr	-1672(ra) # 58a2 <chdir>
    2f32:	04054d63          	bltz	a0,2f8c <exitiputtest+0x98>
    if (unlink("../iputdir") < 0)
    2f36:	00004517          	auipc	a0,0x4
    2f3a:	36250513          	addi	a0,a0,866 # 7298 <malloc+0x1630>
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	944080e7          	jalr	-1724(ra) # 5882 <unlink>
    2f46:	06054163          	bltz	a0,2fa8 <exitiputtest+0xb4>
    exit(0);
    2f4a:	4501                	li	a0,0
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	8e6080e7          	jalr	-1818(ra) # 5832 <exit>
    printf("%s: fork failed\n", s);
    2f54:	85a6                	mv	a1,s1
    2f56:	00004517          	auipc	a0,0x4
    2f5a:	9aa50513          	addi	a0,a0,-1622 # 6900 <malloc+0xc98>
    2f5e:	00003097          	auipc	ra,0x3
    2f62:	c4c080e7          	jalr	-948(ra) # 5baa <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	00003097          	auipc	ra,0x3
    2f6c:	8ca080e7          	jalr	-1846(ra) # 5832 <exit>
      printf("%s: mkdir failed\n", s);
    2f70:	85a6                	mv	a1,s1
    2f72:	00004517          	auipc	a0,0x4
    2f76:	2ee50513          	addi	a0,a0,750 # 7260 <malloc+0x15f8>
    2f7a:	00003097          	auipc	ra,0x3
    2f7e:	c30080e7          	jalr	-976(ra) # 5baa <printf>
      exit(1);
    2f82:	4505                	li	a0,1
    2f84:	00003097          	auipc	ra,0x3
    2f88:	8ae080e7          	jalr	-1874(ra) # 5832 <exit>
      printf("%s: child chdir failed\n", s);
    2f8c:	85a6                	mv	a1,s1
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	35a50513          	addi	a0,a0,858 # 72e8 <malloc+0x1680>
    2f96:	00003097          	auipc	ra,0x3
    2f9a:	c14080e7          	jalr	-1004(ra) # 5baa <printf>
      exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	892080e7          	jalr	-1902(ra) # 5832 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2fa8:	85a6                	mv	a1,s1
    2faa:	00004517          	auipc	a0,0x4
    2fae:	2fe50513          	addi	a0,a0,766 # 72a8 <malloc+0x1640>
    2fb2:	00003097          	auipc	ra,0x3
    2fb6:	bf8080e7          	jalr	-1032(ra) # 5baa <printf>
      exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	00003097          	auipc	ra,0x3
    2fc0:	876080e7          	jalr	-1930(ra) # 5832 <exit>
  wait(&xstatus);
    2fc4:	fdc40513          	addi	a0,s0,-36
    2fc8:	00003097          	auipc	ra,0x3
    2fcc:	872080e7          	jalr	-1934(ra) # 583a <wait>
  exit(xstatus);
    2fd0:	fdc42503          	lw	a0,-36(s0)
    2fd4:	00003097          	auipc	ra,0x3
    2fd8:	85e080e7          	jalr	-1954(ra) # 5832 <exit>

0000000000002fdc <dirtest>:
{
    2fdc:	1101                	addi	sp,sp,-32
    2fde:	ec06                	sd	ra,24(sp)
    2fe0:	e822                	sd	s0,16(sp)
    2fe2:	e426                	sd	s1,8(sp)
    2fe4:	1000                	addi	s0,sp,32
    2fe6:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0)
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	31850513          	addi	a0,a0,792 # 7300 <malloc+0x1698>
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	8aa080e7          	jalr	-1878(ra) # 589a <mkdir>
    2ff8:	04054563          	bltz	a0,3042 <dirtest+0x66>
  if (chdir("dir0") < 0)
    2ffc:	00004517          	auipc	a0,0x4
    3000:	30450513          	addi	a0,a0,772 # 7300 <malloc+0x1698>
    3004:	00003097          	auipc	ra,0x3
    3008:	89e080e7          	jalr	-1890(ra) # 58a2 <chdir>
    300c:	04054963          	bltz	a0,305e <dirtest+0x82>
  if (chdir("..") < 0)
    3010:	00004517          	auipc	a0,0x4
    3014:	31050513          	addi	a0,a0,784 # 7320 <malloc+0x16b8>
    3018:	00003097          	auipc	ra,0x3
    301c:	88a080e7          	jalr	-1910(ra) # 58a2 <chdir>
    3020:	04054d63          	bltz	a0,307a <dirtest+0x9e>
  if (unlink("dir0") < 0)
    3024:	00004517          	auipc	a0,0x4
    3028:	2dc50513          	addi	a0,a0,732 # 7300 <malloc+0x1698>
    302c:	00003097          	auipc	ra,0x3
    3030:	856080e7          	jalr	-1962(ra) # 5882 <unlink>
    3034:	06054163          	bltz	a0,3096 <dirtest+0xba>
}
    3038:	60e2                	ld	ra,24(sp)
    303a:	6442                	ld	s0,16(sp)
    303c:	64a2                	ld	s1,8(sp)
    303e:	6105                	addi	sp,sp,32
    3040:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3042:	85a6                	mv	a1,s1
    3044:	00004517          	auipc	a0,0x4
    3048:	21c50513          	addi	a0,a0,540 # 7260 <malloc+0x15f8>
    304c:	00003097          	auipc	ra,0x3
    3050:	b5e080e7          	jalr	-1186(ra) # 5baa <printf>
    exit(1);
    3054:	4505                	li	a0,1
    3056:	00002097          	auipc	ra,0x2
    305a:	7dc080e7          	jalr	2012(ra) # 5832 <exit>
    printf("%s: chdir dir0 failed\n", s);
    305e:	85a6                	mv	a1,s1
    3060:	00004517          	auipc	a0,0x4
    3064:	2a850513          	addi	a0,a0,680 # 7308 <malloc+0x16a0>
    3068:	00003097          	auipc	ra,0x3
    306c:	b42080e7          	jalr	-1214(ra) # 5baa <printf>
    exit(1);
    3070:	4505                	li	a0,1
    3072:	00002097          	auipc	ra,0x2
    3076:	7c0080e7          	jalr	1984(ra) # 5832 <exit>
    printf("%s: chdir .. failed\n", s);
    307a:	85a6                	mv	a1,s1
    307c:	00004517          	auipc	a0,0x4
    3080:	2ac50513          	addi	a0,a0,684 # 7328 <malloc+0x16c0>
    3084:	00003097          	auipc	ra,0x3
    3088:	b26080e7          	jalr	-1242(ra) # 5baa <printf>
    exit(1);
    308c:	4505                	li	a0,1
    308e:	00002097          	auipc	ra,0x2
    3092:	7a4080e7          	jalr	1956(ra) # 5832 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3096:	85a6                	mv	a1,s1
    3098:	00004517          	auipc	a0,0x4
    309c:	2a850513          	addi	a0,a0,680 # 7340 <malloc+0x16d8>
    30a0:	00003097          	auipc	ra,0x3
    30a4:	b0a080e7          	jalr	-1270(ra) # 5baa <printf>
    exit(1);
    30a8:	4505                	li	a0,1
    30aa:	00002097          	auipc	ra,0x2
    30ae:	788080e7          	jalr	1928(ra) # 5832 <exit>

00000000000030b2 <subdir>:
{
    30b2:	1101                	addi	sp,sp,-32
    30b4:	ec06                	sd	ra,24(sp)
    30b6:	e822                	sd	s0,16(sp)
    30b8:	e426                	sd	s1,8(sp)
    30ba:	e04a                	sd	s2,0(sp)
    30bc:	1000                	addi	s0,sp,32
    30be:	892a                	mv	s2,a0
  unlink("ff");
    30c0:	00004517          	auipc	a0,0x4
    30c4:	3c850513          	addi	a0,a0,968 # 7488 <malloc+0x1820>
    30c8:	00002097          	auipc	ra,0x2
    30cc:	7ba080e7          	jalr	1978(ra) # 5882 <unlink>
  if (mkdir("dd") != 0)
    30d0:	00004517          	auipc	a0,0x4
    30d4:	28850513          	addi	a0,a0,648 # 7358 <malloc+0x16f0>
    30d8:	00002097          	auipc	ra,0x2
    30dc:	7c2080e7          	jalr	1986(ra) # 589a <mkdir>
    30e0:	38051663          	bnez	a0,346c <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    30e4:	20200593          	li	a1,514
    30e8:	00004517          	auipc	a0,0x4
    30ec:	29050513          	addi	a0,a0,656 # 7378 <malloc+0x1710>
    30f0:	00002097          	auipc	ra,0x2
    30f4:	782080e7          	jalr	1922(ra) # 5872 <open>
    30f8:	84aa                	mv	s1,a0
  if (fd < 0)
    30fa:	38054763          	bltz	a0,3488 <subdir+0x3d6>
  write(fd, "ff", 2);
    30fe:	4609                	li	a2,2
    3100:	00004597          	auipc	a1,0x4
    3104:	38858593          	addi	a1,a1,904 # 7488 <malloc+0x1820>
    3108:	00002097          	auipc	ra,0x2
    310c:	74a080e7          	jalr	1866(ra) # 5852 <write>
  close(fd);
    3110:	8526                	mv	a0,s1
    3112:	00002097          	auipc	ra,0x2
    3116:	748080e7          	jalr	1864(ra) # 585a <close>
  if (unlink("dd") >= 0)
    311a:	00004517          	auipc	a0,0x4
    311e:	23e50513          	addi	a0,a0,574 # 7358 <malloc+0x16f0>
    3122:	00002097          	auipc	ra,0x2
    3126:	760080e7          	jalr	1888(ra) # 5882 <unlink>
    312a:	36055d63          	bgez	a0,34a4 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0)
    312e:	00004517          	auipc	a0,0x4
    3132:	2a250513          	addi	a0,a0,674 # 73d0 <malloc+0x1768>
    3136:	00002097          	auipc	ra,0x2
    313a:	764080e7          	jalr	1892(ra) # 589a <mkdir>
    313e:	38051163          	bnez	a0,34c0 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3142:	20200593          	li	a1,514
    3146:	00004517          	auipc	a0,0x4
    314a:	2b250513          	addi	a0,a0,690 # 73f8 <malloc+0x1790>
    314e:	00002097          	auipc	ra,0x2
    3152:	724080e7          	jalr	1828(ra) # 5872 <open>
    3156:	84aa                	mv	s1,a0
  if (fd < 0)
    3158:	38054263          	bltz	a0,34dc <subdir+0x42a>
  write(fd, "FF", 2);
    315c:	4609                	li	a2,2
    315e:	00004597          	auipc	a1,0x4
    3162:	2ca58593          	addi	a1,a1,714 # 7428 <malloc+0x17c0>
    3166:	00002097          	auipc	ra,0x2
    316a:	6ec080e7          	jalr	1772(ra) # 5852 <write>
  close(fd);
    316e:	8526                	mv	a0,s1
    3170:	00002097          	auipc	ra,0x2
    3174:	6ea080e7          	jalr	1770(ra) # 585a <close>
  fd = open("dd/dd/../ff", 0);
    3178:	4581                	li	a1,0
    317a:	00004517          	auipc	a0,0x4
    317e:	2b650513          	addi	a0,a0,694 # 7430 <malloc+0x17c8>
    3182:	00002097          	auipc	ra,0x2
    3186:	6f0080e7          	jalr	1776(ra) # 5872 <open>
    318a:	84aa                	mv	s1,a0
  if (fd < 0)
    318c:	36054663          	bltz	a0,34f8 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3190:	660d                	lui	a2,0x3
    3192:	00009597          	auipc	a1,0x9
    3196:	b8e58593          	addi	a1,a1,-1138 # bd20 <buf>
    319a:	00002097          	auipc	ra,0x2
    319e:	6b0080e7          	jalr	1712(ra) # 584a <read>
  if (cc != 2 || buf[0] != 'f')
    31a2:	4789                	li	a5,2
    31a4:	36f51863          	bne	a0,a5,3514 <subdir+0x462>
    31a8:	00009717          	auipc	a4,0x9
    31ac:	b7874703          	lbu	a4,-1160(a4) # bd20 <buf>
    31b0:	06600793          	li	a5,102
    31b4:	36f71063          	bne	a4,a5,3514 <subdir+0x462>
  close(fd);
    31b8:	8526                	mv	a0,s1
    31ba:	00002097          	auipc	ra,0x2
    31be:	6a0080e7          	jalr	1696(ra) # 585a <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0)
    31c2:	00004597          	auipc	a1,0x4
    31c6:	2be58593          	addi	a1,a1,702 # 7480 <malloc+0x1818>
    31ca:	00004517          	auipc	a0,0x4
    31ce:	22e50513          	addi	a0,a0,558 # 73f8 <malloc+0x1790>
    31d2:	00002097          	auipc	ra,0x2
    31d6:	6c0080e7          	jalr	1728(ra) # 5892 <link>
    31da:	34051b63          	bnez	a0,3530 <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0)
    31de:	00004517          	auipc	a0,0x4
    31e2:	21a50513          	addi	a0,a0,538 # 73f8 <malloc+0x1790>
    31e6:	00002097          	auipc	ra,0x2
    31ea:	69c080e7          	jalr	1692(ra) # 5882 <unlink>
    31ee:	34051f63          	bnez	a0,354c <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0)
    31f2:	4581                	li	a1,0
    31f4:	00004517          	auipc	a0,0x4
    31f8:	20450513          	addi	a0,a0,516 # 73f8 <malloc+0x1790>
    31fc:	00002097          	auipc	ra,0x2
    3200:	676080e7          	jalr	1654(ra) # 5872 <open>
    3204:	36055263          	bgez	a0,3568 <subdir+0x4b6>
  if (chdir("dd") != 0)
    3208:	00004517          	auipc	a0,0x4
    320c:	15050513          	addi	a0,a0,336 # 7358 <malloc+0x16f0>
    3210:	00002097          	auipc	ra,0x2
    3214:	692080e7          	jalr	1682(ra) # 58a2 <chdir>
    3218:	36051663          	bnez	a0,3584 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0)
    321c:	00004517          	auipc	a0,0x4
    3220:	2fc50513          	addi	a0,a0,764 # 7518 <malloc+0x18b0>
    3224:	00002097          	auipc	ra,0x2
    3228:	67e080e7          	jalr	1662(ra) # 58a2 <chdir>
    322c:	36051a63          	bnez	a0,35a0 <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0)
    3230:	00004517          	auipc	a0,0x4
    3234:	31850513          	addi	a0,a0,792 # 7548 <malloc+0x18e0>
    3238:	00002097          	auipc	ra,0x2
    323c:	66a080e7          	jalr	1642(ra) # 58a2 <chdir>
    3240:	36051e63          	bnez	a0,35bc <subdir+0x50a>
  if (chdir("./..") != 0)
    3244:	00004517          	auipc	a0,0x4
    3248:	33450513          	addi	a0,a0,820 # 7578 <malloc+0x1910>
    324c:	00002097          	auipc	ra,0x2
    3250:	656080e7          	jalr	1622(ra) # 58a2 <chdir>
    3254:	38051263          	bnez	a0,35d8 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3258:	4581                	li	a1,0
    325a:	00004517          	auipc	a0,0x4
    325e:	22650513          	addi	a0,a0,550 # 7480 <malloc+0x1818>
    3262:	00002097          	auipc	ra,0x2
    3266:	610080e7          	jalr	1552(ra) # 5872 <open>
    326a:	84aa                	mv	s1,a0
  if (fd < 0)
    326c:	38054463          	bltz	a0,35f4 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2)
    3270:	660d                	lui	a2,0x3
    3272:	00009597          	auipc	a1,0x9
    3276:	aae58593          	addi	a1,a1,-1362 # bd20 <buf>
    327a:	00002097          	auipc	ra,0x2
    327e:	5d0080e7          	jalr	1488(ra) # 584a <read>
    3282:	4789                	li	a5,2
    3284:	38f51663          	bne	a0,a5,3610 <subdir+0x55e>
  close(fd);
    3288:	8526                	mv	a0,s1
    328a:	00002097          	auipc	ra,0x2
    328e:	5d0080e7          	jalr	1488(ra) # 585a <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0)
    3292:	4581                	li	a1,0
    3294:	00004517          	auipc	a0,0x4
    3298:	16450513          	addi	a0,a0,356 # 73f8 <malloc+0x1790>
    329c:	00002097          	auipc	ra,0x2
    32a0:	5d6080e7          	jalr	1494(ra) # 5872 <open>
    32a4:	38055463          	bgez	a0,362c <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0)
    32a8:	20200593          	li	a1,514
    32ac:	00004517          	auipc	a0,0x4
    32b0:	35c50513          	addi	a0,a0,860 # 7608 <malloc+0x19a0>
    32b4:	00002097          	auipc	ra,0x2
    32b8:	5be080e7          	jalr	1470(ra) # 5872 <open>
    32bc:	38055663          	bgez	a0,3648 <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0)
    32c0:	20200593          	li	a1,514
    32c4:	00004517          	auipc	a0,0x4
    32c8:	37450513          	addi	a0,a0,884 # 7638 <malloc+0x19d0>
    32cc:	00002097          	auipc	ra,0x2
    32d0:	5a6080e7          	jalr	1446(ra) # 5872 <open>
    32d4:	38055863          	bgez	a0,3664 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0)
    32d8:	20000593          	li	a1,512
    32dc:	00004517          	auipc	a0,0x4
    32e0:	07c50513          	addi	a0,a0,124 # 7358 <malloc+0x16f0>
    32e4:	00002097          	auipc	ra,0x2
    32e8:	58e080e7          	jalr	1422(ra) # 5872 <open>
    32ec:	38055a63          	bgez	a0,3680 <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0)
    32f0:	4589                	li	a1,2
    32f2:	00004517          	auipc	a0,0x4
    32f6:	06650513          	addi	a0,a0,102 # 7358 <malloc+0x16f0>
    32fa:	00002097          	auipc	ra,0x2
    32fe:	578080e7          	jalr	1400(ra) # 5872 <open>
    3302:	38055d63          	bgez	a0,369c <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0)
    3306:	4585                	li	a1,1
    3308:	00004517          	auipc	a0,0x4
    330c:	05050513          	addi	a0,a0,80 # 7358 <malloc+0x16f0>
    3310:	00002097          	auipc	ra,0x2
    3314:	562080e7          	jalr	1378(ra) # 5872 <open>
    3318:	3a055063          	bgez	a0,36b8 <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0)
    331c:	00004597          	auipc	a1,0x4
    3320:	3ac58593          	addi	a1,a1,940 # 76c8 <malloc+0x1a60>
    3324:	00004517          	auipc	a0,0x4
    3328:	2e450513          	addi	a0,a0,740 # 7608 <malloc+0x19a0>
    332c:	00002097          	auipc	ra,0x2
    3330:	566080e7          	jalr	1382(ra) # 5892 <link>
    3334:	3a050063          	beqz	a0,36d4 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0)
    3338:	00004597          	auipc	a1,0x4
    333c:	39058593          	addi	a1,a1,912 # 76c8 <malloc+0x1a60>
    3340:	00004517          	auipc	a0,0x4
    3344:	2f850513          	addi	a0,a0,760 # 7638 <malloc+0x19d0>
    3348:	00002097          	auipc	ra,0x2
    334c:	54a080e7          	jalr	1354(ra) # 5892 <link>
    3350:	3a050063          	beqz	a0,36f0 <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0)
    3354:	00004597          	auipc	a1,0x4
    3358:	12c58593          	addi	a1,a1,300 # 7480 <malloc+0x1818>
    335c:	00004517          	auipc	a0,0x4
    3360:	01c50513          	addi	a0,a0,28 # 7378 <malloc+0x1710>
    3364:	00002097          	auipc	ra,0x2
    3368:	52e080e7          	jalr	1326(ra) # 5892 <link>
    336c:	3a050063          	beqz	a0,370c <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0)
    3370:	00004517          	auipc	a0,0x4
    3374:	29850513          	addi	a0,a0,664 # 7608 <malloc+0x19a0>
    3378:	00002097          	auipc	ra,0x2
    337c:	522080e7          	jalr	1314(ra) # 589a <mkdir>
    3380:	3a050463          	beqz	a0,3728 <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0)
    3384:	00004517          	auipc	a0,0x4
    3388:	2b450513          	addi	a0,a0,692 # 7638 <malloc+0x19d0>
    338c:	00002097          	auipc	ra,0x2
    3390:	50e080e7          	jalr	1294(ra) # 589a <mkdir>
    3394:	3a050863          	beqz	a0,3744 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0)
    3398:	00004517          	auipc	a0,0x4
    339c:	0e850513          	addi	a0,a0,232 # 7480 <malloc+0x1818>
    33a0:	00002097          	auipc	ra,0x2
    33a4:	4fa080e7          	jalr	1274(ra) # 589a <mkdir>
    33a8:	3a050c63          	beqz	a0,3760 <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0)
    33ac:	00004517          	auipc	a0,0x4
    33b0:	28c50513          	addi	a0,a0,652 # 7638 <malloc+0x19d0>
    33b4:	00002097          	auipc	ra,0x2
    33b8:	4ce080e7          	jalr	1230(ra) # 5882 <unlink>
    33bc:	3c050063          	beqz	a0,377c <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0)
    33c0:	00004517          	auipc	a0,0x4
    33c4:	24850513          	addi	a0,a0,584 # 7608 <malloc+0x19a0>
    33c8:	00002097          	auipc	ra,0x2
    33cc:	4ba080e7          	jalr	1210(ra) # 5882 <unlink>
    33d0:	3c050463          	beqz	a0,3798 <subdir+0x6e6>
  if (chdir("dd/ff") == 0)
    33d4:	00004517          	auipc	a0,0x4
    33d8:	fa450513          	addi	a0,a0,-92 # 7378 <malloc+0x1710>
    33dc:	00002097          	auipc	ra,0x2
    33e0:	4c6080e7          	jalr	1222(ra) # 58a2 <chdir>
    33e4:	3c050863          	beqz	a0,37b4 <subdir+0x702>
  if (chdir("dd/xx") == 0)
    33e8:	00004517          	auipc	a0,0x4
    33ec:	43050513          	addi	a0,a0,1072 # 7818 <malloc+0x1bb0>
    33f0:	00002097          	auipc	ra,0x2
    33f4:	4b2080e7          	jalr	1202(ra) # 58a2 <chdir>
    33f8:	3c050c63          	beqz	a0,37d0 <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0)
    33fc:	00004517          	auipc	a0,0x4
    3400:	08450513          	addi	a0,a0,132 # 7480 <malloc+0x1818>
    3404:	00002097          	auipc	ra,0x2
    3408:	47e080e7          	jalr	1150(ra) # 5882 <unlink>
    340c:	3e051063          	bnez	a0,37ec <subdir+0x73a>
  if (unlink("dd/ff") != 0)
    3410:	00004517          	auipc	a0,0x4
    3414:	f6850513          	addi	a0,a0,-152 # 7378 <malloc+0x1710>
    3418:	00002097          	auipc	ra,0x2
    341c:	46a080e7          	jalr	1130(ra) # 5882 <unlink>
    3420:	3e051463          	bnez	a0,3808 <subdir+0x756>
  if (unlink("dd") == 0)
    3424:	00004517          	auipc	a0,0x4
    3428:	f3450513          	addi	a0,a0,-204 # 7358 <malloc+0x16f0>
    342c:	00002097          	auipc	ra,0x2
    3430:	456080e7          	jalr	1110(ra) # 5882 <unlink>
    3434:	3e050863          	beqz	a0,3824 <subdir+0x772>
  if (unlink("dd/dd") < 0)
    3438:	00004517          	auipc	a0,0x4
    343c:	45050513          	addi	a0,a0,1104 # 7888 <malloc+0x1c20>
    3440:	00002097          	auipc	ra,0x2
    3444:	442080e7          	jalr	1090(ra) # 5882 <unlink>
    3448:	3e054c63          	bltz	a0,3840 <subdir+0x78e>
  if (unlink("dd") < 0)
    344c:	00004517          	auipc	a0,0x4
    3450:	f0c50513          	addi	a0,a0,-244 # 7358 <malloc+0x16f0>
    3454:	00002097          	auipc	ra,0x2
    3458:	42e080e7          	jalr	1070(ra) # 5882 <unlink>
    345c:	40054063          	bltz	a0,385c <subdir+0x7aa>
}
    3460:	60e2                	ld	ra,24(sp)
    3462:	6442                	ld	s0,16(sp)
    3464:	64a2                	ld	s1,8(sp)
    3466:	6902                	ld	s2,0(sp)
    3468:	6105                	addi	sp,sp,32
    346a:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    346c:	85ca                	mv	a1,s2
    346e:	00004517          	auipc	a0,0x4
    3472:	ef250513          	addi	a0,a0,-270 # 7360 <malloc+0x16f8>
    3476:	00002097          	auipc	ra,0x2
    347a:	734080e7          	jalr	1844(ra) # 5baa <printf>
    exit(1);
    347e:	4505                	li	a0,1
    3480:	00002097          	auipc	ra,0x2
    3484:	3b2080e7          	jalr	946(ra) # 5832 <exit>
    printf("%s: create dd/ff failed\n", s);
    3488:	85ca                	mv	a1,s2
    348a:	00004517          	auipc	a0,0x4
    348e:	ef650513          	addi	a0,a0,-266 # 7380 <malloc+0x1718>
    3492:	00002097          	auipc	ra,0x2
    3496:	718080e7          	jalr	1816(ra) # 5baa <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	00002097          	auipc	ra,0x2
    34a0:	396080e7          	jalr	918(ra) # 5832 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    34a4:	85ca                	mv	a1,s2
    34a6:	00004517          	auipc	a0,0x4
    34aa:	efa50513          	addi	a0,a0,-262 # 73a0 <malloc+0x1738>
    34ae:	00002097          	auipc	ra,0x2
    34b2:	6fc080e7          	jalr	1788(ra) # 5baa <printf>
    exit(1);
    34b6:	4505                	li	a0,1
    34b8:	00002097          	auipc	ra,0x2
    34bc:	37a080e7          	jalr	890(ra) # 5832 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    34c0:	85ca                	mv	a1,s2
    34c2:	00004517          	auipc	a0,0x4
    34c6:	f1650513          	addi	a0,a0,-234 # 73d8 <malloc+0x1770>
    34ca:	00002097          	auipc	ra,0x2
    34ce:	6e0080e7          	jalr	1760(ra) # 5baa <printf>
    exit(1);
    34d2:	4505                	li	a0,1
    34d4:	00002097          	auipc	ra,0x2
    34d8:	35e080e7          	jalr	862(ra) # 5832 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    34dc:	85ca                	mv	a1,s2
    34de:	00004517          	auipc	a0,0x4
    34e2:	f2a50513          	addi	a0,a0,-214 # 7408 <malloc+0x17a0>
    34e6:	00002097          	auipc	ra,0x2
    34ea:	6c4080e7          	jalr	1732(ra) # 5baa <printf>
    exit(1);
    34ee:	4505                	li	a0,1
    34f0:	00002097          	auipc	ra,0x2
    34f4:	342080e7          	jalr	834(ra) # 5832 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    34f8:	85ca                	mv	a1,s2
    34fa:	00004517          	auipc	a0,0x4
    34fe:	f4650513          	addi	a0,a0,-186 # 7440 <malloc+0x17d8>
    3502:	00002097          	auipc	ra,0x2
    3506:	6a8080e7          	jalr	1704(ra) # 5baa <printf>
    exit(1);
    350a:	4505                	li	a0,1
    350c:	00002097          	auipc	ra,0x2
    3510:	326080e7          	jalr	806(ra) # 5832 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3514:	85ca                	mv	a1,s2
    3516:	00004517          	auipc	a0,0x4
    351a:	f4a50513          	addi	a0,a0,-182 # 7460 <malloc+0x17f8>
    351e:	00002097          	auipc	ra,0x2
    3522:	68c080e7          	jalr	1676(ra) # 5baa <printf>
    exit(1);
    3526:	4505                	li	a0,1
    3528:	00002097          	auipc	ra,0x2
    352c:	30a080e7          	jalr	778(ra) # 5832 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3530:	85ca                	mv	a1,s2
    3532:	00004517          	auipc	a0,0x4
    3536:	f5e50513          	addi	a0,a0,-162 # 7490 <malloc+0x1828>
    353a:	00002097          	auipc	ra,0x2
    353e:	670080e7          	jalr	1648(ra) # 5baa <printf>
    exit(1);
    3542:	4505                	li	a0,1
    3544:	00002097          	auipc	ra,0x2
    3548:	2ee080e7          	jalr	750(ra) # 5832 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    354c:	85ca                	mv	a1,s2
    354e:	00004517          	auipc	a0,0x4
    3552:	f6a50513          	addi	a0,a0,-150 # 74b8 <malloc+0x1850>
    3556:	00002097          	auipc	ra,0x2
    355a:	654080e7          	jalr	1620(ra) # 5baa <printf>
    exit(1);
    355e:	4505                	li	a0,1
    3560:	00002097          	auipc	ra,0x2
    3564:	2d2080e7          	jalr	722(ra) # 5832 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3568:	85ca                	mv	a1,s2
    356a:	00004517          	auipc	a0,0x4
    356e:	f6e50513          	addi	a0,a0,-146 # 74d8 <malloc+0x1870>
    3572:	00002097          	auipc	ra,0x2
    3576:	638080e7          	jalr	1592(ra) # 5baa <printf>
    exit(1);
    357a:	4505                	li	a0,1
    357c:	00002097          	auipc	ra,0x2
    3580:	2b6080e7          	jalr	694(ra) # 5832 <exit>
    printf("%s: chdir dd failed\n", s);
    3584:	85ca                	mv	a1,s2
    3586:	00004517          	auipc	a0,0x4
    358a:	f7a50513          	addi	a0,a0,-134 # 7500 <malloc+0x1898>
    358e:	00002097          	auipc	ra,0x2
    3592:	61c080e7          	jalr	1564(ra) # 5baa <printf>
    exit(1);
    3596:	4505                	li	a0,1
    3598:	00002097          	auipc	ra,0x2
    359c:	29a080e7          	jalr	666(ra) # 5832 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    35a0:	85ca                	mv	a1,s2
    35a2:	00004517          	auipc	a0,0x4
    35a6:	f8650513          	addi	a0,a0,-122 # 7528 <malloc+0x18c0>
    35aa:	00002097          	auipc	ra,0x2
    35ae:	600080e7          	jalr	1536(ra) # 5baa <printf>
    exit(1);
    35b2:	4505                	li	a0,1
    35b4:	00002097          	auipc	ra,0x2
    35b8:	27e080e7          	jalr	638(ra) # 5832 <exit>
    printf("chdir dd/../../dd failed\n", s);
    35bc:	85ca                	mv	a1,s2
    35be:	00004517          	auipc	a0,0x4
    35c2:	f9a50513          	addi	a0,a0,-102 # 7558 <malloc+0x18f0>
    35c6:	00002097          	auipc	ra,0x2
    35ca:	5e4080e7          	jalr	1508(ra) # 5baa <printf>
    exit(1);
    35ce:	4505                	li	a0,1
    35d0:	00002097          	auipc	ra,0x2
    35d4:	262080e7          	jalr	610(ra) # 5832 <exit>
    printf("%s: chdir ./.. failed\n", s);
    35d8:	85ca                	mv	a1,s2
    35da:	00004517          	auipc	a0,0x4
    35de:	fa650513          	addi	a0,a0,-90 # 7580 <malloc+0x1918>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	5c8080e7          	jalr	1480(ra) # 5baa <printf>
    exit(1);
    35ea:	4505                	li	a0,1
    35ec:	00002097          	auipc	ra,0x2
    35f0:	246080e7          	jalr	582(ra) # 5832 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    35f4:	85ca                	mv	a1,s2
    35f6:	00004517          	auipc	a0,0x4
    35fa:	fa250513          	addi	a0,a0,-94 # 7598 <malloc+0x1930>
    35fe:	00002097          	auipc	ra,0x2
    3602:	5ac080e7          	jalr	1452(ra) # 5baa <printf>
    exit(1);
    3606:	4505                	li	a0,1
    3608:	00002097          	auipc	ra,0x2
    360c:	22a080e7          	jalr	554(ra) # 5832 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3610:	85ca                	mv	a1,s2
    3612:	00004517          	auipc	a0,0x4
    3616:	fa650513          	addi	a0,a0,-90 # 75b8 <malloc+0x1950>
    361a:	00002097          	auipc	ra,0x2
    361e:	590080e7          	jalr	1424(ra) # 5baa <printf>
    exit(1);
    3622:	4505                	li	a0,1
    3624:	00002097          	auipc	ra,0x2
    3628:	20e080e7          	jalr	526(ra) # 5832 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    362c:	85ca                	mv	a1,s2
    362e:	00004517          	auipc	a0,0x4
    3632:	faa50513          	addi	a0,a0,-86 # 75d8 <malloc+0x1970>
    3636:	00002097          	auipc	ra,0x2
    363a:	574080e7          	jalr	1396(ra) # 5baa <printf>
    exit(1);
    363e:	4505                	li	a0,1
    3640:	00002097          	auipc	ra,0x2
    3644:	1f2080e7          	jalr	498(ra) # 5832 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3648:	85ca                	mv	a1,s2
    364a:	00004517          	auipc	a0,0x4
    364e:	fce50513          	addi	a0,a0,-50 # 7618 <malloc+0x19b0>
    3652:	00002097          	auipc	ra,0x2
    3656:	558080e7          	jalr	1368(ra) # 5baa <printf>
    exit(1);
    365a:	4505                	li	a0,1
    365c:	00002097          	auipc	ra,0x2
    3660:	1d6080e7          	jalr	470(ra) # 5832 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3664:	85ca                	mv	a1,s2
    3666:	00004517          	auipc	a0,0x4
    366a:	fe250513          	addi	a0,a0,-30 # 7648 <malloc+0x19e0>
    366e:	00002097          	auipc	ra,0x2
    3672:	53c080e7          	jalr	1340(ra) # 5baa <printf>
    exit(1);
    3676:	4505                	li	a0,1
    3678:	00002097          	auipc	ra,0x2
    367c:	1ba080e7          	jalr	442(ra) # 5832 <exit>
    printf("%s: create dd succeeded!\n", s);
    3680:	85ca                	mv	a1,s2
    3682:	00004517          	auipc	a0,0x4
    3686:	fe650513          	addi	a0,a0,-26 # 7668 <malloc+0x1a00>
    368a:	00002097          	auipc	ra,0x2
    368e:	520080e7          	jalr	1312(ra) # 5baa <printf>
    exit(1);
    3692:	4505                	li	a0,1
    3694:	00002097          	auipc	ra,0x2
    3698:	19e080e7          	jalr	414(ra) # 5832 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    369c:	85ca                	mv	a1,s2
    369e:	00004517          	auipc	a0,0x4
    36a2:	fea50513          	addi	a0,a0,-22 # 7688 <malloc+0x1a20>
    36a6:	00002097          	auipc	ra,0x2
    36aa:	504080e7          	jalr	1284(ra) # 5baa <printf>
    exit(1);
    36ae:	4505                	li	a0,1
    36b0:	00002097          	auipc	ra,0x2
    36b4:	182080e7          	jalr	386(ra) # 5832 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    36b8:	85ca                	mv	a1,s2
    36ba:	00004517          	auipc	a0,0x4
    36be:	fee50513          	addi	a0,a0,-18 # 76a8 <malloc+0x1a40>
    36c2:	00002097          	auipc	ra,0x2
    36c6:	4e8080e7          	jalr	1256(ra) # 5baa <printf>
    exit(1);
    36ca:	4505                	li	a0,1
    36cc:	00002097          	auipc	ra,0x2
    36d0:	166080e7          	jalr	358(ra) # 5832 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    36d4:	85ca                	mv	a1,s2
    36d6:	00004517          	auipc	a0,0x4
    36da:	00250513          	addi	a0,a0,2 # 76d8 <malloc+0x1a70>
    36de:	00002097          	auipc	ra,0x2
    36e2:	4cc080e7          	jalr	1228(ra) # 5baa <printf>
    exit(1);
    36e6:	4505                	li	a0,1
    36e8:	00002097          	auipc	ra,0x2
    36ec:	14a080e7          	jalr	330(ra) # 5832 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    36f0:	85ca                	mv	a1,s2
    36f2:	00004517          	auipc	a0,0x4
    36f6:	00e50513          	addi	a0,a0,14 # 7700 <malloc+0x1a98>
    36fa:	00002097          	auipc	ra,0x2
    36fe:	4b0080e7          	jalr	1200(ra) # 5baa <printf>
    exit(1);
    3702:	4505                	li	a0,1
    3704:	00002097          	auipc	ra,0x2
    3708:	12e080e7          	jalr	302(ra) # 5832 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    370c:	85ca                	mv	a1,s2
    370e:	00004517          	auipc	a0,0x4
    3712:	01a50513          	addi	a0,a0,26 # 7728 <malloc+0x1ac0>
    3716:	00002097          	auipc	ra,0x2
    371a:	494080e7          	jalr	1172(ra) # 5baa <printf>
    exit(1);
    371e:	4505                	li	a0,1
    3720:	00002097          	auipc	ra,0x2
    3724:	112080e7          	jalr	274(ra) # 5832 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3728:	85ca                	mv	a1,s2
    372a:	00004517          	auipc	a0,0x4
    372e:	02650513          	addi	a0,a0,38 # 7750 <malloc+0x1ae8>
    3732:	00002097          	auipc	ra,0x2
    3736:	478080e7          	jalr	1144(ra) # 5baa <printf>
    exit(1);
    373a:	4505                	li	a0,1
    373c:	00002097          	auipc	ra,0x2
    3740:	0f6080e7          	jalr	246(ra) # 5832 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3744:	85ca                	mv	a1,s2
    3746:	00004517          	auipc	a0,0x4
    374a:	02a50513          	addi	a0,a0,42 # 7770 <malloc+0x1b08>
    374e:	00002097          	auipc	ra,0x2
    3752:	45c080e7          	jalr	1116(ra) # 5baa <printf>
    exit(1);
    3756:	4505                	li	a0,1
    3758:	00002097          	auipc	ra,0x2
    375c:	0da080e7          	jalr	218(ra) # 5832 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3760:	85ca                	mv	a1,s2
    3762:	00004517          	auipc	a0,0x4
    3766:	02e50513          	addi	a0,a0,46 # 7790 <malloc+0x1b28>
    376a:	00002097          	auipc	ra,0x2
    376e:	440080e7          	jalr	1088(ra) # 5baa <printf>
    exit(1);
    3772:	4505                	li	a0,1
    3774:	00002097          	auipc	ra,0x2
    3778:	0be080e7          	jalr	190(ra) # 5832 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    377c:	85ca                	mv	a1,s2
    377e:	00004517          	auipc	a0,0x4
    3782:	03a50513          	addi	a0,a0,58 # 77b8 <malloc+0x1b50>
    3786:	00002097          	auipc	ra,0x2
    378a:	424080e7          	jalr	1060(ra) # 5baa <printf>
    exit(1);
    378e:	4505                	li	a0,1
    3790:	00002097          	auipc	ra,0x2
    3794:	0a2080e7          	jalr	162(ra) # 5832 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3798:	85ca                	mv	a1,s2
    379a:	00004517          	auipc	a0,0x4
    379e:	03e50513          	addi	a0,a0,62 # 77d8 <malloc+0x1b70>
    37a2:	00002097          	auipc	ra,0x2
    37a6:	408080e7          	jalr	1032(ra) # 5baa <printf>
    exit(1);
    37aa:	4505                	li	a0,1
    37ac:	00002097          	auipc	ra,0x2
    37b0:	086080e7          	jalr	134(ra) # 5832 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    37b4:	85ca                	mv	a1,s2
    37b6:	00004517          	auipc	a0,0x4
    37ba:	04250513          	addi	a0,a0,66 # 77f8 <malloc+0x1b90>
    37be:	00002097          	auipc	ra,0x2
    37c2:	3ec080e7          	jalr	1004(ra) # 5baa <printf>
    exit(1);
    37c6:	4505                	li	a0,1
    37c8:	00002097          	auipc	ra,0x2
    37cc:	06a080e7          	jalr	106(ra) # 5832 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    37d0:	85ca                	mv	a1,s2
    37d2:	00004517          	auipc	a0,0x4
    37d6:	04e50513          	addi	a0,a0,78 # 7820 <malloc+0x1bb8>
    37da:	00002097          	auipc	ra,0x2
    37de:	3d0080e7          	jalr	976(ra) # 5baa <printf>
    exit(1);
    37e2:	4505                	li	a0,1
    37e4:	00002097          	auipc	ra,0x2
    37e8:	04e080e7          	jalr	78(ra) # 5832 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    37ec:	85ca                	mv	a1,s2
    37ee:	00004517          	auipc	a0,0x4
    37f2:	cca50513          	addi	a0,a0,-822 # 74b8 <malloc+0x1850>
    37f6:	00002097          	auipc	ra,0x2
    37fa:	3b4080e7          	jalr	948(ra) # 5baa <printf>
    exit(1);
    37fe:	4505                	li	a0,1
    3800:	00002097          	auipc	ra,0x2
    3804:	032080e7          	jalr	50(ra) # 5832 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3808:	85ca                	mv	a1,s2
    380a:	00004517          	auipc	a0,0x4
    380e:	03650513          	addi	a0,a0,54 # 7840 <malloc+0x1bd8>
    3812:	00002097          	auipc	ra,0x2
    3816:	398080e7          	jalr	920(ra) # 5baa <printf>
    exit(1);
    381a:	4505                	li	a0,1
    381c:	00002097          	auipc	ra,0x2
    3820:	016080e7          	jalr	22(ra) # 5832 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3824:	85ca                	mv	a1,s2
    3826:	00004517          	auipc	a0,0x4
    382a:	03a50513          	addi	a0,a0,58 # 7860 <malloc+0x1bf8>
    382e:	00002097          	auipc	ra,0x2
    3832:	37c080e7          	jalr	892(ra) # 5baa <printf>
    exit(1);
    3836:	4505                	li	a0,1
    3838:	00002097          	auipc	ra,0x2
    383c:	ffa080e7          	jalr	-6(ra) # 5832 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3840:	85ca                	mv	a1,s2
    3842:	00004517          	auipc	a0,0x4
    3846:	04e50513          	addi	a0,a0,78 # 7890 <malloc+0x1c28>
    384a:	00002097          	auipc	ra,0x2
    384e:	360080e7          	jalr	864(ra) # 5baa <printf>
    exit(1);
    3852:	4505                	li	a0,1
    3854:	00002097          	auipc	ra,0x2
    3858:	fde080e7          	jalr	-34(ra) # 5832 <exit>
    printf("%s: unlink dd failed\n", s);
    385c:	85ca                	mv	a1,s2
    385e:	00004517          	auipc	a0,0x4
    3862:	05250513          	addi	a0,a0,82 # 78b0 <malloc+0x1c48>
    3866:	00002097          	auipc	ra,0x2
    386a:	344080e7          	jalr	836(ra) # 5baa <printf>
    exit(1);
    386e:	4505                	li	a0,1
    3870:	00002097          	auipc	ra,0x2
    3874:	fc2080e7          	jalr	-62(ra) # 5832 <exit>

0000000000003878 <rmdot>:
{
    3878:	1101                	addi	sp,sp,-32
    387a:	ec06                	sd	ra,24(sp)
    387c:	e822                	sd	s0,16(sp)
    387e:	e426                	sd	s1,8(sp)
    3880:	1000                	addi	s0,sp,32
    3882:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0)
    3884:	00004517          	auipc	a0,0x4
    3888:	04450513          	addi	a0,a0,68 # 78c8 <malloc+0x1c60>
    388c:	00002097          	auipc	ra,0x2
    3890:	00e080e7          	jalr	14(ra) # 589a <mkdir>
    3894:	e549                	bnez	a0,391e <rmdot+0xa6>
  if (chdir("dots") != 0)
    3896:	00004517          	auipc	a0,0x4
    389a:	03250513          	addi	a0,a0,50 # 78c8 <malloc+0x1c60>
    389e:	00002097          	auipc	ra,0x2
    38a2:	004080e7          	jalr	4(ra) # 58a2 <chdir>
    38a6:	e951                	bnez	a0,393a <rmdot+0xc2>
  if (unlink(".") == 0)
    38a8:	00003517          	auipc	a0,0x3
    38ac:	eb850513          	addi	a0,a0,-328 # 6760 <malloc+0xaf8>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	fd2080e7          	jalr	-46(ra) # 5882 <unlink>
    38b8:	cd59                	beqz	a0,3956 <rmdot+0xde>
  if (unlink("..") == 0)
    38ba:	00004517          	auipc	a0,0x4
    38be:	a6650513          	addi	a0,a0,-1434 # 7320 <malloc+0x16b8>
    38c2:	00002097          	auipc	ra,0x2
    38c6:	fc0080e7          	jalr	-64(ra) # 5882 <unlink>
    38ca:	c545                	beqz	a0,3972 <rmdot+0xfa>
  if (chdir("/") != 0)
    38cc:	00004517          	auipc	a0,0x4
    38d0:	9fc50513          	addi	a0,a0,-1540 # 72c8 <malloc+0x1660>
    38d4:	00002097          	auipc	ra,0x2
    38d8:	fce080e7          	jalr	-50(ra) # 58a2 <chdir>
    38dc:	e94d                	bnez	a0,398e <rmdot+0x116>
  if (unlink("dots/.") == 0)
    38de:	00004517          	auipc	a0,0x4
    38e2:	05250513          	addi	a0,a0,82 # 7930 <malloc+0x1cc8>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	f9c080e7          	jalr	-100(ra) # 5882 <unlink>
    38ee:	cd55                	beqz	a0,39aa <rmdot+0x132>
  if (unlink("dots/..") == 0)
    38f0:	00004517          	auipc	a0,0x4
    38f4:	06850513          	addi	a0,a0,104 # 7958 <malloc+0x1cf0>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	f8a080e7          	jalr	-118(ra) # 5882 <unlink>
    3900:	c179                	beqz	a0,39c6 <rmdot+0x14e>
  if (unlink("dots") != 0)
    3902:	00004517          	auipc	a0,0x4
    3906:	fc650513          	addi	a0,a0,-58 # 78c8 <malloc+0x1c60>
    390a:	00002097          	auipc	ra,0x2
    390e:	f78080e7          	jalr	-136(ra) # 5882 <unlink>
    3912:	e961                	bnez	a0,39e2 <rmdot+0x16a>
}
    3914:	60e2                	ld	ra,24(sp)
    3916:	6442                	ld	s0,16(sp)
    3918:	64a2                	ld	s1,8(sp)
    391a:	6105                	addi	sp,sp,32
    391c:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    391e:	85a6                	mv	a1,s1
    3920:	00004517          	auipc	a0,0x4
    3924:	fb050513          	addi	a0,a0,-80 # 78d0 <malloc+0x1c68>
    3928:	00002097          	auipc	ra,0x2
    392c:	282080e7          	jalr	642(ra) # 5baa <printf>
    exit(1);
    3930:	4505                	li	a0,1
    3932:	00002097          	auipc	ra,0x2
    3936:	f00080e7          	jalr	-256(ra) # 5832 <exit>
    printf("%s: chdir dots failed\n", s);
    393a:	85a6                	mv	a1,s1
    393c:	00004517          	auipc	a0,0x4
    3940:	fac50513          	addi	a0,a0,-84 # 78e8 <malloc+0x1c80>
    3944:	00002097          	auipc	ra,0x2
    3948:	266080e7          	jalr	614(ra) # 5baa <printf>
    exit(1);
    394c:	4505                	li	a0,1
    394e:	00002097          	auipc	ra,0x2
    3952:	ee4080e7          	jalr	-284(ra) # 5832 <exit>
    printf("%s: rm . worked!\n", s);
    3956:	85a6                	mv	a1,s1
    3958:	00004517          	auipc	a0,0x4
    395c:	fa850513          	addi	a0,a0,-88 # 7900 <malloc+0x1c98>
    3960:	00002097          	auipc	ra,0x2
    3964:	24a080e7          	jalr	586(ra) # 5baa <printf>
    exit(1);
    3968:	4505                	li	a0,1
    396a:	00002097          	auipc	ra,0x2
    396e:	ec8080e7          	jalr	-312(ra) # 5832 <exit>
    printf("%s: rm .. worked!\n", s);
    3972:	85a6                	mv	a1,s1
    3974:	00004517          	auipc	a0,0x4
    3978:	fa450513          	addi	a0,a0,-92 # 7918 <malloc+0x1cb0>
    397c:	00002097          	auipc	ra,0x2
    3980:	22e080e7          	jalr	558(ra) # 5baa <printf>
    exit(1);
    3984:	4505                	li	a0,1
    3986:	00002097          	auipc	ra,0x2
    398a:	eac080e7          	jalr	-340(ra) # 5832 <exit>
    printf("%s: chdir / failed\n", s);
    398e:	85a6                	mv	a1,s1
    3990:	00004517          	auipc	a0,0x4
    3994:	94050513          	addi	a0,a0,-1728 # 72d0 <malloc+0x1668>
    3998:	00002097          	auipc	ra,0x2
    399c:	212080e7          	jalr	530(ra) # 5baa <printf>
    exit(1);
    39a0:	4505                	li	a0,1
    39a2:	00002097          	auipc	ra,0x2
    39a6:	e90080e7          	jalr	-368(ra) # 5832 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    39aa:	85a6                	mv	a1,s1
    39ac:	00004517          	auipc	a0,0x4
    39b0:	f8c50513          	addi	a0,a0,-116 # 7938 <malloc+0x1cd0>
    39b4:	00002097          	auipc	ra,0x2
    39b8:	1f6080e7          	jalr	502(ra) # 5baa <printf>
    exit(1);
    39bc:	4505                	li	a0,1
    39be:	00002097          	auipc	ra,0x2
    39c2:	e74080e7          	jalr	-396(ra) # 5832 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    39c6:	85a6                	mv	a1,s1
    39c8:	00004517          	auipc	a0,0x4
    39cc:	f9850513          	addi	a0,a0,-104 # 7960 <malloc+0x1cf8>
    39d0:	00002097          	auipc	ra,0x2
    39d4:	1da080e7          	jalr	474(ra) # 5baa <printf>
    exit(1);
    39d8:	4505                	li	a0,1
    39da:	00002097          	auipc	ra,0x2
    39de:	e58080e7          	jalr	-424(ra) # 5832 <exit>
    printf("%s: unlink dots failed!\n", s);
    39e2:	85a6                	mv	a1,s1
    39e4:	00004517          	auipc	a0,0x4
    39e8:	f9c50513          	addi	a0,a0,-100 # 7980 <malloc+0x1d18>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	1be080e7          	jalr	446(ra) # 5baa <printf>
    exit(1);
    39f4:	4505                	li	a0,1
    39f6:	00002097          	auipc	ra,0x2
    39fa:	e3c080e7          	jalr	-452(ra) # 5832 <exit>

00000000000039fe <dirfile>:
{
    39fe:	1101                	addi	sp,sp,-32
    3a00:	ec06                	sd	ra,24(sp)
    3a02:	e822                	sd	s0,16(sp)
    3a04:	e426                	sd	s1,8(sp)
    3a06:	e04a                	sd	s2,0(sp)
    3a08:	1000                	addi	s0,sp,32
    3a0a:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3a0c:	20000593          	li	a1,512
    3a10:	00002517          	auipc	a0,0x2
    3a14:	65850513          	addi	a0,a0,1624 # 6068 <malloc+0x400>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	e5a080e7          	jalr	-422(ra) # 5872 <open>
  if (fd < 0)
    3a20:	0e054d63          	bltz	a0,3b1a <dirfile+0x11c>
  close(fd);
    3a24:	00002097          	auipc	ra,0x2
    3a28:	e36080e7          	jalr	-458(ra) # 585a <close>
  if (chdir("dirfile") == 0)
    3a2c:	00002517          	auipc	a0,0x2
    3a30:	63c50513          	addi	a0,a0,1596 # 6068 <malloc+0x400>
    3a34:	00002097          	auipc	ra,0x2
    3a38:	e6e080e7          	jalr	-402(ra) # 58a2 <chdir>
    3a3c:	cd6d                	beqz	a0,3b36 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3a3e:	4581                	li	a1,0
    3a40:	00004517          	auipc	a0,0x4
    3a44:	fa050513          	addi	a0,a0,-96 # 79e0 <malloc+0x1d78>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	e2a080e7          	jalr	-470(ra) # 5872 <open>
  if (fd >= 0)
    3a50:	10055163          	bgez	a0,3b52 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3a54:	20000593          	li	a1,512
    3a58:	00004517          	auipc	a0,0x4
    3a5c:	f8850513          	addi	a0,a0,-120 # 79e0 <malloc+0x1d78>
    3a60:	00002097          	auipc	ra,0x2
    3a64:	e12080e7          	jalr	-494(ra) # 5872 <open>
  if (fd >= 0)
    3a68:	10055363          	bgez	a0,3b6e <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0)
    3a6c:	00004517          	auipc	a0,0x4
    3a70:	f7450513          	addi	a0,a0,-140 # 79e0 <malloc+0x1d78>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	e26080e7          	jalr	-474(ra) # 589a <mkdir>
    3a7c:	10050763          	beqz	a0,3b8a <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0)
    3a80:	00004517          	auipc	a0,0x4
    3a84:	f6050513          	addi	a0,a0,-160 # 79e0 <malloc+0x1d78>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	dfa080e7          	jalr	-518(ra) # 5882 <unlink>
    3a90:	10050b63          	beqz	a0,3ba6 <dirfile+0x1a8>
  if (link("README", "dirfile/xx") == 0)
    3a94:	00004597          	auipc	a1,0x4
    3a98:	f4c58593          	addi	a1,a1,-180 # 79e0 <malloc+0x1d78>
    3a9c:	00002517          	auipc	a0,0x2
    3aa0:	7c450513          	addi	a0,a0,1988 # 6260 <malloc+0x5f8>
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	dee080e7          	jalr	-530(ra) # 5892 <link>
    3aac:	10050b63          	beqz	a0,3bc2 <dirfile+0x1c4>
  if (unlink("dirfile") != 0)
    3ab0:	00002517          	auipc	a0,0x2
    3ab4:	5b850513          	addi	a0,a0,1464 # 6068 <malloc+0x400>
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	dca080e7          	jalr	-566(ra) # 5882 <unlink>
    3ac0:	10051f63          	bnez	a0,3bde <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3ac4:	4589                	li	a1,2
    3ac6:	00003517          	auipc	a0,0x3
    3aca:	c9a50513          	addi	a0,a0,-870 # 6760 <malloc+0xaf8>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	da4080e7          	jalr	-604(ra) # 5872 <open>
  if (fd >= 0)
    3ad6:	12055263          	bgez	a0,3bfa <dirfile+0x1fc>
  fd = open(".", 0);
    3ada:	4581                	li	a1,0
    3adc:	00003517          	auipc	a0,0x3
    3ae0:	c8450513          	addi	a0,a0,-892 # 6760 <malloc+0xaf8>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	d8e080e7          	jalr	-626(ra) # 5872 <open>
    3aec:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0)
    3aee:	4605                	li	a2,1
    3af0:	00002597          	auipc	a1,0x2
    3af4:	64858593          	addi	a1,a1,1608 # 6138 <malloc+0x4d0>
    3af8:	00002097          	auipc	ra,0x2
    3afc:	d5a080e7          	jalr	-678(ra) # 5852 <write>
    3b00:	10a04b63          	bgtz	a0,3c16 <dirfile+0x218>
  close(fd);
    3b04:	8526                	mv	a0,s1
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	d54080e7          	jalr	-684(ra) # 585a <close>
}
    3b0e:	60e2                	ld	ra,24(sp)
    3b10:	6442                	ld	s0,16(sp)
    3b12:	64a2                	ld	s1,8(sp)
    3b14:	6902                	ld	s2,0(sp)
    3b16:	6105                	addi	sp,sp,32
    3b18:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3b1a:	85ca                	mv	a1,s2
    3b1c:	00004517          	auipc	a0,0x4
    3b20:	e8450513          	addi	a0,a0,-380 # 79a0 <malloc+0x1d38>
    3b24:	00002097          	auipc	ra,0x2
    3b28:	086080e7          	jalr	134(ra) # 5baa <printf>
    exit(1);
    3b2c:	4505                	li	a0,1
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	d04080e7          	jalr	-764(ra) # 5832 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3b36:	85ca                	mv	a1,s2
    3b38:	00004517          	auipc	a0,0x4
    3b3c:	e8850513          	addi	a0,a0,-376 # 79c0 <malloc+0x1d58>
    3b40:	00002097          	auipc	ra,0x2
    3b44:	06a080e7          	jalr	106(ra) # 5baa <printf>
    exit(1);
    3b48:	4505                	li	a0,1
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	ce8080e7          	jalr	-792(ra) # 5832 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b52:	85ca                	mv	a1,s2
    3b54:	00004517          	auipc	a0,0x4
    3b58:	e9c50513          	addi	a0,a0,-356 # 79f0 <malloc+0x1d88>
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	04e080e7          	jalr	78(ra) # 5baa <printf>
    exit(1);
    3b64:	4505                	li	a0,1
    3b66:	00002097          	auipc	ra,0x2
    3b6a:	ccc080e7          	jalr	-820(ra) # 5832 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b6e:	85ca                	mv	a1,s2
    3b70:	00004517          	auipc	a0,0x4
    3b74:	e8050513          	addi	a0,a0,-384 # 79f0 <malloc+0x1d88>
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	032080e7          	jalr	50(ra) # 5baa <printf>
    exit(1);
    3b80:	4505                	li	a0,1
    3b82:	00002097          	auipc	ra,0x2
    3b86:	cb0080e7          	jalr	-848(ra) # 5832 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b8a:	85ca                	mv	a1,s2
    3b8c:	00004517          	auipc	a0,0x4
    3b90:	e8c50513          	addi	a0,a0,-372 # 7a18 <malloc+0x1db0>
    3b94:	00002097          	auipc	ra,0x2
    3b98:	016080e7          	jalr	22(ra) # 5baa <printf>
    exit(1);
    3b9c:	4505                	li	a0,1
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	c94080e7          	jalr	-876(ra) # 5832 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3ba6:	85ca                	mv	a1,s2
    3ba8:	00004517          	auipc	a0,0x4
    3bac:	e9850513          	addi	a0,a0,-360 # 7a40 <malloc+0x1dd8>
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	ffa080e7          	jalr	-6(ra) # 5baa <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	00002097          	auipc	ra,0x2
    3bbe:	c78080e7          	jalr	-904(ra) # 5832 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3bc2:	85ca                	mv	a1,s2
    3bc4:	00004517          	auipc	a0,0x4
    3bc8:	ea450513          	addi	a0,a0,-348 # 7a68 <malloc+0x1e00>
    3bcc:	00002097          	auipc	ra,0x2
    3bd0:	fde080e7          	jalr	-34(ra) # 5baa <printf>
    exit(1);
    3bd4:	4505                	li	a0,1
    3bd6:	00002097          	auipc	ra,0x2
    3bda:	c5c080e7          	jalr	-932(ra) # 5832 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3bde:	85ca                	mv	a1,s2
    3be0:	00004517          	auipc	a0,0x4
    3be4:	eb050513          	addi	a0,a0,-336 # 7a90 <malloc+0x1e28>
    3be8:	00002097          	auipc	ra,0x2
    3bec:	fc2080e7          	jalr	-62(ra) # 5baa <printf>
    exit(1);
    3bf0:	4505                	li	a0,1
    3bf2:	00002097          	auipc	ra,0x2
    3bf6:	c40080e7          	jalr	-960(ra) # 5832 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3bfa:	85ca                	mv	a1,s2
    3bfc:	00004517          	auipc	a0,0x4
    3c00:	eb450513          	addi	a0,a0,-332 # 7ab0 <malloc+0x1e48>
    3c04:	00002097          	auipc	ra,0x2
    3c08:	fa6080e7          	jalr	-90(ra) # 5baa <printf>
    exit(1);
    3c0c:	4505                	li	a0,1
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	c24080e7          	jalr	-988(ra) # 5832 <exit>
    printf("%s: write . succeeded!\n", s);
    3c16:	85ca                	mv	a1,s2
    3c18:	00004517          	auipc	a0,0x4
    3c1c:	ec050513          	addi	a0,a0,-320 # 7ad8 <malloc+0x1e70>
    3c20:	00002097          	auipc	ra,0x2
    3c24:	f8a080e7          	jalr	-118(ra) # 5baa <printf>
    exit(1);
    3c28:	4505                	li	a0,1
    3c2a:	00002097          	auipc	ra,0x2
    3c2e:	c08080e7          	jalr	-1016(ra) # 5832 <exit>

0000000000003c32 <iref>:
{
    3c32:	7139                	addi	sp,sp,-64
    3c34:	fc06                	sd	ra,56(sp)
    3c36:	f822                	sd	s0,48(sp)
    3c38:	f426                	sd	s1,40(sp)
    3c3a:	f04a                	sd	s2,32(sp)
    3c3c:	ec4e                	sd	s3,24(sp)
    3c3e:	e852                	sd	s4,16(sp)
    3c40:	e456                	sd	s5,8(sp)
    3c42:	e05a                	sd	s6,0(sp)
    3c44:	0080                	addi	s0,sp,64
    3c46:	8b2a                	mv	s6,a0
    3c48:	03300913          	li	s2,51
    if (mkdir("irefd") != 0)
    3c4c:	00004a17          	auipc	s4,0x4
    3c50:	ea4a0a13          	addi	s4,s4,-348 # 7af0 <malloc+0x1e88>
    mkdir("");
    3c54:	00004497          	auipc	s1,0x4
    3c58:	9ac48493          	addi	s1,s1,-1620 # 7600 <malloc+0x1998>
    link("README", "");
    3c5c:	00002a97          	auipc	s5,0x2
    3c60:	604a8a93          	addi	s5,s5,1540 # 6260 <malloc+0x5f8>
    fd = open("xx", O_CREATE);
    3c64:	00004997          	auipc	s3,0x4
    3c68:	d8498993          	addi	s3,s3,-636 # 79e8 <malloc+0x1d80>
    3c6c:	a891                	j	3cc0 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c6e:	85da                	mv	a1,s6
    3c70:	00004517          	auipc	a0,0x4
    3c74:	e8850513          	addi	a0,a0,-376 # 7af8 <malloc+0x1e90>
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	f32080e7          	jalr	-206(ra) # 5baa <printf>
      exit(1);
    3c80:	4505                	li	a0,1
    3c82:	00002097          	auipc	ra,0x2
    3c86:	bb0080e7          	jalr	-1104(ra) # 5832 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c8a:	85da                	mv	a1,s6
    3c8c:	00004517          	auipc	a0,0x4
    3c90:	e8450513          	addi	a0,a0,-380 # 7b10 <malloc+0x1ea8>
    3c94:	00002097          	auipc	ra,0x2
    3c98:	f16080e7          	jalr	-234(ra) # 5baa <printf>
      exit(1);
    3c9c:	4505                	li	a0,1
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	b94080e7          	jalr	-1132(ra) # 5832 <exit>
      close(fd);
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	bb4080e7          	jalr	-1100(ra) # 585a <close>
    3cae:	a889                	j	3d00 <iref+0xce>
    unlink("xx");
    3cb0:	854e                	mv	a0,s3
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	bd0080e7          	jalr	-1072(ra) # 5882 <unlink>
  for (i = 0; i < NINODE + 1; i++)
    3cba:	397d                	addiw	s2,s2,-1
    3cbc:	06090063          	beqz	s2,3d1c <iref+0xea>
    if (mkdir("irefd") != 0)
    3cc0:	8552                	mv	a0,s4
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	bd8080e7          	jalr	-1064(ra) # 589a <mkdir>
    3cca:	f155                	bnez	a0,3c6e <iref+0x3c>
    if (chdir("irefd") != 0)
    3ccc:	8552                	mv	a0,s4
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	bd4080e7          	jalr	-1068(ra) # 58a2 <chdir>
    3cd6:	f955                	bnez	a0,3c8a <iref+0x58>
    mkdir("");
    3cd8:	8526                	mv	a0,s1
    3cda:	00002097          	auipc	ra,0x2
    3cde:	bc0080e7          	jalr	-1088(ra) # 589a <mkdir>
    link("README", "");
    3ce2:	85a6                	mv	a1,s1
    3ce4:	8556                	mv	a0,s5
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	bac080e7          	jalr	-1108(ra) # 5892 <link>
    fd = open("", O_CREATE);
    3cee:	20000593          	li	a1,512
    3cf2:	8526                	mv	a0,s1
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	b7e080e7          	jalr	-1154(ra) # 5872 <open>
    if (fd >= 0)
    3cfc:	fa0555e3          	bgez	a0,3ca6 <iref+0x74>
    fd = open("xx", O_CREATE);
    3d00:	20000593          	li	a1,512
    3d04:	854e                	mv	a0,s3
    3d06:	00002097          	auipc	ra,0x2
    3d0a:	b6c080e7          	jalr	-1172(ra) # 5872 <open>
    if (fd >= 0)
    3d0e:	fa0541e3          	bltz	a0,3cb0 <iref+0x7e>
      close(fd);
    3d12:	00002097          	auipc	ra,0x2
    3d16:	b48080e7          	jalr	-1208(ra) # 585a <close>
    3d1a:	bf59                	j	3cb0 <iref+0x7e>
    3d1c:	03300493          	li	s1,51
    chdir("..");
    3d20:	00003997          	auipc	s3,0x3
    3d24:	60098993          	addi	s3,s3,1536 # 7320 <malloc+0x16b8>
    unlink("irefd");
    3d28:	00004917          	auipc	s2,0x4
    3d2c:	dc890913          	addi	s2,s2,-568 # 7af0 <malloc+0x1e88>
    chdir("..");
    3d30:	854e                	mv	a0,s3
    3d32:	00002097          	auipc	ra,0x2
    3d36:	b70080e7          	jalr	-1168(ra) # 58a2 <chdir>
    unlink("irefd");
    3d3a:	854a                	mv	a0,s2
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	b46080e7          	jalr	-1210(ra) # 5882 <unlink>
  for (i = 0; i < NINODE + 1; i++)
    3d44:	34fd                	addiw	s1,s1,-1
    3d46:	f4ed                	bnez	s1,3d30 <iref+0xfe>
  chdir("/");
    3d48:	00003517          	auipc	a0,0x3
    3d4c:	58050513          	addi	a0,a0,1408 # 72c8 <malloc+0x1660>
    3d50:	00002097          	auipc	ra,0x2
    3d54:	b52080e7          	jalr	-1198(ra) # 58a2 <chdir>
}
    3d58:	70e2                	ld	ra,56(sp)
    3d5a:	7442                	ld	s0,48(sp)
    3d5c:	74a2                	ld	s1,40(sp)
    3d5e:	7902                	ld	s2,32(sp)
    3d60:	69e2                	ld	s3,24(sp)
    3d62:	6a42                	ld	s4,16(sp)
    3d64:	6aa2                	ld	s5,8(sp)
    3d66:	6b02                	ld	s6,0(sp)
    3d68:	6121                	addi	sp,sp,64
    3d6a:	8082                	ret

0000000000003d6c <openiputtest>:
{
    3d6c:	7179                	addi	sp,sp,-48
    3d6e:	f406                	sd	ra,40(sp)
    3d70:	f022                	sd	s0,32(sp)
    3d72:	ec26                	sd	s1,24(sp)
    3d74:	1800                	addi	s0,sp,48
    3d76:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0)
    3d78:	00004517          	auipc	a0,0x4
    3d7c:	db050513          	addi	a0,a0,-592 # 7b28 <malloc+0x1ec0>
    3d80:	00002097          	auipc	ra,0x2
    3d84:	b1a080e7          	jalr	-1254(ra) # 589a <mkdir>
    3d88:	04054263          	bltz	a0,3dcc <openiputtest+0x60>
  pid = fork();
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	a9e080e7          	jalr	-1378(ra) # 582a <fork>
  if (pid < 0)
    3d94:	04054a63          	bltz	a0,3de8 <openiputtest+0x7c>
  if (pid == 0)
    3d98:	e93d                	bnez	a0,3e0e <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d9a:	4589                	li	a1,2
    3d9c:	00004517          	auipc	a0,0x4
    3da0:	d8c50513          	addi	a0,a0,-628 # 7b28 <malloc+0x1ec0>
    3da4:	00002097          	auipc	ra,0x2
    3da8:	ace080e7          	jalr	-1330(ra) # 5872 <open>
    if (fd >= 0)
    3dac:	04054c63          	bltz	a0,3e04 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3db0:	85a6                	mv	a1,s1
    3db2:	00004517          	auipc	a0,0x4
    3db6:	d9650513          	addi	a0,a0,-618 # 7b48 <malloc+0x1ee0>
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	df0080e7          	jalr	-528(ra) # 5baa <printf>
      exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	a6e080e7          	jalr	-1426(ra) # 5832 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3dcc:	85a6                	mv	a1,s1
    3dce:	00004517          	auipc	a0,0x4
    3dd2:	d6250513          	addi	a0,a0,-670 # 7b30 <malloc+0x1ec8>
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	dd4080e7          	jalr	-556(ra) # 5baa <printf>
    exit(1);
    3dde:	4505                	li	a0,1
    3de0:	00002097          	auipc	ra,0x2
    3de4:	a52080e7          	jalr	-1454(ra) # 5832 <exit>
    printf("%s: fork failed\n", s);
    3de8:	85a6                	mv	a1,s1
    3dea:	00003517          	auipc	a0,0x3
    3dee:	b1650513          	addi	a0,a0,-1258 # 6900 <malloc+0xc98>
    3df2:	00002097          	auipc	ra,0x2
    3df6:	db8080e7          	jalr	-584(ra) # 5baa <printf>
    exit(1);
    3dfa:	4505                	li	a0,1
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	a36080e7          	jalr	-1482(ra) # 5832 <exit>
    exit(0);
    3e04:	4501                	li	a0,0
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	a2c080e7          	jalr	-1492(ra) # 5832 <exit>
  sleep(1);
    3e0e:	4505                	li	a0,1
    3e10:	00002097          	auipc	ra,0x2
    3e14:	ab2080e7          	jalr	-1358(ra) # 58c2 <sleep>
  if (unlink("oidir") != 0)
    3e18:	00004517          	auipc	a0,0x4
    3e1c:	d1050513          	addi	a0,a0,-752 # 7b28 <malloc+0x1ec0>
    3e20:	00002097          	auipc	ra,0x2
    3e24:	a62080e7          	jalr	-1438(ra) # 5882 <unlink>
    3e28:	cd19                	beqz	a0,3e46 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3e2a:	85a6                	mv	a1,s1
    3e2c:	00003517          	auipc	a0,0x3
    3e30:	cc450513          	addi	a0,a0,-828 # 6af0 <malloc+0xe88>
    3e34:	00002097          	auipc	ra,0x2
    3e38:	d76080e7          	jalr	-650(ra) # 5baa <printf>
    exit(1);
    3e3c:	4505                	li	a0,1
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	9f4080e7          	jalr	-1548(ra) # 5832 <exit>
  wait(&xstatus);
    3e46:	fdc40513          	addi	a0,s0,-36
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	9f0080e7          	jalr	-1552(ra) # 583a <wait>
  exit(xstatus);
    3e52:	fdc42503          	lw	a0,-36(s0)
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	9dc080e7          	jalr	-1572(ra) # 5832 <exit>

0000000000003e5e <forkforkfork>:
{
    3e5e:	1101                	addi	sp,sp,-32
    3e60:	ec06                	sd	ra,24(sp)
    3e62:	e822                	sd	s0,16(sp)
    3e64:	e426                	sd	s1,8(sp)
    3e66:	1000                	addi	s0,sp,32
    3e68:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e6a:	00004517          	auipc	a0,0x4
    3e6e:	d0650513          	addi	a0,a0,-762 # 7b70 <malloc+0x1f08>
    3e72:	00002097          	auipc	ra,0x2
    3e76:	a10080e7          	jalr	-1520(ra) # 5882 <unlink>
  int pid = fork();
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	9b0080e7          	jalr	-1616(ra) # 582a <fork>
  if (pid < 0)
    3e82:	04054563          	bltz	a0,3ecc <forkforkfork+0x6e>
  if (pid == 0)
    3e86:	c12d                	beqz	a0,3ee8 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e88:	4551                	li	a0,20
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	a38080e7          	jalr	-1480(ra) # 58c2 <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    3e92:	20200593          	li	a1,514
    3e96:	00004517          	auipc	a0,0x4
    3e9a:	cda50513          	addi	a0,a0,-806 # 7b70 <malloc+0x1f08>
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	9d4080e7          	jalr	-1580(ra) # 5872 <open>
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	9b4080e7          	jalr	-1612(ra) # 585a <close>
  wait(0);
    3eae:	4501                	li	a0,0
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	98a080e7          	jalr	-1654(ra) # 583a <wait>
  sleep(10); // one second
    3eb8:	4529                	li	a0,10
    3eba:	00002097          	auipc	ra,0x2
    3ebe:	a08080e7          	jalr	-1528(ra) # 58c2 <sleep>
}
    3ec2:	60e2                	ld	ra,24(sp)
    3ec4:	6442                	ld	s0,16(sp)
    3ec6:	64a2                	ld	s1,8(sp)
    3ec8:	6105                	addi	sp,sp,32
    3eca:	8082                	ret
    printf("%s: fork failed", s);
    3ecc:	85a6                	mv	a1,s1
    3ece:	00003517          	auipc	a0,0x3
    3ed2:	bf250513          	addi	a0,a0,-1038 # 6ac0 <malloc+0xe58>
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	cd4080e7          	jalr	-812(ra) # 5baa <printf>
    exit(1);
    3ede:	4505                	li	a0,1
    3ee0:	00002097          	auipc	ra,0x2
    3ee4:	952080e7          	jalr	-1710(ra) # 5832 <exit>
      int fd = open("stopforking", 0);
    3ee8:	00004497          	auipc	s1,0x4
    3eec:	c8848493          	addi	s1,s1,-888 # 7b70 <malloc+0x1f08>
    3ef0:	4581                	li	a1,0
    3ef2:	8526                	mv	a0,s1
    3ef4:	00002097          	auipc	ra,0x2
    3ef8:	97e080e7          	jalr	-1666(ra) # 5872 <open>
      if (fd >= 0)
    3efc:	02055463          	bgez	a0,3f24 <forkforkfork+0xc6>
      if (fork() < 0)
    3f00:	00002097          	auipc	ra,0x2
    3f04:	92a080e7          	jalr	-1750(ra) # 582a <fork>
    3f08:	fe0554e3          	bgez	a0,3ef0 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    3f0c:	20200593          	li	a1,514
    3f10:	8526                	mv	a0,s1
    3f12:	00002097          	auipc	ra,0x2
    3f16:	960080e7          	jalr	-1696(ra) # 5872 <open>
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	940080e7          	jalr	-1728(ra) # 585a <close>
    3f22:	b7f9                	j	3ef0 <forkforkfork+0x92>
        exit(0);
    3f24:	4501                	li	a0,0
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	90c080e7          	jalr	-1780(ra) # 5832 <exit>

0000000000003f2e <killstatus>:
{
    3f2e:	7139                	addi	sp,sp,-64
    3f30:	fc06                	sd	ra,56(sp)
    3f32:	f822                	sd	s0,48(sp)
    3f34:	f426                	sd	s1,40(sp)
    3f36:	f04a                	sd	s2,32(sp)
    3f38:	ec4e                	sd	s3,24(sp)
    3f3a:	e852                	sd	s4,16(sp)
    3f3c:	0080                	addi	s0,sp,64
    3f3e:	8a2a                	mv	s4,a0
    3f40:	06400913          	li	s2,100
    if (xst != -1)
    3f44:	59fd                	li	s3,-1
    int pid1 = fork();
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	8e4080e7          	jalr	-1820(ra) # 582a <fork>
    3f4e:	84aa                	mv	s1,a0
    if (pid1 < 0)
    3f50:	02054f63          	bltz	a0,3f8e <killstatus+0x60>
    if (pid1 == 0)
    3f54:	c939                	beqz	a0,3faa <killstatus+0x7c>
    sleep(1);
    3f56:	4505                	li	a0,1
    3f58:	00002097          	auipc	ra,0x2
    3f5c:	96a080e7          	jalr	-1686(ra) # 58c2 <sleep>
    kill(pid1);
    3f60:	8526                	mv	a0,s1
    3f62:	00002097          	auipc	ra,0x2
    3f66:	900080e7          	jalr	-1792(ra) # 5862 <kill>
    wait(&xst);
    3f6a:	fcc40513          	addi	a0,s0,-52
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	8cc080e7          	jalr	-1844(ra) # 583a <wait>
    if (xst != -1)
    3f76:	fcc42783          	lw	a5,-52(s0)
    3f7a:	03379d63          	bne	a5,s3,3fb4 <killstatus+0x86>
  for (int i = 0; i < 100; i++)
    3f7e:	397d                	addiw	s2,s2,-1
    3f80:	fc0913e3          	bnez	s2,3f46 <killstatus+0x18>
  exit(0);
    3f84:	4501                	li	a0,0
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	8ac080e7          	jalr	-1876(ra) # 5832 <exit>
      printf("%s: fork failed\n", s);
    3f8e:	85d2                	mv	a1,s4
    3f90:	00003517          	auipc	a0,0x3
    3f94:	97050513          	addi	a0,a0,-1680 # 6900 <malloc+0xc98>
    3f98:	00002097          	auipc	ra,0x2
    3f9c:	c12080e7          	jalr	-1006(ra) # 5baa <printf>
      exit(1);
    3fa0:	4505                	li	a0,1
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	890080e7          	jalr	-1904(ra) # 5832 <exit>
        getpid();
    3faa:	00002097          	auipc	ra,0x2
    3fae:	908080e7          	jalr	-1784(ra) # 58b2 <getpid>
      while (1)
    3fb2:	bfe5                	j	3faa <killstatus+0x7c>
      printf("%s: status should be -1\n", s);
    3fb4:	85d2                	mv	a1,s4
    3fb6:	00004517          	auipc	a0,0x4
    3fba:	bca50513          	addi	a0,a0,-1078 # 7b80 <malloc+0x1f18>
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	bec080e7          	jalr	-1044(ra) # 5baa <printf>
      exit(1);
    3fc6:	4505                	li	a0,1
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	86a080e7          	jalr	-1942(ra) # 5832 <exit>

0000000000003fd0 <preempt>:
{
    3fd0:	7139                	addi	sp,sp,-64
    3fd2:	fc06                	sd	ra,56(sp)
    3fd4:	f822                	sd	s0,48(sp)
    3fd6:	f426                	sd	s1,40(sp)
    3fd8:	f04a                	sd	s2,32(sp)
    3fda:	ec4e                	sd	s3,24(sp)
    3fdc:	e852                	sd	s4,16(sp)
    3fde:	0080                	addi	s0,sp,64
    3fe0:	84aa                	mv	s1,a0
  pid1 = fork();
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	848080e7          	jalr	-1976(ra) # 582a <fork>
  if (pid1 < 0)
    3fea:	00054563          	bltz	a0,3ff4 <preempt+0x24>
    3fee:	8a2a                	mv	s4,a0
  if (pid1 == 0)
    3ff0:	e105                	bnez	a0,4010 <preempt+0x40>
    for (;;)
    3ff2:	a001                	j	3ff2 <preempt+0x22>
    printf("%s: fork failed", s);
    3ff4:	85a6                	mv	a1,s1
    3ff6:	00003517          	auipc	a0,0x3
    3ffa:	aca50513          	addi	a0,a0,-1334 # 6ac0 <malloc+0xe58>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	bac080e7          	jalr	-1108(ra) # 5baa <printf>
    exit(1);
    4006:	4505                	li	a0,1
    4008:	00002097          	auipc	ra,0x2
    400c:	82a080e7          	jalr	-2006(ra) # 5832 <exit>
  pid2 = fork();
    4010:	00002097          	auipc	ra,0x2
    4014:	81a080e7          	jalr	-2022(ra) # 582a <fork>
    4018:	89aa                	mv	s3,a0
  if (pid2 < 0)
    401a:	00054463          	bltz	a0,4022 <preempt+0x52>
  if (pid2 == 0)
    401e:	e105                	bnez	a0,403e <preempt+0x6e>
    for (;;)
    4020:	a001                	j	4020 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4022:	85a6                	mv	a1,s1
    4024:	00003517          	auipc	a0,0x3
    4028:	8dc50513          	addi	a0,a0,-1828 # 6900 <malloc+0xc98>
    402c:	00002097          	auipc	ra,0x2
    4030:	b7e080e7          	jalr	-1154(ra) # 5baa <printf>
    exit(1);
    4034:	4505                	li	a0,1
    4036:	00001097          	auipc	ra,0x1
    403a:	7fc080e7          	jalr	2044(ra) # 5832 <exit>
  pipe(pfds);
    403e:	fc840513          	addi	a0,s0,-56
    4042:	00002097          	auipc	ra,0x2
    4046:	800080e7          	jalr	-2048(ra) # 5842 <pipe>
  pid3 = fork();
    404a:	00001097          	auipc	ra,0x1
    404e:	7e0080e7          	jalr	2016(ra) # 582a <fork>
    4052:	892a                	mv	s2,a0
  if (pid3 < 0)
    4054:	02054e63          	bltz	a0,4090 <preempt+0xc0>
  if (pid3 == 0)
    4058:	e525                	bnez	a0,40c0 <preempt+0xf0>
    close(pfds[0]);
    405a:	fc842503          	lw	a0,-56(s0)
    405e:	00001097          	auipc	ra,0x1
    4062:	7fc080e7          	jalr	2044(ra) # 585a <close>
    if (write(pfds[1], "x", 1) != 1)
    4066:	4605                	li	a2,1
    4068:	00002597          	auipc	a1,0x2
    406c:	0d058593          	addi	a1,a1,208 # 6138 <malloc+0x4d0>
    4070:	fcc42503          	lw	a0,-52(s0)
    4074:	00001097          	auipc	ra,0x1
    4078:	7de080e7          	jalr	2014(ra) # 5852 <write>
    407c:	4785                	li	a5,1
    407e:	02f51763          	bne	a0,a5,40ac <preempt+0xdc>
    close(pfds[1]);
    4082:	fcc42503          	lw	a0,-52(s0)
    4086:	00001097          	auipc	ra,0x1
    408a:	7d4080e7          	jalr	2004(ra) # 585a <close>
    for (;;)
    408e:	a001                	j	408e <preempt+0xbe>
    printf("%s: fork failed\n", s);
    4090:	85a6                	mv	a1,s1
    4092:	00003517          	auipc	a0,0x3
    4096:	86e50513          	addi	a0,a0,-1938 # 6900 <malloc+0xc98>
    409a:	00002097          	auipc	ra,0x2
    409e:	b10080e7          	jalr	-1264(ra) # 5baa <printf>
    exit(1);
    40a2:	4505                	li	a0,1
    40a4:	00001097          	auipc	ra,0x1
    40a8:	78e080e7          	jalr	1934(ra) # 5832 <exit>
      printf("%s: preempt write error", s);
    40ac:	85a6                	mv	a1,s1
    40ae:	00004517          	auipc	a0,0x4
    40b2:	af250513          	addi	a0,a0,-1294 # 7ba0 <malloc+0x1f38>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	af4080e7          	jalr	-1292(ra) # 5baa <printf>
    40be:	b7d1                	j	4082 <preempt+0xb2>
  close(pfds[1]);
    40c0:	fcc42503          	lw	a0,-52(s0)
    40c4:	00001097          	auipc	ra,0x1
    40c8:	796080e7          	jalr	1942(ra) # 585a <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1)
    40cc:	660d                	lui	a2,0x3
    40ce:	00008597          	auipc	a1,0x8
    40d2:	c5258593          	addi	a1,a1,-942 # bd20 <buf>
    40d6:	fc842503          	lw	a0,-56(s0)
    40da:	00001097          	auipc	ra,0x1
    40de:	770080e7          	jalr	1904(ra) # 584a <read>
    40e2:	4785                	li	a5,1
    40e4:	02f50363          	beq	a0,a5,410a <preempt+0x13a>
    printf("%s: preempt read error", s);
    40e8:	85a6                	mv	a1,s1
    40ea:	00004517          	auipc	a0,0x4
    40ee:	ace50513          	addi	a0,a0,-1330 # 7bb8 <malloc+0x1f50>
    40f2:	00002097          	auipc	ra,0x2
    40f6:	ab8080e7          	jalr	-1352(ra) # 5baa <printf>
}
    40fa:	70e2                	ld	ra,56(sp)
    40fc:	7442                	ld	s0,48(sp)
    40fe:	74a2                	ld	s1,40(sp)
    4100:	7902                	ld	s2,32(sp)
    4102:	69e2                	ld	s3,24(sp)
    4104:	6a42                	ld	s4,16(sp)
    4106:	6121                	addi	sp,sp,64
    4108:	8082                	ret
  close(pfds[0]);
    410a:	fc842503          	lw	a0,-56(s0)
    410e:	00001097          	auipc	ra,0x1
    4112:	74c080e7          	jalr	1868(ra) # 585a <close>
  printf("kill... ");
    4116:	00004517          	auipc	a0,0x4
    411a:	aba50513          	addi	a0,a0,-1350 # 7bd0 <malloc+0x1f68>
    411e:	00002097          	auipc	ra,0x2
    4122:	a8c080e7          	jalr	-1396(ra) # 5baa <printf>
  kill(pid1);
    4126:	8552                	mv	a0,s4
    4128:	00001097          	auipc	ra,0x1
    412c:	73a080e7          	jalr	1850(ra) # 5862 <kill>
  kill(pid2);
    4130:	854e                	mv	a0,s3
    4132:	00001097          	auipc	ra,0x1
    4136:	730080e7          	jalr	1840(ra) # 5862 <kill>
  kill(pid3);
    413a:	854a                	mv	a0,s2
    413c:	00001097          	auipc	ra,0x1
    4140:	726080e7          	jalr	1830(ra) # 5862 <kill>
  printf("wait... ");
    4144:	00004517          	auipc	a0,0x4
    4148:	a9c50513          	addi	a0,a0,-1380 # 7be0 <malloc+0x1f78>
    414c:	00002097          	auipc	ra,0x2
    4150:	a5e080e7          	jalr	-1442(ra) # 5baa <printf>
  wait(0);
    4154:	4501                	li	a0,0
    4156:	00001097          	auipc	ra,0x1
    415a:	6e4080e7          	jalr	1764(ra) # 583a <wait>
  wait(0);
    415e:	4501                	li	a0,0
    4160:	00001097          	auipc	ra,0x1
    4164:	6da080e7          	jalr	1754(ra) # 583a <wait>
  wait(0);
    4168:	4501                	li	a0,0
    416a:	00001097          	auipc	ra,0x1
    416e:	6d0080e7          	jalr	1744(ra) # 583a <wait>
    4172:	b761                	j	40fa <preempt+0x12a>

0000000000004174 <reparent>:
{
    4174:	7179                	addi	sp,sp,-48
    4176:	f406                	sd	ra,40(sp)
    4178:	f022                	sd	s0,32(sp)
    417a:	ec26                	sd	s1,24(sp)
    417c:	e84a                	sd	s2,16(sp)
    417e:	e44e                	sd	s3,8(sp)
    4180:	e052                	sd	s4,0(sp)
    4182:	1800                	addi	s0,sp,48
    4184:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4186:	00001097          	auipc	ra,0x1
    418a:	72c080e7          	jalr	1836(ra) # 58b2 <getpid>
    418e:	8a2a                	mv	s4,a0
    4190:	0c800913          	li	s2,200
    int pid = fork();
    4194:	00001097          	auipc	ra,0x1
    4198:	696080e7          	jalr	1686(ra) # 582a <fork>
    419c:	84aa                	mv	s1,a0
    if (pid < 0)
    419e:	02054263          	bltz	a0,41c2 <reparent+0x4e>
    if (pid)
    41a2:	cd21                	beqz	a0,41fa <reparent+0x86>
      if (wait(0) != pid)
    41a4:	4501                	li	a0,0
    41a6:	00001097          	auipc	ra,0x1
    41aa:	694080e7          	jalr	1684(ra) # 583a <wait>
    41ae:	02951863          	bne	a0,s1,41de <reparent+0x6a>
  for (int i = 0; i < 200; i++)
    41b2:	397d                	addiw	s2,s2,-1
    41b4:	fe0910e3          	bnez	s2,4194 <reparent+0x20>
  exit(0);
    41b8:	4501                	li	a0,0
    41ba:	00001097          	auipc	ra,0x1
    41be:	678080e7          	jalr	1656(ra) # 5832 <exit>
      printf("%s: fork failed\n", s);
    41c2:	85ce                	mv	a1,s3
    41c4:	00002517          	auipc	a0,0x2
    41c8:	73c50513          	addi	a0,a0,1852 # 6900 <malloc+0xc98>
    41cc:	00002097          	auipc	ra,0x2
    41d0:	9de080e7          	jalr	-1570(ra) # 5baa <printf>
      exit(1);
    41d4:	4505                	li	a0,1
    41d6:	00001097          	auipc	ra,0x1
    41da:	65c080e7          	jalr	1628(ra) # 5832 <exit>
        printf("%s: wait wrong pid\n", s);
    41de:	85ce                	mv	a1,s3
    41e0:	00003517          	auipc	a0,0x3
    41e4:	8a850513          	addi	a0,a0,-1880 # 6a88 <malloc+0xe20>
    41e8:	00002097          	auipc	ra,0x2
    41ec:	9c2080e7          	jalr	-1598(ra) # 5baa <printf>
        exit(1);
    41f0:	4505                	li	a0,1
    41f2:	00001097          	auipc	ra,0x1
    41f6:	640080e7          	jalr	1600(ra) # 5832 <exit>
      int pid2 = fork();
    41fa:	00001097          	auipc	ra,0x1
    41fe:	630080e7          	jalr	1584(ra) # 582a <fork>
      if (pid2 < 0)
    4202:	00054763          	bltz	a0,4210 <reparent+0x9c>
      exit(0);
    4206:	4501                	li	a0,0
    4208:	00001097          	auipc	ra,0x1
    420c:	62a080e7          	jalr	1578(ra) # 5832 <exit>
        kill(master_pid);
    4210:	8552                	mv	a0,s4
    4212:	00001097          	auipc	ra,0x1
    4216:	650080e7          	jalr	1616(ra) # 5862 <kill>
        exit(1);
    421a:	4505                	li	a0,1
    421c:	00001097          	auipc	ra,0x1
    4220:	616080e7          	jalr	1558(ra) # 5832 <exit>

0000000000004224 <sbrkfail>:
{
    4224:	7119                	addi	sp,sp,-128
    4226:	fc86                	sd	ra,120(sp)
    4228:	f8a2                	sd	s0,112(sp)
    422a:	f4a6                	sd	s1,104(sp)
    422c:	f0ca                	sd	s2,96(sp)
    422e:	ecce                	sd	s3,88(sp)
    4230:	e8d2                	sd	s4,80(sp)
    4232:	e4d6                	sd	s5,72(sp)
    4234:	0100                	addi	s0,sp,128
    4236:	892a                	mv	s2,a0
  if (pipe(fds) != 0)
    4238:	fb040513          	addi	a0,s0,-80
    423c:	00001097          	auipc	ra,0x1
    4240:	606080e7          	jalr	1542(ra) # 5842 <pipe>
    4244:	e901                	bnez	a0,4254 <sbrkfail+0x30>
    4246:	f8040493          	addi	s1,s0,-128
    424a:	fa840a13          	addi	s4,s0,-88
    424e:	89a6                	mv	s3,s1
    if (pids[i] != -1)
    4250:	5afd                	li	s5,-1
    4252:	a08d                	j	42b4 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    4254:	85ca                	mv	a1,s2
    4256:	00002517          	auipc	a0,0x2
    425a:	7b250513          	addi	a0,a0,1970 # 6a08 <malloc+0xda0>
    425e:	00002097          	auipc	ra,0x2
    4262:	94c080e7          	jalr	-1716(ra) # 5baa <printf>
    exit(1);
    4266:	4505                	li	a0,1
    4268:	00001097          	auipc	ra,0x1
    426c:	5ca080e7          	jalr	1482(ra) # 5832 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4270:	4501                	li	a0,0
    4272:	00001097          	auipc	ra,0x1
    4276:	648080e7          	jalr	1608(ra) # 58ba <sbrk>
    427a:	064007b7          	lui	a5,0x6400
    427e:	40a7853b          	subw	a0,a5,a0
    4282:	00001097          	auipc	ra,0x1
    4286:	638080e7          	jalr	1592(ra) # 58ba <sbrk>
      write(fds[1], "x", 1);
    428a:	4605                	li	a2,1
    428c:	00002597          	auipc	a1,0x2
    4290:	eac58593          	addi	a1,a1,-340 # 6138 <malloc+0x4d0>
    4294:	fb442503          	lw	a0,-76(s0)
    4298:	00001097          	auipc	ra,0x1
    429c:	5ba080e7          	jalr	1466(ra) # 5852 <write>
        sleep(1000);
    42a0:	3e800513          	li	a0,1000
    42a4:	00001097          	auipc	ra,0x1
    42a8:	61e080e7          	jalr	1566(ra) # 58c2 <sleep>
      for (;;)
    42ac:	bfd5                	j	42a0 <sbrkfail+0x7c>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++)
    42ae:	0991                	addi	s3,s3,4
    42b0:	03498563          	beq	s3,s4,42da <sbrkfail+0xb6>
    if ((pids[i] = fork()) == 0)
    42b4:	00001097          	auipc	ra,0x1
    42b8:	576080e7          	jalr	1398(ra) # 582a <fork>
    42bc:	00a9a023          	sw	a0,0(s3)
    42c0:	d945                	beqz	a0,4270 <sbrkfail+0x4c>
    if (pids[i] != -1)
    42c2:	ff5506e3          	beq	a0,s5,42ae <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    42c6:	4605                	li	a2,1
    42c8:	faf40593          	addi	a1,s0,-81
    42cc:	fb042503          	lw	a0,-80(s0)
    42d0:	00001097          	auipc	ra,0x1
    42d4:	57a080e7          	jalr	1402(ra) # 584a <read>
    42d8:	bfd9                	j	42ae <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    42da:	6505                	lui	a0,0x1
    42dc:	00001097          	auipc	ra,0x1
    42e0:	5de080e7          	jalr	1502(ra) # 58ba <sbrk>
    42e4:	89aa                	mv	s3,a0
    if (pids[i] == -1)
    42e6:	5afd                	li	s5,-1
    42e8:	a021                	j	42f0 <sbrkfail+0xcc>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++)
    42ea:	0491                	addi	s1,s1,4
    42ec:	01448f63          	beq	s1,s4,430a <sbrkfail+0xe6>
    if (pids[i] == -1)
    42f0:	4088                	lw	a0,0(s1)
    42f2:	ff550ce3          	beq	a0,s5,42ea <sbrkfail+0xc6>
    kill(pids[i]);
    42f6:	00001097          	auipc	ra,0x1
    42fa:	56c080e7          	jalr	1388(ra) # 5862 <kill>
    wait(0);
    42fe:	4501                	li	a0,0
    4300:	00001097          	auipc	ra,0x1
    4304:	53a080e7          	jalr	1338(ra) # 583a <wait>
    4308:	b7cd                	j	42ea <sbrkfail+0xc6>
  if (c == (char *)0xffffffffffffffffL)
    430a:	57fd                	li	a5,-1
    430c:	04f98163          	beq	s3,a5,434e <sbrkfail+0x12a>
  pid = fork();
    4310:	00001097          	auipc	ra,0x1
    4314:	51a080e7          	jalr	1306(ra) # 582a <fork>
    4318:	84aa                	mv	s1,a0
  if (pid < 0)
    431a:	04054863          	bltz	a0,436a <sbrkfail+0x146>
  if (pid == 0)
    431e:	c525                	beqz	a0,4386 <sbrkfail+0x162>
  wait(&xstatus);
    4320:	fbc40513          	addi	a0,s0,-68
    4324:	00001097          	auipc	ra,0x1
    4328:	516080e7          	jalr	1302(ra) # 583a <wait>
  if (xstatus != -1 && xstatus != 2)
    432c:	fbc42783          	lw	a5,-68(s0)
    4330:	577d                	li	a4,-1
    4332:	00e78563          	beq	a5,a4,433c <sbrkfail+0x118>
    4336:	4709                	li	a4,2
    4338:	08e79d63          	bne	a5,a4,43d2 <sbrkfail+0x1ae>
}
    433c:	70e6                	ld	ra,120(sp)
    433e:	7446                	ld	s0,112(sp)
    4340:	74a6                	ld	s1,104(sp)
    4342:	7906                	ld	s2,96(sp)
    4344:	69e6                	ld	s3,88(sp)
    4346:	6a46                	ld	s4,80(sp)
    4348:	6aa6                	ld	s5,72(sp)
    434a:	6109                	addi	sp,sp,128
    434c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    434e:	85ca                	mv	a1,s2
    4350:	00004517          	auipc	a0,0x4
    4354:	8a050513          	addi	a0,a0,-1888 # 7bf0 <malloc+0x1f88>
    4358:	00002097          	auipc	ra,0x2
    435c:	852080e7          	jalr	-1966(ra) # 5baa <printf>
    exit(1);
    4360:	4505                	li	a0,1
    4362:	00001097          	auipc	ra,0x1
    4366:	4d0080e7          	jalr	1232(ra) # 5832 <exit>
    printf("%s: fork failed\n", s);
    436a:	85ca                	mv	a1,s2
    436c:	00002517          	auipc	a0,0x2
    4370:	59450513          	addi	a0,a0,1428 # 6900 <malloc+0xc98>
    4374:	00002097          	auipc	ra,0x2
    4378:	836080e7          	jalr	-1994(ra) # 5baa <printf>
    exit(1);
    437c:	4505                	li	a0,1
    437e:	00001097          	auipc	ra,0x1
    4382:	4b4080e7          	jalr	1204(ra) # 5832 <exit>
    a = sbrk(0);
    4386:	4501                	li	a0,0
    4388:	00001097          	auipc	ra,0x1
    438c:	532080e7          	jalr	1330(ra) # 58ba <sbrk>
    4390:	89aa                	mv	s3,a0
    sbrk(10 * BIG);
    4392:	3e800537          	lui	a0,0x3e800
    4396:	00001097          	auipc	ra,0x1
    439a:	524080e7          	jalr	1316(ra) # 58ba <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE)
    439e:	874e                	mv	a4,s3
    43a0:	3e8007b7          	lui	a5,0x3e800
    43a4:	97ce                	add	a5,a5,s3
    43a6:	6685                	lui	a3,0x1
      n += *(a + i);
    43a8:	00074603          	lbu	a2,0(a4)
    43ac:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10 * BIG; i += PGSIZE)
    43ae:	9736                	add	a4,a4,a3
    43b0:	fef71ce3          	bne	a4,a5,43a8 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    43b4:	8626                	mv	a2,s1
    43b6:	85ca                	mv	a1,s2
    43b8:	00004517          	auipc	a0,0x4
    43bc:	85850513          	addi	a0,a0,-1960 # 7c10 <malloc+0x1fa8>
    43c0:	00001097          	auipc	ra,0x1
    43c4:	7ea080e7          	jalr	2026(ra) # 5baa <printf>
    exit(1);
    43c8:	4505                	li	a0,1
    43ca:	00001097          	auipc	ra,0x1
    43ce:	468080e7          	jalr	1128(ra) # 5832 <exit>
    exit(1);
    43d2:	4505                	li	a0,1
    43d4:	00001097          	auipc	ra,0x1
    43d8:	45e080e7          	jalr	1118(ra) # 5832 <exit>

00000000000043dc <sharedfd>:
{
    43dc:	7159                	addi	sp,sp,-112
    43de:	f486                	sd	ra,104(sp)
    43e0:	f0a2                	sd	s0,96(sp)
    43e2:	eca6                	sd	s1,88(sp)
    43e4:	e8ca                	sd	s2,80(sp)
    43e6:	e4ce                	sd	s3,72(sp)
    43e8:	e0d2                	sd	s4,64(sp)
    43ea:	fc56                	sd	s5,56(sp)
    43ec:	f85a                	sd	s6,48(sp)
    43ee:	f45e                	sd	s7,40(sp)
    43f0:	1880                	addi	s0,sp,112
    43f2:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    43f4:	00002517          	auipc	a0,0x2
    43f8:	aec50513          	addi	a0,a0,-1300 # 5ee0 <malloc+0x278>
    43fc:	00001097          	auipc	ra,0x1
    4400:	486080e7          	jalr	1158(ra) # 5882 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    4404:	20200593          	li	a1,514
    4408:	00002517          	auipc	a0,0x2
    440c:	ad850513          	addi	a0,a0,-1320 # 5ee0 <malloc+0x278>
    4410:	00001097          	auipc	ra,0x1
    4414:	462080e7          	jalr	1122(ra) # 5872 <open>
  if (fd < 0)
    4418:	04054a63          	bltz	a0,446c <sharedfd+0x90>
    441c:	892a                	mv	s2,a0
  pid = fork();
    441e:	00001097          	auipc	ra,0x1
    4422:	40c080e7          	jalr	1036(ra) # 582a <fork>
    4426:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    4428:	06300593          	li	a1,99
    442c:	c119                	beqz	a0,4432 <sharedfd+0x56>
    442e:	07000593          	li	a1,112
    4432:	4629                	li	a2,10
    4434:	fa040513          	addi	a0,s0,-96
    4438:	00001097          	auipc	ra,0x1
    443c:	1f6080e7          	jalr	502(ra) # 562e <memset>
    4440:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf))
    4444:	4629                	li	a2,10
    4446:	fa040593          	addi	a1,s0,-96
    444a:	854a                	mv	a0,s2
    444c:	00001097          	auipc	ra,0x1
    4450:	406080e7          	jalr	1030(ra) # 5852 <write>
    4454:	47a9                	li	a5,10
    4456:	02f51963          	bne	a0,a5,4488 <sharedfd+0xac>
  for (i = 0; i < N; i++)
    445a:	34fd                	addiw	s1,s1,-1
    445c:	f4e5                	bnez	s1,4444 <sharedfd+0x68>
  if (pid == 0)
    445e:	04099363          	bnez	s3,44a4 <sharedfd+0xc8>
    exit(0);
    4462:	4501                	li	a0,0
    4464:	00001097          	auipc	ra,0x1
    4468:	3ce080e7          	jalr	974(ra) # 5832 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    446c:	85d2                	mv	a1,s4
    446e:	00003517          	auipc	a0,0x3
    4472:	7d250513          	addi	a0,a0,2002 # 7c40 <malloc+0x1fd8>
    4476:	00001097          	auipc	ra,0x1
    447a:	734080e7          	jalr	1844(ra) # 5baa <printf>
    exit(1);
    447e:	4505                	li	a0,1
    4480:	00001097          	auipc	ra,0x1
    4484:	3b2080e7          	jalr	946(ra) # 5832 <exit>
      printf("%s: write sharedfd failed\n", s);
    4488:	85d2                	mv	a1,s4
    448a:	00003517          	auipc	a0,0x3
    448e:	7de50513          	addi	a0,a0,2014 # 7c68 <malloc+0x2000>
    4492:	00001097          	auipc	ra,0x1
    4496:	718080e7          	jalr	1816(ra) # 5baa <printf>
      exit(1);
    449a:	4505                	li	a0,1
    449c:	00001097          	auipc	ra,0x1
    44a0:	396080e7          	jalr	918(ra) # 5832 <exit>
    wait(&xstatus);
    44a4:	f9c40513          	addi	a0,s0,-100
    44a8:	00001097          	auipc	ra,0x1
    44ac:	392080e7          	jalr	914(ra) # 583a <wait>
    if (xstatus != 0)
    44b0:	f9c42983          	lw	s3,-100(s0)
    44b4:	00098763          	beqz	s3,44c2 <sharedfd+0xe6>
      exit(xstatus);
    44b8:	854e                	mv	a0,s3
    44ba:	00001097          	auipc	ra,0x1
    44be:	378080e7          	jalr	888(ra) # 5832 <exit>
  close(fd);
    44c2:	854a                	mv	a0,s2
    44c4:	00001097          	auipc	ra,0x1
    44c8:	396080e7          	jalr	918(ra) # 585a <close>
  fd = open("sharedfd", 0);
    44cc:	4581                	li	a1,0
    44ce:	00002517          	auipc	a0,0x2
    44d2:	a1250513          	addi	a0,a0,-1518 # 5ee0 <malloc+0x278>
    44d6:	00001097          	auipc	ra,0x1
    44da:	39c080e7          	jalr	924(ra) # 5872 <open>
    44de:	8baa                	mv	s7,a0
  nc = np = 0;
    44e0:	8ace                	mv	s5,s3
  if (fd < 0)
    44e2:	02054563          	bltz	a0,450c <sharedfd+0x130>
    44e6:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    44ea:	06300493          	li	s1,99
      if (buf[i] == 'p')
    44ee:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0)
    44f2:	4629                	li	a2,10
    44f4:	fa040593          	addi	a1,s0,-96
    44f8:	855e                	mv	a0,s7
    44fa:	00001097          	auipc	ra,0x1
    44fe:	350080e7          	jalr	848(ra) # 584a <read>
    4502:	02a05f63          	blez	a0,4540 <sharedfd+0x164>
    4506:	fa040793          	addi	a5,s0,-96
    450a:	a01d                	j	4530 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    450c:	85d2                	mv	a1,s4
    450e:	00003517          	auipc	a0,0x3
    4512:	77a50513          	addi	a0,a0,1914 # 7c88 <malloc+0x2020>
    4516:	00001097          	auipc	ra,0x1
    451a:	694080e7          	jalr	1684(ra) # 5baa <printf>
    exit(1);
    451e:	4505                	li	a0,1
    4520:	00001097          	auipc	ra,0x1
    4524:	312080e7          	jalr	786(ra) # 5832 <exit>
        nc++;
    4528:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++)
    452a:	0785                	addi	a5,a5,1
    452c:	fd2783e3          	beq	a5,s2,44f2 <sharedfd+0x116>
      if (buf[i] == 'c')
    4530:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f12d0>
    4534:	fe970ae3          	beq	a4,s1,4528 <sharedfd+0x14c>
      if (buf[i] == 'p')
    4538:	ff6719e3          	bne	a4,s6,452a <sharedfd+0x14e>
        np++;
    453c:	2a85                	addiw	s5,s5,1
    453e:	b7f5                	j	452a <sharedfd+0x14e>
  close(fd);
    4540:	855e                	mv	a0,s7
    4542:	00001097          	auipc	ra,0x1
    4546:	318080e7          	jalr	792(ra) # 585a <close>
  unlink("sharedfd");
    454a:	00002517          	auipc	a0,0x2
    454e:	99650513          	addi	a0,a0,-1642 # 5ee0 <malloc+0x278>
    4552:	00001097          	auipc	ra,0x1
    4556:	330080e7          	jalr	816(ra) # 5882 <unlink>
  if (nc == N * SZ && np == N * SZ)
    455a:	6789                	lui	a5,0x2
    455c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xf0>
    4560:	00f99763          	bne	s3,a5,456e <sharedfd+0x192>
    4564:	6789                	lui	a5,0x2
    4566:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xf0>
    456a:	02fa8063          	beq	s5,a5,458a <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    456e:	85d2                	mv	a1,s4
    4570:	00003517          	auipc	a0,0x3
    4574:	74050513          	addi	a0,a0,1856 # 7cb0 <malloc+0x2048>
    4578:	00001097          	auipc	ra,0x1
    457c:	632080e7          	jalr	1586(ra) # 5baa <printf>
    exit(1);
    4580:	4505                	li	a0,1
    4582:	00001097          	auipc	ra,0x1
    4586:	2b0080e7          	jalr	688(ra) # 5832 <exit>
    exit(0);
    458a:	4501                	li	a0,0
    458c:	00001097          	auipc	ra,0x1
    4590:	2a6080e7          	jalr	678(ra) # 5832 <exit>

0000000000004594 <fourfiles>:
{
    4594:	7171                	addi	sp,sp,-176
    4596:	f506                	sd	ra,168(sp)
    4598:	f122                	sd	s0,160(sp)
    459a:	ed26                	sd	s1,152(sp)
    459c:	e94a                	sd	s2,144(sp)
    459e:	e54e                	sd	s3,136(sp)
    45a0:	e152                	sd	s4,128(sp)
    45a2:	fcd6                	sd	s5,120(sp)
    45a4:	f8da                	sd	s6,112(sp)
    45a6:	f4de                	sd	s7,104(sp)
    45a8:	f0e2                	sd	s8,96(sp)
    45aa:	ece6                	sd	s9,88(sp)
    45ac:	e8ea                	sd	s10,80(sp)
    45ae:	e4ee                	sd	s11,72(sp)
    45b0:	1900                	addi	s0,sp,176
    45b2:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    45b4:	00001797          	auipc	a5,0x1
    45b8:	79c78793          	addi	a5,a5,1948 # 5d50 <malloc+0xe8>
    45bc:	f6f43823          	sd	a5,-144(s0)
    45c0:	00001797          	auipc	a5,0x1
    45c4:	79878793          	addi	a5,a5,1944 # 5d58 <malloc+0xf0>
    45c8:	f6f43c23          	sd	a5,-136(s0)
    45cc:	00001797          	auipc	a5,0x1
    45d0:	79478793          	addi	a5,a5,1940 # 5d60 <malloc+0xf8>
    45d4:	f8f43023          	sd	a5,-128(s0)
    45d8:	00001797          	auipc	a5,0x1
    45dc:	79078793          	addi	a5,a5,1936 # 5d68 <malloc+0x100>
    45e0:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++)
    45e4:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    45e8:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++)
    45ea:	4481                	li	s1,0
    45ec:	4a11                	li	s4,4
    fname = names[pi];
    45ee:	00093983          	ld	s3,0(s2)
    unlink(fname);
    45f2:	854e                	mv	a0,s3
    45f4:	00001097          	auipc	ra,0x1
    45f8:	28e080e7          	jalr	654(ra) # 5882 <unlink>
    pid = fork();
    45fc:	00001097          	auipc	ra,0x1
    4600:	22e080e7          	jalr	558(ra) # 582a <fork>
    if (pid < 0)
    4604:	04054563          	bltz	a0,464e <fourfiles+0xba>
    if (pid == 0)
    4608:	c12d                	beqz	a0,466a <fourfiles+0xd6>
  for (pi = 0; pi < NCHILD; pi++)
    460a:	2485                	addiw	s1,s1,1
    460c:	0921                	addi	s2,s2,8
    460e:	ff4490e3          	bne	s1,s4,45ee <fourfiles+0x5a>
    4612:	4491                	li	s1,4
    wait(&xstatus);
    4614:	f6c40513          	addi	a0,s0,-148
    4618:	00001097          	auipc	ra,0x1
    461c:	222080e7          	jalr	546(ra) # 583a <wait>
    if (xstatus != 0)
    4620:	f6c42503          	lw	a0,-148(s0)
    4624:	ed69                	bnez	a0,46fe <fourfiles+0x16a>
  for (pi = 0; pi < NCHILD; pi++)
    4626:	34fd                	addiw	s1,s1,-1
    4628:	f4f5                	bnez	s1,4614 <fourfiles+0x80>
    462a:	03000b13          	li	s6,48
    total = 0;
    462e:	f4a43c23          	sd	a0,-168(s0)
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4632:	00007a17          	auipc	s4,0x7
    4636:	6eea0a13          	addi	s4,s4,1774 # bd20 <buf>
    463a:	00007a97          	auipc	s5,0x7
    463e:	6e7a8a93          	addi	s5,s5,1767 # bd21 <buf+0x1>
    if (total != N * SZ)
    4642:	6d05                	lui	s10,0x1
    4644:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x78>
  for (i = 0; i < NCHILD; i++)
    4648:	03400d93          	li	s11,52
    464c:	a23d                	j	477a <fourfiles+0x1e6>
      printf("fork failed\n", s);
    464e:	85e6                	mv	a1,s9
    4650:	00002517          	auipc	a0,0x2
    4654:	6d050513          	addi	a0,a0,1744 # 6d20 <malloc+0x10b8>
    4658:	00001097          	auipc	ra,0x1
    465c:	552080e7          	jalr	1362(ra) # 5baa <printf>
      exit(1);
    4660:	4505                	li	a0,1
    4662:	00001097          	auipc	ra,0x1
    4666:	1d0080e7          	jalr	464(ra) # 5832 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    466a:	20200593          	li	a1,514
    466e:	854e                	mv	a0,s3
    4670:	00001097          	auipc	ra,0x1
    4674:	202080e7          	jalr	514(ra) # 5872 <open>
    4678:	892a                	mv	s2,a0
      if (fd < 0)
    467a:	04054763          	bltz	a0,46c8 <fourfiles+0x134>
      memset(buf, '0' + pi, SZ);
    467e:	1f400613          	li	a2,500
    4682:	0304859b          	addiw	a1,s1,48
    4686:	00007517          	auipc	a0,0x7
    468a:	69a50513          	addi	a0,a0,1690 # bd20 <buf>
    468e:	00001097          	auipc	ra,0x1
    4692:	fa0080e7          	jalr	-96(ra) # 562e <memset>
    4696:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ)
    4698:	00007997          	auipc	s3,0x7
    469c:	68898993          	addi	s3,s3,1672 # bd20 <buf>
    46a0:	1f400613          	li	a2,500
    46a4:	85ce                	mv	a1,s3
    46a6:	854a                	mv	a0,s2
    46a8:	00001097          	auipc	ra,0x1
    46ac:	1aa080e7          	jalr	426(ra) # 5852 <write>
    46b0:	85aa                	mv	a1,a0
    46b2:	1f400793          	li	a5,500
    46b6:	02f51763          	bne	a0,a5,46e4 <fourfiles+0x150>
      for (i = 0; i < N; i++)
    46ba:	34fd                	addiw	s1,s1,-1
    46bc:	f0f5                	bnez	s1,46a0 <fourfiles+0x10c>
      exit(0);
    46be:	4501                	li	a0,0
    46c0:	00001097          	auipc	ra,0x1
    46c4:	172080e7          	jalr	370(ra) # 5832 <exit>
        printf("create failed\n", s);
    46c8:	85e6                	mv	a1,s9
    46ca:	00003517          	auipc	a0,0x3
    46ce:	5fe50513          	addi	a0,a0,1534 # 7cc8 <malloc+0x2060>
    46d2:	00001097          	auipc	ra,0x1
    46d6:	4d8080e7          	jalr	1240(ra) # 5baa <printf>
        exit(1);
    46da:	4505                	li	a0,1
    46dc:	00001097          	auipc	ra,0x1
    46e0:	156080e7          	jalr	342(ra) # 5832 <exit>
          printf("write failed %d\n", n);
    46e4:	00003517          	auipc	a0,0x3
    46e8:	5f450513          	addi	a0,a0,1524 # 7cd8 <malloc+0x2070>
    46ec:	00001097          	auipc	ra,0x1
    46f0:	4be080e7          	jalr	1214(ra) # 5baa <printf>
          exit(1);
    46f4:	4505                	li	a0,1
    46f6:	00001097          	auipc	ra,0x1
    46fa:	13c080e7          	jalr	316(ra) # 5832 <exit>
      exit(xstatus);
    46fe:	00001097          	auipc	ra,0x1
    4702:	134080e7          	jalr	308(ra) # 5832 <exit>
          printf("wrong char\n", s);
    4706:	85e6                	mv	a1,s9
    4708:	00003517          	auipc	a0,0x3
    470c:	5e850513          	addi	a0,a0,1512 # 7cf0 <malloc+0x2088>
    4710:	00001097          	auipc	ra,0x1
    4714:	49a080e7          	jalr	1178(ra) # 5baa <printf>
          exit(1);
    4718:	4505                	li	a0,1
    471a:	00001097          	auipc	ra,0x1
    471e:	118080e7          	jalr	280(ra) # 5832 <exit>
      total += n;
    4722:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4726:	660d                	lui	a2,0x3
    4728:	85d2                	mv	a1,s4
    472a:	854e                	mv	a0,s3
    472c:	00001097          	auipc	ra,0x1
    4730:	11e080e7          	jalr	286(ra) # 584a <read>
    4734:	02a05363          	blez	a0,475a <fourfiles+0x1c6>
    4738:	00007797          	auipc	a5,0x7
    473c:	5e878793          	addi	a5,a5,1512 # bd20 <buf>
    4740:	fff5069b          	addiw	a3,a0,-1
    4744:	1682                	slli	a3,a3,0x20
    4746:	9281                	srli	a3,a3,0x20
    4748:	96d6                	add	a3,a3,s5
        if (buf[j] != '0' + i)
    474a:	0007c703          	lbu	a4,0(a5)
    474e:	fa971ce3          	bne	a4,s1,4706 <fourfiles+0x172>
      for (j = 0; j < n; j++)
    4752:	0785                	addi	a5,a5,1
    4754:	fed79be3          	bne	a5,a3,474a <fourfiles+0x1b6>
    4758:	b7e9                	j	4722 <fourfiles+0x18e>
    close(fd);
    475a:	854e                	mv	a0,s3
    475c:	00001097          	auipc	ra,0x1
    4760:	0fe080e7          	jalr	254(ra) # 585a <close>
    if (total != N * SZ)
    4764:	03a91963          	bne	s2,s10,4796 <fourfiles+0x202>
    unlink(fname);
    4768:	8562                	mv	a0,s8
    476a:	00001097          	auipc	ra,0x1
    476e:	118080e7          	jalr	280(ra) # 5882 <unlink>
  for (i = 0; i < NCHILD; i++)
    4772:	0ba1                	addi	s7,s7,8
    4774:	2b05                	addiw	s6,s6,1
    4776:	03bb0e63          	beq	s6,s11,47b2 <fourfiles+0x21e>
    fname = names[i];
    477a:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    477e:	4581                	li	a1,0
    4780:	8562                	mv	a0,s8
    4782:	00001097          	auipc	ra,0x1
    4786:	0f0080e7          	jalr	240(ra) # 5872 <open>
    478a:	89aa                	mv	s3,a0
    total = 0;
    478c:	f5843903          	ld	s2,-168(s0)
        if (buf[j] != '0' + i)
    4790:	000b049b          	sext.w	s1,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4794:	bf49                	j	4726 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4796:	85ca                	mv	a1,s2
    4798:	00003517          	auipc	a0,0x3
    479c:	56850513          	addi	a0,a0,1384 # 7d00 <malloc+0x2098>
    47a0:	00001097          	auipc	ra,0x1
    47a4:	40a080e7          	jalr	1034(ra) # 5baa <printf>
      exit(1);
    47a8:	4505                	li	a0,1
    47aa:	00001097          	auipc	ra,0x1
    47ae:	088080e7          	jalr	136(ra) # 5832 <exit>
}
    47b2:	70aa                	ld	ra,168(sp)
    47b4:	740a                	ld	s0,160(sp)
    47b6:	64ea                	ld	s1,152(sp)
    47b8:	694a                	ld	s2,144(sp)
    47ba:	69aa                	ld	s3,136(sp)
    47bc:	6a0a                	ld	s4,128(sp)
    47be:	7ae6                	ld	s5,120(sp)
    47c0:	7b46                	ld	s6,112(sp)
    47c2:	7ba6                	ld	s7,104(sp)
    47c4:	7c06                	ld	s8,96(sp)
    47c6:	6ce6                	ld	s9,88(sp)
    47c8:	6d46                	ld	s10,80(sp)
    47ca:	6da6                	ld	s11,72(sp)
    47cc:	614d                	addi	sp,sp,176
    47ce:	8082                	ret

00000000000047d0 <concreate>:
{
    47d0:	7135                	addi	sp,sp,-160
    47d2:	ed06                	sd	ra,152(sp)
    47d4:	e922                	sd	s0,144(sp)
    47d6:	e526                	sd	s1,136(sp)
    47d8:	e14a                	sd	s2,128(sp)
    47da:	fcce                	sd	s3,120(sp)
    47dc:	f8d2                	sd	s4,112(sp)
    47de:	f4d6                	sd	s5,104(sp)
    47e0:	f0da                	sd	s6,96(sp)
    47e2:	ecde                	sd	s7,88(sp)
    47e4:	1100                	addi	s0,sp,160
    47e6:	89aa                	mv	s3,a0
  file[0] = 'C';
    47e8:	04300793          	li	a5,67
    47ec:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    47f0:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++)
    47f4:	4901                	li	s2,0
    if (pid && (i % 3) == 1)
    47f6:	4b0d                	li	s6,3
    47f8:	4a85                	li	s5,1
      link("C0", file);
    47fa:	00003b97          	auipc	s7,0x3
    47fe:	51eb8b93          	addi	s7,s7,1310 # 7d18 <malloc+0x20b0>
  for (i = 0; i < N; i++)
    4802:	02800a13          	li	s4,40
    4806:	acc1                	j	4ad6 <concreate+0x306>
      link("C0", file);
    4808:	fa840593          	addi	a1,s0,-88
    480c:	855e                	mv	a0,s7
    480e:	00001097          	auipc	ra,0x1
    4812:	084080e7          	jalr	132(ra) # 5892 <link>
    if (pid == 0)
    4816:	a45d                	j	4abc <concreate+0x2ec>
    else if (pid == 0 && (i % 5) == 1)
    4818:	4795                	li	a5,5
    481a:	02f9693b          	remw	s2,s2,a5
    481e:	4785                	li	a5,1
    4820:	02f90b63          	beq	s2,a5,4856 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4824:	20200593          	li	a1,514
    4828:	fa840513          	addi	a0,s0,-88
    482c:	00001097          	auipc	ra,0x1
    4830:	046080e7          	jalr	70(ra) # 5872 <open>
      if (fd < 0)
    4834:	26055b63          	bgez	a0,4aaa <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4838:	fa840593          	addi	a1,s0,-88
    483c:	00003517          	auipc	a0,0x3
    4840:	4e450513          	addi	a0,a0,1252 # 7d20 <malloc+0x20b8>
    4844:	00001097          	auipc	ra,0x1
    4848:	366080e7          	jalr	870(ra) # 5baa <printf>
        exit(1);
    484c:	4505                	li	a0,1
    484e:	00001097          	auipc	ra,0x1
    4852:	fe4080e7          	jalr	-28(ra) # 5832 <exit>
      link("C0", file);
    4856:	fa840593          	addi	a1,s0,-88
    485a:	00003517          	auipc	a0,0x3
    485e:	4be50513          	addi	a0,a0,1214 # 7d18 <malloc+0x20b0>
    4862:	00001097          	auipc	ra,0x1
    4866:	030080e7          	jalr	48(ra) # 5892 <link>
      exit(0);
    486a:	4501                	li	a0,0
    486c:	00001097          	auipc	ra,0x1
    4870:	fc6080e7          	jalr	-58(ra) # 5832 <exit>
        exit(1);
    4874:	4505                	li	a0,1
    4876:	00001097          	auipc	ra,0x1
    487a:	fbc080e7          	jalr	-68(ra) # 5832 <exit>
  memset(fa, 0, sizeof(fa));
    487e:	02800613          	li	a2,40
    4882:	4581                	li	a1,0
    4884:	f8040513          	addi	a0,s0,-128
    4888:	00001097          	auipc	ra,0x1
    488c:	da6080e7          	jalr	-602(ra) # 562e <memset>
  fd = open(".", 0);
    4890:	4581                	li	a1,0
    4892:	00002517          	auipc	a0,0x2
    4896:	ece50513          	addi	a0,a0,-306 # 6760 <malloc+0xaf8>
    489a:	00001097          	auipc	ra,0x1
    489e:	fd8080e7          	jalr	-40(ra) # 5872 <open>
    48a2:	892a                	mv	s2,a0
  n = 0;
    48a4:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0')
    48a6:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa))
    48aa:	02700b13          	li	s6,39
      fa[i] = 1;
    48ae:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0)
    48b0:	a03d                	j	48de <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    48b2:	f7240613          	addi	a2,s0,-142
    48b6:	85ce                	mv	a1,s3
    48b8:	00003517          	auipc	a0,0x3
    48bc:	48850513          	addi	a0,a0,1160 # 7d40 <malloc+0x20d8>
    48c0:	00001097          	auipc	ra,0x1
    48c4:	2ea080e7          	jalr	746(ra) # 5baa <printf>
        exit(1);
    48c8:	4505                	li	a0,1
    48ca:	00001097          	auipc	ra,0x1
    48ce:	f68080e7          	jalr	-152(ra) # 5832 <exit>
      fa[i] = 1;
    48d2:	fb040793          	addi	a5,s0,-80
    48d6:	973e                	add	a4,a4,a5
    48d8:	fd770823          	sb	s7,-48(a4)
      n++;
    48dc:	2a85                	addiw	s5,s5,1
  while (read(fd, &de, sizeof(de)) > 0)
    48de:	4641                	li	a2,16
    48e0:	f7040593          	addi	a1,s0,-144
    48e4:	854a                	mv	a0,s2
    48e6:	00001097          	auipc	ra,0x1
    48ea:	f64080e7          	jalr	-156(ra) # 584a <read>
    48ee:	04a05a63          	blez	a0,4942 <concreate+0x172>
    if (de.inum == 0)
    48f2:	f7045783          	lhu	a5,-144(s0)
    48f6:	d7e5                	beqz	a5,48de <concreate+0x10e>
    if (de.name[0] == 'C' && de.name[2] == '\0')
    48f8:	f7244783          	lbu	a5,-142(s0)
    48fc:	ff4791e3          	bne	a5,s4,48de <concreate+0x10e>
    4900:	f7444783          	lbu	a5,-140(s0)
    4904:	ffe9                	bnez	a5,48de <concreate+0x10e>
      i = de.name[1] - '0';
    4906:	f7344783          	lbu	a5,-141(s0)
    490a:	fd07879b          	addiw	a5,a5,-48
    490e:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa))
    4912:	faeb60e3          	bltu	s6,a4,48b2 <concreate+0xe2>
      if (fa[i])
    4916:	fb040793          	addi	a5,s0,-80
    491a:	97ba                	add	a5,a5,a4
    491c:	fd07c783          	lbu	a5,-48(a5)
    4920:	dbcd                	beqz	a5,48d2 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4922:	f7240613          	addi	a2,s0,-142
    4926:	85ce                	mv	a1,s3
    4928:	00003517          	auipc	a0,0x3
    492c:	43850513          	addi	a0,a0,1080 # 7d60 <malloc+0x20f8>
    4930:	00001097          	auipc	ra,0x1
    4934:	27a080e7          	jalr	634(ra) # 5baa <printf>
        exit(1);
    4938:	4505                	li	a0,1
    493a:	00001097          	auipc	ra,0x1
    493e:	ef8080e7          	jalr	-264(ra) # 5832 <exit>
  close(fd);
    4942:	854a                	mv	a0,s2
    4944:	00001097          	auipc	ra,0x1
    4948:	f16080e7          	jalr	-234(ra) # 585a <close>
  if (n != N)
    494c:	02800793          	li	a5,40
    4950:	00fa9763          	bne	s5,a5,495e <concreate+0x18e>
    if (((i % 3) == 0 && pid == 0) ||
    4954:	4a8d                	li	s5,3
    4956:	4b05                	li	s6,1
  for (i = 0; i < N; i++)
    4958:	02800a13          	li	s4,40
    495c:	a8c9                	j	4a2e <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    495e:	85ce                	mv	a1,s3
    4960:	00003517          	auipc	a0,0x3
    4964:	42850513          	addi	a0,a0,1064 # 7d88 <malloc+0x2120>
    4968:	00001097          	auipc	ra,0x1
    496c:	242080e7          	jalr	578(ra) # 5baa <printf>
    exit(1);
    4970:	4505                	li	a0,1
    4972:	00001097          	auipc	ra,0x1
    4976:	ec0080e7          	jalr	-320(ra) # 5832 <exit>
      printf("%s: fork failed\n", s);
    497a:	85ce                	mv	a1,s3
    497c:	00002517          	auipc	a0,0x2
    4980:	f8450513          	addi	a0,a0,-124 # 6900 <malloc+0xc98>
    4984:	00001097          	auipc	ra,0x1
    4988:	226080e7          	jalr	550(ra) # 5baa <printf>
      exit(1);
    498c:	4505                	li	a0,1
    498e:	00001097          	auipc	ra,0x1
    4992:	ea4080e7          	jalr	-348(ra) # 5832 <exit>
      close(open(file, 0));
    4996:	4581                	li	a1,0
    4998:	fa840513          	addi	a0,s0,-88
    499c:	00001097          	auipc	ra,0x1
    49a0:	ed6080e7          	jalr	-298(ra) # 5872 <open>
    49a4:	00001097          	auipc	ra,0x1
    49a8:	eb6080e7          	jalr	-330(ra) # 585a <close>
      close(open(file, 0));
    49ac:	4581                	li	a1,0
    49ae:	fa840513          	addi	a0,s0,-88
    49b2:	00001097          	auipc	ra,0x1
    49b6:	ec0080e7          	jalr	-320(ra) # 5872 <open>
    49ba:	00001097          	auipc	ra,0x1
    49be:	ea0080e7          	jalr	-352(ra) # 585a <close>
      close(open(file, 0));
    49c2:	4581                	li	a1,0
    49c4:	fa840513          	addi	a0,s0,-88
    49c8:	00001097          	auipc	ra,0x1
    49cc:	eaa080e7          	jalr	-342(ra) # 5872 <open>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	e8a080e7          	jalr	-374(ra) # 585a <close>
      close(open(file, 0));
    49d8:	4581                	li	a1,0
    49da:	fa840513          	addi	a0,s0,-88
    49de:	00001097          	auipc	ra,0x1
    49e2:	e94080e7          	jalr	-364(ra) # 5872 <open>
    49e6:	00001097          	auipc	ra,0x1
    49ea:	e74080e7          	jalr	-396(ra) # 585a <close>
      close(open(file, 0));
    49ee:	4581                	li	a1,0
    49f0:	fa840513          	addi	a0,s0,-88
    49f4:	00001097          	auipc	ra,0x1
    49f8:	e7e080e7          	jalr	-386(ra) # 5872 <open>
    49fc:	00001097          	auipc	ra,0x1
    4a00:	e5e080e7          	jalr	-418(ra) # 585a <close>
      close(open(file, 0));
    4a04:	4581                	li	a1,0
    4a06:	fa840513          	addi	a0,s0,-88
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	e68080e7          	jalr	-408(ra) # 5872 <open>
    4a12:	00001097          	auipc	ra,0x1
    4a16:	e48080e7          	jalr	-440(ra) # 585a <close>
    if (pid == 0)
    4a1a:	08090363          	beqz	s2,4aa0 <concreate+0x2d0>
      wait(0);
    4a1e:	4501                	li	a0,0
    4a20:	00001097          	auipc	ra,0x1
    4a24:	e1a080e7          	jalr	-486(ra) # 583a <wait>
  for (i = 0; i < N; i++)
    4a28:	2485                	addiw	s1,s1,1
    4a2a:	0f448563          	beq	s1,s4,4b14 <concreate+0x344>
    file[1] = '0' + i;
    4a2e:	0304879b          	addiw	a5,s1,48
    4a32:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	df4080e7          	jalr	-524(ra) # 582a <fork>
    4a3e:	892a                	mv	s2,a0
    if (pid < 0)
    4a40:	f2054de3          	bltz	a0,497a <concreate+0x1aa>
    if (((i % 3) == 0 && pid == 0) ||
    4a44:	0354e73b          	remw	a4,s1,s5
    4a48:	00a767b3          	or	a5,a4,a0
    4a4c:	2781                	sext.w	a5,a5
    4a4e:	d7a1                	beqz	a5,4996 <concreate+0x1c6>
    4a50:	01671363          	bne	a4,s6,4a56 <concreate+0x286>
        ((i % 3) == 1 && pid != 0))
    4a54:	f129                	bnez	a0,4996 <concreate+0x1c6>
      unlink(file);
    4a56:	fa840513          	addi	a0,s0,-88
    4a5a:	00001097          	auipc	ra,0x1
    4a5e:	e28080e7          	jalr	-472(ra) # 5882 <unlink>
      unlink(file);
    4a62:	fa840513          	addi	a0,s0,-88
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	e1c080e7          	jalr	-484(ra) # 5882 <unlink>
      unlink(file);
    4a6e:	fa840513          	addi	a0,s0,-88
    4a72:	00001097          	auipc	ra,0x1
    4a76:	e10080e7          	jalr	-496(ra) # 5882 <unlink>
      unlink(file);
    4a7a:	fa840513          	addi	a0,s0,-88
    4a7e:	00001097          	auipc	ra,0x1
    4a82:	e04080e7          	jalr	-508(ra) # 5882 <unlink>
      unlink(file);
    4a86:	fa840513          	addi	a0,s0,-88
    4a8a:	00001097          	auipc	ra,0x1
    4a8e:	df8080e7          	jalr	-520(ra) # 5882 <unlink>
      unlink(file);
    4a92:	fa840513          	addi	a0,s0,-88
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	dec080e7          	jalr	-532(ra) # 5882 <unlink>
    4a9e:	bfb5                	j	4a1a <concreate+0x24a>
      exit(0);
    4aa0:	4501                	li	a0,0
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	d90080e7          	jalr	-624(ra) # 5832 <exit>
      close(fd);
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	db0080e7          	jalr	-592(ra) # 585a <close>
    if (pid == 0)
    4ab2:	bb65                	j	486a <concreate+0x9a>
      close(fd);
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	da6080e7          	jalr	-602(ra) # 585a <close>
      wait(&xstatus);
    4abc:	f6c40513          	addi	a0,s0,-148
    4ac0:	00001097          	auipc	ra,0x1
    4ac4:	d7a080e7          	jalr	-646(ra) # 583a <wait>
      if (xstatus != 0)
    4ac8:	f6c42483          	lw	s1,-148(s0)
    4acc:	da0494e3          	bnez	s1,4874 <concreate+0xa4>
  for (i = 0; i < N; i++)
    4ad0:	2905                	addiw	s2,s2,1
    4ad2:	db4906e3          	beq	s2,s4,487e <concreate+0xae>
    file[1] = '0' + i;
    4ad6:	0309079b          	addiw	a5,s2,48
    4ada:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4ade:	fa840513          	addi	a0,s0,-88
    4ae2:	00001097          	auipc	ra,0x1
    4ae6:	da0080e7          	jalr	-608(ra) # 5882 <unlink>
    pid = fork();
    4aea:	00001097          	auipc	ra,0x1
    4aee:	d40080e7          	jalr	-704(ra) # 582a <fork>
    if (pid && (i % 3) == 1)
    4af2:	d20503e3          	beqz	a0,4818 <concreate+0x48>
    4af6:	036967bb          	remw	a5,s2,s6
    4afa:	d15787e3          	beq	a5,s5,4808 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4afe:	20200593          	li	a1,514
    4b02:	fa840513          	addi	a0,s0,-88
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	d6c080e7          	jalr	-660(ra) # 5872 <open>
      if (fd < 0)
    4b0e:	fa0553e3          	bgez	a0,4ab4 <concreate+0x2e4>
    4b12:	b31d                	j	4838 <concreate+0x68>
}
    4b14:	60ea                	ld	ra,152(sp)
    4b16:	644a                	ld	s0,144(sp)
    4b18:	64aa                	ld	s1,136(sp)
    4b1a:	690a                	ld	s2,128(sp)
    4b1c:	79e6                	ld	s3,120(sp)
    4b1e:	7a46                	ld	s4,112(sp)
    4b20:	7aa6                	ld	s5,104(sp)
    4b22:	7b06                	ld	s6,96(sp)
    4b24:	6be6                	ld	s7,88(sp)
    4b26:	610d                	addi	sp,sp,160
    4b28:	8082                	ret

0000000000004b2a <bigfile>:
{
    4b2a:	7139                	addi	sp,sp,-64
    4b2c:	fc06                	sd	ra,56(sp)
    4b2e:	f822                	sd	s0,48(sp)
    4b30:	f426                	sd	s1,40(sp)
    4b32:	f04a                	sd	s2,32(sp)
    4b34:	ec4e                	sd	s3,24(sp)
    4b36:	e852                	sd	s4,16(sp)
    4b38:	e456                	sd	s5,8(sp)
    4b3a:	0080                	addi	s0,sp,64
    4b3c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4b3e:	00003517          	auipc	a0,0x3
    4b42:	28250513          	addi	a0,a0,642 # 7dc0 <malloc+0x2158>
    4b46:	00001097          	auipc	ra,0x1
    4b4a:	d3c080e7          	jalr	-708(ra) # 5882 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4b4e:	20200593          	li	a1,514
    4b52:	00003517          	auipc	a0,0x3
    4b56:	26e50513          	addi	a0,a0,622 # 7dc0 <malloc+0x2158>
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	d18080e7          	jalr	-744(ra) # 5872 <open>
    4b62:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++)
    4b64:	4481                	li	s1,0
    memset(buf, i, SZ);
    4b66:	00007917          	auipc	s2,0x7
    4b6a:	1ba90913          	addi	s2,s2,442 # bd20 <buf>
  for (i = 0; i < N; i++)
    4b6e:	4a51                	li	s4,20
  if (fd < 0)
    4b70:	0a054063          	bltz	a0,4c10 <bigfile+0xe6>
    memset(buf, i, SZ);
    4b74:	25800613          	li	a2,600
    4b78:	85a6                	mv	a1,s1
    4b7a:	854a                	mv	a0,s2
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	ab2080e7          	jalr	-1358(ra) # 562e <memset>
    if (write(fd, buf, SZ) != SZ)
    4b84:	25800613          	li	a2,600
    4b88:	85ca                	mv	a1,s2
    4b8a:	854e                	mv	a0,s3
    4b8c:	00001097          	auipc	ra,0x1
    4b90:	cc6080e7          	jalr	-826(ra) # 5852 <write>
    4b94:	25800793          	li	a5,600
    4b98:	08f51a63          	bne	a0,a5,4c2c <bigfile+0x102>
  for (i = 0; i < N; i++)
    4b9c:	2485                	addiw	s1,s1,1
    4b9e:	fd449be3          	bne	s1,s4,4b74 <bigfile+0x4a>
  close(fd);
    4ba2:	854e                	mv	a0,s3
    4ba4:	00001097          	auipc	ra,0x1
    4ba8:	cb6080e7          	jalr	-842(ra) # 585a <close>
  fd = open("bigfile.dat", 0);
    4bac:	4581                	li	a1,0
    4bae:	00003517          	auipc	a0,0x3
    4bb2:	21250513          	addi	a0,a0,530 # 7dc0 <malloc+0x2158>
    4bb6:	00001097          	auipc	ra,0x1
    4bba:	cbc080e7          	jalr	-836(ra) # 5872 <open>
    4bbe:	8a2a                	mv	s4,a0
  total = 0;
    4bc0:	4981                	li	s3,0
  for (i = 0;; i++)
    4bc2:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4bc4:	00007917          	auipc	s2,0x7
    4bc8:	15c90913          	addi	s2,s2,348 # bd20 <buf>
  if (fd < 0)
    4bcc:	06054e63          	bltz	a0,4c48 <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    4bd0:	12c00613          	li	a2,300
    4bd4:	85ca                	mv	a1,s2
    4bd6:	8552                	mv	a0,s4
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	c72080e7          	jalr	-910(ra) # 584a <read>
    if (cc < 0)
    4be0:	08054263          	bltz	a0,4c64 <bigfile+0x13a>
    if (cc == 0)
    4be4:	c971                	beqz	a0,4cb8 <bigfile+0x18e>
    if (cc != SZ / 2)
    4be6:	12c00793          	li	a5,300
    4bea:	08f51b63          	bne	a0,a5,4c80 <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2)
    4bee:	01f4d79b          	srliw	a5,s1,0x1f
    4bf2:	9fa5                	addw	a5,a5,s1
    4bf4:	4017d79b          	sraiw	a5,a5,0x1
    4bf8:	00094703          	lbu	a4,0(s2)
    4bfc:	0af71063          	bne	a4,a5,4c9c <bigfile+0x172>
    4c00:	12b94703          	lbu	a4,299(s2)
    4c04:	08f71c63          	bne	a4,a5,4c9c <bigfile+0x172>
    total += cc;
    4c08:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++)
    4c0c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    4c0e:	b7c9                	j	4bd0 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4c10:	85d6                	mv	a1,s5
    4c12:	00003517          	auipc	a0,0x3
    4c16:	1be50513          	addi	a0,a0,446 # 7dd0 <malloc+0x2168>
    4c1a:	00001097          	auipc	ra,0x1
    4c1e:	f90080e7          	jalr	-112(ra) # 5baa <printf>
    exit(1);
    4c22:	4505                	li	a0,1
    4c24:	00001097          	auipc	ra,0x1
    4c28:	c0e080e7          	jalr	-1010(ra) # 5832 <exit>
      printf("%s: write bigfile failed\n", s);
    4c2c:	85d6                	mv	a1,s5
    4c2e:	00003517          	auipc	a0,0x3
    4c32:	1c250513          	addi	a0,a0,450 # 7df0 <malloc+0x2188>
    4c36:	00001097          	auipc	ra,0x1
    4c3a:	f74080e7          	jalr	-140(ra) # 5baa <printf>
      exit(1);
    4c3e:	4505                	li	a0,1
    4c40:	00001097          	auipc	ra,0x1
    4c44:	bf2080e7          	jalr	-1038(ra) # 5832 <exit>
    printf("%s: cannot open bigfile\n", s);
    4c48:	85d6                	mv	a1,s5
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	1c650513          	addi	a0,a0,454 # 7e10 <malloc+0x21a8>
    4c52:	00001097          	auipc	ra,0x1
    4c56:	f58080e7          	jalr	-168(ra) # 5baa <printf>
    exit(1);
    4c5a:	4505                	li	a0,1
    4c5c:	00001097          	auipc	ra,0x1
    4c60:	bd6080e7          	jalr	-1066(ra) # 5832 <exit>
      printf("%s: read bigfile failed\n", s);
    4c64:	85d6                	mv	a1,s5
    4c66:	00003517          	auipc	a0,0x3
    4c6a:	1ca50513          	addi	a0,a0,458 # 7e30 <malloc+0x21c8>
    4c6e:	00001097          	auipc	ra,0x1
    4c72:	f3c080e7          	jalr	-196(ra) # 5baa <printf>
      exit(1);
    4c76:	4505                	li	a0,1
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	bba080e7          	jalr	-1094(ra) # 5832 <exit>
      printf("%s: short read bigfile\n", s);
    4c80:	85d6                	mv	a1,s5
    4c82:	00003517          	auipc	a0,0x3
    4c86:	1ce50513          	addi	a0,a0,462 # 7e50 <malloc+0x21e8>
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	f20080e7          	jalr	-224(ra) # 5baa <printf>
      exit(1);
    4c92:	4505                	li	a0,1
    4c94:	00001097          	auipc	ra,0x1
    4c98:	b9e080e7          	jalr	-1122(ra) # 5832 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c9c:	85d6                	mv	a1,s5
    4c9e:	00003517          	auipc	a0,0x3
    4ca2:	1ca50513          	addi	a0,a0,458 # 7e68 <malloc+0x2200>
    4ca6:	00001097          	auipc	ra,0x1
    4caa:	f04080e7          	jalr	-252(ra) # 5baa <printf>
      exit(1);
    4cae:	4505                	li	a0,1
    4cb0:	00001097          	auipc	ra,0x1
    4cb4:	b82080e7          	jalr	-1150(ra) # 5832 <exit>
  close(fd);
    4cb8:	8552                	mv	a0,s4
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	ba0080e7          	jalr	-1120(ra) # 585a <close>
  if (total != N * SZ)
    4cc2:	678d                	lui	a5,0x3
    4cc4:	ee078793          	addi	a5,a5,-288 # 2ee0 <iputtest+0xc2>
    4cc8:	02f99363          	bne	s3,a5,4cee <bigfile+0x1c4>
  unlink("bigfile.dat");
    4ccc:	00003517          	auipc	a0,0x3
    4cd0:	0f450513          	addi	a0,a0,244 # 7dc0 <malloc+0x2158>
    4cd4:	00001097          	auipc	ra,0x1
    4cd8:	bae080e7          	jalr	-1106(ra) # 5882 <unlink>
}
    4cdc:	70e2                	ld	ra,56(sp)
    4cde:	7442                	ld	s0,48(sp)
    4ce0:	74a2                	ld	s1,40(sp)
    4ce2:	7902                	ld	s2,32(sp)
    4ce4:	69e2                	ld	s3,24(sp)
    4ce6:	6a42                	ld	s4,16(sp)
    4ce8:	6aa2                	ld	s5,8(sp)
    4cea:	6121                	addi	sp,sp,64
    4cec:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4cee:	85d6                	mv	a1,s5
    4cf0:	00003517          	auipc	a0,0x3
    4cf4:	19850513          	addi	a0,a0,408 # 7e88 <malloc+0x2220>
    4cf8:	00001097          	auipc	ra,0x1
    4cfc:	eb2080e7          	jalr	-334(ra) # 5baa <printf>
    exit(1);
    4d00:	4505                	li	a0,1
    4d02:	00001097          	auipc	ra,0x1
    4d06:	b30080e7          	jalr	-1232(ra) # 5832 <exit>

0000000000004d0a <mem>:
{
    4d0a:	7139                	addi	sp,sp,-64
    4d0c:	fc06                	sd	ra,56(sp)
    4d0e:	f822                	sd	s0,48(sp)
    4d10:	f426                	sd	s1,40(sp)
    4d12:	f04a                	sd	s2,32(sp)
    4d14:	ec4e                	sd	s3,24(sp)
    4d16:	0080                	addi	s0,sp,64
    4d18:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0)
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	b10080e7          	jalr	-1264(ra) # 582a <fork>
    m1 = 0;
    4d22:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0)
    4d24:	6909                	lui	s2,0x2
    4d26:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0xf1>
  if ((pid = fork()) == 0)
    4d2a:	ed39                	bnez	a0,4d88 <mem+0x7e>
    while ((m2 = malloc(10001)) != 0)
    4d2c:	854a                	mv	a0,s2
    4d2e:	00001097          	auipc	ra,0x1
    4d32:	f3a080e7          	jalr	-198(ra) # 5c68 <malloc>
    4d36:	c501                	beqz	a0,4d3e <mem+0x34>
      *(char **)m2 = m1;
    4d38:	e104                	sd	s1,0(a0)
      m1 = m2;
    4d3a:	84aa                	mv	s1,a0
    4d3c:	bfc5                	j	4d2c <mem+0x22>
    while (m1)
    4d3e:	c881                	beqz	s1,4d4e <mem+0x44>
      m2 = *(char **)m1;
    4d40:	8526                	mv	a0,s1
    4d42:	6084                	ld	s1,0(s1)
      free(m1);
    4d44:	00001097          	auipc	ra,0x1
    4d48:	e9c080e7          	jalr	-356(ra) # 5be0 <free>
    while (m1)
    4d4c:	f8f5                	bnez	s1,4d40 <mem+0x36>
    m1 = malloc(1024 * 20);
    4d4e:	6515                	lui	a0,0x5
    4d50:	00001097          	auipc	ra,0x1
    4d54:	f18080e7          	jalr	-232(ra) # 5c68 <malloc>
    if (m1 == 0)
    4d58:	c911                	beqz	a0,4d6c <mem+0x62>
    free(m1);
    4d5a:	00001097          	auipc	ra,0x1
    4d5e:	e86080e7          	jalr	-378(ra) # 5be0 <free>
    exit(0);
    4d62:	4501                	li	a0,0
    4d64:	00001097          	auipc	ra,0x1
    4d68:	ace080e7          	jalr	-1330(ra) # 5832 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4d6c:	85ce                	mv	a1,s3
    4d6e:	00003517          	auipc	a0,0x3
    4d72:	13a50513          	addi	a0,a0,314 # 7ea8 <malloc+0x2240>
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	e34080e7          	jalr	-460(ra) # 5baa <printf>
      exit(1);
    4d7e:	4505                	li	a0,1
    4d80:	00001097          	auipc	ra,0x1
    4d84:	ab2080e7          	jalr	-1358(ra) # 5832 <exit>
    wait(&xstatus);
    4d88:	fcc40513          	addi	a0,s0,-52
    4d8c:	00001097          	auipc	ra,0x1
    4d90:	aae080e7          	jalr	-1362(ra) # 583a <wait>
    if (xstatus == -1)
    4d94:	fcc42503          	lw	a0,-52(s0)
    4d98:	57fd                	li	a5,-1
    4d9a:	00f50663          	beq	a0,a5,4da6 <mem+0x9c>
    exit(xstatus);
    4d9e:	00001097          	auipc	ra,0x1
    4da2:	a94080e7          	jalr	-1388(ra) # 5832 <exit>
      exit(0);
    4da6:	4501                	li	a0,0
    4da8:	00001097          	auipc	ra,0x1
    4dac:	a8a080e7          	jalr	-1398(ra) # 5832 <exit>

0000000000004db0 <fsfull>:
{
    4db0:	7171                	addi	sp,sp,-176
    4db2:	f506                	sd	ra,168(sp)
    4db4:	f122                	sd	s0,160(sp)
    4db6:	ed26                	sd	s1,152(sp)
    4db8:	e94a                	sd	s2,144(sp)
    4dba:	e54e                	sd	s3,136(sp)
    4dbc:	e152                	sd	s4,128(sp)
    4dbe:	fcd6                	sd	s5,120(sp)
    4dc0:	f8da                	sd	s6,112(sp)
    4dc2:	f4de                	sd	s7,104(sp)
    4dc4:	f0e2                	sd	s8,96(sp)
    4dc6:	ece6                	sd	s9,88(sp)
    4dc8:	e8ea                	sd	s10,80(sp)
    4dca:	e4ee                	sd	s11,72(sp)
    4dcc:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4dce:	00003517          	auipc	a0,0x3
    4dd2:	0fa50513          	addi	a0,a0,250 # 7ec8 <malloc+0x2260>
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	dd4080e7          	jalr	-556(ra) # 5baa <printf>
  for (nfiles = 0;; nfiles++)
    4dde:	4481                	li	s1,0
    name[0] = 'f';
    4de0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4de4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4de8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4dec:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4dee:	00003c97          	auipc	s9,0x3
    4df2:	0eac8c93          	addi	s9,s9,234 # 7ed8 <malloc+0x2270>
    int total = 0;
    4df6:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4df8:	00007a17          	auipc	s4,0x7
    4dfc:	f28a0a13          	addi	s4,s4,-216 # bd20 <buf>
    name[0] = 'f';
    4e00:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e04:	0384c7bb          	divw	a5,s1,s8
    4e08:	0307879b          	addiw	a5,a5,48
    4e0c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e10:	0384e7bb          	remw	a5,s1,s8
    4e14:	0377c7bb          	divw	a5,a5,s7
    4e18:	0307879b          	addiw	a5,a5,48
    4e1c:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e20:	0374e7bb          	remw	a5,s1,s7
    4e24:	0367c7bb          	divw	a5,a5,s6
    4e28:	0307879b          	addiw	a5,a5,48
    4e2c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e30:	0364e7bb          	remw	a5,s1,s6
    4e34:	0307879b          	addiw	a5,a5,48
    4e38:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e3c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4e40:	f5040593          	addi	a1,s0,-176
    4e44:	8566                	mv	a0,s9
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	d64080e7          	jalr	-668(ra) # 5baa <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4e4e:	20200593          	li	a1,514
    4e52:	f5040513          	addi	a0,s0,-176
    4e56:	00001097          	auipc	ra,0x1
    4e5a:	a1c080e7          	jalr	-1508(ra) # 5872 <open>
    4e5e:	892a                	mv	s2,a0
    if (fd < 0)
    4e60:	0a055663          	bgez	a0,4f0c <fsfull+0x15c>
      printf("open %s failed\n", name);
    4e64:	f5040593          	addi	a1,s0,-176
    4e68:	00003517          	auipc	a0,0x3
    4e6c:	08050513          	addi	a0,a0,128 # 7ee8 <malloc+0x2280>
    4e70:	00001097          	auipc	ra,0x1
    4e74:	d3a080e7          	jalr	-710(ra) # 5baa <printf>
  while (nfiles >= 0)
    4e78:	0604c363          	bltz	s1,4ede <fsfull+0x12e>
    name[0] = 'f';
    4e7c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4e80:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e84:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e88:	4929                	li	s2,10
  while (nfiles >= 0)
    4e8a:	5afd                	li	s5,-1
    name[0] = 'f';
    4e8c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e90:	0344c7bb          	divw	a5,s1,s4
    4e94:	0307879b          	addiw	a5,a5,48
    4e98:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e9c:	0344e7bb          	remw	a5,s1,s4
    4ea0:	0337c7bb          	divw	a5,a5,s3
    4ea4:	0307879b          	addiw	a5,a5,48
    4ea8:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4eac:	0334e7bb          	remw	a5,s1,s3
    4eb0:	0327c7bb          	divw	a5,a5,s2
    4eb4:	0307879b          	addiw	a5,a5,48
    4eb8:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ebc:	0324e7bb          	remw	a5,s1,s2
    4ec0:	0307879b          	addiw	a5,a5,48
    4ec4:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ec8:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4ecc:	f5040513          	addi	a0,s0,-176
    4ed0:	00001097          	auipc	ra,0x1
    4ed4:	9b2080e7          	jalr	-1614(ra) # 5882 <unlink>
    nfiles--;
    4ed8:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0)
    4eda:	fb5499e3          	bne	s1,s5,4e8c <fsfull+0xdc>
  printf("fsfull test finished\n");
    4ede:	00003517          	auipc	a0,0x3
    4ee2:	02a50513          	addi	a0,a0,42 # 7f08 <malloc+0x22a0>
    4ee6:	00001097          	auipc	ra,0x1
    4eea:	cc4080e7          	jalr	-828(ra) # 5baa <printf>
}
    4eee:	70aa                	ld	ra,168(sp)
    4ef0:	740a                	ld	s0,160(sp)
    4ef2:	64ea                	ld	s1,152(sp)
    4ef4:	694a                	ld	s2,144(sp)
    4ef6:	69aa                	ld	s3,136(sp)
    4ef8:	6a0a                	ld	s4,128(sp)
    4efa:	7ae6                	ld	s5,120(sp)
    4efc:	7b46                	ld	s6,112(sp)
    4efe:	7ba6                	ld	s7,104(sp)
    4f00:	7c06                	ld	s8,96(sp)
    4f02:	6ce6                	ld	s9,88(sp)
    4f04:	6d46                	ld	s10,80(sp)
    4f06:	6da6                	ld	s11,72(sp)
    4f08:	614d                	addi	sp,sp,176
    4f0a:	8082                	ret
    int total = 0;
    4f0c:	89ee                	mv	s3,s11
      if (cc < BSIZE)
    4f0e:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4f12:	40000613          	li	a2,1024
    4f16:	85d2                	mv	a1,s4
    4f18:	854a                	mv	a0,s2
    4f1a:	00001097          	auipc	ra,0x1
    4f1e:	938080e7          	jalr	-1736(ra) # 5852 <write>
      if (cc < BSIZE)
    4f22:	00aad563          	bge	s5,a0,4f2c <fsfull+0x17c>
      total += cc;
    4f26:	00a989bb          	addw	s3,s3,a0
    {
    4f2a:	b7e5                	j	4f12 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4f2c:	85ce                	mv	a1,s3
    4f2e:	00003517          	auipc	a0,0x3
    4f32:	fca50513          	addi	a0,a0,-54 # 7ef8 <malloc+0x2290>
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	c74080e7          	jalr	-908(ra) # 5baa <printf>
    close(fd);
    4f3e:	854a                	mv	a0,s2
    4f40:	00001097          	auipc	ra,0x1
    4f44:	91a080e7          	jalr	-1766(ra) # 585a <close>
    if (total == 0)
    4f48:	f20988e3          	beqz	s3,4e78 <fsfull+0xc8>
  for (nfiles = 0;; nfiles++)
    4f4c:	2485                	addiw	s1,s1,1
  {
    4f4e:	bd4d                	j	4e00 <fsfull+0x50>

0000000000004f50 <sbrkbugs>:
{
    4f50:	1141                	addi	sp,sp,-16
    4f52:	e406                	sd	ra,8(sp)
    4f54:	e022                	sd	s0,0(sp)
    4f56:	0800                	addi	s0,sp,16
  int pid = fork();
    4f58:	00001097          	auipc	ra,0x1
    4f5c:	8d2080e7          	jalr	-1838(ra) # 582a <fork>
  if (pid < 0)
    4f60:	02054263          	bltz	a0,4f84 <sbrkbugs+0x34>
  if (pid == 0)
    4f64:	ed0d                	bnez	a0,4f9e <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    4f66:	00001097          	auipc	ra,0x1
    4f6a:	954080e7          	jalr	-1708(ra) # 58ba <sbrk>
    sbrk(-sz);
    4f6e:	40a0053b          	negw	a0,a0
    4f72:	00001097          	auipc	ra,0x1
    4f76:	948080e7          	jalr	-1720(ra) # 58ba <sbrk>
    exit(0);
    4f7a:	4501                	li	a0,0
    4f7c:	00001097          	auipc	ra,0x1
    4f80:	8b6080e7          	jalr	-1866(ra) # 5832 <exit>
    printf("fork failed\n");
    4f84:	00002517          	auipc	a0,0x2
    4f88:	d9c50513          	addi	a0,a0,-612 # 6d20 <malloc+0x10b8>
    4f8c:	00001097          	auipc	ra,0x1
    4f90:	c1e080e7          	jalr	-994(ra) # 5baa <printf>
    exit(1);
    4f94:	4505                	li	a0,1
    4f96:	00001097          	auipc	ra,0x1
    4f9a:	89c080e7          	jalr	-1892(ra) # 5832 <exit>
  wait(0);
    4f9e:	4501                	li	a0,0
    4fa0:	00001097          	auipc	ra,0x1
    4fa4:	89a080e7          	jalr	-1894(ra) # 583a <wait>
  pid = fork();
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	882080e7          	jalr	-1918(ra) # 582a <fork>
  if (pid < 0)
    4fb0:	02054563          	bltz	a0,4fda <sbrkbugs+0x8a>
  if (pid == 0)
    4fb4:	e121                	bnez	a0,4ff4 <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	904080e7          	jalr	-1788(ra) # 58ba <sbrk>
    sbrk(-(sz - 3500));
    4fbe:	6785                	lui	a5,0x1
    4fc0:	dac7879b          	addiw	a5,a5,-596
    4fc4:	40a7853b          	subw	a0,a5,a0
    4fc8:	00001097          	auipc	ra,0x1
    4fcc:	8f2080e7          	jalr	-1806(ra) # 58ba <sbrk>
    exit(0);
    4fd0:	4501                	li	a0,0
    4fd2:	00001097          	auipc	ra,0x1
    4fd6:	860080e7          	jalr	-1952(ra) # 5832 <exit>
    printf("fork failed\n");
    4fda:	00002517          	auipc	a0,0x2
    4fde:	d4650513          	addi	a0,a0,-698 # 6d20 <malloc+0x10b8>
    4fe2:	00001097          	auipc	ra,0x1
    4fe6:	bc8080e7          	jalr	-1080(ra) # 5baa <printf>
    exit(1);
    4fea:	4505                	li	a0,1
    4fec:	00001097          	auipc	ra,0x1
    4ff0:	846080e7          	jalr	-1978(ra) # 5832 <exit>
  wait(0);
    4ff4:	4501                	li	a0,0
    4ff6:	00001097          	auipc	ra,0x1
    4ffa:	844080e7          	jalr	-1980(ra) # 583a <wait>
  pid = fork();
    4ffe:	00001097          	auipc	ra,0x1
    5002:	82c080e7          	jalr	-2004(ra) # 582a <fork>
  if (pid < 0)
    5006:	02054a63          	bltz	a0,503a <sbrkbugs+0xea>
  if (pid == 0)
    500a:	e529                	bnez	a0,5054 <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    500c:	00001097          	auipc	ra,0x1
    5010:	8ae080e7          	jalr	-1874(ra) # 58ba <sbrk>
    5014:	67ad                	lui	a5,0xb
    5016:	8007879b          	addiw	a5,a5,-2048
    501a:	40a7853b          	subw	a0,a5,a0
    501e:	00001097          	auipc	ra,0x1
    5022:	89c080e7          	jalr	-1892(ra) # 58ba <sbrk>
    sbrk(-10);
    5026:	5559                	li	a0,-10
    5028:	00001097          	auipc	ra,0x1
    502c:	892080e7          	jalr	-1902(ra) # 58ba <sbrk>
    exit(0);
    5030:	4501                	li	a0,0
    5032:	00001097          	auipc	ra,0x1
    5036:	800080e7          	jalr	-2048(ra) # 5832 <exit>
    printf("fork failed\n");
    503a:	00002517          	auipc	a0,0x2
    503e:	ce650513          	addi	a0,a0,-794 # 6d20 <malloc+0x10b8>
    5042:	00001097          	auipc	ra,0x1
    5046:	b68080e7          	jalr	-1176(ra) # 5baa <printf>
    exit(1);
    504a:	4505                	li	a0,1
    504c:	00000097          	auipc	ra,0x0
    5050:	7e6080e7          	jalr	2022(ra) # 5832 <exit>
  wait(0);
    5054:	4501                	li	a0,0
    5056:	00000097          	auipc	ra,0x0
    505a:	7e4080e7          	jalr	2020(ra) # 583a <wait>
  exit(0);
    505e:	4501                	li	a0,0
    5060:	00000097          	auipc	ra,0x0
    5064:	7d2080e7          	jalr	2002(ra) # 5832 <exit>

0000000000005068 <badwrite>:
{
    5068:	7179                	addi	sp,sp,-48
    506a:	f406                	sd	ra,40(sp)
    506c:	f022                	sd	s0,32(sp)
    506e:	ec26                	sd	s1,24(sp)
    5070:	e84a                	sd	s2,16(sp)
    5072:	e44e                	sd	s3,8(sp)
    5074:	e052                	sd	s4,0(sp)
    5076:	1800                	addi	s0,sp,48
  unlink("junk");
    5078:	00003517          	auipc	a0,0x3
    507c:	ea850513          	addi	a0,a0,-344 # 7f20 <malloc+0x22b8>
    5080:	00001097          	auipc	ra,0x1
    5084:	802080e7          	jalr	-2046(ra) # 5882 <unlink>
    5088:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE | O_WRONLY);
    508c:	00003997          	auipc	s3,0x3
    5090:	e9498993          	addi	s3,s3,-364 # 7f20 <malloc+0x22b8>
    write(fd, (char *)0xffffffffffL, 1);
    5094:	5a7d                	li	s4,-1
    5096:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
    509a:	20100593          	li	a1,513
    509e:	854e                	mv	a0,s3
    50a0:	00000097          	auipc	ra,0x0
    50a4:	7d2080e7          	jalr	2002(ra) # 5872 <open>
    50a8:	84aa                	mv	s1,a0
    if (fd < 0)
    50aa:	06054b63          	bltz	a0,5120 <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
    50ae:	4605                	li	a2,1
    50b0:	85d2                	mv	a1,s4
    50b2:	00000097          	auipc	ra,0x0
    50b6:	7a0080e7          	jalr	1952(ra) # 5852 <write>
    close(fd);
    50ba:	8526                	mv	a0,s1
    50bc:	00000097          	auipc	ra,0x0
    50c0:	79e080e7          	jalr	1950(ra) # 585a <close>
    unlink("junk");
    50c4:	854e                	mv	a0,s3
    50c6:	00000097          	auipc	ra,0x0
    50ca:	7bc080e7          	jalr	1980(ra) # 5882 <unlink>
  for (int i = 0; i < assumed_free; i++)
    50ce:	397d                	addiw	s2,s2,-1
    50d0:	fc0915e3          	bnez	s2,509a <badwrite+0x32>
  int fd = open("junk", O_CREATE | O_WRONLY);
    50d4:	20100593          	li	a1,513
    50d8:	00003517          	auipc	a0,0x3
    50dc:	e4850513          	addi	a0,a0,-440 # 7f20 <malloc+0x22b8>
    50e0:	00000097          	auipc	ra,0x0
    50e4:	792080e7          	jalr	1938(ra) # 5872 <open>
    50e8:	84aa                	mv	s1,a0
  if (fd < 0)
    50ea:	04054863          	bltz	a0,513a <badwrite+0xd2>
  if (write(fd, "x", 1) != 1)
    50ee:	4605                	li	a2,1
    50f0:	00001597          	auipc	a1,0x1
    50f4:	04858593          	addi	a1,a1,72 # 6138 <malloc+0x4d0>
    50f8:	00000097          	auipc	ra,0x0
    50fc:	75a080e7          	jalr	1882(ra) # 5852 <write>
    5100:	4785                	li	a5,1
    5102:	04f50963          	beq	a0,a5,5154 <badwrite+0xec>
    printf("write failed\n");
    5106:	00003517          	auipc	a0,0x3
    510a:	e3a50513          	addi	a0,a0,-454 # 7f40 <malloc+0x22d8>
    510e:	00001097          	auipc	ra,0x1
    5112:	a9c080e7          	jalr	-1380(ra) # 5baa <printf>
    exit(1);
    5116:	4505                	li	a0,1
    5118:	00000097          	auipc	ra,0x0
    511c:	71a080e7          	jalr	1818(ra) # 5832 <exit>
      printf("open junk failed\n");
    5120:	00003517          	auipc	a0,0x3
    5124:	e0850513          	addi	a0,a0,-504 # 7f28 <malloc+0x22c0>
    5128:	00001097          	auipc	ra,0x1
    512c:	a82080e7          	jalr	-1406(ra) # 5baa <printf>
      exit(1);
    5130:	4505                	li	a0,1
    5132:	00000097          	auipc	ra,0x0
    5136:	700080e7          	jalr	1792(ra) # 5832 <exit>
    printf("open junk failed\n");
    513a:	00003517          	auipc	a0,0x3
    513e:	dee50513          	addi	a0,a0,-530 # 7f28 <malloc+0x22c0>
    5142:	00001097          	auipc	ra,0x1
    5146:	a68080e7          	jalr	-1432(ra) # 5baa <printf>
    exit(1);
    514a:	4505                	li	a0,1
    514c:	00000097          	auipc	ra,0x0
    5150:	6e6080e7          	jalr	1766(ra) # 5832 <exit>
  close(fd);
    5154:	8526                	mv	a0,s1
    5156:	00000097          	auipc	ra,0x0
    515a:	704080e7          	jalr	1796(ra) # 585a <close>
  unlink("junk");
    515e:	00003517          	auipc	a0,0x3
    5162:	dc250513          	addi	a0,a0,-574 # 7f20 <malloc+0x22b8>
    5166:	00000097          	auipc	ra,0x0
    516a:	71c080e7          	jalr	1820(ra) # 5882 <unlink>
  exit(0);
    516e:	4501                	li	a0,0
    5170:	00000097          	auipc	ra,0x0
    5174:	6c2080e7          	jalr	1730(ra) # 5832 <exit>

0000000000005178 <badarg>:
{
    5178:	7139                	addi	sp,sp,-64
    517a:	fc06                	sd	ra,56(sp)
    517c:	f822                	sd	s0,48(sp)
    517e:	f426                	sd	s1,40(sp)
    5180:	f04a                	sd	s2,32(sp)
    5182:	ec4e                	sd	s3,24(sp)
    5184:	0080                	addi	s0,sp,64
    5186:	64b1                	lui	s1,0xc
    5188:	35048493          	addi	s1,s1,848 # c350 <buf+0x630>
    argv[0] = (char *)0xffffffff;
    518c:	597d                	li	s2,-1
    518e:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    5192:	00001997          	auipc	s3,0x1
    5196:	f3698993          	addi	s3,s3,-202 # 60c8 <malloc+0x460>
    argv[0] = (char *)0xffffffff;
    519a:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    519e:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    51a2:	fc040593          	addi	a1,s0,-64
    51a6:	854e                	mv	a0,s3
    51a8:	00000097          	auipc	ra,0x0
    51ac:	6c2080e7          	jalr	1730(ra) # 586a <exec>
  for (int i = 0; i < 50000; i++)
    51b0:	34fd                	addiw	s1,s1,-1
    51b2:	f4e5                	bnez	s1,519a <badarg+0x22>
  exit(0);
    51b4:	4501                	li	a0,0
    51b6:	00000097          	auipc	ra,0x0
    51ba:	67c080e7          	jalr	1660(ra) # 5832 <exit>

00000000000051be <countfree>:
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree()
{
    51be:	7139                	addi	sp,sp,-64
    51c0:	fc06                	sd	ra,56(sp)
    51c2:	f822                	sd	s0,48(sp)
    51c4:	f426                	sd	s1,40(sp)
    51c6:	f04a                	sd	s2,32(sp)
    51c8:	ec4e                	sd	s3,24(sp)
    51ca:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0)
    51cc:	fc840513          	addi	a0,s0,-56
    51d0:	00000097          	auipc	ra,0x0
    51d4:	672080e7          	jalr	1650(ra) # 5842 <pipe>
    51d8:	06054863          	bltz	a0,5248 <countfree+0x8a>
  {
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    51dc:	00000097          	auipc	ra,0x0
    51e0:	64e080e7          	jalr	1614(ra) # 582a <fork>

  if (pid < 0)
    51e4:	06054f63          	bltz	a0,5262 <countfree+0xa4>
  {
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0)
    51e8:	ed59                	bnez	a0,5286 <countfree+0xc8>
  {
    close(fds[0]);
    51ea:	fc842503          	lw	a0,-56(s0)
    51ee:	00000097          	auipc	ra,0x0
    51f2:	66c080e7          	jalr	1644(ra) # 585a <close>

    while (1)
    {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff)
    51f6:	54fd                	li	s1,-1
      {
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    51f8:	4985                	li	s3,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1)
    51fa:	00001917          	auipc	s2,0x1
    51fe:	f3e90913          	addi	s2,s2,-194 # 6138 <malloc+0x4d0>
      uint64 a = (uint64)sbrk(4096);
    5202:	6505                	lui	a0,0x1
    5204:	00000097          	auipc	ra,0x0
    5208:	6b6080e7          	jalr	1718(ra) # 58ba <sbrk>
      if (a == 0xffffffffffffffff)
    520c:	06950863          	beq	a0,s1,527c <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5210:	6785                	lui	a5,0x1
    5212:	953e                	add	a0,a0,a5
    5214:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x9d>
      if (write(fds[1], "x", 1) != 1)
    5218:	4605                	li	a2,1
    521a:	85ca                	mv	a1,s2
    521c:	fcc42503          	lw	a0,-52(s0)
    5220:	00000097          	auipc	ra,0x0
    5224:	632080e7          	jalr	1586(ra) # 5852 <write>
    5228:	4785                	li	a5,1
    522a:	fcf50ce3          	beq	a0,a5,5202 <countfree+0x44>
      {
        printf("write() failed in countfree()\n");
    522e:	00003517          	auipc	a0,0x3
    5232:	d6250513          	addi	a0,a0,-670 # 7f90 <malloc+0x2328>
    5236:	00001097          	auipc	ra,0x1
    523a:	974080e7          	jalr	-1676(ra) # 5baa <printf>
        exit(1);
    523e:	4505                	li	a0,1
    5240:	00000097          	auipc	ra,0x0
    5244:	5f2080e7          	jalr	1522(ra) # 5832 <exit>
    printf("pipe() failed in countfree()\n");
    5248:	00003517          	auipc	a0,0x3
    524c:	d0850513          	addi	a0,a0,-760 # 7f50 <malloc+0x22e8>
    5250:	00001097          	auipc	ra,0x1
    5254:	95a080e7          	jalr	-1702(ra) # 5baa <printf>
    exit(1);
    5258:	4505                	li	a0,1
    525a:	00000097          	auipc	ra,0x0
    525e:	5d8080e7          	jalr	1496(ra) # 5832 <exit>
    printf("fork failed in countfree()\n");
    5262:	00003517          	auipc	a0,0x3
    5266:	d0e50513          	addi	a0,a0,-754 # 7f70 <malloc+0x2308>
    526a:	00001097          	auipc	ra,0x1
    526e:	940080e7          	jalr	-1728(ra) # 5baa <printf>
    exit(1);
    5272:	4505                	li	a0,1
    5274:	00000097          	auipc	ra,0x0
    5278:	5be080e7          	jalr	1470(ra) # 5832 <exit>
      }
    }

    exit(0);
    527c:	4501                	li	a0,0
    527e:	00000097          	auipc	ra,0x0
    5282:	5b4080e7          	jalr	1460(ra) # 5832 <exit>
  }

  close(fds[1]);
    5286:	fcc42503          	lw	a0,-52(s0)
    528a:	00000097          	auipc	ra,0x0
    528e:	5d0080e7          	jalr	1488(ra) # 585a <close>

  int n = 0;
    5292:	4481                	li	s1,0
  while (1)
  {
    char c;
    int cc = read(fds[0], &c, 1);
    5294:	4605                	li	a2,1
    5296:	fc740593          	addi	a1,s0,-57
    529a:	fc842503          	lw	a0,-56(s0)
    529e:	00000097          	auipc	ra,0x0
    52a2:	5ac080e7          	jalr	1452(ra) # 584a <read>
    if (cc < 0)
    52a6:	00054563          	bltz	a0,52b0 <countfree+0xf2>
    {
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0)
    52aa:	c105                	beqz	a0,52ca <countfree+0x10c>
      break;
    n += 1;
    52ac:	2485                	addiw	s1,s1,1
  {
    52ae:	b7dd                	j	5294 <countfree+0xd6>
      printf("read() failed in countfree()\n");
    52b0:	00003517          	auipc	a0,0x3
    52b4:	d0050513          	addi	a0,a0,-768 # 7fb0 <malloc+0x2348>
    52b8:	00001097          	auipc	ra,0x1
    52bc:	8f2080e7          	jalr	-1806(ra) # 5baa <printf>
      exit(1);
    52c0:	4505                	li	a0,1
    52c2:	00000097          	auipc	ra,0x0
    52c6:	570080e7          	jalr	1392(ra) # 5832 <exit>
  }

  close(fds[0]);
    52ca:	fc842503          	lw	a0,-56(s0)
    52ce:	00000097          	auipc	ra,0x0
    52d2:	58c080e7          	jalr	1420(ra) # 585a <close>
  wait((int *)0);
    52d6:	4501                	li	a0,0
    52d8:	00000097          	auipc	ra,0x0
    52dc:	562080e7          	jalr	1378(ra) # 583a <wait>

  return n;
}
    52e0:	8526                	mv	a0,s1
    52e2:	70e2                	ld	ra,56(sp)
    52e4:	7442                	ld	s0,48(sp)
    52e6:	74a2                	ld	s1,40(sp)
    52e8:	7902                	ld	s2,32(sp)
    52ea:	69e2                	ld	s3,24(sp)
    52ec:	6121                	addi	sp,sp,64
    52ee:	8082                	ret

00000000000052f0 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s)
{
    52f0:	7179                	addi	sp,sp,-48
    52f2:	f406                	sd	ra,40(sp)
    52f4:	f022                	sd	s0,32(sp)
    52f6:	ec26                	sd	s1,24(sp)
    52f8:	e84a                	sd	s2,16(sp)
    52fa:	1800                	addi	s0,sp,48
    52fc:	84aa                	mv	s1,a0
    52fe:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5300:	00003517          	auipc	a0,0x3
    5304:	cd050513          	addi	a0,a0,-816 # 7fd0 <malloc+0x2368>
    5308:	00001097          	auipc	ra,0x1
    530c:	8a2080e7          	jalr	-1886(ra) # 5baa <printf>
  if ((pid = fork()) < 0)
    5310:	00000097          	auipc	ra,0x0
    5314:	51a080e7          	jalr	1306(ra) # 582a <fork>
    5318:	02054e63          	bltz	a0,5354 <run+0x64>
  {
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0)
    531c:	c929                	beqz	a0,536e <run+0x7e>
    f(s);
    exit(0);
  }
  else
  {
    wait(&xstatus);
    531e:	fdc40513          	addi	a0,s0,-36
    5322:	00000097          	auipc	ra,0x0
    5326:	518080e7          	jalr	1304(ra) # 583a <wait>
    if (xstatus != 0)
    532a:	fdc42783          	lw	a5,-36(s0)
    532e:	c7b9                	beqz	a5,537c <run+0x8c>
      printf("FAILED\n");
    5330:	00003517          	auipc	a0,0x3
    5334:	cc850513          	addi	a0,a0,-824 # 7ff8 <malloc+0x2390>
    5338:	00001097          	auipc	ra,0x1
    533c:	872080e7          	jalr	-1934(ra) # 5baa <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5340:	fdc42503          	lw	a0,-36(s0)
  }
}
    5344:	00153513          	seqz	a0,a0
    5348:	70a2                	ld	ra,40(sp)
    534a:	7402                	ld	s0,32(sp)
    534c:	64e2                	ld	s1,24(sp)
    534e:	6942                	ld	s2,16(sp)
    5350:	6145                	addi	sp,sp,48
    5352:	8082                	ret
    printf("runtest: fork error\n");
    5354:	00003517          	auipc	a0,0x3
    5358:	c8c50513          	addi	a0,a0,-884 # 7fe0 <malloc+0x2378>
    535c:	00001097          	auipc	ra,0x1
    5360:	84e080e7          	jalr	-1970(ra) # 5baa <printf>
    exit(1);
    5364:	4505                	li	a0,1
    5366:	00000097          	auipc	ra,0x0
    536a:	4cc080e7          	jalr	1228(ra) # 5832 <exit>
    f(s);
    536e:	854a                	mv	a0,s2
    5370:	9482                	jalr	s1
    exit(0);
    5372:	4501                	li	a0,0
    5374:	00000097          	auipc	ra,0x0
    5378:	4be080e7          	jalr	1214(ra) # 5832 <exit>
      printf("OK\n");
    537c:	00003517          	auipc	a0,0x3
    5380:	c8450513          	addi	a0,a0,-892 # 8000 <malloc+0x2398>
    5384:	00001097          	auipc	ra,0x1
    5388:	826080e7          	jalr	-2010(ra) # 5baa <printf>
    538c:	bf55                	j	5340 <run+0x50>

000000000000538e <main>:

int main(int argc, char *argv[])
{
    538e:	c0010113          	addi	sp,sp,-1024
    5392:	3e113c23          	sd	ra,1016(sp)
    5396:	3e813823          	sd	s0,1008(sp)
    539a:	3e913423          	sd	s1,1000(sp)
    539e:	3f213023          	sd	s2,992(sp)
    53a2:	3d313c23          	sd	s3,984(sp)
    53a6:	3d413823          	sd	s4,976(sp)
    53aa:	3d513423          	sd	s5,968(sp)
    53ae:	3d613023          	sd	s6,960(sp)
    53b2:	40010413          	addi	s0,sp,1024
    53b6:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-c") == 0)
    53b8:	4789                	li	a5,2
    53ba:	08f50763          	beq	a0,a5,5448 <main+0xba>
  }
  else if (argc == 2 && argv[1][0] != '-')
  {
    justone = argv[1];
  }
  else if (argc > 1)
    53be:	4785                	li	a5,1
  char *justone = 0;
    53c0:	4901                	li	s2,0
  else if (argc > 1)
    53c2:	0ca7c163          	blt	a5,a0,5484 <main+0xf6>

  struct test
  {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53c6:	00003797          	auipc	a5,0x3
    53ca:	d5278793          	addi	a5,a5,-686 # 8118 <malloc+0x24b0>
    53ce:	c0040713          	addi	a4,s0,-1024
    53d2:	00003817          	auipc	a6,0x3
    53d6:	10680813          	addi	a6,a6,262 # 84d8 <malloc+0x2870>
    53da:	6388                	ld	a0,0(a5)
    53dc:	678c                	ld	a1,8(a5)
    53de:	6b90                	ld	a2,16(a5)
    53e0:	6f94                	ld	a3,24(a5)
    53e2:	e308                	sd	a0,0(a4)
    53e4:	e70c                	sd	a1,8(a4)
    53e6:	eb10                	sd	a2,16(a4)
    53e8:	ef14                	sd	a3,24(a4)
    53ea:	02078793          	addi	a5,a5,32
    53ee:	02070713          	addi	a4,a4,32
    53f2:	ff0794e3          	bne	a5,a6,53da <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    53f6:	00003517          	auipc	a0,0x3
    53fa:	cc250513          	addi	a0,a0,-830 # 80b8 <malloc+0x2450>
    53fe:	00000097          	auipc	ra,0x0
    5402:	7ac080e7          	jalr	1964(ra) # 5baa <printf>
  int free0 = countfree();
    5406:	00000097          	auipc	ra,0x0
    540a:	db8080e7          	jalr	-584(ra) # 51be <countfree>
    540e:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++)
    5410:	c0843503          	ld	a0,-1016(s0)
    5414:	c0040493          	addi	s1,s0,-1024
  int fail = 0;
    5418:	4981                	li	s3,0
  {
    if ((justone == 0) || strcmp(t->s, justone) == 0)
    {
      if (!run(t->f, t->s))
        fail = 1;
    541a:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++)
    541c:	e55d                	bnez	a0,54ca <main+0x13c>
  if (fail)
  {
    printf("SOME TESTS FAILED\n");
    exit(1);
  }
  else if ((free1 = countfree()) < free0)
    541e:	00000097          	auipc	ra,0x0
    5422:	da0080e7          	jalr	-608(ra) # 51be <countfree>
    5426:	85aa                	mv	a1,a0
    5428:	0f455163          	bge	a0,s4,550a <main+0x17c>
  {
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    542c:	8652                	mv	a2,s4
    542e:	00003517          	auipc	a0,0x3
    5432:	c4250513          	addi	a0,a0,-958 # 8070 <malloc+0x2408>
    5436:	00000097          	auipc	ra,0x0
    543a:	774080e7          	jalr	1908(ra) # 5baa <printf>
    exit(1);
    543e:	4505                	li	a0,1
    5440:	00000097          	auipc	ra,0x0
    5444:	3f2080e7          	jalr	1010(ra) # 5832 <exit>
    5448:	84ae                	mv	s1,a1
  if (argc == 2 && strcmp(argv[1], "-c") == 0)
    544a:	00003597          	auipc	a1,0x3
    544e:	bbe58593          	addi	a1,a1,-1090 # 8008 <malloc+0x23a0>
    5452:	6488                	ld	a0,8(s1)
    5454:	00000097          	auipc	ra,0x0
    5458:	184080e7          	jalr	388(ra) # 55d8 <strcmp>
    545c:	10050563          	beqz	a0,5566 <main+0x1d8>
  else if (argc == 2 && strcmp(argv[1], "-C") == 0)
    5460:	00003597          	auipc	a1,0x3
    5464:	c9058593          	addi	a1,a1,-880 # 80f0 <malloc+0x2488>
    5468:	6488                	ld	a0,8(s1)
    546a:	00000097          	auipc	ra,0x0
    546e:	16e080e7          	jalr	366(ra) # 55d8 <strcmp>
    5472:	c97d                	beqz	a0,5568 <main+0x1da>
  else if (argc == 2 && argv[1][0] != '-')
    5474:	0084b903          	ld	s2,8(s1)
    5478:	00094703          	lbu	a4,0(s2)
    547c:	02d00793          	li	a5,45
    5480:	f4f713e3          	bne	a4,a5,53c6 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    5484:	00003517          	auipc	a0,0x3
    5488:	b8c50513          	addi	a0,a0,-1140 # 8010 <malloc+0x23a8>
    548c:	00000097          	auipc	ra,0x0
    5490:	71e080e7          	jalr	1822(ra) # 5baa <printf>
    exit(1);
    5494:	4505                	li	a0,1
    5496:	00000097          	auipc	ra,0x0
    549a:	39c080e7          	jalr	924(ra) # 5832 <exit>
          exit(1);
    549e:	4505                	li	a0,1
    54a0:	00000097          	auipc	ra,0x0
    54a4:	392080e7          	jalr	914(ra) # 5832 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54a8:	40a905bb          	subw	a1,s2,a0
    54ac:	855a                	mv	a0,s6
    54ae:	00000097          	auipc	ra,0x0
    54b2:	6fc080e7          	jalr	1788(ra) # 5baa <printf>
        if (continuous != 2)
    54b6:	09498463          	beq	s3,s4,553e <main+0x1b0>
          exit(1);
    54ba:	4505                	li	a0,1
    54bc:	00000097          	auipc	ra,0x0
    54c0:	376080e7          	jalr	886(ra) # 5832 <exit>
  for (struct test *t = tests; t->s != 0; t++)
    54c4:	04c1                	addi	s1,s1,16
    54c6:	6488                	ld	a0,8(s1)
    54c8:	c115                	beqz	a0,54ec <main+0x15e>
    if ((justone == 0) || strcmp(t->s, justone) == 0)
    54ca:	00090863          	beqz	s2,54da <main+0x14c>
    54ce:	85ca                	mv	a1,s2
    54d0:	00000097          	auipc	ra,0x0
    54d4:	108080e7          	jalr	264(ra) # 55d8 <strcmp>
    54d8:	f575                	bnez	a0,54c4 <main+0x136>
      if (!run(t->f, t->s))
    54da:	648c                	ld	a1,8(s1)
    54dc:	6088                	ld	a0,0(s1)
    54de:	00000097          	auipc	ra,0x0
    54e2:	e12080e7          	jalr	-494(ra) # 52f0 <run>
    54e6:	fd79                	bnez	a0,54c4 <main+0x136>
        fail = 1;
    54e8:	89d6                	mv	s3,s5
    54ea:	bfe9                	j	54c4 <main+0x136>
  if (fail)
    54ec:	f20989e3          	beqz	s3,541e <main+0x90>
    printf("SOME TESTS FAILED\n");
    54f0:	00003517          	auipc	a0,0x3
    54f4:	b6850513          	addi	a0,a0,-1176 # 8058 <malloc+0x23f0>
    54f8:	00000097          	auipc	ra,0x0
    54fc:	6b2080e7          	jalr	1714(ra) # 5baa <printf>
    exit(1);
    5500:	4505                	li	a0,1
    5502:	00000097          	auipc	ra,0x0
    5506:	330080e7          	jalr	816(ra) # 5832 <exit>
  }
  else
  {
    printf("ALL TESTS PASSED\n");
    550a:	00003517          	auipc	a0,0x3
    550e:	b9650513          	addi	a0,a0,-1130 # 80a0 <malloc+0x2438>
    5512:	00000097          	auipc	ra,0x0
    5516:	698080e7          	jalr	1688(ra) # 5baa <printf>
    exit(0);
    551a:	4501                	li	a0,0
    551c:	00000097          	auipc	ra,0x0
    5520:	316080e7          	jalr	790(ra) # 5832 <exit>
        printf("SOME TESTS FAILED\n");
    5524:	8556                	mv	a0,s5
    5526:	00000097          	auipc	ra,0x0
    552a:	684080e7          	jalr	1668(ra) # 5baa <printf>
        if (continuous != 2)
    552e:	f74998e3          	bne	s3,s4,549e <main+0x110>
      int free1 = countfree();
    5532:	00000097          	auipc	ra,0x0
    5536:	c8c080e7          	jalr	-884(ra) # 51be <countfree>
      if (free1 < free0)
    553a:	f72547e3          	blt	a0,s2,54a8 <main+0x11a>
      int free0 = countfree();
    553e:	00000097          	auipc	ra,0x0
    5542:	c80080e7          	jalr	-896(ra) # 51be <countfree>
    5546:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++)
    5548:	c0843583          	ld	a1,-1016(s0)
    554c:	d1fd                	beqz	a1,5532 <main+0x1a4>
    554e:	c0040493          	addi	s1,s0,-1024
        if (!run(t->f, t->s))
    5552:	6088                	ld	a0,0(s1)
    5554:	00000097          	auipc	ra,0x0
    5558:	d9c080e7          	jalr	-612(ra) # 52f0 <run>
    555c:	d561                	beqz	a0,5524 <main+0x196>
      for (struct test *t = tests; t->s != 0; t++)
    555e:	04c1                	addi	s1,s1,16
    5560:	648c                	ld	a1,8(s1)
    5562:	f9e5                	bnez	a1,5552 <main+0x1c4>
    5564:	b7f9                	j	5532 <main+0x1a4>
    continuous = 1;
    5566:	4985                	li	s3,1
  } tests[] = {
    5568:	00003797          	auipc	a5,0x3
    556c:	bb078793          	addi	a5,a5,-1104 # 8118 <malloc+0x24b0>
    5570:	c0040713          	addi	a4,s0,-1024
    5574:	00003817          	auipc	a6,0x3
    5578:	f6480813          	addi	a6,a6,-156 # 84d8 <malloc+0x2870>
    557c:	6388                	ld	a0,0(a5)
    557e:	678c                	ld	a1,8(a5)
    5580:	6b90                	ld	a2,16(a5)
    5582:	6f94                	ld	a3,24(a5)
    5584:	e308                	sd	a0,0(a4)
    5586:	e70c                	sd	a1,8(a4)
    5588:	eb10                	sd	a2,16(a4)
    558a:	ef14                	sd	a3,24(a4)
    558c:	02078793          	addi	a5,a5,32
    5590:	02070713          	addi	a4,a4,32
    5594:	ff0794e3          	bne	a5,a6,557c <main+0x1ee>
    printf("continuous usertests starting\n");
    5598:	00003517          	auipc	a0,0x3
    559c:	b3850513          	addi	a0,a0,-1224 # 80d0 <malloc+0x2468>
    55a0:	00000097          	auipc	ra,0x0
    55a4:	60a080e7          	jalr	1546(ra) # 5baa <printf>
        printf("SOME TESTS FAILED\n");
    55a8:	00003a97          	auipc	s5,0x3
    55ac:	ab0a8a93          	addi	s5,s5,-1360 # 8058 <malloc+0x23f0>
        if (continuous != 2)
    55b0:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55b2:	00003b17          	auipc	s6,0x3
    55b6:	a86b0b13          	addi	s6,s6,-1402 # 8038 <malloc+0x23d0>
    55ba:	b751                	j	553e <main+0x1b0>

00000000000055bc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    55bc:	1141                	addi	sp,sp,-16
    55be:	e422                	sd	s0,8(sp)
    55c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    55c2:	87aa                	mv	a5,a0
    55c4:	0585                	addi	a1,a1,1
    55c6:	0785                	addi	a5,a5,1
    55c8:	fff5c703          	lbu	a4,-1(a1)
    55cc:	fee78fa3          	sb	a4,-1(a5)
    55d0:	fb75                	bnez	a4,55c4 <strcpy+0x8>
    ;
  return os;
}
    55d2:	6422                	ld	s0,8(sp)
    55d4:	0141                	addi	sp,sp,16
    55d6:	8082                	ret

00000000000055d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    55d8:	1141                	addi	sp,sp,-16
    55da:	e422                	sd	s0,8(sp)
    55dc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    55de:	00054783          	lbu	a5,0(a0)
    55e2:	cb91                	beqz	a5,55f6 <strcmp+0x1e>
    55e4:	0005c703          	lbu	a4,0(a1)
    55e8:	00f71763          	bne	a4,a5,55f6 <strcmp+0x1e>
    p++, q++;
    55ec:	0505                	addi	a0,a0,1
    55ee:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    55f0:	00054783          	lbu	a5,0(a0)
    55f4:	fbe5                	bnez	a5,55e4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    55f6:	0005c503          	lbu	a0,0(a1)
}
    55fa:	40a7853b          	subw	a0,a5,a0
    55fe:	6422                	ld	s0,8(sp)
    5600:	0141                	addi	sp,sp,16
    5602:	8082                	ret

0000000000005604 <strlen>:

uint
strlen(const char *s)
{
    5604:	1141                	addi	sp,sp,-16
    5606:	e422                	sd	s0,8(sp)
    5608:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    560a:	00054783          	lbu	a5,0(a0)
    560e:	cf91                	beqz	a5,562a <strlen+0x26>
    5610:	0505                	addi	a0,a0,1
    5612:	87aa                	mv	a5,a0
    5614:	4685                	li	a3,1
    5616:	9e89                	subw	a3,a3,a0
    5618:	00f6853b          	addw	a0,a3,a5
    561c:	0785                	addi	a5,a5,1
    561e:	fff7c703          	lbu	a4,-1(a5)
    5622:	fb7d                	bnez	a4,5618 <strlen+0x14>
    ;
  return n;
}
    5624:	6422                	ld	s0,8(sp)
    5626:	0141                	addi	sp,sp,16
    5628:	8082                	ret
  for(n = 0; s[n]; n++)
    562a:	4501                	li	a0,0
    562c:	bfe5                	j	5624 <strlen+0x20>

000000000000562e <memset>:

void*
memset(void *dst, int c, uint n)
{
    562e:	1141                	addi	sp,sp,-16
    5630:	e422                	sd	s0,8(sp)
    5632:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5634:	ce09                	beqz	a2,564e <memset+0x20>
    5636:	87aa                	mv	a5,a0
    5638:	fff6071b          	addiw	a4,a2,-1
    563c:	1702                	slli	a4,a4,0x20
    563e:	9301                	srli	a4,a4,0x20
    5640:	0705                	addi	a4,a4,1
    5642:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5644:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5648:	0785                	addi	a5,a5,1
    564a:	fee79de3          	bne	a5,a4,5644 <memset+0x16>
  }
  return dst;
}
    564e:	6422                	ld	s0,8(sp)
    5650:	0141                	addi	sp,sp,16
    5652:	8082                	ret

0000000000005654 <strchr>:

char*
strchr(const char *s, char c)
{
    5654:	1141                	addi	sp,sp,-16
    5656:	e422                	sd	s0,8(sp)
    5658:	0800                	addi	s0,sp,16
  for(; *s; s++)
    565a:	00054783          	lbu	a5,0(a0)
    565e:	cb99                	beqz	a5,5674 <strchr+0x20>
    if(*s == c)
    5660:	00f58763          	beq	a1,a5,566e <strchr+0x1a>
  for(; *s; s++)
    5664:	0505                	addi	a0,a0,1
    5666:	00054783          	lbu	a5,0(a0)
    566a:	fbfd                	bnez	a5,5660 <strchr+0xc>
      return (char*)s;
  return 0;
    566c:	4501                	li	a0,0
}
    566e:	6422                	ld	s0,8(sp)
    5670:	0141                	addi	sp,sp,16
    5672:	8082                	ret
  return 0;
    5674:	4501                	li	a0,0
    5676:	bfe5                	j	566e <strchr+0x1a>

0000000000005678 <gets>:

char*
gets(char *buf, int max)
{
    5678:	711d                	addi	sp,sp,-96
    567a:	ec86                	sd	ra,88(sp)
    567c:	e8a2                	sd	s0,80(sp)
    567e:	e4a6                	sd	s1,72(sp)
    5680:	e0ca                	sd	s2,64(sp)
    5682:	fc4e                	sd	s3,56(sp)
    5684:	f852                	sd	s4,48(sp)
    5686:	f456                	sd	s5,40(sp)
    5688:	f05a                	sd	s6,32(sp)
    568a:	ec5e                	sd	s7,24(sp)
    568c:	1080                	addi	s0,sp,96
    568e:	8baa                	mv	s7,a0
    5690:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5692:	892a                	mv	s2,a0
    5694:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5696:	4aa9                	li	s5,10
    5698:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    569a:	89a6                	mv	s3,s1
    569c:	2485                	addiw	s1,s1,1
    569e:	0344d863          	bge	s1,s4,56ce <gets+0x56>
    cc = read(0, &c, 1);
    56a2:	4605                	li	a2,1
    56a4:	faf40593          	addi	a1,s0,-81
    56a8:	4501                	li	a0,0
    56aa:	00000097          	auipc	ra,0x0
    56ae:	1a0080e7          	jalr	416(ra) # 584a <read>
    if(cc < 1)
    56b2:	00a05e63          	blez	a0,56ce <gets+0x56>
    buf[i++] = c;
    56b6:	faf44783          	lbu	a5,-81(s0)
    56ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    56be:	01578763          	beq	a5,s5,56cc <gets+0x54>
    56c2:	0905                	addi	s2,s2,1
    56c4:	fd679be3          	bne	a5,s6,569a <gets+0x22>
  for(i=0; i+1 < max; ){
    56c8:	89a6                	mv	s3,s1
    56ca:	a011                	j	56ce <gets+0x56>
    56cc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    56ce:	99de                	add	s3,s3,s7
    56d0:	00098023          	sb	zero,0(s3)
  return buf;
}
    56d4:	855e                	mv	a0,s7
    56d6:	60e6                	ld	ra,88(sp)
    56d8:	6446                	ld	s0,80(sp)
    56da:	64a6                	ld	s1,72(sp)
    56dc:	6906                	ld	s2,64(sp)
    56de:	79e2                	ld	s3,56(sp)
    56e0:	7a42                	ld	s4,48(sp)
    56e2:	7aa2                	ld	s5,40(sp)
    56e4:	7b02                	ld	s6,32(sp)
    56e6:	6be2                	ld	s7,24(sp)
    56e8:	6125                	addi	sp,sp,96
    56ea:	8082                	ret

00000000000056ec <stat>:

int
stat(const char *n, struct stat *st)
{
    56ec:	1101                	addi	sp,sp,-32
    56ee:	ec06                	sd	ra,24(sp)
    56f0:	e822                	sd	s0,16(sp)
    56f2:	e426                	sd	s1,8(sp)
    56f4:	e04a                	sd	s2,0(sp)
    56f6:	1000                	addi	s0,sp,32
    56f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    56fa:	4581                	li	a1,0
    56fc:	00000097          	auipc	ra,0x0
    5700:	176080e7          	jalr	374(ra) # 5872 <open>
  if(fd < 0)
    5704:	02054563          	bltz	a0,572e <stat+0x42>
    5708:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    570a:	85ca                	mv	a1,s2
    570c:	00000097          	auipc	ra,0x0
    5710:	17e080e7          	jalr	382(ra) # 588a <fstat>
    5714:	892a                	mv	s2,a0
  close(fd);
    5716:	8526                	mv	a0,s1
    5718:	00000097          	auipc	ra,0x0
    571c:	142080e7          	jalr	322(ra) # 585a <close>
  return r;
}
    5720:	854a                	mv	a0,s2
    5722:	60e2                	ld	ra,24(sp)
    5724:	6442                	ld	s0,16(sp)
    5726:	64a2                	ld	s1,8(sp)
    5728:	6902                	ld	s2,0(sp)
    572a:	6105                	addi	sp,sp,32
    572c:	8082                	ret
    return -1;
    572e:	597d                	li	s2,-1
    5730:	bfc5                	j	5720 <stat+0x34>

0000000000005732 <atoi>:

int
atoi(const char *s)
{
    5732:	1141                	addi	sp,sp,-16
    5734:	e422                	sd	s0,8(sp)
    5736:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5738:	00054603          	lbu	a2,0(a0)
    573c:	fd06079b          	addiw	a5,a2,-48
    5740:	0ff7f793          	andi	a5,a5,255
    5744:	4725                	li	a4,9
    5746:	02f76963          	bltu	a4,a5,5778 <atoi+0x46>
    574a:	86aa                	mv	a3,a0
  n = 0;
    574c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    574e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5750:	0685                	addi	a3,a3,1
    5752:	0025179b          	slliw	a5,a0,0x2
    5756:	9fa9                	addw	a5,a5,a0
    5758:	0017979b          	slliw	a5,a5,0x1
    575c:	9fb1                	addw	a5,a5,a2
    575e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5762:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x9e>
    5766:	fd06071b          	addiw	a4,a2,-48
    576a:	0ff77713          	andi	a4,a4,255
    576e:	fee5f1e3          	bgeu	a1,a4,5750 <atoi+0x1e>
  return n;
}
    5772:	6422                	ld	s0,8(sp)
    5774:	0141                	addi	sp,sp,16
    5776:	8082                	ret
  n = 0;
    5778:	4501                	li	a0,0
    577a:	bfe5                	j	5772 <atoi+0x40>

000000000000577c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    577c:	1141                	addi	sp,sp,-16
    577e:	e422                	sd	s0,8(sp)
    5780:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5782:	02b57663          	bgeu	a0,a1,57ae <memmove+0x32>
    while(n-- > 0)
    5786:	02c05163          	blez	a2,57a8 <memmove+0x2c>
    578a:	fff6079b          	addiw	a5,a2,-1
    578e:	1782                	slli	a5,a5,0x20
    5790:	9381                	srli	a5,a5,0x20
    5792:	0785                	addi	a5,a5,1
    5794:	97aa                	add	a5,a5,a0
  dst = vdst;
    5796:	872a                	mv	a4,a0
      *dst++ = *src++;
    5798:	0585                	addi	a1,a1,1
    579a:	0705                	addi	a4,a4,1
    579c:	fff5c683          	lbu	a3,-1(a1)
    57a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    57a4:	fee79ae3          	bne	a5,a4,5798 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    57a8:	6422                	ld	s0,8(sp)
    57aa:	0141                	addi	sp,sp,16
    57ac:	8082                	ret
    dst += n;
    57ae:	00c50733          	add	a4,a0,a2
    src += n;
    57b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    57b4:	fec05ae3          	blez	a2,57a8 <memmove+0x2c>
    57b8:	fff6079b          	addiw	a5,a2,-1
    57bc:	1782                	slli	a5,a5,0x20
    57be:	9381                	srli	a5,a5,0x20
    57c0:	fff7c793          	not	a5,a5
    57c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    57c6:	15fd                	addi	a1,a1,-1
    57c8:	177d                	addi	a4,a4,-1
    57ca:	0005c683          	lbu	a3,0(a1)
    57ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    57d2:	fee79ae3          	bne	a5,a4,57c6 <memmove+0x4a>
    57d6:	bfc9                	j	57a8 <memmove+0x2c>

00000000000057d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    57d8:	1141                	addi	sp,sp,-16
    57da:	e422                	sd	s0,8(sp)
    57dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    57de:	ca05                	beqz	a2,580e <memcmp+0x36>
    57e0:	fff6069b          	addiw	a3,a2,-1
    57e4:	1682                	slli	a3,a3,0x20
    57e6:	9281                	srli	a3,a3,0x20
    57e8:	0685                	addi	a3,a3,1
    57ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    57ec:	00054783          	lbu	a5,0(a0)
    57f0:	0005c703          	lbu	a4,0(a1)
    57f4:	00e79863          	bne	a5,a4,5804 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    57f8:	0505                	addi	a0,a0,1
    p2++;
    57fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    57fc:	fed518e3          	bne	a0,a3,57ec <memcmp+0x14>
  }
  return 0;
    5800:	4501                	li	a0,0
    5802:	a019                	j	5808 <memcmp+0x30>
      return *p1 - *p2;
    5804:	40e7853b          	subw	a0,a5,a4
}
    5808:	6422                	ld	s0,8(sp)
    580a:	0141                	addi	sp,sp,16
    580c:	8082                	ret
  return 0;
    580e:	4501                	li	a0,0
    5810:	bfe5                	j	5808 <memcmp+0x30>

0000000000005812 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5812:	1141                	addi	sp,sp,-16
    5814:	e406                	sd	ra,8(sp)
    5816:	e022                	sd	s0,0(sp)
    5818:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    581a:	00000097          	auipc	ra,0x0
    581e:	f62080e7          	jalr	-158(ra) # 577c <memmove>
}
    5822:	60a2                	ld	ra,8(sp)
    5824:	6402                	ld	s0,0(sp)
    5826:	0141                	addi	sp,sp,16
    5828:	8082                	ret

000000000000582a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    582a:	4885                	li	a7,1
 ecall
    582c:	00000073          	ecall
 ret
    5830:	8082                	ret

0000000000005832 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5832:	4889                	li	a7,2
 ecall
    5834:	00000073          	ecall
 ret
    5838:	8082                	ret

000000000000583a <wait>:
.global wait
wait:
 li a7, SYS_wait
    583a:	488d                	li	a7,3
 ecall
    583c:	00000073          	ecall
 ret
    5840:	8082                	ret

0000000000005842 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5842:	4891                	li	a7,4
 ecall
    5844:	00000073          	ecall
 ret
    5848:	8082                	ret

000000000000584a <read>:
.global read
read:
 li a7, SYS_read
    584a:	4895                	li	a7,5
 ecall
    584c:	00000073          	ecall
 ret
    5850:	8082                	ret

0000000000005852 <write>:
.global write
write:
 li a7, SYS_write
    5852:	48c1                	li	a7,16
 ecall
    5854:	00000073          	ecall
 ret
    5858:	8082                	ret

000000000000585a <close>:
.global close
close:
 li a7, SYS_close
    585a:	48d5                	li	a7,21
 ecall
    585c:	00000073          	ecall
 ret
    5860:	8082                	ret

0000000000005862 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5862:	4899                	li	a7,6
 ecall
    5864:	00000073          	ecall
 ret
    5868:	8082                	ret

000000000000586a <exec>:
.global exec
exec:
 li a7, SYS_exec
    586a:	489d                	li	a7,7
 ecall
    586c:	00000073          	ecall
 ret
    5870:	8082                	ret

0000000000005872 <open>:
.global open
open:
 li a7, SYS_open
    5872:	48bd                	li	a7,15
 ecall
    5874:	00000073          	ecall
 ret
    5878:	8082                	ret

000000000000587a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    587a:	48c5                	li	a7,17
 ecall
    587c:	00000073          	ecall
 ret
    5880:	8082                	ret

0000000000005882 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5882:	48c9                	li	a7,18
 ecall
    5884:	00000073          	ecall
 ret
    5888:	8082                	ret

000000000000588a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    588a:	48a1                	li	a7,8
 ecall
    588c:	00000073          	ecall
 ret
    5890:	8082                	ret

0000000000005892 <link>:
.global link
link:
 li a7, SYS_link
    5892:	48cd                	li	a7,19
 ecall
    5894:	00000073          	ecall
 ret
    5898:	8082                	ret

000000000000589a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    589a:	48d1                	li	a7,20
 ecall
    589c:	00000073          	ecall
 ret
    58a0:	8082                	ret

00000000000058a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    58a2:	48a5                	li	a7,9
 ecall
    58a4:	00000073          	ecall
 ret
    58a8:	8082                	ret

00000000000058aa <dup>:
.global dup
dup:
 li a7, SYS_dup
    58aa:	48a9                	li	a7,10
 ecall
    58ac:	00000073          	ecall
 ret
    58b0:	8082                	ret

00000000000058b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    58b2:	48ad                	li	a7,11
 ecall
    58b4:	00000073          	ecall
 ret
    58b8:	8082                	ret

00000000000058ba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    58ba:	48b1                	li	a7,12
 ecall
    58bc:	00000073          	ecall
 ret
    58c0:	8082                	ret

00000000000058c2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    58c2:	48b5                	li	a7,13
 ecall
    58c4:	00000073          	ecall
 ret
    58c8:	8082                	ret

00000000000058ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    58ca:	48b9                	li	a7,14
 ecall
    58cc:	00000073          	ecall
 ret
    58d0:	8082                	ret

00000000000058d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    58d2:	1101                	addi	sp,sp,-32
    58d4:	ec06                	sd	ra,24(sp)
    58d6:	e822                	sd	s0,16(sp)
    58d8:	1000                	addi	s0,sp,32
    58da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    58de:	4605                	li	a2,1
    58e0:	fef40593          	addi	a1,s0,-17
    58e4:	00000097          	auipc	ra,0x0
    58e8:	f6e080e7          	jalr	-146(ra) # 5852 <write>
}
    58ec:	60e2                	ld	ra,24(sp)
    58ee:	6442                	ld	s0,16(sp)
    58f0:	6105                	addi	sp,sp,32
    58f2:	8082                	ret

00000000000058f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    58f4:	7139                	addi	sp,sp,-64
    58f6:	fc06                	sd	ra,56(sp)
    58f8:	f822                	sd	s0,48(sp)
    58fa:	f426                	sd	s1,40(sp)
    58fc:	f04a                	sd	s2,32(sp)
    58fe:	ec4e                	sd	s3,24(sp)
    5900:	0080                	addi	s0,sp,64
    5902:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5904:	c299                	beqz	a3,590a <printint+0x16>
    5906:	0805c863          	bltz	a1,5996 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    590a:	2581                	sext.w	a1,a1
  neg = 0;
    590c:	4881                	li	a7,0
    590e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5912:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5914:	2601                	sext.w	a2,a2
    5916:	00003517          	auipc	a0,0x3
    591a:	bca50513          	addi	a0,a0,-1078 # 84e0 <digits>
    591e:	883a                	mv	a6,a4
    5920:	2705                	addiw	a4,a4,1
    5922:	02c5f7bb          	remuw	a5,a1,a2
    5926:	1782                	slli	a5,a5,0x20
    5928:	9381                	srli	a5,a5,0x20
    592a:	97aa                	add	a5,a5,a0
    592c:	0007c783          	lbu	a5,0(a5)
    5930:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5934:	0005879b          	sext.w	a5,a1
    5938:	02c5d5bb          	divuw	a1,a1,a2
    593c:	0685                	addi	a3,a3,1
    593e:	fec7f0e3          	bgeu	a5,a2,591e <printint+0x2a>
  if(neg)
    5942:	00088b63          	beqz	a7,5958 <printint+0x64>
    buf[i++] = '-';
    5946:	fd040793          	addi	a5,s0,-48
    594a:	973e                	add	a4,a4,a5
    594c:	02d00793          	li	a5,45
    5950:	fef70823          	sb	a5,-16(a4)
    5954:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5958:	02e05863          	blez	a4,5988 <printint+0x94>
    595c:	fc040793          	addi	a5,s0,-64
    5960:	00e78933          	add	s2,a5,a4
    5964:	fff78993          	addi	s3,a5,-1
    5968:	99ba                	add	s3,s3,a4
    596a:	377d                	addiw	a4,a4,-1
    596c:	1702                	slli	a4,a4,0x20
    596e:	9301                	srli	a4,a4,0x20
    5970:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5974:	fff94583          	lbu	a1,-1(s2)
    5978:	8526                	mv	a0,s1
    597a:	00000097          	auipc	ra,0x0
    597e:	f58080e7          	jalr	-168(ra) # 58d2 <putc>
  while(--i >= 0)
    5982:	197d                	addi	s2,s2,-1
    5984:	ff3918e3          	bne	s2,s3,5974 <printint+0x80>
}
    5988:	70e2                	ld	ra,56(sp)
    598a:	7442                	ld	s0,48(sp)
    598c:	74a2                	ld	s1,40(sp)
    598e:	7902                	ld	s2,32(sp)
    5990:	69e2                	ld	s3,24(sp)
    5992:	6121                	addi	sp,sp,64
    5994:	8082                	ret
    x = -xx;
    5996:	40b005bb          	negw	a1,a1
    neg = 1;
    599a:	4885                	li	a7,1
    x = -xx;
    599c:	bf8d                	j	590e <printint+0x1a>

000000000000599e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    599e:	7119                	addi	sp,sp,-128
    59a0:	fc86                	sd	ra,120(sp)
    59a2:	f8a2                	sd	s0,112(sp)
    59a4:	f4a6                	sd	s1,104(sp)
    59a6:	f0ca                	sd	s2,96(sp)
    59a8:	ecce                	sd	s3,88(sp)
    59aa:	e8d2                	sd	s4,80(sp)
    59ac:	e4d6                	sd	s5,72(sp)
    59ae:	e0da                	sd	s6,64(sp)
    59b0:	fc5e                	sd	s7,56(sp)
    59b2:	f862                	sd	s8,48(sp)
    59b4:	f466                	sd	s9,40(sp)
    59b6:	f06a                	sd	s10,32(sp)
    59b8:	ec6e                	sd	s11,24(sp)
    59ba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    59bc:	0005c903          	lbu	s2,0(a1)
    59c0:	18090f63          	beqz	s2,5b5e <vprintf+0x1c0>
    59c4:	8aaa                	mv	s5,a0
    59c6:	8b32                	mv	s6,a2
    59c8:	00158493          	addi	s1,a1,1
  state = 0;
    59cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    59ce:	02500a13          	li	s4,37
      if(c == 'd'){
    59d2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    59d6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    59da:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    59de:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    59e2:	00003b97          	auipc	s7,0x3
    59e6:	afeb8b93          	addi	s7,s7,-1282 # 84e0 <digits>
    59ea:	a839                	j	5a08 <vprintf+0x6a>
        putc(fd, c);
    59ec:	85ca                	mv	a1,s2
    59ee:	8556                	mv	a0,s5
    59f0:	00000097          	auipc	ra,0x0
    59f4:	ee2080e7          	jalr	-286(ra) # 58d2 <putc>
    59f8:	a019                	j	59fe <vprintf+0x60>
    } else if(state == '%'){
    59fa:	01498f63          	beq	s3,s4,5a18 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    59fe:	0485                	addi	s1,s1,1
    5a00:	fff4c903          	lbu	s2,-1(s1)
    5a04:	14090d63          	beqz	s2,5b5e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5a08:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5a0c:	fe0997e3          	bnez	s3,59fa <vprintf+0x5c>
      if(c == '%'){
    5a10:	fd479ee3          	bne	a5,s4,59ec <vprintf+0x4e>
        state = '%';
    5a14:	89be                	mv	s3,a5
    5a16:	b7e5                	j	59fe <vprintf+0x60>
      if(c == 'd'){
    5a18:	05878063          	beq	a5,s8,5a58 <vprintf+0xba>
      } else if(c == 'l') {
    5a1c:	05978c63          	beq	a5,s9,5a74 <vprintf+0xd6>
      } else if(c == 'x') {
    5a20:	07a78863          	beq	a5,s10,5a90 <vprintf+0xf2>
      } else if(c == 'p') {
    5a24:	09b78463          	beq	a5,s11,5aac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5a28:	07300713          	li	a4,115
    5a2c:	0ce78663          	beq	a5,a4,5af8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5a30:	06300713          	li	a4,99
    5a34:	0ee78e63          	beq	a5,a4,5b30 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5a38:	11478863          	beq	a5,s4,5b48 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5a3c:	85d2                	mv	a1,s4
    5a3e:	8556                	mv	a0,s5
    5a40:	00000097          	auipc	ra,0x0
    5a44:	e92080e7          	jalr	-366(ra) # 58d2 <putc>
        putc(fd, c);
    5a48:	85ca                	mv	a1,s2
    5a4a:	8556                	mv	a0,s5
    5a4c:	00000097          	auipc	ra,0x0
    5a50:	e86080e7          	jalr	-378(ra) # 58d2 <putc>
      }
      state = 0;
    5a54:	4981                	li	s3,0
    5a56:	b765                	j	59fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5a58:	008b0913          	addi	s2,s6,8
    5a5c:	4685                	li	a3,1
    5a5e:	4629                	li	a2,10
    5a60:	000b2583          	lw	a1,0(s6)
    5a64:	8556                	mv	a0,s5
    5a66:	00000097          	auipc	ra,0x0
    5a6a:	e8e080e7          	jalr	-370(ra) # 58f4 <printint>
    5a6e:	8b4a                	mv	s6,s2
      state = 0;
    5a70:	4981                	li	s3,0
    5a72:	b771                	j	59fe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a74:	008b0913          	addi	s2,s6,8
    5a78:	4681                	li	a3,0
    5a7a:	4629                	li	a2,10
    5a7c:	000b2583          	lw	a1,0(s6)
    5a80:	8556                	mv	a0,s5
    5a82:	00000097          	auipc	ra,0x0
    5a86:	e72080e7          	jalr	-398(ra) # 58f4 <printint>
    5a8a:	8b4a                	mv	s6,s2
      state = 0;
    5a8c:	4981                	li	s3,0
    5a8e:	bf85                	j	59fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5a90:	008b0913          	addi	s2,s6,8
    5a94:	4681                	li	a3,0
    5a96:	4641                	li	a2,16
    5a98:	000b2583          	lw	a1,0(s6)
    5a9c:	8556                	mv	a0,s5
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	e56080e7          	jalr	-426(ra) # 58f4 <printint>
    5aa6:	8b4a                	mv	s6,s2
      state = 0;
    5aa8:	4981                	li	s3,0
    5aaa:	bf91                	j	59fe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5aac:	008b0793          	addi	a5,s6,8
    5ab0:	f8f43423          	sd	a5,-120(s0)
    5ab4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5ab8:	03000593          	li	a1,48
    5abc:	8556                	mv	a0,s5
    5abe:	00000097          	auipc	ra,0x0
    5ac2:	e14080e7          	jalr	-492(ra) # 58d2 <putc>
  putc(fd, 'x');
    5ac6:	85ea                	mv	a1,s10
    5ac8:	8556                	mv	a0,s5
    5aca:	00000097          	auipc	ra,0x0
    5ace:	e08080e7          	jalr	-504(ra) # 58d2 <putc>
    5ad2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ad4:	03c9d793          	srli	a5,s3,0x3c
    5ad8:	97de                	add	a5,a5,s7
    5ada:	0007c583          	lbu	a1,0(a5)
    5ade:	8556                	mv	a0,s5
    5ae0:	00000097          	auipc	ra,0x0
    5ae4:	df2080e7          	jalr	-526(ra) # 58d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5ae8:	0992                	slli	s3,s3,0x4
    5aea:	397d                	addiw	s2,s2,-1
    5aec:	fe0914e3          	bnez	s2,5ad4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5af0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5af4:	4981                	li	s3,0
    5af6:	b721                	j	59fe <vprintf+0x60>
        s = va_arg(ap, char*);
    5af8:	008b0993          	addi	s3,s6,8
    5afc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5b00:	02090163          	beqz	s2,5b22 <vprintf+0x184>
        while(*s != 0){
    5b04:	00094583          	lbu	a1,0(s2)
    5b08:	c9a1                	beqz	a1,5b58 <vprintf+0x1ba>
          putc(fd, *s);
    5b0a:	8556                	mv	a0,s5
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	dc6080e7          	jalr	-570(ra) # 58d2 <putc>
          s++;
    5b14:	0905                	addi	s2,s2,1
        while(*s != 0){
    5b16:	00094583          	lbu	a1,0(s2)
    5b1a:	f9e5                	bnez	a1,5b0a <vprintf+0x16c>
        s = va_arg(ap, char*);
    5b1c:	8b4e                	mv	s6,s3
      state = 0;
    5b1e:	4981                	li	s3,0
    5b20:	bdf9                	j	59fe <vprintf+0x60>
          s = "(null)";
    5b22:	00003917          	auipc	s2,0x3
    5b26:	9b690913          	addi	s2,s2,-1610 # 84d8 <malloc+0x2870>
        while(*s != 0){
    5b2a:	02800593          	li	a1,40
    5b2e:	bff1                	j	5b0a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5b30:	008b0913          	addi	s2,s6,8
    5b34:	000b4583          	lbu	a1,0(s6)
    5b38:	8556                	mv	a0,s5
    5b3a:	00000097          	auipc	ra,0x0
    5b3e:	d98080e7          	jalr	-616(ra) # 58d2 <putc>
    5b42:	8b4a                	mv	s6,s2
      state = 0;
    5b44:	4981                	li	s3,0
    5b46:	bd65                	j	59fe <vprintf+0x60>
        putc(fd, c);
    5b48:	85d2                	mv	a1,s4
    5b4a:	8556                	mv	a0,s5
    5b4c:	00000097          	auipc	ra,0x0
    5b50:	d86080e7          	jalr	-634(ra) # 58d2 <putc>
      state = 0;
    5b54:	4981                	li	s3,0
    5b56:	b565                	j	59fe <vprintf+0x60>
        s = va_arg(ap, char*);
    5b58:	8b4e                	mv	s6,s3
      state = 0;
    5b5a:	4981                	li	s3,0
    5b5c:	b54d                	j	59fe <vprintf+0x60>
    }
  }
}
    5b5e:	70e6                	ld	ra,120(sp)
    5b60:	7446                	ld	s0,112(sp)
    5b62:	74a6                	ld	s1,104(sp)
    5b64:	7906                	ld	s2,96(sp)
    5b66:	69e6                	ld	s3,88(sp)
    5b68:	6a46                	ld	s4,80(sp)
    5b6a:	6aa6                	ld	s5,72(sp)
    5b6c:	6b06                	ld	s6,64(sp)
    5b6e:	7be2                	ld	s7,56(sp)
    5b70:	7c42                	ld	s8,48(sp)
    5b72:	7ca2                	ld	s9,40(sp)
    5b74:	7d02                	ld	s10,32(sp)
    5b76:	6de2                	ld	s11,24(sp)
    5b78:	6109                	addi	sp,sp,128
    5b7a:	8082                	ret

0000000000005b7c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5b7c:	715d                	addi	sp,sp,-80
    5b7e:	ec06                	sd	ra,24(sp)
    5b80:	e822                	sd	s0,16(sp)
    5b82:	1000                	addi	s0,sp,32
    5b84:	e010                	sd	a2,0(s0)
    5b86:	e414                	sd	a3,8(s0)
    5b88:	e818                	sd	a4,16(s0)
    5b8a:	ec1c                	sd	a5,24(s0)
    5b8c:	03043023          	sd	a6,32(s0)
    5b90:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5b94:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5b98:	8622                	mv	a2,s0
    5b9a:	00000097          	auipc	ra,0x0
    5b9e:	e04080e7          	jalr	-508(ra) # 599e <vprintf>
}
    5ba2:	60e2                	ld	ra,24(sp)
    5ba4:	6442                	ld	s0,16(sp)
    5ba6:	6161                	addi	sp,sp,80
    5ba8:	8082                	ret

0000000000005baa <printf>:

void
printf(const char *fmt, ...)
{
    5baa:	711d                	addi	sp,sp,-96
    5bac:	ec06                	sd	ra,24(sp)
    5bae:	e822                	sd	s0,16(sp)
    5bb0:	1000                	addi	s0,sp,32
    5bb2:	e40c                	sd	a1,8(s0)
    5bb4:	e810                	sd	a2,16(s0)
    5bb6:	ec14                	sd	a3,24(s0)
    5bb8:	f018                	sd	a4,32(s0)
    5bba:	f41c                	sd	a5,40(s0)
    5bbc:	03043823          	sd	a6,48(s0)
    5bc0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bc4:	00840613          	addi	a2,s0,8
    5bc8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5bcc:	85aa                	mv	a1,a0
    5bce:	4505                	li	a0,1
    5bd0:	00000097          	auipc	ra,0x0
    5bd4:	dce080e7          	jalr	-562(ra) # 599e <vprintf>
}
    5bd8:	60e2                	ld	ra,24(sp)
    5bda:	6442                	ld	s0,16(sp)
    5bdc:	6125                	addi	sp,sp,96
    5bde:	8082                	ret

0000000000005be0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5be0:	1141                	addi	sp,sp,-16
    5be2:	e422                	sd	s0,8(sp)
    5be4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5be6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5bea:	00003797          	auipc	a5,0x3
    5bee:	9167b783          	ld	a5,-1770(a5) # 8500 <freep>
    5bf2:	a805                	j	5c22 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5bf4:	4618                	lw	a4,8(a2)
    5bf6:	9db9                	addw	a1,a1,a4
    5bf8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5bfc:	6398                	ld	a4,0(a5)
    5bfe:	6318                	ld	a4,0(a4)
    5c00:	fee53823          	sd	a4,-16(a0)
    5c04:	a091                	j	5c48 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c06:	ff852703          	lw	a4,-8(a0)
    5c0a:	9e39                	addw	a2,a2,a4
    5c0c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5c0e:	ff053703          	ld	a4,-16(a0)
    5c12:	e398                	sd	a4,0(a5)
    5c14:	a099                	j	5c5a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c16:	6398                	ld	a4,0(a5)
    5c18:	00e7e463          	bltu	a5,a4,5c20 <free+0x40>
    5c1c:	00e6ea63          	bltu	a3,a4,5c30 <free+0x50>
{
    5c20:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c22:	fed7fae3          	bgeu	a5,a3,5c16 <free+0x36>
    5c26:	6398                	ld	a4,0(a5)
    5c28:	00e6e463          	bltu	a3,a4,5c30 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c2c:	fee7eae3          	bltu	a5,a4,5c20 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5c30:	ff852583          	lw	a1,-8(a0)
    5c34:	6390                	ld	a2,0(a5)
    5c36:	02059713          	slli	a4,a1,0x20
    5c3a:	9301                	srli	a4,a4,0x20
    5c3c:	0712                	slli	a4,a4,0x4
    5c3e:	9736                	add	a4,a4,a3
    5c40:	fae60ae3          	beq	a2,a4,5bf4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5c44:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5c48:	4790                	lw	a2,8(a5)
    5c4a:	02061713          	slli	a4,a2,0x20
    5c4e:	9301                	srli	a4,a4,0x20
    5c50:	0712                	slli	a4,a4,0x4
    5c52:	973e                	add	a4,a4,a5
    5c54:	fae689e3          	beq	a3,a4,5c06 <free+0x26>
  } else
    p->s.ptr = bp;
    5c58:	e394                	sd	a3,0(a5)
  freep = p;
    5c5a:	00003717          	auipc	a4,0x3
    5c5e:	8af73323          	sd	a5,-1882(a4) # 8500 <freep>
}
    5c62:	6422                	ld	s0,8(sp)
    5c64:	0141                	addi	sp,sp,16
    5c66:	8082                	ret

0000000000005c68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5c68:	7139                	addi	sp,sp,-64
    5c6a:	fc06                	sd	ra,56(sp)
    5c6c:	f822                	sd	s0,48(sp)
    5c6e:	f426                	sd	s1,40(sp)
    5c70:	f04a                	sd	s2,32(sp)
    5c72:	ec4e                	sd	s3,24(sp)
    5c74:	e852                	sd	s4,16(sp)
    5c76:	e456                	sd	s5,8(sp)
    5c78:	e05a                	sd	s6,0(sp)
    5c7a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5c7c:	02051493          	slli	s1,a0,0x20
    5c80:	9081                	srli	s1,s1,0x20
    5c82:	04bd                	addi	s1,s1,15
    5c84:	8091                	srli	s1,s1,0x4
    5c86:	0014899b          	addiw	s3,s1,1
    5c8a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5c8c:	00003517          	auipc	a0,0x3
    5c90:	87453503          	ld	a0,-1932(a0) # 8500 <freep>
    5c94:	c515                	beqz	a0,5cc0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5c96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5c98:	4798                	lw	a4,8(a5)
    5c9a:	02977f63          	bgeu	a4,s1,5cd8 <malloc+0x70>
    5c9e:	8a4e                	mv	s4,s3
    5ca0:	0009871b          	sext.w	a4,s3
    5ca4:	6685                	lui	a3,0x1
    5ca6:	00d77363          	bgeu	a4,a3,5cac <malloc+0x44>
    5caa:	6a05                	lui	s4,0x1
    5cac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5cb0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5cb4:	00003917          	auipc	s2,0x3
    5cb8:	84c90913          	addi	s2,s2,-1972 # 8500 <freep>
  if(p == (char*)-1)
    5cbc:	5afd                	li	s5,-1
    5cbe:	a88d                	j	5d30 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5cc0:	00009797          	auipc	a5,0x9
    5cc4:	06078793          	addi	a5,a5,96 # ed20 <base>
    5cc8:	00003717          	auipc	a4,0x3
    5ccc:	82f73c23          	sd	a5,-1992(a4) # 8500 <freep>
    5cd0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5cd2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5cd6:	b7e1                	j	5c9e <malloc+0x36>
      if(p->s.size == nunits)
    5cd8:	02e48b63          	beq	s1,a4,5d0e <malloc+0xa6>
        p->s.size -= nunits;
    5cdc:	4137073b          	subw	a4,a4,s3
    5ce0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5ce2:	1702                	slli	a4,a4,0x20
    5ce4:	9301                	srli	a4,a4,0x20
    5ce6:	0712                	slli	a4,a4,0x4
    5ce8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5cea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5cee:	00003717          	auipc	a4,0x3
    5cf2:	80a73923          	sd	a0,-2030(a4) # 8500 <freep>
      return (void*)(p + 1);
    5cf6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5cfa:	70e2                	ld	ra,56(sp)
    5cfc:	7442                	ld	s0,48(sp)
    5cfe:	74a2                	ld	s1,40(sp)
    5d00:	7902                	ld	s2,32(sp)
    5d02:	69e2                	ld	s3,24(sp)
    5d04:	6a42                	ld	s4,16(sp)
    5d06:	6aa2                	ld	s5,8(sp)
    5d08:	6b02                	ld	s6,0(sp)
    5d0a:	6121                	addi	sp,sp,64
    5d0c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d0e:	6398                	ld	a4,0(a5)
    5d10:	e118                	sd	a4,0(a0)
    5d12:	bff1                	j	5cee <malloc+0x86>
  hp->s.size = nu;
    5d14:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d18:	0541                	addi	a0,a0,16
    5d1a:	00000097          	auipc	ra,0x0
    5d1e:	ec6080e7          	jalr	-314(ra) # 5be0 <free>
  return freep;
    5d22:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d26:	d971                	beqz	a0,5cfa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d2a:	4798                	lw	a4,8(a5)
    5d2c:	fa9776e3          	bgeu	a4,s1,5cd8 <malloc+0x70>
    if(p == freep)
    5d30:	00093703          	ld	a4,0(s2)
    5d34:	853e                	mv	a0,a5
    5d36:	fef719e3          	bne	a4,a5,5d28 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5d3a:	8552                	mv	a0,s4
    5d3c:	00000097          	auipc	ra,0x0
    5d40:	b7e080e7          	jalr	-1154(ra) # 58ba <sbrk>
  if(p == (char*)-1)
    5d44:	fd5518e3          	bne	a0,s5,5d14 <malloc+0xac>
        return 0;
    5d48:	4501                	li	a0,0
    5d4a:	bf45                	j	5cfa <malloc+0x92>
