
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	e06a                	sd	s10,0(sp)
 134:	1080                	addi	s0,sp,96
 136:	89aa                	mv	s3,a0
 138:	8bae                	mv	s7,a1
  m = 0;
 13a:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	3ff00c13          	li	s8,1023
 140:	00001b17          	auipc	s6,0x1
 144:	8f8b0b13          	addi	s6,s6,-1800 # a38 <buf>
    p = buf;
 148:	8d5a                	mv	s10,s6
        *q = '\n';
 14a:	4aa9                	li	s5,10
    p = buf;
 14c:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14e:	a099                	j	194 <grep+0x7a>
        *q = '\n';
 150:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 154:	00148613          	addi	a2,s1,1
 158:	4126063b          	subw	a2,a2,s2
 15c:	85ca                	mv	a1,s2
 15e:	4505                	li	a0,1
 160:	00000097          	auipc	ra,0x0
 164:	35c080e7          	jalr	860(ra) # 4bc <write>
      p = q+1;
 168:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 16c:	45a9                	li	a1,10
 16e:	854a                	mv	a0,s2
 170:	00000097          	auipc	ra,0x0
 174:	1ce080e7          	jalr	462(ra) # 33e <strchr>
 178:	84aa                	mv	s1,a0
 17a:	c919                	beqz	a0,190 <grep+0x76>
      *q = 0;
 17c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 180:	85ca                	mv	a1,s2
 182:	854e                	mv	a0,s3
 184:	00000097          	auipc	ra,0x0
 188:	f48080e7          	jalr	-184(ra) # cc <match>
 18c:	dd71                	beqz	a0,168 <grep+0x4e>
 18e:	b7c9                	j	150 <grep+0x36>
    if(m > 0){
 190:	03404563          	bgtz	s4,1ba <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 194:	414c063b          	subw	a2,s8,s4
 198:	014b05b3          	add	a1,s6,s4
 19c:	855e                	mv	a0,s7
 19e:	00000097          	auipc	ra,0x0
 1a2:	316080e7          	jalr	790(ra) # 4b4 <read>
 1a6:	02a05663          	blez	a0,1d2 <grep+0xb8>
    m += n;
 1aa:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1ae:	014b07b3          	add	a5,s6,s4
 1b2:	00078023          	sb	zero,0(a5)
    p = buf;
 1b6:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 1b8:	bf55                	j	16c <grep+0x52>
      m -= p - buf;
 1ba:	416907b3          	sub	a5,s2,s6
 1be:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1c2:	8652                	mv	a2,s4
 1c4:	85ca                	mv	a1,s2
 1c6:	856a                	mv	a0,s10
 1c8:	00000097          	auipc	ra,0x0
 1cc:	29e080e7          	jalr	670(ra) # 466 <memmove>
 1d0:	b7d1                	j	194 <grep+0x7a>
}
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6c42                	ld	s8,16(sp)
 1e6:	6ca2                	ld	s9,8(sp)
 1e8:	6d02                	ld	s10,0(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <main>:
{
 1ee:	7139                	addi	sp,sp,-64
 1f0:	fc06                	sd	ra,56(sp)
 1f2:	f822                	sd	s0,48(sp)
 1f4:	f426                	sd	s1,40(sp)
 1f6:	f04a                	sd	s2,32(sp)
 1f8:	ec4e                	sd	s3,24(sp)
 1fa:	e852                	sd	s4,16(sp)
 1fc:	e456                	sd	s5,8(sp)
 1fe:	0080                	addi	s0,sp,64
  if(argc <= 1){
 200:	4785                	li	a5,1
 202:	04a7dd63          	bge	a5,a0,25c <main+0x6e>
  pattern = argv[1];
 206:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 20a:	4789                	li	a5,2
 20c:	06a7d563          	bge	a5,a0,276 <main+0x88>
 210:	01058913          	addi	s2,a1,16
 214:	ffd5099b          	addiw	s3,a0,-3
 218:	1982                	slli	s3,s3,0x20
 21a:	0209d993          	srli	s3,s3,0x20
 21e:	098e                	slli	s3,s3,0x3
 220:	05e1                	addi	a1,a1,24
 222:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 224:	4581                	li	a1,0
 226:	00093503          	ld	a0,0(s2)
 22a:	00000097          	auipc	ra,0x0
 22e:	2b2080e7          	jalr	690(ra) # 4dc <open>
 232:	84aa                	mv	s1,a0
 234:	04054b63          	bltz	a0,28a <main+0x9c>
    grep(pattern, fd);
 238:	85aa                	mv	a1,a0
 23a:	8552                	mv	a0,s4
 23c:	00000097          	auipc	ra,0x0
 240:	ede080e7          	jalr	-290(ra) # 11a <grep>
    close(fd);
 244:	8526                	mv	a0,s1
 246:	00000097          	auipc	ra,0x0
 24a:	27e080e7          	jalr	638(ra) # 4c4 <close>
  for(i = 2; i < argc; i++){
 24e:	0921                	addi	s2,s2,8
 250:	fd391ae3          	bne	s2,s3,224 <main+0x36>
  exit();
 254:	00000097          	auipc	ra,0x0
 258:	248080e7          	jalr	584(ra) # 49c <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25c:	00000597          	auipc	a1,0x0
 260:	77c58593          	addi	a1,a1,1916 # 9d8 <malloc+0xe6>
 264:	4509                	li	a0,2
 266:	00000097          	auipc	ra,0x0
 26a:	5a0080e7          	jalr	1440(ra) # 806 <fprintf>
    exit();
 26e:	00000097          	auipc	ra,0x0
 272:	22e080e7          	jalr	558(ra) # 49c <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit();
 282:	00000097          	auipc	ra,0x0
 286:	21a080e7          	jalr	538(ra) # 49c <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28a:	00093583          	ld	a1,0(s2)
 28e:	00000517          	auipc	a0,0x0
 292:	76a50513          	addi	a0,a0,1898 # 9f8 <malloc+0x106>
 296:	00000097          	auipc	ra,0x0
 29a:	59e080e7          	jalr	1438(ra) # 834 <printf>
      exit();
 29e:	00000097          	auipc	ra,0x0
 2a2:	1fe080e7          	jalr	510(ra) # 49c <exit>

00000000000002a6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ac:	87aa                	mv	a5,a0
 2ae:	0585                	addi	a1,a1,1
 2b0:	0785                	addi	a5,a5,1
 2b2:	fff5c703          	lbu	a4,-1(a1)
 2b6:	fee78fa3          	sb	a4,-1(a5)
 2ba:	fb75                	bnez	a4,2ae <strcpy+0x8>
    ;
  return os;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cb91                	beqz	a5,2e0 <strcmp+0x1e>
 2ce:	0005c703          	lbu	a4,0(a1)
 2d2:	00f71763          	bne	a4,a5,2e0 <strcmp+0x1e>
    p++, q++;
 2d6:	0505                	addi	a0,a0,1
 2d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	fbe5                	bnez	a5,2ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e0:	0005c503          	lbu	a0,0(a1)
}
 2e4:	40a7853b          	subw	a0,a5,a0
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <strlen>:

uint
strlen(const char *s)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cf91                	beqz	a5,314 <strlen+0x26>
 2fa:	0505                	addi	a0,a0,1
 2fc:	87aa                	mv	a5,a0
 2fe:	4685                	li	a3,1
 300:	9e89                	subw	a3,a3,a0
 302:	00f6853b          	addw	a0,a3,a5
 306:	0785                	addi	a5,a5,1
 308:	fff7c703          	lbu	a4,-1(a5)
 30c:	fb7d                	bnez	a4,302 <strlen+0x14>
    ;
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strlen+0x20>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31e:	ce09                	beqz	a2,338 <memset+0x20>
 320:	87aa                	mv	a5,a0
 322:	fff6071b          	addiw	a4,a2,-1
 326:	1702                	slli	a4,a4,0x20
 328:	9301                	srli	a4,a4,0x20
 32a:	0705                	addi	a4,a4,1
 32c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 32e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 332:	0785                	addi	a5,a5,1
 334:	fee79de3          	bne	a5,a4,32e <memset+0x16>
  }
  return dst;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  for(; *s; s++)
 344:	00054783          	lbu	a5,0(a0)
 348:	cb99                	beqz	a5,35e <strchr+0x20>
    if(*s == c)
 34a:	00f58763          	beq	a1,a5,358 <strchr+0x1a>
  for(; *s; s++)
 34e:	0505                	addi	a0,a0,1
 350:	00054783          	lbu	a5,0(a0)
 354:	fbfd                	bnez	a5,34a <strchr+0xc>
      return (char*)s;
  return 0;
 356:	4501                	li	a0,0
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  return 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <strchr+0x1a>

0000000000000362 <gets>:

char*
gets(char *buf, int max)
{
 362:	711d                	addi	sp,sp,-96
 364:	ec86                	sd	ra,88(sp)
 366:	e8a2                	sd	s0,80(sp)
 368:	e4a6                	sd	s1,72(sp)
 36a:	e0ca                	sd	s2,64(sp)
 36c:	fc4e                	sd	s3,56(sp)
 36e:	f852                	sd	s4,48(sp)
 370:	f456                	sd	s5,40(sp)
 372:	f05a                	sd	s6,32(sp)
 374:	ec5e                	sd	s7,24(sp)
 376:	1080                	addi	s0,sp,96
 378:	8baa                	mv	s7,a0
 37a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37c:	892a                	mv	s2,a0
 37e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 380:	4aa9                	li	s5,10
 382:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 384:	89a6                	mv	s3,s1
 386:	2485                	addiw	s1,s1,1
 388:	0344d863          	bge	s1,s4,3b8 <gets+0x56>
    cc = read(0, &c, 1);
 38c:	4605                	li	a2,1
 38e:	faf40593          	addi	a1,s0,-81
 392:	4501                	li	a0,0
 394:	00000097          	auipc	ra,0x0
 398:	120080e7          	jalr	288(ra) # 4b4 <read>
    if(cc < 1)
 39c:	00a05e63          	blez	a0,3b8 <gets+0x56>
    buf[i++] = c;
 3a0:	faf44783          	lbu	a5,-81(s0)
 3a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a8:	01578763          	beq	a5,s5,3b6 <gets+0x54>
 3ac:	0905                	addi	s2,s2,1
 3ae:	fd679be3          	bne	a5,s6,384 <gets+0x22>
  for(i=0; i+1 < max; ){
 3b2:	89a6                	mv	s3,s1
 3b4:	a011                	j	3b8 <gets+0x56>
 3b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b8:	99de                	add	s3,s3,s7
 3ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 3be:	855e                	mv	a0,s7
 3c0:	60e6                	ld	ra,88(sp)
 3c2:	6446                	ld	s0,80(sp)
 3c4:	64a6                	ld	s1,72(sp)
 3c6:	6906                	ld	s2,64(sp)
 3c8:	79e2                	ld	s3,56(sp)
 3ca:	7a42                	ld	s4,48(sp)
 3cc:	7aa2                	ld	s5,40(sp)
 3ce:	7b02                	ld	s6,32(sp)
 3d0:	6be2                	ld	s7,24(sp)
 3d2:	6125                	addi	sp,sp,96
 3d4:	8082                	ret

00000000000003d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d6:	1101                	addi	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	e426                	sd	s1,8(sp)
 3de:	e04a                	sd	s2,0(sp)
 3e0:	1000                	addi	s0,sp,32
 3e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e4:	4581                	li	a1,0
 3e6:	00000097          	auipc	ra,0x0
 3ea:	0f6080e7          	jalr	246(ra) # 4dc <open>
  if(fd < 0)
 3ee:	02054563          	bltz	a0,418 <stat+0x42>
 3f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f4:	85ca                	mv	a1,s2
 3f6:	00000097          	auipc	ra,0x0
 3fa:	0fe080e7          	jalr	254(ra) # 4f4 <fstat>
 3fe:	892a                	mv	s2,a0
  close(fd);
 400:	8526                	mv	a0,s1
 402:	00000097          	auipc	ra,0x0
 406:	0c2080e7          	jalr	194(ra) # 4c4 <close>
  return r;
}
 40a:	854a                	mv	a0,s2
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	64a2                	ld	s1,8(sp)
 412:	6902                	ld	s2,0(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret
    return -1;
 418:	597d                	li	s2,-1
 41a:	bfc5                	j	40a <stat+0x34>

000000000000041c <atoi>:

int
atoi(const char *s)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 422:	00054603          	lbu	a2,0(a0)
 426:	fd06079b          	addiw	a5,a2,-48
 42a:	0ff7f793          	andi	a5,a5,255
 42e:	4725                	li	a4,9
 430:	02f76963          	bltu	a4,a5,462 <atoi+0x46>
 434:	86aa                	mv	a3,a0
  n = 0;
 436:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 438:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 43a:	0685                	addi	a3,a3,1
 43c:	0025179b          	slliw	a5,a0,0x2
 440:	9fa9                	addw	a5,a5,a0
 442:	0017979b          	slliw	a5,a5,0x1
 446:	9fb1                	addw	a5,a5,a2
 448:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44c:	0006c603          	lbu	a2,0(a3)
 450:	fd06071b          	addiw	a4,a2,-48
 454:	0ff77713          	andi	a4,a4,255
 458:	fee5f1e3          	bgeu	a1,a4,43a <atoi+0x1e>
  return n;
}
 45c:	6422                	ld	s0,8(sp)
 45e:	0141                	addi	sp,sp,16
 460:	8082                	ret
  n = 0;
 462:	4501                	li	a0,0
 464:	bfe5                	j	45c <atoi+0x40>

0000000000000466 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 466:	1141                	addi	sp,sp,-16
 468:	e422                	sd	s0,8(sp)
 46a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 46c:	02c05163          	blez	a2,48e <memmove+0x28>
 470:	fff6071b          	addiw	a4,a2,-1
 474:	1702                	slli	a4,a4,0x20
 476:	9301                	srli	a4,a4,0x20
 478:	0705                	addi	a4,a4,1
 47a:	972a                	add	a4,a4,a0
  dst = vdst;
 47c:	87aa                	mv	a5,a0
    *dst++ = *src++;
 47e:	0585                	addi	a1,a1,1
 480:	0785                	addi	a5,a5,1
 482:	fff5c683          	lbu	a3,-1(a1)
 486:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 48a:	fee79ae3          	bne	a5,a4,47e <memmove+0x18>
  return vdst;
}
 48e:	6422                	ld	s0,8(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret

0000000000000494 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 494:	4885                	li	a7,1
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <exit>:
.global exit
exit:
 li a7, SYS_exit
 49c:	4889                	li	a7,2
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a4:	488d                	li	a7,3
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ac:	4891                	li	a7,4
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <read>:
.global read
read:
 li a7, SYS_read
 4b4:	4895                	li	a7,5
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <write>:
.global write
write:
 li a7, SYS_write
 4bc:	48c1                	li	a7,16
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <close>:
.global close
close:
 li a7, SYS_close
 4c4:	48d5                	li	a7,21
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 4cc:	4899                	li	a7,6
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d4:	489d                	li	a7,7
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <open>:
.global open
open:
 li a7, SYS_open
 4dc:	48bd                	li	a7,15
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e4:	48c5                	li	a7,17
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ec:	48c9                	li	a7,18
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f4:	48a1                	li	a7,8
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <link>:
.global link
link:
 li a7, SYS_link
 4fc:	48cd                	li	a7,19
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 504:	48d1                	li	a7,20
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 50c:	48a5                	li	a7,9
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <dup>:
.global dup
dup:
 li a7, SYS_dup
 514:	48a9                	li	a7,10
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 51c:	48ad                	li	a7,11
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 524:	48b1                	li	a7,12
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 52c:	48b5                	li	a7,13
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 534:	48b9                	li	a7,14
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 53c:	48d9                	li	a7,22
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <crash>:
.global crash
crash:
 li a7, SYS_crash
 544:	48dd                	li	a7,23
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <mount>:
.global mount
mount:
 li a7, SYS_mount
 54c:	48e1                	li	a7,24
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <umount>:
.global umount
umount:
 li a7, SYS_umount
 554:	48e5                	li	a7,25
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55c:	1101                	addi	sp,sp,-32
 55e:	ec06                	sd	ra,24(sp)
 560:	e822                	sd	s0,16(sp)
 562:	1000                	addi	s0,sp,32
 564:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 568:	4605                	li	a2,1
 56a:	fef40593          	addi	a1,s0,-17
 56e:	00000097          	auipc	ra,0x0
 572:	f4e080e7          	jalr	-178(ra) # 4bc <write>
}
 576:	60e2                	ld	ra,24(sp)
 578:	6442                	ld	s0,16(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	7139                	addi	sp,sp,-64
 580:	fc06                	sd	ra,56(sp)
 582:	f822                	sd	s0,48(sp)
 584:	f426                	sd	s1,40(sp)
 586:	f04a                	sd	s2,32(sp)
 588:	ec4e                	sd	s3,24(sp)
 58a:	0080                	addi	s0,sp,64
 58c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58e:	c299                	beqz	a3,594 <printint+0x16>
 590:	0805c863          	bltz	a1,620 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 594:	2581                	sext.w	a1,a1
  neg = 0;
 596:	4881                	li	a7,0
 598:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 59c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59e:	2601                	sext.w	a2,a2
 5a0:	00000517          	auipc	a0,0x0
 5a4:	47850513          	addi	a0,a0,1144 # a18 <digits>
 5a8:	883a                	mv	a6,a4
 5aa:	2705                	addiw	a4,a4,1
 5ac:	02c5f7bb          	remuw	a5,a1,a2
 5b0:	1782                	slli	a5,a5,0x20
 5b2:	9381                	srli	a5,a5,0x20
 5b4:	97aa                	add	a5,a5,a0
 5b6:	0007c783          	lbu	a5,0(a5)
 5ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5be:	0005879b          	sext.w	a5,a1
 5c2:	02c5d5bb          	divuw	a1,a1,a2
 5c6:	0685                	addi	a3,a3,1
 5c8:	fec7f0e3          	bgeu	a5,a2,5a8 <printint+0x2a>
  if(neg)
 5cc:	00088b63          	beqz	a7,5e2 <printint+0x64>
    buf[i++] = '-';
 5d0:	fd040793          	addi	a5,s0,-48
 5d4:	973e                	add	a4,a4,a5
 5d6:	02d00793          	li	a5,45
 5da:	fef70823          	sb	a5,-16(a4)
 5de:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e2:	02e05863          	blez	a4,612 <printint+0x94>
 5e6:	fc040793          	addi	a5,s0,-64
 5ea:	00e78933          	add	s2,a5,a4
 5ee:	fff78993          	addi	s3,a5,-1
 5f2:	99ba                	add	s3,s3,a4
 5f4:	377d                	addiw	a4,a4,-1
 5f6:	1702                	slli	a4,a4,0x20
 5f8:	9301                	srli	a4,a4,0x20
 5fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fe:	fff94583          	lbu	a1,-1(s2)
 602:	8526                	mv	a0,s1
 604:	00000097          	auipc	ra,0x0
 608:	f58080e7          	jalr	-168(ra) # 55c <putc>
  while(--i >= 0)
 60c:	197d                	addi	s2,s2,-1
 60e:	ff3918e3          	bne	s2,s3,5fe <printint+0x80>
}
 612:	70e2                	ld	ra,56(sp)
 614:	7442                	ld	s0,48(sp)
 616:	74a2                	ld	s1,40(sp)
 618:	7902                	ld	s2,32(sp)
 61a:	69e2                	ld	s3,24(sp)
 61c:	6121                	addi	sp,sp,64
 61e:	8082                	ret
    x = -xx;
 620:	40b005bb          	negw	a1,a1
    neg = 1;
 624:	4885                	li	a7,1
    x = -xx;
 626:	bf8d                	j	598 <printint+0x1a>

0000000000000628 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 628:	7119                	addi	sp,sp,-128
 62a:	fc86                	sd	ra,120(sp)
 62c:	f8a2                	sd	s0,112(sp)
 62e:	f4a6                	sd	s1,104(sp)
 630:	f0ca                	sd	s2,96(sp)
 632:	ecce                	sd	s3,88(sp)
 634:	e8d2                	sd	s4,80(sp)
 636:	e4d6                	sd	s5,72(sp)
 638:	e0da                	sd	s6,64(sp)
 63a:	fc5e                	sd	s7,56(sp)
 63c:	f862                	sd	s8,48(sp)
 63e:	f466                	sd	s9,40(sp)
 640:	f06a                	sd	s10,32(sp)
 642:	ec6e                	sd	s11,24(sp)
 644:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 646:	0005c903          	lbu	s2,0(a1)
 64a:	18090f63          	beqz	s2,7e8 <vprintf+0x1c0>
 64e:	8aaa                	mv	s5,a0
 650:	8b32                	mv	s6,a2
 652:	00158493          	addi	s1,a1,1
  state = 0;
 656:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 658:	02500a13          	li	s4,37
      if(c == 'd'){
 65c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 660:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 664:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 668:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	3acb8b93          	addi	s7,s7,940 # a18 <digits>
 674:	a839                	j	692 <vprintf+0x6a>
        putc(fd, c);
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	ee2080e7          	jalr	-286(ra) # 55c <putc>
 682:	a019                	j	688 <vprintf+0x60>
    } else if(state == '%'){
 684:	01498f63          	beq	s3,s4,6a2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 688:	0485                	addi	s1,s1,1
 68a:	fff4c903          	lbu	s2,-1(s1)
 68e:	14090d63          	beqz	s2,7e8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 692:	0009079b          	sext.w	a5,s2
    if(state == 0){
 696:	fe0997e3          	bnez	s3,684 <vprintf+0x5c>
      if(c == '%'){
 69a:	fd479ee3          	bne	a5,s4,676 <vprintf+0x4e>
        state = '%';
 69e:	89be                	mv	s3,a5
 6a0:	b7e5                	j	688 <vprintf+0x60>
      if(c == 'd'){
 6a2:	05878063          	beq	a5,s8,6e2 <vprintf+0xba>
      } else if(c == 'l') {
 6a6:	05978c63          	beq	a5,s9,6fe <vprintf+0xd6>
      } else if(c == 'x') {
 6aa:	07a78863          	beq	a5,s10,71a <vprintf+0xf2>
      } else if(c == 'p') {
 6ae:	09b78463          	beq	a5,s11,736 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b2:	07300713          	li	a4,115
 6b6:	0ce78663          	beq	a5,a4,782 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ba:	06300713          	li	a4,99
 6be:	0ee78e63          	beq	a5,a4,7ba <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c2:	11478863          	beq	a5,s4,7d2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c6:	85d2                	mv	a1,s4
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e92080e7          	jalr	-366(ra) # 55c <putc>
        putc(fd, c);
 6d2:	85ca                	mv	a1,s2
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e86080e7          	jalr	-378(ra) # 55c <putc>
      }
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b765                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e2:	008b0913          	addi	s2,s6,8
 6e6:	4685                	li	a3,1
 6e8:	4629                	li	a2,10
 6ea:	000b2583          	lw	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e8e080e7          	jalr	-370(ra) # 57e <printint>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b771                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b0913          	addi	s2,s6,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000b2583          	lw	a1,0(s6)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e72080e7          	jalr	-398(ra) # 57e <printint>
 714:	8b4a                	mv	s6,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bf85                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71a:	008b0913          	addi	s2,s6,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000b2583          	lw	a1,0(s6)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e56080e7          	jalr	-426(ra) # 57e <printint>
 730:	8b4a                	mv	s6,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	bf91                	j	688 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 736:	008b0793          	addi	a5,s6,8
 73a:	f8f43423          	sd	a5,-120(s0)
 73e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 742:	03000593          	li	a1,48
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e14080e7          	jalr	-492(ra) # 55c <putc>
  putc(fd, 'x');
 750:	85ea                	mv	a1,s10
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e08080e7          	jalr	-504(ra) # 55c <putc>
 75c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75e:	03c9d793          	srli	a5,s3,0x3c
 762:	97de                	add	a5,a5,s7
 764:	0007c583          	lbu	a1,0(a5)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	df2080e7          	jalr	-526(ra) # 55c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 772:	0992                	slli	s3,s3,0x4
 774:	397d                	addiw	s2,s2,-1
 776:	fe0914e3          	bnez	s2,75e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 77a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 77e:	4981                	li	s3,0
 780:	b721                	j	688 <vprintf+0x60>
        s = va_arg(ap, char*);
 782:	008b0993          	addi	s3,s6,8
 786:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 78a:	02090163          	beqz	s2,7ac <vprintf+0x184>
        while(*s != 0){
 78e:	00094583          	lbu	a1,0(s2)
 792:	c9a1                	beqz	a1,7e2 <vprintf+0x1ba>
          putc(fd, *s);
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	dc6080e7          	jalr	-570(ra) # 55c <putc>
          s++;
 79e:	0905                	addi	s2,s2,1
        while(*s != 0){
 7a0:	00094583          	lbu	a1,0(s2)
 7a4:	f9e5                	bnez	a1,794 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a6:	8b4e                	mv	s6,s3
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bdf9                	j	688 <vprintf+0x60>
          s = "(null)";
 7ac:	00000917          	auipc	s2,0x0
 7b0:	26490913          	addi	s2,s2,612 # a10 <malloc+0x11e>
        while(*s != 0){
 7b4:	02800593          	li	a1,40
 7b8:	bff1                	j	794 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7ba:	008b0913          	addi	s2,s6,8
 7be:	000b4583          	lbu	a1,0(s6)
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	d98080e7          	jalr	-616(ra) # 55c <putc>
 7cc:	8b4a                	mv	s6,s2
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bd65                	j	688 <vprintf+0x60>
        putc(fd, c);
 7d2:	85d2                	mv	a1,s4
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d86080e7          	jalr	-634(ra) # 55c <putc>
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b565                	j	688 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e2:	8b4e                	mv	s6,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b54d                	j	688 <vprintf+0x60>
    }
  }
}
 7e8:	70e6                	ld	ra,120(sp)
 7ea:	7446                	ld	s0,112(sp)
 7ec:	74a6                	ld	s1,104(sp)
 7ee:	7906                	ld	s2,96(sp)
 7f0:	69e6                	ld	s3,88(sp)
 7f2:	6a46                	ld	s4,80(sp)
 7f4:	6aa6                	ld	s5,72(sp)
 7f6:	6b06                	ld	s6,64(sp)
 7f8:	7be2                	ld	s7,56(sp)
 7fa:	7c42                	ld	s8,48(sp)
 7fc:	7ca2                	ld	s9,40(sp)
 7fe:	7d02                	ld	s10,32(sp)
 800:	6de2                	ld	s11,24(sp)
 802:	6109                	addi	sp,sp,128
 804:	8082                	ret

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	8622                	mv	a2,s0
 824:	00000097          	auipc	ra,0x0
 828:	e04080e7          	jalr	-508(ra) # 628 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:

void
printf(const char *fmt, ...)
{
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e40c                	sd	a1,8(s0)
 83e:	e810                	sd	a2,16(s0)
 840:	ec14                	sd	a3,24(s0)
 842:	f018                	sd	a4,32(s0)
 844:	f41c                	sd	a5,40(s0)
 846:	03043823          	sd	a6,48(s0)
 84a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	00840613          	addi	a2,s0,8
 852:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 856:	85aa                	mv	a1,a0
 858:	4505                	li	a0,1
 85a:	00000097          	auipc	ra,0x0
 85e:	dce080e7          	jalr	-562(ra) # 628 <vprintf>
}
 862:	60e2                	ld	ra,24(sp)
 864:	6442                	ld	s0,16(sp)
 866:	6125                	addi	sp,sp,96
 868:	8082                	ret

000000000000086a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86a:	1141                	addi	sp,sp,-16
 86c:	e422                	sd	s0,8(sp)
 86e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 870:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	00000797          	auipc	a5,0x0
 878:	1bc7b783          	ld	a5,444(a5) # a30 <freep>
 87c:	a805                	j	8ac <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87e:	4618                	lw	a4,8(a2)
 880:	9db9                	addw	a1,a1,a4
 882:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	6318                	ld	a4,0(a4)
 88a:	fee53823          	sd	a4,-16(a0)
 88e:	a091                	j	8d2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 890:	ff852703          	lw	a4,-8(a0)
 894:	9e39                	addw	a2,a2,a4
 896:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 898:	ff053703          	ld	a4,-16(a0)
 89c:	e398                	sd	a4,0(a5)
 89e:	a099                	j	8e4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e7e463          	bltu	a5,a4,8aa <free+0x40>
 8a6:	00e6ea63          	bltu	a3,a4,8ba <free+0x50>
{
 8aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	fed7fae3          	bgeu	a5,a3,8a0 <free+0x36>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e6e463          	bltu	a3,a4,8ba <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	fee7eae3          	bltu	a5,a4,8aa <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8ba:	ff852583          	lw	a1,-8(a0)
 8be:	6390                	ld	a2,0(a5)
 8c0:	02059713          	slli	a4,a1,0x20
 8c4:	9301                	srli	a4,a4,0x20
 8c6:	0712                	slli	a4,a4,0x4
 8c8:	9736                	add	a4,a4,a3
 8ca:	fae60ae3          	beq	a2,a4,87e <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d2:	4790                	lw	a2,8(a5)
 8d4:	02061713          	slli	a4,a2,0x20
 8d8:	9301                	srli	a4,a4,0x20
 8da:	0712                	slli	a4,a4,0x4
 8dc:	973e                	add	a4,a4,a5
 8de:	fae689e3          	beq	a3,a4,890 <free+0x26>
  } else
    p->s.ptr = bp;
 8e2:	e394                	sd	a3,0(a5)
  freep = p;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	14f73623          	sd	a5,332(a4) # a30 <freep>
}
 8ec:	6422                	ld	s0,8(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret

00000000000008f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f426                	sd	s1,40(sp)
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	ec4e                	sd	s3,24(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
 904:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 916:	00000517          	auipc	a0,0x0
 91a:	11a53503          	ld	a0,282(a0) # a30 <freep>
 91e:	c515                	beqz	a0,94a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	02977f63          	bgeu	a4,s1,962 <malloc+0x70>
 928:	8a4e                	mv	s4,s3
 92a:	0009871b          	sext.w	a4,s3
 92e:	6685                	lui	a3,0x1
 930:	00d77363          	bgeu	a4,a3,936 <malloc+0x44>
 934:	6a05                	lui	s4,0x1
 936:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93e:	00000917          	auipc	s2,0x0
 942:	0f290913          	addi	s2,s2,242 # a30 <freep>
  if(p == (char*)-1)
 946:	5afd                	li	s5,-1
 948:	a88d                	j	9ba <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 94a:	00000797          	auipc	a5,0x0
 94e:	4ee78793          	addi	a5,a5,1262 # e38 <base>
 952:	00000717          	auipc	a4,0x0
 956:	0cf73f23          	sd	a5,222(a4) # a30 <freep>
 95a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 960:	b7e1                	j	928 <malloc+0x36>
      if(p->s.size == nunits)
 962:	02e48b63          	beq	s1,a4,998 <malloc+0xa6>
        p->s.size -= nunits;
 966:	4137073b          	subw	a4,a4,s3
 96a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96c:	1702                	slli	a4,a4,0x20
 96e:	9301                	srli	a4,a4,0x20
 970:	0712                	slli	a4,a4,0x4
 972:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 974:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 978:	00000717          	auipc	a4,0x0
 97c:	0aa73c23          	sd	a0,184(a4) # a30 <freep>
      return (void*)(p + 1);
 980:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 984:	70e2                	ld	ra,56(sp)
 986:	7442                	ld	s0,48(sp)
 988:	74a2                	ld	s1,40(sp)
 98a:	7902                	ld	s2,32(sp)
 98c:	69e2                	ld	s3,24(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	6121                	addi	sp,sp,64
 996:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 998:	6398                	ld	a4,0(a5)
 99a:	e118                	sd	a4,0(a0)
 99c:	bff1                	j	978 <malloc+0x86>
  hp->s.size = nu;
 99e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a2:	0541                	addi	a0,a0,16
 9a4:	00000097          	auipc	ra,0x0
 9a8:	ec6080e7          	jalr	-314(ra) # 86a <free>
  return freep;
 9ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b0:	d971                	beqz	a0,984 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b4:	4798                	lw	a4,8(a5)
 9b6:	fa9776e3          	bgeu	a4,s1,962 <malloc+0x70>
    if(p == freep)
 9ba:	00093703          	ld	a4,0(s2)
 9be:	853e                	mv	a0,a5
 9c0:	fef719e3          	bne	a4,a5,9b2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9c4:	8552                	mv	a0,s4
 9c6:	00000097          	auipc	ra,0x0
 9ca:	b5e080e7          	jalr	-1186(ra) # 524 <sbrk>
  if(p == (char*)-1)
 9ce:	fd5518e3          	bne	a0,s5,99e <malloc+0xac>
        return 0;
 9d2:	4501                	li	a0,0
 9d4:	bf45                	j	984 <malloc+0x92>
