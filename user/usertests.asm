
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <iputtest>:
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  printf("iput test\n");
       8:	00004517          	auipc	a0,0x4
       c:	4a050513          	addi	a0,a0,1184 # 44a8 <malloc+0x10a>
      10:	00004097          	auipc	ra,0x4
      14:	2d0080e7          	jalr	720(ra) # 42e0 <printf>

  if(mkdir("iputdir") < 0){
      18:	00004517          	auipc	a0,0x4
      1c:	4a050513          	addi	a0,a0,1184 # 44b8 <malloc+0x11a>
      20:	00004097          	auipc	ra,0x4
      24:	f90080e7          	jalr	-112(ra) # 3fb0 <mkdir>
      28:	04054c63          	bltz	a0,80 <iputtest+0x80>
    printf("mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      2c:	00004517          	auipc	a0,0x4
      30:	48c50513          	addi	a0,a0,1164 # 44b8 <malloc+0x11a>
      34:	00004097          	auipc	ra,0x4
      38:	f84080e7          	jalr	-124(ra) # 3fb8 <chdir>
      3c:	04054e63          	bltz	a0,98 <iputtest+0x98>
    printf("chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      40:	00004517          	auipc	a0,0x4
      44:	4a850513          	addi	a0,a0,1192 # 44e8 <malloc+0x14a>
      48:	00004097          	auipc	ra,0x4
      4c:	f50080e7          	jalr	-176(ra) # 3f98 <unlink>
      50:	06054063          	bltz	a0,b0 <iputtest+0xb0>
    printf("unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      54:	00004517          	auipc	a0,0x4
      58:	4c450513          	addi	a0,a0,1220 # 4518 <malloc+0x17a>
      5c:	00004097          	auipc	ra,0x4
      60:	f5c080e7          	jalr	-164(ra) # 3fb8 <chdir>
      64:	06054263          	bltz	a0,c8 <iputtest+0xc8>
    printf("chdir / failed\n");
    exit();
  }
  printf("iput test ok\n");
      68:	00004517          	auipc	a0,0x4
      6c:	4c850513          	addi	a0,a0,1224 # 4530 <malloc+0x192>
      70:	00004097          	auipc	ra,0x4
      74:	270080e7          	jalr	624(ra) # 42e0 <printf>
}
      78:	60a2                	ld	ra,8(sp)
      7a:	6402                	ld	s0,0(sp)
      7c:	0141                	addi	sp,sp,16
      7e:	8082                	ret
    printf("mkdir failed\n");
      80:	00004517          	auipc	a0,0x4
      84:	44050513          	addi	a0,a0,1088 # 44c0 <malloc+0x122>
      88:	00004097          	auipc	ra,0x4
      8c:	258080e7          	jalr	600(ra) # 42e0 <printf>
    exit();
      90:	00004097          	auipc	ra,0x4
      94:	eb8080e7          	jalr	-328(ra) # 3f48 <exit>
    printf("chdir iputdir failed\n");
      98:	00004517          	auipc	a0,0x4
      9c:	43850513          	addi	a0,a0,1080 # 44d0 <malloc+0x132>
      a0:	00004097          	auipc	ra,0x4
      a4:	240080e7          	jalr	576(ra) # 42e0 <printf>
    exit();
      a8:	00004097          	auipc	ra,0x4
      ac:	ea0080e7          	jalr	-352(ra) # 3f48 <exit>
    printf("unlink ../iputdir failed\n");
      b0:	00004517          	auipc	a0,0x4
      b4:	44850513          	addi	a0,a0,1096 # 44f8 <malloc+0x15a>
      b8:	00004097          	auipc	ra,0x4
      bc:	228080e7          	jalr	552(ra) # 42e0 <printf>
    exit();
      c0:	00004097          	auipc	ra,0x4
      c4:	e88080e7          	jalr	-376(ra) # 3f48 <exit>
    printf("chdir / failed\n");
      c8:	00004517          	auipc	a0,0x4
      cc:	45850513          	addi	a0,a0,1112 # 4520 <malloc+0x182>
      d0:	00004097          	auipc	ra,0x4
      d4:	210080e7          	jalr	528(ra) # 42e0 <printf>
    exit();
      d8:	00004097          	auipc	ra,0x4
      dc:	e70080e7          	jalr	-400(ra) # 3f48 <exit>

00000000000000e0 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      e0:	1141                	addi	sp,sp,-16
      e2:	e406                	sd	ra,8(sp)
      e4:	e022                	sd	s0,0(sp)
      e6:	0800                	addi	s0,sp,16
  int pid;

  printf("exitiput test\n");
      e8:	00004517          	auipc	a0,0x4
      ec:	45850513          	addi	a0,a0,1112 # 4540 <malloc+0x1a2>
      f0:	00004097          	auipc	ra,0x4
      f4:	1f0080e7          	jalr	496(ra) # 42e0 <printf>

  pid = fork();
      f8:	00004097          	auipc	ra,0x4
      fc:	e48080e7          	jalr	-440(ra) # 3f40 <fork>
  if(pid < 0){
     100:	04054563          	bltz	a0,14a <exitiputtest+0x6a>
    printf("fork failed\n");
    exit();
  }
  if(pid == 0){
     104:	e15d                	bnez	a0,1aa <exitiputtest+0xca>
    if(mkdir("iputdir") < 0){
     106:	00004517          	auipc	a0,0x4
     10a:	3b250513          	addi	a0,a0,946 # 44b8 <malloc+0x11a>
     10e:	00004097          	auipc	ra,0x4
     112:	ea2080e7          	jalr	-350(ra) # 3fb0 <mkdir>
     116:	04054663          	bltz	a0,162 <exitiputtest+0x82>
      printf("mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     11a:	00004517          	auipc	a0,0x4
     11e:	39e50513          	addi	a0,a0,926 # 44b8 <malloc+0x11a>
     122:	00004097          	auipc	ra,0x4
     126:	e96080e7          	jalr	-362(ra) # 3fb8 <chdir>
     12a:	04054863          	bltz	a0,17a <exitiputtest+0x9a>
      printf("child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     12e:	00004517          	auipc	a0,0x4
     132:	3ba50513          	addi	a0,a0,954 # 44e8 <malloc+0x14a>
     136:	00004097          	auipc	ra,0x4
     13a:	e62080e7          	jalr	-414(ra) # 3f98 <unlink>
     13e:	04054a63          	bltz	a0,192 <exitiputtest+0xb2>
      printf("unlink ../iputdir failed\n");
      exit();
    }
    exit();
     142:	00004097          	auipc	ra,0x4
     146:	e06080e7          	jalr	-506(ra) # 3f48 <exit>
    printf("fork failed\n");
     14a:	00004517          	auipc	a0,0x4
     14e:	40650513          	addi	a0,a0,1030 # 4550 <malloc+0x1b2>
     152:	00004097          	auipc	ra,0x4
     156:	18e080e7          	jalr	398(ra) # 42e0 <printf>
    exit();
     15a:	00004097          	auipc	ra,0x4
     15e:	dee080e7          	jalr	-530(ra) # 3f48 <exit>
      printf("mkdir failed\n");
     162:	00004517          	auipc	a0,0x4
     166:	35e50513          	addi	a0,a0,862 # 44c0 <malloc+0x122>
     16a:	00004097          	auipc	ra,0x4
     16e:	176080e7          	jalr	374(ra) # 42e0 <printf>
      exit();
     172:	00004097          	auipc	ra,0x4
     176:	dd6080e7          	jalr	-554(ra) # 3f48 <exit>
      printf("child chdir failed\n");
     17a:	00004517          	auipc	a0,0x4
     17e:	3e650513          	addi	a0,a0,998 # 4560 <malloc+0x1c2>
     182:	00004097          	auipc	ra,0x4
     186:	15e080e7          	jalr	350(ra) # 42e0 <printf>
      exit();
     18a:	00004097          	auipc	ra,0x4
     18e:	dbe080e7          	jalr	-578(ra) # 3f48 <exit>
      printf("unlink ../iputdir failed\n");
     192:	00004517          	auipc	a0,0x4
     196:	36650513          	addi	a0,a0,870 # 44f8 <malloc+0x15a>
     19a:	00004097          	auipc	ra,0x4
     19e:	146080e7          	jalr	326(ra) # 42e0 <printf>
      exit();
     1a2:	00004097          	auipc	ra,0x4
     1a6:	da6080e7          	jalr	-602(ra) # 3f48 <exit>
  }
  wait();
     1aa:	00004097          	auipc	ra,0x4
     1ae:	da6080e7          	jalr	-602(ra) # 3f50 <wait>
  printf("exitiput test ok\n");
     1b2:	00004517          	auipc	a0,0x4
     1b6:	3c650513          	addi	a0,a0,966 # 4578 <malloc+0x1da>
     1ba:	00004097          	auipc	ra,0x4
     1be:	126080e7          	jalr	294(ra) # 42e0 <printf>
}
     1c2:	60a2                	ld	ra,8(sp)
     1c4:	6402                	ld	s0,0(sp)
     1c6:	0141                	addi	sp,sp,16
     1c8:	8082                	ret

00000000000001ca <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1ca:	1141                	addi	sp,sp,-16
     1cc:	e406                	sd	ra,8(sp)
     1ce:	e022                	sd	s0,0(sp)
     1d0:	0800                	addi	s0,sp,16
  int pid;

  printf("openiput test\n");
     1d2:	00004517          	auipc	a0,0x4
     1d6:	3be50513          	addi	a0,a0,958 # 4590 <malloc+0x1f2>
     1da:	00004097          	auipc	ra,0x4
     1de:	106080e7          	jalr	262(ra) # 42e0 <printf>
  if(mkdir("oidir") < 0){
     1e2:	00004517          	auipc	a0,0x4
     1e6:	3be50513          	addi	a0,a0,958 # 45a0 <malloc+0x202>
     1ea:	00004097          	auipc	ra,0x4
     1ee:	dc6080e7          	jalr	-570(ra) # 3fb0 <mkdir>
     1f2:	04054063          	bltz	a0,232 <openiputtest+0x68>
    printf("mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1f6:	00004097          	auipc	ra,0x4
     1fa:	d4a080e7          	jalr	-694(ra) # 3f40 <fork>
  if(pid < 0){
     1fe:	04054663          	bltz	a0,24a <openiputtest+0x80>
    printf("fork failed\n");
    exit();
  }
  if(pid == 0){
     202:	e525                	bnez	a0,26a <openiputtest+0xa0>
    int fd = open("oidir", O_RDWR);
     204:	4589                	li	a1,2
     206:	00004517          	auipc	a0,0x4
     20a:	39a50513          	addi	a0,a0,922 # 45a0 <malloc+0x202>
     20e:	00004097          	auipc	ra,0x4
     212:	d7a080e7          	jalr	-646(ra) # 3f88 <open>
    if(fd >= 0){
     216:	04054663          	bltz	a0,262 <openiputtest+0x98>
      printf("open directory for write succeeded\n");
     21a:	00004517          	auipc	a0,0x4
     21e:	3a650513          	addi	a0,a0,934 # 45c0 <malloc+0x222>
     222:	00004097          	auipc	ra,0x4
     226:	0be080e7          	jalr	190(ra) # 42e0 <printf>
      exit();
     22a:	00004097          	auipc	ra,0x4
     22e:	d1e080e7          	jalr	-738(ra) # 3f48 <exit>
    printf("mkdir oidir failed\n");
     232:	00004517          	auipc	a0,0x4
     236:	37650513          	addi	a0,a0,886 # 45a8 <malloc+0x20a>
     23a:	00004097          	auipc	ra,0x4
     23e:	0a6080e7          	jalr	166(ra) # 42e0 <printf>
    exit();
     242:	00004097          	auipc	ra,0x4
     246:	d06080e7          	jalr	-762(ra) # 3f48 <exit>
    printf("fork failed\n");
     24a:	00004517          	auipc	a0,0x4
     24e:	30650513          	addi	a0,a0,774 # 4550 <malloc+0x1b2>
     252:	00004097          	auipc	ra,0x4
     256:	08e080e7          	jalr	142(ra) # 42e0 <printf>
    exit();
     25a:	00004097          	auipc	ra,0x4
     25e:	cee080e7          	jalr	-786(ra) # 3f48 <exit>
    }
    exit();
     262:	00004097          	auipc	ra,0x4
     266:	ce6080e7          	jalr	-794(ra) # 3f48 <exit>
  }
  sleep(1);
     26a:	4505                	li	a0,1
     26c:	00004097          	auipc	ra,0x4
     270:	d6c080e7          	jalr	-660(ra) # 3fd8 <sleep>
  if(unlink("oidir") != 0){
     274:	00004517          	auipc	a0,0x4
     278:	32c50513          	addi	a0,a0,812 # 45a0 <malloc+0x202>
     27c:	00004097          	auipc	ra,0x4
     280:	d1c080e7          	jalr	-740(ra) # 3f98 <unlink>
     284:	e10d                	bnez	a0,2a6 <openiputtest+0xdc>
    printf("unlink failed\n");
    exit();
  }
  wait();
     286:	00004097          	auipc	ra,0x4
     28a:	cca080e7          	jalr	-822(ra) # 3f50 <wait>
  printf("openiput test ok\n");
     28e:	00004517          	auipc	a0,0x4
     292:	36a50513          	addi	a0,a0,874 # 45f8 <malloc+0x25a>
     296:	00004097          	auipc	ra,0x4
     29a:	04a080e7          	jalr	74(ra) # 42e0 <printf>
}
     29e:	60a2                	ld	ra,8(sp)
     2a0:	6402                	ld	s0,0(sp)
     2a2:	0141                	addi	sp,sp,16
     2a4:	8082                	ret
    printf("unlink failed\n");
     2a6:	00004517          	auipc	a0,0x4
     2aa:	34250513          	addi	a0,a0,834 # 45e8 <malloc+0x24a>
     2ae:	00004097          	auipc	ra,0x4
     2b2:	032080e7          	jalr	50(ra) # 42e0 <printf>
    exit();
     2b6:	00004097          	auipc	ra,0x4
     2ba:	c92080e7          	jalr	-878(ra) # 3f48 <exit>

00000000000002be <opentest>:

// simple file system tests

void
opentest(void)
{
     2be:	1141                	addi	sp,sp,-16
     2c0:	e406                	sd	ra,8(sp)
     2c2:	e022                	sd	s0,0(sp)
     2c4:	0800                	addi	s0,sp,16
  int fd;

  printf("open test\n");
     2c6:	00004517          	auipc	a0,0x4
     2ca:	34a50513          	addi	a0,a0,842 # 4610 <malloc+0x272>
     2ce:	00004097          	auipc	ra,0x4
     2d2:	012080e7          	jalr	18(ra) # 42e0 <printf>
  fd = open("echo", 0);
     2d6:	4581                	li	a1,0
     2d8:	00004517          	auipc	a0,0x4
     2dc:	34850513          	addi	a0,a0,840 # 4620 <malloc+0x282>
     2e0:	00004097          	auipc	ra,0x4
     2e4:	ca8080e7          	jalr	-856(ra) # 3f88 <open>
  if(fd < 0){
     2e8:	02054d63          	bltz	a0,322 <opentest+0x64>
    printf("open echo failed!\n");
    exit();
  }
  close(fd);
     2ec:	00004097          	auipc	ra,0x4
     2f0:	c84080e7          	jalr	-892(ra) # 3f70 <close>
  fd = open("doesnotexist", 0);
     2f4:	4581                	li	a1,0
     2f6:	00004517          	auipc	a0,0x4
     2fa:	34a50513          	addi	a0,a0,842 # 4640 <malloc+0x2a2>
     2fe:	00004097          	auipc	ra,0x4
     302:	c8a080e7          	jalr	-886(ra) # 3f88 <open>
  if(fd >= 0){
     306:	02055a63          	bgez	a0,33a <opentest+0x7c>
    printf("open doesnotexist succeeded!\n");
    exit();
  }
  printf("open test ok\n");
     30a:	00004517          	auipc	a0,0x4
     30e:	36650513          	addi	a0,a0,870 # 4670 <malloc+0x2d2>
     312:	00004097          	auipc	ra,0x4
     316:	fce080e7          	jalr	-50(ra) # 42e0 <printf>
}
     31a:	60a2                	ld	ra,8(sp)
     31c:	6402                	ld	s0,0(sp)
     31e:	0141                	addi	sp,sp,16
     320:	8082                	ret
    printf("open echo failed!\n");
     322:	00004517          	auipc	a0,0x4
     326:	30650513          	addi	a0,a0,774 # 4628 <malloc+0x28a>
     32a:	00004097          	auipc	ra,0x4
     32e:	fb6080e7          	jalr	-74(ra) # 42e0 <printf>
    exit();
     332:	00004097          	auipc	ra,0x4
     336:	c16080e7          	jalr	-1002(ra) # 3f48 <exit>
    printf("open doesnotexist succeeded!\n");
     33a:	00004517          	auipc	a0,0x4
     33e:	31650513          	addi	a0,a0,790 # 4650 <malloc+0x2b2>
     342:	00004097          	auipc	ra,0x4
     346:	f9e080e7          	jalr	-98(ra) # 42e0 <printf>
    exit();
     34a:	00004097          	auipc	ra,0x4
     34e:	bfe080e7          	jalr	-1026(ra) # 3f48 <exit>

0000000000000352 <writetest>:

void
writetest(void)
{
     352:	7139                	addi	sp,sp,-64
     354:	fc06                	sd	ra,56(sp)
     356:	f822                	sd	s0,48(sp)
     358:	f426                	sd	s1,40(sp)
     35a:	f04a                	sd	s2,32(sp)
     35c:	ec4e                	sd	s3,24(sp)
     35e:	e852                	sd	s4,16(sp)
     360:	e456                	sd	s5,8(sp)
     362:	0080                	addi	s0,sp,64
  int fd;
  int i;
  enum { N=100, SZ=10 };
  
  printf("small file test\n");
     364:	00004517          	auipc	a0,0x4
     368:	31c50513          	addi	a0,a0,796 # 4680 <malloc+0x2e2>
     36c:	00004097          	auipc	ra,0x4
     370:	f74080e7          	jalr	-140(ra) # 42e0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     374:	20200593          	li	a1,514
     378:	00004517          	auipc	a0,0x4
     37c:	32050513          	addi	a0,a0,800 # 4698 <malloc+0x2fa>
     380:	00004097          	auipc	ra,0x4
     384:	c08080e7          	jalr	-1016(ra) # 3f88 <open>
  if(fd >= 0){
     388:	10054563          	bltz	a0,492 <writetest+0x140>
     38c:	892a                	mv	s2,a0
    printf("creat small succeeded; ok\n");
     38e:	00004517          	auipc	a0,0x4
     392:	31250513          	addi	a0,a0,786 # 46a0 <malloc+0x302>
     396:	00004097          	auipc	ra,0x4
     39a:	f4a080e7          	jalr	-182(ra) # 42e0 <printf>
  } else {
    printf("error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < N; i++){
     39e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3a0:	00004997          	auipc	s3,0x4
     3a4:	34098993          	addi	s3,s3,832 # 46e0 <malloc+0x342>
      printf("error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3a8:	00004a97          	auipc	s5,0x4
     3ac:	370a8a93          	addi	s5,s5,880 # 4718 <malloc+0x37a>
  for(i = 0; i < N; i++){
     3b0:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3b4:	4629                	li	a2,10
     3b6:	85ce                	mv	a1,s3
     3b8:	854a                	mv	a0,s2
     3ba:	00004097          	auipc	ra,0x4
     3be:	bae080e7          	jalr	-1106(ra) # 3f68 <write>
     3c2:	47a9                	li	a5,10
     3c4:	0ef51363          	bne	a0,a5,4aa <writetest+0x158>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3c8:	4629                	li	a2,10
     3ca:	85d6                	mv	a1,s5
     3cc:	854a                	mv	a0,s2
     3ce:	00004097          	auipc	ra,0x4
     3d2:	b9a080e7          	jalr	-1126(ra) # 3f68 <write>
     3d6:	47a9                	li	a5,10
     3d8:	0ef51663          	bne	a0,a5,4c4 <writetest+0x172>
  for(i = 0; i < N; i++){
     3dc:	2485                	addiw	s1,s1,1
     3de:	fd449be3          	bne	s1,s4,3b4 <writetest+0x62>
      printf("error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf("writes ok\n");
     3e2:	00004517          	auipc	a0,0x4
     3e6:	36e50513          	addi	a0,a0,878 # 4750 <malloc+0x3b2>
     3ea:	00004097          	auipc	ra,0x4
     3ee:	ef6080e7          	jalr	-266(ra) # 42e0 <printf>
  close(fd);
     3f2:	854a                	mv	a0,s2
     3f4:	00004097          	auipc	ra,0x4
     3f8:	b7c080e7          	jalr	-1156(ra) # 3f70 <close>
  fd = open("small", O_RDONLY);
     3fc:	4581                	li	a1,0
     3fe:	00004517          	auipc	a0,0x4
     402:	29a50513          	addi	a0,a0,666 # 4698 <malloc+0x2fa>
     406:	00004097          	auipc	ra,0x4
     40a:	b82080e7          	jalr	-1150(ra) # 3f88 <open>
     40e:	84aa                	mv	s1,a0
  if(fd >= 0){
     410:	0c054763          	bltz	a0,4de <writetest+0x18c>
    printf("open small succeeded ok\n");
     414:	00004517          	auipc	a0,0x4
     418:	34c50513          	addi	a0,a0,844 # 4760 <malloc+0x3c2>
     41c:	00004097          	auipc	ra,0x4
     420:	ec4080e7          	jalr	-316(ra) # 42e0 <printf>
  } else {
    printf("error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, N*SZ*2);
     424:	7d000613          	li	a2,2000
     428:	00008597          	auipc	a1,0x8
     42c:	64858593          	addi	a1,a1,1608 # 8a70 <buf>
     430:	8526                	mv	a0,s1
     432:	00004097          	auipc	ra,0x4
     436:	b2e080e7          	jalr	-1234(ra) # 3f60 <read>
  if(i == N*SZ*2){
     43a:	7d000793          	li	a5,2000
     43e:	0af51c63          	bne	a0,a5,4f6 <writetest+0x1a4>
    printf("read succeeded ok\n");
     442:	00004517          	auipc	a0,0x4
     446:	35e50513          	addi	a0,a0,862 # 47a0 <malloc+0x402>
     44a:	00004097          	auipc	ra,0x4
     44e:	e96080e7          	jalr	-362(ra) # 42e0 <printf>
  } else {
    printf("read failed\n");
    exit();
  }
  close(fd);
     452:	8526                	mv	a0,s1
     454:	00004097          	auipc	ra,0x4
     458:	b1c080e7          	jalr	-1252(ra) # 3f70 <close>

  if(unlink("small") < 0){
     45c:	00004517          	auipc	a0,0x4
     460:	23c50513          	addi	a0,a0,572 # 4698 <malloc+0x2fa>
     464:	00004097          	auipc	ra,0x4
     468:	b34080e7          	jalr	-1228(ra) # 3f98 <unlink>
     46c:	0a054163          	bltz	a0,50e <writetest+0x1bc>
    printf("unlink small failed\n");
    exit();
  }
  printf("small file test ok\n");
     470:	00004517          	auipc	a0,0x4
     474:	37050513          	addi	a0,a0,880 # 47e0 <malloc+0x442>
     478:	00004097          	auipc	ra,0x4
     47c:	e68080e7          	jalr	-408(ra) # 42e0 <printf>
}
     480:	70e2                	ld	ra,56(sp)
     482:	7442                	ld	s0,48(sp)
     484:	74a2                	ld	s1,40(sp)
     486:	7902                	ld	s2,32(sp)
     488:	69e2                	ld	s3,24(sp)
     48a:	6a42                	ld	s4,16(sp)
     48c:	6aa2                	ld	s5,8(sp)
     48e:	6121                	addi	sp,sp,64
     490:	8082                	ret
    printf("error: creat small failed!\n");
     492:	00004517          	auipc	a0,0x4
     496:	22e50513          	addi	a0,a0,558 # 46c0 <malloc+0x322>
     49a:	00004097          	auipc	ra,0x4
     49e:	e46080e7          	jalr	-442(ra) # 42e0 <printf>
    exit();
     4a2:	00004097          	auipc	ra,0x4
     4a6:	aa6080e7          	jalr	-1370(ra) # 3f48 <exit>
      printf("error: write aa %d new file failed\n", i);
     4aa:	85a6                	mv	a1,s1
     4ac:	00004517          	auipc	a0,0x4
     4b0:	24450513          	addi	a0,a0,580 # 46f0 <malloc+0x352>
     4b4:	00004097          	auipc	ra,0x4
     4b8:	e2c080e7          	jalr	-468(ra) # 42e0 <printf>
      exit();
     4bc:	00004097          	auipc	ra,0x4
     4c0:	a8c080e7          	jalr	-1396(ra) # 3f48 <exit>
      printf("error: write bb %d new file failed\n", i);
     4c4:	85a6                	mv	a1,s1
     4c6:	00004517          	auipc	a0,0x4
     4ca:	26250513          	addi	a0,a0,610 # 4728 <malloc+0x38a>
     4ce:	00004097          	auipc	ra,0x4
     4d2:	e12080e7          	jalr	-494(ra) # 42e0 <printf>
      exit();
     4d6:	00004097          	auipc	ra,0x4
     4da:	a72080e7          	jalr	-1422(ra) # 3f48 <exit>
    printf("error: open small failed!\n");
     4de:	00004517          	auipc	a0,0x4
     4e2:	2a250513          	addi	a0,a0,674 # 4780 <malloc+0x3e2>
     4e6:	00004097          	auipc	ra,0x4
     4ea:	dfa080e7          	jalr	-518(ra) # 42e0 <printf>
    exit();
     4ee:	00004097          	auipc	ra,0x4
     4f2:	a5a080e7          	jalr	-1446(ra) # 3f48 <exit>
    printf("read failed\n");
     4f6:	00004517          	auipc	a0,0x4
     4fa:	2c250513          	addi	a0,a0,706 # 47b8 <malloc+0x41a>
     4fe:	00004097          	auipc	ra,0x4
     502:	de2080e7          	jalr	-542(ra) # 42e0 <printf>
    exit();
     506:	00004097          	auipc	ra,0x4
     50a:	a42080e7          	jalr	-1470(ra) # 3f48 <exit>
    printf("unlink small failed\n");
     50e:	00004517          	auipc	a0,0x4
     512:	2ba50513          	addi	a0,a0,698 # 47c8 <malloc+0x42a>
     516:	00004097          	auipc	ra,0x4
     51a:	dca080e7          	jalr	-566(ra) # 42e0 <printf>
    exit();
     51e:	00004097          	auipc	ra,0x4
     522:	a2a080e7          	jalr	-1494(ra) # 3f48 <exit>

0000000000000526 <writetest1>:

void
writetest1(void)
{
     526:	7179                	addi	sp,sp,-48
     528:	f406                	sd	ra,40(sp)
     52a:	f022                	sd	s0,32(sp)
     52c:	ec26                	sd	s1,24(sp)
     52e:	e84a                	sd	s2,16(sp)
     530:	e44e                	sd	s3,8(sp)
     532:	e052                	sd	s4,0(sp)
     534:	1800                	addi	s0,sp,48
  int i, fd, n;

  printf("big files test\n");
     536:	00004517          	auipc	a0,0x4
     53a:	2c250513          	addi	a0,a0,706 # 47f8 <malloc+0x45a>
     53e:	00004097          	auipc	ra,0x4
     542:	da2080e7          	jalr	-606(ra) # 42e0 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     546:	20200593          	li	a1,514
     54a:	00004517          	auipc	a0,0x4
     54e:	2be50513          	addi	a0,a0,702 # 4808 <malloc+0x46a>
     552:	00004097          	auipc	ra,0x4
     556:	a36080e7          	jalr	-1482(ra) # 3f88 <open>
     55a:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     55c:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     55e:	00008917          	auipc	s2,0x8
     562:	51290913          	addi	s2,s2,1298 # 8a70 <buf>
  for(i = 0; i < MAXFILE; i++){
     566:	10c00a13          	li	s4,268
  if(fd < 0){
     56a:	06054c63          	bltz	a0,5e2 <writetest1+0xbc>
    ((int*)buf)[0] = i;
     56e:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     572:	40000613          	li	a2,1024
     576:	85ca                	mv	a1,s2
     578:	854e                	mv	a0,s3
     57a:	00004097          	auipc	ra,0x4
     57e:	9ee080e7          	jalr	-1554(ra) # 3f68 <write>
     582:	40000793          	li	a5,1024
     586:	06f51a63          	bne	a0,a5,5fa <writetest1+0xd4>
  for(i = 0; i < MAXFILE; i++){
     58a:	2485                	addiw	s1,s1,1
     58c:	ff4491e3          	bne	s1,s4,56e <writetest1+0x48>
      printf("error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     590:	854e                	mv	a0,s3
     592:	00004097          	auipc	ra,0x4
     596:	9de080e7          	jalr	-1570(ra) # 3f70 <close>

  fd = open("big", O_RDONLY);
     59a:	4581                	li	a1,0
     59c:	00004517          	auipc	a0,0x4
     5a0:	26c50513          	addi	a0,a0,620 # 4808 <malloc+0x46a>
     5a4:	00004097          	auipc	ra,0x4
     5a8:	9e4080e7          	jalr	-1564(ra) # 3f88 <open>
     5ac:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: open big failed!\n");
    exit();
  }

  n = 0;
     5ae:	4481                	li	s1,0
  for(;;){
    i = read(fd, buf, BSIZE);
     5b0:	00008917          	auipc	s2,0x8
     5b4:	4c090913          	addi	s2,s2,1216 # 8a70 <buf>
  if(fd < 0){
     5b8:	04054e63          	bltz	a0,614 <writetest1+0xee>
    i = read(fd, buf, BSIZE);
     5bc:	40000613          	li	a2,1024
     5c0:	85ca                	mv	a1,s2
     5c2:	854e                	mv	a0,s3
     5c4:	00004097          	auipc	ra,0x4
     5c8:	99c080e7          	jalr	-1636(ra) # 3f60 <read>
    if(i == 0){
     5cc:	c125                	beqz	a0,62c <writetest1+0x106>
      if(n == MAXFILE - 1){
        printf("read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != BSIZE){
     5ce:	40000793          	li	a5,1024
     5d2:	0af51e63          	bne	a0,a5,68e <writetest1+0x168>
      printf("read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     5d6:	00092603          	lw	a2,0(s2)
     5da:	0c961763          	bne	a2,s1,6a8 <writetest1+0x182>
      printf("read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5de:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     5e0:	bff1                	j	5bc <writetest1+0x96>
    printf("error: creat big failed!\n");
     5e2:	00004517          	auipc	a0,0x4
     5e6:	22e50513          	addi	a0,a0,558 # 4810 <malloc+0x472>
     5ea:	00004097          	auipc	ra,0x4
     5ee:	cf6080e7          	jalr	-778(ra) # 42e0 <printf>
    exit();
     5f2:	00004097          	auipc	ra,0x4
     5f6:	956080e7          	jalr	-1706(ra) # 3f48 <exit>
      printf("error: write big file failed\n", i);
     5fa:	85a6                	mv	a1,s1
     5fc:	00004517          	auipc	a0,0x4
     600:	23450513          	addi	a0,a0,564 # 4830 <malloc+0x492>
     604:	00004097          	auipc	ra,0x4
     608:	cdc080e7          	jalr	-804(ra) # 42e0 <printf>
      exit();
     60c:	00004097          	auipc	ra,0x4
     610:	93c080e7          	jalr	-1732(ra) # 3f48 <exit>
    printf("error: open big failed!\n");
     614:	00004517          	auipc	a0,0x4
     618:	23c50513          	addi	a0,a0,572 # 4850 <malloc+0x4b2>
     61c:	00004097          	auipc	ra,0x4
     620:	cc4080e7          	jalr	-828(ra) # 42e0 <printf>
    exit();
     624:	00004097          	auipc	ra,0x4
     628:	924080e7          	jalr	-1756(ra) # 3f48 <exit>
      if(n == MAXFILE - 1){
     62c:	10b00793          	li	a5,267
     630:	04f48163          	beq	s1,a5,672 <writetest1+0x14c>
  }
  close(fd);
     634:	854e                	mv	a0,s3
     636:	00004097          	auipc	ra,0x4
     63a:	93a080e7          	jalr	-1734(ra) # 3f70 <close>
  if(unlink("big") < 0){
     63e:	00004517          	auipc	a0,0x4
     642:	1ca50513          	addi	a0,a0,458 # 4808 <malloc+0x46a>
     646:	00004097          	auipc	ra,0x4
     64a:	952080e7          	jalr	-1710(ra) # 3f98 <unlink>
     64e:	06054a63          	bltz	a0,6c2 <writetest1+0x19c>
    printf("unlink big failed\n");
    exit();
  }
  printf("big files ok\n");
     652:	00004517          	auipc	a0,0x4
     656:	28650513          	addi	a0,a0,646 # 48d8 <malloc+0x53a>
     65a:	00004097          	auipc	ra,0x4
     65e:	c86080e7          	jalr	-890(ra) # 42e0 <printf>
}
     662:	70a2                	ld	ra,40(sp)
     664:	7402                	ld	s0,32(sp)
     666:	64e2                	ld	s1,24(sp)
     668:	6942                	ld	s2,16(sp)
     66a:	69a2                	ld	s3,8(sp)
     66c:	6a02                	ld	s4,0(sp)
     66e:	6145                	addi	sp,sp,48
     670:	8082                	ret
        printf("read only %d blocks from big", n);
     672:	10b00593          	li	a1,267
     676:	00004517          	auipc	a0,0x4
     67a:	1fa50513          	addi	a0,a0,506 # 4870 <malloc+0x4d2>
     67e:	00004097          	auipc	ra,0x4
     682:	c62080e7          	jalr	-926(ra) # 42e0 <printf>
        exit();
     686:	00004097          	auipc	ra,0x4
     68a:	8c2080e7          	jalr	-1854(ra) # 3f48 <exit>
      printf("read failed %d\n", i);
     68e:	85aa                	mv	a1,a0
     690:	00004517          	auipc	a0,0x4
     694:	20050513          	addi	a0,a0,512 # 4890 <malloc+0x4f2>
     698:	00004097          	auipc	ra,0x4
     69c:	c48080e7          	jalr	-952(ra) # 42e0 <printf>
      exit();
     6a0:	00004097          	auipc	ra,0x4
     6a4:	8a8080e7          	jalr	-1880(ra) # 3f48 <exit>
      printf("read content of block %d is %d\n",
     6a8:	85a6                	mv	a1,s1
     6aa:	00004517          	auipc	a0,0x4
     6ae:	1f650513          	addi	a0,a0,502 # 48a0 <malloc+0x502>
     6b2:	00004097          	auipc	ra,0x4
     6b6:	c2e080e7          	jalr	-978(ra) # 42e0 <printf>
      exit();
     6ba:	00004097          	auipc	ra,0x4
     6be:	88e080e7          	jalr	-1906(ra) # 3f48 <exit>
    printf("unlink big failed\n");
     6c2:	00004517          	auipc	a0,0x4
     6c6:	1fe50513          	addi	a0,a0,510 # 48c0 <malloc+0x522>
     6ca:	00004097          	auipc	ra,0x4
     6ce:	c16080e7          	jalr	-1002(ra) # 42e0 <printf>
    exit();
     6d2:	00004097          	auipc	ra,0x4
     6d6:	876080e7          	jalr	-1930(ra) # 3f48 <exit>

00000000000006da <createtest>:

void
createtest(void)
{
     6da:	7179                	addi	sp,sp,-48
     6dc:	f406                	sd	ra,40(sp)
     6de:	f022                	sd	s0,32(sp)
     6e0:	ec26                	sd	s1,24(sp)
     6e2:	e84a                	sd	s2,16(sp)
     6e4:	e44e                	sd	s3,8(sp)
     6e6:	1800                	addi	s0,sp,48
  int i, fd;
  enum { N=52 };
  
  printf("many creates, followed by unlink test\n");
     6e8:	00004517          	auipc	a0,0x4
     6ec:	20050513          	addi	a0,a0,512 # 48e8 <malloc+0x54a>
     6f0:	00004097          	auipc	ra,0x4
     6f4:	bf0080e7          	jalr	-1040(ra) # 42e0 <printf>

  name[0] = 'a';
     6f8:	00006797          	auipc	a5,0x6
     6fc:	b5878793          	addi	a5,a5,-1192 # 6250 <name>
     700:	06100713          	li	a4,97
     704:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     708:	00078123          	sb	zero,2(a5)
     70c:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     710:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     712:	06400993          	li	s3,100
    name[1] = '0' + i;
     716:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     71a:	20200593          	li	a1,514
     71e:	854a                	mv	a0,s2
     720:	00004097          	auipc	ra,0x4
     724:	868080e7          	jalr	-1944(ra) # 3f88 <open>
    close(fd);
     728:	00004097          	auipc	ra,0x4
     72c:	848080e7          	jalr	-1976(ra) # 3f70 <close>
  for(i = 0; i < N; i++){
     730:	2485                	addiw	s1,s1,1
     732:	0ff4f493          	andi	s1,s1,255
     736:	ff3490e3          	bne	s1,s3,716 <createtest+0x3c>
  }
  name[0] = 'a';
     73a:	00006797          	auipc	a5,0x6
     73e:	b1678793          	addi	a5,a5,-1258 # 6250 <name>
     742:	06100713          	li	a4,97
     746:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     74a:	00078123          	sb	zero,2(a5)
     74e:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     752:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     754:	06400993          	li	s3,100
    name[1] = '0' + i;
     758:	009900a3          	sb	s1,1(s2)
    unlink(name);
     75c:	854a                	mv	a0,s2
     75e:	00004097          	auipc	ra,0x4
     762:	83a080e7          	jalr	-1990(ra) # 3f98 <unlink>
  for(i = 0; i < N; i++){
     766:	2485                	addiw	s1,s1,1
     768:	0ff4f493          	andi	s1,s1,255
     76c:	ff3496e3          	bne	s1,s3,758 <createtest+0x7e>
  }
  printf("many creates, followed by unlink; ok\n");
     770:	00004517          	auipc	a0,0x4
     774:	1a050513          	addi	a0,a0,416 # 4910 <malloc+0x572>
     778:	00004097          	auipc	ra,0x4
     77c:	b68080e7          	jalr	-1176(ra) # 42e0 <printf>
}
     780:	70a2                	ld	ra,40(sp)
     782:	7402                	ld	s0,32(sp)
     784:	64e2                	ld	s1,24(sp)
     786:	6942                	ld	s2,16(sp)
     788:	69a2                	ld	s3,8(sp)
     78a:	6145                	addi	sp,sp,48
     78c:	8082                	ret

000000000000078e <dirtest>:

void dirtest(void)
{
     78e:	1141                	addi	sp,sp,-16
     790:	e406                	sd	ra,8(sp)
     792:	e022                	sd	s0,0(sp)
     794:	0800                	addi	s0,sp,16
  printf("mkdir test\n");
     796:	00004517          	auipc	a0,0x4
     79a:	1a250513          	addi	a0,a0,418 # 4938 <malloc+0x59a>
     79e:	00004097          	auipc	ra,0x4
     7a2:	b42080e7          	jalr	-1214(ra) # 42e0 <printf>

  if(mkdir("dir0") < 0){
     7a6:	00004517          	auipc	a0,0x4
     7aa:	1a250513          	addi	a0,a0,418 # 4948 <malloc+0x5aa>
     7ae:	00004097          	auipc	ra,0x4
     7b2:	802080e7          	jalr	-2046(ra) # 3fb0 <mkdir>
     7b6:	04054c63          	bltz	a0,80e <dirtest+0x80>
    printf("mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     7ba:	00004517          	auipc	a0,0x4
     7be:	18e50513          	addi	a0,a0,398 # 4948 <malloc+0x5aa>
     7c2:	00003097          	auipc	ra,0x3
     7c6:	7f6080e7          	jalr	2038(ra) # 3fb8 <chdir>
     7ca:	04054e63          	bltz	a0,826 <dirtest+0x98>
    printf("chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7ce:	00004517          	auipc	a0,0x4
     7d2:	19a50513          	addi	a0,a0,410 # 4968 <malloc+0x5ca>
     7d6:	00003097          	auipc	ra,0x3
     7da:	7e2080e7          	jalr	2018(ra) # 3fb8 <chdir>
     7de:	06054063          	bltz	a0,83e <dirtest+0xb0>
    printf("chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7e2:	00004517          	auipc	a0,0x4
     7e6:	16650513          	addi	a0,a0,358 # 4948 <malloc+0x5aa>
     7ea:	00003097          	auipc	ra,0x3
     7ee:	7ae080e7          	jalr	1966(ra) # 3f98 <unlink>
     7f2:	06054263          	bltz	a0,856 <dirtest+0xc8>
    printf("unlink dir0 failed\n");
    exit();
  }
  printf("mkdir test ok\n");
     7f6:	00004517          	auipc	a0,0x4
     7fa:	1aa50513          	addi	a0,a0,426 # 49a0 <malloc+0x602>
     7fe:	00004097          	auipc	ra,0x4
     802:	ae2080e7          	jalr	-1310(ra) # 42e0 <printf>
}
     806:	60a2                	ld	ra,8(sp)
     808:	6402                	ld	s0,0(sp)
     80a:	0141                	addi	sp,sp,16
     80c:	8082                	ret
    printf("mkdir failed\n");
     80e:	00004517          	auipc	a0,0x4
     812:	cb250513          	addi	a0,a0,-846 # 44c0 <malloc+0x122>
     816:	00004097          	auipc	ra,0x4
     81a:	aca080e7          	jalr	-1334(ra) # 42e0 <printf>
    exit();
     81e:	00003097          	auipc	ra,0x3
     822:	72a080e7          	jalr	1834(ra) # 3f48 <exit>
    printf("chdir dir0 failed\n");
     826:	00004517          	auipc	a0,0x4
     82a:	12a50513          	addi	a0,a0,298 # 4950 <malloc+0x5b2>
     82e:	00004097          	auipc	ra,0x4
     832:	ab2080e7          	jalr	-1358(ra) # 42e0 <printf>
    exit();
     836:	00003097          	auipc	ra,0x3
     83a:	712080e7          	jalr	1810(ra) # 3f48 <exit>
    printf("chdir .. failed\n");
     83e:	00004517          	auipc	a0,0x4
     842:	13250513          	addi	a0,a0,306 # 4970 <malloc+0x5d2>
     846:	00004097          	auipc	ra,0x4
     84a:	a9a080e7          	jalr	-1382(ra) # 42e0 <printf>
    exit();
     84e:	00003097          	auipc	ra,0x3
     852:	6fa080e7          	jalr	1786(ra) # 3f48 <exit>
    printf("unlink dir0 failed\n");
     856:	00004517          	auipc	a0,0x4
     85a:	13250513          	addi	a0,a0,306 # 4988 <malloc+0x5ea>
     85e:	00004097          	auipc	ra,0x4
     862:	a82080e7          	jalr	-1406(ra) # 42e0 <printf>
    exit();
     866:	00003097          	auipc	ra,0x3
     86a:	6e2080e7          	jalr	1762(ra) # 3f48 <exit>

000000000000086e <exectest>:

void
exectest(void)
{
     86e:	1141                	addi	sp,sp,-16
     870:	e406                	sd	ra,8(sp)
     872:	e022                	sd	s0,0(sp)
     874:	0800                	addi	s0,sp,16
  printf("exec test\n");
     876:	00004517          	auipc	a0,0x4
     87a:	13a50513          	addi	a0,a0,314 # 49b0 <malloc+0x612>
     87e:	00004097          	auipc	ra,0x4
     882:	a62080e7          	jalr	-1438(ra) # 42e0 <printf>
  if(exec("echo", echoargv) < 0){
     886:	00006597          	auipc	a1,0x6
     88a:	99a58593          	addi	a1,a1,-1638 # 6220 <echoargv>
     88e:	00004517          	auipc	a0,0x4
     892:	d9250513          	addi	a0,a0,-622 # 4620 <malloc+0x282>
     896:	00003097          	auipc	ra,0x3
     89a:	6ea080e7          	jalr	1770(ra) # 3f80 <exec>
     89e:	00054663          	bltz	a0,8aa <exectest+0x3c>
    printf("exec echo failed\n");
    exit();
  }
}
     8a2:	60a2                	ld	ra,8(sp)
     8a4:	6402                	ld	s0,0(sp)
     8a6:	0141                	addi	sp,sp,16
     8a8:	8082                	ret
    printf("exec echo failed\n");
     8aa:	00004517          	auipc	a0,0x4
     8ae:	11650513          	addi	a0,a0,278 # 49c0 <malloc+0x622>
     8b2:	00004097          	auipc	ra,0x4
     8b6:	a2e080e7          	jalr	-1490(ra) # 42e0 <printf>
    exit();
     8ba:	00003097          	auipc	ra,0x3
     8be:	68e080e7          	jalr	1678(ra) # 3f48 <exit>

00000000000008c2 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     8c2:	715d                	addi	sp,sp,-80
     8c4:	e486                	sd	ra,72(sp)
     8c6:	e0a2                	sd	s0,64(sp)
     8c8:	fc26                	sd	s1,56(sp)
     8ca:	f84a                	sd	s2,48(sp)
     8cc:	f44e                	sd	s3,40(sp)
     8ce:	f052                	sd	s4,32(sp)
     8d0:	ec56                	sd	s5,24(sp)
     8d2:	e85a                	sd	s6,16(sp)
     8d4:	0880                	addi	s0,sp,80
  int fds[2], pid;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };
  
  if(pipe(fds) != 0){
     8d6:	fb840513          	addi	a0,s0,-72
     8da:	00003097          	auipc	ra,0x3
     8de:	67e080e7          	jalr	1662(ra) # 3f58 <pipe>
     8e2:	ed25                	bnez	a0,95a <pipe1+0x98>
     8e4:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit();
  }
  pid = fork();
     8e6:	00003097          	auipc	ra,0x3
     8ea:	65a080e7          	jalr	1626(ra) # 3f40 <fork>
     8ee:	89aa                	mv	s3,a0
  seq = 0;
  if(pid == 0){
     8f0:	c149                	beqz	a0,972 <pipe1+0xb0>
        printf("pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8f2:	16a05763          	blez	a0,a60 <pipe1+0x19e>
    close(fds[1]);
     8f6:	fbc42503          	lw	a0,-68(s0)
     8fa:	00003097          	auipc	ra,0x3
     8fe:	676080e7          	jalr	1654(ra) # 3f70 <close>
    total = 0;
     902:	89a6                	mv	s3,s1
    cc = 1;
     904:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
     906:	00008a17          	auipc	s4,0x8
     90a:	16aa0a13          	addi	s4,s4,362 # 8a70 <buf>
          return;
        }
      }
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
     90e:	6a8d                	lui	s5,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     910:	864a                	mv	a2,s2
     912:	85d2                	mv	a1,s4
     914:	fb842503          	lw	a0,-72(s0)
     918:	00003097          	auipc	ra,0x3
     91c:	648080e7          	jalr	1608(ra) # 3f60 <read>
     920:	0ea05b63          	blez	a0,a16 <pipe1+0x154>
      for(i = 0; i < n; i++){
     924:	00008717          	auipc	a4,0x8
     928:	14c70713          	addi	a4,a4,332 # 8a70 <buf>
     92c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     930:	00074683          	lbu	a3,0(a4)
     934:	0ff4f793          	andi	a5,s1,255
     938:	2485                	addiw	s1,s1,1
     93a:	0af69c63          	bne	a3,a5,9f2 <pipe1+0x130>
      for(i = 0; i < n; i++){
     93e:	0705                	addi	a4,a4,1
     940:	fec498e3          	bne	s1,a2,930 <pipe1+0x6e>
      total += n;
     944:	00a989bb          	addw	s3,s3,a0
      cc = cc * 2;
     948:	0019179b          	slliw	a5,s2,0x1
     94c:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
     950:	012af363          	bgeu	s5,s2,956 <pipe1+0x94>
        cc = sizeof(buf);
     954:	8956                	mv	s2,s5
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     956:	84b2                	mv	s1,a2
     958:	bf65                	j	910 <pipe1+0x4e>
    printf("pipe() failed\n");
     95a:	00004517          	auipc	a0,0x4
     95e:	07e50513          	addi	a0,a0,126 # 49d8 <malloc+0x63a>
     962:	00004097          	auipc	ra,0x4
     966:	97e080e7          	jalr	-1666(ra) # 42e0 <printf>
    exit();
     96a:	00003097          	auipc	ra,0x3
     96e:	5de080e7          	jalr	1502(ra) # 3f48 <exit>
    close(fds[0]);
     972:	fb842503          	lw	a0,-72(s0)
     976:	00003097          	auipc	ra,0x3
     97a:	5fa080e7          	jalr	1530(ra) # 3f70 <close>
    for(n = 0; n < N; n++){
     97e:	00008a97          	auipc	s5,0x8
     982:	0f2a8a93          	addi	s5,s5,242 # 8a70 <buf>
     986:	415004bb          	negw	s1,s5
     98a:	0ff4f493          	andi	s1,s1,255
     98e:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
     992:	8b56                	mv	s6,s5
    for(n = 0; n < N; n++){
     994:	6a05                	lui	s4,0x1
     996:	42da0a13          	addi	s4,s4,1069 # 142d <fourfiles+0x1cd>
{
     99a:	87d6                	mv	a5,s5
        buf[i] = seq++;
     99c:	0097873b          	addw	a4,a5,s1
     9a0:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
     9a4:	0785                	addi	a5,a5,1
     9a6:	fef91be3          	bne	s2,a5,99c <pipe1+0xda>
     9aa:	4099899b          	addiw	s3,s3,1033
      if(write(fds[1], buf, SZ) != SZ){
     9ae:	40900613          	li	a2,1033
     9b2:	85da                	mv	a1,s6
     9b4:	fbc42503          	lw	a0,-68(s0)
     9b8:	00003097          	auipc	ra,0x3
     9bc:	5b0080e7          	jalr	1456(ra) # 3f68 <write>
     9c0:	40900793          	li	a5,1033
     9c4:	00f51b63          	bne	a0,a5,9da <pipe1+0x118>
    for(n = 0; n < N; n++){
     9c8:	24a5                	addiw	s1,s1,9
     9ca:	0ff4f493          	andi	s1,s1,255
     9ce:	fd4996e3          	bne	s3,s4,99a <pipe1+0xd8>
    exit();
     9d2:	00003097          	auipc	ra,0x3
     9d6:	576080e7          	jalr	1398(ra) # 3f48 <exit>
        printf("pipe1 oops 1\n");
     9da:	00004517          	auipc	a0,0x4
     9de:	00e50513          	addi	a0,a0,14 # 49e8 <malloc+0x64a>
     9e2:	00004097          	auipc	ra,0x4
     9e6:	8fe080e7          	jalr	-1794(ra) # 42e0 <printf>
        exit();
     9ea:	00003097          	auipc	ra,0x3
     9ee:	55e080e7          	jalr	1374(ra) # 3f48 <exit>
          printf("pipe1 oops 2\n");
     9f2:	00004517          	auipc	a0,0x4
     9f6:	00650513          	addi	a0,a0,6 # 49f8 <malloc+0x65a>
     9fa:	00004097          	auipc	ra,0x4
     9fe:	8e6080e7          	jalr	-1818(ra) # 42e0 <printf>
  } else {
    printf("fork() failed\n");
    exit();
  }
  printf("pipe1 ok\n");
}
     a02:	60a6                	ld	ra,72(sp)
     a04:	6406                	ld	s0,64(sp)
     a06:	74e2                	ld	s1,56(sp)
     a08:	7942                	ld	s2,48(sp)
     a0a:	79a2                	ld	s3,40(sp)
     a0c:	7a02                	ld	s4,32(sp)
     a0e:	6ae2                	ld	s5,24(sp)
     a10:	6b42                	ld	s6,16(sp)
     a12:	6161                	addi	sp,sp,80
     a14:	8082                	ret
    if(total != N * SZ){
     a16:	6785                	lui	a5,0x1
     a18:	42d78793          	addi	a5,a5,1069 # 142d <fourfiles+0x1cd>
     a1c:	02f99563          	bne	s3,a5,a46 <pipe1+0x184>
    close(fds[0]);
     a20:	fb842503          	lw	a0,-72(s0)
     a24:	00003097          	auipc	ra,0x3
     a28:	54c080e7          	jalr	1356(ra) # 3f70 <close>
    wait();
     a2c:	00003097          	auipc	ra,0x3
     a30:	524080e7          	jalr	1316(ra) # 3f50 <wait>
  printf("pipe1 ok\n");
     a34:	00004517          	auipc	a0,0x4
     a38:	fec50513          	addi	a0,a0,-20 # 4a20 <malloc+0x682>
     a3c:	00004097          	auipc	ra,0x4
     a40:	8a4080e7          	jalr	-1884(ra) # 42e0 <printf>
     a44:	bf7d                	j	a02 <pipe1+0x140>
      printf("pipe1 oops 3 total %d\n", total);
     a46:	85ce                	mv	a1,s3
     a48:	00004517          	auipc	a0,0x4
     a4c:	fc050513          	addi	a0,a0,-64 # 4a08 <malloc+0x66a>
     a50:	00004097          	auipc	ra,0x4
     a54:	890080e7          	jalr	-1904(ra) # 42e0 <printf>
      exit();
     a58:	00003097          	auipc	ra,0x3
     a5c:	4f0080e7          	jalr	1264(ra) # 3f48 <exit>
    printf("fork() failed\n");
     a60:	00004517          	auipc	a0,0x4
     a64:	fd050513          	addi	a0,a0,-48 # 4a30 <malloc+0x692>
     a68:	00004097          	auipc	ra,0x4
     a6c:	878080e7          	jalr	-1928(ra) # 42e0 <printf>
    exit();
     a70:	00003097          	auipc	ra,0x3
     a74:	4d8080e7          	jalr	1240(ra) # 3f48 <exit>

0000000000000a78 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a78:	7139                	addi	sp,sp,-64
     a7a:	fc06                	sd	ra,56(sp)
     a7c:	f822                	sd	s0,48(sp)
     a7e:	f426                	sd	s1,40(sp)
     a80:	f04a                	sd	s2,32(sp)
     a82:	ec4e                	sd	s3,24(sp)
     a84:	0080                	addi	s0,sp,64
  int pid1, pid2, pid3;
  int pfds[2];

  printf("preempt: ");
     a86:	00004517          	auipc	a0,0x4
     a8a:	fba50513          	addi	a0,a0,-70 # 4a40 <malloc+0x6a2>
     a8e:	00004097          	auipc	ra,0x4
     a92:	852080e7          	jalr	-1966(ra) # 42e0 <printf>
  pid1 = fork();
     a96:	00003097          	auipc	ra,0x3
     a9a:	4aa080e7          	jalr	1194(ra) # 3f40 <fork>
  if(pid1 < 0) {
     a9e:	00054563          	bltz	a0,aa8 <preempt+0x30>
     aa2:	89aa                	mv	s3,a0
    printf("fork failed");
    exit();
  }
  if(pid1 == 0)
     aa4:	ed11                	bnez	a0,ac0 <preempt+0x48>
    for(;;)
     aa6:	a001                	j	aa6 <preempt+0x2e>
    printf("fork failed");
     aa8:	00004517          	auipc	a0,0x4
     aac:	fa850513          	addi	a0,a0,-88 # 4a50 <malloc+0x6b2>
     ab0:	00004097          	auipc	ra,0x4
     ab4:	830080e7          	jalr	-2000(ra) # 42e0 <printf>
    exit();
     ab8:	00003097          	auipc	ra,0x3
     abc:	490080e7          	jalr	1168(ra) # 3f48 <exit>
      ;

  pid2 = fork();
     ac0:	00003097          	auipc	ra,0x3
     ac4:	480080e7          	jalr	1152(ra) # 3f40 <fork>
     ac8:	892a                	mv	s2,a0
  if(pid2 < 0) {
     aca:	00054463          	bltz	a0,ad2 <preempt+0x5a>
    printf("fork failed\n");
    exit();
  }
  if(pid2 == 0)
     ace:	ed11                	bnez	a0,aea <preempt+0x72>
    for(;;)
     ad0:	a001                	j	ad0 <preempt+0x58>
    printf("fork failed\n");
     ad2:	00004517          	auipc	a0,0x4
     ad6:	a7e50513          	addi	a0,a0,-1410 # 4550 <malloc+0x1b2>
     ada:	00004097          	auipc	ra,0x4
     ade:	806080e7          	jalr	-2042(ra) # 42e0 <printf>
    exit();
     ae2:	00003097          	auipc	ra,0x3
     ae6:	466080e7          	jalr	1126(ra) # 3f48 <exit>
      ;

  pipe(pfds);
     aea:	fc840513          	addi	a0,s0,-56
     aee:	00003097          	auipc	ra,0x3
     af2:	46a080e7          	jalr	1130(ra) # 3f58 <pipe>
  pid3 = fork();
     af6:	00003097          	auipc	ra,0x3
     afa:	44a080e7          	jalr	1098(ra) # 3f40 <fork>
     afe:	84aa                	mv	s1,a0
  if(pid3 < 0) {
     b00:	02054e63          	bltz	a0,b3c <preempt+0xc4>
     printf("fork failed\n");
     exit();
  }
  if(pid3 == 0){
     b04:	e12d                	bnez	a0,b66 <preempt+0xee>
    close(pfds[0]);
     b06:	fc842503          	lw	a0,-56(s0)
     b0a:	00003097          	auipc	ra,0x3
     b0e:	466080e7          	jalr	1126(ra) # 3f70 <close>
    if(write(pfds[1], "x", 1) != 1)
     b12:	4605                	li	a2,1
     b14:	00004597          	auipc	a1,0x4
     b18:	f4c58593          	addi	a1,a1,-180 # 4a60 <malloc+0x6c2>
     b1c:	fcc42503          	lw	a0,-52(s0)
     b20:	00003097          	auipc	ra,0x3
     b24:	448080e7          	jalr	1096(ra) # 3f68 <write>
     b28:	4785                	li	a5,1
     b2a:	02f51563          	bne	a0,a5,b54 <preempt+0xdc>
      printf("preempt write error");
    close(pfds[1]);
     b2e:	fcc42503          	lw	a0,-52(s0)
     b32:	00003097          	auipc	ra,0x3
     b36:	43e080e7          	jalr	1086(ra) # 3f70 <close>
    for(;;)
     b3a:	a001                	j	b3a <preempt+0xc2>
     printf("fork failed\n");
     b3c:	00004517          	auipc	a0,0x4
     b40:	a1450513          	addi	a0,a0,-1516 # 4550 <malloc+0x1b2>
     b44:	00003097          	auipc	ra,0x3
     b48:	79c080e7          	jalr	1948(ra) # 42e0 <printf>
     exit();
     b4c:	00003097          	auipc	ra,0x3
     b50:	3fc080e7          	jalr	1020(ra) # 3f48 <exit>
      printf("preempt write error");
     b54:	00004517          	auipc	a0,0x4
     b58:	f1450513          	addi	a0,a0,-236 # 4a68 <malloc+0x6ca>
     b5c:	00003097          	auipc	ra,0x3
     b60:	784080e7          	jalr	1924(ra) # 42e0 <printf>
     b64:	b7e9                	j	b2e <preempt+0xb6>
      ;
  }

  close(pfds[1]);
     b66:	fcc42503          	lw	a0,-52(s0)
     b6a:	00003097          	auipc	ra,0x3
     b6e:	406080e7          	jalr	1030(ra) # 3f70 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     b72:	660d                	lui	a2,0x3
     b74:	00008597          	auipc	a1,0x8
     b78:	efc58593          	addi	a1,a1,-260 # 8a70 <buf>
     b7c:	fc842503          	lw	a0,-56(s0)
     b80:	00003097          	auipc	ra,0x3
     b84:	3e0080e7          	jalr	992(ra) # 3f60 <read>
     b88:	4785                	li	a5,1
     b8a:	02f50163          	beq	a0,a5,bac <preempt+0x134>
    printf("preempt read error");
     b8e:	00004517          	auipc	a0,0x4
     b92:	ef250513          	addi	a0,a0,-270 # 4a80 <malloc+0x6e2>
     b96:	00003097          	auipc	ra,0x3
     b9a:	74a080e7          	jalr	1866(ra) # 42e0 <printf>
  printf("wait... ");
  wait();
  wait();
  wait();
  printf("preempt ok\n");
}
     b9e:	70e2                	ld	ra,56(sp)
     ba0:	7442                	ld	s0,48(sp)
     ba2:	74a2                	ld	s1,40(sp)
     ba4:	7902                	ld	s2,32(sp)
     ba6:	69e2                	ld	s3,24(sp)
     ba8:	6121                	addi	sp,sp,64
     baa:	8082                	ret
  close(pfds[0]);
     bac:	fc842503          	lw	a0,-56(s0)
     bb0:	00003097          	auipc	ra,0x3
     bb4:	3c0080e7          	jalr	960(ra) # 3f70 <close>
  printf("kill... ");
     bb8:	00004517          	auipc	a0,0x4
     bbc:	ee050513          	addi	a0,a0,-288 # 4a98 <malloc+0x6fa>
     bc0:	00003097          	auipc	ra,0x3
     bc4:	720080e7          	jalr	1824(ra) # 42e0 <printf>
  kill(pid1);
     bc8:	854e                	mv	a0,s3
     bca:	00003097          	auipc	ra,0x3
     bce:	3ae080e7          	jalr	942(ra) # 3f78 <kill>
  kill(pid2);
     bd2:	854a                	mv	a0,s2
     bd4:	00003097          	auipc	ra,0x3
     bd8:	3a4080e7          	jalr	932(ra) # 3f78 <kill>
  kill(pid3);
     bdc:	8526                	mv	a0,s1
     bde:	00003097          	auipc	ra,0x3
     be2:	39a080e7          	jalr	922(ra) # 3f78 <kill>
  printf("wait... ");
     be6:	00004517          	auipc	a0,0x4
     bea:	ec250513          	addi	a0,a0,-318 # 4aa8 <malloc+0x70a>
     bee:	00003097          	auipc	ra,0x3
     bf2:	6f2080e7          	jalr	1778(ra) # 42e0 <printf>
  wait();
     bf6:	00003097          	auipc	ra,0x3
     bfa:	35a080e7          	jalr	858(ra) # 3f50 <wait>
  wait();
     bfe:	00003097          	auipc	ra,0x3
     c02:	352080e7          	jalr	850(ra) # 3f50 <wait>
  wait();
     c06:	00003097          	auipc	ra,0x3
     c0a:	34a080e7          	jalr	842(ra) # 3f50 <wait>
  printf("preempt ok\n");
     c0e:	00004517          	auipc	a0,0x4
     c12:	eaa50513          	addi	a0,a0,-342 # 4ab8 <malloc+0x71a>
     c16:	00003097          	auipc	ra,0x3
     c1a:	6ca080e7          	jalr	1738(ra) # 42e0 <printf>
     c1e:	b741                	j	b9e <preempt+0x126>

0000000000000c20 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     c20:	1101                	addi	sp,sp,-32
     c22:	ec06                	sd	ra,24(sp)
     c24:	e822                	sd	s0,16(sp)
     c26:	e426                	sd	s1,8(sp)
     c28:	e04a                	sd	s2,0(sp)
     c2a:	1000                	addi	s0,sp,32
  int i, pid;

  printf("exitwait test\n");
     c2c:	00004517          	auipc	a0,0x4
     c30:	e9c50513          	addi	a0,a0,-356 # 4ac8 <malloc+0x72a>
     c34:	00003097          	auipc	ra,0x3
     c38:	6ac080e7          	jalr	1708(ra) # 42e0 <printf>
     c3c:	06400913          	li	s2,100

  for(i = 0; i < 100; i++){
    pid = fork();
     c40:	00003097          	auipc	ra,0x3
     c44:	300080e7          	jalr	768(ra) # 3f40 <fork>
     c48:	84aa                	mv	s1,a0
    if(pid < 0){
     c4a:	02054a63          	bltz	a0,c7e <exitwait+0x5e>
      printf("fork failed\n");
      exit();
    }
    if(pid){
     c4e:	c125                	beqz	a0,cae <exitwait+0x8e>
      if(wait() != pid){
     c50:	00003097          	auipc	ra,0x3
     c54:	300080e7          	jalr	768(ra) # 3f50 <wait>
     c58:	02951f63          	bne	a0,s1,c96 <exitwait+0x76>
  for(i = 0; i < 100; i++){
     c5c:	397d                	addiw	s2,s2,-1
     c5e:	fe0911e3          	bnez	s2,c40 <exitwait+0x20>
      }
    } else {
      exit();
    }
  }
  printf("exitwait ok\n");
     c62:	00004517          	auipc	a0,0x4
     c66:	e8650513          	addi	a0,a0,-378 # 4ae8 <malloc+0x74a>
     c6a:	00003097          	auipc	ra,0x3
     c6e:	676080e7          	jalr	1654(ra) # 42e0 <printf>
}
     c72:	60e2                	ld	ra,24(sp)
     c74:	6442                	ld	s0,16(sp)
     c76:	64a2                	ld	s1,8(sp)
     c78:	6902                	ld	s2,0(sp)
     c7a:	6105                	addi	sp,sp,32
     c7c:	8082                	ret
      printf("fork failed\n");
     c7e:	00004517          	auipc	a0,0x4
     c82:	8d250513          	addi	a0,a0,-1838 # 4550 <malloc+0x1b2>
     c86:	00003097          	auipc	ra,0x3
     c8a:	65a080e7          	jalr	1626(ra) # 42e0 <printf>
      exit();
     c8e:	00003097          	auipc	ra,0x3
     c92:	2ba080e7          	jalr	698(ra) # 3f48 <exit>
        printf("wait wrong pid\n");
     c96:	00004517          	auipc	a0,0x4
     c9a:	e4250513          	addi	a0,a0,-446 # 4ad8 <malloc+0x73a>
     c9e:	00003097          	auipc	ra,0x3
     ca2:	642080e7          	jalr	1602(ra) # 42e0 <printf>
        exit();
     ca6:	00003097          	auipc	ra,0x3
     caa:	2a2080e7          	jalr	674(ra) # 3f48 <exit>
      exit();
     cae:	00003097          	auipc	ra,0x3
     cb2:	29a080e7          	jalr	666(ra) # 3f48 <exit>

0000000000000cb6 <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(void)
{
     cb6:	7179                	addi	sp,sp,-48
     cb8:	f406                	sd	ra,40(sp)
     cba:	f022                	sd	s0,32(sp)
     cbc:	ec26                	sd	s1,24(sp)
     cbe:	e84a                	sd	s2,16(sp)
     cc0:	e44e                	sd	s3,8(sp)
     cc2:	1800                	addi	s0,sp,48
  int master_pid = getpid();
     cc4:	00003097          	auipc	ra,0x3
     cc8:	304080e7          	jalr	772(ra) # 3fc8 <getpid>
     ccc:	89aa                	mv	s3,a0
  
  printf("reparent test\n");
     cce:	00004517          	auipc	a0,0x4
     cd2:	e2a50513          	addi	a0,a0,-470 # 4af8 <malloc+0x75a>
     cd6:	00003097          	auipc	ra,0x3
     cda:	60a080e7          	jalr	1546(ra) # 42e0 <printf>
     cde:	0c800913          	li	s2,200

  for(int i = 0; i < 200; i++){
    int pid = fork();
     ce2:	00003097          	auipc	ra,0x3
     ce6:	25e080e7          	jalr	606(ra) # 3f40 <fork>
     cea:	84aa                	mv	s1,a0
    if(pid < 0){
     cec:	02054b63          	bltz	a0,d22 <reparent+0x6c>
      printf("fork failed\n");
      exit();
    }
    if(pid){
     cf0:	c12d                	beqz	a0,d52 <reparent+0x9c>
      if(wait() != pid){
     cf2:	00003097          	auipc	ra,0x3
     cf6:	25e080e7          	jalr	606(ra) # 3f50 <wait>
     cfa:	04951063          	bne	a0,s1,d3a <reparent+0x84>
  for(int i = 0; i < 200; i++){
     cfe:	397d                	addiw	s2,s2,-1
     d00:	fe0911e3          	bnez	s2,ce2 <reparent+0x2c>
      } else {
        exit();
      }
    }
  }
  printf("reparent ok\n");
     d04:	00004517          	auipc	a0,0x4
     d08:	e0450513          	addi	a0,a0,-508 # 4b08 <malloc+0x76a>
     d0c:	00003097          	auipc	ra,0x3
     d10:	5d4080e7          	jalr	1492(ra) # 42e0 <printf>
}
     d14:	70a2                	ld	ra,40(sp)
     d16:	7402                	ld	s0,32(sp)
     d18:	64e2                	ld	s1,24(sp)
     d1a:	6942                	ld	s2,16(sp)
     d1c:	69a2                	ld	s3,8(sp)
     d1e:	6145                	addi	sp,sp,48
     d20:	8082                	ret
      printf("fork failed\n");
     d22:	00004517          	auipc	a0,0x4
     d26:	82e50513          	addi	a0,a0,-2002 # 4550 <malloc+0x1b2>
     d2a:	00003097          	auipc	ra,0x3
     d2e:	5b6080e7          	jalr	1462(ra) # 42e0 <printf>
      exit();
     d32:	00003097          	auipc	ra,0x3
     d36:	216080e7          	jalr	534(ra) # 3f48 <exit>
        printf("wait wrong pid\n");
     d3a:	00004517          	auipc	a0,0x4
     d3e:	d9e50513          	addi	a0,a0,-610 # 4ad8 <malloc+0x73a>
     d42:	00003097          	auipc	ra,0x3
     d46:	59e080e7          	jalr	1438(ra) # 42e0 <printf>
        exit();
     d4a:	00003097          	auipc	ra,0x3
     d4e:	1fe080e7          	jalr	510(ra) # 3f48 <exit>
      int pid2 = fork();
     d52:	00003097          	auipc	ra,0x3
     d56:	1ee080e7          	jalr	494(ra) # 3f40 <fork>
      if(pid2 < 0){
     d5a:	00054763          	bltz	a0,d68 <reparent+0xb2>
      if(pid2 == 0){
     d5e:	e515                	bnez	a0,d8a <reparent+0xd4>
        exit();
     d60:	00003097          	auipc	ra,0x3
     d64:	1e8080e7          	jalr	488(ra) # 3f48 <exit>
        printf("fork failed\n");
     d68:	00003517          	auipc	a0,0x3
     d6c:	7e850513          	addi	a0,a0,2024 # 4550 <malloc+0x1b2>
     d70:	00003097          	auipc	ra,0x3
     d74:	570080e7          	jalr	1392(ra) # 42e0 <printf>
        kill(master_pid);
     d78:	854e                	mv	a0,s3
     d7a:	00003097          	auipc	ra,0x3
     d7e:	1fe080e7          	jalr	510(ra) # 3f78 <kill>
        exit();
     d82:	00003097          	auipc	ra,0x3
     d86:	1c6080e7          	jalr	454(ra) # 3f48 <exit>
        exit();
     d8a:	00003097          	auipc	ra,0x3
     d8e:	1be080e7          	jalr	446(ra) # 3f48 <exit>

0000000000000d92 <twochildren>:

// what if two children exit() at the same time?
void
twochildren(void)
{
     d92:	1101                	addi	sp,sp,-32
     d94:	ec06                	sd	ra,24(sp)
     d96:	e822                	sd	s0,16(sp)
     d98:	e426                	sd	s1,8(sp)
     d9a:	1000                	addi	s0,sp,32
  printf("twochildren test\n");
     d9c:	00004517          	auipc	a0,0x4
     da0:	d7c50513          	addi	a0,a0,-644 # 4b18 <malloc+0x77a>
     da4:	00003097          	auipc	ra,0x3
     da8:	53c080e7          	jalr	1340(ra) # 42e0 <printf>
     dac:	3e800493          	li	s1,1000

  for(int i = 0; i < 1000; i++){
    int pid1 = fork();
     db0:	00003097          	auipc	ra,0x3
     db4:	190080e7          	jalr	400(ra) # 3f40 <fork>
    if(pid1 < 0){
     db8:	04054163          	bltz	a0,dfa <twochildren+0x68>
      printf("fork failed\n");
      exit();
    }
    if(pid1 == 0){
     dbc:	c939                	beqz	a0,e12 <twochildren+0x80>
      exit();
    } else {
      int pid2 = fork();
     dbe:	00003097          	auipc	ra,0x3
     dc2:	182080e7          	jalr	386(ra) # 3f40 <fork>
      if(pid2 < 0){
     dc6:	04054a63          	bltz	a0,e1a <twochildren+0x88>
        printf("fork failed\n");
        exit();
      }
      if(pid2 == 0){
     dca:	c525                	beqz	a0,e32 <twochildren+0xa0>
        exit();
      } else {
        wait();
     dcc:	00003097          	auipc	ra,0x3
     dd0:	184080e7          	jalr	388(ra) # 3f50 <wait>
        wait();
     dd4:	00003097          	auipc	ra,0x3
     dd8:	17c080e7          	jalr	380(ra) # 3f50 <wait>
  for(int i = 0; i < 1000; i++){
     ddc:	34fd                	addiw	s1,s1,-1
     dde:	f8e9                	bnez	s1,db0 <twochildren+0x1e>
      }
    }
  }
  printf("twochildren ok\n");
     de0:	00004517          	auipc	a0,0x4
     de4:	d5050513          	addi	a0,a0,-688 # 4b30 <malloc+0x792>
     de8:	00003097          	auipc	ra,0x3
     dec:	4f8080e7          	jalr	1272(ra) # 42e0 <printf>
}
     df0:	60e2                	ld	ra,24(sp)
     df2:	6442                	ld	s0,16(sp)
     df4:	64a2                	ld	s1,8(sp)
     df6:	6105                	addi	sp,sp,32
     df8:	8082                	ret
      printf("fork failed\n");
     dfa:	00003517          	auipc	a0,0x3
     dfe:	75650513          	addi	a0,a0,1878 # 4550 <malloc+0x1b2>
     e02:	00003097          	auipc	ra,0x3
     e06:	4de080e7          	jalr	1246(ra) # 42e0 <printf>
      exit();
     e0a:	00003097          	auipc	ra,0x3
     e0e:	13e080e7          	jalr	318(ra) # 3f48 <exit>
      exit();
     e12:	00003097          	auipc	ra,0x3
     e16:	136080e7          	jalr	310(ra) # 3f48 <exit>
        printf("fork failed\n");
     e1a:	00003517          	auipc	a0,0x3
     e1e:	73650513          	addi	a0,a0,1846 # 4550 <malloc+0x1b2>
     e22:	00003097          	auipc	ra,0x3
     e26:	4be080e7          	jalr	1214(ra) # 42e0 <printf>
        exit();
     e2a:	00003097          	auipc	ra,0x3
     e2e:	11e080e7          	jalr	286(ra) # 3f48 <exit>
        exit();
     e32:	00003097          	auipc	ra,0x3
     e36:	116080e7          	jalr	278(ra) # 3f48 <exit>

0000000000000e3a <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(void)
{
     e3a:	1101                	addi	sp,sp,-32
     e3c:	ec06                	sd	ra,24(sp)
     e3e:	e822                	sd	s0,16(sp)
     e40:	e426                	sd	s1,8(sp)
     e42:	e04a                	sd	s2,0(sp)
     e44:	1000                	addi	s0,sp,32
  int ppid = getpid();
     e46:	00003097          	auipc	ra,0x3
     e4a:	182080e7          	jalr	386(ra) # 3fc8 <getpid>
     e4e:	892a                	mv	s2,a0
  enum { N=2 };
  
  printf("forkfork test\n");
     e50:	00004517          	auipc	a0,0x4
     e54:	cf050513          	addi	a0,a0,-784 # 4b40 <malloc+0x7a2>
     e58:	00003097          	auipc	ra,0x3
     e5c:	488080e7          	jalr	1160(ra) # 42e0 <printf>

  for(int i = 0; i < N; i++){
    int pid = fork();
     e60:	00003097          	auipc	ra,0x3
     e64:	0e0080e7          	jalr	224(ra) # 3f40 <fork>
    if(pid < 0){
     e68:	04054063          	bltz	a0,ea8 <forkfork+0x6e>
      printf("fork failed");
      exit();
    }
    if(pid == 0){
     e6c:	c931                	beqz	a0,ec0 <forkfork+0x86>
    int pid = fork();
     e6e:	00003097          	auipc	ra,0x3
     e72:	0d2080e7          	jalr	210(ra) # 3f40 <fork>
    if(pid < 0){
     e76:	02054963          	bltz	a0,ea8 <forkfork+0x6e>
    if(pid == 0){
     e7a:	c139                	beqz	a0,ec0 <forkfork+0x86>
      exit();
    }
  }

  for(int i = 0; i < N; i++){
    wait();
     e7c:	00003097          	auipc	ra,0x3
     e80:	0d4080e7          	jalr	212(ra) # 3f50 <wait>
     e84:	00003097          	auipc	ra,0x3
     e88:	0cc080e7          	jalr	204(ra) # 3f50 <wait>
  }

  printf("forkfork ok\n");
     e8c:	00004517          	auipc	a0,0x4
     e90:	cc450513          	addi	a0,a0,-828 # 4b50 <malloc+0x7b2>
     e94:	00003097          	auipc	ra,0x3
     e98:	44c080e7          	jalr	1100(ra) # 42e0 <printf>
}
     e9c:	60e2                	ld	ra,24(sp)
     e9e:	6442                	ld	s0,16(sp)
     ea0:	64a2                	ld	s1,8(sp)
     ea2:	6902                	ld	s2,0(sp)
     ea4:	6105                	addi	sp,sp,32
     ea6:	8082                	ret
      printf("fork failed");
     ea8:	00004517          	auipc	a0,0x4
     eac:	ba850513          	addi	a0,a0,-1112 # 4a50 <malloc+0x6b2>
     eb0:	00003097          	auipc	ra,0x3
     eb4:	430080e7          	jalr	1072(ra) # 42e0 <printf>
      exit();
     eb8:	00003097          	auipc	ra,0x3
     ebc:	090080e7          	jalr	144(ra) # 3f48 <exit>
{
     ec0:	0c800493          	li	s1,200
        int pid1 = fork();
     ec4:	00003097          	auipc	ra,0x3
     ec8:	07c080e7          	jalr	124(ra) # 3f40 <fork>
        if(pid1 < 0){
     ecc:	00054d63          	bltz	a0,ee6 <forkfork+0xac>
        if(pid1 == 0){
     ed0:	cd05                	beqz	a0,f08 <forkfork+0xce>
        wait();
     ed2:	00003097          	auipc	ra,0x3
     ed6:	07e080e7          	jalr	126(ra) # 3f50 <wait>
      for(int j = 0; j < 200; j++){
     eda:	34fd                	addiw	s1,s1,-1
     edc:	f4e5                	bnez	s1,ec4 <forkfork+0x8a>
      exit();
     ede:	00003097          	auipc	ra,0x3
     ee2:	06a080e7          	jalr	106(ra) # 3f48 <exit>
          printf("fork failed\n");
     ee6:	00003517          	auipc	a0,0x3
     eea:	66a50513          	addi	a0,a0,1642 # 4550 <malloc+0x1b2>
     eee:	00003097          	auipc	ra,0x3
     ef2:	3f2080e7          	jalr	1010(ra) # 42e0 <printf>
          kill(ppid);
     ef6:	854a                	mv	a0,s2
     ef8:	00003097          	auipc	ra,0x3
     efc:	080080e7          	jalr	128(ra) # 3f78 <kill>
          exit();
     f00:	00003097          	auipc	ra,0x3
     f04:	048080e7          	jalr	72(ra) # 3f48 <exit>
          exit();
     f08:	00003097          	auipc	ra,0x3
     f0c:	040080e7          	jalr	64(ra) # 3f48 <exit>

0000000000000f10 <forkforkfork>:

void
forkforkfork(void)
{
     f10:	1101                	addi	sp,sp,-32
     f12:	ec06                	sd	ra,24(sp)
     f14:	e822                	sd	s0,16(sp)
     f16:	e426                	sd	s1,8(sp)
     f18:	1000                	addi	s0,sp,32
  printf("forkforkfork test\n");
     f1a:	00004517          	auipc	a0,0x4
     f1e:	c4650513          	addi	a0,a0,-954 # 4b60 <malloc+0x7c2>
     f22:	00003097          	auipc	ra,0x3
     f26:	3be080e7          	jalr	958(ra) # 42e0 <printf>

  unlink("stopforking");
     f2a:	00004517          	auipc	a0,0x4
     f2e:	c4e50513          	addi	a0,a0,-946 # 4b78 <malloc+0x7da>
     f32:	00003097          	auipc	ra,0x3
     f36:	066080e7          	jalr	102(ra) # 3f98 <unlink>

  int pid = fork();
     f3a:	00003097          	auipc	ra,0x3
     f3e:	006080e7          	jalr	6(ra) # 3f40 <fork>
  if(pid < 0){
     f42:	04054c63          	bltz	a0,f9a <forkforkfork+0x8a>
    printf("fork failed");
    exit();
  }
  if(pid == 0){
     f46:	c535                	beqz	a0,fb2 <forkforkfork+0xa2>
    }

    exit();
  }

  sleep(20); // two seconds
     f48:	4551                	li	a0,20
     f4a:	00003097          	auipc	ra,0x3
     f4e:	08e080e7          	jalr	142(ra) # 3fd8 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     f52:	20200593          	li	a1,514
     f56:	00004517          	auipc	a0,0x4
     f5a:	c2250513          	addi	a0,a0,-990 # 4b78 <malloc+0x7da>
     f5e:	00003097          	auipc	ra,0x3
     f62:	02a080e7          	jalr	42(ra) # 3f88 <open>
     f66:	00003097          	auipc	ra,0x3
     f6a:	00a080e7          	jalr	10(ra) # 3f70 <close>
  wait();
     f6e:	00003097          	auipc	ra,0x3
     f72:	fe2080e7          	jalr	-30(ra) # 3f50 <wait>
  sleep(10); // one second
     f76:	4529                	li	a0,10
     f78:	00003097          	auipc	ra,0x3
     f7c:	060080e7          	jalr	96(ra) # 3fd8 <sleep>

  printf("forkforkfork ok\n");
     f80:	00004517          	auipc	a0,0x4
     f84:	c0850513          	addi	a0,a0,-1016 # 4b88 <malloc+0x7ea>
     f88:	00003097          	auipc	ra,0x3
     f8c:	358080e7          	jalr	856(ra) # 42e0 <printf>
}
     f90:	60e2                	ld	ra,24(sp)
     f92:	6442                	ld	s0,16(sp)
     f94:	64a2                	ld	s1,8(sp)
     f96:	6105                	addi	sp,sp,32
     f98:	8082                	ret
    printf("fork failed");
     f9a:	00004517          	auipc	a0,0x4
     f9e:	ab650513          	addi	a0,a0,-1354 # 4a50 <malloc+0x6b2>
     fa2:	00003097          	auipc	ra,0x3
     fa6:	33e080e7          	jalr	830(ra) # 42e0 <printf>
    exit();
     faa:	00003097          	auipc	ra,0x3
     fae:	f9e080e7          	jalr	-98(ra) # 3f48 <exit>
      int fd = open("stopforking", 0);
     fb2:	00004497          	auipc	s1,0x4
     fb6:	bc648493          	addi	s1,s1,-1082 # 4b78 <malloc+0x7da>
     fba:	4581                	li	a1,0
     fbc:	8526                	mv	a0,s1
     fbe:	00003097          	auipc	ra,0x3
     fc2:	fca080e7          	jalr	-54(ra) # 3f88 <open>
      if(fd >= 0){
     fc6:	02055463          	bgez	a0,fee <forkforkfork+0xde>
      if(fork() < 0){
     fca:	00003097          	auipc	ra,0x3
     fce:	f76080e7          	jalr	-138(ra) # 3f40 <fork>
     fd2:	fe0554e3          	bgez	a0,fba <forkforkfork+0xaa>
        close(open("stopforking", O_CREATE|O_RDWR));
     fd6:	20200593          	li	a1,514
     fda:	8526                	mv	a0,s1
     fdc:	00003097          	auipc	ra,0x3
     fe0:	fac080e7          	jalr	-84(ra) # 3f88 <open>
     fe4:	00003097          	auipc	ra,0x3
     fe8:	f8c080e7          	jalr	-116(ra) # 3f70 <close>
     fec:	b7f9                	j	fba <forkforkfork+0xaa>
        exit();
     fee:	00003097          	auipc	ra,0x3
     ff2:	f5a080e7          	jalr	-166(ra) # 3f48 <exit>

0000000000000ff6 <mem>:

void
mem(void)
{
     ff6:	7179                	addi	sp,sp,-48
     ff8:	f406                	sd	ra,40(sp)
     ffa:	f022                	sd	s0,32(sp)
     ffc:	ec26                	sd	s1,24(sp)
     ffe:	e84a                	sd	s2,16(sp)
    1000:	e44e                	sd	s3,8(sp)
    1002:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid, ppid;

  printf("mem test\n");
    1004:	00004517          	auipc	a0,0x4
    1008:	b9c50513          	addi	a0,a0,-1124 # 4ba0 <malloc+0x802>
    100c:	00003097          	auipc	ra,0x3
    1010:	2d4080e7          	jalr	724(ra) # 42e0 <printf>
  ppid = getpid();
    1014:	00003097          	auipc	ra,0x3
    1018:	fb4080e7          	jalr	-76(ra) # 3fc8 <getpid>
    101c:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    101e:	00003097          	auipc	ra,0x3
    1022:	f22080e7          	jalr	-222(ra) # 3f40 <fork>
    m1 = 0;
    1026:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    1028:	6909                	lui	s2,0x2
    102a:	71190913          	addi	s2,s2,1809 # 2711 <subdir+0x6cd>
  if((pid = fork()) == 0){
    102e:	e92d                	bnez	a0,10a0 <mem+0xaa>
    while((m2 = malloc(10001)) != 0){
    1030:	854a                	mv	a0,s2
    1032:	00003097          	auipc	ra,0x3
    1036:	36c080e7          	jalr	876(ra) # 439e <malloc>
    103a:	c501                	beqz	a0,1042 <mem+0x4c>
      *(char**)m2 = m1;
    103c:	e104                	sd	s1,0(a0)
      m1 = m2;
    103e:	84aa                	mv	s1,a0
    1040:	bfc5                	j	1030 <mem+0x3a>
    }
    while(m1){
    1042:	c881                	beqz	s1,1052 <mem+0x5c>
      m2 = *(char**)m1;
    1044:	8526                	mv	a0,s1
    1046:	6084                	ld	s1,0(s1)
      free(m1);
    1048:	00003097          	auipc	ra,0x3
    104c:	2ce080e7          	jalr	718(ra) # 4316 <free>
    while(m1){
    1050:	f8f5                	bnez	s1,1044 <mem+0x4e>
      m1 = m2;
    }
    m1 = malloc(1024*20);
    1052:	6515                	lui	a0,0x5
    1054:	00003097          	auipc	ra,0x3
    1058:	34a080e7          	jalr	842(ra) # 439e <malloc>
    if(m1 == 0){
    105c:	c10d                	beqz	a0,107e <mem+0x88>
      printf("couldn't allocate mem?!!\n");
      kill(ppid);
      exit();
    }
    free(m1);
    105e:	00003097          	auipc	ra,0x3
    1062:	2b8080e7          	jalr	696(ra) # 4316 <free>
    printf("mem ok\n");
    1066:	00004517          	auipc	a0,0x4
    106a:	b6a50513          	addi	a0,a0,-1174 # 4bd0 <malloc+0x832>
    106e:	00003097          	auipc	ra,0x3
    1072:	272080e7          	jalr	626(ra) # 42e0 <printf>
    exit();
    1076:	00003097          	auipc	ra,0x3
    107a:	ed2080e7          	jalr	-302(ra) # 3f48 <exit>
      printf("couldn't allocate mem?!!\n");
    107e:	00004517          	auipc	a0,0x4
    1082:	b3250513          	addi	a0,a0,-1230 # 4bb0 <malloc+0x812>
    1086:	00003097          	auipc	ra,0x3
    108a:	25a080e7          	jalr	602(ra) # 42e0 <printf>
      kill(ppid);
    108e:	854e                	mv	a0,s3
    1090:	00003097          	auipc	ra,0x3
    1094:	ee8080e7          	jalr	-280(ra) # 3f78 <kill>
      exit();
    1098:	00003097          	auipc	ra,0x3
    109c:	eb0080e7          	jalr	-336(ra) # 3f48 <exit>
  } else {
    wait();
    10a0:	00003097          	auipc	ra,0x3
    10a4:	eb0080e7          	jalr	-336(ra) # 3f50 <wait>
  }
}
    10a8:	70a2                	ld	ra,40(sp)
    10aa:	7402                	ld	s0,32(sp)
    10ac:	64e2                	ld	s1,24(sp)
    10ae:	6942                	ld	s2,16(sp)
    10b0:	69a2                	ld	s3,8(sp)
    10b2:	6145                	addi	sp,sp,48
    10b4:	8082                	ret

00000000000010b6 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    10b6:	715d                	addi	sp,sp,-80
    10b8:	e486                	sd	ra,72(sp)
    10ba:	e0a2                	sd	s0,64(sp)
    10bc:	fc26                	sd	s1,56(sp)
    10be:	f84a                	sd	s2,48(sp)
    10c0:	f44e                	sd	s3,40(sp)
    10c2:	f052                	sd	s4,32(sp)
    10c4:	ec56                	sd	s5,24(sp)
    10c6:	e85a                	sd	s6,16(sp)
    10c8:	0880                	addi	s0,sp,80
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  printf("sharedfd test\n");
    10ca:	00004517          	auipc	a0,0x4
    10ce:	b0e50513          	addi	a0,a0,-1266 # 4bd8 <malloc+0x83a>
    10d2:	00003097          	auipc	ra,0x3
    10d6:	20e080e7          	jalr	526(ra) # 42e0 <printf>

  unlink("sharedfd");
    10da:	00004517          	auipc	a0,0x4
    10de:	b0e50513          	addi	a0,a0,-1266 # 4be8 <malloc+0x84a>
    10e2:	00003097          	auipc	ra,0x3
    10e6:	eb6080e7          	jalr	-330(ra) # 3f98 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    10ea:	20200593          	li	a1,514
    10ee:	00004517          	auipc	a0,0x4
    10f2:	afa50513          	addi	a0,a0,-1286 # 4be8 <malloc+0x84a>
    10f6:	00003097          	auipc	ra,0x3
    10fa:	e92080e7          	jalr	-366(ra) # 3f88 <open>
  if(fd < 0){
    10fe:	04054463          	bltz	a0,1146 <sharedfd+0x90>
    1102:	892a                	mv	s2,a0
    printf("fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    1104:	00003097          	auipc	ra,0x3
    1108:	e3c080e7          	jalr	-452(ra) # 3f40 <fork>
    110c:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    110e:	06300593          	li	a1,99
    1112:	c119                	beqz	a0,1118 <sharedfd+0x62>
    1114:	07000593          	li	a1,112
    1118:	4629                	li	a2,10
    111a:	fb040513          	addi	a0,s0,-80
    111e:	00003097          	auipc	ra,0x3
    1122:	ca6080e7          	jalr	-858(ra) # 3dc4 <memset>
    1126:	3e800493          	li	s1,1000
  for(i = 0; i < N; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    112a:	4629                	li	a2,10
    112c:	fb040593          	addi	a1,s0,-80
    1130:	854a                	mv	a0,s2
    1132:	00003097          	auipc	ra,0x3
    1136:	e36080e7          	jalr	-458(ra) # 3f68 <write>
    113a:	47a9                	li	a5,10
    113c:	00f51e63          	bne	a0,a5,1158 <sharedfd+0xa2>
  for(i = 0; i < N; i++){
    1140:	34fd                	addiw	s1,s1,-1
    1142:	f4e5                	bnez	s1,112a <sharedfd+0x74>
    1144:	a015                	j	1168 <sharedfd+0xb2>
    printf("fstests: cannot open sharedfd for writing");
    1146:	00004517          	auipc	a0,0x4
    114a:	ab250513          	addi	a0,a0,-1358 # 4bf8 <malloc+0x85a>
    114e:	00003097          	auipc	ra,0x3
    1152:	192080e7          	jalr	402(ra) # 42e0 <printf>
    return;
    1156:	a8e9                	j	1230 <sharedfd+0x17a>
      printf("fstests: write sharedfd failed\n");
    1158:	00004517          	auipc	a0,0x4
    115c:	ad050513          	addi	a0,a0,-1328 # 4c28 <malloc+0x88a>
    1160:	00003097          	auipc	ra,0x3
    1164:	180080e7          	jalr	384(ra) # 42e0 <printf>
      break;
    }
  }
  if(pid == 0)
    1168:	04098c63          	beqz	s3,11c0 <sharedfd+0x10a>
    exit();
  else
    wait();
    116c:	00003097          	auipc	ra,0x3
    1170:	de4080e7          	jalr	-540(ra) # 3f50 <wait>
  close(fd);
    1174:	854a                	mv	a0,s2
    1176:	00003097          	auipc	ra,0x3
    117a:	dfa080e7          	jalr	-518(ra) # 3f70 <close>
  fd = open("sharedfd", 0);
    117e:	4581                	li	a1,0
    1180:	00004517          	auipc	a0,0x4
    1184:	a6850513          	addi	a0,a0,-1432 # 4be8 <malloc+0x84a>
    1188:	00003097          	auipc	ra,0x3
    118c:	e00080e7          	jalr	-512(ra) # 3f88 <open>
    1190:	8b2a                	mv	s6,a0
  if(fd < 0){
    printf("fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
    1192:	4a01                	li	s4,0
    1194:	4981                	li	s3,0
  if(fd < 0){
    1196:	02054963          	bltz	a0,11c8 <sharedfd+0x112>
    119a:	fba40913          	addi	s2,s0,-70
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
    119e:	06300493          	li	s1,99
        nc++;
      if(buf[i] == 'p')
    11a2:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    11a6:	4629                	li	a2,10
    11a8:	fb040593          	addi	a1,s0,-80
    11ac:	855a                	mv	a0,s6
    11ae:	00003097          	auipc	ra,0x3
    11b2:	db2080e7          	jalr	-590(ra) # 3f60 <read>
    11b6:	02a05e63          	blez	a0,11f2 <sharedfd+0x13c>
    11ba:	fb040793          	addi	a5,s0,-80
    11be:	a015                	j	11e2 <sharedfd+0x12c>
    exit();
    11c0:	00003097          	auipc	ra,0x3
    11c4:	d88080e7          	jalr	-632(ra) # 3f48 <exit>
    printf("fstests: cannot open sharedfd for reading\n");
    11c8:	00004517          	auipc	a0,0x4
    11cc:	a8050513          	addi	a0,a0,-1408 # 4c48 <malloc+0x8aa>
    11d0:	00003097          	auipc	ra,0x3
    11d4:	110080e7          	jalr	272(ra) # 42e0 <printf>
    return;
    11d8:	a8a1                	j	1230 <sharedfd+0x17a>
        nc++;
    11da:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    11dc:	0785                	addi	a5,a5,1
    11de:	fd2784e3          	beq	a5,s2,11a6 <sharedfd+0xf0>
      if(buf[i] == 'c')
    11e2:	0007c703          	lbu	a4,0(a5)
    11e6:	fe970ae3          	beq	a4,s1,11da <sharedfd+0x124>
      if(buf[i] == 'p')
    11ea:	ff5719e3          	bne	a4,s5,11dc <sharedfd+0x126>
        np++;
    11ee:	2a05                	addiw	s4,s4,1
    11f0:	b7f5                	j	11dc <sharedfd+0x126>
    }
  }
  close(fd);
    11f2:	855a                	mv	a0,s6
    11f4:	00003097          	auipc	ra,0x3
    11f8:	d7c080e7          	jalr	-644(ra) # 3f70 <close>
  unlink("sharedfd");
    11fc:	00004517          	auipc	a0,0x4
    1200:	9ec50513          	addi	a0,a0,-1556 # 4be8 <malloc+0x84a>
    1204:	00003097          	auipc	ra,0x3
    1208:	d94080e7          	jalr	-620(ra) # 3f98 <unlink>
  if(nc == N*SZ && np == N*SZ){
    120c:	6789                	lui	a5,0x2
    120e:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x6cc>
    1212:	02f99963          	bne	s3,a5,1244 <sharedfd+0x18e>
    1216:	6789                	lui	a5,0x2
    1218:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x6cc>
    121c:	02fa1463          	bne	s4,a5,1244 <sharedfd+0x18e>
    printf("sharedfd ok\n");
    1220:	00004517          	auipc	a0,0x4
    1224:	a5850513          	addi	a0,a0,-1448 # 4c78 <malloc+0x8da>
    1228:	00003097          	auipc	ra,0x3
    122c:	0b8080e7          	jalr	184(ra) # 42e0 <printf>
  } else {
    printf("sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    1230:	60a6                	ld	ra,72(sp)
    1232:	6406                	ld	s0,64(sp)
    1234:	74e2                	ld	s1,56(sp)
    1236:	7942                	ld	s2,48(sp)
    1238:	79a2                	ld	s3,40(sp)
    123a:	7a02                	ld	s4,32(sp)
    123c:	6ae2                	ld	s5,24(sp)
    123e:	6b42                	ld	s6,16(sp)
    1240:	6161                	addi	sp,sp,80
    1242:	8082                	ret
    printf("sharedfd oops %d %d\n", nc, np);
    1244:	8652                	mv	a2,s4
    1246:	85ce                	mv	a1,s3
    1248:	00004517          	auipc	a0,0x4
    124c:	a4050513          	addi	a0,a0,-1472 # 4c88 <malloc+0x8ea>
    1250:	00003097          	auipc	ra,0x3
    1254:	090080e7          	jalr	144(ra) # 42e0 <printf>
    exit();
    1258:	00003097          	auipc	ra,0x3
    125c:	cf0080e7          	jalr	-784(ra) # 3f48 <exit>

0000000000001260 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1260:	7119                	addi	sp,sp,-128
    1262:	fc86                	sd	ra,120(sp)
    1264:	f8a2                	sd	s0,112(sp)
    1266:	f4a6                	sd	s1,104(sp)
    1268:	f0ca                	sd	s2,96(sp)
    126a:	ecce                	sd	s3,88(sp)
    126c:	e8d2                	sd	s4,80(sp)
    126e:	e4d6                	sd	s5,72(sp)
    1270:	e0da                	sd	s6,64(sp)
    1272:	fc5e                	sd	s7,56(sp)
    1274:	f862                	sd	s8,48(sp)
    1276:	f466                	sd	s9,40(sp)
    1278:	f06a                	sd	s10,32(sp)
    127a:	0100                	addi	s0,sp,128
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    127c:	00003797          	auipc	a5,0x3
    1280:	20c78793          	addi	a5,a5,524 # 4488 <malloc+0xea>
    1284:	f8f43023          	sd	a5,-128(s0)
    1288:	00003797          	auipc	a5,0x3
    128c:	20878793          	addi	a5,a5,520 # 4490 <malloc+0xf2>
    1290:	f8f43423          	sd	a5,-120(s0)
    1294:	00003797          	auipc	a5,0x3
    1298:	20478793          	addi	a5,a5,516 # 4498 <malloc+0xfa>
    129c:	f8f43823          	sd	a5,-112(s0)
    12a0:	00003797          	auipc	a5,0x3
    12a4:	20078793          	addi	a5,a5,512 # 44a0 <malloc+0x102>
    12a8:	f8f43c23          	sd	a5,-104(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };
  
  printf("fourfiles test\n");
    12ac:	00004517          	auipc	a0,0x4
    12b0:	9f450513          	addi	a0,a0,-1548 # 4ca0 <malloc+0x902>
    12b4:	00003097          	auipc	ra,0x3
    12b8:	02c080e7          	jalr	44(ra) # 42e0 <printf>

  for(pi = 0; pi < NCHILD; pi++){
    12bc:	f8040b93          	addi	s7,s0,-128
  printf("fourfiles test\n");
    12c0:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    12c2:	4481                	li	s1,0
    12c4:	4a11                	li	s4,4
    fname = names[pi];
    12c6:	00093983          	ld	s3,0(s2)
    unlink(fname);
    12ca:	854e                	mv	a0,s3
    12cc:	00003097          	auipc	ra,0x3
    12d0:	ccc080e7          	jalr	-820(ra) # 3f98 <unlink>

    pid = fork();
    12d4:	00003097          	auipc	ra,0x3
    12d8:	c6c080e7          	jalr	-916(ra) # 3f40 <fork>
    if(pid < 0){
    12dc:	04054763          	bltz	a0,132a <fourfiles+0xca>
      printf("fork failed\n");
      exit();
    }

    if(pid == 0){
    12e0:	c12d                	beqz	a0,1342 <fourfiles+0xe2>
  for(pi = 0; pi < NCHILD; pi++){
    12e2:	2485                	addiw	s1,s1,1
    12e4:	0921                	addi	s2,s2,8
    12e6:	ff4490e3          	bne	s1,s4,12c6 <fourfiles+0x66>
      exit();
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait();
    12ea:	00003097          	auipc	ra,0x3
    12ee:	c66080e7          	jalr	-922(ra) # 3f50 <wait>
    12f2:	00003097          	auipc	ra,0x3
    12f6:	c5e080e7          	jalr	-930(ra) # 3f50 <wait>
    12fa:	00003097          	auipc	ra,0x3
    12fe:	c56080e7          	jalr	-938(ra) # 3f50 <wait>
    1302:	00003097          	auipc	ra,0x3
    1306:	c4e080e7          	jalr	-946(ra) # 3f50 <wait>
    130a:	03000b13          	li	s6,48

  for(i = 0; i < NCHILD; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    130e:	00007a17          	auipc	s4,0x7
    1312:	762a0a13          	addi	s4,s4,1890 # 8a70 <buf>
    1316:	00007a97          	auipc	s5,0x7
    131a:	75ba8a93          	addi	s5,s5,1883 # 8a71 <buf+0x1>
        }
      }
      total += n;
    }
    close(fd);
    if(total != N*SZ){
    131e:	6c85                	lui	s9,0x1
    1320:	770c8c93          	addi	s9,s9,1904 # 1770 <unlinkread+0xaa>
  for(i = 0; i < NCHILD; i++){
    1324:	03400d13          	li	s10,52
    1328:	aa19                	j	143e <fourfiles+0x1de>
      printf("fork failed\n");
    132a:	00003517          	auipc	a0,0x3
    132e:	22650513          	addi	a0,a0,550 # 4550 <malloc+0x1b2>
    1332:	00003097          	auipc	ra,0x3
    1336:	fae080e7          	jalr	-82(ra) # 42e0 <printf>
      exit();
    133a:	00003097          	auipc	ra,0x3
    133e:	c0e080e7          	jalr	-1010(ra) # 3f48 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1342:	20200593          	li	a1,514
    1346:	854e                	mv	a0,s3
    1348:	00003097          	auipc	ra,0x3
    134c:	c40080e7          	jalr	-960(ra) # 3f88 <open>
    1350:	892a                	mv	s2,a0
      if(fd < 0){
    1352:	04054663          	bltz	a0,139e <fourfiles+0x13e>
      memset(buf, '0'+pi, SZ);
    1356:	1f400613          	li	a2,500
    135a:	0304859b          	addiw	a1,s1,48
    135e:	00007517          	auipc	a0,0x7
    1362:	71250513          	addi	a0,a0,1810 # 8a70 <buf>
    1366:	00003097          	auipc	ra,0x3
    136a:	a5e080e7          	jalr	-1442(ra) # 3dc4 <memset>
    136e:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    1370:	00007997          	auipc	s3,0x7
    1374:	70098993          	addi	s3,s3,1792 # 8a70 <buf>
    1378:	1f400613          	li	a2,500
    137c:	85ce                	mv	a1,s3
    137e:	854a                	mv	a0,s2
    1380:	00003097          	auipc	ra,0x3
    1384:	be8080e7          	jalr	-1048(ra) # 3f68 <write>
    1388:	85aa                	mv	a1,a0
    138a:	1f400793          	li	a5,500
    138e:	02f51463          	bne	a0,a5,13b6 <fourfiles+0x156>
      for(i = 0; i < N; i++){
    1392:	34fd                	addiw	s1,s1,-1
    1394:	f0f5                	bnez	s1,1378 <fourfiles+0x118>
      exit();
    1396:	00003097          	auipc	ra,0x3
    139a:	bb2080e7          	jalr	-1102(ra) # 3f48 <exit>
        printf("create failed\n");
    139e:	00004517          	auipc	a0,0x4
    13a2:	91250513          	addi	a0,a0,-1774 # 4cb0 <malloc+0x912>
    13a6:	00003097          	auipc	ra,0x3
    13aa:	f3a080e7          	jalr	-198(ra) # 42e0 <printf>
        exit();
    13ae:	00003097          	auipc	ra,0x3
    13b2:	b9a080e7          	jalr	-1126(ra) # 3f48 <exit>
          printf("write failed %d\n", n);
    13b6:	00004517          	auipc	a0,0x4
    13ba:	90a50513          	addi	a0,a0,-1782 # 4cc0 <malloc+0x922>
    13be:	00003097          	auipc	ra,0x3
    13c2:	f22080e7          	jalr	-222(ra) # 42e0 <printf>
          exit();
    13c6:	00003097          	auipc	ra,0x3
    13ca:	b82080e7          	jalr	-1150(ra) # 3f48 <exit>
          printf("wrong char\n");
    13ce:	00004517          	auipc	a0,0x4
    13d2:	90a50513          	addi	a0,a0,-1782 # 4cd8 <malloc+0x93a>
    13d6:	00003097          	auipc	ra,0x3
    13da:	f0a080e7          	jalr	-246(ra) # 42e0 <printf>
          exit();
    13de:	00003097          	auipc	ra,0x3
    13e2:	b6a080e7          	jalr	-1174(ra) # 3f48 <exit>
      total += n;
    13e6:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    13ea:	660d                	lui	a2,0x3
    13ec:	85d2                	mv	a1,s4
    13ee:	854e                	mv	a0,s3
    13f0:	00003097          	auipc	ra,0x3
    13f4:	b70080e7          	jalr	-1168(ra) # 3f60 <read>
    13f8:	02a05363          	blez	a0,141e <fourfiles+0x1be>
    13fc:	00007797          	auipc	a5,0x7
    1400:	67478793          	addi	a5,a5,1652 # 8a70 <buf>
    1404:	fff5069b          	addiw	a3,a0,-1
    1408:	1682                	slli	a3,a3,0x20
    140a:	9281                	srli	a3,a3,0x20
    140c:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    140e:	0007c703          	lbu	a4,0(a5)
    1412:	fa971ee3          	bne	a4,s1,13ce <fourfiles+0x16e>
      for(j = 0; j < n; j++){
    1416:	0785                	addi	a5,a5,1
    1418:	fed79be3          	bne	a5,a3,140e <fourfiles+0x1ae>
    141c:	b7e9                	j	13e6 <fourfiles+0x186>
    close(fd);
    141e:	854e                	mv	a0,s3
    1420:	00003097          	auipc	ra,0x3
    1424:	b50080e7          	jalr	-1200(ra) # 3f70 <close>
    if(total != N*SZ){
    1428:	03991863          	bne	s2,s9,1458 <fourfiles+0x1f8>
      printf("wrong length %d\n", total);
      exit();
    }
    unlink(fname);
    142c:	8562                	mv	a0,s8
    142e:	00003097          	auipc	ra,0x3
    1432:	b6a080e7          	jalr	-1174(ra) # 3f98 <unlink>
  for(i = 0; i < NCHILD; i++){
    1436:	0ba1                	addi	s7,s7,8
    1438:	2b05                	addiw	s6,s6,1
    143a:	03ab0c63          	beq	s6,s10,1472 <fourfiles+0x212>
    fname = names[i];
    143e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1442:	4581                	li	a1,0
    1444:	8562                	mv	a0,s8
    1446:	00003097          	auipc	ra,0x3
    144a:	b42080e7          	jalr	-1214(ra) # 3f88 <open>
    144e:	89aa                	mv	s3,a0
    total = 0;
    1450:	4901                	li	s2,0
        if(buf[j] != '0'+i){
    1452:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1456:	bf51                	j	13ea <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    1458:	85ca                	mv	a1,s2
    145a:	00004517          	auipc	a0,0x4
    145e:	88e50513          	addi	a0,a0,-1906 # 4ce8 <malloc+0x94a>
    1462:	00003097          	auipc	ra,0x3
    1466:	e7e080e7          	jalr	-386(ra) # 42e0 <printf>
      exit();
    146a:	00003097          	auipc	ra,0x3
    146e:	ade080e7          	jalr	-1314(ra) # 3f48 <exit>
  }

  printf("fourfiles ok\n");
    1472:	00004517          	auipc	a0,0x4
    1476:	88e50513          	addi	a0,a0,-1906 # 4d00 <malloc+0x962>
    147a:	00003097          	auipc	ra,0x3
    147e:	e66080e7          	jalr	-410(ra) # 42e0 <printf>
}
    1482:	70e6                	ld	ra,120(sp)
    1484:	7446                	ld	s0,112(sp)
    1486:	74a6                	ld	s1,104(sp)
    1488:	7906                	ld	s2,96(sp)
    148a:	69e6                	ld	s3,88(sp)
    148c:	6a46                	ld	s4,80(sp)
    148e:	6aa6                	ld	s5,72(sp)
    1490:	6b06                	ld	s6,64(sp)
    1492:	7be2                	ld	s7,56(sp)
    1494:	7c42                	ld	s8,48(sp)
    1496:	7ca2                	ld	s9,40(sp)
    1498:	7d02                	ld	s10,32(sp)
    149a:	6109                	addi	sp,sp,128
    149c:	8082                	ret

000000000000149e <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    149e:	7159                	addi	sp,sp,-112
    14a0:	f486                	sd	ra,104(sp)
    14a2:	f0a2                	sd	s0,96(sp)
    14a4:	eca6                	sd	s1,88(sp)
    14a6:	e8ca                	sd	s2,80(sp)
    14a8:	e4ce                	sd	s3,72(sp)
    14aa:	e0d2                	sd	s4,64(sp)
    14ac:	fc56                	sd	s5,56(sp)
    14ae:	f85a                	sd	s6,48(sp)
    14b0:	f45e                	sd	s7,40(sp)
    14b2:	f062                	sd	s8,32(sp)
    14b4:	1880                	addi	s0,sp,112
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  printf("createdelete test\n");
    14b6:	00004517          	auipc	a0,0x4
    14ba:	85a50513          	addi	a0,a0,-1958 # 4d10 <malloc+0x972>
    14be:	00003097          	auipc	ra,0x3
    14c2:	e22080e7          	jalr	-478(ra) # 42e0 <printf>

  for(pi = 0; pi < NCHILD; pi++){
    14c6:	4901                	li	s2,0
    14c8:	4991                	li	s3,4
    pid = fork();
    14ca:	00003097          	auipc	ra,0x3
    14ce:	a76080e7          	jalr	-1418(ra) # 3f40 <fork>
    14d2:	84aa                	mv	s1,a0
    if(pid < 0){
    14d4:	04054363          	bltz	a0,151a <createdelete+0x7c>
      printf("fork failed\n");
      exit();
    }

    if(pid == 0){
    14d8:	cd29                	beqz	a0,1532 <createdelete+0x94>
  for(pi = 0; pi < NCHILD; pi++){
    14da:	2905                	addiw	s2,s2,1
    14dc:	ff3917e3          	bne	s2,s3,14ca <createdelete+0x2c>
      exit();
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait();
    14e0:	00003097          	auipc	ra,0x3
    14e4:	a70080e7          	jalr	-1424(ra) # 3f50 <wait>
    14e8:	00003097          	auipc	ra,0x3
    14ec:	a68080e7          	jalr	-1432(ra) # 3f50 <wait>
    14f0:	00003097          	auipc	ra,0x3
    14f4:	a60080e7          	jalr	-1440(ra) # 3f50 <wait>
    14f8:	00003097          	auipc	ra,0x3
    14fc:	a58080e7          	jalr	-1448(ra) # 3f50 <wait>
  }

  name[0] = name[1] = name[2] = 0;
    1500:	f8040923          	sb	zero,-110(s0)
    1504:	03000993          	li	s3,48
    1508:	5a7d                	li	s4,-1
  for(i = 0; i < N; i++){
    150a:	4901                	li	s2,0
  for(pi = 0; pi < NCHILD; pi++){
    150c:	07000c13          	li	s8,112
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf("oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1510:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1512:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1514:	07400a93          	li	s5,116
    1518:	a299                	j	165e <createdelete+0x1c0>
      printf("fork failed\n");
    151a:	00003517          	auipc	a0,0x3
    151e:	03650513          	addi	a0,a0,54 # 4550 <malloc+0x1b2>
    1522:	00003097          	auipc	ra,0x3
    1526:	dbe080e7          	jalr	-578(ra) # 42e0 <printf>
      exit();
    152a:	00003097          	auipc	ra,0x3
    152e:	a1e080e7          	jalr	-1506(ra) # 3f48 <exit>
      name[0] = 'p' + pi;
    1532:	0709091b          	addiw	s2,s2,112
    1536:	f9240823          	sb	s2,-112(s0)
      name[2] = '\0';
    153a:	f8040923          	sb	zero,-110(s0)
      for(i = 0; i < N; i++){
    153e:	4951                	li	s2,20
    1540:	a005                	j	1560 <createdelete+0xc2>
          printf("create failed\n");
    1542:	00003517          	auipc	a0,0x3
    1546:	76e50513          	addi	a0,a0,1902 # 4cb0 <malloc+0x912>
    154a:	00003097          	auipc	ra,0x3
    154e:	d96080e7          	jalr	-618(ra) # 42e0 <printf>
          exit();
    1552:	00003097          	auipc	ra,0x3
    1556:	9f6080e7          	jalr	-1546(ra) # 3f48 <exit>
      for(i = 0; i < N; i++){
    155a:	2485                	addiw	s1,s1,1
    155c:	07248663          	beq	s1,s2,15c8 <createdelete+0x12a>
        name[1] = '0' + i;
    1560:	0304879b          	addiw	a5,s1,48
    1564:	f8f408a3          	sb	a5,-111(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1568:	20200593          	li	a1,514
    156c:	f9040513          	addi	a0,s0,-112
    1570:	00003097          	auipc	ra,0x3
    1574:	a18080e7          	jalr	-1512(ra) # 3f88 <open>
        if(fd < 0){
    1578:	fc0545e3          	bltz	a0,1542 <createdelete+0xa4>
        close(fd);
    157c:	00003097          	auipc	ra,0x3
    1580:	9f4080e7          	jalr	-1548(ra) # 3f70 <close>
        if(i > 0 && (i % 2 ) == 0){
    1584:	fc905be3          	blez	s1,155a <createdelete+0xbc>
    1588:	0014f793          	andi	a5,s1,1
    158c:	f7f9                	bnez	a5,155a <createdelete+0xbc>
          name[1] = '0' + (i / 2);
    158e:	01f4d79b          	srliw	a5,s1,0x1f
    1592:	9fa5                	addw	a5,a5,s1
    1594:	4017d79b          	sraiw	a5,a5,0x1
    1598:	0307879b          	addiw	a5,a5,48
    159c:	f8f408a3          	sb	a5,-111(s0)
          if(unlink(name) < 0){
    15a0:	f9040513          	addi	a0,s0,-112
    15a4:	00003097          	auipc	ra,0x3
    15a8:	9f4080e7          	jalr	-1548(ra) # 3f98 <unlink>
    15ac:	fa0557e3          	bgez	a0,155a <createdelete+0xbc>
            printf("unlink failed\n");
    15b0:	00003517          	auipc	a0,0x3
    15b4:	03850513          	addi	a0,a0,56 # 45e8 <malloc+0x24a>
    15b8:	00003097          	auipc	ra,0x3
    15bc:	d28080e7          	jalr	-728(ra) # 42e0 <printf>
            exit();
    15c0:	00003097          	auipc	ra,0x3
    15c4:	988080e7          	jalr	-1656(ra) # 3f48 <exit>
      exit();
    15c8:	00003097          	auipc	ra,0x3
    15cc:	980080e7          	jalr	-1664(ra) # 3f48 <exit>
        printf("oops createdelete %s didn't exist\n", name);
    15d0:	f9040593          	addi	a1,s0,-112
    15d4:	00003517          	auipc	a0,0x3
    15d8:	75450513          	addi	a0,a0,1876 # 4d28 <malloc+0x98a>
    15dc:	00003097          	auipc	ra,0x3
    15e0:	d04080e7          	jalr	-764(ra) # 42e0 <printf>
        exit();
    15e4:	00003097          	auipc	ra,0x3
    15e8:	964080e7          	jalr	-1692(ra) # 3f48 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    15ec:	054b7163          	bgeu	s6,s4,162e <createdelete+0x190>
        printf("oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    15f0:	02055a63          	bgez	a0,1624 <createdelete+0x186>
    for(pi = 0; pi < NCHILD; pi++){
    15f4:	2485                	addiw	s1,s1,1
    15f6:	0ff4f493          	andi	s1,s1,255
    15fa:	05548a63          	beq	s1,s5,164e <createdelete+0x1b0>
      name[0] = 'p' + pi;
    15fe:	f8940823          	sb	s1,-112(s0)
      name[1] = '0' + i;
    1602:	f93408a3          	sb	s3,-111(s0)
      fd = open(name, 0);
    1606:	4581                	li	a1,0
    1608:	f9040513          	addi	a0,s0,-112
    160c:	00003097          	auipc	ra,0x3
    1610:	97c080e7          	jalr	-1668(ra) # 3f88 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1614:	00090463          	beqz	s2,161c <createdelete+0x17e>
    1618:	fd2bdae3          	bge	s7,s2,15ec <createdelete+0x14e>
    161c:	fa054ae3          	bltz	a0,15d0 <createdelete+0x132>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1620:	014b7963          	bgeu	s6,s4,1632 <createdelete+0x194>
        close(fd);
    1624:	00003097          	auipc	ra,0x3
    1628:	94c080e7          	jalr	-1716(ra) # 3f70 <close>
    162c:	b7e1                	j	15f4 <createdelete+0x156>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    162e:	fc0543e3          	bltz	a0,15f4 <createdelete+0x156>
        printf("oops createdelete %s did exist\n", name);
    1632:	f9040593          	addi	a1,s0,-112
    1636:	00003517          	auipc	a0,0x3
    163a:	71a50513          	addi	a0,a0,1818 # 4d50 <malloc+0x9b2>
    163e:	00003097          	auipc	ra,0x3
    1642:	ca2080e7          	jalr	-862(ra) # 42e0 <printf>
        exit();
    1646:	00003097          	auipc	ra,0x3
    164a:	902080e7          	jalr	-1790(ra) # 3f48 <exit>
  for(i = 0; i < N; i++){
    164e:	2905                	addiw	s2,s2,1
    1650:	2a05                	addiw	s4,s4,1
    1652:	2985                	addiw	s3,s3,1
    1654:	0ff9f993          	andi	s3,s3,255
    1658:	47d1                	li	a5,20
    165a:	02f90a63          	beq	s2,a5,168e <createdelete+0x1f0>
  for(pi = 0; pi < NCHILD; pi++){
    165e:	84e2                	mv	s1,s8
    1660:	bf79                	j	15fe <createdelete+0x160>
    }
  }

  for(i = 0; i < N; i++){
    1662:	2905                	addiw	s2,s2,1
    1664:	0ff97913          	andi	s2,s2,255
    1668:	2985                	addiw	s3,s3,1
    166a:	0ff9f993          	andi	s3,s3,255
    166e:	03490863          	beq	s2,s4,169e <createdelete+0x200>
  for(i = 0; i < N; i++){
    1672:	84d6                	mv	s1,s5
    for(pi = 0; pi < NCHILD; pi++){
      name[0] = 'p' + i;
    1674:	f9240823          	sb	s2,-112(s0)
      name[1] = '0' + i;
    1678:	f93408a3          	sb	s3,-111(s0)
      unlink(name);
    167c:	f9040513          	addi	a0,s0,-112
    1680:	00003097          	auipc	ra,0x3
    1684:	918080e7          	jalr	-1768(ra) # 3f98 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1688:	34fd                	addiw	s1,s1,-1
    168a:	f4ed                	bnez	s1,1674 <createdelete+0x1d6>
    168c:	bfd9                	j	1662 <createdelete+0x1c4>
    168e:	03000993          	li	s3,48
    1692:	07000913          	li	s2,112
  for(i = 0; i < N; i++){
    1696:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1698:	08400a13          	li	s4,132
    169c:	bfd9                	j	1672 <createdelete+0x1d4>
    }
  }

  printf("createdelete ok\n");
    169e:	00003517          	auipc	a0,0x3
    16a2:	6d250513          	addi	a0,a0,1746 # 4d70 <malloc+0x9d2>
    16a6:	00003097          	auipc	ra,0x3
    16aa:	c3a080e7          	jalr	-966(ra) # 42e0 <printf>
}
    16ae:	70a6                	ld	ra,104(sp)
    16b0:	7406                	ld	s0,96(sp)
    16b2:	64e6                	ld	s1,88(sp)
    16b4:	6946                	ld	s2,80(sp)
    16b6:	69a6                	ld	s3,72(sp)
    16b8:	6a06                	ld	s4,64(sp)
    16ba:	7ae2                	ld	s5,56(sp)
    16bc:	7b42                	ld	s6,48(sp)
    16be:	7ba2                	ld	s7,40(sp)
    16c0:	7c02                	ld	s8,32(sp)
    16c2:	6165                	addi	sp,sp,112
    16c4:	8082                	ret

00000000000016c6 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    16c6:	1101                	addi	sp,sp,-32
    16c8:	ec06                	sd	ra,24(sp)
    16ca:	e822                	sd	s0,16(sp)
    16cc:	e426                	sd	s1,8(sp)
    16ce:	e04a                	sd	s2,0(sp)
    16d0:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd, fd1;

  printf("unlinkread test\n");
    16d2:	00003517          	auipc	a0,0x3
    16d6:	6b650513          	addi	a0,a0,1718 # 4d88 <malloc+0x9ea>
    16da:	00003097          	auipc	ra,0x3
    16de:	c06080e7          	jalr	-1018(ra) # 42e0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    16e2:	20200593          	li	a1,514
    16e6:	00003517          	auipc	a0,0x3
    16ea:	6ba50513          	addi	a0,a0,1722 # 4da0 <malloc+0xa02>
    16ee:	00003097          	auipc	ra,0x3
    16f2:	89a080e7          	jalr	-1894(ra) # 3f88 <open>
  if(fd < 0){
    16f6:	0e054c63          	bltz	a0,17ee <unlinkread+0x128>
    16fa:	84aa                	mv	s1,a0
    printf("create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", SZ);
    16fc:	4615                	li	a2,5
    16fe:	00003597          	auipc	a1,0x3
    1702:	6d258593          	addi	a1,a1,1746 # 4dd0 <malloc+0xa32>
    1706:	00003097          	auipc	ra,0x3
    170a:	862080e7          	jalr	-1950(ra) # 3f68 <write>
  close(fd);
    170e:	8526                	mv	a0,s1
    1710:	00003097          	auipc	ra,0x3
    1714:	860080e7          	jalr	-1952(ra) # 3f70 <close>

  fd = open("unlinkread", O_RDWR);
    1718:	4589                	li	a1,2
    171a:	00003517          	auipc	a0,0x3
    171e:	68650513          	addi	a0,a0,1670 # 4da0 <malloc+0xa02>
    1722:	00003097          	auipc	ra,0x3
    1726:	866080e7          	jalr	-1946(ra) # 3f88 <open>
    172a:	84aa                	mv	s1,a0
  if(fd < 0){
    172c:	0c054d63          	bltz	a0,1806 <unlinkread+0x140>
    printf("open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1730:	00003517          	auipc	a0,0x3
    1734:	67050513          	addi	a0,a0,1648 # 4da0 <malloc+0xa02>
    1738:	00003097          	auipc	ra,0x3
    173c:	860080e7          	jalr	-1952(ra) # 3f98 <unlink>
    1740:	ed79                	bnez	a0,181e <unlinkread+0x158>
    printf("unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1742:	20200593          	li	a1,514
    1746:	00003517          	auipc	a0,0x3
    174a:	65a50513          	addi	a0,a0,1626 # 4da0 <malloc+0xa02>
    174e:	00003097          	auipc	ra,0x3
    1752:	83a080e7          	jalr	-1990(ra) # 3f88 <open>
    1756:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1758:	460d                	li	a2,3
    175a:	00003597          	auipc	a1,0x3
    175e:	6b658593          	addi	a1,a1,1718 # 4e10 <malloc+0xa72>
    1762:	00003097          	auipc	ra,0x3
    1766:	806080e7          	jalr	-2042(ra) # 3f68 <write>
  close(fd1);
    176a:	854a                	mv	a0,s2
    176c:	00003097          	auipc	ra,0x3
    1770:	804080e7          	jalr	-2044(ra) # 3f70 <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    1774:	660d                	lui	a2,0x3
    1776:	00007597          	auipc	a1,0x7
    177a:	2fa58593          	addi	a1,a1,762 # 8a70 <buf>
    177e:	8526                	mv	a0,s1
    1780:	00002097          	auipc	ra,0x2
    1784:	7e0080e7          	jalr	2016(ra) # 3f60 <read>
    1788:	4795                	li	a5,5
    178a:	0af51663          	bne	a0,a5,1836 <unlinkread+0x170>
    printf("unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    178e:	00007717          	auipc	a4,0x7
    1792:	2e274703          	lbu	a4,738(a4) # 8a70 <buf>
    1796:	06800793          	li	a5,104
    179a:	0af71a63          	bne	a4,a5,184e <unlinkread+0x188>
    printf("unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    179e:	4629                	li	a2,10
    17a0:	00007597          	auipc	a1,0x7
    17a4:	2d058593          	addi	a1,a1,720 # 8a70 <buf>
    17a8:	8526                	mv	a0,s1
    17aa:	00002097          	auipc	ra,0x2
    17ae:	7be080e7          	jalr	1982(ra) # 3f68 <write>
    17b2:	47a9                	li	a5,10
    17b4:	0af51963          	bne	a0,a5,1866 <unlinkread+0x1a0>
    printf("unlinkread write failed\n");
    exit();
  }
  close(fd);
    17b8:	8526                	mv	a0,s1
    17ba:	00002097          	auipc	ra,0x2
    17be:	7b6080e7          	jalr	1974(ra) # 3f70 <close>
  unlink("unlinkread");
    17c2:	00003517          	auipc	a0,0x3
    17c6:	5de50513          	addi	a0,a0,1502 # 4da0 <malloc+0xa02>
    17ca:	00002097          	auipc	ra,0x2
    17ce:	7ce080e7          	jalr	1998(ra) # 3f98 <unlink>
  printf("unlinkread ok\n");
    17d2:	00003517          	auipc	a0,0x3
    17d6:	69650513          	addi	a0,a0,1686 # 4e68 <malloc+0xaca>
    17da:	00003097          	auipc	ra,0x3
    17de:	b06080e7          	jalr	-1274(ra) # 42e0 <printf>
}
    17e2:	60e2                	ld	ra,24(sp)
    17e4:	6442                	ld	s0,16(sp)
    17e6:	64a2                	ld	s1,8(sp)
    17e8:	6902                	ld	s2,0(sp)
    17ea:	6105                	addi	sp,sp,32
    17ec:	8082                	ret
    printf("create unlinkread failed\n");
    17ee:	00003517          	auipc	a0,0x3
    17f2:	5c250513          	addi	a0,a0,1474 # 4db0 <malloc+0xa12>
    17f6:	00003097          	auipc	ra,0x3
    17fa:	aea080e7          	jalr	-1302(ra) # 42e0 <printf>
    exit();
    17fe:	00002097          	auipc	ra,0x2
    1802:	74a080e7          	jalr	1866(ra) # 3f48 <exit>
    printf("open unlinkread failed\n");
    1806:	00003517          	auipc	a0,0x3
    180a:	5d250513          	addi	a0,a0,1490 # 4dd8 <malloc+0xa3a>
    180e:	00003097          	auipc	ra,0x3
    1812:	ad2080e7          	jalr	-1326(ra) # 42e0 <printf>
    exit();
    1816:	00002097          	auipc	ra,0x2
    181a:	732080e7          	jalr	1842(ra) # 3f48 <exit>
    printf("unlink unlinkread failed\n");
    181e:	00003517          	auipc	a0,0x3
    1822:	5d250513          	addi	a0,a0,1490 # 4df0 <malloc+0xa52>
    1826:	00003097          	auipc	ra,0x3
    182a:	aba080e7          	jalr	-1350(ra) # 42e0 <printf>
    exit();
    182e:	00002097          	auipc	ra,0x2
    1832:	71a080e7          	jalr	1818(ra) # 3f48 <exit>
    printf("unlinkread read failed");
    1836:	00003517          	auipc	a0,0x3
    183a:	5e250513          	addi	a0,a0,1506 # 4e18 <malloc+0xa7a>
    183e:	00003097          	auipc	ra,0x3
    1842:	aa2080e7          	jalr	-1374(ra) # 42e0 <printf>
    exit();
    1846:	00002097          	auipc	ra,0x2
    184a:	702080e7          	jalr	1794(ra) # 3f48 <exit>
    printf("unlinkread wrong data\n");
    184e:	00003517          	auipc	a0,0x3
    1852:	5e250513          	addi	a0,a0,1506 # 4e30 <malloc+0xa92>
    1856:	00003097          	auipc	ra,0x3
    185a:	a8a080e7          	jalr	-1398(ra) # 42e0 <printf>
    exit();
    185e:	00002097          	auipc	ra,0x2
    1862:	6ea080e7          	jalr	1770(ra) # 3f48 <exit>
    printf("unlinkread write failed\n");
    1866:	00003517          	auipc	a0,0x3
    186a:	5e250513          	addi	a0,a0,1506 # 4e48 <malloc+0xaaa>
    186e:	00003097          	auipc	ra,0x3
    1872:	a72080e7          	jalr	-1422(ra) # 42e0 <printf>
    exit();
    1876:	00002097          	auipc	ra,0x2
    187a:	6d2080e7          	jalr	1746(ra) # 3f48 <exit>

000000000000187e <linktest>:

void
linktest(void)
{
    187e:	1101                	addi	sp,sp,-32
    1880:	ec06                	sd	ra,24(sp)
    1882:	e822                	sd	s0,16(sp)
    1884:	e426                	sd	s1,8(sp)
    1886:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd;

  printf("linktest\n");
    1888:	00003517          	auipc	a0,0x3
    188c:	5f050513          	addi	a0,a0,1520 # 4e78 <malloc+0xada>
    1890:	00003097          	auipc	ra,0x3
    1894:	a50080e7          	jalr	-1456(ra) # 42e0 <printf>

  unlink("lf1");
    1898:	00003517          	auipc	a0,0x3
    189c:	5f050513          	addi	a0,a0,1520 # 4e88 <malloc+0xaea>
    18a0:	00002097          	auipc	ra,0x2
    18a4:	6f8080e7          	jalr	1784(ra) # 3f98 <unlink>
  unlink("lf2");
    18a8:	00003517          	auipc	a0,0x3
    18ac:	5e850513          	addi	a0,a0,1512 # 4e90 <malloc+0xaf2>
    18b0:	00002097          	auipc	ra,0x2
    18b4:	6e8080e7          	jalr	1768(ra) # 3f98 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    18b8:	20200593          	li	a1,514
    18bc:	00003517          	auipc	a0,0x3
    18c0:	5cc50513          	addi	a0,a0,1484 # 4e88 <malloc+0xaea>
    18c4:	00002097          	auipc	ra,0x2
    18c8:	6c4080e7          	jalr	1732(ra) # 3f88 <open>
  if(fd < 0){
    18cc:	10054e63          	bltz	a0,19e8 <linktest+0x16a>
    18d0:	84aa                	mv	s1,a0
    printf("create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", SZ) != SZ){
    18d2:	4615                	li	a2,5
    18d4:	00003597          	auipc	a1,0x3
    18d8:	4fc58593          	addi	a1,a1,1276 # 4dd0 <malloc+0xa32>
    18dc:	00002097          	auipc	ra,0x2
    18e0:	68c080e7          	jalr	1676(ra) # 3f68 <write>
    18e4:	4795                	li	a5,5
    18e6:	10f51d63          	bne	a0,a5,1a00 <linktest+0x182>
    printf("write lf1 failed\n");
    exit();
  }
  close(fd);
    18ea:	8526                	mv	a0,s1
    18ec:	00002097          	auipc	ra,0x2
    18f0:	684080e7          	jalr	1668(ra) # 3f70 <close>

  if(link("lf1", "lf2") < 0){
    18f4:	00003597          	auipc	a1,0x3
    18f8:	59c58593          	addi	a1,a1,1436 # 4e90 <malloc+0xaf2>
    18fc:	00003517          	auipc	a0,0x3
    1900:	58c50513          	addi	a0,a0,1420 # 4e88 <malloc+0xaea>
    1904:	00002097          	auipc	ra,0x2
    1908:	6a4080e7          	jalr	1700(ra) # 3fa8 <link>
    190c:	10054663          	bltz	a0,1a18 <linktest+0x19a>
    printf("link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1910:	00003517          	auipc	a0,0x3
    1914:	57850513          	addi	a0,a0,1400 # 4e88 <malloc+0xaea>
    1918:	00002097          	auipc	ra,0x2
    191c:	680080e7          	jalr	1664(ra) # 3f98 <unlink>

  if(open("lf1", 0) >= 0){
    1920:	4581                	li	a1,0
    1922:	00003517          	auipc	a0,0x3
    1926:	56650513          	addi	a0,a0,1382 # 4e88 <malloc+0xaea>
    192a:	00002097          	auipc	ra,0x2
    192e:	65e080e7          	jalr	1630(ra) # 3f88 <open>
    1932:	0e055f63          	bgez	a0,1a30 <linktest+0x1b2>
    printf("unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1936:	4581                	li	a1,0
    1938:	00003517          	auipc	a0,0x3
    193c:	55850513          	addi	a0,a0,1368 # 4e90 <malloc+0xaf2>
    1940:	00002097          	auipc	ra,0x2
    1944:	648080e7          	jalr	1608(ra) # 3f88 <open>
    1948:	84aa                	mv	s1,a0
  if(fd < 0){
    194a:	0e054f63          	bltz	a0,1a48 <linktest+0x1ca>
    printf("open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    194e:	660d                	lui	a2,0x3
    1950:	00007597          	auipc	a1,0x7
    1954:	12058593          	addi	a1,a1,288 # 8a70 <buf>
    1958:	00002097          	auipc	ra,0x2
    195c:	608080e7          	jalr	1544(ra) # 3f60 <read>
    1960:	4795                	li	a5,5
    1962:	0ef51f63          	bne	a0,a5,1a60 <linktest+0x1e2>
    printf("read lf2 failed\n");
    exit();
  }
  close(fd);
    1966:	8526                	mv	a0,s1
    1968:	00002097          	auipc	ra,0x2
    196c:	608080e7          	jalr	1544(ra) # 3f70 <close>

  if(link("lf2", "lf2") >= 0){
    1970:	00003597          	auipc	a1,0x3
    1974:	52058593          	addi	a1,a1,1312 # 4e90 <malloc+0xaf2>
    1978:	852e                	mv	a0,a1
    197a:	00002097          	auipc	ra,0x2
    197e:	62e080e7          	jalr	1582(ra) # 3fa8 <link>
    1982:	0e055b63          	bgez	a0,1a78 <linktest+0x1fa>
    printf("link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1986:	00003517          	auipc	a0,0x3
    198a:	50a50513          	addi	a0,a0,1290 # 4e90 <malloc+0xaf2>
    198e:	00002097          	auipc	ra,0x2
    1992:	60a080e7          	jalr	1546(ra) # 3f98 <unlink>
  if(link("lf2", "lf1") >= 0){
    1996:	00003597          	auipc	a1,0x3
    199a:	4f258593          	addi	a1,a1,1266 # 4e88 <malloc+0xaea>
    199e:	00003517          	auipc	a0,0x3
    19a2:	4f250513          	addi	a0,a0,1266 # 4e90 <malloc+0xaf2>
    19a6:	00002097          	auipc	ra,0x2
    19aa:	602080e7          	jalr	1538(ra) # 3fa8 <link>
    19ae:	0e055163          	bgez	a0,1a90 <linktest+0x212>
    printf("link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    19b2:	00003597          	auipc	a1,0x3
    19b6:	4d658593          	addi	a1,a1,1238 # 4e88 <malloc+0xaea>
    19ba:	00003517          	auipc	a0,0x3
    19be:	5c650513          	addi	a0,a0,1478 # 4f80 <malloc+0xbe2>
    19c2:	00002097          	auipc	ra,0x2
    19c6:	5e6080e7          	jalr	1510(ra) # 3fa8 <link>
    19ca:	0c055f63          	bgez	a0,1aa8 <linktest+0x22a>
    printf("link . lf1 succeeded! oops\n");
    exit();
  }

  printf("linktest ok\n");
    19ce:	00003517          	auipc	a0,0x3
    19d2:	5da50513          	addi	a0,a0,1498 # 4fa8 <malloc+0xc0a>
    19d6:	00003097          	auipc	ra,0x3
    19da:	90a080e7          	jalr	-1782(ra) # 42e0 <printf>
}
    19de:	60e2                	ld	ra,24(sp)
    19e0:	6442                	ld	s0,16(sp)
    19e2:	64a2                	ld	s1,8(sp)
    19e4:	6105                	addi	sp,sp,32
    19e6:	8082                	ret
    printf("create lf1 failed\n");
    19e8:	00003517          	auipc	a0,0x3
    19ec:	4b050513          	addi	a0,a0,1200 # 4e98 <malloc+0xafa>
    19f0:	00003097          	auipc	ra,0x3
    19f4:	8f0080e7          	jalr	-1808(ra) # 42e0 <printf>
    exit();
    19f8:	00002097          	auipc	ra,0x2
    19fc:	550080e7          	jalr	1360(ra) # 3f48 <exit>
    printf("write lf1 failed\n");
    1a00:	00003517          	auipc	a0,0x3
    1a04:	4b050513          	addi	a0,a0,1200 # 4eb0 <malloc+0xb12>
    1a08:	00003097          	auipc	ra,0x3
    1a0c:	8d8080e7          	jalr	-1832(ra) # 42e0 <printf>
    exit();
    1a10:	00002097          	auipc	ra,0x2
    1a14:	538080e7          	jalr	1336(ra) # 3f48 <exit>
    printf("link lf1 lf2 failed\n");
    1a18:	00003517          	auipc	a0,0x3
    1a1c:	4b050513          	addi	a0,a0,1200 # 4ec8 <malloc+0xb2a>
    1a20:	00003097          	auipc	ra,0x3
    1a24:	8c0080e7          	jalr	-1856(ra) # 42e0 <printf>
    exit();
    1a28:	00002097          	auipc	ra,0x2
    1a2c:	520080e7          	jalr	1312(ra) # 3f48 <exit>
    printf("unlinked lf1 but it is still there!\n");
    1a30:	00003517          	auipc	a0,0x3
    1a34:	4b050513          	addi	a0,a0,1200 # 4ee0 <malloc+0xb42>
    1a38:	00003097          	auipc	ra,0x3
    1a3c:	8a8080e7          	jalr	-1880(ra) # 42e0 <printf>
    exit();
    1a40:	00002097          	auipc	ra,0x2
    1a44:	508080e7          	jalr	1288(ra) # 3f48 <exit>
    printf("open lf2 failed\n");
    1a48:	00003517          	auipc	a0,0x3
    1a4c:	4c050513          	addi	a0,a0,1216 # 4f08 <malloc+0xb6a>
    1a50:	00003097          	auipc	ra,0x3
    1a54:	890080e7          	jalr	-1904(ra) # 42e0 <printf>
    exit();
    1a58:	00002097          	auipc	ra,0x2
    1a5c:	4f0080e7          	jalr	1264(ra) # 3f48 <exit>
    printf("read lf2 failed\n");
    1a60:	00003517          	auipc	a0,0x3
    1a64:	4c050513          	addi	a0,a0,1216 # 4f20 <malloc+0xb82>
    1a68:	00003097          	auipc	ra,0x3
    1a6c:	878080e7          	jalr	-1928(ra) # 42e0 <printf>
    exit();
    1a70:	00002097          	auipc	ra,0x2
    1a74:	4d8080e7          	jalr	1240(ra) # 3f48 <exit>
    printf("link lf2 lf2 succeeded! oops\n");
    1a78:	00003517          	auipc	a0,0x3
    1a7c:	4c050513          	addi	a0,a0,1216 # 4f38 <malloc+0xb9a>
    1a80:	00003097          	auipc	ra,0x3
    1a84:	860080e7          	jalr	-1952(ra) # 42e0 <printf>
    exit();
    1a88:	00002097          	auipc	ra,0x2
    1a8c:	4c0080e7          	jalr	1216(ra) # 3f48 <exit>
    printf("link non-existant succeeded! oops\n");
    1a90:	00003517          	auipc	a0,0x3
    1a94:	4c850513          	addi	a0,a0,1224 # 4f58 <malloc+0xbba>
    1a98:	00003097          	auipc	ra,0x3
    1a9c:	848080e7          	jalr	-1976(ra) # 42e0 <printf>
    exit();
    1aa0:	00002097          	auipc	ra,0x2
    1aa4:	4a8080e7          	jalr	1192(ra) # 3f48 <exit>
    printf("link . lf1 succeeded! oops\n");
    1aa8:	00003517          	auipc	a0,0x3
    1aac:	4e050513          	addi	a0,a0,1248 # 4f88 <malloc+0xbea>
    1ab0:	00003097          	auipc	ra,0x3
    1ab4:	830080e7          	jalr	-2000(ra) # 42e0 <printf>
    exit();
    1ab8:	00002097          	auipc	ra,0x2
    1abc:	490080e7          	jalr	1168(ra) # 3f48 <exit>

0000000000001ac0 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1ac0:	7119                	addi	sp,sp,-128
    1ac2:	fc86                	sd	ra,120(sp)
    1ac4:	f8a2                	sd	s0,112(sp)
    1ac6:	f4a6                	sd	s1,104(sp)
    1ac8:	f0ca                	sd	s2,96(sp)
    1aca:	ecce                	sd	s3,88(sp)
    1acc:	e8d2                	sd	s4,80(sp)
    1ace:	e4d6                	sd	s5,72(sp)
    1ad0:	0100                	addi	s0,sp,128
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  printf("concreate test\n");
    1ad2:	00003517          	auipc	a0,0x3
    1ad6:	4e650513          	addi	a0,a0,1254 # 4fb8 <malloc+0xc1a>
    1ada:	00003097          	auipc	ra,0x3
    1ade:	806080e7          	jalr	-2042(ra) # 42e0 <printf>
  file[0] = 'C';
    1ae2:	04300793          	li	a5,67
    1ae6:	faf40c23          	sb	a5,-72(s0)
  file[2] = '\0';
    1aea:	fa040d23          	sb	zero,-70(s0)
  for(i = 0; i < N; i++){
    1aee:	4481                	li	s1,0
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    1af0:	4a0d                	li	s4,3
    1af2:	4985                	li	s3,1
      link("C0", file);
    1af4:	00003a97          	auipc	s5,0x3
    1af8:	4d4a8a93          	addi	s5,s5,1236 # 4fc8 <malloc+0xc2a>
  for(i = 0; i < N; i++){
    1afc:	02800913          	li	s2,40
    1b00:	a441                	j	1d80 <concreate+0x2c0>
      link("C0", file);
    1b02:	fb840593          	addi	a1,s0,-72
    1b06:	8556                	mv	a0,s5
    1b08:	00002097          	auipc	ra,0x2
    1b0c:	4a0080e7          	jalr	1184(ra) # 3fa8 <link>
        printf("concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    }
    if(pid == 0)
    1b10:	a48d                	j	1d72 <concreate+0x2b2>
    } else if(pid == 0 && (i % 5) == 1){
    1b12:	4795                	li	a5,5
    1b14:	02f4e4bb          	remw	s1,s1,a5
    1b18:	4785                	li	a5,1
    1b1a:	02f48a63          	beq	s1,a5,1b4e <concreate+0x8e>
      fd = open(file, O_CREATE | O_RDWR);
    1b1e:	20200593          	li	a1,514
    1b22:	fb840513          	addi	a0,s0,-72
    1b26:	00002097          	auipc	ra,0x2
    1b2a:	462080e7          	jalr	1122(ra) # 3f88 <open>
      if(fd < 0){
    1b2e:	22055963          	bgez	a0,1d60 <concreate+0x2a0>
        printf("concreate create %s failed\n", file);
    1b32:	fb840593          	addi	a1,s0,-72
    1b36:	00003517          	auipc	a0,0x3
    1b3a:	49a50513          	addi	a0,a0,1178 # 4fd0 <malloc+0xc32>
    1b3e:	00002097          	auipc	ra,0x2
    1b42:	7a2080e7          	jalr	1954(ra) # 42e0 <printf>
        exit();
    1b46:	00002097          	auipc	ra,0x2
    1b4a:	402080e7          	jalr	1026(ra) # 3f48 <exit>
      link("C0", file);
    1b4e:	fb840593          	addi	a1,s0,-72
    1b52:	00003517          	auipc	a0,0x3
    1b56:	47650513          	addi	a0,a0,1142 # 4fc8 <malloc+0xc2a>
    1b5a:	00002097          	auipc	ra,0x2
    1b5e:	44e080e7          	jalr	1102(ra) # 3fa8 <link>
      exit();
    1b62:	00002097          	auipc	ra,0x2
    1b66:	3e6080e7          	jalr	998(ra) # 3f48 <exit>
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1b6a:	02800613          	li	a2,40
    1b6e:	4581                	li	a1,0
    1b70:	f9040513          	addi	a0,s0,-112
    1b74:	00002097          	auipc	ra,0x2
    1b78:	250080e7          	jalr	592(ra) # 3dc4 <memset>
  fd = open(".", 0);
    1b7c:	4581                	li	a1,0
    1b7e:	00003517          	auipc	a0,0x3
    1b82:	40250513          	addi	a0,a0,1026 # 4f80 <malloc+0xbe2>
    1b86:	00002097          	auipc	ra,0x2
    1b8a:	402080e7          	jalr	1026(ra) # 3f88 <open>
    1b8e:	84aa                	mv	s1,a0
  n = 0;
    1b90:	4981                	li	s3,0
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1b92:	04300913          	li	s2,67
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
    1b96:	02700a13          	li	s4,39
      }
      if(fa[i]){
        printf("concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    1b9a:	4a85                	li	s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    1b9c:	4641                	li	a2,16
    1b9e:	f8040593          	addi	a1,s0,-128
    1ba2:	8526                	mv	a0,s1
    1ba4:	00002097          	auipc	ra,0x2
    1ba8:	3bc080e7          	jalr	956(ra) # 3f60 <read>
    1bac:	06a05d63          	blez	a0,1c26 <concreate+0x166>
    if(de.inum == 0)
    1bb0:	f8045783          	lhu	a5,-128(s0)
    1bb4:	d7e5                	beqz	a5,1b9c <concreate+0xdc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1bb6:	f8244783          	lbu	a5,-126(s0)
    1bba:	ff2791e3          	bne	a5,s2,1b9c <concreate+0xdc>
    1bbe:	f8444783          	lbu	a5,-124(s0)
    1bc2:	ffe9                	bnez	a5,1b9c <concreate+0xdc>
      i = de.name[1] - '0';
    1bc4:	f8344783          	lbu	a5,-125(s0)
    1bc8:	fd07879b          	addiw	a5,a5,-48
    1bcc:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    1bd0:	00ea6f63          	bltu	s4,a4,1bee <concreate+0x12e>
      if(fa[i]){
    1bd4:	fc040793          	addi	a5,s0,-64
    1bd8:	97ba                	add	a5,a5,a4
    1bda:	fd07c783          	lbu	a5,-48(a5)
    1bde:	e795                	bnez	a5,1c0a <concreate+0x14a>
      fa[i] = 1;
    1be0:	fc040793          	addi	a5,s0,-64
    1be4:	973e                	add	a4,a4,a5
    1be6:	fd570823          	sb	s5,-48(a4)
      n++;
    1bea:	2985                	addiw	s3,s3,1
    1bec:	bf45                	j	1b9c <concreate+0xdc>
        printf("concreate weird file %s\n", de.name);
    1bee:	f8240593          	addi	a1,s0,-126
    1bf2:	00003517          	auipc	a0,0x3
    1bf6:	3fe50513          	addi	a0,a0,1022 # 4ff0 <malloc+0xc52>
    1bfa:	00002097          	auipc	ra,0x2
    1bfe:	6e6080e7          	jalr	1766(ra) # 42e0 <printf>
        exit();
    1c02:	00002097          	auipc	ra,0x2
    1c06:	346080e7          	jalr	838(ra) # 3f48 <exit>
        printf("concreate duplicate file %s\n", de.name);
    1c0a:	f8240593          	addi	a1,s0,-126
    1c0e:	00003517          	auipc	a0,0x3
    1c12:	40250513          	addi	a0,a0,1026 # 5010 <malloc+0xc72>
    1c16:	00002097          	auipc	ra,0x2
    1c1a:	6ca080e7          	jalr	1738(ra) # 42e0 <printf>
        exit();
    1c1e:	00002097          	auipc	ra,0x2
    1c22:	32a080e7          	jalr	810(ra) # 3f48 <exit>
    }
  }
  close(fd);
    1c26:	8526                	mv	a0,s1
    1c28:	00002097          	auipc	ra,0x2
    1c2c:	348080e7          	jalr	840(ra) # 3f70 <close>

  if(n != N){
    1c30:	02800793          	li	a5,40
    printf("concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < N; i++){
    1c34:	4901                	li	s2,0
  if(n != N){
    1c36:	00f99763          	bne	s3,a5,1c44 <concreate+0x184>
    pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1c3a:	4a0d                	li	s4,3
    1c3c:	4a85                	li	s5,1
  for(i = 0; i < N; i++){
    1c3e:	02800993          	li	s3,40
    1c42:	a869                	j	1cdc <concreate+0x21c>
    printf("concreate not enough files in directory listing\n");
    1c44:	00003517          	auipc	a0,0x3
    1c48:	3ec50513          	addi	a0,a0,1004 # 5030 <malloc+0xc92>
    1c4c:	00002097          	auipc	ra,0x2
    1c50:	694080e7          	jalr	1684(ra) # 42e0 <printf>
    exit();
    1c54:	00002097          	auipc	ra,0x2
    1c58:	2f4080e7          	jalr	756(ra) # 3f48 <exit>
      printf("fork failed\n");
    1c5c:	00003517          	auipc	a0,0x3
    1c60:	8f450513          	addi	a0,a0,-1804 # 4550 <malloc+0x1b2>
    1c64:	00002097          	auipc	ra,0x2
    1c68:	67c080e7          	jalr	1660(ra) # 42e0 <printf>
      exit();
    1c6c:	00002097          	auipc	ra,0x2
    1c70:	2dc080e7          	jalr	732(ra) # 3f48 <exit>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1c74:	4581                	li	a1,0
    1c76:	fb840513          	addi	a0,s0,-72
    1c7a:	00002097          	auipc	ra,0x2
    1c7e:	30e080e7          	jalr	782(ra) # 3f88 <open>
    1c82:	00002097          	auipc	ra,0x2
    1c86:	2ee080e7          	jalr	750(ra) # 3f70 <close>
      close(open(file, 0));
    1c8a:	4581                	li	a1,0
    1c8c:	fb840513          	addi	a0,s0,-72
    1c90:	00002097          	auipc	ra,0x2
    1c94:	2f8080e7          	jalr	760(ra) # 3f88 <open>
    1c98:	00002097          	auipc	ra,0x2
    1c9c:	2d8080e7          	jalr	728(ra) # 3f70 <close>
      close(open(file, 0));
    1ca0:	4581                	li	a1,0
    1ca2:	fb840513          	addi	a0,s0,-72
    1ca6:	00002097          	auipc	ra,0x2
    1caa:	2e2080e7          	jalr	738(ra) # 3f88 <open>
    1cae:	00002097          	auipc	ra,0x2
    1cb2:	2c2080e7          	jalr	706(ra) # 3f70 <close>
      close(open(file, 0));
    1cb6:	4581                	li	a1,0
    1cb8:	fb840513          	addi	a0,s0,-72
    1cbc:	00002097          	auipc	ra,0x2
    1cc0:	2cc080e7          	jalr	716(ra) # 3f88 <open>
    1cc4:	00002097          	auipc	ra,0x2
    1cc8:	2ac080e7          	jalr	684(ra) # 3f70 <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1ccc:	c4ad                	beqz	s1,1d36 <concreate+0x276>
      exit();
    else
      wait();
    1cce:	00002097          	auipc	ra,0x2
    1cd2:	282080e7          	jalr	642(ra) # 3f50 <wait>
  for(i = 0; i < N; i++){
    1cd6:	2905                	addiw	s2,s2,1
    1cd8:	07390363          	beq	s2,s3,1d3e <concreate+0x27e>
    file[1] = '0' + i;
    1cdc:	0309079b          	addiw	a5,s2,48
    1ce0:	faf40ca3          	sb	a5,-71(s0)
    pid = fork();
    1ce4:	00002097          	auipc	ra,0x2
    1ce8:	25c080e7          	jalr	604(ra) # 3f40 <fork>
    1cec:	84aa                	mv	s1,a0
    if(pid < 0){
    1cee:	f60547e3          	bltz	a0,1c5c <concreate+0x19c>
    if(((i % 3) == 0 && pid == 0) ||
    1cf2:	0349673b          	remw	a4,s2,s4
    1cf6:	00a767b3          	or	a5,a4,a0
    1cfa:	2781                	sext.w	a5,a5
    1cfc:	dfa5                	beqz	a5,1c74 <concreate+0x1b4>
    1cfe:	01571363          	bne	a4,s5,1d04 <concreate+0x244>
       ((i % 3) == 1 && pid != 0)){
    1d02:	f92d                	bnez	a0,1c74 <concreate+0x1b4>
      unlink(file);
    1d04:	fb840513          	addi	a0,s0,-72
    1d08:	00002097          	auipc	ra,0x2
    1d0c:	290080e7          	jalr	656(ra) # 3f98 <unlink>
      unlink(file);
    1d10:	fb840513          	addi	a0,s0,-72
    1d14:	00002097          	auipc	ra,0x2
    1d18:	284080e7          	jalr	644(ra) # 3f98 <unlink>
      unlink(file);
    1d1c:	fb840513          	addi	a0,s0,-72
    1d20:	00002097          	auipc	ra,0x2
    1d24:	278080e7          	jalr	632(ra) # 3f98 <unlink>
      unlink(file);
    1d28:	fb840513          	addi	a0,s0,-72
    1d2c:	00002097          	auipc	ra,0x2
    1d30:	26c080e7          	jalr	620(ra) # 3f98 <unlink>
    1d34:	bf61                	j	1ccc <concreate+0x20c>
      exit();
    1d36:	00002097          	auipc	ra,0x2
    1d3a:	212080e7          	jalr	530(ra) # 3f48 <exit>
  }

  printf("concreate ok\n");
    1d3e:	00003517          	auipc	a0,0x3
    1d42:	32a50513          	addi	a0,a0,810 # 5068 <malloc+0xcca>
    1d46:	00002097          	auipc	ra,0x2
    1d4a:	59a080e7          	jalr	1434(ra) # 42e0 <printf>
}
    1d4e:	70e6                	ld	ra,120(sp)
    1d50:	7446                	ld	s0,112(sp)
    1d52:	74a6                	ld	s1,104(sp)
    1d54:	7906                	ld	s2,96(sp)
    1d56:	69e6                	ld	s3,88(sp)
    1d58:	6a46                	ld	s4,80(sp)
    1d5a:	6aa6                	ld	s5,72(sp)
    1d5c:	6109                	addi	sp,sp,128
    1d5e:	8082                	ret
      close(fd);
    1d60:	00002097          	auipc	ra,0x2
    1d64:	210080e7          	jalr	528(ra) # 3f70 <close>
    if(pid == 0)
    1d68:	bbed                	j	1b62 <concreate+0xa2>
      close(fd);
    1d6a:	00002097          	auipc	ra,0x2
    1d6e:	206080e7          	jalr	518(ra) # 3f70 <close>
      wait();
    1d72:	00002097          	auipc	ra,0x2
    1d76:	1de080e7          	jalr	478(ra) # 3f50 <wait>
  for(i = 0; i < N; i++){
    1d7a:	2485                	addiw	s1,s1,1
    1d7c:	df2487e3          	beq	s1,s2,1b6a <concreate+0xaa>
    file[1] = '0' + i;
    1d80:	0304879b          	addiw	a5,s1,48
    1d84:	faf40ca3          	sb	a5,-71(s0)
    unlink(file);
    1d88:	fb840513          	addi	a0,s0,-72
    1d8c:	00002097          	auipc	ra,0x2
    1d90:	20c080e7          	jalr	524(ra) # 3f98 <unlink>
    pid = fork();
    1d94:	00002097          	auipc	ra,0x2
    1d98:	1ac080e7          	jalr	428(ra) # 3f40 <fork>
    if(pid && (i % 3) == 1){
    1d9c:	d6050be3          	beqz	a0,1b12 <concreate+0x52>
    1da0:	0344e7bb          	remw	a5,s1,s4
    1da4:	d5378fe3          	beq	a5,s3,1b02 <concreate+0x42>
      fd = open(file, O_CREATE | O_RDWR);
    1da8:	20200593          	li	a1,514
    1dac:	fb840513          	addi	a0,s0,-72
    1db0:	00002097          	auipc	ra,0x2
    1db4:	1d8080e7          	jalr	472(ra) # 3f88 <open>
      if(fd < 0){
    1db8:	fa0559e3          	bgez	a0,1d6a <concreate+0x2aa>
    1dbc:	bb9d                	j	1b32 <concreate+0x72>

0000000000001dbe <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1dbe:	711d                	addi	sp,sp,-96
    1dc0:	ec86                	sd	ra,88(sp)
    1dc2:	e8a2                	sd	s0,80(sp)
    1dc4:	e4a6                	sd	s1,72(sp)
    1dc6:	e0ca                	sd	s2,64(sp)
    1dc8:	fc4e                	sd	s3,56(sp)
    1dca:	f852                	sd	s4,48(sp)
    1dcc:	f456                	sd	s5,40(sp)
    1dce:	f05a                	sd	s6,32(sp)
    1dd0:	ec5e                	sd	s7,24(sp)
    1dd2:	e862                	sd	s8,16(sp)
    1dd4:	e466                	sd	s9,8(sp)
    1dd6:	1080                	addi	s0,sp,96
  int pid, i;

  printf("linkunlink test\n");
    1dd8:	00003517          	auipc	a0,0x3
    1ddc:	2a050513          	addi	a0,a0,672 # 5078 <malloc+0xcda>
    1de0:	00002097          	auipc	ra,0x2
    1de4:	500080e7          	jalr	1280(ra) # 42e0 <printf>

  unlink("x");
    1de8:	00003517          	auipc	a0,0x3
    1dec:	c7850513          	addi	a0,a0,-904 # 4a60 <malloc+0x6c2>
    1df0:	00002097          	auipc	ra,0x2
    1df4:	1a8080e7          	jalr	424(ra) # 3f98 <unlink>
  pid = fork();
    1df8:	00002097          	auipc	ra,0x2
    1dfc:	148080e7          	jalr	328(ra) # 3f40 <fork>
  if(pid < 0){
    1e00:	02054b63          	bltz	a0,1e36 <linkunlink+0x78>
    1e04:	8c2a                	mv	s8,a0
    printf("fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    1e06:	4c85                	li	s9,1
    1e08:	e119                	bnez	a0,1e0e <linkunlink+0x50>
    1e0a:	06100c93          	li	s9,97
    1e0e:	06400493          	li	s1,100
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    1e12:	41c659b7          	lui	s3,0x41c65
    1e16:	e6d9899b          	addiw	s3,s3,-403
    1e1a:	690d                	lui	s2,0x3
    1e1c:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e20:	4a0d                	li	s4,3
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
    1e22:	4b05                	li	s6,1
      link("cat", "x");
    } else {
      unlink("x");
    1e24:	00003a97          	auipc	s5,0x3
    1e28:	c3ca8a93          	addi	s5,s5,-964 # 4a60 <malloc+0x6c2>
      link("cat", "x");
    1e2c:	00003b97          	auipc	s7,0x3
    1e30:	264b8b93          	addi	s7,s7,612 # 5090 <malloc+0xcf2>
    1e34:	a081                	j	1e74 <linkunlink+0xb6>
    printf("fork failed\n");
    1e36:	00002517          	auipc	a0,0x2
    1e3a:	71a50513          	addi	a0,a0,1818 # 4550 <malloc+0x1b2>
    1e3e:	00002097          	auipc	ra,0x2
    1e42:	4a2080e7          	jalr	1186(ra) # 42e0 <printf>
    exit();
    1e46:	00002097          	auipc	ra,0x2
    1e4a:	102080e7          	jalr	258(ra) # 3f48 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e4e:	20200593          	li	a1,514
    1e52:	8556                	mv	a0,s5
    1e54:	00002097          	auipc	ra,0x2
    1e58:	134080e7          	jalr	308(ra) # 3f88 <open>
    1e5c:	00002097          	auipc	ra,0x2
    1e60:	114080e7          	jalr	276(ra) # 3f70 <close>
    1e64:	a031                	j	1e70 <linkunlink+0xb2>
      unlink("x");
    1e66:	8556                	mv	a0,s5
    1e68:	00002097          	auipc	ra,0x2
    1e6c:	130080e7          	jalr	304(ra) # 3f98 <unlink>
  for(i = 0; i < 100; i++){
    1e70:	34fd                	addiw	s1,s1,-1
    1e72:	c09d                	beqz	s1,1e98 <linkunlink+0xda>
    x = x * 1103515245 + 12345;
    1e74:	033c87bb          	mulw	a5,s9,s3
    1e78:	012787bb          	addw	a5,a5,s2
    1e7c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e80:	0347f7bb          	remuw	a5,a5,s4
    1e84:	d7e9                	beqz	a5,1e4e <linkunlink+0x90>
    } else if((x % 3) == 1){
    1e86:	ff6790e3          	bne	a5,s6,1e66 <linkunlink+0xa8>
      link("cat", "x");
    1e8a:	85d6                	mv	a1,s5
    1e8c:	855e                	mv	a0,s7
    1e8e:	00002097          	auipc	ra,0x2
    1e92:	11a080e7          	jalr	282(ra) # 3fa8 <link>
    1e96:	bfe9                	j	1e70 <linkunlink+0xb2>
    }
  }

  if(pid)
    1e98:	020c0b63          	beqz	s8,1ece <linkunlink+0x110>
    wait();
    1e9c:	00002097          	auipc	ra,0x2
    1ea0:	0b4080e7          	jalr	180(ra) # 3f50 <wait>
  else
    exit();

  printf("linkunlink ok\n");
    1ea4:	00003517          	auipc	a0,0x3
    1ea8:	1f450513          	addi	a0,a0,500 # 5098 <malloc+0xcfa>
    1eac:	00002097          	auipc	ra,0x2
    1eb0:	434080e7          	jalr	1076(ra) # 42e0 <printf>
}
    1eb4:	60e6                	ld	ra,88(sp)
    1eb6:	6446                	ld	s0,80(sp)
    1eb8:	64a6                	ld	s1,72(sp)
    1eba:	6906                	ld	s2,64(sp)
    1ebc:	79e2                	ld	s3,56(sp)
    1ebe:	7a42                	ld	s4,48(sp)
    1ec0:	7aa2                	ld	s5,40(sp)
    1ec2:	7b02                	ld	s6,32(sp)
    1ec4:	6be2                	ld	s7,24(sp)
    1ec6:	6c42                	ld	s8,16(sp)
    1ec8:	6ca2                	ld	s9,8(sp)
    1eca:	6125                	addi	sp,sp,96
    1ecc:	8082                	ret
    exit();
    1ece:	00002097          	auipc	ra,0x2
    1ed2:	07a080e7          	jalr	122(ra) # 3f48 <exit>

0000000000001ed6 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1ed6:	715d                	addi	sp,sp,-80
    1ed8:	e486                	sd	ra,72(sp)
    1eda:	e0a2                	sd	s0,64(sp)
    1edc:	fc26                	sd	s1,56(sp)
    1ede:	f84a                	sd	s2,48(sp)
    1ee0:	f44e                	sd	s3,40(sp)
    1ee2:	f052                	sd	s4,32(sp)
    1ee4:	ec56                	sd	s5,24(sp)
    1ee6:	0880                	addi	s0,sp,80
  enum { N = 500 };
  int i, fd;
  char name[10];

  printf("bigdir test\n");
    1ee8:	00003517          	auipc	a0,0x3
    1eec:	1c050513          	addi	a0,a0,448 # 50a8 <malloc+0xd0a>
    1ef0:	00002097          	auipc	ra,0x2
    1ef4:	3f0080e7          	jalr	1008(ra) # 42e0 <printf>
  unlink("bd");
    1ef8:	00003517          	auipc	a0,0x3
    1efc:	1c050513          	addi	a0,a0,448 # 50b8 <malloc+0xd1a>
    1f00:	00002097          	auipc	ra,0x2
    1f04:	098080e7          	jalr	152(ra) # 3f98 <unlink>

  fd = open("bd", O_CREATE);
    1f08:	20000593          	li	a1,512
    1f0c:	00003517          	auipc	a0,0x3
    1f10:	1ac50513          	addi	a0,a0,428 # 50b8 <malloc+0xd1a>
    1f14:	00002097          	auipc	ra,0x2
    1f18:	074080e7          	jalr	116(ra) # 3f88 <open>
  if(fd < 0){
    1f1c:	0e054063          	bltz	a0,1ffc <bigdir+0x126>
    printf("bigdir create failed\n");
    exit();
  }
  close(fd);
    1f20:	00002097          	auipc	ra,0x2
    1f24:	050080e7          	jalr	80(ra) # 3f70 <close>

  for(i = 0; i < N; i++){
    1f28:	4901                	li	s2,0
    name[0] = 'x';
    1f2a:	07800a13          	li	s4,120
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    1f2e:	00003997          	auipc	s3,0x3
    1f32:	18a98993          	addi	s3,s3,394 # 50b8 <malloc+0xd1a>
  for(i = 0; i < N; i++){
    1f36:	1f400a93          	li	s5,500
    name[0] = 'x';
    1f3a:	fb440823          	sb	s4,-80(s0)
    name[1] = '0' + (i / 64);
    1f3e:	41f9579b          	sraiw	a5,s2,0x1f
    1f42:	01a7d71b          	srliw	a4,a5,0x1a
    1f46:	012707bb          	addw	a5,a4,s2
    1f4a:	4067d69b          	sraiw	a3,a5,0x6
    1f4e:	0306869b          	addiw	a3,a3,48
    1f52:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1f56:	03f7f793          	andi	a5,a5,63
    1f5a:	9f99                	subw	a5,a5,a4
    1f5c:	0307879b          	addiw	a5,a5,48
    1f60:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1f64:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1f68:	fb040593          	addi	a1,s0,-80
    1f6c:	854e                	mv	a0,s3
    1f6e:	00002097          	auipc	ra,0x2
    1f72:	03a080e7          	jalr	58(ra) # 3fa8 <link>
    1f76:	84aa                	mv	s1,a0
    1f78:	ed51                	bnez	a0,2014 <bigdir+0x13e>
  for(i = 0; i < N; i++){
    1f7a:	2905                	addiw	s2,s2,1
    1f7c:	fb591fe3          	bne	s2,s5,1f3a <bigdir+0x64>
      printf("bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1f80:	00003517          	auipc	a0,0x3
    1f84:	13850513          	addi	a0,a0,312 # 50b8 <malloc+0xd1a>
    1f88:	00002097          	auipc	ra,0x2
    1f8c:	010080e7          	jalr	16(ra) # 3f98 <unlink>
  for(i = 0; i < N; i++){
    name[0] = 'x';
    1f90:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1f94:	1f400993          	li	s3,500
    name[0] = 'x';
    1f98:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1f9c:	41f4d79b          	sraiw	a5,s1,0x1f
    1fa0:	01a7d71b          	srliw	a4,a5,0x1a
    1fa4:	009707bb          	addw	a5,a4,s1
    1fa8:	4067d69b          	sraiw	a3,a5,0x6
    1fac:	0306869b          	addiw	a3,a3,48
    1fb0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1fb4:	03f7f793          	andi	a5,a5,63
    1fb8:	9f99                	subw	a5,a5,a4
    1fba:	0307879b          	addiw	a5,a5,48
    1fbe:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1fc2:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1fc6:	fb040513          	addi	a0,s0,-80
    1fca:	00002097          	auipc	ra,0x2
    1fce:	fce080e7          	jalr	-50(ra) # 3f98 <unlink>
    1fd2:	ed29                	bnez	a0,202c <bigdir+0x156>
  for(i = 0; i < N; i++){
    1fd4:	2485                	addiw	s1,s1,1
    1fd6:	fd3491e3          	bne	s1,s3,1f98 <bigdir+0xc2>
      printf("bigdir unlink failed");
      exit();
    }
  }

  printf("bigdir ok\n");
    1fda:	00003517          	auipc	a0,0x3
    1fde:	12e50513          	addi	a0,a0,302 # 5108 <malloc+0xd6a>
    1fe2:	00002097          	auipc	ra,0x2
    1fe6:	2fe080e7          	jalr	766(ra) # 42e0 <printf>
}
    1fea:	60a6                	ld	ra,72(sp)
    1fec:	6406                	ld	s0,64(sp)
    1fee:	74e2                	ld	s1,56(sp)
    1ff0:	7942                	ld	s2,48(sp)
    1ff2:	79a2                	ld	s3,40(sp)
    1ff4:	7a02                	ld	s4,32(sp)
    1ff6:	6ae2                	ld	s5,24(sp)
    1ff8:	6161                	addi	sp,sp,80
    1ffa:	8082                	ret
    printf("bigdir create failed\n");
    1ffc:	00003517          	auipc	a0,0x3
    2000:	0c450513          	addi	a0,a0,196 # 50c0 <malloc+0xd22>
    2004:	00002097          	auipc	ra,0x2
    2008:	2dc080e7          	jalr	732(ra) # 42e0 <printf>
    exit();
    200c:	00002097          	auipc	ra,0x2
    2010:	f3c080e7          	jalr	-196(ra) # 3f48 <exit>
      printf("bigdir link failed\n");
    2014:	00003517          	auipc	a0,0x3
    2018:	0c450513          	addi	a0,a0,196 # 50d8 <malloc+0xd3a>
    201c:	00002097          	auipc	ra,0x2
    2020:	2c4080e7          	jalr	708(ra) # 42e0 <printf>
      exit();
    2024:	00002097          	auipc	ra,0x2
    2028:	f24080e7          	jalr	-220(ra) # 3f48 <exit>
      printf("bigdir unlink failed");
    202c:	00003517          	auipc	a0,0x3
    2030:	0c450513          	addi	a0,a0,196 # 50f0 <malloc+0xd52>
    2034:	00002097          	auipc	ra,0x2
    2038:	2ac080e7          	jalr	684(ra) # 42e0 <printf>
      exit();
    203c:	00002097          	auipc	ra,0x2
    2040:	f0c080e7          	jalr	-244(ra) # 3f48 <exit>

0000000000002044 <subdir>:

void
subdir(void)
{
    2044:	1101                	addi	sp,sp,-32
    2046:	ec06                	sd	ra,24(sp)
    2048:	e822                	sd	s0,16(sp)
    204a:	e426                	sd	s1,8(sp)
    204c:	1000                	addi	s0,sp,32
  int fd, cc;

  printf("subdir test\n");
    204e:	00003517          	auipc	a0,0x3
    2052:	0ca50513          	addi	a0,a0,202 # 5118 <malloc+0xd7a>
    2056:	00002097          	auipc	ra,0x2
    205a:	28a080e7          	jalr	650(ra) # 42e0 <printf>

  unlink("ff");
    205e:	00003517          	auipc	a0,0x3
    2062:	1e250513          	addi	a0,a0,482 # 5240 <malloc+0xea2>
    2066:	00002097          	auipc	ra,0x2
    206a:	f32080e7          	jalr	-206(ra) # 3f98 <unlink>
  if(mkdir("dd") != 0){
    206e:	00003517          	auipc	a0,0x3
    2072:	0ba50513          	addi	a0,a0,186 # 5128 <malloc+0xd8a>
    2076:	00002097          	auipc	ra,0x2
    207a:	f3a080e7          	jalr	-198(ra) # 3fb0 <mkdir>
    207e:	38051d63          	bnez	a0,2418 <subdir+0x3d4>
    printf("subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2082:	20200593          	li	a1,514
    2086:	00003517          	auipc	a0,0x3
    208a:	0c250513          	addi	a0,a0,194 # 5148 <malloc+0xdaa>
    208e:	00002097          	auipc	ra,0x2
    2092:	efa080e7          	jalr	-262(ra) # 3f88 <open>
    2096:	84aa                	mv	s1,a0
  if(fd < 0){
    2098:	38054c63          	bltz	a0,2430 <subdir+0x3ec>
    printf("create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    209c:	4609                	li	a2,2
    209e:	00003597          	auipc	a1,0x3
    20a2:	1a258593          	addi	a1,a1,418 # 5240 <malloc+0xea2>
    20a6:	00002097          	auipc	ra,0x2
    20aa:	ec2080e7          	jalr	-318(ra) # 3f68 <write>
  close(fd);
    20ae:	8526                	mv	a0,s1
    20b0:	00002097          	auipc	ra,0x2
    20b4:	ec0080e7          	jalr	-320(ra) # 3f70 <close>

  if(unlink("dd") >= 0){
    20b8:	00003517          	auipc	a0,0x3
    20bc:	07050513          	addi	a0,a0,112 # 5128 <malloc+0xd8a>
    20c0:	00002097          	auipc	ra,0x2
    20c4:	ed8080e7          	jalr	-296(ra) # 3f98 <unlink>
    20c8:	38055063          	bgez	a0,2448 <subdir+0x404>
    printf("unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    20cc:	00003517          	auipc	a0,0x3
    20d0:	0c450513          	addi	a0,a0,196 # 5190 <malloc+0xdf2>
    20d4:	00002097          	auipc	ra,0x2
    20d8:	edc080e7          	jalr	-292(ra) # 3fb0 <mkdir>
    20dc:	38051263          	bnez	a0,2460 <subdir+0x41c>
    printf("subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    20e0:	20200593          	li	a1,514
    20e4:	00003517          	auipc	a0,0x3
    20e8:	0d450513          	addi	a0,a0,212 # 51b8 <malloc+0xe1a>
    20ec:	00002097          	auipc	ra,0x2
    20f0:	e9c080e7          	jalr	-356(ra) # 3f88 <open>
    20f4:	84aa                	mv	s1,a0
  if(fd < 0){
    20f6:	38054163          	bltz	a0,2478 <subdir+0x434>
    printf("create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    20fa:	4609                	li	a2,2
    20fc:	00003597          	auipc	a1,0x3
    2100:	0e458593          	addi	a1,a1,228 # 51e0 <malloc+0xe42>
    2104:	00002097          	auipc	ra,0x2
    2108:	e64080e7          	jalr	-412(ra) # 3f68 <write>
  close(fd);
    210c:	8526                	mv	a0,s1
    210e:	00002097          	auipc	ra,0x2
    2112:	e62080e7          	jalr	-414(ra) # 3f70 <close>

  fd = open("dd/dd/../ff", 0);
    2116:	4581                	li	a1,0
    2118:	00003517          	auipc	a0,0x3
    211c:	0d050513          	addi	a0,a0,208 # 51e8 <malloc+0xe4a>
    2120:	00002097          	auipc	ra,0x2
    2124:	e68080e7          	jalr	-408(ra) # 3f88 <open>
    2128:	84aa                	mv	s1,a0
  if(fd < 0){
    212a:	36054363          	bltz	a0,2490 <subdir+0x44c>
    printf("open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    212e:	660d                	lui	a2,0x3
    2130:	00007597          	auipc	a1,0x7
    2134:	94058593          	addi	a1,a1,-1728 # 8a70 <buf>
    2138:	00002097          	auipc	ra,0x2
    213c:	e28080e7          	jalr	-472(ra) # 3f60 <read>
  if(cc != 2 || buf[0] != 'f'){
    2140:	4789                	li	a5,2
    2142:	36f51363          	bne	a0,a5,24a8 <subdir+0x464>
    2146:	00007717          	auipc	a4,0x7
    214a:	92a74703          	lbu	a4,-1750(a4) # 8a70 <buf>
    214e:	06600793          	li	a5,102
    2152:	34f71b63          	bne	a4,a5,24a8 <subdir+0x464>
    printf("dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    2156:	8526                	mv	a0,s1
    2158:	00002097          	auipc	ra,0x2
    215c:	e18080e7          	jalr	-488(ra) # 3f70 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2160:	00003597          	auipc	a1,0x3
    2164:	0d858593          	addi	a1,a1,216 # 5238 <malloc+0xe9a>
    2168:	00003517          	auipc	a0,0x3
    216c:	05050513          	addi	a0,a0,80 # 51b8 <malloc+0xe1a>
    2170:	00002097          	auipc	ra,0x2
    2174:	e38080e7          	jalr	-456(ra) # 3fa8 <link>
    2178:	34051463          	bnez	a0,24c0 <subdir+0x47c>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    217c:	00003517          	auipc	a0,0x3
    2180:	03c50513          	addi	a0,a0,60 # 51b8 <malloc+0xe1a>
    2184:	00002097          	auipc	ra,0x2
    2188:	e14080e7          	jalr	-492(ra) # 3f98 <unlink>
    218c:	34051663          	bnez	a0,24d8 <subdir+0x494>
    printf("unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2190:	4581                	li	a1,0
    2192:	00003517          	auipc	a0,0x3
    2196:	02650513          	addi	a0,a0,38 # 51b8 <malloc+0xe1a>
    219a:	00002097          	auipc	ra,0x2
    219e:	dee080e7          	jalr	-530(ra) # 3f88 <open>
    21a2:	34055763          	bgez	a0,24f0 <subdir+0x4ac>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    21a6:	00003517          	auipc	a0,0x3
    21aa:	f8250513          	addi	a0,a0,-126 # 5128 <malloc+0xd8a>
    21ae:	00002097          	auipc	ra,0x2
    21b2:	e0a080e7          	jalr	-502(ra) # 3fb8 <chdir>
    21b6:	34051963          	bnez	a0,2508 <subdir+0x4c4>
    printf("chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    21ba:	00003517          	auipc	a0,0x3
    21be:	10e50513          	addi	a0,a0,270 # 52c8 <malloc+0xf2a>
    21c2:	00002097          	auipc	ra,0x2
    21c6:	df6080e7          	jalr	-522(ra) # 3fb8 <chdir>
    21ca:	34051b63          	bnez	a0,2520 <subdir+0x4dc>
    printf("chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    21ce:	00003517          	auipc	a0,0x3
    21d2:	12a50513          	addi	a0,a0,298 # 52f8 <malloc+0xf5a>
    21d6:	00002097          	auipc	ra,0x2
    21da:	de2080e7          	jalr	-542(ra) # 3fb8 <chdir>
    21de:	34051d63          	bnez	a0,2538 <subdir+0x4f4>
    printf("chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    21e2:	00003517          	auipc	a0,0x3
    21e6:	12650513          	addi	a0,a0,294 # 5308 <malloc+0xf6a>
    21ea:	00002097          	auipc	ra,0x2
    21ee:	dce080e7          	jalr	-562(ra) # 3fb8 <chdir>
    21f2:	34051f63          	bnez	a0,2550 <subdir+0x50c>
    printf("chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    21f6:	4581                	li	a1,0
    21f8:	00003517          	auipc	a0,0x3
    21fc:	04050513          	addi	a0,a0,64 # 5238 <malloc+0xe9a>
    2200:	00002097          	auipc	ra,0x2
    2204:	d88080e7          	jalr	-632(ra) # 3f88 <open>
    2208:	84aa                	mv	s1,a0
  if(fd < 0){
    220a:	34054f63          	bltz	a0,2568 <subdir+0x524>
    printf("open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    220e:	660d                	lui	a2,0x3
    2210:	00007597          	auipc	a1,0x7
    2214:	86058593          	addi	a1,a1,-1952 # 8a70 <buf>
    2218:	00002097          	auipc	ra,0x2
    221c:	d48080e7          	jalr	-696(ra) # 3f60 <read>
    2220:	4789                	li	a5,2
    2222:	34f51f63          	bne	a0,a5,2580 <subdir+0x53c>
    printf("read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    2226:	8526                	mv	a0,s1
    2228:	00002097          	auipc	ra,0x2
    222c:	d48080e7          	jalr	-696(ra) # 3f70 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2230:	4581                	li	a1,0
    2232:	00003517          	auipc	a0,0x3
    2236:	f8650513          	addi	a0,a0,-122 # 51b8 <malloc+0xe1a>
    223a:	00002097          	auipc	ra,0x2
    223e:	d4e080e7          	jalr	-690(ra) # 3f88 <open>
    2242:	34055b63          	bgez	a0,2598 <subdir+0x554>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2246:	20200593          	li	a1,514
    224a:	00003517          	auipc	a0,0x3
    224e:	13e50513          	addi	a0,a0,318 # 5388 <malloc+0xfea>
    2252:	00002097          	auipc	ra,0x2
    2256:	d36080e7          	jalr	-714(ra) # 3f88 <open>
    225a:	34055b63          	bgez	a0,25b0 <subdir+0x56c>
    printf("create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    225e:	20200593          	li	a1,514
    2262:	00003517          	auipc	a0,0x3
    2266:	15650513          	addi	a0,a0,342 # 53b8 <malloc+0x101a>
    226a:	00002097          	auipc	ra,0x2
    226e:	d1e080e7          	jalr	-738(ra) # 3f88 <open>
    2272:	34055b63          	bgez	a0,25c8 <subdir+0x584>
    printf("create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    2276:	20000593          	li	a1,512
    227a:	00003517          	auipc	a0,0x3
    227e:	eae50513          	addi	a0,a0,-338 # 5128 <malloc+0xd8a>
    2282:	00002097          	auipc	ra,0x2
    2286:	d06080e7          	jalr	-762(ra) # 3f88 <open>
    228a:	34055b63          	bgez	a0,25e0 <subdir+0x59c>
    printf("create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    228e:	4589                	li	a1,2
    2290:	00003517          	auipc	a0,0x3
    2294:	e9850513          	addi	a0,a0,-360 # 5128 <malloc+0xd8a>
    2298:	00002097          	auipc	ra,0x2
    229c:	cf0080e7          	jalr	-784(ra) # 3f88 <open>
    22a0:	34055c63          	bgez	a0,25f8 <subdir+0x5b4>
    printf("open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    22a4:	4585                	li	a1,1
    22a6:	00003517          	auipc	a0,0x3
    22aa:	e8250513          	addi	a0,a0,-382 # 5128 <malloc+0xd8a>
    22ae:	00002097          	auipc	ra,0x2
    22b2:	cda080e7          	jalr	-806(ra) # 3f88 <open>
    22b6:	34055d63          	bgez	a0,2610 <subdir+0x5cc>
    printf("open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    22ba:	00003597          	auipc	a1,0x3
    22be:	18658593          	addi	a1,a1,390 # 5440 <malloc+0x10a2>
    22c2:	00003517          	auipc	a0,0x3
    22c6:	0c650513          	addi	a0,a0,198 # 5388 <malloc+0xfea>
    22ca:	00002097          	auipc	ra,0x2
    22ce:	cde080e7          	jalr	-802(ra) # 3fa8 <link>
    22d2:	34050b63          	beqz	a0,2628 <subdir+0x5e4>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    22d6:	00003597          	auipc	a1,0x3
    22da:	16a58593          	addi	a1,a1,362 # 5440 <malloc+0x10a2>
    22de:	00003517          	auipc	a0,0x3
    22e2:	0da50513          	addi	a0,a0,218 # 53b8 <malloc+0x101a>
    22e6:	00002097          	auipc	ra,0x2
    22ea:	cc2080e7          	jalr	-830(ra) # 3fa8 <link>
    22ee:	34050963          	beqz	a0,2640 <subdir+0x5fc>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    22f2:	00003597          	auipc	a1,0x3
    22f6:	f4658593          	addi	a1,a1,-186 # 5238 <malloc+0xe9a>
    22fa:	00003517          	auipc	a0,0x3
    22fe:	e4e50513          	addi	a0,a0,-434 # 5148 <malloc+0xdaa>
    2302:	00002097          	auipc	ra,0x2
    2306:	ca6080e7          	jalr	-858(ra) # 3fa8 <link>
    230a:	34050763          	beqz	a0,2658 <subdir+0x614>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    230e:	00003517          	auipc	a0,0x3
    2312:	07a50513          	addi	a0,a0,122 # 5388 <malloc+0xfea>
    2316:	00002097          	auipc	ra,0x2
    231a:	c9a080e7          	jalr	-870(ra) # 3fb0 <mkdir>
    231e:	34050963          	beqz	a0,2670 <subdir+0x62c>
    printf("mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    2322:	00003517          	auipc	a0,0x3
    2326:	09650513          	addi	a0,a0,150 # 53b8 <malloc+0x101a>
    232a:	00002097          	auipc	ra,0x2
    232e:	c86080e7          	jalr	-890(ra) # 3fb0 <mkdir>
    2332:	34050b63          	beqz	a0,2688 <subdir+0x644>
    printf("mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    2336:	00003517          	auipc	a0,0x3
    233a:	f0250513          	addi	a0,a0,-254 # 5238 <malloc+0xe9a>
    233e:	00002097          	auipc	ra,0x2
    2342:	c72080e7          	jalr	-910(ra) # 3fb0 <mkdir>
    2346:	34050d63          	beqz	a0,26a0 <subdir+0x65c>
    printf("mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    234a:	00003517          	auipc	a0,0x3
    234e:	06e50513          	addi	a0,a0,110 # 53b8 <malloc+0x101a>
    2352:	00002097          	auipc	ra,0x2
    2356:	c46080e7          	jalr	-954(ra) # 3f98 <unlink>
    235a:	34050f63          	beqz	a0,26b8 <subdir+0x674>
    printf("unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    235e:	00003517          	auipc	a0,0x3
    2362:	02a50513          	addi	a0,a0,42 # 5388 <malloc+0xfea>
    2366:	00002097          	auipc	ra,0x2
    236a:	c32080e7          	jalr	-974(ra) # 3f98 <unlink>
    236e:	36050163          	beqz	a0,26d0 <subdir+0x68c>
    printf("unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    2372:	00003517          	auipc	a0,0x3
    2376:	dd650513          	addi	a0,a0,-554 # 5148 <malloc+0xdaa>
    237a:	00002097          	auipc	ra,0x2
    237e:	c3e080e7          	jalr	-962(ra) # 3fb8 <chdir>
    2382:	36050363          	beqz	a0,26e8 <subdir+0x6a4>
    printf("chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    2386:	00003517          	auipc	a0,0x3
    238a:	1fa50513          	addi	a0,a0,506 # 5580 <malloc+0x11e2>
    238e:	00002097          	auipc	ra,0x2
    2392:	c2a080e7          	jalr	-982(ra) # 3fb8 <chdir>
    2396:	36050563          	beqz	a0,2700 <subdir+0x6bc>
    printf("chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    239a:	00003517          	auipc	a0,0x3
    239e:	e9e50513          	addi	a0,a0,-354 # 5238 <malloc+0xe9a>
    23a2:	00002097          	auipc	ra,0x2
    23a6:	bf6080e7          	jalr	-1034(ra) # 3f98 <unlink>
    23aa:	36051763          	bnez	a0,2718 <subdir+0x6d4>
    printf("unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    23ae:	00003517          	auipc	a0,0x3
    23b2:	d9a50513          	addi	a0,a0,-614 # 5148 <malloc+0xdaa>
    23b6:	00002097          	auipc	ra,0x2
    23ba:	be2080e7          	jalr	-1054(ra) # 3f98 <unlink>
    23be:	36051963          	bnez	a0,2730 <subdir+0x6ec>
    printf("unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    23c2:	00003517          	auipc	a0,0x3
    23c6:	d6650513          	addi	a0,a0,-666 # 5128 <malloc+0xd8a>
    23ca:	00002097          	auipc	ra,0x2
    23ce:	bce080e7          	jalr	-1074(ra) # 3f98 <unlink>
    23d2:	36050b63          	beqz	a0,2748 <subdir+0x704>
    printf("unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    23d6:	00003517          	auipc	a0,0x3
    23da:	20250513          	addi	a0,a0,514 # 55d8 <malloc+0x123a>
    23de:	00002097          	auipc	ra,0x2
    23e2:	bba080e7          	jalr	-1094(ra) # 3f98 <unlink>
    23e6:	36054d63          	bltz	a0,2760 <subdir+0x71c>
    printf("unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    23ea:	00003517          	auipc	a0,0x3
    23ee:	d3e50513          	addi	a0,a0,-706 # 5128 <malloc+0xd8a>
    23f2:	00002097          	auipc	ra,0x2
    23f6:	ba6080e7          	jalr	-1114(ra) # 3f98 <unlink>
    23fa:	36054f63          	bltz	a0,2778 <subdir+0x734>
    printf("unlink dd failed\n");
    exit();
  }

  printf("subdir ok\n");
    23fe:	00003517          	auipc	a0,0x3
    2402:	21250513          	addi	a0,a0,530 # 5610 <malloc+0x1272>
    2406:	00002097          	auipc	ra,0x2
    240a:	eda080e7          	jalr	-294(ra) # 42e0 <printf>
}
    240e:	60e2                	ld	ra,24(sp)
    2410:	6442                	ld	s0,16(sp)
    2412:	64a2                	ld	s1,8(sp)
    2414:	6105                	addi	sp,sp,32
    2416:	8082                	ret
    printf("subdir mkdir dd failed\n");
    2418:	00003517          	auipc	a0,0x3
    241c:	d1850513          	addi	a0,a0,-744 # 5130 <malloc+0xd92>
    2420:	00002097          	auipc	ra,0x2
    2424:	ec0080e7          	jalr	-320(ra) # 42e0 <printf>
    exit();
    2428:	00002097          	auipc	ra,0x2
    242c:	b20080e7          	jalr	-1248(ra) # 3f48 <exit>
    printf("create dd/ff failed\n");
    2430:	00003517          	auipc	a0,0x3
    2434:	d2050513          	addi	a0,a0,-736 # 5150 <malloc+0xdb2>
    2438:	00002097          	auipc	ra,0x2
    243c:	ea8080e7          	jalr	-344(ra) # 42e0 <printf>
    exit();
    2440:	00002097          	auipc	ra,0x2
    2444:	b08080e7          	jalr	-1272(ra) # 3f48 <exit>
    printf("unlink dd (non-empty dir) succeeded!\n");
    2448:	00003517          	auipc	a0,0x3
    244c:	d2050513          	addi	a0,a0,-736 # 5168 <malloc+0xdca>
    2450:	00002097          	auipc	ra,0x2
    2454:	e90080e7          	jalr	-368(ra) # 42e0 <printf>
    exit();
    2458:	00002097          	auipc	ra,0x2
    245c:	af0080e7          	jalr	-1296(ra) # 3f48 <exit>
    printf("subdir mkdir dd/dd failed\n");
    2460:	00003517          	auipc	a0,0x3
    2464:	d3850513          	addi	a0,a0,-712 # 5198 <malloc+0xdfa>
    2468:	00002097          	auipc	ra,0x2
    246c:	e78080e7          	jalr	-392(ra) # 42e0 <printf>
    exit();
    2470:	00002097          	auipc	ra,0x2
    2474:	ad8080e7          	jalr	-1320(ra) # 3f48 <exit>
    printf("create dd/dd/ff failed\n");
    2478:	00003517          	auipc	a0,0x3
    247c:	d5050513          	addi	a0,a0,-688 # 51c8 <malloc+0xe2a>
    2480:	00002097          	auipc	ra,0x2
    2484:	e60080e7          	jalr	-416(ra) # 42e0 <printf>
    exit();
    2488:	00002097          	auipc	ra,0x2
    248c:	ac0080e7          	jalr	-1344(ra) # 3f48 <exit>
    printf("open dd/dd/../ff failed\n");
    2490:	00003517          	auipc	a0,0x3
    2494:	d6850513          	addi	a0,a0,-664 # 51f8 <malloc+0xe5a>
    2498:	00002097          	auipc	ra,0x2
    249c:	e48080e7          	jalr	-440(ra) # 42e0 <printf>
    exit();
    24a0:	00002097          	auipc	ra,0x2
    24a4:	aa8080e7          	jalr	-1368(ra) # 3f48 <exit>
    printf("dd/dd/../ff wrong content\n");
    24a8:	00003517          	auipc	a0,0x3
    24ac:	d7050513          	addi	a0,a0,-656 # 5218 <malloc+0xe7a>
    24b0:	00002097          	auipc	ra,0x2
    24b4:	e30080e7          	jalr	-464(ra) # 42e0 <printf>
    exit();
    24b8:	00002097          	auipc	ra,0x2
    24bc:	a90080e7          	jalr	-1392(ra) # 3f48 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    24c0:	00003517          	auipc	a0,0x3
    24c4:	d8850513          	addi	a0,a0,-632 # 5248 <malloc+0xeaa>
    24c8:	00002097          	auipc	ra,0x2
    24cc:	e18080e7          	jalr	-488(ra) # 42e0 <printf>
    exit();
    24d0:	00002097          	auipc	ra,0x2
    24d4:	a78080e7          	jalr	-1416(ra) # 3f48 <exit>
    printf("unlink dd/dd/ff failed\n");
    24d8:	00003517          	auipc	a0,0x3
    24dc:	d9850513          	addi	a0,a0,-616 # 5270 <malloc+0xed2>
    24e0:	00002097          	auipc	ra,0x2
    24e4:	e00080e7          	jalr	-512(ra) # 42e0 <printf>
    exit();
    24e8:	00002097          	auipc	ra,0x2
    24ec:	a60080e7          	jalr	-1440(ra) # 3f48 <exit>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    24f0:	00003517          	auipc	a0,0x3
    24f4:	d9850513          	addi	a0,a0,-616 # 5288 <malloc+0xeea>
    24f8:	00002097          	auipc	ra,0x2
    24fc:	de8080e7          	jalr	-536(ra) # 42e0 <printf>
    exit();
    2500:	00002097          	auipc	ra,0x2
    2504:	a48080e7          	jalr	-1464(ra) # 3f48 <exit>
    printf("chdir dd failed\n");
    2508:	00003517          	auipc	a0,0x3
    250c:	da850513          	addi	a0,a0,-600 # 52b0 <malloc+0xf12>
    2510:	00002097          	auipc	ra,0x2
    2514:	dd0080e7          	jalr	-560(ra) # 42e0 <printf>
    exit();
    2518:	00002097          	auipc	ra,0x2
    251c:	a30080e7          	jalr	-1488(ra) # 3f48 <exit>
    printf("chdir dd/../../dd failed\n");
    2520:	00003517          	auipc	a0,0x3
    2524:	db850513          	addi	a0,a0,-584 # 52d8 <malloc+0xf3a>
    2528:	00002097          	auipc	ra,0x2
    252c:	db8080e7          	jalr	-584(ra) # 42e0 <printf>
    exit();
    2530:	00002097          	auipc	ra,0x2
    2534:	a18080e7          	jalr	-1512(ra) # 3f48 <exit>
    printf("chdir dd/../../dd failed\n");
    2538:	00003517          	auipc	a0,0x3
    253c:	da050513          	addi	a0,a0,-608 # 52d8 <malloc+0xf3a>
    2540:	00002097          	auipc	ra,0x2
    2544:	da0080e7          	jalr	-608(ra) # 42e0 <printf>
    exit();
    2548:	00002097          	auipc	ra,0x2
    254c:	a00080e7          	jalr	-1536(ra) # 3f48 <exit>
    printf("chdir ./.. failed\n");
    2550:	00003517          	auipc	a0,0x3
    2554:	dc050513          	addi	a0,a0,-576 # 5310 <malloc+0xf72>
    2558:	00002097          	auipc	ra,0x2
    255c:	d88080e7          	jalr	-632(ra) # 42e0 <printf>
    exit();
    2560:	00002097          	auipc	ra,0x2
    2564:	9e8080e7          	jalr	-1560(ra) # 3f48 <exit>
    printf("open dd/dd/ffff failed\n");
    2568:	00003517          	auipc	a0,0x3
    256c:	dc050513          	addi	a0,a0,-576 # 5328 <malloc+0xf8a>
    2570:	00002097          	auipc	ra,0x2
    2574:	d70080e7          	jalr	-656(ra) # 42e0 <printf>
    exit();
    2578:	00002097          	auipc	ra,0x2
    257c:	9d0080e7          	jalr	-1584(ra) # 3f48 <exit>
    printf("read dd/dd/ffff wrong len\n");
    2580:	00003517          	auipc	a0,0x3
    2584:	dc050513          	addi	a0,a0,-576 # 5340 <malloc+0xfa2>
    2588:	00002097          	auipc	ra,0x2
    258c:	d58080e7          	jalr	-680(ra) # 42e0 <printf>
    exit();
    2590:	00002097          	auipc	ra,0x2
    2594:	9b8080e7          	jalr	-1608(ra) # 3f48 <exit>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    2598:	00003517          	auipc	a0,0x3
    259c:	dc850513          	addi	a0,a0,-568 # 5360 <malloc+0xfc2>
    25a0:	00002097          	auipc	ra,0x2
    25a4:	d40080e7          	jalr	-704(ra) # 42e0 <printf>
    exit();
    25a8:	00002097          	auipc	ra,0x2
    25ac:	9a0080e7          	jalr	-1632(ra) # 3f48 <exit>
    printf("create dd/ff/ff succeeded!\n");
    25b0:	00003517          	auipc	a0,0x3
    25b4:	de850513          	addi	a0,a0,-536 # 5398 <malloc+0xffa>
    25b8:	00002097          	auipc	ra,0x2
    25bc:	d28080e7          	jalr	-728(ra) # 42e0 <printf>
    exit();
    25c0:	00002097          	auipc	ra,0x2
    25c4:	988080e7          	jalr	-1656(ra) # 3f48 <exit>
    printf("create dd/xx/ff succeeded!\n");
    25c8:	00003517          	auipc	a0,0x3
    25cc:	e0050513          	addi	a0,a0,-512 # 53c8 <malloc+0x102a>
    25d0:	00002097          	auipc	ra,0x2
    25d4:	d10080e7          	jalr	-752(ra) # 42e0 <printf>
    exit();
    25d8:	00002097          	auipc	ra,0x2
    25dc:	970080e7          	jalr	-1680(ra) # 3f48 <exit>
    printf("create dd succeeded!\n");
    25e0:	00003517          	auipc	a0,0x3
    25e4:	e0850513          	addi	a0,a0,-504 # 53e8 <malloc+0x104a>
    25e8:	00002097          	auipc	ra,0x2
    25ec:	cf8080e7          	jalr	-776(ra) # 42e0 <printf>
    exit();
    25f0:	00002097          	auipc	ra,0x2
    25f4:	958080e7          	jalr	-1704(ra) # 3f48 <exit>
    printf("open dd rdwr succeeded!\n");
    25f8:	00003517          	auipc	a0,0x3
    25fc:	e0850513          	addi	a0,a0,-504 # 5400 <malloc+0x1062>
    2600:	00002097          	auipc	ra,0x2
    2604:	ce0080e7          	jalr	-800(ra) # 42e0 <printf>
    exit();
    2608:	00002097          	auipc	ra,0x2
    260c:	940080e7          	jalr	-1728(ra) # 3f48 <exit>
    printf("open dd wronly succeeded!\n");
    2610:	00003517          	auipc	a0,0x3
    2614:	e1050513          	addi	a0,a0,-496 # 5420 <malloc+0x1082>
    2618:	00002097          	auipc	ra,0x2
    261c:	cc8080e7          	jalr	-824(ra) # 42e0 <printf>
    exit();
    2620:	00002097          	auipc	ra,0x2
    2624:	928080e7          	jalr	-1752(ra) # 3f48 <exit>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    2628:	00003517          	auipc	a0,0x3
    262c:	e2850513          	addi	a0,a0,-472 # 5450 <malloc+0x10b2>
    2630:	00002097          	auipc	ra,0x2
    2634:	cb0080e7          	jalr	-848(ra) # 42e0 <printf>
    exit();
    2638:	00002097          	auipc	ra,0x2
    263c:	910080e7          	jalr	-1776(ra) # 3f48 <exit>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    2640:	00003517          	auipc	a0,0x3
    2644:	e3850513          	addi	a0,a0,-456 # 5478 <malloc+0x10da>
    2648:	00002097          	auipc	ra,0x2
    264c:	c98080e7          	jalr	-872(ra) # 42e0 <printf>
    exit();
    2650:	00002097          	auipc	ra,0x2
    2654:	8f8080e7          	jalr	-1800(ra) # 3f48 <exit>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    2658:	00003517          	auipc	a0,0x3
    265c:	e4850513          	addi	a0,a0,-440 # 54a0 <malloc+0x1102>
    2660:	00002097          	auipc	ra,0x2
    2664:	c80080e7          	jalr	-896(ra) # 42e0 <printf>
    exit();
    2668:	00002097          	auipc	ra,0x2
    266c:	8e0080e7          	jalr	-1824(ra) # 3f48 <exit>
    printf("mkdir dd/ff/ff succeeded!\n");
    2670:	00003517          	auipc	a0,0x3
    2674:	e5850513          	addi	a0,a0,-424 # 54c8 <malloc+0x112a>
    2678:	00002097          	auipc	ra,0x2
    267c:	c68080e7          	jalr	-920(ra) # 42e0 <printf>
    exit();
    2680:	00002097          	auipc	ra,0x2
    2684:	8c8080e7          	jalr	-1848(ra) # 3f48 <exit>
    printf("mkdir dd/xx/ff succeeded!\n");
    2688:	00003517          	auipc	a0,0x3
    268c:	e6050513          	addi	a0,a0,-416 # 54e8 <malloc+0x114a>
    2690:	00002097          	auipc	ra,0x2
    2694:	c50080e7          	jalr	-944(ra) # 42e0 <printf>
    exit();
    2698:	00002097          	auipc	ra,0x2
    269c:	8b0080e7          	jalr	-1872(ra) # 3f48 <exit>
    printf("mkdir dd/dd/ffff succeeded!\n");
    26a0:	00003517          	auipc	a0,0x3
    26a4:	e6850513          	addi	a0,a0,-408 # 5508 <malloc+0x116a>
    26a8:	00002097          	auipc	ra,0x2
    26ac:	c38080e7          	jalr	-968(ra) # 42e0 <printf>
    exit();
    26b0:	00002097          	auipc	ra,0x2
    26b4:	898080e7          	jalr	-1896(ra) # 3f48 <exit>
    printf("unlink dd/xx/ff succeeded!\n");
    26b8:	00003517          	auipc	a0,0x3
    26bc:	e7050513          	addi	a0,a0,-400 # 5528 <malloc+0x118a>
    26c0:	00002097          	auipc	ra,0x2
    26c4:	c20080e7          	jalr	-992(ra) # 42e0 <printf>
    exit();
    26c8:	00002097          	auipc	ra,0x2
    26cc:	880080e7          	jalr	-1920(ra) # 3f48 <exit>
    printf("unlink dd/ff/ff succeeded!\n");
    26d0:	00003517          	auipc	a0,0x3
    26d4:	e7850513          	addi	a0,a0,-392 # 5548 <malloc+0x11aa>
    26d8:	00002097          	auipc	ra,0x2
    26dc:	c08080e7          	jalr	-1016(ra) # 42e0 <printf>
    exit();
    26e0:	00002097          	auipc	ra,0x2
    26e4:	868080e7          	jalr	-1944(ra) # 3f48 <exit>
    printf("chdir dd/ff succeeded!\n");
    26e8:	00003517          	auipc	a0,0x3
    26ec:	e8050513          	addi	a0,a0,-384 # 5568 <malloc+0x11ca>
    26f0:	00002097          	auipc	ra,0x2
    26f4:	bf0080e7          	jalr	-1040(ra) # 42e0 <printf>
    exit();
    26f8:	00002097          	auipc	ra,0x2
    26fc:	850080e7          	jalr	-1968(ra) # 3f48 <exit>
    printf("chdir dd/xx succeeded!\n");
    2700:	00003517          	auipc	a0,0x3
    2704:	e8850513          	addi	a0,a0,-376 # 5588 <malloc+0x11ea>
    2708:	00002097          	auipc	ra,0x2
    270c:	bd8080e7          	jalr	-1064(ra) # 42e0 <printf>
    exit();
    2710:	00002097          	auipc	ra,0x2
    2714:	838080e7          	jalr	-1992(ra) # 3f48 <exit>
    printf("unlink dd/dd/ff failed\n");
    2718:	00003517          	auipc	a0,0x3
    271c:	b5850513          	addi	a0,a0,-1192 # 5270 <malloc+0xed2>
    2720:	00002097          	auipc	ra,0x2
    2724:	bc0080e7          	jalr	-1088(ra) # 42e0 <printf>
    exit();
    2728:	00002097          	auipc	ra,0x2
    272c:	820080e7          	jalr	-2016(ra) # 3f48 <exit>
    printf("unlink dd/ff failed\n");
    2730:	00003517          	auipc	a0,0x3
    2734:	e7050513          	addi	a0,a0,-400 # 55a0 <malloc+0x1202>
    2738:	00002097          	auipc	ra,0x2
    273c:	ba8080e7          	jalr	-1112(ra) # 42e0 <printf>
    exit();
    2740:	00002097          	auipc	ra,0x2
    2744:	808080e7          	jalr	-2040(ra) # 3f48 <exit>
    printf("unlink non-empty dd succeeded!\n");
    2748:	00003517          	auipc	a0,0x3
    274c:	e7050513          	addi	a0,a0,-400 # 55b8 <malloc+0x121a>
    2750:	00002097          	auipc	ra,0x2
    2754:	b90080e7          	jalr	-1136(ra) # 42e0 <printf>
    exit();
    2758:	00001097          	auipc	ra,0x1
    275c:	7f0080e7          	jalr	2032(ra) # 3f48 <exit>
    printf("unlink dd/dd failed\n");
    2760:	00003517          	auipc	a0,0x3
    2764:	e8050513          	addi	a0,a0,-384 # 55e0 <malloc+0x1242>
    2768:	00002097          	auipc	ra,0x2
    276c:	b78080e7          	jalr	-1160(ra) # 42e0 <printf>
    exit();
    2770:	00001097          	auipc	ra,0x1
    2774:	7d8080e7          	jalr	2008(ra) # 3f48 <exit>
    printf("unlink dd failed\n");
    2778:	00003517          	auipc	a0,0x3
    277c:	e8050513          	addi	a0,a0,-384 # 55f8 <malloc+0x125a>
    2780:	00002097          	auipc	ra,0x2
    2784:	b60080e7          	jalr	-1184(ra) # 42e0 <printf>
    exit();
    2788:	00001097          	auipc	ra,0x1
    278c:	7c0080e7          	jalr	1984(ra) # 3f48 <exit>

0000000000002790 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2790:	7139                	addi	sp,sp,-64
    2792:	fc06                	sd	ra,56(sp)
    2794:	f822                	sd	s0,48(sp)
    2796:	f426                	sd	s1,40(sp)
    2798:	f04a                	sd	s2,32(sp)
    279a:	ec4e                	sd	s3,24(sp)
    279c:	e852                	sd	s4,16(sp)
    279e:	e456                	sd	s5,8(sp)
    27a0:	e05a                	sd	s6,0(sp)
    27a2:	0080                	addi	s0,sp,64
  int fd, sz;

  printf("bigwrite test\n");
    27a4:	00003517          	auipc	a0,0x3
    27a8:	e7c50513          	addi	a0,a0,-388 # 5620 <malloc+0x1282>
    27ac:	00002097          	auipc	ra,0x2
    27b0:	b34080e7          	jalr	-1228(ra) # 42e0 <printf>

  unlink("bigwrite");
    27b4:	00003517          	auipc	a0,0x3
    27b8:	e7c50513          	addi	a0,a0,-388 # 5630 <malloc+0x1292>
    27bc:	00001097          	auipc	ra,0x1
    27c0:	7dc080e7          	jalr	2012(ra) # 3f98 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    27c4:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    27c8:	00003a97          	auipc	s5,0x3
    27cc:	e68a8a93          	addi	s5,s5,-408 # 5630 <malloc+0x1292>
      printf("cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    27d0:	00006a17          	auipc	s4,0x6
    27d4:	2a0a0a13          	addi	s4,s4,672 # 8a70 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    27d8:	6b0d                	lui	s6,0x3
    27da:	1c9b0b13          	addi	s6,s6,457 # 31c9 <sbrktest+0x69>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    27de:	20200593          	li	a1,514
    27e2:	8556                	mv	a0,s5
    27e4:	00001097          	auipc	ra,0x1
    27e8:	7a4080e7          	jalr	1956(ra) # 3f88 <open>
    27ec:	892a                	mv	s2,a0
    if(fd < 0){
    27ee:	06054463          	bltz	a0,2856 <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    27f2:	8626                	mv	a2,s1
    27f4:	85d2                	mv	a1,s4
    27f6:	00001097          	auipc	ra,0x1
    27fa:	772080e7          	jalr	1906(ra) # 3f68 <write>
    27fe:	89aa                	mv	s3,a0
      if(cc != sz){
    2800:	06a49963          	bne	s1,a0,2872 <bigwrite+0xe2>
      int cc = write(fd, buf, sz);
    2804:	8626                	mv	a2,s1
    2806:	85d2                	mv	a1,s4
    2808:	854a                	mv	a0,s2
    280a:	00001097          	auipc	ra,0x1
    280e:	75e080e7          	jalr	1886(ra) # 3f68 <write>
      if(cc != sz){
    2812:	04951e63          	bne	a0,s1,286e <bigwrite+0xde>
        printf("write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2816:	854a                	mv	a0,s2
    2818:	00001097          	auipc	ra,0x1
    281c:	758080e7          	jalr	1880(ra) # 3f70 <close>
    unlink("bigwrite");
    2820:	8556                	mv	a0,s5
    2822:	00001097          	auipc	ra,0x1
    2826:	776080e7          	jalr	1910(ra) # 3f98 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    282a:	1d74849b          	addiw	s1,s1,471
    282e:	fb6498e3          	bne	s1,s6,27de <bigwrite+0x4e>
  }

  printf("bigwrite ok\n");
    2832:	00003517          	auipc	a0,0x3
    2836:	e3e50513          	addi	a0,a0,-450 # 5670 <malloc+0x12d2>
    283a:	00002097          	auipc	ra,0x2
    283e:	aa6080e7          	jalr	-1370(ra) # 42e0 <printf>
}
    2842:	70e2                	ld	ra,56(sp)
    2844:	7442                	ld	s0,48(sp)
    2846:	74a2                	ld	s1,40(sp)
    2848:	7902                	ld	s2,32(sp)
    284a:	69e2                	ld	s3,24(sp)
    284c:	6a42                	ld	s4,16(sp)
    284e:	6aa2                	ld	s5,8(sp)
    2850:	6b02                	ld	s6,0(sp)
    2852:	6121                	addi	sp,sp,64
    2854:	8082                	ret
      printf("cannot create bigwrite\n");
    2856:	00003517          	auipc	a0,0x3
    285a:	dea50513          	addi	a0,a0,-534 # 5640 <malloc+0x12a2>
    285e:	00002097          	auipc	ra,0x2
    2862:	a82080e7          	jalr	-1406(ra) # 42e0 <printf>
      exit();
    2866:	00001097          	auipc	ra,0x1
    286a:	6e2080e7          	jalr	1762(ra) # 3f48 <exit>
    286e:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
    2870:	89aa                	mv	s3,a0
        printf("write(%d) ret %d\n", sz, cc);
    2872:	864e                	mv	a2,s3
    2874:	85a6                	mv	a1,s1
    2876:	00003517          	auipc	a0,0x3
    287a:	de250513          	addi	a0,a0,-542 # 5658 <malloc+0x12ba>
    287e:	00002097          	auipc	ra,0x2
    2882:	a62080e7          	jalr	-1438(ra) # 42e0 <printf>
        exit();
    2886:	00001097          	auipc	ra,0x1
    288a:	6c2080e7          	jalr	1730(ra) # 3f48 <exit>

000000000000288e <bigfile>:

void
bigfile(void)
{
    288e:	7179                	addi	sp,sp,-48
    2890:	f406                	sd	ra,40(sp)
    2892:	f022                	sd	s0,32(sp)
    2894:	ec26                	sd	s1,24(sp)
    2896:	e84a                	sd	s2,16(sp)
    2898:	e44e                	sd	s3,8(sp)
    289a:	e052                	sd	s4,0(sp)
    289c:	1800                	addi	s0,sp,48
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  printf("bigfile test\n");
    289e:	00003517          	auipc	a0,0x3
    28a2:	de250513          	addi	a0,a0,-542 # 5680 <malloc+0x12e2>
    28a6:	00002097          	auipc	ra,0x2
    28aa:	a3a080e7          	jalr	-1478(ra) # 42e0 <printf>

  unlink("bigfile");
    28ae:	00003517          	auipc	a0,0x3
    28b2:	de250513          	addi	a0,a0,-542 # 5690 <malloc+0x12f2>
    28b6:	00001097          	auipc	ra,0x1
    28ba:	6e2080e7          	jalr	1762(ra) # 3f98 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    28be:	20200593          	li	a1,514
    28c2:	00003517          	auipc	a0,0x3
    28c6:	dce50513          	addi	a0,a0,-562 # 5690 <malloc+0x12f2>
    28ca:	00001097          	auipc	ra,0x1
    28ce:	6be080e7          	jalr	1726(ra) # 3f88 <open>
    28d2:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("cannot create bigfile");
    exit();
  }
  for(i = 0; i < N; i++){
    28d4:	4481                	li	s1,0
    memset(buf, i, SZ);
    28d6:	00006917          	auipc	s2,0x6
    28da:	19a90913          	addi	s2,s2,410 # 8a70 <buf>
  for(i = 0; i < N; i++){
    28de:	4a51                	li	s4,20
  if(fd < 0){
    28e0:	0a054063          	bltz	a0,2980 <bigfile+0xf2>
    memset(buf, i, SZ);
    28e4:	25800613          	li	a2,600
    28e8:	85a6                	mv	a1,s1
    28ea:	854a                	mv	a0,s2
    28ec:	00001097          	auipc	ra,0x1
    28f0:	4d8080e7          	jalr	1240(ra) # 3dc4 <memset>
    if(write(fd, buf, SZ) != SZ){
    28f4:	25800613          	li	a2,600
    28f8:	85ca                	mv	a1,s2
    28fa:	854e                	mv	a0,s3
    28fc:	00001097          	auipc	ra,0x1
    2900:	66c080e7          	jalr	1644(ra) # 3f68 <write>
    2904:	25800793          	li	a5,600
    2908:	08f51863          	bne	a0,a5,2998 <bigfile+0x10a>
  for(i = 0; i < N; i++){
    290c:	2485                	addiw	s1,s1,1
    290e:	fd449be3          	bne	s1,s4,28e4 <bigfile+0x56>
      printf("write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2912:	854e                	mv	a0,s3
    2914:	00001097          	auipc	ra,0x1
    2918:	65c080e7          	jalr	1628(ra) # 3f70 <close>

  fd = open("bigfile", 0);
    291c:	4581                	li	a1,0
    291e:	00003517          	auipc	a0,0x3
    2922:	d7250513          	addi	a0,a0,-654 # 5690 <malloc+0x12f2>
    2926:	00001097          	auipc	ra,0x1
    292a:	662080e7          	jalr	1634(ra) # 3f88 <open>
    292e:	8a2a                	mv	s4,a0
  if(fd < 0){
    printf("cannot open bigfile\n");
    exit();
  }
  total = 0;
    2930:	4981                	li	s3,0
  for(i = 0; ; i++){
    2932:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    2934:	00006917          	auipc	s2,0x6
    2938:	13c90913          	addi	s2,s2,316 # 8a70 <buf>
  if(fd < 0){
    293c:	06054a63          	bltz	a0,29b0 <bigfile+0x122>
    cc = read(fd, buf, SZ/2);
    2940:	12c00613          	li	a2,300
    2944:	85ca                	mv	a1,s2
    2946:	8552                	mv	a0,s4
    2948:	00001097          	auipc	ra,0x1
    294c:	618080e7          	jalr	1560(ra) # 3f60 <read>
    if(cc < 0){
    2950:	06054c63          	bltz	a0,29c8 <bigfile+0x13a>
      printf("read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    2954:	cd55                	beqz	a0,2a10 <bigfile+0x182>
      break;
    if(cc != SZ/2){
    2956:	12c00793          	li	a5,300
    295a:	08f51363          	bne	a0,a5,29e0 <bigfile+0x152>
      printf("short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    295e:	01f4d79b          	srliw	a5,s1,0x1f
    2962:	9fa5                	addw	a5,a5,s1
    2964:	4017d79b          	sraiw	a5,a5,0x1
    2968:	00094703          	lbu	a4,0(s2)
    296c:	08f71663          	bne	a4,a5,29f8 <bigfile+0x16a>
    2970:	12b94703          	lbu	a4,299(s2)
    2974:	08f71263          	bne	a4,a5,29f8 <bigfile+0x16a>
      printf("read bigfile wrong data\n");
      exit();
    }
    total += cc;
    2978:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    297c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    297e:	b7c9                	j	2940 <bigfile+0xb2>
    printf("cannot create bigfile");
    2980:	00003517          	auipc	a0,0x3
    2984:	d1850513          	addi	a0,a0,-744 # 5698 <malloc+0x12fa>
    2988:	00002097          	auipc	ra,0x2
    298c:	958080e7          	jalr	-1704(ra) # 42e0 <printf>
    exit();
    2990:	00001097          	auipc	ra,0x1
    2994:	5b8080e7          	jalr	1464(ra) # 3f48 <exit>
      printf("write bigfile failed\n");
    2998:	00003517          	auipc	a0,0x3
    299c:	d1850513          	addi	a0,a0,-744 # 56b0 <malloc+0x1312>
    29a0:	00002097          	auipc	ra,0x2
    29a4:	940080e7          	jalr	-1728(ra) # 42e0 <printf>
      exit();
    29a8:	00001097          	auipc	ra,0x1
    29ac:	5a0080e7          	jalr	1440(ra) # 3f48 <exit>
    printf("cannot open bigfile\n");
    29b0:	00003517          	auipc	a0,0x3
    29b4:	d1850513          	addi	a0,a0,-744 # 56c8 <malloc+0x132a>
    29b8:	00002097          	auipc	ra,0x2
    29bc:	928080e7          	jalr	-1752(ra) # 42e0 <printf>
    exit();
    29c0:	00001097          	auipc	ra,0x1
    29c4:	588080e7          	jalr	1416(ra) # 3f48 <exit>
      printf("read bigfile failed\n");
    29c8:	00003517          	auipc	a0,0x3
    29cc:	d1850513          	addi	a0,a0,-744 # 56e0 <malloc+0x1342>
    29d0:	00002097          	auipc	ra,0x2
    29d4:	910080e7          	jalr	-1776(ra) # 42e0 <printf>
      exit();
    29d8:	00001097          	auipc	ra,0x1
    29dc:	570080e7          	jalr	1392(ra) # 3f48 <exit>
      printf("short read bigfile\n");
    29e0:	00003517          	auipc	a0,0x3
    29e4:	d1850513          	addi	a0,a0,-744 # 56f8 <malloc+0x135a>
    29e8:	00002097          	auipc	ra,0x2
    29ec:	8f8080e7          	jalr	-1800(ra) # 42e0 <printf>
      exit();
    29f0:	00001097          	auipc	ra,0x1
    29f4:	558080e7          	jalr	1368(ra) # 3f48 <exit>
      printf("read bigfile wrong data\n");
    29f8:	00003517          	auipc	a0,0x3
    29fc:	d1850513          	addi	a0,a0,-744 # 5710 <malloc+0x1372>
    2a00:	00002097          	auipc	ra,0x2
    2a04:	8e0080e7          	jalr	-1824(ra) # 42e0 <printf>
      exit();
    2a08:	00001097          	auipc	ra,0x1
    2a0c:	540080e7          	jalr	1344(ra) # 3f48 <exit>
  }
  close(fd);
    2a10:	8552                	mv	a0,s4
    2a12:	00001097          	auipc	ra,0x1
    2a16:	55e080e7          	jalr	1374(ra) # 3f70 <close>
  if(total != N*SZ){
    2a1a:	678d                	lui	a5,0x3
    2a1c:	ee078793          	addi	a5,a5,-288 # 2ee0 <dirfile+0x1ae>
    2a20:	02f99a63          	bne	s3,a5,2a54 <bigfile+0x1c6>
    printf("read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    2a24:	00003517          	auipc	a0,0x3
    2a28:	c6c50513          	addi	a0,a0,-916 # 5690 <malloc+0x12f2>
    2a2c:	00001097          	auipc	ra,0x1
    2a30:	56c080e7          	jalr	1388(ra) # 3f98 <unlink>

  printf("bigfile test ok\n");
    2a34:	00003517          	auipc	a0,0x3
    2a38:	d1c50513          	addi	a0,a0,-740 # 5750 <malloc+0x13b2>
    2a3c:	00002097          	auipc	ra,0x2
    2a40:	8a4080e7          	jalr	-1884(ra) # 42e0 <printf>
}
    2a44:	70a2                	ld	ra,40(sp)
    2a46:	7402                	ld	s0,32(sp)
    2a48:	64e2                	ld	s1,24(sp)
    2a4a:	6942                	ld	s2,16(sp)
    2a4c:	69a2                	ld	s3,8(sp)
    2a4e:	6a02                	ld	s4,0(sp)
    2a50:	6145                	addi	sp,sp,48
    2a52:	8082                	ret
    printf("read bigfile wrong total\n");
    2a54:	00003517          	auipc	a0,0x3
    2a58:	cdc50513          	addi	a0,a0,-804 # 5730 <malloc+0x1392>
    2a5c:	00002097          	auipc	ra,0x2
    2a60:	884080e7          	jalr	-1916(ra) # 42e0 <printf>
    exit();
    2a64:	00001097          	auipc	ra,0x1
    2a68:	4e4080e7          	jalr	1252(ra) # 3f48 <exit>

0000000000002a6c <fourteen>:

void
fourteen(void)
{
    2a6c:	1141                	addi	sp,sp,-16
    2a6e:	e406                	sd	ra,8(sp)
    2a70:	e022                	sd	s0,0(sp)
    2a72:	0800                	addi	s0,sp,16
  int fd;

  // DIRSIZ is 14.
  printf("fourteen test\n");
    2a74:	00003517          	auipc	a0,0x3
    2a78:	cf450513          	addi	a0,a0,-780 # 5768 <malloc+0x13ca>
    2a7c:	00002097          	auipc	ra,0x2
    2a80:	864080e7          	jalr	-1948(ra) # 42e0 <printf>

  if(mkdir("12345678901234") != 0){
    2a84:	00003517          	auipc	a0,0x3
    2a88:	ea450513          	addi	a0,a0,-348 # 5928 <malloc+0x158a>
    2a8c:	00001097          	auipc	ra,0x1
    2a90:	524080e7          	jalr	1316(ra) # 3fb0 <mkdir>
    2a94:	e559                	bnez	a0,2b22 <fourteen+0xb6>
    printf("mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a96:	00003517          	auipc	a0,0x3
    2a9a:	d0250513          	addi	a0,a0,-766 # 5798 <malloc+0x13fa>
    2a9e:	00001097          	auipc	ra,0x1
    2aa2:	512080e7          	jalr	1298(ra) # 3fb0 <mkdir>
    2aa6:	e951                	bnez	a0,2b3a <fourteen+0xce>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2aa8:	20000593          	li	a1,512
    2aac:	00003517          	auipc	a0,0x3
    2ab0:	d3c50513          	addi	a0,a0,-708 # 57e8 <malloc+0x144a>
    2ab4:	00001097          	auipc	ra,0x1
    2ab8:	4d4080e7          	jalr	1236(ra) # 3f88 <open>
  if(fd < 0){
    2abc:	08054b63          	bltz	a0,2b52 <fourteen+0xe6>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    2ac0:	00001097          	auipc	ra,0x1
    2ac4:	4b0080e7          	jalr	1200(ra) # 3f70 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2ac8:	4581                	li	a1,0
    2aca:	00003517          	auipc	a0,0x3
    2ace:	d8e50513          	addi	a0,a0,-626 # 5858 <malloc+0x14ba>
    2ad2:	00001097          	auipc	ra,0x1
    2ad6:	4b6080e7          	jalr	1206(ra) # 3f88 <open>
  if(fd < 0){
    2ada:	08054863          	bltz	a0,2b6a <fourteen+0xfe>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    2ade:	00001097          	auipc	ra,0x1
    2ae2:	492080e7          	jalr	1170(ra) # 3f70 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2ae6:	00003517          	auipc	a0,0x3
    2aea:	de250513          	addi	a0,a0,-542 # 58c8 <malloc+0x152a>
    2aee:	00001097          	auipc	ra,0x1
    2af2:	4c2080e7          	jalr	1218(ra) # 3fb0 <mkdir>
    2af6:	c551                	beqz	a0,2b82 <fourteen+0x116>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2af8:	00003517          	auipc	a0,0x3
    2afc:	e2050513          	addi	a0,a0,-480 # 5918 <malloc+0x157a>
    2b00:	00001097          	auipc	ra,0x1
    2b04:	4b0080e7          	jalr	1200(ra) # 3fb0 <mkdir>
    2b08:	c949                	beqz	a0,2b9a <fourteen+0x12e>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf("fourteen ok\n");
    2b0a:	00003517          	auipc	a0,0x3
    2b0e:	e6650513          	addi	a0,a0,-410 # 5970 <malloc+0x15d2>
    2b12:	00001097          	auipc	ra,0x1
    2b16:	7ce080e7          	jalr	1998(ra) # 42e0 <printf>
}
    2b1a:	60a2                	ld	ra,8(sp)
    2b1c:	6402                	ld	s0,0(sp)
    2b1e:	0141                	addi	sp,sp,16
    2b20:	8082                	ret
    printf("mkdir 12345678901234 failed\n");
    2b22:	00003517          	auipc	a0,0x3
    2b26:	c5650513          	addi	a0,a0,-938 # 5778 <malloc+0x13da>
    2b2a:	00001097          	auipc	ra,0x1
    2b2e:	7b6080e7          	jalr	1974(ra) # 42e0 <printf>
    exit();
    2b32:	00001097          	auipc	ra,0x1
    2b36:	416080e7          	jalr	1046(ra) # 3f48 <exit>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    2b3a:	00003517          	auipc	a0,0x3
    2b3e:	c7e50513          	addi	a0,a0,-898 # 57b8 <malloc+0x141a>
    2b42:	00001097          	auipc	ra,0x1
    2b46:	79e080e7          	jalr	1950(ra) # 42e0 <printf>
    exit();
    2b4a:	00001097          	auipc	ra,0x1
    2b4e:	3fe080e7          	jalr	1022(ra) # 3f48 <exit>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    2b52:	00003517          	auipc	a0,0x3
    2b56:	cc650513          	addi	a0,a0,-826 # 5818 <malloc+0x147a>
    2b5a:	00001097          	auipc	ra,0x1
    2b5e:	786080e7          	jalr	1926(ra) # 42e0 <printf>
    exit();
    2b62:	00001097          	auipc	ra,0x1
    2b66:	3e6080e7          	jalr	998(ra) # 3f48 <exit>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    2b6a:	00003517          	auipc	a0,0x3
    2b6e:	d1e50513          	addi	a0,a0,-738 # 5888 <malloc+0x14ea>
    2b72:	00001097          	auipc	ra,0x1
    2b76:	76e080e7          	jalr	1902(ra) # 42e0 <printf>
    exit();
    2b7a:	00001097          	auipc	ra,0x1
    2b7e:	3ce080e7          	jalr	974(ra) # 3f48 <exit>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    2b82:	00003517          	auipc	a0,0x3
    2b86:	d6650513          	addi	a0,a0,-666 # 58e8 <malloc+0x154a>
    2b8a:	00001097          	auipc	ra,0x1
    2b8e:	756080e7          	jalr	1878(ra) # 42e0 <printf>
    exit();
    2b92:	00001097          	auipc	ra,0x1
    2b96:	3b6080e7          	jalr	950(ra) # 3f48 <exit>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    2b9a:	00003517          	auipc	a0,0x3
    2b9e:	d9e50513          	addi	a0,a0,-610 # 5938 <malloc+0x159a>
    2ba2:	00001097          	auipc	ra,0x1
    2ba6:	73e080e7          	jalr	1854(ra) # 42e0 <printf>
    exit();
    2baa:	00001097          	auipc	ra,0x1
    2bae:	39e080e7          	jalr	926(ra) # 3f48 <exit>

0000000000002bb2 <rmdot>:

void
rmdot(void)
{
    2bb2:	1141                	addi	sp,sp,-16
    2bb4:	e406                	sd	ra,8(sp)
    2bb6:	e022                	sd	s0,0(sp)
    2bb8:	0800                	addi	s0,sp,16
  printf("rmdot test\n");
    2bba:	00003517          	auipc	a0,0x3
    2bbe:	dc650513          	addi	a0,a0,-570 # 5980 <malloc+0x15e2>
    2bc2:	00001097          	auipc	ra,0x1
    2bc6:	71e080e7          	jalr	1822(ra) # 42e0 <printf>
  if(mkdir("dots") != 0){
    2bca:	00003517          	auipc	a0,0x3
    2bce:	dc650513          	addi	a0,a0,-570 # 5990 <malloc+0x15f2>
    2bd2:	00001097          	auipc	ra,0x1
    2bd6:	3de080e7          	jalr	990(ra) # 3fb0 <mkdir>
    2bda:	ed41                	bnez	a0,2c72 <rmdot+0xc0>
    printf("mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    2bdc:	00003517          	auipc	a0,0x3
    2be0:	db450513          	addi	a0,a0,-588 # 5990 <malloc+0x15f2>
    2be4:	00001097          	auipc	ra,0x1
    2be8:	3d4080e7          	jalr	980(ra) # 3fb8 <chdir>
    2bec:	ed59                	bnez	a0,2c8a <rmdot+0xd8>
    printf("chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    2bee:	00002517          	auipc	a0,0x2
    2bf2:	39250513          	addi	a0,a0,914 # 4f80 <malloc+0xbe2>
    2bf6:	00001097          	auipc	ra,0x1
    2bfa:	3a2080e7          	jalr	930(ra) # 3f98 <unlink>
    2bfe:	c155                	beqz	a0,2ca2 <rmdot+0xf0>
    printf("rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    2c00:	00002517          	auipc	a0,0x2
    2c04:	d6850513          	addi	a0,a0,-664 # 4968 <malloc+0x5ca>
    2c08:	00001097          	auipc	ra,0x1
    2c0c:	390080e7          	jalr	912(ra) # 3f98 <unlink>
    2c10:	c54d                	beqz	a0,2cba <rmdot+0x108>
    printf("rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    2c12:	00002517          	auipc	a0,0x2
    2c16:	90650513          	addi	a0,a0,-1786 # 4518 <malloc+0x17a>
    2c1a:	00001097          	auipc	ra,0x1
    2c1e:	39e080e7          	jalr	926(ra) # 3fb8 <chdir>
    2c22:	e945                	bnez	a0,2cd2 <rmdot+0x120>
    printf("chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    2c24:	00003517          	auipc	a0,0x3
    2c28:	dc450513          	addi	a0,a0,-572 # 59e8 <malloc+0x164a>
    2c2c:	00001097          	auipc	ra,0x1
    2c30:	36c080e7          	jalr	876(ra) # 3f98 <unlink>
    2c34:	c95d                	beqz	a0,2cea <rmdot+0x138>
    printf("unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    2c36:	00003517          	auipc	a0,0x3
    2c3a:	dd250513          	addi	a0,a0,-558 # 5a08 <malloc+0x166a>
    2c3e:	00001097          	auipc	ra,0x1
    2c42:	35a080e7          	jalr	858(ra) # 3f98 <unlink>
    2c46:	cd55                	beqz	a0,2d02 <rmdot+0x150>
    printf("unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    2c48:	00003517          	auipc	a0,0x3
    2c4c:	d4850513          	addi	a0,a0,-696 # 5990 <malloc+0x15f2>
    2c50:	00001097          	auipc	ra,0x1
    2c54:	348080e7          	jalr	840(ra) # 3f98 <unlink>
    2c58:	e169                	bnez	a0,2d1a <rmdot+0x168>
    printf("unlink dots failed!\n");
    exit();
  }
  printf("rmdot ok\n");
    2c5a:	00003517          	auipc	a0,0x3
    2c5e:	de650513          	addi	a0,a0,-538 # 5a40 <malloc+0x16a2>
    2c62:	00001097          	auipc	ra,0x1
    2c66:	67e080e7          	jalr	1662(ra) # 42e0 <printf>
}
    2c6a:	60a2                	ld	ra,8(sp)
    2c6c:	6402                	ld	s0,0(sp)
    2c6e:	0141                	addi	sp,sp,16
    2c70:	8082                	ret
    printf("mkdir dots failed\n");
    2c72:	00003517          	auipc	a0,0x3
    2c76:	d2650513          	addi	a0,a0,-730 # 5998 <malloc+0x15fa>
    2c7a:	00001097          	auipc	ra,0x1
    2c7e:	666080e7          	jalr	1638(ra) # 42e0 <printf>
    exit();
    2c82:	00001097          	auipc	ra,0x1
    2c86:	2c6080e7          	jalr	710(ra) # 3f48 <exit>
    printf("chdir dots failed\n");
    2c8a:	00003517          	auipc	a0,0x3
    2c8e:	d2650513          	addi	a0,a0,-730 # 59b0 <malloc+0x1612>
    2c92:	00001097          	auipc	ra,0x1
    2c96:	64e080e7          	jalr	1614(ra) # 42e0 <printf>
    exit();
    2c9a:	00001097          	auipc	ra,0x1
    2c9e:	2ae080e7          	jalr	686(ra) # 3f48 <exit>
    printf("rm . worked!\n");
    2ca2:	00003517          	auipc	a0,0x3
    2ca6:	d2650513          	addi	a0,a0,-730 # 59c8 <malloc+0x162a>
    2caa:	00001097          	auipc	ra,0x1
    2cae:	636080e7          	jalr	1590(ra) # 42e0 <printf>
    exit();
    2cb2:	00001097          	auipc	ra,0x1
    2cb6:	296080e7          	jalr	662(ra) # 3f48 <exit>
    printf("rm .. worked!\n");
    2cba:	00003517          	auipc	a0,0x3
    2cbe:	d1e50513          	addi	a0,a0,-738 # 59d8 <malloc+0x163a>
    2cc2:	00001097          	auipc	ra,0x1
    2cc6:	61e080e7          	jalr	1566(ra) # 42e0 <printf>
    exit();
    2cca:	00001097          	auipc	ra,0x1
    2cce:	27e080e7          	jalr	638(ra) # 3f48 <exit>
    printf("chdir / failed\n");
    2cd2:	00002517          	auipc	a0,0x2
    2cd6:	84e50513          	addi	a0,a0,-1970 # 4520 <malloc+0x182>
    2cda:	00001097          	auipc	ra,0x1
    2cde:	606080e7          	jalr	1542(ra) # 42e0 <printf>
    exit();
    2ce2:	00001097          	auipc	ra,0x1
    2ce6:	266080e7          	jalr	614(ra) # 3f48 <exit>
    printf("unlink dots/. worked!\n");
    2cea:	00003517          	auipc	a0,0x3
    2cee:	d0650513          	addi	a0,a0,-762 # 59f0 <malloc+0x1652>
    2cf2:	00001097          	auipc	ra,0x1
    2cf6:	5ee080e7          	jalr	1518(ra) # 42e0 <printf>
    exit();
    2cfa:	00001097          	auipc	ra,0x1
    2cfe:	24e080e7          	jalr	590(ra) # 3f48 <exit>
    printf("unlink dots/.. worked!\n");
    2d02:	00003517          	auipc	a0,0x3
    2d06:	d0e50513          	addi	a0,a0,-754 # 5a10 <malloc+0x1672>
    2d0a:	00001097          	auipc	ra,0x1
    2d0e:	5d6080e7          	jalr	1494(ra) # 42e0 <printf>
    exit();
    2d12:	00001097          	auipc	ra,0x1
    2d16:	236080e7          	jalr	566(ra) # 3f48 <exit>
    printf("unlink dots failed!\n");
    2d1a:	00003517          	auipc	a0,0x3
    2d1e:	d0e50513          	addi	a0,a0,-754 # 5a28 <malloc+0x168a>
    2d22:	00001097          	auipc	ra,0x1
    2d26:	5be080e7          	jalr	1470(ra) # 42e0 <printf>
    exit();
    2d2a:	00001097          	auipc	ra,0x1
    2d2e:	21e080e7          	jalr	542(ra) # 3f48 <exit>

0000000000002d32 <dirfile>:

void
dirfile(void)
{
    2d32:	1101                	addi	sp,sp,-32
    2d34:	ec06                	sd	ra,24(sp)
    2d36:	e822                	sd	s0,16(sp)
    2d38:	e426                	sd	s1,8(sp)
    2d3a:	1000                	addi	s0,sp,32
  int fd;

  printf("dir vs file\n");
    2d3c:	00003517          	auipc	a0,0x3
    2d40:	d1450513          	addi	a0,a0,-748 # 5a50 <malloc+0x16b2>
    2d44:	00001097          	auipc	ra,0x1
    2d48:	59c080e7          	jalr	1436(ra) # 42e0 <printf>

  fd = open("dirfile", O_CREATE);
    2d4c:	20000593          	li	a1,512
    2d50:	00003517          	auipc	a0,0x3
    2d54:	d1050513          	addi	a0,a0,-752 # 5a60 <malloc+0x16c2>
    2d58:	00001097          	auipc	ra,0x1
    2d5c:	230080e7          	jalr	560(ra) # 3f88 <open>
  if(fd < 0){
    2d60:	10054563          	bltz	a0,2e6a <dirfile+0x138>
    printf("create dirfile failed\n");
    exit();
  }
  close(fd);
    2d64:	00001097          	auipc	ra,0x1
    2d68:	20c080e7          	jalr	524(ra) # 3f70 <close>
  if(chdir("dirfile") == 0){
    2d6c:	00003517          	auipc	a0,0x3
    2d70:	cf450513          	addi	a0,a0,-780 # 5a60 <malloc+0x16c2>
    2d74:	00001097          	auipc	ra,0x1
    2d78:	244080e7          	jalr	580(ra) # 3fb8 <chdir>
    2d7c:	10050363          	beqz	a0,2e82 <dirfile+0x150>
    printf("chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    2d80:	4581                	li	a1,0
    2d82:	00003517          	auipc	a0,0x3
    2d86:	d1e50513          	addi	a0,a0,-738 # 5aa0 <malloc+0x1702>
    2d8a:	00001097          	auipc	ra,0x1
    2d8e:	1fe080e7          	jalr	510(ra) # 3f88 <open>
  if(fd >= 0){
    2d92:	10055463          	bgez	a0,2e9a <dirfile+0x168>
    printf("create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    2d96:	20000593          	li	a1,512
    2d9a:	00003517          	auipc	a0,0x3
    2d9e:	d0650513          	addi	a0,a0,-762 # 5aa0 <malloc+0x1702>
    2da2:	00001097          	auipc	ra,0x1
    2da6:	1e6080e7          	jalr	486(ra) # 3f88 <open>
  if(fd >= 0){
    2daa:	10055463          	bgez	a0,2eb2 <dirfile+0x180>
    printf("create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    2dae:	00003517          	auipc	a0,0x3
    2db2:	cf250513          	addi	a0,a0,-782 # 5aa0 <malloc+0x1702>
    2db6:	00001097          	auipc	ra,0x1
    2dba:	1fa080e7          	jalr	506(ra) # 3fb0 <mkdir>
    2dbe:	10050663          	beqz	a0,2eca <dirfile+0x198>
    printf("mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    2dc2:	00003517          	auipc	a0,0x3
    2dc6:	cde50513          	addi	a0,a0,-802 # 5aa0 <malloc+0x1702>
    2dca:	00001097          	auipc	ra,0x1
    2dce:	1ce080e7          	jalr	462(ra) # 3f98 <unlink>
    2dd2:	10050863          	beqz	a0,2ee2 <dirfile+0x1b0>
    printf("unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2dd6:	00003597          	auipc	a1,0x3
    2dda:	cca58593          	addi	a1,a1,-822 # 5aa0 <malloc+0x1702>
    2dde:	00003517          	auipc	a0,0x3
    2de2:	d3250513          	addi	a0,a0,-718 # 5b10 <malloc+0x1772>
    2de6:	00001097          	auipc	ra,0x1
    2dea:	1c2080e7          	jalr	450(ra) # 3fa8 <link>
    2dee:	10050663          	beqz	a0,2efa <dirfile+0x1c8>
    printf("link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    2df2:	00003517          	auipc	a0,0x3
    2df6:	c6e50513          	addi	a0,a0,-914 # 5a60 <malloc+0x16c2>
    2dfa:	00001097          	auipc	ra,0x1
    2dfe:	19e080e7          	jalr	414(ra) # 3f98 <unlink>
    2e02:	10051863          	bnez	a0,2f12 <dirfile+0x1e0>
    printf("unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2e06:	4589                	li	a1,2
    2e08:	00002517          	auipc	a0,0x2
    2e0c:	17850513          	addi	a0,a0,376 # 4f80 <malloc+0xbe2>
    2e10:	00001097          	auipc	ra,0x1
    2e14:	178080e7          	jalr	376(ra) # 3f88 <open>
  if(fd >= 0){
    2e18:	10055963          	bgez	a0,2f2a <dirfile+0x1f8>
    printf("open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    2e1c:	4581                	li	a1,0
    2e1e:	00002517          	auipc	a0,0x2
    2e22:	16250513          	addi	a0,a0,354 # 4f80 <malloc+0xbe2>
    2e26:	00001097          	auipc	ra,0x1
    2e2a:	162080e7          	jalr	354(ra) # 3f88 <open>
    2e2e:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    2e30:	4605                	li	a2,1
    2e32:	00002597          	auipc	a1,0x2
    2e36:	c2e58593          	addi	a1,a1,-978 # 4a60 <malloc+0x6c2>
    2e3a:	00001097          	auipc	ra,0x1
    2e3e:	12e080e7          	jalr	302(ra) # 3f68 <write>
    2e42:	10a04063          	bgtz	a0,2f42 <dirfile+0x210>
    printf("write . succeeded!\n");
    exit();
  }
  close(fd);
    2e46:	8526                	mv	a0,s1
    2e48:	00001097          	auipc	ra,0x1
    2e4c:	128080e7          	jalr	296(ra) # 3f70 <close>

  printf("dir vs file OK\n");
    2e50:	00003517          	auipc	a0,0x3
    2e54:	d3850513          	addi	a0,a0,-712 # 5b88 <malloc+0x17ea>
    2e58:	00001097          	auipc	ra,0x1
    2e5c:	488080e7          	jalr	1160(ra) # 42e0 <printf>
}
    2e60:	60e2                	ld	ra,24(sp)
    2e62:	6442                	ld	s0,16(sp)
    2e64:	64a2                	ld	s1,8(sp)
    2e66:	6105                	addi	sp,sp,32
    2e68:	8082                	ret
    printf("create dirfile failed\n");
    2e6a:	00003517          	auipc	a0,0x3
    2e6e:	bfe50513          	addi	a0,a0,-1026 # 5a68 <malloc+0x16ca>
    2e72:	00001097          	auipc	ra,0x1
    2e76:	46e080e7          	jalr	1134(ra) # 42e0 <printf>
    exit();
    2e7a:	00001097          	auipc	ra,0x1
    2e7e:	0ce080e7          	jalr	206(ra) # 3f48 <exit>
    printf("chdir dirfile succeeded!\n");
    2e82:	00003517          	auipc	a0,0x3
    2e86:	bfe50513          	addi	a0,a0,-1026 # 5a80 <malloc+0x16e2>
    2e8a:	00001097          	auipc	ra,0x1
    2e8e:	456080e7          	jalr	1110(ra) # 42e0 <printf>
    exit();
    2e92:	00001097          	auipc	ra,0x1
    2e96:	0b6080e7          	jalr	182(ra) # 3f48 <exit>
    printf("create dirfile/xx succeeded!\n");
    2e9a:	00003517          	auipc	a0,0x3
    2e9e:	c1650513          	addi	a0,a0,-1002 # 5ab0 <malloc+0x1712>
    2ea2:	00001097          	auipc	ra,0x1
    2ea6:	43e080e7          	jalr	1086(ra) # 42e0 <printf>
    exit();
    2eaa:	00001097          	auipc	ra,0x1
    2eae:	09e080e7          	jalr	158(ra) # 3f48 <exit>
    printf("create dirfile/xx succeeded!\n");
    2eb2:	00003517          	auipc	a0,0x3
    2eb6:	bfe50513          	addi	a0,a0,-1026 # 5ab0 <malloc+0x1712>
    2eba:	00001097          	auipc	ra,0x1
    2ebe:	426080e7          	jalr	1062(ra) # 42e0 <printf>
    exit();
    2ec2:	00001097          	auipc	ra,0x1
    2ec6:	086080e7          	jalr	134(ra) # 3f48 <exit>
    printf("mkdir dirfile/xx succeeded!\n");
    2eca:	00003517          	auipc	a0,0x3
    2ece:	c0650513          	addi	a0,a0,-1018 # 5ad0 <malloc+0x1732>
    2ed2:	00001097          	auipc	ra,0x1
    2ed6:	40e080e7          	jalr	1038(ra) # 42e0 <printf>
    exit();
    2eda:	00001097          	auipc	ra,0x1
    2ede:	06e080e7          	jalr	110(ra) # 3f48 <exit>
    printf("unlink dirfile/xx succeeded!\n");
    2ee2:	00003517          	auipc	a0,0x3
    2ee6:	c0e50513          	addi	a0,a0,-1010 # 5af0 <malloc+0x1752>
    2eea:	00001097          	auipc	ra,0x1
    2eee:	3f6080e7          	jalr	1014(ra) # 42e0 <printf>
    exit();
    2ef2:	00001097          	auipc	ra,0x1
    2ef6:	056080e7          	jalr	86(ra) # 3f48 <exit>
    printf("link to dirfile/xx succeeded!\n");
    2efa:	00003517          	auipc	a0,0x3
    2efe:	c1e50513          	addi	a0,a0,-994 # 5b18 <malloc+0x177a>
    2f02:	00001097          	auipc	ra,0x1
    2f06:	3de080e7          	jalr	990(ra) # 42e0 <printf>
    exit();
    2f0a:	00001097          	auipc	ra,0x1
    2f0e:	03e080e7          	jalr	62(ra) # 3f48 <exit>
    printf("unlink dirfile failed!\n");
    2f12:	00003517          	auipc	a0,0x3
    2f16:	c2650513          	addi	a0,a0,-986 # 5b38 <malloc+0x179a>
    2f1a:	00001097          	auipc	ra,0x1
    2f1e:	3c6080e7          	jalr	966(ra) # 42e0 <printf>
    exit();
    2f22:	00001097          	auipc	ra,0x1
    2f26:	026080e7          	jalr	38(ra) # 3f48 <exit>
    printf("open . for writing succeeded!\n");
    2f2a:	00003517          	auipc	a0,0x3
    2f2e:	c2650513          	addi	a0,a0,-986 # 5b50 <malloc+0x17b2>
    2f32:	00001097          	auipc	ra,0x1
    2f36:	3ae080e7          	jalr	942(ra) # 42e0 <printf>
    exit();
    2f3a:	00001097          	auipc	ra,0x1
    2f3e:	00e080e7          	jalr	14(ra) # 3f48 <exit>
    printf("write . succeeded!\n");
    2f42:	00003517          	auipc	a0,0x3
    2f46:	c2e50513          	addi	a0,a0,-978 # 5b70 <malloc+0x17d2>
    2f4a:	00001097          	auipc	ra,0x1
    2f4e:	396080e7          	jalr	918(ra) # 42e0 <printf>
    exit();
    2f52:	00001097          	auipc	ra,0x1
    2f56:	ff6080e7          	jalr	-10(ra) # 3f48 <exit>

0000000000002f5a <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f5a:	7139                	addi	sp,sp,-64
    2f5c:	fc06                	sd	ra,56(sp)
    2f5e:	f822                	sd	s0,48(sp)
    2f60:	f426                	sd	s1,40(sp)
    2f62:	f04a                	sd	s2,32(sp)
    2f64:	ec4e                	sd	s3,24(sp)
    2f66:	e852                	sd	s4,16(sp)
    2f68:	e456                	sd	s5,8(sp)
    2f6a:	0080                	addi	s0,sp,64
  int i, fd;

  printf("empty file name\n");
    2f6c:	00003517          	auipc	a0,0x3
    2f70:	c2c50513          	addi	a0,a0,-980 # 5b98 <malloc+0x17fa>
    2f74:	00001097          	auipc	ra,0x1
    2f78:	36c080e7          	jalr	876(ra) # 42e0 <printf>
    2f7c:	03300913          	li	s2,51

  for(i = 0; i < NINODE + 1; i++){
    if(mkdir("irefd") != 0){
    2f80:	00003a17          	auipc	s4,0x3
    2f84:	c30a0a13          	addi	s4,s4,-976 # 5bb0 <malloc+0x1812>
    if(chdir("irefd") != 0){
      printf("chdir irefd failed\n");
      exit();
    }

    mkdir("");
    2f88:	00003497          	auipc	s1,0x3
    2f8c:	9e048493          	addi	s1,s1,-1568 # 5968 <malloc+0x15ca>
    link("README", "");
    2f90:	00003a97          	auipc	s5,0x3
    2f94:	b80a8a93          	addi	s5,s5,-1152 # 5b10 <malloc+0x1772>
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    2f98:	00003997          	auipc	s3,0x3
    2f9c:	b1098993          	addi	s3,s3,-1264 # 5aa8 <malloc+0x170a>
    2fa0:	a0b1                	j	2fec <iref+0x92>
      printf("mkdir irefd failed\n");
    2fa2:	00003517          	auipc	a0,0x3
    2fa6:	c1650513          	addi	a0,a0,-1002 # 5bb8 <malloc+0x181a>
    2faa:	00001097          	auipc	ra,0x1
    2fae:	336080e7          	jalr	822(ra) # 42e0 <printf>
      exit();
    2fb2:	00001097          	auipc	ra,0x1
    2fb6:	f96080e7          	jalr	-106(ra) # 3f48 <exit>
      printf("chdir irefd failed\n");
    2fba:	00003517          	auipc	a0,0x3
    2fbe:	c1650513          	addi	a0,a0,-1002 # 5bd0 <malloc+0x1832>
    2fc2:	00001097          	auipc	ra,0x1
    2fc6:	31e080e7          	jalr	798(ra) # 42e0 <printf>
      exit();
    2fca:	00001097          	auipc	ra,0x1
    2fce:	f7e080e7          	jalr	-130(ra) # 3f48 <exit>
      close(fd);
    2fd2:	00001097          	auipc	ra,0x1
    2fd6:	f9e080e7          	jalr	-98(ra) # 3f70 <close>
    2fda:	a889                	j	302c <iref+0xd2>
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2fdc:	854e                	mv	a0,s3
    2fde:	00001097          	auipc	ra,0x1
    2fe2:	fba080e7          	jalr	-70(ra) # 3f98 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    2fe6:	397d                	addiw	s2,s2,-1
    2fe8:	06090063          	beqz	s2,3048 <iref+0xee>
    if(mkdir("irefd") != 0){
    2fec:	8552                	mv	a0,s4
    2fee:	00001097          	auipc	ra,0x1
    2ff2:	fc2080e7          	jalr	-62(ra) # 3fb0 <mkdir>
    2ff6:	f555                	bnez	a0,2fa2 <iref+0x48>
    if(chdir("irefd") != 0){
    2ff8:	8552                	mv	a0,s4
    2ffa:	00001097          	auipc	ra,0x1
    2ffe:	fbe080e7          	jalr	-66(ra) # 3fb8 <chdir>
    3002:	fd45                	bnez	a0,2fba <iref+0x60>
    mkdir("");
    3004:	8526                	mv	a0,s1
    3006:	00001097          	auipc	ra,0x1
    300a:	faa080e7          	jalr	-86(ra) # 3fb0 <mkdir>
    link("README", "");
    300e:	85a6                	mv	a1,s1
    3010:	8556                	mv	a0,s5
    3012:	00001097          	auipc	ra,0x1
    3016:	f96080e7          	jalr	-106(ra) # 3fa8 <link>
    fd = open("", O_CREATE);
    301a:	20000593          	li	a1,512
    301e:	8526                	mv	a0,s1
    3020:	00001097          	auipc	ra,0x1
    3024:	f68080e7          	jalr	-152(ra) # 3f88 <open>
    if(fd >= 0)
    3028:	fa0555e3          	bgez	a0,2fd2 <iref+0x78>
    fd = open("xx", O_CREATE);
    302c:	20000593          	li	a1,512
    3030:	854e                	mv	a0,s3
    3032:	00001097          	auipc	ra,0x1
    3036:	f56080e7          	jalr	-170(ra) # 3f88 <open>
    if(fd >= 0)
    303a:	fa0541e3          	bltz	a0,2fdc <iref+0x82>
      close(fd);
    303e:	00001097          	auipc	ra,0x1
    3042:	f32080e7          	jalr	-206(ra) # 3f70 <close>
    3046:	bf59                	j	2fdc <iref+0x82>
  }

  chdir("/");
    3048:	00001517          	auipc	a0,0x1
    304c:	4d050513          	addi	a0,a0,1232 # 4518 <malloc+0x17a>
    3050:	00001097          	auipc	ra,0x1
    3054:	f68080e7          	jalr	-152(ra) # 3fb8 <chdir>
  printf("empty file name OK\n");
    3058:	00003517          	auipc	a0,0x3
    305c:	b9050513          	addi	a0,a0,-1136 # 5be8 <malloc+0x184a>
    3060:	00001097          	auipc	ra,0x1
    3064:	280080e7          	jalr	640(ra) # 42e0 <printf>
}
    3068:	70e2                	ld	ra,56(sp)
    306a:	7442                	ld	s0,48(sp)
    306c:	74a2                	ld	s1,40(sp)
    306e:	7902                	ld	s2,32(sp)
    3070:	69e2                	ld	s3,24(sp)
    3072:	6a42                	ld	s4,16(sp)
    3074:	6aa2                	ld	s5,8(sp)
    3076:	6121                	addi	sp,sp,64
    3078:	8082                	ret

000000000000307a <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    307a:	1101                	addi	sp,sp,-32
    307c:	ec06                	sd	ra,24(sp)
    307e:	e822                	sd	s0,16(sp)
    3080:	e426                	sd	s1,8(sp)
    3082:	e04a                	sd	s2,0(sp)
    3084:	1000                	addi	s0,sp,32
  enum{ N = 1000 };
  int n, pid;

  printf("fork test\n");
    3086:	00002517          	auipc	a0,0x2
    308a:	ae250513          	addi	a0,a0,-1310 # 4b68 <malloc+0x7ca>
    308e:	00001097          	auipc	ra,0x1
    3092:	252080e7          	jalr	594(ra) # 42e0 <printf>

  for(n=0; n<N; n++){
    3096:	4481                	li	s1,0
    3098:	3e800913          	li	s2,1000
    pid = fork();
    309c:	00001097          	auipc	ra,0x1
    30a0:	ea4080e7          	jalr	-348(ra) # 3f40 <fork>
    if(pid < 0)
    30a4:	02054663          	bltz	a0,30d0 <forktest+0x56>
      break;
    if(pid == 0)
    30a8:	c105                	beqz	a0,30c8 <forktest+0x4e>
  for(n=0; n<N; n++){
    30aa:	2485                	addiw	s1,s1,1
    30ac:	ff2498e3          	bne	s1,s2,309c <forktest+0x22>
    printf("no fork at all!\n");
    exit();
  }

  if(n == N){
    printf("fork claimed to work 1000 times!\n");
    30b0:	00003517          	auipc	a0,0x3
    30b4:	b6850513          	addi	a0,a0,-1176 # 5c18 <malloc+0x187a>
    30b8:	00001097          	auipc	ra,0x1
    30bc:	228080e7          	jalr	552(ra) # 42e0 <printf>
    exit();
    30c0:	00001097          	auipc	ra,0x1
    30c4:	e88080e7          	jalr	-376(ra) # 3f48 <exit>
      exit();
    30c8:	00001097          	auipc	ra,0x1
    30cc:	e80080e7          	jalr	-384(ra) # 3f48 <exit>
  if (n == 0) {
    30d0:	c4a1                	beqz	s1,3118 <forktest+0x9e>
  if(n == N){
    30d2:	3e800793          	li	a5,1000
    30d6:	fcf48de3          	beq	s1,a5,30b0 <forktest+0x36>
  }

  for(; n > 0; n--){
    30da:	00905a63          	blez	s1,30ee <forktest+0x74>
    if(wait() < 0){
    30de:	00001097          	auipc	ra,0x1
    30e2:	e72080e7          	jalr	-398(ra) # 3f50 <wait>
    30e6:	04054563          	bltz	a0,3130 <forktest+0xb6>
  for(; n > 0; n--){
    30ea:	34fd                	addiw	s1,s1,-1
    30ec:	f8ed                	bnez	s1,30de <forktest+0x64>
      printf("wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    30ee:	00001097          	auipc	ra,0x1
    30f2:	e62080e7          	jalr	-414(ra) # 3f50 <wait>
    30f6:	57fd                	li	a5,-1
    30f8:	04f51863          	bne	a0,a5,3148 <forktest+0xce>
    printf("wait got too many\n");
    exit();
  }

  printf("fork test OK\n");
    30fc:	00003517          	auipc	a0,0x3
    3100:	b7450513          	addi	a0,a0,-1164 # 5c70 <malloc+0x18d2>
    3104:	00001097          	auipc	ra,0x1
    3108:	1dc080e7          	jalr	476(ra) # 42e0 <printf>
}
    310c:	60e2                	ld	ra,24(sp)
    310e:	6442                	ld	s0,16(sp)
    3110:	64a2                	ld	s1,8(sp)
    3112:	6902                	ld	s2,0(sp)
    3114:	6105                	addi	sp,sp,32
    3116:	8082                	ret
    printf("no fork at all!\n");
    3118:	00003517          	auipc	a0,0x3
    311c:	ae850513          	addi	a0,a0,-1304 # 5c00 <malloc+0x1862>
    3120:	00001097          	auipc	ra,0x1
    3124:	1c0080e7          	jalr	448(ra) # 42e0 <printf>
    exit();
    3128:	00001097          	auipc	ra,0x1
    312c:	e20080e7          	jalr	-480(ra) # 3f48 <exit>
      printf("wait stopped early\n");
    3130:	00003517          	auipc	a0,0x3
    3134:	b1050513          	addi	a0,a0,-1264 # 5c40 <malloc+0x18a2>
    3138:	00001097          	auipc	ra,0x1
    313c:	1a8080e7          	jalr	424(ra) # 42e0 <printf>
      exit();
    3140:	00001097          	auipc	ra,0x1
    3144:	e08080e7          	jalr	-504(ra) # 3f48 <exit>
    printf("wait got too many\n");
    3148:	00003517          	auipc	a0,0x3
    314c:	b1050513          	addi	a0,a0,-1264 # 5c58 <malloc+0x18ba>
    3150:	00001097          	auipc	ra,0x1
    3154:	190080e7          	jalr	400(ra) # 42e0 <printf>
    exit();
    3158:	00001097          	auipc	ra,0x1
    315c:	df0080e7          	jalr	-528(ra) # 3f48 <exit>

0000000000003160 <sbrktest>:

void
sbrktest(void)
{
    3160:	7119                	addi	sp,sp,-128
    3162:	fc86                	sd	ra,120(sp)
    3164:	f8a2                	sd	s0,112(sp)
    3166:	f4a6                	sd	s1,104(sp)
    3168:	f0ca                	sd	s2,96(sp)
    316a:	ecce                	sd	s3,88(sp)
    316c:	e8d2                	sd	s4,80(sp)
    316e:	e4d6                	sd	s5,72(sp)
    3170:	0100                	addi	s0,sp,128
  char *c, *oldbrk, scratch, *a, *b, *lastaddr, *p;
  uint64 amt;
  int fd;
  int n;

  printf("sbrk test\n");
    3172:	00003517          	auipc	a0,0x3
    3176:	b0e50513          	addi	a0,a0,-1266 # 5c80 <malloc+0x18e2>
    317a:	00001097          	auipc	ra,0x1
    317e:	166080e7          	jalr	358(ra) # 42e0 <printf>
  oldbrk = sbrk(0);
    3182:	4501                	li	a0,0
    3184:	00001097          	auipc	ra,0x1
    3188:	e4c080e7          	jalr	-436(ra) # 3fd0 <sbrk>
    318c:	89aa                	mv	s3,a0

  // does sbrk() return the expected failure value?
  a = sbrk(TOOMUCH);
    318e:	40000537          	lui	a0,0x40000
    3192:	00001097          	auipc	ra,0x1
    3196:	e3e080e7          	jalr	-450(ra) # 3fd0 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    319a:	57fd                	li	a5,-1
    319c:	00f51e63          	bne	a0,a5,31b8 <sbrktest+0x58>
    printf("sbrk(<toomuch>) returned %p\n", a);
    exit();
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    31a0:	4501                	li	a0,0
    31a2:	00001097          	auipc	ra,0x1
    31a6:	e2e080e7          	jalr	-466(ra) # 3fd0 <sbrk>
    31aa:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    31ac:	4901                	li	s2,0
    b = sbrk(1);
    if(b != a){
      printf("sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    31ae:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    31b0:	6a05                	lui	s4,0x1
    31b2:	388a0a13          	addi	s4,s4,904 # 1388 <fourfiles+0x128>
    31b6:	a839                	j	31d4 <sbrktest+0x74>
    31b8:	85aa                	mv	a1,a0
    printf("sbrk(<toomuch>) returned %p\n", a);
    31ba:	00003517          	auipc	a0,0x3
    31be:	ad650513          	addi	a0,a0,-1322 # 5c90 <malloc+0x18f2>
    31c2:	00001097          	auipc	ra,0x1
    31c6:	11e080e7          	jalr	286(ra) # 42e0 <printf>
    exit();
    31ca:	00001097          	auipc	ra,0x1
    31ce:	d7e080e7          	jalr	-642(ra) # 3f48 <exit>
    a = b + 1;
    31d2:	84be                	mv	s1,a5
    b = sbrk(1);
    31d4:	4505                	li	a0,1
    31d6:	00001097          	auipc	ra,0x1
    31da:	dfa080e7          	jalr	-518(ra) # 3fd0 <sbrk>
    if(b != a){
    31de:	16951063          	bne	a0,s1,333e <sbrktest+0x1de>
    *b = 1;
    31e2:	01548023          	sb	s5,0(s1)
    a = b + 1;
    31e6:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    31ea:	2905                	addiw	s2,s2,1
    31ec:	ff4913e3          	bne	s2,s4,31d2 <sbrktest+0x72>
  }
  pid = fork();
    31f0:	00001097          	auipc	ra,0x1
    31f4:	d50080e7          	jalr	-688(ra) # 3f40 <fork>
    31f8:	892a                	mv	s2,a0
  if(pid < 0){
    31fa:	16054163          	bltz	a0,335c <sbrktest+0x1fc>
    printf("sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    31fe:	4505                	li	a0,1
    3200:	00001097          	auipc	ra,0x1
    3204:	dd0080e7          	jalr	-560(ra) # 3fd0 <sbrk>
  c = sbrk(1);
    3208:	4505                	li	a0,1
    320a:	00001097          	auipc	ra,0x1
    320e:	dc6080e7          	jalr	-570(ra) # 3fd0 <sbrk>
  if(c != a + 1){
    3212:	0489                	addi	s1,s1,2
    3214:	16a49063          	bne	s1,a0,3374 <sbrktest+0x214>
    printf("sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    3218:	16090a63          	beqz	s2,338c <sbrktest+0x22c>
    exit();
  wait();
    321c:	00001097          	auipc	ra,0x1
    3220:	d34080e7          	jalr	-716(ra) # 3f50 <wait>

  // can one grow address space to something big?
  a = sbrk(0);
    3224:	4501                	li	a0,0
    3226:	00001097          	auipc	ra,0x1
    322a:	daa080e7          	jalr	-598(ra) # 3fd0 <sbrk>
    322e:	84aa                	mv	s1,a0
  amt = BIG - (uint64)a;
  p = sbrk(amt);
    3230:	06400537          	lui	a0,0x6400
    3234:	9d05                	subw	a0,a0,s1
    3236:	00001097          	auipc	ra,0x1
    323a:	d9a080e7          	jalr	-614(ra) # 3fd0 <sbrk>
  if (p != a) {
    323e:	14a49b63          	bne	s1,a0,3394 <sbrktest+0x234>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3242:	064007b7          	lui	a5,0x6400
    3246:	06300713          	li	a4,99
    324a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f457f>

  // can one de-allocate?
  a = sbrk(0);
    324e:	4501                	li	a0,0
    3250:	00001097          	auipc	ra,0x1
    3254:	d80080e7          	jalr	-640(ra) # 3fd0 <sbrk>
    3258:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    325a:	757d                	lui	a0,0xfffff
    325c:	00001097          	auipc	ra,0x1
    3260:	d74080e7          	jalr	-652(ra) # 3fd0 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3264:	57fd                	li	a5,-1
    3266:	14f50363          	beq	a0,a5,33ac <sbrktest+0x24c>
    printf("sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    326a:	4501                	li	a0,0
    326c:	00001097          	auipc	ra,0x1
    3270:	d64080e7          	jalr	-668(ra) # 3fd0 <sbrk>
    3274:	862a                	mv	a2,a0
  if(c != a - PGSIZE){
    3276:	77fd                	lui	a5,0xfffff
    3278:	97a6                	add	a5,a5,s1
    327a:	14f51563          	bne	a0,a5,33c4 <sbrktest+0x264>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    327e:	4501                	li	a0,0
    3280:	00001097          	auipc	ra,0x1
    3284:	d50080e7          	jalr	-688(ra) # 3fd0 <sbrk>
    3288:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    328a:	6505                	lui	a0,0x1
    328c:	00001097          	auipc	ra,0x1
    3290:	d44080e7          	jalr	-700(ra) # 3fd0 <sbrk>
    3294:	892a                	mv	s2,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    3296:	14a49463          	bne	s1,a0,33de <sbrktest+0x27e>
    329a:	4501                	li	a0,0
    329c:	00001097          	auipc	ra,0x1
    32a0:	d34080e7          	jalr	-716(ra) # 3fd0 <sbrk>
    32a4:	6785                	lui	a5,0x1
    32a6:	97a6                	add	a5,a5,s1
    32a8:	12f51b63          	bne	a0,a5,33de <sbrktest+0x27e>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    32ac:	064007b7          	lui	a5,0x6400
    32b0:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f457f>
    32b4:	06300793          	li	a5,99
    32b8:	14f70163          	beq	a4,a5,33fa <sbrktest+0x29a>
    // should be zero
    printf("sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    32bc:	4501                	li	a0,0
    32be:	00001097          	auipc	ra,0x1
    32c2:	d12080e7          	jalr	-750(ra) # 3fd0 <sbrk>
    32c6:	892a                	mv	s2,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    32c8:	4501                	li	a0,0
    32ca:	00001097          	auipc	ra,0x1
    32ce:	d06080e7          	jalr	-762(ra) # 3fd0 <sbrk>
    32d2:	40a9853b          	subw	a0,s3,a0
    32d6:	00001097          	auipc	ra,0x1
    32da:	cfa080e7          	jalr	-774(ra) # 3fd0 <sbrk>
    32de:	862a                	mv	a2,a0
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    32e0:	4485                	li	s1,1
    32e2:	04fe                	slli	s1,s1,0x1f
  if(c != a){
    32e4:	12a91763          	bne	s2,a0,3412 <sbrktest+0x2b2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    32e8:	6ab1                	lui	s5,0xc
    32ea:	350a8a93          	addi	s5,s5,848 # c350 <__BSS_END__+0x8d0>
    32ee:	1003da37          	lui	s4,0x1003d
    32f2:	0a0e                	slli	s4,s4,0x3
    32f4:	480a0a13          	addi	s4,s4,1152 # 1003d480 <__BSS_END__+0x10031a00>
    ppid = getpid();
    32f8:	00001097          	auipc	ra,0x1
    32fc:	cd0080e7          	jalr	-816(ra) # 3fc8 <getpid>
    3300:	892a                	mv	s2,a0
    pid = fork();
    3302:	00001097          	auipc	ra,0x1
    3306:	c3e080e7          	jalr	-962(ra) # 3f40 <fork>
    if(pid < 0){
    330a:	12054163          	bltz	a0,342c <sbrktest+0x2cc>
      printf("fork failed\n");
      exit();
    }
    if(pid == 0){
    330e:	12050b63          	beqz	a0,3444 <sbrktest+0x2e4>
      printf("oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    3312:	00001097          	auipc	ra,0x1
    3316:	c3e080e7          	jalr	-962(ra) # 3f50 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    331a:	94d6                	add	s1,s1,s5
    331c:	fd449ee3          	bne	s1,s4,32f8 <sbrktest+0x198>
  }
    
  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3320:	fb840513          	addi	a0,s0,-72
    3324:	00001097          	auipc	ra,0x1
    3328:	c34080e7          	jalr	-972(ra) # 3f58 <pipe>
    332c:	14051063          	bnez	a0,346c <sbrktest+0x30c>
    3330:	f9040493          	addi	s1,s0,-112
    3334:	fb840a13          	addi	s4,s0,-72
    3338:	8926                	mv	s2,s1
      sbrk(BIG - (uint64)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
    333a:	5afd                	li	s5,-1
    333c:	a271                	j	34c8 <sbrktest+0x368>
      printf("sbrk test failed %d %x %x\n", i, a, b);
    333e:	86aa                	mv	a3,a0
    3340:	8626                	mv	a2,s1
    3342:	85ca                	mv	a1,s2
    3344:	00003517          	auipc	a0,0x3
    3348:	96c50513          	addi	a0,a0,-1684 # 5cb0 <malloc+0x1912>
    334c:	00001097          	auipc	ra,0x1
    3350:	f94080e7          	jalr	-108(ra) # 42e0 <printf>
      exit();
    3354:	00001097          	auipc	ra,0x1
    3358:	bf4080e7          	jalr	-1036(ra) # 3f48 <exit>
    printf("sbrk test fork failed\n");
    335c:	00003517          	auipc	a0,0x3
    3360:	97450513          	addi	a0,a0,-1676 # 5cd0 <malloc+0x1932>
    3364:	00001097          	auipc	ra,0x1
    3368:	f7c080e7          	jalr	-132(ra) # 42e0 <printf>
    exit();
    336c:	00001097          	auipc	ra,0x1
    3370:	bdc080e7          	jalr	-1060(ra) # 3f48 <exit>
    printf("sbrk test failed post-fork\n");
    3374:	00003517          	auipc	a0,0x3
    3378:	97450513          	addi	a0,a0,-1676 # 5ce8 <malloc+0x194a>
    337c:	00001097          	auipc	ra,0x1
    3380:	f64080e7          	jalr	-156(ra) # 42e0 <printf>
    exit();
    3384:	00001097          	auipc	ra,0x1
    3388:	bc4080e7          	jalr	-1084(ra) # 3f48 <exit>
    exit();
    338c:	00001097          	auipc	ra,0x1
    3390:	bbc080e7          	jalr	-1092(ra) # 3f48 <exit>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    3394:	00003517          	auipc	a0,0x3
    3398:	97450513          	addi	a0,a0,-1676 # 5d08 <malloc+0x196a>
    339c:	00001097          	auipc	ra,0x1
    33a0:	f44080e7          	jalr	-188(ra) # 42e0 <printf>
    exit();
    33a4:	00001097          	auipc	ra,0x1
    33a8:	ba4080e7          	jalr	-1116(ra) # 3f48 <exit>
    printf("sbrk could not deallocate\n");
    33ac:	00003517          	auipc	a0,0x3
    33b0:	99c50513          	addi	a0,a0,-1636 # 5d48 <malloc+0x19aa>
    33b4:	00001097          	auipc	ra,0x1
    33b8:	f2c080e7          	jalr	-212(ra) # 42e0 <printf>
    exit();
    33bc:	00001097          	auipc	ra,0x1
    33c0:	b8c080e7          	jalr	-1140(ra) # 3f48 <exit>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    33c4:	85a6                	mv	a1,s1
    33c6:	00003517          	auipc	a0,0x3
    33ca:	9a250513          	addi	a0,a0,-1630 # 5d68 <malloc+0x19ca>
    33ce:	00001097          	auipc	ra,0x1
    33d2:	f12080e7          	jalr	-238(ra) # 42e0 <printf>
    exit();
    33d6:	00001097          	auipc	ra,0x1
    33da:	b72080e7          	jalr	-1166(ra) # 3f48 <exit>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    33de:	864a                	mv	a2,s2
    33e0:	85a6                	mv	a1,s1
    33e2:	00003517          	auipc	a0,0x3
    33e6:	9be50513          	addi	a0,a0,-1602 # 5da0 <malloc+0x1a02>
    33ea:	00001097          	auipc	ra,0x1
    33ee:	ef6080e7          	jalr	-266(ra) # 42e0 <printf>
    exit();
    33f2:	00001097          	auipc	ra,0x1
    33f6:	b56080e7          	jalr	-1194(ra) # 3f48 <exit>
    printf("sbrk de-allocation didn't really deallocate\n");
    33fa:	00003517          	auipc	a0,0x3
    33fe:	9ce50513          	addi	a0,a0,-1586 # 5dc8 <malloc+0x1a2a>
    3402:	00001097          	auipc	ra,0x1
    3406:	ede080e7          	jalr	-290(ra) # 42e0 <printf>
    exit();
    340a:	00001097          	auipc	ra,0x1
    340e:	b3e080e7          	jalr	-1218(ra) # 3f48 <exit>
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    3412:	85ca                	mv	a1,s2
    3414:	00003517          	auipc	a0,0x3
    3418:	9e450513          	addi	a0,a0,-1564 # 5df8 <malloc+0x1a5a>
    341c:	00001097          	auipc	ra,0x1
    3420:	ec4080e7          	jalr	-316(ra) # 42e0 <printf>
    exit();
    3424:	00001097          	auipc	ra,0x1
    3428:	b24080e7          	jalr	-1244(ra) # 3f48 <exit>
      printf("fork failed\n");
    342c:	00001517          	auipc	a0,0x1
    3430:	12450513          	addi	a0,a0,292 # 4550 <malloc+0x1b2>
    3434:	00001097          	auipc	ra,0x1
    3438:	eac080e7          	jalr	-340(ra) # 42e0 <printf>
      exit();
    343c:	00001097          	auipc	ra,0x1
    3440:	b0c080e7          	jalr	-1268(ra) # 3f48 <exit>
      printf("oops could read %x = %x\n", a, *a);
    3444:	0004c603          	lbu	a2,0(s1)
    3448:	85a6                	mv	a1,s1
    344a:	00003517          	auipc	a0,0x3
    344e:	9d650513          	addi	a0,a0,-1578 # 5e20 <malloc+0x1a82>
    3452:	00001097          	auipc	ra,0x1
    3456:	e8e080e7          	jalr	-370(ra) # 42e0 <printf>
      kill(ppid);
    345a:	854a                	mv	a0,s2
    345c:	00001097          	auipc	ra,0x1
    3460:	b1c080e7          	jalr	-1252(ra) # 3f78 <kill>
      exit();
    3464:	00001097          	auipc	ra,0x1
    3468:	ae4080e7          	jalr	-1308(ra) # 3f48 <exit>
    printf("pipe() failed\n");
    346c:	00001517          	auipc	a0,0x1
    3470:	56c50513          	addi	a0,a0,1388 # 49d8 <malloc+0x63a>
    3474:	00001097          	auipc	ra,0x1
    3478:	e6c080e7          	jalr	-404(ra) # 42e0 <printf>
    exit();
    347c:	00001097          	auipc	ra,0x1
    3480:	acc080e7          	jalr	-1332(ra) # 3f48 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3484:	4501                	li	a0,0
    3486:	00001097          	auipc	ra,0x1
    348a:	b4a080e7          	jalr	-1206(ra) # 3fd0 <sbrk>
    348e:	064007b7          	lui	a5,0x6400
    3492:	40a7853b          	subw	a0,a5,a0
    3496:	00001097          	auipc	ra,0x1
    349a:	b3a080e7          	jalr	-1222(ra) # 3fd0 <sbrk>
      write(fds[1], "x", 1);
    349e:	4605                	li	a2,1
    34a0:	00001597          	auipc	a1,0x1
    34a4:	5c058593          	addi	a1,a1,1472 # 4a60 <malloc+0x6c2>
    34a8:	fbc42503          	lw	a0,-68(s0)
    34ac:	00001097          	auipc	ra,0x1
    34b0:	abc080e7          	jalr	-1348(ra) # 3f68 <write>
      for(;;) sleep(1000);
    34b4:	3e800513          	li	a0,1000
    34b8:	00001097          	auipc	ra,0x1
    34bc:	b20080e7          	jalr	-1248(ra) # 3fd8 <sleep>
    34c0:	bfd5                	j	34b4 <sbrktest+0x354>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34c2:	0911                	addi	s2,s2,4
    34c4:	03490563          	beq	s2,s4,34ee <sbrktest+0x38e>
    if((pids[i] = fork()) == 0){
    34c8:	00001097          	auipc	ra,0x1
    34cc:	a78080e7          	jalr	-1416(ra) # 3f40 <fork>
    34d0:	00a92023          	sw	a0,0(s2)
    34d4:	d945                	beqz	a0,3484 <sbrktest+0x324>
    if(pids[i] != -1)
    34d6:	ff5506e3          	beq	a0,s5,34c2 <sbrktest+0x362>
      read(fds[0], &scratch, 1);
    34da:	4605                	li	a2,1
    34dc:	f8f40593          	addi	a1,s0,-113
    34e0:	fb842503          	lw	a0,-72(s0)
    34e4:	00001097          	auipc	ra,0x1
    34e8:	a7c080e7          	jalr	-1412(ra) # 3f60 <read>
    34ec:	bfd9                	j	34c2 <sbrktest+0x362>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    34ee:	6505                	lui	a0,0x1
    34f0:	00001097          	auipc	ra,0x1
    34f4:	ae0080e7          	jalr	-1312(ra) # 3fd0 <sbrk>
    34f8:	892a                	mv	s2,a0
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    34fa:	5afd                	li	s5,-1
    34fc:	a021                	j	3504 <sbrktest+0x3a4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34fe:	0491                	addi	s1,s1,4
    3500:	01448e63          	beq	s1,s4,351c <sbrktest+0x3bc>
    if(pids[i] == -1)
    3504:	4088                	lw	a0,0(s1)
    3506:	ff550ce3          	beq	a0,s5,34fe <sbrktest+0x39e>
      continue;
    kill(pids[i]);
    350a:	00001097          	auipc	ra,0x1
    350e:	a6e080e7          	jalr	-1426(ra) # 3f78 <kill>
    wait();
    3512:	00001097          	auipc	ra,0x1
    3516:	a3e080e7          	jalr	-1474(ra) # 3f50 <wait>
    351a:	b7d5                	j	34fe <sbrktest+0x39e>
  }
  if(c == (char*)0xffffffffffffffffL){
    351c:	57fd                	li	a5,-1
    351e:	0af90e63          	beq	s2,a5,35da <sbrktest+0x47a>
    printf("failed sbrk leaked memory\n");
    exit();
  }

  // test running fork with the above allocated page 
  ppid = getpid();
    3522:	00001097          	auipc	ra,0x1
    3526:	aa6080e7          	jalr	-1370(ra) # 3fc8 <getpid>
    352a:	8a2a                	mv	s4,a0
  pid = fork();
    352c:	00001097          	auipc	ra,0x1
    3530:	a14080e7          	jalr	-1516(ra) # 3f40 <fork>
    3534:	84aa                	mv	s1,a0
  if(pid < 0){
    3536:	0a054e63          	bltz	a0,35f2 <sbrktest+0x492>
    printf("fork failed\n");
    exit();
  }

  // test out of memory during sbrk
  if(pid == 0){
    353a:	c961                	beqz	a0,360a <sbrktest+0x4aa>
    }
    printf("allocate a lot of memory succeeded %d\n", n);
    kill(ppid);
    exit();
  }
  wait();
    353c:	00001097          	auipc	ra,0x1
    3540:	a14080e7          	jalr	-1516(ra) # 3f50 <wait>

  // test reads from allocated memory
  a = sbrk(PGSIZE);
    3544:	6505                	lui	a0,0x1
    3546:	00001097          	auipc	ra,0x1
    354a:	a8a080e7          	jalr	-1398(ra) # 3fd0 <sbrk>
    354e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    3550:	20100593          	li	a1,513
    3554:	00003517          	auipc	a0,0x3
    3558:	93450513          	addi	a0,a0,-1740 # 5e88 <malloc+0x1aea>
    355c:	00001097          	auipc	ra,0x1
    3560:	a2c080e7          	jalr	-1492(ra) # 3f88 <open>
    3564:	84aa                	mv	s1,a0
  unlink("sbrk");
    3566:	00003517          	auipc	a0,0x3
    356a:	92250513          	addi	a0,a0,-1758 # 5e88 <malloc+0x1aea>
    356e:	00001097          	auipc	ra,0x1
    3572:	a2a080e7          	jalr	-1494(ra) # 3f98 <unlink>
  if(fd < 0)  {
    3576:	0e04c363          	bltz	s1,365c <sbrktest+0x4fc>
    printf("open sbrk failed\n");
    exit();
  }
  if ((n = write(fd, a, 10)) < 0) {
    357a:	4629                	li	a2,10
    357c:	85ca                	mv	a1,s2
    357e:	8526                	mv	a0,s1
    3580:	00001097          	auipc	ra,0x1
    3584:	9e8080e7          	jalr	-1560(ra) # 3f68 <write>
    3588:	0e054663          	bltz	a0,3674 <sbrktest+0x514>
    printf("write sbrk failed\n");
    exit();
  }
  close(fd);
    358c:	8526                	mv	a0,s1
    358e:	00001097          	auipc	ra,0x1
    3592:	9e2080e7          	jalr	-1566(ra) # 3f70 <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    3596:	6505                	lui	a0,0x1
    3598:	00001097          	auipc	ra,0x1
    359c:	a38080e7          	jalr	-1480(ra) # 3fd0 <sbrk>
  if(pipe((int *) a) != 0){
    35a0:	00001097          	auipc	ra,0x1
    35a4:	9b8080e7          	jalr	-1608(ra) # 3f58 <pipe>
    35a8:	e175                	bnez	a0,368c <sbrktest+0x52c>
    printf("pipe() failed\n");
    exit();
  } 

  if(sbrk(0) > oldbrk)
    35aa:	4501                	li	a0,0
    35ac:	00001097          	auipc	ra,0x1
    35b0:	a24080e7          	jalr	-1500(ra) # 3fd0 <sbrk>
    35b4:	0ea9e863          	bltu	s3,a0,36a4 <sbrktest+0x544>
    sbrk(-(sbrk(0) - oldbrk));

  printf("sbrk test OK\n");
    35b8:	00003517          	auipc	a0,0x3
    35bc:	90850513          	addi	a0,a0,-1784 # 5ec0 <malloc+0x1b22>
    35c0:	00001097          	auipc	ra,0x1
    35c4:	d20080e7          	jalr	-736(ra) # 42e0 <printf>
}
    35c8:	70e6                	ld	ra,120(sp)
    35ca:	7446                	ld	s0,112(sp)
    35cc:	74a6                	ld	s1,104(sp)
    35ce:	7906                	ld	s2,96(sp)
    35d0:	69e6                	ld	s3,88(sp)
    35d2:	6a46                	ld	s4,80(sp)
    35d4:	6aa6                	ld	s5,72(sp)
    35d6:	6109                	addi	sp,sp,128
    35d8:	8082                	ret
    printf("failed sbrk leaked memory\n");
    35da:	00003517          	auipc	a0,0x3
    35de:	86650513          	addi	a0,a0,-1946 # 5e40 <malloc+0x1aa2>
    35e2:	00001097          	auipc	ra,0x1
    35e6:	cfe080e7          	jalr	-770(ra) # 42e0 <printf>
    exit();
    35ea:	00001097          	auipc	ra,0x1
    35ee:	95e080e7          	jalr	-1698(ra) # 3f48 <exit>
    printf("fork failed\n");
    35f2:	00001517          	auipc	a0,0x1
    35f6:	f5e50513          	addi	a0,a0,-162 # 4550 <malloc+0x1b2>
    35fa:	00001097          	auipc	ra,0x1
    35fe:	ce6080e7          	jalr	-794(ra) # 42e0 <printf>
    exit();
    3602:	00001097          	auipc	ra,0x1
    3606:	946080e7          	jalr	-1722(ra) # 3f48 <exit>
    a = sbrk(0);
    360a:	4501                	li	a0,0
    360c:	00001097          	auipc	ra,0x1
    3610:	9c4080e7          	jalr	-1596(ra) # 3fd0 <sbrk>
    3614:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3616:	3e800537          	lui	a0,0x3e800
    361a:	00001097          	auipc	ra,0x1
    361e:	9b6080e7          	jalr	-1610(ra) # 3fd0 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3622:	87ca                	mv	a5,s2
    3624:	3e800737          	lui	a4,0x3e800
    3628:	993a                	add	s2,s2,a4
    362a:	6705                	lui	a4,0x1
      n += *(a+i);
    362c:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f4580>
    3630:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3632:	97ba                	add	a5,a5,a4
    3634:	ff279ce3          	bne	a5,s2,362c <sbrktest+0x4cc>
    printf("allocate a lot of memory succeeded %d\n", n);
    3638:	85a6                	mv	a1,s1
    363a:	00003517          	auipc	a0,0x3
    363e:	82650513          	addi	a0,a0,-2010 # 5e60 <malloc+0x1ac2>
    3642:	00001097          	auipc	ra,0x1
    3646:	c9e080e7          	jalr	-866(ra) # 42e0 <printf>
    kill(ppid);
    364a:	8552                	mv	a0,s4
    364c:	00001097          	auipc	ra,0x1
    3650:	92c080e7          	jalr	-1748(ra) # 3f78 <kill>
    exit();
    3654:	00001097          	auipc	ra,0x1
    3658:	8f4080e7          	jalr	-1804(ra) # 3f48 <exit>
    printf("open sbrk failed\n");
    365c:	00003517          	auipc	a0,0x3
    3660:	83450513          	addi	a0,a0,-1996 # 5e90 <malloc+0x1af2>
    3664:	00001097          	auipc	ra,0x1
    3668:	c7c080e7          	jalr	-900(ra) # 42e0 <printf>
    exit();
    366c:	00001097          	auipc	ra,0x1
    3670:	8dc080e7          	jalr	-1828(ra) # 3f48 <exit>
    printf("write sbrk failed\n");
    3674:	00003517          	auipc	a0,0x3
    3678:	83450513          	addi	a0,a0,-1996 # 5ea8 <malloc+0x1b0a>
    367c:	00001097          	auipc	ra,0x1
    3680:	c64080e7          	jalr	-924(ra) # 42e0 <printf>
    exit();
    3684:	00001097          	auipc	ra,0x1
    3688:	8c4080e7          	jalr	-1852(ra) # 3f48 <exit>
    printf("pipe() failed\n");
    368c:	00001517          	auipc	a0,0x1
    3690:	34c50513          	addi	a0,a0,844 # 49d8 <malloc+0x63a>
    3694:	00001097          	auipc	ra,0x1
    3698:	c4c080e7          	jalr	-948(ra) # 42e0 <printf>
    exit();
    369c:	00001097          	auipc	ra,0x1
    36a0:	8ac080e7          	jalr	-1876(ra) # 3f48 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    36a4:	4501                	li	a0,0
    36a6:	00001097          	auipc	ra,0x1
    36aa:	92a080e7          	jalr	-1750(ra) # 3fd0 <sbrk>
    36ae:	40a9853b          	subw	a0,s3,a0
    36b2:	00001097          	auipc	ra,0x1
    36b6:	91e080e7          	jalr	-1762(ra) # 3fd0 <sbrk>
    36ba:	bdfd                	j	35b8 <sbrktest+0x458>

00000000000036bc <validatetest>:

void
validatetest(void)
{
    36bc:	7139                	addi	sp,sp,-64
    36be:	fc06                	sd	ra,56(sp)
    36c0:	f822                	sd	s0,48(sp)
    36c2:	f426                	sd	s1,40(sp)
    36c4:	f04a                	sd	s2,32(sp)
    36c6:	ec4e                	sd	s3,24(sp)
    36c8:	e852                	sd	s4,16(sp)
    36ca:	e456                	sd	s5,8(sp)
    36cc:	0080                	addi	s0,sp,64
  int hi;
  uint64 p;

  printf("validate test\n");
    36ce:	00003517          	auipc	a0,0x3
    36d2:	80250513          	addi	a0,a0,-2046 # 5ed0 <malloc+0x1b32>
    36d6:	00001097          	auipc	ra,0x1
    36da:	c0a080e7          	jalr	-1014(ra) # 42e0 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += PGSIZE){
    36de:	4481                	li	s1,0
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    36e0:	00003997          	auipc	s3,0x3
    36e4:	80098993          	addi	s3,s3,-2048 # 5ee0 <malloc+0x1b42>
    36e8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    36ea:	6a85                	lui	s5,0x1
    36ec:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    36f0:	85a6                	mv	a1,s1
    36f2:	854e                	mv	a0,s3
    36f4:	00001097          	auipc	ra,0x1
    36f8:	8b4080e7          	jalr	-1868(ra) # 3fa8 <link>
    36fc:	03251663          	bne	a0,s2,3728 <validatetest+0x6c>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3700:	94d6                	add	s1,s1,s5
    3702:	ff4497e3          	bne	s1,s4,36f0 <validatetest+0x34>
      printf("link should not succeed\n");
      exit();
    }
  }

  printf("validate ok\n");
    3706:	00003517          	auipc	a0,0x3
    370a:	80a50513          	addi	a0,a0,-2038 # 5f10 <malloc+0x1b72>
    370e:	00001097          	auipc	ra,0x1
    3712:	bd2080e7          	jalr	-1070(ra) # 42e0 <printf>
}
    3716:	70e2                	ld	ra,56(sp)
    3718:	7442                	ld	s0,48(sp)
    371a:	74a2                	ld	s1,40(sp)
    371c:	7902                	ld	s2,32(sp)
    371e:	69e2                	ld	s3,24(sp)
    3720:	6a42                	ld	s4,16(sp)
    3722:	6aa2                	ld	s5,8(sp)
    3724:	6121                	addi	sp,sp,64
    3726:	8082                	ret
      printf("link should not succeed\n");
    3728:	00002517          	auipc	a0,0x2
    372c:	7c850513          	addi	a0,a0,1992 # 5ef0 <malloc+0x1b52>
    3730:	00001097          	auipc	ra,0x1
    3734:	bb0080e7          	jalr	-1104(ra) # 42e0 <printf>
      exit();
    3738:	00001097          	auipc	ra,0x1
    373c:	810080e7          	jalr	-2032(ra) # 3f48 <exit>

0000000000003740 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3740:	1141                	addi	sp,sp,-16
    3742:	e406                	sd	ra,8(sp)
    3744:	e022                	sd	s0,0(sp)
    3746:	0800                	addi	s0,sp,16
  int i;

  printf("bss test\n");
    3748:	00002517          	auipc	a0,0x2
    374c:	7d850513          	addi	a0,a0,2008 # 5f20 <malloc+0x1b82>
    3750:	00001097          	auipc	ra,0x1
    3754:	b90080e7          	jalr	-1136(ra) # 42e0 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3758:	00003797          	auipc	a5,0x3
    375c:	c0878793          	addi	a5,a5,-1016 # 6360 <uninit>
    3760:	00005697          	auipc	a3,0x5
    3764:	31068693          	addi	a3,a3,784 # 8a70 <buf>
    if(uninit[i] != '\0'){
    3768:	0007c703          	lbu	a4,0(a5)
    376c:	e305                	bnez	a4,378c <bsstest+0x4c>
  for(i = 0; i < sizeof(uninit); i++){
    376e:	0785                	addi	a5,a5,1
    3770:	fed79ce3          	bne	a5,a3,3768 <bsstest+0x28>
      printf("bss test failed\n");
      exit();
    }
  }
  printf("bss test ok\n");
    3774:	00002517          	auipc	a0,0x2
    3778:	7d450513          	addi	a0,a0,2004 # 5f48 <malloc+0x1baa>
    377c:	00001097          	auipc	ra,0x1
    3780:	b64080e7          	jalr	-1180(ra) # 42e0 <printf>
}
    3784:	60a2                	ld	ra,8(sp)
    3786:	6402                	ld	s0,0(sp)
    3788:	0141                	addi	sp,sp,16
    378a:	8082                	ret
      printf("bss test failed\n");
    378c:	00002517          	auipc	a0,0x2
    3790:	7a450513          	addi	a0,a0,1956 # 5f30 <malloc+0x1b92>
    3794:	00001097          	auipc	ra,0x1
    3798:	b4c080e7          	jalr	-1204(ra) # 42e0 <printf>
      exit();
    379c:	00000097          	auipc	ra,0x0
    37a0:	7ac080e7          	jalr	1964(ra) # 3f48 <exit>

00000000000037a4 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    37a4:	1101                	addi	sp,sp,-32
    37a6:	ec06                	sd	ra,24(sp)
    37a8:	e822                	sd	s0,16(sp)
    37aa:	e426                	sd	s1,8(sp)
    37ac:	1000                	addi	s0,sp,32
  int pid, fd;

  unlink("bigarg-ok");
    37ae:	00002517          	auipc	a0,0x2
    37b2:	7aa50513          	addi	a0,a0,1962 # 5f58 <malloc+0x1bba>
    37b6:	00000097          	auipc	ra,0x0
    37ba:	7e2080e7          	jalr	2018(ra) # 3f98 <unlink>
  pid = fork();
    37be:	00000097          	auipc	ra,0x0
    37c2:	782080e7          	jalr	1922(ra) # 3f40 <fork>
  if(pid == 0){
    37c6:	c139                	beqz	a0,380c <bigargtest+0x68>
    exec("echo", args);
    printf("bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    37c8:	0c054363          	bltz	a0,388e <bigargtest+0xea>
    printf("bigargtest: fork failed\n");
    exit();
  }
  wait();
    37cc:	00000097          	auipc	ra,0x0
    37d0:	784080e7          	jalr	1924(ra) # 3f50 <wait>
  fd = open("bigarg-ok", 0);
    37d4:	4581                	li	a1,0
    37d6:	00002517          	auipc	a0,0x2
    37da:	78250513          	addi	a0,a0,1922 # 5f58 <malloc+0x1bba>
    37de:	00000097          	auipc	ra,0x0
    37e2:	7aa080e7          	jalr	1962(ra) # 3f88 <open>
  if(fd < 0){
    37e6:	0c054063          	bltz	a0,38a6 <bigargtest+0x102>
    printf("bigarg test failed!\n");
    exit();
  }
  close(fd);
    37ea:	00000097          	auipc	ra,0x0
    37ee:	786080e7          	jalr	1926(ra) # 3f70 <close>
  unlink("bigarg-ok");
    37f2:	00002517          	auipc	a0,0x2
    37f6:	76650513          	addi	a0,a0,1894 # 5f58 <malloc+0x1bba>
    37fa:	00000097          	auipc	ra,0x0
    37fe:	79e080e7          	jalr	1950(ra) # 3f98 <unlink>
}
    3802:	60e2                	ld	ra,24(sp)
    3804:	6442                	ld	s0,16(sp)
    3806:	64a2                	ld	s1,8(sp)
    3808:	6105                	addi	sp,sp,32
    380a:	8082                	ret
    380c:	00003797          	auipc	a5,0x3
    3810:	a5478793          	addi	a5,a5,-1452 # 6260 <args.1651>
    3814:	00003697          	auipc	a3,0x3
    3818:	b4468693          	addi	a3,a3,-1212 # 6358 <args.1651+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    381c:	00002717          	auipc	a4,0x2
    3820:	74c70713          	addi	a4,a4,1868 # 5f68 <malloc+0x1bca>
    3824:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    3826:	07a1                	addi	a5,a5,8
    3828:	fed79ee3          	bne	a5,a3,3824 <bigargtest+0x80>
    args[MAXARG-1] = 0;
    382c:	00003497          	auipc	s1,0x3
    3830:	a3448493          	addi	s1,s1,-1484 # 6260 <args.1651>
    3834:	0e04bc23          	sd	zero,248(s1)
    printf("bigarg test\n");
    3838:	00003517          	auipc	a0,0x3
    383c:	81050513          	addi	a0,a0,-2032 # 6048 <malloc+0x1caa>
    3840:	00001097          	auipc	ra,0x1
    3844:	aa0080e7          	jalr	-1376(ra) # 42e0 <printf>
    exec("echo", args);
    3848:	85a6                	mv	a1,s1
    384a:	00001517          	auipc	a0,0x1
    384e:	dd650513          	addi	a0,a0,-554 # 4620 <malloc+0x282>
    3852:	00000097          	auipc	ra,0x0
    3856:	72e080e7          	jalr	1838(ra) # 3f80 <exec>
    printf("bigarg test ok\n");
    385a:	00002517          	auipc	a0,0x2
    385e:	7fe50513          	addi	a0,a0,2046 # 6058 <malloc+0x1cba>
    3862:	00001097          	auipc	ra,0x1
    3866:	a7e080e7          	jalr	-1410(ra) # 42e0 <printf>
    fd = open("bigarg-ok", O_CREATE);
    386a:	20000593          	li	a1,512
    386e:	00002517          	auipc	a0,0x2
    3872:	6ea50513          	addi	a0,a0,1770 # 5f58 <malloc+0x1bba>
    3876:	00000097          	auipc	ra,0x0
    387a:	712080e7          	jalr	1810(ra) # 3f88 <open>
    close(fd);
    387e:	00000097          	auipc	ra,0x0
    3882:	6f2080e7          	jalr	1778(ra) # 3f70 <close>
    exit();
    3886:	00000097          	auipc	ra,0x0
    388a:	6c2080e7          	jalr	1730(ra) # 3f48 <exit>
    printf("bigargtest: fork failed\n");
    388e:	00002517          	auipc	a0,0x2
    3892:	7da50513          	addi	a0,a0,2010 # 6068 <malloc+0x1cca>
    3896:	00001097          	auipc	ra,0x1
    389a:	a4a080e7          	jalr	-1462(ra) # 42e0 <printf>
    exit();
    389e:	00000097          	auipc	ra,0x0
    38a2:	6aa080e7          	jalr	1706(ra) # 3f48 <exit>
    printf("bigarg test failed!\n");
    38a6:	00002517          	auipc	a0,0x2
    38aa:	7e250513          	addi	a0,a0,2018 # 6088 <malloc+0x1cea>
    38ae:	00001097          	auipc	ra,0x1
    38b2:	a32080e7          	jalr	-1486(ra) # 42e0 <printf>
    exit();
    38b6:	00000097          	auipc	ra,0x0
    38ba:	692080e7          	jalr	1682(ra) # 3f48 <exit>

00000000000038be <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    38be:	7171                	addi	sp,sp,-176
    38c0:	f506                	sd	ra,168(sp)
    38c2:	f122                	sd	s0,160(sp)
    38c4:	ed26                	sd	s1,152(sp)
    38c6:	e94a                	sd	s2,144(sp)
    38c8:	e54e                	sd	s3,136(sp)
    38ca:	e152                	sd	s4,128(sp)
    38cc:	fcd6                	sd	s5,120(sp)
    38ce:	f8da                	sd	s6,112(sp)
    38d0:	f4de                	sd	s7,104(sp)
    38d2:	f0e2                	sd	s8,96(sp)
    38d4:	ece6                	sd	s9,88(sp)
    38d6:	e8ea                	sd	s10,80(sp)
    38d8:	e4ee                	sd	s11,72(sp)
    38da:	1900                	addi	s0,sp,176
  int nfiles;
  int fsblocks = 0;

  printf("fsfull test\n");
    38dc:	00002517          	auipc	a0,0x2
    38e0:	7c450513          	addi	a0,a0,1988 # 60a0 <malloc+0x1d02>
    38e4:	00001097          	auipc	ra,0x1
    38e8:	9fc080e7          	jalr	-1540(ra) # 42e0 <printf>

  for(nfiles = 0; ; nfiles++){
    38ec:	4481                	li	s1,0
    char name[64];
    name[0] = 'f';
    38ee:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    38f2:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    38f6:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    38fa:	4b29                	li	s6,10
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf("writing %s\n", name);
    38fc:	00002c97          	auipc	s9,0x2
    3900:	7b4c8c93          	addi	s9,s9,1972 # 60b0 <malloc+0x1d12>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf("open %s failed\n", name);
      break;
    }
    int total = 0;
    3904:	4d81                	li	s11,0
    while(1){
      int cc = write(fd, buf, BSIZE);
    3906:	00005a17          	auipc	s4,0x5
    390a:	16aa0a13          	addi	s4,s4,362 # 8a70 <buf>
    name[0] = 'f';
    390e:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3912:	0384c7bb          	divw	a5,s1,s8
    3916:	0307879b          	addiw	a5,a5,48
    391a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    391e:	0384e7bb          	remw	a5,s1,s8
    3922:	0377c7bb          	divw	a5,a5,s7
    3926:	0307879b          	addiw	a5,a5,48
    392a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    392e:	0374e7bb          	remw	a5,s1,s7
    3932:	0367c7bb          	divw	a5,a5,s6
    3936:	0307879b          	addiw	a5,a5,48
    393a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    393e:	0364e7bb          	remw	a5,s1,s6
    3942:	0307879b          	addiw	a5,a5,48
    3946:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    394a:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    394e:	f5040593          	addi	a1,s0,-176
    3952:	8566                	mv	a0,s9
    3954:	00001097          	auipc	ra,0x1
    3958:	98c080e7          	jalr	-1652(ra) # 42e0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    395c:	20200593          	li	a1,514
    3960:	f5040513          	addi	a0,s0,-176
    3964:	00000097          	auipc	ra,0x0
    3968:	624080e7          	jalr	1572(ra) # 3f88 <open>
    396c:	892a                	mv	s2,a0
    if(fd < 0){
    396e:	0a055663          	bgez	a0,3a1a <fsfull+0x15c>
      printf("open %s failed\n", name);
    3972:	f5040593          	addi	a1,s0,-176
    3976:	00002517          	auipc	a0,0x2
    397a:	74a50513          	addi	a0,a0,1866 # 60c0 <malloc+0x1d22>
    397e:	00001097          	auipc	ra,0x1
    3982:	962080e7          	jalr	-1694(ra) # 42e0 <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3986:	0604c363          	bltz	s1,39ec <fsfull+0x12e>
    char name[64];
    name[0] = 'f';
    398a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    398e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3992:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3996:	4929                	li	s2,10
  while(nfiles >= 0){
    3998:	5afd                	li	s5,-1
    name[0] = 'f';
    399a:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    399e:	0344c7bb          	divw	a5,s1,s4
    39a2:	0307879b          	addiw	a5,a5,48
    39a6:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    39aa:	0344e7bb          	remw	a5,s1,s4
    39ae:	0337c7bb          	divw	a5,a5,s3
    39b2:	0307879b          	addiw	a5,a5,48
    39b6:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    39ba:	0334e7bb          	remw	a5,s1,s3
    39be:	0327c7bb          	divw	a5,a5,s2
    39c2:	0307879b          	addiw	a5,a5,48
    39c6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    39ca:	0324e7bb          	remw	a5,s1,s2
    39ce:	0307879b          	addiw	a5,a5,48
    39d2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    39d6:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    39da:	f5040513          	addi	a0,s0,-176
    39de:	00000097          	auipc	ra,0x0
    39e2:	5ba080e7          	jalr	1466(ra) # 3f98 <unlink>
    nfiles--;
    39e6:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    39e8:	fb5499e3          	bne	s1,s5,399a <fsfull+0xdc>
  }

  printf("fsfull test finished\n");
    39ec:	00002517          	auipc	a0,0x2
    39f0:	6f450513          	addi	a0,a0,1780 # 60e0 <malloc+0x1d42>
    39f4:	00001097          	auipc	ra,0x1
    39f8:	8ec080e7          	jalr	-1812(ra) # 42e0 <printf>
}
    39fc:	70aa                	ld	ra,168(sp)
    39fe:	740a                	ld	s0,160(sp)
    3a00:	64ea                	ld	s1,152(sp)
    3a02:	694a                	ld	s2,144(sp)
    3a04:	69aa                	ld	s3,136(sp)
    3a06:	6a0a                	ld	s4,128(sp)
    3a08:	7ae6                	ld	s5,120(sp)
    3a0a:	7b46                	ld	s6,112(sp)
    3a0c:	7ba6                	ld	s7,104(sp)
    3a0e:	7c06                	ld	s8,96(sp)
    3a10:	6ce6                	ld	s9,88(sp)
    3a12:	6d46                	ld	s10,80(sp)
    3a14:	6da6                	ld	s11,72(sp)
    3a16:	614d                	addi	sp,sp,176
    3a18:	8082                	ret
    int total = 0;
    3a1a:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3a1c:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3a20:	40000613          	li	a2,1024
    3a24:	85d2                	mv	a1,s4
    3a26:	854a                	mv	a0,s2
    3a28:	00000097          	auipc	ra,0x0
    3a2c:	540080e7          	jalr	1344(ra) # 3f68 <write>
      if(cc < BSIZE)
    3a30:	00aad563          	bge	s5,a0,3a3a <fsfull+0x17c>
      total += cc;
    3a34:	00a989bb          	addw	s3,s3,a0
    while(1){
    3a38:	b7e5                	j	3a20 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    3a3a:	85ce                	mv	a1,s3
    3a3c:	00002517          	auipc	a0,0x2
    3a40:	69450513          	addi	a0,a0,1684 # 60d0 <malloc+0x1d32>
    3a44:	00001097          	auipc	ra,0x1
    3a48:	89c080e7          	jalr	-1892(ra) # 42e0 <printf>
    close(fd);
    3a4c:	854a                	mv	a0,s2
    3a4e:	00000097          	auipc	ra,0x0
    3a52:	522080e7          	jalr	1314(ra) # 3f70 <close>
    if(total == 0)
    3a56:	f20988e3          	beqz	s3,3986 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3a5a:	2485                	addiw	s1,s1,1
    3a5c:	bd4d                	j	390e <fsfull+0x50>

0000000000003a5e <argptest>:

void argptest()
{
    3a5e:	1101                	addi	sp,sp,-32
    3a60:	ec06                	sd	ra,24(sp)
    3a62:	e822                	sd	s0,16(sp)
    3a64:	e426                	sd	s1,8(sp)
    3a66:	1000                	addi	s0,sp,32
  int fd;
  fd = open("init", O_RDONLY);
    3a68:	4581                	li	a1,0
    3a6a:	00002517          	auipc	a0,0x2
    3a6e:	68e50513          	addi	a0,a0,1678 # 60f8 <malloc+0x1d5a>
    3a72:	00000097          	auipc	ra,0x0
    3a76:	516080e7          	jalr	1302(ra) # 3f88 <open>
  if (fd < 0) {
    3a7a:	04054263          	bltz	a0,3abe <argptest+0x60>
    3a7e:	84aa                	mv	s1,a0
    fprintf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    3a80:	4501                	li	a0,0
    3a82:	00000097          	auipc	ra,0x0
    3a86:	54e080e7          	jalr	1358(ra) # 3fd0 <sbrk>
    3a8a:	567d                	li	a2,-1
    3a8c:	fff50593          	addi	a1,a0,-1
    3a90:	8526                	mv	a0,s1
    3a92:	00000097          	auipc	ra,0x0
    3a96:	4ce080e7          	jalr	1230(ra) # 3f60 <read>
  close(fd);
    3a9a:	8526                	mv	a0,s1
    3a9c:	00000097          	auipc	ra,0x0
    3aa0:	4d4080e7          	jalr	1236(ra) # 3f70 <close>
  printf("arg test passed\n");
    3aa4:	00002517          	auipc	a0,0x2
    3aa8:	66c50513          	addi	a0,a0,1644 # 6110 <malloc+0x1d72>
    3aac:	00001097          	auipc	ra,0x1
    3ab0:	834080e7          	jalr	-1996(ra) # 42e0 <printf>
}
    3ab4:	60e2                	ld	ra,24(sp)
    3ab6:	6442                	ld	s0,16(sp)
    3ab8:	64a2                	ld	s1,8(sp)
    3aba:	6105                	addi	sp,sp,32
    3abc:	8082                	ret
    fprintf(2, "open failed\n");
    3abe:	00002597          	auipc	a1,0x2
    3ac2:	64258593          	addi	a1,a1,1602 # 6100 <malloc+0x1d62>
    3ac6:	4509                	li	a0,2
    3ac8:	00000097          	auipc	ra,0x0
    3acc:	7ea080e7          	jalr	2026(ra) # 42b2 <fprintf>
    exit();
    3ad0:	00000097          	auipc	ra,0x0
    3ad4:	478080e7          	jalr	1144(ra) # 3f48 <exit>

0000000000003ad8 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3ad8:	1141                	addi	sp,sp,-16
    3ada:	e422                	sd	s0,8(sp)
    3adc:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3ade:	00002717          	auipc	a4,0x2
    3ae2:	76a70713          	addi	a4,a4,1898 # 6248 <randstate>
    3ae6:	6308                	ld	a0,0(a4)
    3ae8:	001967b7          	lui	a5,0x196
    3aec:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18ab8d>
    3af0:	02f50533          	mul	a0,a0,a5
    3af4:	3c6ef7b7          	lui	a5,0x3c6ef
    3af8:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e38df>
    3afc:	953e                	add	a0,a0,a5
    3afe:	e308                	sd	a0,0(a4)
  return randstate;
}
    3b00:	2501                	sext.w	a0,a0
    3b02:	6422                	ld	s0,8(sp)
    3b04:	0141                	addi	sp,sp,16
    3b06:	8082                	ret

0000000000003b08 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest()
{
    3b08:	1101                	addi	sp,sp,-32
    3b0a:	ec06                	sd	ra,24(sp)
    3b0c:	e822                	sd	s0,16(sp)
    3b0e:	e426                	sd	s1,8(sp)
    3b10:	1000                	addi	s0,sp,32
  int pid;
  int ppid = getpid();
    3b12:	00000097          	auipc	ra,0x0
    3b16:	4b6080e7          	jalr	1206(ra) # 3fc8 <getpid>
    3b1a:	84aa                	mv	s1,a0
  
  printf("stack guard test\n");
    3b1c:	00002517          	auipc	a0,0x2
    3b20:	60c50513          	addi	a0,a0,1548 # 6128 <malloc+0x1d8a>
    3b24:	00000097          	auipc	ra,0x0
    3b28:	7bc080e7          	jalr	1980(ra) # 42e0 <printf>
  pid = fork();
    3b2c:	00000097          	auipc	ra,0x0
    3b30:	414080e7          	jalr	1044(ra) # 3f40 <fork>
  if(pid == 0) {
    3b34:	c505                	beqz	a0,3b5c <stacktest+0x54>
    // the *sp should cause a trap.
    printf("stacktest: read below stack %p\n", *sp);
    printf("stacktest: test FAILED\n");
    kill(ppid);
    exit();
  } else if(pid < 0){
    3b36:	06054163          	bltz	a0,3b98 <stacktest+0x90>
    printf("fork failed\n");
    exit();
  }
  wait();
    3b3a:	00000097          	auipc	ra,0x0
    3b3e:	416080e7          	jalr	1046(ra) # 3f50 <wait>
  printf("stack guard test ok\n");
    3b42:	00002517          	auipc	a0,0x2
    3b46:	63650513          	addi	a0,a0,1590 # 6178 <malloc+0x1dda>
    3b4a:	00000097          	auipc	ra,0x0
    3b4e:	796080e7          	jalr	1942(ra) # 42e0 <printf>
}
    3b52:	60e2                	ld	ra,24(sp)
    3b54:	6442                	ld	s0,16(sp)
    3b56:	64a2                	ld	s1,8(sp)
    3b58:	6105                	addi	sp,sp,32
    3b5a:	8082                	ret

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    3b5c:	870a                	mv	a4,sp
    printf("stacktest: read below stack %p\n", *sp);
    3b5e:	77fd                	lui	a5,0xfffff
    3b60:	97ba                	add	a5,a5,a4
    3b62:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff3580>
    3b66:	00002517          	auipc	a0,0x2
    3b6a:	5da50513          	addi	a0,a0,1498 # 6140 <malloc+0x1da2>
    3b6e:	00000097          	auipc	ra,0x0
    3b72:	772080e7          	jalr	1906(ra) # 42e0 <printf>
    printf("stacktest: test FAILED\n");
    3b76:	00002517          	auipc	a0,0x2
    3b7a:	5ea50513          	addi	a0,a0,1514 # 6160 <malloc+0x1dc2>
    3b7e:	00000097          	auipc	ra,0x0
    3b82:	762080e7          	jalr	1890(ra) # 42e0 <printf>
    kill(ppid);
    3b86:	8526                	mv	a0,s1
    3b88:	00000097          	auipc	ra,0x0
    3b8c:	3f0080e7          	jalr	1008(ra) # 3f78 <kill>
    exit();
    3b90:	00000097          	auipc	ra,0x0
    3b94:	3b8080e7          	jalr	952(ra) # 3f48 <exit>
    printf("fork failed\n");
    3b98:	00001517          	auipc	a0,0x1
    3b9c:	9b850513          	addi	a0,a0,-1608 # 4550 <malloc+0x1b2>
    3ba0:	00000097          	auipc	ra,0x0
    3ba4:	740080e7          	jalr	1856(ra) # 42e0 <printf>
    exit();
    3ba8:	00000097          	auipc	ra,0x0
    3bac:	3a0080e7          	jalr	928(ra) # 3f48 <exit>

0000000000003bb0 <main>:

int
main(int argc, char *argv[])
{
    3bb0:	1141                	addi	sp,sp,-16
    3bb2:	e406                	sd	ra,8(sp)
    3bb4:	e022                	sd	s0,0(sp)
    3bb6:	0800                	addi	s0,sp,16
  printf("usertests starting\n");
    3bb8:	00002517          	auipc	a0,0x2
    3bbc:	5d850513          	addi	a0,a0,1496 # 6190 <malloc+0x1df2>
    3bc0:	00000097          	auipc	ra,0x0
    3bc4:	720080e7          	jalr	1824(ra) # 42e0 <printf>

  if(open("usertests.ran", 0) >= 0){
    3bc8:	4581                	li	a1,0
    3bca:	00002517          	auipc	a0,0x2
    3bce:	5de50513          	addi	a0,a0,1502 # 61a8 <malloc+0x1e0a>
    3bd2:	00000097          	auipc	ra,0x0
    3bd6:	3b6080e7          	jalr	950(ra) # 3f88 <open>
    3bda:	00054e63          	bltz	a0,3bf6 <main+0x46>
    printf("already ran user tests -- rebuild fs.img\n");
    3bde:	00002517          	auipc	a0,0x2
    3be2:	5da50513          	addi	a0,a0,1498 # 61b8 <malloc+0x1e1a>
    3be6:	00000097          	auipc	ra,0x0
    3bea:	6fa080e7          	jalr	1786(ra) # 42e0 <printf>
    exit();
    3bee:	00000097          	auipc	ra,0x0
    3bf2:	35a080e7          	jalr	858(ra) # 3f48 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3bf6:	20000593          	li	a1,512
    3bfa:	00002517          	auipc	a0,0x2
    3bfe:	5ae50513          	addi	a0,a0,1454 # 61a8 <malloc+0x1e0a>
    3c02:	00000097          	auipc	ra,0x0
    3c06:	386080e7          	jalr	902(ra) # 3f88 <open>
    3c0a:	00000097          	auipc	ra,0x0
    3c0e:	366080e7          	jalr	870(ra) # 3f70 <close>

  reparent();
    3c12:	ffffd097          	auipc	ra,0xffffd
    3c16:	0a4080e7          	jalr	164(ra) # cb6 <reparent>
  twochildren();
    3c1a:	ffffd097          	auipc	ra,0xffffd
    3c1e:	178080e7          	jalr	376(ra) # d92 <twochildren>
  forkfork();
    3c22:	ffffd097          	auipc	ra,0xffffd
    3c26:	218080e7          	jalr	536(ra) # e3a <forkfork>
  forkforkfork();
    3c2a:	ffffd097          	auipc	ra,0xffffd
    3c2e:	2e6080e7          	jalr	742(ra) # f10 <forkforkfork>
  
  argptest();
    3c32:	00000097          	auipc	ra,0x0
    3c36:	e2c080e7          	jalr	-468(ra) # 3a5e <argptest>
  createdelete();
    3c3a:	ffffe097          	auipc	ra,0xffffe
    3c3e:	864080e7          	jalr	-1948(ra) # 149e <createdelete>
  linkunlink();
    3c42:	ffffe097          	auipc	ra,0xffffe
    3c46:	17c080e7          	jalr	380(ra) # 1dbe <linkunlink>
  concreate();
    3c4a:	ffffe097          	auipc	ra,0xffffe
    3c4e:	e76080e7          	jalr	-394(ra) # 1ac0 <concreate>
  fourfiles();
    3c52:	ffffd097          	auipc	ra,0xffffd
    3c56:	60e080e7          	jalr	1550(ra) # 1260 <fourfiles>
  sharedfd();
    3c5a:	ffffd097          	auipc	ra,0xffffd
    3c5e:	45c080e7          	jalr	1116(ra) # 10b6 <sharedfd>

  bigargtest();
    3c62:	00000097          	auipc	ra,0x0
    3c66:	b42080e7          	jalr	-1214(ra) # 37a4 <bigargtest>
  bigwrite();
    3c6a:	fffff097          	auipc	ra,0xfffff
    3c6e:	b26080e7          	jalr	-1242(ra) # 2790 <bigwrite>
  bigargtest();
    3c72:	00000097          	auipc	ra,0x0
    3c76:	b32080e7          	jalr	-1230(ra) # 37a4 <bigargtest>
  bsstest();
    3c7a:	00000097          	auipc	ra,0x0
    3c7e:	ac6080e7          	jalr	-1338(ra) # 3740 <bsstest>
  sbrktest();
    3c82:	fffff097          	auipc	ra,0xfffff
    3c86:	4de080e7          	jalr	1246(ra) # 3160 <sbrktest>
  validatetest();
    3c8a:	00000097          	auipc	ra,0x0
    3c8e:	a32080e7          	jalr	-1486(ra) # 36bc <validatetest>
  stacktest();
    3c92:	00000097          	auipc	ra,0x0
    3c96:	e76080e7          	jalr	-394(ra) # 3b08 <stacktest>
  
  opentest();
    3c9a:	ffffc097          	auipc	ra,0xffffc
    3c9e:	624080e7          	jalr	1572(ra) # 2be <opentest>
  writetest();
    3ca2:	ffffc097          	auipc	ra,0xffffc
    3ca6:	6b0080e7          	jalr	1712(ra) # 352 <writetest>
  writetest1();
    3caa:	ffffd097          	auipc	ra,0xffffd
    3cae:	87c080e7          	jalr	-1924(ra) # 526 <writetest1>
  createtest();
    3cb2:	ffffd097          	auipc	ra,0xffffd
    3cb6:	a28080e7          	jalr	-1496(ra) # 6da <createtest>

  openiputtest();
    3cba:	ffffc097          	auipc	ra,0xffffc
    3cbe:	510080e7          	jalr	1296(ra) # 1ca <openiputtest>
  exitiputtest();
    3cc2:	ffffc097          	auipc	ra,0xffffc
    3cc6:	41e080e7          	jalr	1054(ra) # e0 <exitiputtest>
  iputtest();
    3cca:	ffffc097          	auipc	ra,0xffffc
    3cce:	336080e7          	jalr	822(ra) # 0 <iputtest>

  mem();
    3cd2:	ffffd097          	auipc	ra,0xffffd
    3cd6:	324080e7          	jalr	804(ra) # ff6 <mem>
  pipe1();
    3cda:	ffffd097          	auipc	ra,0xffffd
    3cde:	be8080e7          	jalr	-1048(ra) # 8c2 <pipe1>
  preempt();
    3ce2:	ffffd097          	auipc	ra,0xffffd
    3ce6:	d96080e7          	jalr	-618(ra) # a78 <preempt>
  exitwait();
    3cea:	ffffd097          	auipc	ra,0xffffd
    3cee:	f36080e7          	jalr	-202(ra) # c20 <exitwait>

  rmdot();
    3cf2:	fffff097          	auipc	ra,0xfffff
    3cf6:	ec0080e7          	jalr	-320(ra) # 2bb2 <rmdot>
  fourteen();
    3cfa:	fffff097          	auipc	ra,0xfffff
    3cfe:	d72080e7          	jalr	-654(ra) # 2a6c <fourteen>
  bigfile();
    3d02:	fffff097          	auipc	ra,0xfffff
    3d06:	b8c080e7          	jalr	-1140(ra) # 288e <bigfile>
  subdir();
    3d0a:	ffffe097          	auipc	ra,0xffffe
    3d0e:	33a080e7          	jalr	826(ra) # 2044 <subdir>
  linktest();
    3d12:	ffffe097          	auipc	ra,0xffffe
    3d16:	b6c080e7          	jalr	-1172(ra) # 187e <linktest>
  unlinkread();
    3d1a:	ffffe097          	auipc	ra,0xffffe
    3d1e:	9ac080e7          	jalr	-1620(ra) # 16c6 <unlinkread>
  dirfile();
    3d22:	fffff097          	auipc	ra,0xfffff
    3d26:	010080e7          	jalr	16(ra) # 2d32 <dirfile>
  iref();
    3d2a:	fffff097          	auipc	ra,0xfffff
    3d2e:	230080e7          	jalr	560(ra) # 2f5a <iref>
  forktest();
    3d32:	fffff097          	auipc	ra,0xfffff
    3d36:	348080e7          	jalr	840(ra) # 307a <forktest>
  bigdir(); // slow
    3d3a:	ffffe097          	auipc	ra,0xffffe
    3d3e:	19c080e7          	jalr	412(ra) # 1ed6 <bigdir>

  exectest();
    3d42:	ffffd097          	auipc	ra,0xffffd
    3d46:	b2c080e7          	jalr	-1236(ra) # 86e <exectest>

  exit();
    3d4a:	00000097          	auipc	ra,0x0
    3d4e:	1fe080e7          	jalr	510(ra) # 3f48 <exit>

0000000000003d52 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    3d52:	1141                	addi	sp,sp,-16
    3d54:	e422                	sd	s0,8(sp)
    3d56:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3d58:	87aa                	mv	a5,a0
    3d5a:	0585                	addi	a1,a1,1
    3d5c:	0785                	addi	a5,a5,1
    3d5e:	fff5c703          	lbu	a4,-1(a1)
    3d62:	fee78fa3          	sb	a4,-1(a5)
    3d66:	fb75                	bnez	a4,3d5a <strcpy+0x8>
    ;
  return os;
}
    3d68:	6422                	ld	s0,8(sp)
    3d6a:	0141                	addi	sp,sp,16
    3d6c:	8082                	ret

0000000000003d6e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3d6e:	1141                	addi	sp,sp,-16
    3d70:	e422                	sd	s0,8(sp)
    3d72:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    3d74:	00054783          	lbu	a5,0(a0)
    3d78:	cb91                	beqz	a5,3d8c <strcmp+0x1e>
    3d7a:	0005c703          	lbu	a4,0(a1)
    3d7e:	00f71763          	bne	a4,a5,3d8c <strcmp+0x1e>
    p++, q++;
    3d82:	0505                	addi	a0,a0,1
    3d84:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    3d86:	00054783          	lbu	a5,0(a0)
    3d8a:	fbe5                	bnez	a5,3d7a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    3d8c:	0005c503          	lbu	a0,0(a1)
}
    3d90:	40a7853b          	subw	a0,a5,a0
    3d94:	6422                	ld	s0,8(sp)
    3d96:	0141                	addi	sp,sp,16
    3d98:	8082                	ret

0000000000003d9a <strlen>:

uint
strlen(const char *s)
{
    3d9a:	1141                	addi	sp,sp,-16
    3d9c:	e422                	sd	s0,8(sp)
    3d9e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    3da0:	00054783          	lbu	a5,0(a0)
    3da4:	cf91                	beqz	a5,3dc0 <strlen+0x26>
    3da6:	0505                	addi	a0,a0,1
    3da8:	87aa                	mv	a5,a0
    3daa:	4685                	li	a3,1
    3dac:	9e89                	subw	a3,a3,a0
    3dae:	00f6853b          	addw	a0,a3,a5
    3db2:	0785                	addi	a5,a5,1
    3db4:	fff7c703          	lbu	a4,-1(a5)
    3db8:	fb7d                	bnez	a4,3dae <strlen+0x14>
    ;
  return n;
}
    3dba:	6422                	ld	s0,8(sp)
    3dbc:	0141                	addi	sp,sp,16
    3dbe:	8082                	ret
  for(n = 0; s[n]; n++)
    3dc0:	4501                	li	a0,0
    3dc2:	bfe5                	j	3dba <strlen+0x20>

0000000000003dc4 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3dc4:	1141                	addi	sp,sp,-16
    3dc6:	e422                	sd	s0,8(sp)
    3dc8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    3dca:	ce09                	beqz	a2,3de4 <memset+0x20>
    3dcc:	87aa                	mv	a5,a0
    3dce:	fff6071b          	addiw	a4,a2,-1
    3dd2:	1702                	slli	a4,a4,0x20
    3dd4:	9301                	srli	a4,a4,0x20
    3dd6:	0705                	addi	a4,a4,1
    3dd8:	972a                	add	a4,a4,a0
    cdst[i] = c;
    3dda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    3dde:	0785                	addi	a5,a5,1
    3de0:	fee79de3          	bne	a5,a4,3dda <memset+0x16>
  }
  return dst;
}
    3de4:	6422                	ld	s0,8(sp)
    3de6:	0141                	addi	sp,sp,16
    3de8:	8082                	ret

0000000000003dea <strchr>:

char*
strchr(const char *s, char c)
{
    3dea:	1141                	addi	sp,sp,-16
    3dec:	e422                	sd	s0,8(sp)
    3dee:	0800                	addi	s0,sp,16
  for(; *s; s++)
    3df0:	00054783          	lbu	a5,0(a0)
    3df4:	cb99                	beqz	a5,3e0a <strchr+0x20>
    if(*s == c)
    3df6:	00f58763          	beq	a1,a5,3e04 <strchr+0x1a>
  for(; *s; s++)
    3dfa:	0505                	addi	a0,a0,1
    3dfc:	00054783          	lbu	a5,0(a0)
    3e00:	fbfd                	bnez	a5,3df6 <strchr+0xc>
      return (char*)s;
  return 0;
    3e02:	4501                	li	a0,0
}
    3e04:	6422                	ld	s0,8(sp)
    3e06:	0141                	addi	sp,sp,16
    3e08:	8082                	ret
  return 0;
    3e0a:	4501                	li	a0,0
    3e0c:	bfe5                	j	3e04 <strchr+0x1a>

0000000000003e0e <gets>:

char*
gets(char *buf, int max)
{
    3e0e:	711d                	addi	sp,sp,-96
    3e10:	ec86                	sd	ra,88(sp)
    3e12:	e8a2                	sd	s0,80(sp)
    3e14:	e4a6                	sd	s1,72(sp)
    3e16:	e0ca                	sd	s2,64(sp)
    3e18:	fc4e                	sd	s3,56(sp)
    3e1a:	f852                	sd	s4,48(sp)
    3e1c:	f456                	sd	s5,40(sp)
    3e1e:	f05a                	sd	s6,32(sp)
    3e20:	ec5e                	sd	s7,24(sp)
    3e22:	1080                	addi	s0,sp,96
    3e24:	8baa                	mv	s7,a0
    3e26:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3e28:	892a                	mv	s2,a0
    3e2a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    3e2c:	4aa9                	li	s5,10
    3e2e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    3e30:	89a6                	mv	s3,s1
    3e32:	2485                	addiw	s1,s1,1
    3e34:	0344d863          	bge	s1,s4,3e64 <gets+0x56>
    cc = read(0, &c, 1);
    3e38:	4605                	li	a2,1
    3e3a:	faf40593          	addi	a1,s0,-81
    3e3e:	4501                	li	a0,0
    3e40:	00000097          	auipc	ra,0x0
    3e44:	120080e7          	jalr	288(ra) # 3f60 <read>
    if(cc < 1)
    3e48:	00a05e63          	blez	a0,3e64 <gets+0x56>
    buf[i++] = c;
    3e4c:	faf44783          	lbu	a5,-81(s0)
    3e50:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    3e54:	01578763          	beq	a5,s5,3e62 <gets+0x54>
    3e58:	0905                	addi	s2,s2,1
    3e5a:	fd679be3          	bne	a5,s6,3e30 <gets+0x22>
  for(i=0; i+1 < max; ){
    3e5e:	89a6                	mv	s3,s1
    3e60:	a011                	j	3e64 <gets+0x56>
    3e62:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    3e64:	99de                	add	s3,s3,s7
    3e66:	00098023          	sb	zero,0(s3)
  return buf;
}
    3e6a:	855e                	mv	a0,s7
    3e6c:	60e6                	ld	ra,88(sp)
    3e6e:	6446                	ld	s0,80(sp)
    3e70:	64a6                	ld	s1,72(sp)
    3e72:	6906                	ld	s2,64(sp)
    3e74:	79e2                	ld	s3,56(sp)
    3e76:	7a42                	ld	s4,48(sp)
    3e78:	7aa2                	ld	s5,40(sp)
    3e7a:	7b02                	ld	s6,32(sp)
    3e7c:	6be2                	ld	s7,24(sp)
    3e7e:	6125                	addi	sp,sp,96
    3e80:	8082                	ret

0000000000003e82 <stat>:

int
stat(const char *n, struct stat *st)
{
    3e82:	1101                	addi	sp,sp,-32
    3e84:	ec06                	sd	ra,24(sp)
    3e86:	e822                	sd	s0,16(sp)
    3e88:	e426                	sd	s1,8(sp)
    3e8a:	e04a                	sd	s2,0(sp)
    3e8c:	1000                	addi	s0,sp,32
    3e8e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3e90:	4581                	li	a1,0
    3e92:	00000097          	auipc	ra,0x0
    3e96:	0f6080e7          	jalr	246(ra) # 3f88 <open>
  if(fd < 0)
    3e9a:	02054563          	bltz	a0,3ec4 <stat+0x42>
    3e9e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    3ea0:	85ca                	mv	a1,s2
    3ea2:	00000097          	auipc	ra,0x0
    3ea6:	0fe080e7          	jalr	254(ra) # 3fa0 <fstat>
    3eaa:	892a                	mv	s2,a0
  close(fd);
    3eac:	8526                	mv	a0,s1
    3eae:	00000097          	auipc	ra,0x0
    3eb2:	0c2080e7          	jalr	194(ra) # 3f70 <close>
  return r;
}
    3eb6:	854a                	mv	a0,s2
    3eb8:	60e2                	ld	ra,24(sp)
    3eba:	6442                	ld	s0,16(sp)
    3ebc:	64a2                	ld	s1,8(sp)
    3ebe:	6902                	ld	s2,0(sp)
    3ec0:	6105                	addi	sp,sp,32
    3ec2:	8082                	ret
    return -1;
    3ec4:	597d                	li	s2,-1
    3ec6:	bfc5                	j	3eb6 <stat+0x34>

0000000000003ec8 <atoi>:

int
atoi(const char *s)
{
    3ec8:	1141                	addi	sp,sp,-16
    3eca:	e422                	sd	s0,8(sp)
    3ecc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3ece:	00054603          	lbu	a2,0(a0)
    3ed2:	fd06079b          	addiw	a5,a2,-48
    3ed6:	0ff7f793          	andi	a5,a5,255
    3eda:	4725                	li	a4,9
    3edc:	02f76963          	bltu	a4,a5,3f0e <atoi+0x46>
    3ee0:	86aa                	mv	a3,a0
  n = 0;
    3ee2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    3ee4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    3ee6:	0685                	addi	a3,a3,1
    3ee8:	0025179b          	slliw	a5,a0,0x2
    3eec:	9fa9                	addw	a5,a5,a0
    3eee:	0017979b          	slliw	a5,a5,0x1
    3ef2:	9fb1                	addw	a5,a5,a2
    3ef4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    3ef8:	0006c603          	lbu	a2,0(a3)
    3efc:	fd06071b          	addiw	a4,a2,-48
    3f00:	0ff77713          	andi	a4,a4,255
    3f04:	fee5f1e3          	bgeu	a1,a4,3ee6 <atoi+0x1e>
  return n;
}
    3f08:	6422                	ld	s0,8(sp)
    3f0a:	0141                	addi	sp,sp,16
    3f0c:	8082                	ret
  n = 0;
    3f0e:	4501                	li	a0,0
    3f10:	bfe5                	j	3f08 <atoi+0x40>

0000000000003f12 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3f12:	1141                	addi	sp,sp,-16
    3f14:	e422                	sd	s0,8(sp)
    3f16:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3f18:	02c05163          	blez	a2,3f3a <memmove+0x28>
    3f1c:	fff6071b          	addiw	a4,a2,-1
    3f20:	1702                	slli	a4,a4,0x20
    3f22:	9301                	srli	a4,a4,0x20
    3f24:	0705                	addi	a4,a4,1
    3f26:	972a                	add	a4,a4,a0
  dst = vdst;
    3f28:	87aa                	mv	a5,a0
    *dst++ = *src++;
    3f2a:	0585                	addi	a1,a1,1
    3f2c:	0785                	addi	a5,a5,1
    3f2e:	fff5c683          	lbu	a3,-1(a1)
    3f32:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    3f36:	fee79ae3          	bne	a5,a4,3f2a <memmove+0x18>
  return vdst;
}
    3f3a:	6422                	ld	s0,8(sp)
    3f3c:	0141                	addi	sp,sp,16
    3f3e:	8082                	ret

0000000000003f40 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    3f40:	4885                	li	a7,1
 ecall
    3f42:	00000073          	ecall
 ret
    3f46:	8082                	ret

0000000000003f48 <exit>:
.global exit
exit:
 li a7, SYS_exit
    3f48:	4889                	li	a7,2
 ecall
    3f4a:	00000073          	ecall
 ret
    3f4e:	8082                	ret

0000000000003f50 <wait>:
.global wait
wait:
 li a7, SYS_wait
    3f50:	488d                	li	a7,3
 ecall
    3f52:	00000073          	ecall
 ret
    3f56:	8082                	ret

0000000000003f58 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    3f58:	4891                	li	a7,4
 ecall
    3f5a:	00000073          	ecall
 ret
    3f5e:	8082                	ret

0000000000003f60 <read>:
.global read
read:
 li a7, SYS_read
    3f60:	4895                	li	a7,5
 ecall
    3f62:	00000073          	ecall
 ret
    3f66:	8082                	ret

0000000000003f68 <write>:
.global write
write:
 li a7, SYS_write
    3f68:	48c1                	li	a7,16
 ecall
    3f6a:	00000073          	ecall
 ret
    3f6e:	8082                	ret

0000000000003f70 <close>:
.global close
close:
 li a7, SYS_close
    3f70:	48d5                	li	a7,21
 ecall
    3f72:	00000073          	ecall
 ret
    3f76:	8082                	ret

0000000000003f78 <kill>:
.global kill
kill:
 li a7, SYS_kill
    3f78:	4899                	li	a7,6
 ecall
    3f7a:	00000073          	ecall
 ret
    3f7e:	8082                	ret

0000000000003f80 <exec>:
.global exec
exec:
 li a7, SYS_exec
    3f80:	489d                	li	a7,7
 ecall
    3f82:	00000073          	ecall
 ret
    3f86:	8082                	ret

0000000000003f88 <open>:
.global open
open:
 li a7, SYS_open
    3f88:	48bd                	li	a7,15
 ecall
    3f8a:	00000073          	ecall
 ret
    3f8e:	8082                	ret

0000000000003f90 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    3f90:	48c5                	li	a7,17
 ecall
    3f92:	00000073          	ecall
 ret
    3f96:	8082                	ret

0000000000003f98 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    3f98:	48c9                	li	a7,18
 ecall
    3f9a:	00000073          	ecall
 ret
    3f9e:	8082                	ret

0000000000003fa0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    3fa0:	48a1                	li	a7,8
 ecall
    3fa2:	00000073          	ecall
 ret
    3fa6:	8082                	ret

0000000000003fa8 <link>:
.global link
link:
 li a7, SYS_link
    3fa8:	48cd                	li	a7,19
 ecall
    3faa:	00000073          	ecall
 ret
    3fae:	8082                	ret

0000000000003fb0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    3fb0:	48d1                	li	a7,20
 ecall
    3fb2:	00000073          	ecall
 ret
    3fb6:	8082                	ret

0000000000003fb8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    3fb8:	48a5                	li	a7,9
 ecall
    3fba:	00000073          	ecall
 ret
    3fbe:	8082                	ret

0000000000003fc0 <dup>:
.global dup
dup:
 li a7, SYS_dup
    3fc0:	48a9                	li	a7,10
 ecall
    3fc2:	00000073          	ecall
 ret
    3fc6:	8082                	ret

0000000000003fc8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    3fc8:	48ad                	li	a7,11
 ecall
    3fca:	00000073          	ecall
 ret
    3fce:	8082                	ret

0000000000003fd0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    3fd0:	48b1                	li	a7,12
 ecall
    3fd2:	00000073          	ecall
 ret
    3fd6:	8082                	ret

0000000000003fd8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    3fd8:	48b5                	li	a7,13
 ecall
    3fda:	00000073          	ecall
 ret
    3fde:	8082                	ret

0000000000003fe0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    3fe0:	48b9                	li	a7,14
 ecall
    3fe2:	00000073          	ecall
 ret
    3fe6:	8082                	ret

0000000000003fe8 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
    3fe8:	48d9                	li	a7,22
 ecall
    3fea:	00000073          	ecall
 ret
    3fee:	8082                	ret

0000000000003ff0 <crash>:
.global crash
crash:
 li a7, SYS_crash
    3ff0:	48dd                	li	a7,23
 ecall
    3ff2:	00000073          	ecall
 ret
    3ff6:	8082                	ret

0000000000003ff8 <mount>:
.global mount
mount:
 li a7, SYS_mount
    3ff8:	48e1                	li	a7,24
 ecall
    3ffa:	00000073          	ecall
 ret
    3ffe:	8082                	ret

0000000000004000 <umount>:
.global umount
umount:
 li a7, SYS_umount
    4000:	48e5                	li	a7,25
 ecall
    4002:	00000073          	ecall
 ret
    4006:	8082                	ret

0000000000004008 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4008:	1101                	addi	sp,sp,-32
    400a:	ec06                	sd	ra,24(sp)
    400c:	e822                	sd	s0,16(sp)
    400e:	1000                	addi	s0,sp,32
    4010:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4014:	4605                	li	a2,1
    4016:	fef40593          	addi	a1,s0,-17
    401a:	00000097          	auipc	ra,0x0
    401e:	f4e080e7          	jalr	-178(ra) # 3f68 <write>
}
    4022:	60e2                	ld	ra,24(sp)
    4024:	6442                	ld	s0,16(sp)
    4026:	6105                	addi	sp,sp,32
    4028:	8082                	ret

000000000000402a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    402a:	7139                	addi	sp,sp,-64
    402c:	fc06                	sd	ra,56(sp)
    402e:	f822                	sd	s0,48(sp)
    4030:	f426                	sd	s1,40(sp)
    4032:	f04a                	sd	s2,32(sp)
    4034:	ec4e                	sd	s3,24(sp)
    4036:	0080                	addi	s0,sp,64
    4038:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    403a:	c299                	beqz	a3,4040 <printint+0x16>
    403c:	0805c863          	bltz	a1,40cc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4040:	2581                	sext.w	a1,a1
  neg = 0;
    4042:	4881                	li	a7,0
    4044:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4048:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    404a:	2601                	sext.w	a2,a2
    404c:	00002517          	auipc	a0,0x2
    4050:	1bc50513          	addi	a0,a0,444 # 6208 <digits>
    4054:	883a                	mv	a6,a4
    4056:	2705                	addiw	a4,a4,1
    4058:	02c5f7bb          	remuw	a5,a1,a2
    405c:	1782                	slli	a5,a5,0x20
    405e:	9381                	srli	a5,a5,0x20
    4060:	97aa                	add	a5,a5,a0
    4062:	0007c783          	lbu	a5,0(a5)
    4066:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    406a:	0005879b          	sext.w	a5,a1
    406e:	02c5d5bb          	divuw	a1,a1,a2
    4072:	0685                	addi	a3,a3,1
    4074:	fec7f0e3          	bgeu	a5,a2,4054 <printint+0x2a>
  if(neg)
    4078:	00088b63          	beqz	a7,408e <printint+0x64>
    buf[i++] = '-';
    407c:	fd040793          	addi	a5,s0,-48
    4080:	973e                	add	a4,a4,a5
    4082:	02d00793          	li	a5,45
    4086:	fef70823          	sb	a5,-16(a4)
    408a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    408e:	02e05863          	blez	a4,40be <printint+0x94>
    4092:	fc040793          	addi	a5,s0,-64
    4096:	00e78933          	add	s2,a5,a4
    409a:	fff78993          	addi	s3,a5,-1
    409e:	99ba                	add	s3,s3,a4
    40a0:	377d                	addiw	a4,a4,-1
    40a2:	1702                	slli	a4,a4,0x20
    40a4:	9301                	srli	a4,a4,0x20
    40a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    40aa:	fff94583          	lbu	a1,-1(s2)
    40ae:	8526                	mv	a0,s1
    40b0:	00000097          	auipc	ra,0x0
    40b4:	f58080e7          	jalr	-168(ra) # 4008 <putc>
  while(--i >= 0)
    40b8:	197d                	addi	s2,s2,-1
    40ba:	ff3918e3          	bne	s2,s3,40aa <printint+0x80>
}
    40be:	70e2                	ld	ra,56(sp)
    40c0:	7442                	ld	s0,48(sp)
    40c2:	74a2                	ld	s1,40(sp)
    40c4:	7902                	ld	s2,32(sp)
    40c6:	69e2                	ld	s3,24(sp)
    40c8:	6121                	addi	sp,sp,64
    40ca:	8082                	ret
    x = -xx;
    40cc:	40b005bb          	negw	a1,a1
    neg = 1;
    40d0:	4885                	li	a7,1
    x = -xx;
    40d2:	bf8d                	j	4044 <printint+0x1a>

00000000000040d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    40d4:	7119                	addi	sp,sp,-128
    40d6:	fc86                	sd	ra,120(sp)
    40d8:	f8a2                	sd	s0,112(sp)
    40da:	f4a6                	sd	s1,104(sp)
    40dc:	f0ca                	sd	s2,96(sp)
    40de:	ecce                	sd	s3,88(sp)
    40e0:	e8d2                	sd	s4,80(sp)
    40e2:	e4d6                	sd	s5,72(sp)
    40e4:	e0da                	sd	s6,64(sp)
    40e6:	fc5e                	sd	s7,56(sp)
    40e8:	f862                	sd	s8,48(sp)
    40ea:	f466                	sd	s9,40(sp)
    40ec:	f06a                	sd	s10,32(sp)
    40ee:	ec6e                	sd	s11,24(sp)
    40f0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    40f2:	0005c903          	lbu	s2,0(a1)
    40f6:	18090f63          	beqz	s2,4294 <vprintf+0x1c0>
    40fa:	8aaa                	mv	s5,a0
    40fc:	8b32                	mv	s6,a2
    40fe:	00158493          	addi	s1,a1,1
  state = 0;
    4102:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    4104:	02500a13          	li	s4,37
      if(c == 'd'){
    4108:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    410c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    4110:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    4114:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4118:	00002b97          	auipc	s7,0x2
    411c:	0f0b8b93          	addi	s7,s7,240 # 6208 <digits>
    4120:	a839                	j	413e <vprintf+0x6a>
        putc(fd, c);
    4122:	85ca                	mv	a1,s2
    4124:	8556                	mv	a0,s5
    4126:	00000097          	auipc	ra,0x0
    412a:	ee2080e7          	jalr	-286(ra) # 4008 <putc>
    412e:	a019                	j	4134 <vprintf+0x60>
    } else if(state == '%'){
    4130:	01498f63          	beq	s3,s4,414e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4134:	0485                	addi	s1,s1,1
    4136:	fff4c903          	lbu	s2,-1(s1)
    413a:	14090d63          	beqz	s2,4294 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    413e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4142:	fe0997e3          	bnez	s3,4130 <vprintf+0x5c>
      if(c == '%'){
    4146:	fd479ee3          	bne	a5,s4,4122 <vprintf+0x4e>
        state = '%';
    414a:	89be                	mv	s3,a5
    414c:	b7e5                	j	4134 <vprintf+0x60>
      if(c == 'd'){
    414e:	05878063          	beq	a5,s8,418e <vprintf+0xba>
      } else if(c == 'l') {
    4152:	05978c63          	beq	a5,s9,41aa <vprintf+0xd6>
      } else if(c == 'x') {
    4156:	07a78863          	beq	a5,s10,41c6 <vprintf+0xf2>
      } else if(c == 'p') {
    415a:	09b78463          	beq	a5,s11,41e2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    415e:	07300713          	li	a4,115
    4162:	0ce78663          	beq	a5,a4,422e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4166:	06300713          	li	a4,99
    416a:	0ee78e63          	beq	a5,a4,4266 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    416e:	11478863          	beq	a5,s4,427e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4172:	85d2                	mv	a1,s4
    4174:	8556                	mv	a0,s5
    4176:	00000097          	auipc	ra,0x0
    417a:	e92080e7          	jalr	-366(ra) # 4008 <putc>
        putc(fd, c);
    417e:	85ca                	mv	a1,s2
    4180:	8556                	mv	a0,s5
    4182:	00000097          	auipc	ra,0x0
    4186:	e86080e7          	jalr	-378(ra) # 4008 <putc>
      }
      state = 0;
    418a:	4981                	li	s3,0
    418c:	b765                	j	4134 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    418e:	008b0913          	addi	s2,s6,8
    4192:	4685                	li	a3,1
    4194:	4629                	li	a2,10
    4196:	000b2583          	lw	a1,0(s6)
    419a:	8556                	mv	a0,s5
    419c:	00000097          	auipc	ra,0x0
    41a0:	e8e080e7          	jalr	-370(ra) # 402a <printint>
    41a4:	8b4a                	mv	s6,s2
      state = 0;
    41a6:	4981                	li	s3,0
    41a8:	b771                	j	4134 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    41aa:	008b0913          	addi	s2,s6,8
    41ae:	4681                	li	a3,0
    41b0:	4629                	li	a2,10
    41b2:	000b2583          	lw	a1,0(s6)
    41b6:	8556                	mv	a0,s5
    41b8:	00000097          	auipc	ra,0x0
    41bc:	e72080e7          	jalr	-398(ra) # 402a <printint>
    41c0:	8b4a                	mv	s6,s2
      state = 0;
    41c2:	4981                	li	s3,0
    41c4:	bf85                	j	4134 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    41c6:	008b0913          	addi	s2,s6,8
    41ca:	4681                	li	a3,0
    41cc:	4641                	li	a2,16
    41ce:	000b2583          	lw	a1,0(s6)
    41d2:	8556                	mv	a0,s5
    41d4:	00000097          	auipc	ra,0x0
    41d8:	e56080e7          	jalr	-426(ra) # 402a <printint>
    41dc:	8b4a                	mv	s6,s2
      state = 0;
    41de:	4981                	li	s3,0
    41e0:	bf91                	j	4134 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    41e2:	008b0793          	addi	a5,s6,8
    41e6:	f8f43423          	sd	a5,-120(s0)
    41ea:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    41ee:	03000593          	li	a1,48
    41f2:	8556                	mv	a0,s5
    41f4:	00000097          	auipc	ra,0x0
    41f8:	e14080e7          	jalr	-492(ra) # 4008 <putc>
  putc(fd, 'x');
    41fc:	85ea                	mv	a1,s10
    41fe:	8556                	mv	a0,s5
    4200:	00000097          	auipc	ra,0x0
    4204:	e08080e7          	jalr	-504(ra) # 4008 <putc>
    4208:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    420a:	03c9d793          	srli	a5,s3,0x3c
    420e:	97de                	add	a5,a5,s7
    4210:	0007c583          	lbu	a1,0(a5)
    4214:	8556                	mv	a0,s5
    4216:	00000097          	auipc	ra,0x0
    421a:	df2080e7          	jalr	-526(ra) # 4008 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    421e:	0992                	slli	s3,s3,0x4
    4220:	397d                	addiw	s2,s2,-1
    4222:	fe0914e3          	bnez	s2,420a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    4226:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    422a:	4981                	li	s3,0
    422c:	b721                	j	4134 <vprintf+0x60>
        s = va_arg(ap, char*);
    422e:	008b0993          	addi	s3,s6,8
    4232:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    4236:	02090163          	beqz	s2,4258 <vprintf+0x184>
        while(*s != 0){
    423a:	00094583          	lbu	a1,0(s2)
    423e:	c9a1                	beqz	a1,428e <vprintf+0x1ba>
          putc(fd, *s);
    4240:	8556                	mv	a0,s5
    4242:	00000097          	auipc	ra,0x0
    4246:	dc6080e7          	jalr	-570(ra) # 4008 <putc>
          s++;
    424a:	0905                	addi	s2,s2,1
        while(*s != 0){
    424c:	00094583          	lbu	a1,0(s2)
    4250:	f9e5                	bnez	a1,4240 <vprintf+0x16c>
        s = va_arg(ap, char*);
    4252:	8b4e                	mv	s6,s3
      state = 0;
    4254:	4981                	li	s3,0
    4256:	bdf9                	j	4134 <vprintf+0x60>
          s = "(null)";
    4258:	00002917          	auipc	s2,0x2
    425c:	fa890913          	addi	s2,s2,-88 # 6200 <malloc+0x1e62>
        while(*s != 0){
    4260:	02800593          	li	a1,40
    4264:	bff1                	j	4240 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    4266:	008b0913          	addi	s2,s6,8
    426a:	000b4583          	lbu	a1,0(s6)
    426e:	8556                	mv	a0,s5
    4270:	00000097          	auipc	ra,0x0
    4274:	d98080e7          	jalr	-616(ra) # 4008 <putc>
    4278:	8b4a                	mv	s6,s2
      state = 0;
    427a:	4981                	li	s3,0
    427c:	bd65                	j	4134 <vprintf+0x60>
        putc(fd, c);
    427e:	85d2                	mv	a1,s4
    4280:	8556                	mv	a0,s5
    4282:	00000097          	auipc	ra,0x0
    4286:	d86080e7          	jalr	-634(ra) # 4008 <putc>
      state = 0;
    428a:	4981                	li	s3,0
    428c:	b565                	j	4134 <vprintf+0x60>
        s = va_arg(ap, char*);
    428e:	8b4e                	mv	s6,s3
      state = 0;
    4290:	4981                	li	s3,0
    4292:	b54d                	j	4134 <vprintf+0x60>
    }
  }
}
    4294:	70e6                	ld	ra,120(sp)
    4296:	7446                	ld	s0,112(sp)
    4298:	74a6                	ld	s1,104(sp)
    429a:	7906                	ld	s2,96(sp)
    429c:	69e6                	ld	s3,88(sp)
    429e:	6a46                	ld	s4,80(sp)
    42a0:	6aa6                	ld	s5,72(sp)
    42a2:	6b06                	ld	s6,64(sp)
    42a4:	7be2                	ld	s7,56(sp)
    42a6:	7c42                	ld	s8,48(sp)
    42a8:	7ca2                	ld	s9,40(sp)
    42aa:	7d02                	ld	s10,32(sp)
    42ac:	6de2                	ld	s11,24(sp)
    42ae:	6109                	addi	sp,sp,128
    42b0:	8082                	ret

00000000000042b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    42b2:	715d                	addi	sp,sp,-80
    42b4:	ec06                	sd	ra,24(sp)
    42b6:	e822                	sd	s0,16(sp)
    42b8:	1000                	addi	s0,sp,32
    42ba:	e010                	sd	a2,0(s0)
    42bc:	e414                	sd	a3,8(s0)
    42be:	e818                	sd	a4,16(s0)
    42c0:	ec1c                	sd	a5,24(s0)
    42c2:	03043023          	sd	a6,32(s0)
    42c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    42ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    42ce:	8622                	mv	a2,s0
    42d0:	00000097          	auipc	ra,0x0
    42d4:	e04080e7          	jalr	-508(ra) # 40d4 <vprintf>
}
    42d8:	60e2                	ld	ra,24(sp)
    42da:	6442                	ld	s0,16(sp)
    42dc:	6161                	addi	sp,sp,80
    42de:	8082                	ret

00000000000042e0 <printf>:

void
printf(const char *fmt, ...)
{
    42e0:	711d                	addi	sp,sp,-96
    42e2:	ec06                	sd	ra,24(sp)
    42e4:	e822                	sd	s0,16(sp)
    42e6:	1000                	addi	s0,sp,32
    42e8:	e40c                	sd	a1,8(s0)
    42ea:	e810                	sd	a2,16(s0)
    42ec:	ec14                	sd	a3,24(s0)
    42ee:	f018                	sd	a4,32(s0)
    42f0:	f41c                	sd	a5,40(s0)
    42f2:	03043823          	sd	a6,48(s0)
    42f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    42fa:	00840613          	addi	a2,s0,8
    42fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4302:	85aa                	mv	a1,a0
    4304:	4505                	li	a0,1
    4306:	00000097          	auipc	ra,0x0
    430a:	dce080e7          	jalr	-562(ra) # 40d4 <vprintf>
}
    430e:	60e2                	ld	ra,24(sp)
    4310:	6442                	ld	s0,16(sp)
    4312:	6125                	addi	sp,sp,96
    4314:	8082                	ret

0000000000004316 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4316:	1141                	addi	sp,sp,-16
    4318:	e422                	sd	s0,8(sp)
    431a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    431c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4320:	00002797          	auipc	a5,0x2
    4324:	f387b783          	ld	a5,-200(a5) # 6258 <freep>
    4328:	a805                	j	4358 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    432a:	4618                	lw	a4,8(a2)
    432c:	9db9                	addw	a1,a1,a4
    432e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4332:	6398                	ld	a4,0(a5)
    4334:	6318                	ld	a4,0(a4)
    4336:	fee53823          	sd	a4,-16(a0)
    433a:	a091                	j	437e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    433c:	ff852703          	lw	a4,-8(a0)
    4340:	9e39                	addw	a2,a2,a4
    4342:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4344:	ff053703          	ld	a4,-16(a0)
    4348:	e398                	sd	a4,0(a5)
    434a:	a099                	j	4390 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    434c:	6398                	ld	a4,0(a5)
    434e:	00e7e463          	bltu	a5,a4,4356 <free+0x40>
    4352:	00e6ea63          	bltu	a3,a4,4366 <free+0x50>
{
    4356:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4358:	fed7fae3          	bgeu	a5,a3,434c <free+0x36>
    435c:	6398                	ld	a4,0(a5)
    435e:	00e6e463          	bltu	a3,a4,4366 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4362:	fee7eae3          	bltu	a5,a4,4356 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4366:	ff852583          	lw	a1,-8(a0)
    436a:	6390                	ld	a2,0(a5)
    436c:	02059713          	slli	a4,a1,0x20
    4370:	9301                	srli	a4,a4,0x20
    4372:	0712                	slli	a4,a4,0x4
    4374:	9736                	add	a4,a4,a3
    4376:	fae60ae3          	beq	a2,a4,432a <free+0x14>
    bp->s.ptr = p->s.ptr;
    437a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    437e:	4790                	lw	a2,8(a5)
    4380:	02061713          	slli	a4,a2,0x20
    4384:	9301                	srli	a4,a4,0x20
    4386:	0712                	slli	a4,a4,0x4
    4388:	973e                	add	a4,a4,a5
    438a:	fae689e3          	beq	a3,a4,433c <free+0x26>
  } else
    p->s.ptr = bp;
    438e:	e394                	sd	a3,0(a5)
  freep = p;
    4390:	00002717          	auipc	a4,0x2
    4394:	ecf73423          	sd	a5,-312(a4) # 6258 <freep>
}
    4398:	6422                	ld	s0,8(sp)
    439a:	0141                	addi	sp,sp,16
    439c:	8082                	ret

000000000000439e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    439e:	7139                	addi	sp,sp,-64
    43a0:	fc06                	sd	ra,56(sp)
    43a2:	f822                	sd	s0,48(sp)
    43a4:	f426                	sd	s1,40(sp)
    43a6:	f04a                	sd	s2,32(sp)
    43a8:	ec4e                	sd	s3,24(sp)
    43aa:	e852                	sd	s4,16(sp)
    43ac:	e456                	sd	s5,8(sp)
    43ae:	e05a                	sd	s6,0(sp)
    43b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    43b2:	02051493          	slli	s1,a0,0x20
    43b6:	9081                	srli	s1,s1,0x20
    43b8:	04bd                	addi	s1,s1,15
    43ba:	8091                	srli	s1,s1,0x4
    43bc:	0014899b          	addiw	s3,s1,1
    43c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    43c2:	00002517          	auipc	a0,0x2
    43c6:	e9653503          	ld	a0,-362(a0) # 6258 <freep>
    43ca:	c515                	beqz	a0,43f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    43ce:	4798                	lw	a4,8(a5)
    43d0:	02977f63          	bgeu	a4,s1,440e <malloc+0x70>
    43d4:	8a4e                	mv	s4,s3
    43d6:	0009871b          	sext.w	a4,s3
    43da:	6685                	lui	a3,0x1
    43dc:	00d77363          	bgeu	a4,a3,43e2 <malloc+0x44>
    43e0:	6a05                	lui	s4,0x1
    43e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    43e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    43ea:	00002917          	auipc	s2,0x2
    43ee:	e6e90913          	addi	s2,s2,-402 # 6258 <freep>
  if(p == (char*)-1)
    43f2:	5afd                	li	s5,-1
    43f4:	a88d                	j	4466 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    43f6:	00007797          	auipc	a5,0x7
    43fa:	67a78793          	addi	a5,a5,1658 # ba70 <base>
    43fe:	00002717          	auipc	a4,0x2
    4402:	e4f73d23          	sd	a5,-422(a4) # 6258 <freep>
    4406:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4408:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    440c:	b7e1                	j	43d4 <malloc+0x36>
      if(p->s.size == nunits)
    440e:	02e48b63          	beq	s1,a4,4444 <malloc+0xa6>
        p->s.size -= nunits;
    4412:	4137073b          	subw	a4,a4,s3
    4416:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4418:	1702                	slli	a4,a4,0x20
    441a:	9301                	srli	a4,a4,0x20
    441c:	0712                	slli	a4,a4,0x4
    441e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4420:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4424:	00002717          	auipc	a4,0x2
    4428:	e2a73a23          	sd	a0,-460(a4) # 6258 <freep>
      return (void*)(p + 1);
    442c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4430:	70e2                	ld	ra,56(sp)
    4432:	7442                	ld	s0,48(sp)
    4434:	74a2                	ld	s1,40(sp)
    4436:	7902                	ld	s2,32(sp)
    4438:	69e2                	ld	s3,24(sp)
    443a:	6a42                	ld	s4,16(sp)
    443c:	6aa2                	ld	s5,8(sp)
    443e:	6b02                	ld	s6,0(sp)
    4440:	6121                	addi	sp,sp,64
    4442:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4444:	6398                	ld	a4,0(a5)
    4446:	e118                	sd	a4,0(a0)
    4448:	bff1                	j	4424 <malloc+0x86>
  hp->s.size = nu;
    444a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    444e:	0541                	addi	a0,a0,16
    4450:	00000097          	auipc	ra,0x0
    4454:	ec6080e7          	jalr	-314(ra) # 4316 <free>
  return freep;
    4458:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    445c:	d971                	beqz	a0,4430 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    445e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4460:	4798                	lw	a4,8(a5)
    4462:	fa9776e3          	bgeu	a4,s1,440e <malloc+0x70>
    if(p == freep)
    4466:	00093703          	ld	a4,0(s2)
    446a:	853e                	mv	a0,a5
    446c:	fef719e3          	bne	a4,a5,445e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    4470:	8552                	mv	a0,s4
    4472:	00000097          	auipc	ra,0x0
    4476:	b5e080e7          	jalr	-1186(ra) # 3fd0 <sbrk>
  if(p == (char*)-1)
    447a:	fd5518e3          	bne	a0,s5,444a <malloc+0xac>
        return 0;
    447e:	4501                	li	a0,0
    4480:	bf45                	j	4430 <malloc+0x92>
