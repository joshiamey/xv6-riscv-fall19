
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	8a090913          	addi	s2,s2,-1888 # 8b0 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	2fc080e7          	jalr	764(ra) # 31c <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05763          	blez	a0,58 <cat+0x58>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	2f0080e7          	jalr	752(ra) # 324 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      printf("cat: write error\n");
  40:	00001517          	auipc	a0,0x1
  44:	80050513          	addi	a0,a0,-2048 # 840 <malloc+0xe6>
  48:	00000097          	auipc	ra,0x0
  4c:	654080e7          	jalr	1620(ra) # 69c <printf>
      exit();
  50:	00000097          	auipc	ra,0x0
  54:	2b4080e7          	jalr	692(ra) # 304 <exit>
    }
  }
  if(n < 0){
  58:	00054963          	bltz	a0,6a <cat+0x6a>
    printf("cat: read error\n");
    exit();
  }
}
  5c:	70a2                	ld	ra,40(sp)
  5e:	7402                	ld	s0,32(sp)
  60:	64e2                	ld	s1,24(sp)
  62:	6942                	ld	s2,16(sp)
  64:	69a2                	ld	s3,8(sp)
  66:	6145                	addi	sp,sp,48
  68:	8082                	ret
    printf("cat: read error\n");
  6a:	00000517          	auipc	a0,0x0
  6e:	7ee50513          	addi	a0,a0,2030 # 858 <malloc+0xfe>
  72:	00000097          	auipc	ra,0x0
  76:	62a080e7          	jalr	1578(ra) # 69c <printf>
    exit();
  7a:	00000097          	auipc	ra,0x0
  7e:	28a080e7          	jalr	650(ra) # 304 <exit>

0000000000000082 <main>:

int
main(int argc, char *argv[])
{
  82:	7179                	addi	sp,sp,-48
  84:	f406                	sd	ra,40(sp)
  86:	f022                	sd	s0,32(sp)
  88:	ec26                	sd	s1,24(sp)
  8a:	e84a                	sd	s2,16(sp)
  8c:	e44e                	sd	s3,8(sp)
  8e:	e052                	sd	s4,0(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  92:	4785                	li	a5,1
  94:	04a7d663          	bge	a5,a0,e0 <main+0x5e>
  98:	00858913          	addi	s2,a1,8
  9c:	ffe5099b          	addiw	s3,a0,-2
  a0:	1982                	slli	s3,s3,0x20
  a2:	0209d993          	srli	s3,s3,0x20
  a6:	098e                	slli	s3,s3,0x3
  a8:	05c1                	addi	a1,a1,16
  aa:	99ae                	add	s3,s3,a1
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  ac:	4581                	li	a1,0
  ae:	00093503          	ld	a0,0(s2)
  b2:	00000097          	auipc	ra,0x0
  b6:	292080e7          	jalr	658(ra) # 344 <open>
  ba:	84aa                	mv	s1,a0
  bc:	02054b63          	bltz	a0,f2 <main+0x70>
      printf("cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  c0:	00000097          	auipc	ra,0x0
  c4:	f40080e7          	jalr	-192(ra) # 0 <cat>
    close(fd);
  c8:	8526                	mv	a0,s1
  ca:	00000097          	auipc	ra,0x0
  ce:	262080e7          	jalr	610(ra) # 32c <close>
  for(i = 1; i < argc; i++){
  d2:	0921                	addi	s2,s2,8
  d4:	fd391ce3          	bne	s2,s3,ac <main+0x2a>
  }
  exit();
  d8:	00000097          	auipc	ra,0x0
  dc:	22c080e7          	jalr	556(ra) # 304 <exit>
    cat(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	f1e080e7          	jalr	-226(ra) # 0 <cat>
    exit();
  ea:	00000097          	auipc	ra,0x0
  ee:	21a080e7          	jalr	538(ra) # 304 <exit>
      printf("cat: cannot open %s\n", argv[i]);
  f2:	00093583          	ld	a1,0(s2)
  f6:	00000517          	auipc	a0,0x0
  fa:	77a50513          	addi	a0,a0,1914 # 870 <malloc+0x116>
  fe:	00000097          	auipc	ra,0x0
 102:	59e080e7          	jalr	1438(ra) # 69c <printf>
      exit();
 106:	00000097          	auipc	ra,0x0
 10a:	1fe080e7          	jalr	510(ra) # 304 <exit>

000000000000010e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 114:	87aa                	mv	a5,a0
 116:	0585                	addi	a1,a1,1
 118:	0785                	addi	a5,a5,1
 11a:	fff5c703          	lbu	a4,-1(a1)
 11e:	fee78fa3          	sb	a4,-1(a5)
 122:	fb75                	bnez	a4,116 <strcpy+0x8>
    ;
  return os;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb91                	beqz	a5,148 <strcmp+0x1e>
 136:	0005c703          	lbu	a4,0(a1)
 13a:	00f71763          	bne	a4,a5,148 <strcmp+0x1e>
    p++, q++;
 13e:	0505                	addi	a0,a0,1
 140:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 142:	00054783          	lbu	a5,0(a0)
 146:	fbe5                	bnez	a5,136 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 148:	0005c503          	lbu	a0,0(a1)
}
 14c:	40a7853b          	subw	a0,a5,a0
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cf91                	beqz	a5,17c <strlen+0x26>
 162:	0505                	addi	a0,a0,1
 164:	87aa                	mv	a5,a0
 166:	4685                	li	a3,1
 168:	9e89                	subw	a3,a3,a0
 16a:	00f6853b          	addw	a0,a3,a5
 16e:	0785                	addi	a5,a5,1
 170:	fff7c703          	lbu	a4,-1(a5)
 174:	fb7d                	bnez	a4,16a <strlen+0x14>
    ;
  return n;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret
  for(n = 0; s[n]; n++)
 17c:	4501                	li	a0,0
 17e:	bfe5                	j	176 <strlen+0x20>

0000000000000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 186:	ce09                	beqz	a2,1a0 <memset+0x20>
 188:	87aa                	mv	a5,a0
 18a:	fff6071b          	addiw	a4,a2,-1
 18e:	1702                	slli	a4,a4,0x20
 190:	9301                	srli	a4,a4,0x20
 192:	0705                	addi	a4,a4,1
 194:	972a                	add	a4,a4,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x16>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addiw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	addi	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	120080e7          	jalr	288(ra) # 31c <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	addi	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e426                	sd	s1,8(sp)
 246:	e04a                	sd	s2,0(sp)
 248:	1000                	addi	s0,sp,32
 24a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	4581                	li	a1,0
 24e:	00000097          	auipc	ra,0x0
 252:	0f6080e7          	jalr	246(ra) # 344 <open>
  if(fd < 0)
 256:	02054563          	bltz	a0,280 <stat+0x42>
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	0fe080e7          	jalr	254(ra) # 35c <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	0c2080e7          	jalr	194(ra) # 32c <close>
  return r;
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	64a2                	ld	s1,8(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfc5                	j	272 <stat+0x34>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054603          	lbu	a2,0(a0)
 28e:	fd06079b          	addiw	a5,a2,-48
 292:	0ff7f793          	andi	a5,a5,255
 296:	4725                	li	a4,9
 298:	02f76963          	bltu	a4,a5,2ca <atoi+0x46>
 29c:	86aa                	mv	a3,a0
  n = 0;
 29e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2a0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2a2:	0685                	addi	a3,a3,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb1                	addw	a5,a5,a2
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	0006c603          	lbu	a2,0(a3)
 2b8:	fd06071b          	addiw	a4,a2,-48
 2bc:	0ff77713          	andi	a4,a4,255
 2c0:	fee5f1e3          	bgeu	a1,a4,2a2 <atoi+0x1e>
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <atoi+0x40>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d4:	02c05163          	blez	a2,2f6 <memmove+0x28>
 2d8:	fff6071b          	addiw	a4,a2,-1
 2dc:	1702                	slli	a4,a4,0x20
 2de:	9301                	srli	a4,a4,0x20
 2e0:	0705                	addi	a4,a4,1
 2e2:	972a                	add	a4,a4,a0
  dst = vdst;
 2e4:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2e6:	0585                	addi	a1,a1,1
 2e8:	0785                	addi	a5,a5,1
 2ea:	fff5c683          	lbu	a3,-1(a1)
 2ee:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2f2:	fee79ae3          	bne	a5,a4,2e6 <memmove+0x18>
  return vdst;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <crash>:
.global crash
crash:
 li a7, SYS_crash
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mount>:
.global mount
mount:
 li a7, SYS_mount
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <umount>:
.global umount
umount:
 li a7, SYS_umount
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c4:	1101                	addi	sp,sp,-32
 3c6:	ec06                	sd	ra,24(sp)
 3c8:	e822                	sd	s0,16(sp)
 3ca:	1000                	addi	s0,sp,32
 3cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	fef40593          	addi	a1,s0,-17
 3d6:	00000097          	auipc	ra,0x0
 3da:	f4e080e7          	jalr	-178(ra) # 324 <write>
}
 3de:	60e2                	ld	ra,24(sp)
 3e0:	6442                	ld	s0,16(sp)
 3e2:	6105                	addi	sp,sp,32
 3e4:	8082                	ret

00000000000003e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e6:	7139                	addi	sp,sp,-64
 3e8:	fc06                	sd	ra,56(sp)
 3ea:	f822                	sd	s0,48(sp)
 3ec:	f426                	sd	s1,40(sp)
 3ee:	f04a                	sd	s2,32(sp)
 3f0:	ec4e                	sd	s3,24(sp)
 3f2:	0080                	addi	s0,sp,64
 3f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f6:	c299                	beqz	a3,3fc <printint+0x16>
 3f8:	0805c863          	bltz	a1,488 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fc:	2581                	sext.w	a1,a1
  neg = 0;
 3fe:	4881                	li	a7,0
 400:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 404:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 406:	2601                	sext.w	a2,a2
 408:	00000517          	auipc	a0,0x0
 40c:	48850513          	addi	a0,a0,1160 # 890 <digits>
 410:	883a                	mv	a6,a4
 412:	2705                	addiw	a4,a4,1
 414:	02c5f7bb          	remuw	a5,a1,a2
 418:	1782                	slli	a5,a5,0x20
 41a:	9381                	srli	a5,a5,0x20
 41c:	97aa                	add	a5,a5,a0
 41e:	0007c783          	lbu	a5,0(a5)
 422:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 426:	0005879b          	sext.w	a5,a1
 42a:	02c5d5bb          	divuw	a1,a1,a2
 42e:	0685                	addi	a3,a3,1
 430:	fec7f0e3          	bgeu	a5,a2,410 <printint+0x2a>
  if(neg)
 434:	00088b63          	beqz	a7,44a <printint+0x64>
    buf[i++] = '-';
 438:	fd040793          	addi	a5,s0,-48
 43c:	973e                	add	a4,a4,a5
 43e:	02d00793          	li	a5,45
 442:	fef70823          	sb	a5,-16(a4)
 446:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44a:	02e05863          	blez	a4,47a <printint+0x94>
 44e:	fc040793          	addi	a5,s0,-64
 452:	00e78933          	add	s2,a5,a4
 456:	fff78993          	addi	s3,a5,-1
 45a:	99ba                	add	s3,s3,a4
 45c:	377d                	addiw	a4,a4,-1
 45e:	1702                	slli	a4,a4,0x20
 460:	9301                	srli	a4,a4,0x20
 462:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 466:	fff94583          	lbu	a1,-1(s2)
 46a:	8526                	mv	a0,s1
 46c:	00000097          	auipc	ra,0x0
 470:	f58080e7          	jalr	-168(ra) # 3c4 <putc>
  while(--i >= 0)
 474:	197d                	addi	s2,s2,-1
 476:	ff3918e3          	bne	s2,s3,466 <printint+0x80>
}
 47a:	70e2                	ld	ra,56(sp)
 47c:	7442                	ld	s0,48(sp)
 47e:	74a2                	ld	s1,40(sp)
 480:	7902                	ld	s2,32(sp)
 482:	69e2                	ld	s3,24(sp)
 484:	6121                	addi	sp,sp,64
 486:	8082                	ret
    x = -xx;
 488:	40b005bb          	negw	a1,a1
    neg = 1;
 48c:	4885                	li	a7,1
    x = -xx;
 48e:	bf8d                	j	400 <printint+0x1a>

0000000000000490 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 490:	7119                	addi	sp,sp,-128
 492:	fc86                	sd	ra,120(sp)
 494:	f8a2                	sd	s0,112(sp)
 496:	f4a6                	sd	s1,104(sp)
 498:	f0ca                	sd	s2,96(sp)
 49a:	ecce                	sd	s3,88(sp)
 49c:	e8d2                	sd	s4,80(sp)
 49e:	e4d6                	sd	s5,72(sp)
 4a0:	e0da                	sd	s6,64(sp)
 4a2:	fc5e                	sd	s7,56(sp)
 4a4:	f862                	sd	s8,48(sp)
 4a6:	f466                	sd	s9,40(sp)
 4a8:	f06a                	sd	s10,32(sp)
 4aa:	ec6e                	sd	s11,24(sp)
 4ac:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ae:	0005c903          	lbu	s2,0(a1)
 4b2:	18090f63          	beqz	s2,650 <vprintf+0x1c0>
 4b6:	8aaa                	mv	s5,a0
 4b8:	8b32                	mv	s6,a2
 4ba:	00158493          	addi	s1,a1,1
  state = 0;
 4be:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c0:	02500a13          	li	s4,37
      if(c == 'd'){
 4c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4c8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4cc:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4d0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d4:	00000b97          	auipc	s7,0x0
 4d8:	3bcb8b93          	addi	s7,s7,956 # 890 <digits>
 4dc:	a839                	j	4fa <vprintf+0x6a>
        putc(fd, c);
 4de:	85ca                	mv	a1,s2
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	ee2080e7          	jalr	-286(ra) # 3c4 <putc>
 4ea:	a019                	j	4f0 <vprintf+0x60>
    } else if(state == '%'){
 4ec:	01498f63          	beq	s3,s4,50a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4f0:	0485                	addi	s1,s1,1
 4f2:	fff4c903          	lbu	s2,-1(s1)
 4f6:	14090d63          	beqz	s2,650 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4fa:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4fe:	fe0997e3          	bnez	s3,4ec <vprintf+0x5c>
      if(c == '%'){
 502:	fd479ee3          	bne	a5,s4,4de <vprintf+0x4e>
        state = '%';
 506:	89be                	mv	s3,a5
 508:	b7e5                	j	4f0 <vprintf+0x60>
      if(c == 'd'){
 50a:	05878063          	beq	a5,s8,54a <vprintf+0xba>
      } else if(c == 'l') {
 50e:	05978c63          	beq	a5,s9,566 <vprintf+0xd6>
      } else if(c == 'x') {
 512:	07a78863          	beq	a5,s10,582 <vprintf+0xf2>
      } else if(c == 'p') {
 516:	09b78463          	beq	a5,s11,59e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 51a:	07300713          	li	a4,115
 51e:	0ce78663          	beq	a5,a4,5ea <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 522:	06300713          	li	a4,99
 526:	0ee78e63          	beq	a5,a4,622 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 52a:	11478863          	beq	a5,s4,63a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 52e:	85d2                	mv	a1,s4
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e92080e7          	jalr	-366(ra) # 3c4 <putc>
        putc(fd, c);
 53a:	85ca                	mv	a1,s2
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e86080e7          	jalr	-378(ra) # 3c4 <putc>
      }
      state = 0;
 546:	4981                	li	s3,0
 548:	b765                	j	4f0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 54a:	008b0913          	addi	s2,s6,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000b2583          	lw	a1,0(s6)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e8e080e7          	jalr	-370(ra) # 3e6 <printint>
 560:	8b4a                	mv	s6,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	b771                	j	4f0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 566:	008b0913          	addi	s2,s6,8
 56a:	4681                	li	a3,0
 56c:	4629                	li	a2,10
 56e:	000b2583          	lw	a1,0(s6)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e72080e7          	jalr	-398(ra) # 3e6 <printint>
 57c:	8b4a                	mv	s6,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	bf85                	j	4f0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 582:	008b0913          	addi	s2,s6,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000b2583          	lw	a1,0(s6)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e56080e7          	jalr	-426(ra) # 3e6 <printint>
 598:	8b4a                	mv	s6,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bf91                	j	4f0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 59e:	008b0793          	addi	a5,s6,8
 5a2:	f8f43423          	sd	a5,-120(s0)
 5a6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5aa:	03000593          	li	a1,48
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e14080e7          	jalr	-492(ra) # 3c4 <putc>
  putc(fd, 'x');
 5b8:	85ea                	mv	a1,s10
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e08080e7          	jalr	-504(ra) # 3c4 <putc>
 5c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c6:	03c9d793          	srli	a5,s3,0x3c
 5ca:	97de                	add	a5,a5,s7
 5cc:	0007c583          	lbu	a1,0(a5)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	df2080e7          	jalr	-526(ra) # 3c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5da:	0992                	slli	s3,s3,0x4
 5dc:	397d                	addiw	s2,s2,-1
 5de:	fe0914e3          	bnez	s2,5c6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5e2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b721                	j	4f0 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ea:	008b0993          	addi	s3,s6,8
 5ee:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5f2:	02090163          	beqz	s2,614 <vprintf+0x184>
        while(*s != 0){
 5f6:	00094583          	lbu	a1,0(s2)
 5fa:	c9a1                	beqz	a1,64a <vprintf+0x1ba>
          putc(fd, *s);
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	dc6080e7          	jalr	-570(ra) # 3c4 <putc>
          s++;
 606:	0905                	addi	s2,s2,1
        while(*s != 0){
 608:	00094583          	lbu	a1,0(s2)
 60c:	f9e5                	bnez	a1,5fc <vprintf+0x16c>
        s = va_arg(ap, char*);
 60e:	8b4e                	mv	s6,s3
      state = 0;
 610:	4981                	li	s3,0
 612:	bdf9                	j	4f0 <vprintf+0x60>
          s = "(null)";
 614:	00000917          	auipc	s2,0x0
 618:	27490913          	addi	s2,s2,628 # 888 <malloc+0x12e>
        while(*s != 0){
 61c:	02800593          	li	a1,40
 620:	bff1                	j	5fc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 622:	008b0913          	addi	s2,s6,8
 626:	000b4583          	lbu	a1,0(s6)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	d98080e7          	jalr	-616(ra) # 3c4 <putc>
 634:	8b4a                	mv	s6,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	bd65                	j	4f0 <vprintf+0x60>
        putc(fd, c);
 63a:	85d2                	mv	a1,s4
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	d86080e7          	jalr	-634(ra) # 3c4 <putc>
      state = 0;
 646:	4981                	li	s3,0
 648:	b565                	j	4f0 <vprintf+0x60>
        s = va_arg(ap, char*);
 64a:	8b4e                	mv	s6,s3
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b54d                	j	4f0 <vprintf+0x60>
    }
  }
}
 650:	70e6                	ld	ra,120(sp)
 652:	7446                	ld	s0,112(sp)
 654:	74a6                	ld	s1,104(sp)
 656:	7906                	ld	s2,96(sp)
 658:	69e6                	ld	s3,88(sp)
 65a:	6a46                	ld	s4,80(sp)
 65c:	6aa6                	ld	s5,72(sp)
 65e:	6b06                	ld	s6,64(sp)
 660:	7be2                	ld	s7,56(sp)
 662:	7c42                	ld	s8,48(sp)
 664:	7ca2                	ld	s9,40(sp)
 666:	7d02                	ld	s10,32(sp)
 668:	6de2                	ld	s11,24(sp)
 66a:	6109                	addi	sp,sp,128
 66c:	8082                	ret

000000000000066e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66e:	715d                	addi	sp,sp,-80
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	e010                	sd	a2,0(s0)
 678:	e414                	sd	a3,8(s0)
 67a:	e818                	sd	a4,16(s0)
 67c:	ec1c                	sd	a5,24(s0)
 67e:	03043023          	sd	a6,32(s0)
 682:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 686:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68a:	8622                	mv	a2,s0
 68c:	00000097          	auipc	ra,0x0
 690:	e04080e7          	jalr	-508(ra) # 490 <vprintf>
}
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6161                	addi	sp,sp,80
 69a:	8082                	ret

000000000000069c <printf>:

void
printf(const char *fmt, ...)
{
 69c:	711d                	addi	sp,sp,-96
 69e:	ec06                	sd	ra,24(sp)
 6a0:	e822                	sd	s0,16(sp)
 6a2:	1000                	addi	s0,sp,32
 6a4:	e40c                	sd	a1,8(s0)
 6a6:	e810                	sd	a2,16(s0)
 6a8:	ec14                	sd	a3,24(s0)
 6aa:	f018                	sd	a4,32(s0)
 6ac:	f41c                	sd	a5,40(s0)
 6ae:	03043823          	sd	a6,48(s0)
 6b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b6:	00840613          	addi	a2,s0,8
 6ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6be:	85aa                	mv	a1,a0
 6c0:	4505                	li	a0,1
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dce080e7          	jalr	-562(ra) # 490 <vprintf>
}
 6ca:	60e2                	ld	ra,24(sp)
 6cc:	6442                	ld	s0,16(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret

00000000000006d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d2:	1141                	addi	sp,sp,-16
 6d4:	e422                	sd	s0,8(sp)
 6d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	00000797          	auipc	a5,0x0
 6e0:	1cc7b783          	ld	a5,460(a5) # 8a8 <freep>
 6e4:	a805                	j	714 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e6:	4618                	lw	a4,8(a2)
 6e8:	9db9                	addw	a1,a1,a4
 6ea:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ee:	6398                	ld	a4,0(a5)
 6f0:	6318                	ld	a4,0(a4)
 6f2:	fee53823          	sd	a4,-16(a0)
 6f6:	a091                	j	73a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f8:	ff852703          	lw	a4,-8(a0)
 6fc:	9e39                	addw	a2,a2,a4
 6fe:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 700:	ff053703          	ld	a4,-16(a0)
 704:	e398                	sd	a4,0(a5)
 706:	a099                	j	74c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	6398                	ld	a4,0(a5)
 70a:	00e7e463          	bltu	a5,a4,712 <free+0x40>
 70e:	00e6ea63          	bltu	a3,a4,722 <free+0x50>
{
 712:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	fed7fae3          	bgeu	a5,a3,708 <free+0x36>
 718:	6398                	ld	a4,0(a5)
 71a:	00e6e463          	bltu	a3,a4,722 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	fee7eae3          	bltu	a5,a4,712 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 722:	ff852583          	lw	a1,-8(a0)
 726:	6390                	ld	a2,0(a5)
 728:	02059713          	slli	a4,a1,0x20
 72c:	9301                	srli	a4,a4,0x20
 72e:	0712                	slli	a4,a4,0x4
 730:	9736                	add	a4,a4,a3
 732:	fae60ae3          	beq	a2,a4,6e6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 736:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73a:	4790                	lw	a2,8(a5)
 73c:	02061713          	slli	a4,a2,0x20
 740:	9301                	srli	a4,a4,0x20
 742:	0712                	slli	a4,a4,0x4
 744:	973e                	add	a4,a4,a5
 746:	fae689e3          	beq	a3,a4,6f8 <free+0x26>
  } else
    p->s.ptr = bp;
 74a:	e394                	sd	a3,0(a5)
  freep = p;
 74c:	00000717          	auipc	a4,0x0
 750:	14f73e23          	sd	a5,348(a4) # 8a8 <freep>
}
 754:	6422                	ld	s0,8(sp)
 756:	0141                	addi	sp,sp,16
 758:	8082                	ret

000000000000075a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75a:	7139                	addi	sp,sp,-64
 75c:	fc06                	sd	ra,56(sp)
 75e:	f822                	sd	s0,48(sp)
 760:	f426                	sd	s1,40(sp)
 762:	f04a                	sd	s2,32(sp)
 764:	ec4e                	sd	s3,24(sp)
 766:	e852                	sd	s4,16(sp)
 768:	e456                	sd	s5,8(sp)
 76a:	e05a                	sd	s6,0(sp)
 76c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76e:	02051493          	slli	s1,a0,0x20
 772:	9081                	srli	s1,s1,0x20
 774:	04bd                	addi	s1,s1,15
 776:	8091                	srli	s1,s1,0x4
 778:	0014899b          	addiw	s3,s1,1
 77c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 77e:	00000517          	auipc	a0,0x0
 782:	12a53503          	ld	a0,298(a0) # 8a8 <freep>
 786:	c515                	beqz	a0,7b2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78a:	4798                	lw	a4,8(a5)
 78c:	02977f63          	bgeu	a4,s1,7ca <malloc+0x70>
 790:	8a4e                	mv	s4,s3
 792:	0009871b          	sext.w	a4,s3
 796:	6685                	lui	a3,0x1
 798:	00d77363          	bgeu	a4,a3,79e <malloc+0x44>
 79c:	6a05                	lui	s4,0x1
 79e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a6:	00000917          	auipc	s2,0x0
 7aa:	10290913          	addi	s2,s2,258 # 8a8 <freep>
  if(p == (char*)-1)
 7ae:	5afd                	li	s5,-1
 7b0:	a88d                	j	822 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7b2:	00000797          	auipc	a5,0x0
 7b6:	2fe78793          	addi	a5,a5,766 # ab0 <base>
 7ba:	00000717          	auipc	a4,0x0
 7be:	0ef73723          	sd	a5,238(a4) # 8a8 <freep>
 7c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c8:	b7e1                	j	790 <malloc+0x36>
      if(p->s.size == nunits)
 7ca:	02e48b63          	beq	s1,a4,800 <malloc+0xa6>
        p->s.size -= nunits;
 7ce:	4137073b          	subw	a4,a4,s3
 7d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d4:	1702                	slli	a4,a4,0x20
 7d6:	9301                	srli	a4,a4,0x20
 7d8:	0712                	slli	a4,a4,0x4
 7da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e0:	00000717          	auipc	a4,0x0
 7e4:	0ca73423          	sd	a0,200(a4) # 8a8 <freep>
      return (void*)(p + 1);
 7e8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ec:	70e2                	ld	ra,56(sp)
 7ee:	7442                	ld	s0,48(sp)
 7f0:	74a2                	ld	s1,40(sp)
 7f2:	7902                	ld	s2,32(sp)
 7f4:	69e2                	ld	s3,24(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	6121                	addi	sp,sp,64
 7fe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	bff1                	j	7e0 <malloc+0x86>
  hp->s.size = nu;
 806:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	ec6080e7          	jalr	-314(ra) # 6d2 <free>
  return freep;
 814:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 818:	d971                	beqz	a0,7ec <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	fa9776e3          	bgeu	a4,s1,7ca <malloc+0x70>
    if(p == freep)
 822:	00093703          	ld	a4,0(s2)
 826:	853e                	mv	a0,a5
 828:	fef719e3          	bne	a4,a5,81a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	b5e080e7          	jalr	-1186(ra) # 38c <sbrk>
  if(p == (char*)-1)
 836:	fd5518e3          	bne	a0,s5,806 <malloc+0xac>
        return 0;
 83a:	4501                	li	a0,0
 83c:	bf45                	j	7ec <malloc+0x92>
