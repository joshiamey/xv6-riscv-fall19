
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	308080e7          	jalr	776(ra) # 318 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2dc080e7          	jalr	732(ra) # 318 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2ba080e7          	jalr	698(ra) # 318 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	a3298993          	addi	s3,s3,-1486 # a98 <buf.1108>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	41a080e7          	jalr	1050(ra) # 490 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	298080e7          	jalr	664(ra) # 318 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28a080e7          	jalr	650(ra) # 318 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29a080e7          	jalr	666(ra) # 342 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	42c080e7          	jalr	1068(ra) # 506 <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	432080e7          	jalr	1074(ra) # 51e <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	90c50513          	addi	a0,a0,-1780 # a30 <malloc+0x114>
 12c:	00000097          	auipc	ra,0x0
 130:	732080e7          	jalr	1842(ra) # 85e <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	3b8080e7          	jalr	952(ra) # 4ee <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	89e58593          	addi	a1,a1,-1890 # a00 <malloc+0xe4>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	6c4080e7          	jalr	1732(ra) # 830 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	8a058593          	addi	a1,a1,-1888 # a18 <malloc+0xfc>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	6ae080e7          	jalr	1710(ra) # 830 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	362080e7          	jalr	866(ra) # 4ee <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	180080e7          	jalr	384(ra) # 318 <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	89650513          	addi	a0,a0,-1898 # a40 <malloc+0x124>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	6ac080e7          	jalr	1708(ra) # 85e <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	10e080e7          	jalr	270(ra) # 2d0 <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14a080e7          	jalr	330(ra) # 318 <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	868a0a13          	addi	s4,s4,-1944 # a58 <malloc+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	820a8a93          	addi	s5,s5,-2016 # a18 <malloc+0xfc>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	656080e7          	jalr	1622(ra) # 85e <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	2c6080e7          	jalr	710(ra) # 4de <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	25c080e7          	jalr	604(ra) # 490 <memmove>
      p[DIRSIZ] = 0;
 23c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1b8080e7          	jalr	440(ra) # 400 <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	5ee080e7          	jalr	1518(ra) # 85e <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7d863          	bge	a5,a0,2b8 <main+0x3e>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	1902                	slli	s2,s2,0x20
 296:	02095913          	srli	s2,s2,0x20
 29a:	090e                	slli	s2,s2,0x3
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit();
 2b0:	00000097          	auipc	ra,0x0
 2b4:	216080e7          	jalr	534(ra) # 4c6 <exit>
    ls(".");
 2b8:	00000517          	auipc	a0,0x0
 2bc:	7b050513          	addi	a0,a0,1968 # a68 <malloc+0x14c>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	df4080e7          	jalr	-524(ra) # b4 <ls>
    exit();
 2c8:	00000097          	auipc	ra,0x0
 2cc:	1fe080e7          	jalr	510(ra) # 4c6 <exit>

00000000000002d0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d6:	87aa                	mv	a5,a0
 2d8:	0585                	addi	a1,a1,1
 2da:	0785                	addi	a5,a5,1
 2dc:	fff5c703          	lbu	a4,-1(a1)
 2e0:	fee78fa3          	sb	a4,-1(a5)
 2e4:	fb75                	bnez	a4,2d8 <strcpy+0x8>
    ;
  return os;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cb91                	beqz	a5,30a <strcmp+0x1e>
 2f8:	0005c703          	lbu	a4,0(a1)
 2fc:	00f71763          	bne	a4,a5,30a <strcmp+0x1e>
    p++, q++;
 300:	0505                	addi	a0,a0,1
 302:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 304:	00054783          	lbu	a5,0(a0)
 308:	fbe5                	bnez	a5,2f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 30a:	0005c503          	lbu	a0,0(a1)
}
 30e:	40a7853b          	subw	a0,a5,a0
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <strlen>:

uint
strlen(const char *s)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 31e:	00054783          	lbu	a5,0(a0)
 322:	cf91                	beqz	a5,33e <strlen+0x26>
 324:	0505                	addi	a0,a0,1
 326:	87aa                	mv	a5,a0
 328:	4685                	li	a3,1
 32a:	9e89                	subw	a3,a3,a0
 32c:	00f6853b          	addw	a0,a3,a5
 330:	0785                	addi	a5,a5,1
 332:	fff7c703          	lbu	a4,-1(a5)
 336:	fb7d                	bnez	a4,32c <strlen+0x14>
    ;
  return n;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  for(n = 0; s[n]; n++)
 33e:	4501                	li	a0,0
 340:	bfe5                	j	338 <strlen+0x20>

0000000000000342 <memset>:

void*
memset(void *dst, int c, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 348:	ce09                	beqz	a2,362 <memset+0x20>
 34a:	87aa                	mv	a5,a0
 34c:	fff6071b          	addiw	a4,a2,-1
 350:	1702                	slli	a4,a4,0x20
 352:	9301                	srli	a4,a4,0x20
 354:	0705                	addi	a4,a4,1
 356:	972a                	add	a4,a4,a0
    cdst[i] = c;
 358:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 35c:	0785                	addi	a5,a5,1
 35e:	fee79de3          	bne	a5,a4,358 <memset+0x16>
  }
  return dst;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strchr>:

char*
strchr(const char *s, char c)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cb99                	beqz	a5,388 <strchr+0x20>
    if(*s == c)
 374:	00f58763          	beq	a1,a5,382 <strchr+0x1a>
  for(; *s; s++)
 378:	0505                	addi	a0,a0,1
 37a:	00054783          	lbu	a5,0(a0)
 37e:	fbfd                	bnez	a5,374 <strchr+0xc>
      return (char*)s;
  return 0;
 380:	4501                	li	a0,0
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  return 0;
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <strchr+0x1a>

000000000000038c <gets>:

char*
gets(char *buf, int max)
{
 38c:	711d                	addi	sp,sp,-96
 38e:	ec86                	sd	ra,88(sp)
 390:	e8a2                	sd	s0,80(sp)
 392:	e4a6                	sd	s1,72(sp)
 394:	e0ca                	sd	s2,64(sp)
 396:	fc4e                	sd	s3,56(sp)
 398:	f852                	sd	s4,48(sp)
 39a:	f456                	sd	s5,40(sp)
 39c:	f05a                	sd	s6,32(sp)
 39e:	ec5e                	sd	s7,24(sp)
 3a0:	1080                	addi	s0,sp,96
 3a2:	8baa                	mv	s7,a0
 3a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	892a                	mv	s2,a0
 3a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3aa:	4aa9                	li	s5,10
 3ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ae:	89a6                	mv	s3,s1
 3b0:	2485                	addiw	s1,s1,1
 3b2:	0344d863          	bge	s1,s4,3e2 <gets+0x56>
    cc = read(0, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	faf40593          	addi	a1,s0,-81
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	120080e7          	jalr	288(ra) # 4de <read>
    if(cc < 1)
 3c6:	00a05e63          	blez	a0,3e2 <gets+0x56>
    buf[i++] = c;
 3ca:	faf44783          	lbu	a5,-81(s0)
 3ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d2:	01578763          	beq	a5,s5,3e0 <gets+0x54>
 3d6:	0905                	addi	s2,s2,1
 3d8:	fd679be3          	bne	a5,s6,3ae <gets+0x22>
  for(i=0; i+1 < max; ){
 3dc:	89a6                	mv	s3,s1
 3de:	a011                	j	3e2 <gets+0x56>
 3e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e2:	99de                	add	s3,s3,s7
 3e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e8:	855e                	mv	a0,s7
 3ea:	60e6                	ld	ra,88(sp)
 3ec:	6446                	ld	s0,80(sp)
 3ee:	64a6                	ld	s1,72(sp)
 3f0:	6906                	ld	s2,64(sp)
 3f2:	79e2                	ld	s3,56(sp)
 3f4:	7a42                	ld	s4,48(sp)
 3f6:	7aa2                	ld	s5,40(sp)
 3f8:	7b02                	ld	s6,32(sp)
 3fa:	6be2                	ld	s7,24(sp)
 3fc:	6125                	addi	sp,sp,96
 3fe:	8082                	ret

0000000000000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	e426                	sd	s1,8(sp)
 408:	e04a                	sd	s2,0(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40e:	4581                	li	a1,0
 410:	00000097          	auipc	ra,0x0
 414:	0f6080e7          	jalr	246(ra) # 506 <open>
  if(fd < 0)
 418:	02054563          	bltz	a0,442 <stat+0x42>
 41c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 41e:	85ca                	mv	a1,s2
 420:	00000097          	auipc	ra,0x0
 424:	0fe080e7          	jalr	254(ra) # 51e <fstat>
 428:	892a                	mv	s2,a0
  close(fd);
 42a:	8526                	mv	a0,s1
 42c:	00000097          	auipc	ra,0x0
 430:	0c2080e7          	jalr	194(ra) # 4ee <close>
  return r;
}
 434:	854a                	mv	a0,s2
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	64a2                	ld	s1,8(sp)
 43c:	6902                	ld	s2,0(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret
    return -1;
 442:	597d                	li	s2,-1
 444:	bfc5                	j	434 <stat+0x34>

0000000000000446 <atoi>:

int
atoi(const char *s)
{
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44c:	00054603          	lbu	a2,0(a0)
 450:	fd06079b          	addiw	a5,a2,-48
 454:	0ff7f793          	andi	a5,a5,255
 458:	4725                	li	a4,9
 45a:	02f76963          	bltu	a4,a5,48c <atoi+0x46>
 45e:	86aa                	mv	a3,a0
  n = 0;
 460:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 462:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 464:	0685                	addi	a3,a3,1
 466:	0025179b          	slliw	a5,a0,0x2
 46a:	9fa9                	addw	a5,a5,a0
 46c:	0017979b          	slliw	a5,a5,0x1
 470:	9fb1                	addw	a5,a5,a2
 472:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 476:	0006c603          	lbu	a2,0(a3)
 47a:	fd06071b          	addiw	a4,a2,-48
 47e:	0ff77713          	andi	a4,a4,255
 482:	fee5f1e3          	bgeu	a1,a4,464 <atoi+0x1e>
  return n;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  n = 0;
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <atoi+0x40>

0000000000000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 496:	02c05163          	blez	a2,4b8 <memmove+0x28>
 49a:	fff6071b          	addiw	a4,a2,-1
 49e:	1702                	slli	a4,a4,0x20
 4a0:	9301                	srli	a4,a4,0x20
 4a2:	0705                	addi	a4,a4,1
 4a4:	972a                	add	a4,a4,a0
  dst = vdst;
 4a6:	87aa                	mv	a5,a0
    *dst++ = *src++;
 4a8:	0585                	addi	a1,a1,1
 4aa:	0785                	addi	a5,a5,1
 4ac:	fff5c683          	lbu	a3,-1(a1)
 4b0:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x18>
  return vdst;
}
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret

00000000000004be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4be:	4885                	li	a7,1
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c6:	4889                	li	a7,2
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ce:	488d                	li	a7,3
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d6:	4891                	li	a7,4
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <read>:
.global read
read:
 li a7, SYS_read
 4de:	4895                	li	a7,5
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <write>:
.global write
write:
 li a7, SYS_write
 4e6:	48c1                	li	a7,16
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <close>:
.global close
close:
 li a7, SYS_close
 4ee:	48d5                	li	a7,21
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f6:	4899                	li	a7,6
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 4fe:	489d                	li	a7,7
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <open>:
.global open
open:
 li a7, SYS_open
 506:	48bd                	li	a7,15
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 50e:	48c5                	li	a7,17
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 516:	48c9                	li	a7,18
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 51e:	48a1                	li	a7,8
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <link>:
.global link
link:
 li a7, SYS_link
 526:	48cd                	li	a7,19
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 52e:	48d1                	li	a7,20
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 536:	48a5                	li	a7,9
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <dup>:
.global dup
dup:
 li a7, SYS_dup
 53e:	48a9                	li	a7,10
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 546:	48ad                	li	a7,11
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 54e:	48b1                	li	a7,12
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 556:	48b5                	li	a7,13
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 55e:	48b9                	li	a7,14
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 566:	48d9                	li	a7,22
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <crash>:
.global crash
crash:
 li a7, SYS_crash
 56e:	48dd                	li	a7,23
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mount>:
.global mount
mount:
 li a7, SYS_mount
 576:	48e1                	li	a7,24
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <umount>:
.global umount
umount:
 li a7, SYS_umount
 57e:	48e5                	li	a7,25
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 586:	1101                	addi	sp,sp,-32
 588:	ec06                	sd	ra,24(sp)
 58a:	e822                	sd	s0,16(sp)
 58c:	1000                	addi	s0,sp,32
 58e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 592:	4605                	li	a2,1
 594:	fef40593          	addi	a1,s0,-17
 598:	00000097          	auipc	ra,0x0
 59c:	f4e080e7          	jalr	-178(ra) # 4e6 <write>
}
 5a0:	60e2                	ld	ra,24(sp)
 5a2:	6442                	ld	s0,16(sp)
 5a4:	6105                	addi	sp,sp,32
 5a6:	8082                	ret

00000000000005a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a8:	7139                	addi	sp,sp,-64
 5aa:	fc06                	sd	ra,56(sp)
 5ac:	f822                	sd	s0,48(sp)
 5ae:	f426                	sd	s1,40(sp)
 5b0:	f04a                	sd	s2,32(sp)
 5b2:	ec4e                	sd	s3,24(sp)
 5b4:	0080                	addi	s0,sp,64
 5b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b8:	c299                	beqz	a3,5be <printint+0x16>
 5ba:	0805c863          	bltz	a1,64a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5be:	2581                	sext.w	a1,a1
  neg = 0;
 5c0:	4881                	li	a7,0
 5c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c8:	2601                	sext.w	a2,a2
 5ca:	00000517          	auipc	a0,0x0
 5ce:	4ae50513          	addi	a0,a0,1198 # a78 <digits>
 5d2:	883a                	mv	a6,a4
 5d4:	2705                	addiw	a4,a4,1
 5d6:	02c5f7bb          	remuw	a5,a1,a2
 5da:	1782                	slli	a5,a5,0x20
 5dc:	9381                	srli	a5,a5,0x20
 5de:	97aa                	add	a5,a5,a0
 5e0:	0007c783          	lbu	a5,0(a5)
 5e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e8:	0005879b          	sext.w	a5,a1
 5ec:	02c5d5bb          	divuw	a1,a1,a2
 5f0:	0685                	addi	a3,a3,1
 5f2:	fec7f0e3          	bgeu	a5,a2,5d2 <printint+0x2a>
  if(neg)
 5f6:	00088b63          	beqz	a7,60c <printint+0x64>
    buf[i++] = '-';
 5fa:	fd040793          	addi	a5,s0,-48
 5fe:	973e                	add	a4,a4,a5
 600:	02d00793          	li	a5,45
 604:	fef70823          	sb	a5,-16(a4)
 608:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 60c:	02e05863          	blez	a4,63c <printint+0x94>
 610:	fc040793          	addi	a5,s0,-64
 614:	00e78933          	add	s2,a5,a4
 618:	fff78993          	addi	s3,a5,-1
 61c:	99ba                	add	s3,s3,a4
 61e:	377d                	addiw	a4,a4,-1
 620:	1702                	slli	a4,a4,0x20
 622:	9301                	srli	a4,a4,0x20
 624:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 628:	fff94583          	lbu	a1,-1(s2)
 62c:	8526                	mv	a0,s1
 62e:	00000097          	auipc	ra,0x0
 632:	f58080e7          	jalr	-168(ra) # 586 <putc>
  while(--i >= 0)
 636:	197d                	addi	s2,s2,-1
 638:	ff3918e3          	bne	s2,s3,628 <printint+0x80>
}
 63c:	70e2                	ld	ra,56(sp)
 63e:	7442                	ld	s0,48(sp)
 640:	74a2                	ld	s1,40(sp)
 642:	7902                	ld	s2,32(sp)
 644:	69e2                	ld	s3,24(sp)
 646:	6121                	addi	sp,sp,64
 648:	8082                	ret
    x = -xx;
 64a:	40b005bb          	negw	a1,a1
    neg = 1;
 64e:	4885                	li	a7,1
    x = -xx;
 650:	bf8d                	j	5c2 <printint+0x1a>

0000000000000652 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 652:	7119                	addi	sp,sp,-128
 654:	fc86                	sd	ra,120(sp)
 656:	f8a2                	sd	s0,112(sp)
 658:	f4a6                	sd	s1,104(sp)
 65a:	f0ca                	sd	s2,96(sp)
 65c:	ecce                	sd	s3,88(sp)
 65e:	e8d2                	sd	s4,80(sp)
 660:	e4d6                	sd	s5,72(sp)
 662:	e0da                	sd	s6,64(sp)
 664:	fc5e                	sd	s7,56(sp)
 666:	f862                	sd	s8,48(sp)
 668:	f466                	sd	s9,40(sp)
 66a:	f06a                	sd	s10,32(sp)
 66c:	ec6e                	sd	s11,24(sp)
 66e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 670:	0005c903          	lbu	s2,0(a1)
 674:	18090f63          	beqz	s2,812 <vprintf+0x1c0>
 678:	8aaa                	mv	s5,a0
 67a:	8b32                	mv	s6,a2
 67c:	00158493          	addi	s1,a1,1
  state = 0;
 680:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 682:	02500a13          	li	s4,37
      if(c == 'd'){
 686:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 68a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 68e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 692:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	00000b97          	auipc	s7,0x0
 69a:	3e2b8b93          	addi	s7,s7,994 # a78 <digits>
 69e:	a839                	j	6bc <vprintf+0x6a>
        putc(fd, c);
 6a0:	85ca                	mv	a1,s2
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	ee2080e7          	jalr	-286(ra) # 586 <putc>
 6ac:	a019                	j	6b2 <vprintf+0x60>
    } else if(state == '%'){
 6ae:	01498f63          	beq	s3,s4,6cc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6b2:	0485                	addi	s1,s1,1
 6b4:	fff4c903          	lbu	s2,-1(s1)
 6b8:	14090d63          	beqz	s2,812 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c0:	fe0997e3          	bnez	s3,6ae <vprintf+0x5c>
      if(c == '%'){
 6c4:	fd479ee3          	bne	a5,s4,6a0 <vprintf+0x4e>
        state = '%';
 6c8:	89be                	mv	s3,a5
 6ca:	b7e5                	j	6b2 <vprintf+0x60>
      if(c == 'd'){
 6cc:	05878063          	beq	a5,s8,70c <vprintf+0xba>
      } else if(c == 'l') {
 6d0:	05978c63          	beq	a5,s9,728 <vprintf+0xd6>
      } else if(c == 'x') {
 6d4:	07a78863          	beq	a5,s10,744 <vprintf+0xf2>
      } else if(c == 'p') {
 6d8:	09b78463          	beq	a5,s11,760 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6dc:	07300713          	li	a4,115
 6e0:	0ce78663          	beq	a5,a4,7ac <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e4:	06300713          	li	a4,99
 6e8:	0ee78e63          	beq	a5,a4,7e4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6ec:	11478863          	beq	a5,s4,7fc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f0:	85d2                	mv	a1,s4
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e92080e7          	jalr	-366(ra) # 586 <putc>
        putc(fd, c);
 6fc:	85ca                	mv	a1,s2
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e86080e7          	jalr	-378(ra) # 586 <putc>
      }
      state = 0;
 708:	4981                	li	s3,0
 70a:	b765                	j	6b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 70c:	008b0913          	addi	s2,s6,8
 710:	4685                	li	a3,1
 712:	4629                	li	a2,10
 714:	000b2583          	lw	a1,0(s6)
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	e8e080e7          	jalr	-370(ra) # 5a8 <printint>
 722:	8b4a                	mv	s6,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	b771                	j	6b2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 728:	008b0913          	addi	s2,s6,8
 72c:	4681                	li	a3,0
 72e:	4629                	li	a2,10
 730:	000b2583          	lw	a1,0(s6)
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	e72080e7          	jalr	-398(ra) # 5a8 <printint>
 73e:	8b4a                	mv	s6,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bf85                	j	6b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 744:	008b0913          	addi	s2,s6,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000b2583          	lw	a1,0(s6)
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e56080e7          	jalr	-426(ra) # 5a8 <printint>
 75a:	8b4a                	mv	s6,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bf91                	j	6b2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 760:	008b0793          	addi	a5,s6,8
 764:	f8f43423          	sd	a5,-120(s0)
 768:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 76c:	03000593          	li	a1,48
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	e14080e7          	jalr	-492(ra) # 586 <putc>
  putc(fd, 'x');
 77a:	85ea                	mv	a1,s10
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e08080e7          	jalr	-504(ra) # 586 <putc>
 786:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 788:	03c9d793          	srli	a5,s3,0x3c
 78c:	97de                	add	a5,a5,s7
 78e:	0007c583          	lbu	a1,0(a5)
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	df2080e7          	jalr	-526(ra) # 586 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79c:	0992                	slli	s3,s3,0x4
 79e:	397d                	addiw	s2,s2,-1
 7a0:	fe0914e3          	bnez	s2,788 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7a4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b721                	j	6b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 7ac:	008b0993          	addi	s3,s6,8
 7b0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7b4:	02090163          	beqz	s2,7d6 <vprintf+0x184>
        while(*s != 0){
 7b8:	00094583          	lbu	a1,0(s2)
 7bc:	c9a1                	beqz	a1,80c <vprintf+0x1ba>
          putc(fd, *s);
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	dc6080e7          	jalr	-570(ra) # 586 <putc>
          s++;
 7c8:	0905                	addi	s2,s2,1
        while(*s != 0){
 7ca:	00094583          	lbu	a1,0(s2)
 7ce:	f9e5                	bnez	a1,7be <vprintf+0x16c>
        s = va_arg(ap, char*);
 7d0:	8b4e                	mv	s6,s3
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bdf9                	j	6b2 <vprintf+0x60>
          s = "(null)";
 7d6:	00000917          	auipc	s2,0x0
 7da:	29a90913          	addi	s2,s2,666 # a70 <malloc+0x154>
        while(*s != 0){
 7de:	02800593          	li	a1,40
 7e2:	bff1                	j	7be <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7e4:	008b0913          	addi	s2,s6,8
 7e8:	000b4583          	lbu	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	d98080e7          	jalr	-616(ra) # 586 <putc>
 7f6:	8b4a                	mv	s6,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bd65                	j	6b2 <vprintf+0x60>
        putc(fd, c);
 7fc:	85d2                	mv	a1,s4
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	d86080e7          	jalr	-634(ra) # 586 <putc>
      state = 0;
 808:	4981                	li	s3,0
 80a:	b565                	j	6b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 80c:	8b4e                	mv	s6,s3
      state = 0;
 80e:	4981                	li	s3,0
 810:	b54d                	j	6b2 <vprintf+0x60>
    }
  }
}
 812:	70e6                	ld	ra,120(sp)
 814:	7446                	ld	s0,112(sp)
 816:	74a6                	ld	s1,104(sp)
 818:	7906                	ld	s2,96(sp)
 81a:	69e6                	ld	s3,88(sp)
 81c:	6a46                	ld	s4,80(sp)
 81e:	6aa6                	ld	s5,72(sp)
 820:	6b06                	ld	s6,64(sp)
 822:	7be2                	ld	s7,56(sp)
 824:	7c42                	ld	s8,48(sp)
 826:	7ca2                	ld	s9,40(sp)
 828:	7d02                	ld	s10,32(sp)
 82a:	6de2                	ld	s11,24(sp)
 82c:	6109                	addi	sp,sp,128
 82e:	8082                	ret

0000000000000830 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 830:	715d                	addi	sp,sp,-80
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e010                	sd	a2,0(s0)
 83a:	e414                	sd	a3,8(s0)
 83c:	e818                	sd	a4,16(s0)
 83e:	ec1c                	sd	a5,24(s0)
 840:	03043023          	sd	a6,32(s0)
 844:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84c:	8622                	mv	a2,s0
 84e:	00000097          	auipc	ra,0x0
 852:	e04080e7          	jalr	-508(ra) # 652 <vprintf>
}
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6161                	addi	sp,sp,80
 85c:	8082                	ret

000000000000085e <printf>:

void
printf(const char *fmt, ...)
{
 85e:	711d                	addi	sp,sp,-96
 860:	ec06                	sd	ra,24(sp)
 862:	e822                	sd	s0,16(sp)
 864:	1000                	addi	s0,sp,32
 866:	e40c                	sd	a1,8(s0)
 868:	e810                	sd	a2,16(s0)
 86a:	ec14                	sd	a3,24(s0)
 86c:	f018                	sd	a4,32(s0)
 86e:	f41c                	sd	a5,40(s0)
 870:	03043823          	sd	a6,48(s0)
 874:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 878:	00840613          	addi	a2,s0,8
 87c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 880:	85aa                	mv	a1,a0
 882:	4505                	li	a0,1
 884:	00000097          	auipc	ra,0x0
 888:	dce080e7          	jalr	-562(ra) # 652 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6125                	addi	sp,sp,96
 892:	8082                	ret

0000000000000894 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 894:	1141                	addi	sp,sp,-16
 896:	e422                	sd	s0,8(sp)
 898:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89e:	00000797          	auipc	a5,0x0
 8a2:	1f27b783          	ld	a5,498(a5) # a90 <freep>
 8a6:	a805                	j	8d6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a8:	4618                	lw	a4,8(a2)
 8aa:	9db9                	addw	a1,a1,a4
 8ac:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	6398                	ld	a4,0(a5)
 8b2:	6318                	ld	a4,0(a4)
 8b4:	fee53823          	sd	a4,-16(a0)
 8b8:	a091                	j	8fc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ba:	ff852703          	lw	a4,-8(a0)
 8be:	9e39                	addw	a2,a2,a4
 8c0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8c2:	ff053703          	ld	a4,-16(a0)
 8c6:	e398                	sd	a4,0(a5)
 8c8:	a099                	j	90e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e7e463          	bltu	a5,a4,8d4 <free+0x40>
 8d0:	00e6ea63          	bltu	a3,a4,8e4 <free+0x50>
{
 8d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	fed7fae3          	bgeu	a5,a3,8ca <free+0x36>
 8da:	6398                	ld	a4,0(a5)
 8dc:	00e6e463          	bltu	a3,a4,8e4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	fee7eae3          	bltu	a5,a4,8d4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8e4:	ff852583          	lw	a1,-8(a0)
 8e8:	6390                	ld	a2,0(a5)
 8ea:	02059713          	slli	a4,a1,0x20
 8ee:	9301                	srli	a4,a4,0x20
 8f0:	0712                	slli	a4,a4,0x4
 8f2:	9736                	add	a4,a4,a3
 8f4:	fae60ae3          	beq	a2,a4,8a8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8fc:	4790                	lw	a2,8(a5)
 8fe:	02061713          	slli	a4,a2,0x20
 902:	9301                	srli	a4,a4,0x20
 904:	0712                	slli	a4,a4,0x4
 906:	973e                	add	a4,a4,a5
 908:	fae689e3          	beq	a3,a4,8ba <free+0x26>
  } else
    p->s.ptr = bp;
 90c:	e394                	sd	a3,0(a5)
  freep = p;
 90e:	00000717          	auipc	a4,0x0
 912:	18f73123          	sd	a5,386(a4) # a90 <freep>
}
 916:	6422                	ld	s0,8(sp)
 918:	0141                	addi	sp,sp,16
 91a:	8082                	ret

000000000000091c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 91c:	7139                	addi	sp,sp,-64
 91e:	fc06                	sd	ra,56(sp)
 920:	f822                	sd	s0,48(sp)
 922:	f426                	sd	s1,40(sp)
 924:	f04a                	sd	s2,32(sp)
 926:	ec4e                	sd	s3,24(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
 92e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 930:	02051493          	slli	s1,a0,0x20
 934:	9081                	srli	s1,s1,0x20
 936:	04bd                	addi	s1,s1,15
 938:	8091                	srli	s1,s1,0x4
 93a:	0014899b          	addiw	s3,s1,1
 93e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 940:	00000517          	auipc	a0,0x0
 944:	15053503          	ld	a0,336(a0) # a90 <freep>
 948:	c515                	beqz	a0,974 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94c:	4798                	lw	a4,8(a5)
 94e:	02977f63          	bgeu	a4,s1,98c <malloc+0x70>
 952:	8a4e                	mv	s4,s3
 954:	0009871b          	sext.w	a4,s3
 958:	6685                	lui	a3,0x1
 95a:	00d77363          	bgeu	a4,a3,960 <malloc+0x44>
 95e:	6a05                	lui	s4,0x1
 960:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 964:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 968:	00000917          	auipc	s2,0x0
 96c:	12890913          	addi	s2,s2,296 # a90 <freep>
  if(p == (char*)-1)
 970:	5afd                	li	s5,-1
 972:	a88d                	j	9e4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 974:	00000797          	auipc	a5,0x0
 978:	13478793          	addi	a5,a5,308 # aa8 <base>
 97c:	00000717          	auipc	a4,0x0
 980:	10f73a23          	sd	a5,276(a4) # a90 <freep>
 984:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 986:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98a:	b7e1                	j	952 <malloc+0x36>
      if(p->s.size == nunits)
 98c:	02e48b63          	beq	s1,a4,9c2 <malloc+0xa6>
        p->s.size -= nunits;
 990:	4137073b          	subw	a4,a4,s3
 994:	c798                	sw	a4,8(a5)
        p += p->s.size;
 996:	1702                	slli	a4,a4,0x20
 998:	9301                	srli	a4,a4,0x20
 99a:	0712                	slli	a4,a4,0x4
 99c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a2:	00000717          	auipc	a4,0x0
 9a6:	0ea73723          	sd	a0,238(a4) # a90 <freep>
      return (void*)(p + 1);
 9aa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ae:	70e2                	ld	ra,56(sp)
 9b0:	7442                	ld	s0,48(sp)
 9b2:	74a2                	ld	s1,40(sp)
 9b4:	7902                	ld	s2,32(sp)
 9b6:	69e2                	ld	s3,24(sp)
 9b8:	6a42                	ld	s4,16(sp)
 9ba:	6aa2                	ld	s5,8(sp)
 9bc:	6b02                	ld	s6,0(sp)
 9be:	6121                	addi	sp,sp,64
 9c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9c2:	6398                	ld	a4,0(a5)
 9c4:	e118                	sd	a4,0(a0)
 9c6:	bff1                	j	9a2 <malloc+0x86>
  hp->s.size = nu;
 9c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9cc:	0541                	addi	a0,a0,16
 9ce:	00000097          	auipc	ra,0x0
 9d2:	ec6080e7          	jalr	-314(ra) # 894 <free>
  return freep;
 9d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9da:	d971                	beqz	a0,9ae <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9de:	4798                	lw	a4,8(a5)
 9e0:	fa9776e3          	bgeu	a4,s1,98c <malloc+0x70>
    if(p == freep)
 9e4:	00093703          	ld	a4,0(s2)
 9e8:	853e                	mv	a0,a5
 9ea:	fef719e3          	bne	a4,a5,9dc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9ee:	8552                	mv	a0,s4
 9f0:	00000097          	auipc	ra,0x0
 9f4:	b5e080e7          	jalr	-1186(ra) # 54e <sbrk>
  if(p == (char*)-1)
 9f8:	fd5518e3          	bne	a0,s5,9c8 <malloc+0xac>
        return 0;
 9fc:	4501                	li	a0,0
 9fe:	bf45                	j	9ae <malloc+0x92>
