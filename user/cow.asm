
user/_cow:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
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
  12:	bea50513          	addi	a0,a0,-1046 # bf8 <malloc+0xe8>
  16:	00001097          	auipc	ra,0x1
  1a:	a3c080e7          	jalr	-1476(ra) # a52 <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x555080c>
  26:	00000097          	auipc	ra,0x0
  2a:	71c080e7          	jalr	1820(ra) # 742 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50463          	beq	a0,a5,98 <simpletest+0x98>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit();
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	6fc080e7          	jalr	1788(ra) # 73a <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	664080e7          	jalr	1636(ra) # 6b2 <fork>
  if(pid < 0){
  56:	06054163          	bltz	a0,b8 <simpletest+0xb8>
    printf("fork() failed\n");
    exit();
  }

  if(pid == 0)
  5a:	c93d                	beqz	a0,d0 <simpletest+0xd0>
    exit();

  wait();
  5c:	00000097          	auipc	ra,0x0
  60:	666080e7          	jalr	1638(ra) # 6c2 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  64:	faaab537          	lui	a0,0xfaaab
  68:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5d64>
  6c:	00000097          	auipc	ra,0x0
  70:	6d6080e7          	jalr	1750(ra) # 742 <sbrk>
  74:	57fd                	li	a5,-1
  76:	06f50163          	beq	a0,a5,d8 <simpletest+0xd8>
    printf("sbrk(-%d) failed\n", sz);
    exit();
  }

  printf("ok\n");
  7a:	00001517          	auipc	a0,0x1
  7e:	bce50513          	addi	a0,a0,-1074 # c48 <malloc+0x138>
  82:	00001097          	auipc	ra,0x1
  86:	9d0080e7          	jalr	-1584(ra) # a52 <printf>
}
  8a:	70a2                	ld	ra,40(sp)
  8c:	7402                	ld	s0,32(sp)
  8e:	64e2                	ld	s1,24(sp)
  90:	6942                	ld	s2,16(sp)
  92:	69a2                	ld	s3,8(sp)
  94:	6145                	addi	sp,sp,48
  96:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  98:	055555b7          	lui	a1,0x5555
  9c:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x555080c>
  a0:	00001517          	auipc	a0,0x1
  a4:	b6850513          	addi	a0,a0,-1176 # c08 <malloc+0xf8>
  a8:	00001097          	auipc	ra,0x1
  ac:	9aa080e7          	jalr	-1622(ra) # a52 <printf>
    exit();
  b0:	00000097          	auipc	ra,0x0
  b4:	60a080e7          	jalr	1546(ra) # 6ba <exit>
    printf("fork() failed\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	b6850513          	addi	a0,a0,-1176 # c20 <malloc+0x110>
  c0:	00001097          	auipc	ra,0x1
  c4:	992080e7          	jalr	-1646(ra) # a52 <printf>
    exit();
  c8:	00000097          	auipc	ra,0x0
  cc:	5f2080e7          	jalr	1522(ra) # 6ba <exit>
    exit();
  d0:	00000097          	auipc	ra,0x0
  d4:	5ea080e7          	jalr	1514(ra) # 6ba <exit>
    printf("sbrk(-%d) failed\n", sz);
  d8:	055555b7          	lui	a1,0x5555
  dc:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x555080c>
  e0:	00001517          	auipc	a0,0x1
  e4:	b5050513          	addi	a0,a0,-1200 # c30 <malloc+0x120>
  e8:	00001097          	auipc	ra,0x1
  ec:	96a080e7          	jalr	-1686(ra) # a52 <printf>
    exit();
  f0:	00000097          	auipc	ra,0x0
  f4:	5ca080e7          	jalr	1482(ra) # 6ba <exit>

00000000000000f8 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  f8:	7179                	addi	sp,sp,-48
  fa:	f406                	sd	ra,40(sp)
  fc:	f022                	sd	s0,32(sp)
  fe:	ec26                	sd	s1,24(sp)
 100:	e84a                	sd	s2,16(sp)
 102:	e44e                	sd	s3,8(sp)
 104:	e052                	sd	s4,0(sp)
 106:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 108:	00001517          	auipc	a0,0x1
 10c:	b4850513          	addi	a0,a0,-1208 # c50 <malloc+0x140>
 110:	00001097          	auipc	ra,0x1
 114:	942080e7          	jalr	-1726(ra) # a52 <printf>
  
  char *p = sbrk(sz);
 118:	02000537          	lui	a0,0x2000
 11c:	00000097          	auipc	ra,0x0
 120:	626080e7          	jalr	1574(ra) # 742 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 124:	57fd                	li	a5,-1
 126:	08f50663          	beq	a0,a5,1b2 <threetest+0xba>
 12a:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit();
  }

  pid1 = fork();
 12c:	00000097          	auipc	ra,0x0
 130:	586080e7          	jalr	1414(ra) # 6b2 <fork>
  if(pid1 < 0){
 134:	08054d63          	bltz	a0,1ce <threetest+0xd6>
    printf("fork failed\n");
    exit();
  }
  if(pid1 == 0){
 138:	c55d                	beqz	a0,1e6 <threetest+0xee>
      *(int*)q = 9999;
    }
    exit();
  }

  for(char *q = p; q < p + sz; q += 4096){
 13a:	020009b7          	lui	s3,0x2000
 13e:	99a6                	add	s3,s3,s1
 140:	8926                	mv	s2,s1
 142:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 144:	00000097          	auipc	ra,0x0
 148:	5f6080e7          	jalr	1526(ra) # 73a <getpid>
 14c:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x55512b8>
  for(char *q = p; q < p + sz; q += 4096){
 150:	9952                	add	s2,s2,s4
 152:	ff3919e3          	bne	s2,s3,144 <threetest+0x4c>
  }

  wait();
 156:	00000097          	auipc	ra,0x0
 15a:	56c080e7          	jalr	1388(ra) # 6c2 <wait>

  sleep(1);
 15e:	4505                	li	a0,1
 160:	00000097          	auipc	ra,0x0
 164:	5ea080e7          	jalr	1514(ra) # 74a <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 168:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 16a:	0004a903          	lw	s2,0(s1)
 16e:	00000097          	auipc	ra,0x0
 172:	5cc080e7          	jalr	1484(ra) # 73a <getpid>
 176:	10a91463          	bne	s2,a0,27e <threetest+0x186>
  for(char *q = p; q < p + sz; q += 4096){
 17a:	94d2                	add	s1,s1,s4
 17c:	ff3497e3          	bne	s1,s3,16a <threetest+0x72>
      printf("wrong content\n");
      exit();
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 180:	fe000537          	lui	a0,0xfe000
 184:	00000097          	auipc	ra,0x0
 188:	5be080e7          	jalr	1470(ra) # 742 <sbrk>
 18c:	57fd                	li	a5,-1
 18e:	10f50463          	beq	a0,a5,296 <threetest+0x19e>
    printf("sbrk(-%d) failed\n", sz);
    exit();
  }

  printf("ok\n");
 192:	00001517          	auipc	a0,0x1
 196:	ab650513          	addi	a0,a0,-1354 # c48 <malloc+0x138>
 19a:	00001097          	auipc	ra,0x1
 19e:	8b8080e7          	jalr	-1864(ra) # a52 <printf>
}
 1a2:	70a2                	ld	ra,40(sp)
 1a4:	7402                	ld	s0,32(sp)
 1a6:	64e2                	ld	s1,24(sp)
 1a8:	6942                	ld	s2,16(sp)
 1aa:	69a2                	ld	s3,8(sp)
 1ac:	6a02                	ld	s4,0(sp)
 1ae:	6145                	addi	sp,sp,48
 1b0:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1b2:	020005b7          	lui	a1,0x2000
 1b6:	00001517          	auipc	a0,0x1
 1ba:	a5250513          	addi	a0,a0,-1454 # c08 <malloc+0xf8>
 1be:	00001097          	auipc	ra,0x1
 1c2:	894080e7          	jalr	-1900(ra) # a52 <printf>
    exit();
 1c6:	00000097          	auipc	ra,0x0
 1ca:	4f4080e7          	jalr	1268(ra) # 6ba <exit>
    printf("fork failed\n");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	a8a50513          	addi	a0,a0,-1398 # c58 <malloc+0x148>
 1d6:	00001097          	auipc	ra,0x1
 1da:	87c080e7          	jalr	-1924(ra) # a52 <printf>
    exit();
 1de:	00000097          	auipc	ra,0x0
 1e2:	4dc080e7          	jalr	1244(ra) # 6ba <exit>
    pid2 = fork();
 1e6:	00000097          	auipc	ra,0x0
 1ea:	4cc080e7          	jalr	1228(ra) # 6b2 <fork>
    if(pid2 < 0){
 1ee:	04054163          	bltz	a0,230 <threetest+0x138>
    if(pid2 == 0){
 1f2:	e939                	bnez	a0,248 <threetest+0x150>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1f4:	0199a9b7          	lui	s3,0x199a
 1f8:	99a6                	add	s3,s3,s1
 1fa:	8926                	mv	s2,s1
 1fc:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 1fe:	00000097          	auipc	ra,0x0
 202:	53c080e7          	jalr	1340(ra) # 73a <getpid>
 206:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 20a:	9952                	add	s2,s2,s4
 20c:	ff2999e3          	bne	s3,s2,1fe <threetest+0x106>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 210:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 212:	0004a903          	lw	s2,0(s1)
 216:	00000097          	auipc	ra,0x0
 21a:	524080e7          	jalr	1316(ra) # 73a <getpid>
 21e:	04a91463          	bne	s2,a0,266 <threetest+0x16e>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 222:	94d2                	add	s1,s1,s4
 224:	fe9997e3          	bne	s3,s1,212 <threetest+0x11a>
      exit();
 228:	00000097          	auipc	ra,0x0
 22c:	492080e7          	jalr	1170(ra) # 6ba <exit>
      printf("fork failed");
 230:	00001517          	auipc	a0,0x1
 234:	a3850513          	addi	a0,a0,-1480 # c68 <malloc+0x158>
 238:	00001097          	auipc	ra,0x1
 23c:	81a080e7          	jalr	-2022(ra) # a52 <printf>
      exit();
 240:	00000097          	auipc	ra,0x0
 244:	47a080e7          	jalr	1146(ra) # 6ba <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 248:	01000737          	lui	a4,0x1000
 24c:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 24e:	6789                	lui	a5,0x2
 250:	70f7879b          	addiw	a5,a5,1807
    for(char *q = p; q < p + (sz/2); q += 4096){
 254:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 256:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 258:	94b6                	add	s1,s1,a3
 25a:	fee49ee3          	bne	s1,a4,256 <threetest+0x15e>
    exit();
 25e:	00000097          	auipc	ra,0x0
 262:	45c080e7          	jalr	1116(ra) # 6ba <exit>
          printf("wrong content\n");
 266:	00001517          	auipc	a0,0x1
 26a:	a1250513          	addi	a0,a0,-1518 # c78 <malloc+0x168>
 26e:	00000097          	auipc	ra,0x0
 272:	7e4080e7          	jalr	2020(ra) # a52 <printf>
          exit();
 276:	00000097          	auipc	ra,0x0
 27a:	444080e7          	jalr	1092(ra) # 6ba <exit>
      printf("wrong content\n");
 27e:	00001517          	auipc	a0,0x1
 282:	9fa50513          	addi	a0,a0,-1542 # c78 <malloc+0x168>
 286:	00000097          	auipc	ra,0x0
 28a:	7cc080e7          	jalr	1996(ra) # a52 <printf>
      exit();
 28e:	00000097          	auipc	ra,0x0
 292:	42c080e7          	jalr	1068(ra) # 6ba <exit>
    printf("sbrk(-%d) failed\n", sz);
 296:	020005b7          	lui	a1,0x2000
 29a:	00001517          	auipc	a0,0x1
 29e:	99650513          	addi	a0,a0,-1642 # c30 <malloc+0x120>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	7b0080e7          	jalr	1968(ra) # a52 <printf>
    exit();
 2aa:	00000097          	auipc	ra,0x0
 2ae:	410080e7          	jalr	1040(ra) # 6ba <exit>

00000000000002b2 <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2b2:	7139                	addi	sp,sp,-64
 2b4:	fc06                	sd	ra,56(sp)
 2b6:	f822                	sd	s0,48(sp)
 2b8:	f426                	sd	s1,40(sp)
 2ba:	f04a                	sd	s2,32(sp)
 2bc:	ec4e                	sd	s3,24(sp)
 2be:	0080                	addi	s0,sp,64
  int parent = getpid();
 2c0:	00000097          	auipc	ra,0x0
 2c4:	47a080e7          	jalr	1146(ra) # 73a <getpid>
 2c8:	89aa                	mv	s3,a0
  
  printf("file: ");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	9be50513          	addi	a0,a0,-1602 # c88 <malloc+0x178>
 2d2:	00000097          	auipc	ra,0x0
 2d6:	780080e7          	jalr	1920(ra) # a52 <printf>
  
  buf[0] = 99;
 2da:	06300793          	li	a5,99
 2de:	00002717          	auipc	a4,0x2
 2e2:	a4f70d23          	sb	a5,-1446(a4) # 1d38 <buf>

  for(int i = 0; i < 4; i++){
 2e6:	fc042623          	sw	zero,-52(s0)
    if(pipe(fds) != 0){
 2ea:	00001497          	auipc	s1,0x1
 2ee:	a3e48493          	addi	s1,s1,-1474 # d28 <fds>
  for(int i = 0; i < 4; i++){
 2f2:	490d                	li	s2,3
    if(pipe(fds) != 0){
 2f4:	8526                	mv	a0,s1
 2f6:	00000097          	auipc	ra,0x0
 2fa:	3d4080e7          	jalr	980(ra) # 6ca <pipe>
 2fe:	e159                	bnez	a0,384 <filetest+0xd2>
      printf("pipe() failed\n");
      exit();
    }
    int pid = fork();
 300:	00000097          	auipc	ra,0x0
 304:	3b2080e7          	jalr	946(ra) # 6b2 <fork>
    if(pid < 0){
 308:	08054a63          	bltz	a0,39c <filetest+0xea>
      printf("fork failed\n");
      exit();
    }
    if(pid == 0){
 30c:	c545                	beqz	a0,3b4 <filetest+0x102>
        kill(parent);
        exit();
      }
      exit();
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 30e:	4611                	li	a2,4
 310:	fcc40593          	addi	a1,s0,-52
 314:	40c8                	lw	a0,4(s1)
 316:	00000097          	auipc	ra,0x0
 31a:	3c4080e7          	jalr	964(ra) # 6da <write>
 31e:	4791                	li	a5,4
 320:	12f51263          	bne	a0,a5,444 <filetest+0x192>
  for(int i = 0; i < 4; i++){
 324:	fcc42783          	lw	a5,-52(s0)
 328:	2785                	addiw	a5,a5,1
 32a:	0007871b          	sext.w	a4,a5
 32e:	fcf42623          	sw	a5,-52(s0)
 332:	fce951e3          	bge	s2,a4,2f4 <filetest+0x42>
      exit();
    }
  }

  for(int i = 0; i < 4; i++)
    wait();
 336:	00000097          	auipc	ra,0x0
 33a:	38c080e7          	jalr	908(ra) # 6c2 <wait>
 33e:	00000097          	auipc	ra,0x0
 342:	384080e7          	jalr	900(ra) # 6c2 <wait>
 346:	00000097          	auipc	ra,0x0
 34a:	37c080e7          	jalr	892(ra) # 6c2 <wait>
 34e:	00000097          	auipc	ra,0x0
 352:	374080e7          	jalr	884(ra) # 6c2 <wait>

  if(buf[0] != 99){
 356:	00002717          	auipc	a4,0x2
 35a:	9e274703          	lbu	a4,-1566(a4) # 1d38 <buf>
 35e:	06300793          	li	a5,99
 362:	0ef71d63          	bne	a4,a5,45c <filetest+0x1aa>
    printf("child overwrote parent\n");
    exit();
  }

  printf("ok\n");
 366:	00001517          	auipc	a0,0x1
 36a:	8e250513          	addi	a0,a0,-1822 # c48 <malloc+0x138>
 36e:	00000097          	auipc	ra,0x0
 372:	6e4080e7          	jalr	1764(ra) # a52 <printf>
}
 376:	70e2                	ld	ra,56(sp)
 378:	7442                	ld	s0,48(sp)
 37a:	74a2                	ld	s1,40(sp)
 37c:	7902                	ld	s2,32(sp)
 37e:	69e2                	ld	s3,24(sp)
 380:	6121                	addi	sp,sp,64
 382:	8082                	ret
      printf("pipe() failed\n");
 384:	00001517          	auipc	a0,0x1
 388:	90c50513          	addi	a0,a0,-1780 # c90 <malloc+0x180>
 38c:	00000097          	auipc	ra,0x0
 390:	6c6080e7          	jalr	1734(ra) # a52 <printf>
      exit();
 394:	00000097          	auipc	ra,0x0
 398:	326080e7          	jalr	806(ra) # 6ba <exit>
      printf("fork failed\n");
 39c:	00001517          	auipc	a0,0x1
 3a0:	8bc50513          	addi	a0,a0,-1860 # c58 <malloc+0x148>
 3a4:	00000097          	auipc	ra,0x0
 3a8:	6ae080e7          	jalr	1710(ra) # a52 <printf>
      exit();
 3ac:	00000097          	auipc	ra,0x0
 3b0:	30e080e7          	jalr	782(ra) # 6ba <exit>
      sleep(1);
 3b4:	4505                	li	a0,1
 3b6:	00000097          	auipc	ra,0x0
 3ba:	394080e7          	jalr	916(ra) # 74a <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3be:	4611                	li	a2,4
 3c0:	00002597          	auipc	a1,0x2
 3c4:	97858593          	addi	a1,a1,-1672 # 1d38 <buf>
 3c8:	00001517          	auipc	a0,0x1
 3cc:	96052503          	lw	a0,-1696(a0) # d28 <fds>
 3d0:	00000097          	auipc	ra,0x0
 3d4:	302080e7          	jalr	770(ra) # 6d2 <read>
 3d8:	4791                	li	a5,4
 3da:	04f51063          	bne	a0,a5,41a <filetest+0x168>
      sleep(1);
 3de:	4505                	li	a0,1
 3e0:	00000097          	auipc	ra,0x0
 3e4:	36a080e7          	jalr	874(ra) # 74a <sleep>
      if(j != i){
 3e8:	fcc42703          	lw	a4,-52(s0)
 3ec:	00002797          	auipc	a5,0x2
 3f0:	94c7a783          	lw	a5,-1716(a5) # 1d38 <buf>
 3f4:	04f70463          	beq	a4,a5,43c <filetest+0x18a>
        printf("read the wrong value\n");
 3f8:	00001517          	auipc	a0,0x1
 3fc:	8b850513          	addi	a0,a0,-1864 # cb0 <malloc+0x1a0>
 400:	00000097          	auipc	ra,0x0
 404:	652080e7          	jalr	1618(ra) # a52 <printf>
        kill(parent);
 408:	854e                	mv	a0,s3
 40a:	00000097          	auipc	ra,0x0
 40e:	2e0080e7          	jalr	736(ra) # 6ea <kill>
        exit();
 412:	00000097          	auipc	ra,0x0
 416:	2a8080e7          	jalr	680(ra) # 6ba <exit>
        printf("read failed\n");
 41a:	00001517          	auipc	a0,0x1
 41e:	88650513          	addi	a0,a0,-1914 # ca0 <malloc+0x190>
 422:	00000097          	auipc	ra,0x0
 426:	630080e7          	jalr	1584(ra) # a52 <printf>
        kill(parent);
 42a:	854e                	mv	a0,s3
 42c:	00000097          	auipc	ra,0x0
 430:	2be080e7          	jalr	702(ra) # 6ea <kill>
        exit();
 434:	00000097          	auipc	ra,0x0
 438:	286080e7          	jalr	646(ra) # 6ba <exit>
      exit();
 43c:	00000097          	auipc	ra,0x0
 440:	27e080e7          	jalr	638(ra) # 6ba <exit>
      printf("write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	88450513          	addi	a0,a0,-1916 # cc8 <malloc+0x1b8>
 44c:	00000097          	auipc	ra,0x0
 450:	606080e7          	jalr	1542(ra) # a52 <printf>
      exit();
 454:	00000097          	auipc	ra,0x0
 458:	266080e7          	jalr	614(ra) # 6ba <exit>
    printf("child overwrote parent\n");
 45c:	00001517          	auipc	a0,0x1
 460:	87c50513          	addi	a0,a0,-1924 # cd8 <malloc+0x1c8>
 464:	00000097          	auipc	ra,0x0
 468:	5ee080e7          	jalr	1518(ra) # a52 <printf>
    exit();
 46c:	00000097          	auipc	ra,0x0
 470:	24e080e7          	jalr	590(ra) # 6ba <exit>

0000000000000474 <main>:

int
main(int argc, char *argv[])
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  simpletest();
 47c:	00000097          	auipc	ra,0x0
 480:	b84080e7          	jalr	-1148(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 484:	00000097          	auipc	ra,0x0
 488:	b7c080e7          	jalr	-1156(ra) # 0 <simpletest>

  threetest();
 48c:	00000097          	auipc	ra,0x0
 490:	c6c080e7          	jalr	-916(ra) # f8 <threetest>
  threetest();
 494:	00000097          	auipc	ra,0x0
 498:	c64080e7          	jalr	-924(ra) # f8 <threetest>
  threetest();
 49c:	00000097          	auipc	ra,0x0
 4a0:	c5c080e7          	jalr	-932(ra) # f8 <threetest>

  filetest();
 4a4:	00000097          	auipc	ra,0x0
 4a8:	e0e080e7          	jalr	-498(ra) # 2b2 <filetest>

  printf("ALL COW TESTS PASSED\n");
 4ac:	00001517          	auipc	a0,0x1
 4b0:	84450513          	addi	a0,a0,-1980 # cf0 <malloc+0x1e0>
 4b4:	00000097          	auipc	ra,0x0
 4b8:	59e080e7          	jalr	1438(ra) # a52 <printf>

  exit();
 4bc:	00000097          	auipc	ra,0x0
 4c0:	1fe080e7          	jalr	510(ra) # 6ba <exit>

00000000000004c4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ca:	87aa                	mv	a5,a0
 4cc:	0585                	addi	a1,a1,1
 4ce:	0785                	addi	a5,a5,1
 4d0:	fff5c703          	lbu	a4,-1(a1)
 4d4:	fee78fa3          	sb	a4,-1(a5)
 4d8:	fb75                	bnez	a4,4cc <strcpy+0x8>
    ;
  return os;
}
 4da:	6422                	ld	s0,8(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret

00000000000004e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e422                	sd	s0,8(sp)
 4e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4e6:	00054783          	lbu	a5,0(a0)
 4ea:	cb91                	beqz	a5,4fe <strcmp+0x1e>
 4ec:	0005c703          	lbu	a4,0(a1)
 4f0:	00f71763          	bne	a4,a5,4fe <strcmp+0x1e>
    p++, q++;
 4f4:	0505                	addi	a0,a0,1
 4f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4f8:	00054783          	lbu	a5,0(a0)
 4fc:	fbe5                	bnez	a5,4ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4fe:	0005c503          	lbu	a0,0(a1)
}
 502:	40a7853b          	subw	a0,a5,a0
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret

000000000000050c <strlen>:

uint
strlen(const char *s)
{
 50c:	1141                	addi	sp,sp,-16
 50e:	e422                	sd	s0,8(sp)
 510:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 512:	00054783          	lbu	a5,0(a0)
 516:	cf91                	beqz	a5,532 <strlen+0x26>
 518:	0505                	addi	a0,a0,1
 51a:	87aa                	mv	a5,a0
 51c:	4685                	li	a3,1
 51e:	9e89                	subw	a3,a3,a0
 520:	00f6853b          	addw	a0,a3,a5
 524:	0785                	addi	a5,a5,1
 526:	fff7c703          	lbu	a4,-1(a5)
 52a:	fb7d                	bnez	a4,520 <strlen+0x14>
    ;
  return n;
}
 52c:	6422                	ld	s0,8(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret
  for(n = 0; s[n]; n++)
 532:	4501                	li	a0,0
 534:	bfe5                	j	52c <strlen+0x20>

0000000000000536 <memset>:

void*
memset(void *dst, int c, uint n)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 53c:	ce09                	beqz	a2,556 <memset+0x20>
 53e:	87aa                	mv	a5,a0
 540:	fff6071b          	addiw	a4,a2,-1
 544:	1702                	slli	a4,a4,0x20
 546:	9301                	srli	a4,a4,0x20
 548:	0705                	addi	a4,a4,1
 54a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 54c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 550:	0785                	addi	a5,a5,1
 552:	fee79de3          	bne	a5,a4,54c <memset+0x16>
  }
  return dst;
}
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret

000000000000055c <strchr>:

char*
strchr(const char *s, char c)
{
 55c:	1141                	addi	sp,sp,-16
 55e:	e422                	sd	s0,8(sp)
 560:	0800                	addi	s0,sp,16
  for(; *s; s++)
 562:	00054783          	lbu	a5,0(a0)
 566:	cb99                	beqz	a5,57c <strchr+0x20>
    if(*s == c)
 568:	00f58763          	beq	a1,a5,576 <strchr+0x1a>
  for(; *s; s++)
 56c:	0505                	addi	a0,a0,1
 56e:	00054783          	lbu	a5,0(a0)
 572:	fbfd                	bnez	a5,568 <strchr+0xc>
      return (char*)s;
  return 0;
 574:	4501                	li	a0,0
}
 576:	6422                	ld	s0,8(sp)
 578:	0141                	addi	sp,sp,16
 57a:	8082                	ret
  return 0;
 57c:	4501                	li	a0,0
 57e:	bfe5                	j	576 <strchr+0x1a>

0000000000000580 <gets>:

char*
gets(char *buf, int max)
{
 580:	711d                	addi	sp,sp,-96
 582:	ec86                	sd	ra,88(sp)
 584:	e8a2                	sd	s0,80(sp)
 586:	e4a6                	sd	s1,72(sp)
 588:	e0ca                	sd	s2,64(sp)
 58a:	fc4e                	sd	s3,56(sp)
 58c:	f852                	sd	s4,48(sp)
 58e:	f456                	sd	s5,40(sp)
 590:	f05a                	sd	s6,32(sp)
 592:	ec5e                	sd	s7,24(sp)
 594:	1080                	addi	s0,sp,96
 596:	8baa                	mv	s7,a0
 598:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 59a:	892a                	mv	s2,a0
 59c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 59e:	4aa9                	li	s5,10
 5a0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5a2:	89a6                	mv	s3,s1
 5a4:	2485                	addiw	s1,s1,1
 5a6:	0344d863          	bge	s1,s4,5d6 <gets+0x56>
    cc = read(0, &c, 1);
 5aa:	4605                	li	a2,1
 5ac:	faf40593          	addi	a1,s0,-81
 5b0:	4501                	li	a0,0
 5b2:	00000097          	auipc	ra,0x0
 5b6:	120080e7          	jalr	288(ra) # 6d2 <read>
    if(cc < 1)
 5ba:	00a05e63          	blez	a0,5d6 <gets+0x56>
    buf[i++] = c;
 5be:	faf44783          	lbu	a5,-81(s0)
 5c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5c6:	01578763          	beq	a5,s5,5d4 <gets+0x54>
 5ca:	0905                	addi	s2,s2,1
 5cc:	fd679be3          	bne	a5,s6,5a2 <gets+0x22>
  for(i=0; i+1 < max; ){
 5d0:	89a6                	mv	s3,s1
 5d2:	a011                	j	5d6 <gets+0x56>
 5d4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5d6:	99de                	add	s3,s3,s7
 5d8:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x19952b8>
  return buf;
}
 5dc:	855e                	mv	a0,s7
 5de:	60e6                	ld	ra,88(sp)
 5e0:	6446                	ld	s0,80(sp)
 5e2:	64a6                	ld	s1,72(sp)
 5e4:	6906                	ld	s2,64(sp)
 5e6:	79e2                	ld	s3,56(sp)
 5e8:	7a42                	ld	s4,48(sp)
 5ea:	7aa2                	ld	s5,40(sp)
 5ec:	7b02                	ld	s6,32(sp)
 5ee:	6be2                	ld	s7,24(sp)
 5f0:	6125                	addi	sp,sp,96
 5f2:	8082                	ret

00000000000005f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 5f4:	1101                	addi	sp,sp,-32
 5f6:	ec06                	sd	ra,24(sp)
 5f8:	e822                	sd	s0,16(sp)
 5fa:	e426                	sd	s1,8(sp)
 5fc:	e04a                	sd	s2,0(sp)
 5fe:	1000                	addi	s0,sp,32
 600:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 602:	4581                	li	a1,0
 604:	00000097          	auipc	ra,0x0
 608:	0f6080e7          	jalr	246(ra) # 6fa <open>
  if(fd < 0)
 60c:	02054563          	bltz	a0,636 <stat+0x42>
 610:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 612:	85ca                	mv	a1,s2
 614:	00000097          	auipc	ra,0x0
 618:	0fe080e7          	jalr	254(ra) # 712 <fstat>
 61c:	892a                	mv	s2,a0
  close(fd);
 61e:	8526                	mv	a0,s1
 620:	00000097          	auipc	ra,0x0
 624:	0c2080e7          	jalr	194(ra) # 6e2 <close>
  return r;
}
 628:	854a                	mv	a0,s2
 62a:	60e2                	ld	ra,24(sp)
 62c:	6442                	ld	s0,16(sp)
 62e:	64a2                	ld	s1,8(sp)
 630:	6902                	ld	s2,0(sp)
 632:	6105                	addi	sp,sp,32
 634:	8082                	ret
    return -1;
 636:	597d                	li	s2,-1
 638:	bfc5                	j	628 <stat+0x34>

000000000000063a <atoi>:

int
atoi(const char *s)
{
 63a:	1141                	addi	sp,sp,-16
 63c:	e422                	sd	s0,8(sp)
 63e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 640:	00054603          	lbu	a2,0(a0)
 644:	fd06079b          	addiw	a5,a2,-48
 648:	0ff7f793          	andi	a5,a5,255
 64c:	4725                	li	a4,9
 64e:	02f76963          	bltu	a4,a5,680 <atoi+0x46>
 652:	86aa                	mv	a3,a0
  n = 0;
 654:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 656:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 658:	0685                	addi	a3,a3,1
 65a:	0025179b          	slliw	a5,a0,0x2
 65e:	9fa9                	addw	a5,a5,a0
 660:	0017979b          	slliw	a5,a5,0x1
 664:	9fb1                	addw	a5,a5,a2
 666:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 66a:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x2c8>
 66e:	fd06071b          	addiw	a4,a2,-48
 672:	0ff77713          	andi	a4,a4,255
 676:	fee5f1e3          	bgeu	a1,a4,658 <atoi+0x1e>
  return n;
}
 67a:	6422                	ld	s0,8(sp)
 67c:	0141                	addi	sp,sp,16
 67e:	8082                	ret
  n = 0;
 680:	4501                	li	a0,0
 682:	bfe5                	j	67a <atoi+0x40>

0000000000000684 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 684:	1141                	addi	sp,sp,-16
 686:	e422                	sd	s0,8(sp)
 688:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 68a:	02c05163          	blez	a2,6ac <memmove+0x28>
 68e:	fff6071b          	addiw	a4,a2,-1
 692:	1702                	slli	a4,a4,0x20
 694:	9301                	srli	a4,a4,0x20
 696:	0705                	addi	a4,a4,1
 698:	972a                	add	a4,a4,a0
  dst = vdst;
 69a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 69c:	0585                	addi	a1,a1,1
 69e:	0785                	addi	a5,a5,1
 6a0:	fff5c683          	lbu	a3,-1(a1)
 6a4:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 6a8:	fee79ae3          	bne	a5,a4,69c <memmove+0x18>
  return vdst;
}
 6ac:	6422                	ld	s0,8(sp)
 6ae:	0141                	addi	sp,sp,16
 6b0:	8082                	ret

00000000000006b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6b2:	4885                	li	a7,1
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 6ba:	4889                	li	a7,2
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6c2:	488d                	li	a7,3
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6ca:	4891                	li	a7,4
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <read>:
.global read
read:
 li a7, SYS_read
 6d2:	4895                	li	a7,5
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <write>:
.global write
write:
 li a7, SYS_write
 6da:	48c1                	li	a7,16
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <close>:
.global close
close:
 li a7, SYS_close
 6e2:	48d5                	li	a7,21
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 6ea:	4899                	li	a7,6
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6f2:	489d                	li	a7,7
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <open>:
.global open
open:
 li a7, SYS_open
 6fa:	48bd                	li	a7,15
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 702:	48c5                	li	a7,17
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 70a:	48c9                	li	a7,18
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 712:	48a1                	li	a7,8
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <link>:
.global link
link:
 li a7, SYS_link
 71a:	48cd                	li	a7,19
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 722:	48d1                	li	a7,20
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 72a:	48a5                	li	a7,9
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <dup>:
.global dup
dup:
 li a7, SYS_dup
 732:	48a9                	li	a7,10
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 73a:	48ad                	li	a7,11
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 742:	48b1                	li	a7,12
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 74a:	48b5                	li	a7,13
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 752:	48b9                	li	a7,14
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 75a:	48d9                	li	a7,22
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <crash>:
.global crash
crash:
 li a7, SYS_crash
 762:	48dd                	li	a7,23
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <mount>:
.global mount
mount:
 li a7, SYS_mount
 76a:	48e1                	li	a7,24
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <umount>:
.global umount
umount:
 li a7, SYS_umount
 772:	48e5                	li	a7,25
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 77a:	1101                	addi	sp,sp,-32
 77c:	ec06                	sd	ra,24(sp)
 77e:	e822                	sd	s0,16(sp)
 780:	1000                	addi	s0,sp,32
 782:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 786:	4605                	li	a2,1
 788:	fef40593          	addi	a1,s0,-17
 78c:	00000097          	auipc	ra,0x0
 790:	f4e080e7          	jalr	-178(ra) # 6da <write>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6105                	addi	sp,sp,32
 79a:	8082                	ret

000000000000079c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f426                	sd	s1,40(sp)
 7a4:	f04a                	sd	s2,32(sp)
 7a6:	ec4e                	sd	s3,24(sp)
 7a8:	0080                	addi	s0,sp,64
 7aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7ac:	c299                	beqz	a3,7b2 <printint+0x16>
 7ae:	0805c863          	bltz	a1,83e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7b2:	2581                	sext.w	a1,a1
  neg = 0;
 7b4:	4881                	li	a7,0
 7b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7bc:	2601                	sext.w	a2,a2
 7be:	00000517          	auipc	a0,0x0
 7c2:	55250513          	addi	a0,a0,1362 # d10 <digits>
 7c6:	883a                	mv	a6,a4
 7c8:	2705                	addiw	a4,a4,1
 7ca:	02c5f7bb          	remuw	a5,a1,a2
 7ce:	1782                	slli	a5,a5,0x20
 7d0:	9381                	srli	a5,a5,0x20
 7d2:	97aa                	add	a5,a5,a0
 7d4:	0007c783          	lbu	a5,0(a5)
 7d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7dc:	0005879b          	sext.w	a5,a1
 7e0:	02c5d5bb          	divuw	a1,a1,a2
 7e4:	0685                	addi	a3,a3,1
 7e6:	fec7f0e3          	bgeu	a5,a2,7c6 <printint+0x2a>
  if(neg)
 7ea:	00088b63          	beqz	a7,800 <printint+0x64>
    buf[i++] = '-';
 7ee:	fd040793          	addi	a5,s0,-48
 7f2:	973e                	add	a4,a4,a5
 7f4:	02d00793          	li	a5,45
 7f8:	fef70823          	sb	a5,-16(a4)
 7fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 800:	02e05863          	blez	a4,830 <printint+0x94>
 804:	fc040793          	addi	a5,s0,-64
 808:	00e78933          	add	s2,a5,a4
 80c:	fff78993          	addi	s3,a5,-1
 810:	99ba                	add	s3,s3,a4
 812:	377d                	addiw	a4,a4,-1
 814:	1702                	slli	a4,a4,0x20
 816:	9301                	srli	a4,a4,0x20
 818:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 81c:	fff94583          	lbu	a1,-1(s2)
 820:	8526                	mv	a0,s1
 822:	00000097          	auipc	ra,0x0
 826:	f58080e7          	jalr	-168(ra) # 77a <putc>
  while(--i >= 0)
 82a:	197d                	addi	s2,s2,-1
 82c:	ff3918e3          	bne	s2,s3,81c <printint+0x80>
}
 830:	70e2                	ld	ra,56(sp)
 832:	7442                	ld	s0,48(sp)
 834:	74a2                	ld	s1,40(sp)
 836:	7902                	ld	s2,32(sp)
 838:	69e2                	ld	s3,24(sp)
 83a:	6121                	addi	sp,sp,64
 83c:	8082                	ret
    x = -xx;
 83e:	40b005bb          	negw	a1,a1
    neg = 1;
 842:	4885                	li	a7,1
    x = -xx;
 844:	bf8d                	j	7b6 <printint+0x1a>

0000000000000846 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 846:	7119                	addi	sp,sp,-128
 848:	fc86                	sd	ra,120(sp)
 84a:	f8a2                	sd	s0,112(sp)
 84c:	f4a6                	sd	s1,104(sp)
 84e:	f0ca                	sd	s2,96(sp)
 850:	ecce                	sd	s3,88(sp)
 852:	e8d2                	sd	s4,80(sp)
 854:	e4d6                	sd	s5,72(sp)
 856:	e0da                	sd	s6,64(sp)
 858:	fc5e                	sd	s7,56(sp)
 85a:	f862                	sd	s8,48(sp)
 85c:	f466                	sd	s9,40(sp)
 85e:	f06a                	sd	s10,32(sp)
 860:	ec6e                	sd	s11,24(sp)
 862:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 864:	0005c903          	lbu	s2,0(a1)
 868:	18090f63          	beqz	s2,a06 <vprintf+0x1c0>
 86c:	8aaa                	mv	s5,a0
 86e:	8b32                	mv	s6,a2
 870:	00158493          	addi	s1,a1,1
  state = 0;
 874:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 876:	02500a13          	li	s4,37
      if(c == 'd'){
 87a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 87e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 882:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 886:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88a:	00000b97          	auipc	s7,0x0
 88e:	486b8b93          	addi	s7,s7,1158 # d10 <digits>
 892:	a839                	j	8b0 <vprintf+0x6a>
        putc(fd, c);
 894:	85ca                	mv	a1,s2
 896:	8556                	mv	a0,s5
 898:	00000097          	auipc	ra,0x0
 89c:	ee2080e7          	jalr	-286(ra) # 77a <putc>
 8a0:	a019                	j	8a6 <vprintf+0x60>
    } else if(state == '%'){
 8a2:	01498f63          	beq	s3,s4,8c0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8a6:	0485                	addi	s1,s1,1
 8a8:	fff4c903          	lbu	s2,-1(s1)
 8ac:	14090d63          	beqz	s2,a06 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8b4:	fe0997e3          	bnez	s3,8a2 <vprintf+0x5c>
      if(c == '%'){
 8b8:	fd479ee3          	bne	a5,s4,894 <vprintf+0x4e>
        state = '%';
 8bc:	89be                	mv	s3,a5
 8be:	b7e5                	j	8a6 <vprintf+0x60>
      if(c == 'd'){
 8c0:	05878063          	beq	a5,s8,900 <vprintf+0xba>
      } else if(c == 'l') {
 8c4:	05978c63          	beq	a5,s9,91c <vprintf+0xd6>
      } else if(c == 'x') {
 8c8:	07a78863          	beq	a5,s10,938 <vprintf+0xf2>
      } else if(c == 'p') {
 8cc:	09b78463          	beq	a5,s11,954 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8d0:	07300713          	li	a4,115
 8d4:	0ce78663          	beq	a5,a4,9a0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8d8:	06300713          	li	a4,99
 8dc:	0ee78e63          	beq	a5,a4,9d8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8e0:	11478863          	beq	a5,s4,9f0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8e4:	85d2                	mv	a1,s4
 8e6:	8556                	mv	a0,s5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e92080e7          	jalr	-366(ra) # 77a <putc>
        putc(fd, c);
 8f0:	85ca                	mv	a1,s2
 8f2:	8556                	mv	a0,s5
 8f4:	00000097          	auipc	ra,0x0
 8f8:	e86080e7          	jalr	-378(ra) # 77a <putc>
      }
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	b765                	j	8a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 900:	008b0913          	addi	s2,s6,8
 904:	4685                	li	a3,1
 906:	4629                	li	a2,10
 908:	000b2583          	lw	a1,0(s6)
 90c:	8556                	mv	a0,s5
 90e:	00000097          	auipc	ra,0x0
 912:	e8e080e7          	jalr	-370(ra) # 79c <printint>
 916:	8b4a                	mv	s6,s2
      state = 0;
 918:	4981                	li	s3,0
 91a:	b771                	j	8a6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 91c:	008b0913          	addi	s2,s6,8
 920:	4681                	li	a3,0
 922:	4629                	li	a2,10
 924:	000b2583          	lw	a1,0(s6)
 928:	8556                	mv	a0,s5
 92a:	00000097          	auipc	ra,0x0
 92e:	e72080e7          	jalr	-398(ra) # 79c <printint>
 932:	8b4a                	mv	s6,s2
      state = 0;
 934:	4981                	li	s3,0
 936:	bf85                	j	8a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 938:	008b0913          	addi	s2,s6,8
 93c:	4681                	li	a3,0
 93e:	4641                	li	a2,16
 940:	000b2583          	lw	a1,0(s6)
 944:	8556                	mv	a0,s5
 946:	00000097          	auipc	ra,0x0
 94a:	e56080e7          	jalr	-426(ra) # 79c <printint>
 94e:	8b4a                	mv	s6,s2
      state = 0;
 950:	4981                	li	s3,0
 952:	bf91                	j	8a6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 954:	008b0793          	addi	a5,s6,8
 958:	f8f43423          	sd	a5,-120(s0)
 95c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 960:	03000593          	li	a1,48
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	e14080e7          	jalr	-492(ra) # 77a <putc>
  putc(fd, 'x');
 96e:	85ea                	mv	a1,s10
 970:	8556                	mv	a0,s5
 972:	00000097          	auipc	ra,0x0
 976:	e08080e7          	jalr	-504(ra) # 77a <putc>
 97a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 97c:	03c9d793          	srli	a5,s3,0x3c
 980:	97de                	add	a5,a5,s7
 982:	0007c583          	lbu	a1,0(a5)
 986:	8556                	mv	a0,s5
 988:	00000097          	auipc	ra,0x0
 98c:	df2080e7          	jalr	-526(ra) # 77a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 990:	0992                	slli	s3,s3,0x4
 992:	397d                	addiw	s2,s2,-1
 994:	fe0914e3          	bnez	s2,97c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 998:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 99c:	4981                	li	s3,0
 99e:	b721                	j	8a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 9a0:	008b0993          	addi	s3,s6,8
 9a4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9a8:	02090163          	beqz	s2,9ca <vprintf+0x184>
        while(*s != 0){
 9ac:	00094583          	lbu	a1,0(s2)
 9b0:	c9a1                	beqz	a1,a00 <vprintf+0x1ba>
          putc(fd, *s);
 9b2:	8556                	mv	a0,s5
 9b4:	00000097          	auipc	ra,0x0
 9b8:	dc6080e7          	jalr	-570(ra) # 77a <putc>
          s++;
 9bc:	0905                	addi	s2,s2,1
        while(*s != 0){
 9be:	00094583          	lbu	a1,0(s2)
 9c2:	f9e5                	bnez	a1,9b2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9c4:	8b4e                	mv	s6,s3
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	bdf9                	j	8a6 <vprintf+0x60>
          s = "(null)";
 9ca:	00000917          	auipc	s2,0x0
 9ce:	33e90913          	addi	s2,s2,830 # d08 <malloc+0x1f8>
        while(*s != 0){
 9d2:	02800593          	li	a1,40
 9d6:	bff1                	j	9b2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9d8:	008b0913          	addi	s2,s6,8
 9dc:	000b4583          	lbu	a1,0(s6)
 9e0:	8556                	mv	a0,s5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	d98080e7          	jalr	-616(ra) # 77a <putc>
 9ea:	8b4a                	mv	s6,s2
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	bd65                	j	8a6 <vprintf+0x60>
        putc(fd, c);
 9f0:	85d2                	mv	a1,s4
 9f2:	8556                	mv	a0,s5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	d86080e7          	jalr	-634(ra) # 77a <putc>
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	b565                	j	8a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 a00:	8b4e                	mv	s6,s3
      state = 0;
 a02:	4981                	li	s3,0
 a04:	b54d                	j	8a6 <vprintf+0x60>
    }
  }
}
 a06:	70e6                	ld	ra,120(sp)
 a08:	7446                	ld	s0,112(sp)
 a0a:	74a6                	ld	s1,104(sp)
 a0c:	7906                	ld	s2,96(sp)
 a0e:	69e6                	ld	s3,88(sp)
 a10:	6a46                	ld	s4,80(sp)
 a12:	6aa6                	ld	s5,72(sp)
 a14:	6b06                	ld	s6,64(sp)
 a16:	7be2                	ld	s7,56(sp)
 a18:	7c42                	ld	s8,48(sp)
 a1a:	7ca2                	ld	s9,40(sp)
 a1c:	7d02                	ld	s10,32(sp)
 a1e:	6de2                	ld	s11,24(sp)
 a20:	6109                	addi	sp,sp,128
 a22:	8082                	ret

0000000000000a24 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a24:	715d                	addi	sp,sp,-80
 a26:	ec06                	sd	ra,24(sp)
 a28:	e822                	sd	s0,16(sp)
 a2a:	1000                	addi	s0,sp,32
 a2c:	e010                	sd	a2,0(s0)
 a2e:	e414                	sd	a3,8(s0)
 a30:	e818                	sd	a4,16(s0)
 a32:	ec1c                	sd	a5,24(s0)
 a34:	03043023          	sd	a6,32(s0)
 a38:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a3c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a40:	8622                	mv	a2,s0
 a42:	00000097          	auipc	ra,0x0
 a46:	e04080e7          	jalr	-508(ra) # 846 <vprintf>
}
 a4a:	60e2                	ld	ra,24(sp)
 a4c:	6442                	ld	s0,16(sp)
 a4e:	6161                	addi	sp,sp,80
 a50:	8082                	ret

0000000000000a52 <printf>:

void
printf(const char *fmt, ...)
{
 a52:	711d                	addi	sp,sp,-96
 a54:	ec06                	sd	ra,24(sp)
 a56:	e822                	sd	s0,16(sp)
 a58:	1000                	addi	s0,sp,32
 a5a:	e40c                	sd	a1,8(s0)
 a5c:	e810                	sd	a2,16(s0)
 a5e:	ec14                	sd	a3,24(s0)
 a60:	f018                	sd	a4,32(s0)
 a62:	f41c                	sd	a5,40(s0)
 a64:	03043823          	sd	a6,48(s0)
 a68:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6c:	00840613          	addi	a2,s0,8
 a70:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a74:	85aa                	mv	a1,a0
 a76:	4505                	li	a0,1
 a78:	00000097          	auipc	ra,0x0
 a7c:	dce080e7          	jalr	-562(ra) # 846 <vprintf>
}
 a80:	60e2                	ld	ra,24(sp)
 a82:	6442                	ld	s0,16(sp)
 a84:	6125                	addi	sp,sp,96
 a86:	8082                	ret

0000000000000a88 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a88:	1141                	addi	sp,sp,-16
 a8a:	e422                	sd	s0,8(sp)
 a8c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a92:	00000797          	auipc	a5,0x0
 a96:	29e7b783          	ld	a5,670(a5) # d30 <freep>
 a9a:	a805                	j	aca <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a9c:	4618                	lw	a4,8(a2)
 a9e:	9db9                	addw	a1,a1,a4
 aa0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa4:	6398                	ld	a4,0(a5)
 aa6:	6318                	ld	a4,0(a4)
 aa8:	fee53823          	sd	a4,-16(a0)
 aac:	a091                	j	af0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aae:	ff852703          	lw	a4,-8(a0)
 ab2:	9e39                	addw	a2,a2,a4
 ab4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ab6:	ff053703          	ld	a4,-16(a0)
 aba:	e398                	sd	a4,0(a5)
 abc:	a099                	j	b02 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abe:	6398                	ld	a4,0(a5)
 ac0:	00e7e463          	bltu	a5,a4,ac8 <free+0x40>
 ac4:	00e6ea63          	bltu	a3,a4,ad8 <free+0x50>
{
 ac8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aca:	fed7fae3          	bgeu	a5,a3,abe <free+0x36>
 ace:	6398                	ld	a4,0(a5)
 ad0:	00e6e463          	bltu	a3,a4,ad8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad4:	fee7eae3          	bltu	a5,a4,ac8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ad8:	ff852583          	lw	a1,-8(a0)
 adc:	6390                	ld	a2,0(a5)
 ade:	02059713          	slli	a4,a1,0x20
 ae2:	9301                	srli	a4,a4,0x20
 ae4:	0712                	slli	a4,a4,0x4
 ae6:	9736                	add	a4,a4,a3
 ae8:	fae60ae3          	beq	a2,a4,a9c <free+0x14>
    bp->s.ptr = p->s.ptr;
 aec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 af0:	4790                	lw	a2,8(a5)
 af2:	02061713          	slli	a4,a2,0x20
 af6:	9301                	srli	a4,a4,0x20
 af8:	0712                	slli	a4,a4,0x4
 afa:	973e                	add	a4,a4,a5
 afc:	fae689e3          	beq	a3,a4,aae <free+0x26>
  } else
    p->s.ptr = bp;
 b00:	e394                	sd	a3,0(a5)
  freep = p;
 b02:	00000717          	auipc	a4,0x0
 b06:	22f73723          	sd	a5,558(a4) # d30 <freep>
}
 b0a:	6422                	ld	s0,8(sp)
 b0c:	0141                	addi	sp,sp,16
 b0e:	8082                	ret

0000000000000b10 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b10:	7139                	addi	sp,sp,-64
 b12:	fc06                	sd	ra,56(sp)
 b14:	f822                	sd	s0,48(sp)
 b16:	f426                	sd	s1,40(sp)
 b18:	f04a                	sd	s2,32(sp)
 b1a:	ec4e                	sd	s3,24(sp)
 b1c:	e852                	sd	s4,16(sp)
 b1e:	e456                	sd	s5,8(sp)
 b20:	e05a                	sd	s6,0(sp)
 b22:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b24:	02051493          	slli	s1,a0,0x20
 b28:	9081                	srli	s1,s1,0x20
 b2a:	04bd                	addi	s1,s1,15
 b2c:	8091                	srli	s1,s1,0x4
 b2e:	0014899b          	addiw	s3,s1,1
 b32:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b34:	00000517          	auipc	a0,0x0
 b38:	1fc53503          	ld	a0,508(a0) # d30 <freep>
 b3c:	c515                	beqz	a0,b68 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b40:	4798                	lw	a4,8(a5)
 b42:	02977f63          	bgeu	a4,s1,b80 <malloc+0x70>
 b46:	8a4e                	mv	s4,s3
 b48:	0009871b          	sext.w	a4,s3
 b4c:	6685                	lui	a3,0x1
 b4e:	00d77363          	bgeu	a4,a3,b54 <malloc+0x44>
 b52:	6a05                	lui	s4,0x1
 b54:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b58:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b5c:	00000917          	auipc	s2,0x0
 b60:	1d490913          	addi	s2,s2,468 # d30 <freep>
  if(p == (char*)-1)
 b64:	5afd                	li	s5,-1
 b66:	a88d                	j	bd8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b68:	00004797          	auipc	a5,0x4
 b6c:	1d078793          	addi	a5,a5,464 # 4d38 <base>
 b70:	00000717          	auipc	a4,0x0
 b74:	1cf73023          	sd	a5,448(a4) # d30 <freep>
 b78:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b7a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b7e:	b7e1                	j	b46 <malloc+0x36>
      if(p->s.size == nunits)
 b80:	02e48b63          	beq	s1,a4,bb6 <malloc+0xa6>
        p->s.size -= nunits;
 b84:	4137073b          	subw	a4,a4,s3
 b88:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b8a:	1702                	slli	a4,a4,0x20
 b8c:	9301                	srli	a4,a4,0x20
 b8e:	0712                	slli	a4,a4,0x4
 b90:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b92:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b96:	00000717          	auipc	a4,0x0
 b9a:	18a73d23          	sd	a0,410(a4) # d30 <freep>
      return (void*)(p + 1);
 b9e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ba2:	70e2                	ld	ra,56(sp)
 ba4:	7442                	ld	s0,48(sp)
 ba6:	74a2                	ld	s1,40(sp)
 ba8:	7902                	ld	s2,32(sp)
 baa:	69e2                	ld	s3,24(sp)
 bac:	6a42                	ld	s4,16(sp)
 bae:	6aa2                	ld	s5,8(sp)
 bb0:	6b02                	ld	s6,0(sp)
 bb2:	6121                	addi	sp,sp,64
 bb4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bb6:	6398                	ld	a4,0(a5)
 bb8:	e118                	sd	a4,0(a0)
 bba:	bff1                	j	b96 <malloc+0x86>
  hp->s.size = nu;
 bbc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc0:	0541                	addi	a0,a0,16
 bc2:	00000097          	auipc	ra,0x0
 bc6:	ec6080e7          	jalr	-314(ra) # a88 <free>
  return freep;
 bca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bce:	d971                	beqz	a0,ba2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bd2:	4798                	lw	a4,8(a5)
 bd4:	fa9776e3          	bgeu	a4,s1,b80 <malloc+0x70>
    if(p == freep)
 bd8:	00093703          	ld	a4,0(s2)
 bdc:	853e                	mv	a0,a5
 bde:	fef719e3          	bne	a4,a5,bd0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 be2:	8552                	mv	a0,s4
 be4:	00000097          	auipc	ra,0x0
 be8:	b5e080e7          	jalr	-1186(ra) # 742 <sbrk>
  if(p == (char*)-1)
 bec:	fd5518e3          	bne	a0,s5,bbc <malloc+0xac>
        return 0;
 bf0:	4501                	li	a0,0
 bf2:	bf45                	j	ba2 <malloc+0x92>
