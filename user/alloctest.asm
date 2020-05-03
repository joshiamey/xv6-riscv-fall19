
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void
test0() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  enum { NCHILD = 50, NFD = 10};
  int i, j;
  int fd;

  printf("filetest: start\n");
  12:	00001517          	auipc	a0,0x1
  16:	9e650513          	addi	a0,a0,-1562 # 9f8 <malloc+0xe8>
  1a:	00001097          	auipc	ra,0x1
  1e:	838080e7          	jalr	-1992(ra) # 852 <printf>
  22:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	4a4080e7          	jalr	1188(ra) # 4ca <fork>
    if(pid < 0){
  2e:	00054f63          	bltz	a0,4c <test0+0x4c>
      printf("fork failed");
      exit(1);
    }
    if(pid == 0){
  32:	c915                	beqz	a0,66 <test0+0x66>
  for (i = 0; i < NCHILD; i++) {
  34:	34fd                	addiw	s1,s1,-1
  36:	f8e5                	bnez	s1,26 <test0+0x26>
  38:	03200493          	li	s1,50
      sleep(10);
      exit(0);  // no errors; exit with 0.
    }
  }

  int all_ok = 1;
  3c:	4905                	li	s2,1
  for(int i = 0; i < NCHILD; i++){
    int xstatus;
    wait(&xstatus);
    if(xstatus != 0) {
      if(all_ok == 1)
  3e:	4985                	li	s3,1
        printf("filetest: FAILED\n");
  40:	00001a97          	auipc	s5,0x1
  44:	9e8a8a93          	addi	s5,s5,-1560 # a28 <malloc+0x118>
      all_ok = 0;
  48:	4a01                	li	s4,0
  4a:	a0a5                	j	b2 <test0+0xb2>
      printf("fork failed");
  4c:	00001517          	auipc	a0,0x1
  50:	9c450513          	addi	a0,a0,-1596 # a10 <malloc+0x100>
  54:	00000097          	auipc	ra,0x0
  58:	7fe080e7          	jalr	2046(ra) # 852 <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	474080e7          	jalr	1140(ra) # 4d2 <exit>
  66:	44a9                	li	s1,10
        if ((fd = open("README", O_RDONLY)) < 0) {
  68:	00001917          	auipc	s2,0x1
  6c:	9b890913          	addi	s2,s2,-1608 # a20 <malloc+0x110>
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	49e080e7          	jalr	1182(ra) # 512 <open>
  7c:	00054e63          	bltz	a0,98 <test0+0x98>
      for(j = 0; j < NFD; j++) {
  80:	34fd                	addiw	s1,s1,-1
  82:	f4fd                	bnez	s1,70 <test0+0x70>
      sleep(10);
  84:	4529                	li	a0,10
  86:	00000097          	auipc	ra,0x0
  8a:	4dc080e7          	jalr	1244(ra) # 562 <sleep>
      exit(0);  // no errors; exit with 0.
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	442080e7          	jalr	1090(ra) # 4d2 <exit>
          exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	438080e7          	jalr	1080(ra) # 4d2 <exit>
        printf("filetest: FAILED\n");
  a2:	8556                	mv	a0,s5
  a4:	00000097          	auipc	ra,0x0
  a8:	7ae080e7          	jalr	1966(ra) # 852 <printf>
      all_ok = 0;
  ac:	8952                	mv	s2,s4
  for(int i = 0; i < NCHILD; i++){
  ae:	34fd                	addiw	s1,s1,-1
  b0:	cc89                	beqz	s1,ca <test0+0xca>
    wait(&xstatus);
  b2:	fbc40513          	addi	a0,s0,-68
  b6:	00000097          	auipc	ra,0x0
  ba:	424080e7          	jalr	1060(ra) # 4da <wait>
    if(xstatus != 0) {
  be:	fbc42783          	lw	a5,-68(s0)
  c2:	d7f5                	beqz	a5,ae <test0+0xae>
      if(all_ok == 1)
  c4:	ff3915e3          	bne	s2,s3,ae <test0+0xae>
  c8:	bfe9                	j	a2 <test0+0xa2>
    }
  }

  if(all_ok)
  ca:	00091b63          	bnez	s2,e0 <test0+0xe0>
    printf("filetest: OK\n");
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6ae2                	ld	s5,24(sp)
  dc:	6161                	addi	sp,sp,80
  de:	8082                	ret
    printf("filetest: OK\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	96050513          	addi	a0,a0,-1696 # a40 <malloc+0x130>
  e8:	00000097          	auipc	ra,0x0
  ec:	76a080e7          	jalr	1898(ra) # 852 <printf>
}
  f0:	bff9                	j	ce <test0+0xce>

00000000000000f2 <test1>:

// Allocate all free memory and count how it is
void test1()
{
  f2:	7139                	addi	sp,sp,-64
  f4:	fc06                	sd	ra,56(sp)
  f6:	f822                	sd	s0,48(sp)
  f8:	f426                	sd	s1,40(sp)
  fa:	f04a                	sd	s2,32(sp)
  fc:	ec4e                	sd	s3,24(sp)
  fe:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];
  
  printf("memtest: start\n");  
 100:	00001517          	auipc	a0,0x1
 104:	95050513          	addi	a0,a0,-1712 # a50 <malloc+0x140>
 108:	00000097          	auipc	ra,0x0
 10c:	74a080e7          	jalr	1866(ra) # 852 <printf>
  if(pipe(fds) != 0){
 110:	fc040513          	addi	a0,s0,-64
 114:	00000097          	auipc	ra,0x0
 118:	3ce080e7          	jalr	974(ra) # 4e2 <pipe>
 11c:	e535                	bnez	a0,188 <test1+0x96>
 11e:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }
  int pid = fork();
 120:	00000097          	auipc	ra,0x0
 124:	3aa080e7          	jalr	938(ra) # 4ca <fork>
  if(pid < 0){
 128:	06054d63          	bltz	a0,1a2 <test1+0xb0>
    printf("fork failed");
    exit(1);
  }
  if(pid == 0){
 12c:	ed49                	bnez	a0,1c6 <test1+0xd4>
      close(fds[0]);
 12e:	fc042503          	lw	a0,-64(s0)
 132:	00000097          	auipc	ra,0x0
 136:	3c8080e7          	jalr	968(ra) # 4fa <close>
      while(1) {
        a = sbrk(PGSIZE);
        if (a == (char*)0xffffffffffffffffL)
 13a:	54fd                	li	s1,-1
          exit(0);
        *(int *)(a+4) = 1;
 13c:	4985                	li	s3,1
        if (write(fds[1], "x", 1) != 1) {
 13e:	00001917          	auipc	s2,0x1
 142:	93290913          	addi	s2,s2,-1742 # a70 <malloc+0x160>
        a = sbrk(PGSIZE);
 146:	6505                	lui	a0,0x1
 148:	00000097          	auipc	ra,0x0
 14c:	412080e7          	jalr	1042(ra) # 55a <sbrk>
        if (a == (char*)0xffffffffffffffffL)
 150:	06950663          	beq	a0,s1,1bc <test1+0xca>
        *(int *)(a+4) = 1;
 154:	01352223          	sw	s3,4(a0) # 1004 <__BSS_END__+0x4e4>
        if (write(fds[1], "x", 1) != 1) {
 158:	4605                	li	a2,1
 15a:	85ca                	mv	a1,s2
 15c:	fc442503          	lw	a0,-60(s0)
 160:	00000097          	auipc	ra,0x0
 164:	392080e7          	jalr	914(ra) # 4f2 <write>
 168:	4785                	li	a5,1
 16a:	fcf50ee3          	beq	a0,a5,146 <test1+0x54>
          printf("write failed");
 16e:	00001517          	auipc	a0,0x1
 172:	90a50513          	addi	a0,a0,-1782 # a78 <malloc+0x168>
 176:	00000097          	auipc	ra,0x0
 17a:	6dc080e7          	jalr	1756(ra) # 852 <printf>
          exit(1);
 17e:	4505                	li	a0,1
 180:	00000097          	auipc	ra,0x0
 184:	352080e7          	jalr	850(ra) # 4d2 <exit>
    printf("pipe() failed\n");
 188:	00001517          	auipc	a0,0x1
 18c:	8d850513          	addi	a0,a0,-1832 # a60 <malloc+0x150>
 190:	00000097          	auipc	ra,0x0
 194:	6c2080e7          	jalr	1730(ra) # 852 <printf>
    exit(1);
 198:	4505                	li	a0,1
 19a:	00000097          	auipc	ra,0x0
 19e:	338080e7          	jalr	824(ra) # 4d2 <exit>
    printf("fork failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	86e50513          	addi	a0,a0,-1938 # a10 <malloc+0x100>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	6a8080e7          	jalr	1704(ra) # 852 <printf>
    exit(1);
 1b2:	4505                	li	a0,1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	31e080e7          	jalr	798(ra) # 4d2 <exit>
          exit(0);
 1bc:	4501                	li	a0,0
 1be:	00000097          	auipc	ra,0x0
 1c2:	314080e7          	jalr	788(ra) # 4d2 <exit>
        }
      }
      exit(0);
  }
  close(fds[1]);
 1c6:	fc442503          	lw	a0,-60(s0)
 1ca:	00000097          	auipc	ra,0x0
 1ce:	330080e7          	jalr	816(ra) # 4fa <close>
  while(1) {
      if (read(fds[0], buf, 1) != 1) {
 1d2:	4605                	li	a2,1
 1d4:	fc840593          	addi	a1,s0,-56
 1d8:	fc042503          	lw	a0,-64(s0)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	30e080e7          	jalr	782(ra) # 4ea <read>
 1e4:	4785                	li	a5,1
 1e6:	00f51463          	bne	a0,a5,1ee <test1+0xfc>
        break;
      } else {
        tot += 1;
 1ea:	2485                	addiw	s1,s1,1
      if (read(fds[0], buf, 1) != 1) {
 1ec:	b7dd                	j	1d2 <test1+0xe0>
      }
  }
  //int n = (PHYSTOP-KERNBASE)/PGSIZE;
  //printf("allocated %d out of %d pages\n", tot, n);
  if(tot < 31950) {
 1ee:	67a1                	lui	a5,0x8
 1f0:	ccd78793          	addi	a5,a5,-819 # 7ccd <__global_pointer$+0x69cc>
 1f4:	0297ca63          	blt	a5,s1,228 <test1+0x136>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 1f8:	85a6                	mv	a1,s1
 1fa:	00001517          	auipc	a0,0x1
 1fe:	88e50513          	addi	a0,a0,-1906 # a88 <malloc+0x178>
 202:	00000097          	auipc	ra,0x0
 206:	650080e7          	jalr	1616(ra) # 852 <printf>
    printf("memtest: FAILED\n");  
 20a:	00001517          	auipc	a0,0x1
 20e:	8b650513          	addi	a0,a0,-1866 # ac0 <malloc+0x1b0>
 212:	00000097          	auipc	ra,0x0
 216:	640080e7          	jalr	1600(ra) # 852 <printf>
  } else {
    printf("memtest: OK\n");  
  }
}
 21a:	70e2                	ld	ra,56(sp)
 21c:	7442                	ld	s0,48(sp)
 21e:	74a2                	ld	s1,40(sp)
 220:	7902                	ld	s2,32(sp)
 222:	69e2                	ld	s3,24(sp)
 224:	6121                	addi	sp,sp,64
 226:	8082                	ret
    printf("memtest: OK\n");  
 228:	00001517          	auipc	a0,0x1
 22c:	8b050513          	addi	a0,a0,-1872 # ad8 <malloc+0x1c8>
 230:	00000097          	auipc	ra,0x0
 234:	622080e7          	jalr	1570(ra) # 852 <printf>
}
 238:	b7cd                	j	21a <test1+0x128>

000000000000023a <main>:

int
main(int argc, char *argv[])
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
  test0();
 242:	00000097          	auipc	ra,0x0
 246:	dbe080e7          	jalr	-578(ra) # 0 <test0>
  test1();
 24a:	00000097          	auipc	ra,0x0
 24e:	ea8080e7          	jalr	-344(ra) # f2 <test1>
  exit(0);
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	27e080e7          	jalr	638(ra) # 4d2 <exit>

000000000000025c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 262:	87aa                	mv	a5,a0
 264:	0585                	addi	a1,a1,1
 266:	0785                	addi	a5,a5,1
 268:	fff5c703          	lbu	a4,-1(a1)
 26c:	fee78fa3          	sb	a4,-1(a5)
 270:	fb75                	bnez	a4,264 <strcpy+0x8>
    ;
  return os;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 27e:	00054783          	lbu	a5,0(a0)
 282:	cb91                	beqz	a5,296 <strcmp+0x1e>
 284:	0005c703          	lbu	a4,0(a1)
 288:	00f71763          	bne	a4,a5,296 <strcmp+0x1e>
    p++, q++;
 28c:	0505                	addi	a0,a0,1
 28e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	fbe5                	bnez	a5,284 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 296:	0005c503          	lbu	a0,0(a1)
}
 29a:	40a7853b          	subw	a0,a5,a0
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <strlen>:

uint
strlen(const char *s)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	cf91                	beqz	a5,2ca <strlen+0x26>
 2b0:	0505                	addi	a0,a0,1
 2b2:	87aa                	mv	a5,a0
 2b4:	4685                	li	a3,1
 2b6:	9e89                	subw	a3,a3,a0
 2b8:	00f6853b          	addw	a0,a3,a5
 2bc:	0785                	addi	a5,a5,1
 2be:	fff7c703          	lbu	a4,-1(a5)
 2c2:	fb7d                	bnez	a4,2b8 <strlen+0x14>
    ;
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  for(n = 0; s[n]; n++)
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <strlen+0x20>

00000000000002ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d4:	ce09                	beqz	a2,2ee <memset+0x20>
 2d6:	87aa                	mv	a5,a0
 2d8:	fff6071b          	addiw	a4,a2,-1
 2dc:	1702                	slli	a4,a4,0x20
 2de:	9301                	srli	a4,a4,0x20
 2e0:	0705                	addi	a4,a4,1
 2e2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e8:	0785                	addi	a5,a5,1
 2ea:	fee79de3          	bne	a5,a4,2e4 <memset+0x16>
  }
  return dst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strchr>:

char*
strchr(const char *s, char c)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb99                	beqz	a5,314 <strchr+0x20>
    if(*s == c)
 300:	00f58763          	beq	a1,a5,30e <strchr+0x1a>
  for(; *s; s++)
 304:	0505                	addi	a0,a0,1
 306:	00054783          	lbu	a5,0(a0)
 30a:	fbfd                	bnez	a5,300 <strchr+0xc>
      return (char*)s;
  return 0;
 30c:	4501                	li	a0,0
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strchr+0x1a>

0000000000000318 <gets>:

char*
gets(char *buf, int max)
{
 318:	711d                	addi	sp,sp,-96
 31a:	ec86                	sd	ra,88(sp)
 31c:	e8a2                	sd	s0,80(sp)
 31e:	e4a6                	sd	s1,72(sp)
 320:	e0ca                	sd	s2,64(sp)
 322:	fc4e                	sd	s3,56(sp)
 324:	f852                	sd	s4,48(sp)
 326:	f456                	sd	s5,40(sp)
 328:	f05a                	sd	s6,32(sp)
 32a:	ec5e                	sd	s7,24(sp)
 32c:	1080                	addi	s0,sp,96
 32e:	8baa                	mv	s7,a0
 330:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 332:	892a                	mv	s2,a0
 334:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 336:	4aa9                	li	s5,10
 338:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 33a:	89a6                	mv	s3,s1
 33c:	2485                	addiw	s1,s1,1
 33e:	0344d863          	bge	s1,s4,36e <gets+0x56>
    cc = read(0, &c, 1);
 342:	4605                	li	a2,1
 344:	faf40593          	addi	a1,s0,-81
 348:	4501                	li	a0,0
 34a:	00000097          	auipc	ra,0x0
 34e:	1a0080e7          	jalr	416(ra) # 4ea <read>
    if(cc < 1)
 352:	00a05e63          	blez	a0,36e <gets+0x56>
    buf[i++] = c;
 356:	faf44783          	lbu	a5,-81(s0)
 35a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 35e:	01578763          	beq	a5,s5,36c <gets+0x54>
 362:	0905                	addi	s2,s2,1
 364:	fd679be3          	bne	a5,s6,33a <gets+0x22>
  for(i=0; i+1 < max; ){
 368:	89a6                	mv	s3,s1
 36a:	a011                	j	36e <gets+0x56>
 36c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 36e:	99de                	add	s3,s3,s7
 370:	00098023          	sb	zero,0(s3)
  return buf;
}
 374:	855e                	mv	a0,s7
 376:	60e6                	ld	ra,88(sp)
 378:	6446                	ld	s0,80(sp)
 37a:	64a6                	ld	s1,72(sp)
 37c:	6906                	ld	s2,64(sp)
 37e:	79e2                	ld	s3,56(sp)
 380:	7a42                	ld	s4,48(sp)
 382:	7aa2                	ld	s5,40(sp)
 384:	7b02                	ld	s6,32(sp)
 386:	6be2                	ld	s7,24(sp)
 388:	6125                	addi	sp,sp,96
 38a:	8082                	ret

000000000000038c <stat>:

int
stat(const char *n, struct stat *st)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	e426                	sd	s1,8(sp)
 394:	e04a                	sd	s2,0(sp)
 396:	1000                	addi	s0,sp,32
 398:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39a:	4581                	li	a1,0
 39c:	00000097          	auipc	ra,0x0
 3a0:	176080e7          	jalr	374(ra) # 512 <open>
  if(fd < 0)
 3a4:	02054563          	bltz	a0,3ce <stat+0x42>
 3a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3aa:	85ca                	mv	a1,s2
 3ac:	00000097          	auipc	ra,0x0
 3b0:	17e080e7          	jalr	382(ra) # 52a <fstat>
 3b4:	892a                	mv	s2,a0
  close(fd);
 3b6:	8526                	mv	a0,s1
 3b8:	00000097          	auipc	ra,0x0
 3bc:	142080e7          	jalr	322(ra) # 4fa <close>
  return r;
}
 3c0:	854a                	mv	a0,s2
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	64a2                	ld	s1,8(sp)
 3c8:	6902                	ld	s2,0(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret
    return -1;
 3ce:	597d                	li	s2,-1
 3d0:	bfc5                	j	3c0 <stat+0x34>

00000000000003d2 <atoi>:

int
atoi(const char *s)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d8:	00054603          	lbu	a2,0(a0)
 3dc:	fd06079b          	addiw	a5,a2,-48
 3e0:	0ff7f793          	andi	a5,a5,255
 3e4:	4725                	li	a4,9
 3e6:	02f76963          	bltu	a4,a5,418 <atoi+0x46>
 3ea:	86aa                	mv	a3,a0
  n = 0;
 3ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f0:	0685                	addi	a3,a3,1
 3f2:	0025179b          	slliw	a5,a0,0x2
 3f6:	9fa9                	addw	a5,a5,a0
 3f8:	0017979b          	slliw	a5,a5,0x1
 3fc:	9fb1                	addw	a5,a5,a2
 3fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 402:	0006c603          	lbu	a2,0(a3)
 406:	fd06071b          	addiw	a4,a2,-48
 40a:	0ff77713          	andi	a4,a4,255
 40e:	fee5f1e3          	bgeu	a1,a4,3f0 <atoi+0x1e>
  return n;
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret
  n = 0;
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <atoi+0x40>

000000000000041c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 422:	02b57663          	bgeu	a0,a1,44e <memmove+0x32>
    while(n-- > 0)
 426:	02c05163          	blez	a2,448 <memmove+0x2c>
 42a:	fff6079b          	addiw	a5,a2,-1
 42e:	1782                	slli	a5,a5,0x20
 430:	9381                	srli	a5,a5,0x20
 432:	0785                	addi	a5,a5,1
 434:	97aa                	add	a5,a5,a0
  dst = vdst;
 436:	872a                	mv	a4,a0
      *dst++ = *src++;
 438:	0585                	addi	a1,a1,1
 43a:	0705                	addi	a4,a4,1
 43c:	fff5c683          	lbu	a3,-1(a1)
 440:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 444:	fee79ae3          	bne	a5,a4,438 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
    dst += n;
 44e:	00c50733          	add	a4,a0,a2
    src += n;
 452:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 454:	fec05ae3          	blez	a2,448 <memmove+0x2c>
 458:	fff6079b          	addiw	a5,a2,-1
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	fff7c793          	not	a5,a5
 464:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 466:	15fd                	addi	a1,a1,-1
 468:	177d                	addi	a4,a4,-1
 46a:	0005c683          	lbu	a3,0(a1)
 46e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 472:	fee79ae3          	bne	a5,a4,466 <memmove+0x4a>
 476:	bfc9                	j	448 <memmove+0x2c>

0000000000000478 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 47e:	ca05                	beqz	a2,4ae <memcmp+0x36>
 480:	fff6069b          	addiw	a3,a2,-1
 484:	1682                	slli	a3,a3,0x20
 486:	9281                	srli	a3,a3,0x20
 488:	0685                	addi	a3,a3,1
 48a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 48c:	00054783          	lbu	a5,0(a0)
 490:	0005c703          	lbu	a4,0(a1)
 494:	00e79863          	bne	a5,a4,4a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 498:	0505                	addi	a0,a0,1
    p2++;
 49a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 49c:	fed518e3          	bne	a0,a3,48c <memcmp+0x14>
  }
  return 0;
 4a0:	4501                	li	a0,0
 4a2:	a019                	j	4a8 <memcmp+0x30>
      return *p1 - *p2;
 4a4:	40e7853b          	subw	a0,a5,a4
}
 4a8:	6422                	ld	s0,8(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret
  return 0;
 4ae:	4501                	li	a0,0
 4b0:	bfe5                	j	4a8 <memcmp+0x30>

00000000000004b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ba:	00000097          	auipc	ra,0x0
 4be:	f62080e7          	jalr	-158(ra) # 41c <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 572:	48d9                	li	a7,22
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57a:	1101                	addi	sp,sp,-32
 57c:	ec06                	sd	ra,24(sp)
 57e:	e822                	sd	s0,16(sp)
 580:	1000                	addi	s0,sp,32
 582:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 586:	4605                	li	a2,1
 588:	fef40593          	addi	a1,s0,-17
 58c:	00000097          	auipc	ra,0x0
 590:	f66080e7          	jalr	-154(ra) # 4f2 <write>
}
 594:	60e2                	ld	ra,24(sp)
 596:	6442                	ld	s0,16(sp)
 598:	6105                	addi	sp,sp,32
 59a:	8082                	ret

000000000000059c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59c:	7139                	addi	sp,sp,-64
 59e:	fc06                	sd	ra,56(sp)
 5a0:	f822                	sd	s0,48(sp)
 5a2:	f426                	sd	s1,40(sp)
 5a4:	f04a                	sd	s2,32(sp)
 5a6:	ec4e                	sd	s3,24(sp)
 5a8:	0080                	addi	s0,sp,64
 5aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ac:	c299                	beqz	a3,5b2 <printint+0x16>
 5ae:	0805c863          	bltz	a1,63e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b2:	2581                	sext.w	a1,a1
  neg = 0;
 5b4:	4881                	li	a7,0
 5b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5bc:	2601                	sext.w	a2,a2
 5be:	00000517          	auipc	a0,0x0
 5c2:	53250513          	addi	a0,a0,1330 # af0 <digits>
 5c6:	883a                	mv	a6,a4
 5c8:	2705                	addiw	a4,a4,1
 5ca:	02c5f7bb          	remuw	a5,a1,a2
 5ce:	1782                	slli	a5,a5,0x20
 5d0:	9381                	srli	a5,a5,0x20
 5d2:	97aa                	add	a5,a5,a0
 5d4:	0007c783          	lbu	a5,0(a5)
 5d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5dc:	0005879b          	sext.w	a5,a1
 5e0:	02c5d5bb          	divuw	a1,a1,a2
 5e4:	0685                	addi	a3,a3,1
 5e6:	fec7f0e3          	bgeu	a5,a2,5c6 <printint+0x2a>
  if(neg)
 5ea:	00088b63          	beqz	a7,600 <printint+0x64>
    buf[i++] = '-';
 5ee:	fd040793          	addi	a5,s0,-48
 5f2:	973e                	add	a4,a4,a5
 5f4:	02d00793          	li	a5,45
 5f8:	fef70823          	sb	a5,-16(a4)
 5fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 600:	02e05863          	blez	a4,630 <printint+0x94>
 604:	fc040793          	addi	a5,s0,-64
 608:	00e78933          	add	s2,a5,a4
 60c:	fff78993          	addi	s3,a5,-1
 610:	99ba                	add	s3,s3,a4
 612:	377d                	addiw	a4,a4,-1
 614:	1702                	slli	a4,a4,0x20
 616:	9301                	srli	a4,a4,0x20
 618:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 61c:	fff94583          	lbu	a1,-1(s2)
 620:	8526                	mv	a0,s1
 622:	00000097          	auipc	ra,0x0
 626:	f58080e7          	jalr	-168(ra) # 57a <putc>
  while(--i >= 0)
 62a:	197d                	addi	s2,s2,-1
 62c:	ff3918e3          	bne	s2,s3,61c <printint+0x80>
}
 630:	70e2                	ld	ra,56(sp)
 632:	7442                	ld	s0,48(sp)
 634:	74a2                	ld	s1,40(sp)
 636:	7902                	ld	s2,32(sp)
 638:	69e2                	ld	s3,24(sp)
 63a:	6121                	addi	sp,sp,64
 63c:	8082                	ret
    x = -xx;
 63e:	40b005bb          	negw	a1,a1
    neg = 1;
 642:	4885                	li	a7,1
    x = -xx;
 644:	bf8d                	j	5b6 <printint+0x1a>

0000000000000646 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 646:	7119                	addi	sp,sp,-128
 648:	fc86                	sd	ra,120(sp)
 64a:	f8a2                	sd	s0,112(sp)
 64c:	f4a6                	sd	s1,104(sp)
 64e:	f0ca                	sd	s2,96(sp)
 650:	ecce                	sd	s3,88(sp)
 652:	e8d2                	sd	s4,80(sp)
 654:	e4d6                	sd	s5,72(sp)
 656:	e0da                	sd	s6,64(sp)
 658:	fc5e                	sd	s7,56(sp)
 65a:	f862                	sd	s8,48(sp)
 65c:	f466                	sd	s9,40(sp)
 65e:	f06a                	sd	s10,32(sp)
 660:	ec6e                	sd	s11,24(sp)
 662:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 664:	0005c903          	lbu	s2,0(a1)
 668:	18090f63          	beqz	s2,806 <vprintf+0x1c0>
 66c:	8aaa                	mv	s5,a0
 66e:	8b32                	mv	s6,a2
 670:	00158493          	addi	s1,a1,1
  state = 0;
 674:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 676:	02500a13          	li	s4,37
      if(c == 'd'){
 67a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 67e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 682:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 686:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	466b8b93          	addi	s7,s7,1126 # af0 <digits>
 692:	a839                	j	6b0 <vprintf+0x6a>
        putc(fd, c);
 694:	85ca                	mv	a1,s2
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	ee2080e7          	jalr	-286(ra) # 57a <putc>
 6a0:	a019                	j	6a6 <vprintf+0x60>
    } else if(state == '%'){
 6a2:	01498f63          	beq	s3,s4,6c0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a6:	0485                	addi	s1,s1,1
 6a8:	fff4c903          	lbu	s2,-1(s1)
 6ac:	14090d63          	beqz	s2,806 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b4:	fe0997e3          	bnez	s3,6a2 <vprintf+0x5c>
      if(c == '%'){
 6b8:	fd479ee3          	bne	a5,s4,694 <vprintf+0x4e>
        state = '%';
 6bc:	89be                	mv	s3,a5
 6be:	b7e5                	j	6a6 <vprintf+0x60>
      if(c == 'd'){
 6c0:	05878063          	beq	a5,s8,700 <vprintf+0xba>
      } else if(c == 'l') {
 6c4:	05978c63          	beq	a5,s9,71c <vprintf+0xd6>
      } else if(c == 'x') {
 6c8:	07a78863          	beq	a5,s10,738 <vprintf+0xf2>
      } else if(c == 'p') {
 6cc:	09b78463          	beq	a5,s11,754 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6d0:	07300713          	li	a4,115
 6d4:	0ce78663          	beq	a5,a4,7a0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d8:	06300713          	li	a4,99
 6dc:	0ee78e63          	beq	a5,a4,7d8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6e0:	11478863          	beq	a5,s4,7f0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e4:	85d2                	mv	a1,s4
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e92080e7          	jalr	-366(ra) # 57a <putc>
        putc(fd, c);
 6f0:	85ca                	mv	a1,s2
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e86080e7          	jalr	-378(ra) # 57a <putc>
      }
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b765                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 700:	008b0913          	addi	s2,s6,8
 704:	4685                	li	a3,1
 706:	4629                	li	a2,10
 708:	000b2583          	lw	a1,0(s6)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e8e080e7          	jalr	-370(ra) # 59c <printint>
 716:	8b4a                	mv	s6,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	b771                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	008b0913          	addi	s2,s6,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000b2583          	lw	a1,0(s6)
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e72080e7          	jalr	-398(ra) # 59c <printint>
 732:	8b4a                	mv	s6,s2
      state = 0;
 734:	4981                	li	s3,0
 736:	bf85                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 738:	008b0913          	addi	s2,s6,8
 73c:	4681                	li	a3,0
 73e:	4641                	li	a2,16
 740:	000b2583          	lw	a1,0(s6)
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	e56080e7          	jalr	-426(ra) # 59c <printint>
 74e:	8b4a                	mv	s6,s2
      state = 0;
 750:	4981                	li	s3,0
 752:	bf91                	j	6a6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 754:	008b0793          	addi	a5,s6,8
 758:	f8f43423          	sd	a5,-120(s0)
 75c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 760:	03000593          	li	a1,48
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e14080e7          	jalr	-492(ra) # 57a <putc>
  putc(fd, 'x');
 76e:	85ea                	mv	a1,s10
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	e08080e7          	jalr	-504(ra) # 57a <putc>
 77a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77c:	03c9d793          	srli	a5,s3,0x3c
 780:	97de                	add	a5,a5,s7
 782:	0007c583          	lbu	a1,0(a5)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	df2080e7          	jalr	-526(ra) # 57a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 790:	0992                	slli	s3,s3,0x4
 792:	397d                	addiw	s2,s2,-1
 794:	fe0914e3          	bnez	s2,77c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 798:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b721                	j	6a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 7a0:	008b0993          	addi	s3,s6,8
 7a4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7a8:	02090163          	beqz	s2,7ca <vprintf+0x184>
        while(*s != 0){
 7ac:	00094583          	lbu	a1,0(s2)
 7b0:	c9a1                	beqz	a1,800 <vprintf+0x1ba>
          putc(fd, *s);
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	dc6080e7          	jalr	-570(ra) # 57a <putc>
          s++;
 7bc:	0905                	addi	s2,s2,1
        while(*s != 0){
 7be:	00094583          	lbu	a1,0(s2)
 7c2:	f9e5                	bnez	a1,7b2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c4:	8b4e                	mv	s6,s3
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	bdf9                	j	6a6 <vprintf+0x60>
          s = "(null)";
 7ca:	00000917          	auipc	s2,0x0
 7ce:	31e90913          	addi	s2,s2,798 # ae8 <malloc+0x1d8>
        while(*s != 0){
 7d2:	02800593          	li	a1,40
 7d6:	bff1                	j	7b2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7d8:	008b0913          	addi	s2,s6,8
 7dc:	000b4583          	lbu	a1,0(s6)
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	d98080e7          	jalr	-616(ra) # 57a <putc>
 7ea:	8b4a                	mv	s6,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bd65                	j	6a6 <vprintf+0x60>
        putc(fd, c);
 7f0:	85d2                	mv	a1,s4
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	d86080e7          	jalr	-634(ra) # 57a <putc>
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b565                	j	6a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 800:	8b4e                	mv	s6,s3
      state = 0;
 802:	4981                	li	s3,0
 804:	b54d                	j	6a6 <vprintf+0x60>
    }
  }
}
 806:	70e6                	ld	ra,120(sp)
 808:	7446                	ld	s0,112(sp)
 80a:	74a6                	ld	s1,104(sp)
 80c:	7906                	ld	s2,96(sp)
 80e:	69e6                	ld	s3,88(sp)
 810:	6a46                	ld	s4,80(sp)
 812:	6aa6                	ld	s5,72(sp)
 814:	6b06                	ld	s6,64(sp)
 816:	7be2                	ld	s7,56(sp)
 818:	7c42                	ld	s8,48(sp)
 81a:	7ca2                	ld	s9,40(sp)
 81c:	7d02                	ld	s10,32(sp)
 81e:	6de2                	ld	s11,24(sp)
 820:	6109                	addi	sp,sp,128
 822:	8082                	ret

0000000000000824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 824:	715d                	addi	sp,sp,-80
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e010                	sd	a2,0(s0)
 82e:	e414                	sd	a3,8(s0)
 830:	e818                	sd	a4,16(s0)
 832:	ec1c                	sd	a5,24(s0)
 834:	03043023          	sd	a6,32(s0)
 838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 840:	8622                	mv	a2,s0
 842:	00000097          	auipc	ra,0x0
 846:	e04080e7          	jalr	-508(ra) # 646 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6161                	addi	sp,sp,80
 850:	8082                	ret

0000000000000852 <printf>:

void
printf(const char *fmt, ...)
{
 852:	711d                	addi	sp,sp,-96
 854:	ec06                	sd	ra,24(sp)
 856:	e822                	sd	s0,16(sp)
 858:	1000                	addi	s0,sp,32
 85a:	e40c                	sd	a1,8(s0)
 85c:	e810                	sd	a2,16(s0)
 85e:	ec14                	sd	a3,24(s0)
 860:	f018                	sd	a4,32(s0)
 862:	f41c                	sd	a5,40(s0)
 864:	03043823          	sd	a6,48(s0)
 868:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	00840613          	addi	a2,s0,8
 870:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 874:	85aa                	mv	a1,a0
 876:	4505                	li	a0,1
 878:	00000097          	auipc	ra,0x0
 87c:	dce080e7          	jalr	-562(ra) # 646 <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e422                	sd	s0,8(sp)
 88c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	00000797          	auipc	a5,0x0
 896:	2767b783          	ld	a5,630(a5) # b08 <freep>
 89a:	a805                	j	8ca <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89c:	4618                	lw	a4,8(a2)
 89e:	9db9                	addw	a1,a1,a4
 8a0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	6398                	ld	a4,0(a5)
 8a6:	6318                	ld	a4,0(a4)
 8a8:	fee53823          	sd	a4,-16(a0)
 8ac:	a091                	j	8f0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ae:	ff852703          	lw	a4,-8(a0)
 8b2:	9e39                	addw	a2,a2,a4
 8b4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8b6:	ff053703          	ld	a4,-16(a0)
 8ba:	e398                	sd	a4,0(a5)
 8bc:	a099                	j	902 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	6398                	ld	a4,0(a5)
 8c0:	00e7e463          	bltu	a5,a4,8c8 <free+0x40>
 8c4:	00e6ea63          	bltu	a3,a4,8d8 <free+0x50>
{
 8c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ca:	fed7fae3          	bgeu	a5,a3,8be <free+0x36>
 8ce:	6398                	ld	a4,0(a5)
 8d0:	00e6e463          	bltu	a3,a4,8d8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	fee7eae3          	bltu	a5,a4,8c8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8d8:	ff852583          	lw	a1,-8(a0)
 8dc:	6390                	ld	a2,0(a5)
 8de:	02059713          	slli	a4,a1,0x20
 8e2:	9301                	srli	a4,a4,0x20
 8e4:	0712                	slli	a4,a4,0x4
 8e6:	9736                	add	a4,a4,a3
 8e8:	fae60ae3          	beq	a2,a4,89c <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f0:	4790                	lw	a2,8(a5)
 8f2:	02061713          	slli	a4,a2,0x20
 8f6:	9301                	srli	a4,a4,0x20
 8f8:	0712                	slli	a4,a4,0x4
 8fa:	973e                	add	a4,a4,a5
 8fc:	fae689e3          	beq	a3,a4,8ae <free+0x26>
  } else
    p->s.ptr = bp;
 900:	e394                	sd	a3,0(a5)
  freep = p;
 902:	00000717          	auipc	a4,0x0
 906:	20f73323          	sd	a5,518(a4) # b08 <freep>
}
 90a:	6422                	ld	s0,8(sp)
 90c:	0141                	addi	sp,sp,16
 90e:	8082                	ret

0000000000000910 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 910:	7139                	addi	sp,sp,-64
 912:	fc06                	sd	ra,56(sp)
 914:	f822                	sd	s0,48(sp)
 916:	f426                	sd	s1,40(sp)
 918:	f04a                	sd	s2,32(sp)
 91a:	ec4e                	sd	s3,24(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
 922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	02051493          	slli	s1,a0,0x20
 928:	9081                	srli	s1,s1,0x20
 92a:	04bd                	addi	s1,s1,15
 92c:	8091                	srli	s1,s1,0x4
 92e:	0014899b          	addiw	s3,s1,1
 932:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 934:	00000517          	auipc	a0,0x0
 938:	1d453503          	ld	a0,468(a0) # b08 <freep>
 93c:	c515                	beqz	a0,968 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 940:	4798                	lw	a4,8(a5)
 942:	02977f63          	bgeu	a4,s1,980 <malloc+0x70>
 946:	8a4e                	mv	s4,s3
 948:	0009871b          	sext.w	a4,s3
 94c:	6685                	lui	a3,0x1
 94e:	00d77363          	bgeu	a4,a3,954 <malloc+0x44>
 952:	6a05                	lui	s4,0x1
 954:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 958:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 95c:	00000917          	auipc	s2,0x0
 960:	1ac90913          	addi	s2,s2,428 # b08 <freep>
  if(p == (char*)-1)
 964:	5afd                	li	s5,-1
 966:	a88d                	j	9d8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 968:	00000797          	auipc	a5,0x0
 96c:	1a878793          	addi	a5,a5,424 # b10 <base>
 970:	00000717          	auipc	a4,0x0
 974:	18f73c23          	sd	a5,408(a4) # b08 <freep>
 978:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 97e:	b7e1                	j	946 <malloc+0x36>
      if(p->s.size == nunits)
 980:	02e48b63          	beq	s1,a4,9b6 <malloc+0xa6>
        p->s.size -= nunits;
 984:	4137073b          	subw	a4,a4,s3
 988:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98a:	1702                	slli	a4,a4,0x20
 98c:	9301                	srli	a4,a4,0x20
 98e:	0712                	slli	a4,a4,0x4
 990:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 992:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 996:	00000717          	auipc	a4,0x0
 99a:	16a73923          	sd	a0,370(a4) # b08 <freep>
      return (void*)(p + 1);
 99e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a2:	70e2                	ld	ra,56(sp)
 9a4:	7442                	ld	s0,48(sp)
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	7902                	ld	s2,32(sp)
 9aa:	69e2                	ld	s3,24(sp)
 9ac:	6a42                	ld	s4,16(sp)
 9ae:	6aa2                	ld	s5,8(sp)
 9b0:	6b02                	ld	s6,0(sp)
 9b2:	6121                	addi	sp,sp,64
 9b4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9b6:	6398                	ld	a4,0(a5)
 9b8:	e118                	sd	a4,0(a0)
 9ba:	bff1                	j	996 <malloc+0x86>
  hp->s.size = nu;
 9bc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c0:	0541                	addi	a0,a0,16
 9c2:	00000097          	auipc	ra,0x0
 9c6:	ec6080e7          	jalr	-314(ra) # 888 <free>
  return freep;
 9ca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ce:	d971                	beqz	a0,9a2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d2:	4798                	lw	a4,8(a5)
 9d4:	fa9776e3          	bgeu	a4,s1,980 <malloc+0x70>
    if(p == freep)
 9d8:	00093703          	ld	a4,0(s2)
 9dc:	853e                	mv	a0,a5
 9de:	fef719e3          	bne	a4,a5,9d0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9e2:	8552                	mv	a0,s4
 9e4:	00000097          	auipc	ra,0x0
 9e8:	b76080e7          	jalr	-1162(ra) # 55a <sbrk>
  if(p == (char*)-1)
 9ec:	fd5518e3          	bne	a0,s5,9bc <malloc+0xac>
        return 0;
 9f0:	4501                	li	a0,0
 9f2:	bf45                	j	9a2 <malloc+0x92>
