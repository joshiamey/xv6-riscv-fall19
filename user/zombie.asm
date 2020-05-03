
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	20e080e7          	jalr	526(ra) # 216 <fork>
  10:	00a04663          	bgtz	a0,1c <main+0x1c>
    sleep(5);  // Let child exit before parent.
  exit();
  14:	00000097          	auipc	ra,0x0
  18:	20a080e7          	jalr	522(ra) # 21e <exit>
    sleep(5);  // Let child exit before parent.
  1c:	4515                	li	a0,5
  1e:	00000097          	auipc	ra,0x0
  22:	290080e7          	jalr	656(ra) # 2ae <sleep>
  26:	b7fd                	j	14 <main+0x14>

0000000000000028 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2e:	87aa                	mv	a5,a0
  30:	0585                	addi	a1,a1,1
  32:	0785                	addi	a5,a5,1
  34:	fff5c703          	lbu	a4,-1(a1)
  38:	fee78fa3          	sb	a4,-1(a5)
  3c:	fb75                	bnez	a4,30 <strcpy+0x8>
    ;
  return os;
}
  3e:	6422                	ld	s0,8(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x1e>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x1e>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	6422                	ld	s0,8(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  76:	00054783          	lbu	a5,0(a0)
  7a:	cf91                	beqz	a5,96 <strlen+0x26>
  7c:	0505                	addi	a0,a0,1
  7e:	87aa                	mv	a5,a0
  80:	4685                	li	a3,1
  82:	9e89                	subw	a3,a3,a0
  84:	00f6853b          	addw	a0,a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	fb7d                	bnez	a4,84 <strlen+0x14>
    ;
  return n;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfe5                	j	90 <strlen+0x20>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a0:	ce09                	beqz	a2,ba <memset+0x20>
  a2:	87aa                	mv	a5,a0
  a4:	fff6071b          	addiw	a4,a2,-1
  a8:	1702                	slli	a4,a4,0x20
  aa:	9301                	srli	a4,a4,0x20
  ac:	0705                	addi	a4,a4,1
  ae:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b4:	0785                	addi	a5,a5,1
  b6:	fee79de3          	bne	a5,a4,b0 <memset+0x16>
  }
  return dst;
}
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strchr>:

char*
strchr(const char *s, char c)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cb99                	beqz	a5,e0 <strchr+0x20>
    if(*s == c)
  cc:	00f58763          	beq	a1,a5,da <strchr+0x1a>
  for(; *s; s++)
  d0:	0505                	addi	a0,a0,1
  d2:	00054783          	lbu	a5,0(a0)
  d6:	fbfd                	bnez	a5,cc <strchr+0xc>
      return (char*)s;
  return 0;
  d8:	4501                	li	a0,0
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret
  return 0;
  e0:	4501                	li	a0,0
  e2:	bfe5                	j	da <strchr+0x1a>

00000000000000e4 <gets>:

char*
gets(char *buf, int max)
{
  e4:	711d                	addi	sp,sp,-96
  e6:	ec86                	sd	ra,88(sp)
  e8:	e8a2                	sd	s0,80(sp)
  ea:	e4a6                	sd	s1,72(sp)
  ec:	e0ca                	sd	s2,64(sp)
  ee:	fc4e                	sd	s3,56(sp)
  f0:	f852                	sd	s4,48(sp)
  f2:	f456                	sd	s5,40(sp)
  f4:	f05a                	sd	s6,32(sp)
  f6:	ec5e                	sd	s7,24(sp)
  f8:	1080                	addi	s0,sp,96
  fa:	8baa                	mv	s7,a0
  fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fe:	892a                	mv	s2,a0
 100:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 102:	4aa9                	li	s5,10
 104:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 106:	89a6                	mv	s3,s1
 108:	2485                	addiw	s1,s1,1
 10a:	0344d863          	bge	s1,s4,13a <gets+0x56>
    cc = read(0, &c, 1);
 10e:	4605                	li	a2,1
 110:	faf40593          	addi	a1,s0,-81
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	120080e7          	jalr	288(ra) # 236 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x56>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x54>
 12e:	0905                	addi	s2,s2,1
 130:	fd679be3          	bne	a5,s6,106 <gets+0x22>
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x56>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e426                	sd	s1,8(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	addi	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	00000097          	auipc	ra,0x0
 16c:	0f6080e7          	jalr	246(ra) # 25e <open>
  if(fd < 0)
 170:	02054563          	bltz	a0,19a <stat+0x42>
 174:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 176:	85ca                	mv	a1,s2
 178:	00000097          	auipc	ra,0x0
 17c:	0fe080e7          	jalr	254(ra) # 276 <fstat>
 180:	892a                	mv	s2,a0
  close(fd);
 182:	8526                	mv	a0,s1
 184:	00000097          	auipc	ra,0x0
 188:	0c2080e7          	jalr	194(ra) # 246 <close>
  return r;
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	64a2                	ld	s1,8(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
    return -1;
 19a:	597d                	li	s2,-1
 19c:	bfc5                	j	18c <stat+0x34>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a4:	00054603          	lbu	a2,0(a0)
 1a8:	fd06079b          	addiw	a5,a2,-48
 1ac:	0ff7f793          	andi	a5,a5,255
 1b0:	4725                	li	a4,9
 1b2:	02f76963          	bltu	a4,a5,1e4 <atoi+0x46>
 1b6:	86aa                	mv	a3,a0
  n = 0;
 1b8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ba:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1bc:	0685                	addi	a3,a3,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb1                	addw	a5,a5,a2
 1ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ce:	0006c603          	lbu	a2,0(a3)
 1d2:	fd06071b          	addiw	a4,a2,-48
 1d6:	0ff77713          	andi	a4,a4,255
 1da:	fee5f1e3          	bgeu	a1,a4,1bc <atoi+0x1e>
  return n;
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  n = 0;
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <atoi+0x40>

00000000000001e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ee:	02c05163          	blez	a2,210 <memmove+0x28>
 1f2:	fff6071b          	addiw	a4,a2,-1
 1f6:	1702                	slli	a4,a4,0x20
 1f8:	9301                	srli	a4,a4,0x20
 1fa:	0705                	addi	a4,a4,1
 1fc:	972a                	add	a4,a4,a0
  dst = vdst;
 1fe:	87aa                	mv	a5,a0
    *dst++ = *src++;
 200:	0585                	addi	a1,a1,1
 202:	0785                	addi	a5,a5,1
 204:	fff5c683          	lbu	a3,-1(a1)
 208:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 20c:	fee79ae3          	bne	a5,a4,200 <memmove+0x18>
  return vdst;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 216:	4885                	li	a7,1
 ecall
 218:	00000073          	ecall
 ret
 21c:	8082                	ret

000000000000021e <exit>:
.global exit
exit:
 li a7, SYS_exit
 21e:	4889                	li	a7,2
 ecall
 220:	00000073          	ecall
 ret
 224:	8082                	ret

0000000000000226 <wait>:
.global wait
wait:
 li a7, SYS_wait
 226:	488d                	li	a7,3
 ecall
 228:	00000073          	ecall
 ret
 22c:	8082                	ret

000000000000022e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 22e:	4891                	li	a7,4
 ecall
 230:	00000073          	ecall
 ret
 234:	8082                	ret

0000000000000236 <read>:
.global read
read:
 li a7, SYS_read
 236:	4895                	li	a7,5
 ecall
 238:	00000073          	ecall
 ret
 23c:	8082                	ret

000000000000023e <write>:
.global write
write:
 li a7, SYS_write
 23e:	48c1                	li	a7,16
 ecall
 240:	00000073          	ecall
 ret
 244:	8082                	ret

0000000000000246 <close>:
.global close
close:
 li a7, SYS_close
 246:	48d5                	li	a7,21
 ecall
 248:	00000073          	ecall
 ret
 24c:	8082                	ret

000000000000024e <kill>:
.global kill
kill:
 li a7, SYS_kill
 24e:	4899                	li	a7,6
 ecall
 250:	00000073          	ecall
 ret
 254:	8082                	ret

0000000000000256 <exec>:
.global exec
exec:
 li a7, SYS_exec
 256:	489d                	li	a7,7
 ecall
 258:	00000073          	ecall
 ret
 25c:	8082                	ret

000000000000025e <open>:
.global open
open:
 li a7, SYS_open
 25e:	48bd                	li	a7,15
 ecall
 260:	00000073          	ecall
 ret
 264:	8082                	ret

0000000000000266 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 266:	48c5                	li	a7,17
 ecall
 268:	00000073          	ecall
 ret
 26c:	8082                	ret

000000000000026e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 26e:	48c9                	li	a7,18
 ecall
 270:	00000073          	ecall
 ret
 274:	8082                	ret

0000000000000276 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 276:	48a1                	li	a7,8
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <link>:
.global link
link:
 li a7, SYS_link
 27e:	48cd                	li	a7,19
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 286:	48d1                	li	a7,20
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 28e:	48a5                	li	a7,9
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <dup>:
.global dup
dup:
 li a7, SYS_dup
 296:	48a9                	li	a7,10
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 29e:	48ad                	li	a7,11
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2a6:	48b1                	li	a7,12
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2ae:	48b5                	li	a7,13
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2b6:	48b9                	li	a7,14
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2be:	48d9                	li	a7,22
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <crash>:
.global crash
crash:
 li a7, SYS_crash
 2c6:	48dd                	li	a7,23
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <mount>:
.global mount
mount:
 li a7, SYS_mount
 2ce:	48e1                	li	a7,24
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <umount>:
.global umount
umount:
 li a7, SYS_umount
 2d6:	48e5                	li	a7,25
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2de:	1101                	addi	sp,sp,-32
 2e0:	ec06                	sd	ra,24(sp)
 2e2:	e822                	sd	s0,16(sp)
 2e4:	1000                	addi	s0,sp,32
 2e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2ea:	4605                	li	a2,1
 2ec:	fef40593          	addi	a1,s0,-17
 2f0:	00000097          	auipc	ra,0x0
 2f4:	f4e080e7          	jalr	-178(ra) # 23e <write>
}
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	6105                	addi	sp,sp,32
 2fe:	8082                	ret

0000000000000300 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 300:	7139                	addi	sp,sp,-64
 302:	fc06                	sd	ra,56(sp)
 304:	f822                	sd	s0,48(sp)
 306:	f426                	sd	s1,40(sp)
 308:	f04a                	sd	s2,32(sp)
 30a:	ec4e                	sd	s3,24(sp)
 30c:	0080                	addi	s0,sp,64
 30e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 310:	c299                	beqz	a3,316 <printint+0x16>
 312:	0805c863          	bltz	a1,3a2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 316:	2581                	sext.w	a1,a1
  neg = 0;
 318:	4881                	li	a7,0
 31a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 31e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 320:	2601                	sext.w	a2,a2
 322:	00000517          	auipc	a0,0x0
 326:	43e50513          	addi	a0,a0,1086 # 760 <digits>
 32a:	883a                	mv	a6,a4
 32c:	2705                	addiw	a4,a4,1
 32e:	02c5f7bb          	remuw	a5,a1,a2
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	97aa                	add	a5,a5,a0
 338:	0007c783          	lbu	a5,0(a5)
 33c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 340:	0005879b          	sext.w	a5,a1
 344:	02c5d5bb          	divuw	a1,a1,a2
 348:	0685                	addi	a3,a3,1
 34a:	fec7f0e3          	bgeu	a5,a2,32a <printint+0x2a>
  if(neg)
 34e:	00088b63          	beqz	a7,364 <printint+0x64>
    buf[i++] = '-';
 352:	fd040793          	addi	a5,s0,-48
 356:	973e                	add	a4,a4,a5
 358:	02d00793          	li	a5,45
 35c:	fef70823          	sb	a5,-16(a4)
 360:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 364:	02e05863          	blez	a4,394 <printint+0x94>
 368:	fc040793          	addi	a5,s0,-64
 36c:	00e78933          	add	s2,a5,a4
 370:	fff78993          	addi	s3,a5,-1
 374:	99ba                	add	s3,s3,a4
 376:	377d                	addiw	a4,a4,-1
 378:	1702                	slli	a4,a4,0x20
 37a:	9301                	srli	a4,a4,0x20
 37c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 380:	fff94583          	lbu	a1,-1(s2)
 384:	8526                	mv	a0,s1
 386:	00000097          	auipc	ra,0x0
 38a:	f58080e7          	jalr	-168(ra) # 2de <putc>
  while(--i >= 0)
 38e:	197d                	addi	s2,s2,-1
 390:	ff3918e3          	bne	s2,s3,380 <printint+0x80>
}
 394:	70e2                	ld	ra,56(sp)
 396:	7442                	ld	s0,48(sp)
 398:	74a2                	ld	s1,40(sp)
 39a:	7902                	ld	s2,32(sp)
 39c:	69e2                	ld	s3,24(sp)
 39e:	6121                	addi	sp,sp,64
 3a0:	8082                	ret
    x = -xx;
 3a2:	40b005bb          	negw	a1,a1
    neg = 1;
 3a6:	4885                	li	a7,1
    x = -xx;
 3a8:	bf8d                	j	31a <printint+0x1a>

00000000000003aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3aa:	7119                	addi	sp,sp,-128
 3ac:	fc86                	sd	ra,120(sp)
 3ae:	f8a2                	sd	s0,112(sp)
 3b0:	f4a6                	sd	s1,104(sp)
 3b2:	f0ca                	sd	s2,96(sp)
 3b4:	ecce                	sd	s3,88(sp)
 3b6:	e8d2                	sd	s4,80(sp)
 3b8:	e4d6                	sd	s5,72(sp)
 3ba:	e0da                	sd	s6,64(sp)
 3bc:	fc5e                	sd	s7,56(sp)
 3be:	f862                	sd	s8,48(sp)
 3c0:	f466                	sd	s9,40(sp)
 3c2:	f06a                	sd	s10,32(sp)
 3c4:	ec6e                	sd	s11,24(sp)
 3c6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3c8:	0005c903          	lbu	s2,0(a1)
 3cc:	18090f63          	beqz	s2,56a <vprintf+0x1c0>
 3d0:	8aaa                	mv	s5,a0
 3d2:	8b32                	mv	s6,a2
 3d4:	00158493          	addi	s1,a1,1
  state = 0;
 3d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3da:	02500a13          	li	s4,37
      if(c == 'd'){
 3de:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3e2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 3e6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 3ea:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 3ee:	00000b97          	auipc	s7,0x0
 3f2:	372b8b93          	addi	s7,s7,882 # 760 <digits>
 3f6:	a839                	j	414 <vprintf+0x6a>
        putc(fd, c);
 3f8:	85ca                	mv	a1,s2
 3fa:	8556                	mv	a0,s5
 3fc:	00000097          	auipc	ra,0x0
 400:	ee2080e7          	jalr	-286(ra) # 2de <putc>
 404:	a019                	j	40a <vprintf+0x60>
    } else if(state == '%'){
 406:	01498f63          	beq	s3,s4,424 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 40a:	0485                	addi	s1,s1,1
 40c:	fff4c903          	lbu	s2,-1(s1)
 410:	14090d63          	beqz	s2,56a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 414:	0009079b          	sext.w	a5,s2
    if(state == 0){
 418:	fe0997e3          	bnez	s3,406 <vprintf+0x5c>
      if(c == '%'){
 41c:	fd479ee3          	bne	a5,s4,3f8 <vprintf+0x4e>
        state = '%';
 420:	89be                	mv	s3,a5
 422:	b7e5                	j	40a <vprintf+0x60>
      if(c == 'd'){
 424:	05878063          	beq	a5,s8,464 <vprintf+0xba>
      } else if(c == 'l') {
 428:	05978c63          	beq	a5,s9,480 <vprintf+0xd6>
      } else if(c == 'x') {
 42c:	07a78863          	beq	a5,s10,49c <vprintf+0xf2>
      } else if(c == 'p') {
 430:	09b78463          	beq	a5,s11,4b8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 434:	07300713          	li	a4,115
 438:	0ce78663          	beq	a5,a4,504 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 43c:	06300713          	li	a4,99
 440:	0ee78e63          	beq	a5,a4,53c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 444:	11478863          	beq	a5,s4,554 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 448:	85d2                	mv	a1,s4
 44a:	8556                	mv	a0,s5
 44c:	00000097          	auipc	ra,0x0
 450:	e92080e7          	jalr	-366(ra) # 2de <putc>
        putc(fd, c);
 454:	85ca                	mv	a1,s2
 456:	8556                	mv	a0,s5
 458:	00000097          	auipc	ra,0x0
 45c:	e86080e7          	jalr	-378(ra) # 2de <putc>
      }
      state = 0;
 460:	4981                	li	s3,0
 462:	b765                	j	40a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 464:	008b0913          	addi	s2,s6,8
 468:	4685                	li	a3,1
 46a:	4629                	li	a2,10
 46c:	000b2583          	lw	a1,0(s6)
 470:	8556                	mv	a0,s5
 472:	00000097          	auipc	ra,0x0
 476:	e8e080e7          	jalr	-370(ra) # 300 <printint>
 47a:	8b4a                	mv	s6,s2
      state = 0;
 47c:	4981                	li	s3,0
 47e:	b771                	j	40a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 480:	008b0913          	addi	s2,s6,8
 484:	4681                	li	a3,0
 486:	4629                	li	a2,10
 488:	000b2583          	lw	a1,0(s6)
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	e72080e7          	jalr	-398(ra) # 300 <printint>
 496:	8b4a                	mv	s6,s2
      state = 0;
 498:	4981                	li	s3,0
 49a:	bf85                	j	40a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 49c:	008b0913          	addi	s2,s6,8
 4a0:	4681                	li	a3,0
 4a2:	4641                	li	a2,16
 4a4:	000b2583          	lw	a1,0(s6)
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	e56080e7          	jalr	-426(ra) # 300 <printint>
 4b2:	8b4a                	mv	s6,s2
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	bf91                	j	40a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4b8:	008b0793          	addi	a5,s6,8
 4bc:	f8f43423          	sd	a5,-120(s0)
 4c0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4c4:	03000593          	li	a1,48
 4c8:	8556                	mv	a0,s5
 4ca:	00000097          	auipc	ra,0x0
 4ce:	e14080e7          	jalr	-492(ra) # 2de <putc>
  putc(fd, 'x');
 4d2:	85ea                	mv	a1,s10
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	e08080e7          	jalr	-504(ra) # 2de <putc>
 4de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e0:	03c9d793          	srli	a5,s3,0x3c
 4e4:	97de                	add	a5,a5,s7
 4e6:	0007c583          	lbu	a1,0(a5)
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	df2080e7          	jalr	-526(ra) # 2de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4f4:	0992                	slli	s3,s3,0x4
 4f6:	397d                	addiw	s2,s2,-1
 4f8:	fe0914e3          	bnez	s2,4e0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 4fc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 500:	4981                	li	s3,0
 502:	b721                	j	40a <vprintf+0x60>
        s = va_arg(ap, char*);
 504:	008b0993          	addi	s3,s6,8
 508:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 50c:	02090163          	beqz	s2,52e <vprintf+0x184>
        while(*s != 0){
 510:	00094583          	lbu	a1,0(s2)
 514:	c9a1                	beqz	a1,564 <vprintf+0x1ba>
          putc(fd, *s);
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	dc6080e7          	jalr	-570(ra) # 2de <putc>
          s++;
 520:	0905                	addi	s2,s2,1
        while(*s != 0){
 522:	00094583          	lbu	a1,0(s2)
 526:	f9e5                	bnez	a1,516 <vprintf+0x16c>
        s = va_arg(ap, char*);
 528:	8b4e                	mv	s6,s3
      state = 0;
 52a:	4981                	li	s3,0
 52c:	bdf9                	j	40a <vprintf+0x60>
          s = "(null)";
 52e:	00000917          	auipc	s2,0x0
 532:	22a90913          	addi	s2,s2,554 # 758 <malloc+0xe4>
        while(*s != 0){
 536:	02800593          	li	a1,40
 53a:	bff1                	j	516 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 53c:	008b0913          	addi	s2,s6,8
 540:	000b4583          	lbu	a1,0(s6)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	d98080e7          	jalr	-616(ra) # 2de <putc>
 54e:	8b4a                	mv	s6,s2
      state = 0;
 550:	4981                	li	s3,0
 552:	bd65                	j	40a <vprintf+0x60>
        putc(fd, c);
 554:	85d2                	mv	a1,s4
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	d86080e7          	jalr	-634(ra) # 2de <putc>
      state = 0;
 560:	4981                	li	s3,0
 562:	b565                	j	40a <vprintf+0x60>
        s = va_arg(ap, char*);
 564:	8b4e                	mv	s6,s3
      state = 0;
 566:	4981                	li	s3,0
 568:	b54d                	j	40a <vprintf+0x60>
    }
  }
}
 56a:	70e6                	ld	ra,120(sp)
 56c:	7446                	ld	s0,112(sp)
 56e:	74a6                	ld	s1,104(sp)
 570:	7906                	ld	s2,96(sp)
 572:	69e6                	ld	s3,88(sp)
 574:	6a46                	ld	s4,80(sp)
 576:	6aa6                	ld	s5,72(sp)
 578:	6b06                	ld	s6,64(sp)
 57a:	7be2                	ld	s7,56(sp)
 57c:	7c42                	ld	s8,48(sp)
 57e:	7ca2                	ld	s9,40(sp)
 580:	7d02                	ld	s10,32(sp)
 582:	6de2                	ld	s11,24(sp)
 584:	6109                	addi	sp,sp,128
 586:	8082                	ret

0000000000000588 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 588:	715d                	addi	sp,sp,-80
 58a:	ec06                	sd	ra,24(sp)
 58c:	e822                	sd	s0,16(sp)
 58e:	1000                	addi	s0,sp,32
 590:	e010                	sd	a2,0(s0)
 592:	e414                	sd	a3,8(s0)
 594:	e818                	sd	a4,16(s0)
 596:	ec1c                	sd	a5,24(s0)
 598:	03043023          	sd	a6,32(s0)
 59c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5a4:	8622                	mv	a2,s0
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e04080e7          	jalr	-508(ra) # 3aa <vprintf>
}
 5ae:	60e2                	ld	ra,24(sp)
 5b0:	6442                	ld	s0,16(sp)
 5b2:	6161                	addi	sp,sp,80
 5b4:	8082                	ret

00000000000005b6 <printf>:

void
printf(const char *fmt, ...)
{
 5b6:	711d                	addi	sp,sp,-96
 5b8:	ec06                	sd	ra,24(sp)
 5ba:	e822                	sd	s0,16(sp)
 5bc:	1000                	addi	s0,sp,32
 5be:	e40c                	sd	a1,8(s0)
 5c0:	e810                	sd	a2,16(s0)
 5c2:	ec14                	sd	a3,24(s0)
 5c4:	f018                	sd	a4,32(s0)
 5c6:	f41c                	sd	a5,40(s0)
 5c8:	03043823          	sd	a6,48(s0)
 5cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5d0:	00840613          	addi	a2,s0,8
 5d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5d8:	85aa                	mv	a1,a0
 5da:	4505                	li	a0,1
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dce080e7          	jalr	-562(ra) # 3aa <vprintf>
}
 5e4:	60e2                	ld	ra,24(sp)
 5e6:	6442                	ld	s0,16(sp)
 5e8:	6125                	addi	sp,sp,96
 5ea:	8082                	ret

00000000000005ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ec:	1141                	addi	sp,sp,-16
 5ee:	e422                	sd	s0,8(sp)
 5f0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f6:	00000797          	auipc	a5,0x0
 5fa:	1827b783          	ld	a5,386(a5) # 778 <freep>
 5fe:	a805                	j	62e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 600:	4618                	lw	a4,8(a2)
 602:	9db9                	addw	a1,a1,a4
 604:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 608:	6398                	ld	a4,0(a5)
 60a:	6318                	ld	a4,0(a4)
 60c:	fee53823          	sd	a4,-16(a0)
 610:	a091                	j	654 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 612:	ff852703          	lw	a4,-8(a0)
 616:	9e39                	addw	a2,a2,a4
 618:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 61a:	ff053703          	ld	a4,-16(a0)
 61e:	e398                	sd	a4,0(a5)
 620:	a099                	j	666 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 622:	6398                	ld	a4,0(a5)
 624:	00e7e463          	bltu	a5,a4,62c <free+0x40>
 628:	00e6ea63          	bltu	a3,a4,63c <free+0x50>
{
 62c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62e:	fed7fae3          	bgeu	a5,a3,622 <free+0x36>
 632:	6398                	ld	a4,0(a5)
 634:	00e6e463          	bltu	a3,a4,63c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 638:	fee7eae3          	bltu	a5,a4,62c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 63c:	ff852583          	lw	a1,-8(a0)
 640:	6390                	ld	a2,0(a5)
 642:	02059713          	slli	a4,a1,0x20
 646:	9301                	srli	a4,a4,0x20
 648:	0712                	slli	a4,a4,0x4
 64a:	9736                	add	a4,a4,a3
 64c:	fae60ae3          	beq	a2,a4,600 <free+0x14>
    bp->s.ptr = p->s.ptr;
 650:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 654:	4790                	lw	a2,8(a5)
 656:	02061713          	slli	a4,a2,0x20
 65a:	9301                	srli	a4,a4,0x20
 65c:	0712                	slli	a4,a4,0x4
 65e:	973e                	add	a4,a4,a5
 660:	fae689e3          	beq	a3,a4,612 <free+0x26>
  } else
    p->s.ptr = bp;
 664:	e394                	sd	a3,0(a5)
  freep = p;
 666:	00000717          	auipc	a4,0x0
 66a:	10f73923          	sd	a5,274(a4) # 778 <freep>
}
 66e:	6422                	ld	s0,8(sp)
 670:	0141                	addi	sp,sp,16
 672:	8082                	ret

0000000000000674 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 674:	7139                	addi	sp,sp,-64
 676:	fc06                	sd	ra,56(sp)
 678:	f822                	sd	s0,48(sp)
 67a:	f426                	sd	s1,40(sp)
 67c:	f04a                	sd	s2,32(sp)
 67e:	ec4e                	sd	s3,24(sp)
 680:	e852                	sd	s4,16(sp)
 682:	e456                	sd	s5,8(sp)
 684:	e05a                	sd	s6,0(sp)
 686:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 688:	02051493          	slli	s1,a0,0x20
 68c:	9081                	srli	s1,s1,0x20
 68e:	04bd                	addi	s1,s1,15
 690:	8091                	srli	s1,s1,0x4
 692:	0014899b          	addiw	s3,s1,1
 696:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 698:	00000517          	auipc	a0,0x0
 69c:	0e053503          	ld	a0,224(a0) # 778 <freep>
 6a0:	c515                	beqz	a0,6cc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6a4:	4798                	lw	a4,8(a5)
 6a6:	02977f63          	bgeu	a4,s1,6e4 <malloc+0x70>
 6aa:	8a4e                	mv	s4,s3
 6ac:	0009871b          	sext.w	a4,s3
 6b0:	6685                	lui	a3,0x1
 6b2:	00d77363          	bgeu	a4,a3,6b8 <malloc+0x44>
 6b6:	6a05                	lui	s4,0x1
 6b8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c0:	00000917          	auipc	s2,0x0
 6c4:	0b890913          	addi	s2,s2,184 # 778 <freep>
  if(p == (char*)-1)
 6c8:	5afd                	li	s5,-1
 6ca:	a88d                	j	73c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 6cc:	00000797          	auipc	a5,0x0
 6d0:	0b478793          	addi	a5,a5,180 # 780 <base>
 6d4:	00000717          	auipc	a4,0x0
 6d8:	0af73223          	sd	a5,164(a4) # 778 <freep>
 6dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6e2:	b7e1                	j	6aa <malloc+0x36>
      if(p->s.size == nunits)
 6e4:	02e48b63          	beq	s1,a4,71a <malloc+0xa6>
        p->s.size -= nunits;
 6e8:	4137073b          	subw	a4,a4,s3
 6ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 6ee:	1702                	slli	a4,a4,0x20
 6f0:	9301                	srli	a4,a4,0x20
 6f2:	0712                	slli	a4,a4,0x4
 6f4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 6f6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 6fa:	00000717          	auipc	a4,0x0
 6fe:	06a73f23          	sd	a0,126(a4) # 778 <freep>
      return (void*)(p + 1);
 702:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 706:	70e2                	ld	ra,56(sp)
 708:	7442                	ld	s0,48(sp)
 70a:	74a2                	ld	s1,40(sp)
 70c:	7902                	ld	s2,32(sp)
 70e:	69e2                	ld	s3,24(sp)
 710:	6a42                	ld	s4,16(sp)
 712:	6aa2                	ld	s5,8(sp)
 714:	6b02                	ld	s6,0(sp)
 716:	6121                	addi	sp,sp,64
 718:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 71a:	6398                	ld	a4,0(a5)
 71c:	e118                	sd	a4,0(a0)
 71e:	bff1                	j	6fa <malloc+0x86>
  hp->s.size = nu;
 720:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 724:	0541                	addi	a0,a0,16
 726:	00000097          	auipc	ra,0x0
 72a:	ec6080e7          	jalr	-314(ra) # 5ec <free>
  return freep;
 72e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 732:	d971                	beqz	a0,706 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 734:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 736:	4798                	lw	a4,8(a5)
 738:	fa9776e3          	bgeu	a4,s1,6e4 <malloc+0x70>
    if(p == freep)
 73c:	00093703          	ld	a4,0(s2)
 740:	853e                	mv	a0,a5
 742:	fef719e3          	bne	a4,a5,734 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 746:	8552                	mv	a0,s4
 748:	00000097          	auipc	ra,0x0
 74c:	b5e080e7          	jalr	-1186(ra) # 2a6 <sbrk>
  if(p == (char*)-1)
 750:	fd5518e3          	bne	a0,s5,720 <malloc+0xac>
        return 0;
 754:	4501                	li	a0,0
 756:	bf45                	j	706 <malloc+0x92>
