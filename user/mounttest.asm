
user/_mounttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test4();
  exit();
}

void test0()
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
  int fd;
  char buf[4];
  struct stat st;
  
  printf("test0 start\n");
       a:	00001517          	auipc	a0,0x1
       e:	18650513          	addi	a0,a0,390 # 1190 <malloc+0xea>
      12:	00001097          	auipc	ra,0x1
      16:	fd6080e7          	jalr	-42(ra) # fe8 <printf>

  mknod("disk1", DISK, 1);
      1a:	4605                	li	a2,1
      1c:	4581                	li	a1,0
      1e:	00001517          	auipc	a0,0x1
      22:	18250513          	addi	a0,a0,386 # 11a0 <malloc+0xfa>
      26:	00001097          	auipc	ra,0x1
      2a:	c72080e7          	jalr	-910(ra) # c98 <mknod>
  mkdir("/m");
      2e:	00001517          	auipc	a0,0x1
      32:	17a50513          	addi	a0,a0,378 # 11a8 <malloc+0x102>
      36:	00001097          	auipc	ra,0x1
      3a:	c82080e7          	jalr	-894(ra) # cb8 <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
      3e:	00001597          	auipc	a1,0x1
      42:	16a58593          	addi	a1,a1,362 # 11a8 <malloc+0x102>
      46:	00001517          	auipc	a0,0x1
      4a:	16a50513          	addi	a0,a0,362 # 11b0 <malloc+0x10a>
      4e:	00001097          	auipc	ra,0x1
      52:	cb2080e7          	jalr	-846(ra) # d00 <mount>
      56:	1a054663          	bltz	a0,202 <test0+0x202>
    printf("mount failed\n");
    exit();
  }    

  if (stat("/m", &st) < 0) {
      5a:	fc040593          	addi	a1,s0,-64
      5e:	00001517          	auipc	a0,0x1
      62:	14a50513          	addi	a0,a0,330 # 11a8 <malloc+0x102>
      66:	00001097          	auipc	ra,0x1
      6a:	b24080e7          	jalr	-1244(ra) # b8a <stat>
      6e:	1a054663          	bltz	a0,21a <test0+0x21a>
    printf("stat /m failed\n");
    exit();
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
      72:	f00017b7          	lui	a5,0xf0001
      76:	fc043703          	ld	a4,-64(s0)
      7a:	0792                	slli	a5,a5,0x4
      7c:	17fd                	addi	a5,a5,-1
      7e:	8f7d                	and	a4,a4,a5
      80:	4785                	li	a5,1
      82:	1782                	slli	a5,a5,0x20
      84:	0785                	addi	a5,a5,1
      86:	1af71663          	bne	a4,a5,232 <test0+0x232>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit();
  }
  
  if ((fd = open("/m/README", O_RDONLY)) < 0) {
      8a:	4581                	li	a1,0
      8c:	00001517          	auipc	a0,0x1
      90:	16c50513          	addi	a0,a0,364 # 11f8 <malloc+0x152>
      94:	00001097          	auipc	ra,0x1
      98:	bfc080e7          	jalr	-1028(ra) # c90 <open>
      9c:	84aa                	mv	s1,a0
      9e:	1a054a63          	bltz	a0,252 <test0+0x252>
    printf("open read failed\n");
    exit();
  }
  if (read(fd, buf, sizeof(buf)-1) != sizeof(buf)-1) {
      a2:	460d                	li	a2,3
      a4:	fd840593          	addi	a1,s0,-40
      a8:	00001097          	auipc	ra,0x1
      ac:	bc0080e7          	jalr	-1088(ra) # c68 <read>
      b0:	478d                	li	a5,3
      b2:	1af51c63          	bne	a0,a5,26a <test0+0x26a>
    printf("read failed\n");
    exit();
  }
  if (strcmp("xv6", buf) != 0) {
      b6:	fd840593          	addi	a1,s0,-40
      ba:	00001517          	auipc	a0,0x1
      be:	17650513          	addi	a0,a0,374 # 1230 <malloc+0x18a>
      c2:	00001097          	auipc	ra,0x1
      c6:	9b4080e7          	jalr	-1612(ra) # a76 <strcmp>
      ca:	1a051c63          	bnez	a0,282 <test0+0x282>
    printf("read failed\n", buf);
  }
  close(fd);
      ce:	8526                	mv	a0,s1
      d0:	00001097          	auipc	ra,0x1
      d4:	ba8080e7          	jalr	-1112(ra) # c78 <close>
  
  if ((fd = open("/m/a", O_CREATE|O_WRONLY)) < 0) {
      d8:	20100593          	li	a1,513
      dc:	00001517          	auipc	a0,0x1
      e0:	15c50513          	addi	a0,a0,348 # 1238 <malloc+0x192>
      e4:	00001097          	auipc	ra,0x1
      e8:	bac080e7          	jalr	-1108(ra) # c90 <open>
      ec:	84aa                	mv	s1,a0
      ee:	1a054563          	bltz	a0,298 <test0+0x298>
    printf("open write failed\n");
    exit();
  }
  
  if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      f2:	4611                	li	a2,4
      f4:	fd840593          	addi	a1,s0,-40
      f8:	00001097          	auipc	ra,0x1
      fc:	b78080e7          	jalr	-1160(ra) # c70 <write>
     100:	4791                	li	a5,4
     102:	1af51763          	bne	a0,a5,2b0 <test0+0x2b0>
    printf("write failed\n");
    exit();
  }

  close(fd);
     106:	8526                	mv	a0,s1
     108:	00001097          	auipc	ra,0x1
     10c:	b70080e7          	jalr	-1168(ra) # c78 <close>

  if (stat("/m/a", &st) < 0) {
     110:	fc040593          	addi	a1,s0,-64
     114:	00001517          	auipc	a0,0x1
     118:	12450513          	addi	a0,a0,292 # 1238 <malloc+0x192>
     11c:	00001097          	auipc	ra,0x1
     120:	a6e080e7          	jalr	-1426(ra) # b8a <stat>
     124:	1a054263          	bltz	a0,2c8 <test0+0x2c8>
    printf("stat /m/a failed\n");
    exit();
  }

  if (minor(st.dev) != 1) {
     128:	fc045583          	lhu	a1,-64(s0)
     12c:	4785                	li	a5,1
     12e:	1af59963          	bne	a1,a5,2e0 <test0+0x2e0>
    printf("stat wrong minor %d\n", minor(st.dev));
    exit();
  }


  if (link("m/a", "/a") == 0) {
     132:	00001597          	auipc	a1,0x1
     136:	16658593          	addi	a1,a1,358 # 1298 <malloc+0x1f2>
     13a:	00001517          	auipc	a0,0x1
     13e:	16650513          	addi	a0,a0,358 # 12a0 <malloc+0x1fa>
     142:	00001097          	auipc	ra,0x1
     146:	b6e080e7          	jalr	-1170(ra) # cb0 <link>
     14a:	1a050763          	beqz	a0,2f8 <test0+0x2f8>
    printf("link m/a a succeeded\n");
    exit();
  }

  if (unlink("m/a") < 0) {
     14e:	00001517          	auipc	a0,0x1
     152:	15250513          	addi	a0,a0,338 # 12a0 <malloc+0x1fa>
     156:	00001097          	auipc	ra,0x1
     15a:	b4a080e7          	jalr	-1206(ra) # ca0 <unlink>
     15e:	1a054963          	bltz	a0,310 <test0+0x310>
    printf("unlink m/a failed\n");
    exit();
  }

  if (chdir("/m") < 0) {
     162:	00001517          	auipc	a0,0x1
     166:	04650513          	addi	a0,a0,70 # 11a8 <malloc+0x102>
     16a:	00001097          	auipc	ra,0x1
     16e:	b56080e7          	jalr	-1194(ra) # cc0 <chdir>
     172:	1a054b63          	bltz	a0,328 <test0+0x328>
    printf("chdir /m failed\n");
    exit();
  }

  if (stat(".", &st) < 0) {
     176:	fc040593          	addi	a1,s0,-64
     17a:	00001517          	auipc	a0,0x1
     17e:	17650513          	addi	a0,a0,374 # 12f0 <malloc+0x24a>
     182:	00001097          	auipc	ra,0x1
     186:	a08080e7          	jalr	-1528(ra) # b8a <stat>
     18a:	1a054b63          	bltz	a0,340 <test0+0x340>
    printf("stat . failed\n");
    exit();
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
     18e:	f00017b7          	lui	a5,0xf0001
     192:	fc043703          	ld	a4,-64(s0)
     196:	0792                	slli	a5,a5,0x4
     198:	17fd                	addi	a5,a5,-1
     19a:	8f7d                	and	a4,a4,a5
     19c:	4785                	li	a5,1
     19e:	1782                	slli	a5,a5,0x20
     1a0:	0785                	addi	a5,a5,1
     1a2:	1af71b63          	bne	a4,a5,358 <test0+0x358>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit();
  }

  if (chdir("..") < 0) {
     1a6:	00001517          	auipc	a0,0x1
     1aa:	16250513          	addi	a0,a0,354 # 1308 <malloc+0x262>
     1ae:	00001097          	auipc	ra,0x1
     1b2:	b12080e7          	jalr	-1262(ra) # cc0 <chdir>
     1b6:	1c054163          	bltz	a0,378 <test0+0x378>
    printf("chdir .. failed\n");
    exit();
  }

  if (stat(".", &st) < 0) {
     1ba:	fc040593          	addi	a1,s0,-64
     1be:	00001517          	auipc	a0,0x1
     1c2:	13250513          	addi	a0,a0,306 # 12f0 <malloc+0x24a>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	9c4080e7          	jalr	-1596(ra) # b8a <stat>
     1ce:	1c054163          	bltz	a0,390 <test0+0x390>
    printf("stat . failed\n");
    exit();
  }

  if (st.ino == 1 && minor(st.dev) == 0) {
     1d2:	f00017b7          	lui	a5,0xf0001
     1d6:	fc043703          	ld	a4,-64(s0)
     1da:	0792                	slli	a5,a5,0x4
     1dc:	17fd                	addi	a5,a5,-1
     1de:	8ff9                	and	a5,a5,a4
     1e0:	4705                	li	a4,1
     1e2:	1702                	slli	a4,a4,0x20
     1e4:	1ce78263          	beq	a5,a4,3a8 <test0+0x3a8>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit();
  }

  printf("test0 done\n");
     1e8:	00001517          	auipc	a0,0x1
     1ec:	14050513          	addi	a0,a0,320 # 1328 <malloc+0x282>
     1f0:	00001097          	auipc	ra,0x1
     1f4:	df8080e7          	jalr	-520(ra) # fe8 <printf>
}
     1f8:	70e2                	ld	ra,56(sp)
     1fa:	7442                	ld	s0,48(sp)
     1fc:	74a2                	ld	s1,40(sp)
     1fe:	6121                	addi	sp,sp,64
     200:	8082                	ret
    printf("mount failed\n");
     202:	00001517          	auipc	a0,0x1
     206:	fb650513          	addi	a0,a0,-74 # 11b8 <malloc+0x112>
     20a:	00001097          	auipc	ra,0x1
     20e:	dde080e7          	jalr	-546(ra) # fe8 <printf>
    exit();
     212:	00001097          	auipc	ra,0x1
     216:	a3e080e7          	jalr	-1474(ra) # c50 <exit>
    printf("stat /m failed\n");
     21a:	00001517          	auipc	a0,0x1
     21e:	fae50513          	addi	a0,a0,-82 # 11c8 <malloc+0x122>
     222:	00001097          	auipc	ra,0x1
     226:	dc6080e7          	jalr	-570(ra) # fe8 <printf>
    exit();
     22a:	00001097          	auipc	ra,0x1
     22e:	a26080e7          	jalr	-1498(ra) # c50 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     232:	fc045603          	lhu	a2,-64(s0)
     236:	fc442583          	lw	a1,-60(s0)
     23a:	00001517          	auipc	a0,0x1
     23e:	f9e50513          	addi	a0,a0,-98 # 11d8 <malloc+0x132>
     242:	00001097          	auipc	ra,0x1
     246:	da6080e7          	jalr	-602(ra) # fe8 <printf>
    exit();
     24a:	00001097          	auipc	ra,0x1
     24e:	a06080e7          	jalr	-1530(ra) # c50 <exit>
    printf("open read failed\n");
     252:	00001517          	auipc	a0,0x1
     256:	fb650513          	addi	a0,a0,-74 # 1208 <malloc+0x162>
     25a:	00001097          	auipc	ra,0x1
     25e:	d8e080e7          	jalr	-626(ra) # fe8 <printf>
    exit();
     262:	00001097          	auipc	ra,0x1
     266:	9ee080e7          	jalr	-1554(ra) # c50 <exit>
    printf("read failed\n");
     26a:	00001517          	auipc	a0,0x1
     26e:	fb650513          	addi	a0,a0,-74 # 1220 <malloc+0x17a>
     272:	00001097          	auipc	ra,0x1
     276:	d76080e7          	jalr	-650(ra) # fe8 <printf>
    exit();
     27a:	00001097          	auipc	ra,0x1
     27e:	9d6080e7          	jalr	-1578(ra) # c50 <exit>
    printf("read failed\n", buf);
     282:	fd840593          	addi	a1,s0,-40
     286:	00001517          	auipc	a0,0x1
     28a:	f9a50513          	addi	a0,a0,-102 # 1220 <malloc+0x17a>
     28e:	00001097          	auipc	ra,0x1
     292:	d5a080e7          	jalr	-678(ra) # fe8 <printf>
     296:	bd25                	j	ce <test0+0xce>
    printf("open write failed\n");
     298:	00001517          	auipc	a0,0x1
     29c:	fa850513          	addi	a0,a0,-88 # 1240 <malloc+0x19a>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	d48080e7          	jalr	-696(ra) # fe8 <printf>
    exit();
     2a8:	00001097          	auipc	ra,0x1
     2ac:	9a8080e7          	jalr	-1624(ra) # c50 <exit>
    printf("write failed\n");
     2b0:	00001517          	auipc	a0,0x1
     2b4:	fa850513          	addi	a0,a0,-88 # 1258 <malloc+0x1b2>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	d30080e7          	jalr	-720(ra) # fe8 <printf>
    exit();
     2c0:	00001097          	auipc	ra,0x1
     2c4:	990080e7          	jalr	-1648(ra) # c50 <exit>
    printf("stat /m/a failed\n");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	fa050513          	addi	a0,a0,-96 # 1268 <malloc+0x1c2>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	d18080e7          	jalr	-744(ra) # fe8 <printf>
    exit();
     2d8:	00001097          	auipc	ra,0x1
     2dc:	978080e7          	jalr	-1672(ra) # c50 <exit>
    printf("stat wrong minor %d\n", minor(st.dev));
     2e0:	00001517          	auipc	a0,0x1
     2e4:	fa050513          	addi	a0,a0,-96 # 1280 <malloc+0x1da>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	d00080e7          	jalr	-768(ra) # fe8 <printf>
    exit();
     2f0:	00001097          	auipc	ra,0x1
     2f4:	960080e7          	jalr	-1696(ra) # c50 <exit>
    printf("link m/a a succeeded\n");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	fb050513          	addi	a0,a0,-80 # 12a8 <malloc+0x202>
     300:	00001097          	auipc	ra,0x1
     304:	ce8080e7          	jalr	-792(ra) # fe8 <printf>
    exit();
     308:	00001097          	auipc	ra,0x1
     30c:	948080e7          	jalr	-1720(ra) # c50 <exit>
    printf("unlink m/a failed\n");
     310:	00001517          	auipc	a0,0x1
     314:	fb050513          	addi	a0,a0,-80 # 12c0 <malloc+0x21a>
     318:	00001097          	auipc	ra,0x1
     31c:	cd0080e7          	jalr	-816(ra) # fe8 <printf>
    exit();
     320:	00001097          	auipc	ra,0x1
     324:	930080e7          	jalr	-1744(ra) # c50 <exit>
    printf("chdir /m failed\n");
     328:	00001517          	auipc	a0,0x1
     32c:	fb050513          	addi	a0,a0,-80 # 12d8 <malloc+0x232>
     330:	00001097          	auipc	ra,0x1
     334:	cb8080e7          	jalr	-840(ra) # fe8 <printf>
    exit();
     338:	00001097          	auipc	ra,0x1
     33c:	918080e7          	jalr	-1768(ra) # c50 <exit>
    printf("stat . failed\n");
     340:	00001517          	auipc	a0,0x1
     344:	fb850513          	addi	a0,a0,-72 # 12f8 <malloc+0x252>
     348:	00001097          	auipc	ra,0x1
     34c:	ca0080e7          	jalr	-864(ra) # fe8 <printf>
    exit();
     350:	00001097          	auipc	ra,0x1
     354:	900080e7          	jalr	-1792(ra) # c50 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     358:	fc045603          	lhu	a2,-64(s0)
     35c:	fc442583          	lw	a1,-60(s0)
     360:	00001517          	auipc	a0,0x1
     364:	e7850513          	addi	a0,a0,-392 # 11d8 <malloc+0x132>
     368:	00001097          	auipc	ra,0x1
     36c:	c80080e7          	jalr	-896(ra) # fe8 <printf>
    exit();
     370:	00001097          	auipc	ra,0x1
     374:	8e0080e7          	jalr	-1824(ra) # c50 <exit>
    printf("chdir .. failed\n");
     378:	00001517          	auipc	a0,0x1
     37c:	f9850513          	addi	a0,a0,-104 # 1310 <malloc+0x26a>
     380:	00001097          	auipc	ra,0x1
     384:	c68080e7          	jalr	-920(ra) # fe8 <printf>
    exit();
     388:	00001097          	auipc	ra,0x1
     38c:	8c8080e7          	jalr	-1848(ra) # c50 <exit>
    printf("stat . failed\n");
     390:	00001517          	auipc	a0,0x1
     394:	f6850513          	addi	a0,a0,-152 # 12f8 <malloc+0x252>
     398:	00001097          	auipc	ra,0x1
     39c:	c50080e7          	jalr	-944(ra) # fe8 <printf>
    exit();
     3a0:	00001097          	auipc	ra,0x1
     3a4:	8b0080e7          	jalr	-1872(ra) # c50 <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     3a8:	fc045603          	lhu	a2,-64(s0)
     3ac:	fc442583          	lw	a1,-60(s0)
     3b0:	00001517          	auipc	a0,0x1
     3b4:	e2850513          	addi	a0,a0,-472 # 11d8 <malloc+0x132>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	c30080e7          	jalr	-976(ra) # fe8 <printf>
    exit();
     3c0:	00001097          	auipc	ra,0x1
     3c4:	890080e7          	jalr	-1904(ra) # c50 <exit>

00000000000003c8 <test1>:

// depends on test0
void test1() {
     3c8:	715d                	addi	sp,sp,-80
     3ca:	e486                	sd	ra,72(sp)
     3cc:	e0a2                	sd	s0,64(sp)
     3ce:	fc26                	sd	s1,56(sp)
     3d0:	f84a                	sd	s2,48(sp)
     3d2:	f44e                	sd	s3,40(sp)
     3d4:	0880                	addi	s0,sp,80
  struct stat st;
  int fd;
  int i;
  
  printf("test1 start\n");
     3d6:	00001517          	auipc	a0,0x1
     3da:	f6250513          	addi	a0,a0,-158 # 1338 <malloc+0x292>
     3de:	00001097          	auipc	ra,0x1
     3e2:	c0a080e7          	jalr	-1014(ra) # fe8 <printf>

  if (mount("/disk1", "/m") == 0) {
     3e6:	00001597          	auipc	a1,0x1
     3ea:	dc258593          	addi	a1,a1,-574 # 11a8 <malloc+0x102>
     3ee:	00001517          	auipc	a0,0x1
     3f2:	dc250513          	addi	a0,a0,-574 # 11b0 <malloc+0x10a>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	90a080e7          	jalr	-1782(ra) # d00 <mount>
     3fe:	10050d63          	beqz	a0,518 <test1+0x150>
    printf("mount should fail\n");
    exit();
  }    

  if (umount("/m") < 0) {
     402:	00001517          	auipc	a0,0x1
     406:	da650513          	addi	a0,a0,-602 # 11a8 <malloc+0x102>
     40a:	00001097          	auipc	ra,0x1
     40e:	8fe080e7          	jalr	-1794(ra) # d08 <umount>
     412:	10054f63          	bltz	a0,530 <test1+0x168>
    printf("umount /m failed\n");
    exit();
  }    

  if (umount("/m") == 0) {
     416:	00001517          	auipc	a0,0x1
     41a:	d9250513          	addi	a0,a0,-622 # 11a8 <malloc+0x102>
     41e:	00001097          	auipc	ra,0x1
     422:	8ea080e7          	jalr	-1814(ra) # d08 <umount>
     426:	12050163          	beqz	a0,548 <test1+0x180>
    printf("umount /m succeeded\n");
    exit();
  }    

  if (umount("/") == 0) {
     42a:	00001517          	auipc	a0,0x1
     42e:	f6650513          	addi	a0,a0,-154 # 1390 <malloc+0x2ea>
     432:	00001097          	auipc	ra,0x1
     436:	8d6080e7          	jalr	-1834(ra) # d08 <umount>
     43a:	12050363          	beqz	a0,560 <test1+0x198>
    printf("umount / succeeded\n");
    exit();
  }    

  if (stat("/m", &st) < 0) {
     43e:	fb840593          	addi	a1,s0,-72
     442:	00001517          	auipc	a0,0x1
     446:	d6650513          	addi	a0,a0,-666 # 11a8 <malloc+0x102>
     44a:	00000097          	auipc	ra,0x0
     44e:	740080e7          	jalr	1856(ra) # b8a <stat>
     452:	12054363          	bltz	a0,578 <test1+0x1b0>
    printf("stat /m failed\n");
    exit();
  }

  if (minor(st.dev) != 0) {
     456:	fb845603          	lhu	a2,-72(s0)
     45a:	06400493          	li	s1,100
    exit();
  }

  // many mounts and umounts
  for (i = 0; i < 100; i++) {
    if (mount("/disk1", "/m") < 0) {
     45e:	00001917          	auipc	s2,0x1
     462:	d4a90913          	addi	s2,s2,-694 # 11a8 <malloc+0x102>
     466:	00001997          	auipc	s3,0x1
     46a:	d4a98993          	addi	s3,s3,-694 # 11b0 <malloc+0x10a>
  if (minor(st.dev) != 0) {
     46e:	12061163          	bnez	a2,590 <test1+0x1c8>
    if (mount("/disk1", "/m") < 0) {
     472:	85ca                	mv	a1,s2
     474:	854e                	mv	a0,s3
     476:	00001097          	auipc	ra,0x1
     47a:	88a080e7          	jalr	-1910(ra) # d00 <mount>
     47e:	12054763          	bltz	a0,5ac <test1+0x1e4>
      printf("mount /m should succeed\n");
      exit();
    }    

    if (umount("/m") < 0) {
     482:	854a                	mv	a0,s2
     484:	00001097          	auipc	ra,0x1
     488:	884080e7          	jalr	-1916(ra) # d08 <umount>
     48c:	12054c63          	bltz	a0,5c4 <test1+0x1fc>
  for (i = 0; i < 100; i++) {
     490:	34fd                	addiw	s1,s1,-1
     492:	f0e5                	bnez	s1,472 <test1+0xaa>
      printf("umount /m failed\n");
      exit();
    }
  }

  if (mount("/disk1", "/m") < 0) {
     494:	00001597          	auipc	a1,0x1
     498:	d1458593          	addi	a1,a1,-748 # 11a8 <malloc+0x102>
     49c:	00001517          	auipc	a0,0x1
     4a0:	d1450513          	addi	a0,a0,-748 # 11b0 <malloc+0x10a>
     4a4:	00001097          	auipc	ra,0x1
     4a8:	85c080e7          	jalr	-1956(ra) # d00 <mount>
     4ac:	12054863          	bltz	a0,5dc <test1+0x214>
    printf("mount /m should succeed\n");
    exit();
  }    

  if ((fd = open("/m/README", O_RDONLY)) < 0) {
     4b0:	4581                	li	a1,0
     4b2:	00001517          	auipc	a0,0x1
     4b6:	d4650513          	addi	a0,a0,-698 # 11f8 <malloc+0x152>
     4ba:	00000097          	auipc	ra,0x0
     4be:	7d6080e7          	jalr	2006(ra) # c90 <open>
     4c2:	84aa                	mv	s1,a0
     4c4:	12054863          	bltz	a0,5f4 <test1+0x22c>
    printf("open read failed\n");
    exit();
  }

  if (umount("/m") == 0) {
     4c8:	00001517          	auipc	a0,0x1
     4cc:	ce050513          	addi	a0,a0,-800 # 11a8 <malloc+0x102>
     4d0:	00001097          	auipc	ra,0x1
     4d4:	838080e7          	jalr	-1992(ra) # d08 <umount>
     4d8:	12050a63          	beqz	a0,60c <test1+0x244>
    printf("umount /m succeeded\n");
    exit();
  }

  close(fd);
     4dc:	8526                	mv	a0,s1
     4de:	00000097          	auipc	ra,0x0
     4e2:	79a080e7          	jalr	1946(ra) # c78 <close>
  
  if (umount("/m") < 0) {
     4e6:	00001517          	auipc	a0,0x1
     4ea:	cc250513          	addi	a0,a0,-830 # 11a8 <malloc+0x102>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	81a080e7          	jalr	-2022(ra) # d08 <umount>
     4f6:	12054763          	bltz	a0,624 <test1+0x25c>
    printf("final umount failed\n");
    exit();
  }

  printf("test1 done\n");
     4fa:	00001517          	auipc	a0,0x1
     4fe:	f0e50513          	addi	a0,a0,-242 # 1408 <malloc+0x362>
     502:	00001097          	auipc	ra,0x1
     506:	ae6080e7          	jalr	-1306(ra) # fe8 <printf>
}
     50a:	60a6                	ld	ra,72(sp)
     50c:	6406                	ld	s0,64(sp)
     50e:	74e2                	ld	s1,56(sp)
     510:	7942                	ld	s2,48(sp)
     512:	79a2                	ld	s3,40(sp)
     514:	6161                	addi	sp,sp,80
     516:	8082                	ret
    printf("mount should fail\n");
     518:	00001517          	auipc	a0,0x1
     51c:	e3050513          	addi	a0,a0,-464 # 1348 <malloc+0x2a2>
     520:	00001097          	auipc	ra,0x1
     524:	ac8080e7          	jalr	-1336(ra) # fe8 <printf>
    exit();
     528:	00000097          	auipc	ra,0x0
     52c:	728080e7          	jalr	1832(ra) # c50 <exit>
    printf("umount /m failed\n");
     530:	00001517          	auipc	a0,0x1
     534:	e3050513          	addi	a0,a0,-464 # 1360 <malloc+0x2ba>
     538:	00001097          	auipc	ra,0x1
     53c:	ab0080e7          	jalr	-1360(ra) # fe8 <printf>
    exit();
     540:	00000097          	auipc	ra,0x0
     544:	710080e7          	jalr	1808(ra) # c50 <exit>
    printf("umount /m succeeded\n");
     548:	00001517          	auipc	a0,0x1
     54c:	e3050513          	addi	a0,a0,-464 # 1378 <malloc+0x2d2>
     550:	00001097          	auipc	ra,0x1
     554:	a98080e7          	jalr	-1384(ra) # fe8 <printf>
    exit();
     558:	00000097          	auipc	ra,0x0
     55c:	6f8080e7          	jalr	1784(ra) # c50 <exit>
    printf("umount / succeeded\n");
     560:	00001517          	auipc	a0,0x1
     564:	e3850513          	addi	a0,a0,-456 # 1398 <malloc+0x2f2>
     568:	00001097          	auipc	ra,0x1
     56c:	a80080e7          	jalr	-1408(ra) # fe8 <printf>
    exit();
     570:	00000097          	auipc	ra,0x0
     574:	6e0080e7          	jalr	1760(ra) # c50 <exit>
    printf("stat /m failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	c5050513          	addi	a0,a0,-944 # 11c8 <malloc+0x122>
     580:	00001097          	auipc	ra,0x1
     584:	a68080e7          	jalr	-1432(ra) # fe8 <printf>
    exit();
     588:	00000097          	auipc	ra,0x0
     58c:	6c8080e7          	jalr	1736(ra) # c50 <exit>
    printf("stat wrong inum/dev %d %d\n", st.ino, minor(st.dev));
     590:	fbc42583          	lw	a1,-68(s0)
     594:	00001517          	auipc	a0,0x1
     598:	e1c50513          	addi	a0,a0,-484 # 13b0 <malloc+0x30a>
     59c:	00001097          	auipc	ra,0x1
     5a0:	a4c080e7          	jalr	-1460(ra) # fe8 <printf>
    exit();
     5a4:	00000097          	auipc	ra,0x0
     5a8:	6ac080e7          	jalr	1708(ra) # c50 <exit>
      printf("mount /m should succeed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	e2450513          	addi	a0,a0,-476 # 13d0 <malloc+0x32a>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	a34080e7          	jalr	-1484(ra) # fe8 <printf>
      exit();
     5bc:	00000097          	auipc	ra,0x0
     5c0:	694080e7          	jalr	1684(ra) # c50 <exit>
      printf("umount /m failed\n");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	d9c50513          	addi	a0,a0,-612 # 1360 <malloc+0x2ba>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	a1c080e7          	jalr	-1508(ra) # fe8 <printf>
      exit();
     5d4:	00000097          	auipc	ra,0x0
     5d8:	67c080e7          	jalr	1660(ra) # c50 <exit>
    printf("mount /m should succeed\n");
     5dc:	00001517          	auipc	a0,0x1
     5e0:	df450513          	addi	a0,a0,-524 # 13d0 <malloc+0x32a>
     5e4:	00001097          	auipc	ra,0x1
     5e8:	a04080e7          	jalr	-1532(ra) # fe8 <printf>
    exit();
     5ec:	00000097          	auipc	ra,0x0
     5f0:	664080e7          	jalr	1636(ra) # c50 <exit>
    printf("open read failed\n");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	c1450513          	addi	a0,a0,-1004 # 1208 <malloc+0x162>
     5fc:	00001097          	auipc	ra,0x1
     600:	9ec080e7          	jalr	-1556(ra) # fe8 <printf>
    exit();
     604:	00000097          	auipc	ra,0x0
     608:	64c080e7          	jalr	1612(ra) # c50 <exit>
    printf("umount /m succeeded\n");
     60c:	00001517          	auipc	a0,0x1
     610:	d6c50513          	addi	a0,a0,-660 # 1378 <malloc+0x2d2>
     614:	00001097          	auipc	ra,0x1
     618:	9d4080e7          	jalr	-1580(ra) # fe8 <printf>
    exit();
     61c:	00000097          	auipc	ra,0x0
     620:	634080e7          	jalr	1588(ra) # c50 <exit>
    printf("final umount failed\n");
     624:	00001517          	auipc	a0,0x1
     628:	dcc50513          	addi	a0,a0,-564 # 13f0 <malloc+0x34a>
     62c:	00001097          	auipc	ra,0x1
     630:	9bc080e7          	jalr	-1604(ra) # fe8 <printf>
    exit();
     634:	00000097          	auipc	ra,0x0
     638:	61c080e7          	jalr	1564(ra) # c50 <exit>

000000000000063c <test2>:
#define NOP 100

// try to trigger races/deadlocks in namex; it is helpful to add
// sleepticks(1) in if(ip->type != T_DIR) branch in namei, so that you
// will observe some more reliably.
void test2() {
     63c:	715d                	addi	sp,sp,-80
     63e:	e486                	sd	ra,72(sp)
     640:	e0a2                	sd	s0,64(sp)
     642:	fc26                	sd	s1,56(sp)
     644:	f84a                	sd	s2,48(sp)
     646:	f44e                	sd	s3,40(sp)
     648:	f052                	sd	s4,32(sp)
     64a:	0880                	addi	s0,sp,80
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test2\n");
     64c:	00001517          	auipc	a0,0x1
     650:	dcc50513          	addi	a0,a0,-564 # 1418 <malloc+0x372>
     654:	00001097          	auipc	ra,0x1
     658:	994080e7          	jalr	-1644(ra) # fe8 <printf>

  mkdir("/m");
     65c:	00001517          	auipc	a0,0x1
     660:	b4c50513          	addi	a0,a0,-1204 # 11a8 <malloc+0x102>
     664:	00000097          	auipc	ra,0x0
     668:	654080e7          	jalr	1620(ra) # cb8 <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
     66c:	00001597          	auipc	a1,0x1
     670:	b3c58593          	addi	a1,a1,-1220 # 11a8 <malloc+0x102>
     674:	00001517          	auipc	a0,0x1
     678:	b3c50513          	addi	a0,a0,-1220 # 11b0 <malloc+0x10a>
     67c:	00000097          	auipc	ra,0x0
     680:	684080e7          	jalr	1668(ra) # d00 <mount>
     684:	fc040a13          	addi	s4,s0,-64
     688:	84d2                	mv	s1,s4
     68a:	0c054263          	bltz	a0,74e <test2+0x112>
      printf("mount failed\n");
      exit();
  }    

  for (i = 0; i < NPID; i++) {
    if ((pid[i] = fork()) < 0) {
     68e:	00000097          	auipc	ra,0x0
     692:	5ba080e7          	jalr	1466(ra) # c48 <fork>
     696:	c088                	sw	a0,0(s1)
     698:	0c054763          	bltz	a0,766 <test2+0x12a>
      printf("fork failed\n");
      exit();
    }
    if (pid[i] == 0) {
     69c:	c16d                	beqz	a0,77e <test2+0x142>
  for (i = 0; i < NPID; i++) {
     69e:	0491                	addi	s1,s1,4
     6a0:	fd040793          	addi	a5,s0,-48
     6a4:	fef495e3          	bne	s1,a5,68e <test2+0x52>
     6a8:	06400913          	li	s2,100
        }
      }
    }
  }
  for (i = 0; i < NOP; i++) {
    if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     6ac:	00001997          	auipc	s3,0x1
     6b0:	d8c98993          	addi	s3,s3,-628 # 1438 <malloc+0x392>
     6b4:	20100593          	li	a1,513
     6b8:	854e                	mv	a0,s3
     6ba:	00000097          	auipc	ra,0x0
     6be:	5d6080e7          	jalr	1494(ra) # c90 <open>
     6c2:	84aa                	mv	s1,a0
     6c4:	0c054e63          	bltz	a0,7a0 <test2+0x164>
      printf("open write failed");
      exit();
    }
    if (unlink("/m/b") < 0) {
     6c8:	854e                	mv	a0,s3
     6ca:	00000097          	auipc	ra,0x0
     6ce:	5d6080e7          	jalr	1494(ra) # ca0 <unlink>
     6d2:	0e054363          	bltz	a0,7b8 <test2+0x17c>
      printf("unlink failed\n");
      exit();
    }
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     6d6:	4605                	li	a2,1
     6d8:	fb840593          	addi	a1,s0,-72
     6dc:	8526                	mv	a0,s1
     6de:	00000097          	auipc	ra,0x0
     6e2:	592080e7          	jalr	1426(ra) # c70 <write>
     6e6:	4785                	li	a5,1
     6e8:	0ef51463          	bne	a0,a5,7d0 <test2+0x194>
      printf("write failed\n");
      exit();
    }
    close(fd);
     6ec:	8526                	mv	a0,s1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	58a080e7          	jalr	1418(ra) # c78 <close>
  for (i = 0; i < NOP; i++) {
     6f6:	397d                	addiw	s2,s2,-1
     6f8:	fa091ee3          	bnez	s2,6b4 <test2+0x78>
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     6fc:	000a2503          	lw	a0,0(s4)
     700:	00000097          	auipc	ra,0x0
     704:	580080e7          	jalr	1408(ra) # c80 <kill>
    wait();
     708:	00000097          	auipc	ra,0x0
     70c:	550080e7          	jalr	1360(ra) # c58 <wait>
  for (i = 0; i < NPID; i++) {
     710:	0a11                	addi	s4,s4,4
     712:	fd040793          	addi	a5,s0,-48
     716:	fefa13e3          	bne	s4,a5,6fc <test2+0xc0>
  }
  if (umount("/m") < 0) {
     71a:	00001517          	auipc	a0,0x1
     71e:	a8e50513          	addi	a0,a0,-1394 # 11a8 <malloc+0x102>
     722:	00000097          	auipc	ra,0x0
     726:	5e6080e7          	jalr	1510(ra) # d08 <umount>
     72a:	0a054f63          	bltz	a0,7e8 <test2+0x1ac>
    printf("umount failed\n");
    exit();
  }    

  printf("test2 ok\n");
     72e:	00001517          	auipc	a0,0x1
     732:	d4a50513          	addi	a0,a0,-694 # 1478 <malloc+0x3d2>
     736:	00001097          	auipc	ra,0x1
     73a:	8b2080e7          	jalr	-1870(ra) # fe8 <printf>
}
     73e:	60a6                	ld	ra,72(sp)
     740:	6406                	ld	s0,64(sp)
     742:	74e2                	ld	s1,56(sp)
     744:	7942                	ld	s2,48(sp)
     746:	79a2                	ld	s3,40(sp)
     748:	7a02                	ld	s4,32(sp)
     74a:	6161                	addi	sp,sp,80
     74c:	8082                	ret
      printf("mount failed\n");
     74e:	00001517          	auipc	a0,0x1
     752:	a6a50513          	addi	a0,a0,-1430 # 11b8 <malloc+0x112>
     756:	00001097          	auipc	ra,0x1
     75a:	892080e7          	jalr	-1902(ra) # fe8 <printf>
      exit();
     75e:	00000097          	auipc	ra,0x0
     762:	4f2080e7          	jalr	1266(ra) # c50 <exit>
      printf("fork failed\n");
     766:	00001517          	auipc	a0,0x1
     76a:	cba50513          	addi	a0,a0,-838 # 1420 <malloc+0x37a>
     76e:	00001097          	auipc	ra,0x1
     772:	87a080e7          	jalr	-1926(ra) # fe8 <printf>
      exit();
     776:	00000097          	auipc	ra,0x0
     77a:	4da080e7          	jalr	1242(ra) # c50 <exit>
        if ((fd = open("/m/b/c", O_RDONLY)) >= 0) {
     77e:	00001497          	auipc	s1,0x1
     782:	cb248493          	addi	s1,s1,-846 # 1430 <malloc+0x38a>
     786:	4581                	li	a1,0
     788:	8526                	mv	a0,s1
     78a:	00000097          	auipc	ra,0x0
     78e:	506080e7          	jalr	1286(ra) # c90 <open>
     792:	fe054ae3          	bltz	a0,786 <test2+0x14a>
          close(fd);
     796:	00000097          	auipc	ra,0x0
     79a:	4e2080e7          	jalr	1250(ra) # c78 <close>
     79e:	b7e5                	j	786 <test2+0x14a>
      printf("open write failed");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	ca050513          	addi	a0,a0,-864 # 1440 <malloc+0x39a>
     7a8:	00001097          	auipc	ra,0x1
     7ac:	840080e7          	jalr	-1984(ra) # fe8 <printf>
      exit();
     7b0:	00000097          	auipc	ra,0x0
     7b4:	4a0080e7          	jalr	1184(ra) # c50 <exit>
      printf("unlink failed\n");
     7b8:	00001517          	auipc	a0,0x1
     7bc:	ca050513          	addi	a0,a0,-864 # 1458 <malloc+0x3b2>
     7c0:	00001097          	auipc	ra,0x1
     7c4:	828080e7          	jalr	-2008(ra) # fe8 <printf>
      exit();
     7c8:	00000097          	auipc	ra,0x0
     7cc:	488080e7          	jalr	1160(ra) # c50 <exit>
      printf("write failed\n");
     7d0:	00001517          	auipc	a0,0x1
     7d4:	a8850513          	addi	a0,a0,-1400 # 1258 <malloc+0x1b2>
     7d8:	00001097          	auipc	ra,0x1
     7dc:	810080e7          	jalr	-2032(ra) # fe8 <printf>
      exit();
     7e0:	00000097          	auipc	ra,0x0
     7e4:	470080e7          	jalr	1136(ra) # c50 <exit>
    printf("umount failed\n");
     7e8:	00001517          	auipc	a0,0x1
     7ec:	c8050513          	addi	a0,a0,-896 # 1468 <malloc+0x3c2>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	7f8080e7          	jalr	2040(ra) # fe8 <printf>
    exit();
     7f8:	00000097          	auipc	ra,0x0
     7fc:	458080e7          	jalr	1112(ra) # c50 <exit>

0000000000000800 <test3>:


// Mount/unmount concurrently with creating files on the mounted fs
void test3() {
     800:	7159                	addi	sp,sp,-112
     802:	f486                	sd	ra,104(sp)
     804:	f0a2                	sd	s0,96(sp)
     806:	eca6                	sd	s1,88(sp)
     808:	e8ca                	sd	s2,80(sp)
     80a:	e4ce                	sd	s3,72(sp)
     80c:	e0d2                	sd	s4,64(sp)
     80e:	fc56                	sd	s5,56(sp)
     810:	f85a                	sd	s6,48(sp)
     812:	f45e                	sd	s7,40(sp)
     814:	1880                	addi	s0,sp,112
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test3\n");
     816:	00001517          	auipc	a0,0x1
     81a:	c7250513          	addi	a0,a0,-910 # 1488 <malloc+0x3e2>
     81e:	00000097          	auipc	ra,0x0
     822:	7ca080e7          	jalr	1994(ra) # fe8 <printf>

  mkdir("/m");
     826:	00001517          	auipc	a0,0x1
     82a:	98250513          	addi	a0,a0,-1662 # 11a8 <malloc+0x102>
     82e:	00000097          	auipc	ra,0x0
     832:	48a080e7          	jalr	1162(ra) # cb8 <mkdir>
  for (i = 0; i < NPID; i++) {
     836:	fa040b13          	addi	s6,s0,-96
     83a:	fb040b93          	addi	s7,s0,-80
  mkdir("/m");
     83e:	84da                	mv	s1,s6
    if ((pid[i] = fork()) < 0) {
     840:	00000097          	auipc	ra,0x0
     844:	408080e7          	jalr	1032(ra) # c48 <fork>
     848:	c088                	sw	a0,0(s1)
     84a:	02054663          	bltz	a0,876 <test3+0x76>
      printf("fork failed\n");
      exit();
    }
    if (pid[i] == 0) {
     84e:	c121                	beqz	a0,88e <test3+0x8e>
  for (i = 0; i < NPID; i++) {
     850:	0491                	addi	s1,s1,4
     852:	ff7497e3          	bne	s1,s7,840 <test3+0x40>
        close(fd);
        sleep(1);
      }
    }
  }
  for (i = 0; i < NOP; i++) {
     856:	4481                	li	s1,0
    if (mount("/disk1", "/m") < 0) {
     858:	00001917          	auipc	s2,0x1
     85c:	95090913          	addi	s2,s2,-1712 # 11a8 <malloc+0x102>
     860:	00001a97          	auipc	s5,0x1
     864:	950a8a93          	addi	s5,s5,-1712 # 11b0 <malloc+0x10a>
      printf("mount failed\n");
      exit();
    }    
    while (umount("/m") < 0) {
      printf("umount failed; try again %d\n", i);
     868:	00001997          	auipc	s3,0x1
     86c:	c2898993          	addi	s3,s3,-984 # 1490 <malloc+0x3ea>
  for (i = 0; i < NOP; i++) {
     870:	06400a13          	li	s4,100
     874:	a875                	j	930 <test3+0x130>
      printf("fork failed\n");
     876:	00001517          	auipc	a0,0x1
     87a:	baa50513          	addi	a0,a0,-1110 # 1420 <malloc+0x37a>
     87e:	00000097          	auipc	ra,0x0
     882:	76a080e7          	jalr	1898(ra) # fe8 <printf>
      exit();
     886:	00000097          	auipc	ra,0x0
     88a:	3ca080e7          	jalr	970(ra) # c50 <exit>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     88e:	00001917          	auipc	s2,0x1
     892:	baa90913          	addi	s2,s2,-1110 # 1438 <malloc+0x392>
     896:	20100593          	li	a1,513
     89a:	854a                	mv	a0,s2
     89c:	00000097          	auipc	ra,0x0
     8a0:	3f4080e7          	jalr	1012(ra) # c90 <open>
     8a4:	84aa                	mv	s1,a0
     8a6:	02054d63          	bltz	a0,8e0 <test3+0xe0>
        unlink("/m/b");
     8aa:	854a                	mv	a0,s2
     8ac:	00000097          	auipc	ra,0x0
     8b0:	3f4080e7          	jalr	1012(ra) # ca0 <unlink>
        if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     8b4:	4605                	li	a2,1
     8b6:	f9840593          	addi	a1,s0,-104
     8ba:	8526                	mv	a0,s1
     8bc:	00000097          	auipc	ra,0x0
     8c0:	3b4080e7          	jalr	948(ra) # c70 <write>
     8c4:	4785                	li	a5,1
     8c6:	02f51963          	bne	a0,a5,8f8 <test3+0xf8>
        close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00000097          	auipc	ra,0x0
     8d0:	3ac080e7          	jalr	940(ra) # c78 <close>
        sleep(1);
     8d4:	4505                	li	a0,1
     8d6:	00000097          	auipc	ra,0x0
     8da:	40a080e7          	jalr	1034(ra) # ce0 <sleep>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     8de:	bf65                	j	896 <test3+0x96>
          printf("open write failed");
     8e0:	00001517          	auipc	a0,0x1
     8e4:	b6050513          	addi	a0,a0,-1184 # 1440 <malloc+0x39a>
     8e8:	00000097          	auipc	ra,0x0
     8ec:	700080e7          	jalr	1792(ra) # fe8 <printf>
          exit();
     8f0:	00000097          	auipc	ra,0x0
     8f4:	360080e7          	jalr	864(ra) # c50 <exit>
          printf("write failed\n");
     8f8:	00001517          	auipc	a0,0x1
     8fc:	96050513          	addi	a0,a0,-1696 # 1258 <malloc+0x1b2>
     900:	00000097          	auipc	ra,0x0
     904:	6e8080e7          	jalr	1768(ra) # fe8 <printf>
          exit();
     908:	00000097          	auipc	ra,0x0
     90c:	348080e7          	jalr	840(ra) # c50 <exit>
      printf("umount failed; try again %d\n", i);
     910:	85a6                	mv	a1,s1
     912:	854e                	mv	a0,s3
     914:	00000097          	auipc	ra,0x0
     918:	6d4080e7          	jalr	1748(ra) # fe8 <printf>
    while (umount("/m") < 0) {
     91c:	854a                	mv	a0,s2
     91e:	00000097          	auipc	ra,0x0
     922:	3ea080e7          	jalr	1002(ra) # d08 <umount>
     926:	fe0545e3          	bltz	a0,910 <test3+0x110>
  for (i = 0; i < NOP; i++) {
     92a:	2485                	addiw	s1,s1,1
     92c:	03448663          	beq	s1,s4,958 <test3+0x158>
    if (mount("/disk1", "/m") < 0) {
     930:	85ca                	mv	a1,s2
     932:	8556                	mv	a0,s5
     934:	00000097          	auipc	ra,0x0
     938:	3cc080e7          	jalr	972(ra) # d00 <mount>
     93c:	fe0550e3          	bgez	a0,91c <test3+0x11c>
      printf("mount failed\n");
     940:	00001517          	auipc	a0,0x1
     944:	87850513          	addi	a0,a0,-1928 # 11b8 <malloc+0x112>
     948:	00000097          	auipc	ra,0x0
     94c:	6a0080e7          	jalr	1696(ra) # fe8 <printf>
      exit();
     950:	00000097          	auipc	ra,0x0
     954:	300080e7          	jalr	768(ra) # c50 <exit>
    }    
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     958:	000b2503          	lw	a0,0(s6)
     95c:	00000097          	auipc	ra,0x0
     960:	324080e7          	jalr	804(ra) # c80 <kill>
    wait();
     964:	00000097          	auipc	ra,0x0
     968:	2f4080e7          	jalr	756(ra) # c58 <wait>
  for (i = 0; i < NPID; i++) {
     96c:	0b11                	addi	s6,s6,4
     96e:	ff7b15e3          	bne	s6,s7,958 <test3+0x158>
  }
  printf("test3 ok\n");
     972:	00001517          	auipc	a0,0x1
     976:	b3e50513          	addi	a0,a0,-1218 # 14b0 <malloc+0x40a>
     97a:	00000097          	auipc	ra,0x0
     97e:	66e080e7          	jalr	1646(ra) # fe8 <printf>
}
     982:	70a6                	ld	ra,104(sp)
     984:	7406                	ld	s0,96(sp)
     986:	64e6                	ld	s1,88(sp)
     988:	6946                	ld	s2,80(sp)
     98a:	69a6                	ld	s3,72(sp)
     98c:	6a06                	ld	s4,64(sp)
     98e:	7ae2                	ld	s5,56(sp)
     990:	7b42                	ld	s6,48(sp)
     992:	7ba2                	ld	s7,40(sp)
     994:	6165                	addi	sp,sp,112
     996:	8082                	ret

0000000000000998 <test4>:

void
test4()
{
     998:	1141                	addi	sp,sp,-16
     99a:	e406                	sd	ra,8(sp)
     99c:	e022                	sd	s0,0(sp)
     99e:	0800                	addi	s0,sp,16
  printf("test4\n");
     9a0:	00001517          	auipc	a0,0x1
     9a4:	b2050513          	addi	a0,a0,-1248 # 14c0 <malloc+0x41a>
     9a8:	00000097          	auipc	ra,0x0
     9ac:	640080e7          	jalr	1600(ra) # fe8 <printf>

  mknod("disk1", DISK, 1);
     9b0:	4605                	li	a2,1
     9b2:	4581                	li	a1,0
     9b4:	00000517          	auipc	a0,0x0
     9b8:	7ec50513          	addi	a0,a0,2028 # 11a0 <malloc+0xfa>
     9bc:	00000097          	auipc	ra,0x0
     9c0:	2dc080e7          	jalr	732(ra) # c98 <mknod>
  mkdir("/m");
     9c4:	00000517          	auipc	a0,0x0
     9c8:	7e450513          	addi	a0,a0,2020 # 11a8 <malloc+0x102>
     9cc:	00000097          	auipc	ra,0x0
     9d0:	2ec080e7          	jalr	748(ra) # cb8 <mkdir>
  if (mount("/disk1", "/m") < 0) {
     9d4:	00000597          	auipc	a1,0x0
     9d8:	7d458593          	addi	a1,a1,2004 # 11a8 <malloc+0x102>
     9dc:	00000517          	auipc	a0,0x0
     9e0:	7d450513          	addi	a0,a0,2004 # 11b0 <malloc+0x10a>
     9e4:	00000097          	auipc	ra,0x0
     9e8:	31c080e7          	jalr	796(ra) # d00 <mount>
     9ec:	00054f63          	bltz	a0,a0a <test4+0x72>
      printf("mount failed\n");
      exit();
  }
  crash("/m/crashf", 1);
     9f0:	4585                	li	a1,1
     9f2:	00001517          	auipc	a0,0x1
     9f6:	ad650513          	addi	a0,a0,-1322 # 14c8 <malloc+0x422>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	2fe080e7          	jalr	766(ra) # cf8 <crash>
}
     a02:	60a2                	ld	ra,8(sp)
     a04:	6402                	ld	s0,0(sp)
     a06:	0141                	addi	sp,sp,16
     a08:	8082                	ret
      printf("mount failed\n");
     a0a:	00000517          	auipc	a0,0x0
     a0e:	7ae50513          	addi	a0,a0,1966 # 11b8 <malloc+0x112>
     a12:	00000097          	auipc	ra,0x0
     a16:	5d6080e7          	jalr	1494(ra) # fe8 <printf>
      exit();
     a1a:	00000097          	auipc	ra,0x0
     a1e:	236080e7          	jalr	566(ra) # c50 <exit>

0000000000000a22 <main>:
{
     a22:	1141                	addi	sp,sp,-16
     a24:	e406                	sd	ra,8(sp)
     a26:	e022                	sd	s0,0(sp)
     a28:	0800                	addi	s0,sp,16
  test0();
     a2a:	fffff097          	auipc	ra,0xfffff
     a2e:	5d6080e7          	jalr	1494(ra) # 0 <test0>
  test1();
     a32:	00000097          	auipc	ra,0x0
     a36:	996080e7          	jalr	-1642(ra) # 3c8 <test1>
  test2();
     a3a:	00000097          	auipc	ra,0x0
     a3e:	c02080e7          	jalr	-1022(ra) # 63c <test2>
  test3();
     a42:	00000097          	auipc	ra,0x0
     a46:	dbe080e7          	jalr	-578(ra) # 800 <test3>
  test4();
     a4a:	00000097          	auipc	ra,0x0
     a4e:	f4e080e7          	jalr	-178(ra) # 998 <test4>
  exit();
     a52:	00000097          	auipc	ra,0x0
     a56:	1fe080e7          	jalr	510(ra) # c50 <exit>

0000000000000a5a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     a5a:	1141                	addi	sp,sp,-16
     a5c:	e422                	sd	s0,8(sp)
     a5e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a60:	87aa                	mv	a5,a0
     a62:	0585                	addi	a1,a1,1
     a64:	0785                	addi	a5,a5,1
     a66:	fff5c703          	lbu	a4,-1(a1)
     a6a:	fee78fa3          	sb	a4,-1(a5) # fffffffff0000fff <__global_pointer$+0xffffffffeffff30e>
     a6e:	fb75                	bnez	a4,a62 <strcpy+0x8>
    ;
  return os;
}
     a70:	6422                	ld	s0,8(sp)
     a72:	0141                	addi	sp,sp,16
     a74:	8082                	ret

0000000000000a76 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a76:	1141                	addi	sp,sp,-16
     a78:	e422                	sd	s0,8(sp)
     a7a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a7c:	00054783          	lbu	a5,0(a0)
     a80:	cb91                	beqz	a5,a94 <strcmp+0x1e>
     a82:	0005c703          	lbu	a4,0(a1)
     a86:	00f71763          	bne	a4,a5,a94 <strcmp+0x1e>
    p++, q++;
     a8a:	0505                	addi	a0,a0,1
     a8c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a8e:	00054783          	lbu	a5,0(a0)
     a92:	fbe5                	bnez	a5,a82 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     a94:	0005c503          	lbu	a0,0(a1)
}
     a98:	40a7853b          	subw	a0,a5,a0
     a9c:	6422                	ld	s0,8(sp)
     a9e:	0141                	addi	sp,sp,16
     aa0:	8082                	ret

0000000000000aa2 <strlen>:

uint
strlen(const char *s)
{
     aa2:	1141                	addi	sp,sp,-16
     aa4:	e422                	sd	s0,8(sp)
     aa6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     aa8:	00054783          	lbu	a5,0(a0)
     aac:	cf91                	beqz	a5,ac8 <strlen+0x26>
     aae:	0505                	addi	a0,a0,1
     ab0:	87aa                	mv	a5,a0
     ab2:	4685                	li	a3,1
     ab4:	9e89                	subw	a3,a3,a0
     ab6:	00f6853b          	addw	a0,a3,a5
     aba:	0785                	addi	a5,a5,1
     abc:	fff7c703          	lbu	a4,-1(a5)
     ac0:	fb7d                	bnez	a4,ab6 <strlen+0x14>
    ;
  return n;
}
     ac2:	6422                	ld	s0,8(sp)
     ac4:	0141                	addi	sp,sp,16
     ac6:	8082                	ret
  for(n = 0; s[n]; n++)
     ac8:	4501                	li	a0,0
     aca:	bfe5                	j	ac2 <strlen+0x20>

0000000000000acc <memset>:

void*
memset(void *dst, int c, uint n)
{
     acc:	1141                	addi	sp,sp,-16
     ace:	e422                	sd	s0,8(sp)
     ad0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     ad2:	ce09                	beqz	a2,aec <memset+0x20>
     ad4:	87aa                	mv	a5,a0
     ad6:	fff6071b          	addiw	a4,a2,-1
     ada:	1702                	slli	a4,a4,0x20
     adc:	9301                	srli	a4,a4,0x20
     ade:	0705                	addi	a4,a4,1
     ae0:	972a                	add	a4,a4,a0
    cdst[i] = c;
     ae2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     ae6:	0785                	addi	a5,a5,1
     ae8:	fee79de3          	bne	a5,a4,ae2 <memset+0x16>
  }
  return dst;
}
     aec:	6422                	ld	s0,8(sp)
     aee:	0141                	addi	sp,sp,16
     af0:	8082                	ret

0000000000000af2 <strchr>:

char*
strchr(const char *s, char c)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e422                	sd	s0,8(sp)
     af6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     af8:	00054783          	lbu	a5,0(a0)
     afc:	cb99                	beqz	a5,b12 <strchr+0x20>
    if(*s == c)
     afe:	00f58763          	beq	a1,a5,b0c <strchr+0x1a>
  for(; *s; s++)
     b02:	0505                	addi	a0,a0,1
     b04:	00054783          	lbu	a5,0(a0)
     b08:	fbfd                	bnez	a5,afe <strchr+0xc>
      return (char*)s;
  return 0;
     b0a:	4501                	li	a0,0
}
     b0c:	6422                	ld	s0,8(sp)
     b0e:	0141                	addi	sp,sp,16
     b10:	8082                	ret
  return 0;
     b12:	4501                	li	a0,0
     b14:	bfe5                	j	b0c <strchr+0x1a>

0000000000000b16 <gets>:

char*
gets(char *buf, int max)
{
     b16:	711d                	addi	sp,sp,-96
     b18:	ec86                	sd	ra,88(sp)
     b1a:	e8a2                	sd	s0,80(sp)
     b1c:	e4a6                	sd	s1,72(sp)
     b1e:	e0ca                	sd	s2,64(sp)
     b20:	fc4e                	sd	s3,56(sp)
     b22:	f852                	sd	s4,48(sp)
     b24:	f456                	sd	s5,40(sp)
     b26:	f05a                	sd	s6,32(sp)
     b28:	ec5e                	sd	s7,24(sp)
     b2a:	1080                	addi	s0,sp,96
     b2c:	8baa                	mv	s7,a0
     b2e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b30:	892a                	mv	s2,a0
     b32:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     b34:	4aa9                	li	s5,10
     b36:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     b38:	89a6                	mv	s3,s1
     b3a:	2485                	addiw	s1,s1,1
     b3c:	0344d863          	bge	s1,s4,b6c <gets+0x56>
    cc = read(0, &c, 1);
     b40:	4605                	li	a2,1
     b42:	faf40593          	addi	a1,s0,-81
     b46:	4501                	li	a0,0
     b48:	00000097          	auipc	ra,0x0
     b4c:	120080e7          	jalr	288(ra) # c68 <read>
    if(cc < 1)
     b50:	00a05e63          	blez	a0,b6c <gets+0x56>
    buf[i++] = c;
     b54:	faf44783          	lbu	a5,-81(s0)
     b58:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     b5c:	01578763          	beq	a5,s5,b6a <gets+0x54>
     b60:	0905                	addi	s2,s2,1
     b62:	fd679be3          	bne	a5,s6,b38 <gets+0x22>
  for(i=0; i+1 < max; ){
     b66:	89a6                	mv	s3,s1
     b68:	a011                	j	b6c <gets+0x56>
     b6a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     b6c:	99de                	add	s3,s3,s7
     b6e:	00098023          	sb	zero,0(s3)
  return buf;
}
     b72:	855e                	mv	a0,s7
     b74:	60e6                	ld	ra,88(sp)
     b76:	6446                	ld	s0,80(sp)
     b78:	64a6                	ld	s1,72(sp)
     b7a:	6906                	ld	s2,64(sp)
     b7c:	79e2                	ld	s3,56(sp)
     b7e:	7a42                	ld	s4,48(sp)
     b80:	7aa2                	ld	s5,40(sp)
     b82:	7b02                	ld	s6,32(sp)
     b84:	6be2                	ld	s7,24(sp)
     b86:	6125                	addi	sp,sp,96
     b88:	8082                	ret

0000000000000b8a <stat>:

int
stat(const char *n, struct stat *st)
{
     b8a:	1101                	addi	sp,sp,-32
     b8c:	ec06                	sd	ra,24(sp)
     b8e:	e822                	sd	s0,16(sp)
     b90:	e426                	sd	s1,8(sp)
     b92:	e04a                	sd	s2,0(sp)
     b94:	1000                	addi	s0,sp,32
     b96:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b98:	4581                	li	a1,0
     b9a:	00000097          	auipc	ra,0x0
     b9e:	0f6080e7          	jalr	246(ra) # c90 <open>
  if(fd < 0)
     ba2:	02054563          	bltz	a0,bcc <stat+0x42>
     ba6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ba8:	85ca                	mv	a1,s2
     baa:	00000097          	auipc	ra,0x0
     bae:	0fe080e7          	jalr	254(ra) # ca8 <fstat>
     bb2:	892a                	mv	s2,a0
  close(fd);
     bb4:	8526                	mv	a0,s1
     bb6:	00000097          	auipc	ra,0x0
     bba:	0c2080e7          	jalr	194(ra) # c78 <close>
  return r;
}
     bbe:	854a                	mv	a0,s2
     bc0:	60e2                	ld	ra,24(sp)
     bc2:	6442                	ld	s0,16(sp)
     bc4:	64a2                	ld	s1,8(sp)
     bc6:	6902                	ld	s2,0(sp)
     bc8:	6105                	addi	sp,sp,32
     bca:	8082                	ret
    return -1;
     bcc:	597d                	li	s2,-1
     bce:	bfc5                	j	bbe <stat+0x34>

0000000000000bd0 <atoi>:

int
atoi(const char *s)
{
     bd0:	1141                	addi	sp,sp,-16
     bd2:	e422                	sd	s0,8(sp)
     bd4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     bd6:	00054603          	lbu	a2,0(a0)
     bda:	fd06079b          	addiw	a5,a2,-48
     bde:	0ff7f793          	andi	a5,a5,255
     be2:	4725                	li	a4,9
     be4:	02f76963          	bltu	a4,a5,c16 <atoi+0x46>
     be8:	86aa                	mv	a3,a0
  n = 0;
     bea:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     bec:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     bee:	0685                	addi	a3,a3,1
     bf0:	0025179b          	slliw	a5,a0,0x2
     bf4:	9fa9                	addw	a5,a5,a0
     bf6:	0017979b          	slliw	a5,a5,0x1
     bfa:	9fb1                	addw	a5,a5,a2
     bfc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c00:	0006c603          	lbu	a2,0(a3)
     c04:	fd06071b          	addiw	a4,a2,-48
     c08:	0ff77713          	andi	a4,a4,255
     c0c:	fee5f1e3          	bgeu	a1,a4,bee <atoi+0x1e>
  return n;
}
     c10:	6422                	ld	s0,8(sp)
     c12:	0141                	addi	sp,sp,16
     c14:	8082                	ret
  n = 0;
     c16:	4501                	li	a0,0
     c18:	bfe5                	j	c10 <atoi+0x40>

0000000000000c1a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c1a:	1141                	addi	sp,sp,-16
     c1c:	e422                	sd	s0,8(sp)
     c1e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     c20:	02c05163          	blez	a2,c42 <memmove+0x28>
     c24:	fff6071b          	addiw	a4,a2,-1
     c28:	1702                	slli	a4,a4,0x20
     c2a:	9301                	srli	a4,a4,0x20
     c2c:	0705                	addi	a4,a4,1
     c2e:	972a                	add	a4,a4,a0
  dst = vdst;
     c30:	87aa                	mv	a5,a0
    *dst++ = *src++;
     c32:	0585                	addi	a1,a1,1
     c34:	0785                	addi	a5,a5,1
     c36:	fff5c683          	lbu	a3,-1(a1)
     c3a:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
     c3e:	fee79ae3          	bne	a5,a4,c32 <memmove+0x18>
  return vdst;
}
     c42:	6422                	ld	s0,8(sp)
     c44:	0141                	addi	sp,sp,16
     c46:	8082                	ret

0000000000000c48 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c48:	4885                	li	a7,1
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c50:	4889                	li	a7,2
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c58:	488d                	li	a7,3
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c60:	4891                	li	a7,4
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <read>:
.global read
read:
 li a7, SYS_read
     c68:	4895                	li	a7,5
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <write>:
.global write
write:
 li a7, SYS_write
     c70:	48c1                	li	a7,16
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <close>:
.global close
close:
 li a7, SYS_close
     c78:	48d5                	li	a7,21
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c80:	4899                	li	a7,6
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c88:	489d                	li	a7,7
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <open>:
.global open
open:
 li a7, SYS_open
     c90:	48bd                	li	a7,15
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c98:	48c5                	li	a7,17
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ca0:	48c9                	li	a7,18
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ca8:	48a1                	li	a7,8
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <link>:
.global link
link:
 li a7, SYS_link
     cb0:	48cd                	li	a7,19
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cb8:	48d1                	li	a7,20
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cc0:	48a5                	li	a7,9
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cc8:	48a9                	li	a7,10
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cd0:	48ad                	li	a7,11
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     cd8:	48b1                	li	a7,12
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ce0:	48b5                	li	a7,13
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ce8:	48b9                	li	a7,14
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     cf0:	48d9                	li	a7,22
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <crash>:
.global crash
crash:
 li a7, SYS_crash
     cf8:	48dd                	li	a7,23
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <mount>:
.global mount
mount:
 li a7, SYS_mount
     d00:	48e1                	li	a7,24
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <umount>:
.global umount
umount:
 li a7, SYS_umount
     d08:	48e5                	li	a7,25
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d10:	1101                	addi	sp,sp,-32
     d12:	ec06                	sd	ra,24(sp)
     d14:	e822                	sd	s0,16(sp)
     d16:	1000                	addi	s0,sp,32
     d18:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d1c:	4605                	li	a2,1
     d1e:	fef40593          	addi	a1,s0,-17
     d22:	00000097          	auipc	ra,0x0
     d26:	f4e080e7          	jalr	-178(ra) # c70 <write>
}
     d2a:	60e2                	ld	ra,24(sp)
     d2c:	6442                	ld	s0,16(sp)
     d2e:	6105                	addi	sp,sp,32
     d30:	8082                	ret

0000000000000d32 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d32:	7139                	addi	sp,sp,-64
     d34:	fc06                	sd	ra,56(sp)
     d36:	f822                	sd	s0,48(sp)
     d38:	f426                	sd	s1,40(sp)
     d3a:	f04a                	sd	s2,32(sp)
     d3c:	ec4e                	sd	s3,24(sp)
     d3e:	0080                	addi	s0,sp,64
     d40:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d42:	c299                	beqz	a3,d48 <printint+0x16>
     d44:	0805c863          	bltz	a1,dd4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d48:	2581                	sext.w	a1,a1
  neg = 0;
     d4a:	4881                	li	a7,0
     d4c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     d50:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d52:	2601                	sext.w	a2,a2
     d54:	00000517          	auipc	a0,0x0
     d58:	78c50513          	addi	a0,a0,1932 # 14e0 <digits>
     d5c:	883a                	mv	a6,a4
     d5e:	2705                	addiw	a4,a4,1
     d60:	02c5f7bb          	remuw	a5,a1,a2
     d64:	1782                	slli	a5,a5,0x20
     d66:	9381                	srli	a5,a5,0x20
     d68:	97aa                	add	a5,a5,a0
     d6a:	0007c783          	lbu	a5,0(a5)
     d6e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d72:	0005879b          	sext.w	a5,a1
     d76:	02c5d5bb          	divuw	a1,a1,a2
     d7a:	0685                	addi	a3,a3,1
     d7c:	fec7f0e3          	bgeu	a5,a2,d5c <printint+0x2a>
  if(neg)
     d80:	00088b63          	beqz	a7,d96 <printint+0x64>
    buf[i++] = '-';
     d84:	fd040793          	addi	a5,s0,-48
     d88:	973e                	add	a4,a4,a5
     d8a:	02d00793          	li	a5,45
     d8e:	fef70823          	sb	a5,-16(a4)
     d92:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d96:	02e05863          	blez	a4,dc6 <printint+0x94>
     d9a:	fc040793          	addi	a5,s0,-64
     d9e:	00e78933          	add	s2,a5,a4
     da2:	fff78993          	addi	s3,a5,-1
     da6:	99ba                	add	s3,s3,a4
     da8:	377d                	addiw	a4,a4,-1
     daa:	1702                	slli	a4,a4,0x20
     dac:	9301                	srli	a4,a4,0x20
     dae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     db2:	fff94583          	lbu	a1,-1(s2)
     db6:	8526                	mv	a0,s1
     db8:	00000097          	auipc	ra,0x0
     dbc:	f58080e7          	jalr	-168(ra) # d10 <putc>
  while(--i >= 0)
     dc0:	197d                	addi	s2,s2,-1
     dc2:	ff3918e3          	bne	s2,s3,db2 <printint+0x80>
}
     dc6:	70e2                	ld	ra,56(sp)
     dc8:	7442                	ld	s0,48(sp)
     dca:	74a2                	ld	s1,40(sp)
     dcc:	7902                	ld	s2,32(sp)
     dce:	69e2                	ld	s3,24(sp)
     dd0:	6121                	addi	sp,sp,64
     dd2:	8082                	ret
    x = -xx;
     dd4:	40b005bb          	negw	a1,a1
    neg = 1;
     dd8:	4885                	li	a7,1
    x = -xx;
     dda:	bf8d                	j	d4c <printint+0x1a>

0000000000000ddc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ddc:	7119                	addi	sp,sp,-128
     dde:	fc86                	sd	ra,120(sp)
     de0:	f8a2                	sd	s0,112(sp)
     de2:	f4a6                	sd	s1,104(sp)
     de4:	f0ca                	sd	s2,96(sp)
     de6:	ecce                	sd	s3,88(sp)
     de8:	e8d2                	sd	s4,80(sp)
     dea:	e4d6                	sd	s5,72(sp)
     dec:	e0da                	sd	s6,64(sp)
     dee:	fc5e                	sd	s7,56(sp)
     df0:	f862                	sd	s8,48(sp)
     df2:	f466                	sd	s9,40(sp)
     df4:	f06a                	sd	s10,32(sp)
     df6:	ec6e                	sd	s11,24(sp)
     df8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dfa:	0005c903          	lbu	s2,0(a1)
     dfe:	18090f63          	beqz	s2,f9c <vprintf+0x1c0>
     e02:	8aaa                	mv	s5,a0
     e04:	8b32                	mv	s6,a2
     e06:	00158493          	addi	s1,a1,1
  state = 0;
     e0a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     e0c:	02500a13          	li	s4,37
      if(c == 'd'){
     e10:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     e14:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     e18:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     e1c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e20:	00000b97          	auipc	s7,0x0
     e24:	6c0b8b93          	addi	s7,s7,1728 # 14e0 <digits>
     e28:	a839                	j	e46 <vprintf+0x6a>
        putc(fd, c);
     e2a:	85ca                	mv	a1,s2
     e2c:	8556                	mv	a0,s5
     e2e:	00000097          	auipc	ra,0x0
     e32:	ee2080e7          	jalr	-286(ra) # d10 <putc>
     e36:	a019                	j	e3c <vprintf+0x60>
    } else if(state == '%'){
     e38:	01498f63          	beq	s3,s4,e56 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     e3c:	0485                	addi	s1,s1,1
     e3e:	fff4c903          	lbu	s2,-1(s1)
     e42:	14090d63          	beqz	s2,f9c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     e46:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e4a:	fe0997e3          	bnez	s3,e38 <vprintf+0x5c>
      if(c == '%'){
     e4e:	fd479ee3          	bne	a5,s4,e2a <vprintf+0x4e>
        state = '%';
     e52:	89be                	mv	s3,a5
     e54:	b7e5                	j	e3c <vprintf+0x60>
      if(c == 'd'){
     e56:	05878063          	beq	a5,s8,e96 <vprintf+0xba>
      } else if(c == 'l') {
     e5a:	05978c63          	beq	a5,s9,eb2 <vprintf+0xd6>
      } else if(c == 'x') {
     e5e:	07a78863          	beq	a5,s10,ece <vprintf+0xf2>
      } else if(c == 'p') {
     e62:	09b78463          	beq	a5,s11,eea <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     e66:	07300713          	li	a4,115
     e6a:	0ce78663          	beq	a5,a4,f36 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     e6e:	06300713          	li	a4,99
     e72:	0ee78e63          	beq	a5,a4,f6e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     e76:	11478863          	beq	a5,s4,f86 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     e7a:	85d2                	mv	a1,s4
     e7c:	8556                	mv	a0,s5
     e7e:	00000097          	auipc	ra,0x0
     e82:	e92080e7          	jalr	-366(ra) # d10 <putc>
        putc(fd, c);
     e86:	85ca                	mv	a1,s2
     e88:	8556                	mv	a0,s5
     e8a:	00000097          	auipc	ra,0x0
     e8e:	e86080e7          	jalr	-378(ra) # d10 <putc>
      }
      state = 0;
     e92:	4981                	li	s3,0
     e94:	b765                	j	e3c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     e96:	008b0913          	addi	s2,s6,8
     e9a:	4685                	li	a3,1
     e9c:	4629                	li	a2,10
     e9e:	000b2583          	lw	a1,0(s6)
     ea2:	8556                	mv	a0,s5
     ea4:	00000097          	auipc	ra,0x0
     ea8:	e8e080e7          	jalr	-370(ra) # d32 <printint>
     eac:	8b4a                	mv	s6,s2
      state = 0;
     eae:	4981                	li	s3,0
     eb0:	b771                	j	e3c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eb2:	008b0913          	addi	s2,s6,8
     eb6:	4681                	li	a3,0
     eb8:	4629                	li	a2,10
     eba:	000b2583          	lw	a1,0(s6)
     ebe:	8556                	mv	a0,s5
     ec0:	00000097          	auipc	ra,0x0
     ec4:	e72080e7          	jalr	-398(ra) # d32 <printint>
     ec8:	8b4a                	mv	s6,s2
      state = 0;
     eca:	4981                	li	s3,0
     ecc:	bf85                	j	e3c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     ece:	008b0913          	addi	s2,s6,8
     ed2:	4681                	li	a3,0
     ed4:	4641                	li	a2,16
     ed6:	000b2583          	lw	a1,0(s6)
     eda:	8556                	mv	a0,s5
     edc:	00000097          	auipc	ra,0x0
     ee0:	e56080e7          	jalr	-426(ra) # d32 <printint>
     ee4:	8b4a                	mv	s6,s2
      state = 0;
     ee6:	4981                	li	s3,0
     ee8:	bf91                	j	e3c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     eea:	008b0793          	addi	a5,s6,8
     eee:	f8f43423          	sd	a5,-120(s0)
     ef2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     ef6:	03000593          	li	a1,48
     efa:	8556                	mv	a0,s5
     efc:	00000097          	auipc	ra,0x0
     f00:	e14080e7          	jalr	-492(ra) # d10 <putc>
  putc(fd, 'x');
     f04:	85ea                	mv	a1,s10
     f06:	8556                	mv	a0,s5
     f08:	00000097          	auipc	ra,0x0
     f0c:	e08080e7          	jalr	-504(ra) # d10 <putc>
     f10:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f12:	03c9d793          	srli	a5,s3,0x3c
     f16:	97de                	add	a5,a5,s7
     f18:	0007c583          	lbu	a1,0(a5)
     f1c:	8556                	mv	a0,s5
     f1e:	00000097          	auipc	ra,0x0
     f22:	df2080e7          	jalr	-526(ra) # d10 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f26:	0992                	slli	s3,s3,0x4
     f28:	397d                	addiw	s2,s2,-1
     f2a:	fe0914e3          	bnez	s2,f12 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     f2e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     f32:	4981                	li	s3,0
     f34:	b721                	j	e3c <vprintf+0x60>
        s = va_arg(ap, char*);
     f36:	008b0993          	addi	s3,s6,8
     f3a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     f3e:	02090163          	beqz	s2,f60 <vprintf+0x184>
        while(*s != 0){
     f42:	00094583          	lbu	a1,0(s2)
     f46:	c9a1                	beqz	a1,f96 <vprintf+0x1ba>
          putc(fd, *s);
     f48:	8556                	mv	a0,s5
     f4a:	00000097          	auipc	ra,0x0
     f4e:	dc6080e7          	jalr	-570(ra) # d10 <putc>
          s++;
     f52:	0905                	addi	s2,s2,1
        while(*s != 0){
     f54:	00094583          	lbu	a1,0(s2)
     f58:	f9e5                	bnez	a1,f48 <vprintf+0x16c>
        s = va_arg(ap, char*);
     f5a:	8b4e                	mv	s6,s3
      state = 0;
     f5c:	4981                	li	s3,0
     f5e:	bdf9                	j	e3c <vprintf+0x60>
          s = "(null)";
     f60:	00000917          	auipc	s2,0x0
     f64:	57890913          	addi	s2,s2,1400 # 14d8 <malloc+0x432>
        while(*s != 0){
     f68:	02800593          	li	a1,40
     f6c:	bff1                	j	f48 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     f6e:	008b0913          	addi	s2,s6,8
     f72:	000b4583          	lbu	a1,0(s6)
     f76:	8556                	mv	a0,s5
     f78:	00000097          	auipc	ra,0x0
     f7c:	d98080e7          	jalr	-616(ra) # d10 <putc>
     f80:	8b4a                	mv	s6,s2
      state = 0;
     f82:	4981                	li	s3,0
     f84:	bd65                	j	e3c <vprintf+0x60>
        putc(fd, c);
     f86:	85d2                	mv	a1,s4
     f88:	8556                	mv	a0,s5
     f8a:	00000097          	auipc	ra,0x0
     f8e:	d86080e7          	jalr	-634(ra) # d10 <putc>
      state = 0;
     f92:	4981                	li	s3,0
     f94:	b565                	j	e3c <vprintf+0x60>
        s = va_arg(ap, char*);
     f96:	8b4e                	mv	s6,s3
      state = 0;
     f98:	4981                	li	s3,0
     f9a:	b54d                	j	e3c <vprintf+0x60>
    }
  }
}
     f9c:	70e6                	ld	ra,120(sp)
     f9e:	7446                	ld	s0,112(sp)
     fa0:	74a6                	ld	s1,104(sp)
     fa2:	7906                	ld	s2,96(sp)
     fa4:	69e6                	ld	s3,88(sp)
     fa6:	6a46                	ld	s4,80(sp)
     fa8:	6aa6                	ld	s5,72(sp)
     faa:	6b06                	ld	s6,64(sp)
     fac:	7be2                	ld	s7,56(sp)
     fae:	7c42                	ld	s8,48(sp)
     fb0:	7ca2                	ld	s9,40(sp)
     fb2:	7d02                	ld	s10,32(sp)
     fb4:	6de2                	ld	s11,24(sp)
     fb6:	6109                	addi	sp,sp,128
     fb8:	8082                	ret

0000000000000fba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fba:	715d                	addi	sp,sp,-80
     fbc:	ec06                	sd	ra,24(sp)
     fbe:	e822                	sd	s0,16(sp)
     fc0:	1000                	addi	s0,sp,32
     fc2:	e010                	sd	a2,0(s0)
     fc4:	e414                	sd	a3,8(s0)
     fc6:	e818                	sd	a4,16(s0)
     fc8:	ec1c                	sd	a5,24(s0)
     fca:	03043023          	sd	a6,32(s0)
     fce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fd2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fd6:	8622                	mv	a2,s0
     fd8:	00000097          	auipc	ra,0x0
     fdc:	e04080e7          	jalr	-508(ra) # ddc <vprintf>
}
     fe0:	60e2                	ld	ra,24(sp)
     fe2:	6442                	ld	s0,16(sp)
     fe4:	6161                	addi	sp,sp,80
     fe6:	8082                	ret

0000000000000fe8 <printf>:

void
printf(const char *fmt, ...)
{
     fe8:	711d                	addi	sp,sp,-96
     fea:	ec06                	sd	ra,24(sp)
     fec:	e822                	sd	s0,16(sp)
     fee:	1000                	addi	s0,sp,32
     ff0:	e40c                	sd	a1,8(s0)
     ff2:	e810                	sd	a2,16(s0)
     ff4:	ec14                	sd	a3,24(s0)
     ff6:	f018                	sd	a4,32(s0)
     ff8:	f41c                	sd	a5,40(s0)
     ffa:	03043823          	sd	a6,48(s0)
     ffe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1002:	00840613          	addi	a2,s0,8
    1006:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    100a:	85aa                	mv	a1,a0
    100c:	4505                	li	a0,1
    100e:	00000097          	auipc	ra,0x0
    1012:	dce080e7          	jalr	-562(ra) # ddc <vprintf>
}
    1016:	60e2                	ld	ra,24(sp)
    1018:	6442                	ld	s0,16(sp)
    101a:	6125                	addi	sp,sp,96
    101c:	8082                	ret

000000000000101e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    101e:	1141                	addi	sp,sp,-16
    1020:	e422                	sd	s0,8(sp)
    1022:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1024:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1028:	00000797          	auipc	a5,0x0
    102c:	4d07b783          	ld	a5,1232(a5) # 14f8 <freep>
    1030:	a805                	j	1060 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1032:	4618                	lw	a4,8(a2)
    1034:	9db9                	addw	a1,a1,a4
    1036:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    103a:	6398                	ld	a4,0(a5)
    103c:	6318                	ld	a4,0(a4)
    103e:	fee53823          	sd	a4,-16(a0)
    1042:	a091                	j	1086 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1044:	ff852703          	lw	a4,-8(a0)
    1048:	9e39                	addw	a2,a2,a4
    104a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    104c:	ff053703          	ld	a4,-16(a0)
    1050:	e398                	sd	a4,0(a5)
    1052:	a099                	j	1098 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1054:	6398                	ld	a4,0(a5)
    1056:	00e7e463          	bltu	a5,a4,105e <free+0x40>
    105a:	00e6ea63          	bltu	a3,a4,106e <free+0x50>
{
    105e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1060:	fed7fae3          	bgeu	a5,a3,1054 <free+0x36>
    1064:	6398                	ld	a4,0(a5)
    1066:	00e6e463          	bltu	a3,a4,106e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    106a:	fee7eae3          	bltu	a5,a4,105e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    106e:	ff852583          	lw	a1,-8(a0)
    1072:	6390                	ld	a2,0(a5)
    1074:	02059713          	slli	a4,a1,0x20
    1078:	9301                	srli	a4,a4,0x20
    107a:	0712                	slli	a4,a4,0x4
    107c:	9736                	add	a4,a4,a3
    107e:	fae60ae3          	beq	a2,a4,1032 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1082:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1086:	4790                	lw	a2,8(a5)
    1088:	02061713          	slli	a4,a2,0x20
    108c:	9301                	srli	a4,a4,0x20
    108e:	0712                	slli	a4,a4,0x4
    1090:	973e                	add	a4,a4,a5
    1092:	fae689e3          	beq	a3,a4,1044 <free+0x26>
  } else
    p->s.ptr = bp;
    1096:	e394                	sd	a3,0(a5)
  freep = p;
    1098:	00000717          	auipc	a4,0x0
    109c:	46f73023          	sd	a5,1120(a4) # 14f8 <freep>
}
    10a0:	6422                	ld	s0,8(sp)
    10a2:	0141                	addi	sp,sp,16
    10a4:	8082                	ret

00000000000010a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10a6:	7139                	addi	sp,sp,-64
    10a8:	fc06                	sd	ra,56(sp)
    10aa:	f822                	sd	s0,48(sp)
    10ac:	f426                	sd	s1,40(sp)
    10ae:	f04a                	sd	s2,32(sp)
    10b0:	ec4e                	sd	s3,24(sp)
    10b2:	e852                	sd	s4,16(sp)
    10b4:	e456                	sd	s5,8(sp)
    10b6:	e05a                	sd	s6,0(sp)
    10b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10ba:	02051493          	slli	s1,a0,0x20
    10be:	9081                	srli	s1,s1,0x20
    10c0:	04bd                	addi	s1,s1,15
    10c2:	8091                	srli	s1,s1,0x4
    10c4:	0014899b          	addiw	s3,s1,1
    10c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10ca:	00000517          	auipc	a0,0x0
    10ce:	42e53503          	ld	a0,1070(a0) # 14f8 <freep>
    10d2:	c515                	beqz	a0,10fe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10d6:	4798                	lw	a4,8(a5)
    10d8:	02977f63          	bgeu	a4,s1,1116 <malloc+0x70>
    10dc:	8a4e                	mv	s4,s3
    10de:	0009871b          	sext.w	a4,s3
    10e2:	6685                	lui	a3,0x1
    10e4:	00d77363          	bgeu	a4,a3,10ea <malloc+0x44>
    10e8:	6a05                	lui	s4,0x1
    10ea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10ee:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10f2:	00000917          	auipc	s2,0x0
    10f6:	40690913          	addi	s2,s2,1030 # 14f8 <freep>
  if(p == (char*)-1)
    10fa:	5afd                	li	s5,-1
    10fc:	a88d                	j	116e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    10fe:	00000797          	auipc	a5,0x0
    1102:	40278793          	addi	a5,a5,1026 # 1500 <base>
    1106:	00000717          	auipc	a4,0x0
    110a:	3ef73923          	sd	a5,1010(a4) # 14f8 <freep>
    110e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1110:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1114:	b7e1                	j	10dc <malloc+0x36>
      if(p->s.size == nunits)
    1116:	02e48b63          	beq	s1,a4,114c <malloc+0xa6>
        p->s.size -= nunits;
    111a:	4137073b          	subw	a4,a4,s3
    111e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1120:	1702                	slli	a4,a4,0x20
    1122:	9301                	srli	a4,a4,0x20
    1124:	0712                	slli	a4,a4,0x4
    1126:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1128:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    112c:	00000717          	auipc	a4,0x0
    1130:	3ca73623          	sd	a0,972(a4) # 14f8 <freep>
      return (void*)(p + 1);
    1134:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1138:	70e2                	ld	ra,56(sp)
    113a:	7442                	ld	s0,48(sp)
    113c:	74a2                	ld	s1,40(sp)
    113e:	7902                	ld	s2,32(sp)
    1140:	69e2                	ld	s3,24(sp)
    1142:	6a42                	ld	s4,16(sp)
    1144:	6aa2                	ld	s5,8(sp)
    1146:	6b02                	ld	s6,0(sp)
    1148:	6121                	addi	sp,sp,64
    114a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    114c:	6398                	ld	a4,0(a5)
    114e:	e118                	sd	a4,0(a0)
    1150:	bff1                	j	112c <malloc+0x86>
  hp->s.size = nu;
    1152:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1156:	0541                	addi	a0,a0,16
    1158:	00000097          	auipc	ra,0x0
    115c:	ec6080e7          	jalr	-314(ra) # 101e <free>
  return freep;
    1160:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1164:	d971                	beqz	a0,1138 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1166:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1168:	4798                	lw	a4,8(a5)
    116a:	fa9776e3          	bgeu	a4,s1,1116 <malloc+0x70>
    if(p == freep)
    116e:	00093703          	ld	a4,0(s2)
    1172:	853e                	mv	a0,a5
    1174:	fef719e3          	bne	a4,a5,1166 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1178:	8552                	mv	a0,s4
    117a:	00000097          	auipc	ra,0x0
    117e:	b5e080e7          	jalr	-1186(ra) # cd8 <sbrk>
  if(p == (char*)-1)
    1182:	fd5518e3          	bne	a0,s5,1152 <malloc+0xac>
        return 0;
    1186:	4501                	li	a0,0
    1188:	bf45                	j	1138 <malloc+0x92>
