
user/_crashtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test0();
  exit();
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  struct stat st;
  
  printf("test0 start\n");
   8:	00001517          	auipc	a0,0x1
   c:	83850513          	addi	a0,a0,-1992 # 840 <malloc+0xe4>
  10:	00000097          	auipc	ra,0x0
  14:	68e080e7          	jalr	1678(ra) # 69e <printf>

  mknod("disk1", DISK, 1);
  18:	4605                	li	a2,1
  1a:	4581                	li	a1,0
  1c:	00001517          	auipc	a0,0x1
  20:	83450513          	addi	a0,a0,-1996 # 850 <malloc+0xf4>
  24:	00000097          	auipc	ra,0x0
  28:	32a080e7          	jalr	810(ra) # 34e <mknod>

  if (stat("/m/crashf", &st) == 0) {
  2c:	fd840593          	addi	a1,s0,-40
  30:	00001517          	auipc	a0,0x1
  34:	82850513          	addi	a0,a0,-2008 # 858 <malloc+0xfc>
  38:	00000097          	auipc	ra,0x0
  3c:	208080e7          	jalr	520(ra) # 240 <stat>
  40:	cd21                	beqz	a0,98 <test0+0x98>
    printf("stat /m/crashf succeeded\n");
    exit();
  }

  if (mount("/disk1", "/m") < 0) {
  42:	00001597          	auipc	a1,0x1
  46:	84658593          	addi	a1,a1,-1978 # 888 <malloc+0x12c>
  4a:	00001517          	auipc	a0,0x1
  4e:	84650513          	addi	a0,a0,-1978 # 890 <malloc+0x134>
  52:	00000097          	auipc	ra,0x0
  56:	364080e7          	jalr	868(ra) # 3b6 <mount>
  5a:	04054b63          	bltz	a0,b0 <test0+0xb0>
    printf("mount failed\n");
    exit();
  }    

  if (stat("/m/crashf", &st) < 0) {
  5e:	fd840593          	addi	a1,s0,-40
  62:	00000517          	auipc	a0,0x0
  66:	7f650513          	addi	a0,a0,2038 # 858 <malloc+0xfc>
  6a:	00000097          	auipc	ra,0x0
  6e:	1d6080e7          	jalr	470(ra) # 240 <stat>
  72:	04054b63          	bltz	a0,c8 <test0+0xc8>
    printf("stat /m/crashf failed\n");
    exit();
  }

  if (minor(st.dev) != 1) {
  76:	fd845583          	lhu	a1,-40(s0)
  7a:	4785                	li	a5,1
  7c:	06f59263          	bne	a1,a5,e0 <test0+0xe0>
    printf("stat wrong minor %d\n", minor(st.dev));
    exit();
  }
  
  printf("test0 ok\n");
  80:	00001517          	auipc	a0,0x1
  84:	85850513          	addi	a0,a0,-1960 # 8d8 <malloc+0x17c>
  88:	00000097          	auipc	ra,0x0
  8c:	616080e7          	jalr	1558(ra) # 69e <printf>
}
  90:	70a2                	ld	ra,40(sp)
  92:	7402                	ld	s0,32(sp)
  94:	6145                	addi	sp,sp,48
  96:	8082                	ret
    printf("stat /m/crashf succeeded\n");
  98:	00000517          	auipc	a0,0x0
  9c:	7d050513          	addi	a0,a0,2000 # 868 <malloc+0x10c>
  a0:	00000097          	auipc	ra,0x0
  a4:	5fe080e7          	jalr	1534(ra) # 69e <printf>
    exit();
  a8:	00000097          	auipc	ra,0x0
  ac:	25e080e7          	jalr	606(ra) # 306 <exit>
    printf("mount failed\n");
  b0:	00000517          	auipc	a0,0x0
  b4:	7e850513          	addi	a0,a0,2024 # 898 <malloc+0x13c>
  b8:	00000097          	auipc	ra,0x0
  bc:	5e6080e7          	jalr	1510(ra) # 69e <printf>
    exit();
  c0:	00000097          	auipc	ra,0x0
  c4:	246080e7          	jalr	582(ra) # 306 <exit>
    printf("stat /m/crashf failed\n");
  c8:	00000517          	auipc	a0,0x0
  cc:	7e050513          	addi	a0,a0,2016 # 8a8 <malloc+0x14c>
  d0:	00000097          	auipc	ra,0x0
  d4:	5ce080e7          	jalr	1486(ra) # 69e <printf>
    exit();
  d8:	00000097          	auipc	ra,0x0
  dc:	22e080e7          	jalr	558(ra) # 306 <exit>
    printf("stat wrong minor %d\n", minor(st.dev));
  e0:	00000517          	auipc	a0,0x0
  e4:	7e050513          	addi	a0,a0,2016 # 8c0 <malloc+0x164>
  e8:	00000097          	auipc	ra,0x0
  ec:	5b6080e7          	jalr	1462(ra) # 69e <printf>
    exit();
  f0:	00000097          	auipc	ra,0x0
  f4:	216080e7          	jalr	534(ra) # 306 <exit>

00000000000000f8 <main>:
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  test0();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <test0>
  exit();
 108:	00000097          	auipc	ra,0x0
 10c:	1fe080e7          	jalr	510(ra) # 306 <exit>

0000000000000110 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	87aa                	mv	a5,a0
 118:	0585                	addi	a1,a1,1
 11a:	0785                	addi	a5,a5,1
 11c:	fff5c703          	lbu	a4,-1(a1)
 120:	fee78fa3          	sb	a4,-1(a5)
 124:	fb75                	bnez	a4,118 <strcpy+0x8>
    ;
  return os;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x1e>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x1e>
    p++, q++;
 140:	0505                	addi	a0,a0,1
 142:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x26>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	4685                	li	a3,1
 16a:	9e89                	subw	a3,a3,a0
 16c:	00f6853b          	addw	a0,a3,a5
 170:	0785                	addi	a5,a5,1
 172:	fff7c703          	lbu	a4,-1(a5)
 176:	fb7d                	bnez	a4,16c <strlen+0x14>
    ;
  return n;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	ce09                	beqz	a2,1a2 <memset+0x20>
 18a:	87aa                	mv	a5,a0
 18c:	fff6071b          	addiw	a4,a2,-1
 190:	1702                	slli	a4,a4,0x20
 192:	9301                	srli	a4,a4,0x20
 194:	0705                	addi	a4,a4,1
 196:	972a                	add	a4,a4,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x16>
  }
  return dst;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char*
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb99                	beqz	a5,1c8 <strchr+0x20>
    if(*s == c)
 1b4:	00f58763          	beq	a1,a5,1c2 <strchr+0x1a>
  for(; *s; s++)
 1b8:	0505                	addi	a0,a0,1
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbfd                	bnez	a5,1b4 <strchr+0xc>
      return (char*)s;
  return 0;
 1c0:	4501                	li	a0,0
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret
  return 0;
 1c8:	4501                	li	a0,0
 1ca:	bfe5                	j	1c2 <strchr+0x1a>

00000000000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	711d                	addi	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	1080                	addi	s0,sp,96
 1e2:	8baa                	mv	s7,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ea:	4aa9                	li	s5,10
 1ec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ee:	89a6                	mv	s3,s1
 1f0:	2485                	addiw	s1,s1,1
 1f2:	0344d863          	bge	s1,s4,222 <gets+0x56>
    cc = read(0, &c, 1);
 1f6:	4605                	li	a2,1
 1f8:	faf40593          	addi	a1,s0,-81
 1fc:	4501                	li	a0,0
 1fe:	00000097          	auipc	ra,0x0
 202:	120080e7          	jalr	288(ra) # 31e <read>
    if(cc < 1)
 206:	00a05e63          	blez	a0,222 <gets+0x56>
    buf[i++] = c;
 20a:	faf44783          	lbu	a5,-81(s0)
 20e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 212:	01578763          	beq	a5,s5,220 <gets+0x54>
 216:	0905                	addi	s2,s2,1
 218:	fd679be3          	bne	a5,s6,1ee <gets+0x22>
  for(i=0; i+1 < max; ){
 21c:	89a6                	mv	s3,s1
 21e:	a011                	j	222 <gets+0x56>
 220:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 222:	99de                	add	s3,s3,s7
 224:	00098023          	sb	zero,0(s3)
  return buf;
}
 228:	855e                	mv	a0,s7
 22a:	60e6                	ld	ra,88(sp)
 22c:	6446                	ld	s0,80(sp)
 22e:	64a6                	ld	s1,72(sp)
 230:	6906                	ld	s2,64(sp)
 232:	79e2                	ld	s3,56(sp)
 234:	7a42                	ld	s4,48(sp)
 236:	7aa2                	ld	s5,40(sp)
 238:	7b02                	ld	s6,32(sp)
 23a:	6be2                	ld	s7,24(sp)
 23c:	6125                	addi	sp,sp,96
 23e:	8082                	ret

0000000000000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	1101                	addi	sp,sp,-32
 242:	ec06                	sd	ra,24(sp)
 244:	e822                	sd	s0,16(sp)
 246:	e426                	sd	s1,8(sp)
 248:	e04a                	sd	s2,0(sp)
 24a:	1000                	addi	s0,sp,32
 24c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24e:	4581                	li	a1,0
 250:	00000097          	auipc	ra,0x0
 254:	0f6080e7          	jalr	246(ra) # 346 <open>
  if(fd < 0)
 258:	02054563          	bltz	a0,282 <stat+0x42>
 25c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25e:	85ca                	mv	a1,s2
 260:	00000097          	auipc	ra,0x0
 264:	0fe080e7          	jalr	254(ra) # 35e <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	00000097          	auipc	ra,0x0
 270:	0c2080e7          	jalr	194(ra) # 32e <close>
  return r;
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	64a2                	ld	s1,8(sp)
 27c:	6902                	ld	s2,0(sp)
 27e:	6105                	addi	sp,sp,32
 280:	8082                	ret
    return -1;
 282:	597d                	li	s2,-1
 284:	bfc5                	j	274 <stat+0x34>

0000000000000286 <atoi>:

int
atoi(const char *s)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054603          	lbu	a2,0(a0)
 290:	fd06079b          	addiw	a5,a2,-48
 294:	0ff7f793          	andi	a5,a5,255
 298:	4725                	li	a4,9
 29a:	02f76963          	bltu	a4,a5,2cc <atoi+0x46>
 29e:	86aa                	mv	a3,a0
  n = 0;
 2a0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2a2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2a4:	0685                	addi	a3,a3,1
 2a6:	0025179b          	slliw	a5,a0,0x2
 2aa:	9fa9                	addw	a5,a5,a0
 2ac:	0017979b          	slliw	a5,a5,0x1
 2b0:	9fb1                	addw	a5,a5,a2
 2b2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b6:	0006c603          	lbu	a2,0(a3)
 2ba:	fd06071b          	addiw	a4,a2,-48
 2be:	0ff77713          	andi	a4,a4,255
 2c2:	fee5f1e3          	bgeu	a1,a4,2a4 <atoi+0x1e>
  return n;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  n = 0;
 2cc:	4501                	li	a0,0
 2ce:	bfe5                	j	2c6 <atoi+0x40>

00000000000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d6:	02c05163          	blez	a2,2f8 <memmove+0x28>
 2da:	fff6071b          	addiw	a4,a2,-1
 2de:	1702                	slli	a4,a4,0x20
 2e0:	9301                	srli	a4,a4,0x20
 2e2:	0705                	addi	a4,a4,1
 2e4:	972a                	add	a4,a4,a0
  dst = vdst;
 2e6:	87aa                	mv	a5,a0
    *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0785                	addi	a5,a5,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x18>
  return vdst;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fe:	4885                	li	a7,1
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exit>:
.global exit
exit:
 li a7, SYS_exit
 306:	4889                	li	a7,2
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <wait>:
.global wait
wait:
 li a7, SYS_wait
 30e:	488d                	li	a7,3
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 316:	4891                	li	a7,4
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <read>:
.global read
read:
 li a7, SYS_read
 31e:	4895                	li	a7,5
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <write>:
.global write
write:
 li a7, SYS_write
 326:	48c1                	li	a7,16
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <close>:
.global close
close:
 li a7, SYS_close
 32e:	48d5                	li	a7,21
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <kill>:
.global kill
kill:
 li a7, SYS_kill
 336:	4899                	li	a7,6
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exec>:
.global exec
exec:
 li a7, SYS_exec
 33e:	489d                	li	a7,7
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <open>:
.global open
open:
 li a7, SYS_open
 346:	48bd                	li	a7,15
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34e:	48c5                	li	a7,17
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 356:	48c9                	li	a7,18
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35e:	48a1                	li	a7,8
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <link>:
.global link
link:
 li a7, SYS_link
 366:	48cd                	li	a7,19
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36e:	48d1                	li	a7,20
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 376:	48a5                	li	a7,9
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <dup>:
.global dup
dup:
 li a7, SYS_dup
 37e:	48a9                	li	a7,10
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 386:	48ad                	li	a7,11
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38e:	48b1                	li	a7,12
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 396:	48b5                	li	a7,13
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39e:	48b9                	li	a7,14
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 3a6:	48d9                	li	a7,22
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <crash>:
.global crash
crash:
 li a7, SYS_crash
 3ae:	48dd                	li	a7,23
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mount>:
.global mount
mount:
 li a7, SYS_mount
 3b6:	48e1                	li	a7,24
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <umount>:
.global umount
umount:
 li a7, SYS_umount
 3be:	48e5                	li	a7,25
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c6:	1101                	addi	sp,sp,-32
 3c8:	ec06                	sd	ra,24(sp)
 3ca:	e822                	sd	s0,16(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	fef40593          	addi	a1,s0,-17
 3d8:	00000097          	auipc	ra,0x0
 3dc:	f4e080e7          	jalr	-178(ra) # 326 <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e8:	7139                	addi	sp,sp,-64
 3ea:	fc06                	sd	ra,56(sp)
 3ec:	f822                	sd	s0,48(sp)
 3ee:	f426                	sd	s1,40(sp)
 3f0:	f04a                	sd	s2,32(sp)
 3f2:	ec4e                	sd	s3,24(sp)
 3f4:	0080                	addi	s0,sp,64
 3f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c299                	beqz	a3,3fe <printint+0x16>
 3fa:	0805c863          	bltz	a1,48a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fe:	2581                	sext.w	a1,a1
  neg = 0;
 400:	4881                	li	a7,0
 402:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 406:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 408:	2601                	sext.w	a2,a2
 40a:	00000517          	auipc	a0,0x0
 40e:	4e650513          	addi	a0,a0,1254 # 8f0 <digits>
 412:	883a                	mv	a6,a4
 414:	2705                	addiw	a4,a4,1
 416:	02c5f7bb          	remuw	a5,a1,a2
 41a:	1782                	slli	a5,a5,0x20
 41c:	9381                	srli	a5,a5,0x20
 41e:	97aa                	add	a5,a5,a0
 420:	0007c783          	lbu	a5,0(a5)
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	0005879b          	sext.w	a5,a1
 42c:	02c5d5bb          	divuw	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f0e3          	bgeu	a5,a2,412 <printint+0x2a>
  if(neg)
 436:	00088b63          	beqz	a7,44c <printint+0x64>
    buf[i++] = '-';
 43a:	fd040793          	addi	a5,s0,-48
 43e:	973e                	add	a4,a4,a5
 440:	02d00793          	li	a5,45
 444:	fef70823          	sb	a5,-16(a4)
 448:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44c:	02e05863          	blez	a4,47c <printint+0x94>
 450:	fc040793          	addi	a5,s0,-64
 454:	00e78933          	add	s2,a5,a4
 458:	fff78993          	addi	s3,a5,-1
 45c:	99ba                	add	s3,s3,a4
 45e:	377d                	addiw	a4,a4,-1
 460:	1702                	slli	a4,a4,0x20
 462:	9301                	srli	a4,a4,0x20
 464:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 468:	fff94583          	lbu	a1,-1(s2)
 46c:	8526                	mv	a0,s1
 46e:	00000097          	auipc	ra,0x0
 472:	f58080e7          	jalr	-168(ra) # 3c6 <putc>
  while(--i >= 0)
 476:	197d                	addi	s2,s2,-1
 478:	ff3918e3          	bne	s2,s3,468 <printint+0x80>
}
 47c:	70e2                	ld	ra,56(sp)
 47e:	7442                	ld	s0,48(sp)
 480:	74a2                	ld	s1,40(sp)
 482:	7902                	ld	s2,32(sp)
 484:	69e2                	ld	s3,24(sp)
 486:	6121                	addi	sp,sp,64
 488:	8082                	ret
    x = -xx;
 48a:	40b005bb          	negw	a1,a1
    neg = 1;
 48e:	4885                	li	a7,1
    x = -xx;
 490:	bf8d                	j	402 <printint+0x1a>

0000000000000492 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 492:	7119                	addi	sp,sp,-128
 494:	fc86                	sd	ra,120(sp)
 496:	f8a2                	sd	s0,112(sp)
 498:	f4a6                	sd	s1,104(sp)
 49a:	f0ca                	sd	s2,96(sp)
 49c:	ecce                	sd	s3,88(sp)
 49e:	e8d2                	sd	s4,80(sp)
 4a0:	e4d6                	sd	s5,72(sp)
 4a2:	e0da                	sd	s6,64(sp)
 4a4:	fc5e                	sd	s7,56(sp)
 4a6:	f862                	sd	s8,48(sp)
 4a8:	f466                	sd	s9,40(sp)
 4aa:	f06a                	sd	s10,32(sp)
 4ac:	ec6e                	sd	s11,24(sp)
 4ae:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b0:	0005c903          	lbu	s2,0(a1)
 4b4:	18090f63          	beqz	s2,652 <vprintf+0x1c0>
 4b8:	8aaa                	mv	s5,a0
 4ba:	8b32                	mv	s6,a2
 4bc:	00158493          	addi	s1,a1,1
  state = 0;
 4c0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c2:	02500a13          	li	s4,37
      if(c == 'd'){
 4c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ca:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4ce:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4d2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d6:	00000b97          	auipc	s7,0x0
 4da:	41ab8b93          	addi	s7,s7,1050 # 8f0 <digits>
 4de:	a839                	j	4fc <vprintf+0x6a>
        putc(fd, c);
 4e0:	85ca                	mv	a1,s2
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	ee2080e7          	jalr	-286(ra) # 3c6 <putc>
 4ec:	a019                	j	4f2 <vprintf+0x60>
    } else if(state == '%'){
 4ee:	01498f63          	beq	s3,s4,50c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4f2:	0485                	addi	s1,s1,1
 4f4:	fff4c903          	lbu	s2,-1(s1)
 4f8:	14090d63          	beqz	s2,652 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 500:	fe0997e3          	bnez	s3,4ee <vprintf+0x5c>
      if(c == '%'){
 504:	fd479ee3          	bne	a5,s4,4e0 <vprintf+0x4e>
        state = '%';
 508:	89be                	mv	s3,a5
 50a:	b7e5                	j	4f2 <vprintf+0x60>
      if(c == 'd'){
 50c:	05878063          	beq	a5,s8,54c <vprintf+0xba>
      } else if(c == 'l') {
 510:	05978c63          	beq	a5,s9,568 <vprintf+0xd6>
      } else if(c == 'x') {
 514:	07a78863          	beq	a5,s10,584 <vprintf+0xf2>
      } else if(c == 'p') {
 518:	09b78463          	beq	a5,s11,5a0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 51c:	07300713          	li	a4,115
 520:	0ce78663          	beq	a5,a4,5ec <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 524:	06300713          	li	a4,99
 528:	0ee78e63          	beq	a5,a4,624 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 52c:	11478863          	beq	a5,s4,63c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 530:	85d2                	mv	a1,s4
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e92080e7          	jalr	-366(ra) # 3c6 <putc>
        putc(fd, c);
 53c:	85ca                	mv	a1,s2
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e86080e7          	jalr	-378(ra) # 3c6 <putc>
      }
      state = 0;
 548:	4981                	li	s3,0
 54a:	b765                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 54c:	008b0913          	addi	s2,s6,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e8e080e7          	jalr	-370(ra) # 3e8 <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	b771                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	008b0913          	addi	s2,s6,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000b2583          	lw	a1,0(s6)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e72080e7          	jalr	-398(ra) # 3e8 <printint>
 57e:	8b4a                	mv	s6,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	bf85                	j	4f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 584:	008b0913          	addi	s2,s6,8
 588:	4681                	li	a3,0
 58a:	4641                	li	a2,16
 58c:	000b2583          	lw	a1,0(s6)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e56080e7          	jalr	-426(ra) # 3e8 <printint>
 59a:	8b4a                	mv	s6,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bf91                	j	4f2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5a0:	008b0793          	addi	a5,s6,8
 5a4:	f8f43423          	sd	a5,-120(s0)
 5a8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ac:	03000593          	li	a1,48
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e14080e7          	jalr	-492(ra) # 3c6 <putc>
  putc(fd, 'x');
 5ba:	85ea                	mv	a1,s10
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e08080e7          	jalr	-504(ra) # 3c6 <putc>
 5c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	03c9d793          	srli	a5,s3,0x3c
 5cc:	97de                	add	a5,a5,s7
 5ce:	0007c583          	lbu	a1,0(a5)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	df2080e7          	jalr	-526(ra) # 3c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5dc:	0992                	slli	s3,s3,0x4
 5de:	397d                	addiw	s2,s2,-1
 5e0:	fe0914e3          	bnez	s2,5c8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5e4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b721                	j	4f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ec:	008b0993          	addi	s3,s6,8
 5f0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5f4:	02090163          	beqz	s2,616 <vprintf+0x184>
        while(*s != 0){
 5f8:	00094583          	lbu	a1,0(s2)
 5fc:	c9a1                	beqz	a1,64c <vprintf+0x1ba>
          putc(fd, *s);
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dc6080e7          	jalr	-570(ra) # 3c6 <putc>
          s++;
 608:	0905                	addi	s2,s2,1
        while(*s != 0){
 60a:	00094583          	lbu	a1,0(s2)
 60e:	f9e5                	bnez	a1,5fe <vprintf+0x16c>
        s = va_arg(ap, char*);
 610:	8b4e                	mv	s6,s3
      state = 0;
 612:	4981                	li	s3,0
 614:	bdf9                	j	4f2 <vprintf+0x60>
          s = "(null)";
 616:	00000917          	auipc	s2,0x0
 61a:	2d290913          	addi	s2,s2,722 # 8e8 <malloc+0x18c>
        while(*s != 0){
 61e:	02800593          	li	a1,40
 622:	bff1                	j	5fe <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 624:	008b0913          	addi	s2,s6,8
 628:	000b4583          	lbu	a1,0(s6)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	d98080e7          	jalr	-616(ra) # 3c6 <putc>
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd65                	j	4f2 <vprintf+0x60>
        putc(fd, c);
 63c:	85d2                	mv	a1,s4
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d86080e7          	jalr	-634(ra) # 3c6 <putc>
      state = 0;
 648:	4981                	li	s3,0
 64a:	b565                	j	4f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 64c:	8b4e                	mv	s6,s3
      state = 0;
 64e:	4981                	li	s3,0
 650:	b54d                	j	4f2 <vprintf+0x60>
    }
  }
}
 652:	70e6                	ld	ra,120(sp)
 654:	7446                	ld	s0,112(sp)
 656:	74a6                	ld	s1,104(sp)
 658:	7906                	ld	s2,96(sp)
 65a:	69e6                	ld	s3,88(sp)
 65c:	6a46                	ld	s4,80(sp)
 65e:	6aa6                	ld	s5,72(sp)
 660:	6b06                	ld	s6,64(sp)
 662:	7be2                	ld	s7,56(sp)
 664:	7c42                	ld	s8,48(sp)
 666:	7ca2                	ld	s9,40(sp)
 668:	7d02                	ld	s10,32(sp)
 66a:	6de2                	ld	s11,24(sp)
 66c:	6109                	addi	sp,sp,128
 66e:	8082                	ret

0000000000000670 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 670:	715d                	addi	sp,sp,-80
 672:	ec06                	sd	ra,24(sp)
 674:	e822                	sd	s0,16(sp)
 676:	1000                	addi	s0,sp,32
 678:	e010                	sd	a2,0(s0)
 67a:	e414                	sd	a3,8(s0)
 67c:	e818                	sd	a4,16(s0)
 67e:	ec1c                	sd	a5,24(s0)
 680:	03043023          	sd	a6,32(s0)
 684:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 688:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68c:	8622                	mv	a2,s0
 68e:	00000097          	auipc	ra,0x0
 692:	e04080e7          	jalr	-508(ra) # 492 <vprintf>
}
 696:	60e2                	ld	ra,24(sp)
 698:	6442                	ld	s0,16(sp)
 69a:	6161                	addi	sp,sp,80
 69c:	8082                	ret

000000000000069e <printf>:

void
printf(const char *fmt, ...)
{
 69e:	711d                	addi	sp,sp,-96
 6a0:	ec06                	sd	ra,24(sp)
 6a2:	e822                	sd	s0,16(sp)
 6a4:	1000                	addi	s0,sp,32
 6a6:	e40c                	sd	a1,8(s0)
 6a8:	e810                	sd	a2,16(s0)
 6aa:	ec14                	sd	a3,24(s0)
 6ac:	f018                	sd	a4,32(s0)
 6ae:	f41c                	sd	a5,40(s0)
 6b0:	03043823          	sd	a6,48(s0)
 6b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	00840613          	addi	a2,s0,8
 6bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c0:	85aa                	mv	a1,a0
 6c2:	4505                	li	a0,1
 6c4:	00000097          	auipc	ra,0x0
 6c8:	dce080e7          	jalr	-562(ra) # 492 <vprintf>
}
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret

00000000000006d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	00000797          	auipc	a5,0x0
 6e2:	22a7b783          	ld	a5,554(a5) # 908 <freep>
 6e6:	a805                	j	716 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e8:	4618                	lw	a4,8(a2)
 6ea:	9db9                	addw	a1,a1,a4
 6ec:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	6398                	ld	a4,0(a5)
 6f2:	6318                	ld	a4,0(a4)
 6f4:	fee53823          	sd	a4,-16(a0)
 6f8:	a091                	j	73c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fa:	ff852703          	lw	a4,-8(a0)
 6fe:	9e39                	addw	a2,a2,a4
 700:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 702:	ff053703          	ld	a4,-16(a0)
 706:	e398                	sd	a4,0(a5)
 708:	a099                	j	74e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x40>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x50>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x36>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059713          	slli	a4,a1,0x20
 72e:	9301                	srli	a4,a4,0x20
 730:	0712                	slli	a4,a4,0x4
 732:	9736                	add	a4,a4,a3
 734:	fae60ae3          	beq	a2,a4,6e8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061713          	slli	a4,a2,0x20
 742:	9301                	srli	a4,a4,0x20
 744:	0712                	slli	a4,a4,0x4
 746:	973e                	add	a4,a4,a5
 748:	fae689e3          	beq	a3,a4,6fa <free+0x26>
  } else
    p->s.ptr = bp;
 74c:	e394                	sd	a3,0(a5)
  freep = p;
 74e:	00000717          	auipc	a4,0x0
 752:	1af73d23          	sd	a5,442(a4) # 908 <freep>
}
 756:	6422                	ld	s0,8(sp)
 758:	0141                	addi	sp,sp,16
 75a:	8082                	ret

000000000000075c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75c:	7139                	addi	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f426                	sd	s1,40(sp)
 764:	f04a                	sd	s2,32(sp)
 766:	ec4e                	sd	s3,24(sp)
 768:	e852                	sd	s4,16(sp)
 76a:	e456                	sd	s5,8(sp)
 76c:	e05a                	sd	s6,0(sp)
 76e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	02051493          	slli	s1,a0,0x20
 774:	9081                	srli	s1,s1,0x20
 776:	04bd                	addi	s1,s1,15
 778:	8091                	srli	s1,s1,0x4
 77a:	0014899b          	addiw	s3,s1,1
 77e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 780:	00000517          	auipc	a0,0x0
 784:	18853503          	ld	a0,392(a0) # 908 <freep>
 788:	c515                	beqz	a0,7b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78c:	4798                	lw	a4,8(a5)
 78e:	02977f63          	bgeu	a4,s1,7cc <malloc+0x70>
 792:	8a4e                	mv	s4,s3
 794:	0009871b          	sext.w	a4,s3
 798:	6685                	lui	a3,0x1
 79a:	00d77363          	bgeu	a4,a3,7a0 <malloc+0x44>
 79e:	6a05                	lui	s4,0x1
 7a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a8:	00000917          	auipc	s2,0x0
 7ac:	16090913          	addi	s2,s2,352 # 908 <freep>
  if(p == (char*)-1)
 7b0:	5afd                	li	s5,-1
 7b2:	a88d                	j	824 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7b4:	00000797          	auipc	a5,0x0
 7b8:	15c78793          	addi	a5,a5,348 # 910 <base>
 7bc:	00000717          	auipc	a4,0x0
 7c0:	14f73623          	sd	a5,332(a4) # 908 <freep>
 7c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ca:	b7e1                	j	792 <malloc+0x36>
      if(p->s.size == nunits)
 7cc:	02e48b63          	beq	s1,a4,802 <malloc+0xa6>
        p->s.size -= nunits;
 7d0:	4137073b          	subw	a4,a4,s3
 7d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d6:	1702                	slli	a4,a4,0x20
 7d8:	9301                	srli	a4,a4,0x20
 7da:	0712                	slli	a4,a4,0x4
 7dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e2:	00000717          	auipc	a4,0x0
 7e6:	12a73323          	sd	a0,294(a4) # 908 <freep>
      return (void*)(p + 1);
 7ea:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ee:	70e2                	ld	ra,56(sp)
 7f0:	7442                	ld	s0,48(sp)
 7f2:	74a2                	ld	s1,40(sp)
 7f4:	7902                	ld	s2,32(sp)
 7f6:	69e2                	ld	s3,24(sp)
 7f8:	6a42                	ld	s4,16(sp)
 7fa:	6aa2                	ld	s5,8(sp)
 7fc:	6b02                	ld	s6,0(sp)
 7fe:	6121                	addi	sp,sp,64
 800:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	e118                	sd	a4,0(a0)
 806:	bff1                	j	7e2 <malloc+0x86>
  hp->s.size = nu;
 808:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80c:	0541                	addi	a0,a0,16
 80e:	00000097          	auipc	ra,0x0
 812:	ec6080e7          	jalr	-314(ra) # 6d4 <free>
  return freep;
 816:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81a:	d971                	beqz	a0,7ee <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	fa9776e3          	bgeu	a4,s1,7cc <malloc+0x70>
    if(p == freep)
 824:	00093703          	ld	a4,0(s2)
 828:	853e                	mv	a0,a5
 82a:	fef719e3          	bne	a4,a5,81c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 82e:	8552                	mv	a0,s4
 830:	00000097          	auipc	ra,0x0
 834:	b5e080e7          	jalr	-1186(ra) # 38e <sbrk>
  if(p == (char*)-1)
 838:	fd5518e3          	bne	a0,s5,808 <malloc+0xac>
        return 0;
 83c:	4501                	li	a0,0
 83e:	bf45                	j	7ee <malloc+0x92>
