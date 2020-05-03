
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test1();
  exit(0);
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n = 0;
  printf("start test0\n");  
   e:	00001517          	auipc	a0,0x1
  12:	a6a50513          	addi	a0,a0,-1430 # a78 <malloc+0xe8>
  16:	00001097          	auipc	ra,0x1
  1a:	8bc080e7          	jalr	-1860(ra) # 8d2 <printf>
  ntas(0);
  1e:	4501                	li	a0,0
  20:	00000097          	auipc	ra,0x0
  24:	5d2080e7          	jalr	1490(ra) # 5f2 <ntas>
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  28:	00000097          	auipc	ra,0x0
  2c:	522080e7          	jalr	1314(ra) # 54a <fork>
    if(pid < 0){
  30:	06054363          	bltz	a0,96 <test0+0x96>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  34:	cd35                	beqz	a0,b0 <test0+0xb0>
    int pid = fork();
  36:	00000097          	auipc	ra,0x0
  3a:	514080e7          	jalr	1300(ra) # 54a <fork>
    if(pid < 0){
  3e:	04054c63          	bltz	a0,96 <test0+0x96>
    if(pid == 0){
  42:	c53d                	beqz	a0,b0 <test0+0xb0>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  44:	4501                	li	a0,0
  46:	00000097          	auipc	ra,0x0
  4a:	514080e7          	jalr	1300(ra) # 55a <wait>
  4e:	4501                	li	a0,0
  50:	00000097          	auipc	ra,0x0
  54:	50a080e7          	jalr	1290(ra) # 55a <wait>
  }
  printf("test0 results:\n");
  58:	00001517          	auipc	a0,0x1
  5c:	a5050513          	addi	a0,a0,-1456 # aa8 <malloc+0x118>
  60:	00001097          	auipc	ra,0x1
  64:	872080e7          	jalr	-1934(ra) # 8d2 <printf>
  n = ntas(1);
  68:	4505                	li	a0,1
  6a:	00000097          	auipc	ra,0x0
  6e:	588080e7          	jalr	1416(ra) # 5f2 <ntas>
  if(n < 10) 
  72:	47a5                	li	a5,9
  74:	08a7c863          	blt	a5,a0,104 <test0+0x104>
    printf("test0 OK\n");
  78:	00001517          	auipc	a0,0x1
  7c:	a4050513          	addi	a0,a0,-1472 # ab8 <malloc+0x128>
  80:	00001097          	auipc	ra,0x1
  84:	852080e7          	jalr	-1966(ra) # 8d2 <printf>
  else
    printf("test0 FAIL\n");
}
  88:	70a2                	ld	ra,40(sp)
  8a:	7402                	ld	s0,32(sp)
  8c:	64e2                	ld	s1,24(sp)
  8e:	6942                	ld	s2,16(sp)
  90:	69a2                	ld	s3,8(sp)
  92:	6145                	addi	sp,sp,48
  94:	8082                	ret
      printf("fork failed");
  96:	00001517          	auipc	a0,0x1
  9a:	9f250513          	addi	a0,a0,-1550 # a88 <malloc+0xf8>
  9e:	00001097          	auipc	ra,0x1
  a2:	834080e7          	jalr	-1996(ra) # 8d2 <printf>
      exit(-1);
  a6:	557d                	li	a0,-1
  a8:	00000097          	auipc	ra,0x0
  ac:	4aa080e7          	jalr	1194(ra) # 552 <exit>
{
  b0:	6961                	lui	s2,0x18
  b2:	6a090913          	addi	s2,s2,1696 # 186a0 <__global_pointer$+0x172ff>
        *(int *)(a+4) = 1;
  b6:	4985                	li	s3,1
        a = sbrk(4096);
  b8:	6505                	lui	a0,0x1
  ba:	00000097          	auipc	ra,0x0
  be:	520080e7          	jalr	1312(ra) # 5da <sbrk>
  c2:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
  c4:	01352223          	sw	s3,4(a0) # 1004 <__BSS_END__+0x444>
        a1 = sbrk(-4096);
  c8:	757d                	lui	a0,0xfffff
  ca:	00000097          	auipc	ra,0x0
  ce:	510080e7          	jalr	1296(ra) # 5da <sbrk>
        if (a1 != a + 4096) {
  d2:	6785                	lui	a5,0x1
  d4:	94be                	add	s1,s1,a5
  d6:	00951a63          	bne	a0,s1,ea <test0+0xea>
      for(i = 0; i < N; i++) {
  da:	397d                	addiw	s2,s2,-1
  dc:	fc091ee3          	bnez	s2,b8 <test0+0xb8>
      exit(-1);
  e0:	557d                	li	a0,-1
  e2:	00000097          	auipc	ra,0x0
  e6:	470080e7          	jalr	1136(ra) # 552 <exit>
          printf("wrong sbrk\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	9ae50513          	addi	a0,a0,-1618 # a98 <malloc+0x108>
  f2:	00000097          	auipc	ra,0x0
  f6:	7e0080e7          	jalr	2016(ra) # 8d2 <printf>
          exit(-1);
  fa:	557d                	li	a0,-1
  fc:	00000097          	auipc	ra,0x0
 100:	456080e7          	jalr	1110(ra) # 552 <exit>
    printf("test0 FAIL\n");
 104:	00001517          	auipc	a0,0x1
 108:	9c450513          	addi	a0,a0,-1596 # ac8 <malloc+0x138>
 10c:	00000097          	auipc	ra,0x0
 110:	7c6080e7          	jalr	1990(ra) # 8d2 <printf>
}
 114:	bf95                	j	88 <test0+0x88>

0000000000000116 <test1>:

// Run system out of memory and count tot memory allocated
void test1()
{
 116:	715d                	addi	sp,sp,-80
 118:	e486                	sd	ra,72(sp)
 11a:	e0a2                	sd	s0,64(sp)
 11c:	fc26                	sd	s1,56(sp)
 11e:	f84a                	sd	s2,48(sp)
 120:	f44e                	sd	s3,40(sp)
 122:	0880                	addi	s0,sp,80
  void *a;
  int pipes[NCHILD];
  int tot = 0;
  char buf[1];
  
  printf("start test1\n");  
 124:	00001517          	auipc	a0,0x1
 128:	9b450513          	addi	a0,a0,-1612 # ad8 <malloc+0x148>
 12c:	00000097          	auipc	ra,0x0
 130:	7a6080e7          	jalr	1958(ra) # 8d2 <printf>
  for(int i = 0; i < NCHILD; i++){
 134:	fc840913          	addi	s2,s0,-56
    int fds[2];
    if(pipe(fds) != 0){
 138:	fb840513          	addi	a0,s0,-72
 13c:	00000097          	auipc	ra,0x0
 140:	426080e7          	jalr	1062(ra) # 562 <pipe>
 144:	84aa                	mv	s1,a0
 146:	e905                	bnez	a0,176 <test1+0x60>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 148:	00000097          	auipc	ra,0x0
 14c:	402080e7          	jalr	1026(ra) # 54a <fork>
    if(pid < 0){
 150:	04054063          	bltz	a0,190 <test1+0x7a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 154:	c939                	beqz	a0,1aa <test1+0x94>
          exit(-1);
        }
      }
      exit(0);
    } else {
      close(fds[1]);
 156:	fbc42503          	lw	a0,-68(s0)
 15a:	00000097          	auipc	ra,0x0
 15e:	420080e7          	jalr	1056(ra) # 57a <close>
      pipes[i] = fds[0];
 162:	fb842783          	lw	a5,-72(s0)
 166:	00f92023          	sw	a5,0(s2)
  for(int i = 0; i < NCHILD; i++){
 16a:	0911                	addi	s2,s2,4
 16c:	fd040793          	addi	a5,s0,-48
 170:	fd2794e3          	bne	a5,s2,138 <test1+0x22>
 174:	a865                	j	22c <test1+0x116>
      printf("pipe() failed\n");
 176:	00001517          	auipc	a0,0x1
 17a:	97250513          	addi	a0,a0,-1678 # ae8 <malloc+0x158>
 17e:	00000097          	auipc	ra,0x0
 182:	754080e7          	jalr	1876(ra) # 8d2 <printf>
      exit(-1);
 186:	557d                	li	a0,-1
 188:	00000097          	auipc	ra,0x0
 18c:	3ca080e7          	jalr	970(ra) # 552 <exit>
      printf("fork failed");
 190:	00001517          	auipc	a0,0x1
 194:	8f850513          	addi	a0,a0,-1800 # a88 <malloc+0xf8>
 198:	00000097          	auipc	ra,0x0
 19c:	73a080e7          	jalr	1850(ra) # 8d2 <printf>
      exit(-1);
 1a0:	557d                	li	a0,-1
 1a2:	00000097          	auipc	ra,0x0
 1a6:	3b0080e7          	jalr	944(ra) # 552 <exit>
      close(fds[0]);
 1aa:	fb842503          	lw	a0,-72(s0)
 1ae:	00000097          	auipc	ra,0x0
 1b2:	3cc080e7          	jalr	972(ra) # 57a <close>
 1b6:	64e1                	lui	s1,0x18
 1b8:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x172ff>
        *(int *)(a+4) = 1;
 1bc:	4985                	li	s3,1
        if (write(fds[1], "x", 1) != 1) {
 1be:	00001917          	auipc	s2,0x1
 1c2:	93a90913          	addi	s2,s2,-1734 # af8 <malloc+0x168>
        a = sbrk(PGSIZE);
 1c6:	6505                	lui	a0,0x1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	412080e7          	jalr	1042(ra) # 5da <sbrk>
        *(int *)(a+4) = 1;
 1d0:	01352223          	sw	s3,4(a0) # 1004 <__BSS_END__+0x444>
        if (write(fds[1], "x", 1) != 1) {
 1d4:	4605                	li	a2,1
 1d6:	85ca                	mv	a1,s2
 1d8:	fbc42503          	lw	a0,-68(s0)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	396080e7          	jalr	918(ra) # 572 <write>
 1e4:	4785                	li	a5,1
 1e6:	00f51963          	bne	a0,a5,1f8 <test1+0xe2>
      for(i = 0; i < N; i++) {
 1ea:	34fd                	addiw	s1,s1,-1
 1ec:	fce9                	bnez	s1,1c6 <test1+0xb0>
      exit(0);
 1ee:	4501                	li	a0,0
 1f0:	00000097          	auipc	ra,0x0
 1f4:	362080e7          	jalr	866(ra) # 552 <exit>
          printf("write failed");
 1f8:	00001517          	auipc	a0,0x1
 1fc:	90850513          	addi	a0,a0,-1784 # b00 <malloc+0x170>
 200:	00000097          	auipc	ra,0x0
 204:	6d2080e7          	jalr	1746(ra) # 8d2 <printf>
          exit(-1);
 208:	557d                	li	a0,-1
 20a:	00000097          	auipc	ra,0x0
 20e:	348080e7          	jalr	840(ra) # 552 <exit>
  int stop = 0;
  while (!stop) {
    stop = 1;
    for(int i = 0; i < NCHILD; i++){
      if (read(pipes[i], buf, 1) == 1) {
        tot += 1;
 212:	2485                	addiw	s1,s1,1
      if (read(pipes[i], buf, 1) == 1) {
 214:	4605                	li	a2,1
 216:	fc040593          	addi	a1,s0,-64
 21a:	fcc42503          	lw	a0,-52(s0)
 21e:	00000097          	auipc	ra,0x0
 222:	34c080e7          	jalr	844(ra) # 56a <read>
 226:	4785                	li	a5,1
 228:	02f50a63          	beq	a0,a5,25c <test1+0x146>
 22c:	4605                	li	a2,1
 22e:	fc040593          	addi	a1,s0,-64
 232:	fc842503          	lw	a0,-56(s0)
 236:	00000097          	auipc	ra,0x0
 23a:	334080e7          	jalr	820(ra) # 56a <read>
 23e:	4785                	li	a5,1
 240:	fcf509e3          	beq	a0,a5,212 <test1+0xfc>
 244:	4605                	li	a2,1
 246:	fc040593          	addi	a1,s0,-64
 24a:	fcc42503          	lw	a0,-52(s0)
 24e:	00000097          	auipc	ra,0x0
 252:	31c080e7          	jalr	796(ra) # 56a <read>
 256:	4785                	li	a5,1
 258:	02f51163          	bne	a0,a5,27a <test1+0x164>
        tot += 1;
 25c:	2485                	addiw	s1,s1,1
  while (!stop) {
 25e:	b7f9                	j	22c <test1+0x116>
    }
  }
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
  if(n - tot > 1000) {
    printf("test1 FAILED: cannot allocate enough memory");
 260:	00001517          	auipc	a0,0x1
 264:	8b050513          	addi	a0,a0,-1872 # b10 <malloc+0x180>
 268:	00000097          	auipc	ra,0x0
 26c:	66a080e7          	jalr	1642(ra) # 8d2 <printf>
    exit(-1);
 270:	557d                	li	a0,-1
 272:	00000097          	auipc	ra,0x0
 276:	2e0080e7          	jalr	736(ra) # 552 <exit>
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
 27a:	6621                	lui	a2,0x8
 27c:	85a6                	mv	a1,s1
 27e:	00001517          	auipc	a0,0x1
 282:	8d250513          	addi	a0,a0,-1838 # b50 <malloc+0x1c0>
 286:	00000097          	auipc	ra,0x0
 28a:	64c080e7          	jalr	1612(ra) # 8d2 <printf>
  if(n - tot > 1000) {
 28e:	67a1                	lui	a5,0x8
 290:	409784bb          	subw	s1,a5,s1
 294:	3e800793          	li	a5,1000
 298:	fc97c4e3          	blt	a5,s1,260 <test1+0x14a>
  }
  printf("test1 OK\n");  
 29c:	00001517          	auipc	a0,0x1
 2a0:	8a450513          	addi	a0,a0,-1884 # b40 <malloc+0x1b0>
 2a4:	00000097          	auipc	ra,0x0
 2a8:	62e080e7          	jalr	1582(ra) # 8d2 <printf>
}
 2ac:	60a6                	ld	ra,72(sp)
 2ae:	6406                	ld	s0,64(sp)
 2b0:	74e2                	ld	s1,56(sp)
 2b2:	7942                	ld	s2,48(sp)
 2b4:	79a2                	ld	s3,40(sp)
 2b6:	6161                	addi	sp,sp,80
 2b8:	8082                	ret

00000000000002ba <main>:
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  test0();
 2c2:	00000097          	auipc	ra,0x0
 2c6:	d3e080e7          	jalr	-706(ra) # 0 <test0>
  test1();
 2ca:	00000097          	auipc	ra,0x0
 2ce:	e4c080e7          	jalr	-436(ra) # 116 <test1>
  exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	27e080e7          	jalr	638(ra) # 552 <exit>

00000000000002dc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e2:	87aa                	mv	a5,a0
 2e4:	0585                	addi	a1,a1,1
 2e6:	0785                	addi	a5,a5,1
 2e8:	fff5c703          	lbu	a4,-1(a1)
 2ec:	fee78fa3          	sb	a4,-1(a5) # 7fff <__global_pointer$+0x6c5e>
 2f0:	fb75                	bnez	a4,2e4 <strcpy+0x8>
    ;
  return os;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fe:	00054783          	lbu	a5,0(a0)
 302:	cb91                	beqz	a5,316 <strcmp+0x1e>
 304:	0005c703          	lbu	a4,0(a1)
 308:	00f71763          	bne	a4,a5,316 <strcmp+0x1e>
    p++, q++;
 30c:	0505                	addi	a0,a0,1
 30e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 310:	00054783          	lbu	a5,0(a0)
 314:	fbe5                	bnez	a5,304 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 316:	0005c503          	lbu	a0,0(a1)
}
 31a:	40a7853b          	subw	a0,a5,a0
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <strlen>:

uint
strlen(const char *s)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	cf91                	beqz	a5,34a <strlen+0x26>
 330:	0505                	addi	a0,a0,1
 332:	87aa                	mv	a5,a0
 334:	4685                	li	a3,1
 336:	9e89                	subw	a3,a3,a0
 338:	00f6853b          	addw	a0,a3,a5
 33c:	0785                	addi	a5,a5,1
 33e:	fff7c703          	lbu	a4,-1(a5)
 342:	fb7d                	bnez	a4,338 <strlen+0x14>
    ;
  return n;
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
  for(n = 0; s[n]; n++)
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <strlen+0x20>

000000000000034e <memset>:

void*
memset(void *dst, int c, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 354:	ce09                	beqz	a2,36e <memset+0x20>
 356:	87aa                	mv	a5,a0
 358:	fff6071b          	addiw	a4,a2,-1
 35c:	1702                	slli	a4,a4,0x20
 35e:	9301                	srli	a4,a4,0x20
 360:	0705                	addi	a4,a4,1
 362:	972a                	add	a4,a4,a0
    cdst[i] = c;
 364:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 368:	0785                	addi	a5,a5,1
 36a:	fee79de3          	bne	a5,a4,364 <memset+0x16>
  }
  return dst;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <strchr>:

char*
strchr(const char *s, char c)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  for(; *s; s++)
 37a:	00054783          	lbu	a5,0(a0)
 37e:	cb99                	beqz	a5,394 <strchr+0x20>
    if(*s == c)
 380:	00f58763          	beq	a1,a5,38e <strchr+0x1a>
  for(; *s; s++)
 384:	0505                	addi	a0,a0,1
 386:	00054783          	lbu	a5,0(a0)
 38a:	fbfd                	bnez	a5,380 <strchr+0xc>
      return (char*)s;
  return 0;
 38c:	4501                	li	a0,0
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
  return 0;
 394:	4501                	li	a0,0
 396:	bfe5                	j	38e <strchr+0x1a>

0000000000000398 <gets>:

char*
gets(char *buf, int max)
{
 398:	711d                	addi	sp,sp,-96
 39a:	ec86                	sd	ra,88(sp)
 39c:	e8a2                	sd	s0,80(sp)
 39e:	e4a6                	sd	s1,72(sp)
 3a0:	e0ca                	sd	s2,64(sp)
 3a2:	fc4e                	sd	s3,56(sp)
 3a4:	f852                	sd	s4,48(sp)
 3a6:	f456                	sd	s5,40(sp)
 3a8:	f05a                	sd	s6,32(sp)
 3aa:	ec5e                	sd	s7,24(sp)
 3ac:	1080                	addi	s0,sp,96
 3ae:	8baa                	mv	s7,a0
 3b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b2:	892a                	mv	s2,a0
 3b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3b6:	4aa9                	li	s5,10
 3b8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ba:	89a6                	mv	s3,s1
 3bc:	2485                	addiw	s1,s1,1
 3be:	0344d863          	bge	s1,s4,3ee <gets+0x56>
    cc = read(0, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	faf40593          	addi	a1,s0,-81
 3c8:	4501                	li	a0,0
 3ca:	00000097          	auipc	ra,0x0
 3ce:	1a0080e7          	jalr	416(ra) # 56a <read>
    if(cc < 1)
 3d2:	00a05e63          	blez	a0,3ee <gets+0x56>
    buf[i++] = c;
 3d6:	faf44783          	lbu	a5,-81(s0)
 3da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3de:	01578763          	beq	a5,s5,3ec <gets+0x54>
 3e2:	0905                	addi	s2,s2,1
 3e4:	fd679be3          	bne	a5,s6,3ba <gets+0x22>
  for(i=0; i+1 < max; ){
 3e8:	89a6                	mv	s3,s1
 3ea:	a011                	j	3ee <gets+0x56>
 3ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ee:	99de                	add	s3,s3,s7
 3f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 3f4:	855e                	mv	a0,s7
 3f6:	60e6                	ld	ra,88(sp)
 3f8:	6446                	ld	s0,80(sp)
 3fa:	64a6                	ld	s1,72(sp)
 3fc:	6906                	ld	s2,64(sp)
 3fe:	79e2                	ld	s3,56(sp)
 400:	7a42                	ld	s4,48(sp)
 402:	7aa2                	ld	s5,40(sp)
 404:	7b02                	ld	s6,32(sp)
 406:	6be2                	ld	s7,24(sp)
 408:	6125                	addi	sp,sp,96
 40a:	8082                	ret

000000000000040c <stat>:

int
stat(const char *n, struct stat *st)
{
 40c:	1101                	addi	sp,sp,-32
 40e:	ec06                	sd	ra,24(sp)
 410:	e822                	sd	s0,16(sp)
 412:	e426                	sd	s1,8(sp)
 414:	e04a                	sd	s2,0(sp)
 416:	1000                	addi	s0,sp,32
 418:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41a:	4581                	li	a1,0
 41c:	00000097          	auipc	ra,0x0
 420:	176080e7          	jalr	374(ra) # 592 <open>
  if(fd < 0)
 424:	02054563          	bltz	a0,44e <stat+0x42>
 428:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 42a:	85ca                	mv	a1,s2
 42c:	00000097          	auipc	ra,0x0
 430:	17e080e7          	jalr	382(ra) # 5aa <fstat>
 434:	892a                	mv	s2,a0
  close(fd);
 436:	8526                	mv	a0,s1
 438:	00000097          	auipc	ra,0x0
 43c:	142080e7          	jalr	322(ra) # 57a <close>
  return r;
}
 440:	854a                	mv	a0,s2
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	64a2                	ld	s1,8(sp)
 448:	6902                	ld	s2,0(sp)
 44a:	6105                	addi	sp,sp,32
 44c:	8082                	ret
    return -1;
 44e:	597d                	li	s2,-1
 450:	bfc5                	j	440 <stat+0x34>

0000000000000452 <atoi>:

int
atoi(const char *s)
{
 452:	1141                	addi	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 458:	00054603          	lbu	a2,0(a0)
 45c:	fd06079b          	addiw	a5,a2,-48
 460:	0ff7f793          	andi	a5,a5,255
 464:	4725                	li	a4,9
 466:	02f76963          	bltu	a4,a5,498 <atoi+0x46>
 46a:	86aa                	mv	a3,a0
  n = 0;
 46c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 46e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 470:	0685                	addi	a3,a3,1
 472:	0025179b          	slliw	a5,a0,0x2
 476:	9fa9                	addw	a5,a5,a0
 478:	0017979b          	slliw	a5,a5,0x1
 47c:	9fb1                	addw	a5,a5,a2
 47e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 482:	0006c603          	lbu	a2,0(a3)
 486:	fd06071b          	addiw	a4,a2,-48
 48a:	0ff77713          	andi	a4,a4,255
 48e:	fee5f1e3          	bgeu	a1,a4,470 <atoi+0x1e>
  return n;
}
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret
  n = 0;
 498:	4501                	li	a0,0
 49a:	bfe5                	j	492 <atoi+0x40>

000000000000049c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e422                	sd	s0,8(sp)
 4a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4a2:	02b57663          	bgeu	a0,a1,4ce <memmove+0x32>
    while(n-- > 0)
 4a6:	02c05163          	blez	a2,4c8 <memmove+0x2c>
 4aa:	fff6079b          	addiw	a5,a2,-1
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	0785                	addi	a5,a5,1
 4b4:	97aa                	add	a5,a5,a0
  dst = vdst;
 4b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4b8:	0585                	addi	a1,a1,1
 4ba:	0705                	addi	a4,a4,1
 4bc:	fff5c683          	lbu	a3,-1(a1)
 4c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4c4:	fee79ae3          	bne	a5,a4,4b8 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4c8:	6422                	ld	s0,8(sp)
 4ca:	0141                	addi	sp,sp,16
 4cc:	8082                	ret
    dst += n;
 4ce:	00c50733          	add	a4,a0,a2
    src += n;
 4d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4d4:	fec05ae3          	blez	a2,4c8 <memmove+0x2c>
 4d8:	fff6079b          	addiw	a5,a2,-1
 4dc:	1782                	slli	a5,a5,0x20
 4de:	9381                	srli	a5,a5,0x20
 4e0:	fff7c793          	not	a5,a5
 4e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4e6:	15fd                	addi	a1,a1,-1
 4e8:	177d                	addi	a4,a4,-1
 4ea:	0005c683          	lbu	a3,0(a1)
 4ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4f2:	fee79ae3          	bne	a5,a4,4e6 <memmove+0x4a>
 4f6:	bfc9                	j	4c8 <memmove+0x2c>

00000000000004f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4f8:	1141                	addi	sp,sp,-16
 4fa:	e422                	sd	s0,8(sp)
 4fc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4fe:	ca05                	beqz	a2,52e <memcmp+0x36>
 500:	fff6069b          	addiw	a3,a2,-1
 504:	1682                	slli	a3,a3,0x20
 506:	9281                	srli	a3,a3,0x20
 508:	0685                	addi	a3,a3,1
 50a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 50c:	00054783          	lbu	a5,0(a0)
 510:	0005c703          	lbu	a4,0(a1)
 514:	00e79863          	bne	a5,a4,524 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 518:	0505                	addi	a0,a0,1
    p2++;
 51a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 51c:	fed518e3          	bne	a0,a3,50c <memcmp+0x14>
  }
  return 0;
 520:	4501                	li	a0,0
 522:	a019                	j	528 <memcmp+0x30>
      return *p1 - *p2;
 524:	40e7853b          	subw	a0,a5,a4
}
 528:	6422                	ld	s0,8(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
  return 0;
 52e:	4501                	li	a0,0
 530:	bfe5                	j	528 <memcmp+0x30>

0000000000000532 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 532:	1141                	addi	sp,sp,-16
 534:	e406                	sd	ra,8(sp)
 536:	e022                	sd	s0,0(sp)
 538:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 53a:	00000097          	auipc	ra,0x0
 53e:	f62080e7          	jalr	-158(ra) # 49c <memmove>
}
 542:	60a2                	ld	ra,8(sp)
 544:	6402                	ld	s0,0(sp)
 546:	0141                	addi	sp,sp,16
 548:	8082                	ret

000000000000054a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 54a:	4885                	li	a7,1
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <exit>:
.global exit
exit:
 li a7, SYS_exit
 552:	4889                	li	a7,2
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <wait>:
.global wait
wait:
 li a7, SYS_wait
 55a:	488d                	li	a7,3
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 562:	4891                	li	a7,4
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <read>:
.global read
read:
 li a7, SYS_read
 56a:	4895                	li	a7,5
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <write>:
.global write
write:
 li a7, SYS_write
 572:	48c1                	li	a7,16
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <close>:
.global close
close:
 li a7, SYS_close
 57a:	48d5                	li	a7,21
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <kill>:
.global kill
kill:
 li a7, SYS_kill
 582:	4899                	li	a7,6
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <exec>:
.global exec
exec:
 li a7, SYS_exec
 58a:	489d                	li	a7,7
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <open>:
.global open
open:
 li a7, SYS_open
 592:	48bd                	li	a7,15
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 59a:	48c5                	li	a7,17
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a2:	48c9                	li	a7,18
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5aa:	48a1                	li	a7,8
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <link>:
.global link
link:
 li a7, SYS_link
 5b2:	48cd                	li	a7,19
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ba:	48d1                	li	a7,20
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c2:	48a5                	li	a7,9
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ca:	48a9                	li	a7,10
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d2:	48ad                	li	a7,11
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5da:	48b1                	li	a7,12
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e2:	48b5                	li	a7,13
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ea:	48b9                	li	a7,14
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 5f2:	48d9                	li	a7,22
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5fa:	1101                	addi	sp,sp,-32
 5fc:	ec06                	sd	ra,24(sp)
 5fe:	e822                	sd	s0,16(sp)
 600:	1000                	addi	s0,sp,32
 602:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 606:	4605                	li	a2,1
 608:	fef40593          	addi	a1,s0,-17
 60c:	00000097          	auipc	ra,0x0
 610:	f66080e7          	jalr	-154(ra) # 572 <write>
}
 614:	60e2                	ld	ra,24(sp)
 616:	6442                	ld	s0,16(sp)
 618:	6105                	addi	sp,sp,32
 61a:	8082                	ret

000000000000061c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61c:	7139                	addi	sp,sp,-64
 61e:	fc06                	sd	ra,56(sp)
 620:	f822                	sd	s0,48(sp)
 622:	f426                	sd	s1,40(sp)
 624:	f04a                	sd	s2,32(sp)
 626:	ec4e                	sd	s3,24(sp)
 628:	0080                	addi	s0,sp,64
 62a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 62c:	c299                	beqz	a3,632 <printint+0x16>
 62e:	0805c863          	bltz	a1,6be <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 632:	2581                	sext.w	a1,a1
  neg = 0;
 634:	4881                	li	a7,0
 636:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 63a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 63c:	2601                	sext.w	a2,a2
 63e:	00000517          	auipc	a0,0x0
 642:	55250513          	addi	a0,a0,1362 # b90 <digits>
 646:	883a                	mv	a6,a4
 648:	2705                	addiw	a4,a4,1
 64a:	02c5f7bb          	remuw	a5,a1,a2
 64e:	1782                	slli	a5,a5,0x20
 650:	9381                	srli	a5,a5,0x20
 652:	97aa                	add	a5,a5,a0
 654:	0007c783          	lbu	a5,0(a5)
 658:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 65c:	0005879b          	sext.w	a5,a1
 660:	02c5d5bb          	divuw	a1,a1,a2
 664:	0685                	addi	a3,a3,1
 666:	fec7f0e3          	bgeu	a5,a2,646 <printint+0x2a>
  if(neg)
 66a:	00088b63          	beqz	a7,680 <printint+0x64>
    buf[i++] = '-';
 66e:	fd040793          	addi	a5,s0,-48
 672:	973e                	add	a4,a4,a5
 674:	02d00793          	li	a5,45
 678:	fef70823          	sb	a5,-16(a4)
 67c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 680:	02e05863          	blez	a4,6b0 <printint+0x94>
 684:	fc040793          	addi	a5,s0,-64
 688:	00e78933          	add	s2,a5,a4
 68c:	fff78993          	addi	s3,a5,-1
 690:	99ba                	add	s3,s3,a4
 692:	377d                	addiw	a4,a4,-1
 694:	1702                	slli	a4,a4,0x20
 696:	9301                	srli	a4,a4,0x20
 698:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 69c:	fff94583          	lbu	a1,-1(s2)
 6a0:	8526                	mv	a0,s1
 6a2:	00000097          	auipc	ra,0x0
 6a6:	f58080e7          	jalr	-168(ra) # 5fa <putc>
  while(--i >= 0)
 6aa:	197d                	addi	s2,s2,-1
 6ac:	ff3918e3          	bne	s2,s3,69c <printint+0x80>
}
 6b0:	70e2                	ld	ra,56(sp)
 6b2:	7442                	ld	s0,48(sp)
 6b4:	74a2                	ld	s1,40(sp)
 6b6:	7902                	ld	s2,32(sp)
 6b8:	69e2                	ld	s3,24(sp)
 6ba:	6121                	addi	sp,sp,64
 6bc:	8082                	ret
    x = -xx;
 6be:	40b005bb          	negw	a1,a1
    neg = 1;
 6c2:	4885                	li	a7,1
    x = -xx;
 6c4:	bf8d                	j	636 <printint+0x1a>

00000000000006c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c6:	7119                	addi	sp,sp,-128
 6c8:	fc86                	sd	ra,120(sp)
 6ca:	f8a2                	sd	s0,112(sp)
 6cc:	f4a6                	sd	s1,104(sp)
 6ce:	f0ca                	sd	s2,96(sp)
 6d0:	ecce                	sd	s3,88(sp)
 6d2:	e8d2                	sd	s4,80(sp)
 6d4:	e4d6                	sd	s5,72(sp)
 6d6:	e0da                	sd	s6,64(sp)
 6d8:	fc5e                	sd	s7,56(sp)
 6da:	f862                	sd	s8,48(sp)
 6dc:	f466                	sd	s9,40(sp)
 6de:	f06a                	sd	s10,32(sp)
 6e0:	ec6e                	sd	s11,24(sp)
 6e2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e4:	0005c903          	lbu	s2,0(a1)
 6e8:	18090f63          	beqz	s2,886 <vprintf+0x1c0>
 6ec:	8aaa                	mv	s5,a0
 6ee:	8b32                	mv	s6,a2
 6f0:	00158493          	addi	s1,a1,1
  state = 0;
 6f4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6f6:	02500a13          	li	s4,37
      if(c == 'd'){
 6fa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6fe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 702:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 706:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70a:	00000b97          	auipc	s7,0x0
 70e:	486b8b93          	addi	s7,s7,1158 # b90 <digits>
 712:	a839                	j	730 <vprintf+0x6a>
        putc(fd, c);
 714:	85ca                	mv	a1,s2
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	ee2080e7          	jalr	-286(ra) # 5fa <putc>
 720:	a019                	j	726 <vprintf+0x60>
    } else if(state == '%'){
 722:	01498f63          	beq	s3,s4,740 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 726:	0485                	addi	s1,s1,1
 728:	fff4c903          	lbu	s2,-1(s1)
 72c:	14090d63          	beqz	s2,886 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 730:	0009079b          	sext.w	a5,s2
    if(state == 0){
 734:	fe0997e3          	bnez	s3,722 <vprintf+0x5c>
      if(c == '%'){
 738:	fd479ee3          	bne	a5,s4,714 <vprintf+0x4e>
        state = '%';
 73c:	89be                	mv	s3,a5
 73e:	b7e5                	j	726 <vprintf+0x60>
      if(c == 'd'){
 740:	05878063          	beq	a5,s8,780 <vprintf+0xba>
      } else if(c == 'l') {
 744:	05978c63          	beq	a5,s9,79c <vprintf+0xd6>
      } else if(c == 'x') {
 748:	07a78863          	beq	a5,s10,7b8 <vprintf+0xf2>
      } else if(c == 'p') {
 74c:	09b78463          	beq	a5,s11,7d4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 750:	07300713          	li	a4,115
 754:	0ce78663          	beq	a5,a4,820 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 758:	06300713          	li	a4,99
 75c:	0ee78e63          	beq	a5,a4,858 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 760:	11478863          	beq	a5,s4,870 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 764:	85d2                	mv	a1,s4
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	e92080e7          	jalr	-366(ra) # 5fa <putc>
        putc(fd, c);
 770:	85ca                	mv	a1,s2
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	e86080e7          	jalr	-378(ra) # 5fa <putc>
      }
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b765                	j	726 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 780:	008b0913          	addi	s2,s6,8
 784:	4685                	li	a3,1
 786:	4629                	li	a2,10
 788:	000b2583          	lw	a1,0(s6)
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	e8e080e7          	jalr	-370(ra) # 61c <printint>
 796:	8b4a                	mv	s6,s2
      state = 0;
 798:	4981                	li	s3,0
 79a:	b771                	j	726 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79c:	008b0913          	addi	s2,s6,8
 7a0:	4681                	li	a3,0
 7a2:	4629                	li	a2,10
 7a4:	000b2583          	lw	a1,0(s6)
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e72080e7          	jalr	-398(ra) # 61c <printint>
 7b2:	8b4a                	mv	s6,s2
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	bf85                	j	726 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7b8:	008b0913          	addi	s2,s6,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000b2583          	lw	a1,0(s6)
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e56080e7          	jalr	-426(ra) # 61c <printint>
 7ce:	8b4a                	mv	s6,s2
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bf91                	j	726 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7d4:	008b0793          	addi	a5,s6,8
 7d8:	f8f43423          	sd	a5,-120(s0)
 7dc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7e0:	03000593          	li	a1,48
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e14080e7          	jalr	-492(ra) # 5fa <putc>
  putc(fd, 'x');
 7ee:	85ea                	mv	a1,s10
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e08080e7          	jalr	-504(ra) # 5fa <putc>
 7fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fc:	03c9d793          	srli	a5,s3,0x3c
 800:	97de                	add	a5,a5,s7
 802:	0007c583          	lbu	a1,0(a5)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	df2080e7          	jalr	-526(ra) # 5fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 810:	0992                	slli	s3,s3,0x4
 812:	397d                	addiw	s2,s2,-1
 814:	fe0914e3          	bnez	s2,7fc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 818:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b721                	j	726 <vprintf+0x60>
        s = va_arg(ap, char*);
 820:	008b0993          	addi	s3,s6,8
 824:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 828:	02090163          	beqz	s2,84a <vprintf+0x184>
        while(*s != 0){
 82c:	00094583          	lbu	a1,0(s2)
 830:	c9a1                	beqz	a1,880 <vprintf+0x1ba>
          putc(fd, *s);
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	dc6080e7          	jalr	-570(ra) # 5fa <putc>
          s++;
 83c:	0905                	addi	s2,s2,1
        while(*s != 0){
 83e:	00094583          	lbu	a1,0(s2)
 842:	f9e5                	bnez	a1,832 <vprintf+0x16c>
        s = va_arg(ap, char*);
 844:	8b4e                	mv	s6,s3
      state = 0;
 846:	4981                	li	s3,0
 848:	bdf9                	j	726 <vprintf+0x60>
          s = "(null)";
 84a:	00000917          	auipc	s2,0x0
 84e:	33e90913          	addi	s2,s2,830 # b88 <malloc+0x1f8>
        while(*s != 0){
 852:	02800593          	li	a1,40
 856:	bff1                	j	832 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 858:	008b0913          	addi	s2,s6,8
 85c:	000b4583          	lbu	a1,0(s6)
 860:	8556                	mv	a0,s5
 862:	00000097          	auipc	ra,0x0
 866:	d98080e7          	jalr	-616(ra) # 5fa <putc>
 86a:	8b4a                	mv	s6,s2
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bd65                	j	726 <vprintf+0x60>
        putc(fd, c);
 870:	85d2                	mv	a1,s4
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	d86080e7          	jalr	-634(ra) # 5fa <putc>
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b565                	j	726 <vprintf+0x60>
        s = va_arg(ap, char*);
 880:	8b4e                	mv	s6,s3
      state = 0;
 882:	4981                	li	s3,0
 884:	b54d                	j	726 <vprintf+0x60>
    }
  }
}
 886:	70e6                	ld	ra,120(sp)
 888:	7446                	ld	s0,112(sp)
 88a:	74a6                	ld	s1,104(sp)
 88c:	7906                	ld	s2,96(sp)
 88e:	69e6                	ld	s3,88(sp)
 890:	6a46                	ld	s4,80(sp)
 892:	6aa6                	ld	s5,72(sp)
 894:	6b06                	ld	s6,64(sp)
 896:	7be2                	ld	s7,56(sp)
 898:	7c42                	ld	s8,48(sp)
 89a:	7ca2                	ld	s9,40(sp)
 89c:	7d02                	ld	s10,32(sp)
 89e:	6de2                	ld	s11,24(sp)
 8a0:	6109                	addi	sp,sp,128
 8a2:	8082                	ret

00000000000008a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a4:	715d                	addi	sp,sp,-80
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e010                	sd	a2,0(s0)
 8ae:	e414                	sd	a3,8(s0)
 8b0:	e818                	sd	a4,16(s0)
 8b2:	ec1c                	sd	a5,24(s0)
 8b4:	03043023          	sd	a6,32(s0)
 8b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c0:	8622                	mv	a2,s0
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e04080e7          	jalr	-508(ra) # 6c6 <vprintf>
}
 8ca:	60e2                	ld	ra,24(sp)
 8cc:	6442                	ld	s0,16(sp)
 8ce:	6161                	addi	sp,sp,80
 8d0:	8082                	ret

00000000000008d2 <printf>:

void
printf(const char *fmt, ...)
{
 8d2:	711d                	addi	sp,sp,-96
 8d4:	ec06                	sd	ra,24(sp)
 8d6:	e822                	sd	s0,16(sp)
 8d8:	1000                	addi	s0,sp,32
 8da:	e40c                	sd	a1,8(s0)
 8dc:	e810                	sd	a2,16(s0)
 8de:	ec14                	sd	a3,24(s0)
 8e0:	f018                	sd	a4,32(s0)
 8e2:	f41c                	sd	a5,40(s0)
 8e4:	03043823          	sd	a6,48(s0)
 8e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	00840613          	addi	a2,s0,8
 8f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f4:	85aa                	mv	a1,a0
 8f6:	4505                	li	a0,1
 8f8:	00000097          	auipc	ra,0x0
 8fc:	dce080e7          	jalr	-562(ra) # 6c6 <vprintf>
}
 900:	60e2                	ld	ra,24(sp)
 902:	6442                	ld	s0,16(sp)
 904:	6125                	addi	sp,sp,96
 906:	8082                	ret

0000000000000908 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 908:	1141                	addi	sp,sp,-16
 90a:	e422                	sd	s0,8(sp)
 90c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 912:	00000797          	auipc	a5,0x0
 916:	2967b783          	ld	a5,662(a5) # ba8 <freep>
 91a:	a805                	j	94a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91c:	4618                	lw	a4,8(a2)
 91e:	9db9                	addw	a1,a1,a4
 920:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	6318                	ld	a4,0(a4)
 928:	fee53823          	sd	a4,-16(a0)
 92c:	a091                	j	970 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 92e:	ff852703          	lw	a4,-8(a0)
 932:	9e39                	addw	a2,a2,a4
 934:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 936:	ff053703          	ld	a4,-16(a0)
 93a:	e398                	sd	a4,0(a5)
 93c:	a099                	j	982 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93e:	6398                	ld	a4,0(a5)
 940:	00e7e463          	bltu	a5,a4,948 <free+0x40>
 944:	00e6ea63          	bltu	a3,a4,958 <free+0x50>
{
 948:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94a:	fed7fae3          	bgeu	a5,a3,93e <free+0x36>
 94e:	6398                	ld	a4,0(a5)
 950:	00e6e463          	bltu	a3,a4,958 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 954:	fee7eae3          	bltu	a5,a4,948 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 958:	ff852583          	lw	a1,-8(a0)
 95c:	6390                	ld	a2,0(a5)
 95e:	02059713          	slli	a4,a1,0x20
 962:	9301                	srli	a4,a4,0x20
 964:	0712                	slli	a4,a4,0x4
 966:	9736                	add	a4,a4,a3
 968:	fae60ae3          	beq	a2,a4,91c <free+0x14>
    bp->s.ptr = p->s.ptr;
 96c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 970:	4790                	lw	a2,8(a5)
 972:	02061713          	slli	a4,a2,0x20
 976:	9301                	srli	a4,a4,0x20
 978:	0712                	slli	a4,a4,0x4
 97a:	973e                	add	a4,a4,a5
 97c:	fae689e3          	beq	a3,a4,92e <free+0x26>
  } else
    p->s.ptr = bp;
 980:	e394                	sd	a3,0(a5)
  freep = p;
 982:	00000717          	auipc	a4,0x0
 986:	22f73323          	sd	a5,550(a4) # ba8 <freep>
}
 98a:	6422                	ld	s0,8(sp)
 98c:	0141                	addi	sp,sp,16
 98e:	8082                	ret

0000000000000990 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 990:	7139                	addi	sp,sp,-64
 992:	fc06                	sd	ra,56(sp)
 994:	f822                	sd	s0,48(sp)
 996:	f426                	sd	s1,40(sp)
 998:	f04a                	sd	s2,32(sp)
 99a:	ec4e                	sd	s3,24(sp)
 99c:	e852                	sd	s4,16(sp)
 99e:	e456                	sd	s5,8(sp)
 9a0:	e05a                	sd	s6,0(sp)
 9a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a4:	02051493          	slli	s1,a0,0x20
 9a8:	9081                	srli	s1,s1,0x20
 9aa:	04bd                	addi	s1,s1,15
 9ac:	8091                	srli	s1,s1,0x4
 9ae:	0014899b          	addiw	s3,s1,1
 9b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9b4:	00000517          	auipc	a0,0x0
 9b8:	1f453503          	ld	a0,500(a0) # ba8 <freep>
 9bc:	c515                	beqz	a0,9e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c0:	4798                	lw	a4,8(a5)
 9c2:	02977f63          	bgeu	a4,s1,a00 <malloc+0x70>
 9c6:	8a4e                	mv	s4,s3
 9c8:	0009871b          	sext.w	a4,s3
 9cc:	6685                	lui	a3,0x1
 9ce:	00d77363          	bgeu	a4,a3,9d4 <malloc+0x44>
 9d2:	6a05                	lui	s4,0x1
 9d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9dc:	00000917          	auipc	s2,0x0
 9e0:	1cc90913          	addi	s2,s2,460 # ba8 <freep>
  if(p == (char*)-1)
 9e4:	5afd                	li	s5,-1
 9e6:	a88d                	j	a58 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9e8:	00000797          	auipc	a5,0x0
 9ec:	1c878793          	addi	a5,a5,456 # bb0 <base>
 9f0:	00000717          	auipc	a4,0x0
 9f4:	1af73c23          	sd	a5,440(a4) # ba8 <freep>
 9f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fe:	b7e1                	j	9c6 <malloc+0x36>
      if(p->s.size == nunits)
 a00:	02e48b63          	beq	s1,a4,a36 <malloc+0xa6>
        p->s.size -= nunits;
 a04:	4137073b          	subw	a4,a4,s3
 a08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a0a:	1702                	slli	a4,a4,0x20
 a0c:	9301                	srli	a4,a4,0x20
 a0e:	0712                	slli	a4,a4,0x4
 a10:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a12:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a16:	00000717          	auipc	a4,0x0
 a1a:	18a73923          	sd	a0,402(a4) # ba8 <freep>
      return (void*)(p + 1);
 a1e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a22:	70e2                	ld	ra,56(sp)
 a24:	7442                	ld	s0,48(sp)
 a26:	74a2                	ld	s1,40(sp)
 a28:	7902                	ld	s2,32(sp)
 a2a:	69e2                	ld	s3,24(sp)
 a2c:	6a42                	ld	s4,16(sp)
 a2e:	6aa2                	ld	s5,8(sp)
 a30:	6b02                	ld	s6,0(sp)
 a32:	6121                	addi	sp,sp,64
 a34:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a36:	6398                	ld	a4,0(a5)
 a38:	e118                	sd	a4,0(a0)
 a3a:	bff1                	j	a16 <malloc+0x86>
  hp->s.size = nu;
 a3c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a40:	0541                	addi	a0,a0,16
 a42:	00000097          	auipc	ra,0x0
 a46:	ec6080e7          	jalr	-314(ra) # 908 <free>
  return freep;
 a4a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a4e:	d971                	beqz	a0,a22 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a52:	4798                	lw	a4,8(a5)
 a54:	fa9776e3          	bgeu	a4,s1,a00 <malloc+0x70>
    if(p == freep)
 a58:	00093703          	ld	a4,0(s2)
 a5c:	853e                	mv	a0,a5
 a5e:	fef719e3          	bne	a4,a5,a50 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a62:	8552                	mv	a0,s4
 a64:	00000097          	auipc	ra,0x0
 a68:	b76080e7          	jalr	-1162(ra) # 5da <sbrk>
  if(p == (char*)-1)
 a6c:	fd5518e3          	bne	a0,s5,a3c <malloc+0xac>
        return 0;
 a70:	4501                	li	a0,0
 a72:	bf45                	j	a22 <malloc+0x92>
