
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	04013103          	ld	sp,64(sp) # 80009040 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	0000a617          	auipc	a2,0xa
    8000004e:	fb660613          	addi	a2,a2,-74 # 8000a000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	d3478793          	addi	a5,a5,-716 # 80005d90 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd67a3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e8a78793          	addi	a5,a5,-374 # 80000f30 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(struct file *f, int user_dst, uint64 dst, int n)
{
    800000ec:	7119                	addi	sp,sp,-128
    800000ee:	fc86                	sd	ra,120(sp)
    800000f0:	f8a2                	sd	s0,112(sp)
    800000f2:	f4a6                	sd	s1,104(sp)
    800000f4:	f0ca                	sd	s2,96(sp)
    800000f6:	ecce                	sd	s3,88(sp)
    800000f8:	e8d2                	sd	s4,80(sp)
    800000fa:	e4d6                	sd	s5,72(sp)
    800000fc:	e0da                	sd	s6,64(sp)
    800000fe:	fc5e                	sd	s7,56(sp)
    80000100:	f862                	sd	s8,48(sp)
    80000102:	f466                	sd	s9,40(sp)
    80000104:	f06a                	sd	s10,32(sp)
    80000106:	ec6e                	sd	s11,24(sp)
    80000108:	0100                	addi	s0,sp,128
    8000010a:	8b2e                	mv	s6,a1
    8000010c:	8ab2                	mv	s5,a2
    8000010e:	8a36                	mv	s4,a3
  uint target;
  int c;
  char cbuf;

  target = n;
    80000110:	00068b9b          	sext.w	s7,a3
  acquire(&cons.lock);
    80000114:	00012517          	auipc	a0,0x12
    80000118:	6ec50513          	addi	a0,a0,1772 # 80012800 <cons>
    8000011c:	00001097          	auipc	ra,0x1
    80000120:	994080e7          	jalr	-1644(ra) # 80000ab0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000124:	00012497          	auipc	s1,0x12
    80000128:	6dc48493          	addi	s1,s1,1756 # 80012800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000012c:	89a6                	mv	s3,s1
    8000012e:	00012917          	auipc	s2,0x12
    80000132:	77290913          	addi	s2,s2,1906 # 800128a0 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80000136:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000138:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000013a:	4da9                	li	s11,10
  while(n > 0){
    8000013c:	07405863          	blez	s4,800001ac <consoleread+0xc0>
    while(cons.r == cons.w){
    80000140:	0a04a783          	lw	a5,160(s1)
    80000144:	0a44a703          	lw	a4,164(s1)
    80000148:	02f71463          	bne	a4,a5,80000170 <consoleread+0x84>
      if(myproc()->killed){
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	91e080e7          	jalr	-1762(ra) # 80001a6a <myproc>
    80000154:	5d1c                	lw	a5,56(a0)
    80000156:	e7b5                	bnez	a5,800001c2 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80000158:	85ce                	mv	a1,s3
    8000015a:	854a                	mv	a0,s2
    8000015c:	00002097          	auipc	ra,0x2
    80000160:	0ca080e7          	jalr	202(ra) # 80002226 <sleep>
    while(cons.r == cons.w){
    80000164:	0a04a783          	lw	a5,160(s1)
    80000168:	0a44a703          	lw	a4,164(s1)
    8000016c:	fef700e3          	beq	a4,a5,8000014c <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000170:	0017871b          	addiw	a4,a5,1
    80000174:	0ae4a023          	sw	a4,160(s1)
    80000178:	07f7f713          	andi	a4,a5,127
    8000017c:	9726                	add	a4,a4,s1
    8000017e:	02074703          	lbu	a4,32(a4)
    80000182:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000186:	079c0663          	beq	s8,s9,800001f2 <consoleread+0x106>
    cbuf = c;
    8000018a:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000018e:	4685                	li	a3,1
    80000190:	f8f40613          	addi	a2,s0,-113
    80000194:	85d6                	mv	a1,s5
    80000196:	855a                	mv	a0,s6
    80000198:	00002097          	auipc	ra,0x2
    8000019c:	2f0080e7          	jalr	752(ra) # 80002488 <either_copyout>
    800001a0:	01a50663          	beq	a0,s10,800001ac <consoleread+0xc0>
    dst++;
    800001a4:	0a85                	addi	s5,s5,1
    --n;
    800001a6:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800001a8:	f9bc1ae3          	bne	s8,s11,8000013c <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001ac:	00012517          	auipc	a0,0x12
    800001b0:	65450513          	addi	a0,a0,1620 # 80012800 <cons>
    800001b4:	00001097          	auipc	ra,0x1
    800001b8:	9cc080e7          	jalr	-1588(ra) # 80000b80 <release>

  return target - n;
    800001bc:	414b853b          	subw	a0,s7,s4
    800001c0:	a811                	j	800001d4 <consoleread+0xe8>
        release(&cons.lock);
    800001c2:	00012517          	auipc	a0,0x12
    800001c6:	63e50513          	addi	a0,a0,1598 # 80012800 <cons>
    800001ca:	00001097          	auipc	ra,0x1
    800001ce:	9b6080e7          	jalr	-1610(ra) # 80000b80 <release>
        return -1;
    800001d2:	557d                	li	a0,-1
}
    800001d4:	70e6                	ld	ra,120(sp)
    800001d6:	7446                	ld	s0,112(sp)
    800001d8:	74a6                	ld	s1,104(sp)
    800001da:	7906                	ld	s2,96(sp)
    800001dc:	69e6                	ld	s3,88(sp)
    800001de:	6a46                	ld	s4,80(sp)
    800001e0:	6aa6                	ld	s5,72(sp)
    800001e2:	6b06                	ld	s6,64(sp)
    800001e4:	7be2                	ld	s7,56(sp)
    800001e6:	7c42                	ld	s8,48(sp)
    800001e8:	7ca2                	ld	s9,40(sp)
    800001ea:	7d02                	ld	s10,32(sp)
    800001ec:	6de2                	ld	s11,24(sp)
    800001ee:	6109                	addi	sp,sp,128
    800001f0:	8082                	ret
      if(n < target){
    800001f2:	000a071b          	sext.w	a4,s4
    800001f6:	fb777be3          	bgeu	a4,s7,800001ac <consoleread+0xc0>
        cons.r--;
    800001fa:	00012717          	auipc	a4,0x12
    800001fe:	6af72323          	sw	a5,1702(a4) # 800128a0 <cons+0xa0>
    80000202:	b76d                	j	800001ac <consoleread+0xc0>

0000000080000204 <consputc>:
  if(panicked){
    80000204:	00028797          	auipc	a5,0x28
    80000208:	e1c7a783          	lw	a5,-484(a5) # 80028020 <panicked>
    8000020c:	c391                	beqz	a5,80000210 <consputc+0xc>
    for(;;)
    8000020e:	a001                	j	8000020e <consputc+0xa>
{
    80000210:	1141                	addi	sp,sp,-16
    80000212:	e406                	sd	ra,8(sp)
    80000214:	e022                	sd	s0,0(sp)
    80000216:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000218:	10000793          	li	a5,256
    8000021c:	00f50a63          	beq	a0,a5,80000230 <consputc+0x2c>
    uartputc(c);
    80000220:	00000097          	auipc	ra,0x0
    80000224:	5e2080e7          	jalr	1506(ra) # 80000802 <uartputc>
}
    80000228:	60a2                	ld	ra,8(sp)
    8000022a:	6402                	ld	s0,0(sp)
    8000022c:	0141                	addi	sp,sp,16
    8000022e:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    80000230:	4521                	li	a0,8
    80000232:	00000097          	auipc	ra,0x0
    80000236:	5d0080e7          	jalr	1488(ra) # 80000802 <uartputc>
    8000023a:	02000513          	li	a0,32
    8000023e:	00000097          	auipc	ra,0x0
    80000242:	5c4080e7          	jalr	1476(ra) # 80000802 <uartputc>
    80000246:	4521                	li	a0,8
    80000248:	00000097          	auipc	ra,0x0
    8000024c:	5ba080e7          	jalr	1466(ra) # 80000802 <uartputc>
    80000250:	bfe1                	j	80000228 <consputc+0x24>

0000000080000252 <consolewrite>:
{
    80000252:	715d                	addi	sp,sp,-80
    80000254:	e486                	sd	ra,72(sp)
    80000256:	e0a2                	sd	s0,64(sp)
    80000258:	fc26                	sd	s1,56(sp)
    8000025a:	f84a                	sd	s2,48(sp)
    8000025c:	f44e                	sd	s3,40(sp)
    8000025e:	f052                	sd	s4,32(sp)
    80000260:	ec56                	sd	s5,24(sp)
    80000262:	0880                	addi	s0,sp,80
    80000264:	89ae                	mv	s3,a1
    80000266:	84b2                	mv	s1,a2
    80000268:	8ab6                	mv	s5,a3
  acquire(&cons.lock);
    8000026a:	00012517          	auipc	a0,0x12
    8000026e:	59650513          	addi	a0,a0,1430 # 80012800 <cons>
    80000272:	00001097          	auipc	ra,0x1
    80000276:	83e080e7          	jalr	-1986(ra) # 80000ab0 <acquire>
  for(i = 0; i < n; i++){
    8000027a:	03505e63          	blez	s5,800002b6 <consolewrite+0x64>
    8000027e:	00148913          	addi	s2,s1,1
    80000282:	fffa879b          	addiw	a5,s5,-1
    80000286:	1782                	slli	a5,a5,0x20
    80000288:	9381                	srli	a5,a5,0x20
    8000028a:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000028c:	5a7d                	li	s4,-1
    8000028e:	4685                	li	a3,1
    80000290:	8626                	mv	a2,s1
    80000292:	85ce                	mv	a1,s3
    80000294:	fbf40513          	addi	a0,s0,-65
    80000298:	00002097          	auipc	ra,0x2
    8000029c:	246080e7          	jalr	582(ra) # 800024de <either_copyin>
    800002a0:	01450b63          	beq	a0,s4,800002b6 <consolewrite+0x64>
    consputc(c);
    800002a4:	fbf44503          	lbu	a0,-65(s0)
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	f5c080e7          	jalr	-164(ra) # 80000204 <consputc>
  for(i = 0; i < n; i++){
    800002b0:	0485                	addi	s1,s1,1
    800002b2:	fd249ee3          	bne	s1,s2,8000028e <consolewrite+0x3c>
  release(&cons.lock);
    800002b6:	00012517          	auipc	a0,0x12
    800002ba:	54a50513          	addi	a0,a0,1354 # 80012800 <cons>
    800002be:	00001097          	auipc	ra,0x1
    800002c2:	8c2080e7          	jalr	-1854(ra) # 80000b80 <release>
}
    800002c6:	8556                	mv	a0,s5
    800002c8:	60a6                	ld	ra,72(sp)
    800002ca:	6406                	ld	s0,64(sp)
    800002cc:	74e2                	ld	s1,56(sp)
    800002ce:	7942                	ld	s2,48(sp)
    800002d0:	79a2                	ld	s3,40(sp)
    800002d2:	7a02                	ld	s4,32(sp)
    800002d4:	6ae2                	ld	s5,24(sp)
    800002d6:	6161                	addi	sp,sp,80
    800002d8:	8082                	ret

00000000800002da <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002da:	1101                	addi	sp,sp,-32
    800002dc:	ec06                	sd	ra,24(sp)
    800002de:	e822                	sd	s0,16(sp)
    800002e0:	e426                	sd	s1,8(sp)
    800002e2:	e04a                	sd	s2,0(sp)
    800002e4:	1000                	addi	s0,sp,32
    800002e6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e8:	00012517          	auipc	a0,0x12
    800002ec:	51850513          	addi	a0,a0,1304 # 80012800 <cons>
    800002f0:	00000097          	auipc	ra,0x0
    800002f4:	7c0080e7          	jalr	1984(ra) # 80000ab0 <acquire>

  switch(c){
    800002f8:	47d5                	li	a5,21
    800002fa:	0af48663          	beq	s1,a5,800003a6 <consoleintr+0xcc>
    800002fe:	0297ca63          	blt	a5,s1,80000332 <consoleintr+0x58>
    80000302:	47a1                	li	a5,8
    80000304:	0ef48763          	beq	s1,a5,800003f2 <consoleintr+0x118>
    80000308:	47c1                	li	a5,16
    8000030a:	10f49a63          	bne	s1,a5,8000041e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000030e:	00002097          	auipc	ra,0x2
    80000312:	226080e7          	jalr	550(ra) # 80002534 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000316:	00012517          	auipc	a0,0x12
    8000031a:	4ea50513          	addi	a0,a0,1258 # 80012800 <cons>
    8000031e:	00001097          	auipc	ra,0x1
    80000322:	862080e7          	jalr	-1950(ra) # 80000b80 <release>
}
    80000326:	60e2                	ld	ra,24(sp)
    80000328:	6442                	ld	s0,16(sp)
    8000032a:	64a2                	ld	s1,8(sp)
    8000032c:	6902                	ld	s2,0(sp)
    8000032e:	6105                	addi	sp,sp,32
    80000330:	8082                	ret
  switch(c){
    80000332:	07f00793          	li	a5,127
    80000336:	0af48e63          	beq	s1,a5,800003f2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	4c670713          	addi	a4,a4,1222 # 80012800 <cons>
    80000342:	0a872783          	lw	a5,168(a4)
    80000346:	0a072703          	lw	a4,160(a4)
    8000034a:	9f99                	subw	a5,a5,a4
    8000034c:	07f00713          	li	a4,127
    80000350:	fcf763e3          	bltu	a4,a5,80000316 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000354:	47b5                	li	a5,13
    80000356:	0cf48763          	beq	s1,a5,80000424 <consoleintr+0x14a>
      consputc(c);
    8000035a:	8526                	mv	a0,s1
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	ea8080e7          	jalr	-344(ra) # 80000204 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000364:	00012797          	auipc	a5,0x12
    80000368:	49c78793          	addi	a5,a5,1180 # 80012800 <cons>
    8000036c:	0a87a703          	lw	a4,168(a5)
    80000370:	0017069b          	addiw	a3,a4,1
    80000374:	0006861b          	sext.w	a2,a3
    80000378:	0ad7a423          	sw	a3,168(a5)
    8000037c:	07f77713          	andi	a4,a4,127
    80000380:	97ba                	add	a5,a5,a4
    80000382:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000386:	47a9                	li	a5,10
    80000388:	0cf48563          	beq	s1,a5,80000452 <consoleintr+0x178>
    8000038c:	4791                	li	a5,4
    8000038e:	0cf48263          	beq	s1,a5,80000452 <consoleintr+0x178>
    80000392:	00012797          	auipc	a5,0x12
    80000396:	50e7a783          	lw	a5,1294(a5) # 800128a0 <cons+0xa0>
    8000039a:	0807879b          	addiw	a5,a5,128
    8000039e:	f6f61ce3          	bne	a2,a5,80000316 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003a2:	863e                	mv	a2,a5
    800003a4:	a07d                	j	80000452 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800003a6:	00012717          	auipc	a4,0x12
    800003aa:	45a70713          	addi	a4,a4,1114 # 80012800 <cons>
    800003ae:	0a872783          	lw	a5,168(a4)
    800003b2:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b6:	00012497          	auipc	s1,0x12
    800003ba:	44a48493          	addi	s1,s1,1098 # 80012800 <cons>
    while(cons.e != cons.w &&
    800003be:	4929                	li	s2,10
    800003c0:	f4f70be3          	beq	a4,a5,80000316 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003c4:	37fd                	addiw	a5,a5,-1
    800003c6:	07f7f713          	andi	a4,a5,127
    800003ca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003cc:	02074703          	lbu	a4,32(a4)
    800003d0:	f52703e3          	beq	a4,s2,80000316 <consoleintr+0x3c>
      cons.e--;
    800003d4:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800003d8:	10000513          	li	a0,256
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	e28080e7          	jalr	-472(ra) # 80000204 <consputc>
    while(cons.e != cons.w &&
    800003e4:	0a84a783          	lw	a5,168(s1)
    800003e8:	0a44a703          	lw	a4,164(s1)
    800003ec:	fcf71ce3          	bne	a4,a5,800003c4 <consoleintr+0xea>
    800003f0:	b71d                	j	80000316 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003f2:	00012717          	auipc	a4,0x12
    800003f6:	40e70713          	addi	a4,a4,1038 # 80012800 <cons>
    800003fa:	0a872783          	lw	a5,168(a4)
    800003fe:	0a472703          	lw	a4,164(a4)
    80000402:	f0f70ae3          	beq	a4,a5,80000316 <consoleintr+0x3c>
      cons.e--;
    80000406:	37fd                	addiw	a5,a5,-1
    80000408:	00012717          	auipc	a4,0x12
    8000040c:	4af72023          	sw	a5,1184(a4) # 800128a8 <cons+0xa8>
      consputc(BACKSPACE);
    80000410:	10000513          	li	a0,256
    80000414:	00000097          	auipc	ra,0x0
    80000418:	df0080e7          	jalr	-528(ra) # 80000204 <consputc>
    8000041c:	bded                	j	80000316 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000041e:	ee048ce3          	beqz	s1,80000316 <consoleintr+0x3c>
    80000422:	bf21                	j	8000033a <consoleintr+0x60>
      consputc(c);
    80000424:	4529                	li	a0,10
    80000426:	00000097          	auipc	ra,0x0
    8000042a:	dde080e7          	jalr	-546(ra) # 80000204 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000042e:	00012797          	auipc	a5,0x12
    80000432:	3d278793          	addi	a5,a5,978 # 80012800 <cons>
    80000436:	0a87a703          	lw	a4,168(a5)
    8000043a:	0017069b          	addiw	a3,a4,1
    8000043e:	0006861b          	sext.w	a2,a3
    80000442:	0ad7a423          	sw	a3,168(a5)
    80000446:	07f77713          	andi	a4,a4,127
    8000044a:	97ba                	add	a5,a5,a4
    8000044c:	4729                	li	a4,10
    8000044e:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80000452:	00012797          	auipc	a5,0x12
    80000456:	44c7a923          	sw	a2,1106(a5) # 800128a4 <cons+0xa4>
        wakeup(&cons.r);
    8000045a:	00012517          	auipc	a0,0x12
    8000045e:	44650513          	addi	a0,a0,1094 # 800128a0 <cons+0xa0>
    80000462:	00002097          	auipc	ra,0x2
    80000466:	f4a080e7          	jalr	-182(ra) # 800023ac <wakeup>
    8000046a:	b575                	j	80000316 <consoleintr+0x3c>

000000008000046c <consoleinit>:

void
consoleinit(void)
{
    8000046c:	1141                	addi	sp,sp,-16
    8000046e:	e406                	sd	ra,8(sp)
    80000470:	e022                	sd	s0,0(sp)
    80000472:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000474:	00008597          	auipc	a1,0x8
    80000478:	ca458593          	addi	a1,a1,-860 # 80008118 <userret+0x88>
    8000047c:	00012517          	auipc	a0,0x12
    80000480:	38450513          	addi	a0,a0,900 # 80012800 <cons>
    80000484:	00000097          	auipc	ra,0x0
    80000488:	558080e7          	jalr	1368(ra) # 800009dc <initlock>

  uartinit();
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	340080e7          	jalr	832(ra) # 800007cc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000494:	00020797          	auipc	a5,0x20
    80000498:	bcc78793          	addi	a5,a5,-1076 # 80020060 <devsw>
    8000049c:	00000717          	auipc	a4,0x0
    800004a0:	c5070713          	addi	a4,a4,-944 # 800000ec <consoleread>
    800004a4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004a6:	00000717          	auipc	a4,0x0
    800004aa:	dac70713          	addi	a4,a4,-596 # 80000252 <consolewrite>
    800004ae:	ef98                	sd	a4,24(a5)
}
    800004b0:	60a2                	ld	ra,8(sp)
    800004b2:	6402                	ld	s0,0(sp)
    800004b4:	0141                	addi	sp,sp,16
    800004b6:	8082                	ret

00000000800004b8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004b8:	7179                	addi	sp,sp,-48
    800004ba:	f406                	sd	ra,40(sp)
    800004bc:	f022                	sd	s0,32(sp)
    800004be:	ec26                	sd	s1,24(sp)
    800004c0:	e84a                	sd	s2,16(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0x12>
    800004c6:	08054663          	bltz	a0,80000552 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00009617          	auipc	a2,0x9
    800004da:	83a60613          	addi	a2,a2,-1990 # 80008d10 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x26>

  if(sign)
    80000502:	00088b63          	beqz	a7,80000518 <printint+0x60>
    buf[i++] = '-';
    80000506:	fe040793          	addi	a5,s0,-32
    8000050a:	973e                	add	a4,a4,a5
    8000050c:	02d00793          	li	a5,45
    80000510:	fef70823          	sb	a5,-16(a4)
    80000514:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000518:	02e05763          	blez	a4,80000546 <printint+0x8e>
    8000051c:	fd040793          	addi	a5,s0,-48
    80000520:	00e784b3          	add	s1,a5,a4
    80000524:	fff78913          	addi	s2,a5,-1
    80000528:	993a                	add	s2,s2,a4
    8000052a:	377d                	addiw	a4,a4,-1
    8000052c:	1702                	slli	a4,a4,0x20
    8000052e:	9301                	srli	a4,a4,0x20
    80000530:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000534:	fff4c503          	lbu	a0,-1(s1)
    80000538:	00000097          	auipc	ra,0x0
    8000053c:	ccc080e7          	jalr	-820(ra) # 80000204 <consputc>
  while(--i >= 0)
    80000540:	14fd                	addi	s1,s1,-1
    80000542:	ff2499e3          	bne	s1,s2,80000534 <printint+0x7c>
}
    80000546:	70a2                	ld	ra,40(sp)
    80000548:	7402                	ld	s0,32(sp)
    8000054a:	64e2                	ld	s1,24(sp)
    8000054c:	6942                	ld	s2,16(sp)
    8000054e:	6145                	addi	sp,sp,48
    80000550:	8082                	ret
    x = -xx;
    80000552:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000556:	4885                	li	a7,1
    x = -xx;
    80000558:	bf9d                	j	800004ce <printint+0x16>

000000008000055a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000055a:	1101                	addi	sp,sp,-32
    8000055c:	ec06                	sd	ra,24(sp)
    8000055e:	e822                	sd	s0,16(sp)
    80000560:	e426                	sd	s1,8(sp)
    80000562:	1000                	addi	s0,sp,32
    80000564:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000566:	00012797          	auipc	a5,0x12
    8000056a:	3607a523          	sw	zero,874(a5) # 800128d0 <pr+0x20>
  printf("PANIC: ");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	bb250513          	addi	a0,a0,-1102 # 80008120 <userret+0x90>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	03e080e7          	jalr	62(ra) # 800005b4 <printf>
  printf(s);
    8000057e:	8526                	mv	a0,s1
    80000580:	00000097          	auipc	ra,0x0
    80000584:	034080e7          	jalr	52(ra) # 800005b4 <printf>
  printf("\n");
    80000588:	00008517          	auipc	a0,0x8
    8000058c:	d0850513          	addi	a0,a0,-760 # 80008290 <userret+0x200>
    80000590:	00000097          	auipc	ra,0x0
    80000594:	024080e7          	jalr	36(ra) # 800005b4 <printf>
  printf("HINT: restart xv6 using 'make qemu-gdb', type 'b panic' (to set breakpoint in panic) in the gdb window, followed by 'c' (continue), and when the kernel hits the breakpoint, type 'bt' to get a backtrace\n");
    80000598:	00008517          	auipc	a0,0x8
    8000059c:	b9050513          	addi	a0,a0,-1136 # 80008128 <userret+0x98>
    800005a0:	00000097          	auipc	ra,0x0
    800005a4:	014080e7          	jalr	20(ra) # 800005b4 <printf>
  panicked = 1; // freeze other CPUs
    800005a8:	4785                	li	a5,1
    800005aa:	00028717          	auipc	a4,0x28
    800005ae:	a6f72b23          	sw	a5,-1418(a4) # 80028020 <panicked>
  for(;;)
    800005b2:	a001                	j	800005b2 <panic+0x58>

00000000800005b4 <printf>:
{
    800005b4:	7131                	addi	sp,sp,-192
    800005b6:	fc86                	sd	ra,120(sp)
    800005b8:	f8a2                	sd	s0,112(sp)
    800005ba:	f4a6                	sd	s1,104(sp)
    800005bc:	f0ca                	sd	s2,96(sp)
    800005be:	ecce                	sd	s3,88(sp)
    800005c0:	e8d2                	sd	s4,80(sp)
    800005c2:	e4d6                	sd	s5,72(sp)
    800005c4:	e0da                	sd	s6,64(sp)
    800005c6:	fc5e                	sd	s7,56(sp)
    800005c8:	f862                	sd	s8,48(sp)
    800005ca:	f466                	sd	s9,40(sp)
    800005cc:	f06a                	sd	s10,32(sp)
    800005ce:	ec6e                	sd	s11,24(sp)
    800005d0:	0100                	addi	s0,sp,128
    800005d2:	8a2a                	mv	s4,a0
    800005d4:	e40c                	sd	a1,8(s0)
    800005d6:	e810                	sd	a2,16(s0)
    800005d8:	ec14                	sd	a3,24(s0)
    800005da:	f018                	sd	a4,32(s0)
    800005dc:	f41c                	sd	a5,40(s0)
    800005de:	03043823          	sd	a6,48(s0)
    800005e2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005e6:	00012d97          	auipc	s11,0x12
    800005ea:	2eadad83          	lw	s11,746(s11) # 800128d0 <pr+0x20>
  if(locking)
    800005ee:	020d9b63          	bnez	s11,80000624 <printf+0x70>
  if (fmt == 0)
    800005f2:	040a0263          	beqz	s4,80000636 <printf+0x82>
  va_start(ap, fmt);
    800005f6:	00840793          	addi	a5,s0,8
    800005fa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005fe:	000a4503          	lbu	a0,0(s4)
    80000602:	16050263          	beqz	a0,80000766 <printf+0x1b2>
    80000606:	4481                	li	s1,0
    if(c != '%'){
    80000608:	02500a93          	li	s5,37
    switch(c){
    8000060c:	07000b13          	li	s6,112
  consputc('x');
    80000610:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000612:	00008b97          	auipc	s7,0x8
    80000616:	6feb8b93          	addi	s7,s7,1790 # 80008d10 <digits>
    switch(c){
    8000061a:	07300c93          	li	s9,115
    8000061e:	06400c13          	li	s8,100
    80000622:	a82d                	j	8000065c <printf+0xa8>
    acquire(&pr.lock);
    80000624:	00012517          	auipc	a0,0x12
    80000628:	28c50513          	addi	a0,a0,652 # 800128b0 <pr>
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	484080e7          	jalr	1156(ra) # 80000ab0 <acquire>
    80000634:	bf7d                	j	800005f2 <printf+0x3e>
    panic("null fmt");
    80000636:	00008517          	auipc	a0,0x8
    8000063a:	bca50513          	addi	a0,a0,-1078 # 80008200 <userret+0x170>
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	f1c080e7          	jalr	-228(ra) # 8000055a <panic>
      consputc(c);
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	bbe080e7          	jalr	-1090(ra) # 80000204 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000064e:	2485                	addiw	s1,s1,1
    80000650:	009a07b3          	add	a5,s4,s1
    80000654:	0007c503          	lbu	a0,0(a5)
    80000658:	10050763          	beqz	a0,80000766 <printf+0x1b2>
    if(c != '%'){
    8000065c:	ff5515e3          	bne	a0,s5,80000646 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000660:	2485                	addiw	s1,s1,1
    80000662:	009a07b3          	add	a5,s4,s1
    80000666:	0007c783          	lbu	a5,0(a5)
    8000066a:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000066e:	cfe5                	beqz	a5,80000766 <printf+0x1b2>
    switch(c){
    80000670:	05678a63          	beq	a5,s6,800006c4 <printf+0x110>
    80000674:	02fb7663          	bgeu	s6,a5,800006a0 <printf+0xec>
    80000678:	09978963          	beq	a5,s9,8000070a <printf+0x156>
    8000067c:	07800713          	li	a4,120
    80000680:	0ce79863          	bne	a5,a4,80000750 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	4605                	li	a2,1
    80000692:	85ea                	mv	a1,s10
    80000694:	4388                	lw	a0,0(a5)
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	e22080e7          	jalr	-478(ra) # 800004b8 <printint>
      break;
    8000069e:	bf45                	j	8000064e <printf+0x9a>
    switch(c){
    800006a0:	0b578263          	beq	a5,s5,80000744 <printf+0x190>
    800006a4:	0b879663          	bne	a5,s8,80000750 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	4605                	li	a2,1
    800006b6:	45a9                	li	a1,10
    800006b8:	4388                	lw	a0,0(a5)
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	dfe080e7          	jalr	-514(ra) # 800004b8 <printint>
      break;
    800006c2:	b771                	j	8000064e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006d4:	03000513          	li	a0,48
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	b2c080e7          	jalr	-1236(ra) # 80000204 <consputc>
  consputc('x');
    800006e0:	07800513          	li	a0,120
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	b20080e7          	jalr	-1248(ra) # 80000204 <consputc>
    800006ec:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ee:	03c9d793          	srli	a5,s3,0x3c
    800006f2:	97de                	add	a5,a5,s7
    800006f4:	0007c503          	lbu	a0,0(a5)
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	b0c080e7          	jalr	-1268(ra) # 80000204 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000700:	0992                	slli	s3,s3,0x4
    80000702:	397d                	addiw	s2,s2,-1
    80000704:	fe0915e3          	bnez	s2,800006ee <printf+0x13a>
    80000708:	b799                	j	8000064e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000070a:	f8843783          	ld	a5,-120(s0)
    8000070e:	00878713          	addi	a4,a5,8
    80000712:	f8e43423          	sd	a4,-120(s0)
    80000716:	0007b903          	ld	s2,0(a5)
    8000071a:	00090e63          	beqz	s2,80000736 <printf+0x182>
      for(; *s; s++)
    8000071e:	00094503          	lbu	a0,0(s2)
    80000722:	d515                	beqz	a0,8000064e <printf+0x9a>
        consputc(*s);
    80000724:	00000097          	auipc	ra,0x0
    80000728:	ae0080e7          	jalr	-1312(ra) # 80000204 <consputc>
      for(; *s; s++)
    8000072c:	0905                	addi	s2,s2,1
    8000072e:	00094503          	lbu	a0,0(s2)
    80000732:	f96d                	bnez	a0,80000724 <printf+0x170>
    80000734:	bf29                	j	8000064e <printf+0x9a>
        s = "(null)";
    80000736:	00008917          	auipc	s2,0x8
    8000073a:	ac290913          	addi	s2,s2,-1342 # 800081f8 <userret+0x168>
      for(; *s; s++)
    8000073e:	02800513          	li	a0,40
    80000742:	b7cd                	j	80000724 <printf+0x170>
      consputc('%');
    80000744:	8556                	mv	a0,s5
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	abe080e7          	jalr	-1346(ra) # 80000204 <consputc>
      break;
    8000074e:	b701                	j	8000064e <printf+0x9a>
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	00000097          	auipc	ra,0x0
    80000756:	ab2080e7          	jalr	-1358(ra) # 80000204 <consputc>
      consputc(c);
    8000075a:	854a                	mv	a0,s2
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	aa8080e7          	jalr	-1368(ra) # 80000204 <consputc>
      break;
    80000764:	b5ed                	j	8000064e <printf+0x9a>
  if(locking)
    80000766:	020d9163          	bnez	s11,80000788 <printf+0x1d4>
}
    8000076a:	70e6                	ld	ra,120(sp)
    8000076c:	7446                	ld	s0,112(sp)
    8000076e:	74a6                	ld	s1,104(sp)
    80000770:	7906                	ld	s2,96(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7ca2                	ld	s9,40(sp)
    80000780:	7d02                	ld	s10,32(sp)
    80000782:	6de2                	ld	s11,24(sp)
    80000784:	6129                	addi	sp,sp,192
    80000786:	8082                	ret
    release(&pr.lock);
    80000788:	00012517          	auipc	a0,0x12
    8000078c:	12850513          	addi	a0,a0,296 # 800128b0 <pr>
    80000790:	00000097          	auipc	ra,0x0
    80000794:	3f0080e7          	jalr	1008(ra) # 80000b80 <release>
}
    80000798:	bfc9                	j	8000076a <printf+0x1b6>

000000008000079a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000079a:	1101                	addi	sp,sp,-32
    8000079c:	ec06                	sd	ra,24(sp)
    8000079e:	e822                	sd	s0,16(sp)
    800007a0:	e426                	sd	s1,8(sp)
    800007a2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a4:	00012497          	auipc	s1,0x12
    800007a8:	10c48493          	addi	s1,s1,268 # 800128b0 <pr>
    800007ac:	00008597          	auipc	a1,0x8
    800007b0:	a6458593          	addi	a1,a1,-1436 # 80008210 <userret+0x180>
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	226080e7          	jalr	550(ra) # 800009dc <initlock>
  pr.locking = 1;
    800007be:	4785                	li	a5,1
    800007c0:	d09c                	sw	a5,32(s1)
}
    800007c2:	60e2                	ld	ra,24(sp)
    800007c4:	6442                	ld	s0,16(sp)
    800007c6:	64a2                	ld	s1,8(sp)
    800007c8:	6105                	addi	sp,sp,32
    800007ca:	8082                	ret

00000000800007cc <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007cc:	1141                	addi	sp,sp,-16
    800007ce:	e422                	sd	s0,8(sp)
    800007d0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007d2:	100007b7          	lui	a5,0x10000
    800007d6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007da:	f8000713          	li	a4,-128
    800007de:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007e2:	470d                	li	a4,3
    800007e4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007e8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007ec:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007f0:	471d                	li	a4,7
    800007f2:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007f6:	4705                	li	a4,1
    800007f8:	00e780a3          	sb	a4,1(a5)
}
    800007fc:	6422                	ld	s0,8(sp)
    800007fe:	0141                	addi	sp,sp,16
    80000800:	8082                	ret

0000000080000802 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    80000802:	1141                	addi	sp,sp,-16
    80000804:	e422                	sd	s0,8(sp)
    80000806:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    80000808:	10000737          	lui	a4,0x10000
    8000080c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000810:	0ff7f793          	andi	a5,a5,255
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dbf5                	beqz	a5,8000080c <uartputc+0xa>
    ;
  WriteReg(THR, c);
    8000081a:	0ff57513          	andi	a0,a0,255
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000826:	6422                	ld	s0,8(sp)
    80000828:	0141                	addi	sp,sp,16
    8000082a:	8082                	ret

000000008000082c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000082c:	1141                	addi	sp,sp,-16
    8000082e:	e422                	sd	s0,8(sp)
    80000830:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000832:	100007b7          	lui	a5,0x10000
    80000836:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000083a:	8b85                	andi	a5,a5,1
    8000083c:	cb91                	beqz	a5,80000850 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000083e:	100007b7          	lui	a5,0x10000
    80000842:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000846:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000084a:	6422                	ld	s0,8(sp)
    8000084c:	0141                	addi	sp,sp,16
    8000084e:	8082                	ret
    return -1;
    80000850:	557d                	li	a0,-1
    80000852:	bfe5                	j	8000084a <uartgetc+0x1e>

0000000080000854 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000085e:	54fd                	li	s1,-1
    int c = uartgetc();
    80000860:	00000097          	auipc	ra,0x0
    80000864:	fcc080e7          	jalr	-52(ra) # 8000082c <uartgetc>
    if(c == -1)
    80000868:	00950763          	beq	a0,s1,80000876 <uartintr+0x22>
      break;
    consoleintr(c);
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	a6e080e7          	jalr	-1426(ra) # 800002da <consoleintr>
  while(1){
    80000874:	b7f5                	j	80000860 <uartintr+0xc>
  }
}
    80000876:	60e2                	ld	ra,24(sp)
    80000878:	6442                	ld	s0,16(sp)
    8000087a:	64a2                	ld	s1,8(sp)
    8000087c:	6105                	addi	sp,sp,32
    8000087e:	8082                	ret

0000000080000880 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000880:	1101                	addi	sp,sp,-32
    80000882:	ec06                	sd	ra,24(sp)
    80000884:	e822                	sd	s0,16(sp)
    80000886:	e426                	sd	s1,8(sp)
    80000888:	e04a                	sd	s2,0(sp)
    8000088a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000088c:	03451793          	slli	a5,a0,0x34
    80000890:	ebb9                	bnez	a5,800008e6 <kfree+0x66>
    80000892:	84aa                	mv	s1,a0
    80000894:	00027797          	auipc	a5,0x27
    80000898:	7c878793          	addi	a5,a5,1992 # 8002805c <end>
    8000089c:	04f56563          	bltu	a0,a5,800008e6 <kfree+0x66>
    800008a0:	47c5                	li	a5,17
    800008a2:	07ee                	slli	a5,a5,0x1b
    800008a4:	04f57163          	bgeu	a0,a5,800008e6 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800008a8:	6605                	lui	a2,0x1
    800008aa:	4585                	li	a1,1
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	4d2080e7          	jalr	1234(ra) # 80000d7e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800008b4:	00012917          	auipc	s2,0x12
    800008b8:	02490913          	addi	s2,s2,36 # 800128d8 <kmem>
    800008bc:	854a                	mv	a0,s2
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	1f2080e7          	jalr	498(ra) # 80000ab0 <acquire>
  r->next = kmem.freelist;
    800008c6:	02093783          	ld	a5,32(s2)
    800008ca:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008cc:	02993023          	sd	s1,32(s2)
  release(&kmem.lock);
    800008d0:	854a                	mv	a0,s2
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	2ae080e7          	jalr	686(ra) # 80000b80 <release>
}
    800008da:	60e2                	ld	ra,24(sp)
    800008dc:	6442                	ld	s0,16(sp)
    800008de:	64a2                	ld	s1,8(sp)
    800008e0:	6902                	ld	s2,0(sp)
    800008e2:	6105                	addi	sp,sp,32
    800008e4:	8082                	ret
    panic("kfree");
    800008e6:	00008517          	auipc	a0,0x8
    800008ea:	93250513          	addi	a0,a0,-1742 # 80008218 <userret+0x188>
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	c6c080e7          	jalr	-916(ra) # 8000055a <panic>

00000000800008f6 <freerange>:
{
    800008f6:	7179                	addi	sp,sp,-48
    800008f8:	f406                	sd	ra,40(sp)
    800008fa:	f022                	sd	s0,32(sp)
    800008fc:	ec26                	sd	s1,24(sp)
    800008fe:	e84a                	sd	s2,16(sp)
    80000900:	e44e                	sd	s3,8(sp)
    80000902:	e052                	sd	s4,0(sp)
    80000904:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000906:	6785                	lui	a5,0x1
    80000908:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000090c:	94aa                	add	s1,s1,a0
    8000090e:	757d                	lui	a0,0xfffff
    80000910:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000912:	94be                	add	s1,s1,a5
    80000914:	0095ee63          	bltu	a1,s1,80000930 <freerange+0x3a>
    80000918:	892e                	mv	s2,a1
    kfree(p);
    8000091a:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000091c:	6985                	lui	s3,0x1
    kfree(p);
    8000091e:	01448533          	add	a0,s1,s4
    80000922:	00000097          	auipc	ra,0x0
    80000926:	f5e080e7          	jalr	-162(ra) # 80000880 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000092a:	94ce                	add	s1,s1,s3
    8000092c:	fe9979e3          	bgeu	s2,s1,8000091e <freerange+0x28>
}
    80000930:	70a2                	ld	ra,40(sp)
    80000932:	7402                	ld	s0,32(sp)
    80000934:	64e2                	ld	s1,24(sp)
    80000936:	6942                	ld	s2,16(sp)
    80000938:	69a2                	ld	s3,8(sp)
    8000093a:	6a02                	ld	s4,0(sp)
    8000093c:	6145                	addi	sp,sp,48
    8000093e:	8082                	ret

0000000080000940 <kinit>:
{
    80000940:	1141                	addi	sp,sp,-16
    80000942:	e406                	sd	ra,8(sp)
    80000944:	e022                	sd	s0,0(sp)
    80000946:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000948:	00008597          	auipc	a1,0x8
    8000094c:	8d858593          	addi	a1,a1,-1832 # 80008220 <userret+0x190>
    80000950:	00012517          	auipc	a0,0x12
    80000954:	f8850513          	addi	a0,a0,-120 # 800128d8 <kmem>
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	084080e7          	jalr	132(ra) # 800009dc <initlock>
  freerange(end, (void*)PHYSTOP);
    80000960:	45c5                	li	a1,17
    80000962:	05ee                	slli	a1,a1,0x1b
    80000964:	00027517          	auipc	a0,0x27
    80000968:	6f850513          	addi	a0,a0,1784 # 8002805c <end>
    8000096c:	00000097          	auipc	ra,0x0
    80000970:	f8a080e7          	jalr	-118(ra) # 800008f6 <freerange>
}
    80000974:	60a2                	ld	ra,8(sp)
    80000976:	6402                	ld	s0,0(sp)
    80000978:	0141                	addi	sp,sp,16
    8000097a:	8082                	ret

000000008000097c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000097c:	1101                	addi	sp,sp,-32
    8000097e:	ec06                	sd	ra,24(sp)
    80000980:	e822                	sd	s0,16(sp)
    80000982:	e426                	sd	s1,8(sp)
    80000984:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000986:	00012497          	auipc	s1,0x12
    8000098a:	f5248493          	addi	s1,s1,-174 # 800128d8 <kmem>
    8000098e:	8526                	mv	a0,s1
    80000990:	00000097          	auipc	ra,0x0
    80000994:	120080e7          	jalr	288(ra) # 80000ab0 <acquire>
  r = kmem.freelist;
    80000998:	7084                	ld	s1,32(s1)
  if(r)
    8000099a:	c885                	beqz	s1,800009ca <kalloc+0x4e>
    kmem.freelist = r->next;
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	00012517          	auipc	a0,0x12
    800009a2:	f3a50513          	addi	a0,a0,-198 # 800128d8 <kmem>
    800009a6:	f11c                	sd	a5,32(a0)
  release(&kmem.lock);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	1d8080e7          	jalr	472(ra) # 80000b80 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800009b0:	6605                	lui	a2,0x1
    800009b2:	4595                	li	a1,5
    800009b4:	8526                	mv	a0,s1
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	3c8080e7          	jalr	968(ra) # 80000d7e <memset>
  return (void*)r;
}
    800009be:	8526                	mv	a0,s1
    800009c0:	60e2                	ld	ra,24(sp)
    800009c2:	6442                	ld	s0,16(sp)
    800009c4:	64a2                	ld	s1,8(sp)
    800009c6:	6105                	addi	sp,sp,32
    800009c8:	8082                	ret
  release(&kmem.lock);
    800009ca:	00012517          	auipc	a0,0x12
    800009ce:	f0e50513          	addi	a0,a0,-242 # 800128d8 <kmem>
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	1ae080e7          	jalr	430(ra) # 80000b80 <release>
  if(r)
    800009da:	b7d5                	j	800009be <kalloc+0x42>

00000000800009dc <initlock>:

// assumes locks are not freed
void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
    800009dc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009de:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009e2:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800009e6:	00052e23          	sw	zero,28(a0)
  lk->n = 0;
    800009ea:	00052c23          	sw	zero,24(a0)
  if(nlock >= NLOCK)
    800009ee:	00027797          	auipc	a5,0x27
    800009f2:	6367a783          	lw	a5,1590(a5) # 80028024 <nlock>
    800009f6:	3e700713          	li	a4,999
    800009fa:	02f74063          	blt	a4,a5,80000a1a <initlock+0x3e>
    panic("initlock");
  locks[nlock] = lk;
    800009fe:	00379693          	slli	a3,a5,0x3
    80000a02:	00012717          	auipc	a4,0x12
    80000a06:	efe70713          	addi	a4,a4,-258 # 80012900 <locks>
    80000a0a:	9736                	add	a4,a4,a3
    80000a0c:	e308                	sd	a0,0(a4)
  nlock++;
    80000a0e:	2785                	addiw	a5,a5,1
    80000a10:	00027717          	auipc	a4,0x27
    80000a14:	60f72a23          	sw	a5,1556(a4) # 80028024 <nlock>
    80000a18:	8082                	ret
{
    80000a1a:	1141                	addi	sp,sp,-16
    80000a1c:	e406                	sd	ra,8(sp)
    80000a1e:	e022                	sd	s0,0(sp)
    80000a20:	0800                	addi	s0,sp,16
    panic("initlock");
    80000a22:	00008517          	auipc	a0,0x8
    80000a26:	80650513          	addi	a0,a0,-2042 # 80008228 <userret+0x198>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	b30080e7          	jalr	-1232(ra) # 8000055a <panic>

0000000080000a32 <holding>:
// Must be called with interrupts off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000a32:	411c                	lw	a5,0(a0)
    80000a34:	e399                	bnez	a5,80000a3a <holding+0x8>
    80000a36:	4501                	li	a0,0
  return r;
}
    80000a38:	8082                	ret
{
    80000a3a:	1101                	addi	sp,sp,-32
    80000a3c:	ec06                	sd	ra,24(sp)
    80000a3e:	e822                	sd	s0,16(sp)
    80000a40:	e426                	sd	s1,8(sp)
    80000a42:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000a44:	6904                	ld	s1,16(a0)
    80000a46:	00001097          	auipc	ra,0x1
    80000a4a:	008080e7          	jalr	8(ra) # 80001a4e <mycpu>
    80000a4e:	40a48533          	sub	a0,s1,a0
    80000a52:	00153513          	seqz	a0,a0
}
    80000a56:	60e2                	ld	ra,24(sp)
    80000a58:	6442                	ld	s0,16(sp)
    80000a5a:	64a2                	ld	s1,8(sp)
    80000a5c:	6105                	addi	sp,sp,32
    80000a5e:	8082                	ret

0000000080000a60 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000a60:	1101                	addi	sp,sp,-32
    80000a62:	ec06                	sd	ra,24(sp)
    80000a64:	e822                	sd	s0,16(sp)
    80000a66:	e426                	sd	s1,8(sp)
    80000a68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a6a:	100024f3          	csrr	s1,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a6e:	8889                	andi	s1,s1,2
  int old = intr_get();
  if(old)
    80000a70:	c491                	beqz	s1,80000a7c <push_off+0x1c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000a76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a78:	10079073          	csrw	sstatus,a5
    intr_off();
  if(mycpu()->noff == 0)
    80000a7c:	00001097          	auipc	ra,0x1
    80000a80:	fd2080e7          	jalr	-46(ra) # 80001a4e <mycpu>
    80000a84:	5d3c                	lw	a5,120(a0)
    80000a86:	cf89                	beqz	a5,80000aa0 <push_off+0x40>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000a88:	00001097          	auipc	ra,0x1
    80000a8c:	fc6080e7          	jalr	-58(ra) # 80001a4e <mycpu>
    80000a90:	5d3c                	lw	a5,120(a0)
    80000a92:	2785                	addiw	a5,a5,1
    80000a94:	dd3c                	sw	a5,120(a0)
}
    80000a96:	60e2                	ld	ra,24(sp)
    80000a98:	6442                	ld	s0,16(sp)
    80000a9a:	64a2                	ld	s1,8(sp)
    80000a9c:	6105                	addi	sp,sp,32
    80000a9e:	8082                	ret
    mycpu()->intena = old;
    80000aa0:	00001097          	auipc	ra,0x1
    80000aa4:	fae080e7          	jalr	-82(ra) # 80001a4e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000aa8:	009034b3          	snez	s1,s1
    80000aac:	dd64                	sw	s1,124(a0)
    80000aae:	bfe9                	j	80000a88 <push_off+0x28>

0000000080000ab0 <acquire>:
{
    80000ab0:	1101                	addi	sp,sp,-32
    80000ab2:	ec06                	sd	ra,24(sp)
    80000ab4:	e822                	sd	s0,16(sp)
    80000ab6:	e426                	sd	s1,8(sp)
    80000ab8:	1000                	addi	s0,sp,32
    80000aba:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	fa4080e7          	jalr	-92(ra) # 80000a60 <push_off>
  if(holding(lk))
    80000ac4:	8526                	mv	a0,s1
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f6c080e7          	jalr	-148(ra) # 80000a32 <holding>
    80000ace:	e911                	bnez	a0,80000ae2 <acquire+0x32>
  __sync_fetch_and_add(&(lk->n), 1);
    80000ad0:	4785                	li	a5,1
    80000ad2:	01848713          	addi	a4,s1,24
    80000ad6:	0f50000f          	fence	iorw,ow
    80000ada:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000ade:	4705                	li	a4,1
    80000ae0:	a839                	j	80000afe <acquire+0x4e>
    panic("acquire");
    80000ae2:	00007517          	auipc	a0,0x7
    80000ae6:	75650513          	addi	a0,a0,1878 # 80008238 <userret+0x1a8>
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	a70080e7          	jalr	-1424(ra) # 8000055a <panic>
     __sync_fetch_and_add(&lk->nts, 1);
    80000af2:	01c48793          	addi	a5,s1,28
    80000af6:	0f50000f          	fence	iorw,ow
    80000afa:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000afe:	87ba                	mv	a5,a4
    80000b00:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b04:	2781                	sext.w	a5,a5
    80000b06:	f7f5                	bnez	a5,80000af2 <acquire+0x42>
  __sync_synchronize();
    80000b08:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b0c:	00001097          	auipc	ra,0x1
    80000b10:	f42080e7          	jalr	-190(ra) # 80001a4e <mycpu>
    80000b14:	e888                	sd	a0,16(s1)
}
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret

0000000080000b20 <pop_off>:

void
pop_off(void)
{
    80000b20:	1141                	addi	sp,sp,-16
    80000b22:	e406                	sd	ra,8(sp)
    80000b24:	e022                	sd	s0,0(sp)
    80000b26:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b28:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000b2c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000b2e:	eb8d                	bnez	a5,80000b60 <pop_off+0x40>
    panic("pop_off - interruptible");
  struct cpu *c = mycpu();
    80000b30:	00001097          	auipc	ra,0x1
    80000b34:	f1e080e7          	jalr	-226(ra) # 80001a4e <mycpu>
  if(c->noff < 1)
    80000b38:	5d3c                	lw	a5,120(a0)
    80000b3a:	02f05b63          	blez	a5,80000b70 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000b3e:	37fd                	addiw	a5,a5,-1
    80000b40:	0007871b          	sext.w	a4,a5
    80000b44:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000b46:	eb09                	bnez	a4,80000b58 <pop_off+0x38>
    80000b48:	5d7c                	lw	a5,124(a0)
    80000b4a:	c799                	beqz	a5,80000b58 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000b50:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b54:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000b58:	60a2                	ld	ra,8(sp)
    80000b5a:	6402                	ld	s0,0(sp)
    80000b5c:	0141                	addi	sp,sp,16
    80000b5e:	8082                	ret
    panic("pop_off - interruptible");
    80000b60:	00007517          	auipc	a0,0x7
    80000b64:	6e050513          	addi	a0,a0,1760 # 80008240 <userret+0x1b0>
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9f2080e7          	jalr	-1550(ra) # 8000055a <panic>
    panic("pop_off");
    80000b70:	00007517          	auipc	a0,0x7
    80000b74:	6e850513          	addi	a0,a0,1768 # 80008258 <userret+0x1c8>
    80000b78:	00000097          	auipc	ra,0x0
    80000b7c:	9e2080e7          	jalr	-1566(ra) # 8000055a <panic>

0000000080000b80 <release>:
{
    80000b80:	1101                	addi	sp,sp,-32
    80000b82:	ec06                	sd	ra,24(sp)
    80000b84:	e822                	sd	s0,16(sp)
    80000b86:	e426                	sd	s1,8(sp)
    80000b88:	1000                	addi	s0,sp,32
    80000b8a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b8c:	00000097          	auipc	ra,0x0
    80000b90:	ea6080e7          	jalr	-346(ra) # 80000a32 <holding>
    80000b94:	c115                	beqz	a0,80000bb8 <release+0x38>
  lk->cpu = 0;
    80000b96:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b9a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b9e:	0f50000f          	fence	iorw,ow
    80000ba2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	f7a080e7          	jalr	-134(ra) # 80000b20 <pop_off>
}
    80000bae:	60e2                	ld	ra,24(sp)
    80000bb0:	6442                	ld	s0,16(sp)
    80000bb2:	64a2                	ld	s1,8(sp)
    80000bb4:	6105                	addi	sp,sp,32
    80000bb6:	8082                	ret
    panic("release");
    80000bb8:	00007517          	auipc	a0,0x7
    80000bbc:	6a850513          	addi	a0,a0,1704 # 80008260 <userret+0x1d0>
    80000bc0:	00000097          	auipc	ra,0x0
    80000bc4:	99a080e7          	jalr	-1638(ra) # 8000055a <panic>

0000000080000bc8 <print_lock>:

void
print_lock(struct spinlock *lk)
{
  if(lk->n > 0) 
    80000bc8:	4d14                	lw	a3,24(a0)
    80000bca:	e291                	bnez	a3,80000bce <print_lock+0x6>
    80000bcc:	8082                	ret
{
    80000bce:	1141                	addi	sp,sp,-16
    80000bd0:	e406                	sd	ra,8(sp)
    80000bd2:	e022                	sd	s0,0(sp)
    80000bd4:	0800                	addi	s0,sp,16
    printf("lock: %s: #test-and-set %d #acquire() %d\n", lk->name, lk->nts, lk->n);
    80000bd6:	4d50                	lw	a2,28(a0)
    80000bd8:	650c                	ld	a1,8(a0)
    80000bda:	00007517          	auipc	a0,0x7
    80000bde:	68e50513          	addi	a0,a0,1678 # 80008268 <userret+0x1d8>
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	9d2080e7          	jalr	-1582(ra) # 800005b4 <printf>
}
    80000bea:	60a2                	ld	ra,8(sp)
    80000bec:	6402                	ld	s0,0(sp)
    80000bee:	0141                	addi	sp,sp,16
    80000bf0:	8082                	ret

0000000080000bf2 <sys_ntas>:

uint64
sys_ntas(void)
{
    80000bf2:	711d                	addi	sp,sp,-96
    80000bf4:	ec86                	sd	ra,88(sp)
    80000bf6:	e8a2                	sd	s0,80(sp)
    80000bf8:	e4a6                	sd	s1,72(sp)
    80000bfa:	e0ca                	sd	s2,64(sp)
    80000bfc:	fc4e                	sd	s3,56(sp)
    80000bfe:	f852                	sd	s4,48(sp)
    80000c00:	f456                	sd	s5,40(sp)
    80000c02:	f05a                	sd	s6,32(sp)
    80000c04:	ec5e                	sd	s7,24(sp)
    80000c06:	e862                	sd	s8,16(sp)
    80000c08:	1080                	addi	s0,sp,96
  int zero = 0;
    80000c0a:	fa042623          	sw	zero,-84(s0)
  int tot = 0;
  
  if (argint(0, &zero) < 0) {
    80000c0e:	fac40593          	addi	a1,s0,-84
    80000c12:	4501                	li	a0,0
    80000c14:	00002097          	auipc	ra,0x2
    80000c18:	f6e080e7          	jalr	-146(ra) # 80002b82 <argint>
    80000c1c:	14054d63          	bltz	a0,80000d76 <sys_ntas+0x184>
    return -1;
  }
  if(zero == 0) {
    80000c20:	fac42783          	lw	a5,-84(s0)
    80000c24:	e78d                	bnez	a5,80000c4e <sys_ntas+0x5c>
    80000c26:	00012797          	auipc	a5,0x12
    80000c2a:	cda78793          	addi	a5,a5,-806 # 80012900 <locks>
    80000c2e:	00014697          	auipc	a3,0x14
    80000c32:	c1268693          	addi	a3,a3,-1006 # 80014840 <pid_lock>
    for(int i = 0; i < NLOCK; i++) {
      if(locks[i] == 0)
    80000c36:	6398                	ld	a4,0(a5)
    80000c38:	14070163          	beqz	a4,80000d7a <sys_ntas+0x188>
        break;
      locks[i]->nts = 0;
    80000c3c:	00072e23          	sw	zero,28(a4)
      locks[i]->n = 0;
    80000c40:	00072c23          	sw	zero,24(a4)
    for(int i = 0; i < NLOCK; i++) {
    80000c44:	07a1                	addi	a5,a5,8
    80000c46:	fed798e3          	bne	a5,a3,80000c36 <sys_ntas+0x44>
    }
    return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	aa09                	j	80000d5e <sys_ntas+0x16c>
  }

  printf("=== lock kmem/bcache stats\n");
    80000c4e:	00007517          	auipc	a0,0x7
    80000c52:	64a50513          	addi	a0,a0,1610 # 80008298 <userret+0x208>
    80000c56:	00000097          	auipc	ra,0x0
    80000c5a:	95e080e7          	jalr	-1698(ra) # 800005b4 <printf>
  for(int i = 0; i < NLOCK; i++) {
    80000c5e:	00012b17          	auipc	s6,0x12
    80000c62:	ca2b0b13          	addi	s6,s6,-862 # 80012900 <locks>
    80000c66:	00014b97          	auipc	s7,0x14
    80000c6a:	bdab8b93          	addi	s7,s7,-1062 # 80014840 <pid_lock>
  printf("=== lock kmem/bcache stats\n");
    80000c6e:	84da                	mv	s1,s6
  int tot = 0;
    80000c70:	4981                	li	s3,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000c72:	00007a17          	auipc	s4,0x7
    80000c76:	646a0a13          	addi	s4,s4,1606 # 800082b8 <userret+0x228>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000c7a:	00007c17          	auipc	s8,0x7
    80000c7e:	5a6c0c13          	addi	s8,s8,1446 # 80008220 <userret+0x190>
    80000c82:	a829                	j	80000c9c <sys_ntas+0xaa>
      tot += locks[i]->nts;
    80000c84:	00093503          	ld	a0,0(s2)
    80000c88:	4d5c                	lw	a5,28(a0)
    80000c8a:	013789bb          	addw	s3,a5,s3
      print_lock(locks[i]);
    80000c8e:	00000097          	auipc	ra,0x0
    80000c92:	f3a080e7          	jalr	-198(ra) # 80000bc8 <print_lock>
  for(int i = 0; i < NLOCK; i++) {
    80000c96:	04a1                	addi	s1,s1,8
    80000c98:	05748763          	beq	s1,s7,80000ce6 <sys_ntas+0xf4>
    if(locks[i] == 0)
    80000c9c:	8926                	mv	s2,s1
    80000c9e:	609c                	ld	a5,0(s1)
    80000ca0:	c3b9                	beqz	a5,80000ce6 <sys_ntas+0xf4>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000ca2:	0087ba83          	ld	s5,8(a5)
    80000ca6:	8552                	mv	a0,s4
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	25e080e7          	jalr	606(ra) # 80000f06 <strlen>
    80000cb0:	0005061b          	sext.w	a2,a0
    80000cb4:	85d2                	mv	a1,s4
    80000cb6:	8556                	mv	a0,s5
    80000cb8:	00000097          	auipc	ra,0x0
    80000cbc:	1a2080e7          	jalr	418(ra) # 80000e5a <strncmp>
    80000cc0:	d171                	beqz	a0,80000c84 <sys_ntas+0x92>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000cc2:	609c                	ld	a5,0(s1)
    80000cc4:	0087ba83          	ld	s5,8(a5)
    80000cc8:	8562                	mv	a0,s8
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	23c080e7          	jalr	572(ra) # 80000f06 <strlen>
    80000cd2:	0005061b          	sext.w	a2,a0
    80000cd6:	85e2                	mv	a1,s8
    80000cd8:	8556                	mv	a0,s5
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	180080e7          	jalr	384(ra) # 80000e5a <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000ce2:	f955                	bnez	a0,80000c96 <sys_ntas+0xa4>
    80000ce4:	b745                	j	80000c84 <sys_ntas+0x92>
    }
  }

  printf("=== top 5 contended locks:\n");
    80000ce6:	00007517          	auipc	a0,0x7
    80000cea:	5da50513          	addi	a0,a0,1498 # 800082c0 <userret+0x230>
    80000cee:	00000097          	auipc	ra,0x0
    80000cf2:	8c6080e7          	jalr	-1850(ra) # 800005b4 <printf>
    80000cf6:	4a15                	li	s4,5
  int last = 100000000;
    80000cf8:	05f5e537          	lui	a0,0x5f5e
    80000cfc:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t= 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80000d00:	4a81                	li	s5,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d02:	00012497          	auipc	s1,0x12
    80000d06:	bfe48493          	addi	s1,s1,-1026 # 80012900 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80000d0a:	3e800913          	li	s2,1000
    80000d0e:	a091                	j	80000d52 <sys_ntas+0x160>
    80000d10:	2705                	addiw	a4,a4,1
    80000d12:	06a1                	addi	a3,a3,8
    80000d14:	03270063          	beq	a4,s2,80000d34 <sys_ntas+0x142>
      if(locks[i] == 0)
    80000d18:	629c                	ld	a5,0(a3)
    80000d1a:	cf89                	beqz	a5,80000d34 <sys_ntas+0x142>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d1c:	4fd0                	lw	a2,28(a5)
    80000d1e:	00359793          	slli	a5,a1,0x3
    80000d22:	97a6                	add	a5,a5,s1
    80000d24:	639c                	ld	a5,0(a5)
    80000d26:	4fdc                	lw	a5,28(a5)
    80000d28:	fec7f4e3          	bgeu	a5,a2,80000d10 <sys_ntas+0x11e>
    80000d2c:	fea672e3          	bgeu	a2,a0,80000d10 <sys_ntas+0x11e>
    80000d30:	85ba                	mv	a1,a4
    80000d32:	bff9                	j	80000d10 <sys_ntas+0x11e>
        top = i;
      }
    }
    print_lock(locks[top]);
    80000d34:	058e                	slli	a1,a1,0x3
    80000d36:	00b48bb3          	add	s7,s1,a1
    80000d3a:	000bb503          	ld	a0,0(s7)
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	e8a080e7          	jalr	-374(ra) # 80000bc8 <print_lock>
    last = locks[top]->nts;
    80000d46:	000bb783          	ld	a5,0(s7)
    80000d4a:	4fc8                	lw	a0,28(a5)
  for(int t= 0; t < 5; t++) {
    80000d4c:	3a7d                	addiw	s4,s4,-1
    80000d4e:	000a0763          	beqz	s4,80000d5c <sys_ntas+0x16a>
  int tot = 0;
    80000d52:	86da                	mv	a3,s6
    for(int i = 0; i < NLOCK; i++) {
    80000d54:	8756                	mv	a4,s5
    int top = 0;
    80000d56:	85d6                	mv	a1,s5
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d58:	2501                	sext.w	a0,a0
    80000d5a:	bf7d                	j	80000d18 <sys_ntas+0x126>
  }
  return tot;
    80000d5c:	854e                	mv	a0,s3
}
    80000d5e:	60e6                	ld	ra,88(sp)
    80000d60:	6446                	ld	s0,80(sp)
    80000d62:	64a6                	ld	s1,72(sp)
    80000d64:	6906                	ld	s2,64(sp)
    80000d66:	79e2                	ld	s3,56(sp)
    80000d68:	7a42                	ld	s4,48(sp)
    80000d6a:	7aa2                	ld	s5,40(sp)
    80000d6c:	7b02                	ld	s6,32(sp)
    80000d6e:	6be2                	ld	s7,24(sp)
    80000d70:	6c42                	ld	s8,16(sp)
    80000d72:	6125                	addi	sp,sp,96
    80000d74:	8082                	ret
    return -1;
    80000d76:	557d                	li	a0,-1
    80000d78:	b7dd                	j	80000d5e <sys_ntas+0x16c>
    return 0;
    80000d7a:	4501                	li	a0,0
    80000d7c:	b7cd                	j	80000d5e <sys_ntas+0x16c>

0000000080000d7e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e422                	sd	s0,8(sp)
    80000d82:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d84:	ce09                	beqz	a2,80000d9e <memset+0x20>
    80000d86:	87aa                	mv	a5,a0
    80000d88:	fff6071b          	addiw	a4,a2,-1
    80000d8c:	1702                	slli	a4,a4,0x20
    80000d8e:	9301                	srli	a4,a4,0x20
    80000d90:	0705                	addi	a4,a4,1
    80000d92:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d94:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d98:	0785                	addi	a5,a5,1
    80000d9a:	fee79de3          	bne	a5,a4,80000d94 <memset+0x16>
  }
  return dst;
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000daa:	ca05                	beqz	a2,80000dda <memcmp+0x36>
    80000dac:	fff6069b          	addiw	a3,a2,-1
    80000db0:	1682                	slli	a3,a3,0x20
    80000db2:	9281                	srli	a3,a3,0x20
    80000db4:	0685                	addi	a3,a3,1
    80000db6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000db8:	00054783          	lbu	a5,0(a0)
    80000dbc:	0005c703          	lbu	a4,0(a1)
    80000dc0:	00e79863          	bne	a5,a4,80000dd0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000dc4:	0505                	addi	a0,a0,1
    80000dc6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000dc8:	fed518e3          	bne	a0,a3,80000db8 <memcmp+0x14>
  }

  return 0;
    80000dcc:	4501                	li	a0,0
    80000dce:	a019                	j	80000dd4 <memcmp+0x30>
      return *s1 - *s2;
    80000dd0:	40e7853b          	subw	a0,a5,a4
}
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
  return 0;
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <memcmp+0x30>

0000000080000dde <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000de4:	00a5f963          	bgeu	a1,a0,80000df6 <memmove+0x18>
    80000de8:	02061713          	slli	a4,a2,0x20
    80000dec:	9301                	srli	a4,a4,0x20
    80000dee:	00e587b3          	add	a5,a1,a4
    80000df2:	02f56563          	bltu	a0,a5,80000e1c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000df6:	fff6069b          	addiw	a3,a2,-1
    80000dfa:	ce11                	beqz	a2,80000e16 <memmove+0x38>
    80000dfc:	1682                	slli	a3,a3,0x20
    80000dfe:	9281                	srli	a3,a3,0x20
    80000e00:	0685                	addi	a3,a3,1
    80000e02:	96ae                	add	a3,a3,a1
    80000e04:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000e06:	0585                	addi	a1,a1,1
    80000e08:	0785                	addi	a5,a5,1
    80000e0a:	fff5c703          	lbu	a4,-1(a1)
    80000e0e:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000e12:	fed59ae3          	bne	a1,a3,80000e06 <memmove+0x28>

  return dst;
}
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret
    d += n;
    80000e1c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000e1e:	fff6069b          	addiw	a3,a2,-1
    80000e22:	da75                	beqz	a2,80000e16 <memmove+0x38>
    80000e24:	02069613          	slli	a2,a3,0x20
    80000e28:	9201                	srli	a2,a2,0x20
    80000e2a:	fff64613          	not	a2,a2
    80000e2e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000e30:	17fd                	addi	a5,a5,-1
    80000e32:	177d                	addi	a4,a4,-1
    80000e34:	0007c683          	lbu	a3,0(a5)
    80000e38:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000e3c:	fec79ae3          	bne	a5,a2,80000e30 <memmove+0x52>
    80000e40:	bfd9                	j	80000e16 <memmove+0x38>

0000000080000e42 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e406                	sd	ra,8(sp)
    80000e46:	e022                	sd	s0,0(sp)
    80000e48:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e4a:	00000097          	auipc	ra,0x0
    80000e4e:	f94080e7          	jalr	-108(ra) # 80000dde <memmove>
}
    80000e52:	60a2                	ld	ra,8(sp)
    80000e54:	6402                	ld	s0,0(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret

0000000080000e5a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e5a:	1141                	addi	sp,sp,-16
    80000e5c:	e422                	sd	s0,8(sp)
    80000e5e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e60:	ce11                	beqz	a2,80000e7c <strncmp+0x22>
    80000e62:	00054783          	lbu	a5,0(a0)
    80000e66:	cf89                	beqz	a5,80000e80 <strncmp+0x26>
    80000e68:	0005c703          	lbu	a4,0(a1)
    80000e6c:	00f71a63          	bne	a4,a5,80000e80 <strncmp+0x26>
    n--, p++, q++;
    80000e70:	367d                	addiw	a2,a2,-1
    80000e72:	0505                	addi	a0,a0,1
    80000e74:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e76:	f675                	bnez	a2,80000e62 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e78:	4501                	li	a0,0
    80000e7a:	a809                	j	80000e8c <strncmp+0x32>
    80000e7c:	4501                	li	a0,0
    80000e7e:	a039                	j	80000e8c <strncmp+0x32>
  if(n == 0)
    80000e80:	ca09                	beqz	a2,80000e92 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e82:	00054503          	lbu	a0,0(a0)
    80000e86:	0005c783          	lbu	a5,0(a1)
    80000e8a:	9d1d                	subw	a0,a0,a5
}
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret
    return 0;
    80000e92:	4501                	li	a0,0
    80000e94:	bfe5                	j	80000e8c <strncmp+0x32>

0000000080000e96 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e96:	1141                	addi	sp,sp,-16
    80000e98:	e422                	sd	s0,8(sp)
    80000e9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e9c:	872a                	mv	a4,a0
    80000e9e:	8832                	mv	a6,a2
    80000ea0:	367d                	addiw	a2,a2,-1
    80000ea2:	01005963          	blez	a6,80000eb4 <strncpy+0x1e>
    80000ea6:	0705                	addi	a4,a4,1
    80000ea8:	0005c783          	lbu	a5,0(a1)
    80000eac:	fef70fa3          	sb	a5,-1(a4)
    80000eb0:	0585                	addi	a1,a1,1
    80000eb2:	f7f5                	bnez	a5,80000e9e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000eb4:	00c05d63          	blez	a2,80000ece <strncpy+0x38>
    80000eb8:	86ba                	mv	a3,a4
    *s++ = 0;
    80000eba:	0685                	addi	a3,a3,1
    80000ebc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000ec0:	fff6c793          	not	a5,a3
    80000ec4:	9fb9                	addw	a5,a5,a4
    80000ec6:	010787bb          	addw	a5,a5,a6
    80000eca:	fef048e3          	bgtz	a5,80000eba <strncpy+0x24>
  return os;
}
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret

0000000080000ed4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ed4:	1141                	addi	sp,sp,-16
    80000ed6:	e422                	sd	s0,8(sp)
    80000ed8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eda:	02c05363          	blez	a2,80000f00 <safestrcpy+0x2c>
    80000ede:	fff6069b          	addiw	a3,a2,-1
    80000ee2:	1682                	slli	a3,a3,0x20
    80000ee4:	9281                	srli	a3,a3,0x20
    80000ee6:	96ae                	add	a3,a3,a1
    80000ee8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000eea:	00d58963          	beq	a1,a3,80000efc <safestrcpy+0x28>
    80000eee:	0585                	addi	a1,a1,1
    80000ef0:	0785                	addi	a5,a5,1
    80000ef2:	fff5c703          	lbu	a4,-1(a1)
    80000ef6:	fee78fa3          	sb	a4,-1(a5)
    80000efa:	fb65                	bnez	a4,80000eea <safestrcpy+0x16>
    ;
  *s = 0;
    80000efc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f00:	6422                	ld	s0,8(sp)
    80000f02:	0141                	addi	sp,sp,16
    80000f04:	8082                	ret

0000000080000f06 <strlen>:

int
strlen(const char *s)
{
    80000f06:	1141                	addi	sp,sp,-16
    80000f08:	e422                	sd	s0,8(sp)
    80000f0a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f0c:	00054783          	lbu	a5,0(a0)
    80000f10:	cf91                	beqz	a5,80000f2c <strlen+0x26>
    80000f12:	0505                	addi	a0,a0,1
    80000f14:	87aa                	mv	a5,a0
    80000f16:	4685                	li	a3,1
    80000f18:	9e89                	subw	a3,a3,a0
    80000f1a:	00f6853b          	addw	a0,a3,a5
    80000f1e:	0785                	addi	a5,a5,1
    80000f20:	fff7c703          	lbu	a4,-1(a5)
    80000f24:	fb7d                	bnez	a4,80000f1a <strlen+0x14>
    ;
  return n;
}
    80000f26:	6422                	ld	s0,8(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f2c:	4501                	li	a0,0
    80000f2e:	bfe5                	j	80000f26 <strlen+0x20>

0000000080000f30 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f30:	1141                	addi	sp,sp,-16
    80000f32:	e406                	sd	ra,8(sp)
    80000f34:	e022                	sd	s0,0(sp)
    80000f36:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f38:	00001097          	auipc	ra,0x1
    80000f3c:	b06080e7          	jalr	-1274(ra) # 80001a3e <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f40:	00027717          	auipc	a4,0x27
    80000f44:	0e870713          	addi	a4,a4,232 # 80028028 <started>
  if(cpuid() == 0){
    80000f48:	c139                	beqz	a0,80000f8e <main+0x5e>
    while(started == 0)
    80000f4a:	431c                	lw	a5,0(a4)
    80000f4c:	2781                	sext.w	a5,a5
    80000f4e:	dff5                	beqz	a5,80000f4a <main+0x1a>
      ;
    __sync_synchronize();
    80000f50:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f54:	00001097          	auipc	ra,0x1
    80000f58:	aea080e7          	jalr	-1302(ra) # 80001a3e <cpuid>
    80000f5c:	85aa                	mv	a1,a0
    80000f5e:	00007517          	auipc	a0,0x7
    80000f62:	39a50513          	addi	a0,a0,922 # 800082f8 <userret+0x268>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	64e080e7          	jalr	1614(ra) # 800005b4 <printf>
    kvminithart();    // turn on paging
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	1ea080e7          	jalr	490(ra) # 80001158 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	798080e7          	jalr	1944(ra) # 8000270e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	e52080e7          	jalr	-430(ra) # 80005dd0 <plicinithart>
  }

  scheduler();        
    80000f86:	00001097          	auipc	ra,0x1
    80000f8a:	fbe080e7          	jalr	-66(ra) # 80001f44 <scheduler>
    consoleinit();
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	4de080e7          	jalr	1246(ra) # 8000046c <consoleinit>
    printfinit();
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	804080e7          	jalr	-2044(ra) # 8000079a <printfinit>
    printf("\n");
    80000f9e:	00007517          	auipc	a0,0x7
    80000fa2:	2f250513          	addi	a0,a0,754 # 80008290 <userret+0x200>
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	60e080e7          	jalr	1550(ra) # 800005b4 <printf>
    printf("xv6 kernel is booting\n");
    80000fae:	00007517          	auipc	a0,0x7
    80000fb2:	33250513          	addi	a0,a0,818 # 800082e0 <userret+0x250>
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	5fe080e7          	jalr	1534(ra) # 800005b4 <printf>
    printf("\n");
    80000fbe:	00007517          	auipc	a0,0x7
    80000fc2:	2d250513          	addi	a0,a0,722 # 80008290 <userret+0x200>
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	5ee080e7          	jalr	1518(ra) # 800005b4 <printf>
    kinit();         // physical page allocator
    80000fce:	00000097          	auipc	ra,0x0
    80000fd2:	972080e7          	jalr	-1678(ra) # 80000940 <kinit>
    kvminit();       // create kernel page table
    80000fd6:	00000097          	auipc	ra,0x0
    80000fda:	30c080e7          	jalr	780(ra) # 800012e2 <kvminit>
    kvminithart();   // turn on paging
    80000fde:	00000097          	auipc	ra,0x0
    80000fe2:	17a080e7          	jalr	378(ra) # 80001158 <kvminithart>
    procinit();      // process table
    80000fe6:	00001097          	auipc	ra,0x1
    80000fea:	988080e7          	jalr	-1656(ra) # 8000196e <procinit>
    trapinit();      // trap vectors
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	6f8080e7          	jalr	1784(ra) # 800026e6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ff6:	00001097          	auipc	ra,0x1
    80000ffa:	718080e7          	jalr	1816(ra) # 8000270e <trapinithart>
    plicinit();      // set up interrupt controller
    80000ffe:	00005097          	auipc	ra,0x5
    80001002:	dbc080e7          	jalr	-580(ra) # 80005dba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	dca080e7          	jalr	-566(ra) # 80005dd0 <plicinithart>
    binit();         // buffer cache
    8000100e:	00002097          	auipc	ra,0x2
    80001012:	e56080e7          	jalr	-426(ra) # 80002e64 <binit>
    iinit();         // inode cache
    80001016:	00002097          	auipc	ra,0x2
    8000101a:	4ea080e7          	jalr	1258(ra) # 80003500 <iinit>
    fileinit();      // file table
    8000101e:	00003097          	auipc	ra,0x3
    80001022:	574080e7          	jalr	1396(ra) # 80004592 <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80001026:	4501                	li	a0,0
    80001028:	00005097          	auipc	ra,0x5
    8000102c:	eca080e7          	jalr	-310(ra) # 80005ef2 <virtio_disk_init>
    userinit();      // first user process
    80001030:	00001097          	auipc	ra,0x1
    80001034:	cae080e7          	jalr	-850(ra) # 80001cde <userinit>
    __sync_synchronize();
    80001038:	0ff0000f          	fence
    started = 1;
    8000103c:	4785                	li	a5,1
    8000103e:	00027717          	auipc	a4,0x27
    80001042:	fef72523          	sw	a5,-22(a4) # 80028028 <started>
    80001046:	b781                	j	80000f86 <main+0x56>

0000000080001048 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001048:	7139                	addi	sp,sp,-64
    8000104a:	fc06                	sd	ra,56(sp)
    8000104c:	f822                	sd	s0,48(sp)
    8000104e:	f426                	sd	s1,40(sp)
    80001050:	f04a                	sd	s2,32(sp)
    80001052:	ec4e                	sd	s3,24(sp)
    80001054:	e852                	sd	s4,16(sp)
    80001056:	e456                	sd	s5,8(sp)
    80001058:	e05a                	sd	s6,0(sp)
    8000105a:	0080                	addi	s0,sp,64
    8000105c:	84aa                	mv	s1,a0
    8000105e:	89ae                	mv	s3,a1
    80001060:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001062:	57fd                	li	a5,-1
    80001064:	83e9                	srli	a5,a5,0x1a
    80001066:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001068:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000106a:	04b7f263          	bgeu	a5,a1,800010ae <walk+0x66>
    panic("walk");
    8000106e:	00007517          	auipc	a0,0x7
    80001072:	2a250513          	addi	a0,a0,674 # 80008310 <userret+0x280>
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	4e4080e7          	jalr	1252(ra) # 8000055a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000107e:	060a8663          	beqz	s5,800010ea <walk+0xa2>
    80001082:	00000097          	auipc	ra,0x0
    80001086:	8fa080e7          	jalr	-1798(ra) # 8000097c <kalloc>
    8000108a:	84aa                	mv	s1,a0
    8000108c:	c529                	beqz	a0,800010d6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000108e:	6605                	lui	a2,0x1
    80001090:	4581                	li	a1,0
    80001092:	00000097          	auipc	ra,0x0
    80001096:	cec080e7          	jalr	-788(ra) # 80000d7e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000109a:	00c4d793          	srli	a5,s1,0xc
    8000109e:	07aa                	slli	a5,a5,0xa
    800010a0:	0017e793          	ori	a5,a5,1
    800010a4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010a8:	3a5d                	addiw	s4,s4,-9
    800010aa:	036a0063          	beq	s4,s6,800010ca <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010ae:	0149d933          	srl	s2,s3,s4
    800010b2:	1ff97913          	andi	s2,s2,511
    800010b6:	090e                	slli	s2,s2,0x3
    800010b8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010ba:	00093483          	ld	s1,0(s2)
    800010be:	0014f793          	andi	a5,s1,1
    800010c2:	dfd5                	beqz	a5,8000107e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010c4:	80a9                	srli	s1,s1,0xa
    800010c6:	04b2                	slli	s1,s1,0xc
    800010c8:	b7c5                	j	800010a8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010ca:	00c9d513          	srli	a0,s3,0xc
    800010ce:	1ff57513          	andi	a0,a0,511
    800010d2:	050e                	slli	a0,a0,0x3
    800010d4:	9526                	add	a0,a0,s1
}
    800010d6:	70e2                	ld	ra,56(sp)
    800010d8:	7442                	ld	s0,48(sp)
    800010da:	74a2                	ld	s1,40(sp)
    800010dc:	7902                	ld	s2,32(sp)
    800010de:	69e2                	ld	s3,24(sp)
    800010e0:	6a42                	ld	s4,16(sp)
    800010e2:	6aa2                	ld	s5,8(sp)
    800010e4:	6b02                	ld	s6,0(sp)
    800010e6:	6121                	addi	sp,sp,64
    800010e8:	8082                	ret
        return 0;
    800010ea:	4501                	li	a0,0
    800010ec:	b7ed                	j	800010d6 <walk+0x8e>

00000000800010ee <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    800010ee:	7179                	addi	sp,sp,-48
    800010f0:	f406                	sd	ra,40(sp)
    800010f2:	f022                	sd	s0,32(sp)
    800010f4:	ec26                	sd	s1,24(sp)
    800010f6:	e84a                	sd	s2,16(sp)
    800010f8:	e44e                	sd	s3,8(sp)
    800010fa:	e052                	sd	s4,0(sp)
    800010fc:	1800                	addi	s0,sp,48
    800010fe:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001100:	84aa                	mv	s1,a0
    80001102:	6905                	lui	s2,0x1
    80001104:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001106:	4985                	li	s3,1
    80001108:	a821                	j	80001120 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000110a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000110c:	0532                	slli	a0,a0,0xc
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	fe0080e7          	jalr	-32(ra) # 800010ee <freewalk>
      pagetable[i] = 0;
    80001116:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000111a:	04a1                	addi	s1,s1,8
    8000111c:	03248163          	beq	s1,s2,8000113e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001120:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001122:	00f57793          	andi	a5,a0,15
    80001126:	ff3782e3          	beq	a5,s3,8000110a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000112a:	8905                	andi	a0,a0,1
    8000112c:	d57d                	beqz	a0,8000111a <freewalk+0x2c>
      panic("freewalk: leaf");
    8000112e:	00007517          	auipc	a0,0x7
    80001132:	1ea50513          	addi	a0,a0,490 # 80008318 <userret+0x288>
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	424080e7          	jalr	1060(ra) # 8000055a <panic>
    }
  }
  kfree((void*)pagetable);
    8000113e:	8552                	mv	a0,s4
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	740080e7          	jalr	1856(ra) # 80000880 <kfree>
}
    80001148:	70a2                	ld	ra,40(sp)
    8000114a:	7402                	ld	s0,32(sp)
    8000114c:	64e2                	ld	s1,24(sp)
    8000114e:	6942                	ld	s2,16(sp)
    80001150:	69a2                	ld	s3,8(sp)
    80001152:	6a02                	ld	s4,0(sp)
    80001154:	6145                	addi	sp,sp,48
    80001156:	8082                	ret

0000000080001158 <kvminithart>:
{
    80001158:	1141                	addi	sp,sp,-16
    8000115a:	e422                	sd	s0,8(sp)
    8000115c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000115e:	00027797          	auipc	a5,0x27
    80001162:	ed27b783          	ld	a5,-302(a5) # 80028030 <kernel_pagetable>
    80001166:	83b1                	srli	a5,a5,0xc
    80001168:	577d                	li	a4,-1
    8000116a:	177e                	slli	a4,a4,0x3f
    8000116c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000116e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001172:	12000073          	sfence.vma
}
    80001176:	6422                	ld	s0,8(sp)
    80001178:	0141                	addi	sp,sp,16
    8000117a:	8082                	ret

000000008000117c <walkaddr>:
  if(va >= MAXVA)
    8000117c:	57fd                	li	a5,-1
    8000117e:	83e9                	srli	a5,a5,0x1a
    80001180:	00b7f463          	bgeu	a5,a1,80001188 <walkaddr+0xc>
    return 0;
    80001184:	4501                	li	a0,0
}
    80001186:	8082                	ret
{
    80001188:	1141                	addi	sp,sp,-16
    8000118a:	e406                	sd	ra,8(sp)
    8000118c:	e022                	sd	s0,0(sp)
    8000118e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001190:	4601                	li	a2,0
    80001192:	00000097          	auipc	ra,0x0
    80001196:	eb6080e7          	jalr	-330(ra) # 80001048 <walk>
  if(pte == 0)
    8000119a:	c105                	beqz	a0,800011ba <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000119c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000119e:	0117f693          	andi	a3,a5,17
    800011a2:	4745                	li	a4,17
    return 0;
    800011a4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011a6:	00e68663          	beq	a3,a4,800011b2 <walkaddr+0x36>
}
    800011aa:	60a2                	ld	ra,8(sp)
    800011ac:	6402                	ld	s0,0(sp)
    800011ae:	0141                	addi	sp,sp,16
    800011b0:	8082                	ret
  pa = PTE2PA(*pte);
    800011b2:	00a7d513          	srli	a0,a5,0xa
    800011b6:	0532                	slli	a0,a0,0xc
  return pa;
    800011b8:	bfcd                	j	800011aa <walkaddr+0x2e>
    return 0;
    800011ba:	4501                	li	a0,0
    800011bc:	b7fd                	j	800011aa <walkaddr+0x2e>

00000000800011be <kvmpa>:
{
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	1000                	addi	s0,sp,32
    800011c8:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800011ca:	1552                	slli	a0,a0,0x34
    800011cc:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    800011d0:	4601                	li	a2,0
    800011d2:	00027517          	auipc	a0,0x27
    800011d6:	e5e53503          	ld	a0,-418(a0) # 80028030 <kernel_pagetable>
    800011da:	00000097          	auipc	ra,0x0
    800011de:	e6e080e7          	jalr	-402(ra) # 80001048 <walk>
  if(pte == 0)
    800011e2:	cd09                	beqz	a0,800011fc <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    800011e4:	6108                	ld	a0,0(a0)
    800011e6:	00157793          	andi	a5,a0,1
    800011ea:	c38d                	beqz	a5,8000120c <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    800011ec:	8129                	srli	a0,a0,0xa
    800011ee:	0532                	slli	a0,a0,0xc
}
    800011f0:	9526                	add	a0,a0,s1
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6105                	addi	sp,sp,32
    800011fa:	8082                	ret
    panic("kvmpa");
    800011fc:	00007517          	auipc	a0,0x7
    80001200:	12c50513          	addi	a0,a0,300 # 80008328 <userret+0x298>
    80001204:	fffff097          	auipc	ra,0xfffff
    80001208:	356080e7          	jalr	854(ra) # 8000055a <panic>
    panic("kvmpa");
    8000120c:	00007517          	auipc	a0,0x7
    80001210:	11c50513          	addi	a0,a0,284 # 80008328 <userret+0x298>
    80001214:	fffff097          	auipc	ra,0xfffff
    80001218:	346080e7          	jalr	838(ra) # 8000055a <panic>

000000008000121c <mappages>:
{
    8000121c:	715d                	addi	sp,sp,-80
    8000121e:	e486                	sd	ra,72(sp)
    80001220:	e0a2                	sd	s0,64(sp)
    80001222:	fc26                	sd	s1,56(sp)
    80001224:	f84a                	sd	s2,48(sp)
    80001226:	f44e                	sd	s3,40(sp)
    80001228:	f052                	sd	s4,32(sp)
    8000122a:	ec56                	sd	s5,24(sp)
    8000122c:	e85a                	sd	s6,16(sp)
    8000122e:	e45e                	sd	s7,8(sp)
    80001230:	0880                	addi	s0,sp,80
    80001232:	8aaa                	mv	s5,a0
    80001234:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001236:	777d                	lui	a4,0xfffff
    80001238:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000123c:	167d                	addi	a2,a2,-1
    8000123e:	00b609b3          	add	s3,a2,a1
    80001242:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001246:	893e                	mv	s2,a5
    80001248:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000124c:	6b85                	lui	s7,0x1
    8000124e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001252:	4605                	li	a2,1
    80001254:	85ca                	mv	a1,s2
    80001256:	8556                	mv	a0,s5
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	df0080e7          	jalr	-528(ra) # 80001048 <walk>
    80001260:	c51d                	beqz	a0,8000128e <mappages+0x72>
    if(*pte & PTE_V)
    80001262:	611c                	ld	a5,0(a0)
    80001264:	8b85                	andi	a5,a5,1
    80001266:	ef81                	bnez	a5,8000127e <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001268:	80b1                	srli	s1,s1,0xc
    8000126a:	04aa                	slli	s1,s1,0xa
    8000126c:	0164e4b3          	or	s1,s1,s6
    80001270:	0014e493          	ori	s1,s1,1
    80001274:	e104                	sd	s1,0(a0)
    if(a == last)
    80001276:	03390863          	beq	s2,s3,800012a6 <mappages+0x8a>
    a += PGSIZE;
    8000127a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000127c:	bfc9                	j	8000124e <mappages+0x32>
      panic("remap");
    8000127e:	00007517          	auipc	a0,0x7
    80001282:	0b250513          	addi	a0,a0,178 # 80008330 <userret+0x2a0>
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	2d4080e7          	jalr	724(ra) # 8000055a <panic>
      return -1;
    8000128e:	557d                	li	a0,-1
}
    80001290:	60a6                	ld	ra,72(sp)
    80001292:	6406                	ld	s0,64(sp)
    80001294:	74e2                	ld	s1,56(sp)
    80001296:	7942                	ld	s2,48(sp)
    80001298:	79a2                	ld	s3,40(sp)
    8000129a:	7a02                	ld	s4,32(sp)
    8000129c:	6ae2                	ld	s5,24(sp)
    8000129e:	6b42                	ld	s6,16(sp)
    800012a0:	6ba2                	ld	s7,8(sp)
    800012a2:	6161                	addi	sp,sp,80
    800012a4:	8082                	ret
  return 0;
    800012a6:	4501                	li	a0,0
    800012a8:	b7e5                	j	80001290 <mappages+0x74>

00000000800012aa <kvmmap>:
{
    800012aa:	1141                	addi	sp,sp,-16
    800012ac:	e406                	sd	ra,8(sp)
    800012ae:	e022                	sd	s0,0(sp)
    800012b0:	0800                	addi	s0,sp,16
    800012b2:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800012b4:	86ae                	mv	a3,a1
    800012b6:	85aa                	mv	a1,a0
    800012b8:	00027517          	auipc	a0,0x27
    800012bc:	d7853503          	ld	a0,-648(a0) # 80028030 <kernel_pagetable>
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	f5c080e7          	jalr	-164(ra) # 8000121c <mappages>
    800012c8:	e509                	bnez	a0,800012d2 <kvmmap+0x28>
}
    800012ca:	60a2                	ld	ra,8(sp)
    800012cc:	6402                	ld	s0,0(sp)
    800012ce:	0141                	addi	sp,sp,16
    800012d0:	8082                	ret
    panic("kvmmap");
    800012d2:	00007517          	auipc	a0,0x7
    800012d6:	06650513          	addi	a0,a0,102 # 80008338 <userret+0x2a8>
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	280080e7          	jalr	640(ra) # 8000055a <panic>

00000000800012e2 <kvminit>:
{
    800012e2:	1101                	addi	sp,sp,-32
    800012e4:	ec06                	sd	ra,24(sp)
    800012e6:	e822                	sd	s0,16(sp)
    800012e8:	e426                	sd	s1,8(sp)
    800012ea:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	690080e7          	jalr	1680(ra) # 8000097c <kalloc>
    800012f4:	00027797          	auipc	a5,0x27
    800012f8:	d2a7be23          	sd	a0,-708(a5) # 80028030 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800012fc:	6605                	lui	a2,0x1
    800012fe:	4581                	li	a1,0
    80001300:	00000097          	auipc	ra,0x0
    80001304:	a7e080e7          	jalr	-1410(ra) # 80000d7e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001308:	4699                	li	a3,6
    8000130a:	6605                	lui	a2,0x1
    8000130c:	100005b7          	lui	a1,0x10000
    80001310:	10000537          	lui	a0,0x10000
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f96080e7          	jalr	-106(ra) # 800012aa <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    8000131c:	4699                	li	a3,6
    8000131e:	6605                	lui	a2,0x1
    80001320:	100015b7          	lui	a1,0x10001
    80001324:	10001537          	lui	a0,0x10001
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	f82080e7          	jalr	-126(ra) # 800012aa <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    80001330:	4699                	li	a3,6
    80001332:	6605                	lui	a2,0x1
    80001334:	100025b7          	lui	a1,0x10002
    80001338:	10002537          	lui	a0,0x10002
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f6e080e7          	jalr	-146(ra) # 800012aa <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001344:	4699                	li	a3,6
    80001346:	6641                	lui	a2,0x10
    80001348:	020005b7          	lui	a1,0x2000
    8000134c:	02000537          	lui	a0,0x2000
    80001350:	00000097          	auipc	ra,0x0
    80001354:	f5a080e7          	jalr	-166(ra) # 800012aa <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001358:	4699                	li	a3,6
    8000135a:	00400637          	lui	a2,0x400
    8000135e:	0c0005b7          	lui	a1,0xc000
    80001362:	0c000537          	lui	a0,0xc000
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	f44080e7          	jalr	-188(ra) # 800012aa <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000136e:	00008497          	auipc	s1,0x8
    80001372:	c9248493          	addi	s1,s1,-878 # 80009000 <initcode>
    80001376:	46a9                	li	a3,10
    80001378:	80008617          	auipc	a2,0x80008
    8000137c:	c8860613          	addi	a2,a2,-888 # 9000 <_entry-0x7fff7000>
    80001380:	4585                	li	a1,1
    80001382:	05fe                	slli	a1,a1,0x1f
    80001384:	852e                	mv	a0,a1
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	f24080e7          	jalr	-220(ra) # 800012aa <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000138e:	4699                	li	a3,6
    80001390:	4645                	li	a2,17
    80001392:	066e                	slli	a2,a2,0x1b
    80001394:	8e05                	sub	a2,a2,s1
    80001396:	85a6                	mv	a1,s1
    80001398:	8526                	mv	a0,s1
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	f10080e7          	jalr	-240(ra) # 800012aa <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013a2:	46a9                	li	a3,10
    800013a4:	6605                	lui	a2,0x1
    800013a6:	00007597          	auipc	a1,0x7
    800013aa:	c5a58593          	addi	a1,a1,-934 # 80008000 <trampoline>
    800013ae:	04000537          	lui	a0,0x4000
    800013b2:	157d                	addi	a0,a0,-1
    800013b4:	0532                	slli	a0,a0,0xc
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	ef4080e7          	jalr	-268(ra) # 800012aa <kvmmap>
}
    800013be:	60e2                	ld	ra,24(sp)
    800013c0:	6442                	ld	s0,16(sp)
    800013c2:	64a2                	ld	s1,8(sp)
    800013c4:	6105                	addi	sp,sp,32
    800013c6:	8082                	ret

00000000800013c8 <uvmunmap>:
{
    800013c8:	715d                	addi	sp,sp,-80
    800013ca:	e486                	sd	ra,72(sp)
    800013cc:	e0a2                	sd	s0,64(sp)
    800013ce:	fc26                	sd	s1,56(sp)
    800013d0:	f84a                	sd	s2,48(sp)
    800013d2:	f44e                	sd	s3,40(sp)
    800013d4:	f052                	sd	s4,32(sp)
    800013d6:	ec56                	sd	s5,24(sp)
    800013d8:	e85a                	sd	s6,16(sp)
    800013da:	e45e                	sd	s7,8(sp)
    800013dc:	0880                	addi	s0,sp,80
    800013de:	8a2a                	mv	s4,a0
    800013e0:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800013e2:	77fd                	lui	a5,0xfffff
    800013e4:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800013e8:	167d                	addi	a2,a2,-1
    800013ea:	00b609b3          	add	s3,a2,a1
    800013ee:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800013f2:	4b05                	li	s6,1
    a += PGSIZE;
    800013f4:	6b85                	lui	s7,0x1
    800013f6:	a8b1                	j	80001452 <uvmunmap+0x8a>
      panic("uvmunmap: walk");
    800013f8:	00007517          	auipc	a0,0x7
    800013fc:	f4850513          	addi	a0,a0,-184 # 80008340 <userret+0x2b0>
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	15a080e7          	jalr	346(ra) # 8000055a <panic>
      printf("va=%p pte=%p\n", a, *pte);
    80001408:	862a                	mv	a2,a0
    8000140a:	85ca                	mv	a1,s2
    8000140c:	00007517          	auipc	a0,0x7
    80001410:	f4450513          	addi	a0,a0,-188 # 80008350 <userret+0x2c0>
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	1a0080e7          	jalr	416(ra) # 800005b4 <printf>
      panic("uvmunmap: not mapped");
    8000141c:	00007517          	auipc	a0,0x7
    80001420:	f4450513          	addi	a0,a0,-188 # 80008360 <userret+0x2d0>
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	136080e7          	jalr	310(ra) # 8000055a <panic>
      panic("uvmunmap: not a leaf");
    8000142c:	00007517          	auipc	a0,0x7
    80001430:	f4c50513          	addi	a0,a0,-180 # 80008378 <userret+0x2e8>
    80001434:	fffff097          	auipc	ra,0xfffff
    80001438:	126080e7          	jalr	294(ra) # 8000055a <panic>
      pa = PTE2PA(*pte);
    8000143c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000143e:	0532                	slli	a0,a0,0xc
    80001440:	fffff097          	auipc	ra,0xfffff
    80001444:	440080e7          	jalr	1088(ra) # 80000880 <kfree>
    *pte = 0;
    80001448:	0004b023          	sd	zero,0(s1)
    if(a == last)
    8000144c:	03390763          	beq	s2,s3,8000147a <uvmunmap+0xb2>
    a += PGSIZE;
    80001450:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001452:	4601                	li	a2,0
    80001454:	85ca                	mv	a1,s2
    80001456:	8552                	mv	a0,s4
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	bf0080e7          	jalr	-1040(ra) # 80001048 <walk>
    80001460:	84aa                	mv	s1,a0
    80001462:	d959                	beqz	a0,800013f8 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    80001464:	6108                	ld	a0,0(a0)
    80001466:	00157793          	andi	a5,a0,1
    8000146a:	dfd9                	beqz	a5,80001408 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000146c:	3ff57793          	andi	a5,a0,1023
    80001470:	fb678ee3          	beq	a5,s6,8000142c <uvmunmap+0x64>
    if(do_free){
    80001474:	fc0a8ae3          	beqz	s5,80001448 <uvmunmap+0x80>
    80001478:	b7d1                	j	8000143c <uvmunmap+0x74>
}
    8000147a:	60a6                	ld	ra,72(sp)
    8000147c:	6406                	ld	s0,64(sp)
    8000147e:	74e2                	ld	s1,56(sp)
    80001480:	7942                	ld	s2,48(sp)
    80001482:	79a2                	ld	s3,40(sp)
    80001484:	7a02                	ld	s4,32(sp)
    80001486:	6ae2                	ld	s5,24(sp)
    80001488:	6b42                	ld	s6,16(sp)
    8000148a:	6ba2                	ld	s7,8(sp)
    8000148c:	6161                	addi	sp,sp,80
    8000148e:	8082                	ret

0000000080001490 <uvmcreate>:
{
    80001490:	1101                	addi	sp,sp,-32
    80001492:	ec06                	sd	ra,24(sp)
    80001494:	e822                	sd	s0,16(sp)
    80001496:	e426                	sd	s1,8(sp)
    80001498:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    8000149a:	fffff097          	auipc	ra,0xfffff
    8000149e:	4e2080e7          	jalr	1250(ra) # 8000097c <kalloc>
  if(pagetable == 0)
    800014a2:	cd11                	beqz	a0,800014be <uvmcreate+0x2e>
    800014a4:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    800014a6:	6605                	lui	a2,0x1
    800014a8:	4581                	li	a1,0
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	8d4080e7          	jalr	-1836(ra) # 80000d7e <memset>
}
    800014b2:	8526                	mv	a0,s1
    800014b4:	60e2                	ld	ra,24(sp)
    800014b6:	6442                	ld	s0,16(sp)
    800014b8:	64a2                	ld	s1,8(sp)
    800014ba:	6105                	addi	sp,sp,32
    800014bc:	8082                	ret
    panic("uvmcreate: out of memory");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	ed250513          	addi	a0,a0,-302 # 80008390 <userret+0x300>
    800014c6:	fffff097          	auipc	ra,0xfffff
    800014ca:	094080e7          	jalr	148(ra) # 8000055a <panic>

00000000800014ce <uvminit>:
{
    800014ce:	7179                	addi	sp,sp,-48
    800014d0:	f406                	sd	ra,40(sp)
    800014d2:	f022                	sd	s0,32(sp)
    800014d4:	ec26                	sd	s1,24(sp)
    800014d6:	e84a                	sd	s2,16(sp)
    800014d8:	e44e                	sd	s3,8(sp)
    800014da:	e052                	sd	s4,0(sp)
    800014dc:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800014de:	6785                	lui	a5,0x1
    800014e0:	04f67863          	bgeu	a2,a5,80001530 <uvminit+0x62>
    800014e4:	8a2a                	mv	s4,a0
    800014e6:	89ae                	mv	s3,a1
    800014e8:	84b2                	mv	s1,a2
  mem = kalloc();
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	492080e7          	jalr	1170(ra) # 8000097c <kalloc>
    800014f2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014f4:	6605                	lui	a2,0x1
    800014f6:	4581                	li	a1,0
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	886080e7          	jalr	-1914(ra) # 80000d7e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001500:	4779                	li	a4,30
    80001502:	86ca                	mv	a3,s2
    80001504:	6605                	lui	a2,0x1
    80001506:	4581                	li	a1,0
    80001508:	8552                	mv	a0,s4
    8000150a:	00000097          	auipc	ra,0x0
    8000150e:	d12080e7          	jalr	-750(ra) # 8000121c <mappages>
  memmove(mem, src, sz);
    80001512:	8626                	mv	a2,s1
    80001514:	85ce                	mv	a1,s3
    80001516:	854a                	mv	a0,s2
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	8c6080e7          	jalr	-1850(ra) # 80000dde <memmove>
}
    80001520:	70a2                	ld	ra,40(sp)
    80001522:	7402                	ld	s0,32(sp)
    80001524:	64e2                	ld	s1,24(sp)
    80001526:	6942                	ld	s2,16(sp)
    80001528:	69a2                	ld	s3,8(sp)
    8000152a:	6a02                	ld	s4,0(sp)
    8000152c:	6145                	addi	sp,sp,48
    8000152e:	8082                	ret
    panic("inituvm: more than a page");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	e8050513          	addi	a0,a0,-384 # 800083b0 <userret+0x320>
    80001538:	fffff097          	auipc	ra,0xfffff
    8000153c:	022080e7          	jalr	34(ra) # 8000055a <panic>

0000000080001540 <uvmdealloc>:
{
    80001540:	1101                	addi	sp,sp,-32
    80001542:	ec06                	sd	ra,24(sp)
    80001544:	e822                	sd	s0,16(sp)
    80001546:	e426                	sd	s1,8(sp)
    80001548:	1000                	addi	s0,sp,32
    return oldsz;
    8000154a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000154c:	00b67d63          	bgeu	a2,a1,80001566 <uvmdealloc+0x26>
    80001550:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    80001552:	6785                	lui	a5,0x1
    80001554:	17fd                	addi	a5,a5,-1
    80001556:	00f60733          	add	a4,a2,a5
    8000155a:	76fd                	lui	a3,0xfffff
    8000155c:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    8000155e:	97ae                	add	a5,a5,a1
    80001560:	8ff5                	and	a5,a5,a3
    80001562:	00f76863          	bltu	a4,a5,80001572 <uvmdealloc+0x32>
}
    80001566:	8526                	mv	a0,s1
    80001568:	60e2                	ld	ra,24(sp)
    8000156a:	6442                	ld	s0,16(sp)
    8000156c:	64a2                	ld	s1,8(sp)
    8000156e:	6105                	addi	sp,sp,32
    80001570:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    80001572:	4685                	li	a3,1
    80001574:	40e58633          	sub	a2,a1,a4
    80001578:	85ba                	mv	a1,a4
    8000157a:	00000097          	auipc	ra,0x0
    8000157e:	e4e080e7          	jalr	-434(ra) # 800013c8 <uvmunmap>
    80001582:	b7d5                	j	80001566 <uvmdealloc+0x26>

0000000080001584 <uvmalloc>:
  if(newsz < oldsz)
    80001584:	0ab66163          	bltu	a2,a1,80001626 <uvmalloc+0xa2>
{
    80001588:	7139                	addi	sp,sp,-64
    8000158a:	fc06                	sd	ra,56(sp)
    8000158c:	f822                	sd	s0,48(sp)
    8000158e:	f426                	sd	s1,40(sp)
    80001590:	f04a                	sd	s2,32(sp)
    80001592:	ec4e                	sd	s3,24(sp)
    80001594:	e852                	sd	s4,16(sp)
    80001596:	e456                	sd	s5,8(sp)
    80001598:	0080                	addi	s0,sp,64
    8000159a:	8aaa                	mv	s5,a0
    8000159c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000159e:	6985                	lui	s3,0x1
    800015a0:	19fd                	addi	s3,s3,-1
    800015a2:	95ce                	add	a1,a1,s3
    800015a4:	79fd                	lui	s3,0xfffff
    800015a6:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    800015aa:	08c9f063          	bgeu	s3,a2,8000162a <uvmalloc+0xa6>
  a = oldsz;
    800015ae:	894e                	mv	s2,s3
    mem = kalloc();
    800015b0:	fffff097          	auipc	ra,0xfffff
    800015b4:	3cc080e7          	jalr	972(ra) # 8000097c <kalloc>
    800015b8:	84aa                	mv	s1,a0
    if(mem == 0){
    800015ba:	c51d                	beqz	a0,800015e8 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800015bc:	6605                	lui	a2,0x1
    800015be:	4581                	li	a1,0
    800015c0:	fffff097          	auipc	ra,0xfffff
    800015c4:	7be080e7          	jalr	1982(ra) # 80000d7e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800015c8:	4779                	li	a4,30
    800015ca:	86a6                	mv	a3,s1
    800015cc:	6605                	lui	a2,0x1
    800015ce:	85ca                	mv	a1,s2
    800015d0:	8556                	mv	a0,s5
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	c4a080e7          	jalr	-950(ra) # 8000121c <mappages>
    800015da:	e905                	bnez	a0,8000160a <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800015dc:	6785                	lui	a5,0x1
    800015de:	993e                	add	s2,s2,a5
    800015e0:	fd4968e3          	bltu	s2,s4,800015b0 <uvmalloc+0x2c>
  return newsz;
    800015e4:	8552                	mv	a0,s4
    800015e6:	a809                	j	800015f8 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800015e8:	864e                	mv	a2,s3
    800015ea:	85ca                	mv	a1,s2
    800015ec:	8556                	mv	a0,s5
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	f52080e7          	jalr	-174(ra) # 80001540 <uvmdealloc>
      return 0;
    800015f6:	4501                	li	a0,0
}
    800015f8:	70e2                	ld	ra,56(sp)
    800015fa:	7442                	ld	s0,48(sp)
    800015fc:	74a2                	ld	s1,40(sp)
    800015fe:	7902                	ld	s2,32(sp)
    80001600:	69e2                	ld	s3,24(sp)
    80001602:	6a42                	ld	s4,16(sp)
    80001604:	6aa2                	ld	s5,8(sp)
    80001606:	6121                	addi	sp,sp,64
    80001608:	8082                	ret
      kfree(mem);
    8000160a:	8526                	mv	a0,s1
    8000160c:	fffff097          	auipc	ra,0xfffff
    80001610:	274080e7          	jalr	628(ra) # 80000880 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001614:	864e                	mv	a2,s3
    80001616:	85ca                	mv	a1,s2
    80001618:	8556                	mv	a0,s5
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	f26080e7          	jalr	-218(ra) # 80001540 <uvmdealloc>
      return 0;
    80001622:	4501                	li	a0,0
    80001624:	bfd1                	j	800015f8 <uvmalloc+0x74>
    return oldsz;
    80001626:	852e                	mv	a0,a1
}
    80001628:	8082                	ret
  return newsz;
    8000162a:	8532                	mv	a0,a2
    8000162c:	b7f1                	j	800015f8 <uvmalloc+0x74>

000000008000162e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000162e:	1101                	addi	sp,sp,-32
    80001630:	ec06                	sd	ra,24(sp)
    80001632:	e822                	sd	s0,16(sp)
    80001634:	e426                	sd	s1,8(sp)
    80001636:	1000                	addi	s0,sp,32
    80001638:	84aa                	mv	s1,a0
    8000163a:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    8000163c:	4685                	li	a3,1
    8000163e:	4581                	li	a1,0
    80001640:	00000097          	auipc	ra,0x0
    80001644:	d88080e7          	jalr	-632(ra) # 800013c8 <uvmunmap>
  freewalk(pagetable);
    80001648:	8526                	mv	a0,s1
    8000164a:	00000097          	auipc	ra,0x0
    8000164e:	aa4080e7          	jalr	-1372(ra) # 800010ee <freewalk>
}
    80001652:	60e2                	ld	ra,24(sp)
    80001654:	6442                	ld	s0,16(sp)
    80001656:	64a2                	ld	s1,8(sp)
    80001658:	6105                	addi	sp,sp,32
    8000165a:	8082                	ret

000000008000165c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000165c:	c671                	beqz	a2,80001728 <uvmcopy+0xcc>
{
    8000165e:	715d                	addi	sp,sp,-80
    80001660:	e486                	sd	ra,72(sp)
    80001662:	e0a2                	sd	s0,64(sp)
    80001664:	fc26                	sd	s1,56(sp)
    80001666:	f84a                	sd	s2,48(sp)
    80001668:	f44e                	sd	s3,40(sp)
    8000166a:	f052                	sd	s4,32(sp)
    8000166c:	ec56                	sd	s5,24(sp)
    8000166e:	e85a                	sd	s6,16(sp)
    80001670:	e45e                	sd	s7,8(sp)
    80001672:	0880                	addi	s0,sp,80
    80001674:	8b2a                	mv	s6,a0
    80001676:	8aae                	mv	s5,a1
    80001678:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000167a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000167c:	4601                	li	a2,0
    8000167e:	85ce                	mv	a1,s3
    80001680:	855a                	mv	a0,s6
    80001682:	00000097          	auipc	ra,0x0
    80001686:	9c6080e7          	jalr	-1594(ra) # 80001048 <walk>
    8000168a:	c531                	beqz	a0,800016d6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000168c:	6118                	ld	a4,0(a0)
    8000168e:	00177793          	andi	a5,a4,1
    80001692:	cbb1                	beqz	a5,800016e6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001694:	00a75593          	srli	a1,a4,0xa
    80001698:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000169c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	2dc080e7          	jalr	732(ra) # 8000097c <kalloc>
    800016a8:	892a                	mv	s2,a0
    800016aa:	c939                	beqz	a0,80001700 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800016ac:	6605                	lui	a2,0x1
    800016ae:	85de                	mv	a1,s7
    800016b0:	fffff097          	auipc	ra,0xfffff
    800016b4:	72e080e7          	jalr	1838(ra) # 80000dde <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800016b8:	8726                	mv	a4,s1
    800016ba:	86ca                	mv	a3,s2
    800016bc:	6605                	lui	a2,0x1
    800016be:	85ce                	mv	a1,s3
    800016c0:	8556                	mv	a0,s5
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	b5a080e7          	jalr	-1190(ra) # 8000121c <mappages>
    800016ca:	e515                	bnez	a0,800016f6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800016cc:	6785                	lui	a5,0x1
    800016ce:	99be                	add	s3,s3,a5
    800016d0:	fb49e6e3          	bltu	s3,s4,8000167c <uvmcopy+0x20>
    800016d4:	a83d                	j	80001712 <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    800016d6:	00007517          	auipc	a0,0x7
    800016da:	cfa50513          	addi	a0,a0,-774 # 800083d0 <userret+0x340>
    800016de:	fffff097          	auipc	ra,0xfffff
    800016e2:	e7c080e7          	jalr	-388(ra) # 8000055a <panic>
      panic("uvmcopy: page not present");
    800016e6:	00007517          	auipc	a0,0x7
    800016ea:	d0a50513          	addi	a0,a0,-758 # 800083f0 <userret+0x360>
    800016ee:	fffff097          	auipc	ra,0xfffff
    800016f2:	e6c080e7          	jalr	-404(ra) # 8000055a <panic>
      kfree(mem);
    800016f6:	854a                	mv	a0,s2
    800016f8:	fffff097          	auipc	ra,0xfffff
    800016fc:	188080e7          	jalr	392(ra) # 80000880 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    80001700:	4685                	li	a3,1
    80001702:	864e                	mv	a2,s3
    80001704:	4581                	li	a1,0
    80001706:	8556                	mv	a0,s5
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	cc0080e7          	jalr	-832(ra) # 800013c8 <uvmunmap>
  return -1;
    80001710:	557d                	li	a0,-1
}
    80001712:	60a6                	ld	ra,72(sp)
    80001714:	6406                	ld	s0,64(sp)
    80001716:	74e2                	ld	s1,56(sp)
    80001718:	7942                	ld	s2,48(sp)
    8000171a:	79a2                	ld	s3,40(sp)
    8000171c:	7a02                	ld	s4,32(sp)
    8000171e:	6ae2                	ld	s5,24(sp)
    80001720:	6b42                	ld	s6,16(sp)
    80001722:	6ba2                	ld	s7,8(sp)
    80001724:	6161                	addi	sp,sp,80
    80001726:	8082                	ret
  return 0;
    80001728:	4501                	li	a0,0
}
    8000172a:	8082                	ret

000000008000172c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000172c:	1141                	addi	sp,sp,-16
    8000172e:	e406                	sd	ra,8(sp)
    80001730:	e022                	sd	s0,0(sp)
    80001732:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001734:	4601                	li	a2,0
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	912080e7          	jalr	-1774(ra) # 80001048 <walk>
  if(pte == 0)
    8000173e:	c901                	beqz	a0,8000174e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001740:	611c                	ld	a5,0(a0)
    80001742:	9bbd                	andi	a5,a5,-17
    80001744:	e11c                	sd	a5,0(a0)
}
    80001746:	60a2                	ld	ra,8(sp)
    80001748:	6402                	ld	s0,0(sp)
    8000174a:	0141                	addi	sp,sp,16
    8000174c:	8082                	ret
    panic("uvmclear");
    8000174e:	00007517          	auipc	a0,0x7
    80001752:	cc250513          	addi	a0,a0,-830 # 80008410 <userret+0x380>
    80001756:	fffff097          	auipc	ra,0xfffff
    8000175a:	e04080e7          	jalr	-508(ra) # 8000055a <panic>

000000008000175e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000175e:	c6bd                	beqz	a3,800017cc <copyout+0x6e>
{
    80001760:	715d                	addi	sp,sp,-80
    80001762:	e486                	sd	ra,72(sp)
    80001764:	e0a2                	sd	s0,64(sp)
    80001766:	fc26                	sd	s1,56(sp)
    80001768:	f84a                	sd	s2,48(sp)
    8000176a:	f44e                	sd	s3,40(sp)
    8000176c:	f052                	sd	s4,32(sp)
    8000176e:	ec56                	sd	s5,24(sp)
    80001770:	e85a                	sd	s6,16(sp)
    80001772:	e45e                	sd	s7,8(sp)
    80001774:	e062                	sd	s8,0(sp)
    80001776:	0880                	addi	s0,sp,80
    80001778:	8b2a                	mv	s6,a0
    8000177a:	8c2e                	mv	s8,a1
    8000177c:	8a32                	mv	s4,a2
    8000177e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001780:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001782:	6a85                	lui	s5,0x1
    80001784:	a015                	j	800017a8 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001786:	9562                	add	a0,a0,s8
    80001788:	0004861b          	sext.w	a2,s1
    8000178c:	85d2                	mv	a1,s4
    8000178e:	41250533          	sub	a0,a0,s2
    80001792:	fffff097          	auipc	ra,0xfffff
    80001796:	64c080e7          	jalr	1612(ra) # 80000dde <memmove>

    len -= n;
    8000179a:	409989b3          	sub	s3,s3,s1
    src += n;
    8000179e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800017a0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017a4:	02098263          	beqz	s3,800017c8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800017a8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017ac:	85ca                	mv	a1,s2
    800017ae:	855a                	mv	a0,s6
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	9cc080e7          	jalr	-1588(ra) # 8000117c <walkaddr>
    if(pa0 == 0)
    800017b8:	cd01                	beqz	a0,800017d0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800017ba:	418904b3          	sub	s1,s2,s8
    800017be:	94d6                	add	s1,s1,s5
    if(n > len)
    800017c0:	fc99f3e3          	bgeu	s3,s1,80001786 <copyout+0x28>
    800017c4:	84ce                	mv	s1,s3
    800017c6:	b7c1                	j	80001786 <copyout+0x28>
  }
  return 0;
    800017c8:	4501                	li	a0,0
    800017ca:	a021                	j	800017d2 <copyout+0x74>
    800017cc:	4501                	li	a0,0
}
    800017ce:	8082                	ret
      return -1;
    800017d0:	557d                	li	a0,-1
}
    800017d2:	60a6                	ld	ra,72(sp)
    800017d4:	6406                	ld	s0,64(sp)
    800017d6:	74e2                	ld	s1,56(sp)
    800017d8:	7942                	ld	s2,48(sp)
    800017da:	79a2                	ld	s3,40(sp)
    800017dc:	7a02                	ld	s4,32(sp)
    800017de:	6ae2                	ld	s5,24(sp)
    800017e0:	6b42                	ld	s6,16(sp)
    800017e2:	6ba2                	ld	s7,8(sp)
    800017e4:	6c02                	ld	s8,0(sp)
    800017e6:	6161                	addi	sp,sp,80
    800017e8:	8082                	ret

00000000800017ea <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017ea:	c6bd                	beqz	a3,80001858 <copyin+0x6e>
{
    800017ec:	715d                	addi	sp,sp,-80
    800017ee:	e486                	sd	ra,72(sp)
    800017f0:	e0a2                	sd	s0,64(sp)
    800017f2:	fc26                	sd	s1,56(sp)
    800017f4:	f84a                	sd	s2,48(sp)
    800017f6:	f44e                	sd	s3,40(sp)
    800017f8:	f052                	sd	s4,32(sp)
    800017fa:	ec56                	sd	s5,24(sp)
    800017fc:	e85a                	sd	s6,16(sp)
    800017fe:	e45e                	sd	s7,8(sp)
    80001800:	e062                	sd	s8,0(sp)
    80001802:	0880                	addi	s0,sp,80
    80001804:	8b2a                	mv	s6,a0
    80001806:	8a2e                	mv	s4,a1
    80001808:	8c32                	mv	s8,a2
    8000180a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000180c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000180e:	6a85                	lui	s5,0x1
    80001810:	a015                	j	80001834 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001812:	9562                	add	a0,a0,s8
    80001814:	0004861b          	sext.w	a2,s1
    80001818:	412505b3          	sub	a1,a0,s2
    8000181c:	8552                	mv	a0,s4
    8000181e:	fffff097          	auipc	ra,0xfffff
    80001822:	5c0080e7          	jalr	1472(ra) # 80000dde <memmove>

    len -= n;
    80001826:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000182a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000182c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001830:	02098263          	beqz	s3,80001854 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80001834:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001838:	85ca                	mv	a1,s2
    8000183a:	855a                	mv	a0,s6
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	940080e7          	jalr	-1728(ra) # 8000117c <walkaddr>
    if(pa0 == 0)
    80001844:	cd01                	beqz	a0,8000185c <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001846:	418904b3          	sub	s1,s2,s8
    8000184a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000184c:	fc99f3e3          	bgeu	s3,s1,80001812 <copyin+0x28>
    80001850:	84ce                	mv	s1,s3
    80001852:	b7c1                	j	80001812 <copyin+0x28>
  }
  return 0;
    80001854:	4501                	li	a0,0
    80001856:	a021                	j	8000185e <copyin+0x74>
    80001858:	4501                	li	a0,0
}
    8000185a:	8082                	ret
      return -1;
    8000185c:	557d                	li	a0,-1
}
    8000185e:	60a6                	ld	ra,72(sp)
    80001860:	6406                	ld	s0,64(sp)
    80001862:	74e2                	ld	s1,56(sp)
    80001864:	7942                	ld	s2,48(sp)
    80001866:	79a2                	ld	s3,40(sp)
    80001868:	7a02                	ld	s4,32(sp)
    8000186a:	6ae2                	ld	s5,24(sp)
    8000186c:	6b42                	ld	s6,16(sp)
    8000186e:	6ba2                	ld	s7,8(sp)
    80001870:	6c02                	ld	s8,0(sp)
    80001872:	6161                	addi	sp,sp,80
    80001874:	8082                	ret

0000000080001876 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001876:	c6c5                	beqz	a3,8000191e <copyinstr+0xa8>
{
    80001878:	715d                	addi	sp,sp,-80
    8000187a:	e486                	sd	ra,72(sp)
    8000187c:	e0a2                	sd	s0,64(sp)
    8000187e:	fc26                	sd	s1,56(sp)
    80001880:	f84a                	sd	s2,48(sp)
    80001882:	f44e                	sd	s3,40(sp)
    80001884:	f052                	sd	s4,32(sp)
    80001886:	ec56                	sd	s5,24(sp)
    80001888:	e85a                	sd	s6,16(sp)
    8000188a:	e45e                	sd	s7,8(sp)
    8000188c:	0880                	addi	s0,sp,80
    8000188e:	8a2a                	mv	s4,a0
    80001890:	8b2e                	mv	s6,a1
    80001892:	8bb2                	mv	s7,a2
    80001894:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001896:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001898:	6985                	lui	s3,0x1
    8000189a:	a035                	j	800018c6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000189c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800018a0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800018a2:	0017b793          	seqz	a5,a5
    800018a6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800018aa:	60a6                	ld	ra,72(sp)
    800018ac:	6406                	ld	s0,64(sp)
    800018ae:	74e2                	ld	s1,56(sp)
    800018b0:	7942                	ld	s2,48(sp)
    800018b2:	79a2                	ld	s3,40(sp)
    800018b4:	7a02                	ld	s4,32(sp)
    800018b6:	6ae2                	ld	s5,24(sp)
    800018b8:	6b42                	ld	s6,16(sp)
    800018ba:	6ba2                	ld	s7,8(sp)
    800018bc:	6161                	addi	sp,sp,80
    800018be:	8082                	ret
    srcva = va0 + PGSIZE;
    800018c0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800018c4:	c8a9                	beqz	s1,80001916 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800018c6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800018ca:	85ca                	mv	a1,s2
    800018cc:	8552                	mv	a0,s4
    800018ce:	00000097          	auipc	ra,0x0
    800018d2:	8ae080e7          	jalr	-1874(ra) # 8000117c <walkaddr>
    if(pa0 == 0)
    800018d6:	c131                	beqz	a0,8000191a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800018d8:	41790833          	sub	a6,s2,s7
    800018dc:	984e                	add	a6,a6,s3
    if(n > max)
    800018de:	0104f363          	bgeu	s1,a6,800018e4 <copyinstr+0x6e>
    800018e2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800018e4:	955e                	add	a0,a0,s7
    800018e6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800018ea:	fc080be3          	beqz	a6,800018c0 <copyinstr+0x4a>
    800018ee:	985a                	add	a6,a6,s6
    800018f0:	87da                	mv	a5,s6
      if(*p == '\0'){
    800018f2:	41650633          	sub	a2,a0,s6
    800018f6:	14fd                	addi	s1,s1,-1
    800018f8:	9b26                	add	s6,s6,s1
    800018fa:	00f60733          	add	a4,a2,a5
    800018fe:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd6fa4>
    80001902:	df49                	beqz	a4,8000189c <copyinstr+0x26>
        *dst = *p;
    80001904:	00e78023          	sb	a4,0(a5)
      --max;
    80001908:	40fb04b3          	sub	s1,s6,a5
      dst++;
    8000190c:	0785                	addi	a5,a5,1
    while(n > 0){
    8000190e:	ff0796e3          	bne	a5,a6,800018fa <copyinstr+0x84>
      dst++;
    80001912:	8b42                	mv	s6,a6
    80001914:	b775                	j	800018c0 <copyinstr+0x4a>
    80001916:	4781                	li	a5,0
    80001918:	b769                	j	800018a2 <copyinstr+0x2c>
      return -1;
    8000191a:	557d                	li	a0,-1
    8000191c:	b779                	j	800018aa <copyinstr+0x34>
  int got_null = 0;
    8000191e:	4781                	li	a5,0
  if(got_null){
    80001920:	0017b793          	seqz	a5,a5
    80001924:	40f00533          	neg	a0,a5
}
    80001928:	8082                	ret

000000008000192a <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000192a:	1101                	addi	sp,sp,-32
    8000192c:	ec06                	sd	ra,24(sp)
    8000192e:	e822                	sd	s0,16(sp)
    80001930:	e426                	sd	s1,8(sp)
    80001932:	1000                	addi	s0,sp,32
    80001934:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	0fc080e7          	jalr	252(ra) # 80000a32 <holding>
    8000193e:	c909                	beqz	a0,80001950 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001940:	789c                	ld	a5,48(s1)
    80001942:	00978f63          	beq	a5,s1,80001960 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001946:	60e2                	ld	ra,24(sp)
    80001948:	6442                	ld	s0,16(sp)
    8000194a:	64a2                	ld	s1,8(sp)
    8000194c:	6105                	addi	sp,sp,32
    8000194e:	8082                	ret
    panic("wakeup1");
    80001950:	00007517          	auipc	a0,0x7
    80001954:	ad050513          	addi	a0,a0,-1328 # 80008420 <userret+0x390>
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	c02080e7          	jalr	-1022(ra) # 8000055a <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001960:	5098                	lw	a4,32(s1)
    80001962:	4785                	li	a5,1
    80001964:	fef711e3          	bne	a4,a5,80001946 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001968:	4789                	li	a5,2
    8000196a:	d09c                	sw	a5,32(s1)
}
    8000196c:	bfe9                	j	80001946 <wakeup1+0x1c>

000000008000196e <procinit>:
{
    8000196e:	715d                	addi	sp,sp,-80
    80001970:	e486                	sd	ra,72(sp)
    80001972:	e0a2                	sd	s0,64(sp)
    80001974:	fc26                	sd	s1,56(sp)
    80001976:	f84a                	sd	s2,48(sp)
    80001978:	f44e                	sd	s3,40(sp)
    8000197a:	f052                	sd	s4,32(sp)
    8000197c:	ec56                	sd	s5,24(sp)
    8000197e:	e85a                	sd	s6,16(sp)
    80001980:	e45e                	sd	s7,8(sp)
    80001982:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001984:	00007597          	auipc	a1,0x7
    80001988:	aa458593          	addi	a1,a1,-1372 # 80008428 <userret+0x398>
    8000198c:	00013517          	auipc	a0,0x13
    80001990:	eb450513          	addi	a0,a0,-332 # 80014840 <pid_lock>
    80001994:	fffff097          	auipc	ra,0xfffff
    80001998:	048080e7          	jalr	72(ra) # 800009dc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000199c:	00013917          	auipc	s2,0x13
    800019a0:	2c490913          	addi	s2,s2,708 # 80014c60 <proc>
      initlock(&p->lock, "proc");
    800019a4:	00007a17          	auipc	s4,0x7
    800019a8:	a8ca0a13          	addi	s4,s4,-1396 # 80008430 <userret+0x3a0>
      uint64 va = KSTACK((int) (p - proc));
    800019ac:	8bca                	mv	s7,s2
    800019ae:	00007b17          	auipc	s6,0x7
    800019b2:	572b0b13          	addi	s6,s6,1394 # 80008f20 <syscalls+0xb8>
    800019b6:	040009b7          	lui	s3,0x4000
    800019ba:	19fd                	addi	s3,s3,-1
    800019bc:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019be:	00014a97          	auipc	s5,0x14
    800019c2:	102a8a93          	addi	s5,s5,258 # 80015ac0 <tickslock>
      initlock(&p->lock, "proc");
    800019c6:	85d2                	mv	a1,s4
    800019c8:	854a                	mv	a0,s2
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	012080e7          	jalr	18(ra) # 800009dc <initlock>
      char *pa = kalloc();
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	faa080e7          	jalr	-86(ra) # 8000097c <kalloc>
    800019da:	85aa                	mv	a1,a0
      if(pa == 0)
    800019dc:	c929                	beqz	a0,80001a2e <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019de:	417904b3          	sub	s1,s2,s7
    800019e2:	8491                	srai	s1,s1,0x4
    800019e4:	000b3783          	ld	a5,0(s6)
    800019e8:	02f484b3          	mul	s1,s1,a5
    800019ec:	2485                	addiw	s1,s1,1
    800019ee:	00d4949b          	slliw	s1,s1,0xd
    800019f2:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019f6:	4699                	li	a3,6
    800019f8:	6605                	lui	a2,0x1
    800019fa:	8526                	mv	a0,s1
    800019fc:	00000097          	auipc	ra,0x0
    80001a00:	8ae080e7          	jalr	-1874(ra) # 800012aa <kvmmap>
      p->kstack = va;
    80001a04:	04993423          	sd	s1,72(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a08:	17090913          	addi	s2,s2,368
    80001a0c:	fb591de3          	bne	s2,s5,800019c6 <procinit+0x58>
  kvminithart();
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	748080e7          	jalr	1864(ra) # 80001158 <kvminithart>
}
    80001a18:	60a6                	ld	ra,72(sp)
    80001a1a:	6406                	ld	s0,64(sp)
    80001a1c:	74e2                	ld	s1,56(sp)
    80001a1e:	7942                	ld	s2,48(sp)
    80001a20:	79a2                	ld	s3,40(sp)
    80001a22:	7a02                	ld	s4,32(sp)
    80001a24:	6ae2                	ld	s5,24(sp)
    80001a26:	6b42                	ld	s6,16(sp)
    80001a28:	6ba2                	ld	s7,8(sp)
    80001a2a:	6161                	addi	sp,sp,80
    80001a2c:	8082                	ret
        panic("kalloc");
    80001a2e:	00007517          	auipc	a0,0x7
    80001a32:	a0a50513          	addi	a0,a0,-1526 # 80008438 <userret+0x3a8>
    80001a36:	fffff097          	auipc	ra,0xfffff
    80001a3a:	b24080e7          	jalr	-1244(ra) # 8000055a <panic>

0000000080001a3e <cpuid>:
{
    80001a3e:	1141                	addi	sp,sp,-16
    80001a40:	e422                	sd	s0,8(sp)
    80001a42:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a44:	8512                	mv	a0,tp
}
    80001a46:	2501                	sext.w	a0,a0
    80001a48:	6422                	ld	s0,8(sp)
    80001a4a:	0141                	addi	sp,sp,16
    80001a4c:	8082                	ret

0000000080001a4e <mycpu>:
mycpu(void) {
    80001a4e:	1141                	addi	sp,sp,-16
    80001a50:	e422                	sd	s0,8(sp)
    80001a52:	0800                	addi	s0,sp,16
    80001a54:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a56:	2781                	sext.w	a5,a5
    80001a58:	079e                	slli	a5,a5,0x7
}
    80001a5a:	00013517          	auipc	a0,0x13
    80001a5e:	e0650513          	addi	a0,a0,-506 # 80014860 <cpus>
    80001a62:	953e                	add	a0,a0,a5
    80001a64:	6422                	ld	s0,8(sp)
    80001a66:	0141                	addi	sp,sp,16
    80001a68:	8082                	ret

0000000080001a6a <myproc>:
myproc(void) {
    80001a6a:	1101                	addi	sp,sp,-32
    80001a6c:	ec06                	sd	ra,24(sp)
    80001a6e:	e822                	sd	s0,16(sp)
    80001a70:	e426                	sd	s1,8(sp)
    80001a72:	1000                	addi	s0,sp,32
  push_off();
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	fec080e7          	jalr	-20(ra) # 80000a60 <push_off>
    80001a7c:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a7e:	2781                	sext.w	a5,a5
    80001a80:	079e                	slli	a5,a5,0x7
    80001a82:	00013717          	auipc	a4,0x13
    80001a86:	dbe70713          	addi	a4,a4,-578 # 80014840 <pid_lock>
    80001a8a:	97ba                	add	a5,a5,a4
    80001a8c:	7384                	ld	s1,32(a5)
  pop_off();
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	092080e7          	jalr	146(ra) # 80000b20 <pop_off>
}
    80001a96:	8526                	mv	a0,s1
    80001a98:	60e2                	ld	ra,24(sp)
    80001a9a:	6442                	ld	s0,16(sp)
    80001a9c:	64a2                	ld	s1,8(sp)
    80001a9e:	6105                	addi	sp,sp,32
    80001aa0:	8082                	ret

0000000080001aa2 <forkret>:
{
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e406                	sd	ra,8(sp)
    80001aa6:	e022                	sd	s0,0(sp)
    80001aa8:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001aaa:	00000097          	auipc	ra,0x0
    80001aae:	fc0080e7          	jalr	-64(ra) # 80001a6a <myproc>
    80001ab2:	fffff097          	auipc	ra,0xfffff
    80001ab6:	0ce080e7          	jalr	206(ra) # 80000b80 <release>
  if (first) {
    80001aba:	00007797          	auipc	a5,0x7
    80001abe:	59e7a783          	lw	a5,1438(a5) # 80009058 <first.1745>
    80001ac2:	eb89                	bnez	a5,80001ad4 <forkret+0x32>
  usertrapret();
    80001ac4:	00001097          	auipc	ra,0x1
    80001ac8:	c62080e7          	jalr	-926(ra) # 80002726 <usertrapret>
}
    80001acc:	60a2                	ld	ra,8(sp)
    80001ace:	6402                	ld	s0,0(sp)
    80001ad0:	0141                	addi	sp,sp,16
    80001ad2:	8082                	ret
    first = 0;
    80001ad4:	00007797          	auipc	a5,0x7
    80001ad8:	5807a223          	sw	zero,1412(a5) # 80009058 <first.1745>
    fsinit(minor(ROOTDEV));
    80001adc:	4501                	li	a0,0
    80001ade:	00002097          	auipc	ra,0x2
    80001ae2:	9a2080e7          	jalr	-1630(ra) # 80003480 <fsinit>
    80001ae6:	bff9                	j	80001ac4 <forkret+0x22>

0000000080001ae8 <allocpid>:
allocpid() {
    80001ae8:	1101                	addi	sp,sp,-32
    80001aea:	ec06                	sd	ra,24(sp)
    80001aec:	e822                	sd	s0,16(sp)
    80001aee:	e426                	sd	s1,8(sp)
    80001af0:	e04a                	sd	s2,0(sp)
    80001af2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001af4:	00013917          	auipc	s2,0x13
    80001af8:	d4c90913          	addi	s2,s2,-692 # 80014840 <pid_lock>
    80001afc:	854a                	mv	a0,s2
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	fb2080e7          	jalr	-78(ra) # 80000ab0 <acquire>
  pid = nextpid;
    80001b06:	00007797          	auipc	a5,0x7
    80001b0a:	55678793          	addi	a5,a5,1366 # 8000905c <nextpid>
    80001b0e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b10:	0014871b          	addiw	a4,s1,1
    80001b14:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b16:	854a                	mv	a0,s2
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	068080e7          	jalr	104(ra) # 80000b80 <release>
}
    80001b20:	8526                	mv	a0,s1
    80001b22:	60e2                	ld	ra,24(sp)
    80001b24:	6442                	ld	s0,16(sp)
    80001b26:	64a2                	ld	s1,8(sp)
    80001b28:	6902                	ld	s2,0(sp)
    80001b2a:	6105                	addi	sp,sp,32
    80001b2c:	8082                	ret

0000000080001b2e <proc_pagetable>:
{
    80001b2e:	1101                	addi	sp,sp,-32
    80001b30:	ec06                	sd	ra,24(sp)
    80001b32:	e822                	sd	s0,16(sp)
    80001b34:	e426                	sd	s1,8(sp)
    80001b36:	e04a                	sd	s2,0(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b3c:	00000097          	auipc	ra,0x0
    80001b40:	954080e7          	jalr	-1708(ra) # 80001490 <uvmcreate>
    80001b44:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b46:	4729                	li	a4,10
    80001b48:	00006697          	auipc	a3,0x6
    80001b4c:	4b868693          	addi	a3,a3,1208 # 80008000 <trampoline>
    80001b50:	6605                	lui	a2,0x1
    80001b52:	040005b7          	lui	a1,0x4000
    80001b56:	15fd                	addi	a1,a1,-1
    80001b58:	05b2                	slli	a1,a1,0xc
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	6c2080e7          	jalr	1730(ra) # 8000121c <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b62:	4719                	li	a4,6
    80001b64:	06093683          	ld	a3,96(s2)
    80001b68:	6605                	lui	a2,0x1
    80001b6a:	020005b7          	lui	a1,0x2000
    80001b6e:	15fd                	addi	a1,a1,-1
    80001b70:	05b6                	slli	a1,a1,0xd
    80001b72:	8526                	mv	a0,s1
    80001b74:	fffff097          	auipc	ra,0xfffff
    80001b78:	6a8080e7          	jalr	1704(ra) # 8000121c <mappages>
}
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6902                	ld	s2,0(sp)
    80001b86:	6105                	addi	sp,sp,32
    80001b88:	8082                	ret

0000000080001b8a <allocproc>:
{
    80001b8a:	1101                	addi	sp,sp,-32
    80001b8c:	ec06                	sd	ra,24(sp)
    80001b8e:	e822                	sd	s0,16(sp)
    80001b90:	e426                	sd	s1,8(sp)
    80001b92:	e04a                	sd	s2,0(sp)
    80001b94:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b96:	00013497          	auipc	s1,0x13
    80001b9a:	0ca48493          	addi	s1,s1,202 # 80014c60 <proc>
    80001b9e:	00014917          	auipc	s2,0x14
    80001ba2:	f2290913          	addi	s2,s2,-222 # 80015ac0 <tickslock>
    acquire(&p->lock);
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	f08080e7          	jalr	-248(ra) # 80000ab0 <acquire>
    if(p->state == UNUSED) {
    80001bb0:	509c                	lw	a5,32(s1)
    80001bb2:	c395                	beqz	a5,80001bd6 <allocproc+0x4c>
      release(&p->lock);
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	fca080e7          	jalr	-54(ra) # 80000b80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbe:	17048493          	addi	s1,s1,368
    80001bc2:	ff2492e3          	bne	s1,s2,80001ba6 <allocproc+0x1c>
  return 0;
    80001bc6:	4481                	li	s1,0
}
    80001bc8:	8526                	mv	a0,s1
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6902                	ld	s2,0(sp)
    80001bd2:	6105                	addi	sp,sp,32
    80001bd4:	8082                	ret
  p->pid = allocpid();
    80001bd6:	00000097          	auipc	ra,0x0
    80001bda:	f12080e7          	jalr	-238(ra) # 80001ae8 <allocpid>
    80001bde:	c0a8                	sw	a0,64(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001be0:	fffff097          	auipc	ra,0xfffff
    80001be4:	d9c080e7          	jalr	-612(ra) # 8000097c <kalloc>
    80001be8:	892a                	mv	s2,a0
    80001bea:	f0a8                	sd	a0,96(s1)
    80001bec:	c915                	beqz	a0,80001c20 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	f3e080e7          	jalr	-194(ra) # 80001b2e <proc_pagetable>
    80001bf8:	eca8                	sd	a0,88(s1)
  memset(&p->context, 0, sizeof p->context);
    80001bfa:	07000613          	li	a2,112
    80001bfe:	4581                	li	a1,0
    80001c00:	06848513          	addi	a0,s1,104
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	17a080e7          	jalr	378(ra) # 80000d7e <memset>
  p->context.ra = (uint64)forkret;
    80001c0c:	00000797          	auipc	a5,0x0
    80001c10:	e9678793          	addi	a5,a5,-362 # 80001aa2 <forkret>
    80001c14:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c16:	64bc                	ld	a5,72(s1)
    80001c18:	6705                	lui	a4,0x1
    80001c1a:	97ba                	add	a5,a5,a4
    80001c1c:	f8bc                	sd	a5,112(s1)
  return p;
    80001c1e:	b76d                	j	80001bc8 <allocproc+0x3e>
    release(&p->lock);
    80001c20:	8526                	mv	a0,s1
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	f5e080e7          	jalr	-162(ra) # 80000b80 <release>
    return 0;
    80001c2a:	84ca                	mv	s1,s2
    80001c2c:	bf71                	j	80001bc8 <allocproc+0x3e>

0000000080001c2e <proc_freepagetable>:
{
    80001c2e:	1101                	addi	sp,sp,-32
    80001c30:	ec06                	sd	ra,24(sp)
    80001c32:	e822                	sd	s0,16(sp)
    80001c34:	e426                	sd	s1,8(sp)
    80001c36:	e04a                	sd	s2,0(sp)
    80001c38:	1000                	addi	s0,sp,32
    80001c3a:	84aa                	mv	s1,a0
    80001c3c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001c3e:	4681                	li	a3,0
    80001c40:	6605                	lui	a2,0x1
    80001c42:	040005b7          	lui	a1,0x4000
    80001c46:	15fd                	addi	a1,a1,-1
    80001c48:	05b2                	slli	a1,a1,0xc
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	77e080e7          	jalr	1918(ra) # 800013c8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001c52:	4681                	li	a3,0
    80001c54:	6605                	lui	a2,0x1
    80001c56:	020005b7          	lui	a1,0x2000
    80001c5a:	15fd                	addi	a1,a1,-1
    80001c5c:	05b6                	slli	a1,a1,0xd
    80001c5e:	8526                	mv	a0,s1
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	768080e7          	jalr	1896(ra) # 800013c8 <uvmunmap>
  if(sz > 0)
    80001c68:	00091863          	bnez	s2,80001c78 <proc_freepagetable+0x4a>
}
    80001c6c:	60e2                	ld	ra,24(sp)
    80001c6e:	6442                	ld	s0,16(sp)
    80001c70:	64a2                	ld	s1,8(sp)
    80001c72:	6902                	ld	s2,0(sp)
    80001c74:	6105                	addi	sp,sp,32
    80001c76:	8082                	ret
    uvmfree(pagetable, sz);
    80001c78:	85ca                	mv	a1,s2
    80001c7a:	8526                	mv	a0,s1
    80001c7c:	00000097          	auipc	ra,0x0
    80001c80:	9b2080e7          	jalr	-1614(ra) # 8000162e <uvmfree>
}
    80001c84:	b7e5                	j	80001c6c <proc_freepagetable+0x3e>

0000000080001c86 <freeproc>:
{
    80001c86:	1101                	addi	sp,sp,-32
    80001c88:	ec06                	sd	ra,24(sp)
    80001c8a:	e822                	sd	s0,16(sp)
    80001c8c:	e426                	sd	s1,8(sp)
    80001c8e:	1000                	addi	s0,sp,32
    80001c90:	84aa                	mv	s1,a0
  if(p->tf)
    80001c92:	7128                	ld	a0,96(a0)
    80001c94:	c509                	beqz	a0,80001c9e <freeproc+0x18>
    kfree((void*)p->tf);
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	bea080e7          	jalr	-1046(ra) # 80000880 <kfree>
  p->tf = 0;
    80001c9e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001ca2:	6ca8                	ld	a0,88(s1)
    80001ca4:	c511                	beqz	a0,80001cb0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001ca6:	68ac                	ld	a1,80(s1)
    80001ca8:	00000097          	auipc	ra,0x0
    80001cac:	f86080e7          	jalr	-122(ra) # 80001c2e <proc_freepagetable>
  p->pagetable = 0;
    80001cb0:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001cb4:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001cb8:	0404a023          	sw	zero,64(s1)
  p->parent = 0;
    80001cbc:	0204b423          	sd	zero,40(s1)
  p->name[0] = 0;
    80001cc0:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001cc4:	0204b823          	sd	zero,48(s1)
  p->killed = 0;
    80001cc8:	0204ac23          	sw	zero,56(s1)
  p->xstate = 0;
    80001ccc:	0204ae23          	sw	zero,60(s1)
  p->state = UNUSED;
    80001cd0:	0204a023          	sw	zero,32(s1)
}
    80001cd4:	60e2                	ld	ra,24(sp)
    80001cd6:	6442                	ld	s0,16(sp)
    80001cd8:	64a2                	ld	s1,8(sp)
    80001cda:	6105                	addi	sp,sp,32
    80001cdc:	8082                	ret

0000000080001cde <userinit>:
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	ea2080e7          	jalr	-350(ra) # 80001b8a <allocproc>
    80001cf0:	84aa                	mv	s1,a0
  initproc = p;
    80001cf2:	00026797          	auipc	a5,0x26
    80001cf6:	34a7b323          	sd	a0,838(a5) # 80028038 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cfa:	03300613          	li	a2,51
    80001cfe:	00007597          	auipc	a1,0x7
    80001d02:	30258593          	addi	a1,a1,770 # 80009000 <initcode>
    80001d06:	6d28                	ld	a0,88(a0)
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	7c6080e7          	jalr	1990(ra) # 800014ce <uvminit>
  p->sz = PGSIZE;
    80001d10:	6785                	lui	a5,0x1
    80001d12:	e8bc                	sd	a5,80(s1)
  p->tf->epc = 0;      // user program counter
    80001d14:	70b8                	ld	a4,96(s1)
    80001d16:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001d1a:	70b8                	ld	a4,96(s1)
    80001d1c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d1e:	4641                	li	a2,16
    80001d20:	00006597          	auipc	a1,0x6
    80001d24:	72058593          	addi	a1,a1,1824 # 80008440 <userret+0x3b0>
    80001d28:	16048513          	addi	a0,s1,352
    80001d2c:	fffff097          	auipc	ra,0xfffff
    80001d30:	1a8080e7          	jalr	424(ra) # 80000ed4 <safestrcpy>
  p->cwd = namei("/");
    80001d34:	00006517          	auipc	a0,0x6
    80001d38:	71c50513          	addi	a0,a0,1820 # 80008450 <userret+0x3c0>
    80001d3c:	00002097          	auipc	ra,0x2
    80001d40:	146080e7          	jalr	326(ra) # 80003e82 <namei>
    80001d44:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001d48:	4789                	li	a5,2
    80001d4a:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	e32080e7          	jalr	-462(ra) # 80000b80 <release>
}
    80001d56:	60e2                	ld	ra,24(sp)
    80001d58:	6442                	ld	s0,16(sp)
    80001d5a:	64a2                	ld	s1,8(sp)
    80001d5c:	6105                	addi	sp,sp,32
    80001d5e:	8082                	ret

0000000080001d60 <growproc>:
{
    80001d60:	1101                	addi	sp,sp,-32
    80001d62:	ec06                	sd	ra,24(sp)
    80001d64:	e822                	sd	s0,16(sp)
    80001d66:	e426                	sd	s1,8(sp)
    80001d68:	e04a                	sd	s2,0(sp)
    80001d6a:	1000                	addi	s0,sp,32
    80001d6c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	cfc080e7          	jalr	-772(ra) # 80001a6a <myproc>
    80001d76:	892a                	mv	s2,a0
  sz = p->sz;
    80001d78:	692c                	ld	a1,80(a0)
    80001d7a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d7e:	00904f63          	bgtz	s1,80001d9c <growproc+0x3c>
  } else if(n < 0){
    80001d82:	0204cc63          	bltz	s1,80001dba <growproc+0x5a>
  p->sz = sz;
    80001d86:	1602                	slli	a2,a2,0x20
    80001d88:	9201                	srli	a2,a2,0x20
    80001d8a:	04c93823          	sd	a2,80(s2)
  return 0;
    80001d8e:	4501                	li	a0,0
}
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	64a2                	ld	s1,8(sp)
    80001d96:	6902                	ld	s2,0(sp)
    80001d98:	6105                	addi	sp,sp,32
    80001d9a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d9c:	9e25                	addw	a2,a2,s1
    80001d9e:	1602                	slli	a2,a2,0x20
    80001da0:	9201                	srli	a2,a2,0x20
    80001da2:	1582                	slli	a1,a1,0x20
    80001da4:	9181                	srli	a1,a1,0x20
    80001da6:	6d28                	ld	a0,88(a0)
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	7dc080e7          	jalr	2012(ra) # 80001584 <uvmalloc>
    80001db0:	0005061b          	sext.w	a2,a0
    80001db4:	fa69                	bnez	a2,80001d86 <growproc+0x26>
      return -1;
    80001db6:	557d                	li	a0,-1
    80001db8:	bfe1                	j	80001d90 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dba:	9e25                	addw	a2,a2,s1
    80001dbc:	1602                	slli	a2,a2,0x20
    80001dbe:	9201                	srli	a2,a2,0x20
    80001dc0:	1582                	slli	a1,a1,0x20
    80001dc2:	9181                	srli	a1,a1,0x20
    80001dc4:	6d28                	ld	a0,88(a0)
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	77a080e7          	jalr	1914(ra) # 80001540 <uvmdealloc>
    80001dce:	0005061b          	sext.w	a2,a0
    80001dd2:	bf55                	j	80001d86 <growproc+0x26>

0000000080001dd4 <fork>:
{
    80001dd4:	7179                	addi	sp,sp,-48
    80001dd6:	f406                	sd	ra,40(sp)
    80001dd8:	f022                	sd	s0,32(sp)
    80001dda:	ec26                	sd	s1,24(sp)
    80001ddc:	e84a                	sd	s2,16(sp)
    80001dde:	e44e                	sd	s3,8(sp)
    80001de0:	e052                	sd	s4,0(sp)
    80001de2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001de4:	00000097          	auipc	ra,0x0
    80001de8:	c86080e7          	jalr	-890(ra) # 80001a6a <myproc>
    80001dec:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	d9c080e7          	jalr	-612(ra) # 80001b8a <allocproc>
    80001df6:	c175                	beqz	a0,80001eda <fork+0x106>
    80001df8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dfa:	05093603          	ld	a2,80(s2)
    80001dfe:	6d2c                	ld	a1,88(a0)
    80001e00:	05893503          	ld	a0,88(s2)
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	858080e7          	jalr	-1960(ra) # 8000165c <uvmcopy>
    80001e0c:	04054863          	bltz	a0,80001e5c <fork+0x88>
  np->sz = p->sz;
    80001e10:	05093783          	ld	a5,80(s2)
    80001e14:	04f9b823          	sd	a5,80(s3) # 4000050 <_entry-0x7bffffb0>
  np->parent = p;
    80001e18:	0329b423          	sd	s2,40(s3)
  *(np->tf) = *(p->tf);
    80001e1c:	06093683          	ld	a3,96(s2)
    80001e20:	87b6                	mv	a5,a3
    80001e22:	0609b703          	ld	a4,96(s3)
    80001e26:	12068693          	addi	a3,a3,288
    80001e2a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e2e:	6788                	ld	a0,8(a5)
    80001e30:	6b8c                	ld	a1,16(a5)
    80001e32:	6f90                	ld	a2,24(a5)
    80001e34:	01073023          	sd	a6,0(a4)
    80001e38:	e708                	sd	a0,8(a4)
    80001e3a:	eb0c                	sd	a1,16(a4)
    80001e3c:	ef10                	sd	a2,24(a4)
    80001e3e:	02078793          	addi	a5,a5,32
    80001e42:	02070713          	addi	a4,a4,32
    80001e46:	fed792e3          	bne	a5,a3,80001e2a <fork+0x56>
  np->tf->a0 = 0;
    80001e4a:	0609b783          	ld	a5,96(s3)
    80001e4e:	0607b823          	sd	zero,112(a5)
    80001e52:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001e56:	15800a13          	li	s4,344
    80001e5a:	a03d                	j	80001e88 <fork+0xb4>
    freeproc(np);
    80001e5c:	854e                	mv	a0,s3
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	e28080e7          	jalr	-472(ra) # 80001c86 <freeproc>
    release(&np->lock);
    80001e66:	854e                	mv	a0,s3
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	d18080e7          	jalr	-744(ra) # 80000b80 <release>
    return -1;
    80001e70:	54fd                	li	s1,-1
    80001e72:	a899                	j	80001ec8 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e74:	00002097          	auipc	ra,0x2
    80001e78:	7b0080e7          	jalr	1968(ra) # 80004624 <filedup>
    80001e7c:	009987b3          	add	a5,s3,s1
    80001e80:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001e82:	04a1                	addi	s1,s1,8
    80001e84:	01448763          	beq	s1,s4,80001e92 <fork+0xbe>
    if(p->ofile[i])
    80001e88:	009907b3          	add	a5,s2,s1
    80001e8c:	6388                	ld	a0,0(a5)
    80001e8e:	f17d                	bnez	a0,80001e74 <fork+0xa0>
    80001e90:	bfcd                	j	80001e82 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001e92:	15893503          	ld	a0,344(s2)
    80001e96:	00002097          	auipc	ra,0x2
    80001e9a:	824080e7          	jalr	-2012(ra) # 800036ba <idup>
    80001e9e:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea2:	4641                	li	a2,16
    80001ea4:	16090593          	addi	a1,s2,352
    80001ea8:	16098513          	addi	a0,s3,352
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	028080e7          	jalr	40(ra) # 80000ed4 <safestrcpy>
  pid = np->pid;
    80001eb4:	0409a483          	lw	s1,64(s3)
  np->state = RUNNABLE;
    80001eb8:	4789                	li	a5,2
    80001eba:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001ebe:	854e                	mv	a0,s3
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	cc0080e7          	jalr	-832(ra) # 80000b80 <release>
}
    80001ec8:	8526                	mv	a0,s1
    80001eca:	70a2                	ld	ra,40(sp)
    80001ecc:	7402                	ld	s0,32(sp)
    80001ece:	64e2                	ld	s1,24(sp)
    80001ed0:	6942                	ld	s2,16(sp)
    80001ed2:	69a2                	ld	s3,8(sp)
    80001ed4:	6a02                	ld	s4,0(sp)
    80001ed6:	6145                	addi	sp,sp,48
    80001ed8:	8082                	ret
    return -1;
    80001eda:	54fd                	li	s1,-1
    80001edc:	b7f5                	j	80001ec8 <fork+0xf4>

0000000080001ede <reparent>:
{
    80001ede:	7179                	addi	sp,sp,-48
    80001ee0:	f406                	sd	ra,40(sp)
    80001ee2:	f022                	sd	s0,32(sp)
    80001ee4:	ec26                	sd	s1,24(sp)
    80001ee6:	e84a                	sd	s2,16(sp)
    80001ee8:	e44e                	sd	s3,8(sp)
    80001eea:	e052                	sd	s4,0(sp)
    80001eec:	1800                	addi	s0,sp,48
    80001eee:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ef0:	00013497          	auipc	s1,0x13
    80001ef4:	d7048493          	addi	s1,s1,-656 # 80014c60 <proc>
      pp->parent = initproc;
    80001ef8:	00026a17          	auipc	s4,0x26
    80001efc:	140a0a13          	addi	s4,s4,320 # 80028038 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f00:	00014997          	auipc	s3,0x14
    80001f04:	bc098993          	addi	s3,s3,-1088 # 80015ac0 <tickslock>
    80001f08:	a029                	j	80001f12 <reparent+0x34>
    80001f0a:	17048493          	addi	s1,s1,368
    80001f0e:	03348363          	beq	s1,s3,80001f34 <reparent+0x56>
    if(pp->parent == p){
    80001f12:	749c                	ld	a5,40(s1)
    80001f14:	ff279be3          	bne	a5,s2,80001f0a <reparent+0x2c>
      acquire(&pp->lock);
    80001f18:	8526                	mv	a0,s1
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	b96080e7          	jalr	-1130(ra) # 80000ab0 <acquire>
      pp->parent = initproc;
    80001f22:	000a3783          	ld	a5,0(s4)
    80001f26:	f49c                	sd	a5,40(s1)
      release(&pp->lock);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	c56080e7          	jalr	-938(ra) # 80000b80 <release>
    80001f32:	bfe1                	j	80001f0a <reparent+0x2c>
}
    80001f34:	70a2                	ld	ra,40(sp)
    80001f36:	7402                	ld	s0,32(sp)
    80001f38:	64e2                	ld	s1,24(sp)
    80001f3a:	6942                	ld	s2,16(sp)
    80001f3c:	69a2                	ld	s3,8(sp)
    80001f3e:	6a02                	ld	s4,0(sp)
    80001f40:	6145                	addi	sp,sp,48
    80001f42:	8082                	ret

0000000080001f44 <scheduler>:
{
    80001f44:	715d                	addi	sp,sp,-80
    80001f46:	e486                	sd	ra,72(sp)
    80001f48:	e0a2                	sd	s0,64(sp)
    80001f4a:	fc26                	sd	s1,56(sp)
    80001f4c:	f84a                	sd	s2,48(sp)
    80001f4e:	f44e                	sd	s3,40(sp)
    80001f50:	f052                	sd	s4,32(sp)
    80001f52:	ec56                	sd	s5,24(sp)
    80001f54:	e85a                	sd	s6,16(sp)
    80001f56:	e45e                	sd	s7,8(sp)
    80001f58:	e062                	sd	s8,0(sp)
    80001f5a:	0880                	addi	s0,sp,80
    80001f5c:	8792                	mv	a5,tp
  int id = r_tp();
    80001f5e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f60:	00779b13          	slli	s6,a5,0x7
    80001f64:	00013717          	auipc	a4,0x13
    80001f68:	8dc70713          	addi	a4,a4,-1828 # 80014840 <pid_lock>
    80001f6c:	975a                	add	a4,a4,s6
    80001f6e:	02073023          	sd	zero,32(a4)
        swtch(&c->scheduler, &p->context);
    80001f72:	00013717          	auipc	a4,0x13
    80001f76:	8f670713          	addi	a4,a4,-1802 # 80014868 <cpus+0x8>
    80001f7a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f7c:	4b8d                	li	s7,3
        c->proc = p;
    80001f7e:	079e                	slli	a5,a5,0x7
    80001f80:	00013917          	auipc	s2,0x13
    80001f84:	8c090913          	addi	s2,s2,-1856 # 80014840 <pid_lock>
    80001f88:	993e                	add	s2,s2,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f8a:	00014a17          	auipc	s4,0x14
    80001f8e:	b36a0a13          	addi	s4,s4,-1226 # 80015ac0 <tickslock>
    80001f92:	a0b9                	j	80001fe0 <scheduler+0x9c>
        p->state = RUNNING;
    80001f94:	0374a023          	sw	s7,32(s1)
        c->proc = p;
    80001f98:	02993023          	sd	s1,32(s2)
        swtch(&c->scheduler, &p->context);
    80001f9c:	06848593          	addi	a1,s1,104
    80001fa0:	855a                	mv	a0,s6
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	640080e7          	jalr	1600(ra) # 800025e2 <swtch>
        c->proc = 0;
    80001faa:	02093023          	sd	zero,32(s2)
        found = 1;
    80001fae:	8ae2                	mv	s5,s8
      c->intena = 0;
    80001fb0:	08092e23          	sw	zero,156(s2)
      release(&p->lock);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	bca080e7          	jalr	-1078(ra) # 80000b80 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fbe:	17048493          	addi	s1,s1,368
    80001fc2:	01448b63          	beq	s1,s4,80001fd8 <scheduler+0x94>
      acquire(&p->lock);
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	ae8080e7          	jalr	-1304(ra) # 80000ab0 <acquire>
      if(p->state == RUNNABLE) {
    80001fd0:	509c                	lw	a5,32(s1)
    80001fd2:	fd379fe3          	bne	a5,s3,80001fb0 <scheduler+0x6c>
    80001fd6:	bf7d                	j	80001f94 <scheduler+0x50>
    if(found == 0){
    80001fd8:	000a9463          	bnez	s5,80001fe0 <scheduler+0x9c>
      asm volatile("wfi");
    80001fdc:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fe4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe8:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ff0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ff2:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001ff6:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ff8:	00013497          	auipc	s1,0x13
    80001ffc:	c6848493          	addi	s1,s1,-920 # 80014c60 <proc>
      if(p->state == RUNNABLE) {
    80002000:	4989                	li	s3,2
        found = 1;
    80002002:	4c05                	li	s8,1
    80002004:	b7c9                	j	80001fc6 <scheduler+0x82>

0000000080002006 <sched>:
{
    80002006:	7179                	addi	sp,sp,-48
    80002008:	f406                	sd	ra,40(sp)
    8000200a:	f022                	sd	s0,32(sp)
    8000200c:	ec26                	sd	s1,24(sp)
    8000200e:	e84a                	sd	s2,16(sp)
    80002010:	e44e                	sd	s3,8(sp)
    80002012:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002014:	00000097          	auipc	ra,0x0
    80002018:	a56080e7          	jalr	-1450(ra) # 80001a6a <myproc>
    8000201c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	a14080e7          	jalr	-1516(ra) # 80000a32 <holding>
    80002026:	c93d                	beqz	a0,8000209c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002028:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000202a:	2781                	sext.w	a5,a5
    8000202c:	079e                	slli	a5,a5,0x7
    8000202e:	00013717          	auipc	a4,0x13
    80002032:	81270713          	addi	a4,a4,-2030 # 80014840 <pid_lock>
    80002036:	97ba                	add	a5,a5,a4
    80002038:	0987a703          	lw	a4,152(a5)
    8000203c:	4785                	li	a5,1
    8000203e:	06f71763          	bne	a4,a5,800020ac <sched+0xa6>
  if(p->state == RUNNING)
    80002042:	5098                	lw	a4,32(s1)
    80002044:	478d                	li	a5,3
    80002046:	06f70b63          	beq	a4,a5,800020bc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000204a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000204e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002050:	efb5                	bnez	a5,800020cc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002052:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002054:	00012917          	auipc	s2,0x12
    80002058:	7ec90913          	addi	s2,s2,2028 # 80014840 <pid_lock>
    8000205c:	2781                	sext.w	a5,a5
    8000205e:	079e                	slli	a5,a5,0x7
    80002060:	97ca                	add	a5,a5,s2
    80002062:	09c7a983          	lw	s3,156(a5)
    80002066:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80002068:	2781                	sext.w	a5,a5
    8000206a:	079e                	slli	a5,a5,0x7
    8000206c:	00012597          	auipc	a1,0x12
    80002070:	7fc58593          	addi	a1,a1,2044 # 80014868 <cpus+0x8>
    80002074:	95be                	add	a1,a1,a5
    80002076:	06848513          	addi	a0,s1,104
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	568080e7          	jalr	1384(ra) # 800025e2 <swtch>
    80002082:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002084:	2781                	sext.w	a5,a5
    80002086:	079e                	slli	a5,a5,0x7
    80002088:	97ca                	add	a5,a5,s2
    8000208a:	0937ae23          	sw	s3,156(a5)
}
    8000208e:	70a2                	ld	ra,40(sp)
    80002090:	7402                	ld	s0,32(sp)
    80002092:	64e2                	ld	s1,24(sp)
    80002094:	6942                	ld	s2,16(sp)
    80002096:	69a2                	ld	s3,8(sp)
    80002098:	6145                	addi	sp,sp,48
    8000209a:	8082                	ret
    panic("sched p->lock");
    8000209c:	00006517          	auipc	a0,0x6
    800020a0:	3bc50513          	addi	a0,a0,956 # 80008458 <userret+0x3c8>
    800020a4:	ffffe097          	auipc	ra,0xffffe
    800020a8:	4b6080e7          	jalr	1206(ra) # 8000055a <panic>
    panic("sched locks");
    800020ac:	00006517          	auipc	a0,0x6
    800020b0:	3bc50513          	addi	a0,a0,956 # 80008468 <userret+0x3d8>
    800020b4:	ffffe097          	auipc	ra,0xffffe
    800020b8:	4a6080e7          	jalr	1190(ra) # 8000055a <panic>
    panic("sched running");
    800020bc:	00006517          	auipc	a0,0x6
    800020c0:	3bc50513          	addi	a0,a0,956 # 80008478 <userret+0x3e8>
    800020c4:	ffffe097          	auipc	ra,0xffffe
    800020c8:	496080e7          	jalr	1174(ra) # 8000055a <panic>
    panic("sched interruptible");
    800020cc:	00006517          	auipc	a0,0x6
    800020d0:	3bc50513          	addi	a0,a0,956 # 80008488 <userret+0x3f8>
    800020d4:	ffffe097          	auipc	ra,0xffffe
    800020d8:	486080e7          	jalr	1158(ra) # 8000055a <panic>

00000000800020dc <exit>:
{
    800020dc:	7179                	addi	sp,sp,-48
    800020de:	f406                	sd	ra,40(sp)
    800020e0:	f022                	sd	s0,32(sp)
    800020e2:	ec26                	sd	s1,24(sp)
    800020e4:	e84a                	sd	s2,16(sp)
    800020e6:	e44e                	sd	s3,8(sp)
    800020e8:	e052                	sd	s4,0(sp)
    800020ea:	1800                	addi	s0,sp,48
    800020ec:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020ee:	00000097          	auipc	ra,0x0
    800020f2:	97c080e7          	jalr	-1668(ra) # 80001a6a <myproc>
    800020f6:	89aa                	mv	s3,a0
  if(p == initproc)
    800020f8:	00026797          	auipc	a5,0x26
    800020fc:	f407b783          	ld	a5,-192(a5) # 80028038 <initproc>
    80002100:	0d850493          	addi	s1,a0,216
    80002104:	15850913          	addi	s2,a0,344
    80002108:	02a79363          	bne	a5,a0,8000212e <exit+0x52>
    panic("init exiting");
    8000210c:	00006517          	auipc	a0,0x6
    80002110:	39450513          	addi	a0,a0,916 # 800084a0 <userret+0x410>
    80002114:	ffffe097          	auipc	ra,0xffffe
    80002118:	446080e7          	jalr	1094(ra) # 8000055a <panic>
      fileclose(f);
    8000211c:	00002097          	auipc	ra,0x2
    80002120:	55a080e7          	jalr	1370(ra) # 80004676 <fileclose>
      p->ofile[fd] = 0;
    80002124:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002128:	04a1                	addi	s1,s1,8
    8000212a:	01248563          	beq	s1,s2,80002134 <exit+0x58>
    if(p->ofile[fd]){
    8000212e:	6088                	ld	a0,0(s1)
    80002130:	f575                	bnez	a0,8000211c <exit+0x40>
    80002132:	bfdd                	j	80002128 <exit+0x4c>
  begin_op(ROOTDEV);
    80002134:	4501                	li	a0,0
    80002136:	00002097          	auipc	ra,0x2
    8000213a:	fa6080e7          	jalr	-90(ra) # 800040dc <begin_op>
  iput(p->cwd);
    8000213e:	1589b503          	ld	a0,344(s3)
    80002142:	00001097          	auipc	ra,0x1
    80002146:	6c4080e7          	jalr	1732(ra) # 80003806 <iput>
  end_op(ROOTDEV);
    8000214a:	4501                	li	a0,0
    8000214c:	00002097          	auipc	ra,0x2
    80002150:	03a080e7          	jalr	58(ra) # 80004186 <end_op>
  p->cwd = 0;
    80002154:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    80002158:	00026497          	auipc	s1,0x26
    8000215c:	ee048493          	addi	s1,s1,-288 # 80028038 <initproc>
    80002160:	6088                	ld	a0,0(s1)
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	94e080e7          	jalr	-1714(ra) # 80000ab0 <acquire>
  wakeup1(initproc);
    8000216a:	6088                	ld	a0,0(s1)
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	7be080e7          	jalr	1982(ra) # 8000192a <wakeup1>
  release(&initproc->lock);
    80002174:	6088                	ld	a0,0(s1)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	a0a080e7          	jalr	-1526(ra) # 80000b80 <release>
  acquire(&p->lock);
    8000217e:	854e                	mv	a0,s3
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	930080e7          	jalr	-1744(ra) # 80000ab0 <acquire>
  struct proc *original_parent = p->parent;
    80002188:	0289b483          	ld	s1,40(s3)
  release(&p->lock);
    8000218c:	854e                	mv	a0,s3
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	9f2080e7          	jalr	-1550(ra) # 80000b80 <release>
  acquire(&original_parent->lock);
    80002196:	8526                	mv	a0,s1
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	918080e7          	jalr	-1768(ra) # 80000ab0 <acquire>
  acquire(&p->lock);
    800021a0:	854e                	mv	a0,s3
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	90e080e7          	jalr	-1778(ra) # 80000ab0 <acquire>
  reparent(p);
    800021aa:	854e                	mv	a0,s3
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	d32080e7          	jalr	-718(ra) # 80001ede <reparent>
  wakeup1(original_parent);
    800021b4:	8526                	mv	a0,s1
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	774080e7          	jalr	1908(ra) # 8000192a <wakeup1>
  p->xstate = status;
    800021be:	0349ae23          	sw	s4,60(s3)
  p->state = ZOMBIE;
    800021c2:	4791                	li	a5,4
    800021c4:	02f9a023          	sw	a5,32(s3)
  release(&original_parent->lock);
    800021c8:	8526                	mv	a0,s1
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	9b6080e7          	jalr	-1610(ra) # 80000b80 <release>
  sched();
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	e34080e7          	jalr	-460(ra) # 80002006 <sched>
  panic("zombie exit");
    800021da:	00006517          	auipc	a0,0x6
    800021de:	2d650513          	addi	a0,a0,726 # 800084b0 <userret+0x420>
    800021e2:	ffffe097          	auipc	ra,0xffffe
    800021e6:	378080e7          	jalr	888(ra) # 8000055a <panic>

00000000800021ea <yield>:
{
    800021ea:	1101                	addi	sp,sp,-32
    800021ec:	ec06                	sd	ra,24(sp)
    800021ee:	e822                	sd	s0,16(sp)
    800021f0:	e426                	sd	s1,8(sp)
    800021f2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	876080e7          	jalr	-1930(ra) # 80001a6a <myproc>
    800021fc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	8b2080e7          	jalr	-1870(ra) # 80000ab0 <acquire>
  p->state = RUNNABLE;
    80002206:	4789                	li	a5,2
    80002208:	d09c                	sw	a5,32(s1)
  sched();
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	dfc080e7          	jalr	-516(ra) # 80002006 <sched>
  release(&p->lock);
    80002212:	8526                	mv	a0,s1
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	96c080e7          	jalr	-1684(ra) # 80000b80 <release>
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <sleep>:
{
    80002226:	7179                	addi	sp,sp,-48
    80002228:	f406                	sd	ra,40(sp)
    8000222a:	f022                	sd	s0,32(sp)
    8000222c:	ec26                	sd	s1,24(sp)
    8000222e:	e84a                	sd	s2,16(sp)
    80002230:	e44e                	sd	s3,8(sp)
    80002232:	1800                	addi	s0,sp,48
    80002234:	89aa                	mv	s3,a0
    80002236:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	832080e7          	jalr	-1998(ra) # 80001a6a <myproc>
    80002240:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002242:	05250663          	beq	a0,s2,8000228e <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	86a080e7          	jalr	-1942(ra) # 80000ab0 <acquire>
    release(lk);
    8000224e:	854a                	mv	a0,s2
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	930080e7          	jalr	-1744(ra) # 80000b80 <release>
  p->chan = chan;
    80002258:	0334b823          	sd	s3,48(s1)
  p->state = SLEEPING;
    8000225c:	4785                	li	a5,1
    8000225e:	d09c                	sw	a5,32(s1)
  sched();
    80002260:	00000097          	auipc	ra,0x0
    80002264:	da6080e7          	jalr	-602(ra) # 80002006 <sched>
  p->chan = 0;
    80002268:	0204b823          	sd	zero,48(s1)
    release(&p->lock);
    8000226c:	8526                	mv	a0,s1
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	912080e7          	jalr	-1774(ra) # 80000b80 <release>
    acquire(lk);
    80002276:	854a                	mv	a0,s2
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	838080e7          	jalr	-1992(ra) # 80000ab0 <acquire>
}
    80002280:	70a2                	ld	ra,40(sp)
    80002282:	7402                	ld	s0,32(sp)
    80002284:	64e2                	ld	s1,24(sp)
    80002286:	6942                	ld	s2,16(sp)
    80002288:	69a2                	ld	s3,8(sp)
    8000228a:	6145                	addi	sp,sp,48
    8000228c:	8082                	ret
  p->chan = chan;
    8000228e:	03353823          	sd	s3,48(a0)
  p->state = SLEEPING;
    80002292:	4785                	li	a5,1
    80002294:	d11c                	sw	a5,32(a0)
  sched();
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	d70080e7          	jalr	-656(ra) # 80002006 <sched>
  p->chan = 0;
    8000229e:	0204b823          	sd	zero,48(s1)
  if(lk != &p->lock){
    800022a2:	bff9                	j	80002280 <sleep+0x5a>

00000000800022a4 <wait>:
{
    800022a4:	715d                	addi	sp,sp,-80
    800022a6:	e486                	sd	ra,72(sp)
    800022a8:	e0a2                	sd	s0,64(sp)
    800022aa:	fc26                	sd	s1,56(sp)
    800022ac:	f84a                	sd	s2,48(sp)
    800022ae:	f44e                	sd	s3,40(sp)
    800022b0:	f052                	sd	s4,32(sp)
    800022b2:	ec56                	sd	s5,24(sp)
    800022b4:	e85a                	sd	s6,16(sp)
    800022b6:	e45e                	sd	s7,8(sp)
    800022b8:	e062                	sd	s8,0(sp)
    800022ba:	0880                	addi	s0,sp,80
    800022bc:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	7ac080e7          	jalr	1964(ra) # 80001a6a <myproc>
    800022c6:	892a                	mv	s2,a0
  acquire(&p->lock);
    800022c8:	8c2a                	mv	s8,a0
    800022ca:	ffffe097          	auipc	ra,0xffffe
    800022ce:	7e6080e7          	jalr	2022(ra) # 80000ab0 <acquire>
    havekids = 0;
    800022d2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800022d4:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    800022d6:	00013997          	auipc	s3,0x13
    800022da:	7ea98993          	addi	s3,s3,2026 # 80015ac0 <tickslock>
        havekids = 1;
    800022de:	4b05                	li	s6,1
    havekids = 0;
    800022e0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800022e2:	00013497          	auipc	s1,0x13
    800022e6:	97e48493          	addi	s1,s1,-1666 # 80014c60 <proc>
    800022ea:	a08d                	j	8000234c <wait+0xa8>
          pid = np->pid;
    800022ec:	0404a983          	lw	s3,64(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022f0:	000a8e63          	beqz	s5,8000230c <wait+0x68>
    800022f4:	4691                	li	a3,4
    800022f6:	03c48613          	addi	a2,s1,60
    800022fa:	85d6                	mv	a1,s5
    800022fc:	05893503          	ld	a0,88(s2)
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	45e080e7          	jalr	1118(ra) # 8000175e <copyout>
    80002308:	02054263          	bltz	a0,8000232c <wait+0x88>
          freeproc(np);
    8000230c:	8526                	mv	a0,s1
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	978080e7          	jalr	-1672(ra) # 80001c86 <freeproc>
          release(&np->lock);
    80002316:	8526                	mv	a0,s1
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	868080e7          	jalr	-1944(ra) # 80000b80 <release>
          release(&p->lock);
    80002320:	854a                	mv	a0,s2
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	85e080e7          	jalr	-1954(ra) # 80000b80 <release>
          return pid;
    8000232a:	a8a9                	j	80002384 <wait+0xe0>
            release(&np->lock);
    8000232c:	8526                	mv	a0,s1
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	852080e7          	jalr	-1966(ra) # 80000b80 <release>
            release(&p->lock);
    80002336:	854a                	mv	a0,s2
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	848080e7          	jalr	-1976(ra) # 80000b80 <release>
            return -1;
    80002340:	59fd                	li	s3,-1
    80002342:	a089                	j	80002384 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002344:	17048493          	addi	s1,s1,368
    80002348:	03348463          	beq	s1,s3,80002370 <wait+0xcc>
      if(np->parent == p){
    8000234c:	749c                	ld	a5,40(s1)
    8000234e:	ff279be3          	bne	a5,s2,80002344 <wait+0xa0>
        acquire(&np->lock);
    80002352:	8526                	mv	a0,s1
    80002354:	ffffe097          	auipc	ra,0xffffe
    80002358:	75c080e7          	jalr	1884(ra) # 80000ab0 <acquire>
        if(np->state == ZOMBIE){
    8000235c:	509c                	lw	a5,32(s1)
    8000235e:	f94787e3          	beq	a5,s4,800022ec <wait+0x48>
        release(&np->lock);
    80002362:	8526                	mv	a0,s1
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	81c080e7          	jalr	-2020(ra) # 80000b80 <release>
        havekids = 1;
    8000236c:	875a                	mv	a4,s6
    8000236e:	bfd9                	j	80002344 <wait+0xa0>
    if(!havekids || p->killed){
    80002370:	c701                	beqz	a4,80002378 <wait+0xd4>
    80002372:	03892783          	lw	a5,56(s2)
    80002376:	c785                	beqz	a5,8000239e <wait+0xfa>
      release(&p->lock);
    80002378:	854a                	mv	a0,s2
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	806080e7          	jalr	-2042(ra) # 80000b80 <release>
      return -1;
    80002382:	59fd                	li	s3,-1
}
    80002384:	854e                	mv	a0,s3
    80002386:	60a6                	ld	ra,72(sp)
    80002388:	6406                	ld	s0,64(sp)
    8000238a:	74e2                	ld	s1,56(sp)
    8000238c:	7942                	ld	s2,48(sp)
    8000238e:	79a2                	ld	s3,40(sp)
    80002390:	7a02                	ld	s4,32(sp)
    80002392:	6ae2                	ld	s5,24(sp)
    80002394:	6b42                	ld	s6,16(sp)
    80002396:	6ba2                	ld	s7,8(sp)
    80002398:	6c02                	ld	s8,0(sp)
    8000239a:	6161                	addi	sp,sp,80
    8000239c:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000239e:	85e2                	mv	a1,s8
    800023a0:	854a                	mv	a0,s2
    800023a2:	00000097          	auipc	ra,0x0
    800023a6:	e84080e7          	jalr	-380(ra) # 80002226 <sleep>
    havekids = 0;
    800023aa:	bf1d                	j	800022e0 <wait+0x3c>

00000000800023ac <wakeup>:
{
    800023ac:	7139                	addi	sp,sp,-64
    800023ae:	fc06                	sd	ra,56(sp)
    800023b0:	f822                	sd	s0,48(sp)
    800023b2:	f426                	sd	s1,40(sp)
    800023b4:	f04a                	sd	s2,32(sp)
    800023b6:	ec4e                	sd	s3,24(sp)
    800023b8:	e852                	sd	s4,16(sp)
    800023ba:	e456                	sd	s5,8(sp)
    800023bc:	0080                	addi	s0,sp,64
    800023be:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023c0:	00013497          	auipc	s1,0x13
    800023c4:	8a048493          	addi	s1,s1,-1888 # 80014c60 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800023c8:	4985                	li	s3,1
      p->state = RUNNABLE;
    800023ca:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800023cc:	00013917          	auipc	s2,0x13
    800023d0:	6f490913          	addi	s2,s2,1780 # 80015ac0 <tickslock>
    800023d4:	a821                	j	800023ec <wakeup+0x40>
      p->state = RUNNABLE;
    800023d6:	0354a023          	sw	s5,32(s1)
    release(&p->lock);
    800023da:	8526                	mv	a0,s1
    800023dc:	ffffe097          	auipc	ra,0xffffe
    800023e0:	7a4080e7          	jalr	1956(ra) # 80000b80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800023e4:	17048493          	addi	s1,s1,368
    800023e8:	01248e63          	beq	s1,s2,80002404 <wakeup+0x58>
    acquire(&p->lock);
    800023ec:	8526                	mv	a0,s1
    800023ee:	ffffe097          	auipc	ra,0xffffe
    800023f2:	6c2080e7          	jalr	1730(ra) # 80000ab0 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023f6:	509c                	lw	a5,32(s1)
    800023f8:	ff3791e3          	bne	a5,s3,800023da <wakeup+0x2e>
    800023fc:	789c                	ld	a5,48(s1)
    800023fe:	fd479ee3          	bne	a5,s4,800023da <wakeup+0x2e>
    80002402:	bfd1                	j	800023d6 <wakeup+0x2a>
}
    80002404:	70e2                	ld	ra,56(sp)
    80002406:	7442                	ld	s0,48(sp)
    80002408:	74a2                	ld	s1,40(sp)
    8000240a:	7902                	ld	s2,32(sp)
    8000240c:	69e2                	ld	s3,24(sp)
    8000240e:	6a42                	ld	s4,16(sp)
    80002410:	6aa2                	ld	s5,8(sp)
    80002412:	6121                	addi	sp,sp,64
    80002414:	8082                	ret

0000000080002416 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002416:	7179                	addi	sp,sp,-48
    80002418:	f406                	sd	ra,40(sp)
    8000241a:	f022                	sd	s0,32(sp)
    8000241c:	ec26                	sd	s1,24(sp)
    8000241e:	e84a                	sd	s2,16(sp)
    80002420:	e44e                	sd	s3,8(sp)
    80002422:	1800                	addi	s0,sp,48
    80002424:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002426:	00013497          	auipc	s1,0x13
    8000242a:	83a48493          	addi	s1,s1,-1990 # 80014c60 <proc>
    8000242e:	00013997          	auipc	s3,0x13
    80002432:	69298993          	addi	s3,s3,1682 # 80015ac0 <tickslock>
    acquire(&p->lock);
    80002436:	8526                	mv	a0,s1
    80002438:	ffffe097          	auipc	ra,0xffffe
    8000243c:	678080e7          	jalr	1656(ra) # 80000ab0 <acquire>
    if(p->pid == pid){
    80002440:	40bc                	lw	a5,64(s1)
    80002442:	03278363          	beq	a5,s2,80002468 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002446:	8526                	mv	a0,s1
    80002448:	ffffe097          	auipc	ra,0xffffe
    8000244c:	738080e7          	jalr	1848(ra) # 80000b80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002450:	17048493          	addi	s1,s1,368
    80002454:	ff3491e3          	bne	s1,s3,80002436 <kill+0x20>
  }
  return -1;
    80002458:	557d                	li	a0,-1
}
    8000245a:	70a2                	ld	ra,40(sp)
    8000245c:	7402                	ld	s0,32(sp)
    8000245e:	64e2                	ld	s1,24(sp)
    80002460:	6942                	ld	s2,16(sp)
    80002462:	69a2                	ld	s3,8(sp)
    80002464:	6145                	addi	sp,sp,48
    80002466:	8082                	ret
      p->killed = 1;
    80002468:	4785                	li	a5,1
    8000246a:	dc9c                	sw	a5,56(s1)
      if(p->state == SLEEPING){
    8000246c:	5098                	lw	a4,32(s1)
    8000246e:	4785                	li	a5,1
    80002470:	00f70963          	beq	a4,a5,80002482 <kill+0x6c>
      release(&p->lock);
    80002474:	8526                	mv	a0,s1
    80002476:	ffffe097          	auipc	ra,0xffffe
    8000247a:	70a080e7          	jalr	1802(ra) # 80000b80 <release>
      return 0;
    8000247e:	4501                	li	a0,0
    80002480:	bfe9                	j	8000245a <kill+0x44>
        p->state = RUNNABLE;
    80002482:	4789                	li	a5,2
    80002484:	d09c                	sw	a5,32(s1)
    80002486:	b7fd                	j	80002474 <kill+0x5e>

0000000080002488 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002488:	7179                	addi	sp,sp,-48
    8000248a:	f406                	sd	ra,40(sp)
    8000248c:	f022                	sd	s0,32(sp)
    8000248e:	ec26                	sd	s1,24(sp)
    80002490:	e84a                	sd	s2,16(sp)
    80002492:	e44e                	sd	s3,8(sp)
    80002494:	e052                	sd	s4,0(sp)
    80002496:	1800                	addi	s0,sp,48
    80002498:	84aa                	mv	s1,a0
    8000249a:	892e                	mv	s2,a1
    8000249c:	89b2                	mv	s3,a2
    8000249e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a0:	fffff097          	auipc	ra,0xfffff
    800024a4:	5ca080e7          	jalr	1482(ra) # 80001a6a <myproc>
  if(user_dst){
    800024a8:	c08d                	beqz	s1,800024ca <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024aa:	86d2                	mv	a3,s4
    800024ac:	864e                	mv	a2,s3
    800024ae:	85ca                	mv	a1,s2
    800024b0:	6d28                	ld	a0,88(a0)
    800024b2:	fffff097          	auipc	ra,0xfffff
    800024b6:	2ac080e7          	jalr	684(ra) # 8000175e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024ba:	70a2                	ld	ra,40(sp)
    800024bc:	7402                	ld	s0,32(sp)
    800024be:	64e2                	ld	s1,24(sp)
    800024c0:	6942                	ld	s2,16(sp)
    800024c2:	69a2                	ld	s3,8(sp)
    800024c4:	6a02                	ld	s4,0(sp)
    800024c6:	6145                	addi	sp,sp,48
    800024c8:	8082                	ret
    memmove((char *)dst, src, len);
    800024ca:	000a061b          	sext.w	a2,s4
    800024ce:	85ce                	mv	a1,s3
    800024d0:	854a                	mv	a0,s2
    800024d2:	fffff097          	auipc	ra,0xfffff
    800024d6:	90c080e7          	jalr	-1780(ra) # 80000dde <memmove>
    return 0;
    800024da:	8526                	mv	a0,s1
    800024dc:	bff9                	j	800024ba <either_copyout+0x32>

00000000800024de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024de:	7179                	addi	sp,sp,-48
    800024e0:	f406                	sd	ra,40(sp)
    800024e2:	f022                	sd	s0,32(sp)
    800024e4:	ec26                	sd	s1,24(sp)
    800024e6:	e84a                	sd	s2,16(sp)
    800024e8:	e44e                	sd	s3,8(sp)
    800024ea:	e052                	sd	s4,0(sp)
    800024ec:	1800                	addi	s0,sp,48
    800024ee:	892a                	mv	s2,a0
    800024f0:	84ae                	mv	s1,a1
    800024f2:	89b2                	mv	s3,a2
    800024f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024f6:	fffff097          	auipc	ra,0xfffff
    800024fa:	574080e7          	jalr	1396(ra) # 80001a6a <myproc>
  if(user_src){
    800024fe:	c08d                	beqz	s1,80002520 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002500:	86d2                	mv	a3,s4
    80002502:	864e                	mv	a2,s3
    80002504:	85ca                	mv	a1,s2
    80002506:	6d28                	ld	a0,88(a0)
    80002508:	fffff097          	auipc	ra,0xfffff
    8000250c:	2e2080e7          	jalr	738(ra) # 800017ea <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002510:	70a2                	ld	ra,40(sp)
    80002512:	7402                	ld	s0,32(sp)
    80002514:	64e2                	ld	s1,24(sp)
    80002516:	6942                	ld	s2,16(sp)
    80002518:	69a2                	ld	s3,8(sp)
    8000251a:	6a02                	ld	s4,0(sp)
    8000251c:	6145                	addi	sp,sp,48
    8000251e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002520:	000a061b          	sext.w	a2,s4
    80002524:	85ce                	mv	a1,s3
    80002526:	854a                	mv	a0,s2
    80002528:	fffff097          	auipc	ra,0xfffff
    8000252c:	8b6080e7          	jalr	-1866(ra) # 80000dde <memmove>
    return 0;
    80002530:	8526                	mv	a0,s1
    80002532:	bff9                	j	80002510 <either_copyin+0x32>

0000000080002534 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002534:	715d                	addi	sp,sp,-80
    80002536:	e486                	sd	ra,72(sp)
    80002538:	e0a2                	sd	s0,64(sp)
    8000253a:	fc26                	sd	s1,56(sp)
    8000253c:	f84a                	sd	s2,48(sp)
    8000253e:	f44e                	sd	s3,40(sp)
    80002540:	f052                	sd	s4,32(sp)
    80002542:	ec56                	sd	s5,24(sp)
    80002544:	e85a                	sd	s6,16(sp)
    80002546:	e45e                	sd	s7,8(sp)
    80002548:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000254a:	00006517          	auipc	a0,0x6
    8000254e:	d4650513          	addi	a0,a0,-698 # 80008290 <userret+0x200>
    80002552:	ffffe097          	auipc	ra,0xffffe
    80002556:	062080e7          	jalr	98(ra) # 800005b4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000255a:	00013497          	auipc	s1,0x13
    8000255e:	86648493          	addi	s1,s1,-1946 # 80014dc0 <proc+0x160>
    80002562:	00013917          	auipc	s2,0x13
    80002566:	6be90913          	addi	s2,s2,1726 # 80015c20 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000256a:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000256c:	00006997          	auipc	s3,0x6
    80002570:	f5498993          	addi	s3,s3,-172 # 800084c0 <userret+0x430>
    printf("%d %s %s", p->pid, state, p->name);
    80002574:	00006a97          	auipc	s5,0x6
    80002578:	f54a8a93          	addi	s5,s5,-172 # 800084c8 <userret+0x438>
    printf("\n");
    8000257c:	00006a17          	auipc	s4,0x6
    80002580:	d14a0a13          	addi	s4,s4,-748 # 80008290 <userret+0x200>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002584:	00006b97          	auipc	s7,0x6
    80002588:	7a4b8b93          	addi	s7,s7,1956 # 80008d28 <states.1785>
    8000258c:	a00d                	j	800025ae <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000258e:	ee06a583          	lw	a1,-288(a3)
    80002592:	8556                	mv	a0,s5
    80002594:	ffffe097          	auipc	ra,0xffffe
    80002598:	020080e7          	jalr	32(ra) # 800005b4 <printf>
    printf("\n");
    8000259c:	8552                	mv	a0,s4
    8000259e:	ffffe097          	auipc	ra,0xffffe
    800025a2:	016080e7          	jalr	22(ra) # 800005b4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025a6:	17048493          	addi	s1,s1,368
    800025aa:	03248163          	beq	s1,s2,800025cc <procdump+0x98>
    if(p->state == UNUSED)
    800025ae:	86a6                	mv	a3,s1
    800025b0:	ec04a783          	lw	a5,-320(s1)
    800025b4:	dbed                	beqz	a5,800025a6 <procdump+0x72>
      state = "???";
    800025b6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025b8:	fcfb6be3          	bltu	s6,a5,8000258e <procdump+0x5a>
    800025bc:	1782                	slli	a5,a5,0x20
    800025be:	9381                	srli	a5,a5,0x20
    800025c0:	078e                	slli	a5,a5,0x3
    800025c2:	97de                	add	a5,a5,s7
    800025c4:	6390                	ld	a2,0(a5)
    800025c6:	f661                	bnez	a2,8000258e <procdump+0x5a>
      state = "???";
    800025c8:	864e                	mv	a2,s3
    800025ca:	b7d1                	j	8000258e <procdump+0x5a>
  }
}
    800025cc:	60a6                	ld	ra,72(sp)
    800025ce:	6406                	ld	s0,64(sp)
    800025d0:	74e2                	ld	s1,56(sp)
    800025d2:	7942                	ld	s2,48(sp)
    800025d4:	79a2                	ld	s3,40(sp)
    800025d6:	7a02                	ld	s4,32(sp)
    800025d8:	6ae2                	ld	s5,24(sp)
    800025da:	6b42                	ld	s6,16(sp)
    800025dc:	6ba2                	ld	s7,8(sp)
    800025de:	6161                	addi	sp,sp,80
    800025e0:	8082                	ret

00000000800025e2 <swtch>:
    800025e2:	00153023          	sd	ra,0(a0)
    800025e6:	00253423          	sd	sp,8(a0)
    800025ea:	e900                	sd	s0,16(a0)
    800025ec:	ed04                	sd	s1,24(a0)
    800025ee:	03253023          	sd	s2,32(a0)
    800025f2:	03353423          	sd	s3,40(a0)
    800025f6:	03453823          	sd	s4,48(a0)
    800025fa:	03553c23          	sd	s5,56(a0)
    800025fe:	05653023          	sd	s6,64(a0)
    80002602:	05753423          	sd	s7,72(a0)
    80002606:	05853823          	sd	s8,80(a0)
    8000260a:	05953c23          	sd	s9,88(a0)
    8000260e:	07a53023          	sd	s10,96(a0)
    80002612:	07b53423          	sd	s11,104(a0)
    80002616:	0005b083          	ld	ra,0(a1)
    8000261a:	0085b103          	ld	sp,8(a1)
    8000261e:	6980                	ld	s0,16(a1)
    80002620:	6d84                	ld	s1,24(a1)
    80002622:	0205b903          	ld	s2,32(a1)
    80002626:	0285b983          	ld	s3,40(a1)
    8000262a:	0305ba03          	ld	s4,48(a1)
    8000262e:	0385ba83          	ld	s5,56(a1)
    80002632:	0405bb03          	ld	s6,64(a1)
    80002636:	0485bb83          	ld	s7,72(a1)
    8000263a:	0505bc03          	ld	s8,80(a1)
    8000263e:	0585bc83          	ld	s9,88(a1)
    80002642:	0605bd03          	ld	s10,96(a1)
    80002646:	0685bd83          	ld	s11,104(a1)
    8000264a:	8082                	ret

000000008000264c <scause_desc>:
  }
}

static const char *
scause_desc(uint64 stval)
{
    8000264c:	1141                	addi	sp,sp,-16
    8000264e:	e422                	sd	s0,8(sp)
    80002650:	0800                	addi	s0,sp,16
    80002652:	87aa                	mv	a5,a0
    [13] "load page fault",
    [14] "<reserved for future standard use>",
    [15] "store/AMO page fault",
  };
  uint64 interrupt = stval & 0x8000000000000000L;
  uint64 code = stval & ~0x8000000000000000L;
    80002654:	00151713          	slli	a4,a0,0x1
    80002658:	8305                	srli	a4,a4,0x1
  if (interrupt) {
    8000265a:	04054c63          	bltz	a0,800026b2 <scause_desc+0x66>
      return intr_desc[code];
    } else {
      return "<reserved for platform use>";
    }
  } else {
    if (code < NELEM(nointr_desc)) {
    8000265e:	5685                	li	a3,-31
    80002660:	8285                	srli	a3,a3,0x1
    80002662:	8ee9                	and	a3,a3,a0
    80002664:	caad                	beqz	a3,800026d6 <scause_desc+0x8a>
      return nointr_desc[code];
    } else if (code <= 23) {
    80002666:	46dd                	li	a3,23
      return "<reserved for future standard use>";
    80002668:	00006517          	auipc	a0,0x6
    8000266c:	e9850513          	addi	a0,a0,-360 # 80008500 <userret+0x470>
    } else if (code <= 23) {
    80002670:	06e6f063          	bgeu	a3,a4,800026d0 <scause_desc+0x84>
    } else if (code <= 31) {
    80002674:	fc100693          	li	a3,-63
    80002678:	8285                	srli	a3,a3,0x1
    8000267a:	8efd                	and	a3,a3,a5
      return "<reserved for custom use>";
    8000267c:	00006517          	auipc	a0,0x6
    80002680:	eac50513          	addi	a0,a0,-340 # 80008528 <userret+0x498>
    } else if (code <= 31) {
    80002684:	c6b1                	beqz	a3,800026d0 <scause_desc+0x84>
    } else if (code <= 47) {
    80002686:	02f00693          	li	a3,47
      return "<reserved for future standard use>";
    8000268a:	00006517          	auipc	a0,0x6
    8000268e:	e7650513          	addi	a0,a0,-394 # 80008500 <userret+0x470>
    } else if (code <= 47) {
    80002692:	02e6ff63          	bgeu	a3,a4,800026d0 <scause_desc+0x84>
    } else if (code <= 63) {
    80002696:	f8100513          	li	a0,-127
    8000269a:	8105                	srli	a0,a0,0x1
    8000269c:	8fe9                	and	a5,a5,a0
      return "<reserved for custom use>";
    8000269e:	00006517          	auipc	a0,0x6
    800026a2:	e8a50513          	addi	a0,a0,-374 # 80008528 <userret+0x498>
    } else if (code <= 63) {
    800026a6:	c78d                	beqz	a5,800026d0 <scause_desc+0x84>
    } else {
      return "<reserved for future standard use>";
    800026a8:	00006517          	auipc	a0,0x6
    800026ac:	e5850513          	addi	a0,a0,-424 # 80008500 <userret+0x470>
    800026b0:	a005                	j	800026d0 <scause_desc+0x84>
    if (code < NELEM(intr_desc)) {
    800026b2:	5505                	li	a0,-31
    800026b4:	8105                	srli	a0,a0,0x1
    800026b6:	8fe9                	and	a5,a5,a0
      return "<reserved for platform use>";
    800026b8:	00006517          	auipc	a0,0x6
    800026bc:	e9050513          	addi	a0,a0,-368 # 80008548 <userret+0x4b8>
    if (code < NELEM(intr_desc)) {
    800026c0:	eb81                	bnez	a5,800026d0 <scause_desc+0x84>
      return intr_desc[code];
    800026c2:	070e                	slli	a4,a4,0x3
    800026c4:	00006797          	auipc	a5,0x6
    800026c8:	68c78793          	addi	a5,a5,1676 # 80008d50 <intr_desc.1606>
    800026cc:	973e                	add	a4,a4,a5
    800026ce:	6308                	ld	a0,0(a4)
    }
  }
}
    800026d0:	6422                	ld	s0,8(sp)
    800026d2:	0141                	addi	sp,sp,16
    800026d4:	8082                	ret
      return nointr_desc[code];
    800026d6:	070e                	slli	a4,a4,0x3
    800026d8:	00006797          	auipc	a5,0x6
    800026dc:	67878793          	addi	a5,a5,1656 # 80008d50 <intr_desc.1606>
    800026e0:	973e                	add	a4,a4,a5
    800026e2:	6348                	ld	a0,128(a4)
    800026e4:	b7f5                	j	800026d0 <scause_desc+0x84>

00000000800026e6 <trapinit>:
{
    800026e6:	1141                	addi	sp,sp,-16
    800026e8:	e406                	sd	ra,8(sp)
    800026ea:	e022                	sd	s0,0(sp)
    800026ec:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026ee:	00006597          	auipc	a1,0x6
    800026f2:	e7a58593          	addi	a1,a1,-390 # 80008568 <userret+0x4d8>
    800026f6:	00013517          	auipc	a0,0x13
    800026fa:	3ca50513          	addi	a0,a0,970 # 80015ac0 <tickslock>
    800026fe:	ffffe097          	auipc	ra,0xffffe
    80002702:	2de080e7          	jalr	734(ra) # 800009dc <initlock>
}
    80002706:	60a2                	ld	ra,8(sp)
    80002708:	6402                	ld	s0,0(sp)
    8000270a:	0141                	addi	sp,sp,16
    8000270c:	8082                	ret

000000008000270e <trapinithart>:
{
    8000270e:	1141                	addi	sp,sp,-16
    80002710:	e422                	sd	s0,8(sp)
    80002712:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002714:	00003797          	auipc	a5,0x3
    80002718:	5ec78793          	addi	a5,a5,1516 # 80005d00 <kernelvec>
    8000271c:	10579073          	csrw	stvec,a5
}
    80002720:	6422                	ld	s0,8(sp)
    80002722:	0141                	addi	sp,sp,16
    80002724:	8082                	ret

0000000080002726 <usertrapret>:
{
    80002726:	1141                	addi	sp,sp,-16
    80002728:	e406                	sd	ra,8(sp)
    8000272a:	e022                	sd	s0,0(sp)
    8000272c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000272e:	fffff097          	auipc	ra,0xfffff
    80002732:	33c080e7          	jalr	828(ra) # 80001a6a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002736:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000273a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000273c:	10079073          	csrw	sstatus,a5
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002740:	00006617          	auipc	a2,0x6
    80002744:	8c060613          	addi	a2,a2,-1856 # 80008000 <trampoline>
    80002748:	00006697          	auipc	a3,0x6
    8000274c:	8b868693          	addi	a3,a3,-1864 # 80008000 <trampoline>
    80002750:	8e91                	sub	a3,a3,a2
    80002752:	040007b7          	lui	a5,0x4000
    80002756:	17fd                	addi	a5,a5,-1
    80002758:	07b2                	slli	a5,a5,0xc
    8000275a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000275c:	10569073          	csrw	stvec,a3
  p->tf->kernel_satp = r_satp();         // kernel page table
    80002760:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002762:	180026f3          	csrr	a3,satp
    80002766:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002768:	7138                	ld	a4,96(a0)
    8000276a:	6534                	ld	a3,72(a0)
    8000276c:	6585                	lui	a1,0x1
    8000276e:	96ae                	add	a3,a3,a1
    80002770:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    80002772:	7138                	ld	a4,96(a0)
    80002774:	00000697          	auipc	a3,0x0
    80002778:	12c68693          	addi	a3,a3,300 # 800028a0 <usertrap>
    8000277c:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    8000277e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002780:	8692                	mv	a3,tp
    80002782:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002784:	100026f3          	csrr	a3,sstatus
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002788:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000278c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002790:	10069073          	csrw	sstatus,a3
  w_sepc(p->tf->epc);
    80002794:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002796:	6f18                	ld	a4,24(a4)
    80002798:	14171073          	csrw	sepc,a4
  uint64 satp = MAKE_SATP(p->pagetable);
    8000279c:	6d2c                	ld	a1,88(a0)
    8000279e:	81b1                	srli	a1,a1,0xc
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800027a0:	00006717          	auipc	a4,0x6
    800027a4:	8f070713          	addi	a4,a4,-1808 # 80008090 <userret>
    800027a8:	8f11                	sub	a4,a4,a2
    800027aa:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800027ac:	577d                	li	a4,-1
    800027ae:	177e                	slli	a4,a4,0x3f
    800027b0:	8dd9                	or	a1,a1,a4
    800027b2:	02000537          	lui	a0,0x2000
    800027b6:	157d                	addi	a0,a0,-1
    800027b8:	0536                	slli	a0,a0,0xd
    800027ba:	9782                	jalr	a5
}
    800027bc:	60a2                	ld	ra,8(sp)
    800027be:	6402                	ld	s0,0(sp)
    800027c0:	0141                	addi	sp,sp,16
    800027c2:	8082                	ret

00000000800027c4 <clockintr>:
{
    800027c4:	1101                	addi	sp,sp,-32
    800027c6:	ec06                	sd	ra,24(sp)
    800027c8:	e822                	sd	s0,16(sp)
    800027ca:	e426                	sd	s1,8(sp)
    800027cc:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027ce:	00013497          	auipc	s1,0x13
    800027d2:	2f248493          	addi	s1,s1,754 # 80015ac0 <tickslock>
    800027d6:	8526                	mv	a0,s1
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	2d8080e7          	jalr	728(ra) # 80000ab0 <acquire>
  ticks++;
    800027e0:	00026517          	auipc	a0,0x26
    800027e4:	86050513          	addi	a0,a0,-1952 # 80028040 <ticks>
    800027e8:	411c                	lw	a5,0(a0)
    800027ea:	2785                	addiw	a5,a5,1
    800027ec:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	bbe080e7          	jalr	-1090(ra) # 800023ac <wakeup>
  release(&tickslock);
    800027f6:	8526                	mv	a0,s1
    800027f8:	ffffe097          	auipc	ra,0xffffe
    800027fc:	388080e7          	jalr	904(ra) # 80000b80 <release>
}
    80002800:	60e2                	ld	ra,24(sp)
    80002802:	6442                	ld	s0,16(sp)
    80002804:	64a2                	ld	s1,8(sp)
    80002806:	6105                	addi	sp,sp,32
    80002808:	8082                	ret

000000008000280a <devintr>:
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002814:	14202773          	csrr	a4,scause
  if((scause & 0x8000000000000000L) &&
    80002818:	00074d63          	bltz	a4,80002832 <devintr+0x28>
  } else if(scause == 0x8000000000000001L){
    8000281c:	57fd                	li	a5,-1
    8000281e:	17fe                	slli	a5,a5,0x3f
    80002820:	0785                	addi	a5,a5,1
    return 0;
    80002822:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002824:	04f70d63          	beq	a4,a5,8000287e <devintr+0x74>
}
    80002828:	60e2                	ld	ra,24(sp)
    8000282a:	6442                	ld	s0,16(sp)
    8000282c:	64a2                	ld	s1,8(sp)
    8000282e:	6105                	addi	sp,sp,32
    80002830:	8082                	ret
     (scause & 0xff) == 9){
    80002832:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002836:	46a5                	li	a3,9
    80002838:	fed792e3          	bne	a5,a3,8000281c <devintr+0x12>
    int irq = plic_claim();
    8000283c:	00003097          	auipc	ra,0x3
    80002840:	5cc080e7          	jalr	1484(ra) # 80005e08 <plic_claim>
    80002844:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002846:	47a9                	li	a5,10
    80002848:	00f50a63          	beq	a0,a5,8000285c <devintr+0x52>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    8000284c:	fff5079b          	addiw	a5,a0,-1
    80002850:	4705                	li	a4,1
    80002852:	00f77a63          	bgeu	a4,a5,80002866 <devintr+0x5c>
    return 1;
    80002856:	4505                	li	a0,1
    if(irq)
    80002858:	d8e1                	beqz	s1,80002828 <devintr+0x1e>
    8000285a:	a819                	j	80002870 <devintr+0x66>
      uartintr();
    8000285c:	ffffe097          	auipc	ra,0xffffe
    80002860:	ff8080e7          	jalr	-8(ra) # 80000854 <uartintr>
    80002864:	a031                	j	80002870 <devintr+0x66>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    80002866:	853e                	mv	a0,a5
    80002868:	00004097          	auipc	ra,0x4
    8000286c:	b8e080e7          	jalr	-1138(ra) # 800063f6 <virtio_disk_intr>
      plic_complete(irq);
    80002870:	8526                	mv	a0,s1
    80002872:	00003097          	auipc	ra,0x3
    80002876:	5ba080e7          	jalr	1466(ra) # 80005e2c <plic_complete>
    return 1;
    8000287a:	4505                	li	a0,1
    8000287c:	b775                	j	80002828 <devintr+0x1e>
    if(cpuid() == 0){
    8000287e:	fffff097          	auipc	ra,0xfffff
    80002882:	1c0080e7          	jalr	448(ra) # 80001a3e <cpuid>
    80002886:	c901                	beqz	a0,80002896 <devintr+0x8c>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002888:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000288c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000288e:	14479073          	csrw	sip,a5
    return 2;
    80002892:	4509                	li	a0,2
    80002894:	bf51                	j	80002828 <devintr+0x1e>
      clockintr();
    80002896:	00000097          	auipc	ra,0x0
    8000289a:	f2e080e7          	jalr	-210(ra) # 800027c4 <clockintr>
    8000289e:	b7ed                	j	80002888 <devintr+0x7e>

00000000800028a0 <usertrap>:
{
    800028a0:	7179                	addi	sp,sp,-48
    800028a2:	f406                	sd	ra,40(sp)
    800028a4:	f022                	sd	s0,32(sp)
    800028a6:	ec26                	sd	s1,24(sp)
    800028a8:	e84a                	sd	s2,16(sp)
    800028aa:	e44e                	sd	s3,8(sp)
    800028ac:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ae:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028b2:	1007f793          	andi	a5,a5,256
    800028b6:	e3b5                	bnez	a5,8000291a <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028b8:	00003797          	auipc	a5,0x3
    800028bc:	44878793          	addi	a5,a5,1096 # 80005d00 <kernelvec>
    800028c0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028c4:	fffff097          	auipc	ra,0xfffff
    800028c8:	1a6080e7          	jalr	422(ra) # 80001a6a <myproc>
    800028cc:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    800028ce:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028d0:	14102773          	csrr	a4,sepc
    800028d4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028da:	47a1                	li	a5,8
    800028dc:	04f71d63          	bne	a4,a5,80002936 <usertrap+0x96>
    if(p->killed)
    800028e0:	5d1c                	lw	a5,56(a0)
    800028e2:	e7a1                	bnez	a5,8000292a <usertrap+0x8a>
    p->tf->epc += 4;
    800028e4:	70b8                	ld	a4,96(s1)
    800028e6:	6f1c                	ld	a5,24(a4)
    800028e8:	0791                	addi	a5,a5,4
    800028ea:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f4:	10079073          	csrw	sstatus,a5
    syscall();
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	2fe080e7          	jalr	766(ra) # 80002bf6 <syscall>
  if(p->killed)
    80002900:	5c9c                	lw	a5,56(s1)
    80002902:	e3cd                	bnez	a5,800029a4 <usertrap+0x104>
  usertrapret();
    80002904:	00000097          	auipc	ra,0x0
    80002908:	e22080e7          	jalr	-478(ra) # 80002726 <usertrapret>
}
    8000290c:	70a2                	ld	ra,40(sp)
    8000290e:	7402                	ld	s0,32(sp)
    80002910:	64e2                	ld	s1,24(sp)
    80002912:	6942                	ld	s2,16(sp)
    80002914:	69a2                	ld	s3,8(sp)
    80002916:	6145                	addi	sp,sp,48
    80002918:	8082                	ret
    panic("usertrap: not from user mode");
    8000291a:	00006517          	auipc	a0,0x6
    8000291e:	c5650513          	addi	a0,a0,-938 # 80008570 <userret+0x4e0>
    80002922:	ffffe097          	auipc	ra,0xffffe
    80002926:	c38080e7          	jalr	-968(ra) # 8000055a <panic>
      exit(-1);
    8000292a:	557d                	li	a0,-1
    8000292c:	fffff097          	auipc	ra,0xfffff
    80002930:	7b0080e7          	jalr	1968(ra) # 800020dc <exit>
    80002934:	bf45                	j	800028e4 <usertrap+0x44>
  } else if((which_dev = devintr()) != 0){
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	ed4080e7          	jalr	-300(ra) # 8000280a <devintr>
    8000293e:	892a                	mv	s2,a0
    80002940:	c501                	beqz	a0,80002948 <usertrap+0xa8>
  if(p->killed)
    80002942:	5c9c                	lw	a5,56(s1)
    80002944:	cba1                	beqz	a5,80002994 <usertrap+0xf4>
    80002946:	a091                	j	8000298a <usertrap+0xea>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002948:	142029f3          	csrr	s3,scause
    8000294c:	14202573          	csrr	a0,scause
    printf("usertrap(): unexpected scause %p (%s) pid=%d\n", r_scause(), scause_desc(r_scause()), p->pid);
    80002950:	00000097          	auipc	ra,0x0
    80002954:	cfc080e7          	jalr	-772(ra) # 8000264c <scause_desc>
    80002958:	862a                	mv	a2,a0
    8000295a:	40b4                	lw	a3,64(s1)
    8000295c:	85ce                	mv	a1,s3
    8000295e:	00006517          	auipc	a0,0x6
    80002962:	c3250513          	addi	a0,a0,-974 # 80008590 <userret+0x500>
    80002966:	ffffe097          	auipc	ra,0xffffe
    8000296a:	c4e080e7          	jalr	-946(ra) # 800005b4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000296e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002972:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002976:	00006517          	auipc	a0,0x6
    8000297a:	c4a50513          	addi	a0,a0,-950 # 800085c0 <userret+0x530>
    8000297e:	ffffe097          	auipc	ra,0xffffe
    80002982:	c36080e7          	jalr	-970(ra) # 800005b4 <printf>
    p->killed = 1;
    80002986:	4785                	li	a5,1
    80002988:	dc9c                	sw	a5,56(s1)
    exit(-1);
    8000298a:	557d                	li	a0,-1
    8000298c:	fffff097          	auipc	ra,0xfffff
    80002990:	750080e7          	jalr	1872(ra) # 800020dc <exit>
  if(which_dev == 2)
    80002994:	4789                	li	a5,2
    80002996:	f6f917e3          	bne	s2,a5,80002904 <usertrap+0x64>
    yield();
    8000299a:	00000097          	auipc	ra,0x0
    8000299e:	850080e7          	jalr	-1968(ra) # 800021ea <yield>
    800029a2:	b78d                	j	80002904 <usertrap+0x64>
  int which_dev = 0;
    800029a4:	4901                	li	s2,0
    800029a6:	b7d5                	j	8000298a <usertrap+0xea>

00000000800029a8 <kerneltrap>:
{
    800029a8:	7179                	addi	sp,sp,-48
    800029aa:	f406                	sd	ra,40(sp)
    800029ac:	f022                	sd	s0,32(sp)
    800029ae:	ec26                	sd	s1,24(sp)
    800029b0:	e84a                	sd	s2,16(sp)
    800029b2:	e44e                	sd	s3,8(sp)
    800029b4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029b6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ba:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029be:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029c2:	1004f793          	andi	a5,s1,256
    800029c6:	cb85                	beqz	a5,800029f6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029cc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029ce:	ef85                	bnez	a5,80002a06 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	e3a080e7          	jalr	-454(ra) # 8000280a <devintr>
    800029d8:	cd1d                	beqz	a0,80002a16 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029da:	4789                	li	a5,2
    800029dc:	08f50063          	beq	a0,a5,80002a5c <kerneltrap+0xb4>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029e0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029e4:	10049073          	csrw	sstatus,s1
}
    800029e8:	70a2                	ld	ra,40(sp)
    800029ea:	7402                	ld	s0,32(sp)
    800029ec:	64e2                	ld	s1,24(sp)
    800029ee:	6942                	ld	s2,16(sp)
    800029f0:	69a2                	ld	s3,8(sp)
    800029f2:	6145                	addi	sp,sp,48
    800029f4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029f6:	00006517          	auipc	a0,0x6
    800029fa:	bea50513          	addi	a0,a0,-1046 # 800085e0 <userret+0x550>
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	b5c080e7          	jalr	-1188(ra) # 8000055a <panic>
    panic("kerneltrap: interrupts enabled");
    80002a06:	00006517          	auipc	a0,0x6
    80002a0a:	c0250513          	addi	a0,a0,-1022 # 80008608 <userret+0x578>
    80002a0e:	ffffe097          	auipc	ra,0xffffe
    80002a12:	b4c080e7          	jalr	-1204(ra) # 8000055a <panic>
    printf("scause %p (%s)\n", scause, scause_desc(scause));
    80002a16:	854e                	mv	a0,s3
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	c34080e7          	jalr	-972(ra) # 8000264c <scause_desc>
    80002a20:	862a                	mv	a2,a0
    80002a22:	85ce                	mv	a1,s3
    80002a24:	00006517          	auipc	a0,0x6
    80002a28:	c0450513          	addi	a0,a0,-1020 # 80008628 <userret+0x598>
    80002a2c:	ffffe097          	auipc	ra,0xffffe
    80002a30:	b88080e7          	jalr	-1144(ra) # 800005b4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a38:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a3c:	00006517          	auipc	a0,0x6
    80002a40:	bfc50513          	addi	a0,a0,-1028 # 80008638 <userret+0x5a8>
    80002a44:	ffffe097          	auipc	ra,0xffffe
    80002a48:	b70080e7          	jalr	-1168(ra) # 800005b4 <printf>
    panic("kerneltrap");
    80002a4c:	00006517          	auipc	a0,0x6
    80002a50:	c0450513          	addi	a0,a0,-1020 # 80008650 <userret+0x5c0>
    80002a54:	ffffe097          	auipc	ra,0xffffe
    80002a58:	b06080e7          	jalr	-1274(ra) # 8000055a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a5c:	fffff097          	auipc	ra,0xfffff
    80002a60:	00e080e7          	jalr	14(ra) # 80001a6a <myproc>
    80002a64:	dd35                	beqz	a0,800029e0 <kerneltrap+0x38>
    80002a66:	fffff097          	auipc	ra,0xfffff
    80002a6a:	004080e7          	jalr	4(ra) # 80001a6a <myproc>
    80002a6e:	5118                	lw	a4,32(a0)
    80002a70:	478d                	li	a5,3
    80002a72:	f6f717e3          	bne	a4,a5,800029e0 <kerneltrap+0x38>
    yield();
    80002a76:	fffff097          	auipc	ra,0xfffff
    80002a7a:	774080e7          	jalr	1908(ra) # 800021ea <yield>
    80002a7e:	b78d                	j	800029e0 <kerneltrap+0x38>

0000000080002a80 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a80:	1101                	addi	sp,sp,-32
    80002a82:	ec06                	sd	ra,24(sp)
    80002a84:	e822                	sd	s0,16(sp)
    80002a86:	e426                	sd	s1,8(sp)
    80002a88:	1000                	addi	s0,sp,32
    80002a8a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a8c:	fffff097          	auipc	ra,0xfffff
    80002a90:	fde080e7          	jalr	-34(ra) # 80001a6a <myproc>
  switch (n) {
    80002a94:	4795                	li	a5,5
    80002a96:	0497e163          	bltu	a5,s1,80002ad8 <argraw+0x58>
    80002a9a:	048a                	slli	s1,s1,0x2
    80002a9c:	00006717          	auipc	a4,0x6
    80002aa0:	3b470713          	addi	a4,a4,948 # 80008e50 <nointr_desc.1607+0x80>
    80002aa4:	94ba                	add	s1,s1,a4
    80002aa6:	409c                	lw	a5,0(s1)
    80002aa8:	97ba                	add	a5,a5,a4
    80002aaa:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002aac:	713c                	ld	a5,96(a0)
    80002aae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002ab0:	60e2                	ld	ra,24(sp)
    80002ab2:	6442                	ld	s0,16(sp)
    80002ab4:	64a2                	ld	s1,8(sp)
    80002ab6:	6105                	addi	sp,sp,32
    80002ab8:	8082                	ret
    return p->tf->a1;
    80002aba:	713c                	ld	a5,96(a0)
    80002abc:	7fa8                	ld	a0,120(a5)
    80002abe:	bfcd                	j	80002ab0 <argraw+0x30>
    return p->tf->a2;
    80002ac0:	713c                	ld	a5,96(a0)
    80002ac2:	63c8                	ld	a0,128(a5)
    80002ac4:	b7f5                	j	80002ab0 <argraw+0x30>
    return p->tf->a3;
    80002ac6:	713c                	ld	a5,96(a0)
    80002ac8:	67c8                	ld	a0,136(a5)
    80002aca:	b7dd                	j	80002ab0 <argraw+0x30>
    return p->tf->a4;
    80002acc:	713c                	ld	a5,96(a0)
    80002ace:	6bc8                	ld	a0,144(a5)
    80002ad0:	b7c5                	j	80002ab0 <argraw+0x30>
    return p->tf->a5;
    80002ad2:	713c                	ld	a5,96(a0)
    80002ad4:	6fc8                	ld	a0,152(a5)
    80002ad6:	bfe9                	j	80002ab0 <argraw+0x30>
  panic("argraw");
    80002ad8:	00006517          	auipc	a0,0x6
    80002adc:	d8050513          	addi	a0,a0,-640 # 80008858 <userret+0x7c8>
    80002ae0:	ffffe097          	auipc	ra,0xffffe
    80002ae4:	a7a080e7          	jalr	-1414(ra) # 8000055a <panic>

0000000080002ae8 <fetchaddr>:
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	e426                	sd	s1,8(sp)
    80002af0:	e04a                	sd	s2,0(sp)
    80002af2:	1000                	addi	s0,sp,32
    80002af4:	84aa                	mv	s1,a0
    80002af6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002af8:	fffff097          	auipc	ra,0xfffff
    80002afc:	f72080e7          	jalr	-142(ra) # 80001a6a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002b00:	693c                	ld	a5,80(a0)
    80002b02:	02f4f863          	bgeu	s1,a5,80002b32 <fetchaddr+0x4a>
    80002b06:	00848713          	addi	a4,s1,8
    80002b0a:	02e7e663          	bltu	a5,a4,80002b36 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b0e:	46a1                	li	a3,8
    80002b10:	8626                	mv	a2,s1
    80002b12:	85ca                	mv	a1,s2
    80002b14:	6d28                	ld	a0,88(a0)
    80002b16:	fffff097          	auipc	ra,0xfffff
    80002b1a:	cd4080e7          	jalr	-812(ra) # 800017ea <copyin>
    80002b1e:	00a03533          	snez	a0,a0
    80002b22:	40a00533          	neg	a0,a0
}
    80002b26:	60e2                	ld	ra,24(sp)
    80002b28:	6442                	ld	s0,16(sp)
    80002b2a:	64a2                	ld	s1,8(sp)
    80002b2c:	6902                	ld	s2,0(sp)
    80002b2e:	6105                	addi	sp,sp,32
    80002b30:	8082                	ret
    return -1;
    80002b32:	557d                	li	a0,-1
    80002b34:	bfcd                	j	80002b26 <fetchaddr+0x3e>
    80002b36:	557d                	li	a0,-1
    80002b38:	b7fd                	j	80002b26 <fetchaddr+0x3e>

0000000080002b3a <fetchstr>:
{
    80002b3a:	7179                	addi	sp,sp,-48
    80002b3c:	f406                	sd	ra,40(sp)
    80002b3e:	f022                	sd	s0,32(sp)
    80002b40:	ec26                	sd	s1,24(sp)
    80002b42:	e84a                	sd	s2,16(sp)
    80002b44:	e44e                	sd	s3,8(sp)
    80002b46:	1800                	addi	s0,sp,48
    80002b48:	892a                	mv	s2,a0
    80002b4a:	84ae                	mv	s1,a1
    80002b4c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b4e:	fffff097          	auipc	ra,0xfffff
    80002b52:	f1c080e7          	jalr	-228(ra) # 80001a6a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b56:	86ce                	mv	a3,s3
    80002b58:	864a                	mv	a2,s2
    80002b5a:	85a6                	mv	a1,s1
    80002b5c:	6d28                	ld	a0,88(a0)
    80002b5e:	fffff097          	auipc	ra,0xfffff
    80002b62:	d18080e7          	jalr	-744(ra) # 80001876 <copyinstr>
  if(err < 0)
    80002b66:	00054763          	bltz	a0,80002b74 <fetchstr+0x3a>
  return strlen(buf);
    80002b6a:	8526                	mv	a0,s1
    80002b6c:	ffffe097          	auipc	ra,0xffffe
    80002b70:	39a080e7          	jalr	922(ra) # 80000f06 <strlen>
}
    80002b74:	70a2                	ld	ra,40(sp)
    80002b76:	7402                	ld	s0,32(sp)
    80002b78:	64e2                	ld	s1,24(sp)
    80002b7a:	6942                	ld	s2,16(sp)
    80002b7c:	69a2                	ld	s3,8(sp)
    80002b7e:	6145                	addi	sp,sp,48
    80002b80:	8082                	ret

0000000080002b82 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b82:	1101                	addi	sp,sp,-32
    80002b84:	ec06                	sd	ra,24(sp)
    80002b86:	e822                	sd	s0,16(sp)
    80002b88:	e426                	sd	s1,8(sp)
    80002b8a:	1000                	addi	s0,sp,32
    80002b8c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	ef2080e7          	jalr	-270(ra) # 80002a80 <argraw>
    80002b96:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b98:	4501                	li	a0,0
    80002b9a:	60e2                	ld	ra,24(sp)
    80002b9c:	6442                	ld	s0,16(sp)
    80002b9e:	64a2                	ld	s1,8(sp)
    80002ba0:	6105                	addi	sp,sp,32
    80002ba2:	8082                	ret

0000000080002ba4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	1000                	addi	s0,sp,32
    80002bae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bb0:	00000097          	auipc	ra,0x0
    80002bb4:	ed0080e7          	jalr	-304(ra) # 80002a80 <argraw>
    80002bb8:	e088                	sd	a0,0(s1)
  return 0;
}
    80002bba:	4501                	li	a0,0
    80002bbc:	60e2                	ld	ra,24(sp)
    80002bbe:	6442                	ld	s0,16(sp)
    80002bc0:	64a2                	ld	s1,8(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret

0000000080002bc6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bc6:	1101                	addi	sp,sp,-32
    80002bc8:	ec06                	sd	ra,24(sp)
    80002bca:	e822                	sd	s0,16(sp)
    80002bcc:	e426                	sd	s1,8(sp)
    80002bce:	e04a                	sd	s2,0(sp)
    80002bd0:	1000                	addi	s0,sp,32
    80002bd2:	84ae                	mv	s1,a1
    80002bd4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	eaa080e7          	jalr	-342(ra) # 80002a80 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002bde:	864a                	mv	a2,s2
    80002be0:	85a6                	mv	a1,s1
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	f58080e7          	jalr	-168(ra) # 80002b3a <fetchstr>
}
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6902                	ld	s2,0(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret

0000000080002bf6 <syscall>:
[SYS_ntas]    sys_ntas,
};

void
syscall(void)
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	e426                	sd	s1,8(sp)
    80002bfe:	e04a                	sd	s2,0(sp)
    80002c00:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c02:	fffff097          	auipc	ra,0xfffff
    80002c06:	e68080e7          	jalr	-408(ra) # 80001a6a <myproc>
    80002c0a:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002c0c:	06053903          	ld	s2,96(a0)
    80002c10:	0a893783          	ld	a5,168(s2)
    80002c14:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c18:	37fd                	addiw	a5,a5,-1
    80002c1a:	4755                	li	a4,21
    80002c1c:	00f76f63          	bltu	a4,a5,80002c3a <syscall+0x44>
    80002c20:	00369713          	slli	a4,a3,0x3
    80002c24:	00006797          	auipc	a5,0x6
    80002c28:	24478793          	addi	a5,a5,580 # 80008e68 <syscalls>
    80002c2c:	97ba                	add	a5,a5,a4
    80002c2e:	639c                	ld	a5,0(a5)
    80002c30:	c789                	beqz	a5,80002c3a <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002c32:	9782                	jalr	a5
    80002c34:	06a93823          	sd	a0,112(s2)
    80002c38:	a839                	j	80002c56 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c3a:	16048613          	addi	a2,s1,352
    80002c3e:	40ac                	lw	a1,64(s1)
    80002c40:	00006517          	auipc	a0,0x6
    80002c44:	c2050513          	addi	a0,a0,-992 # 80008860 <userret+0x7d0>
    80002c48:	ffffe097          	auipc	ra,0xffffe
    80002c4c:	96c080e7          	jalr	-1684(ra) # 800005b4 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002c50:	70bc                	ld	a5,96(s1)
    80002c52:	577d                	li	a4,-1
    80002c54:	fbb8                	sd	a4,112(a5)
  }
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6902                	ld	s2,0(sp)
    80002c5e:	6105                	addi	sp,sp,32
    80002c60:	8082                	ret

0000000080002c62 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c62:	1101                	addi	sp,sp,-32
    80002c64:	ec06                	sd	ra,24(sp)
    80002c66:	e822                	sd	s0,16(sp)
    80002c68:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c6a:	fec40593          	addi	a1,s0,-20
    80002c6e:	4501                	li	a0,0
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	f12080e7          	jalr	-238(ra) # 80002b82 <argint>
    return -1;
    80002c78:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c7a:	00054963          	bltz	a0,80002c8c <sys_exit+0x2a>
  exit(n);
    80002c7e:	fec42503          	lw	a0,-20(s0)
    80002c82:	fffff097          	auipc	ra,0xfffff
    80002c86:	45a080e7          	jalr	1114(ra) # 800020dc <exit>
  return 0;  // not reached
    80002c8a:	4781                	li	a5,0
}
    80002c8c:	853e                	mv	a0,a5
    80002c8e:	60e2                	ld	ra,24(sp)
    80002c90:	6442                	ld	s0,16(sp)
    80002c92:	6105                	addi	sp,sp,32
    80002c94:	8082                	ret

0000000080002c96 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c96:	1141                	addi	sp,sp,-16
    80002c98:	e406                	sd	ra,8(sp)
    80002c9a:	e022                	sd	s0,0(sp)
    80002c9c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c9e:	fffff097          	auipc	ra,0xfffff
    80002ca2:	dcc080e7          	jalr	-564(ra) # 80001a6a <myproc>
}
    80002ca6:	4128                	lw	a0,64(a0)
    80002ca8:	60a2                	ld	ra,8(sp)
    80002caa:	6402                	ld	s0,0(sp)
    80002cac:	0141                	addi	sp,sp,16
    80002cae:	8082                	ret

0000000080002cb0 <sys_fork>:

uint64
sys_fork(void)
{
    80002cb0:	1141                	addi	sp,sp,-16
    80002cb2:	e406                	sd	ra,8(sp)
    80002cb4:	e022                	sd	s0,0(sp)
    80002cb6:	0800                	addi	s0,sp,16
  return fork();
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	11c080e7          	jalr	284(ra) # 80001dd4 <fork>
}
    80002cc0:	60a2                	ld	ra,8(sp)
    80002cc2:	6402                	ld	s0,0(sp)
    80002cc4:	0141                	addi	sp,sp,16
    80002cc6:	8082                	ret

0000000080002cc8 <sys_wait>:

uint64
sys_wait(void)
{
    80002cc8:	1101                	addi	sp,sp,-32
    80002cca:	ec06                	sd	ra,24(sp)
    80002ccc:	e822                	sd	s0,16(sp)
    80002cce:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002cd0:	fe840593          	addi	a1,s0,-24
    80002cd4:	4501                	li	a0,0
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	ece080e7          	jalr	-306(ra) # 80002ba4 <argaddr>
    80002cde:	87aa                	mv	a5,a0
    return -1;
    80002ce0:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002ce2:	0007c863          	bltz	a5,80002cf2 <sys_wait+0x2a>
  return wait(p);
    80002ce6:	fe843503          	ld	a0,-24(s0)
    80002cea:	fffff097          	auipc	ra,0xfffff
    80002cee:	5ba080e7          	jalr	1466(ra) # 800022a4 <wait>
}
    80002cf2:	60e2                	ld	ra,24(sp)
    80002cf4:	6442                	ld	s0,16(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret

0000000080002cfa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cfa:	7179                	addi	sp,sp,-48
    80002cfc:	f406                	sd	ra,40(sp)
    80002cfe:	f022                	sd	s0,32(sp)
    80002d00:	ec26                	sd	s1,24(sp)
    80002d02:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002d04:	fdc40593          	addi	a1,s0,-36
    80002d08:	4501                	li	a0,0
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	e78080e7          	jalr	-392(ra) # 80002b82 <argint>
    80002d12:	87aa                	mv	a5,a0
    return -1;
    80002d14:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002d16:	0207c063          	bltz	a5,80002d36 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002d1a:	fffff097          	auipc	ra,0xfffff
    80002d1e:	d50080e7          	jalr	-688(ra) # 80001a6a <myproc>
    80002d22:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002d24:	fdc42503          	lw	a0,-36(s0)
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	038080e7          	jalr	56(ra) # 80001d60 <growproc>
    80002d30:	00054863          	bltz	a0,80002d40 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002d34:	8526                	mv	a0,s1
}
    80002d36:	70a2                	ld	ra,40(sp)
    80002d38:	7402                	ld	s0,32(sp)
    80002d3a:	64e2                	ld	s1,24(sp)
    80002d3c:	6145                	addi	sp,sp,48
    80002d3e:	8082                	ret
    return -1;
    80002d40:	557d                	li	a0,-1
    80002d42:	bfd5                	j	80002d36 <sys_sbrk+0x3c>

0000000080002d44 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d44:	7139                	addi	sp,sp,-64
    80002d46:	fc06                	sd	ra,56(sp)
    80002d48:	f822                	sd	s0,48(sp)
    80002d4a:	f426                	sd	s1,40(sp)
    80002d4c:	f04a                	sd	s2,32(sp)
    80002d4e:	ec4e                	sd	s3,24(sp)
    80002d50:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d52:	fcc40593          	addi	a1,s0,-52
    80002d56:	4501                	li	a0,0
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	e2a080e7          	jalr	-470(ra) # 80002b82 <argint>
    return -1;
    80002d60:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d62:	06054563          	bltz	a0,80002dcc <sys_sleep+0x88>
  acquire(&tickslock);
    80002d66:	00013517          	auipc	a0,0x13
    80002d6a:	d5a50513          	addi	a0,a0,-678 # 80015ac0 <tickslock>
    80002d6e:	ffffe097          	auipc	ra,0xffffe
    80002d72:	d42080e7          	jalr	-702(ra) # 80000ab0 <acquire>
  ticks0 = ticks;
    80002d76:	00025917          	auipc	s2,0x25
    80002d7a:	2ca92903          	lw	s2,714(s2) # 80028040 <ticks>
  while(ticks - ticks0 < n){
    80002d7e:	fcc42783          	lw	a5,-52(s0)
    80002d82:	cf85                	beqz	a5,80002dba <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d84:	00013997          	auipc	s3,0x13
    80002d88:	d3c98993          	addi	s3,s3,-708 # 80015ac0 <tickslock>
    80002d8c:	00025497          	auipc	s1,0x25
    80002d90:	2b448493          	addi	s1,s1,692 # 80028040 <ticks>
    if(myproc()->killed){
    80002d94:	fffff097          	auipc	ra,0xfffff
    80002d98:	cd6080e7          	jalr	-810(ra) # 80001a6a <myproc>
    80002d9c:	5d1c                	lw	a5,56(a0)
    80002d9e:	ef9d                	bnez	a5,80002ddc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002da0:	85ce                	mv	a1,s3
    80002da2:	8526                	mv	a0,s1
    80002da4:	fffff097          	auipc	ra,0xfffff
    80002da8:	482080e7          	jalr	1154(ra) # 80002226 <sleep>
  while(ticks - ticks0 < n){
    80002dac:	409c                	lw	a5,0(s1)
    80002dae:	412787bb          	subw	a5,a5,s2
    80002db2:	fcc42703          	lw	a4,-52(s0)
    80002db6:	fce7efe3          	bltu	a5,a4,80002d94 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002dba:	00013517          	auipc	a0,0x13
    80002dbe:	d0650513          	addi	a0,a0,-762 # 80015ac0 <tickslock>
    80002dc2:	ffffe097          	auipc	ra,0xffffe
    80002dc6:	dbe080e7          	jalr	-578(ra) # 80000b80 <release>
  return 0;
    80002dca:	4781                	li	a5,0
}
    80002dcc:	853e                	mv	a0,a5
    80002dce:	70e2                	ld	ra,56(sp)
    80002dd0:	7442                	ld	s0,48(sp)
    80002dd2:	74a2                	ld	s1,40(sp)
    80002dd4:	7902                	ld	s2,32(sp)
    80002dd6:	69e2                	ld	s3,24(sp)
    80002dd8:	6121                	addi	sp,sp,64
    80002dda:	8082                	ret
      release(&tickslock);
    80002ddc:	00013517          	auipc	a0,0x13
    80002de0:	ce450513          	addi	a0,a0,-796 # 80015ac0 <tickslock>
    80002de4:	ffffe097          	auipc	ra,0xffffe
    80002de8:	d9c080e7          	jalr	-612(ra) # 80000b80 <release>
      return -1;
    80002dec:	57fd                	li	a5,-1
    80002dee:	bff9                	j	80002dcc <sys_sleep+0x88>

0000000080002df0 <sys_kill>:

uint64
sys_kill(void)
{
    80002df0:	1101                	addi	sp,sp,-32
    80002df2:	ec06                	sd	ra,24(sp)
    80002df4:	e822                	sd	s0,16(sp)
    80002df6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002df8:	fec40593          	addi	a1,s0,-20
    80002dfc:	4501                	li	a0,0
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	d84080e7          	jalr	-636(ra) # 80002b82 <argint>
    80002e06:	87aa                	mv	a5,a0
    return -1;
    80002e08:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002e0a:	0007c863          	bltz	a5,80002e1a <sys_kill+0x2a>
  return kill(pid);
    80002e0e:	fec42503          	lw	a0,-20(s0)
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	604080e7          	jalr	1540(ra) # 80002416 <kill>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	6105                	addi	sp,sp,32
    80002e20:	8082                	ret

0000000080002e22 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e22:	1101                	addi	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e2c:	00013517          	auipc	a0,0x13
    80002e30:	c9450513          	addi	a0,a0,-876 # 80015ac0 <tickslock>
    80002e34:	ffffe097          	auipc	ra,0xffffe
    80002e38:	c7c080e7          	jalr	-900(ra) # 80000ab0 <acquire>
  xticks = ticks;
    80002e3c:	00025497          	auipc	s1,0x25
    80002e40:	2044a483          	lw	s1,516(s1) # 80028040 <ticks>
  release(&tickslock);
    80002e44:	00013517          	auipc	a0,0x13
    80002e48:	c7c50513          	addi	a0,a0,-900 # 80015ac0 <tickslock>
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	d34080e7          	jalr	-716(ra) # 80000b80 <release>
  return xticks;
}
    80002e54:	02049513          	slli	a0,s1,0x20
    80002e58:	9101                	srli	a0,a0,0x20
    80002e5a:	60e2                	ld	ra,24(sp)
    80002e5c:	6442                	ld	s0,16(sp)
    80002e5e:	64a2                	ld	s1,8(sp)
    80002e60:	6105                	addi	sp,sp,32
    80002e62:	8082                	ret

0000000080002e64 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e64:	7179                	addi	sp,sp,-48
    80002e66:	f406                	sd	ra,40(sp)
    80002e68:	f022                	sd	s0,32(sp)
    80002e6a:	ec26                	sd	s1,24(sp)
    80002e6c:	e84a                	sd	s2,16(sp)
    80002e6e:	e44e                	sd	s3,8(sp)
    80002e70:	e052                	sd	s4,0(sp)
    80002e72:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e74:	00005597          	auipc	a1,0x5
    80002e78:	44458593          	addi	a1,a1,1092 # 800082b8 <userret+0x228>
    80002e7c:	00013517          	auipc	a0,0x13
    80002e80:	c6450513          	addi	a0,a0,-924 # 80015ae0 <bcache>
    80002e84:	ffffe097          	auipc	ra,0xffffe
    80002e88:	b58080e7          	jalr	-1192(ra) # 800009dc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e8c:	0001b797          	auipc	a5,0x1b
    80002e90:	c5478793          	addi	a5,a5,-940 # 8001dae0 <bcache+0x8000>
    80002e94:	0001b717          	auipc	a4,0x1b
    80002e98:	fac70713          	addi	a4,a4,-84 # 8001de40 <bcache+0x8360>
    80002e9c:	3ae7b823          	sd	a4,944(a5)
  bcache.head.next = &bcache.head;
    80002ea0:	3ae7bc23          	sd	a4,952(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ea4:	00013497          	auipc	s1,0x13
    80002ea8:	c5c48493          	addi	s1,s1,-932 # 80015b00 <bcache+0x20>
    b->next = bcache.head.next;
    80002eac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002eae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002eb0:	00006a17          	auipc	s4,0x6
    80002eb4:	9d0a0a13          	addi	s4,s4,-1584 # 80008880 <userret+0x7f0>
    b->next = bcache.head.next;
    80002eb8:	3b893783          	ld	a5,952(s2)
    80002ebc:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head;
    80002ebe:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    80002ec2:	85d2                	mv	a1,s4
    80002ec4:	01048513          	addi	a0,s1,16
    80002ec8:	00001097          	auipc	ra,0x1
    80002ecc:	5a0080e7          	jalr	1440(ra) # 80004468 <initsleeplock>
    bcache.head.next->prev = b;
    80002ed0:	3b893783          	ld	a5,952(s2)
    80002ed4:	eba4                	sd	s1,80(a5)
    bcache.head.next = b;
    80002ed6:	3a993c23          	sd	s1,952(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002eda:	46048493          	addi	s1,s1,1120
    80002ede:	fd349de3          	bne	s1,s3,80002eb8 <binit+0x54>
  }
}
    80002ee2:	70a2                	ld	ra,40(sp)
    80002ee4:	7402                	ld	s0,32(sp)
    80002ee6:	64e2                	ld	s1,24(sp)
    80002ee8:	6942                	ld	s2,16(sp)
    80002eea:	69a2                	ld	s3,8(sp)
    80002eec:	6a02                	ld	s4,0(sp)
    80002eee:	6145                	addi	sp,sp,48
    80002ef0:	8082                	ret

0000000080002ef2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002ef2:	7179                	addi	sp,sp,-48
    80002ef4:	f406                	sd	ra,40(sp)
    80002ef6:	f022                	sd	s0,32(sp)
    80002ef8:	ec26                	sd	s1,24(sp)
    80002efa:	e84a                	sd	s2,16(sp)
    80002efc:	e44e                	sd	s3,8(sp)
    80002efe:	1800                	addi	s0,sp,48
    80002f00:	89aa                	mv	s3,a0
    80002f02:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002f04:	00013517          	auipc	a0,0x13
    80002f08:	bdc50513          	addi	a0,a0,-1060 # 80015ae0 <bcache>
    80002f0c:	ffffe097          	auipc	ra,0xffffe
    80002f10:	ba4080e7          	jalr	-1116(ra) # 80000ab0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f14:	0001b497          	auipc	s1,0x1b
    80002f18:	f844b483          	ld	s1,-124(s1) # 8001de98 <bcache+0x83b8>
    80002f1c:	0001b797          	auipc	a5,0x1b
    80002f20:	f2478793          	addi	a5,a5,-220 # 8001de40 <bcache+0x8360>
    80002f24:	02f48f63          	beq	s1,a5,80002f62 <bread+0x70>
    80002f28:	873e                	mv	a4,a5
    80002f2a:	a021                	j	80002f32 <bread+0x40>
    80002f2c:	6ca4                	ld	s1,88(s1)
    80002f2e:	02e48a63          	beq	s1,a4,80002f62 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f32:	449c                	lw	a5,8(s1)
    80002f34:	ff379ce3          	bne	a5,s3,80002f2c <bread+0x3a>
    80002f38:	44dc                	lw	a5,12(s1)
    80002f3a:	ff2799e3          	bne	a5,s2,80002f2c <bread+0x3a>
      b->refcnt++;
    80002f3e:	44bc                	lw	a5,72(s1)
    80002f40:	2785                	addiw	a5,a5,1
    80002f42:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002f44:	00013517          	auipc	a0,0x13
    80002f48:	b9c50513          	addi	a0,a0,-1124 # 80015ae0 <bcache>
    80002f4c:	ffffe097          	auipc	ra,0xffffe
    80002f50:	c34080e7          	jalr	-972(ra) # 80000b80 <release>
      acquiresleep(&b->lock);
    80002f54:	01048513          	addi	a0,s1,16
    80002f58:	00001097          	auipc	ra,0x1
    80002f5c:	54a080e7          	jalr	1354(ra) # 800044a2 <acquiresleep>
      return b;
    80002f60:	a8b9                	j	80002fbe <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f62:	0001b497          	auipc	s1,0x1b
    80002f66:	f2e4b483          	ld	s1,-210(s1) # 8001de90 <bcache+0x83b0>
    80002f6a:	0001b797          	auipc	a5,0x1b
    80002f6e:	ed678793          	addi	a5,a5,-298 # 8001de40 <bcache+0x8360>
    80002f72:	00f48863          	beq	s1,a5,80002f82 <bread+0x90>
    80002f76:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f78:	44bc                	lw	a5,72(s1)
    80002f7a:	cf81                	beqz	a5,80002f92 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f7c:	68a4                	ld	s1,80(s1)
    80002f7e:	fee49de3          	bne	s1,a4,80002f78 <bread+0x86>
  panic("bget: no buffers");
    80002f82:	00006517          	auipc	a0,0x6
    80002f86:	90650513          	addi	a0,a0,-1786 # 80008888 <userret+0x7f8>
    80002f8a:	ffffd097          	auipc	ra,0xffffd
    80002f8e:	5d0080e7          	jalr	1488(ra) # 8000055a <panic>
      b->dev = dev;
    80002f92:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002f96:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002f9a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f9e:	4785                	li	a5,1
    80002fa0:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002fa2:	00013517          	auipc	a0,0x13
    80002fa6:	b3e50513          	addi	a0,a0,-1218 # 80015ae0 <bcache>
    80002faa:	ffffe097          	auipc	ra,0xffffe
    80002fae:	bd6080e7          	jalr	-1066(ra) # 80000b80 <release>
      acquiresleep(&b->lock);
    80002fb2:	01048513          	addi	a0,s1,16
    80002fb6:	00001097          	auipc	ra,0x1
    80002fba:	4ec080e7          	jalr	1260(ra) # 800044a2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002fbe:	409c                	lw	a5,0(s1)
    80002fc0:	cb89                	beqz	a5,80002fd2 <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fc2:	8526                	mv	a0,s1
    80002fc4:	70a2                	ld	ra,40(sp)
    80002fc6:	7402                	ld	s0,32(sp)
    80002fc8:	64e2                	ld	s1,24(sp)
    80002fca:	6942                	ld	s2,16(sp)
    80002fcc:	69a2                	ld	s3,8(sp)
    80002fce:	6145                	addi	sp,sp,48
    80002fd0:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    80002fd2:	4601                	li	a2,0
    80002fd4:	85a6                	mv	a1,s1
    80002fd6:	4488                	lw	a0,8(s1)
    80002fd8:	00003097          	auipc	ra,0x3
    80002fdc:	106080e7          	jalr	262(ra) # 800060de <virtio_disk_rw>
    b->valid = 1;
    80002fe0:	4785                	li	a5,1
    80002fe2:	c09c                	sw	a5,0(s1)
  return b;
    80002fe4:	bff9                	j	80002fc2 <bread+0xd0>

0000000080002fe6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fe6:	1101                	addi	sp,sp,-32
    80002fe8:	ec06                	sd	ra,24(sp)
    80002fea:	e822                	sd	s0,16(sp)
    80002fec:	e426                	sd	s1,8(sp)
    80002fee:	1000                	addi	s0,sp,32
    80002ff0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ff2:	0541                	addi	a0,a0,16
    80002ff4:	00001097          	auipc	ra,0x1
    80002ff8:	548080e7          	jalr	1352(ra) # 8000453c <holdingsleep>
    80002ffc:	cd09                	beqz	a0,80003016 <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    80002ffe:	4605                	li	a2,1
    80003000:	85a6                	mv	a1,s1
    80003002:	4488                	lw	a0,8(s1)
    80003004:	00003097          	auipc	ra,0x3
    80003008:	0da080e7          	jalr	218(ra) # 800060de <virtio_disk_rw>
}
    8000300c:	60e2                	ld	ra,24(sp)
    8000300e:	6442                	ld	s0,16(sp)
    80003010:	64a2                	ld	s1,8(sp)
    80003012:	6105                	addi	sp,sp,32
    80003014:	8082                	ret
    panic("bwrite");
    80003016:	00006517          	auipc	a0,0x6
    8000301a:	88a50513          	addi	a0,a0,-1910 # 800088a0 <userret+0x810>
    8000301e:	ffffd097          	auipc	ra,0xffffd
    80003022:	53c080e7          	jalr	1340(ra) # 8000055a <panic>

0000000080003026 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80003026:	1101                	addi	sp,sp,-32
    80003028:	ec06                	sd	ra,24(sp)
    8000302a:	e822                	sd	s0,16(sp)
    8000302c:	e426                	sd	s1,8(sp)
    8000302e:	e04a                	sd	s2,0(sp)
    80003030:	1000                	addi	s0,sp,32
    80003032:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003034:	01050913          	addi	s2,a0,16
    80003038:	854a                	mv	a0,s2
    8000303a:	00001097          	auipc	ra,0x1
    8000303e:	502080e7          	jalr	1282(ra) # 8000453c <holdingsleep>
    80003042:	c92d                	beqz	a0,800030b4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003044:	854a                	mv	a0,s2
    80003046:	00001097          	auipc	ra,0x1
    8000304a:	4b2080e7          	jalr	1202(ra) # 800044f8 <releasesleep>

  acquire(&bcache.lock);
    8000304e:	00013517          	auipc	a0,0x13
    80003052:	a9250513          	addi	a0,a0,-1390 # 80015ae0 <bcache>
    80003056:	ffffe097          	auipc	ra,0xffffe
    8000305a:	a5a080e7          	jalr	-1446(ra) # 80000ab0 <acquire>
  b->refcnt--;
    8000305e:	44bc                	lw	a5,72(s1)
    80003060:	37fd                	addiw	a5,a5,-1
    80003062:	0007871b          	sext.w	a4,a5
    80003066:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    80003068:	eb05                	bnez	a4,80003098 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000306a:	6cbc                	ld	a5,88(s1)
    8000306c:	68b8                	ld	a4,80(s1)
    8000306e:	ebb8                	sd	a4,80(a5)
    b->prev->next = b->next;
    80003070:	68bc                	ld	a5,80(s1)
    80003072:	6cb8                	ld	a4,88(s1)
    80003074:	efb8                	sd	a4,88(a5)
    b->next = bcache.head.next;
    80003076:	0001b797          	auipc	a5,0x1b
    8000307a:	a6a78793          	addi	a5,a5,-1430 # 8001dae0 <bcache+0x8000>
    8000307e:	3b87b703          	ld	a4,952(a5)
    80003082:	ecb8                	sd	a4,88(s1)
    b->prev = &bcache.head;
    80003084:	0001b717          	auipc	a4,0x1b
    80003088:	dbc70713          	addi	a4,a4,-580 # 8001de40 <bcache+0x8360>
    8000308c:	e8b8                	sd	a4,80(s1)
    bcache.head.next->prev = b;
    8000308e:	3b87b703          	ld	a4,952(a5)
    80003092:	eb24                	sd	s1,80(a4)
    bcache.head.next = b;
    80003094:	3a97bc23          	sd	s1,952(a5)
  }
  
  release(&bcache.lock);
    80003098:	00013517          	auipc	a0,0x13
    8000309c:	a4850513          	addi	a0,a0,-1464 # 80015ae0 <bcache>
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	ae0080e7          	jalr	-1312(ra) # 80000b80 <release>
}
    800030a8:	60e2                	ld	ra,24(sp)
    800030aa:	6442                	ld	s0,16(sp)
    800030ac:	64a2                	ld	s1,8(sp)
    800030ae:	6902                	ld	s2,0(sp)
    800030b0:	6105                	addi	sp,sp,32
    800030b2:	8082                	ret
    panic("brelse");
    800030b4:	00005517          	auipc	a0,0x5
    800030b8:	7f450513          	addi	a0,a0,2036 # 800088a8 <userret+0x818>
    800030bc:	ffffd097          	auipc	ra,0xffffd
    800030c0:	49e080e7          	jalr	1182(ra) # 8000055a <panic>

00000000800030c4 <bpin>:

void
bpin(struct buf *b) {
    800030c4:	1101                	addi	sp,sp,-32
    800030c6:	ec06                	sd	ra,24(sp)
    800030c8:	e822                	sd	s0,16(sp)
    800030ca:	e426                	sd	s1,8(sp)
    800030cc:	1000                	addi	s0,sp,32
    800030ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030d0:	00013517          	auipc	a0,0x13
    800030d4:	a1050513          	addi	a0,a0,-1520 # 80015ae0 <bcache>
    800030d8:	ffffe097          	auipc	ra,0xffffe
    800030dc:	9d8080e7          	jalr	-1576(ra) # 80000ab0 <acquire>
  b->refcnt++;
    800030e0:	44bc                	lw	a5,72(s1)
    800030e2:	2785                	addiw	a5,a5,1
    800030e4:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    800030e6:	00013517          	auipc	a0,0x13
    800030ea:	9fa50513          	addi	a0,a0,-1542 # 80015ae0 <bcache>
    800030ee:	ffffe097          	auipc	ra,0xffffe
    800030f2:	a92080e7          	jalr	-1390(ra) # 80000b80 <release>
}
    800030f6:	60e2                	ld	ra,24(sp)
    800030f8:	6442                	ld	s0,16(sp)
    800030fa:	64a2                	ld	s1,8(sp)
    800030fc:	6105                	addi	sp,sp,32
    800030fe:	8082                	ret

0000000080003100 <bunpin>:

void
bunpin(struct buf *b) {
    80003100:	1101                	addi	sp,sp,-32
    80003102:	ec06                	sd	ra,24(sp)
    80003104:	e822                	sd	s0,16(sp)
    80003106:	e426                	sd	s1,8(sp)
    80003108:	1000                	addi	s0,sp,32
    8000310a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000310c:	00013517          	auipc	a0,0x13
    80003110:	9d450513          	addi	a0,a0,-1580 # 80015ae0 <bcache>
    80003114:	ffffe097          	auipc	ra,0xffffe
    80003118:	99c080e7          	jalr	-1636(ra) # 80000ab0 <acquire>
  b->refcnt--;
    8000311c:	44bc                	lw	a5,72(s1)
    8000311e:	37fd                	addiw	a5,a5,-1
    80003120:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    80003122:	00013517          	auipc	a0,0x13
    80003126:	9be50513          	addi	a0,a0,-1602 # 80015ae0 <bcache>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	a56080e7          	jalr	-1450(ra) # 80000b80 <release>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6105                	addi	sp,sp,32
    8000313a:	8082                	ret

000000008000313c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000313c:	1101                	addi	sp,sp,-32
    8000313e:	ec06                	sd	ra,24(sp)
    80003140:	e822                	sd	s0,16(sp)
    80003142:	e426                	sd	s1,8(sp)
    80003144:	e04a                	sd	s2,0(sp)
    80003146:	1000                	addi	s0,sp,32
    80003148:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000314a:	00d5d59b          	srliw	a1,a1,0xd
    8000314e:	0001b797          	auipc	a5,0x1b
    80003152:	16e7a783          	lw	a5,366(a5) # 8001e2bc <sb+0x1c>
    80003156:	9dbd                	addw	a1,a1,a5
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	d9a080e7          	jalr	-614(ra) # 80002ef2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003160:	0074f713          	andi	a4,s1,7
    80003164:	4785                	li	a5,1
    80003166:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000316a:	14ce                	slli	s1,s1,0x33
    8000316c:	90d9                	srli	s1,s1,0x36
    8000316e:	00950733          	add	a4,a0,s1
    80003172:	06074703          	lbu	a4,96(a4)
    80003176:	00e7f6b3          	and	a3,a5,a4
    8000317a:	c69d                	beqz	a3,800031a8 <bfree+0x6c>
    8000317c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000317e:	94aa                	add	s1,s1,a0
    80003180:	fff7c793          	not	a5,a5
    80003184:	8ff9                	and	a5,a5,a4
    80003186:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000318a:	00001097          	auipc	ra,0x1
    8000318e:	19e080e7          	jalr	414(ra) # 80004328 <log_write>
  brelse(bp);
    80003192:	854a                	mv	a0,s2
    80003194:	00000097          	auipc	ra,0x0
    80003198:	e92080e7          	jalr	-366(ra) # 80003026 <brelse>
}
    8000319c:	60e2                	ld	ra,24(sp)
    8000319e:	6442                	ld	s0,16(sp)
    800031a0:	64a2                	ld	s1,8(sp)
    800031a2:	6902                	ld	s2,0(sp)
    800031a4:	6105                	addi	sp,sp,32
    800031a6:	8082                	ret
    panic("freeing free block");
    800031a8:	00005517          	auipc	a0,0x5
    800031ac:	70850513          	addi	a0,a0,1800 # 800088b0 <userret+0x820>
    800031b0:	ffffd097          	auipc	ra,0xffffd
    800031b4:	3aa080e7          	jalr	938(ra) # 8000055a <panic>

00000000800031b8 <balloc>:
{
    800031b8:	711d                	addi	sp,sp,-96
    800031ba:	ec86                	sd	ra,88(sp)
    800031bc:	e8a2                	sd	s0,80(sp)
    800031be:	e4a6                	sd	s1,72(sp)
    800031c0:	e0ca                	sd	s2,64(sp)
    800031c2:	fc4e                	sd	s3,56(sp)
    800031c4:	f852                	sd	s4,48(sp)
    800031c6:	f456                	sd	s5,40(sp)
    800031c8:	f05a                	sd	s6,32(sp)
    800031ca:	ec5e                	sd	s7,24(sp)
    800031cc:	e862                	sd	s8,16(sp)
    800031ce:	e466                	sd	s9,8(sp)
    800031d0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800031d2:	0001b797          	auipc	a5,0x1b
    800031d6:	0d27a783          	lw	a5,210(a5) # 8001e2a4 <sb+0x4>
    800031da:	cbd1                	beqz	a5,8000326e <balloc+0xb6>
    800031dc:	8baa                	mv	s7,a0
    800031de:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031e0:	0001bb17          	auipc	s6,0x1b
    800031e4:	0c0b0b13          	addi	s6,s6,192 # 8001e2a0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031e8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031ea:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031ec:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031ee:	6c89                	lui	s9,0x2
    800031f0:	a831                	j	8000320c <balloc+0x54>
    brelse(bp);
    800031f2:	854a                	mv	a0,s2
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	e32080e7          	jalr	-462(ra) # 80003026 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031fc:	015c87bb          	addw	a5,s9,s5
    80003200:	00078a9b          	sext.w	s5,a5
    80003204:	004b2703          	lw	a4,4(s6)
    80003208:	06eaf363          	bgeu	s5,a4,8000326e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000320c:	41fad79b          	sraiw	a5,s5,0x1f
    80003210:	0137d79b          	srliw	a5,a5,0x13
    80003214:	015787bb          	addw	a5,a5,s5
    80003218:	40d7d79b          	sraiw	a5,a5,0xd
    8000321c:	01cb2583          	lw	a1,28(s6)
    80003220:	9dbd                	addw	a1,a1,a5
    80003222:	855e                	mv	a0,s7
    80003224:	00000097          	auipc	ra,0x0
    80003228:	cce080e7          	jalr	-818(ra) # 80002ef2 <bread>
    8000322c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000322e:	004b2503          	lw	a0,4(s6)
    80003232:	000a849b          	sext.w	s1,s5
    80003236:	8662                	mv	a2,s8
    80003238:	faa4fde3          	bgeu	s1,a0,800031f2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000323c:	41f6579b          	sraiw	a5,a2,0x1f
    80003240:	01d7d69b          	srliw	a3,a5,0x1d
    80003244:	00c6873b          	addw	a4,a3,a2
    80003248:	00777793          	andi	a5,a4,7
    8000324c:	9f95                	subw	a5,a5,a3
    8000324e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003252:	4037571b          	sraiw	a4,a4,0x3
    80003256:	00e906b3          	add	a3,s2,a4
    8000325a:	0606c683          	lbu	a3,96(a3)
    8000325e:	00d7f5b3          	and	a1,a5,a3
    80003262:	cd91                	beqz	a1,8000327e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003264:	2605                	addiw	a2,a2,1
    80003266:	2485                	addiw	s1,s1,1
    80003268:	fd4618e3          	bne	a2,s4,80003238 <balloc+0x80>
    8000326c:	b759                	j	800031f2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000326e:	00005517          	auipc	a0,0x5
    80003272:	65a50513          	addi	a0,a0,1626 # 800088c8 <userret+0x838>
    80003276:	ffffd097          	auipc	ra,0xffffd
    8000327a:	2e4080e7          	jalr	740(ra) # 8000055a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000327e:	974a                	add	a4,a4,s2
    80003280:	8fd5                	or	a5,a5,a3
    80003282:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80003286:	854a                	mv	a0,s2
    80003288:	00001097          	auipc	ra,0x1
    8000328c:	0a0080e7          	jalr	160(ra) # 80004328 <log_write>
        brelse(bp);
    80003290:	854a                	mv	a0,s2
    80003292:	00000097          	auipc	ra,0x0
    80003296:	d94080e7          	jalr	-620(ra) # 80003026 <brelse>
  bp = bread(dev, bno);
    8000329a:	85a6                	mv	a1,s1
    8000329c:	855e                	mv	a0,s7
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	c54080e7          	jalr	-940(ra) # 80002ef2 <bread>
    800032a6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032a8:	40000613          	li	a2,1024
    800032ac:	4581                	li	a1,0
    800032ae:	06050513          	addi	a0,a0,96
    800032b2:	ffffe097          	auipc	ra,0xffffe
    800032b6:	acc080e7          	jalr	-1332(ra) # 80000d7e <memset>
  log_write(bp);
    800032ba:	854a                	mv	a0,s2
    800032bc:	00001097          	auipc	ra,0x1
    800032c0:	06c080e7          	jalr	108(ra) # 80004328 <log_write>
  brelse(bp);
    800032c4:	854a                	mv	a0,s2
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	d60080e7          	jalr	-672(ra) # 80003026 <brelse>
}
    800032ce:	8526                	mv	a0,s1
    800032d0:	60e6                	ld	ra,88(sp)
    800032d2:	6446                	ld	s0,80(sp)
    800032d4:	64a6                	ld	s1,72(sp)
    800032d6:	6906                	ld	s2,64(sp)
    800032d8:	79e2                	ld	s3,56(sp)
    800032da:	7a42                	ld	s4,48(sp)
    800032dc:	7aa2                	ld	s5,40(sp)
    800032de:	7b02                	ld	s6,32(sp)
    800032e0:	6be2                	ld	s7,24(sp)
    800032e2:	6c42                	ld	s8,16(sp)
    800032e4:	6ca2                	ld	s9,8(sp)
    800032e6:	6125                	addi	sp,sp,96
    800032e8:	8082                	ret

00000000800032ea <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800032ea:	7179                	addi	sp,sp,-48
    800032ec:	f406                	sd	ra,40(sp)
    800032ee:	f022                	sd	s0,32(sp)
    800032f0:	ec26                	sd	s1,24(sp)
    800032f2:	e84a                	sd	s2,16(sp)
    800032f4:	e44e                	sd	s3,8(sp)
    800032f6:	e052                	sd	s4,0(sp)
    800032f8:	1800                	addi	s0,sp,48
    800032fa:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800032fc:	47ad                	li	a5,11
    800032fe:	04b7fe63          	bgeu	a5,a1,8000335a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003302:	ff45849b          	addiw	s1,a1,-12
    80003306:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000330a:	0ff00793          	li	a5,255
    8000330e:	0ae7e363          	bltu	a5,a4,800033b4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003312:	08852583          	lw	a1,136(a0)
    80003316:	c5ad                	beqz	a1,80003380 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003318:	00092503          	lw	a0,0(s2)
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	bd6080e7          	jalr	-1066(ra) # 80002ef2 <bread>
    80003324:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003326:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    8000332a:	02049593          	slli	a1,s1,0x20
    8000332e:	9181                	srli	a1,a1,0x20
    80003330:	058a                	slli	a1,a1,0x2
    80003332:	00b784b3          	add	s1,a5,a1
    80003336:	0004a983          	lw	s3,0(s1)
    8000333a:	04098d63          	beqz	s3,80003394 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000333e:	8552                	mv	a0,s4
    80003340:	00000097          	auipc	ra,0x0
    80003344:	ce6080e7          	jalr	-794(ra) # 80003026 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003348:	854e                	mv	a0,s3
    8000334a:	70a2                	ld	ra,40(sp)
    8000334c:	7402                	ld	s0,32(sp)
    8000334e:	64e2                	ld	s1,24(sp)
    80003350:	6942                	ld	s2,16(sp)
    80003352:	69a2                	ld	s3,8(sp)
    80003354:	6a02                	ld	s4,0(sp)
    80003356:	6145                	addi	sp,sp,48
    80003358:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000335a:	02059493          	slli	s1,a1,0x20
    8000335e:	9081                	srli	s1,s1,0x20
    80003360:	048a                	slli	s1,s1,0x2
    80003362:	94aa                	add	s1,s1,a0
    80003364:	0584a983          	lw	s3,88(s1)
    80003368:	fe0990e3          	bnez	s3,80003348 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000336c:	4108                	lw	a0,0(a0)
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	e4a080e7          	jalr	-438(ra) # 800031b8 <balloc>
    80003376:	0005099b          	sext.w	s3,a0
    8000337a:	0534ac23          	sw	s3,88(s1)
    8000337e:	b7e9                	j	80003348 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003380:	4108                	lw	a0,0(a0)
    80003382:	00000097          	auipc	ra,0x0
    80003386:	e36080e7          	jalr	-458(ra) # 800031b8 <balloc>
    8000338a:	0005059b          	sext.w	a1,a0
    8000338e:	08b92423          	sw	a1,136(s2)
    80003392:	b759                	j	80003318 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003394:	00092503          	lw	a0,0(s2)
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	e20080e7          	jalr	-480(ra) # 800031b8 <balloc>
    800033a0:	0005099b          	sext.w	s3,a0
    800033a4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800033a8:	8552                	mv	a0,s4
    800033aa:	00001097          	auipc	ra,0x1
    800033ae:	f7e080e7          	jalr	-130(ra) # 80004328 <log_write>
    800033b2:	b771                	j	8000333e <bmap+0x54>
  panic("bmap: out of range");
    800033b4:	00005517          	auipc	a0,0x5
    800033b8:	52c50513          	addi	a0,a0,1324 # 800088e0 <userret+0x850>
    800033bc:	ffffd097          	auipc	ra,0xffffd
    800033c0:	19e080e7          	jalr	414(ra) # 8000055a <panic>

00000000800033c4 <iget>:
{
    800033c4:	7179                	addi	sp,sp,-48
    800033c6:	f406                	sd	ra,40(sp)
    800033c8:	f022                	sd	s0,32(sp)
    800033ca:	ec26                	sd	s1,24(sp)
    800033cc:	e84a                	sd	s2,16(sp)
    800033ce:	e44e                	sd	s3,8(sp)
    800033d0:	e052                	sd	s4,0(sp)
    800033d2:	1800                	addi	s0,sp,48
    800033d4:	89aa                	mv	s3,a0
    800033d6:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800033d8:	0001b517          	auipc	a0,0x1b
    800033dc:	ee850513          	addi	a0,a0,-280 # 8001e2c0 <icache>
    800033e0:	ffffd097          	auipc	ra,0xffffd
    800033e4:	6d0080e7          	jalr	1744(ra) # 80000ab0 <acquire>
  empty = 0;
    800033e8:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033ea:	0001b497          	auipc	s1,0x1b
    800033ee:	ef648493          	addi	s1,s1,-266 # 8001e2e0 <icache+0x20>
    800033f2:	0001d697          	auipc	a3,0x1d
    800033f6:	b0e68693          	addi	a3,a3,-1266 # 8001ff00 <log>
    800033fa:	a039                	j	80003408 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033fc:	02090b63          	beqz	s2,80003432 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003400:	09048493          	addi	s1,s1,144
    80003404:	02d48a63          	beq	s1,a3,80003438 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003408:	449c                	lw	a5,8(s1)
    8000340a:	fef059e3          	blez	a5,800033fc <iget+0x38>
    8000340e:	4098                	lw	a4,0(s1)
    80003410:	ff3716e3          	bne	a4,s3,800033fc <iget+0x38>
    80003414:	40d8                	lw	a4,4(s1)
    80003416:	ff4713e3          	bne	a4,s4,800033fc <iget+0x38>
      ip->ref++;
    8000341a:	2785                	addiw	a5,a5,1
    8000341c:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000341e:	0001b517          	auipc	a0,0x1b
    80003422:	ea250513          	addi	a0,a0,-350 # 8001e2c0 <icache>
    80003426:	ffffd097          	auipc	ra,0xffffd
    8000342a:	75a080e7          	jalr	1882(ra) # 80000b80 <release>
      return ip;
    8000342e:	8926                	mv	s2,s1
    80003430:	a03d                	j	8000345e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003432:	f7f9                	bnez	a5,80003400 <iget+0x3c>
    80003434:	8926                	mv	s2,s1
    80003436:	b7e9                	j	80003400 <iget+0x3c>
  if(empty == 0)
    80003438:	02090c63          	beqz	s2,80003470 <iget+0xac>
  ip->dev = dev;
    8000343c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003440:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003444:	4785                	li	a5,1
    80003446:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000344a:	04092423          	sw	zero,72(s2)
  release(&icache.lock);
    8000344e:	0001b517          	auipc	a0,0x1b
    80003452:	e7250513          	addi	a0,a0,-398 # 8001e2c0 <icache>
    80003456:	ffffd097          	auipc	ra,0xffffd
    8000345a:	72a080e7          	jalr	1834(ra) # 80000b80 <release>
}
    8000345e:	854a                	mv	a0,s2
    80003460:	70a2                	ld	ra,40(sp)
    80003462:	7402                	ld	s0,32(sp)
    80003464:	64e2                	ld	s1,24(sp)
    80003466:	6942                	ld	s2,16(sp)
    80003468:	69a2                	ld	s3,8(sp)
    8000346a:	6a02                	ld	s4,0(sp)
    8000346c:	6145                	addi	sp,sp,48
    8000346e:	8082                	ret
    panic("iget: no inodes");
    80003470:	00005517          	auipc	a0,0x5
    80003474:	48850513          	addi	a0,a0,1160 # 800088f8 <userret+0x868>
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	0e2080e7          	jalr	226(ra) # 8000055a <panic>

0000000080003480 <fsinit>:
fsinit(int dev) {
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003490:	4585                	li	a1,1
    80003492:	00000097          	auipc	ra,0x0
    80003496:	a60080e7          	jalr	-1440(ra) # 80002ef2 <bread>
    8000349a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000349c:	0001b997          	auipc	s3,0x1b
    800034a0:	e0498993          	addi	s3,s3,-508 # 8001e2a0 <sb>
    800034a4:	02000613          	li	a2,32
    800034a8:	06050593          	addi	a1,a0,96
    800034ac:	854e                	mv	a0,s3
    800034ae:	ffffe097          	auipc	ra,0xffffe
    800034b2:	930080e7          	jalr	-1744(ra) # 80000dde <memmove>
  brelse(bp);
    800034b6:	8526                	mv	a0,s1
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	b6e080e7          	jalr	-1170(ra) # 80003026 <brelse>
  if(sb.magic != FSMAGIC)
    800034c0:	0009a703          	lw	a4,0(s3)
    800034c4:	102037b7          	lui	a5,0x10203
    800034c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034cc:	02f71263          	bne	a4,a5,800034f0 <fsinit+0x70>
  initlog(dev, &sb);
    800034d0:	0001b597          	auipc	a1,0x1b
    800034d4:	dd058593          	addi	a1,a1,-560 # 8001e2a0 <sb>
    800034d8:	854a                	mv	a0,s2
    800034da:	00001097          	auipc	ra,0x1
    800034de:	b38080e7          	jalr	-1224(ra) # 80004012 <initlog>
}
    800034e2:	70a2                	ld	ra,40(sp)
    800034e4:	7402                	ld	s0,32(sp)
    800034e6:	64e2                	ld	s1,24(sp)
    800034e8:	6942                	ld	s2,16(sp)
    800034ea:	69a2                	ld	s3,8(sp)
    800034ec:	6145                	addi	sp,sp,48
    800034ee:	8082                	ret
    panic("invalid file system");
    800034f0:	00005517          	auipc	a0,0x5
    800034f4:	41850513          	addi	a0,a0,1048 # 80008908 <userret+0x878>
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	062080e7          	jalr	98(ra) # 8000055a <panic>

0000000080003500 <iinit>:
{
    80003500:	7179                	addi	sp,sp,-48
    80003502:	f406                	sd	ra,40(sp)
    80003504:	f022                	sd	s0,32(sp)
    80003506:	ec26                	sd	s1,24(sp)
    80003508:	e84a                	sd	s2,16(sp)
    8000350a:	e44e                	sd	s3,8(sp)
    8000350c:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000350e:	00005597          	auipc	a1,0x5
    80003512:	41258593          	addi	a1,a1,1042 # 80008920 <userret+0x890>
    80003516:	0001b517          	auipc	a0,0x1b
    8000351a:	daa50513          	addi	a0,a0,-598 # 8001e2c0 <icache>
    8000351e:	ffffd097          	auipc	ra,0xffffd
    80003522:	4be080e7          	jalr	1214(ra) # 800009dc <initlock>
  for(i = 0; i < NINODE; i++) {
    80003526:	0001b497          	auipc	s1,0x1b
    8000352a:	dca48493          	addi	s1,s1,-566 # 8001e2f0 <icache+0x30>
    8000352e:	0001d997          	auipc	s3,0x1d
    80003532:	9e298993          	addi	s3,s3,-1566 # 8001ff10 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003536:	00005917          	auipc	s2,0x5
    8000353a:	3f290913          	addi	s2,s2,1010 # 80008928 <userret+0x898>
    8000353e:	85ca                	mv	a1,s2
    80003540:	8526                	mv	a0,s1
    80003542:	00001097          	auipc	ra,0x1
    80003546:	f26080e7          	jalr	-218(ra) # 80004468 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000354a:	09048493          	addi	s1,s1,144
    8000354e:	ff3498e3          	bne	s1,s3,8000353e <iinit+0x3e>
}
    80003552:	70a2                	ld	ra,40(sp)
    80003554:	7402                	ld	s0,32(sp)
    80003556:	64e2                	ld	s1,24(sp)
    80003558:	6942                	ld	s2,16(sp)
    8000355a:	69a2                	ld	s3,8(sp)
    8000355c:	6145                	addi	sp,sp,48
    8000355e:	8082                	ret

0000000080003560 <ialloc>:
{
    80003560:	715d                	addi	sp,sp,-80
    80003562:	e486                	sd	ra,72(sp)
    80003564:	e0a2                	sd	s0,64(sp)
    80003566:	fc26                	sd	s1,56(sp)
    80003568:	f84a                	sd	s2,48(sp)
    8000356a:	f44e                	sd	s3,40(sp)
    8000356c:	f052                	sd	s4,32(sp)
    8000356e:	ec56                	sd	s5,24(sp)
    80003570:	e85a                	sd	s6,16(sp)
    80003572:	e45e                	sd	s7,8(sp)
    80003574:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003576:	0001b717          	auipc	a4,0x1b
    8000357a:	d3672703          	lw	a4,-714(a4) # 8001e2ac <sb+0xc>
    8000357e:	4785                	li	a5,1
    80003580:	04e7fa63          	bgeu	a5,a4,800035d4 <ialloc+0x74>
    80003584:	8aaa                	mv	s5,a0
    80003586:	8bae                	mv	s7,a1
    80003588:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000358a:	0001ba17          	auipc	s4,0x1b
    8000358e:	d16a0a13          	addi	s4,s4,-746 # 8001e2a0 <sb>
    80003592:	00048b1b          	sext.w	s6,s1
    80003596:	0044d593          	srli	a1,s1,0x4
    8000359a:	018a2783          	lw	a5,24(s4)
    8000359e:	9dbd                	addw	a1,a1,a5
    800035a0:	8556                	mv	a0,s5
    800035a2:	00000097          	auipc	ra,0x0
    800035a6:	950080e7          	jalr	-1712(ra) # 80002ef2 <bread>
    800035aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035ac:	06050993          	addi	s3,a0,96
    800035b0:	00f4f793          	andi	a5,s1,15
    800035b4:	079a                	slli	a5,a5,0x6
    800035b6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035b8:	00099783          	lh	a5,0(s3)
    800035bc:	c785                	beqz	a5,800035e4 <ialloc+0x84>
    brelse(bp);
    800035be:	00000097          	auipc	ra,0x0
    800035c2:	a68080e7          	jalr	-1432(ra) # 80003026 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035c6:	0485                	addi	s1,s1,1
    800035c8:	00ca2703          	lw	a4,12(s4)
    800035cc:	0004879b          	sext.w	a5,s1
    800035d0:	fce7e1e3          	bltu	a5,a4,80003592 <ialloc+0x32>
  panic("ialloc: no inodes");
    800035d4:	00005517          	auipc	a0,0x5
    800035d8:	35c50513          	addi	a0,a0,860 # 80008930 <userret+0x8a0>
    800035dc:	ffffd097          	auipc	ra,0xffffd
    800035e0:	f7e080e7          	jalr	-130(ra) # 8000055a <panic>
      memset(dip, 0, sizeof(*dip));
    800035e4:	04000613          	li	a2,64
    800035e8:	4581                	li	a1,0
    800035ea:	854e                	mv	a0,s3
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	792080e7          	jalr	1938(ra) # 80000d7e <memset>
      dip->type = type;
    800035f4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800035f8:	854a                	mv	a0,s2
    800035fa:	00001097          	auipc	ra,0x1
    800035fe:	d2e080e7          	jalr	-722(ra) # 80004328 <log_write>
      brelse(bp);
    80003602:	854a                	mv	a0,s2
    80003604:	00000097          	auipc	ra,0x0
    80003608:	a22080e7          	jalr	-1502(ra) # 80003026 <brelse>
      return iget(dev, inum);
    8000360c:	85da                	mv	a1,s6
    8000360e:	8556                	mv	a0,s5
    80003610:	00000097          	auipc	ra,0x0
    80003614:	db4080e7          	jalr	-588(ra) # 800033c4 <iget>
}
    80003618:	60a6                	ld	ra,72(sp)
    8000361a:	6406                	ld	s0,64(sp)
    8000361c:	74e2                	ld	s1,56(sp)
    8000361e:	7942                	ld	s2,48(sp)
    80003620:	79a2                	ld	s3,40(sp)
    80003622:	7a02                	ld	s4,32(sp)
    80003624:	6ae2                	ld	s5,24(sp)
    80003626:	6b42                	ld	s6,16(sp)
    80003628:	6ba2                	ld	s7,8(sp)
    8000362a:	6161                	addi	sp,sp,80
    8000362c:	8082                	ret

000000008000362e <iupdate>:
{
    8000362e:	1101                	addi	sp,sp,-32
    80003630:	ec06                	sd	ra,24(sp)
    80003632:	e822                	sd	s0,16(sp)
    80003634:	e426                	sd	s1,8(sp)
    80003636:	e04a                	sd	s2,0(sp)
    80003638:	1000                	addi	s0,sp,32
    8000363a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000363c:	415c                	lw	a5,4(a0)
    8000363e:	0047d79b          	srliw	a5,a5,0x4
    80003642:	0001b597          	auipc	a1,0x1b
    80003646:	c765a583          	lw	a1,-906(a1) # 8001e2b8 <sb+0x18>
    8000364a:	9dbd                	addw	a1,a1,a5
    8000364c:	4108                	lw	a0,0(a0)
    8000364e:	00000097          	auipc	ra,0x0
    80003652:	8a4080e7          	jalr	-1884(ra) # 80002ef2 <bread>
    80003656:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003658:	06050793          	addi	a5,a0,96
    8000365c:	40c8                	lw	a0,4(s1)
    8000365e:	893d                	andi	a0,a0,15
    80003660:	051a                	slli	a0,a0,0x6
    80003662:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003664:	04c49703          	lh	a4,76(s1)
    80003668:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000366c:	04e49703          	lh	a4,78(s1)
    80003670:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003674:	05049703          	lh	a4,80(s1)
    80003678:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000367c:	05249703          	lh	a4,82(s1)
    80003680:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003684:	48f8                	lw	a4,84(s1)
    80003686:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003688:	03400613          	li	a2,52
    8000368c:	05848593          	addi	a1,s1,88
    80003690:	0531                	addi	a0,a0,12
    80003692:	ffffd097          	auipc	ra,0xffffd
    80003696:	74c080e7          	jalr	1868(ra) # 80000dde <memmove>
  log_write(bp);
    8000369a:	854a                	mv	a0,s2
    8000369c:	00001097          	auipc	ra,0x1
    800036a0:	c8c080e7          	jalr	-884(ra) # 80004328 <log_write>
  brelse(bp);
    800036a4:	854a                	mv	a0,s2
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	980080e7          	jalr	-1664(ra) # 80003026 <brelse>
}
    800036ae:	60e2                	ld	ra,24(sp)
    800036b0:	6442                	ld	s0,16(sp)
    800036b2:	64a2                	ld	s1,8(sp)
    800036b4:	6902                	ld	s2,0(sp)
    800036b6:	6105                	addi	sp,sp,32
    800036b8:	8082                	ret

00000000800036ba <idup>:
{
    800036ba:	1101                	addi	sp,sp,-32
    800036bc:	ec06                	sd	ra,24(sp)
    800036be:	e822                	sd	s0,16(sp)
    800036c0:	e426                	sd	s1,8(sp)
    800036c2:	1000                	addi	s0,sp,32
    800036c4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800036c6:	0001b517          	auipc	a0,0x1b
    800036ca:	bfa50513          	addi	a0,a0,-1030 # 8001e2c0 <icache>
    800036ce:	ffffd097          	auipc	ra,0xffffd
    800036d2:	3e2080e7          	jalr	994(ra) # 80000ab0 <acquire>
  ip->ref++;
    800036d6:	449c                	lw	a5,8(s1)
    800036d8:	2785                	addiw	a5,a5,1
    800036da:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800036dc:	0001b517          	auipc	a0,0x1b
    800036e0:	be450513          	addi	a0,a0,-1052 # 8001e2c0 <icache>
    800036e4:	ffffd097          	auipc	ra,0xffffd
    800036e8:	49c080e7          	jalr	1180(ra) # 80000b80 <release>
}
    800036ec:	8526                	mv	a0,s1
    800036ee:	60e2                	ld	ra,24(sp)
    800036f0:	6442                	ld	s0,16(sp)
    800036f2:	64a2                	ld	s1,8(sp)
    800036f4:	6105                	addi	sp,sp,32
    800036f6:	8082                	ret

00000000800036f8 <ilock>:
{
    800036f8:	1101                	addi	sp,sp,-32
    800036fa:	ec06                	sd	ra,24(sp)
    800036fc:	e822                	sd	s0,16(sp)
    800036fe:	e426                	sd	s1,8(sp)
    80003700:	e04a                	sd	s2,0(sp)
    80003702:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003704:	c115                	beqz	a0,80003728 <ilock+0x30>
    80003706:	84aa                	mv	s1,a0
    80003708:	451c                	lw	a5,8(a0)
    8000370a:	00f05f63          	blez	a5,80003728 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000370e:	0541                	addi	a0,a0,16
    80003710:	00001097          	auipc	ra,0x1
    80003714:	d92080e7          	jalr	-622(ra) # 800044a2 <acquiresleep>
  if(ip->valid == 0){
    80003718:	44bc                	lw	a5,72(s1)
    8000371a:	cf99                	beqz	a5,80003738 <ilock+0x40>
}
    8000371c:	60e2                	ld	ra,24(sp)
    8000371e:	6442                	ld	s0,16(sp)
    80003720:	64a2                	ld	s1,8(sp)
    80003722:	6902                	ld	s2,0(sp)
    80003724:	6105                	addi	sp,sp,32
    80003726:	8082                	ret
    panic("ilock");
    80003728:	00005517          	auipc	a0,0x5
    8000372c:	22050513          	addi	a0,a0,544 # 80008948 <userret+0x8b8>
    80003730:	ffffd097          	auipc	ra,0xffffd
    80003734:	e2a080e7          	jalr	-470(ra) # 8000055a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003738:	40dc                	lw	a5,4(s1)
    8000373a:	0047d79b          	srliw	a5,a5,0x4
    8000373e:	0001b597          	auipc	a1,0x1b
    80003742:	b7a5a583          	lw	a1,-1158(a1) # 8001e2b8 <sb+0x18>
    80003746:	9dbd                	addw	a1,a1,a5
    80003748:	4088                	lw	a0,0(s1)
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	7a8080e7          	jalr	1960(ra) # 80002ef2 <bread>
    80003752:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003754:	06050593          	addi	a1,a0,96
    80003758:	40dc                	lw	a5,4(s1)
    8000375a:	8bbd                	andi	a5,a5,15
    8000375c:	079a                	slli	a5,a5,0x6
    8000375e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003760:	00059783          	lh	a5,0(a1)
    80003764:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80003768:	00259783          	lh	a5,2(a1)
    8000376c:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80003770:	00459783          	lh	a5,4(a1)
    80003774:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80003778:	00659783          	lh	a5,6(a1)
    8000377c:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80003780:	459c                	lw	a5,8(a1)
    80003782:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003784:	03400613          	li	a2,52
    80003788:	05b1                	addi	a1,a1,12
    8000378a:	05848513          	addi	a0,s1,88
    8000378e:	ffffd097          	auipc	ra,0xffffd
    80003792:	650080e7          	jalr	1616(ra) # 80000dde <memmove>
    brelse(bp);
    80003796:	854a                	mv	a0,s2
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	88e080e7          	jalr	-1906(ra) # 80003026 <brelse>
    ip->valid = 1;
    800037a0:	4785                	li	a5,1
    800037a2:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    800037a4:	04c49783          	lh	a5,76(s1)
    800037a8:	fbb5                	bnez	a5,8000371c <ilock+0x24>
      panic("ilock: no type");
    800037aa:	00005517          	auipc	a0,0x5
    800037ae:	1a650513          	addi	a0,a0,422 # 80008950 <userret+0x8c0>
    800037b2:	ffffd097          	auipc	ra,0xffffd
    800037b6:	da8080e7          	jalr	-600(ra) # 8000055a <panic>

00000000800037ba <iunlock>:
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037c6:	c905                	beqz	a0,800037f6 <iunlock+0x3c>
    800037c8:	84aa                	mv	s1,a0
    800037ca:	01050913          	addi	s2,a0,16
    800037ce:	854a                	mv	a0,s2
    800037d0:	00001097          	auipc	ra,0x1
    800037d4:	d6c080e7          	jalr	-660(ra) # 8000453c <holdingsleep>
    800037d8:	cd19                	beqz	a0,800037f6 <iunlock+0x3c>
    800037da:	449c                	lw	a5,8(s1)
    800037dc:	00f05d63          	blez	a5,800037f6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037e0:	854a                	mv	a0,s2
    800037e2:	00001097          	auipc	ra,0x1
    800037e6:	d16080e7          	jalr	-746(ra) # 800044f8 <releasesleep>
}
    800037ea:	60e2                	ld	ra,24(sp)
    800037ec:	6442                	ld	s0,16(sp)
    800037ee:	64a2                	ld	s1,8(sp)
    800037f0:	6902                	ld	s2,0(sp)
    800037f2:	6105                	addi	sp,sp,32
    800037f4:	8082                	ret
    panic("iunlock");
    800037f6:	00005517          	auipc	a0,0x5
    800037fa:	16a50513          	addi	a0,a0,362 # 80008960 <userret+0x8d0>
    800037fe:	ffffd097          	auipc	ra,0xffffd
    80003802:	d5c080e7          	jalr	-676(ra) # 8000055a <panic>

0000000080003806 <iput>:
{
    80003806:	7139                	addi	sp,sp,-64
    80003808:	fc06                	sd	ra,56(sp)
    8000380a:	f822                	sd	s0,48(sp)
    8000380c:	f426                	sd	s1,40(sp)
    8000380e:	f04a                	sd	s2,32(sp)
    80003810:	ec4e                	sd	s3,24(sp)
    80003812:	e852                	sd	s4,16(sp)
    80003814:	e456                	sd	s5,8(sp)
    80003816:	0080                	addi	s0,sp,64
    80003818:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000381a:	0001b517          	auipc	a0,0x1b
    8000381e:	aa650513          	addi	a0,a0,-1370 # 8001e2c0 <icache>
    80003822:	ffffd097          	auipc	ra,0xffffd
    80003826:	28e080e7          	jalr	654(ra) # 80000ab0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000382a:	4498                	lw	a4,8(s1)
    8000382c:	4785                	li	a5,1
    8000382e:	02f70663          	beq	a4,a5,8000385a <iput+0x54>
  ip->ref--;
    80003832:	449c                	lw	a5,8(s1)
    80003834:	37fd                	addiw	a5,a5,-1
    80003836:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003838:	0001b517          	auipc	a0,0x1b
    8000383c:	a8850513          	addi	a0,a0,-1400 # 8001e2c0 <icache>
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	340080e7          	jalr	832(ra) # 80000b80 <release>
}
    80003848:	70e2                	ld	ra,56(sp)
    8000384a:	7442                	ld	s0,48(sp)
    8000384c:	74a2                	ld	s1,40(sp)
    8000384e:	7902                	ld	s2,32(sp)
    80003850:	69e2                	ld	s3,24(sp)
    80003852:	6a42                	ld	s4,16(sp)
    80003854:	6aa2                	ld	s5,8(sp)
    80003856:	6121                	addi	sp,sp,64
    80003858:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000385a:	44bc                	lw	a5,72(s1)
    8000385c:	dbf9                	beqz	a5,80003832 <iput+0x2c>
    8000385e:	05249783          	lh	a5,82(s1)
    80003862:	fbe1                	bnez	a5,80003832 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003864:	01048a13          	addi	s4,s1,16
    80003868:	8552                	mv	a0,s4
    8000386a:	00001097          	auipc	ra,0x1
    8000386e:	c38080e7          	jalr	-968(ra) # 800044a2 <acquiresleep>
    release(&icache.lock);
    80003872:	0001b517          	auipc	a0,0x1b
    80003876:	a4e50513          	addi	a0,a0,-1458 # 8001e2c0 <icache>
    8000387a:	ffffd097          	auipc	ra,0xffffd
    8000387e:	306080e7          	jalr	774(ra) # 80000b80 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003882:	05848913          	addi	s2,s1,88
    80003886:	08848993          	addi	s3,s1,136
    8000388a:	a819                	j	800038a0 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    8000388c:	4088                	lw	a0,0(s1)
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	8ae080e7          	jalr	-1874(ra) # 8000313c <bfree>
      ip->addrs[i] = 0;
    80003896:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    8000389a:	0911                	addi	s2,s2,4
    8000389c:	01390663          	beq	s2,s3,800038a8 <iput+0xa2>
    if(ip->addrs[i]){
    800038a0:	00092583          	lw	a1,0(s2)
    800038a4:	d9fd                	beqz	a1,8000389a <iput+0x94>
    800038a6:	b7dd                	j	8000388c <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038a8:	0884a583          	lw	a1,136(s1)
    800038ac:	ed9d                	bnez	a1,800038ea <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038ae:	0404aa23          	sw	zero,84(s1)
  iupdate(ip);
    800038b2:	8526                	mv	a0,s1
    800038b4:	00000097          	auipc	ra,0x0
    800038b8:	d7a080e7          	jalr	-646(ra) # 8000362e <iupdate>
    ip->type = 0;
    800038bc:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    800038c0:	8526                	mv	a0,s1
    800038c2:	00000097          	auipc	ra,0x0
    800038c6:	d6c080e7          	jalr	-660(ra) # 8000362e <iupdate>
    ip->valid = 0;
    800038ca:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    800038ce:	8552                	mv	a0,s4
    800038d0:	00001097          	auipc	ra,0x1
    800038d4:	c28080e7          	jalr	-984(ra) # 800044f8 <releasesleep>
    acquire(&icache.lock);
    800038d8:	0001b517          	auipc	a0,0x1b
    800038dc:	9e850513          	addi	a0,a0,-1560 # 8001e2c0 <icache>
    800038e0:	ffffd097          	auipc	ra,0xffffd
    800038e4:	1d0080e7          	jalr	464(ra) # 80000ab0 <acquire>
    800038e8:	b7a9                	j	80003832 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038ea:	4088                	lw	a0,0(s1)
    800038ec:	fffff097          	auipc	ra,0xfffff
    800038f0:	606080e7          	jalr	1542(ra) # 80002ef2 <bread>
    800038f4:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    800038f6:	06050913          	addi	s2,a0,96
    800038fa:	46050993          	addi	s3,a0,1120
    800038fe:	a809                	j	80003910 <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003900:	4088                	lw	a0,0(s1)
    80003902:	00000097          	auipc	ra,0x0
    80003906:	83a080e7          	jalr	-1990(ra) # 8000313c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000390a:	0911                	addi	s2,s2,4
    8000390c:	01390663          	beq	s2,s3,80003918 <iput+0x112>
      if(a[j])
    80003910:	00092583          	lw	a1,0(s2)
    80003914:	d9fd                	beqz	a1,8000390a <iput+0x104>
    80003916:	b7ed                	j	80003900 <iput+0xfa>
    brelse(bp);
    80003918:	8556                	mv	a0,s5
    8000391a:	fffff097          	auipc	ra,0xfffff
    8000391e:	70c080e7          	jalr	1804(ra) # 80003026 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003922:	0884a583          	lw	a1,136(s1)
    80003926:	4088                	lw	a0,0(s1)
    80003928:	00000097          	auipc	ra,0x0
    8000392c:	814080e7          	jalr	-2028(ra) # 8000313c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003930:	0804a423          	sw	zero,136(s1)
    80003934:	bfad                	j	800038ae <iput+0xa8>

0000000080003936 <iunlockput>:
{
    80003936:	1101                	addi	sp,sp,-32
    80003938:	ec06                	sd	ra,24(sp)
    8000393a:	e822                	sd	s0,16(sp)
    8000393c:	e426                	sd	s1,8(sp)
    8000393e:	1000                	addi	s0,sp,32
    80003940:	84aa                	mv	s1,a0
  iunlock(ip);
    80003942:	00000097          	auipc	ra,0x0
    80003946:	e78080e7          	jalr	-392(ra) # 800037ba <iunlock>
  iput(ip);
    8000394a:	8526                	mv	a0,s1
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	eba080e7          	jalr	-326(ra) # 80003806 <iput>
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6105                	addi	sp,sp,32
    8000395c:	8082                	ret

000000008000395e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000395e:	1141                	addi	sp,sp,-16
    80003960:	e422                	sd	s0,8(sp)
    80003962:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003964:	411c                	lw	a5,0(a0)
    80003966:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003968:	415c                	lw	a5,4(a0)
    8000396a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000396c:	04c51783          	lh	a5,76(a0)
    80003970:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003974:	05251783          	lh	a5,82(a0)
    80003978:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000397c:	05456783          	lwu	a5,84(a0)
    80003980:	e99c                	sd	a5,16(a1)
}
    80003982:	6422                	ld	s0,8(sp)
    80003984:	0141                	addi	sp,sp,16
    80003986:	8082                	ret

0000000080003988 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003988:	497c                	lw	a5,84(a0)
    8000398a:	0ed7e563          	bltu	a5,a3,80003a74 <readi+0xec>
{
    8000398e:	7159                	addi	sp,sp,-112
    80003990:	f486                	sd	ra,104(sp)
    80003992:	f0a2                	sd	s0,96(sp)
    80003994:	eca6                	sd	s1,88(sp)
    80003996:	e8ca                	sd	s2,80(sp)
    80003998:	e4ce                	sd	s3,72(sp)
    8000399a:	e0d2                	sd	s4,64(sp)
    8000399c:	fc56                	sd	s5,56(sp)
    8000399e:	f85a                	sd	s6,48(sp)
    800039a0:	f45e                	sd	s7,40(sp)
    800039a2:	f062                	sd	s8,32(sp)
    800039a4:	ec66                	sd	s9,24(sp)
    800039a6:	e86a                	sd	s10,16(sp)
    800039a8:	e46e                	sd	s11,8(sp)
    800039aa:	1880                	addi	s0,sp,112
    800039ac:	8baa                	mv	s7,a0
    800039ae:	8c2e                	mv	s8,a1
    800039b0:	8ab2                	mv	s5,a2
    800039b2:	8936                	mv	s2,a3
    800039b4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039b6:	9f35                	addw	a4,a4,a3
    800039b8:	0cd76063          	bltu	a4,a3,80003a78 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    800039bc:	00e7f463          	bgeu	a5,a4,800039c4 <readi+0x3c>
    n = ip->size - off;
    800039c0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039c4:	080b0763          	beqz	s6,80003a52 <readi+0xca>
    800039c8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039ca:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039ce:	5cfd                	li	s9,-1
    800039d0:	a82d                	j	80003a0a <readi+0x82>
    800039d2:	02099d93          	slli	s11,s3,0x20
    800039d6:	020ddd93          	srli	s11,s11,0x20
    800039da:	06048613          	addi	a2,s1,96
    800039de:	86ee                	mv	a3,s11
    800039e0:	963a                	add	a2,a2,a4
    800039e2:	85d6                	mv	a1,s5
    800039e4:	8562                	mv	a0,s8
    800039e6:	fffff097          	auipc	ra,0xfffff
    800039ea:	aa2080e7          	jalr	-1374(ra) # 80002488 <either_copyout>
    800039ee:	05950d63          	beq	a0,s9,80003a48 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    800039f2:	8526                	mv	a0,s1
    800039f4:	fffff097          	auipc	ra,0xfffff
    800039f8:	632080e7          	jalr	1586(ra) # 80003026 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039fc:	01498a3b          	addw	s4,s3,s4
    80003a00:	0129893b          	addw	s2,s3,s2
    80003a04:	9aee                	add	s5,s5,s11
    80003a06:	056a7663          	bgeu	s4,s6,80003a52 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a0a:	000ba483          	lw	s1,0(s7)
    80003a0e:	00a9559b          	srliw	a1,s2,0xa
    80003a12:	855e                	mv	a0,s7
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	8d6080e7          	jalr	-1834(ra) # 800032ea <bmap>
    80003a1c:	0005059b          	sext.w	a1,a0
    80003a20:	8526                	mv	a0,s1
    80003a22:	fffff097          	auipc	ra,0xfffff
    80003a26:	4d0080e7          	jalr	1232(ra) # 80002ef2 <bread>
    80003a2a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a2c:	3ff97713          	andi	a4,s2,1023
    80003a30:	40ed07bb          	subw	a5,s10,a4
    80003a34:	414b06bb          	subw	a3,s6,s4
    80003a38:	89be                	mv	s3,a5
    80003a3a:	2781                	sext.w	a5,a5
    80003a3c:	0006861b          	sext.w	a2,a3
    80003a40:	f8f679e3          	bgeu	a2,a5,800039d2 <readi+0x4a>
    80003a44:	89b6                	mv	s3,a3
    80003a46:	b771                	j	800039d2 <readi+0x4a>
      brelse(bp);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	fffff097          	auipc	ra,0xfffff
    80003a4e:	5dc080e7          	jalr	1500(ra) # 80003026 <brelse>
  }
  return n;
    80003a52:	000b051b          	sext.w	a0,s6
}
    80003a56:	70a6                	ld	ra,104(sp)
    80003a58:	7406                	ld	s0,96(sp)
    80003a5a:	64e6                	ld	s1,88(sp)
    80003a5c:	6946                	ld	s2,80(sp)
    80003a5e:	69a6                	ld	s3,72(sp)
    80003a60:	6a06                	ld	s4,64(sp)
    80003a62:	7ae2                	ld	s5,56(sp)
    80003a64:	7b42                	ld	s6,48(sp)
    80003a66:	7ba2                	ld	s7,40(sp)
    80003a68:	7c02                	ld	s8,32(sp)
    80003a6a:	6ce2                	ld	s9,24(sp)
    80003a6c:	6d42                	ld	s10,16(sp)
    80003a6e:	6da2                	ld	s11,8(sp)
    80003a70:	6165                	addi	sp,sp,112
    80003a72:	8082                	ret
    return -1;
    80003a74:	557d                	li	a0,-1
}
    80003a76:	8082                	ret
    return -1;
    80003a78:	557d                	li	a0,-1
    80003a7a:	bff1                	j	80003a56 <readi+0xce>

0000000080003a7c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a7c:	497c                	lw	a5,84(a0)
    80003a7e:	10d7e663          	bltu	a5,a3,80003b8a <writei+0x10e>
{
    80003a82:	7159                	addi	sp,sp,-112
    80003a84:	f486                	sd	ra,104(sp)
    80003a86:	f0a2                	sd	s0,96(sp)
    80003a88:	eca6                	sd	s1,88(sp)
    80003a8a:	e8ca                	sd	s2,80(sp)
    80003a8c:	e4ce                	sd	s3,72(sp)
    80003a8e:	e0d2                	sd	s4,64(sp)
    80003a90:	fc56                	sd	s5,56(sp)
    80003a92:	f85a                	sd	s6,48(sp)
    80003a94:	f45e                	sd	s7,40(sp)
    80003a96:	f062                	sd	s8,32(sp)
    80003a98:	ec66                	sd	s9,24(sp)
    80003a9a:	e86a                	sd	s10,16(sp)
    80003a9c:	e46e                	sd	s11,8(sp)
    80003a9e:	1880                	addi	s0,sp,112
    80003aa0:	8baa                	mv	s7,a0
    80003aa2:	8c2e                	mv	s8,a1
    80003aa4:	8ab2                	mv	s5,a2
    80003aa6:	8936                	mv	s2,a3
    80003aa8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003aaa:	00e687bb          	addw	a5,a3,a4
    80003aae:	0ed7e063          	bltu	a5,a3,80003b8e <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ab2:	00043737          	lui	a4,0x43
    80003ab6:	0cf76e63          	bltu	a4,a5,80003b92 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003aba:	0a0b0763          	beqz	s6,80003b68 <writei+0xec>
    80003abe:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ac0:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ac4:	5cfd                	li	s9,-1
    80003ac6:	a091                	j	80003b0a <writei+0x8e>
    80003ac8:	02099d93          	slli	s11,s3,0x20
    80003acc:	020ddd93          	srli	s11,s11,0x20
    80003ad0:	06048513          	addi	a0,s1,96
    80003ad4:	86ee                	mv	a3,s11
    80003ad6:	8656                	mv	a2,s5
    80003ad8:	85e2                	mv	a1,s8
    80003ada:	953a                	add	a0,a0,a4
    80003adc:	fffff097          	auipc	ra,0xfffff
    80003ae0:	a02080e7          	jalr	-1534(ra) # 800024de <either_copyin>
    80003ae4:	07950263          	beq	a0,s9,80003b48 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ae8:	8526                	mv	a0,s1
    80003aea:	00001097          	auipc	ra,0x1
    80003aee:	83e080e7          	jalr	-1986(ra) # 80004328 <log_write>
    brelse(bp);
    80003af2:	8526                	mv	a0,s1
    80003af4:	fffff097          	auipc	ra,0xfffff
    80003af8:	532080e7          	jalr	1330(ra) # 80003026 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003afc:	01498a3b          	addw	s4,s3,s4
    80003b00:	0129893b          	addw	s2,s3,s2
    80003b04:	9aee                	add	s5,s5,s11
    80003b06:	056a7663          	bgeu	s4,s6,80003b52 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b0a:	000ba483          	lw	s1,0(s7)
    80003b0e:	00a9559b          	srliw	a1,s2,0xa
    80003b12:	855e                	mv	a0,s7
    80003b14:	fffff097          	auipc	ra,0xfffff
    80003b18:	7d6080e7          	jalr	2006(ra) # 800032ea <bmap>
    80003b1c:	0005059b          	sext.w	a1,a0
    80003b20:	8526                	mv	a0,s1
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	3d0080e7          	jalr	976(ra) # 80002ef2 <bread>
    80003b2a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b2c:	3ff97713          	andi	a4,s2,1023
    80003b30:	40ed07bb          	subw	a5,s10,a4
    80003b34:	414b06bb          	subw	a3,s6,s4
    80003b38:	89be                	mv	s3,a5
    80003b3a:	2781                	sext.w	a5,a5
    80003b3c:	0006861b          	sext.w	a2,a3
    80003b40:	f8f674e3          	bgeu	a2,a5,80003ac8 <writei+0x4c>
    80003b44:	89b6                	mv	s3,a3
    80003b46:	b749                	j	80003ac8 <writei+0x4c>
      brelse(bp);
    80003b48:	8526                	mv	a0,s1
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	4dc080e7          	jalr	1244(ra) # 80003026 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003b52:	054ba783          	lw	a5,84(s7)
    80003b56:	0127f463          	bgeu	a5,s2,80003b5e <writei+0xe2>
      ip->size = off;
    80003b5a:	052baa23          	sw	s2,84(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003b5e:	855e                	mv	a0,s7
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	ace080e7          	jalr	-1330(ra) # 8000362e <iupdate>
  }

  return n;
    80003b68:	000b051b          	sext.w	a0,s6
}
    80003b6c:	70a6                	ld	ra,104(sp)
    80003b6e:	7406                	ld	s0,96(sp)
    80003b70:	64e6                	ld	s1,88(sp)
    80003b72:	6946                	ld	s2,80(sp)
    80003b74:	69a6                	ld	s3,72(sp)
    80003b76:	6a06                	ld	s4,64(sp)
    80003b78:	7ae2                	ld	s5,56(sp)
    80003b7a:	7b42                	ld	s6,48(sp)
    80003b7c:	7ba2                	ld	s7,40(sp)
    80003b7e:	7c02                	ld	s8,32(sp)
    80003b80:	6ce2                	ld	s9,24(sp)
    80003b82:	6d42                	ld	s10,16(sp)
    80003b84:	6da2                	ld	s11,8(sp)
    80003b86:	6165                	addi	sp,sp,112
    80003b88:	8082                	ret
    return -1;
    80003b8a:	557d                	li	a0,-1
}
    80003b8c:	8082                	ret
    return -1;
    80003b8e:	557d                	li	a0,-1
    80003b90:	bff1                	j	80003b6c <writei+0xf0>
    return -1;
    80003b92:	557d                	li	a0,-1
    80003b94:	bfe1                	j	80003b6c <writei+0xf0>

0000000080003b96 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003b96:	1141                	addi	sp,sp,-16
    80003b98:	e406                	sd	ra,8(sp)
    80003b9a:	e022                	sd	s0,0(sp)
    80003b9c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003b9e:	4639                	li	a2,14
    80003ba0:	ffffd097          	auipc	ra,0xffffd
    80003ba4:	2ba080e7          	jalr	698(ra) # 80000e5a <strncmp>
}
    80003ba8:	60a2                	ld	ra,8(sp)
    80003baa:	6402                	ld	s0,0(sp)
    80003bac:	0141                	addi	sp,sp,16
    80003bae:	8082                	ret

0000000080003bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003bb0:	7139                	addi	sp,sp,-64
    80003bb2:	fc06                	sd	ra,56(sp)
    80003bb4:	f822                	sd	s0,48(sp)
    80003bb6:	f426                	sd	s1,40(sp)
    80003bb8:	f04a                	sd	s2,32(sp)
    80003bba:	ec4e                	sd	s3,24(sp)
    80003bbc:	e852                	sd	s4,16(sp)
    80003bbe:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003bc0:	04c51703          	lh	a4,76(a0)
    80003bc4:	4785                	li	a5,1
    80003bc6:	00f71a63          	bne	a4,a5,80003bda <dirlookup+0x2a>
    80003bca:	892a                	mv	s2,a0
    80003bcc:	89ae                	mv	s3,a1
    80003bce:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bd0:	497c                	lw	a5,84(a0)
    80003bd2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003bd4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bd6:	e79d                	bnez	a5,80003c04 <dirlookup+0x54>
    80003bd8:	a8a5                	j	80003c50 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003bda:	00005517          	auipc	a0,0x5
    80003bde:	d8e50513          	addi	a0,a0,-626 # 80008968 <userret+0x8d8>
    80003be2:	ffffd097          	auipc	ra,0xffffd
    80003be6:	978080e7          	jalr	-1672(ra) # 8000055a <panic>
      panic("dirlookup read");
    80003bea:	00005517          	auipc	a0,0x5
    80003bee:	d9650513          	addi	a0,a0,-618 # 80008980 <userret+0x8f0>
    80003bf2:	ffffd097          	auipc	ra,0xffffd
    80003bf6:	968080e7          	jalr	-1688(ra) # 8000055a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bfa:	24c1                	addiw	s1,s1,16
    80003bfc:	05492783          	lw	a5,84(s2)
    80003c00:	04f4f763          	bgeu	s1,a5,80003c4e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c04:	4741                	li	a4,16
    80003c06:	86a6                	mv	a3,s1
    80003c08:	fc040613          	addi	a2,s0,-64
    80003c0c:	4581                	li	a1,0
    80003c0e:	854a                	mv	a0,s2
    80003c10:	00000097          	auipc	ra,0x0
    80003c14:	d78080e7          	jalr	-648(ra) # 80003988 <readi>
    80003c18:	47c1                	li	a5,16
    80003c1a:	fcf518e3          	bne	a0,a5,80003bea <dirlookup+0x3a>
    if(de.inum == 0)
    80003c1e:	fc045783          	lhu	a5,-64(s0)
    80003c22:	dfe1                	beqz	a5,80003bfa <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c24:	fc240593          	addi	a1,s0,-62
    80003c28:	854e                	mv	a0,s3
    80003c2a:	00000097          	auipc	ra,0x0
    80003c2e:	f6c080e7          	jalr	-148(ra) # 80003b96 <namecmp>
    80003c32:	f561                	bnez	a0,80003bfa <dirlookup+0x4a>
      if(poff)
    80003c34:	000a0463          	beqz	s4,80003c3c <dirlookup+0x8c>
        *poff = off;
    80003c38:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c3c:	fc045583          	lhu	a1,-64(s0)
    80003c40:	00092503          	lw	a0,0(s2)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	780080e7          	jalr	1920(ra) # 800033c4 <iget>
    80003c4c:	a011                	j	80003c50 <dirlookup+0xa0>
  return 0;
    80003c4e:	4501                	li	a0,0
}
    80003c50:	70e2                	ld	ra,56(sp)
    80003c52:	7442                	ld	s0,48(sp)
    80003c54:	74a2                	ld	s1,40(sp)
    80003c56:	7902                	ld	s2,32(sp)
    80003c58:	69e2                	ld	s3,24(sp)
    80003c5a:	6a42                	ld	s4,16(sp)
    80003c5c:	6121                	addi	sp,sp,64
    80003c5e:	8082                	ret

0000000080003c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c60:	711d                	addi	sp,sp,-96
    80003c62:	ec86                	sd	ra,88(sp)
    80003c64:	e8a2                	sd	s0,80(sp)
    80003c66:	e4a6                	sd	s1,72(sp)
    80003c68:	e0ca                	sd	s2,64(sp)
    80003c6a:	fc4e                	sd	s3,56(sp)
    80003c6c:	f852                	sd	s4,48(sp)
    80003c6e:	f456                	sd	s5,40(sp)
    80003c70:	f05a                	sd	s6,32(sp)
    80003c72:	ec5e                	sd	s7,24(sp)
    80003c74:	e862                	sd	s8,16(sp)
    80003c76:	e466                	sd	s9,8(sp)
    80003c78:	1080                	addi	s0,sp,96
    80003c7a:	84aa                	mv	s1,a0
    80003c7c:	8b2e                	mv	s6,a1
    80003c7e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003c80:	00054703          	lbu	a4,0(a0)
    80003c84:	02f00793          	li	a5,47
    80003c88:	02f70363          	beq	a4,a5,80003cae <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c8c:	ffffe097          	auipc	ra,0xffffe
    80003c90:	dde080e7          	jalr	-546(ra) # 80001a6a <myproc>
    80003c94:	15853503          	ld	a0,344(a0)
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	a22080e7          	jalr	-1502(ra) # 800036ba <idup>
    80003ca0:	89aa                	mv	s3,a0
  while(*path == '/')
    80003ca2:	02f00913          	li	s2,47
  len = path - s;
    80003ca6:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003ca8:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003caa:	4c05                	li	s8,1
    80003cac:	a865                	j	80003d64 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003cae:	4585                	li	a1,1
    80003cb0:	4501                	li	a0,0
    80003cb2:	fffff097          	auipc	ra,0xfffff
    80003cb6:	712080e7          	jalr	1810(ra) # 800033c4 <iget>
    80003cba:	89aa                	mv	s3,a0
    80003cbc:	b7dd                	j	80003ca2 <namex+0x42>
      iunlockput(ip);
    80003cbe:	854e                	mv	a0,s3
    80003cc0:	00000097          	auipc	ra,0x0
    80003cc4:	c76080e7          	jalr	-906(ra) # 80003936 <iunlockput>
      return 0;
    80003cc8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003cca:	854e                	mv	a0,s3
    80003ccc:	60e6                	ld	ra,88(sp)
    80003cce:	6446                	ld	s0,80(sp)
    80003cd0:	64a6                	ld	s1,72(sp)
    80003cd2:	6906                	ld	s2,64(sp)
    80003cd4:	79e2                	ld	s3,56(sp)
    80003cd6:	7a42                	ld	s4,48(sp)
    80003cd8:	7aa2                	ld	s5,40(sp)
    80003cda:	7b02                	ld	s6,32(sp)
    80003cdc:	6be2                	ld	s7,24(sp)
    80003cde:	6c42                	ld	s8,16(sp)
    80003ce0:	6ca2                	ld	s9,8(sp)
    80003ce2:	6125                	addi	sp,sp,96
    80003ce4:	8082                	ret
      iunlock(ip);
    80003ce6:	854e                	mv	a0,s3
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	ad2080e7          	jalr	-1326(ra) # 800037ba <iunlock>
      return ip;
    80003cf0:	bfe9                	j	80003cca <namex+0x6a>
      iunlockput(ip);
    80003cf2:	854e                	mv	a0,s3
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	c42080e7          	jalr	-958(ra) # 80003936 <iunlockput>
      return 0;
    80003cfc:	89d2                	mv	s3,s4
    80003cfe:	b7f1                	j	80003cca <namex+0x6a>
  len = path - s;
    80003d00:	40b48633          	sub	a2,s1,a1
    80003d04:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003d08:	094cd463          	bge	s9,s4,80003d90 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d0c:	4639                	li	a2,14
    80003d0e:	8556                	mv	a0,s5
    80003d10:	ffffd097          	auipc	ra,0xffffd
    80003d14:	0ce080e7          	jalr	206(ra) # 80000dde <memmove>
  while(*path == '/')
    80003d18:	0004c783          	lbu	a5,0(s1)
    80003d1c:	01279763          	bne	a5,s2,80003d2a <namex+0xca>
    path++;
    80003d20:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d22:	0004c783          	lbu	a5,0(s1)
    80003d26:	ff278de3          	beq	a5,s2,80003d20 <namex+0xc0>
    ilock(ip);
    80003d2a:	854e                	mv	a0,s3
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	9cc080e7          	jalr	-1588(ra) # 800036f8 <ilock>
    if(ip->type != T_DIR){
    80003d34:	04c99783          	lh	a5,76(s3)
    80003d38:	f98793e3          	bne	a5,s8,80003cbe <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d3c:	000b0563          	beqz	s6,80003d46 <namex+0xe6>
    80003d40:	0004c783          	lbu	a5,0(s1)
    80003d44:	d3cd                	beqz	a5,80003ce6 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d46:	865e                	mv	a2,s7
    80003d48:	85d6                	mv	a1,s5
    80003d4a:	854e                	mv	a0,s3
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	e64080e7          	jalr	-412(ra) # 80003bb0 <dirlookup>
    80003d54:	8a2a                	mv	s4,a0
    80003d56:	dd51                	beqz	a0,80003cf2 <namex+0x92>
    iunlockput(ip);
    80003d58:	854e                	mv	a0,s3
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	bdc080e7          	jalr	-1060(ra) # 80003936 <iunlockput>
    ip = next;
    80003d62:	89d2                	mv	s3,s4
  while(*path == '/')
    80003d64:	0004c783          	lbu	a5,0(s1)
    80003d68:	05279763          	bne	a5,s2,80003db6 <namex+0x156>
    path++;
    80003d6c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d6e:	0004c783          	lbu	a5,0(s1)
    80003d72:	ff278de3          	beq	a5,s2,80003d6c <namex+0x10c>
  if(*path == 0)
    80003d76:	c79d                	beqz	a5,80003da4 <namex+0x144>
    path++;
    80003d78:	85a6                	mv	a1,s1
  len = path - s;
    80003d7a:	8a5e                	mv	s4,s7
    80003d7c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003d7e:	01278963          	beq	a5,s2,80003d90 <namex+0x130>
    80003d82:	dfbd                	beqz	a5,80003d00 <namex+0xa0>
    path++;
    80003d84:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003d86:	0004c783          	lbu	a5,0(s1)
    80003d8a:	ff279ce3          	bne	a5,s2,80003d82 <namex+0x122>
    80003d8e:	bf8d                	j	80003d00 <namex+0xa0>
    memmove(name, s, len);
    80003d90:	2601                	sext.w	a2,a2
    80003d92:	8556                	mv	a0,s5
    80003d94:	ffffd097          	auipc	ra,0xffffd
    80003d98:	04a080e7          	jalr	74(ra) # 80000dde <memmove>
    name[len] = 0;
    80003d9c:	9a56                	add	s4,s4,s5
    80003d9e:	000a0023          	sb	zero,0(s4)
    80003da2:	bf9d                	j	80003d18 <namex+0xb8>
  if(nameiparent){
    80003da4:	f20b03e3          	beqz	s6,80003cca <namex+0x6a>
    iput(ip);
    80003da8:	854e                	mv	a0,s3
    80003daa:	00000097          	auipc	ra,0x0
    80003dae:	a5c080e7          	jalr	-1444(ra) # 80003806 <iput>
    return 0;
    80003db2:	4981                	li	s3,0
    80003db4:	bf19                	j	80003cca <namex+0x6a>
  if(*path == 0)
    80003db6:	d7fd                	beqz	a5,80003da4 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003db8:	0004c783          	lbu	a5,0(s1)
    80003dbc:	85a6                	mv	a1,s1
    80003dbe:	b7d1                	j	80003d82 <namex+0x122>

0000000080003dc0 <dirlink>:
{
    80003dc0:	7139                	addi	sp,sp,-64
    80003dc2:	fc06                	sd	ra,56(sp)
    80003dc4:	f822                	sd	s0,48(sp)
    80003dc6:	f426                	sd	s1,40(sp)
    80003dc8:	f04a                	sd	s2,32(sp)
    80003dca:	ec4e                	sd	s3,24(sp)
    80003dcc:	e852                	sd	s4,16(sp)
    80003dce:	0080                	addi	s0,sp,64
    80003dd0:	892a                	mv	s2,a0
    80003dd2:	8a2e                	mv	s4,a1
    80003dd4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003dd6:	4601                	li	a2,0
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	dd8080e7          	jalr	-552(ra) # 80003bb0 <dirlookup>
    80003de0:	e93d                	bnez	a0,80003e56 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003de2:	05492483          	lw	s1,84(s2)
    80003de6:	c49d                	beqz	s1,80003e14 <dirlink+0x54>
    80003de8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dea:	4741                	li	a4,16
    80003dec:	86a6                	mv	a3,s1
    80003dee:	fc040613          	addi	a2,s0,-64
    80003df2:	4581                	li	a1,0
    80003df4:	854a                	mv	a0,s2
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	b92080e7          	jalr	-1134(ra) # 80003988 <readi>
    80003dfe:	47c1                	li	a5,16
    80003e00:	06f51163          	bne	a0,a5,80003e62 <dirlink+0xa2>
    if(de.inum == 0)
    80003e04:	fc045783          	lhu	a5,-64(s0)
    80003e08:	c791                	beqz	a5,80003e14 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e0a:	24c1                	addiw	s1,s1,16
    80003e0c:	05492783          	lw	a5,84(s2)
    80003e10:	fcf4ede3          	bltu	s1,a5,80003dea <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e14:	4639                	li	a2,14
    80003e16:	85d2                	mv	a1,s4
    80003e18:	fc240513          	addi	a0,s0,-62
    80003e1c:	ffffd097          	auipc	ra,0xffffd
    80003e20:	07a080e7          	jalr	122(ra) # 80000e96 <strncpy>
  de.inum = inum;
    80003e24:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e28:	4741                	li	a4,16
    80003e2a:	86a6                	mv	a3,s1
    80003e2c:	fc040613          	addi	a2,s0,-64
    80003e30:	4581                	li	a1,0
    80003e32:	854a                	mv	a0,s2
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	c48080e7          	jalr	-952(ra) # 80003a7c <writei>
    80003e3c:	872a                	mv	a4,a0
    80003e3e:	47c1                	li	a5,16
  return 0;
    80003e40:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e42:	02f71863          	bne	a4,a5,80003e72 <dirlink+0xb2>
}
    80003e46:	70e2                	ld	ra,56(sp)
    80003e48:	7442                	ld	s0,48(sp)
    80003e4a:	74a2                	ld	s1,40(sp)
    80003e4c:	7902                	ld	s2,32(sp)
    80003e4e:	69e2                	ld	s3,24(sp)
    80003e50:	6a42                	ld	s4,16(sp)
    80003e52:	6121                	addi	sp,sp,64
    80003e54:	8082                	ret
    iput(ip);
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	9b0080e7          	jalr	-1616(ra) # 80003806 <iput>
    return -1;
    80003e5e:	557d                	li	a0,-1
    80003e60:	b7dd                	j	80003e46 <dirlink+0x86>
      panic("dirlink read");
    80003e62:	00005517          	auipc	a0,0x5
    80003e66:	b2e50513          	addi	a0,a0,-1234 # 80008990 <userret+0x900>
    80003e6a:	ffffc097          	auipc	ra,0xffffc
    80003e6e:	6f0080e7          	jalr	1776(ra) # 8000055a <panic>
    panic("dirlink");
    80003e72:	00005517          	auipc	a0,0x5
    80003e76:	c3e50513          	addi	a0,a0,-962 # 80008ab0 <userret+0xa20>
    80003e7a:	ffffc097          	auipc	ra,0xffffc
    80003e7e:	6e0080e7          	jalr	1760(ra) # 8000055a <panic>

0000000080003e82 <namei>:

struct inode*
namei(char *path)
{
    80003e82:	1101                	addi	sp,sp,-32
    80003e84:	ec06                	sd	ra,24(sp)
    80003e86:	e822                	sd	s0,16(sp)
    80003e88:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003e8a:	fe040613          	addi	a2,s0,-32
    80003e8e:	4581                	li	a1,0
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	dd0080e7          	jalr	-560(ra) # 80003c60 <namex>
}
    80003e98:	60e2                	ld	ra,24(sp)
    80003e9a:	6442                	ld	s0,16(sp)
    80003e9c:	6105                	addi	sp,sp,32
    80003e9e:	8082                	ret

0000000080003ea0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003ea0:	1141                	addi	sp,sp,-16
    80003ea2:	e406                	sd	ra,8(sp)
    80003ea4:	e022                	sd	s0,0(sp)
    80003ea6:	0800                	addi	s0,sp,16
    80003ea8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003eaa:	4585                	li	a1,1
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	db4080e7          	jalr	-588(ra) # 80003c60 <namex>
}
    80003eb4:	60a2                	ld	ra,8(sp)
    80003eb6:	6402                	ld	s0,0(sp)
    80003eb8:	0141                	addi	sp,sp,16
    80003eba:	8082                	ret

0000000080003ebc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80003ebc:	7179                	addi	sp,sp,-48
    80003ebe:	f406                	sd	ra,40(sp)
    80003ec0:	f022                	sd	s0,32(sp)
    80003ec2:	ec26                	sd	s1,24(sp)
    80003ec4:	e84a                	sd	s2,16(sp)
    80003ec6:	e44e                	sd	s3,8(sp)
    80003ec8:	1800                	addi	s0,sp,48
    80003eca:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80003ecc:	0b000993          	li	s3,176
    80003ed0:	033507b3          	mul	a5,a0,s3
    80003ed4:	0001c997          	auipc	s3,0x1c
    80003ed8:	02c98993          	addi	s3,s3,44 # 8001ff00 <log>
    80003edc:	99be                	add	s3,s3,a5
    80003ede:	0209a583          	lw	a1,32(s3)
    80003ee2:	fffff097          	auipc	ra,0xfffff
    80003ee6:	010080e7          	jalr	16(ra) # 80002ef2 <bread>
    80003eea:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80003eec:	0349a783          	lw	a5,52(s3)
    80003ef0:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003ef2:	0349a783          	lw	a5,52(s3)
    80003ef6:	02f05763          	blez	a5,80003f24 <write_head+0x68>
    80003efa:	0b000793          	li	a5,176
    80003efe:	02f487b3          	mul	a5,s1,a5
    80003f02:	0001c717          	auipc	a4,0x1c
    80003f06:	03670713          	addi	a4,a4,54 # 8001ff38 <log+0x38>
    80003f0a:	97ba                	add	a5,a5,a4
    80003f0c:	06450693          	addi	a3,a0,100
    80003f10:	4701                	li	a4,0
    80003f12:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    80003f14:	4390                	lw	a2,0(a5)
    80003f16:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003f18:	2705                	addiw	a4,a4,1
    80003f1a:	0791                	addi	a5,a5,4
    80003f1c:	0691                	addi	a3,a3,4
    80003f1e:	59d0                	lw	a2,52(a1)
    80003f20:	fec74ae3          	blt	a4,a2,80003f14 <write_head+0x58>
  }
  bwrite(buf);
    80003f24:	854a                	mv	a0,s2
    80003f26:	fffff097          	auipc	ra,0xfffff
    80003f2a:	0c0080e7          	jalr	192(ra) # 80002fe6 <bwrite>
  brelse(buf);
    80003f2e:	854a                	mv	a0,s2
    80003f30:	fffff097          	auipc	ra,0xfffff
    80003f34:	0f6080e7          	jalr	246(ra) # 80003026 <brelse>
}
    80003f38:	70a2                	ld	ra,40(sp)
    80003f3a:	7402                	ld	s0,32(sp)
    80003f3c:	64e2                	ld	s1,24(sp)
    80003f3e:	6942                	ld	s2,16(sp)
    80003f40:	69a2                	ld	s3,8(sp)
    80003f42:	6145                	addi	sp,sp,48
    80003f44:	8082                	ret

0000000080003f46 <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003f46:	0b000793          	li	a5,176
    80003f4a:	02f50733          	mul	a4,a0,a5
    80003f4e:	0001c797          	auipc	a5,0x1c
    80003f52:	fb278793          	addi	a5,a5,-78 # 8001ff00 <log>
    80003f56:	97ba                	add	a5,a5,a4
    80003f58:	5bdc                	lw	a5,52(a5)
    80003f5a:	0af05b63          	blez	a5,80004010 <install_trans+0xca>
{
    80003f5e:	7139                	addi	sp,sp,-64
    80003f60:	fc06                	sd	ra,56(sp)
    80003f62:	f822                	sd	s0,48(sp)
    80003f64:	f426                	sd	s1,40(sp)
    80003f66:	f04a                	sd	s2,32(sp)
    80003f68:	ec4e                	sd	s3,24(sp)
    80003f6a:	e852                	sd	s4,16(sp)
    80003f6c:	e456                	sd	s5,8(sp)
    80003f6e:	e05a                	sd	s6,0(sp)
    80003f70:	0080                	addi	s0,sp,64
    80003f72:	0001c797          	auipc	a5,0x1c
    80003f76:	fc678793          	addi	a5,a5,-58 # 8001ff38 <log+0x38>
    80003f7a:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003f7e:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80003f80:	00050b1b          	sext.w	s6,a0
    80003f84:	0001ca97          	auipc	s5,0x1c
    80003f88:	f7ca8a93          	addi	s5,s5,-132 # 8001ff00 <log>
    80003f8c:	9aba                	add	s5,s5,a4
    80003f8e:	020aa583          	lw	a1,32(s5)
    80003f92:	013585bb          	addw	a1,a1,s3
    80003f96:	2585                	addiw	a1,a1,1
    80003f98:	855a                	mv	a0,s6
    80003f9a:	fffff097          	auipc	ra,0xfffff
    80003f9e:	f58080e7          	jalr	-168(ra) # 80002ef2 <bread>
    80003fa2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80003fa4:	000a2583          	lw	a1,0(s4)
    80003fa8:	855a                	mv	a0,s6
    80003faa:	fffff097          	auipc	ra,0xfffff
    80003fae:	f48080e7          	jalr	-184(ra) # 80002ef2 <bread>
    80003fb2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fb4:	40000613          	li	a2,1024
    80003fb8:	06090593          	addi	a1,s2,96
    80003fbc:	06050513          	addi	a0,a0,96
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	e1e080e7          	jalr	-482(ra) # 80000dde <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fc8:	8526                	mv	a0,s1
    80003fca:	fffff097          	auipc	ra,0xfffff
    80003fce:	01c080e7          	jalr	28(ra) # 80002fe6 <bwrite>
    bunpin(dbuf);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	fffff097          	auipc	ra,0xfffff
    80003fd8:	12c080e7          	jalr	300(ra) # 80003100 <bunpin>
    brelse(lbuf);
    80003fdc:	854a                	mv	a0,s2
    80003fde:	fffff097          	auipc	ra,0xfffff
    80003fe2:	048080e7          	jalr	72(ra) # 80003026 <brelse>
    brelse(dbuf);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	03e080e7          	jalr	62(ra) # 80003026 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003ff0:	2985                	addiw	s3,s3,1
    80003ff2:	0a11                	addi	s4,s4,4
    80003ff4:	034aa783          	lw	a5,52(s5)
    80003ff8:	f8f9cbe3          	blt	s3,a5,80003f8e <install_trans+0x48>
}
    80003ffc:	70e2                	ld	ra,56(sp)
    80003ffe:	7442                	ld	s0,48(sp)
    80004000:	74a2                	ld	s1,40(sp)
    80004002:	7902                	ld	s2,32(sp)
    80004004:	69e2                	ld	s3,24(sp)
    80004006:	6a42                	ld	s4,16(sp)
    80004008:	6aa2                	ld	s5,8(sp)
    8000400a:	6b02                	ld	s6,0(sp)
    8000400c:	6121                	addi	sp,sp,64
    8000400e:	8082                	ret
    80004010:	8082                	ret

0000000080004012 <initlog>:
{
    80004012:	7179                	addi	sp,sp,-48
    80004014:	f406                	sd	ra,40(sp)
    80004016:	f022                	sd	s0,32(sp)
    80004018:	ec26                	sd	s1,24(sp)
    8000401a:	e84a                	sd	s2,16(sp)
    8000401c:	e44e                	sd	s3,8(sp)
    8000401e:	e052                	sd	s4,0(sp)
    80004020:	1800                	addi	s0,sp,48
    80004022:	84aa                	mv	s1,a0
    80004024:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    80004026:	0b000713          	li	a4,176
    8000402a:	02e509b3          	mul	s3,a0,a4
    8000402e:	0001c917          	auipc	s2,0x1c
    80004032:	ed290913          	addi	s2,s2,-302 # 8001ff00 <log>
    80004036:	994e                	add	s2,s2,s3
    80004038:	00005597          	auipc	a1,0x5
    8000403c:	96858593          	addi	a1,a1,-1688 # 800089a0 <userret+0x910>
    80004040:	854a                	mv	a0,s2
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	99a080e7          	jalr	-1638(ra) # 800009dc <initlock>
  log[dev].start = sb->logstart;
    8000404a:	014a2583          	lw	a1,20(s4)
    8000404e:	02b92023          	sw	a1,32(s2)
  log[dev].size = sb->nlog;
    80004052:	010a2783          	lw	a5,16(s4)
    80004056:	02f92223          	sw	a5,36(s2)
  log[dev].dev = dev;
    8000405a:	02992823          	sw	s1,48(s2)
  struct buf *buf = bread(dev, log[dev].start);
    8000405e:	8526                	mv	a0,s1
    80004060:	fffff097          	auipc	ra,0xfffff
    80004064:	e92080e7          	jalr	-366(ra) # 80002ef2 <bread>
  log[dev].lh.n = lh->n;
    80004068:	513c                	lw	a5,96(a0)
    8000406a:	02f92a23          	sw	a5,52(s2)
  for (i = 0; i < log[dev].lh.n; i++) {
    8000406e:	02f05663          	blez	a5,8000409a <initlog+0x88>
    80004072:	06450693          	addi	a3,a0,100
    80004076:	0001c717          	auipc	a4,0x1c
    8000407a:	ec270713          	addi	a4,a4,-318 # 8001ff38 <log+0x38>
    8000407e:	974e                	add	a4,a4,s3
    80004080:	37fd                	addiw	a5,a5,-1
    80004082:	1782                	slli	a5,a5,0x20
    80004084:	9381                	srli	a5,a5,0x20
    80004086:	078a                	slli	a5,a5,0x2
    80004088:	06850613          	addi	a2,a0,104
    8000408c:	97b2                	add	a5,a5,a2
    log[dev].lh.block[i] = lh->block[i];
    8000408e:	4290                	lw	a2,0(a3)
    80004090:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    80004092:	0691                	addi	a3,a3,4
    80004094:	0711                	addi	a4,a4,4
    80004096:	fef69ce3          	bne	a3,a5,8000408e <initlog+0x7c>
  brelse(buf);
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	f8c080e7          	jalr	-116(ra) # 80003026 <brelse>

static void
recover_from_log(int dev)
{
  read_head(dev);
  install_trans(dev); // if committed, copy from log to disk
    800040a2:	8526                	mv	a0,s1
    800040a4:	00000097          	auipc	ra,0x0
    800040a8:	ea2080e7          	jalr	-350(ra) # 80003f46 <install_trans>
  log[dev].lh.n = 0;
    800040ac:	0b000793          	li	a5,176
    800040b0:	02f48733          	mul	a4,s1,a5
    800040b4:	0001c797          	auipc	a5,0x1c
    800040b8:	e4c78793          	addi	a5,a5,-436 # 8001ff00 <log>
    800040bc:	97ba                	add	a5,a5,a4
    800040be:	0207aa23          	sw	zero,52(a5)
  write_head(dev); // clear the log
    800040c2:	8526                	mv	a0,s1
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	df8080e7          	jalr	-520(ra) # 80003ebc <write_head>
}
    800040cc:	70a2                	ld	ra,40(sp)
    800040ce:	7402                	ld	s0,32(sp)
    800040d0:	64e2                	ld	s1,24(sp)
    800040d2:	6942                	ld	s2,16(sp)
    800040d4:	69a2                	ld	s3,8(sp)
    800040d6:	6a02                	ld	s4,0(sp)
    800040d8:	6145                	addi	sp,sp,48
    800040da:	8082                	ret

00000000800040dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(int dev)
{
    800040dc:	7139                	addi	sp,sp,-64
    800040de:	fc06                	sd	ra,56(sp)
    800040e0:	f822                	sd	s0,48(sp)
    800040e2:	f426                	sd	s1,40(sp)
    800040e4:	f04a                	sd	s2,32(sp)
    800040e6:	ec4e                	sd	s3,24(sp)
    800040e8:	e852                	sd	s4,16(sp)
    800040ea:	e456                	sd	s5,8(sp)
    800040ec:	0080                	addi	s0,sp,64
    800040ee:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    800040f0:	0b000913          	li	s2,176
    800040f4:	032507b3          	mul	a5,a0,s2
    800040f8:	0001c917          	auipc	s2,0x1c
    800040fc:	e0890913          	addi	s2,s2,-504 # 8001ff00 <log>
    80004100:	993e                	add	s2,s2,a5
    80004102:	854a                	mv	a0,s2
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	9ac080e7          	jalr	-1620(ra) # 80000ab0 <acquire>
  while(1){
    if(log[dev].committing){
    8000410c:	0001c997          	auipc	s3,0x1c
    80004110:	df498993          	addi	s3,s3,-524 # 8001ff00 <log>
    80004114:	84ca                	mv	s1,s2
      sleep(&log, &log[dev].lock);
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004116:	4a79                	li	s4,30
    80004118:	a039                	j	80004126 <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    8000411a:	85ca                	mv	a1,s2
    8000411c:	854e                	mv	a0,s3
    8000411e:	ffffe097          	auipc	ra,0xffffe
    80004122:	108080e7          	jalr	264(ra) # 80002226 <sleep>
    if(log[dev].committing){
    80004126:	54dc                	lw	a5,44(s1)
    80004128:	fbed                	bnez	a5,8000411a <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000412a:	549c                	lw	a5,40(s1)
    8000412c:	0017871b          	addiw	a4,a5,1
    80004130:	0007069b          	sext.w	a3,a4
    80004134:	0027179b          	slliw	a5,a4,0x2
    80004138:	9fb9                	addw	a5,a5,a4
    8000413a:	0017979b          	slliw	a5,a5,0x1
    8000413e:	58d8                	lw	a4,52(s1)
    80004140:	9fb9                	addw	a5,a5,a4
    80004142:	00fa5963          	bge	s4,a5,80004154 <begin_op+0x78>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log[dev].lock);
    80004146:	85ca                	mv	a1,s2
    80004148:	854e                	mv	a0,s3
    8000414a:	ffffe097          	auipc	ra,0xffffe
    8000414e:	0dc080e7          	jalr	220(ra) # 80002226 <sleep>
    80004152:	bfd1                	j	80004126 <begin_op+0x4a>
    } else {
      log[dev].outstanding += 1;
    80004154:	0b000513          	li	a0,176
    80004158:	02aa8ab3          	mul	s5,s5,a0
    8000415c:	0001c797          	auipc	a5,0x1c
    80004160:	da478793          	addi	a5,a5,-604 # 8001ff00 <log>
    80004164:	9abe                	add	s5,s5,a5
    80004166:	02daa423          	sw	a3,40(s5)
      release(&log[dev].lock);
    8000416a:	854a                	mv	a0,s2
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	a14080e7          	jalr	-1516(ra) # 80000b80 <release>
      break;
    }
  }
}
    80004174:	70e2                	ld	ra,56(sp)
    80004176:	7442                	ld	s0,48(sp)
    80004178:	74a2                	ld	s1,40(sp)
    8000417a:	7902                	ld	s2,32(sp)
    8000417c:	69e2                	ld	s3,24(sp)
    8000417e:	6a42                	ld	s4,16(sp)
    80004180:	6aa2                	ld	s5,8(sp)
    80004182:	6121                	addi	sp,sp,64
    80004184:	8082                	ret

0000000080004186 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(int dev)
{
    80004186:	715d                	addi	sp,sp,-80
    80004188:	e486                	sd	ra,72(sp)
    8000418a:	e0a2                	sd	s0,64(sp)
    8000418c:	fc26                	sd	s1,56(sp)
    8000418e:	f84a                	sd	s2,48(sp)
    80004190:	f44e                	sd	s3,40(sp)
    80004192:	f052                	sd	s4,32(sp)
    80004194:	ec56                	sd	s5,24(sp)
    80004196:	e85a                	sd	s6,16(sp)
    80004198:	e45e                	sd	s7,8(sp)
    8000419a:	e062                	sd	s8,0(sp)
    8000419c:	0880                	addi	s0,sp,80
    8000419e:	8aaa                	mv	s5,a0
  int do_commit = 0;

  acquire(&log[dev].lock);
    800041a0:	0b000913          	li	s2,176
    800041a4:	03250933          	mul	s2,a0,s2
    800041a8:	0001c497          	auipc	s1,0x1c
    800041ac:	d5848493          	addi	s1,s1,-680 # 8001ff00 <log>
    800041b0:	94ca                	add	s1,s1,s2
    800041b2:	8526                	mv	a0,s1
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	8fc080e7          	jalr	-1796(ra) # 80000ab0 <acquire>
  log[dev].outstanding -= 1;
    800041bc:	5498                	lw	a4,40(s1)
    800041be:	377d                	addiw	a4,a4,-1
    800041c0:	d498                	sw	a4,40(s1)
  if(log[dev].committing)
    800041c2:	54dc                	lw	a5,44(s1)
    800041c4:	efbd                	bnez	a5,80004242 <end_op+0xbc>
    800041c6:	00070b1b          	sext.w	s6,a4
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    800041ca:	080b1463          	bnez	s6,80004252 <end_op+0xcc>
    do_commit = 1;
    log[dev].committing = 1;
    800041ce:	0b000993          	li	s3,176
    800041d2:	033a87b3          	mul	a5,s5,s3
    800041d6:	0001c997          	auipc	s3,0x1c
    800041da:	d2a98993          	addi	s3,s3,-726 # 8001ff00 <log>
    800041de:	99be                	add	s3,s3,a5
    800041e0:	4785                	li	a5,1
    800041e2:	02f9a623          	sw	a5,44(s3)
    // begin_op() may be waiting for log space,
    // and decrementing log[dev].outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log[dev].lock);
    800041e6:	8526                	mv	a0,s1
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	998080e7          	jalr	-1640(ra) # 80000b80 <release>
}

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    800041f0:	0349a783          	lw	a5,52(s3)
    800041f4:	06f04d63          	bgtz	a5,8000426e <end_op+0xe8>
    acquire(&log[dev].lock);
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	8b6080e7          	jalr	-1866(ra) # 80000ab0 <acquire>
    log[dev].committing = 0;
    80004202:	0001c517          	auipc	a0,0x1c
    80004206:	cfe50513          	addi	a0,a0,-770 # 8001ff00 <log>
    8000420a:	0b000793          	li	a5,176
    8000420e:	02fa87b3          	mul	a5,s5,a5
    80004212:	97aa                	add	a5,a5,a0
    80004214:	0207a623          	sw	zero,44(a5)
    wakeup(&log);
    80004218:	ffffe097          	auipc	ra,0xffffe
    8000421c:	194080e7          	jalr	404(ra) # 800023ac <wakeup>
    release(&log[dev].lock);
    80004220:	8526                	mv	a0,s1
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	95e080e7          	jalr	-1698(ra) # 80000b80 <release>
}
    8000422a:	60a6                	ld	ra,72(sp)
    8000422c:	6406                	ld	s0,64(sp)
    8000422e:	74e2                	ld	s1,56(sp)
    80004230:	7942                	ld	s2,48(sp)
    80004232:	79a2                	ld	s3,40(sp)
    80004234:	7a02                	ld	s4,32(sp)
    80004236:	6ae2                	ld	s5,24(sp)
    80004238:	6b42                	ld	s6,16(sp)
    8000423a:	6ba2                	ld	s7,8(sp)
    8000423c:	6c02                	ld	s8,0(sp)
    8000423e:	6161                	addi	sp,sp,80
    80004240:	8082                	ret
    panic("log[dev].committing");
    80004242:	00004517          	auipc	a0,0x4
    80004246:	76650513          	addi	a0,a0,1894 # 800089a8 <userret+0x918>
    8000424a:	ffffc097          	auipc	ra,0xffffc
    8000424e:	310080e7          	jalr	784(ra) # 8000055a <panic>
    wakeup(&log);
    80004252:	0001c517          	auipc	a0,0x1c
    80004256:	cae50513          	addi	a0,a0,-850 # 8001ff00 <log>
    8000425a:	ffffe097          	auipc	ra,0xffffe
    8000425e:	152080e7          	jalr	338(ra) # 800023ac <wakeup>
  release(&log[dev].lock);
    80004262:	8526                	mv	a0,s1
    80004264:	ffffd097          	auipc	ra,0xffffd
    80004268:	91c080e7          	jalr	-1764(ra) # 80000b80 <release>
  if(do_commit){
    8000426c:	bf7d                	j	8000422a <end_op+0xa4>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    8000426e:	0001c797          	auipc	a5,0x1c
    80004272:	cca78793          	addi	a5,a5,-822 # 8001ff38 <log+0x38>
    80004276:	993e                	add	s2,s2,a5
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80004278:	000a8c1b          	sext.w	s8,s5
    8000427c:	0b000b93          	li	s7,176
    80004280:	037a87b3          	mul	a5,s5,s7
    80004284:	0001cb97          	auipc	s7,0x1c
    80004288:	c7cb8b93          	addi	s7,s7,-900 # 8001ff00 <log>
    8000428c:	9bbe                	add	s7,s7,a5
    8000428e:	020ba583          	lw	a1,32(s7)
    80004292:	016585bb          	addw	a1,a1,s6
    80004296:	2585                	addiw	a1,a1,1
    80004298:	8562                	mv	a0,s8
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	c58080e7          	jalr	-936(ra) # 80002ef2 <bread>
    800042a2:	89aa                	mv	s3,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    800042a4:	00092583          	lw	a1,0(s2)
    800042a8:	8562                	mv	a0,s8
    800042aa:	fffff097          	auipc	ra,0xfffff
    800042ae:	c48080e7          	jalr	-952(ra) # 80002ef2 <bread>
    800042b2:	8a2a                	mv	s4,a0
    memmove(to->data, from->data, BSIZE);
    800042b4:	40000613          	li	a2,1024
    800042b8:	06050593          	addi	a1,a0,96
    800042bc:	06098513          	addi	a0,s3,96
    800042c0:	ffffd097          	auipc	ra,0xffffd
    800042c4:	b1e080e7          	jalr	-1250(ra) # 80000dde <memmove>
    bwrite(to);  // write the log
    800042c8:	854e                	mv	a0,s3
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	d1c080e7          	jalr	-740(ra) # 80002fe6 <bwrite>
    brelse(from);
    800042d2:	8552                	mv	a0,s4
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	d52080e7          	jalr	-686(ra) # 80003026 <brelse>
    brelse(to);
    800042dc:	854e                	mv	a0,s3
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	d48080e7          	jalr	-696(ra) # 80003026 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    800042e6:	2b05                	addiw	s6,s6,1
    800042e8:	0911                	addi	s2,s2,4
    800042ea:	034ba783          	lw	a5,52(s7)
    800042ee:	fafb40e3          	blt	s6,a5,8000428e <end_op+0x108>
    write_log(dev);     // Write modified blocks from cache to log
    write_head(dev);    // Write header to disk -- the real commit
    800042f2:	8556                	mv	a0,s5
    800042f4:	00000097          	auipc	ra,0x0
    800042f8:	bc8080e7          	jalr	-1080(ra) # 80003ebc <write_head>
    install_trans(dev); // Now install writes to home locations
    800042fc:	8556                	mv	a0,s5
    800042fe:	00000097          	auipc	ra,0x0
    80004302:	c48080e7          	jalr	-952(ra) # 80003f46 <install_trans>
    log[dev].lh.n = 0;
    80004306:	0b000793          	li	a5,176
    8000430a:	02fa8733          	mul	a4,s5,a5
    8000430e:	0001c797          	auipc	a5,0x1c
    80004312:	bf278793          	addi	a5,a5,-1038 # 8001ff00 <log>
    80004316:	97ba                	add	a5,a5,a4
    80004318:	0207aa23          	sw	zero,52(a5)
    write_head(dev);    // Erase the transaction from the log
    8000431c:	8556                	mv	a0,s5
    8000431e:	00000097          	auipc	ra,0x0
    80004322:	b9e080e7          	jalr	-1122(ra) # 80003ebc <write_head>
    80004326:	bdc9                	j	800041f8 <end_op+0x72>

0000000080004328 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004328:	7179                	addi	sp,sp,-48
    8000432a:	f406                	sd	ra,40(sp)
    8000432c:	f022                	sd	s0,32(sp)
    8000432e:	ec26                	sd	s1,24(sp)
    80004330:	e84a                	sd	s2,16(sp)
    80004332:	e44e                	sd	s3,8(sp)
    80004334:	e052                	sd	s4,0(sp)
    80004336:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    80004338:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    8000433c:	0b000793          	li	a5,176
    80004340:	02f90733          	mul	a4,s2,a5
    80004344:	0001c797          	auipc	a5,0x1c
    80004348:	bbc78793          	addi	a5,a5,-1092 # 8001ff00 <log>
    8000434c:	97ba                	add	a5,a5,a4
    8000434e:	5bd4                	lw	a3,52(a5)
    80004350:	47f5                	li	a5,29
    80004352:	0ad7cc63          	blt	a5,a3,8000440a <log_write+0xe2>
    80004356:	89aa                	mv	s3,a0
    80004358:	0001c797          	auipc	a5,0x1c
    8000435c:	ba878793          	addi	a5,a5,-1112 # 8001ff00 <log>
    80004360:	97ba                	add	a5,a5,a4
    80004362:	53dc                	lw	a5,36(a5)
    80004364:	37fd                	addiw	a5,a5,-1
    80004366:	0af6d263          	bge	a3,a5,8000440a <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    8000436a:	0b000793          	li	a5,176
    8000436e:	02f90733          	mul	a4,s2,a5
    80004372:	0001c797          	auipc	a5,0x1c
    80004376:	b8e78793          	addi	a5,a5,-1138 # 8001ff00 <log>
    8000437a:	97ba                	add	a5,a5,a4
    8000437c:	579c                	lw	a5,40(a5)
    8000437e:	08f05e63          	blez	a5,8000441a <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    80004382:	0b000793          	li	a5,176
    80004386:	02f904b3          	mul	s1,s2,a5
    8000438a:	0001ca17          	auipc	s4,0x1c
    8000438e:	b76a0a13          	addi	s4,s4,-1162 # 8001ff00 <log>
    80004392:	9a26                	add	s4,s4,s1
    80004394:	8552                	mv	a0,s4
    80004396:	ffffc097          	auipc	ra,0xffffc
    8000439a:	71a080e7          	jalr	1818(ra) # 80000ab0 <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    8000439e:	034a2603          	lw	a2,52(s4)
    800043a2:	08c05463          	blez	a2,8000442a <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800043a6:	00c9a583          	lw	a1,12(s3)
    800043aa:	0001c797          	auipc	a5,0x1c
    800043ae:	b8e78793          	addi	a5,a5,-1138 # 8001ff38 <log+0x38>
    800043b2:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    800043b4:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800043b6:	4394                	lw	a3,0(a5)
    800043b8:	06b68a63          	beq	a3,a1,8000442c <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    800043bc:	2705                	addiw	a4,a4,1
    800043be:	0791                	addi	a5,a5,4
    800043c0:	fec71be3          	bne	a4,a2,800043b6 <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    800043c4:	02c00793          	li	a5,44
    800043c8:	02f907b3          	mul	a5,s2,a5
    800043cc:	97b2                	add	a5,a5,a2
    800043ce:	07b1                	addi	a5,a5,12
    800043d0:	078a                	slli	a5,a5,0x2
    800043d2:	0001c717          	auipc	a4,0x1c
    800043d6:	b2e70713          	addi	a4,a4,-1234 # 8001ff00 <log>
    800043da:	97ba                	add	a5,a5,a4
    800043dc:	00c9a703          	lw	a4,12(s3)
    800043e0:	c798                	sw	a4,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    800043e2:	854e                	mv	a0,s3
    800043e4:	fffff097          	auipc	ra,0xfffff
    800043e8:	ce0080e7          	jalr	-800(ra) # 800030c4 <bpin>
    log[dev].lh.n++;
    800043ec:	0b000793          	li	a5,176
    800043f0:	02f90933          	mul	s2,s2,a5
    800043f4:	0001c797          	auipc	a5,0x1c
    800043f8:	b0c78793          	addi	a5,a5,-1268 # 8001ff00 <log>
    800043fc:	993e                	add	s2,s2,a5
    800043fe:	03492783          	lw	a5,52(s2)
    80004402:	2785                	addiw	a5,a5,1
    80004404:	02f92a23          	sw	a5,52(s2)
    80004408:	a099                	j	8000444e <log_write+0x126>
    panic("too big a transaction");
    8000440a:	00004517          	auipc	a0,0x4
    8000440e:	5b650513          	addi	a0,a0,1462 # 800089c0 <userret+0x930>
    80004412:	ffffc097          	auipc	ra,0xffffc
    80004416:	148080e7          	jalr	328(ra) # 8000055a <panic>
    panic("log_write outside of trans");
    8000441a:	00004517          	auipc	a0,0x4
    8000441e:	5be50513          	addi	a0,a0,1470 # 800089d8 <userret+0x948>
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	138080e7          	jalr	312(ra) # 8000055a <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    8000442a:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    8000442c:	02c00793          	li	a5,44
    80004430:	02f907b3          	mul	a5,s2,a5
    80004434:	97ba                	add	a5,a5,a4
    80004436:	07b1                	addi	a5,a5,12
    80004438:	078a                	slli	a5,a5,0x2
    8000443a:	0001c697          	auipc	a3,0x1c
    8000443e:	ac668693          	addi	a3,a3,-1338 # 8001ff00 <log>
    80004442:	97b6                	add	a5,a5,a3
    80004444:	00c9a683          	lw	a3,12(s3)
    80004448:	c794                	sw	a3,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    8000444a:	f8e60ce3          	beq	a2,a4,800043e2 <log_write+0xba>
  }
  release(&log[dev].lock);
    8000444e:	8552                	mv	a0,s4
    80004450:	ffffc097          	auipc	ra,0xffffc
    80004454:	730080e7          	jalr	1840(ra) # 80000b80 <release>
}
    80004458:	70a2                	ld	ra,40(sp)
    8000445a:	7402                	ld	s0,32(sp)
    8000445c:	64e2                	ld	s1,24(sp)
    8000445e:	6942                	ld	s2,16(sp)
    80004460:	69a2                	ld	s3,8(sp)
    80004462:	6a02                	ld	s4,0(sp)
    80004464:	6145                	addi	sp,sp,48
    80004466:	8082                	ret

0000000080004468 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004468:	1101                	addi	sp,sp,-32
    8000446a:	ec06                	sd	ra,24(sp)
    8000446c:	e822                	sd	s0,16(sp)
    8000446e:	e426                	sd	s1,8(sp)
    80004470:	e04a                	sd	s2,0(sp)
    80004472:	1000                	addi	s0,sp,32
    80004474:	84aa                	mv	s1,a0
    80004476:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004478:	00004597          	auipc	a1,0x4
    8000447c:	58058593          	addi	a1,a1,1408 # 800089f8 <userret+0x968>
    80004480:	0521                	addi	a0,a0,8
    80004482:	ffffc097          	auipc	ra,0xffffc
    80004486:	55a080e7          	jalr	1370(ra) # 800009dc <initlock>
  lk->name = name;
    8000448a:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    8000448e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004492:	0204a823          	sw	zero,48(s1)
}
    80004496:	60e2                	ld	ra,24(sp)
    80004498:	6442                	ld	s0,16(sp)
    8000449a:	64a2                	ld	s1,8(sp)
    8000449c:	6902                	ld	s2,0(sp)
    8000449e:	6105                	addi	sp,sp,32
    800044a0:	8082                	ret

00000000800044a2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044a2:	1101                	addi	sp,sp,-32
    800044a4:	ec06                	sd	ra,24(sp)
    800044a6:	e822                	sd	s0,16(sp)
    800044a8:	e426                	sd	s1,8(sp)
    800044aa:	e04a                	sd	s2,0(sp)
    800044ac:	1000                	addi	s0,sp,32
    800044ae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044b0:	00850913          	addi	s2,a0,8
    800044b4:	854a                	mv	a0,s2
    800044b6:	ffffc097          	auipc	ra,0xffffc
    800044ba:	5fa080e7          	jalr	1530(ra) # 80000ab0 <acquire>
  while (lk->locked) {
    800044be:	409c                	lw	a5,0(s1)
    800044c0:	cb89                	beqz	a5,800044d2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044c2:	85ca                	mv	a1,s2
    800044c4:	8526                	mv	a0,s1
    800044c6:	ffffe097          	auipc	ra,0xffffe
    800044ca:	d60080e7          	jalr	-672(ra) # 80002226 <sleep>
  while (lk->locked) {
    800044ce:	409c                	lw	a5,0(s1)
    800044d0:	fbed                	bnez	a5,800044c2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044d2:	4785                	li	a5,1
    800044d4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044d6:	ffffd097          	auipc	ra,0xffffd
    800044da:	594080e7          	jalr	1428(ra) # 80001a6a <myproc>
    800044de:	413c                	lw	a5,64(a0)
    800044e0:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    800044e2:	854a                	mv	a0,s2
    800044e4:	ffffc097          	auipc	ra,0xffffc
    800044e8:	69c080e7          	jalr	1692(ra) # 80000b80 <release>
}
    800044ec:	60e2                	ld	ra,24(sp)
    800044ee:	6442                	ld	s0,16(sp)
    800044f0:	64a2                	ld	s1,8(sp)
    800044f2:	6902                	ld	s2,0(sp)
    800044f4:	6105                	addi	sp,sp,32
    800044f6:	8082                	ret

00000000800044f8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800044f8:	1101                	addi	sp,sp,-32
    800044fa:	ec06                	sd	ra,24(sp)
    800044fc:	e822                	sd	s0,16(sp)
    800044fe:	e426                	sd	s1,8(sp)
    80004500:	e04a                	sd	s2,0(sp)
    80004502:	1000                	addi	s0,sp,32
    80004504:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004506:	00850913          	addi	s2,a0,8
    8000450a:	854a                	mv	a0,s2
    8000450c:	ffffc097          	auipc	ra,0xffffc
    80004510:	5a4080e7          	jalr	1444(ra) # 80000ab0 <acquire>
  lk->locked = 0;
    80004514:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004518:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    8000451c:	8526                	mv	a0,s1
    8000451e:	ffffe097          	auipc	ra,0xffffe
    80004522:	e8e080e7          	jalr	-370(ra) # 800023ac <wakeup>
  release(&lk->lk);
    80004526:	854a                	mv	a0,s2
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	658080e7          	jalr	1624(ra) # 80000b80 <release>
}
    80004530:	60e2                	ld	ra,24(sp)
    80004532:	6442                	ld	s0,16(sp)
    80004534:	64a2                	ld	s1,8(sp)
    80004536:	6902                	ld	s2,0(sp)
    80004538:	6105                	addi	sp,sp,32
    8000453a:	8082                	ret

000000008000453c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000453c:	7179                	addi	sp,sp,-48
    8000453e:	f406                	sd	ra,40(sp)
    80004540:	f022                	sd	s0,32(sp)
    80004542:	ec26                	sd	s1,24(sp)
    80004544:	e84a                	sd	s2,16(sp)
    80004546:	e44e                	sd	s3,8(sp)
    80004548:	1800                	addi	s0,sp,48
    8000454a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000454c:	00850913          	addi	s2,a0,8
    80004550:	854a                	mv	a0,s2
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	55e080e7          	jalr	1374(ra) # 80000ab0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000455a:	409c                	lw	a5,0(s1)
    8000455c:	ef99                	bnez	a5,8000457a <holdingsleep+0x3e>
    8000455e:	4481                	li	s1,0
  release(&lk->lk);
    80004560:	854a                	mv	a0,s2
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	61e080e7          	jalr	1566(ra) # 80000b80 <release>
  return r;
}
    8000456a:	8526                	mv	a0,s1
    8000456c:	70a2                	ld	ra,40(sp)
    8000456e:	7402                	ld	s0,32(sp)
    80004570:	64e2                	ld	s1,24(sp)
    80004572:	6942                	ld	s2,16(sp)
    80004574:	69a2                	ld	s3,8(sp)
    80004576:	6145                	addi	sp,sp,48
    80004578:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000457a:	0304a983          	lw	s3,48(s1)
    8000457e:	ffffd097          	auipc	ra,0xffffd
    80004582:	4ec080e7          	jalr	1260(ra) # 80001a6a <myproc>
    80004586:	4124                	lw	s1,64(a0)
    80004588:	413484b3          	sub	s1,s1,s3
    8000458c:	0014b493          	seqz	s1,s1
    80004590:	bfc1                	j	80004560 <holdingsleep+0x24>

0000000080004592 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004592:	1141                	addi	sp,sp,-16
    80004594:	e406                	sd	ra,8(sp)
    80004596:	e022                	sd	s0,0(sp)
    80004598:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000459a:	00004597          	auipc	a1,0x4
    8000459e:	46e58593          	addi	a1,a1,1134 # 80008a08 <userret+0x978>
    800045a2:	0001c517          	auipc	a0,0x1c
    800045a6:	b5e50513          	addi	a0,a0,-1186 # 80020100 <ftable>
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	432080e7          	jalr	1074(ra) # 800009dc <initlock>
}
    800045b2:	60a2                	ld	ra,8(sp)
    800045b4:	6402                	ld	s0,0(sp)
    800045b6:	0141                	addi	sp,sp,16
    800045b8:	8082                	ret

00000000800045ba <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045ba:	1101                	addi	sp,sp,-32
    800045bc:	ec06                	sd	ra,24(sp)
    800045be:	e822                	sd	s0,16(sp)
    800045c0:	e426                	sd	s1,8(sp)
    800045c2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045c4:	0001c517          	auipc	a0,0x1c
    800045c8:	b3c50513          	addi	a0,a0,-1220 # 80020100 <ftable>
    800045cc:	ffffc097          	auipc	ra,0xffffc
    800045d0:	4e4080e7          	jalr	1252(ra) # 80000ab0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045d4:	0001c497          	auipc	s1,0x1c
    800045d8:	b4c48493          	addi	s1,s1,-1204 # 80020120 <ftable+0x20>
    800045dc:	0001d717          	auipc	a4,0x1d
    800045e0:	ae470713          	addi	a4,a4,-1308 # 800210c0 <ftable+0xfc0>
    if(f->ref == 0){
    800045e4:	40dc                	lw	a5,4(s1)
    800045e6:	cf99                	beqz	a5,80004604 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045e8:	02848493          	addi	s1,s1,40
    800045ec:	fee49ce3          	bne	s1,a4,800045e4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045f0:	0001c517          	auipc	a0,0x1c
    800045f4:	b1050513          	addi	a0,a0,-1264 # 80020100 <ftable>
    800045f8:	ffffc097          	auipc	ra,0xffffc
    800045fc:	588080e7          	jalr	1416(ra) # 80000b80 <release>
  return 0;
    80004600:	4481                	li	s1,0
    80004602:	a819                	j	80004618 <filealloc+0x5e>
      f->ref = 1;
    80004604:	4785                	li	a5,1
    80004606:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004608:	0001c517          	auipc	a0,0x1c
    8000460c:	af850513          	addi	a0,a0,-1288 # 80020100 <ftable>
    80004610:	ffffc097          	auipc	ra,0xffffc
    80004614:	570080e7          	jalr	1392(ra) # 80000b80 <release>
}
    80004618:	8526                	mv	a0,s1
    8000461a:	60e2                	ld	ra,24(sp)
    8000461c:	6442                	ld	s0,16(sp)
    8000461e:	64a2                	ld	s1,8(sp)
    80004620:	6105                	addi	sp,sp,32
    80004622:	8082                	ret

0000000080004624 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004624:	1101                	addi	sp,sp,-32
    80004626:	ec06                	sd	ra,24(sp)
    80004628:	e822                	sd	s0,16(sp)
    8000462a:	e426                	sd	s1,8(sp)
    8000462c:	1000                	addi	s0,sp,32
    8000462e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004630:	0001c517          	auipc	a0,0x1c
    80004634:	ad050513          	addi	a0,a0,-1328 # 80020100 <ftable>
    80004638:	ffffc097          	auipc	ra,0xffffc
    8000463c:	478080e7          	jalr	1144(ra) # 80000ab0 <acquire>
  if(f->ref < 1)
    80004640:	40dc                	lw	a5,4(s1)
    80004642:	02f05263          	blez	a5,80004666 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004646:	2785                	addiw	a5,a5,1
    80004648:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000464a:	0001c517          	auipc	a0,0x1c
    8000464e:	ab650513          	addi	a0,a0,-1354 # 80020100 <ftable>
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	52e080e7          	jalr	1326(ra) # 80000b80 <release>
  return f;
}
    8000465a:	8526                	mv	a0,s1
    8000465c:	60e2                	ld	ra,24(sp)
    8000465e:	6442                	ld	s0,16(sp)
    80004660:	64a2                	ld	s1,8(sp)
    80004662:	6105                	addi	sp,sp,32
    80004664:	8082                	ret
    panic("filedup");
    80004666:	00004517          	auipc	a0,0x4
    8000466a:	3aa50513          	addi	a0,a0,938 # 80008a10 <userret+0x980>
    8000466e:	ffffc097          	auipc	ra,0xffffc
    80004672:	eec080e7          	jalr	-276(ra) # 8000055a <panic>

0000000080004676 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004676:	7139                	addi	sp,sp,-64
    80004678:	fc06                	sd	ra,56(sp)
    8000467a:	f822                	sd	s0,48(sp)
    8000467c:	f426                	sd	s1,40(sp)
    8000467e:	f04a                	sd	s2,32(sp)
    80004680:	ec4e                	sd	s3,24(sp)
    80004682:	e852                	sd	s4,16(sp)
    80004684:	e456                	sd	s5,8(sp)
    80004686:	0080                	addi	s0,sp,64
    80004688:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000468a:	0001c517          	auipc	a0,0x1c
    8000468e:	a7650513          	addi	a0,a0,-1418 # 80020100 <ftable>
    80004692:	ffffc097          	auipc	ra,0xffffc
    80004696:	41e080e7          	jalr	1054(ra) # 80000ab0 <acquire>
  if(f->ref < 1)
    8000469a:	40dc                	lw	a5,4(s1)
    8000469c:	06f05563          	blez	a5,80004706 <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    800046a0:	37fd                	addiw	a5,a5,-1
    800046a2:	0007871b          	sext.w	a4,a5
    800046a6:	c0dc                	sw	a5,4(s1)
    800046a8:	06e04763          	bgtz	a4,80004716 <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046ac:	0004a903          	lw	s2,0(s1)
    800046b0:	0094ca83          	lbu	s5,9(s1)
    800046b4:	0104ba03          	ld	s4,16(s1)
    800046b8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046bc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046c0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046c4:	0001c517          	auipc	a0,0x1c
    800046c8:	a3c50513          	addi	a0,a0,-1476 # 80020100 <ftable>
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	4b4080e7          	jalr	1204(ra) # 80000b80 <release>

  if(ff.type == FD_PIPE){
    800046d4:	4785                	li	a5,1
    800046d6:	06f90163          	beq	s2,a5,80004738 <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046da:	3979                	addiw	s2,s2,-2
    800046dc:	4785                	li	a5,1
    800046de:	0527e463          	bltu	a5,s2,80004726 <fileclose+0xb0>
    begin_op(ff.ip->dev);
    800046e2:	0009a503          	lw	a0,0(s3)
    800046e6:	00000097          	auipc	ra,0x0
    800046ea:	9f6080e7          	jalr	-1546(ra) # 800040dc <begin_op>
    iput(ff.ip);
    800046ee:	854e                	mv	a0,s3
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	116080e7          	jalr	278(ra) # 80003806 <iput>
    end_op(ff.ip->dev);
    800046f8:	0009a503          	lw	a0,0(s3)
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	a8a080e7          	jalr	-1398(ra) # 80004186 <end_op>
    80004704:	a00d                	j	80004726 <fileclose+0xb0>
    panic("fileclose");
    80004706:	00004517          	auipc	a0,0x4
    8000470a:	31250513          	addi	a0,a0,786 # 80008a18 <userret+0x988>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	e4c080e7          	jalr	-436(ra) # 8000055a <panic>
    release(&ftable.lock);
    80004716:	0001c517          	auipc	a0,0x1c
    8000471a:	9ea50513          	addi	a0,a0,-1558 # 80020100 <ftable>
    8000471e:	ffffc097          	auipc	ra,0xffffc
    80004722:	462080e7          	jalr	1122(ra) # 80000b80 <release>
  }
}
    80004726:	70e2                	ld	ra,56(sp)
    80004728:	7442                	ld	s0,48(sp)
    8000472a:	74a2                	ld	s1,40(sp)
    8000472c:	7902                	ld	s2,32(sp)
    8000472e:	69e2                	ld	s3,24(sp)
    80004730:	6a42                	ld	s4,16(sp)
    80004732:	6aa2                	ld	s5,8(sp)
    80004734:	6121                	addi	sp,sp,64
    80004736:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004738:	85d6                	mv	a1,s5
    8000473a:	8552                	mv	a0,s4
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	376080e7          	jalr	886(ra) # 80004ab2 <pipeclose>
    80004744:	b7cd                	j	80004726 <fileclose+0xb0>

0000000080004746 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004746:	715d                	addi	sp,sp,-80
    80004748:	e486                	sd	ra,72(sp)
    8000474a:	e0a2                	sd	s0,64(sp)
    8000474c:	fc26                	sd	s1,56(sp)
    8000474e:	f84a                	sd	s2,48(sp)
    80004750:	f44e                	sd	s3,40(sp)
    80004752:	0880                	addi	s0,sp,80
    80004754:	84aa                	mv	s1,a0
    80004756:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004758:	ffffd097          	auipc	ra,0xffffd
    8000475c:	312080e7          	jalr	786(ra) # 80001a6a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004760:	409c                	lw	a5,0(s1)
    80004762:	37f9                	addiw	a5,a5,-2
    80004764:	4705                	li	a4,1
    80004766:	04f76763          	bltu	a4,a5,800047b4 <filestat+0x6e>
    8000476a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000476c:	6c88                	ld	a0,24(s1)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	f8a080e7          	jalr	-118(ra) # 800036f8 <ilock>
    stati(f->ip, &st);
    80004776:	fb840593          	addi	a1,s0,-72
    8000477a:	6c88                	ld	a0,24(s1)
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	1e2080e7          	jalr	482(ra) # 8000395e <stati>
    iunlock(f->ip);
    80004784:	6c88                	ld	a0,24(s1)
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	034080e7          	jalr	52(ra) # 800037ba <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000478e:	46e1                	li	a3,24
    80004790:	fb840613          	addi	a2,s0,-72
    80004794:	85ce                	mv	a1,s3
    80004796:	05893503          	ld	a0,88(s2)
    8000479a:	ffffd097          	auipc	ra,0xffffd
    8000479e:	fc4080e7          	jalr	-60(ra) # 8000175e <copyout>
    800047a2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800047a6:	60a6                	ld	ra,72(sp)
    800047a8:	6406                	ld	s0,64(sp)
    800047aa:	74e2                	ld	s1,56(sp)
    800047ac:	7942                	ld	s2,48(sp)
    800047ae:	79a2                	ld	s3,40(sp)
    800047b0:	6161                	addi	sp,sp,80
    800047b2:	8082                	ret
  return -1;
    800047b4:	557d                	li	a0,-1
    800047b6:	bfc5                	j	800047a6 <filestat+0x60>

00000000800047b8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047b8:	7179                	addi	sp,sp,-48
    800047ba:	f406                	sd	ra,40(sp)
    800047bc:	f022                	sd	s0,32(sp)
    800047be:	ec26                	sd	s1,24(sp)
    800047c0:	e84a                	sd	s2,16(sp)
    800047c2:	e44e                	sd	s3,8(sp)
    800047c4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047c6:	00854783          	lbu	a5,8(a0)
    800047ca:	c7c5                	beqz	a5,80004872 <fileread+0xba>
    800047cc:	84aa                	mv	s1,a0
    800047ce:	89ae                	mv	s3,a1
    800047d0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047d2:	411c                	lw	a5,0(a0)
    800047d4:	4705                	li	a4,1
    800047d6:	04e78963          	beq	a5,a4,80004828 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047da:	470d                	li	a4,3
    800047dc:	04e78d63          	beq	a5,a4,80004836 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    800047e0:	4709                	li	a4,2
    800047e2:	08e79063          	bne	a5,a4,80004862 <fileread+0xaa>
    ilock(f->ip);
    800047e6:	6d08                	ld	a0,24(a0)
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	f10080e7          	jalr	-240(ra) # 800036f8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047f0:	874a                	mv	a4,s2
    800047f2:	5094                	lw	a3,32(s1)
    800047f4:	864e                	mv	a2,s3
    800047f6:	4585                	li	a1,1
    800047f8:	6c88                	ld	a0,24(s1)
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	18e080e7          	jalr	398(ra) # 80003988 <readi>
    80004802:	892a                	mv	s2,a0
    80004804:	00a05563          	blez	a0,8000480e <fileread+0x56>
      f->off += r;
    80004808:	509c                	lw	a5,32(s1)
    8000480a:	9fa9                	addw	a5,a5,a0
    8000480c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000480e:	6c88                	ld	a0,24(s1)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	faa080e7          	jalr	-86(ra) # 800037ba <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004818:	854a                	mv	a0,s2
    8000481a:	70a2                	ld	ra,40(sp)
    8000481c:	7402                	ld	s0,32(sp)
    8000481e:	64e2                	ld	s1,24(sp)
    80004820:	6942                	ld	s2,16(sp)
    80004822:	69a2                	ld	s3,8(sp)
    80004824:	6145                	addi	sp,sp,48
    80004826:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004828:	6908                	ld	a0,16(a0)
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	40c080e7          	jalr	1036(ra) # 80004c36 <piperead>
    80004832:	892a                	mv	s2,a0
    80004834:	b7d5                	j	80004818 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004836:	02451783          	lh	a5,36(a0)
    8000483a:	03079693          	slli	a3,a5,0x30
    8000483e:	92c1                	srli	a3,a3,0x30
    80004840:	4725                	li	a4,9
    80004842:	02d76a63          	bltu	a4,a3,80004876 <fileread+0xbe>
    80004846:	0792                	slli	a5,a5,0x4
    80004848:	0001c717          	auipc	a4,0x1c
    8000484c:	81870713          	addi	a4,a4,-2024 # 80020060 <devsw>
    80004850:	97ba                	add	a5,a5,a4
    80004852:	639c                	ld	a5,0(a5)
    80004854:	c39d                	beqz	a5,8000487a <fileread+0xc2>
    r = devsw[f->major].read(f, 1, addr, n);
    80004856:	86b2                	mv	a3,a2
    80004858:	862e                	mv	a2,a1
    8000485a:	4585                	li	a1,1
    8000485c:	9782                	jalr	a5
    8000485e:	892a                	mv	s2,a0
    80004860:	bf65                	j	80004818 <fileread+0x60>
    panic("fileread");
    80004862:	00004517          	auipc	a0,0x4
    80004866:	1c650513          	addi	a0,a0,454 # 80008a28 <userret+0x998>
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	cf0080e7          	jalr	-784(ra) # 8000055a <panic>
    return -1;
    80004872:	597d                	li	s2,-1
    80004874:	b755                	j	80004818 <fileread+0x60>
      return -1;
    80004876:	597d                	li	s2,-1
    80004878:	b745                	j	80004818 <fileread+0x60>
    8000487a:	597d                	li	s2,-1
    8000487c:	bf71                	j	80004818 <fileread+0x60>

000000008000487e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000487e:	00954783          	lbu	a5,9(a0)
    80004882:	14078663          	beqz	a5,800049ce <filewrite+0x150>
{
    80004886:	715d                	addi	sp,sp,-80
    80004888:	e486                	sd	ra,72(sp)
    8000488a:	e0a2                	sd	s0,64(sp)
    8000488c:	fc26                	sd	s1,56(sp)
    8000488e:	f84a                	sd	s2,48(sp)
    80004890:	f44e                	sd	s3,40(sp)
    80004892:	f052                	sd	s4,32(sp)
    80004894:	ec56                	sd	s5,24(sp)
    80004896:	e85a                	sd	s6,16(sp)
    80004898:	e45e                	sd	s7,8(sp)
    8000489a:	e062                	sd	s8,0(sp)
    8000489c:	0880                	addi	s0,sp,80
    8000489e:	84aa                	mv	s1,a0
    800048a0:	8aae                	mv	s5,a1
    800048a2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800048a4:	411c                	lw	a5,0(a0)
    800048a6:	4705                	li	a4,1
    800048a8:	02e78263          	beq	a5,a4,800048cc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048ac:	470d                	li	a4,3
    800048ae:	02e78563          	beq	a5,a4,800048d8 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    800048b2:	4709                	li	a4,2
    800048b4:	10e79563          	bne	a5,a4,800049be <filewrite+0x140>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048b8:	0ec05f63          	blez	a2,800049b6 <filewrite+0x138>
    int i = 0;
    800048bc:	4981                	li	s3,0
    800048be:	6b05                	lui	s6,0x1
    800048c0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800048c4:	6b85                	lui	s7,0x1
    800048c6:	c00b8b9b          	addiw	s7,s7,-1024
    800048ca:	a851                	j	8000495e <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800048cc:	6908                	ld	a0,16(a0)
    800048ce:	00000097          	auipc	ra,0x0
    800048d2:	254080e7          	jalr	596(ra) # 80004b22 <pipewrite>
    800048d6:	a865                	j	8000498e <filewrite+0x110>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048d8:	02451783          	lh	a5,36(a0)
    800048dc:	03079693          	slli	a3,a5,0x30
    800048e0:	92c1                	srli	a3,a3,0x30
    800048e2:	4725                	li	a4,9
    800048e4:	0ed76763          	bltu	a4,a3,800049d2 <filewrite+0x154>
    800048e8:	0792                	slli	a5,a5,0x4
    800048ea:	0001b717          	auipc	a4,0x1b
    800048ee:	77670713          	addi	a4,a4,1910 # 80020060 <devsw>
    800048f2:	97ba                	add	a5,a5,a4
    800048f4:	679c                	ld	a5,8(a5)
    800048f6:	c3e5                	beqz	a5,800049d6 <filewrite+0x158>
    ret = devsw[f->major].write(f, 1, addr, n);
    800048f8:	86b2                	mv	a3,a2
    800048fa:	862e                	mv	a2,a1
    800048fc:	4585                	li	a1,1
    800048fe:	9782                	jalr	a5
    80004900:	a079                	j	8000498e <filewrite+0x110>
    80004902:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    80004906:	6c9c                	ld	a5,24(s1)
    80004908:	4388                	lw	a0,0(a5)
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	7d2080e7          	jalr	2002(ra) # 800040dc <begin_op>
      ilock(f->ip);
    80004912:	6c88                	ld	a0,24(s1)
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	de4080e7          	jalr	-540(ra) # 800036f8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000491c:	8762                	mv	a4,s8
    8000491e:	5094                	lw	a3,32(s1)
    80004920:	01598633          	add	a2,s3,s5
    80004924:	4585                	li	a1,1
    80004926:	6c88                	ld	a0,24(s1)
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	154080e7          	jalr	340(ra) # 80003a7c <writei>
    80004930:	892a                	mv	s2,a0
    80004932:	02a05e63          	blez	a0,8000496e <filewrite+0xf0>
        f->off += r;
    80004936:	509c                	lw	a5,32(s1)
    80004938:	9fa9                	addw	a5,a5,a0
    8000493a:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    8000493c:	6c88                	ld	a0,24(s1)
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	e7c080e7          	jalr	-388(ra) # 800037ba <iunlock>
      end_op(f->ip->dev);
    80004946:	6c9c                	ld	a5,24(s1)
    80004948:	4388                	lw	a0,0(a5)
    8000494a:	00000097          	auipc	ra,0x0
    8000494e:	83c080e7          	jalr	-1988(ra) # 80004186 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004952:	052c1a63          	bne	s8,s2,800049a6 <filewrite+0x128>
        panic("short filewrite");
      i += r;
    80004956:	013909bb          	addw	s3,s2,s3
    while(i < n){
    8000495a:	0349d763          	bge	s3,s4,80004988 <filewrite+0x10a>
      int n1 = n - i;
    8000495e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004962:	893e                	mv	s2,a5
    80004964:	2781                	sext.w	a5,a5
    80004966:	f8fb5ee3          	bge	s6,a5,80004902 <filewrite+0x84>
    8000496a:	895e                	mv	s2,s7
    8000496c:	bf59                	j	80004902 <filewrite+0x84>
      iunlock(f->ip);
    8000496e:	6c88                	ld	a0,24(s1)
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	e4a080e7          	jalr	-438(ra) # 800037ba <iunlock>
      end_op(f->ip->dev);
    80004978:	6c9c                	ld	a5,24(s1)
    8000497a:	4388                	lw	a0,0(a5)
    8000497c:	00000097          	auipc	ra,0x0
    80004980:	80a080e7          	jalr	-2038(ra) # 80004186 <end_op>
      if(r < 0)
    80004984:	fc0957e3          	bgez	s2,80004952 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004988:	8552                	mv	a0,s4
    8000498a:	033a1863          	bne	s4,s3,800049ba <filewrite+0x13c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000498e:	60a6                	ld	ra,72(sp)
    80004990:	6406                	ld	s0,64(sp)
    80004992:	74e2                	ld	s1,56(sp)
    80004994:	7942                	ld	s2,48(sp)
    80004996:	79a2                	ld	s3,40(sp)
    80004998:	7a02                	ld	s4,32(sp)
    8000499a:	6ae2                	ld	s5,24(sp)
    8000499c:	6b42                	ld	s6,16(sp)
    8000499e:	6ba2                	ld	s7,8(sp)
    800049a0:	6c02                	ld	s8,0(sp)
    800049a2:	6161                	addi	sp,sp,80
    800049a4:	8082                	ret
        panic("short filewrite");
    800049a6:	00004517          	auipc	a0,0x4
    800049aa:	09250513          	addi	a0,a0,146 # 80008a38 <userret+0x9a8>
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	bac080e7          	jalr	-1108(ra) # 8000055a <panic>
    int i = 0;
    800049b6:	4981                	li	s3,0
    800049b8:	bfc1                	j	80004988 <filewrite+0x10a>
    ret = (i == n ? n : -1);
    800049ba:	557d                	li	a0,-1
    800049bc:	bfc9                	j	8000498e <filewrite+0x110>
    panic("filewrite");
    800049be:	00004517          	auipc	a0,0x4
    800049c2:	08a50513          	addi	a0,a0,138 # 80008a48 <userret+0x9b8>
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	b94080e7          	jalr	-1132(ra) # 8000055a <panic>
    return -1;
    800049ce:	557d                	li	a0,-1
}
    800049d0:	8082                	ret
      return -1;
    800049d2:	557d                	li	a0,-1
    800049d4:	bf6d                	j	8000498e <filewrite+0x110>
    800049d6:	557d                	li	a0,-1
    800049d8:	bf5d                	j	8000498e <filewrite+0x110>

00000000800049da <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049da:	7179                	addi	sp,sp,-48
    800049dc:	f406                	sd	ra,40(sp)
    800049de:	f022                	sd	s0,32(sp)
    800049e0:	ec26                	sd	s1,24(sp)
    800049e2:	e84a                	sd	s2,16(sp)
    800049e4:	e44e                	sd	s3,8(sp)
    800049e6:	e052                	sd	s4,0(sp)
    800049e8:	1800                	addi	s0,sp,48
    800049ea:	84aa                	mv	s1,a0
    800049ec:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049ee:	0005b023          	sd	zero,0(a1)
    800049f2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049f6:	00000097          	auipc	ra,0x0
    800049fa:	bc4080e7          	jalr	-1084(ra) # 800045ba <filealloc>
    800049fe:	e088                	sd	a0,0(s1)
    80004a00:	c549                	beqz	a0,80004a8a <pipealloc+0xb0>
    80004a02:	00000097          	auipc	ra,0x0
    80004a06:	bb8080e7          	jalr	-1096(ra) # 800045ba <filealloc>
    80004a0a:	00aa3023          	sd	a0,0(s4)
    80004a0e:	c925                	beqz	a0,80004a7e <pipealloc+0xa4>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a10:	ffffc097          	auipc	ra,0xffffc
    80004a14:	f6c080e7          	jalr	-148(ra) # 8000097c <kalloc>
    80004a18:	892a                	mv	s2,a0
    80004a1a:	cd39                	beqz	a0,80004a78 <pipealloc+0x9e>
    goto bad;
  pi->readopen = 1;
    80004a1c:	4985                	li	s3,1
    80004a1e:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004a22:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004a26:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004a2a:	22052023          	sw	zero,544(a0)
  memset(&pi->lock, 0, sizeof(pi->lock));
    80004a2e:	02000613          	li	a2,32
    80004a32:	4581                	li	a1,0
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	34a080e7          	jalr	842(ra) # 80000d7e <memset>
  (*f0)->type = FD_PIPE;
    80004a3c:	609c                	ld	a5,0(s1)
    80004a3e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a42:	609c                	ld	a5,0(s1)
    80004a44:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a48:	609c                	ld	a5,0(s1)
    80004a4a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a4e:	609c                	ld	a5,0(s1)
    80004a50:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a54:	000a3783          	ld	a5,0(s4)
    80004a58:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a5c:	000a3783          	ld	a5,0(s4)
    80004a60:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a64:	000a3783          	ld	a5,0(s4)
    80004a68:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a6c:	000a3783          	ld	a5,0(s4)
    80004a70:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a74:	4501                	li	a0,0
    80004a76:	a025                	j	80004a9e <pipealloc+0xc4>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a78:	6088                	ld	a0,0(s1)
    80004a7a:	e501                	bnez	a0,80004a82 <pipealloc+0xa8>
    80004a7c:	a039                	j	80004a8a <pipealloc+0xb0>
    80004a7e:	6088                	ld	a0,0(s1)
    80004a80:	c51d                	beqz	a0,80004aae <pipealloc+0xd4>
    fileclose(*f0);
    80004a82:	00000097          	auipc	ra,0x0
    80004a86:	bf4080e7          	jalr	-1036(ra) # 80004676 <fileclose>
  if(*f1)
    80004a8a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a8e:	557d                	li	a0,-1
  if(*f1)
    80004a90:	c799                	beqz	a5,80004a9e <pipealloc+0xc4>
    fileclose(*f1);
    80004a92:	853e                	mv	a0,a5
    80004a94:	00000097          	auipc	ra,0x0
    80004a98:	be2080e7          	jalr	-1054(ra) # 80004676 <fileclose>
  return -1;
    80004a9c:	557d                	li	a0,-1
}
    80004a9e:	70a2                	ld	ra,40(sp)
    80004aa0:	7402                	ld	s0,32(sp)
    80004aa2:	64e2                	ld	s1,24(sp)
    80004aa4:	6942                	ld	s2,16(sp)
    80004aa6:	69a2                	ld	s3,8(sp)
    80004aa8:	6a02                	ld	s4,0(sp)
    80004aaa:	6145                	addi	sp,sp,48
    80004aac:	8082                	ret
  return -1;
    80004aae:	557d                	li	a0,-1
    80004ab0:	b7fd                	j	80004a9e <pipealloc+0xc4>

0000000080004ab2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ab2:	1101                	addi	sp,sp,-32
    80004ab4:	ec06                	sd	ra,24(sp)
    80004ab6:	e822                	sd	s0,16(sp)
    80004ab8:	e426                	sd	s1,8(sp)
    80004aba:	e04a                	sd	s2,0(sp)
    80004abc:	1000                	addi	s0,sp,32
    80004abe:	84aa                	mv	s1,a0
    80004ac0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ac2:	ffffc097          	auipc	ra,0xffffc
    80004ac6:	fee080e7          	jalr	-18(ra) # 80000ab0 <acquire>
  if(writable){
    80004aca:	02090d63          	beqz	s2,80004b04 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ace:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004ad2:	22048513          	addi	a0,s1,544
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	8d6080e7          	jalr	-1834(ra) # 800023ac <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004ade:	2284b783          	ld	a5,552(s1)
    80004ae2:	eb95                	bnez	a5,80004b16 <pipeclose+0x64>
    release(&pi->lock);
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	09a080e7          	jalr	154(ra) # 80000b80 <release>
    kfree((char*)pi);
    80004aee:	8526                	mv	a0,s1
    80004af0:	ffffc097          	auipc	ra,0xffffc
    80004af4:	d90080e7          	jalr	-624(ra) # 80000880 <kfree>
  } else
    release(&pi->lock);
}
    80004af8:	60e2                	ld	ra,24(sp)
    80004afa:	6442                	ld	s0,16(sp)
    80004afc:	64a2                	ld	s1,8(sp)
    80004afe:	6902                	ld	s2,0(sp)
    80004b00:	6105                	addi	sp,sp,32
    80004b02:	8082                	ret
    pi->readopen = 0;
    80004b04:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004b08:	22448513          	addi	a0,s1,548
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	8a0080e7          	jalr	-1888(ra) # 800023ac <wakeup>
    80004b14:	b7e9                	j	80004ade <pipeclose+0x2c>
    release(&pi->lock);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffc097          	auipc	ra,0xffffc
    80004b1c:	068080e7          	jalr	104(ra) # 80000b80 <release>
}
    80004b20:	bfe1                	j	80004af8 <pipeclose+0x46>

0000000080004b22 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b22:	7159                	addi	sp,sp,-112
    80004b24:	f486                	sd	ra,104(sp)
    80004b26:	f0a2                	sd	s0,96(sp)
    80004b28:	eca6                	sd	s1,88(sp)
    80004b2a:	e8ca                	sd	s2,80(sp)
    80004b2c:	e4ce                	sd	s3,72(sp)
    80004b2e:	e0d2                	sd	s4,64(sp)
    80004b30:	fc56                	sd	s5,56(sp)
    80004b32:	f85a                	sd	s6,48(sp)
    80004b34:	f45e                	sd	s7,40(sp)
    80004b36:	f062                	sd	s8,32(sp)
    80004b38:	ec66                	sd	s9,24(sp)
    80004b3a:	1880                	addi	s0,sp,112
    80004b3c:	84aa                	mv	s1,a0
    80004b3e:	8b2e                	mv	s6,a1
    80004b40:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004b42:	ffffd097          	auipc	ra,0xffffd
    80004b46:	f28080e7          	jalr	-216(ra) # 80001a6a <myproc>
    80004b4a:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	ffffc097          	auipc	ra,0xffffc
    80004b52:	f62080e7          	jalr	-158(ra) # 80000ab0 <acquire>
  for(i = 0; i < n; i++){
    80004b56:	0b505063          	blez	s5,80004bf6 <pipewrite+0xd4>
    80004b5a:	8926                	mv	s2,s1
    80004b5c:	fffa8b9b          	addiw	s7,s5,-1
    80004b60:	1b82                	slli	s7,s7,0x20
    80004b62:	020bdb93          	srli	s7,s7,0x20
    80004b66:	001b0793          	addi	a5,s6,1
    80004b6a:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004b6c:	22048a13          	addi	s4,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004b70:	22448993          	addi	s3,s1,548
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b74:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004b76:	2204a783          	lw	a5,544(s1)
    80004b7a:	2244a703          	lw	a4,548(s1)
    80004b7e:	2007879b          	addiw	a5,a5,512
    80004b82:	02f71e63          	bne	a4,a5,80004bbe <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004b86:	2284a783          	lw	a5,552(s1)
    80004b8a:	c3d9                	beqz	a5,80004c10 <pipewrite+0xee>
    80004b8c:	ffffd097          	auipc	ra,0xffffd
    80004b90:	ede080e7          	jalr	-290(ra) # 80001a6a <myproc>
    80004b94:	5d1c                	lw	a5,56(a0)
    80004b96:	efad                	bnez	a5,80004c10 <pipewrite+0xee>
      wakeup(&pi->nread);
    80004b98:	8552                	mv	a0,s4
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	812080e7          	jalr	-2030(ra) # 800023ac <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ba2:	85ca                	mv	a1,s2
    80004ba4:	854e                	mv	a0,s3
    80004ba6:	ffffd097          	auipc	ra,0xffffd
    80004baa:	680080e7          	jalr	1664(ra) # 80002226 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004bae:	2204a783          	lw	a5,544(s1)
    80004bb2:	2244a703          	lw	a4,548(s1)
    80004bb6:	2007879b          	addiw	a5,a5,512
    80004bba:	fcf706e3          	beq	a4,a5,80004b86 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004bbe:	4685                	li	a3,1
    80004bc0:	865a                	mv	a2,s6
    80004bc2:	f9f40593          	addi	a1,s0,-97
    80004bc6:	058c3503          	ld	a0,88(s8)
    80004bca:	ffffd097          	auipc	ra,0xffffd
    80004bce:	c20080e7          	jalr	-992(ra) # 800017ea <copyin>
    80004bd2:	03950263          	beq	a0,s9,80004bf6 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004bd6:	2244a783          	lw	a5,548(s1)
    80004bda:	0017871b          	addiw	a4,a5,1
    80004bde:	22e4a223          	sw	a4,548(s1)
    80004be2:	1ff7f793          	andi	a5,a5,511
    80004be6:	97a6                	add	a5,a5,s1
    80004be8:	f9f44703          	lbu	a4,-97(s0)
    80004bec:	02e78023          	sb	a4,32(a5)
  for(i = 0; i < n; i++){
    80004bf0:	0b05                	addi	s6,s6,1
    80004bf2:	f97b12e3          	bne	s6,s7,80004b76 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004bf6:	22048513          	addi	a0,s1,544
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	7b2080e7          	jalr	1970(ra) # 800023ac <wakeup>
  release(&pi->lock);
    80004c02:	8526                	mv	a0,s1
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	f7c080e7          	jalr	-132(ra) # 80000b80 <release>
  return n;
    80004c0c:	8556                	mv	a0,s5
    80004c0e:	a039                	j	80004c1c <pipewrite+0xfa>
        release(&pi->lock);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffc097          	auipc	ra,0xffffc
    80004c16:	f6e080e7          	jalr	-146(ra) # 80000b80 <release>
        return -1;
    80004c1a:	557d                	li	a0,-1
}
    80004c1c:	70a6                	ld	ra,104(sp)
    80004c1e:	7406                	ld	s0,96(sp)
    80004c20:	64e6                	ld	s1,88(sp)
    80004c22:	6946                	ld	s2,80(sp)
    80004c24:	69a6                	ld	s3,72(sp)
    80004c26:	6a06                	ld	s4,64(sp)
    80004c28:	7ae2                	ld	s5,56(sp)
    80004c2a:	7b42                	ld	s6,48(sp)
    80004c2c:	7ba2                	ld	s7,40(sp)
    80004c2e:	7c02                	ld	s8,32(sp)
    80004c30:	6ce2                	ld	s9,24(sp)
    80004c32:	6165                	addi	sp,sp,112
    80004c34:	8082                	ret

0000000080004c36 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c36:	715d                	addi	sp,sp,-80
    80004c38:	e486                	sd	ra,72(sp)
    80004c3a:	e0a2                	sd	s0,64(sp)
    80004c3c:	fc26                	sd	s1,56(sp)
    80004c3e:	f84a                	sd	s2,48(sp)
    80004c40:	f44e                	sd	s3,40(sp)
    80004c42:	f052                	sd	s4,32(sp)
    80004c44:	ec56                	sd	s5,24(sp)
    80004c46:	e85a                	sd	s6,16(sp)
    80004c48:	0880                	addi	s0,sp,80
    80004c4a:	84aa                	mv	s1,a0
    80004c4c:	892e                	mv	s2,a1
    80004c4e:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004c50:	ffffd097          	auipc	ra,0xffffd
    80004c54:	e1a080e7          	jalr	-486(ra) # 80001a6a <myproc>
    80004c58:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004c5a:	8b26                	mv	s6,s1
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	ffffc097          	auipc	ra,0xffffc
    80004c62:	e52080e7          	jalr	-430(ra) # 80000ab0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c66:	2204a703          	lw	a4,544(s1)
    80004c6a:	2244a783          	lw	a5,548(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c6e:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c72:	02f71763          	bne	a4,a5,80004ca0 <piperead+0x6a>
    80004c76:	22c4a783          	lw	a5,556(s1)
    80004c7a:	c39d                	beqz	a5,80004ca0 <piperead+0x6a>
    if(myproc()->killed){
    80004c7c:	ffffd097          	auipc	ra,0xffffd
    80004c80:	dee080e7          	jalr	-530(ra) # 80001a6a <myproc>
    80004c84:	5d1c                	lw	a5,56(a0)
    80004c86:	ebc1                	bnez	a5,80004d16 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c88:	85da                	mv	a1,s6
    80004c8a:	854e                	mv	a0,s3
    80004c8c:	ffffd097          	auipc	ra,0xffffd
    80004c90:	59a080e7          	jalr	1434(ra) # 80002226 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c94:	2204a703          	lw	a4,544(s1)
    80004c98:	2244a783          	lw	a5,548(s1)
    80004c9c:	fcf70de3          	beq	a4,a5,80004c76 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ca0:	09405263          	blez	s4,80004d24 <piperead+0xee>
    80004ca4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ca6:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004ca8:	2204a783          	lw	a5,544(s1)
    80004cac:	2244a703          	lw	a4,548(s1)
    80004cb0:	02f70d63          	beq	a4,a5,80004cea <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004cb4:	0017871b          	addiw	a4,a5,1
    80004cb8:	22e4a023          	sw	a4,544(s1)
    80004cbc:	1ff7f793          	andi	a5,a5,511
    80004cc0:	97a6                	add	a5,a5,s1
    80004cc2:	0207c783          	lbu	a5,32(a5)
    80004cc6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004cca:	4685                	li	a3,1
    80004ccc:	fbf40613          	addi	a2,s0,-65
    80004cd0:	85ca                	mv	a1,s2
    80004cd2:	058ab503          	ld	a0,88(s5)
    80004cd6:	ffffd097          	auipc	ra,0xffffd
    80004cda:	a88080e7          	jalr	-1400(ra) # 8000175e <copyout>
    80004cde:	01650663          	beq	a0,s6,80004cea <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ce2:	2985                	addiw	s3,s3,1
    80004ce4:	0905                	addi	s2,s2,1
    80004ce6:	fd3a11e3          	bne	s4,s3,80004ca8 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004cea:	22448513          	addi	a0,s1,548
    80004cee:	ffffd097          	auipc	ra,0xffffd
    80004cf2:	6be080e7          	jalr	1726(ra) # 800023ac <wakeup>
  release(&pi->lock);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	e88080e7          	jalr	-376(ra) # 80000b80 <release>
  return i;
}
    80004d00:	854e                	mv	a0,s3
    80004d02:	60a6                	ld	ra,72(sp)
    80004d04:	6406                	ld	s0,64(sp)
    80004d06:	74e2                	ld	s1,56(sp)
    80004d08:	7942                	ld	s2,48(sp)
    80004d0a:	79a2                	ld	s3,40(sp)
    80004d0c:	7a02                	ld	s4,32(sp)
    80004d0e:	6ae2                	ld	s5,24(sp)
    80004d10:	6b42                	ld	s6,16(sp)
    80004d12:	6161                	addi	sp,sp,80
    80004d14:	8082                	ret
      release(&pi->lock);
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffc097          	auipc	ra,0xffffc
    80004d1c:	e68080e7          	jalr	-408(ra) # 80000b80 <release>
      return -1;
    80004d20:	59fd                	li	s3,-1
    80004d22:	bff9                	j	80004d00 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d24:	4981                	li	s3,0
    80004d26:	b7d1                	j	80004cea <piperead+0xb4>

0000000080004d28 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004d28:	df010113          	addi	sp,sp,-528
    80004d2c:	20113423          	sd	ra,520(sp)
    80004d30:	20813023          	sd	s0,512(sp)
    80004d34:	ffa6                	sd	s1,504(sp)
    80004d36:	fbca                	sd	s2,496(sp)
    80004d38:	f7ce                	sd	s3,488(sp)
    80004d3a:	f3d2                	sd	s4,480(sp)
    80004d3c:	efd6                	sd	s5,472(sp)
    80004d3e:	ebda                	sd	s6,464(sp)
    80004d40:	e7de                	sd	s7,456(sp)
    80004d42:	e3e2                	sd	s8,448(sp)
    80004d44:	ff66                	sd	s9,440(sp)
    80004d46:	fb6a                	sd	s10,432(sp)
    80004d48:	f76e                	sd	s11,424(sp)
    80004d4a:	0c00                	addi	s0,sp,528
    80004d4c:	84aa                	mv	s1,a0
    80004d4e:	dea43c23          	sd	a0,-520(s0)
    80004d52:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d56:	ffffd097          	auipc	ra,0xffffd
    80004d5a:	d14080e7          	jalr	-748(ra) # 80001a6a <myproc>
    80004d5e:	892a                	mv	s2,a0

  begin_op(ROOTDEV);
    80004d60:	4501                	li	a0,0
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	37a080e7          	jalr	890(ra) # 800040dc <begin_op>

  if((ip = namei(path)) == 0){
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	116080e7          	jalr	278(ra) # 80003e82 <namei>
    80004d74:	c935                	beqz	a0,80004de8 <exec+0xc0>
    80004d76:	84aa                	mv	s1,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	980080e7          	jalr	-1664(ra) # 800036f8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d80:	04000713          	li	a4,64
    80004d84:	4681                	li	a3,0
    80004d86:	e4840613          	addi	a2,s0,-440
    80004d8a:	4581                	li	a1,0
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	bfa080e7          	jalr	-1030(ra) # 80003988 <readi>
    80004d96:	04000793          	li	a5,64
    80004d9a:	00f51a63          	bne	a0,a5,80004dae <exec+0x86>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004d9e:	e4842703          	lw	a4,-440(s0)
    80004da2:	464c47b7          	lui	a5,0x464c4
    80004da6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004daa:	04f70663          	beq	a4,a5,80004df6 <exec+0xce>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004dae:	8526                	mv	a0,s1
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	b86080e7          	jalr	-1146(ra) # 80003936 <iunlockput>
    end_op(ROOTDEV);
    80004db8:	4501                	li	a0,0
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	3cc080e7          	jalr	972(ra) # 80004186 <end_op>
  }
  return -1;
    80004dc2:	557d                	li	a0,-1
}
    80004dc4:	20813083          	ld	ra,520(sp)
    80004dc8:	20013403          	ld	s0,512(sp)
    80004dcc:	74fe                	ld	s1,504(sp)
    80004dce:	795e                	ld	s2,496(sp)
    80004dd0:	79be                	ld	s3,488(sp)
    80004dd2:	7a1e                	ld	s4,480(sp)
    80004dd4:	6afe                	ld	s5,472(sp)
    80004dd6:	6b5e                	ld	s6,464(sp)
    80004dd8:	6bbe                	ld	s7,456(sp)
    80004dda:	6c1e                	ld	s8,448(sp)
    80004ddc:	7cfa                	ld	s9,440(sp)
    80004dde:	7d5a                	ld	s10,432(sp)
    80004de0:	7dba                	ld	s11,424(sp)
    80004de2:	21010113          	addi	sp,sp,528
    80004de6:	8082                	ret
    end_op(ROOTDEV);
    80004de8:	4501                	li	a0,0
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	39c080e7          	jalr	924(ra) # 80004186 <end_op>
    return -1;
    80004df2:	557d                	li	a0,-1
    80004df4:	bfc1                	j	80004dc4 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004df6:	854a                	mv	a0,s2
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	d36080e7          	jalr	-714(ra) # 80001b2e <proc_pagetable>
    80004e00:	8c2a                	mv	s8,a0
    80004e02:	d555                	beqz	a0,80004dae <exec+0x86>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e04:	e6842983          	lw	s3,-408(s0)
    80004e08:	e8045783          	lhu	a5,-384(s0)
    80004e0c:	c7fd                	beqz	a5,80004efa <exec+0x1d2>
  sz = 0;
    80004e0e:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e12:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80004e14:	6b05                	lui	s6,0x1
    80004e16:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004e1a:	def43823          	sd	a5,-528(s0)
    80004e1e:	a0a5                	j	80004e86 <exec+0x15e>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004e20:	00004517          	auipc	a0,0x4
    80004e24:	c3850513          	addi	a0,a0,-968 # 80008a58 <userret+0x9c8>
    80004e28:	ffffb097          	auipc	ra,0xffffb
    80004e2c:	732080e7          	jalr	1842(ra) # 8000055a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e30:	8756                	mv	a4,s5
    80004e32:	012d86bb          	addw	a3,s11,s2
    80004e36:	4581                	li	a1,0
    80004e38:	8526                	mv	a0,s1
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	b4e080e7          	jalr	-1202(ra) # 80003988 <readi>
    80004e42:	2501                	sext.w	a0,a0
    80004e44:	10aa9263          	bne	s5,a0,80004f48 <exec+0x220>
  for(i = 0; i < sz; i += PGSIZE){
    80004e48:	6785                	lui	a5,0x1
    80004e4a:	0127893b          	addw	s2,a5,s2
    80004e4e:	77fd                	lui	a5,0xfffff
    80004e50:	01478a3b          	addw	s4,a5,s4
    80004e54:	03997263          	bgeu	s2,s9,80004e78 <exec+0x150>
    pa = walkaddr(pagetable, va + i);
    80004e58:	02091593          	slli	a1,s2,0x20
    80004e5c:	9181                	srli	a1,a1,0x20
    80004e5e:	95ea                	add	a1,a1,s10
    80004e60:	8562                	mv	a0,s8
    80004e62:	ffffc097          	auipc	ra,0xffffc
    80004e66:	31a080e7          	jalr	794(ra) # 8000117c <walkaddr>
    80004e6a:	862a                	mv	a2,a0
    if(pa == 0)
    80004e6c:	d955                	beqz	a0,80004e20 <exec+0xf8>
      n = PGSIZE;
    80004e6e:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    80004e70:	fd6a70e3          	bgeu	s4,s6,80004e30 <exec+0x108>
      n = sz - i;
    80004e74:	8ad2                	mv	s5,s4
    80004e76:	bf6d                	j	80004e30 <exec+0x108>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e78:	2b85                	addiw	s7,s7,1
    80004e7a:	0389899b          	addiw	s3,s3,56
    80004e7e:	e8045783          	lhu	a5,-384(s0)
    80004e82:	06fbde63          	bge	s7,a5,80004efe <exec+0x1d6>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e86:	2981                	sext.w	s3,s3
    80004e88:	03800713          	li	a4,56
    80004e8c:	86ce                	mv	a3,s3
    80004e8e:	e1040613          	addi	a2,s0,-496
    80004e92:	4581                	li	a1,0
    80004e94:	8526                	mv	a0,s1
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	af2080e7          	jalr	-1294(ra) # 80003988 <readi>
    80004e9e:	03800793          	li	a5,56
    80004ea2:	0af51363          	bne	a0,a5,80004f48 <exec+0x220>
    if(ph.type != ELF_PROG_LOAD)
    80004ea6:	e1042783          	lw	a5,-496(s0)
    80004eaa:	4705                	li	a4,1
    80004eac:	fce796e3          	bne	a5,a4,80004e78 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004eb0:	e3843603          	ld	a2,-456(s0)
    80004eb4:	e3043783          	ld	a5,-464(s0)
    80004eb8:	08f66863          	bltu	a2,a5,80004f48 <exec+0x220>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ebc:	e2043783          	ld	a5,-480(s0)
    80004ec0:	963e                	add	a2,a2,a5
    80004ec2:	08f66363          	bltu	a2,a5,80004f48 <exec+0x220>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004ec6:	e0843583          	ld	a1,-504(s0)
    80004eca:	8562                	mv	a0,s8
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	6b8080e7          	jalr	1720(ra) # 80001584 <uvmalloc>
    80004ed4:	e0a43423          	sd	a0,-504(s0)
    80004ed8:	c925                	beqz	a0,80004f48 <exec+0x220>
    if(ph.vaddr % PGSIZE != 0)
    80004eda:	e2043d03          	ld	s10,-480(s0)
    80004ede:	df043783          	ld	a5,-528(s0)
    80004ee2:	00fd77b3          	and	a5,s10,a5
    80004ee6:	e3ad                	bnez	a5,80004f48 <exec+0x220>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ee8:	e1842d83          	lw	s11,-488(s0)
    80004eec:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ef0:	f80c84e3          	beqz	s9,80004e78 <exec+0x150>
    80004ef4:	8a66                	mv	s4,s9
    80004ef6:	4901                	li	s2,0
    80004ef8:	b785                	j	80004e58 <exec+0x130>
  sz = 0;
    80004efa:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80004efe:	8526                	mv	a0,s1
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	a36080e7          	jalr	-1482(ra) # 80003936 <iunlockput>
  end_op(ROOTDEV);
    80004f08:	4501                	li	a0,0
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	27c080e7          	jalr	636(ra) # 80004186 <end_op>
  p = myproc();
    80004f12:	ffffd097          	auipc	ra,0xffffd
    80004f16:	b58080e7          	jalr	-1192(ra) # 80001a6a <myproc>
    80004f1a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004f1c:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004f20:	6585                	lui	a1,0x1
    80004f22:	15fd                	addi	a1,a1,-1
    80004f24:	e0843783          	ld	a5,-504(s0)
    80004f28:	00b78b33          	add	s6,a5,a1
    80004f2c:	75fd                	lui	a1,0xfffff
    80004f2e:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f32:	6609                	lui	a2,0x2
    80004f34:	962e                	add	a2,a2,a1
    80004f36:	8562                	mv	a0,s8
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	64c080e7          	jalr	1612(ra) # 80001584 <uvmalloc>
    80004f40:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004f44:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f46:	ed01                	bnez	a0,80004f5e <exec+0x236>
    proc_freepagetable(pagetable, sz);
    80004f48:	e0843583          	ld	a1,-504(s0)
    80004f4c:	8562                	mv	a0,s8
    80004f4e:	ffffd097          	auipc	ra,0xffffd
    80004f52:	ce0080e7          	jalr	-800(ra) # 80001c2e <proc_freepagetable>
  if(ip){
    80004f56:	e4049ce3          	bnez	s1,80004dae <exec+0x86>
  return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	b5a5                	j	80004dc4 <exec+0x9c>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f5e:	75f9                	lui	a1,0xffffe
    80004f60:	84aa                	mv	s1,a0
    80004f62:	95aa                	add	a1,a1,a0
    80004f64:	8562                	mv	a0,s8
    80004f66:	ffffc097          	auipc	ra,0xffffc
    80004f6a:	7c6080e7          	jalr	1990(ra) # 8000172c <uvmclear>
  stackbase = sp - PGSIZE;
    80004f6e:	7afd                	lui	s5,0xfffff
    80004f70:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004f72:	e0043783          	ld	a5,-512(s0)
    80004f76:	6388                	ld	a0,0(a5)
    80004f78:	c135                	beqz	a0,80004fdc <exec+0x2b4>
    80004f7a:	e8840993          	addi	s3,s0,-376
    80004f7e:	f8840c93          	addi	s9,s0,-120
    80004f82:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004f84:	ffffc097          	auipc	ra,0xffffc
    80004f88:	f82080e7          	jalr	-126(ra) # 80000f06 <strlen>
    80004f8c:	2505                	addiw	a0,a0,1
    80004f8e:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f90:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80004f92:	0f54ea63          	bltu	s1,s5,80005086 <exec+0x35e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f96:	e0043b03          	ld	s6,-512(s0)
    80004f9a:	000b3a03          	ld	s4,0(s6)
    80004f9e:	8552                	mv	a0,s4
    80004fa0:	ffffc097          	auipc	ra,0xffffc
    80004fa4:	f66080e7          	jalr	-154(ra) # 80000f06 <strlen>
    80004fa8:	0015069b          	addiw	a3,a0,1
    80004fac:	8652                	mv	a2,s4
    80004fae:	85a6                	mv	a1,s1
    80004fb0:	8562                	mv	a0,s8
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	7ac080e7          	jalr	1964(ra) # 8000175e <copyout>
    80004fba:	0c054863          	bltz	a0,8000508a <exec+0x362>
    ustack[argc] = sp;
    80004fbe:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004fc2:	0905                	addi	s2,s2,1
    80004fc4:	008b0793          	addi	a5,s6,8
    80004fc8:	e0f43023          	sd	a5,-512(s0)
    80004fcc:	008b3503          	ld	a0,8(s6)
    80004fd0:	c909                	beqz	a0,80004fe2 <exec+0x2ba>
    if(argc >= MAXARG)
    80004fd2:	09a1                	addi	s3,s3,8
    80004fd4:	fb3c98e3          	bne	s9,s3,80004f84 <exec+0x25c>
  ip = 0;
    80004fd8:	4481                	li	s1,0
    80004fda:	b7bd                	j	80004f48 <exec+0x220>
  sp = sz;
    80004fdc:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004fe0:	4901                	li	s2,0
  ustack[argc] = 0;
    80004fe2:	00391793          	slli	a5,s2,0x3
    80004fe6:	f9040713          	addi	a4,s0,-112
    80004fea:	97ba                	add	a5,a5,a4
    80004fec:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd6e9c>
  sp -= (argc+1) * sizeof(uint64);
    80004ff0:	00190693          	addi	a3,s2,1
    80004ff4:	068e                	slli	a3,a3,0x3
    80004ff6:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80004ff8:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80004ffc:	4481                	li	s1,0
  if(sp < stackbase)
    80004ffe:	f559e5e3          	bltu	s3,s5,80004f48 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005002:	e8840613          	addi	a2,s0,-376
    80005006:	85ce                	mv	a1,s3
    80005008:	8562                	mv	a0,s8
    8000500a:	ffffc097          	auipc	ra,0xffffc
    8000500e:	754080e7          	jalr	1876(ra) # 8000175e <copyout>
    80005012:	06054e63          	bltz	a0,8000508e <exec+0x366>
  p->tf->a1 = sp;
    80005016:	060bb783          	ld	a5,96(s7) # 1060 <_entry-0x7fffefa0>
    8000501a:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    8000501e:	df843783          	ld	a5,-520(s0)
    80005022:	0007c703          	lbu	a4,0(a5)
    80005026:	cf11                	beqz	a4,80005042 <exec+0x31a>
    80005028:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000502a:	02f00693          	li	a3,47
    8000502e:	a029                	j	80005038 <exec+0x310>
  for(last=s=path; *s; s++)
    80005030:	0785                	addi	a5,a5,1
    80005032:	fff7c703          	lbu	a4,-1(a5)
    80005036:	c711                	beqz	a4,80005042 <exec+0x31a>
    if(*s == '/')
    80005038:	fed71ce3          	bne	a4,a3,80005030 <exec+0x308>
      last = s+1;
    8000503c:	def43c23          	sd	a5,-520(s0)
    80005040:	bfc5                	j	80005030 <exec+0x308>
  safestrcpy(p->name, last, sizeof(p->name));
    80005042:	4641                	li	a2,16
    80005044:	df843583          	ld	a1,-520(s0)
    80005048:	160b8513          	addi	a0,s7,352
    8000504c:	ffffc097          	auipc	ra,0xffffc
    80005050:	e88080e7          	jalr	-376(ra) # 80000ed4 <safestrcpy>
  oldpagetable = p->pagetable;
    80005054:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80005058:	058bbc23          	sd	s8,88(s7)
  p->sz = sz;
    8000505c:	e0843783          	ld	a5,-504(s0)
    80005060:	04fbb823          	sd	a5,80(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80005064:	060bb783          	ld	a5,96(s7)
    80005068:	e6043703          	ld	a4,-416(s0)
    8000506c:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    8000506e:	060bb783          	ld	a5,96(s7)
    80005072:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005076:	85ea                	mv	a1,s10
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	bb6080e7          	jalr	-1098(ra) # 80001c2e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005080:	0009051b          	sext.w	a0,s2
    80005084:	b381                	j	80004dc4 <exec+0x9c>
  ip = 0;
    80005086:	4481                	li	s1,0
    80005088:	b5c1                	j	80004f48 <exec+0x220>
    8000508a:	4481                	li	s1,0
    8000508c:	bd75                	j	80004f48 <exec+0x220>
    8000508e:	4481                	li	s1,0
    80005090:	bd65                	j	80004f48 <exec+0x220>

0000000080005092 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005092:	7179                	addi	sp,sp,-48
    80005094:	f406                	sd	ra,40(sp)
    80005096:	f022                	sd	s0,32(sp)
    80005098:	ec26                	sd	s1,24(sp)
    8000509a:	e84a                	sd	s2,16(sp)
    8000509c:	1800                	addi	s0,sp,48
    8000509e:	892e                	mv	s2,a1
    800050a0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800050a2:	fdc40593          	addi	a1,s0,-36
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	adc080e7          	jalr	-1316(ra) # 80002b82 <argint>
    800050ae:	04054063          	bltz	a0,800050ee <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050b2:	fdc42703          	lw	a4,-36(s0)
    800050b6:	47bd                	li	a5,15
    800050b8:	02e7ed63          	bltu	a5,a4,800050f2 <argfd+0x60>
    800050bc:	ffffd097          	auipc	ra,0xffffd
    800050c0:	9ae080e7          	jalr	-1618(ra) # 80001a6a <myproc>
    800050c4:	fdc42703          	lw	a4,-36(s0)
    800050c8:	01a70793          	addi	a5,a4,26
    800050cc:	078e                	slli	a5,a5,0x3
    800050ce:	953e                	add	a0,a0,a5
    800050d0:	651c                	ld	a5,8(a0)
    800050d2:	c395                	beqz	a5,800050f6 <argfd+0x64>
    return -1;
  if(pfd)
    800050d4:	00090463          	beqz	s2,800050dc <argfd+0x4a>
    *pfd = fd;
    800050d8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050dc:	4501                	li	a0,0
  if(pf)
    800050de:	c091                	beqz	s1,800050e2 <argfd+0x50>
    *pf = f;
    800050e0:	e09c                	sd	a5,0(s1)
}
    800050e2:	70a2                	ld	ra,40(sp)
    800050e4:	7402                	ld	s0,32(sp)
    800050e6:	64e2                	ld	s1,24(sp)
    800050e8:	6942                	ld	s2,16(sp)
    800050ea:	6145                	addi	sp,sp,48
    800050ec:	8082                	ret
    return -1;
    800050ee:	557d                	li	a0,-1
    800050f0:	bfcd                	j	800050e2 <argfd+0x50>
    return -1;
    800050f2:	557d                	li	a0,-1
    800050f4:	b7fd                	j	800050e2 <argfd+0x50>
    800050f6:	557d                	li	a0,-1
    800050f8:	b7ed                	j	800050e2 <argfd+0x50>

00000000800050fa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050fa:	1101                	addi	sp,sp,-32
    800050fc:	ec06                	sd	ra,24(sp)
    800050fe:	e822                	sd	s0,16(sp)
    80005100:	e426                	sd	s1,8(sp)
    80005102:	1000                	addi	s0,sp,32
    80005104:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	964080e7          	jalr	-1692(ra) # 80001a6a <myproc>
    8000510e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005110:	0d850793          	addi	a5,a0,216
    80005114:	4501                	li	a0,0
    80005116:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005118:	6398                	ld	a4,0(a5)
    8000511a:	cb19                	beqz	a4,80005130 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000511c:	2505                	addiw	a0,a0,1
    8000511e:	07a1                	addi	a5,a5,8
    80005120:	fed51ce3          	bne	a0,a3,80005118 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005124:	557d                	li	a0,-1
}
    80005126:	60e2                	ld	ra,24(sp)
    80005128:	6442                	ld	s0,16(sp)
    8000512a:	64a2                	ld	s1,8(sp)
    8000512c:	6105                	addi	sp,sp,32
    8000512e:	8082                	ret
      p->ofile[fd] = f;
    80005130:	01a50793          	addi	a5,a0,26
    80005134:	078e                	slli	a5,a5,0x3
    80005136:	963e                	add	a2,a2,a5
    80005138:	e604                	sd	s1,8(a2)
      return fd;
    8000513a:	b7f5                	j	80005126 <fdalloc+0x2c>

000000008000513c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000513c:	715d                	addi	sp,sp,-80
    8000513e:	e486                	sd	ra,72(sp)
    80005140:	e0a2                	sd	s0,64(sp)
    80005142:	fc26                	sd	s1,56(sp)
    80005144:	f84a                	sd	s2,48(sp)
    80005146:	f44e                	sd	s3,40(sp)
    80005148:	f052                	sd	s4,32(sp)
    8000514a:	ec56                	sd	s5,24(sp)
    8000514c:	0880                	addi	s0,sp,80
    8000514e:	89ae                	mv	s3,a1
    80005150:	8ab2                	mv	s5,a2
    80005152:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005154:	fb040593          	addi	a1,s0,-80
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	d48080e7          	jalr	-696(ra) # 80003ea0 <nameiparent>
    80005160:	892a                	mv	s2,a0
    80005162:	12050f63          	beqz	a0,800052a0 <create+0x164>
    return 0;

  ilock(dp);
    80005166:	ffffe097          	auipc	ra,0xffffe
    8000516a:	592080e7          	jalr	1426(ra) # 800036f8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000516e:	4601                	li	a2,0
    80005170:	fb040593          	addi	a1,s0,-80
    80005174:	854a                	mv	a0,s2
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	a3a080e7          	jalr	-1478(ra) # 80003bb0 <dirlookup>
    8000517e:	84aa                	mv	s1,a0
    80005180:	c921                	beqz	a0,800051d0 <create+0x94>
    iunlockput(dp);
    80005182:	854a                	mv	a0,s2
    80005184:	ffffe097          	auipc	ra,0xffffe
    80005188:	7b2080e7          	jalr	1970(ra) # 80003936 <iunlockput>
    ilock(ip);
    8000518c:	8526                	mv	a0,s1
    8000518e:	ffffe097          	auipc	ra,0xffffe
    80005192:	56a080e7          	jalr	1386(ra) # 800036f8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005196:	2981                	sext.w	s3,s3
    80005198:	4789                	li	a5,2
    8000519a:	02f99463          	bne	s3,a5,800051c2 <create+0x86>
    8000519e:	04c4d783          	lhu	a5,76(s1)
    800051a2:	37f9                	addiw	a5,a5,-2
    800051a4:	17c2                	slli	a5,a5,0x30
    800051a6:	93c1                	srli	a5,a5,0x30
    800051a8:	4705                	li	a4,1
    800051aa:	00f76c63          	bltu	a4,a5,800051c2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800051ae:	8526                	mv	a0,s1
    800051b0:	60a6                	ld	ra,72(sp)
    800051b2:	6406                	ld	s0,64(sp)
    800051b4:	74e2                	ld	s1,56(sp)
    800051b6:	7942                	ld	s2,48(sp)
    800051b8:	79a2                	ld	s3,40(sp)
    800051ba:	7a02                	ld	s4,32(sp)
    800051bc:	6ae2                	ld	s5,24(sp)
    800051be:	6161                	addi	sp,sp,80
    800051c0:	8082                	ret
    iunlockput(ip);
    800051c2:	8526                	mv	a0,s1
    800051c4:	ffffe097          	auipc	ra,0xffffe
    800051c8:	772080e7          	jalr	1906(ra) # 80003936 <iunlockput>
    return 0;
    800051cc:	4481                	li	s1,0
    800051ce:	b7c5                	j	800051ae <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800051d0:	85ce                	mv	a1,s3
    800051d2:	00092503          	lw	a0,0(s2)
    800051d6:	ffffe097          	auipc	ra,0xffffe
    800051da:	38a080e7          	jalr	906(ra) # 80003560 <ialloc>
    800051de:	84aa                	mv	s1,a0
    800051e0:	c529                	beqz	a0,8000522a <create+0xee>
  ilock(ip);
    800051e2:	ffffe097          	auipc	ra,0xffffe
    800051e6:	516080e7          	jalr	1302(ra) # 800036f8 <ilock>
  ip->major = major;
    800051ea:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    800051ee:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800051f2:	4785                	li	a5,1
    800051f4:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    800051f8:	8526                	mv	a0,s1
    800051fa:	ffffe097          	auipc	ra,0xffffe
    800051fe:	434080e7          	jalr	1076(ra) # 8000362e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005202:	2981                	sext.w	s3,s3
    80005204:	4785                	li	a5,1
    80005206:	02f98a63          	beq	s3,a5,8000523a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000520a:	40d0                	lw	a2,4(s1)
    8000520c:	fb040593          	addi	a1,s0,-80
    80005210:	854a                	mv	a0,s2
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	bae080e7          	jalr	-1106(ra) # 80003dc0 <dirlink>
    8000521a:	06054b63          	bltz	a0,80005290 <create+0x154>
  iunlockput(dp);
    8000521e:	854a                	mv	a0,s2
    80005220:	ffffe097          	auipc	ra,0xffffe
    80005224:	716080e7          	jalr	1814(ra) # 80003936 <iunlockput>
  return ip;
    80005228:	b759                	j	800051ae <create+0x72>
    panic("create: ialloc");
    8000522a:	00004517          	auipc	a0,0x4
    8000522e:	84e50513          	addi	a0,a0,-1970 # 80008a78 <userret+0x9e8>
    80005232:	ffffb097          	auipc	ra,0xffffb
    80005236:	328080e7          	jalr	808(ra) # 8000055a <panic>
    dp->nlink++;  // for ".."
    8000523a:	05295783          	lhu	a5,82(s2)
    8000523e:	2785                	addiw	a5,a5,1
    80005240:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    80005244:	854a                	mv	a0,s2
    80005246:	ffffe097          	auipc	ra,0xffffe
    8000524a:	3e8080e7          	jalr	1000(ra) # 8000362e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000524e:	40d0                	lw	a2,4(s1)
    80005250:	00004597          	auipc	a1,0x4
    80005254:	83858593          	addi	a1,a1,-1992 # 80008a88 <userret+0x9f8>
    80005258:	8526                	mv	a0,s1
    8000525a:	fffff097          	auipc	ra,0xfffff
    8000525e:	b66080e7          	jalr	-1178(ra) # 80003dc0 <dirlink>
    80005262:	00054f63          	bltz	a0,80005280 <create+0x144>
    80005266:	00492603          	lw	a2,4(s2)
    8000526a:	00004597          	auipc	a1,0x4
    8000526e:	82658593          	addi	a1,a1,-2010 # 80008a90 <userret+0xa00>
    80005272:	8526                	mv	a0,s1
    80005274:	fffff097          	auipc	ra,0xfffff
    80005278:	b4c080e7          	jalr	-1204(ra) # 80003dc0 <dirlink>
    8000527c:	f80557e3          	bgez	a0,8000520a <create+0xce>
      panic("create dots");
    80005280:	00004517          	auipc	a0,0x4
    80005284:	81850513          	addi	a0,a0,-2024 # 80008a98 <userret+0xa08>
    80005288:	ffffb097          	auipc	ra,0xffffb
    8000528c:	2d2080e7          	jalr	722(ra) # 8000055a <panic>
    panic("create: dirlink");
    80005290:	00004517          	auipc	a0,0x4
    80005294:	81850513          	addi	a0,a0,-2024 # 80008aa8 <userret+0xa18>
    80005298:	ffffb097          	auipc	ra,0xffffb
    8000529c:	2c2080e7          	jalr	706(ra) # 8000055a <panic>
    return 0;
    800052a0:	84aa                	mv	s1,a0
    800052a2:	b731                	j	800051ae <create+0x72>

00000000800052a4 <sys_dup>:
{
    800052a4:	7179                	addi	sp,sp,-48
    800052a6:	f406                	sd	ra,40(sp)
    800052a8:	f022                	sd	s0,32(sp)
    800052aa:	ec26                	sd	s1,24(sp)
    800052ac:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052ae:	fd840613          	addi	a2,s0,-40
    800052b2:	4581                	li	a1,0
    800052b4:	4501                	li	a0,0
    800052b6:	00000097          	auipc	ra,0x0
    800052ba:	ddc080e7          	jalr	-548(ra) # 80005092 <argfd>
    return -1;
    800052be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052c0:	02054363          	bltz	a0,800052e6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800052c4:	fd843503          	ld	a0,-40(s0)
    800052c8:	00000097          	auipc	ra,0x0
    800052cc:	e32080e7          	jalr	-462(ra) # 800050fa <fdalloc>
    800052d0:	84aa                	mv	s1,a0
    return -1;
    800052d2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052d4:	00054963          	bltz	a0,800052e6 <sys_dup+0x42>
  filedup(f);
    800052d8:	fd843503          	ld	a0,-40(s0)
    800052dc:	fffff097          	auipc	ra,0xfffff
    800052e0:	348080e7          	jalr	840(ra) # 80004624 <filedup>
  return fd;
    800052e4:	87a6                	mv	a5,s1
}
    800052e6:	853e                	mv	a0,a5
    800052e8:	70a2                	ld	ra,40(sp)
    800052ea:	7402                	ld	s0,32(sp)
    800052ec:	64e2                	ld	s1,24(sp)
    800052ee:	6145                	addi	sp,sp,48
    800052f0:	8082                	ret

00000000800052f2 <sys_read>:
{
    800052f2:	7179                	addi	sp,sp,-48
    800052f4:	f406                	sd	ra,40(sp)
    800052f6:	f022                	sd	s0,32(sp)
    800052f8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052fa:	fe840613          	addi	a2,s0,-24
    800052fe:	4581                	li	a1,0
    80005300:	4501                	li	a0,0
    80005302:	00000097          	auipc	ra,0x0
    80005306:	d90080e7          	jalr	-624(ra) # 80005092 <argfd>
    return -1;
    8000530a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000530c:	04054163          	bltz	a0,8000534e <sys_read+0x5c>
    80005310:	fe440593          	addi	a1,s0,-28
    80005314:	4509                	li	a0,2
    80005316:	ffffe097          	auipc	ra,0xffffe
    8000531a:	86c080e7          	jalr	-1940(ra) # 80002b82 <argint>
    return -1;
    8000531e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005320:	02054763          	bltz	a0,8000534e <sys_read+0x5c>
    80005324:	fd840593          	addi	a1,s0,-40
    80005328:	4505                	li	a0,1
    8000532a:	ffffe097          	auipc	ra,0xffffe
    8000532e:	87a080e7          	jalr	-1926(ra) # 80002ba4 <argaddr>
    return -1;
    80005332:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005334:	00054d63          	bltz	a0,8000534e <sys_read+0x5c>
  return fileread(f, p, n);
    80005338:	fe442603          	lw	a2,-28(s0)
    8000533c:	fd843583          	ld	a1,-40(s0)
    80005340:	fe843503          	ld	a0,-24(s0)
    80005344:	fffff097          	auipc	ra,0xfffff
    80005348:	474080e7          	jalr	1140(ra) # 800047b8 <fileread>
    8000534c:	87aa                	mv	a5,a0
}
    8000534e:	853e                	mv	a0,a5
    80005350:	70a2                	ld	ra,40(sp)
    80005352:	7402                	ld	s0,32(sp)
    80005354:	6145                	addi	sp,sp,48
    80005356:	8082                	ret

0000000080005358 <sys_write>:
{
    80005358:	7179                	addi	sp,sp,-48
    8000535a:	f406                	sd	ra,40(sp)
    8000535c:	f022                	sd	s0,32(sp)
    8000535e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005360:	fe840613          	addi	a2,s0,-24
    80005364:	4581                	li	a1,0
    80005366:	4501                	li	a0,0
    80005368:	00000097          	auipc	ra,0x0
    8000536c:	d2a080e7          	jalr	-726(ra) # 80005092 <argfd>
    return -1;
    80005370:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005372:	04054163          	bltz	a0,800053b4 <sys_write+0x5c>
    80005376:	fe440593          	addi	a1,s0,-28
    8000537a:	4509                	li	a0,2
    8000537c:	ffffe097          	auipc	ra,0xffffe
    80005380:	806080e7          	jalr	-2042(ra) # 80002b82 <argint>
    return -1;
    80005384:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005386:	02054763          	bltz	a0,800053b4 <sys_write+0x5c>
    8000538a:	fd840593          	addi	a1,s0,-40
    8000538e:	4505                	li	a0,1
    80005390:	ffffe097          	auipc	ra,0xffffe
    80005394:	814080e7          	jalr	-2028(ra) # 80002ba4 <argaddr>
    return -1;
    80005398:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000539a:	00054d63          	bltz	a0,800053b4 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000539e:	fe442603          	lw	a2,-28(s0)
    800053a2:	fd843583          	ld	a1,-40(s0)
    800053a6:	fe843503          	ld	a0,-24(s0)
    800053aa:	fffff097          	auipc	ra,0xfffff
    800053ae:	4d4080e7          	jalr	1236(ra) # 8000487e <filewrite>
    800053b2:	87aa                	mv	a5,a0
}
    800053b4:	853e                	mv	a0,a5
    800053b6:	70a2                	ld	ra,40(sp)
    800053b8:	7402                	ld	s0,32(sp)
    800053ba:	6145                	addi	sp,sp,48
    800053bc:	8082                	ret

00000000800053be <sys_close>:
{
    800053be:	1101                	addi	sp,sp,-32
    800053c0:	ec06                	sd	ra,24(sp)
    800053c2:	e822                	sd	s0,16(sp)
    800053c4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053c6:	fe040613          	addi	a2,s0,-32
    800053ca:	fec40593          	addi	a1,s0,-20
    800053ce:	4501                	li	a0,0
    800053d0:	00000097          	auipc	ra,0x0
    800053d4:	cc2080e7          	jalr	-830(ra) # 80005092 <argfd>
    return -1;
    800053d8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053da:	02054463          	bltz	a0,80005402 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053de:	ffffc097          	auipc	ra,0xffffc
    800053e2:	68c080e7          	jalr	1676(ra) # 80001a6a <myproc>
    800053e6:	fec42783          	lw	a5,-20(s0)
    800053ea:	07e9                	addi	a5,a5,26
    800053ec:	078e                	slli	a5,a5,0x3
    800053ee:	97aa                	add	a5,a5,a0
    800053f0:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800053f4:	fe043503          	ld	a0,-32(s0)
    800053f8:	fffff097          	auipc	ra,0xfffff
    800053fc:	27e080e7          	jalr	638(ra) # 80004676 <fileclose>
  return 0;
    80005400:	4781                	li	a5,0
}
    80005402:	853e                	mv	a0,a5
    80005404:	60e2                	ld	ra,24(sp)
    80005406:	6442                	ld	s0,16(sp)
    80005408:	6105                	addi	sp,sp,32
    8000540a:	8082                	ret

000000008000540c <sys_fstat>:
{
    8000540c:	1101                	addi	sp,sp,-32
    8000540e:	ec06                	sd	ra,24(sp)
    80005410:	e822                	sd	s0,16(sp)
    80005412:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005414:	fe840613          	addi	a2,s0,-24
    80005418:	4581                	li	a1,0
    8000541a:	4501                	li	a0,0
    8000541c:	00000097          	auipc	ra,0x0
    80005420:	c76080e7          	jalr	-906(ra) # 80005092 <argfd>
    return -1;
    80005424:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005426:	02054563          	bltz	a0,80005450 <sys_fstat+0x44>
    8000542a:	fe040593          	addi	a1,s0,-32
    8000542e:	4505                	li	a0,1
    80005430:	ffffd097          	auipc	ra,0xffffd
    80005434:	774080e7          	jalr	1908(ra) # 80002ba4 <argaddr>
    return -1;
    80005438:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000543a:	00054b63          	bltz	a0,80005450 <sys_fstat+0x44>
  return filestat(f, st);
    8000543e:	fe043583          	ld	a1,-32(s0)
    80005442:	fe843503          	ld	a0,-24(s0)
    80005446:	fffff097          	auipc	ra,0xfffff
    8000544a:	300080e7          	jalr	768(ra) # 80004746 <filestat>
    8000544e:	87aa                	mv	a5,a0
}
    80005450:	853e                	mv	a0,a5
    80005452:	60e2                	ld	ra,24(sp)
    80005454:	6442                	ld	s0,16(sp)
    80005456:	6105                	addi	sp,sp,32
    80005458:	8082                	ret

000000008000545a <sys_link>:
{
    8000545a:	7169                	addi	sp,sp,-304
    8000545c:	f606                	sd	ra,296(sp)
    8000545e:	f222                	sd	s0,288(sp)
    80005460:	ee26                	sd	s1,280(sp)
    80005462:	ea4a                	sd	s2,272(sp)
    80005464:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005466:	08000613          	li	a2,128
    8000546a:	ed040593          	addi	a1,s0,-304
    8000546e:	4501                	li	a0,0
    80005470:	ffffd097          	auipc	ra,0xffffd
    80005474:	756080e7          	jalr	1878(ra) # 80002bc6 <argstr>
    return -1;
    80005478:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000547a:	12054363          	bltz	a0,800055a0 <sys_link+0x146>
    8000547e:	08000613          	li	a2,128
    80005482:	f5040593          	addi	a1,s0,-176
    80005486:	4505                	li	a0,1
    80005488:	ffffd097          	auipc	ra,0xffffd
    8000548c:	73e080e7          	jalr	1854(ra) # 80002bc6 <argstr>
    return -1;
    80005490:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005492:	10054763          	bltz	a0,800055a0 <sys_link+0x146>
  begin_op(ROOTDEV);
    80005496:	4501                	li	a0,0
    80005498:	fffff097          	auipc	ra,0xfffff
    8000549c:	c44080e7          	jalr	-956(ra) # 800040dc <begin_op>
  if((ip = namei(old)) == 0){
    800054a0:	ed040513          	addi	a0,s0,-304
    800054a4:	fffff097          	auipc	ra,0xfffff
    800054a8:	9de080e7          	jalr	-1570(ra) # 80003e82 <namei>
    800054ac:	84aa                	mv	s1,a0
    800054ae:	c559                	beqz	a0,8000553c <sys_link+0xe2>
  ilock(ip);
    800054b0:	ffffe097          	auipc	ra,0xffffe
    800054b4:	248080e7          	jalr	584(ra) # 800036f8 <ilock>
  if(ip->type == T_DIR){
    800054b8:	04c49703          	lh	a4,76(s1)
    800054bc:	4785                	li	a5,1
    800054be:	08f70663          	beq	a4,a5,8000554a <sys_link+0xf0>
  ip->nlink++;
    800054c2:	0524d783          	lhu	a5,82(s1)
    800054c6:	2785                	addiw	a5,a5,1
    800054c8:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    800054cc:	8526                	mv	a0,s1
    800054ce:	ffffe097          	auipc	ra,0xffffe
    800054d2:	160080e7          	jalr	352(ra) # 8000362e <iupdate>
  iunlock(ip);
    800054d6:	8526                	mv	a0,s1
    800054d8:	ffffe097          	auipc	ra,0xffffe
    800054dc:	2e2080e7          	jalr	738(ra) # 800037ba <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054e0:	fd040593          	addi	a1,s0,-48
    800054e4:	f5040513          	addi	a0,s0,-176
    800054e8:	fffff097          	auipc	ra,0xfffff
    800054ec:	9b8080e7          	jalr	-1608(ra) # 80003ea0 <nameiparent>
    800054f0:	892a                	mv	s2,a0
    800054f2:	cd2d                	beqz	a0,8000556c <sys_link+0x112>
  ilock(dp);
    800054f4:	ffffe097          	auipc	ra,0xffffe
    800054f8:	204080e7          	jalr	516(ra) # 800036f8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054fc:	00092703          	lw	a4,0(s2)
    80005500:	409c                	lw	a5,0(s1)
    80005502:	06f71063          	bne	a4,a5,80005562 <sys_link+0x108>
    80005506:	40d0                	lw	a2,4(s1)
    80005508:	fd040593          	addi	a1,s0,-48
    8000550c:	854a                	mv	a0,s2
    8000550e:	fffff097          	auipc	ra,0xfffff
    80005512:	8b2080e7          	jalr	-1870(ra) # 80003dc0 <dirlink>
    80005516:	04054663          	bltz	a0,80005562 <sys_link+0x108>
  iunlockput(dp);
    8000551a:	854a                	mv	a0,s2
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	41a080e7          	jalr	1050(ra) # 80003936 <iunlockput>
  iput(ip);
    80005524:	8526                	mv	a0,s1
    80005526:	ffffe097          	auipc	ra,0xffffe
    8000552a:	2e0080e7          	jalr	736(ra) # 80003806 <iput>
  end_op(ROOTDEV);
    8000552e:	4501                	li	a0,0
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	c56080e7          	jalr	-938(ra) # 80004186 <end_op>
  return 0;
    80005538:	4781                	li	a5,0
    8000553a:	a09d                	j	800055a0 <sys_link+0x146>
    end_op(ROOTDEV);
    8000553c:	4501                	li	a0,0
    8000553e:	fffff097          	auipc	ra,0xfffff
    80005542:	c48080e7          	jalr	-952(ra) # 80004186 <end_op>
    return -1;
    80005546:	57fd                	li	a5,-1
    80005548:	a8a1                	j	800055a0 <sys_link+0x146>
    iunlockput(ip);
    8000554a:	8526                	mv	a0,s1
    8000554c:	ffffe097          	auipc	ra,0xffffe
    80005550:	3ea080e7          	jalr	1002(ra) # 80003936 <iunlockput>
    end_op(ROOTDEV);
    80005554:	4501                	li	a0,0
    80005556:	fffff097          	auipc	ra,0xfffff
    8000555a:	c30080e7          	jalr	-976(ra) # 80004186 <end_op>
    return -1;
    8000555e:	57fd                	li	a5,-1
    80005560:	a081                	j	800055a0 <sys_link+0x146>
    iunlockput(dp);
    80005562:	854a                	mv	a0,s2
    80005564:	ffffe097          	auipc	ra,0xffffe
    80005568:	3d2080e7          	jalr	978(ra) # 80003936 <iunlockput>
  ilock(ip);
    8000556c:	8526                	mv	a0,s1
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	18a080e7          	jalr	394(ra) # 800036f8 <ilock>
  ip->nlink--;
    80005576:	0524d783          	lhu	a5,82(s1)
    8000557a:	37fd                	addiw	a5,a5,-1
    8000557c:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80005580:	8526                	mv	a0,s1
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	0ac080e7          	jalr	172(ra) # 8000362e <iupdate>
  iunlockput(ip);
    8000558a:	8526                	mv	a0,s1
    8000558c:	ffffe097          	auipc	ra,0xffffe
    80005590:	3aa080e7          	jalr	938(ra) # 80003936 <iunlockput>
  end_op(ROOTDEV);
    80005594:	4501                	li	a0,0
    80005596:	fffff097          	auipc	ra,0xfffff
    8000559a:	bf0080e7          	jalr	-1040(ra) # 80004186 <end_op>
  return -1;
    8000559e:	57fd                	li	a5,-1
}
    800055a0:	853e                	mv	a0,a5
    800055a2:	70b2                	ld	ra,296(sp)
    800055a4:	7412                	ld	s0,288(sp)
    800055a6:	64f2                	ld	s1,280(sp)
    800055a8:	6952                	ld	s2,272(sp)
    800055aa:	6155                	addi	sp,sp,304
    800055ac:	8082                	ret

00000000800055ae <sys_unlink>:
{
    800055ae:	7151                	addi	sp,sp,-240
    800055b0:	f586                	sd	ra,232(sp)
    800055b2:	f1a2                	sd	s0,224(sp)
    800055b4:	eda6                	sd	s1,216(sp)
    800055b6:	e9ca                	sd	s2,208(sp)
    800055b8:	e5ce                	sd	s3,200(sp)
    800055ba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055bc:	08000613          	li	a2,128
    800055c0:	f3040593          	addi	a1,s0,-208
    800055c4:	4501                	li	a0,0
    800055c6:	ffffd097          	auipc	ra,0xffffd
    800055ca:	600080e7          	jalr	1536(ra) # 80002bc6 <argstr>
    800055ce:	18054463          	bltz	a0,80005756 <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    800055d2:	4501                	li	a0,0
    800055d4:	fffff097          	auipc	ra,0xfffff
    800055d8:	b08080e7          	jalr	-1272(ra) # 800040dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055dc:	fb040593          	addi	a1,s0,-80
    800055e0:	f3040513          	addi	a0,s0,-208
    800055e4:	fffff097          	auipc	ra,0xfffff
    800055e8:	8bc080e7          	jalr	-1860(ra) # 80003ea0 <nameiparent>
    800055ec:	84aa                	mv	s1,a0
    800055ee:	cd61                	beqz	a0,800056c6 <sys_unlink+0x118>
  ilock(dp);
    800055f0:	ffffe097          	auipc	ra,0xffffe
    800055f4:	108080e7          	jalr	264(ra) # 800036f8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055f8:	00003597          	auipc	a1,0x3
    800055fc:	49058593          	addi	a1,a1,1168 # 80008a88 <userret+0x9f8>
    80005600:	fb040513          	addi	a0,s0,-80
    80005604:	ffffe097          	auipc	ra,0xffffe
    80005608:	592080e7          	jalr	1426(ra) # 80003b96 <namecmp>
    8000560c:	14050c63          	beqz	a0,80005764 <sys_unlink+0x1b6>
    80005610:	00003597          	auipc	a1,0x3
    80005614:	48058593          	addi	a1,a1,1152 # 80008a90 <userret+0xa00>
    80005618:	fb040513          	addi	a0,s0,-80
    8000561c:	ffffe097          	auipc	ra,0xffffe
    80005620:	57a080e7          	jalr	1402(ra) # 80003b96 <namecmp>
    80005624:	14050063          	beqz	a0,80005764 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005628:	f2c40613          	addi	a2,s0,-212
    8000562c:	fb040593          	addi	a1,s0,-80
    80005630:	8526                	mv	a0,s1
    80005632:	ffffe097          	auipc	ra,0xffffe
    80005636:	57e080e7          	jalr	1406(ra) # 80003bb0 <dirlookup>
    8000563a:	892a                	mv	s2,a0
    8000563c:	12050463          	beqz	a0,80005764 <sys_unlink+0x1b6>
  ilock(ip);
    80005640:	ffffe097          	auipc	ra,0xffffe
    80005644:	0b8080e7          	jalr	184(ra) # 800036f8 <ilock>
  if(ip->nlink < 1)
    80005648:	05291783          	lh	a5,82(s2)
    8000564c:	08f05463          	blez	a5,800056d4 <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005650:	04c91703          	lh	a4,76(s2)
    80005654:	4785                	li	a5,1
    80005656:	08f70763          	beq	a4,a5,800056e4 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    8000565a:	4641                	li	a2,16
    8000565c:	4581                	li	a1,0
    8000565e:	fc040513          	addi	a0,s0,-64
    80005662:	ffffb097          	auipc	ra,0xffffb
    80005666:	71c080e7          	jalr	1820(ra) # 80000d7e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000566a:	4741                	li	a4,16
    8000566c:	f2c42683          	lw	a3,-212(s0)
    80005670:	fc040613          	addi	a2,s0,-64
    80005674:	4581                	li	a1,0
    80005676:	8526                	mv	a0,s1
    80005678:	ffffe097          	auipc	ra,0xffffe
    8000567c:	404080e7          	jalr	1028(ra) # 80003a7c <writei>
    80005680:	47c1                	li	a5,16
    80005682:	0af51763          	bne	a0,a5,80005730 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005686:	04c91703          	lh	a4,76(s2)
    8000568a:	4785                	li	a5,1
    8000568c:	0af70a63          	beq	a4,a5,80005740 <sys_unlink+0x192>
  iunlockput(dp);
    80005690:	8526                	mv	a0,s1
    80005692:	ffffe097          	auipc	ra,0xffffe
    80005696:	2a4080e7          	jalr	676(ra) # 80003936 <iunlockput>
  ip->nlink--;
    8000569a:	05295783          	lhu	a5,82(s2)
    8000569e:	37fd                	addiw	a5,a5,-1
    800056a0:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    800056a4:	854a                	mv	a0,s2
    800056a6:	ffffe097          	auipc	ra,0xffffe
    800056aa:	f88080e7          	jalr	-120(ra) # 8000362e <iupdate>
  iunlockput(ip);
    800056ae:	854a                	mv	a0,s2
    800056b0:	ffffe097          	auipc	ra,0xffffe
    800056b4:	286080e7          	jalr	646(ra) # 80003936 <iunlockput>
  end_op(ROOTDEV);
    800056b8:	4501                	li	a0,0
    800056ba:	fffff097          	auipc	ra,0xfffff
    800056be:	acc080e7          	jalr	-1332(ra) # 80004186 <end_op>
  return 0;
    800056c2:	4501                	li	a0,0
    800056c4:	a85d                	j	8000577a <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    800056c6:	4501                	li	a0,0
    800056c8:	fffff097          	auipc	ra,0xfffff
    800056cc:	abe080e7          	jalr	-1346(ra) # 80004186 <end_op>
    return -1;
    800056d0:	557d                	li	a0,-1
    800056d2:	a065                	j	8000577a <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    800056d4:	00003517          	auipc	a0,0x3
    800056d8:	3e450513          	addi	a0,a0,996 # 80008ab8 <userret+0xa28>
    800056dc:	ffffb097          	auipc	ra,0xffffb
    800056e0:	e7e080e7          	jalr	-386(ra) # 8000055a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056e4:	05492703          	lw	a4,84(s2)
    800056e8:	02000793          	li	a5,32
    800056ec:	f6e7f7e3          	bgeu	a5,a4,8000565a <sys_unlink+0xac>
    800056f0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056f4:	4741                	li	a4,16
    800056f6:	86ce                	mv	a3,s3
    800056f8:	f1840613          	addi	a2,s0,-232
    800056fc:	4581                	li	a1,0
    800056fe:	854a                	mv	a0,s2
    80005700:	ffffe097          	auipc	ra,0xffffe
    80005704:	288080e7          	jalr	648(ra) # 80003988 <readi>
    80005708:	47c1                	li	a5,16
    8000570a:	00f51b63          	bne	a0,a5,80005720 <sys_unlink+0x172>
    if(de.inum != 0)
    8000570e:	f1845783          	lhu	a5,-232(s0)
    80005712:	e7a1                	bnez	a5,8000575a <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005714:	29c1                	addiw	s3,s3,16
    80005716:	05492783          	lw	a5,84(s2)
    8000571a:	fcf9ede3          	bltu	s3,a5,800056f4 <sys_unlink+0x146>
    8000571e:	bf35                	j	8000565a <sys_unlink+0xac>
      panic("isdirempty: readi");
    80005720:	00003517          	auipc	a0,0x3
    80005724:	3b050513          	addi	a0,a0,944 # 80008ad0 <userret+0xa40>
    80005728:	ffffb097          	auipc	ra,0xffffb
    8000572c:	e32080e7          	jalr	-462(ra) # 8000055a <panic>
    panic("unlink: writei");
    80005730:	00003517          	auipc	a0,0x3
    80005734:	3b850513          	addi	a0,a0,952 # 80008ae8 <userret+0xa58>
    80005738:	ffffb097          	auipc	ra,0xffffb
    8000573c:	e22080e7          	jalr	-478(ra) # 8000055a <panic>
    dp->nlink--;
    80005740:	0524d783          	lhu	a5,82(s1)
    80005744:	37fd                	addiw	a5,a5,-1
    80005746:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    8000574a:	8526                	mv	a0,s1
    8000574c:	ffffe097          	auipc	ra,0xffffe
    80005750:	ee2080e7          	jalr	-286(ra) # 8000362e <iupdate>
    80005754:	bf35                	j	80005690 <sys_unlink+0xe2>
    return -1;
    80005756:	557d                	li	a0,-1
    80005758:	a00d                	j	8000577a <sys_unlink+0x1cc>
    iunlockput(ip);
    8000575a:	854a                	mv	a0,s2
    8000575c:	ffffe097          	auipc	ra,0xffffe
    80005760:	1da080e7          	jalr	474(ra) # 80003936 <iunlockput>
  iunlockput(dp);
    80005764:	8526                	mv	a0,s1
    80005766:	ffffe097          	auipc	ra,0xffffe
    8000576a:	1d0080e7          	jalr	464(ra) # 80003936 <iunlockput>
  end_op(ROOTDEV);
    8000576e:	4501                	li	a0,0
    80005770:	fffff097          	auipc	ra,0xfffff
    80005774:	a16080e7          	jalr	-1514(ra) # 80004186 <end_op>
  return -1;
    80005778:	557d                	li	a0,-1
}
    8000577a:	70ae                	ld	ra,232(sp)
    8000577c:	740e                	ld	s0,224(sp)
    8000577e:	64ee                	ld	s1,216(sp)
    80005780:	694e                	ld	s2,208(sp)
    80005782:	69ae                	ld	s3,200(sp)
    80005784:	616d                	addi	sp,sp,240
    80005786:	8082                	ret

0000000080005788 <sys_open>:

uint64
sys_open(void)
{
    80005788:	7131                	addi	sp,sp,-192
    8000578a:	fd06                	sd	ra,184(sp)
    8000578c:	f922                	sd	s0,176(sp)
    8000578e:	f526                	sd	s1,168(sp)
    80005790:	f14a                	sd	s2,160(sp)
    80005792:	ed4e                	sd	s3,152(sp)
    80005794:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005796:	08000613          	li	a2,128
    8000579a:	f5040593          	addi	a1,s0,-176
    8000579e:	4501                	li	a0,0
    800057a0:	ffffd097          	auipc	ra,0xffffd
    800057a4:	426080e7          	jalr	1062(ra) # 80002bc6 <argstr>
    return -1;
    800057a8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800057aa:	0a054963          	bltz	a0,8000585c <sys_open+0xd4>
    800057ae:	f4c40593          	addi	a1,s0,-180
    800057b2:	4505                	li	a0,1
    800057b4:	ffffd097          	auipc	ra,0xffffd
    800057b8:	3ce080e7          	jalr	974(ra) # 80002b82 <argint>
    800057bc:	0a054063          	bltz	a0,8000585c <sys_open+0xd4>

  begin_op(ROOTDEV);
    800057c0:	4501                	li	a0,0
    800057c2:	fffff097          	auipc	ra,0xfffff
    800057c6:	91a080e7          	jalr	-1766(ra) # 800040dc <begin_op>

  if(omode & O_CREATE){
    800057ca:	f4c42783          	lw	a5,-180(s0)
    800057ce:	2007f793          	andi	a5,a5,512
    800057d2:	c3dd                	beqz	a5,80005878 <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    800057d4:	4681                	li	a3,0
    800057d6:	4601                	li	a2,0
    800057d8:	4589                	li	a1,2
    800057da:	f5040513          	addi	a0,s0,-176
    800057de:	00000097          	auipc	ra,0x0
    800057e2:	95e080e7          	jalr	-1698(ra) # 8000513c <create>
    800057e6:	892a                	mv	s2,a0
    if(ip == 0){
    800057e8:	c151                	beqz	a0,8000586c <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057ea:	04c91703          	lh	a4,76(s2)
    800057ee:	478d                	li	a5,3
    800057f0:	00f71763          	bne	a4,a5,800057fe <sys_open+0x76>
    800057f4:	04e95703          	lhu	a4,78(s2)
    800057f8:	47a5                	li	a5,9
    800057fa:	0ce7e663          	bltu	a5,a4,800058c6 <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057fe:	fffff097          	auipc	ra,0xfffff
    80005802:	dbc080e7          	jalr	-580(ra) # 800045ba <filealloc>
    80005806:	89aa                	mv	s3,a0
    80005808:	c97d                	beqz	a0,800058fe <sys_open+0x176>
    8000580a:	00000097          	auipc	ra,0x0
    8000580e:	8f0080e7          	jalr	-1808(ra) # 800050fa <fdalloc>
    80005812:	84aa                	mv	s1,a0
    80005814:	0e054063          	bltz	a0,800058f4 <sys_open+0x16c>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005818:	04c91703          	lh	a4,76(s2)
    8000581c:	478d                	li	a5,3
    8000581e:	0cf70063          	beq	a4,a5,800058de <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
    f->minor = ip->minor;
  } else {
    f->type = FD_INODE;
    80005822:	4789                	li	a5,2
    80005824:	00f9a023          	sw	a5,0(s3)
  }
  f->ip = ip;
    80005828:	0129bc23          	sd	s2,24(s3)
  f->off = 0;
    8000582c:	0209a023          	sw	zero,32(s3)
  f->readable = !(omode & O_WRONLY);
    80005830:	f4c42783          	lw	a5,-180(s0)
    80005834:	0017c713          	xori	a4,a5,1
    80005838:	8b05                	andi	a4,a4,1
    8000583a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000583e:	8b8d                	andi	a5,a5,3
    80005840:	00f037b3          	snez	a5,a5
    80005844:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    80005848:	854a                	mv	a0,s2
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	f70080e7          	jalr	-144(ra) # 800037ba <iunlock>
  end_op(ROOTDEV);
    80005852:	4501                	li	a0,0
    80005854:	fffff097          	auipc	ra,0xfffff
    80005858:	932080e7          	jalr	-1742(ra) # 80004186 <end_op>

  return fd;
}
    8000585c:	8526                	mv	a0,s1
    8000585e:	70ea                	ld	ra,184(sp)
    80005860:	744a                	ld	s0,176(sp)
    80005862:	74aa                	ld	s1,168(sp)
    80005864:	790a                	ld	s2,160(sp)
    80005866:	69ea                	ld	s3,152(sp)
    80005868:	6129                	addi	sp,sp,192
    8000586a:	8082                	ret
      end_op(ROOTDEV);
    8000586c:	4501                	li	a0,0
    8000586e:	fffff097          	auipc	ra,0xfffff
    80005872:	918080e7          	jalr	-1768(ra) # 80004186 <end_op>
      return -1;
    80005876:	b7dd                	j	8000585c <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    80005878:	f5040513          	addi	a0,s0,-176
    8000587c:	ffffe097          	auipc	ra,0xffffe
    80005880:	606080e7          	jalr	1542(ra) # 80003e82 <namei>
    80005884:	892a                	mv	s2,a0
    80005886:	c90d                	beqz	a0,800058b8 <sys_open+0x130>
    ilock(ip);
    80005888:	ffffe097          	auipc	ra,0xffffe
    8000588c:	e70080e7          	jalr	-400(ra) # 800036f8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005890:	04c91703          	lh	a4,76(s2)
    80005894:	4785                	li	a5,1
    80005896:	f4f71ae3          	bne	a4,a5,800057ea <sys_open+0x62>
    8000589a:	f4c42783          	lw	a5,-180(s0)
    8000589e:	d3a5                	beqz	a5,800057fe <sys_open+0x76>
      iunlockput(ip);
    800058a0:	854a                	mv	a0,s2
    800058a2:	ffffe097          	auipc	ra,0xffffe
    800058a6:	094080e7          	jalr	148(ra) # 80003936 <iunlockput>
      end_op(ROOTDEV);
    800058aa:	4501                	li	a0,0
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	8da080e7          	jalr	-1830(ra) # 80004186 <end_op>
      return -1;
    800058b4:	54fd                	li	s1,-1
    800058b6:	b75d                	j	8000585c <sys_open+0xd4>
      end_op(ROOTDEV);
    800058b8:	4501                	li	a0,0
    800058ba:	fffff097          	auipc	ra,0xfffff
    800058be:	8cc080e7          	jalr	-1844(ra) # 80004186 <end_op>
      return -1;
    800058c2:	54fd                	li	s1,-1
    800058c4:	bf61                	j	8000585c <sys_open+0xd4>
    iunlockput(ip);
    800058c6:	854a                	mv	a0,s2
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	06e080e7          	jalr	110(ra) # 80003936 <iunlockput>
    end_op(ROOTDEV);
    800058d0:	4501                	li	a0,0
    800058d2:	fffff097          	auipc	ra,0xfffff
    800058d6:	8b4080e7          	jalr	-1868(ra) # 80004186 <end_op>
    return -1;
    800058da:	54fd                	li	s1,-1
    800058dc:	b741                	j	8000585c <sys_open+0xd4>
    f->type = FD_DEVICE;
    800058de:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800058e2:	04e91783          	lh	a5,78(s2)
    800058e6:	02f99223          	sh	a5,36(s3)
    f->minor = ip->minor;
    800058ea:	05091783          	lh	a5,80(s2)
    800058ee:	02f99323          	sh	a5,38(s3)
    800058f2:	bf1d                	j	80005828 <sys_open+0xa0>
      fileclose(f);
    800058f4:	854e                	mv	a0,s3
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	d80080e7          	jalr	-640(ra) # 80004676 <fileclose>
    iunlockput(ip);
    800058fe:	854a                	mv	a0,s2
    80005900:	ffffe097          	auipc	ra,0xffffe
    80005904:	036080e7          	jalr	54(ra) # 80003936 <iunlockput>
    end_op(ROOTDEV);
    80005908:	4501                	li	a0,0
    8000590a:	fffff097          	auipc	ra,0xfffff
    8000590e:	87c080e7          	jalr	-1924(ra) # 80004186 <end_op>
    return -1;
    80005912:	54fd                	li	s1,-1
    80005914:	b7a1                	j	8000585c <sys_open+0xd4>

0000000080005916 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005916:	7175                	addi	sp,sp,-144
    80005918:	e506                	sd	ra,136(sp)
    8000591a:	e122                	sd	s0,128(sp)
    8000591c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    8000591e:	4501                	li	a0,0
    80005920:	ffffe097          	auipc	ra,0xffffe
    80005924:	7bc080e7          	jalr	1980(ra) # 800040dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005928:	08000613          	li	a2,128
    8000592c:	f7040593          	addi	a1,s0,-144
    80005930:	4501                	li	a0,0
    80005932:	ffffd097          	auipc	ra,0xffffd
    80005936:	294080e7          	jalr	660(ra) # 80002bc6 <argstr>
    8000593a:	02054a63          	bltz	a0,8000596e <sys_mkdir+0x58>
    8000593e:	4681                	li	a3,0
    80005940:	4601                	li	a2,0
    80005942:	4585                	li	a1,1
    80005944:	f7040513          	addi	a0,s0,-144
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	7f4080e7          	jalr	2036(ra) # 8000513c <create>
    80005950:	cd19                	beqz	a0,8000596e <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005952:	ffffe097          	auipc	ra,0xffffe
    80005956:	fe4080e7          	jalr	-28(ra) # 80003936 <iunlockput>
  end_op(ROOTDEV);
    8000595a:	4501                	li	a0,0
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	82a080e7          	jalr	-2006(ra) # 80004186 <end_op>
  return 0;
    80005964:	4501                	li	a0,0
}
    80005966:	60aa                	ld	ra,136(sp)
    80005968:	640a                	ld	s0,128(sp)
    8000596a:	6149                	addi	sp,sp,144
    8000596c:	8082                	ret
    end_op(ROOTDEV);
    8000596e:	4501                	li	a0,0
    80005970:	fffff097          	auipc	ra,0xfffff
    80005974:	816080e7          	jalr	-2026(ra) # 80004186 <end_op>
    return -1;
    80005978:	557d                	li	a0,-1
    8000597a:	b7f5                	j	80005966 <sys_mkdir+0x50>

000000008000597c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000597c:	7135                	addi	sp,sp,-160
    8000597e:	ed06                	sd	ra,152(sp)
    80005980:	e922                	sd	s0,144(sp)
    80005982:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    80005984:	4501                	li	a0,0
    80005986:	ffffe097          	auipc	ra,0xffffe
    8000598a:	756080e7          	jalr	1878(ra) # 800040dc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000598e:	08000613          	li	a2,128
    80005992:	f7040593          	addi	a1,s0,-144
    80005996:	4501                	li	a0,0
    80005998:	ffffd097          	auipc	ra,0xffffd
    8000599c:	22e080e7          	jalr	558(ra) # 80002bc6 <argstr>
    800059a0:	04054b63          	bltz	a0,800059f6 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    800059a4:	f6c40593          	addi	a1,s0,-148
    800059a8:	4505                	li	a0,1
    800059aa:	ffffd097          	auipc	ra,0xffffd
    800059ae:	1d8080e7          	jalr	472(ra) # 80002b82 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059b2:	04054263          	bltz	a0,800059f6 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    800059b6:	f6840593          	addi	a1,s0,-152
    800059ba:	4509                	li	a0,2
    800059bc:	ffffd097          	auipc	ra,0xffffd
    800059c0:	1c6080e7          	jalr	454(ra) # 80002b82 <argint>
     argint(1, &major) < 0 ||
    800059c4:	02054963          	bltz	a0,800059f6 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059c8:	f6841683          	lh	a3,-152(s0)
    800059cc:	f6c41603          	lh	a2,-148(s0)
    800059d0:	458d                	li	a1,3
    800059d2:	f7040513          	addi	a0,s0,-144
    800059d6:	fffff097          	auipc	ra,0xfffff
    800059da:	766080e7          	jalr	1894(ra) # 8000513c <create>
     argint(2, &minor) < 0 ||
    800059de:	cd01                	beqz	a0,800059f6 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    800059e0:	ffffe097          	auipc	ra,0xffffe
    800059e4:	f56080e7          	jalr	-170(ra) # 80003936 <iunlockput>
  end_op(ROOTDEV);
    800059e8:	4501                	li	a0,0
    800059ea:	ffffe097          	auipc	ra,0xffffe
    800059ee:	79c080e7          	jalr	1948(ra) # 80004186 <end_op>
  return 0;
    800059f2:	4501                	li	a0,0
    800059f4:	a039                	j	80005a02 <sys_mknod+0x86>
    end_op(ROOTDEV);
    800059f6:	4501                	li	a0,0
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	78e080e7          	jalr	1934(ra) # 80004186 <end_op>
    return -1;
    80005a00:	557d                	li	a0,-1
}
    80005a02:	60ea                	ld	ra,152(sp)
    80005a04:	644a                	ld	s0,144(sp)
    80005a06:	610d                	addi	sp,sp,160
    80005a08:	8082                	ret

0000000080005a0a <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a0a:	7135                	addi	sp,sp,-160
    80005a0c:	ed06                	sd	ra,152(sp)
    80005a0e:	e922                	sd	s0,144(sp)
    80005a10:	e526                	sd	s1,136(sp)
    80005a12:	e14a                	sd	s2,128(sp)
    80005a14:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	054080e7          	jalr	84(ra) # 80001a6a <myproc>
    80005a1e:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    80005a20:	4501                	li	a0,0
    80005a22:	ffffe097          	auipc	ra,0xffffe
    80005a26:	6ba080e7          	jalr	1722(ra) # 800040dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a2a:	08000613          	li	a2,128
    80005a2e:	f6040593          	addi	a1,s0,-160
    80005a32:	4501                	li	a0,0
    80005a34:	ffffd097          	auipc	ra,0xffffd
    80005a38:	192080e7          	jalr	402(ra) # 80002bc6 <argstr>
    80005a3c:	04054c63          	bltz	a0,80005a94 <sys_chdir+0x8a>
    80005a40:	f6040513          	addi	a0,s0,-160
    80005a44:	ffffe097          	auipc	ra,0xffffe
    80005a48:	43e080e7          	jalr	1086(ra) # 80003e82 <namei>
    80005a4c:	84aa                	mv	s1,a0
    80005a4e:	c139                	beqz	a0,80005a94 <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	ca8080e7          	jalr	-856(ra) # 800036f8 <ilock>
  if(ip->type != T_DIR){
    80005a58:	04c49703          	lh	a4,76(s1)
    80005a5c:	4785                	li	a5,1
    80005a5e:	04f71263          	bne	a4,a5,80005aa2 <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	d56080e7          	jalr	-682(ra) # 800037ba <iunlock>
  iput(p->cwd);
    80005a6c:	15893503          	ld	a0,344(s2)
    80005a70:	ffffe097          	auipc	ra,0xffffe
    80005a74:	d96080e7          	jalr	-618(ra) # 80003806 <iput>
  end_op(ROOTDEV);
    80005a78:	4501                	li	a0,0
    80005a7a:	ffffe097          	auipc	ra,0xffffe
    80005a7e:	70c080e7          	jalr	1804(ra) # 80004186 <end_op>
  p->cwd = ip;
    80005a82:	14993c23          	sd	s1,344(s2)
  return 0;
    80005a86:	4501                	li	a0,0
}
    80005a88:	60ea                	ld	ra,152(sp)
    80005a8a:	644a                	ld	s0,144(sp)
    80005a8c:	64aa                	ld	s1,136(sp)
    80005a8e:	690a                	ld	s2,128(sp)
    80005a90:	610d                	addi	sp,sp,160
    80005a92:	8082                	ret
    end_op(ROOTDEV);
    80005a94:	4501                	li	a0,0
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	6f0080e7          	jalr	1776(ra) # 80004186 <end_op>
    return -1;
    80005a9e:	557d                	li	a0,-1
    80005aa0:	b7e5                	j	80005a88 <sys_chdir+0x7e>
    iunlockput(ip);
    80005aa2:	8526                	mv	a0,s1
    80005aa4:	ffffe097          	auipc	ra,0xffffe
    80005aa8:	e92080e7          	jalr	-366(ra) # 80003936 <iunlockput>
    end_op(ROOTDEV);
    80005aac:	4501                	li	a0,0
    80005aae:	ffffe097          	auipc	ra,0xffffe
    80005ab2:	6d8080e7          	jalr	1752(ra) # 80004186 <end_op>
    return -1;
    80005ab6:	557d                	li	a0,-1
    80005ab8:	bfc1                	j	80005a88 <sys_chdir+0x7e>

0000000080005aba <sys_exec>:

uint64
sys_exec(void)
{
    80005aba:	7145                	addi	sp,sp,-464
    80005abc:	e786                	sd	ra,456(sp)
    80005abe:	e3a2                	sd	s0,448(sp)
    80005ac0:	ff26                	sd	s1,440(sp)
    80005ac2:	fb4a                	sd	s2,432(sp)
    80005ac4:	f74e                	sd	s3,424(sp)
    80005ac6:	f352                	sd	s4,416(sp)
    80005ac8:	ef56                	sd	s5,408(sp)
    80005aca:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005acc:	08000613          	li	a2,128
    80005ad0:	f4040593          	addi	a1,s0,-192
    80005ad4:	4501                	li	a0,0
    80005ad6:	ffffd097          	auipc	ra,0xffffd
    80005ada:	0f0080e7          	jalr	240(ra) # 80002bc6 <argstr>
    80005ade:	0e054663          	bltz	a0,80005bca <sys_exec+0x110>
    80005ae2:	e3840593          	addi	a1,s0,-456
    80005ae6:	4505                	li	a0,1
    80005ae8:	ffffd097          	auipc	ra,0xffffd
    80005aec:	0bc080e7          	jalr	188(ra) # 80002ba4 <argaddr>
    80005af0:	0e054763          	bltz	a0,80005bde <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005af4:	10000613          	li	a2,256
    80005af8:	4581                	li	a1,0
    80005afa:	e4040513          	addi	a0,s0,-448
    80005afe:	ffffb097          	auipc	ra,0xffffb
    80005b02:	280080e7          	jalr	640(ra) # 80000d7e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b06:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005b0a:	89ca                	mv	s3,s2
    80005b0c:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005b0e:	02000a13          	li	s4,32
    80005b12:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b16:	00349513          	slli	a0,s1,0x3
    80005b1a:	e3040593          	addi	a1,s0,-464
    80005b1e:	e3843783          	ld	a5,-456(s0)
    80005b22:	953e                	add	a0,a0,a5
    80005b24:	ffffd097          	auipc	ra,0xffffd
    80005b28:	fc4080e7          	jalr	-60(ra) # 80002ae8 <fetchaddr>
    80005b2c:	02054a63          	bltz	a0,80005b60 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005b30:	e3043783          	ld	a5,-464(s0)
    80005b34:	c7a1                	beqz	a5,80005b7c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b36:	ffffb097          	auipc	ra,0xffffb
    80005b3a:	e46080e7          	jalr	-442(ra) # 8000097c <kalloc>
    80005b3e:	85aa                	mv	a1,a0
    80005b40:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b44:	c92d                	beqz	a0,80005bb6 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005b46:	6605                	lui	a2,0x1
    80005b48:	e3043503          	ld	a0,-464(s0)
    80005b4c:	ffffd097          	auipc	ra,0xffffd
    80005b50:	fee080e7          	jalr	-18(ra) # 80002b3a <fetchstr>
    80005b54:	00054663          	bltz	a0,80005b60 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005b58:	0485                	addi	s1,s1,1
    80005b5a:	09a1                	addi	s3,s3,8
    80005b5c:	fb449be3          	bne	s1,s4,80005b12 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b60:	10090493          	addi	s1,s2,256
    80005b64:	00093503          	ld	a0,0(s2)
    80005b68:	cd39                	beqz	a0,80005bc6 <sys_exec+0x10c>
    kfree(argv[i]);
    80005b6a:	ffffb097          	auipc	ra,0xffffb
    80005b6e:	d16080e7          	jalr	-746(ra) # 80000880 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b72:	0921                	addi	s2,s2,8
    80005b74:	fe9918e3          	bne	s2,s1,80005b64 <sys_exec+0xaa>
  return -1;
    80005b78:	557d                	li	a0,-1
    80005b7a:	a889                	j	80005bcc <sys_exec+0x112>
      argv[i] = 0;
    80005b7c:	0a8e                	slli	s5,s5,0x3
    80005b7e:	fc040793          	addi	a5,s0,-64
    80005b82:	9abe                	add	s5,s5,a5
    80005b84:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd6e24>
  int ret = exec(path, argv);
    80005b88:	e4040593          	addi	a1,s0,-448
    80005b8c:	f4040513          	addi	a0,s0,-192
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	198080e7          	jalr	408(ra) # 80004d28 <exec>
    80005b98:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b9a:	10090993          	addi	s3,s2,256
    80005b9e:	00093503          	ld	a0,0(s2)
    80005ba2:	c901                	beqz	a0,80005bb2 <sys_exec+0xf8>
    kfree(argv[i]);
    80005ba4:	ffffb097          	auipc	ra,0xffffb
    80005ba8:	cdc080e7          	jalr	-804(ra) # 80000880 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bac:	0921                	addi	s2,s2,8
    80005bae:	ff3918e3          	bne	s2,s3,80005b9e <sys_exec+0xe4>
  return ret;
    80005bb2:	8526                	mv	a0,s1
    80005bb4:	a821                	j	80005bcc <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005bb6:	00003517          	auipc	a0,0x3
    80005bba:	f4250513          	addi	a0,a0,-190 # 80008af8 <userret+0xa68>
    80005bbe:	ffffb097          	auipc	ra,0xffffb
    80005bc2:	99c080e7          	jalr	-1636(ra) # 8000055a <panic>
  return -1;
    80005bc6:	557d                	li	a0,-1
    80005bc8:	a011                	j	80005bcc <sys_exec+0x112>
    return -1;
    80005bca:	557d                	li	a0,-1
}
    80005bcc:	60be                	ld	ra,456(sp)
    80005bce:	641e                	ld	s0,448(sp)
    80005bd0:	74fa                	ld	s1,440(sp)
    80005bd2:	795a                	ld	s2,432(sp)
    80005bd4:	79ba                	ld	s3,424(sp)
    80005bd6:	7a1a                	ld	s4,416(sp)
    80005bd8:	6afa                	ld	s5,408(sp)
    80005bda:	6179                	addi	sp,sp,464
    80005bdc:	8082                	ret
    return -1;
    80005bde:	557d                	li	a0,-1
    80005be0:	b7f5                	j	80005bcc <sys_exec+0x112>

0000000080005be2 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005be2:	7139                	addi	sp,sp,-64
    80005be4:	fc06                	sd	ra,56(sp)
    80005be6:	f822                	sd	s0,48(sp)
    80005be8:	f426                	sd	s1,40(sp)
    80005bea:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	e7e080e7          	jalr	-386(ra) # 80001a6a <myproc>
    80005bf4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005bf6:	fd840593          	addi	a1,s0,-40
    80005bfa:	4501                	li	a0,0
    80005bfc:	ffffd097          	auipc	ra,0xffffd
    80005c00:	fa8080e7          	jalr	-88(ra) # 80002ba4 <argaddr>
    return -1;
    80005c04:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005c06:	0e054063          	bltz	a0,80005ce6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005c0a:	fc840593          	addi	a1,s0,-56
    80005c0e:	fd040513          	addi	a0,s0,-48
    80005c12:	fffff097          	auipc	ra,0xfffff
    80005c16:	dc8080e7          	jalr	-568(ra) # 800049da <pipealloc>
    return -1;
    80005c1a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c1c:	0c054563          	bltz	a0,80005ce6 <sys_pipe+0x104>
  fd0 = -1;
    80005c20:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c24:	fd043503          	ld	a0,-48(s0)
    80005c28:	fffff097          	auipc	ra,0xfffff
    80005c2c:	4d2080e7          	jalr	1234(ra) # 800050fa <fdalloc>
    80005c30:	fca42223          	sw	a0,-60(s0)
    80005c34:	08054c63          	bltz	a0,80005ccc <sys_pipe+0xea>
    80005c38:	fc843503          	ld	a0,-56(s0)
    80005c3c:	fffff097          	auipc	ra,0xfffff
    80005c40:	4be080e7          	jalr	1214(ra) # 800050fa <fdalloc>
    80005c44:	fca42023          	sw	a0,-64(s0)
    80005c48:	06054863          	bltz	a0,80005cb8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c4c:	4691                	li	a3,4
    80005c4e:	fc440613          	addi	a2,s0,-60
    80005c52:	fd843583          	ld	a1,-40(s0)
    80005c56:	6ca8                	ld	a0,88(s1)
    80005c58:	ffffc097          	auipc	ra,0xffffc
    80005c5c:	b06080e7          	jalr	-1274(ra) # 8000175e <copyout>
    80005c60:	02054063          	bltz	a0,80005c80 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c64:	4691                	li	a3,4
    80005c66:	fc040613          	addi	a2,s0,-64
    80005c6a:	fd843583          	ld	a1,-40(s0)
    80005c6e:	0591                	addi	a1,a1,4
    80005c70:	6ca8                	ld	a0,88(s1)
    80005c72:	ffffc097          	auipc	ra,0xffffc
    80005c76:	aec080e7          	jalr	-1300(ra) # 8000175e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c7a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c7c:	06055563          	bgez	a0,80005ce6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005c80:	fc442783          	lw	a5,-60(s0)
    80005c84:	07e9                	addi	a5,a5,26
    80005c86:	078e                	slli	a5,a5,0x3
    80005c88:	97a6                	add	a5,a5,s1
    80005c8a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005c8e:	fc042503          	lw	a0,-64(s0)
    80005c92:	0569                	addi	a0,a0,26
    80005c94:	050e                	slli	a0,a0,0x3
    80005c96:	9526                	add	a0,a0,s1
    80005c98:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005c9c:	fd043503          	ld	a0,-48(s0)
    80005ca0:	fffff097          	auipc	ra,0xfffff
    80005ca4:	9d6080e7          	jalr	-1578(ra) # 80004676 <fileclose>
    fileclose(wf);
    80005ca8:	fc843503          	ld	a0,-56(s0)
    80005cac:	fffff097          	auipc	ra,0xfffff
    80005cb0:	9ca080e7          	jalr	-1590(ra) # 80004676 <fileclose>
    return -1;
    80005cb4:	57fd                	li	a5,-1
    80005cb6:	a805                	j	80005ce6 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005cb8:	fc442783          	lw	a5,-60(s0)
    80005cbc:	0007c863          	bltz	a5,80005ccc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005cc0:	01a78513          	addi	a0,a5,26
    80005cc4:	050e                	slli	a0,a0,0x3
    80005cc6:	9526                	add	a0,a0,s1
    80005cc8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005ccc:	fd043503          	ld	a0,-48(s0)
    80005cd0:	fffff097          	auipc	ra,0xfffff
    80005cd4:	9a6080e7          	jalr	-1626(ra) # 80004676 <fileclose>
    fileclose(wf);
    80005cd8:	fc843503          	ld	a0,-56(s0)
    80005cdc:	fffff097          	auipc	ra,0xfffff
    80005ce0:	99a080e7          	jalr	-1638(ra) # 80004676 <fileclose>
    return -1;
    80005ce4:	57fd                	li	a5,-1
}
    80005ce6:	853e                	mv	a0,a5
    80005ce8:	70e2                	ld	ra,56(sp)
    80005cea:	7442                	ld	s0,48(sp)
    80005cec:	74a2                	ld	s1,40(sp)
    80005cee:	6121                	addi	sp,sp,64
    80005cf0:	8082                	ret
	...

0000000080005d00 <kernelvec>:
    80005d00:	7111                	addi	sp,sp,-256
    80005d02:	e006                	sd	ra,0(sp)
    80005d04:	e40a                	sd	sp,8(sp)
    80005d06:	e80e                	sd	gp,16(sp)
    80005d08:	ec12                	sd	tp,24(sp)
    80005d0a:	f016                	sd	t0,32(sp)
    80005d0c:	f41a                	sd	t1,40(sp)
    80005d0e:	f81e                	sd	t2,48(sp)
    80005d10:	fc22                	sd	s0,56(sp)
    80005d12:	e0a6                	sd	s1,64(sp)
    80005d14:	e4aa                	sd	a0,72(sp)
    80005d16:	e8ae                	sd	a1,80(sp)
    80005d18:	ecb2                	sd	a2,88(sp)
    80005d1a:	f0b6                	sd	a3,96(sp)
    80005d1c:	f4ba                	sd	a4,104(sp)
    80005d1e:	f8be                	sd	a5,112(sp)
    80005d20:	fcc2                	sd	a6,120(sp)
    80005d22:	e146                	sd	a7,128(sp)
    80005d24:	e54a                	sd	s2,136(sp)
    80005d26:	e94e                	sd	s3,144(sp)
    80005d28:	ed52                	sd	s4,152(sp)
    80005d2a:	f156                	sd	s5,160(sp)
    80005d2c:	f55a                	sd	s6,168(sp)
    80005d2e:	f95e                	sd	s7,176(sp)
    80005d30:	fd62                	sd	s8,184(sp)
    80005d32:	e1e6                	sd	s9,192(sp)
    80005d34:	e5ea                	sd	s10,200(sp)
    80005d36:	e9ee                	sd	s11,208(sp)
    80005d38:	edf2                	sd	t3,216(sp)
    80005d3a:	f1f6                	sd	t4,224(sp)
    80005d3c:	f5fa                	sd	t5,232(sp)
    80005d3e:	f9fe                	sd	t6,240(sp)
    80005d40:	c69fc0ef          	jal	ra,800029a8 <kerneltrap>
    80005d44:	6082                	ld	ra,0(sp)
    80005d46:	6122                	ld	sp,8(sp)
    80005d48:	61c2                	ld	gp,16(sp)
    80005d4a:	7282                	ld	t0,32(sp)
    80005d4c:	7322                	ld	t1,40(sp)
    80005d4e:	73c2                	ld	t2,48(sp)
    80005d50:	7462                	ld	s0,56(sp)
    80005d52:	6486                	ld	s1,64(sp)
    80005d54:	6526                	ld	a0,72(sp)
    80005d56:	65c6                	ld	a1,80(sp)
    80005d58:	6666                	ld	a2,88(sp)
    80005d5a:	7686                	ld	a3,96(sp)
    80005d5c:	7726                	ld	a4,104(sp)
    80005d5e:	77c6                	ld	a5,112(sp)
    80005d60:	7866                	ld	a6,120(sp)
    80005d62:	688a                	ld	a7,128(sp)
    80005d64:	692a                	ld	s2,136(sp)
    80005d66:	69ca                	ld	s3,144(sp)
    80005d68:	6a6a                	ld	s4,152(sp)
    80005d6a:	7a8a                	ld	s5,160(sp)
    80005d6c:	7b2a                	ld	s6,168(sp)
    80005d6e:	7bca                	ld	s7,176(sp)
    80005d70:	7c6a                	ld	s8,184(sp)
    80005d72:	6c8e                	ld	s9,192(sp)
    80005d74:	6d2e                	ld	s10,200(sp)
    80005d76:	6dce                	ld	s11,208(sp)
    80005d78:	6e6e                	ld	t3,216(sp)
    80005d7a:	7e8e                	ld	t4,224(sp)
    80005d7c:	7f2e                	ld	t5,232(sp)
    80005d7e:	7fce                	ld	t6,240(sp)
    80005d80:	6111                	addi	sp,sp,256
    80005d82:	10200073          	sret
    80005d86:	00000013          	nop
    80005d8a:	00000013          	nop
    80005d8e:	0001                	nop

0000000080005d90 <timervec>:
    80005d90:	34051573          	csrrw	a0,mscratch,a0
    80005d94:	e10c                	sd	a1,0(a0)
    80005d96:	e510                	sd	a2,8(a0)
    80005d98:	e914                	sd	a3,16(a0)
    80005d9a:	710c                	ld	a1,32(a0)
    80005d9c:	7510                	ld	a2,40(a0)
    80005d9e:	6194                	ld	a3,0(a1)
    80005da0:	96b2                	add	a3,a3,a2
    80005da2:	e194                	sd	a3,0(a1)
    80005da4:	4589                	li	a1,2
    80005da6:	14459073          	csrw	sip,a1
    80005daa:	6914                	ld	a3,16(a0)
    80005dac:	6510                	ld	a2,8(a0)
    80005dae:	610c                	ld	a1,0(a0)
    80005db0:	34051573          	csrrw	a0,mscratch,a0
    80005db4:	30200073          	mret
	...

0000000080005dba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dba:	1141                	addi	sp,sp,-16
    80005dbc:	e422                	sd	s0,8(sp)
    80005dbe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005dc0:	0c0007b7          	lui	a5,0xc000
    80005dc4:	4705                	li	a4,1
    80005dc6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005dc8:	c3d8                	sw	a4,4(a5)
}
    80005dca:	6422                	ld	s0,8(sp)
    80005dcc:	0141                	addi	sp,sp,16
    80005dce:	8082                	ret

0000000080005dd0 <plicinithart>:

void
plicinithart(void)
{
    80005dd0:	1141                	addi	sp,sp,-16
    80005dd2:	e406                	sd	ra,8(sp)
    80005dd4:	e022                	sd	s0,0(sp)
    80005dd6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005dd8:	ffffc097          	auipc	ra,0xffffc
    80005ddc:	c66080e7          	jalr	-922(ra) # 80001a3e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005de0:	0085171b          	slliw	a4,a0,0x8
    80005de4:	0c0027b7          	lui	a5,0xc002
    80005de8:	97ba                	add	a5,a5,a4
    80005dea:	40200713          	li	a4,1026
    80005dee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005df2:	00d5151b          	slliw	a0,a0,0xd
    80005df6:	0c2017b7          	lui	a5,0xc201
    80005dfa:	953e                	add	a0,a0,a5
    80005dfc:	00052023          	sw	zero,0(a0)
}
    80005e00:	60a2                	ld	ra,8(sp)
    80005e02:	6402                	ld	s0,0(sp)
    80005e04:	0141                	addi	sp,sp,16
    80005e06:	8082                	ret

0000000080005e08 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e08:	1141                	addi	sp,sp,-16
    80005e0a:	e406                	sd	ra,8(sp)
    80005e0c:	e022                	sd	s0,0(sp)
    80005e0e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e10:	ffffc097          	auipc	ra,0xffffc
    80005e14:	c2e080e7          	jalr	-978(ra) # 80001a3e <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e18:	00d5179b          	slliw	a5,a0,0xd
    80005e1c:	0c201537          	lui	a0,0xc201
    80005e20:	953e                	add	a0,a0,a5
  return irq;
}
    80005e22:	4148                	lw	a0,4(a0)
    80005e24:	60a2                	ld	ra,8(sp)
    80005e26:	6402                	ld	s0,0(sp)
    80005e28:	0141                	addi	sp,sp,16
    80005e2a:	8082                	ret

0000000080005e2c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e2c:	1101                	addi	sp,sp,-32
    80005e2e:	ec06                	sd	ra,24(sp)
    80005e30:	e822                	sd	s0,16(sp)
    80005e32:	e426                	sd	s1,8(sp)
    80005e34:	1000                	addi	s0,sp,32
    80005e36:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e38:	ffffc097          	auipc	ra,0xffffc
    80005e3c:	c06080e7          	jalr	-1018(ra) # 80001a3e <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e40:	00d5151b          	slliw	a0,a0,0xd
    80005e44:	0c2017b7          	lui	a5,0xc201
    80005e48:	97aa                	add	a5,a5,a0
    80005e4a:	c3c4                	sw	s1,4(a5)
}
    80005e4c:	60e2                	ld	ra,24(sp)
    80005e4e:	6442                	ld	s0,16(sp)
    80005e50:	64a2                	ld	s1,8(sp)
    80005e52:	6105                	addi	sp,sp,32
    80005e54:	8082                	ret

0000000080005e56 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005e56:	1141                	addi	sp,sp,-16
    80005e58:	e406                	sd	ra,8(sp)
    80005e5a:	e022                	sd	s0,0(sp)
    80005e5c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e5e:	479d                	li	a5,7
    80005e60:	06b7c963          	blt	a5,a1,80005ed2 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005e64:	00151793          	slli	a5,a0,0x1
    80005e68:	97aa                	add	a5,a5,a0
    80005e6a:	00c79713          	slli	a4,a5,0xc
    80005e6e:	0001c797          	auipc	a5,0x1c
    80005e72:	19278793          	addi	a5,a5,402 # 80022000 <disk>
    80005e76:	97ba                	add	a5,a5,a4
    80005e78:	97ae                	add	a5,a5,a1
    80005e7a:	6709                	lui	a4,0x2
    80005e7c:	97ba                	add	a5,a5,a4
    80005e7e:	0187c783          	lbu	a5,24(a5)
    80005e82:	e3a5                	bnez	a5,80005ee2 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80005e84:	0001c817          	auipc	a6,0x1c
    80005e88:	17c80813          	addi	a6,a6,380 # 80022000 <disk>
    80005e8c:	00151693          	slli	a3,a0,0x1
    80005e90:	00a68733          	add	a4,a3,a0
    80005e94:	0732                	slli	a4,a4,0xc
    80005e96:	00e807b3          	add	a5,a6,a4
    80005e9a:	6709                	lui	a4,0x2
    80005e9c:	00f70633          	add	a2,a4,a5
    80005ea0:	6210                	ld	a2,0(a2)
    80005ea2:	00459893          	slli	a7,a1,0x4
    80005ea6:	9646                	add	a2,a2,a7
    80005ea8:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    80005eac:	97ae                	add	a5,a5,a1
    80005eae:	97ba                	add	a5,a5,a4
    80005eb0:	4605                	li	a2,1
    80005eb2:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80005eb6:	96aa                	add	a3,a3,a0
    80005eb8:	06b2                	slli	a3,a3,0xc
    80005eba:	0761                	addi	a4,a4,24
    80005ebc:	96ba                	add	a3,a3,a4
    80005ebe:	00d80533          	add	a0,a6,a3
    80005ec2:	ffffc097          	auipc	ra,0xffffc
    80005ec6:	4ea080e7          	jalr	1258(ra) # 800023ac <wakeup>
}
    80005eca:	60a2                	ld	ra,8(sp)
    80005ecc:	6402                	ld	s0,0(sp)
    80005ece:	0141                	addi	sp,sp,16
    80005ed0:	8082                	ret
    panic("virtio_disk_intr 1");
    80005ed2:	00003517          	auipc	a0,0x3
    80005ed6:	c3650513          	addi	a0,a0,-970 # 80008b08 <userret+0xa78>
    80005eda:	ffffa097          	auipc	ra,0xffffa
    80005ede:	680080e7          	jalr	1664(ra) # 8000055a <panic>
    panic("virtio_disk_intr 2");
    80005ee2:	00003517          	auipc	a0,0x3
    80005ee6:	c3e50513          	addi	a0,a0,-962 # 80008b20 <userret+0xa90>
    80005eea:	ffffa097          	auipc	ra,0xffffa
    80005eee:	670080e7          	jalr	1648(ra) # 8000055a <panic>

0000000080005ef2 <virtio_disk_init>:
  __sync_synchronize();
    80005ef2:	0ff0000f          	fence
  if(disk[n].init)
    80005ef6:	00151793          	slli	a5,a0,0x1
    80005efa:	97aa                	add	a5,a5,a0
    80005efc:	07b2                	slli	a5,a5,0xc
    80005efe:	0001c717          	auipc	a4,0x1c
    80005f02:	10270713          	addi	a4,a4,258 # 80022000 <disk>
    80005f06:	973e                	add	a4,a4,a5
    80005f08:	6789                	lui	a5,0x2
    80005f0a:	97ba                	add	a5,a5,a4
    80005f0c:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80005f10:	c391                	beqz	a5,80005f14 <virtio_disk_init+0x22>
    80005f12:	8082                	ret
{
    80005f14:	7139                	addi	sp,sp,-64
    80005f16:	fc06                	sd	ra,56(sp)
    80005f18:	f822                	sd	s0,48(sp)
    80005f1a:	f426                	sd	s1,40(sp)
    80005f1c:	f04a                	sd	s2,32(sp)
    80005f1e:	ec4e                	sd	s3,24(sp)
    80005f20:	e852                	sd	s4,16(sp)
    80005f22:	e456                	sd	s5,8(sp)
    80005f24:	0080                	addi	s0,sp,64
    80005f26:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    80005f28:	85aa                	mv	a1,a0
    80005f2a:	00003517          	auipc	a0,0x3
    80005f2e:	c0e50513          	addi	a0,a0,-1010 # 80008b38 <userret+0xaa8>
    80005f32:	ffffa097          	auipc	ra,0xffffa
    80005f36:	682080e7          	jalr	1666(ra) # 800005b4 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    80005f3a:	00149993          	slli	s3,s1,0x1
    80005f3e:	99a6                	add	s3,s3,s1
    80005f40:	09b2                	slli	s3,s3,0xc
    80005f42:	6789                	lui	a5,0x2
    80005f44:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    80005f48:	97ce                	add	a5,a5,s3
    80005f4a:	00003597          	auipc	a1,0x3
    80005f4e:	c0658593          	addi	a1,a1,-1018 # 80008b50 <userret+0xac0>
    80005f52:	0001c517          	auipc	a0,0x1c
    80005f56:	0ae50513          	addi	a0,a0,174 # 80022000 <disk>
    80005f5a:	953e                	add	a0,a0,a5
    80005f5c:	ffffb097          	auipc	ra,0xffffb
    80005f60:	a80080e7          	jalr	-1408(ra) # 800009dc <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f64:	0014891b          	addiw	s2,s1,1
    80005f68:	00c9191b          	slliw	s2,s2,0xc
    80005f6c:	100007b7          	lui	a5,0x10000
    80005f70:	97ca                	add	a5,a5,s2
    80005f72:	4398                	lw	a4,0(a5)
    80005f74:	2701                	sext.w	a4,a4
    80005f76:	747277b7          	lui	a5,0x74727
    80005f7a:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f7e:	12f71863          	bne	a4,a5,800060ae <virtio_disk_init+0x1bc>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005f82:	100007b7          	lui	a5,0x10000
    80005f86:	0791                	addi	a5,a5,4
    80005f88:	97ca                	add	a5,a5,s2
    80005f8a:	439c                	lw	a5,0(a5)
    80005f8c:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f8e:	4705                	li	a4,1
    80005f90:	10e79f63          	bne	a5,a4,800060ae <virtio_disk_init+0x1bc>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f94:	100007b7          	lui	a5,0x10000
    80005f98:	07a1                	addi	a5,a5,8
    80005f9a:	97ca                	add	a5,a5,s2
    80005f9c:	439c                	lw	a5,0(a5)
    80005f9e:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005fa0:	4709                	li	a4,2
    80005fa2:	10e79663          	bne	a5,a4,800060ae <virtio_disk_init+0x1bc>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005fa6:	100007b7          	lui	a5,0x10000
    80005faa:	07b1                	addi	a5,a5,12
    80005fac:	97ca                	add	a5,a5,s2
    80005fae:	4398                	lw	a4,0(a5)
    80005fb0:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005fb2:	554d47b7          	lui	a5,0x554d4
    80005fb6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005fba:	0ef71a63          	bne	a4,a5,800060ae <virtio_disk_init+0x1bc>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005fbe:	100007b7          	lui	a5,0x10000
    80005fc2:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80005fc6:	96ca                	add	a3,a3,s2
    80005fc8:	4705                	li	a4,1
    80005fca:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005fcc:	470d                	li	a4,3
    80005fce:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80005fd0:	01078713          	addi	a4,a5,16
    80005fd4:	974a                	add	a4,a4,s2
    80005fd6:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005fd8:	02078613          	addi	a2,a5,32
    80005fdc:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005fde:	c7ffe737          	lui	a4,0xc7ffe
    80005fe2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd6703>
    80005fe6:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005fe8:	2701                	sext.w	a4,a4
    80005fea:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005fec:	472d                	li	a4,11
    80005fee:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ff0:	473d                	li	a4,15
    80005ff2:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005ff4:	02878713          	addi	a4,a5,40
    80005ff8:	974a                	add	a4,a4,s2
    80005ffa:	6685                	lui	a3,0x1
    80005ffc:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005ffe:	03078713          	addi	a4,a5,48
    80006002:	974a                	add	a4,a4,s2
    80006004:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006008:	03478793          	addi	a5,a5,52
    8000600c:	97ca                	add	a5,a5,s2
    8000600e:	439c                	lw	a5,0(a5)
    80006010:	2781                	sext.w	a5,a5
  if(max == 0)
    80006012:	c7d5                	beqz	a5,800060be <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006014:	471d                	li	a4,7
    80006016:	0af77c63          	bgeu	a4,a5,800060ce <virtio_disk_init+0x1dc>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000601a:	10000ab7          	lui	s5,0x10000
    8000601e:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    80006022:	97ca                	add	a5,a5,s2
    80006024:	4721                	li	a4,8
    80006026:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    80006028:	0001ca17          	auipc	s4,0x1c
    8000602c:	fd8a0a13          	addi	s4,s4,-40 # 80022000 <disk>
    80006030:	99d2                	add	s3,s3,s4
    80006032:	6609                	lui	a2,0x2
    80006034:	4581                	li	a1,0
    80006036:	854e                	mv	a0,s3
    80006038:	ffffb097          	auipc	ra,0xffffb
    8000603c:	d46080e7          	jalr	-698(ra) # 80000d7e <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    80006040:	040a8a93          	addi	s5,s5,64
    80006044:	9956                	add	s2,s2,s5
    80006046:	00c9d793          	srli	a5,s3,0xc
    8000604a:	2781                	sext.w	a5,a5
    8000604c:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    80006050:	00149513          	slli	a0,s1,0x1
    80006054:	009507b3          	add	a5,a0,s1
    80006058:	07b2                	slli	a5,a5,0xc
    8000605a:	97d2                	add	a5,a5,s4
    8000605c:	6689                	lui	a3,0x2
    8000605e:	97b6                	add	a5,a5,a3
    80006060:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80006064:	08098713          	addi	a4,s3,128
    80006068:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    8000606a:	6705                	lui	a4,0x1
    8000606c:	99ba                	add	s3,s3,a4
    8000606e:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80006072:	4705                	li	a4,1
    80006074:	00e78c23          	sb	a4,24(a5)
    80006078:	00e78ca3          	sb	a4,25(a5)
    8000607c:	00e78d23          	sb	a4,26(a5)
    80006080:	00e78da3          	sb	a4,27(a5)
    80006084:	00e78e23          	sb	a4,28(a5)
    80006088:	00e78ea3          	sb	a4,29(a5)
    8000608c:	00e78f23          	sb	a4,30(a5)
    80006090:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80006094:	853e                	mv	a0,a5
    80006096:	4785                	li	a5,1
    80006098:	0af52423          	sw	a5,168(a0)
}
    8000609c:	70e2                	ld	ra,56(sp)
    8000609e:	7442                	ld	s0,48(sp)
    800060a0:	74a2                	ld	s1,40(sp)
    800060a2:	7902                	ld	s2,32(sp)
    800060a4:	69e2                	ld	s3,24(sp)
    800060a6:	6a42                	ld	s4,16(sp)
    800060a8:	6aa2                	ld	s5,8(sp)
    800060aa:	6121                	addi	sp,sp,64
    800060ac:	8082                	ret
    panic("could not find virtio disk");
    800060ae:	00003517          	auipc	a0,0x3
    800060b2:	ab250513          	addi	a0,a0,-1358 # 80008b60 <userret+0xad0>
    800060b6:	ffffa097          	auipc	ra,0xffffa
    800060ba:	4a4080e7          	jalr	1188(ra) # 8000055a <panic>
    panic("virtio disk has no queue 0");
    800060be:	00003517          	auipc	a0,0x3
    800060c2:	ac250513          	addi	a0,a0,-1342 # 80008b80 <userret+0xaf0>
    800060c6:	ffffa097          	auipc	ra,0xffffa
    800060ca:	494080e7          	jalr	1172(ra) # 8000055a <panic>
    panic("virtio disk max queue too short");
    800060ce:	00003517          	auipc	a0,0x3
    800060d2:	ad250513          	addi	a0,a0,-1326 # 80008ba0 <userret+0xb10>
    800060d6:	ffffa097          	auipc	ra,0xffffa
    800060da:	484080e7          	jalr	1156(ra) # 8000055a <panic>

00000000800060de <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    800060de:	7135                	addi	sp,sp,-160
    800060e0:	ed06                	sd	ra,152(sp)
    800060e2:	e922                	sd	s0,144(sp)
    800060e4:	e526                	sd	s1,136(sp)
    800060e6:	e14a                	sd	s2,128(sp)
    800060e8:	fcce                	sd	s3,120(sp)
    800060ea:	f8d2                	sd	s4,112(sp)
    800060ec:	f4d6                	sd	s5,104(sp)
    800060ee:	f0da                	sd	s6,96(sp)
    800060f0:	ecde                	sd	s7,88(sp)
    800060f2:	e8e2                	sd	s8,80(sp)
    800060f4:	e4e6                	sd	s9,72(sp)
    800060f6:	e0ea                	sd	s10,64(sp)
    800060f8:	fc6e                	sd	s11,56(sp)
    800060fa:	1100                	addi	s0,sp,160
    800060fc:	892a                	mv	s2,a0
    800060fe:	89ae                	mv	s3,a1
    80006100:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    80006102:	45dc                	lw	a5,12(a1)
    80006104:	0017979b          	slliw	a5,a5,0x1
    80006108:	1782                	slli	a5,a5,0x20
    8000610a:	9381                	srli	a5,a5,0x20
    8000610c:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    80006110:	00151493          	slli	s1,a0,0x1
    80006114:	94aa                	add	s1,s1,a0
    80006116:	04b2                	slli	s1,s1,0xc
    80006118:	6a89                	lui	s5,0x2
    8000611a:	0b0a8a13          	addi	s4,s5,176 # 20b0 <_entry-0x7fffdf50>
    8000611e:	9a26                	add	s4,s4,s1
    80006120:	0001cb97          	auipc	s7,0x1c
    80006124:	ee0b8b93          	addi	s7,s7,-288 # 80022000 <disk>
    80006128:	9a5e                	add	s4,s4,s7
    8000612a:	8552                	mv	a0,s4
    8000612c:	ffffb097          	auipc	ra,0xffffb
    80006130:	984080e7          	jalr	-1660(ra) # 80000ab0 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80006134:	0ae1                	addi	s5,s5,24
    80006136:	94d6                	add	s1,s1,s5
    80006138:	01748ab3          	add	s5,s1,s7
    8000613c:	8d56                	mv	s10,s5
  for(int i = 0; i < 3; i++){
    8000613e:	4b81                	li	s7,0
  for(int i = 0; i < NUM; i++){
    80006140:	4ca1                	li	s9,8
      disk[n].free[i] = 0;
    80006142:	00191b13          	slli	s6,s2,0x1
    80006146:	9b4a                	add	s6,s6,s2
    80006148:	00cb1793          	slli	a5,s6,0xc
    8000614c:	0001cb17          	auipc	s6,0x1c
    80006150:	eb4b0b13          	addi	s6,s6,-332 # 80022000 <disk>
    80006154:	9b3e                	add	s6,s6,a5
  for(int i = 0; i < NUM; i++){
    80006156:	8c5e                	mv	s8,s7
    80006158:	a8ad                	j	800061d2 <virtio_disk_rw+0xf4>
      disk[n].free[i] = 0;
    8000615a:	00fb06b3          	add	a3,s6,a5
    8000615e:	96aa                	add	a3,a3,a0
    80006160:	00068c23          	sb	zero,24(a3) # 2018 <_entry-0x7fffdfe8>
    idx[i] = alloc_desc(n);
    80006164:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80006166:	0207c363          	bltz	a5,8000618c <virtio_disk_rw+0xae>
  for(int i = 0; i < 3; i++){
    8000616a:	2485                	addiw	s1,s1,1
    8000616c:	0711                	addi	a4,a4,4
    8000616e:	26b48f63          	beq	s1,a1,800063ec <virtio_disk_rw+0x30e>
    idx[i] = alloc_desc(n);
    80006172:	863a                	mv	a2,a4
    80006174:	86ea                	mv	a3,s10
  for(int i = 0; i < NUM; i++){
    80006176:	87e2                	mv	a5,s8
    if(disk[n].free[i]){
    80006178:	0006c803          	lbu	a6,0(a3)
    8000617c:	fc081fe3          	bnez	a6,8000615a <virtio_disk_rw+0x7c>
  for(int i = 0; i < NUM; i++){
    80006180:	2785                	addiw	a5,a5,1
    80006182:	0685                	addi	a3,a3,1
    80006184:	ff979ae3          	bne	a5,s9,80006178 <virtio_disk_rw+0x9a>
    idx[i] = alloc_desc(n);
    80006188:	57fd                	li	a5,-1
    8000618a:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000618c:	02905d63          	blez	s1,800061c6 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    80006190:	f8042583          	lw	a1,-128(s0)
    80006194:	854a                	mv	a0,s2
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	cc0080e7          	jalr	-832(ra) # 80005e56 <free_desc>
      for(int j = 0; j < i; j++)
    8000619e:	4785                	li	a5,1
    800061a0:	0297d363          	bge	a5,s1,800061c6 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    800061a4:	f8442583          	lw	a1,-124(s0)
    800061a8:	854a                	mv	a0,s2
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	cac080e7          	jalr	-852(ra) # 80005e56 <free_desc>
      for(int j = 0; j < i; j++)
    800061b2:	4789                	li	a5,2
    800061b4:	0097d963          	bge	a5,s1,800061c6 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    800061b8:	f8842583          	lw	a1,-120(s0)
    800061bc:	854a                	mv	a0,s2
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	c98080e7          	jalr	-872(ra) # 80005e56 <free_desc>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    800061c6:	85d2                	mv	a1,s4
    800061c8:	8556                	mv	a0,s5
    800061ca:	ffffc097          	auipc	ra,0xffffc
    800061ce:	05c080e7          	jalr	92(ra) # 80002226 <sleep>
  for(int i = 0; i < 3; i++){
    800061d2:	f8040713          	addi	a4,s0,-128
    800061d6:	84de                	mv	s1,s7
      disk[n].free[i] = 0;
    800061d8:	6509                	lui	a0,0x2
  for(int i = 0; i < 3; i++){
    800061da:	458d                	li	a1,3
    800061dc:	bf59                	j	80006172 <virtio_disk_rw+0x94>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    800061de:	4785                	li	a5,1
    800061e0:	f6f42823          	sw	a5,-144(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    800061e4:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800061e8:	f6843783          	ld	a5,-152(s0)
    800061ec:	f6f43c23          	sd	a5,-136(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800061f0:	f8042483          	lw	s1,-128(s0)
    800061f4:	00449b13          	slli	s6,s1,0x4
    800061f8:	00191793          	slli	a5,s2,0x1
    800061fc:	97ca                	add	a5,a5,s2
    800061fe:	07b2                	slli	a5,a5,0xc
    80006200:	0001ca97          	auipc	s5,0x1c
    80006204:	e00a8a93          	addi	s5,s5,-512 # 80022000 <disk>
    80006208:	97d6                	add	a5,a5,s5
    8000620a:	6a89                	lui	s5,0x2
    8000620c:	9abe                	add	s5,s5,a5
    8000620e:	000abb83          	ld	s7,0(s5) # 2000 <_entry-0x7fffe000>
    80006212:	9bda                	add	s7,s7,s6
    80006214:	f7040513          	addi	a0,s0,-144
    80006218:	ffffb097          	auipc	ra,0xffffb
    8000621c:	fa6080e7          	jalr	-90(ra) # 800011be <kvmpa>
    80006220:	00abb023          	sd	a0,0(s7)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    80006224:	000ab783          	ld	a5,0(s5)
    80006228:	97da                	add	a5,a5,s6
    8000622a:	4741                	li	a4,16
    8000622c:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000622e:	000ab783          	ld	a5,0(s5)
    80006232:	97da                	add	a5,a5,s6
    80006234:	4705                	li	a4,1
    80006236:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    8000623a:	f8442683          	lw	a3,-124(s0)
    8000623e:	000ab783          	ld	a5,0(s5)
    80006242:	9b3e                	add	s6,s6,a5
    80006244:	00db1723          	sh	a3,14(s6)

  disk[n].desc[idx[1]].addr = (uint64) b->data;
    80006248:	0692                	slli	a3,a3,0x4
    8000624a:	000ab783          	ld	a5,0(s5)
    8000624e:	97b6                	add	a5,a5,a3
    80006250:	06098713          	addi	a4,s3,96
    80006254:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    80006256:	000ab783          	ld	a5,0(s5)
    8000625a:	97b6                	add	a5,a5,a3
    8000625c:	40000713          	li	a4,1024
    80006260:	c798                	sw	a4,8(a5)
  if(write)
    80006262:	140d8063          	beqz	s11,800063a2 <virtio_disk_rw+0x2c4>
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    80006266:	000ab783          	ld	a5,0(s5)
    8000626a:	97b6                	add	a5,a5,a3
    8000626c:	00079623          	sh	zero,12(a5)
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006270:	0001c517          	auipc	a0,0x1c
    80006274:	d9050513          	addi	a0,a0,-624 # 80022000 <disk>
    80006278:	00191793          	slli	a5,s2,0x1
    8000627c:	01278733          	add	a4,a5,s2
    80006280:	0732                	slli	a4,a4,0xc
    80006282:	972a                	add	a4,a4,a0
    80006284:	6609                	lui	a2,0x2
    80006286:	9732                	add	a4,a4,a2
    80006288:	630c                	ld	a1,0(a4)
    8000628a:	95b6                	add	a1,a1,a3
    8000628c:	00c5d603          	lhu	a2,12(a1)
    80006290:	00166613          	ori	a2,a2,1
    80006294:	00c59623          	sh	a2,12(a1)
  disk[n].desc[idx[1]].next = idx[2];
    80006298:	f8842603          	lw	a2,-120(s0)
    8000629c:	630c                	ld	a1,0(a4)
    8000629e:	96ae                	add	a3,a3,a1
    800062a0:	00c69723          	sh	a2,14(a3)

  disk[n].info[idx[0]].status = 0;
    800062a4:	97ca                	add	a5,a5,s2
    800062a6:	07a2                	slli	a5,a5,0x8
    800062a8:	97a6                	add	a5,a5,s1
    800062aa:	20078793          	addi	a5,a5,512
    800062ae:	0792                	slli	a5,a5,0x4
    800062b0:	97aa                	add	a5,a5,a0
    800062b2:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    800062b6:	00461693          	slli	a3,a2,0x4
    800062ba:	00073803          	ld	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800062be:	9836                	add	a6,a6,a3
    800062c0:	20348613          	addi	a2,s1,515
    800062c4:	00191593          	slli	a1,s2,0x1
    800062c8:	95ca                	add	a1,a1,s2
    800062ca:	05a2                	slli	a1,a1,0x8
    800062cc:	962e                	add	a2,a2,a1
    800062ce:	0612                	slli	a2,a2,0x4
    800062d0:	962a                	add	a2,a2,a0
    800062d2:	00c83023          	sd	a2,0(a6)
  disk[n].desc[idx[2]].len = 1;
    800062d6:	6310                	ld	a2,0(a4)
    800062d8:	9636                	add	a2,a2,a3
    800062da:	4585                	li	a1,1
    800062dc:	c60c                	sw	a1,8(a2)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800062de:	6310                	ld	a2,0(a4)
    800062e0:	9636                	add	a2,a2,a3
    800062e2:	4509                	li	a0,2
    800062e4:	00a61623          	sh	a0,12(a2) # 200c <_entry-0x7fffdff4>
  disk[n].desc[idx[2]].next = 0;
    800062e8:	6310                	ld	a2,0(a4)
    800062ea:	96b2                	add	a3,a3,a2
    800062ec:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800062f0:	00b9a223          	sw	a1,4(s3)
  disk[n].info[idx[0]].b = b;
    800062f4:	0337b423          	sd	s3,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    800062f8:	6714                	ld	a3,8(a4)
    800062fa:	0026d783          	lhu	a5,2(a3)
    800062fe:	8b9d                	andi	a5,a5,7
    80006300:	2789                	addiw	a5,a5,2
    80006302:	0786                	slli	a5,a5,0x1
    80006304:	97b6                	add	a5,a5,a3
    80006306:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000630a:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    8000630e:	6718                	ld	a4,8(a4)
    80006310:	00275783          	lhu	a5,2(a4)
    80006314:	2785                	addiw	a5,a5,1
    80006316:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000631a:	0019079b          	addiw	a5,s2,1
    8000631e:	00c7979b          	slliw	a5,a5,0xc
    80006322:	10000737          	lui	a4,0x10000
    80006326:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    8000632a:	97ba                	add	a5,a5,a4
    8000632c:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006330:	0049a703          	lw	a4,4(s3)
    80006334:	4785                	li	a5,1
    80006336:	00f71d63          	bne	a4,a5,80006350 <virtio_disk_rw+0x272>
    8000633a:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    8000633c:	85d2                	mv	a1,s4
    8000633e:	854e                	mv	a0,s3
    80006340:	ffffc097          	auipc	ra,0xffffc
    80006344:	ee6080e7          	jalr	-282(ra) # 80002226 <sleep>
  while(b->disk == 1) {
    80006348:	0049a783          	lw	a5,4(s3)
    8000634c:	fe9788e3          	beq	a5,s1,8000633c <virtio_disk_rw+0x25e>
  }

  disk[n].info[idx[0]].b = 0;
    80006350:	f8042483          	lw	s1,-128(s0)
    80006354:	00191793          	slli	a5,s2,0x1
    80006358:	97ca                	add	a5,a5,s2
    8000635a:	07a2                	slli	a5,a5,0x8
    8000635c:	97a6                	add	a5,a5,s1
    8000635e:	20078793          	addi	a5,a5,512
    80006362:	0792                	slli	a5,a5,0x4
    80006364:	0001c717          	auipc	a4,0x1c
    80006368:	c9c70713          	addi	a4,a4,-868 # 80022000 <disk>
    8000636c:	97ba                	add	a5,a5,a4
    8000636e:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006372:	00191793          	slli	a5,s2,0x1
    80006376:	97ca                	add	a5,a5,s2
    80006378:	07b2                	slli	a5,a5,0xc
    8000637a:	97ba                	add	a5,a5,a4
    8000637c:	6989                	lui	s3,0x2
    8000637e:	99be                	add	s3,s3,a5
    free_desc(n, i);
    80006380:	85a6                	mv	a1,s1
    80006382:	854a                	mv	a0,s2
    80006384:	00000097          	auipc	ra,0x0
    80006388:	ad2080e7          	jalr	-1326(ra) # 80005e56 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    8000638c:	0492                	slli	s1,s1,0x4
    8000638e:	0009b783          	ld	a5,0(s3) # 2000 <_entry-0x7fffe000>
    80006392:	94be                	add	s1,s1,a5
    80006394:	00c4d783          	lhu	a5,12(s1)
    80006398:	8b85                	andi	a5,a5,1
    8000639a:	c78d                	beqz	a5,800063c4 <virtio_disk_rw+0x2e6>
      i = disk[n].desc[i].next;
    8000639c:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    800063a0:	b7c5                	j	80006380 <virtio_disk_rw+0x2a2>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800063a2:	00191793          	slli	a5,s2,0x1
    800063a6:	97ca                	add	a5,a5,s2
    800063a8:	07b2                	slli	a5,a5,0xc
    800063aa:	0001c717          	auipc	a4,0x1c
    800063ae:	c5670713          	addi	a4,a4,-938 # 80022000 <disk>
    800063b2:	973e                	add	a4,a4,a5
    800063b4:	6789                	lui	a5,0x2
    800063b6:	97ba                	add	a5,a5,a4
    800063b8:	639c                	ld	a5,0(a5)
    800063ba:	97b6                	add	a5,a5,a3
    800063bc:	4709                	li	a4,2
    800063be:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    800063c2:	b57d                	j	80006270 <virtio_disk_rw+0x192>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    800063c4:	8552                	mv	a0,s4
    800063c6:	ffffa097          	auipc	ra,0xffffa
    800063ca:	7ba080e7          	jalr	1978(ra) # 80000b80 <release>
}
    800063ce:	60ea                	ld	ra,152(sp)
    800063d0:	644a                	ld	s0,144(sp)
    800063d2:	64aa                	ld	s1,136(sp)
    800063d4:	690a                	ld	s2,128(sp)
    800063d6:	79e6                	ld	s3,120(sp)
    800063d8:	7a46                	ld	s4,112(sp)
    800063da:	7aa6                	ld	s5,104(sp)
    800063dc:	7b06                	ld	s6,96(sp)
    800063de:	6be6                	ld	s7,88(sp)
    800063e0:	6c46                	ld	s8,80(sp)
    800063e2:	6ca6                	ld	s9,72(sp)
    800063e4:	6d06                	ld	s10,64(sp)
    800063e6:	7de2                	ld	s11,56(sp)
    800063e8:	610d                	addi	sp,sp,160
    800063ea:	8082                	ret
  if(write)
    800063ec:	de0d99e3          	bnez	s11,800061de <virtio_disk_rw+0x100>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    800063f0:	f6042823          	sw	zero,-144(s0)
    800063f4:	bbc5                	j	800061e4 <virtio_disk_rw+0x106>

00000000800063f6 <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    800063f6:	7139                	addi	sp,sp,-64
    800063f8:	fc06                	sd	ra,56(sp)
    800063fa:	f822                	sd	s0,48(sp)
    800063fc:	f426                	sd	s1,40(sp)
    800063fe:	f04a                	sd	s2,32(sp)
    80006400:	ec4e                	sd	s3,24(sp)
    80006402:	e852                	sd	s4,16(sp)
    80006404:	e456                	sd	s5,8(sp)
    80006406:	0080                	addi	s0,sp,64
    80006408:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    8000640a:	00151913          	slli	s2,a0,0x1
    8000640e:	00a90a33          	add	s4,s2,a0
    80006412:	0a32                	slli	s4,s4,0xc
    80006414:	6989                	lui	s3,0x2
    80006416:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    8000641a:	9a3e                	add	s4,s4,a5
    8000641c:	0001ca97          	auipc	s5,0x1c
    80006420:	be4a8a93          	addi	s5,s5,-1052 # 80022000 <disk>
    80006424:	9a56                	add	s4,s4,s5
    80006426:	8552                	mv	a0,s4
    80006428:	ffffa097          	auipc	ra,0xffffa
    8000642c:	688080e7          	jalr	1672(ra) # 80000ab0 <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    80006430:	9926                	add	s2,s2,s1
    80006432:	0932                	slli	s2,s2,0xc
    80006434:	9956                	add	s2,s2,s5
    80006436:	99ca                	add	s3,s3,s2
    80006438:	0209d783          	lhu	a5,32(s3)
    8000643c:	0109b703          	ld	a4,16(s3)
    80006440:	00275683          	lhu	a3,2(a4)
    80006444:	8ebd                	xor	a3,a3,a5
    80006446:	8a9d                	andi	a3,a3,7
    80006448:	c2a5                	beqz	a3,800064a8 <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    8000644a:	8956                	mv	s2,s5
    8000644c:	00149693          	slli	a3,s1,0x1
    80006450:	96a6                	add	a3,a3,s1
    80006452:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006456:	06b2                	slli	a3,a3,0xc
    80006458:	96d6                	add	a3,a3,s5
    8000645a:	6489                	lui	s1,0x2
    8000645c:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    8000645e:	078e                	slli	a5,a5,0x3
    80006460:	97ba                	add	a5,a5,a4
    80006462:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    80006464:	00f98733          	add	a4,s3,a5
    80006468:	20070713          	addi	a4,a4,512
    8000646c:	0712                	slli	a4,a4,0x4
    8000646e:	974a                	add	a4,a4,s2
    80006470:	03074703          	lbu	a4,48(a4)
    80006474:	eb21                	bnez	a4,800064c4 <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    80006476:	97ce                	add	a5,a5,s3
    80006478:	20078793          	addi	a5,a5,512
    8000647c:	0792                	slli	a5,a5,0x4
    8000647e:	97ca                	add	a5,a5,s2
    80006480:	7798                	ld	a4,40(a5)
    80006482:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    80006486:	7788                	ld	a0,40(a5)
    80006488:	ffffc097          	auipc	ra,0xffffc
    8000648c:	f24080e7          	jalr	-220(ra) # 800023ac <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006490:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    80006494:	2785                	addiw	a5,a5,1
    80006496:	8b9d                	andi	a5,a5,7
    80006498:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    8000649c:	6898                	ld	a4,16(s1)
    8000649e:	00275683          	lhu	a3,2(a4)
    800064a2:	8a9d                	andi	a3,a3,7
    800064a4:	faf69de3          	bne	a3,a5,8000645e <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    800064a8:	8552                	mv	a0,s4
    800064aa:	ffffa097          	auipc	ra,0xffffa
    800064ae:	6d6080e7          	jalr	1750(ra) # 80000b80 <release>
}
    800064b2:	70e2                	ld	ra,56(sp)
    800064b4:	7442                	ld	s0,48(sp)
    800064b6:	74a2                	ld	s1,40(sp)
    800064b8:	7902                	ld	s2,32(sp)
    800064ba:	69e2                	ld	s3,24(sp)
    800064bc:	6a42                	ld	s4,16(sp)
    800064be:	6aa2                	ld	s5,8(sp)
    800064c0:	6121                	addi	sp,sp,64
    800064c2:	8082                	ret
      panic("virtio_disk_intr status");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	6fc50513          	addi	a0,a0,1788 # 80008bc0 <userret+0xb30>
    800064cc:	ffffa097          	auipc	ra,0xffffa
    800064d0:	08e080e7          	jalr	142(ra) # 8000055a <panic>

00000000800064d4 <bit_isset>:
static Sz_info *bd_sizes; 
static void *bd_base;   // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    800064d4:	1141                	addi	sp,sp,-16
    800064d6:	e422                	sd	s0,8(sp)
    800064d8:	0800                	addi	s0,sp,16
  char b = array[index/8];
  char m = (1 << (index % 8));
    800064da:	41f5d79b          	sraiw	a5,a1,0x1f
    800064de:	01d7d79b          	srliw	a5,a5,0x1d
    800064e2:	9dbd                	addw	a1,a1,a5
    800064e4:	0075f713          	andi	a4,a1,7
    800064e8:	9f1d                	subw	a4,a4,a5
    800064ea:	4785                	li	a5,1
    800064ec:	00e797bb          	sllw	a5,a5,a4
    800064f0:	0ff7f793          	andi	a5,a5,255
  char b = array[index/8];
    800064f4:	4035d59b          	sraiw	a1,a1,0x3
    800064f8:	95aa                	add	a1,a1,a0
  return (b & m) == m;
    800064fa:	0005c503          	lbu	a0,0(a1)
    800064fe:	8d7d                	and	a0,a0,a5
    80006500:	8d1d                	sub	a0,a0,a5
}
    80006502:	00153513          	seqz	a0,a0
    80006506:	6422                	ld	s0,8(sp)
    80006508:	0141                	addi	sp,sp,16
    8000650a:	8082                	ret

000000008000650c <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    8000650c:	1141                	addi	sp,sp,-16
    8000650e:	e422                	sd	s0,8(sp)
    80006510:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006512:	41f5d79b          	sraiw	a5,a1,0x1f
    80006516:	01d7d79b          	srliw	a5,a5,0x1d
    8000651a:	9dbd                	addw	a1,a1,a5
    8000651c:	4035d71b          	sraiw	a4,a1,0x3
    80006520:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    80006522:	899d                	andi	a1,a1,7
    80006524:	9d9d                	subw	a1,a1,a5
  array[index/8] = (b | m);
    80006526:	4785                	li	a5,1
    80006528:	00b795bb          	sllw	a1,a5,a1
    8000652c:	00054783          	lbu	a5,0(a0)
    80006530:	8ddd                	or	a1,a1,a5
    80006532:	00b50023          	sb	a1,0(a0)
}
    80006536:	6422                	ld	s0,8(sp)
    80006538:	0141                	addi	sp,sp,16
    8000653a:	8082                	ret

000000008000653c <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    8000653c:	1141                	addi	sp,sp,-16
    8000653e:	e422                	sd	s0,8(sp)
    80006540:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006542:	41f5d79b          	sraiw	a5,a1,0x1f
    80006546:	01d7d79b          	srliw	a5,a5,0x1d
    8000654a:	9dbd                	addw	a1,a1,a5
    8000654c:	4035d71b          	sraiw	a4,a1,0x3
    80006550:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    80006552:	899d                	andi	a1,a1,7
    80006554:	9d9d                	subw	a1,a1,a5
  array[index/8] = (b & ~m);
    80006556:	4785                	li	a5,1
    80006558:	00b795bb          	sllw	a1,a5,a1
    8000655c:	fff5c593          	not	a1,a1
    80006560:	00054783          	lbu	a5,0(a0)
    80006564:	8dfd                	and	a1,a1,a5
    80006566:	00b50023          	sb	a1,0(a0)
}
    8000656a:	6422                	ld	s0,8(sp)
    8000656c:	0141                	addi	sp,sp,16
    8000656e:	8082                	ret

0000000080006570 <bd_print_vector>:

// Print a bit vector as a list of ranges of 1 bits
void
bd_print_vector(char *vector, int len) {
    80006570:	715d                	addi	sp,sp,-80
    80006572:	e486                	sd	ra,72(sp)
    80006574:	e0a2                	sd	s0,64(sp)
    80006576:	fc26                	sd	s1,56(sp)
    80006578:	f84a                	sd	s2,48(sp)
    8000657a:	f44e                	sd	s3,40(sp)
    8000657c:	f052                	sd	s4,32(sp)
    8000657e:	ec56                	sd	s5,24(sp)
    80006580:	e85a                	sd	s6,16(sp)
    80006582:	e45e                	sd	s7,8(sp)
    80006584:	0880                	addi	s0,sp,80
    80006586:	8a2e                	mv	s4,a1
  int last, lb;
  
  last = 1;
  lb = 0;
  for (int b = 0; b < len; b++) {
    80006588:	08b05b63          	blez	a1,8000661e <bd_print_vector+0xae>
    8000658c:	89aa                	mv	s3,a0
    8000658e:	4481                	li	s1,0
  lb = 0;
    80006590:	4a81                	li	s5,0
  last = 1;
    80006592:	4905                	li	s2,1
    if (last == bit_isset(vector, b))
      continue;
    if(last == 1)
    80006594:	4b05                	li	s6,1
      printf(" [%d, %d)", lb, b);
    80006596:	00002b97          	auipc	s7,0x2
    8000659a:	642b8b93          	addi	s7,s7,1602 # 80008bd8 <userret+0xb48>
    8000659e:	a01d                	j	800065c4 <bd_print_vector+0x54>
    800065a0:	8626                	mv	a2,s1
    800065a2:	85d6                	mv	a1,s5
    800065a4:	855e                	mv	a0,s7
    800065a6:	ffffa097          	auipc	ra,0xffffa
    800065aa:	00e080e7          	jalr	14(ra) # 800005b4 <printf>
    lb = b;
    last = bit_isset(vector, b);
    800065ae:	85a6                	mv	a1,s1
    800065b0:	854e                	mv	a0,s3
    800065b2:	00000097          	auipc	ra,0x0
    800065b6:	f22080e7          	jalr	-222(ra) # 800064d4 <bit_isset>
    800065ba:	892a                	mv	s2,a0
    800065bc:	8aa6                	mv	s5,s1
  for (int b = 0; b < len; b++) {
    800065be:	2485                	addiw	s1,s1,1
    800065c0:	009a0d63          	beq	s4,s1,800065da <bd_print_vector+0x6a>
    if (last == bit_isset(vector, b))
    800065c4:	85a6                	mv	a1,s1
    800065c6:	854e                	mv	a0,s3
    800065c8:	00000097          	auipc	ra,0x0
    800065cc:	f0c080e7          	jalr	-244(ra) # 800064d4 <bit_isset>
    800065d0:	ff2507e3          	beq	a0,s2,800065be <bd_print_vector+0x4e>
    if(last == 1)
    800065d4:	fd691de3          	bne	s2,s6,800065ae <bd_print_vector+0x3e>
    800065d8:	b7e1                	j	800065a0 <bd_print_vector+0x30>
  }
  if(lb == 0 || last == 1) {
    800065da:	000a8563          	beqz	s5,800065e4 <bd_print_vector+0x74>
    800065de:	4785                	li	a5,1
    800065e0:	00f91c63          	bne	s2,a5,800065f8 <bd_print_vector+0x88>
    printf(" [%d, %d)", lb, len);
    800065e4:	8652                	mv	a2,s4
    800065e6:	85d6                	mv	a1,s5
    800065e8:	00002517          	auipc	a0,0x2
    800065ec:	5f050513          	addi	a0,a0,1520 # 80008bd8 <userret+0xb48>
    800065f0:	ffffa097          	auipc	ra,0xffffa
    800065f4:	fc4080e7          	jalr	-60(ra) # 800005b4 <printf>
  }
  printf("\n");
    800065f8:	00002517          	auipc	a0,0x2
    800065fc:	c9850513          	addi	a0,a0,-872 # 80008290 <userret+0x200>
    80006600:	ffffa097          	auipc	ra,0xffffa
    80006604:	fb4080e7          	jalr	-76(ra) # 800005b4 <printf>
}
    80006608:	60a6                	ld	ra,72(sp)
    8000660a:	6406                	ld	s0,64(sp)
    8000660c:	74e2                	ld	s1,56(sp)
    8000660e:	7942                	ld	s2,48(sp)
    80006610:	79a2                	ld	s3,40(sp)
    80006612:	7a02                	ld	s4,32(sp)
    80006614:	6ae2                	ld	s5,24(sp)
    80006616:	6b42                	ld	s6,16(sp)
    80006618:	6ba2                	ld	s7,8(sp)
    8000661a:	6161                	addi	sp,sp,80
    8000661c:	8082                	ret
  lb = 0;
    8000661e:	4a81                	li	s5,0
    80006620:	b7d1                	j	800065e4 <bd_print_vector+0x74>

0000000080006622 <bd_print>:

// Print buddy's data structures
void
bd_print() {
  for (int k = 0; k < nsizes; k++) {
    80006622:	00022697          	auipc	a3,0x22
    80006626:	a366a683          	lw	a3,-1482(a3) # 80028058 <nsizes>
    8000662a:	10d05063          	blez	a3,8000672a <bd_print+0x108>
bd_print() {
    8000662e:	711d                	addi	sp,sp,-96
    80006630:	ec86                	sd	ra,88(sp)
    80006632:	e8a2                	sd	s0,80(sp)
    80006634:	e4a6                	sd	s1,72(sp)
    80006636:	e0ca                	sd	s2,64(sp)
    80006638:	fc4e                	sd	s3,56(sp)
    8000663a:	f852                	sd	s4,48(sp)
    8000663c:	f456                	sd	s5,40(sp)
    8000663e:	f05a                	sd	s6,32(sp)
    80006640:	ec5e                	sd	s7,24(sp)
    80006642:	e862                	sd	s8,16(sp)
    80006644:	e466                	sd	s9,8(sp)
    80006646:	e06a                	sd	s10,0(sp)
    80006648:	1080                	addi	s0,sp,96
  for (int k = 0; k < nsizes; k++) {
    8000664a:	4481                	li	s1,0
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    8000664c:	4a85                	li	s5,1
    8000664e:	4c41                	li	s8,16
    80006650:	00002b97          	auipc	s7,0x2
    80006654:	598b8b93          	addi	s7,s7,1432 # 80008be8 <userret+0xb58>
    lst_print(&bd_sizes[k].free);
    80006658:	00022a17          	auipc	s4,0x22
    8000665c:	9f8a0a13          	addi	s4,s4,-1544 # 80028050 <bd_sizes>
    printf("  alloc:");
    80006660:	00002b17          	auipc	s6,0x2
    80006664:	5b0b0b13          	addi	s6,s6,1456 # 80008c10 <userret+0xb80>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    80006668:	00022997          	auipc	s3,0x22
    8000666c:	9f098993          	addi	s3,s3,-1552 # 80028058 <nsizes>
    if(k > 0) {
      printf("  split:");
    80006670:	00002c97          	auipc	s9,0x2
    80006674:	5b0c8c93          	addi	s9,s9,1456 # 80008c20 <userret+0xb90>
    80006678:	a801                	j	80006688 <bd_print+0x66>
  for (int k = 0; k < nsizes; k++) {
    8000667a:	0009a683          	lw	a3,0(s3)
    8000667e:	0485                	addi	s1,s1,1
    80006680:	0004879b          	sext.w	a5,s1
    80006684:	08d7d563          	bge	a5,a3,8000670e <bd_print+0xec>
    80006688:	0004891b          	sext.w	s2,s1
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    8000668c:	36fd                	addiw	a3,a3,-1
    8000668e:	9e85                	subw	a3,a3,s1
    80006690:	00da96bb          	sllw	a3,s5,a3
    80006694:	009c1633          	sll	a2,s8,s1
    80006698:	85ca                	mv	a1,s2
    8000669a:	855e                	mv	a0,s7
    8000669c:	ffffa097          	auipc	ra,0xffffa
    800066a0:	f18080e7          	jalr	-232(ra) # 800005b4 <printf>
    lst_print(&bd_sizes[k].free);
    800066a4:	00549d13          	slli	s10,s1,0x5
    800066a8:	000a3503          	ld	a0,0(s4)
    800066ac:	956a                	add	a0,a0,s10
    800066ae:	00001097          	auipc	ra,0x1
    800066b2:	a4e080e7          	jalr	-1458(ra) # 800070fc <lst_print>
    printf("  alloc:");
    800066b6:	855a                	mv	a0,s6
    800066b8:	ffffa097          	auipc	ra,0xffffa
    800066bc:	efc080e7          	jalr	-260(ra) # 800005b4 <printf>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    800066c0:	0009a583          	lw	a1,0(s3)
    800066c4:	35fd                	addiw	a1,a1,-1
    800066c6:	412585bb          	subw	a1,a1,s2
    800066ca:	000a3783          	ld	a5,0(s4)
    800066ce:	97ea                	add	a5,a5,s10
    800066d0:	00ba95bb          	sllw	a1,s5,a1
    800066d4:	6b88                	ld	a0,16(a5)
    800066d6:	00000097          	auipc	ra,0x0
    800066da:	e9a080e7          	jalr	-358(ra) # 80006570 <bd_print_vector>
    if(k > 0) {
    800066de:	f9205ee3          	blez	s2,8000667a <bd_print+0x58>
      printf("  split:");
    800066e2:	8566                	mv	a0,s9
    800066e4:	ffffa097          	auipc	ra,0xffffa
    800066e8:	ed0080e7          	jalr	-304(ra) # 800005b4 <printf>
      bd_print_vector(bd_sizes[k].split, NBLK(k));
    800066ec:	0009a583          	lw	a1,0(s3)
    800066f0:	35fd                	addiw	a1,a1,-1
    800066f2:	412585bb          	subw	a1,a1,s2
    800066f6:	000a3783          	ld	a5,0(s4)
    800066fa:	9d3e                	add	s10,s10,a5
    800066fc:	00ba95bb          	sllw	a1,s5,a1
    80006700:	018d3503          	ld	a0,24(s10)
    80006704:	00000097          	auipc	ra,0x0
    80006708:	e6c080e7          	jalr	-404(ra) # 80006570 <bd_print_vector>
    8000670c:	b7bd                	j	8000667a <bd_print+0x58>
    }
  }
}
    8000670e:	60e6                	ld	ra,88(sp)
    80006710:	6446                	ld	s0,80(sp)
    80006712:	64a6                	ld	s1,72(sp)
    80006714:	6906                	ld	s2,64(sp)
    80006716:	79e2                	ld	s3,56(sp)
    80006718:	7a42                	ld	s4,48(sp)
    8000671a:	7aa2                	ld	s5,40(sp)
    8000671c:	7b02                	ld	s6,32(sp)
    8000671e:	6be2                	ld	s7,24(sp)
    80006720:	6c42                	ld	s8,16(sp)
    80006722:	6ca2                	ld	s9,8(sp)
    80006724:	6d02                	ld	s10,0(sp)
    80006726:	6125                	addi	sp,sp,96
    80006728:	8082                	ret
    8000672a:	8082                	ret

000000008000672c <firstk>:

// What is the first k such that 2^k >= n?
int
firstk(uint64 n) {
    8000672c:	1141                	addi	sp,sp,-16
    8000672e:	e422                	sd	s0,8(sp)
    80006730:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    80006732:	47c1                	li	a5,16
    80006734:	00a7fb63          	bgeu	a5,a0,8000674a <firstk+0x1e>
    80006738:	872a                	mv	a4,a0
  int k = 0;
    8000673a:	4501                	li	a0,0
    k++;
    8000673c:	2505                	addiw	a0,a0,1
    size *= 2;
    8000673e:	0786                	slli	a5,a5,0x1
  while (size < n) {
    80006740:	fee7eee3          	bltu	a5,a4,8000673c <firstk+0x10>
  }
  return k;
}
    80006744:	6422                	ld	s0,8(sp)
    80006746:	0141                	addi	sp,sp,16
    80006748:	8082                	ret
  int k = 0;
    8000674a:	4501                	li	a0,0
    8000674c:	bfe5                	j	80006744 <firstk+0x18>

000000008000674e <blk_index>:

// Compute the block index for address p at size k
int
blk_index(int k, char *p) {
    8000674e:	1141                	addi	sp,sp,-16
    80006750:	e422                	sd	s0,8(sp)
    80006752:	0800                	addi	s0,sp,16
  int n = p - (char *) bd_base;
  return n / BLK_SIZE(k);
    80006754:	00022797          	auipc	a5,0x22
    80006758:	8f47b783          	ld	a5,-1804(a5) # 80028048 <bd_base>
    8000675c:	9d9d                	subw	a1,a1,a5
    8000675e:	47c1                	li	a5,16
    80006760:	00a79533          	sll	a0,a5,a0
    80006764:	02a5c533          	div	a0,a1,a0
}
    80006768:	2501                	sext.w	a0,a0
    8000676a:	6422                	ld	s0,8(sp)
    8000676c:	0141                	addi	sp,sp,16
    8000676e:	8082                	ret

0000000080006770 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    80006770:	1141                	addi	sp,sp,-16
    80006772:	e422                	sd	s0,8(sp)
    80006774:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    80006776:	47c1                	li	a5,16
    80006778:	00a797b3          	sll	a5,a5,a0
  return (char *) bd_base + n;
    8000677c:	02b787bb          	mulw	a5,a5,a1
}
    80006780:	00022517          	auipc	a0,0x22
    80006784:	8c853503          	ld	a0,-1848(a0) # 80028048 <bd_base>
    80006788:	953e                	add	a0,a0,a5
    8000678a:	6422                	ld	s0,8(sp)
    8000678c:	0141                	addi	sp,sp,16
    8000678e:	8082                	ret

0000000080006790 <bd_malloc>:

// allocate nbytes, but malloc won't return anything smaller than LEAF_SIZE
void *
bd_malloc(uint64 nbytes)
{
    80006790:	7159                	addi	sp,sp,-112
    80006792:	f486                	sd	ra,104(sp)
    80006794:	f0a2                	sd	s0,96(sp)
    80006796:	eca6                	sd	s1,88(sp)
    80006798:	e8ca                	sd	s2,80(sp)
    8000679a:	e4ce                	sd	s3,72(sp)
    8000679c:	e0d2                	sd	s4,64(sp)
    8000679e:	fc56                	sd	s5,56(sp)
    800067a0:	f85a                	sd	s6,48(sp)
    800067a2:	f45e                	sd	s7,40(sp)
    800067a4:	f062                	sd	s8,32(sp)
    800067a6:	ec66                	sd	s9,24(sp)
    800067a8:	e86a                	sd	s10,16(sp)
    800067aa:	e46e                	sd	s11,8(sp)
    800067ac:	1880                	addi	s0,sp,112
    800067ae:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    800067b0:	00022517          	auipc	a0,0x22
    800067b4:	85050513          	addi	a0,a0,-1968 # 80028000 <lock>
    800067b8:	ffffa097          	auipc	ra,0xffffa
    800067bc:	2f8080e7          	jalr	760(ra) # 80000ab0 <acquire>

  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    800067c0:	8526                	mv	a0,s1
    800067c2:	00000097          	auipc	ra,0x0
    800067c6:	f6a080e7          	jalr	-150(ra) # 8000672c <firstk>
  for (k = fk; k < nsizes; k++) {
    800067ca:	00022797          	auipc	a5,0x22
    800067ce:	88e7a783          	lw	a5,-1906(a5) # 80028058 <nsizes>
    800067d2:	02f55d63          	bge	a0,a5,8000680c <bd_malloc+0x7c>
    800067d6:	8c2a                	mv	s8,a0
    800067d8:	00551913          	slli	s2,a0,0x5
    800067dc:	84aa                	mv	s1,a0
    if(!lst_empty(&bd_sizes[k].free))
    800067de:	00022997          	auipc	s3,0x22
    800067e2:	87298993          	addi	s3,s3,-1934 # 80028050 <bd_sizes>
  for (k = fk; k < nsizes; k++) {
    800067e6:	00022a17          	auipc	s4,0x22
    800067ea:	872a0a13          	addi	s4,s4,-1934 # 80028058 <nsizes>
    if(!lst_empty(&bd_sizes[k].free))
    800067ee:	0009b503          	ld	a0,0(s3)
    800067f2:	954a                	add	a0,a0,s2
    800067f4:	00001097          	auipc	ra,0x1
    800067f8:	88e080e7          	jalr	-1906(ra) # 80007082 <lst_empty>
    800067fc:	c115                	beqz	a0,80006820 <bd_malloc+0x90>
  for (k = fk; k < nsizes; k++) {
    800067fe:	2485                	addiw	s1,s1,1
    80006800:	02090913          	addi	s2,s2,32
    80006804:	000a2783          	lw	a5,0(s4)
    80006808:	fef4c3e3          	blt	s1,a5,800067ee <bd_malloc+0x5e>
      break;
  }
  if(k >= nsizes) { // No free blocks?
    release(&lock);
    8000680c:	00021517          	auipc	a0,0x21
    80006810:	7f450513          	addi	a0,a0,2036 # 80028000 <lock>
    80006814:	ffffa097          	auipc	ra,0xffffa
    80006818:	36c080e7          	jalr	876(ra) # 80000b80 <release>
    return 0;
    8000681c:	4b01                	li	s6,0
    8000681e:	a0e1                	j	800068e6 <bd_malloc+0x156>
  if(k >= nsizes) { // No free blocks?
    80006820:	00022797          	auipc	a5,0x22
    80006824:	8387a783          	lw	a5,-1992(a5) # 80028058 <nsizes>
    80006828:	fef4d2e3          	bge	s1,a5,8000680c <bd_malloc+0x7c>
  }

  // Found a block; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    8000682c:	00549993          	slli	s3,s1,0x5
    80006830:	00022917          	auipc	s2,0x22
    80006834:	82090913          	addi	s2,s2,-2016 # 80028050 <bd_sizes>
    80006838:	00093503          	ld	a0,0(s2)
    8000683c:	954e                	add	a0,a0,s3
    8000683e:	00001097          	auipc	ra,0x1
    80006842:	870080e7          	jalr	-1936(ra) # 800070ae <lst_pop>
    80006846:	8b2a                	mv	s6,a0
  return n / BLK_SIZE(k);
    80006848:	00022597          	auipc	a1,0x22
    8000684c:	8005b583          	ld	a1,-2048(a1) # 80028048 <bd_base>
    80006850:	40b505bb          	subw	a1,a0,a1
    80006854:	47c1                	li	a5,16
    80006856:	009797b3          	sll	a5,a5,s1
    8000685a:	02f5c5b3          	div	a1,a1,a5
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    8000685e:	00093783          	ld	a5,0(s2)
    80006862:	97ce                	add	a5,a5,s3
    80006864:	2581                	sext.w	a1,a1
    80006866:	6b88                	ld	a0,16(a5)
    80006868:	00000097          	auipc	ra,0x0
    8000686c:	ca4080e7          	jalr	-860(ra) # 8000650c <bit_set>
  for(; k > fk; k--) {
    80006870:	069c5363          	bge	s8,s1,800068d6 <bd_malloc+0x146>
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80006874:	4bc1                	li	s7,16
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006876:	8dca                	mv	s11,s2
  int n = p - (char *) bd_base;
    80006878:	00021d17          	auipc	s10,0x21
    8000687c:	7d0d0d13          	addi	s10,s10,2000 # 80028048 <bd_base>
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80006880:	85a6                	mv	a1,s1
    80006882:	34fd                	addiw	s1,s1,-1
    80006884:	009b9ab3          	sll	s5,s7,s1
    80006888:	015b0cb3          	add	s9,s6,s5
    bit_set(bd_sizes[k].split, blk_index(k, p));
    8000688c:	000dba03          	ld	s4,0(s11)
  int n = p - (char *) bd_base;
    80006890:	000d3903          	ld	s2,0(s10)
  return n / BLK_SIZE(k);
    80006894:	412b093b          	subw	s2,s6,s2
    80006898:	00bb95b3          	sll	a1,s7,a1
    8000689c:	02b945b3          	div	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    800068a0:	013a07b3          	add	a5,s4,s3
    800068a4:	2581                	sext.w	a1,a1
    800068a6:	6f88                	ld	a0,24(a5)
    800068a8:	00000097          	auipc	ra,0x0
    800068ac:	c64080e7          	jalr	-924(ra) # 8000650c <bit_set>
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    800068b0:	1981                	addi	s3,s3,-32
    800068b2:	9a4e                	add	s4,s4,s3
  return n / BLK_SIZE(k);
    800068b4:	035945b3          	div	a1,s2,s5
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    800068b8:	2581                	sext.w	a1,a1
    800068ba:	010a3503          	ld	a0,16(s4)
    800068be:	00000097          	auipc	ra,0x0
    800068c2:	c4e080e7          	jalr	-946(ra) # 8000650c <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    800068c6:	85e6                	mv	a1,s9
    800068c8:	8552                	mv	a0,s4
    800068ca:	00001097          	auipc	ra,0x1
    800068ce:	81a080e7          	jalr	-2022(ra) # 800070e4 <lst_push>
  for(; k > fk; k--) {
    800068d2:	fb8497e3          	bne	s1,s8,80006880 <bd_malloc+0xf0>
  }
  release(&lock);
    800068d6:	00021517          	auipc	a0,0x21
    800068da:	72a50513          	addi	a0,a0,1834 # 80028000 <lock>
    800068de:	ffffa097          	auipc	ra,0xffffa
    800068e2:	2a2080e7          	jalr	674(ra) # 80000b80 <release>

  return p;
}
    800068e6:	855a                	mv	a0,s6
    800068e8:	70a6                	ld	ra,104(sp)
    800068ea:	7406                	ld	s0,96(sp)
    800068ec:	64e6                	ld	s1,88(sp)
    800068ee:	6946                	ld	s2,80(sp)
    800068f0:	69a6                	ld	s3,72(sp)
    800068f2:	6a06                	ld	s4,64(sp)
    800068f4:	7ae2                	ld	s5,56(sp)
    800068f6:	7b42                	ld	s6,48(sp)
    800068f8:	7ba2                	ld	s7,40(sp)
    800068fa:	7c02                	ld	s8,32(sp)
    800068fc:	6ce2                	ld	s9,24(sp)
    800068fe:	6d42                	ld	s10,16(sp)
    80006900:	6da2                	ld	s11,8(sp)
    80006902:	6165                	addi	sp,sp,112
    80006904:	8082                	ret

0000000080006906 <size>:

// Find the size of the block that p points to.
int
size(char *p) {
    80006906:	7139                	addi	sp,sp,-64
    80006908:	fc06                	sd	ra,56(sp)
    8000690a:	f822                	sd	s0,48(sp)
    8000690c:	f426                	sd	s1,40(sp)
    8000690e:	f04a                	sd	s2,32(sp)
    80006910:	ec4e                	sd	s3,24(sp)
    80006912:	e852                	sd	s4,16(sp)
    80006914:	e456                	sd	s5,8(sp)
    80006916:	e05a                	sd	s6,0(sp)
    80006918:	0080                	addi	s0,sp,64
  for (int k = 0; k < nsizes; k++) {
    8000691a:	00021a97          	auipc	s5,0x21
    8000691e:	73eaaa83          	lw	s5,1854(s5) # 80028058 <nsizes>
  return n / BLK_SIZE(k);
    80006922:	00021a17          	auipc	s4,0x21
    80006926:	726a3a03          	ld	s4,1830(s4) # 80028048 <bd_base>
    8000692a:	41450a3b          	subw	s4,a0,s4
    8000692e:	00021497          	auipc	s1,0x21
    80006932:	7224b483          	ld	s1,1826(s1) # 80028050 <bd_sizes>
    80006936:	03848493          	addi	s1,s1,56
  for (int k = 0; k < nsizes; k++) {
    8000693a:	4901                	li	s2,0
  return n / BLK_SIZE(k);
    8000693c:	4b41                	li	s6,16
  for (int k = 0; k < nsizes; k++) {
    8000693e:	03595363          	bge	s2,s5,80006964 <size+0x5e>
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006942:	0019099b          	addiw	s3,s2,1
  return n / BLK_SIZE(k);
    80006946:	013b15b3          	sll	a1,s6,s3
    8000694a:	02ba45b3          	div	a1,s4,a1
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    8000694e:	2581                	sext.w	a1,a1
    80006950:	6088                	ld	a0,0(s1)
    80006952:	00000097          	auipc	ra,0x0
    80006956:	b82080e7          	jalr	-1150(ra) # 800064d4 <bit_isset>
    8000695a:	02048493          	addi	s1,s1,32
    8000695e:	e501                	bnez	a0,80006966 <size+0x60>
  for (int k = 0; k < nsizes; k++) {
    80006960:	894e                	mv	s2,s3
    80006962:	bff1                	j	8000693e <size+0x38>
      return k;
    }
  }
  return 0;
    80006964:	4901                	li	s2,0
}
    80006966:	854a                	mv	a0,s2
    80006968:	70e2                	ld	ra,56(sp)
    8000696a:	7442                	ld	s0,48(sp)
    8000696c:	74a2                	ld	s1,40(sp)
    8000696e:	7902                	ld	s2,32(sp)
    80006970:	69e2                	ld	s3,24(sp)
    80006972:	6a42                	ld	s4,16(sp)
    80006974:	6aa2                	ld	s5,8(sp)
    80006976:	6b02                	ld	s6,0(sp)
    80006978:	6121                	addi	sp,sp,64
    8000697a:	8082                	ret

000000008000697c <bd_free>:

// Free memory pointed to by p, which was earlier allocated using
// bd_malloc.
void
bd_free(void *p) {
    8000697c:	7159                	addi	sp,sp,-112
    8000697e:	f486                	sd	ra,104(sp)
    80006980:	f0a2                	sd	s0,96(sp)
    80006982:	eca6                	sd	s1,88(sp)
    80006984:	e8ca                	sd	s2,80(sp)
    80006986:	e4ce                	sd	s3,72(sp)
    80006988:	e0d2                	sd	s4,64(sp)
    8000698a:	fc56                	sd	s5,56(sp)
    8000698c:	f85a                	sd	s6,48(sp)
    8000698e:	f45e                	sd	s7,40(sp)
    80006990:	f062                	sd	s8,32(sp)
    80006992:	ec66                	sd	s9,24(sp)
    80006994:	e86a                	sd	s10,16(sp)
    80006996:	e46e                	sd	s11,8(sp)
    80006998:	1880                	addi	s0,sp,112
    8000699a:	8aaa                	mv	s5,a0
  void *q;
  int k;

  acquire(&lock);
    8000699c:	00021517          	auipc	a0,0x21
    800069a0:	66450513          	addi	a0,a0,1636 # 80028000 <lock>
    800069a4:	ffffa097          	auipc	ra,0xffffa
    800069a8:	10c080e7          	jalr	268(ra) # 80000ab0 <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    800069ac:	8556                	mv	a0,s5
    800069ae:	00000097          	auipc	ra,0x0
    800069b2:	f58080e7          	jalr	-168(ra) # 80006906 <size>
    800069b6:	84aa                	mv	s1,a0
    800069b8:	00021797          	auipc	a5,0x21
    800069bc:	6a07a783          	lw	a5,1696(a5) # 80028058 <nsizes>
    800069c0:	37fd                	addiw	a5,a5,-1
    800069c2:	0af55d63          	bge	a0,a5,80006a7c <bd_free+0x100>
    800069c6:	00551a13          	slli	s4,a0,0x5
  int n = p - (char *) bd_base;
    800069ca:	00021c17          	auipc	s8,0x21
    800069ce:	67ec0c13          	addi	s8,s8,1662 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    800069d2:	4bc1                	li	s7,16
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    800069d4:	00021b17          	auipc	s6,0x21
    800069d8:	67cb0b13          	addi	s6,s6,1660 # 80028050 <bd_sizes>
  for (k = size(p); k < MAXSIZE; k++) {
    800069dc:	00021c97          	auipc	s9,0x21
    800069e0:	67cc8c93          	addi	s9,s9,1660 # 80028058 <nsizes>
    800069e4:	a82d                	j	80006a1e <bd_free+0xa2>
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    800069e6:	fff58d9b          	addiw	s11,a1,-1
    800069ea:	a881                	j	80006a3a <bd_free+0xbe>
    if(buddy % 2 == 0) {
      p = q;
    }
    // at size k+1, mark that the merged buddy pair isn't split
    // anymore
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800069ec:	020a0a13          	addi	s4,s4,32
    800069f0:	2485                	addiw	s1,s1,1
  int n = p - (char *) bd_base;
    800069f2:	000c3583          	ld	a1,0(s8)
  return n / BLK_SIZE(k);
    800069f6:	40ba85bb          	subw	a1,s5,a1
    800069fa:	009b97b3          	sll	a5,s7,s1
    800069fe:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    80006a02:	000b3783          	ld	a5,0(s6)
    80006a06:	97d2                	add	a5,a5,s4
    80006a08:	2581                	sext.w	a1,a1
    80006a0a:	6f88                	ld	a0,24(a5)
    80006a0c:	00000097          	auipc	ra,0x0
    80006a10:	b30080e7          	jalr	-1232(ra) # 8000653c <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    80006a14:	000ca783          	lw	a5,0(s9)
    80006a18:	37fd                	addiw	a5,a5,-1
    80006a1a:	06f4d163          	bge	s1,a5,80006a7c <bd_free+0x100>
  int n = p - (char *) bd_base;
    80006a1e:	000c3903          	ld	s2,0(s8)
  return n / BLK_SIZE(k);
    80006a22:	009b99b3          	sll	s3,s7,s1
    80006a26:	412a87bb          	subw	a5,s5,s2
    80006a2a:	0337c7b3          	div	a5,a5,s3
    80006a2e:	0007859b          	sext.w	a1,a5
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006a32:	8b85                	andi	a5,a5,1
    80006a34:	fbcd                	bnez	a5,800069e6 <bd_free+0x6a>
    80006a36:	00158d9b          	addiw	s11,a1,1
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    80006a3a:	000b3d03          	ld	s10,0(s6)
    80006a3e:	9d52                	add	s10,s10,s4
    80006a40:	010d3503          	ld	a0,16(s10)
    80006a44:	00000097          	auipc	ra,0x0
    80006a48:	af8080e7          	jalr	-1288(ra) # 8000653c <bit_clear>
    if (bit_isset(bd_sizes[k].alloc, buddy)) {  // is buddy allocated?
    80006a4c:	85ee                	mv	a1,s11
    80006a4e:	010d3503          	ld	a0,16(s10)
    80006a52:	00000097          	auipc	ra,0x0
    80006a56:	a82080e7          	jalr	-1406(ra) # 800064d4 <bit_isset>
    80006a5a:	e10d                	bnez	a0,80006a7c <bd_free+0x100>
  int n = bi * BLK_SIZE(k);
    80006a5c:	000d8d1b          	sext.w	s10,s11
  return (char *) bd_base + n;
    80006a60:	03b989bb          	mulw	s3,s3,s11
    80006a64:	994e                	add	s2,s2,s3
    lst_remove(q);    // remove buddy from free list
    80006a66:	854a                	mv	a0,s2
    80006a68:	00000097          	auipc	ra,0x0
    80006a6c:	630080e7          	jalr	1584(ra) # 80007098 <lst_remove>
    if(buddy % 2 == 0) {
    80006a70:	001d7d13          	andi	s10,s10,1
    80006a74:	f60d1ce3          	bnez	s10,800069ec <bd_free+0x70>
      p = q;
    80006a78:	8aca                	mv	s5,s2
    80006a7a:	bf8d                	j	800069ec <bd_free+0x70>
  }
  lst_push(&bd_sizes[k].free, p);
    80006a7c:	0496                	slli	s1,s1,0x5
    80006a7e:	85d6                	mv	a1,s5
    80006a80:	00021517          	auipc	a0,0x21
    80006a84:	5d053503          	ld	a0,1488(a0) # 80028050 <bd_sizes>
    80006a88:	9526                	add	a0,a0,s1
    80006a8a:	00000097          	auipc	ra,0x0
    80006a8e:	65a080e7          	jalr	1626(ra) # 800070e4 <lst_push>
  release(&lock);
    80006a92:	00021517          	auipc	a0,0x21
    80006a96:	56e50513          	addi	a0,a0,1390 # 80028000 <lock>
    80006a9a:	ffffa097          	auipc	ra,0xffffa
    80006a9e:	0e6080e7          	jalr	230(ra) # 80000b80 <release>
}
    80006aa2:	70a6                	ld	ra,104(sp)
    80006aa4:	7406                	ld	s0,96(sp)
    80006aa6:	64e6                	ld	s1,88(sp)
    80006aa8:	6946                	ld	s2,80(sp)
    80006aaa:	69a6                	ld	s3,72(sp)
    80006aac:	6a06                	ld	s4,64(sp)
    80006aae:	7ae2                	ld	s5,56(sp)
    80006ab0:	7b42                	ld	s6,48(sp)
    80006ab2:	7ba2                	ld	s7,40(sp)
    80006ab4:	7c02                	ld	s8,32(sp)
    80006ab6:	6ce2                	ld	s9,24(sp)
    80006ab8:	6d42                	ld	s10,16(sp)
    80006aba:	6da2                	ld	s11,8(sp)
    80006abc:	6165                	addi	sp,sp,112
    80006abe:	8082                	ret

0000000080006ac0 <blk_index_next>:

// Compute the first block at size k that doesn't contain p
int
blk_index_next(int k, char *p) {
    80006ac0:	1141                	addi	sp,sp,-16
    80006ac2:	e422                	sd	s0,8(sp)
    80006ac4:	0800                	addi	s0,sp,16
  int n = (p - (char *) bd_base) / BLK_SIZE(k);
    80006ac6:	00021797          	auipc	a5,0x21
    80006aca:	5827b783          	ld	a5,1410(a5) # 80028048 <bd_base>
    80006ace:	8d9d                	sub	a1,a1,a5
    80006ad0:	47c1                	li	a5,16
    80006ad2:	00a797b3          	sll	a5,a5,a0
    80006ad6:	02f5c533          	div	a0,a1,a5
    80006ada:	2501                	sext.w	a0,a0
  if((p - (char*) bd_base) % BLK_SIZE(k) != 0)
    80006adc:	02f5e5b3          	rem	a1,a1,a5
    80006ae0:	c191                	beqz	a1,80006ae4 <blk_index_next+0x24>
      n++;
    80006ae2:	2505                	addiw	a0,a0,1
  return n ;
}
    80006ae4:	6422                	ld	s0,8(sp)
    80006ae6:	0141                	addi	sp,sp,16
    80006ae8:	8082                	ret

0000000080006aea <log2>:

int
log2(uint64 n) {
    80006aea:	1141                	addi	sp,sp,-16
    80006aec:	e422                	sd	s0,8(sp)
    80006aee:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80006af0:	4705                	li	a4,1
    80006af2:	00a77b63          	bgeu	a4,a0,80006b08 <log2+0x1e>
    80006af6:	87aa                	mv	a5,a0
  int k = 0;
    80006af8:	4501                	li	a0,0
    k++;
    80006afa:	2505                	addiw	a0,a0,1
    n = n >> 1;
    80006afc:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    80006afe:	fef76ee3          	bltu	a4,a5,80006afa <log2+0x10>
  }
  return k;
}
    80006b02:	6422                	ld	s0,8(sp)
    80006b04:	0141                	addi	sp,sp,16
    80006b06:	8082                	ret
  int k = 0;
    80006b08:	4501                	li	a0,0
    80006b0a:	bfe5                	j	80006b02 <log2+0x18>

0000000080006b0c <bd_mark>:

// Mark memory from [start, stop), starting at size 0, as allocated. 
void
bd_mark(void *start, void *stop)
{
    80006b0c:	711d                	addi	sp,sp,-96
    80006b0e:	ec86                	sd	ra,88(sp)
    80006b10:	e8a2                	sd	s0,80(sp)
    80006b12:	e4a6                	sd	s1,72(sp)
    80006b14:	e0ca                	sd	s2,64(sp)
    80006b16:	fc4e                	sd	s3,56(sp)
    80006b18:	f852                	sd	s4,48(sp)
    80006b1a:	f456                	sd	s5,40(sp)
    80006b1c:	f05a                	sd	s6,32(sp)
    80006b1e:	ec5e                	sd	s7,24(sp)
    80006b20:	e862                	sd	s8,16(sp)
    80006b22:	e466                	sd	s9,8(sp)
    80006b24:	e06a                	sd	s10,0(sp)
    80006b26:	1080                	addi	s0,sp,96
  int bi, bj;

  if (((uint64) start % LEAF_SIZE != 0) || ((uint64) stop % LEAF_SIZE != 0))
    80006b28:	00b56933          	or	s2,a0,a1
    80006b2c:	00f97913          	andi	s2,s2,15
    80006b30:	04091263          	bnez	s2,80006b74 <bd_mark+0x68>
    80006b34:	8b2a                	mv	s6,a0
    80006b36:	8bae                	mv	s7,a1
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    80006b38:	00021c17          	auipc	s8,0x21
    80006b3c:	520c2c03          	lw	s8,1312(s8) # 80028058 <nsizes>
    80006b40:	4981                	li	s3,0
  int n = p - (char *) bd_base;
    80006b42:	00021d17          	auipc	s10,0x21
    80006b46:	506d0d13          	addi	s10,s10,1286 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006b4a:	4cc1                	li	s9,16
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for(; bi < bj; bi++) {
      if(k > 0) {
        // if a block is allocated at size k, mark it as split too.
        bit_set(bd_sizes[k].split, bi);
    80006b4c:	00021a97          	auipc	s5,0x21
    80006b50:	504a8a93          	addi	s5,s5,1284 # 80028050 <bd_sizes>
  for (int k = 0; k < nsizes; k++) {
    80006b54:	07804563          	bgtz	s8,80006bbe <bd_mark+0xb2>
      }
      bit_set(bd_sizes[k].alloc, bi);
    }
  }
}
    80006b58:	60e6                	ld	ra,88(sp)
    80006b5a:	6446                	ld	s0,80(sp)
    80006b5c:	64a6                	ld	s1,72(sp)
    80006b5e:	6906                	ld	s2,64(sp)
    80006b60:	79e2                	ld	s3,56(sp)
    80006b62:	7a42                	ld	s4,48(sp)
    80006b64:	7aa2                	ld	s5,40(sp)
    80006b66:	7b02                	ld	s6,32(sp)
    80006b68:	6be2                	ld	s7,24(sp)
    80006b6a:	6c42                	ld	s8,16(sp)
    80006b6c:	6ca2                	ld	s9,8(sp)
    80006b6e:	6d02                	ld	s10,0(sp)
    80006b70:	6125                	addi	sp,sp,96
    80006b72:	8082                	ret
    panic("bd_mark");
    80006b74:	00002517          	auipc	a0,0x2
    80006b78:	0bc50513          	addi	a0,a0,188 # 80008c30 <userret+0xba0>
    80006b7c:	ffffa097          	auipc	ra,0xffffa
    80006b80:	9de080e7          	jalr	-1570(ra) # 8000055a <panic>
      bit_set(bd_sizes[k].alloc, bi);
    80006b84:	000ab783          	ld	a5,0(s5)
    80006b88:	97ca                	add	a5,a5,s2
    80006b8a:	85a6                	mv	a1,s1
    80006b8c:	6b88                	ld	a0,16(a5)
    80006b8e:	00000097          	auipc	ra,0x0
    80006b92:	97e080e7          	jalr	-1666(ra) # 8000650c <bit_set>
    for(; bi < bj; bi++) {
    80006b96:	2485                	addiw	s1,s1,1
    80006b98:	009a0e63          	beq	s4,s1,80006bb4 <bd_mark+0xa8>
      if(k > 0) {
    80006b9c:	ff3054e3          	blez	s3,80006b84 <bd_mark+0x78>
        bit_set(bd_sizes[k].split, bi);
    80006ba0:	000ab783          	ld	a5,0(s5)
    80006ba4:	97ca                	add	a5,a5,s2
    80006ba6:	85a6                	mv	a1,s1
    80006ba8:	6f88                	ld	a0,24(a5)
    80006baa:	00000097          	auipc	ra,0x0
    80006bae:	962080e7          	jalr	-1694(ra) # 8000650c <bit_set>
    80006bb2:	bfc9                	j	80006b84 <bd_mark+0x78>
  for (int k = 0; k < nsizes; k++) {
    80006bb4:	2985                	addiw	s3,s3,1
    80006bb6:	02090913          	addi	s2,s2,32
    80006bba:	f9898fe3          	beq	s3,s8,80006b58 <bd_mark+0x4c>
  int n = p - (char *) bd_base;
    80006bbe:	000d3483          	ld	s1,0(s10)
  return n / BLK_SIZE(k);
    80006bc2:	409b04bb          	subw	s1,s6,s1
    80006bc6:	013c97b3          	sll	a5,s9,s3
    80006bca:	02f4c4b3          	div	s1,s1,a5
    80006bce:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80006bd0:	85de                	mv	a1,s7
    80006bd2:	854e                	mv	a0,s3
    80006bd4:	00000097          	auipc	ra,0x0
    80006bd8:	eec080e7          	jalr	-276(ra) # 80006ac0 <blk_index_next>
    80006bdc:	8a2a                	mv	s4,a0
    for(; bi < bj; bi++) {
    80006bde:	faa4cfe3          	blt	s1,a0,80006b9c <bd_mark+0x90>
    80006be2:	bfc9                	j	80006bb4 <bd_mark+0xa8>

0000000080006be4 <bd_initfree_pair>:

// If a block is marked as allocated and the buddy is free, put the
// buddy on the free list at size k.
int
bd_initfree_pair(int k, int bi) {
    80006be4:	7139                	addi	sp,sp,-64
    80006be6:	fc06                	sd	ra,56(sp)
    80006be8:	f822                	sd	s0,48(sp)
    80006bea:	f426                	sd	s1,40(sp)
    80006bec:	f04a                	sd	s2,32(sp)
    80006bee:	ec4e                	sd	s3,24(sp)
    80006bf0:	e852                	sd	s4,16(sp)
    80006bf2:	e456                	sd	s5,8(sp)
    80006bf4:	e05a                	sd	s6,0(sp)
    80006bf6:	0080                	addi	s0,sp,64
    80006bf8:	89aa                	mv	s3,a0
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006bfa:	00058a9b          	sext.w	s5,a1
    80006bfe:	0015f793          	andi	a5,a1,1
    80006c02:	ebad                	bnez	a5,80006c74 <bd_initfree_pair+0x90>
    80006c04:	00158a1b          	addiw	s4,a1,1
  int free = 0;
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006c08:	00599493          	slli	s1,s3,0x5
    80006c0c:	00021797          	auipc	a5,0x21
    80006c10:	4447b783          	ld	a5,1092(a5) # 80028050 <bd_sizes>
    80006c14:	94be                	add	s1,s1,a5
    80006c16:	0104bb03          	ld	s6,16(s1)
    80006c1a:	855a                	mv	a0,s6
    80006c1c:	00000097          	auipc	ra,0x0
    80006c20:	8b8080e7          	jalr	-1864(ra) # 800064d4 <bit_isset>
    80006c24:	892a                	mv	s2,a0
    80006c26:	85d2                	mv	a1,s4
    80006c28:	855a                	mv	a0,s6
    80006c2a:	00000097          	auipc	ra,0x0
    80006c2e:	8aa080e7          	jalr	-1878(ra) # 800064d4 <bit_isset>
  int free = 0;
    80006c32:	4b01                	li	s6,0
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006c34:	02a90563          	beq	s2,a0,80006c5e <bd_initfree_pair+0x7a>
    // one of the pair is free
    free = BLK_SIZE(k);
    80006c38:	45c1                	li	a1,16
    80006c3a:	013599b3          	sll	s3,a1,s3
    80006c3e:	00098b1b          	sext.w	s6,s3
    if(bit_isset(bd_sizes[k].alloc, bi))
    80006c42:	02090c63          	beqz	s2,80006c7a <bd_initfree_pair+0x96>
  return (char *) bd_base + n;
    80006c46:	034989bb          	mulw	s3,s3,s4
      lst_push(&bd_sizes[k].free, addr(k, buddy));   // put buddy on free list
    80006c4a:	00021597          	auipc	a1,0x21
    80006c4e:	3fe5b583          	ld	a1,1022(a1) # 80028048 <bd_base>
    80006c52:	95ce                	add	a1,a1,s3
    80006c54:	8526                	mv	a0,s1
    80006c56:	00000097          	auipc	ra,0x0
    80006c5a:	48e080e7          	jalr	1166(ra) # 800070e4 <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
  }
  return free;
}
    80006c5e:	855a                	mv	a0,s6
    80006c60:	70e2                	ld	ra,56(sp)
    80006c62:	7442                	ld	s0,48(sp)
    80006c64:	74a2                	ld	s1,40(sp)
    80006c66:	7902                	ld	s2,32(sp)
    80006c68:	69e2                	ld	s3,24(sp)
    80006c6a:	6a42                	ld	s4,16(sp)
    80006c6c:	6aa2                	ld	s5,8(sp)
    80006c6e:	6b02                	ld	s6,0(sp)
    80006c70:	6121                	addi	sp,sp,64
    80006c72:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006c74:	fff58a1b          	addiw	s4,a1,-1
    80006c78:	bf41                	j	80006c08 <bd_initfree_pair+0x24>
  return (char *) bd_base + n;
    80006c7a:	035989bb          	mulw	s3,s3,s5
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
    80006c7e:	00021597          	auipc	a1,0x21
    80006c82:	3ca5b583          	ld	a1,970(a1) # 80028048 <bd_base>
    80006c86:	95ce                	add	a1,a1,s3
    80006c88:	8526                	mv	a0,s1
    80006c8a:	00000097          	auipc	ra,0x0
    80006c8e:	45a080e7          	jalr	1114(ra) # 800070e4 <lst_push>
    80006c92:	b7f1                	j	80006c5e <bd_initfree_pair+0x7a>

0000000080006c94 <bd_initfree>:
  
// Initialize the free lists for each size k.  For each size k, there
// are only two pairs that may have a buddy that should be on free list:
// bd_left and bd_right.
int
bd_initfree(void *bd_left, void *bd_right) {
    80006c94:	711d                	addi	sp,sp,-96
    80006c96:	ec86                	sd	ra,88(sp)
    80006c98:	e8a2                	sd	s0,80(sp)
    80006c9a:	e4a6                	sd	s1,72(sp)
    80006c9c:	e0ca                	sd	s2,64(sp)
    80006c9e:	fc4e                	sd	s3,56(sp)
    80006ca0:	f852                	sd	s4,48(sp)
    80006ca2:	f456                	sd	s5,40(sp)
    80006ca4:	f05a                	sd	s6,32(sp)
    80006ca6:	ec5e                	sd	s7,24(sp)
    80006ca8:	e862                	sd	s8,16(sp)
    80006caa:	e466                	sd	s9,8(sp)
    80006cac:	e06a                	sd	s10,0(sp)
    80006cae:	1080                	addi	s0,sp,96
  int free = 0;

  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006cb0:	00021717          	auipc	a4,0x21
    80006cb4:	3a872703          	lw	a4,936(a4) # 80028058 <nsizes>
    80006cb8:	4785                	li	a5,1
    80006cba:	06e7db63          	bge	a5,a4,80006d30 <bd_initfree+0x9c>
    80006cbe:	8aaa                	mv	s5,a0
    80006cc0:	8b2e                	mv	s6,a1
    80006cc2:	4901                	li	s2,0
  int free = 0;
    80006cc4:	4a01                	li	s4,0
  int n = p - (char *) bd_base;
    80006cc6:	00021c97          	auipc	s9,0x21
    80006cca:	382c8c93          	addi	s9,s9,898 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006cce:	4c41                	li	s8,16
  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006cd0:	00021b97          	auipc	s7,0x21
    80006cd4:	388b8b93          	addi	s7,s7,904 # 80028058 <nsizes>
    80006cd8:	a039                	j	80006ce6 <bd_initfree+0x52>
    80006cda:	2905                	addiw	s2,s2,1
    80006cdc:	000ba783          	lw	a5,0(s7)
    80006ce0:	37fd                	addiw	a5,a5,-1
    80006ce2:	04f95863          	bge	s2,a5,80006d32 <bd_initfree+0x9e>
    int left = blk_index_next(k, bd_left);
    80006ce6:	85d6                	mv	a1,s5
    80006ce8:	854a                	mv	a0,s2
    80006cea:	00000097          	auipc	ra,0x0
    80006cee:	dd6080e7          	jalr	-554(ra) # 80006ac0 <blk_index_next>
    80006cf2:	89aa                	mv	s3,a0
  int n = p - (char *) bd_base;
    80006cf4:	000cb483          	ld	s1,0(s9)
  return n / BLK_SIZE(k);
    80006cf8:	409b04bb          	subw	s1,s6,s1
    80006cfc:	012c17b3          	sll	a5,s8,s2
    80006d00:	02f4c4b3          	div	s1,s1,a5
    80006d04:	2481                	sext.w	s1,s1
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left);
    80006d06:	85aa                	mv	a1,a0
    80006d08:	854a                	mv	a0,s2
    80006d0a:	00000097          	auipc	ra,0x0
    80006d0e:	eda080e7          	jalr	-294(ra) # 80006be4 <bd_initfree_pair>
    80006d12:	01450d3b          	addw	s10,a0,s4
    80006d16:	000d0a1b          	sext.w	s4,s10
    if(right <= left)
    80006d1a:	fc99d0e3          	bge	s3,s1,80006cda <bd_initfree+0x46>
      continue;
    free += bd_initfree_pair(k, right);
    80006d1e:	85a6                	mv	a1,s1
    80006d20:	854a                	mv	a0,s2
    80006d22:	00000097          	auipc	ra,0x0
    80006d26:	ec2080e7          	jalr	-318(ra) # 80006be4 <bd_initfree_pair>
    80006d2a:	00ad0a3b          	addw	s4,s10,a0
    80006d2e:	b775                	j	80006cda <bd_initfree+0x46>
  int free = 0;
    80006d30:	4a01                	li	s4,0
  }
  return free;
}
    80006d32:	8552                	mv	a0,s4
    80006d34:	60e6                	ld	ra,88(sp)
    80006d36:	6446                	ld	s0,80(sp)
    80006d38:	64a6                	ld	s1,72(sp)
    80006d3a:	6906                	ld	s2,64(sp)
    80006d3c:	79e2                	ld	s3,56(sp)
    80006d3e:	7a42                	ld	s4,48(sp)
    80006d40:	7aa2                	ld	s5,40(sp)
    80006d42:	7b02                	ld	s6,32(sp)
    80006d44:	6be2                	ld	s7,24(sp)
    80006d46:	6c42                	ld	s8,16(sp)
    80006d48:	6ca2                	ld	s9,8(sp)
    80006d4a:	6d02                	ld	s10,0(sp)
    80006d4c:	6125                	addi	sp,sp,96
    80006d4e:	8082                	ret

0000000080006d50 <bd_mark_data_structures>:

// Mark the range [bd_base,p) as allocated
int
bd_mark_data_structures(char *p) {
    80006d50:	7179                	addi	sp,sp,-48
    80006d52:	f406                	sd	ra,40(sp)
    80006d54:	f022                	sd	s0,32(sp)
    80006d56:	ec26                	sd	s1,24(sp)
    80006d58:	e84a                	sd	s2,16(sp)
    80006d5a:	e44e                	sd	s3,8(sp)
    80006d5c:	1800                	addi	s0,sp,48
    80006d5e:	892a                	mv	s2,a0
  int meta = p - (char*)bd_base;
    80006d60:	00021997          	auipc	s3,0x21
    80006d64:	2e898993          	addi	s3,s3,744 # 80028048 <bd_base>
    80006d68:	0009b483          	ld	s1,0(s3)
    80006d6c:	409504bb          	subw	s1,a0,s1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta, BLK_SIZE(MAXSIZE));
    80006d70:	00021797          	auipc	a5,0x21
    80006d74:	2e87a783          	lw	a5,744(a5) # 80028058 <nsizes>
    80006d78:	37fd                	addiw	a5,a5,-1
    80006d7a:	4641                	li	a2,16
    80006d7c:	00f61633          	sll	a2,a2,a5
    80006d80:	85a6                	mv	a1,s1
    80006d82:	00002517          	auipc	a0,0x2
    80006d86:	eb650513          	addi	a0,a0,-330 # 80008c38 <userret+0xba8>
    80006d8a:	ffffa097          	auipc	ra,0xffffa
    80006d8e:	82a080e7          	jalr	-2006(ra) # 800005b4 <printf>
  bd_mark(bd_base, p);
    80006d92:	85ca                	mv	a1,s2
    80006d94:	0009b503          	ld	a0,0(s3)
    80006d98:	00000097          	auipc	ra,0x0
    80006d9c:	d74080e7          	jalr	-652(ra) # 80006b0c <bd_mark>
  return meta;
}
    80006da0:	8526                	mv	a0,s1
    80006da2:	70a2                	ld	ra,40(sp)
    80006da4:	7402                	ld	s0,32(sp)
    80006da6:	64e2                	ld	s1,24(sp)
    80006da8:	6942                	ld	s2,16(sp)
    80006daa:	69a2                	ld	s3,8(sp)
    80006dac:	6145                	addi	sp,sp,48
    80006dae:	8082                	ret

0000000080006db0 <bd_mark_unavailable>:

// Mark the range [end, HEAPSIZE) as allocated
int
bd_mark_unavailable(void *end, void *left) {
    80006db0:	1101                	addi	sp,sp,-32
    80006db2:	ec06                	sd	ra,24(sp)
    80006db4:	e822                	sd	s0,16(sp)
    80006db6:	e426                	sd	s1,8(sp)
    80006db8:	1000                	addi	s0,sp,32
  int unavailable = BLK_SIZE(MAXSIZE)-(end-bd_base);
    80006dba:	00021497          	auipc	s1,0x21
    80006dbe:	29e4a483          	lw	s1,670(s1) # 80028058 <nsizes>
    80006dc2:	fff4879b          	addiw	a5,s1,-1
    80006dc6:	44c1                	li	s1,16
    80006dc8:	00f494b3          	sll	s1,s1,a5
    80006dcc:	00021797          	auipc	a5,0x21
    80006dd0:	27c7b783          	ld	a5,636(a5) # 80028048 <bd_base>
    80006dd4:	8d1d                	sub	a0,a0,a5
    80006dd6:	40a4853b          	subw	a0,s1,a0
    80006dda:	0005049b          	sext.w	s1,a0
  if(unavailable > 0)
    80006dde:	00905a63          	blez	s1,80006df2 <bd_mark_unavailable+0x42>
    unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    80006de2:	357d                	addiw	a0,a0,-1
    80006de4:	41f5549b          	sraiw	s1,a0,0x1f
    80006de8:	01c4d49b          	srliw	s1,s1,0x1c
    80006dec:	9ca9                	addw	s1,s1,a0
    80006dee:	98c1                	andi	s1,s1,-16
    80006df0:	24c1                	addiw	s1,s1,16
  printf("bd: 0x%x bytes unavailable\n", unavailable);
    80006df2:	85a6                	mv	a1,s1
    80006df4:	00002517          	auipc	a0,0x2
    80006df8:	e7c50513          	addi	a0,a0,-388 # 80008c70 <userret+0xbe0>
    80006dfc:	ffff9097          	auipc	ra,0xffff9
    80006e00:	7b8080e7          	jalr	1976(ra) # 800005b4 <printf>

  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80006e04:	00021717          	auipc	a4,0x21
    80006e08:	24473703          	ld	a4,580(a4) # 80028048 <bd_base>
    80006e0c:	00021597          	auipc	a1,0x21
    80006e10:	24c5a583          	lw	a1,588(a1) # 80028058 <nsizes>
    80006e14:	fff5879b          	addiw	a5,a1,-1
    80006e18:	45c1                	li	a1,16
    80006e1a:	00f595b3          	sll	a1,a1,a5
    80006e1e:	40958533          	sub	a0,a1,s1
  bd_mark(bd_end, bd_base+BLK_SIZE(MAXSIZE));
    80006e22:	95ba                	add	a1,a1,a4
    80006e24:	953a                	add	a0,a0,a4
    80006e26:	00000097          	auipc	ra,0x0
    80006e2a:	ce6080e7          	jalr	-794(ra) # 80006b0c <bd_mark>
  return unavailable;
}
    80006e2e:	8526                	mv	a0,s1
    80006e30:	60e2                	ld	ra,24(sp)
    80006e32:	6442                	ld	s0,16(sp)
    80006e34:	64a2                	ld	s1,8(sp)
    80006e36:	6105                	addi	sp,sp,32
    80006e38:	8082                	ret

0000000080006e3a <bd_init>:

// Initialize the buddy allocator: it manages memory from [base, end).
void
bd_init(void *base, void *end) {
    80006e3a:	715d                	addi	sp,sp,-80
    80006e3c:	e486                	sd	ra,72(sp)
    80006e3e:	e0a2                	sd	s0,64(sp)
    80006e40:	fc26                	sd	s1,56(sp)
    80006e42:	f84a                	sd	s2,48(sp)
    80006e44:	f44e                	sd	s3,40(sp)
    80006e46:	f052                	sd	s4,32(sp)
    80006e48:	ec56                	sd	s5,24(sp)
    80006e4a:	e85a                	sd	s6,16(sp)
    80006e4c:	e45e                	sd	s7,8(sp)
    80006e4e:	e062                	sd	s8,0(sp)
    80006e50:	0880                	addi	s0,sp,80
    80006e52:	8c2e                	mv	s8,a1
  char *p = (char *) ROUNDUP((uint64)base, LEAF_SIZE);
    80006e54:	fff50493          	addi	s1,a0,-1
    80006e58:	98c1                	andi	s1,s1,-16
    80006e5a:	04c1                	addi	s1,s1,16
  int sz;

  initlock(&lock, "buddy");
    80006e5c:	00002597          	auipc	a1,0x2
    80006e60:	e3458593          	addi	a1,a1,-460 # 80008c90 <userret+0xc00>
    80006e64:	00021517          	auipc	a0,0x21
    80006e68:	19c50513          	addi	a0,a0,412 # 80028000 <lock>
    80006e6c:	ffffa097          	auipc	ra,0xffffa
    80006e70:	b70080e7          	jalr	-1168(ra) # 800009dc <initlock>
  bd_base = (void *) p;
    80006e74:	00021797          	auipc	a5,0x21
    80006e78:	1c97ba23          	sd	s1,468(a5) # 80028048 <bd_base>

  // compute the number of sizes we need to manage [base, end)
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80006e7c:	409c0933          	sub	s2,s8,s1
    80006e80:	43f95513          	srai	a0,s2,0x3f
    80006e84:	893d                	andi	a0,a0,15
    80006e86:	954a                	add	a0,a0,s2
    80006e88:	8511                	srai	a0,a0,0x4
    80006e8a:	00000097          	auipc	ra,0x0
    80006e8e:	c60080e7          	jalr	-928(ra) # 80006aea <log2>
  if((char*)end-p > BLK_SIZE(MAXSIZE)) {
    80006e92:	47c1                	li	a5,16
    80006e94:	00a797b3          	sll	a5,a5,a0
    80006e98:	1b27c663          	blt	a5,s2,80007044 <bd_init+0x20a>
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80006e9c:	2505                	addiw	a0,a0,1
    80006e9e:	00021797          	auipc	a5,0x21
    80006ea2:	1aa7ad23          	sw	a0,442(a5) # 80028058 <nsizes>
    nsizes++;  // round up to the next power of 2
  }

  printf("bd: memory sz is %d bytes; allocate an size array of length %d\n",
    80006ea6:	00021997          	auipc	s3,0x21
    80006eaa:	1b298993          	addi	s3,s3,434 # 80028058 <nsizes>
    80006eae:	0009a603          	lw	a2,0(s3)
    80006eb2:	85ca                	mv	a1,s2
    80006eb4:	00002517          	auipc	a0,0x2
    80006eb8:	de450513          	addi	a0,a0,-540 # 80008c98 <userret+0xc08>
    80006ebc:	ffff9097          	auipc	ra,0xffff9
    80006ec0:	6f8080e7          	jalr	1784(ra) # 800005b4 <printf>
         (char*) end - p, nsizes);

  // allocate bd_sizes array
  bd_sizes = (Sz_info *) p;
    80006ec4:	00021797          	auipc	a5,0x21
    80006ec8:	1897b623          	sd	s1,396(a5) # 80028050 <bd_sizes>
  p += sizeof(Sz_info) * nsizes;
    80006ecc:	0009a603          	lw	a2,0(s3)
    80006ed0:	00561913          	slli	s2,a2,0x5
    80006ed4:	9926                	add	s2,s2,s1
  memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);
    80006ed6:	0056161b          	slliw	a2,a2,0x5
    80006eda:	4581                	li	a1,0
    80006edc:	8526                	mv	a0,s1
    80006ede:	ffffa097          	auipc	ra,0xffffa
    80006ee2:	ea0080e7          	jalr	-352(ra) # 80000d7e <memset>

  // initialize free list and allocate the alloc array for each size k
  for (int k = 0; k < nsizes; k++) {
    80006ee6:	0009a783          	lw	a5,0(s3)
    80006eea:	06f05a63          	blez	a5,80006f5e <bd_init+0x124>
    80006eee:	4981                	li	s3,0
    lst_init(&bd_sizes[k].free);
    80006ef0:	00021a97          	auipc	s5,0x21
    80006ef4:	160a8a93          	addi	s5,s5,352 # 80028050 <bd_sizes>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    80006ef8:	00021a17          	auipc	s4,0x21
    80006efc:	160a0a13          	addi	s4,s4,352 # 80028058 <nsizes>
    80006f00:	4b05                	li	s6,1
    lst_init(&bd_sizes[k].free);
    80006f02:	00599b93          	slli	s7,s3,0x5
    80006f06:	000ab503          	ld	a0,0(s5)
    80006f0a:	955e                	add	a0,a0,s7
    80006f0c:	00000097          	auipc	ra,0x0
    80006f10:	166080e7          	jalr	358(ra) # 80007072 <lst_init>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    80006f14:	000a2483          	lw	s1,0(s4)
    80006f18:	34fd                	addiw	s1,s1,-1
    80006f1a:	413484bb          	subw	s1,s1,s3
    80006f1e:	009b14bb          	sllw	s1,s6,s1
    80006f22:	fff4879b          	addiw	a5,s1,-1
    80006f26:	41f7d49b          	sraiw	s1,a5,0x1f
    80006f2a:	01d4d49b          	srliw	s1,s1,0x1d
    80006f2e:	9cbd                	addw	s1,s1,a5
    80006f30:	98e1                	andi	s1,s1,-8
    80006f32:	24a1                	addiw	s1,s1,8
    bd_sizes[k].alloc = p;
    80006f34:	000ab783          	ld	a5,0(s5)
    80006f38:	9bbe                	add	s7,s7,a5
    80006f3a:	012bb823          	sd	s2,16(s7)
    memset(bd_sizes[k].alloc, 0, sz);
    80006f3e:	848d                	srai	s1,s1,0x3
    80006f40:	8626                	mv	a2,s1
    80006f42:	4581                	li	a1,0
    80006f44:	854a                	mv	a0,s2
    80006f46:	ffffa097          	auipc	ra,0xffffa
    80006f4a:	e38080e7          	jalr	-456(ra) # 80000d7e <memset>
    p += sz;
    80006f4e:	9926                	add	s2,s2,s1
  for (int k = 0; k < nsizes; k++) {
    80006f50:	0985                	addi	s3,s3,1
    80006f52:	000a2703          	lw	a4,0(s4)
    80006f56:	0009879b          	sext.w	a5,s3
    80006f5a:	fae7c4e3          	blt	a5,a4,80006f02 <bd_init+0xc8>
  }

  // allocate the split array for each size k, except for k = 0, since
  // we will not split blocks of size k = 0, the smallest size.
  for (int k = 1; k < nsizes; k++) {
    80006f5e:	00021797          	auipc	a5,0x21
    80006f62:	0fa7a783          	lw	a5,250(a5) # 80028058 <nsizes>
    80006f66:	4705                	li	a4,1
    80006f68:	06f75163          	bge	a4,a5,80006fca <bd_init+0x190>
    80006f6c:	02000a13          	li	s4,32
    80006f70:	4985                	li	s3,1
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    80006f72:	4b85                	li	s7,1
    bd_sizes[k].split = p;
    80006f74:	00021b17          	auipc	s6,0x21
    80006f78:	0dcb0b13          	addi	s6,s6,220 # 80028050 <bd_sizes>
  for (int k = 1; k < nsizes; k++) {
    80006f7c:	00021a97          	auipc	s5,0x21
    80006f80:	0dca8a93          	addi	s5,s5,220 # 80028058 <nsizes>
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    80006f84:	37fd                	addiw	a5,a5,-1
    80006f86:	413787bb          	subw	a5,a5,s3
    80006f8a:	00fb94bb          	sllw	s1,s7,a5
    80006f8e:	fff4879b          	addiw	a5,s1,-1
    80006f92:	41f7d49b          	sraiw	s1,a5,0x1f
    80006f96:	01d4d49b          	srliw	s1,s1,0x1d
    80006f9a:	9cbd                	addw	s1,s1,a5
    80006f9c:	98e1                	andi	s1,s1,-8
    80006f9e:	24a1                	addiw	s1,s1,8
    bd_sizes[k].split = p;
    80006fa0:	000b3783          	ld	a5,0(s6)
    80006fa4:	97d2                	add	a5,a5,s4
    80006fa6:	0127bc23          	sd	s2,24(a5)
    memset(bd_sizes[k].split, 0, sz);
    80006faa:	848d                	srai	s1,s1,0x3
    80006fac:	8626                	mv	a2,s1
    80006fae:	4581                	li	a1,0
    80006fb0:	854a                	mv	a0,s2
    80006fb2:	ffffa097          	auipc	ra,0xffffa
    80006fb6:	dcc080e7          	jalr	-564(ra) # 80000d7e <memset>
    p += sz;
    80006fba:	9926                	add	s2,s2,s1
  for (int k = 1; k < nsizes; k++) {
    80006fbc:	2985                	addiw	s3,s3,1
    80006fbe:	000aa783          	lw	a5,0(s5)
    80006fc2:	020a0a13          	addi	s4,s4,32
    80006fc6:	faf9cfe3          	blt	s3,a5,80006f84 <bd_init+0x14a>
  }
  p = (char *) ROUNDUP((uint64) p, LEAF_SIZE);
    80006fca:	197d                	addi	s2,s2,-1
    80006fcc:	ff097913          	andi	s2,s2,-16
    80006fd0:	0941                	addi	s2,s2,16

  // done allocating; mark the memory range [base, p) as allocated, so
  // that buddy will not hand out that memory.
  int meta = bd_mark_data_structures(p);
    80006fd2:	854a                	mv	a0,s2
    80006fd4:	00000097          	auipc	ra,0x0
    80006fd8:	d7c080e7          	jalr	-644(ra) # 80006d50 <bd_mark_data_structures>
    80006fdc:	8a2a                	mv	s4,a0
  
  // mark the unavailable memory range [end, HEAP_SIZE) as allocated,
  // so that buddy will not hand out that memory.
  int unavailable = bd_mark_unavailable(end, p);
    80006fde:	85ca                	mv	a1,s2
    80006fe0:	8562                	mv	a0,s8
    80006fe2:	00000097          	auipc	ra,0x0
    80006fe6:	dce080e7          	jalr	-562(ra) # 80006db0 <bd_mark_unavailable>
    80006fea:	89aa                	mv	s3,a0
  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80006fec:	00021a97          	auipc	s5,0x21
    80006ff0:	06ca8a93          	addi	s5,s5,108 # 80028058 <nsizes>
    80006ff4:	000aa783          	lw	a5,0(s5)
    80006ff8:	37fd                	addiw	a5,a5,-1
    80006ffa:	44c1                	li	s1,16
    80006ffc:	00f497b3          	sll	a5,s1,a5
    80007000:	8f89                	sub	a5,a5,a0
  
  // initialize free lists for each size k
  int free = bd_initfree(p, bd_end);
    80007002:	00021597          	auipc	a1,0x21
    80007006:	0465b583          	ld	a1,70(a1) # 80028048 <bd_base>
    8000700a:	95be                	add	a1,a1,a5
    8000700c:	854a                	mv	a0,s2
    8000700e:	00000097          	auipc	ra,0x0
    80007012:	c86080e7          	jalr	-890(ra) # 80006c94 <bd_initfree>

  // check if the amount that is free is what we expect
  if(free != BLK_SIZE(MAXSIZE)-meta-unavailable) {
    80007016:	000aa603          	lw	a2,0(s5)
    8000701a:	367d                	addiw	a2,a2,-1
    8000701c:	00c49633          	sll	a2,s1,a2
    80007020:	41460633          	sub	a2,a2,s4
    80007024:	41360633          	sub	a2,a2,s3
    80007028:	02c51463          	bne	a0,a2,80007050 <bd_init+0x216>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    panic("bd_init: free mem");
  }
}
    8000702c:	60a6                	ld	ra,72(sp)
    8000702e:	6406                	ld	s0,64(sp)
    80007030:	74e2                	ld	s1,56(sp)
    80007032:	7942                	ld	s2,48(sp)
    80007034:	79a2                	ld	s3,40(sp)
    80007036:	7a02                	ld	s4,32(sp)
    80007038:	6ae2                	ld	s5,24(sp)
    8000703a:	6b42                	ld	s6,16(sp)
    8000703c:	6ba2                	ld	s7,8(sp)
    8000703e:	6c02                	ld	s8,0(sp)
    80007040:	6161                	addi	sp,sp,80
    80007042:	8082                	ret
    nsizes++;  // round up to the next power of 2
    80007044:	2509                	addiw	a0,a0,2
    80007046:	00021797          	auipc	a5,0x21
    8000704a:	00a7a923          	sw	a0,18(a5) # 80028058 <nsizes>
    8000704e:	bda1                	j	80006ea6 <bd_init+0x6c>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    80007050:	85aa                	mv	a1,a0
    80007052:	00002517          	auipc	a0,0x2
    80007056:	c8650513          	addi	a0,a0,-890 # 80008cd8 <userret+0xc48>
    8000705a:	ffff9097          	auipc	ra,0xffff9
    8000705e:	55a080e7          	jalr	1370(ra) # 800005b4 <printf>
    panic("bd_init: free mem");
    80007062:	00002517          	auipc	a0,0x2
    80007066:	c8650513          	addi	a0,a0,-890 # 80008ce8 <userret+0xc58>
    8000706a:	ffff9097          	auipc	ra,0xffff9
    8000706e:	4f0080e7          	jalr	1264(ra) # 8000055a <panic>

0000000080007072 <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    80007072:	1141                	addi	sp,sp,-16
    80007074:	e422                	sd	s0,8(sp)
    80007076:	0800                	addi	s0,sp,16
  lst->next = lst;
    80007078:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    8000707a:	e508                	sd	a0,8(a0)
}
    8000707c:	6422                	ld	s0,8(sp)
    8000707e:	0141                	addi	sp,sp,16
    80007080:	8082                	ret

0000000080007082 <lst_empty>:

int
lst_empty(struct list *lst) {
    80007082:	1141                	addi	sp,sp,-16
    80007084:	e422                	sd	s0,8(sp)
    80007086:	0800                	addi	s0,sp,16
  return lst->next == lst;
    80007088:	611c                	ld	a5,0(a0)
    8000708a:	40a78533          	sub	a0,a5,a0
}
    8000708e:	00153513          	seqz	a0,a0
    80007092:	6422                	ld	s0,8(sp)
    80007094:	0141                	addi	sp,sp,16
    80007096:	8082                	ret

0000000080007098 <lst_remove>:

void
lst_remove(struct list *e) {
    80007098:	1141                	addi	sp,sp,-16
    8000709a:	e422                	sd	s0,8(sp)
    8000709c:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    8000709e:	6518                	ld	a4,8(a0)
    800070a0:	611c                	ld	a5,0(a0)
    800070a2:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    800070a4:	6518                	ld	a4,8(a0)
    800070a6:	e798                	sd	a4,8(a5)
}
    800070a8:	6422                	ld	s0,8(sp)
    800070aa:	0141                	addi	sp,sp,16
    800070ac:	8082                	ret

00000000800070ae <lst_pop>:

void*
lst_pop(struct list *lst) {
    800070ae:	1101                	addi	sp,sp,-32
    800070b0:	ec06                	sd	ra,24(sp)
    800070b2:	e822                	sd	s0,16(sp)
    800070b4:	e426                	sd	s1,8(sp)
    800070b6:	1000                	addi	s0,sp,32
  if(lst->next == lst)
    800070b8:	6104                	ld	s1,0(a0)
    800070ba:	00a48d63          	beq	s1,a0,800070d4 <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
  lst_remove(p);
    800070be:	8526                	mv	a0,s1
    800070c0:	00000097          	auipc	ra,0x0
    800070c4:	fd8080e7          	jalr	-40(ra) # 80007098 <lst_remove>
  return (void *)p;
}
    800070c8:	8526                	mv	a0,s1
    800070ca:	60e2                	ld	ra,24(sp)
    800070cc:	6442                	ld	s0,16(sp)
    800070ce:	64a2                	ld	s1,8(sp)
    800070d0:	6105                	addi	sp,sp,32
    800070d2:	8082                	ret
    panic("lst_pop");
    800070d4:	00002517          	auipc	a0,0x2
    800070d8:	c2c50513          	addi	a0,a0,-980 # 80008d00 <userret+0xc70>
    800070dc:	ffff9097          	auipc	ra,0xffff9
    800070e0:	47e080e7          	jalr	1150(ra) # 8000055a <panic>

00000000800070e4 <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    800070e4:	1141                	addi	sp,sp,-16
    800070e6:	e422                	sd	s0,8(sp)
    800070e8:	0800                	addi	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    800070ea:	611c                	ld	a5,0(a0)
    800070ec:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    800070ee:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    800070f0:	611c                	ld	a5,0(a0)
    800070f2:	e78c                	sd	a1,8(a5)
  lst->next = e;
    800070f4:	e10c                	sd	a1,0(a0)
}
    800070f6:	6422                	ld	s0,8(sp)
    800070f8:	0141                	addi	sp,sp,16
    800070fa:	8082                	ret

00000000800070fc <lst_print>:

void
lst_print(struct list *lst)
{
    800070fc:	7179                	addi	sp,sp,-48
    800070fe:	f406                	sd	ra,40(sp)
    80007100:	f022                	sd	s0,32(sp)
    80007102:	ec26                	sd	s1,24(sp)
    80007104:	e84a                	sd	s2,16(sp)
    80007106:	e44e                	sd	s3,8(sp)
    80007108:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    8000710a:	6104                	ld	s1,0(a0)
    8000710c:	02950063          	beq	a0,s1,8000712c <lst_print+0x30>
    80007110:	892a                	mv	s2,a0
    printf(" %p", p);
    80007112:	00002997          	auipc	s3,0x2
    80007116:	bf698993          	addi	s3,s3,-1034 # 80008d08 <userret+0xc78>
    8000711a:	85a6                	mv	a1,s1
    8000711c:	854e                	mv	a0,s3
    8000711e:	ffff9097          	auipc	ra,0xffff9
    80007122:	496080e7          	jalr	1174(ra) # 800005b4 <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80007126:	6084                	ld	s1,0(s1)
    80007128:	fe9919e3          	bne	s2,s1,8000711a <lst_print+0x1e>
  }
  printf("\n");
    8000712c:	00001517          	auipc	a0,0x1
    80007130:	16450513          	addi	a0,a0,356 # 80008290 <userret+0x200>
    80007134:	ffff9097          	auipc	ra,0xffff9
    80007138:	480080e7          	jalr	1152(ra) # 800005b4 <printf>
}
    8000713c:	70a2                	ld	ra,40(sp)
    8000713e:	7402                	ld	s0,32(sp)
    80007140:	64e2                	ld	s1,24(sp)
    80007142:	6942                	ld	s2,16(sp)
    80007144:	69a2                	ld	s3,8(sp)
    80007146:	6145                	addi	sp,sp,48
    80007148:	8082                	ret
	...

0000000080008000 <trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
