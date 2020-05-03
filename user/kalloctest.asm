
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test1();
  exit();
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test0\n");  
  10:	00001517          	auipc	a0,0x1
  14:	9d850513          	addi	a0,a0,-1576 # 9e8 <malloc+0xe8>
  18:	00001097          	auipc	ra,0x1
  1c:	82a080e7          	jalr	-2006(ra) # 842 <printf>
  int n = ntas();
  20:	00000097          	auipc	ra,0x0
  24:	52a080e7          	jalr	1322(ra) # 54a <ntas>
  28:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  2a:	00000097          	auipc	ra,0x0
  2e:	478080e7          	jalr	1144(ra) # 4a2 <fork>
    if(pid < 0){
  32:	04054863          	bltz	a0,82 <test0+0x82>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
  36:	c135                	beqz	a0,9a <test0+0x9a>
    int pid = fork();
  38:	00000097          	auipc	ra,0x0
  3c:	46a080e7          	jalr	1130(ra) # 4a2 <fork>
    if(pid < 0){
  40:	04054163          	bltz	a0,82 <test0+0x82>
    if(pid == 0){
  44:	c939                	beqz	a0,9a <test0+0x9a>
      exit();
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait();
  46:	00000097          	auipc	ra,0x0
  4a:	46c080e7          	jalr	1132(ra) # 4b2 <wait>
  4e:	00000097          	auipc	ra,0x0
  52:	464080e7          	jalr	1124(ra) # 4b2 <wait>
  }
  int t = ntas();
  56:	00000097          	auipc	ra,0x0
  5a:	4f4080e7          	jalr	1268(ra) # 54a <ntas>
  printf("test0 done: #test-and-sets = %d\n", t - n);
  5e:	409505bb          	subw	a1,a0,s1
  62:	00001517          	auipc	a0,0x1
  66:	9b650513          	addi	a0,a0,-1610 # a18 <malloc+0x118>
  6a:	00000097          	auipc	ra,0x0
  6e:	7d8080e7          	jalr	2008(ra) # 842 <printf>
}
  72:	70a2                	ld	ra,40(sp)
  74:	7402                	ld	s0,32(sp)
  76:	64e2                	ld	s1,24(sp)
  78:	6942                	ld	s2,16(sp)
  7a:	69a2                	ld	s3,8(sp)
  7c:	6a02                	ld	s4,0(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
      printf("fork failed");
  82:	00001517          	auipc	a0,0x1
  86:	97650513          	addi	a0,a0,-1674 # 9f8 <malloc+0xf8>
  8a:	00000097          	auipc	ra,0x0
  8e:	7b8080e7          	jalr	1976(ra) # 842 <printf>
      exit();
  92:	00000097          	auipc	ra,0x0
  96:	418080e7          	jalr	1048(ra) # 4aa <exit>
{
  9a:	6961                	lui	s2,0x18
  9c:	6a090913          	addi	s2,s2,1696 # 186a0 <__global_pointer$+0x17397>
        if(a == (char*)0xffffffffffffffffL){
  a0:	59fd                	li	s3,-1
        *(int *)(a+4) = 1;
  a2:	4a05                	li	s4,1
        a = sbrk(4096);
  a4:	6505                	lui	a0,0x1
  a6:	00000097          	auipc	ra,0x0
  aa:	48c080e7          	jalr	1164(ra) # 532 <sbrk>
  ae:	84aa                	mv	s1,a0
        if(a == (char*)0xffffffffffffffffL){
  b0:	03350063          	beq	a0,s3,d0 <test0+0xd0>
        *(int *)(a+4) = 1;
  b4:	01452223          	sw	s4,4(a0) # 1004 <__BSS_END__+0x4dc>
        a1 = sbrk(-4096);
  b8:	757d                	lui	a0,0xfffff
  ba:	00000097          	auipc	ra,0x0
  be:	478080e7          	jalr	1144(ra) # 532 <sbrk>
        if (a1 != a + 4096) {
  c2:	6785                	lui	a5,0x1
  c4:	94be                	add	s1,s1,a5
  c6:	00951963          	bne	a0,s1,d8 <test0+0xd8>
      for(i = 0; i < N; i++) {
  ca:	397d                	addiw	s2,s2,-1
  cc:	fc091ce3          	bnez	s2,a4 <test0+0xa4>
      exit();
  d0:	00000097          	auipc	ra,0x0
  d4:	3da080e7          	jalr	986(ra) # 4aa <exit>
          printf("wrong sbrk\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	93050513          	addi	a0,a0,-1744 # a08 <malloc+0x108>
  e0:	00000097          	auipc	ra,0x0
  e4:	762080e7          	jalr	1890(ra) # 842 <printf>
          exit();
  e8:	00000097          	auipc	ra,0x0
  ec:	3c2080e7          	jalr	962(ra) # 4aa <exit>

00000000000000f0 <test1>:

// Run system out of memory and count tot memory allocated
void test1()
{
  f0:	715d                	addi	sp,sp,-80
  f2:	e486                	sd	ra,72(sp)
  f4:	e0a2                	sd	s0,64(sp)
  f6:	fc26                	sd	s1,56(sp)
  f8:	f84a                	sd	s2,48(sp)
  fa:	f44e                	sd	s3,40(sp)
  fc:	f052                	sd	s4,32(sp)
  fe:	0880                	addi	s0,sp,80
  void *a;
  int pipes[NCHILD];
  int tot = 0;
  char buf[1];
  
  printf("start test1\n");  
 100:	00001517          	auipc	a0,0x1
 104:	94050513          	addi	a0,a0,-1728 # a40 <malloc+0x140>
 108:	00000097          	auipc	ra,0x0
 10c:	73a080e7          	jalr	1850(ra) # 842 <printf>
  for(int i = 0; i < NCHILD; i++){
 110:	fc840913          	addi	s2,s0,-56
    int fds[2];
    if(pipe(fds) != 0){
 114:	fb840513          	addi	a0,s0,-72
 118:	00000097          	auipc	ra,0x0
 11c:	3a2080e7          	jalr	930(ra) # 4ba <pipe>
 120:	84aa                	mv	s1,a0
 122:	e905                	bnez	a0,152 <test1+0x62>
      printf("pipe() failed\n");
      exit();
    }
    int pid = fork();
 124:	00000097          	auipc	ra,0x0
 128:	37e080e7          	jalr	894(ra) # 4a2 <fork>
    if(pid < 0){
 12c:	02054f63          	bltz	a0,16a <test1+0x7a>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
 130:	c929                	beqz	a0,182 <test1+0x92>
          exit();
        }
      }
      exit();
    } else {
      close(fds[1]);
 132:	fbc42503          	lw	a0,-68(s0)
 136:	00000097          	auipc	ra,0x0
 13a:	39c080e7          	jalr	924(ra) # 4d2 <close>
      pipes[i] = fds[0];
 13e:	fb842783          	lw	a5,-72(s0)
 142:	00f92023          	sw	a5,0(s2)
  for(int i = 0; i < NCHILD; i++){
 146:	0911                	addi	s2,s2,4
 148:	fd040793          	addi	a5,s0,-48
 14c:	fd2794e3          	bne	a5,s2,114 <test1+0x24>
 150:	a85d                	j	206 <test1+0x116>
      printf("pipe() failed\n");
 152:	00001517          	auipc	a0,0x1
 156:	8fe50513          	addi	a0,a0,-1794 # a50 <malloc+0x150>
 15a:	00000097          	auipc	ra,0x0
 15e:	6e8080e7          	jalr	1768(ra) # 842 <printf>
      exit();
 162:	00000097          	auipc	ra,0x0
 166:	348080e7          	jalr	840(ra) # 4aa <exit>
      printf("fork failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	88e50513          	addi	a0,a0,-1906 # 9f8 <malloc+0xf8>
 172:	00000097          	auipc	ra,0x0
 176:	6d0080e7          	jalr	1744(ra) # 842 <printf>
      exit();
 17a:	00000097          	auipc	ra,0x0
 17e:	330080e7          	jalr	816(ra) # 4aa <exit>
      close(fds[0]);
 182:	fb842503          	lw	a0,-72(s0)
 186:	00000097          	auipc	ra,0x0
 18a:	34c080e7          	jalr	844(ra) # 4d2 <close>
 18e:	64e1                	lui	s1,0x18
 190:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x17397>
        if(a == (char*)0xffffffffffffffffL){
 194:	5a7d                	li	s4,-1
        *(int *)(a+4) = 1;
 196:	4985                	li	s3,1
        if (write(fds[1], "x", 1) != 1) {
 198:	00001917          	auipc	s2,0x1
 19c:	8c890913          	addi	s2,s2,-1848 # a60 <malloc+0x160>
        a = sbrk(PGSIZE);
 1a0:	6505                	lui	a0,0x1
 1a2:	00000097          	auipc	ra,0x0
 1a6:	390080e7          	jalr	912(ra) # 532 <sbrk>
        if(a == (char*)0xffffffffffffffffL){
 1aa:	03450163          	beq	a0,s4,1cc <test1+0xdc>
        *(int *)(a+4) = 1;
 1ae:	01352223          	sw	s3,4(a0) # 1004 <__BSS_END__+0x4dc>
        if (write(fds[1], "x", 1) != 1) {
 1b2:	4605                	li	a2,1
 1b4:	85ca                	mv	a1,s2
 1b6:	fbc42503          	lw	a0,-68(s0)
 1ba:	00000097          	auipc	ra,0x0
 1be:	310080e7          	jalr	784(ra) # 4ca <write>
 1c2:	4785                	li	a5,1
 1c4:	00f51863          	bne	a0,a5,1d4 <test1+0xe4>
      for(i = 0; i < N; i++) {
 1c8:	34fd                	addiw	s1,s1,-1
 1ca:	f8f9                	bnez	s1,1a0 <test1+0xb0>
      exit();
 1cc:	00000097          	auipc	ra,0x0
 1d0:	2de080e7          	jalr	734(ra) # 4aa <exit>
          printf("write failed");
 1d4:	00001517          	auipc	a0,0x1
 1d8:	89450513          	addi	a0,a0,-1900 # a68 <malloc+0x168>
 1dc:	00000097          	auipc	ra,0x0
 1e0:	666080e7          	jalr	1638(ra) # 842 <printf>
          exit();
 1e4:	00000097          	auipc	ra,0x0
 1e8:	2c6080e7          	jalr	710(ra) # 4aa <exit>
  int stop = 0;
  while (!stop) {
    stop = 1;
    for(int i = 0; i < NCHILD; i++){
      if (read(pipes[i], buf, 1) == 1) {
        tot += 1;
 1ec:	2485                	addiw	s1,s1,1
      if (read(pipes[i], buf, 1) == 1) {
 1ee:	4605                	li	a2,1
 1f0:	fc040593          	addi	a1,s0,-64
 1f4:	fcc42503          	lw	a0,-52(s0)
 1f8:	00000097          	auipc	ra,0x0
 1fc:	2ca080e7          	jalr	714(ra) # 4c2 <read>
 200:	4785                	li	a5,1
 202:	02f50a63          	beq	a0,a5,236 <test1+0x146>
 206:	4605                	li	a2,1
 208:	fc040593          	addi	a1,s0,-64
 20c:	fc842503          	lw	a0,-56(s0)
 210:	00000097          	auipc	ra,0x0
 214:	2b2080e7          	jalr	690(ra) # 4c2 <read>
 218:	4785                	li	a5,1
 21a:	fcf509e3          	beq	a0,a5,1ec <test1+0xfc>
 21e:	4605                	li	a2,1
 220:	fc040593          	addi	a1,s0,-64
 224:	fcc42503          	lw	a0,-52(s0)
 228:	00000097          	auipc	ra,0x0
 22c:	29a080e7          	jalr	666(ra) # 4c2 <read>
 230:	4785                	li	a5,1
 232:	02f51063          	bne	a0,a5,252 <test1+0x162>
        tot += 1;
 236:	2485                	addiw	s1,s1,1
  while (!stop) {
 238:	b7f9                	j	206 <test1+0x116>
    }
  }
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
  if(n - tot > 1000) {
    printf("test1 failed: cannot allocate enough memory\n");
 23a:	00001517          	auipc	a0,0x1
 23e:	83e50513          	addi	a0,a0,-1986 # a78 <malloc+0x178>
 242:	00000097          	auipc	ra,0x0
 246:	600080e7          	jalr	1536(ra) # 842 <printf>
    exit();
 24a:	00000097          	auipc	ra,0x0
 24e:	260080e7          	jalr	608(ra) # 4aa <exit>
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
 252:	6621                	lui	a2,0x8
 254:	85a6                	mv	a1,s1
 256:	00001517          	auipc	a0,0x1
 25a:	86250513          	addi	a0,a0,-1950 # ab8 <malloc+0x1b8>
 25e:	00000097          	auipc	ra,0x0
 262:	5e4080e7          	jalr	1508(ra) # 842 <printf>
  if(n - tot > 1000) {
 266:	67a1                	lui	a5,0x8
 268:	409784bb          	subw	s1,a5,s1
 26c:	3e800793          	li	a5,1000
 270:	fc97c5e3          	blt	a5,s1,23a <test1+0x14a>
  }
  printf("test1 done\n");
 274:	00001517          	auipc	a0,0x1
 278:	83450513          	addi	a0,a0,-1996 # aa8 <malloc+0x1a8>
 27c:	00000097          	auipc	ra,0x0
 280:	5c6080e7          	jalr	1478(ra) # 842 <printf>
}
 284:	60a6                	ld	ra,72(sp)
 286:	6406                	ld	s0,64(sp)
 288:	74e2                	ld	s1,56(sp)
 28a:	7942                	ld	s2,48(sp)
 28c:	79a2                	ld	s3,40(sp)
 28e:	7a02                	ld	s4,32(sp)
 290:	6161                	addi	sp,sp,80
 292:	8082                	ret

0000000000000294 <main>:
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  test0();
 29c:	00000097          	auipc	ra,0x0
 2a0:	d64080e7          	jalr	-668(ra) # 0 <test0>
  test1();
 2a4:	00000097          	auipc	ra,0x0
 2a8:	e4c080e7          	jalr	-436(ra) # f0 <test1>
  exit();
 2ac:	00000097          	auipc	ra,0x0
 2b0:	1fe080e7          	jalr	510(ra) # 4aa <exit>

00000000000002b4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ba:	87aa                	mv	a5,a0
 2bc:	0585                	addi	a1,a1,1
 2be:	0785                	addi	a5,a5,1
 2c0:	fff5c703          	lbu	a4,-1(a1)
 2c4:	fee78fa3          	sb	a4,-1(a5) # 7fff <__global_pointer$+0x6cf6>
 2c8:	fb75                	bnez	a4,2bc <strcpy+0x8>
    ;
  return os;
}
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cb91                	beqz	a5,2ee <strcmp+0x1e>
 2dc:	0005c703          	lbu	a4,0(a1)
 2e0:	00f71763          	bne	a4,a5,2ee <strcmp+0x1e>
    p++, q++;
 2e4:	0505                	addi	a0,a0,1
 2e6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	fbe5                	bnez	a5,2dc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ee:	0005c503          	lbu	a0,0(a1)
}
 2f2:	40a7853b          	subw	a0,a5,a0
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <strlen>:

uint
strlen(const char *s)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 302:	00054783          	lbu	a5,0(a0)
 306:	cf91                	beqz	a5,322 <strlen+0x26>
 308:	0505                	addi	a0,a0,1
 30a:	87aa                	mv	a5,a0
 30c:	4685                	li	a3,1
 30e:	9e89                	subw	a3,a3,a0
 310:	00f6853b          	addw	a0,a3,a5
 314:	0785                	addi	a5,a5,1
 316:	fff7c703          	lbu	a4,-1(a5)
 31a:	fb7d                	bnez	a4,310 <strlen+0x14>
    ;
  return n;
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  for(n = 0; s[n]; n++)
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <strlen+0x20>

0000000000000326 <memset>:

void*
memset(void *dst, int c, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 32c:	ce09                	beqz	a2,346 <memset+0x20>
 32e:	87aa                	mv	a5,a0
 330:	fff6071b          	addiw	a4,a2,-1
 334:	1702                	slli	a4,a4,0x20
 336:	9301                	srli	a4,a4,0x20
 338:	0705                	addi	a4,a4,1
 33a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 33c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 340:	0785                	addi	a5,a5,1
 342:	fee79de3          	bne	a5,a4,33c <memset+0x16>
  }
  return dst;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strchr>:

char*
strchr(const char *s, char c)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  for(; *s; s++)
 352:	00054783          	lbu	a5,0(a0)
 356:	cb99                	beqz	a5,36c <strchr+0x20>
    if(*s == c)
 358:	00f58763          	beq	a1,a5,366 <strchr+0x1a>
  for(; *s; s++)
 35c:	0505                	addi	a0,a0,1
 35e:	00054783          	lbu	a5,0(a0)
 362:	fbfd                	bnez	a5,358 <strchr+0xc>
      return (char*)s;
  return 0;
 364:	4501                	li	a0,0
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <strchr+0x1a>

0000000000000370 <gets>:

char*
gets(char *buf, int max)
{
 370:	711d                	addi	sp,sp,-96
 372:	ec86                	sd	ra,88(sp)
 374:	e8a2                	sd	s0,80(sp)
 376:	e4a6                	sd	s1,72(sp)
 378:	e0ca                	sd	s2,64(sp)
 37a:	fc4e                	sd	s3,56(sp)
 37c:	f852                	sd	s4,48(sp)
 37e:	f456                	sd	s5,40(sp)
 380:	f05a                	sd	s6,32(sp)
 382:	ec5e                	sd	s7,24(sp)
 384:	1080                	addi	s0,sp,96
 386:	8baa                	mv	s7,a0
 388:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38a:	892a                	mv	s2,a0
 38c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 38e:	4aa9                	li	s5,10
 390:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 392:	89a6                	mv	s3,s1
 394:	2485                	addiw	s1,s1,1
 396:	0344d863          	bge	s1,s4,3c6 <gets+0x56>
    cc = read(0, &c, 1);
 39a:	4605                	li	a2,1
 39c:	faf40593          	addi	a1,s0,-81
 3a0:	4501                	li	a0,0
 3a2:	00000097          	auipc	ra,0x0
 3a6:	120080e7          	jalr	288(ra) # 4c2 <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x56>
    buf[i++] = c;
 3ae:	faf44783          	lbu	a5,-81(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01578763          	beq	a5,s5,3c4 <gets+0x54>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd679be3          	bne	a5,s6,392 <gets+0x22>
  for(i=0; i+1 < max; ){
 3c0:	89a6                	mv	s3,s1
 3c2:	a011                	j	3c6 <gets+0x56>
 3c4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c6:	99de                	add	s3,s3,s7
 3c8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3cc:	855e                	mv	a0,s7
 3ce:	60e6                	ld	ra,88(sp)
 3d0:	6446                	ld	s0,80(sp)
 3d2:	64a6                	ld	s1,72(sp)
 3d4:	6906                	ld	s2,64(sp)
 3d6:	79e2                	ld	s3,56(sp)
 3d8:	7a42                	ld	s4,48(sp)
 3da:	7aa2                	ld	s5,40(sp)
 3dc:	7b02                	ld	s6,32(sp)
 3de:	6be2                	ld	s7,24(sp)
 3e0:	6125                	addi	sp,sp,96
 3e2:	8082                	ret

00000000000003e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	e426                	sd	s1,8(sp)
 3ec:	e04a                	sd	s2,0(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f2:	4581                	li	a1,0
 3f4:	00000097          	auipc	ra,0x0
 3f8:	0f6080e7          	jalr	246(ra) # 4ea <open>
  if(fd < 0)
 3fc:	02054563          	bltz	a0,426 <stat+0x42>
 400:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 402:	85ca                	mv	a1,s2
 404:	00000097          	auipc	ra,0x0
 408:	0fe080e7          	jalr	254(ra) # 502 <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	0c2080e7          	jalr	194(ra) # 4d2 <close>
  return r;
}
 418:	854a                	mv	a0,s2
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	64a2                	ld	s1,8(sp)
 420:	6902                	ld	s2,0(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret
    return -1;
 426:	597d                	li	s2,-1
 428:	bfc5                	j	418 <stat+0x34>

000000000000042a <atoi>:

int
atoi(const char *s)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 430:	00054603          	lbu	a2,0(a0)
 434:	fd06079b          	addiw	a5,a2,-48
 438:	0ff7f793          	andi	a5,a5,255
 43c:	4725                	li	a4,9
 43e:	02f76963          	bltu	a4,a5,470 <atoi+0x46>
 442:	86aa                	mv	a3,a0
  n = 0;
 444:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 446:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 448:	0685                	addi	a3,a3,1
 44a:	0025179b          	slliw	a5,a0,0x2
 44e:	9fa9                	addw	a5,a5,a0
 450:	0017979b          	slliw	a5,a5,0x1
 454:	9fb1                	addw	a5,a5,a2
 456:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 45a:	0006c603          	lbu	a2,0(a3)
 45e:	fd06071b          	addiw	a4,a2,-48
 462:	0ff77713          	andi	a4,a4,255
 466:	fee5f1e3          	bgeu	a1,a4,448 <atoi+0x1e>
  return n;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
  n = 0;
 470:	4501                	li	a0,0
 472:	bfe5                	j	46a <atoi+0x40>

0000000000000474 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 474:	1141                	addi	sp,sp,-16
 476:	e422                	sd	s0,8(sp)
 478:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47a:	02c05163          	blez	a2,49c <memmove+0x28>
 47e:	fff6071b          	addiw	a4,a2,-1
 482:	1702                	slli	a4,a4,0x20
 484:	9301                	srli	a4,a4,0x20
 486:	0705                	addi	a4,a4,1
 488:	972a                	add	a4,a4,a0
  dst = vdst;
 48a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 48c:	0585                	addi	a1,a1,1
 48e:	0785                	addi	a5,a5,1
 490:	fff5c683          	lbu	a3,-1(a1)
 494:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 498:	fee79ae3          	bne	a5,a4,48c <memmove+0x18>
  return vdst;
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret

00000000000004a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a2:	4885                	li	a7,1
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 4aa:	4889                	li	a7,2
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b2:	488d                	li	a7,3
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ba:	4891                	li	a7,4
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <read>:
.global read
read:
 li a7, SYS_read
 4c2:	4895                	li	a7,5
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <write>:
.global write
write:
 li a7, SYS_write
 4ca:	48c1                	li	a7,16
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <close>:
.global close
close:
 li a7, SYS_close
 4d2:	48d5                	li	a7,21
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <kill>:
.global kill
kill:
 li a7, SYS_kill
 4da:	4899                	li	a7,6
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e2:	489d                	li	a7,7
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <open>:
.global open
open:
 li a7, SYS_open
 4ea:	48bd                	li	a7,15
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f2:	48c5                	li	a7,17
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4fa:	48c9                	li	a7,18
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 502:	48a1                	li	a7,8
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <link>:
.global link
link:
 li a7, SYS_link
 50a:	48cd                	li	a7,19
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 512:	48d1                	li	a7,20
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 51a:	48a5                	li	a7,9
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <dup>:
.global dup
dup:
 li a7, SYS_dup
 522:	48a9                	li	a7,10
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 52a:	48ad                	li	a7,11
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 532:	48b1                	li	a7,12
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 53a:	48b5                	li	a7,13
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 542:	48b9                	li	a7,14
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 54a:	48d9                	li	a7,22
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <crash>:
.global crash
crash:
 li a7, SYS_crash
 552:	48dd                	li	a7,23
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <mount>:
.global mount
mount:
 li a7, SYS_mount
 55a:	48e1                	li	a7,24
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <umount>:
.global umount
umount:
 li a7, SYS_umount
 562:	48e5                	li	a7,25
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56a:	1101                	addi	sp,sp,-32
 56c:	ec06                	sd	ra,24(sp)
 56e:	e822                	sd	s0,16(sp)
 570:	1000                	addi	s0,sp,32
 572:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 576:	4605                	li	a2,1
 578:	fef40593          	addi	a1,s0,-17
 57c:	00000097          	auipc	ra,0x0
 580:	f4e080e7          	jalr	-178(ra) # 4ca <write>
}
 584:	60e2                	ld	ra,24(sp)
 586:	6442                	ld	s0,16(sp)
 588:	6105                	addi	sp,sp,32
 58a:	8082                	ret

000000000000058c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58c:	7139                	addi	sp,sp,-64
 58e:	fc06                	sd	ra,56(sp)
 590:	f822                	sd	s0,48(sp)
 592:	f426                	sd	s1,40(sp)
 594:	f04a                	sd	s2,32(sp)
 596:	ec4e                	sd	s3,24(sp)
 598:	0080                	addi	s0,sp,64
 59a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59c:	c299                	beqz	a3,5a2 <printint+0x16>
 59e:	0805c863          	bltz	a1,62e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a2:	2581                	sext.w	a1,a1
  neg = 0;
 5a4:	4881                	li	a7,0
 5a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ac:	2601                	sext.w	a2,a2
 5ae:	00000517          	auipc	a0,0x0
 5b2:	54a50513          	addi	a0,a0,1354 # af8 <digits>
 5b6:	883a                	mv	a6,a4
 5b8:	2705                	addiw	a4,a4,1
 5ba:	02c5f7bb          	remuw	a5,a1,a2
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	97aa                	add	a5,a5,a0
 5c4:	0007c783          	lbu	a5,0(a5)
 5c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5cc:	0005879b          	sext.w	a5,a1
 5d0:	02c5d5bb          	divuw	a1,a1,a2
 5d4:	0685                	addi	a3,a3,1
 5d6:	fec7f0e3          	bgeu	a5,a2,5b6 <printint+0x2a>
  if(neg)
 5da:	00088b63          	beqz	a7,5f0 <printint+0x64>
    buf[i++] = '-';
 5de:	fd040793          	addi	a5,s0,-48
 5e2:	973e                	add	a4,a4,a5
 5e4:	02d00793          	li	a5,45
 5e8:	fef70823          	sb	a5,-16(a4)
 5ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f0:	02e05863          	blez	a4,620 <printint+0x94>
 5f4:	fc040793          	addi	a5,s0,-64
 5f8:	00e78933          	add	s2,a5,a4
 5fc:	fff78993          	addi	s3,a5,-1
 600:	99ba                	add	s3,s3,a4
 602:	377d                	addiw	a4,a4,-1
 604:	1702                	slli	a4,a4,0x20
 606:	9301                	srli	a4,a4,0x20
 608:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 60c:	fff94583          	lbu	a1,-1(s2)
 610:	8526                	mv	a0,s1
 612:	00000097          	auipc	ra,0x0
 616:	f58080e7          	jalr	-168(ra) # 56a <putc>
  while(--i >= 0)
 61a:	197d                	addi	s2,s2,-1
 61c:	ff3918e3          	bne	s2,s3,60c <printint+0x80>
}
 620:	70e2                	ld	ra,56(sp)
 622:	7442                	ld	s0,48(sp)
 624:	74a2                	ld	s1,40(sp)
 626:	7902                	ld	s2,32(sp)
 628:	69e2                	ld	s3,24(sp)
 62a:	6121                	addi	sp,sp,64
 62c:	8082                	ret
    x = -xx;
 62e:	40b005bb          	negw	a1,a1
    neg = 1;
 632:	4885                	li	a7,1
    x = -xx;
 634:	bf8d                	j	5a6 <printint+0x1a>

0000000000000636 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 636:	7119                	addi	sp,sp,-128
 638:	fc86                	sd	ra,120(sp)
 63a:	f8a2                	sd	s0,112(sp)
 63c:	f4a6                	sd	s1,104(sp)
 63e:	f0ca                	sd	s2,96(sp)
 640:	ecce                	sd	s3,88(sp)
 642:	e8d2                	sd	s4,80(sp)
 644:	e4d6                	sd	s5,72(sp)
 646:	e0da                	sd	s6,64(sp)
 648:	fc5e                	sd	s7,56(sp)
 64a:	f862                	sd	s8,48(sp)
 64c:	f466                	sd	s9,40(sp)
 64e:	f06a                	sd	s10,32(sp)
 650:	ec6e                	sd	s11,24(sp)
 652:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 654:	0005c903          	lbu	s2,0(a1)
 658:	18090f63          	beqz	s2,7f6 <vprintf+0x1c0>
 65c:	8aaa                	mv	s5,a0
 65e:	8b32                	mv	s6,a2
 660:	00158493          	addi	s1,a1,1
  state = 0;
 664:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 666:	02500a13          	li	s4,37
      if(c == 'd'){
 66a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 66e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 672:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 676:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67a:	00000b97          	auipc	s7,0x0
 67e:	47eb8b93          	addi	s7,s7,1150 # af8 <digits>
 682:	a839                	j	6a0 <vprintf+0x6a>
        putc(fd, c);
 684:	85ca                	mv	a1,s2
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	ee2080e7          	jalr	-286(ra) # 56a <putc>
 690:	a019                	j	696 <vprintf+0x60>
    } else if(state == '%'){
 692:	01498f63          	beq	s3,s4,6b0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 696:	0485                	addi	s1,s1,1
 698:	fff4c903          	lbu	s2,-1(s1)
 69c:	14090d63          	beqz	s2,7f6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6a0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a4:	fe0997e3          	bnez	s3,692 <vprintf+0x5c>
      if(c == '%'){
 6a8:	fd479ee3          	bne	a5,s4,684 <vprintf+0x4e>
        state = '%';
 6ac:	89be                	mv	s3,a5
 6ae:	b7e5                	j	696 <vprintf+0x60>
      if(c == 'd'){
 6b0:	05878063          	beq	a5,s8,6f0 <vprintf+0xba>
      } else if(c == 'l') {
 6b4:	05978c63          	beq	a5,s9,70c <vprintf+0xd6>
      } else if(c == 'x') {
 6b8:	07a78863          	beq	a5,s10,728 <vprintf+0xf2>
      } else if(c == 'p') {
 6bc:	09b78463          	beq	a5,s11,744 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6c0:	07300713          	li	a4,115
 6c4:	0ce78663          	beq	a5,a4,790 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c8:	06300713          	li	a4,99
 6cc:	0ee78e63          	beq	a5,a4,7c8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6d0:	11478863          	beq	a5,s4,7e0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d4:	85d2                	mv	a1,s4
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e92080e7          	jalr	-366(ra) # 56a <putc>
        putc(fd, c);
 6e0:	85ca                	mv	a1,s2
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e86080e7          	jalr	-378(ra) # 56a <putc>
      }
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b765                	j	696 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6f0:	008b0913          	addi	s2,s6,8
 6f4:	4685                	li	a3,1
 6f6:	4629                	li	a2,10
 6f8:	000b2583          	lw	a1,0(s6)
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e8e080e7          	jalr	-370(ra) # 58c <printint>
 706:	8b4a                	mv	s6,s2
      state = 0;
 708:	4981                	li	s3,0
 70a:	b771                	j	696 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	008b0913          	addi	s2,s6,8
 710:	4681                	li	a3,0
 712:	4629                	li	a2,10
 714:	000b2583          	lw	a1,0(s6)
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	e72080e7          	jalr	-398(ra) # 58c <printint>
 722:	8b4a                	mv	s6,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	bf85                	j	696 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 728:	008b0913          	addi	s2,s6,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000b2583          	lw	a1,0(s6)
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	e56080e7          	jalr	-426(ra) # 58c <printint>
 73e:	8b4a                	mv	s6,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bf91                	j	696 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 744:	008b0793          	addi	a5,s6,8
 748:	f8f43423          	sd	a5,-120(s0)
 74c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 750:	03000593          	li	a1,48
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	e14080e7          	jalr	-492(ra) # 56a <putc>
  putc(fd, 'x');
 75e:	85ea                	mv	a1,s10
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	e08080e7          	jalr	-504(ra) # 56a <putc>
 76a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76c:	03c9d793          	srli	a5,s3,0x3c
 770:	97de                	add	a5,a5,s7
 772:	0007c583          	lbu	a1,0(a5)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	df2080e7          	jalr	-526(ra) # 56a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 780:	0992                	slli	s3,s3,0x4
 782:	397d                	addiw	s2,s2,-1
 784:	fe0914e3          	bnez	s2,76c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 788:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b721                	j	696 <vprintf+0x60>
        s = va_arg(ap, char*);
 790:	008b0993          	addi	s3,s6,8
 794:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 798:	02090163          	beqz	s2,7ba <vprintf+0x184>
        while(*s != 0){
 79c:	00094583          	lbu	a1,0(s2)
 7a0:	c9a1                	beqz	a1,7f0 <vprintf+0x1ba>
          putc(fd, *s);
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	dc6080e7          	jalr	-570(ra) # 56a <putc>
          s++;
 7ac:	0905                	addi	s2,s2,1
        while(*s != 0){
 7ae:	00094583          	lbu	a1,0(s2)
 7b2:	f9e5                	bnez	a1,7a2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7b4:	8b4e                	mv	s6,s3
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	bdf9                	j	696 <vprintf+0x60>
          s = "(null)";
 7ba:	00000917          	auipc	s2,0x0
 7be:	33690913          	addi	s2,s2,822 # af0 <malloc+0x1f0>
        while(*s != 0){
 7c2:	02800593          	li	a1,40
 7c6:	bff1                	j	7a2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7c8:	008b0913          	addi	s2,s6,8
 7cc:	000b4583          	lbu	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	d98080e7          	jalr	-616(ra) # 56a <putc>
 7da:	8b4a                	mv	s6,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bd65                	j	696 <vprintf+0x60>
        putc(fd, c);
 7e0:	85d2                	mv	a1,s4
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	d86080e7          	jalr	-634(ra) # 56a <putc>
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b565                	j	696 <vprintf+0x60>
        s = va_arg(ap, char*);
 7f0:	8b4e                	mv	s6,s3
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b54d                	j	696 <vprintf+0x60>
    }
  }
}
 7f6:	70e6                	ld	ra,120(sp)
 7f8:	7446                	ld	s0,112(sp)
 7fa:	74a6                	ld	s1,104(sp)
 7fc:	7906                	ld	s2,96(sp)
 7fe:	69e6                	ld	s3,88(sp)
 800:	6a46                	ld	s4,80(sp)
 802:	6aa6                	ld	s5,72(sp)
 804:	6b06                	ld	s6,64(sp)
 806:	7be2                	ld	s7,56(sp)
 808:	7c42                	ld	s8,48(sp)
 80a:	7ca2                	ld	s9,40(sp)
 80c:	7d02                	ld	s10,32(sp)
 80e:	6de2                	ld	s11,24(sp)
 810:	6109                	addi	sp,sp,128
 812:	8082                	ret

0000000000000814 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 814:	715d                	addi	sp,sp,-80
 816:	ec06                	sd	ra,24(sp)
 818:	e822                	sd	s0,16(sp)
 81a:	1000                	addi	s0,sp,32
 81c:	e010                	sd	a2,0(s0)
 81e:	e414                	sd	a3,8(s0)
 820:	e818                	sd	a4,16(s0)
 822:	ec1c                	sd	a5,24(s0)
 824:	03043023          	sd	a6,32(s0)
 828:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 830:	8622                	mv	a2,s0
 832:	00000097          	auipc	ra,0x0
 836:	e04080e7          	jalr	-508(ra) # 636 <vprintf>
}
 83a:	60e2                	ld	ra,24(sp)
 83c:	6442                	ld	s0,16(sp)
 83e:	6161                	addi	sp,sp,80
 840:	8082                	ret

0000000000000842 <printf>:

void
printf(const char *fmt, ...)
{
 842:	711d                	addi	sp,sp,-96
 844:	ec06                	sd	ra,24(sp)
 846:	e822                	sd	s0,16(sp)
 848:	1000                	addi	s0,sp,32
 84a:	e40c                	sd	a1,8(s0)
 84c:	e810                	sd	a2,16(s0)
 84e:	ec14                	sd	a3,24(s0)
 850:	f018                	sd	a4,32(s0)
 852:	f41c                	sd	a5,40(s0)
 854:	03043823          	sd	a6,48(s0)
 858:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85c:	00840613          	addi	a2,s0,8
 860:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 864:	85aa                	mv	a1,a0
 866:	4505                	li	a0,1
 868:	00000097          	auipc	ra,0x0
 86c:	dce080e7          	jalr	-562(ra) # 636 <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 878:	1141                	addi	sp,sp,-16
 87a:	e422                	sd	s0,8(sp)
 87c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	00000797          	auipc	a5,0x0
 886:	28e7b783          	ld	a5,654(a5) # b10 <freep>
 88a:	a805                	j	8ba <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88c:	4618                	lw	a4,8(a2)
 88e:	9db9                	addw	a1,a1,a4
 890:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	6318                	ld	a4,0(a4)
 898:	fee53823          	sd	a4,-16(a0)
 89c:	a091                	j	8e0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 89e:	ff852703          	lw	a4,-8(a0)
 8a2:	9e39                	addw	a2,a2,a4
 8a4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8a6:	ff053703          	ld	a4,-16(a0)
 8aa:	e398                	sd	a4,0(a5)
 8ac:	a099                	j	8f2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e7e463          	bltu	a5,a4,8b8 <free+0x40>
 8b4:	00e6ea63          	bltu	a3,a4,8c8 <free+0x50>
{
 8b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	fed7fae3          	bgeu	a5,a3,8ae <free+0x36>
 8be:	6398                	ld	a4,0(a5)
 8c0:	00e6e463          	bltu	a3,a4,8c8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c4:	fee7eae3          	bltu	a5,a4,8b8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8c8:	ff852583          	lw	a1,-8(a0)
 8cc:	6390                	ld	a2,0(a5)
 8ce:	02059713          	slli	a4,a1,0x20
 8d2:	9301                	srli	a4,a4,0x20
 8d4:	0712                	slli	a4,a4,0x4
 8d6:	9736                	add	a4,a4,a3
 8d8:	fae60ae3          	beq	a2,a4,88c <free+0x14>
    bp->s.ptr = p->s.ptr;
 8dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e0:	4790                	lw	a2,8(a5)
 8e2:	02061713          	slli	a4,a2,0x20
 8e6:	9301                	srli	a4,a4,0x20
 8e8:	0712                	slli	a4,a4,0x4
 8ea:	973e                	add	a4,a4,a5
 8ec:	fae689e3          	beq	a3,a4,89e <free+0x26>
  } else
    p->s.ptr = bp;
 8f0:	e394                	sd	a3,0(a5)
  freep = p;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	20f73f23          	sd	a5,542(a4) # b10 <freep>
}
 8fa:	6422                	ld	s0,8(sp)
 8fc:	0141                	addi	sp,sp,16
 8fe:	8082                	ret

0000000000000900 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 900:	7139                	addi	sp,sp,-64
 902:	fc06                	sd	ra,56(sp)
 904:	f822                	sd	s0,48(sp)
 906:	f426                	sd	s1,40(sp)
 908:	f04a                	sd	s2,32(sp)
 90a:	ec4e                	sd	s3,24(sp)
 90c:	e852                	sd	s4,16(sp)
 90e:	e456                	sd	s5,8(sp)
 910:	e05a                	sd	s6,0(sp)
 912:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 914:	02051493          	slli	s1,a0,0x20
 918:	9081                	srli	s1,s1,0x20
 91a:	04bd                	addi	s1,s1,15
 91c:	8091                	srli	s1,s1,0x4
 91e:	0014899b          	addiw	s3,s1,1
 922:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 924:	00000517          	auipc	a0,0x0
 928:	1ec53503          	ld	a0,492(a0) # b10 <freep>
 92c:	c515                	beqz	a0,958 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 930:	4798                	lw	a4,8(a5)
 932:	02977f63          	bgeu	a4,s1,970 <malloc+0x70>
 936:	8a4e                	mv	s4,s3
 938:	0009871b          	sext.w	a4,s3
 93c:	6685                	lui	a3,0x1
 93e:	00d77363          	bgeu	a4,a3,944 <malloc+0x44>
 942:	6a05                	lui	s4,0x1
 944:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 948:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94c:	00000917          	auipc	s2,0x0
 950:	1c490913          	addi	s2,s2,452 # b10 <freep>
  if(p == (char*)-1)
 954:	5afd                	li	s5,-1
 956:	a88d                	j	9c8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 958:	00000797          	auipc	a5,0x0
 95c:	1c078793          	addi	a5,a5,448 # b18 <base>
 960:	00000717          	auipc	a4,0x0
 964:	1af73823          	sd	a5,432(a4) # b10 <freep>
 968:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 96e:	b7e1                	j	936 <malloc+0x36>
      if(p->s.size == nunits)
 970:	02e48b63          	beq	s1,a4,9a6 <malloc+0xa6>
        p->s.size -= nunits;
 974:	4137073b          	subw	a4,a4,s3
 978:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97a:	1702                	slli	a4,a4,0x20
 97c:	9301                	srli	a4,a4,0x20
 97e:	0712                	slli	a4,a4,0x4
 980:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 982:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 986:	00000717          	auipc	a4,0x0
 98a:	18a73523          	sd	a0,394(a4) # b10 <freep>
      return (void*)(p + 1);
 98e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 992:	70e2                	ld	ra,56(sp)
 994:	7442                	ld	s0,48(sp)
 996:	74a2                	ld	s1,40(sp)
 998:	7902                	ld	s2,32(sp)
 99a:	69e2                	ld	s3,24(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
 9a2:	6121                	addi	sp,sp,64
 9a4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9a6:	6398                	ld	a4,0(a5)
 9a8:	e118                	sd	a4,0(a0)
 9aa:	bff1                	j	986 <malloc+0x86>
  hp->s.size = nu;
 9ac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b0:	0541                	addi	a0,a0,16
 9b2:	00000097          	auipc	ra,0x0
 9b6:	ec6080e7          	jalr	-314(ra) # 878 <free>
  return freep;
 9ba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9be:	d971                	beqz	a0,992 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c2:	4798                	lw	a4,8(a5)
 9c4:	fa9776e3          	bgeu	a4,s1,970 <malloc+0x70>
    if(p == freep)
 9c8:	00093703          	ld	a4,0(s2)
 9cc:	853e                	mv	a0,a5
 9ce:	fef719e3          	bne	a4,a5,9c0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9d2:	8552                	mv	a0,s4
 9d4:	00000097          	auipc	ra,0x0
 9d8:	b5e080e7          	jalr	-1186(ra) # 532 <sbrk>
  if(p == (char*)-1)
 9dc:	fd5518e3          	bne	a0,s5,9ac <malloc+0xac>
        return 0;
 9e0:	4501                	li	a0,0
 9e2:	bf45                	j	992 <malloc+0x92>
