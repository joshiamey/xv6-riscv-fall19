
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit();
}

void
createfile(char *file, int nblock)
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	21513423          	sd	s5,520(sp)
  20:	0480                	addi	s0,sp,576
  22:	8a2a                	mv	s4,a0
  24:	89ae                	mv	s3,a1
  int fd;
  char buf[512];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  26:	20200593          	li	a1,514
  2a:	00000097          	auipc	ra,0x0
  2e:	59c080e7          	jalr	1436(ra) # 5c6 <open>
  if(fd < 0){
  32:	04054063          	bltz	a0,72 <createfile+0x72>
  36:	892a                	mv	s2,a0
    printf("test0 create %s failed\n", file);
    exit();
  }
  for(i = 0; i < nblock; i++) {
  38:	4481                	li	s1,0
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      printf("write %s failed\n", file);
  3a:	00001a97          	auipc	s5,0x1
  3e:	a9ea8a93          	addi	s5,s5,-1378 # ad8 <malloc+0xfc>
  for(i = 0; i < nblock; i++) {
  42:	05304e63          	bgtz	s3,9e <createfile+0x9e>
    }
  }
  close(fd);
  46:	854a                	mv	a0,s2
  48:	00000097          	auipc	ra,0x0
  4c:	566080e7          	jalr	1382(ra) # 5ae <close>
}
  50:	23813083          	ld	ra,568(sp)
  54:	23013403          	ld	s0,560(sp)
  58:	22813483          	ld	s1,552(sp)
  5c:	22013903          	ld	s2,544(sp)
  60:	21813983          	ld	s3,536(sp)
  64:	21013a03          	ld	s4,528(sp)
  68:	20813a83          	ld	s5,520(sp)
  6c:	24010113          	addi	sp,sp,576
  70:	8082                	ret
    printf("test0 create %s failed\n", file);
  72:	85d2                	mv	a1,s4
  74:	00001517          	auipc	a0,0x1
  78:	a4c50513          	addi	a0,a0,-1460 # ac0 <malloc+0xe4>
  7c:	00001097          	auipc	ra,0x1
  80:	8a2080e7          	jalr	-1886(ra) # 91e <printf>
    exit();
  84:	00000097          	auipc	ra,0x0
  88:	502080e7          	jalr	1282(ra) # 586 <exit>
      printf("write %s failed\n", file);
  8c:	85d2                	mv	a1,s4
  8e:	8556                	mv	a0,s5
  90:	00001097          	auipc	ra,0x1
  94:	88e080e7          	jalr	-1906(ra) # 91e <printf>
  for(i = 0; i < nblock; i++) {
  98:	2485                	addiw	s1,s1,1
  9a:	fa9986e3          	beq	s3,s1,46 <createfile+0x46>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  9e:	20000613          	li	a2,512
  a2:	dc040593          	addi	a1,s0,-576
  a6:	854a                	mv	a0,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	4fe080e7          	jalr	1278(ra) # 5a6 <write>
  b0:	20000793          	li	a5,512
  b4:	fef502e3          	beq	a0,a5,98 <createfile+0x98>
  b8:	bfd1                	j	8c <createfile+0x8c>

00000000000000ba <readfile>:

void
readfile(char *file, int nblock)
{
  ba:	dd010113          	addi	sp,sp,-560
  be:	22113423          	sd	ra,552(sp)
  c2:	22813023          	sd	s0,544(sp)
  c6:	20913c23          	sd	s1,536(sp)
  ca:	21213823          	sd	s2,528(sp)
  ce:	21313423          	sd	s3,520(sp)
  d2:	21413023          	sd	s4,512(sp)
  d6:	1c00                	addi	s0,sp,560
  d8:	8a2a                	mv	s4,a0
  da:	89ae                	mv	s3,a1
  char buf[512];
  int fd;
  int i;
  
  if ((fd = open(file, O_RDONLY)) < 0) {
  dc:	4581                	li	a1,0
  de:	00000097          	auipc	ra,0x0
  e2:	4e8080e7          	jalr	1256(ra) # 5c6 <open>
  e6:	04054a63          	bltz	a0,13a <readfile+0x80>
  ea:	892a                	mv	s2,a0
    printf("test0 open %s failed\n", file);
    exit();
  }
  for (i = 0; i < nblock; i++) {
  ec:	4481                	li	s1,0
  ee:	03305263          	blez	s3,112 <readfile+0x58>
    if(read(fd, buf, sizeof(buf)) != sizeof(buf)) {
  f2:	20000613          	li	a2,512
  f6:	dd040593          	addi	a1,s0,-560
  fa:	854a                	mv	a0,s2
  fc:	00000097          	auipc	ra,0x0
 100:	4a2080e7          	jalr	1186(ra) # 59e <read>
 104:	20000793          	li	a5,512
 108:	04f51663          	bne	a0,a5,154 <readfile+0x9a>
  for (i = 0; i < nblock; i++) {
 10c:	2485                	addiw	s1,s1,1
 10e:	fe9992e3          	bne	s3,s1,f2 <readfile+0x38>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
      exit();
    }
  }
  close(fd);
 112:	854a                	mv	a0,s2
 114:	00000097          	auipc	ra,0x0
 118:	49a080e7          	jalr	1178(ra) # 5ae <close>
}
 11c:	22813083          	ld	ra,552(sp)
 120:	22013403          	ld	s0,544(sp)
 124:	21813483          	ld	s1,536(sp)
 128:	21013903          	ld	s2,528(sp)
 12c:	20813983          	ld	s3,520(sp)
 130:	20013a03          	ld	s4,512(sp)
 134:	23010113          	addi	sp,sp,560
 138:	8082                	ret
    printf("test0 open %s failed\n", file);
 13a:	85d2                	mv	a1,s4
 13c:	00001517          	auipc	a0,0x1
 140:	9b450513          	addi	a0,a0,-1612 # af0 <malloc+0x114>
 144:	00000097          	auipc	ra,0x0
 148:	7da080e7          	jalr	2010(ra) # 91e <printf>
    exit();
 14c:	00000097          	auipc	ra,0x0
 150:	43a080e7          	jalr	1082(ra) # 586 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
 154:	86ce                	mv	a3,s3
 156:	8626                	mv	a2,s1
 158:	85d2                	mv	a1,s4
 15a:	00001517          	auipc	a0,0x1
 15e:	9ae50513          	addi	a0,a0,-1618 # b08 <malloc+0x12c>
 162:	00000097          	auipc	ra,0x0
 166:	7bc080e7          	jalr	1980(ra) # 91e <printf>
      exit();
 16a:	00000097          	auipc	ra,0x0
 16e:	41c080e7          	jalr	1052(ra) # 586 <exit>

0000000000000172 <test0>:

void
test0()
{
 172:	7139                	addi	sp,sp,-64
 174:	fc06                	sd	ra,56(sp)
 176:	f822                	sd	s0,48(sp)
 178:	f426                	sd	s1,40(sp)
 17a:	f04a                	sd	s2,32(sp)
 17c:	ec4e                	sd	s3,24(sp)
 17e:	0080                	addi	s0,sp,64
  char file[3];

  file[0] = 'B';
 180:	04200793          	li	a5,66
 184:	fcf40423          	sb	a5,-56(s0)
  file[2] = '\0';
 188:	fc040523          	sb	zero,-54(s0)

  printf("start test0\n");
 18c:	00001517          	auipc	a0,0x1
 190:	9a450513          	addi	a0,a0,-1628 # b30 <malloc+0x154>
 194:	00000097          	auipc	ra,0x0
 198:	78a080e7          	jalr	1930(ra) # 91e <printf>
  int n = ntas();
 19c:	00000097          	auipc	ra,0x0
 1a0:	48a080e7          	jalr	1162(ra) # 626 <ntas>
 1a4:	892a                	mv	s2,a0
 1a6:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 1aa:	03300993          	li	s3,51
    file[1] = '0' + i;
 1ae:	fc9404a3          	sb	s1,-55(s0)
    createfile(file, 1);
 1b2:	4585                	li	a1,1
 1b4:	fc840513          	addi	a0,s0,-56
 1b8:	00000097          	auipc	ra,0x0
 1bc:	e48080e7          	jalr	-440(ra) # 0 <createfile>
    int pid = fork();
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3be080e7          	jalr	958(ra) # 57e <fork>
    if(pid < 0){
 1c8:	04054963          	bltz	a0,21a <test0+0xa8>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
 1cc:	c13d                	beqz	a0,232 <test0+0xc0>
  for(int i = 0; i < NCHILD; i++){
 1ce:	2485                	addiw	s1,s1,1
 1d0:	0ff4f493          	andi	s1,s1,255
 1d4:	fd349de3          	bne	s1,s3,1ae <test0+0x3c>
      exit();
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait();
 1d8:	00000097          	auipc	ra,0x0
 1dc:	3b6080e7          	jalr	950(ra) # 58e <wait>
 1e0:	00000097          	auipc	ra,0x0
 1e4:	3ae080e7          	jalr	942(ra) # 58e <wait>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	3a6080e7          	jalr	934(ra) # 58e <wait>
  }
  printf("test0 done: #test-and-sets: %d\n", ntas() - n);
 1f0:	00000097          	auipc	ra,0x0
 1f4:	436080e7          	jalr	1078(ra) # 626 <ntas>
 1f8:	412505bb          	subw	a1,a0,s2
 1fc:	00001517          	auipc	a0,0x1
 200:	95450513          	addi	a0,a0,-1708 # b50 <malloc+0x174>
 204:	00000097          	auipc	ra,0x0
 208:	71a080e7          	jalr	1818(ra) # 91e <printf>
}
 20c:	70e2                	ld	ra,56(sp)
 20e:	7442                	ld	s0,48(sp)
 210:	74a2                	ld	s1,40(sp)
 212:	7902                	ld	s2,32(sp)
 214:	69e2                	ld	s3,24(sp)
 216:	6121                	addi	sp,sp,64
 218:	8082                	ret
      printf("fork failed");
 21a:	00001517          	auipc	a0,0x1
 21e:	92650513          	addi	a0,a0,-1754 # b40 <malloc+0x164>
 222:	00000097          	auipc	ra,0x0
 226:	6fc080e7          	jalr	1788(ra) # 91e <printf>
      exit();
 22a:	00000097          	auipc	ra,0x0
 22e:	35c080e7          	jalr	860(ra) # 586 <exit>
 232:	3e800493          	li	s1,1000
        readfile(file, 1);
 236:	4585                	li	a1,1
 238:	fc840513          	addi	a0,s0,-56
 23c:	00000097          	auipc	ra,0x0
 240:	e7e080e7          	jalr	-386(ra) # ba <readfile>
      for (i = 0; i < N; i++) {
 244:	34fd                	addiw	s1,s1,-1
 246:	f8e5                	bnez	s1,236 <test0+0xc4>
      unlink(file);
 248:	fc840513          	addi	a0,s0,-56
 24c:	00000097          	auipc	ra,0x0
 250:	38a080e7          	jalr	906(ra) # 5d6 <unlink>
      exit();
 254:	00000097          	auipc	ra,0x0
 258:	332080e7          	jalr	818(ra) # 586 <exit>

000000000000025c <test1>:

void test1()
{
 25c:	7179                	addi	sp,sp,-48
 25e:	f406                	sd	ra,40(sp)
 260:	f022                	sd	s0,32(sp)
 262:	ec26                	sd	s1,24(sp)
 264:	1800                	addi	s0,sp,48
  char file[3];
  
  printf("start test1\n");
 266:	00001517          	auipc	a0,0x1
 26a:	90a50513          	addi	a0,a0,-1782 # b70 <malloc+0x194>
 26e:	00000097          	auipc	ra,0x0
 272:	6b0080e7          	jalr	1712(ra) # 91e <printf>
  file[0] = 'B';
 276:	04200793          	li	a5,66
 27a:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 27e:	fc040d23          	sb	zero,-38(s0)
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 282:	03000493          	li	s1,48
 286:	fc940ca3          	sb	s1,-39(s0)
    if (i == 0) {
      createfile(file, BIG);
 28a:	06400593          	li	a1,100
 28e:	fd840513          	addi	a0,s0,-40
 292:	00000097          	auipc	ra,0x0
 296:	d6e080e7          	jalr	-658(ra) # 0 <createfile>
    file[1] = '0' + i;
 29a:	03100793          	li	a5,49
 29e:	fcf40ca3          	sb	a5,-39(s0)
    } else {
      createfile(file, 1);
 2a2:	4585                	li	a1,1
 2a4:	fd840513          	addi	a0,s0,-40
 2a8:	00000097          	auipc	ra,0x0
 2ac:	d58080e7          	jalr	-680(ra) # 0 <createfile>
    }
  }
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 2b0:	fc940ca3          	sb	s1,-39(s0)
    int pid = fork();
 2b4:	00000097          	auipc	ra,0x0
 2b8:	2ca080e7          	jalr	714(ra) # 57e <fork>
    if(pid < 0){
 2bc:	04054363          	bltz	a0,302 <test1+0xa6>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
 2c0:	cd29                	beqz	a0,31a <test1+0xbe>
    file[1] = '0' + i;
 2c2:	03100793          	li	a5,49
 2c6:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 2ca:	00000097          	auipc	ra,0x0
 2ce:	2b4080e7          	jalr	692(ra) # 57e <fork>
    if(pid < 0){
 2d2:	02054863          	bltz	a0,302 <test1+0xa6>
    if(pid == 0){
 2d6:	c925                	beqz	a0,346 <test1+0xea>
      exit();
    }
  }

  for(int i = 0; i < 2; i++){
    wait();
 2d8:	00000097          	auipc	ra,0x0
 2dc:	2b6080e7          	jalr	694(ra) # 58e <wait>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	2ae080e7          	jalr	686(ra) # 58e <wait>
  }
  printf("test1 done\n");
 2e8:	00001517          	auipc	a0,0x1
 2ec:	89850513          	addi	a0,a0,-1896 # b80 <malloc+0x1a4>
 2f0:	00000097          	auipc	ra,0x0
 2f4:	62e080e7          	jalr	1582(ra) # 91e <printf>
}
 2f8:	70a2                	ld	ra,40(sp)
 2fa:	7402                	ld	s0,32(sp)
 2fc:	64e2                	ld	s1,24(sp)
 2fe:	6145                	addi	sp,sp,48
 300:	8082                	ret
      printf("fork failed");
 302:	00001517          	auipc	a0,0x1
 306:	83e50513          	addi	a0,a0,-1986 # b40 <malloc+0x164>
 30a:	00000097          	auipc	ra,0x0
 30e:	614080e7          	jalr	1556(ra) # 91e <printf>
      exit();
 312:	00000097          	auipc	ra,0x0
 316:	274080e7          	jalr	628(ra) # 586 <exit>
    if(pid == 0){
 31a:	3e800493          	li	s1,1000
          readfile(file, BIG);
 31e:	06400593          	li	a1,100
 322:	fd840513          	addi	a0,s0,-40
 326:	00000097          	auipc	ra,0x0
 32a:	d94080e7          	jalr	-620(ra) # ba <readfile>
        for (i = 0; i < N; i++) {
 32e:	34fd                	addiw	s1,s1,-1
 330:	f4fd                	bnez	s1,31e <test1+0xc2>
        unlink(file);
 332:	fd840513          	addi	a0,s0,-40
 336:	00000097          	auipc	ra,0x0
 33a:	2a0080e7          	jalr	672(ra) # 5d6 <unlink>
        exit();
 33e:	00000097          	auipc	ra,0x0
 342:	248080e7          	jalr	584(ra) # 586 <exit>
 346:	3e800493          	li	s1,1000
          readfile(file, 1);
 34a:	4585                	li	a1,1
 34c:	fd840513          	addi	a0,s0,-40
 350:	00000097          	auipc	ra,0x0
 354:	d6a080e7          	jalr	-662(ra) # ba <readfile>
        for (i = 0; i < N; i++) {
 358:	34fd                	addiw	s1,s1,-1
 35a:	f8e5                	bnez	s1,34a <test1+0xee>
        unlink(file);
 35c:	fd840513          	addi	a0,s0,-40
 360:	00000097          	auipc	ra,0x0
 364:	276080e7          	jalr	630(ra) # 5d6 <unlink>
      exit();
 368:	00000097          	auipc	ra,0x0
 36c:	21e080e7          	jalr	542(ra) # 586 <exit>

0000000000000370 <main>:
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  test0();
 378:	00000097          	auipc	ra,0x0
 37c:	dfa080e7          	jalr	-518(ra) # 172 <test0>
  test1();
 380:	00000097          	auipc	ra,0x0
 384:	edc080e7          	jalr	-292(ra) # 25c <test1>
  exit();
 388:	00000097          	auipc	ra,0x0
 38c:	1fe080e7          	jalr	510(ra) # 586 <exit>

0000000000000390 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 396:	87aa                	mv	a5,a0
 398:	0585                	addi	a1,a1,1
 39a:	0785                	addi	a5,a5,1
 39c:	fff5c703          	lbu	a4,-1(a1)
 3a0:	fee78fa3          	sb	a4,-1(a5)
 3a4:	fb75                	bnez	a4,398 <strcpy+0x8>
    ;
  return os;
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	cb91                	beqz	a5,3ca <strcmp+0x1e>
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00f71763          	bne	a4,a5,3ca <strcmp+0x1e>
    p++, q++;
 3c0:	0505                	addi	a0,a0,1
 3c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	fbe5                	bnez	a5,3b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3ca:	0005c503          	lbu	a0,0(a1)
}
 3ce:	40a7853b          	subw	a0,a5,a0
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret

00000000000003d8 <strlen>:

uint
strlen(const char *s)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3de:	00054783          	lbu	a5,0(a0)
 3e2:	cf91                	beqz	a5,3fe <strlen+0x26>
 3e4:	0505                	addi	a0,a0,1
 3e6:	87aa                	mv	a5,a0
 3e8:	4685                	li	a3,1
 3ea:	9e89                	subw	a3,a3,a0
 3ec:	00f6853b          	addw	a0,a3,a5
 3f0:	0785                	addi	a5,a5,1
 3f2:	fff7c703          	lbu	a4,-1(a5)
 3f6:	fb7d                	bnez	a4,3ec <strlen+0x14>
    ;
  return n;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  for(n = 0; s[n]; n++)
 3fe:	4501                	li	a0,0
 400:	bfe5                	j	3f8 <strlen+0x20>

0000000000000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 408:	ce09                	beqz	a2,422 <memset+0x20>
 40a:	87aa                	mv	a5,a0
 40c:	fff6071b          	addiw	a4,a2,-1
 410:	1702                	slli	a4,a4,0x20
 412:	9301                	srli	a4,a4,0x20
 414:	0705                	addi	a4,a4,1
 416:	972a                	add	a4,a4,a0
    cdst[i] = c;
 418:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 41c:	0785                	addi	a5,a5,1
 41e:	fee79de3          	bne	a5,a4,418 <memset+0x16>
  }
  return dst;
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret

0000000000000428 <strchr>:

char*
strchr(const char *s, char c)
{
 428:	1141                	addi	sp,sp,-16
 42a:	e422                	sd	s0,8(sp)
 42c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 42e:	00054783          	lbu	a5,0(a0)
 432:	cb99                	beqz	a5,448 <strchr+0x20>
    if(*s == c)
 434:	00f58763          	beq	a1,a5,442 <strchr+0x1a>
  for(; *s; s++)
 438:	0505                	addi	a0,a0,1
 43a:	00054783          	lbu	a5,0(a0)
 43e:	fbfd                	bnez	a5,434 <strchr+0xc>
      return (char*)s;
  return 0;
 440:	4501                	li	a0,0
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  return 0;
 448:	4501                	li	a0,0
 44a:	bfe5                	j	442 <strchr+0x1a>

000000000000044c <gets>:

char*
gets(char *buf, int max)
{
 44c:	711d                	addi	sp,sp,-96
 44e:	ec86                	sd	ra,88(sp)
 450:	e8a2                	sd	s0,80(sp)
 452:	e4a6                	sd	s1,72(sp)
 454:	e0ca                	sd	s2,64(sp)
 456:	fc4e                	sd	s3,56(sp)
 458:	f852                	sd	s4,48(sp)
 45a:	f456                	sd	s5,40(sp)
 45c:	f05a                	sd	s6,32(sp)
 45e:	ec5e                	sd	s7,24(sp)
 460:	1080                	addi	s0,sp,96
 462:	8baa                	mv	s7,a0
 464:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 466:	892a                	mv	s2,a0
 468:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 46a:	4aa9                	li	s5,10
 46c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 46e:	89a6                	mv	s3,s1
 470:	2485                	addiw	s1,s1,1
 472:	0344d863          	bge	s1,s4,4a2 <gets+0x56>
    cc = read(0, &c, 1);
 476:	4605                	li	a2,1
 478:	faf40593          	addi	a1,s0,-81
 47c:	4501                	li	a0,0
 47e:	00000097          	auipc	ra,0x0
 482:	120080e7          	jalr	288(ra) # 59e <read>
    if(cc < 1)
 486:	00a05e63          	blez	a0,4a2 <gets+0x56>
    buf[i++] = c;
 48a:	faf44783          	lbu	a5,-81(s0)
 48e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 492:	01578763          	beq	a5,s5,4a0 <gets+0x54>
 496:	0905                	addi	s2,s2,1
 498:	fd679be3          	bne	a5,s6,46e <gets+0x22>
  for(i=0; i+1 < max; ){
 49c:	89a6                	mv	s3,s1
 49e:	a011                	j	4a2 <gets+0x56>
 4a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4a2:	99de                	add	s3,s3,s7
 4a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 4a8:	855e                	mv	a0,s7
 4aa:	60e6                	ld	ra,88(sp)
 4ac:	6446                	ld	s0,80(sp)
 4ae:	64a6                	ld	s1,72(sp)
 4b0:	6906                	ld	s2,64(sp)
 4b2:	79e2                	ld	s3,56(sp)
 4b4:	7a42                	ld	s4,48(sp)
 4b6:	7aa2                	ld	s5,40(sp)
 4b8:	7b02                	ld	s6,32(sp)
 4ba:	6be2                	ld	s7,24(sp)
 4bc:	6125                	addi	sp,sp,96
 4be:	8082                	ret

00000000000004c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4c0:	1101                	addi	sp,sp,-32
 4c2:	ec06                	sd	ra,24(sp)
 4c4:	e822                	sd	s0,16(sp)
 4c6:	e426                	sd	s1,8(sp)
 4c8:	e04a                	sd	s2,0(sp)
 4ca:	1000                	addi	s0,sp,32
 4cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ce:	4581                	li	a1,0
 4d0:	00000097          	auipc	ra,0x0
 4d4:	0f6080e7          	jalr	246(ra) # 5c6 <open>
  if(fd < 0)
 4d8:	02054563          	bltz	a0,502 <stat+0x42>
 4dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4de:	85ca                	mv	a1,s2
 4e0:	00000097          	auipc	ra,0x0
 4e4:	0fe080e7          	jalr	254(ra) # 5de <fstat>
 4e8:	892a                	mv	s2,a0
  close(fd);
 4ea:	8526                	mv	a0,s1
 4ec:	00000097          	auipc	ra,0x0
 4f0:	0c2080e7          	jalr	194(ra) # 5ae <close>
  return r;
}
 4f4:	854a                	mv	a0,s2
 4f6:	60e2                	ld	ra,24(sp)
 4f8:	6442                	ld	s0,16(sp)
 4fa:	64a2                	ld	s1,8(sp)
 4fc:	6902                	ld	s2,0(sp)
 4fe:	6105                	addi	sp,sp,32
 500:	8082                	ret
    return -1;
 502:	597d                	li	s2,-1
 504:	bfc5                	j	4f4 <stat+0x34>

0000000000000506 <atoi>:

int
atoi(const char *s)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 50c:	00054603          	lbu	a2,0(a0)
 510:	fd06079b          	addiw	a5,a2,-48
 514:	0ff7f793          	andi	a5,a5,255
 518:	4725                	li	a4,9
 51a:	02f76963          	bltu	a4,a5,54c <atoi+0x46>
 51e:	86aa                	mv	a3,a0
  n = 0;
 520:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 522:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 524:	0685                	addi	a3,a3,1
 526:	0025179b          	slliw	a5,a0,0x2
 52a:	9fa9                	addw	a5,a5,a0
 52c:	0017979b          	slliw	a5,a5,0x1
 530:	9fb1                	addw	a5,a5,a2
 532:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 536:	0006c603          	lbu	a2,0(a3)
 53a:	fd06071b          	addiw	a4,a2,-48
 53e:	0ff77713          	andi	a4,a4,255
 542:	fee5f1e3          	bgeu	a1,a4,524 <atoi+0x1e>
  return n;
}
 546:	6422                	ld	s0,8(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret
  n = 0;
 54c:	4501                	li	a0,0
 54e:	bfe5                	j	546 <atoi+0x40>

0000000000000550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 550:	1141                	addi	sp,sp,-16
 552:	e422                	sd	s0,8(sp)
 554:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 556:	02c05163          	blez	a2,578 <memmove+0x28>
 55a:	fff6071b          	addiw	a4,a2,-1
 55e:	1702                	slli	a4,a4,0x20
 560:	9301                	srli	a4,a4,0x20
 562:	0705                	addi	a4,a4,1
 564:	972a                	add	a4,a4,a0
  dst = vdst;
 566:	87aa                	mv	a5,a0
    *dst++ = *src++;
 568:	0585                	addi	a1,a1,1
 56a:	0785                	addi	a5,a5,1
 56c:	fff5c683          	lbu	a3,-1(a1)
 570:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 574:	fee79ae3          	bne	a5,a4,568 <memmove+0x18>
  return vdst;
}
 578:	6422                	ld	s0,8(sp)
 57a:	0141                	addi	sp,sp,16
 57c:	8082                	ret

000000000000057e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 57e:	4885                	li	a7,1
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <exit>:
.global exit
exit:
 li a7, SYS_exit
 586:	4889                	li	a7,2
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <wait>:
.global wait
wait:
 li a7, SYS_wait
 58e:	488d                	li	a7,3
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 596:	4891                	li	a7,4
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <read>:
.global read
read:
 li a7, SYS_read
 59e:	4895                	li	a7,5
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <write>:
.global write
write:
 li a7, SYS_write
 5a6:	48c1                	li	a7,16
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <close>:
.global close
close:
 li a7, SYS_close
 5ae:	48d5                	li	a7,21
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5b6:	4899                	li	a7,6
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <exec>:
.global exec
exec:
 li a7, SYS_exec
 5be:	489d                	li	a7,7
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <open>:
.global open
open:
 li a7, SYS_open
 5c6:	48bd                	li	a7,15
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ce:	48c5                	li	a7,17
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d6:	48c9                	li	a7,18
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5de:	48a1                	li	a7,8
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <link>:
.global link
link:
 li a7, SYS_link
 5e6:	48cd                	li	a7,19
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ee:	48d1                	li	a7,20
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5f6:	48a5                	li	a7,9
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 5fe:	48a9                	li	a7,10
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 606:	48ad                	li	a7,11
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 60e:	48b1                	li	a7,12
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 616:	48b5                	li	a7,13
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 61e:	48b9                	li	a7,14
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 626:	48d9                	li	a7,22
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <crash>:
.global crash
crash:
 li a7, SYS_crash
 62e:	48dd                	li	a7,23
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <mount>:
.global mount
mount:
 li a7, SYS_mount
 636:	48e1                	li	a7,24
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <umount>:
.global umount
umount:
 li a7, SYS_umount
 63e:	48e5                	li	a7,25
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 646:	1101                	addi	sp,sp,-32
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	1000                	addi	s0,sp,32
 64e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 652:	4605                	li	a2,1
 654:	fef40593          	addi	a1,s0,-17
 658:	00000097          	auipc	ra,0x0
 65c:	f4e080e7          	jalr	-178(ra) # 5a6 <write>
}
 660:	60e2                	ld	ra,24(sp)
 662:	6442                	ld	s0,16(sp)
 664:	6105                	addi	sp,sp,32
 666:	8082                	ret

0000000000000668 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 668:	7139                	addi	sp,sp,-64
 66a:	fc06                	sd	ra,56(sp)
 66c:	f822                	sd	s0,48(sp)
 66e:	f426                	sd	s1,40(sp)
 670:	f04a                	sd	s2,32(sp)
 672:	ec4e                	sd	s3,24(sp)
 674:	0080                	addi	s0,sp,64
 676:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 678:	c299                	beqz	a3,67e <printint+0x16>
 67a:	0805c863          	bltz	a1,70a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 67e:	2581                	sext.w	a1,a1
  neg = 0;
 680:	4881                	li	a7,0
 682:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 686:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 688:	2601                	sext.w	a2,a2
 68a:	00000517          	auipc	a0,0x0
 68e:	50e50513          	addi	a0,a0,1294 # b98 <digits>
 692:	883a                	mv	a6,a4
 694:	2705                	addiw	a4,a4,1
 696:	02c5f7bb          	remuw	a5,a1,a2
 69a:	1782                	slli	a5,a5,0x20
 69c:	9381                	srli	a5,a5,0x20
 69e:	97aa                	add	a5,a5,a0
 6a0:	0007c783          	lbu	a5,0(a5)
 6a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6a8:	0005879b          	sext.w	a5,a1
 6ac:	02c5d5bb          	divuw	a1,a1,a2
 6b0:	0685                	addi	a3,a3,1
 6b2:	fec7f0e3          	bgeu	a5,a2,692 <printint+0x2a>
  if(neg)
 6b6:	00088b63          	beqz	a7,6cc <printint+0x64>
    buf[i++] = '-';
 6ba:	fd040793          	addi	a5,s0,-48
 6be:	973e                	add	a4,a4,a5
 6c0:	02d00793          	li	a5,45
 6c4:	fef70823          	sb	a5,-16(a4)
 6c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6cc:	02e05863          	blez	a4,6fc <printint+0x94>
 6d0:	fc040793          	addi	a5,s0,-64
 6d4:	00e78933          	add	s2,a5,a4
 6d8:	fff78993          	addi	s3,a5,-1
 6dc:	99ba                	add	s3,s3,a4
 6de:	377d                	addiw	a4,a4,-1
 6e0:	1702                	slli	a4,a4,0x20
 6e2:	9301                	srli	a4,a4,0x20
 6e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e8:	fff94583          	lbu	a1,-1(s2)
 6ec:	8526                	mv	a0,s1
 6ee:	00000097          	auipc	ra,0x0
 6f2:	f58080e7          	jalr	-168(ra) # 646 <putc>
  while(--i >= 0)
 6f6:	197d                	addi	s2,s2,-1
 6f8:	ff3918e3          	bne	s2,s3,6e8 <printint+0x80>
}
 6fc:	70e2                	ld	ra,56(sp)
 6fe:	7442                	ld	s0,48(sp)
 700:	74a2                	ld	s1,40(sp)
 702:	7902                	ld	s2,32(sp)
 704:	69e2                	ld	s3,24(sp)
 706:	6121                	addi	sp,sp,64
 708:	8082                	ret
    x = -xx;
 70a:	40b005bb          	negw	a1,a1
    neg = 1;
 70e:	4885                	li	a7,1
    x = -xx;
 710:	bf8d                	j	682 <printint+0x1a>

0000000000000712 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 712:	7119                	addi	sp,sp,-128
 714:	fc86                	sd	ra,120(sp)
 716:	f8a2                	sd	s0,112(sp)
 718:	f4a6                	sd	s1,104(sp)
 71a:	f0ca                	sd	s2,96(sp)
 71c:	ecce                	sd	s3,88(sp)
 71e:	e8d2                	sd	s4,80(sp)
 720:	e4d6                	sd	s5,72(sp)
 722:	e0da                	sd	s6,64(sp)
 724:	fc5e                	sd	s7,56(sp)
 726:	f862                	sd	s8,48(sp)
 728:	f466                	sd	s9,40(sp)
 72a:	f06a                	sd	s10,32(sp)
 72c:	ec6e                	sd	s11,24(sp)
 72e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 730:	0005c903          	lbu	s2,0(a1)
 734:	18090f63          	beqz	s2,8d2 <vprintf+0x1c0>
 738:	8aaa                	mv	s5,a0
 73a:	8b32                	mv	s6,a2
 73c:	00158493          	addi	s1,a1,1
  state = 0;
 740:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 742:	02500a13          	li	s4,37
      if(c == 'd'){
 746:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 74a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 74e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 752:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 756:	00000b97          	auipc	s7,0x0
 75a:	442b8b93          	addi	s7,s7,1090 # b98 <digits>
 75e:	a839                	j	77c <vprintf+0x6a>
        putc(fd, c);
 760:	85ca                	mv	a1,s2
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	ee2080e7          	jalr	-286(ra) # 646 <putc>
 76c:	a019                	j	772 <vprintf+0x60>
    } else if(state == '%'){
 76e:	01498f63          	beq	s3,s4,78c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 772:	0485                	addi	s1,s1,1
 774:	fff4c903          	lbu	s2,-1(s1)
 778:	14090d63          	beqz	s2,8d2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 77c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 780:	fe0997e3          	bnez	s3,76e <vprintf+0x5c>
      if(c == '%'){
 784:	fd479ee3          	bne	a5,s4,760 <vprintf+0x4e>
        state = '%';
 788:	89be                	mv	s3,a5
 78a:	b7e5                	j	772 <vprintf+0x60>
      if(c == 'd'){
 78c:	05878063          	beq	a5,s8,7cc <vprintf+0xba>
      } else if(c == 'l') {
 790:	05978c63          	beq	a5,s9,7e8 <vprintf+0xd6>
      } else if(c == 'x') {
 794:	07a78863          	beq	a5,s10,804 <vprintf+0xf2>
      } else if(c == 'p') {
 798:	09b78463          	beq	a5,s11,820 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 79c:	07300713          	li	a4,115
 7a0:	0ce78663          	beq	a5,a4,86c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7a4:	06300713          	li	a4,99
 7a8:	0ee78e63          	beq	a5,a4,8a4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7ac:	11478863          	beq	a5,s4,8bc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b0:	85d2                	mv	a1,s4
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e92080e7          	jalr	-366(ra) # 646 <putc>
        putc(fd, c);
 7bc:	85ca                	mv	a1,s2
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e86080e7          	jalr	-378(ra) # 646 <putc>
      }
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b765                	j	772 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7cc:	008b0913          	addi	s2,s6,8
 7d0:	4685                	li	a3,1
 7d2:	4629                	li	a2,10
 7d4:	000b2583          	lw	a1,0(s6)
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	e8e080e7          	jalr	-370(ra) # 668 <printint>
 7e2:	8b4a                	mv	s6,s2
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b771                	j	772 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e8:	008b0913          	addi	s2,s6,8
 7ec:	4681                	li	a3,0
 7ee:	4629                	li	a2,10
 7f0:	000b2583          	lw	a1,0(s6)
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e72080e7          	jalr	-398(ra) # 668 <printint>
 7fe:	8b4a                	mv	s6,s2
      state = 0;
 800:	4981                	li	s3,0
 802:	bf85                	j	772 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 804:	008b0913          	addi	s2,s6,8
 808:	4681                	li	a3,0
 80a:	4641                	li	a2,16
 80c:	000b2583          	lw	a1,0(s6)
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	e56080e7          	jalr	-426(ra) # 668 <printint>
 81a:	8b4a                	mv	s6,s2
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bf91                	j	772 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 820:	008b0793          	addi	a5,s6,8
 824:	f8f43423          	sd	a5,-120(s0)
 828:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 82c:	03000593          	li	a1,48
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e14080e7          	jalr	-492(ra) # 646 <putc>
  putc(fd, 'x');
 83a:	85ea                	mv	a1,s10
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	e08080e7          	jalr	-504(ra) # 646 <putc>
 846:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 848:	03c9d793          	srli	a5,s3,0x3c
 84c:	97de                	add	a5,a5,s7
 84e:	0007c583          	lbu	a1,0(a5)
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	df2080e7          	jalr	-526(ra) # 646 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85c:	0992                	slli	s3,s3,0x4
 85e:	397d                	addiw	s2,s2,-1
 860:	fe0914e3          	bnez	s2,848 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 864:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 868:	4981                	li	s3,0
 86a:	b721                	j	772 <vprintf+0x60>
        s = va_arg(ap, char*);
 86c:	008b0993          	addi	s3,s6,8
 870:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 874:	02090163          	beqz	s2,896 <vprintf+0x184>
        while(*s != 0){
 878:	00094583          	lbu	a1,0(s2)
 87c:	c9a1                	beqz	a1,8cc <vprintf+0x1ba>
          putc(fd, *s);
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	dc6080e7          	jalr	-570(ra) # 646 <putc>
          s++;
 888:	0905                	addi	s2,s2,1
        while(*s != 0){
 88a:	00094583          	lbu	a1,0(s2)
 88e:	f9e5                	bnez	a1,87e <vprintf+0x16c>
        s = va_arg(ap, char*);
 890:	8b4e                	mv	s6,s3
      state = 0;
 892:	4981                	li	s3,0
 894:	bdf9                	j	772 <vprintf+0x60>
          s = "(null)";
 896:	00000917          	auipc	s2,0x0
 89a:	2fa90913          	addi	s2,s2,762 # b90 <malloc+0x1b4>
        while(*s != 0){
 89e:	02800593          	li	a1,40
 8a2:	bff1                	j	87e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8a4:	008b0913          	addi	s2,s6,8
 8a8:	000b4583          	lbu	a1,0(s6)
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	d98080e7          	jalr	-616(ra) # 646 <putc>
 8b6:	8b4a                	mv	s6,s2
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	bd65                	j	772 <vprintf+0x60>
        putc(fd, c);
 8bc:	85d2                	mv	a1,s4
 8be:	8556                	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	d86080e7          	jalr	-634(ra) # 646 <putc>
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	b565                	j	772 <vprintf+0x60>
        s = va_arg(ap, char*);
 8cc:	8b4e                	mv	s6,s3
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b54d                	j	772 <vprintf+0x60>
    }
  }
}
 8d2:	70e6                	ld	ra,120(sp)
 8d4:	7446                	ld	s0,112(sp)
 8d6:	74a6                	ld	s1,104(sp)
 8d8:	7906                	ld	s2,96(sp)
 8da:	69e6                	ld	s3,88(sp)
 8dc:	6a46                	ld	s4,80(sp)
 8de:	6aa6                	ld	s5,72(sp)
 8e0:	6b06                	ld	s6,64(sp)
 8e2:	7be2                	ld	s7,56(sp)
 8e4:	7c42                	ld	s8,48(sp)
 8e6:	7ca2                	ld	s9,40(sp)
 8e8:	7d02                	ld	s10,32(sp)
 8ea:	6de2                	ld	s11,24(sp)
 8ec:	6109                	addi	sp,sp,128
 8ee:	8082                	ret

00000000000008f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f0:	715d                	addi	sp,sp,-80
 8f2:	ec06                	sd	ra,24(sp)
 8f4:	e822                	sd	s0,16(sp)
 8f6:	1000                	addi	s0,sp,32
 8f8:	e010                	sd	a2,0(s0)
 8fa:	e414                	sd	a3,8(s0)
 8fc:	e818                	sd	a4,16(s0)
 8fe:	ec1c                	sd	a5,24(s0)
 900:	03043023          	sd	a6,32(s0)
 904:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 908:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 90c:	8622                	mv	a2,s0
 90e:	00000097          	auipc	ra,0x0
 912:	e04080e7          	jalr	-508(ra) # 712 <vprintf>
}
 916:	60e2                	ld	ra,24(sp)
 918:	6442                	ld	s0,16(sp)
 91a:	6161                	addi	sp,sp,80
 91c:	8082                	ret

000000000000091e <printf>:

void
printf(const char *fmt, ...)
{
 91e:	711d                	addi	sp,sp,-96
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	1000                	addi	s0,sp,32
 926:	e40c                	sd	a1,8(s0)
 928:	e810                	sd	a2,16(s0)
 92a:	ec14                	sd	a3,24(s0)
 92c:	f018                	sd	a4,32(s0)
 92e:	f41c                	sd	a5,40(s0)
 930:	03043823          	sd	a6,48(s0)
 934:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 938:	00840613          	addi	a2,s0,8
 93c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 940:	85aa                	mv	a1,a0
 942:	4505                	li	a0,1
 944:	00000097          	auipc	ra,0x0
 948:	dce080e7          	jalr	-562(ra) # 712 <vprintf>
}
 94c:	60e2                	ld	ra,24(sp)
 94e:	6442                	ld	s0,16(sp)
 950:	6125                	addi	sp,sp,96
 952:	8082                	ret

0000000000000954 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 954:	1141                	addi	sp,sp,-16
 956:	e422                	sd	s0,8(sp)
 958:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 95a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	00000797          	auipc	a5,0x0
 962:	2527b783          	ld	a5,594(a5) # bb0 <freep>
 966:	a805                	j	996 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 968:	4618                	lw	a4,8(a2)
 96a:	9db9                	addw	a1,a1,a4
 96c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	6318                	ld	a4,0(a4)
 974:	fee53823          	sd	a4,-16(a0)
 978:	a091                	j	9bc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 97a:	ff852703          	lw	a4,-8(a0)
 97e:	9e39                	addw	a2,a2,a4
 980:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 982:	ff053703          	ld	a4,-16(a0)
 986:	e398                	sd	a4,0(a5)
 988:	a099                	j	9ce <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98a:	6398                	ld	a4,0(a5)
 98c:	00e7e463          	bltu	a5,a4,994 <free+0x40>
 990:	00e6ea63          	bltu	a3,a4,9a4 <free+0x50>
{
 994:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 996:	fed7fae3          	bgeu	a5,a3,98a <free+0x36>
 99a:	6398                	ld	a4,0(a5)
 99c:	00e6e463          	bltu	a3,a4,9a4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a0:	fee7eae3          	bltu	a5,a4,994 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9a4:	ff852583          	lw	a1,-8(a0)
 9a8:	6390                	ld	a2,0(a5)
 9aa:	02059713          	slli	a4,a1,0x20
 9ae:	9301                	srli	a4,a4,0x20
 9b0:	0712                	slli	a4,a4,0x4
 9b2:	9736                	add	a4,a4,a3
 9b4:	fae60ae3          	beq	a2,a4,968 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9bc:	4790                	lw	a2,8(a5)
 9be:	02061713          	slli	a4,a2,0x20
 9c2:	9301                	srli	a4,a4,0x20
 9c4:	0712                	slli	a4,a4,0x4
 9c6:	973e                	add	a4,a4,a5
 9c8:	fae689e3          	beq	a3,a4,97a <free+0x26>
  } else
    p->s.ptr = bp;
 9cc:	e394                	sd	a3,0(a5)
  freep = p;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	1ef73123          	sd	a5,482(a4) # bb0 <freep>
}
 9d6:	6422                	ld	s0,8(sp)
 9d8:	0141                	addi	sp,sp,16
 9da:	8082                	ret

00000000000009dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9dc:	7139                	addi	sp,sp,-64
 9de:	fc06                	sd	ra,56(sp)
 9e0:	f822                	sd	s0,48(sp)
 9e2:	f426                	sd	s1,40(sp)
 9e4:	f04a                	sd	s2,32(sp)
 9e6:	ec4e                	sd	s3,24(sp)
 9e8:	e852                	sd	s4,16(sp)
 9ea:	e456                	sd	s5,8(sp)
 9ec:	e05a                	sd	s6,0(sp)
 9ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f0:	02051493          	slli	s1,a0,0x20
 9f4:	9081                	srli	s1,s1,0x20
 9f6:	04bd                	addi	s1,s1,15
 9f8:	8091                	srli	s1,s1,0x4
 9fa:	0014899b          	addiw	s3,s1,1
 9fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a00:	00000517          	auipc	a0,0x0
 a04:	1b053503          	ld	a0,432(a0) # bb0 <freep>
 a08:	c515                	beqz	a0,a34 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	02977f63          	bgeu	a4,s1,a4c <malloc+0x70>
 a12:	8a4e                	mv	s4,s3
 a14:	0009871b          	sext.w	a4,s3
 a18:	6685                	lui	a3,0x1
 a1a:	00d77363          	bgeu	a4,a3,a20 <malloc+0x44>
 a1e:	6a05                	lui	s4,0x1
 a20:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a24:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a28:	00000917          	auipc	s2,0x0
 a2c:	18890913          	addi	s2,s2,392 # bb0 <freep>
  if(p == (char*)-1)
 a30:	5afd                	li	s5,-1
 a32:	a88d                	j	aa4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a34:	00000797          	auipc	a5,0x0
 a38:	18478793          	addi	a5,a5,388 # bb8 <base>
 a3c:	00000717          	auipc	a4,0x0
 a40:	16f73a23          	sd	a5,372(a4) # bb0 <freep>
 a44:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a46:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4a:	b7e1                	j	a12 <malloc+0x36>
      if(p->s.size == nunits)
 a4c:	02e48b63          	beq	s1,a4,a82 <malloc+0xa6>
        p->s.size -= nunits;
 a50:	4137073b          	subw	a4,a4,s3
 a54:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a56:	1702                	slli	a4,a4,0x20
 a58:	9301                	srli	a4,a4,0x20
 a5a:	0712                	slli	a4,a4,0x4
 a5c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a5e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a62:	00000717          	auipc	a4,0x0
 a66:	14a73723          	sd	a0,334(a4) # bb0 <freep>
      return (void*)(p + 1);
 a6a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a6e:	70e2                	ld	ra,56(sp)
 a70:	7442                	ld	s0,48(sp)
 a72:	74a2                	ld	s1,40(sp)
 a74:	7902                	ld	s2,32(sp)
 a76:	69e2                	ld	s3,24(sp)
 a78:	6a42                	ld	s4,16(sp)
 a7a:	6aa2                	ld	s5,8(sp)
 a7c:	6b02                	ld	s6,0(sp)
 a7e:	6121                	addi	sp,sp,64
 a80:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a82:	6398                	ld	a4,0(a5)
 a84:	e118                	sd	a4,0(a0)
 a86:	bff1                	j	a62 <malloc+0x86>
  hp->s.size = nu;
 a88:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a8c:	0541                	addi	a0,a0,16
 a8e:	00000097          	auipc	ra,0x0
 a92:	ec6080e7          	jalr	-314(ra) # 954 <free>
  return freep;
 a96:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a9a:	d971                	beqz	a0,a6e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9e:	4798                	lw	a4,8(a5)
 aa0:	fa9776e3          	bgeu	a4,s1,a4c <malloc+0x70>
    if(p == freep)
 aa4:	00093703          	ld	a4,0(s2)
 aa8:	853e                	mv	a0,a5
 aaa:	fef719e3          	bne	a4,a5,a9c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aae:	8552                	mv	a0,s4
 ab0:	00000097          	auipc	ra,0x0
 ab4:	b5e080e7          	jalr	-1186(ra) # 60e <sbrk>
  if(p == (char*)-1)
 ab8:	fd5518e3          	bne	a0,s5,a88 <malloc+0xac>
        return 0;
 abc:	4501                	li	a0,0
 abe:	bf45                	j	a6e <malloc+0x92>
