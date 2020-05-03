
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	04013103          	ld	sp,64(sp) # 80008040 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fb660613          	addi	a2,a2,-74 # 80009000 <mscratch0>
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
    80000060:	b9478793          	addi	a5,a5,-1132 # 80005bf0 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <ticks+0xffffffff7ffd57d7>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	ca278793          	addi	a5,a5,-862 # 80000d48 <main>
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
  timerinit();
    800000c4:	00000097          	auipc	ra,0x0
    800000c8:	f58080e7          	jalr	-168(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000d0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000d4:	30200073          	mret
}
    800000d8:	60a2                	ld	ra,8(sp)
    800000da:	6402                	ld	s0,0(sp)
    800000dc:	0141                	addi	sp,sp,16
    800000de:	8082                	ret

00000000800000e0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800000e0:	7119                	addi	sp,sp,-128
    800000e2:	fc86                	sd	ra,120(sp)
    800000e4:	f8a2                	sd	s0,112(sp)
    800000e6:	f4a6                	sd	s1,104(sp)
    800000e8:	f0ca                	sd	s2,96(sp)
    800000ea:	ecce                	sd	s3,88(sp)
    800000ec:	e8d2                	sd	s4,80(sp)
    800000ee:	e4d6                	sd	s5,72(sp)
    800000f0:	e0da                	sd	s6,64(sp)
    800000f2:	fc5e                	sd	s7,56(sp)
    800000f4:	f862                	sd	s8,48(sp)
    800000f6:	f466                	sd	s9,40(sp)
    800000f8:	f06a                	sd	s10,32(sp)
    800000fa:	ec6e                	sd	s11,24(sp)
    800000fc:	0100                	addi	s0,sp,128
    800000fe:	8b2a                	mv	s6,a0
    80000100:	8aae                	mv	s5,a1
    80000102:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000104:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000108:	00011517          	auipc	a0,0x11
    8000010c:	6f850513          	addi	a0,a0,1784 # 80011800 <cons>
    80000110:	00001097          	auipc	ra,0x1
    80000114:	9c2080e7          	jalr	-1598(ra) # 80000ad2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000118:	00011497          	auipc	s1,0x11
    8000011c:	6e848493          	addi	s1,s1,1768 # 80011800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000120:	89a6                	mv	s3,s1
    80000122:	00011917          	auipc	s2,0x11
    80000126:	77690913          	addi	s2,s2,1910 # 80011898 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000012a:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000012c:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000012e:	4da9                	li	s11,10
  while(n > 0){
    80000130:	07405863          	blez	s4,800001a0 <consoleread+0xc0>
    while(cons.r == cons.w){
    80000134:	0984a783          	lw	a5,152(s1)
    80000138:	09c4a703          	lw	a4,156(s1)
    8000013c:	02f71463          	bne	a4,a5,80000164 <consoleread+0x84>
      if(myproc()->killed){
    80000140:	00001097          	auipc	ra,0x1
    80000144:	6f4080e7          	jalr	1780(ra) # 80001834 <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	eea080e7          	jalr	-278(ra) # 8000203a <sleep>
    while(cons.r == cons.w){
    80000158:	0984a783          	lw	a5,152(s1)
    8000015c:	09c4a703          	lw	a4,156(s1)
    80000160:	fef700e3          	beq	a4,a5,80000140 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000164:	0017871b          	addiw	a4,a5,1
    80000168:	08e4ac23          	sw	a4,152(s1)
    8000016c:	07f7f713          	andi	a4,a5,127
    80000170:	9726                	add	a4,a4,s1
    80000172:	01874703          	lbu	a4,24(a4)
    80000176:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    8000017a:	079c0663          	beq	s8,s9,800001e6 <consoleread+0x106>
    cbuf = c;
    8000017e:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000182:	4685                	li	a3,1
    80000184:	f8f40613          	addi	a2,s0,-113
    80000188:	85d6                	mv	a1,s5
    8000018a:	855a                	mv	a0,s6
    8000018c:	00002097          	auipc	ra,0x2
    80000190:	0d6080e7          	jalr	214(ra) # 80002262 <either_copyout>
    80000194:	01a50663          	beq	a0,s10,800001a0 <consoleread+0xc0>
    dst++;
    80000198:	0a85                	addi	s5,s5,1
    --n;
    8000019a:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000019c:	f9bc1ae3          	bne	s8,s11,80000130 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001a0:	00011517          	auipc	a0,0x11
    800001a4:	66050513          	addi	a0,a0,1632 # 80011800 <cons>
    800001a8:	00001097          	auipc	ra,0x1
    800001ac:	992080e7          	jalr	-1646(ra) # 80000b3a <release>

  return target - n;
    800001b0:	414b853b          	subw	a0,s7,s4
    800001b4:	a811                	j	800001c8 <consoleread+0xe8>
        release(&cons.lock);
    800001b6:	00011517          	auipc	a0,0x11
    800001ba:	64a50513          	addi	a0,a0,1610 # 80011800 <cons>
    800001be:	00001097          	auipc	ra,0x1
    800001c2:	97c080e7          	jalr	-1668(ra) # 80000b3a <release>
        return -1;
    800001c6:	557d                	li	a0,-1
}
    800001c8:	70e6                	ld	ra,120(sp)
    800001ca:	7446                	ld	s0,112(sp)
    800001cc:	74a6                	ld	s1,104(sp)
    800001ce:	7906                	ld	s2,96(sp)
    800001d0:	69e6                	ld	s3,88(sp)
    800001d2:	6a46                	ld	s4,80(sp)
    800001d4:	6aa6                	ld	s5,72(sp)
    800001d6:	6b06                	ld	s6,64(sp)
    800001d8:	7be2                	ld	s7,56(sp)
    800001da:	7c42                	ld	s8,48(sp)
    800001dc:	7ca2                	ld	s9,40(sp)
    800001de:	7d02                	ld	s10,32(sp)
    800001e0:	6de2                	ld	s11,24(sp)
    800001e2:	6109                	addi	sp,sp,128
    800001e4:	8082                	ret
      if(n < target){
    800001e6:	000a071b          	sext.w	a4,s4
    800001ea:	fb777be3          	bgeu	a4,s7,800001a0 <consoleread+0xc0>
        cons.r--;
    800001ee:	00011717          	auipc	a4,0x11
    800001f2:	6af72523          	sw	a5,1706(a4) # 80011898 <cons+0x98>
    800001f6:	b76d                	j	800001a0 <consoleread+0xc0>

00000000800001f8 <consputc>:
  if(panicked){
    800001f8:	00029797          	auipc	a5,0x29
    800001fc:	e087a783          	lw	a5,-504(a5) # 80029000 <panicked>
    80000200:	c391                	beqz	a5,80000204 <consputc+0xc>
    for(;;)
    80000202:	a001                	j	80000202 <consputc+0xa>
{
    80000204:	1141                	addi	sp,sp,-16
    80000206:	e406                	sd	ra,8(sp)
    80000208:	e022                	sd	s0,0(sp)
    8000020a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000020c:	10000793          	li	a5,256
    80000210:	00f50a63          	beq	a0,a5,80000224 <consputc+0x2c>
    uartputc(c);
    80000214:	00000097          	auipc	ra,0x0
    80000218:	5d2080e7          	jalr	1490(ra) # 800007e6 <uartputc>
}
    8000021c:	60a2                	ld	ra,8(sp)
    8000021e:	6402                	ld	s0,0(sp)
    80000220:	0141                	addi	sp,sp,16
    80000222:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    80000224:	4521                	li	a0,8
    80000226:	00000097          	auipc	ra,0x0
    8000022a:	5c0080e7          	jalr	1472(ra) # 800007e6 <uartputc>
    8000022e:	02000513          	li	a0,32
    80000232:	00000097          	auipc	ra,0x0
    80000236:	5b4080e7          	jalr	1460(ra) # 800007e6 <uartputc>
    8000023a:	4521                	li	a0,8
    8000023c:	00000097          	auipc	ra,0x0
    80000240:	5aa080e7          	jalr	1450(ra) # 800007e6 <uartputc>
    80000244:	bfe1                	j	8000021c <consputc+0x24>

0000000080000246 <consolewrite>:
{
    80000246:	715d                	addi	sp,sp,-80
    80000248:	e486                	sd	ra,72(sp)
    8000024a:	e0a2                	sd	s0,64(sp)
    8000024c:	fc26                	sd	s1,56(sp)
    8000024e:	f84a                	sd	s2,48(sp)
    80000250:	f44e                	sd	s3,40(sp)
    80000252:	f052                	sd	s4,32(sp)
    80000254:	ec56                	sd	s5,24(sp)
    80000256:	0880                	addi	s0,sp,80
    80000258:	89aa                	mv	s3,a0
    8000025a:	84ae                	mv	s1,a1
    8000025c:	8ab2                	mv	s5,a2
  acquire(&cons.lock);
    8000025e:	00011517          	auipc	a0,0x11
    80000262:	5a250513          	addi	a0,a0,1442 # 80011800 <cons>
    80000266:	00001097          	auipc	ra,0x1
    8000026a:	86c080e7          	jalr	-1940(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    8000026e:	03505e63          	blez	s5,800002aa <consolewrite+0x64>
    80000272:	00148913          	addi	s2,s1,1
    80000276:	fffa879b          	addiw	a5,s5,-1
    8000027a:	1782                	slli	a5,a5,0x20
    8000027c:	9381                	srli	a5,a5,0x20
    8000027e:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000280:	5a7d                	li	s4,-1
    80000282:	4685                	li	a3,1
    80000284:	8626                	mv	a2,s1
    80000286:	85ce                	mv	a1,s3
    80000288:	fbf40513          	addi	a0,s0,-65
    8000028c:	00002097          	auipc	ra,0x2
    80000290:	02c080e7          	jalr	44(ra) # 800022b8 <either_copyin>
    80000294:	01450b63          	beq	a0,s4,800002aa <consolewrite+0x64>
    consputc(c);
    80000298:	fbf44503          	lbu	a0,-65(s0)
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	f5c080e7          	jalr	-164(ra) # 800001f8 <consputc>
  for(i = 0; i < n; i++){
    800002a4:	0485                	addi	s1,s1,1
    800002a6:	fd249ee3          	bne	s1,s2,80000282 <consolewrite+0x3c>
  release(&cons.lock);
    800002aa:	00011517          	auipc	a0,0x11
    800002ae:	55650513          	addi	a0,a0,1366 # 80011800 <cons>
    800002b2:	00001097          	auipc	ra,0x1
    800002b6:	888080e7          	jalr	-1912(ra) # 80000b3a <release>
}
    800002ba:	8556                	mv	a0,s5
    800002bc:	60a6                	ld	ra,72(sp)
    800002be:	6406                	ld	s0,64(sp)
    800002c0:	74e2                	ld	s1,56(sp)
    800002c2:	7942                	ld	s2,48(sp)
    800002c4:	79a2                	ld	s3,40(sp)
    800002c6:	7a02                	ld	s4,32(sp)
    800002c8:	6ae2                	ld	s5,24(sp)
    800002ca:	6161                	addi	sp,sp,80
    800002cc:	8082                	ret

00000000800002ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ce:	1101                	addi	sp,sp,-32
    800002d0:	ec06                	sd	ra,24(sp)
    800002d2:	e822                	sd	s0,16(sp)
    800002d4:	e426                	sd	s1,8(sp)
    800002d6:	e04a                	sd	s2,0(sp)
    800002d8:	1000                	addi	s0,sp,32
    800002da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002dc:	00011517          	auipc	a0,0x11
    800002e0:	52450513          	addi	a0,a0,1316 # 80011800 <cons>
    800002e4:	00000097          	auipc	ra,0x0
    800002e8:	7ee080e7          	jalr	2030(ra) # 80000ad2 <acquire>

  switch(c){
    800002ec:	47d5                	li	a5,21
    800002ee:	0af48663          	beq	s1,a5,8000039a <consoleintr+0xcc>
    800002f2:	0297ca63          	blt	a5,s1,80000326 <consoleintr+0x58>
    800002f6:	47a1                	li	a5,8
    800002f8:	0ef48763          	beq	s1,a5,800003e6 <consoleintr+0x118>
    800002fc:	47c1                	li	a5,16
    800002fe:	10f49a63          	bne	s1,a5,80000412 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80000302:	00002097          	auipc	ra,0x2
    80000306:	00c080e7          	jalr	12(ra) # 8000230e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000030a:	00011517          	auipc	a0,0x11
    8000030e:	4f650513          	addi	a0,a0,1270 # 80011800 <cons>
    80000312:	00001097          	auipc	ra,0x1
    80000316:	828080e7          	jalr	-2008(ra) # 80000b3a <release>
}
    8000031a:	60e2                	ld	ra,24(sp)
    8000031c:	6442                	ld	s0,16(sp)
    8000031e:	64a2                	ld	s1,8(sp)
    80000320:	6902                	ld	s2,0(sp)
    80000322:	6105                	addi	sp,sp,32
    80000324:	8082                	ret
  switch(c){
    80000326:	07f00793          	li	a5,127
    8000032a:	0af48e63          	beq	s1,a5,800003e6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000032e:	00011717          	auipc	a4,0x11
    80000332:	4d270713          	addi	a4,a4,1234 # 80011800 <cons>
    80000336:	0a072783          	lw	a5,160(a4)
    8000033a:	09872703          	lw	a4,152(a4)
    8000033e:	9f99                	subw	a5,a5,a4
    80000340:	07f00713          	li	a4,127
    80000344:	fcf763e3          	bltu	a4,a5,8000030a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000348:	47b5                	li	a5,13
    8000034a:	0cf48763          	beq	s1,a5,80000418 <consoleintr+0x14a>
      consputc(c);
    8000034e:	8526                	mv	a0,s1
    80000350:	00000097          	auipc	ra,0x0
    80000354:	ea8080e7          	jalr	-344(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000358:	00011797          	auipc	a5,0x11
    8000035c:	4a878793          	addi	a5,a5,1192 # 80011800 <cons>
    80000360:	0a07a703          	lw	a4,160(a5)
    80000364:	0017069b          	addiw	a3,a4,1
    80000368:	0006861b          	sext.w	a2,a3
    8000036c:	0ad7a023          	sw	a3,160(a5)
    80000370:	07f77713          	andi	a4,a4,127
    80000374:	97ba                	add	a5,a5,a4
    80000376:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000037a:	47a9                	li	a5,10
    8000037c:	0cf48563          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000380:	4791                	li	a5,4
    80000382:	0cf48263          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000386:	00011797          	auipc	a5,0x11
    8000038a:	5127a783          	lw	a5,1298(a5) # 80011898 <cons+0x98>
    8000038e:	0807879b          	addiw	a5,a5,128
    80000392:	f6f61ce3          	bne	a2,a5,8000030a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000396:	863e                	mv	a2,a5
    80000398:	a07d                	j	80000446 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000039a:	00011717          	auipc	a4,0x11
    8000039e:	46670713          	addi	a4,a4,1126 # 80011800 <cons>
    800003a2:	0a072783          	lw	a5,160(a4)
    800003a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003aa:	00011497          	auipc	s1,0x11
    800003ae:	45648493          	addi	s1,s1,1110 # 80011800 <cons>
    while(cons.e != cons.w &&
    800003b2:	4929                	li	s2,10
    800003b4:	f4f70be3          	beq	a4,a5,8000030a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b8:	37fd                	addiw	a5,a5,-1
    800003ba:	07f7f713          	andi	a4,a5,127
    800003be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c0:	01874703          	lbu	a4,24(a4)
    800003c4:	f52703e3          	beq	a4,s2,8000030a <consoleintr+0x3c>
      cons.e--;
    800003c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003cc:	10000513          	li	a0,256
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	e28080e7          	jalr	-472(ra) # 800001f8 <consputc>
    while(cons.e != cons.w &&
    800003d8:	0a04a783          	lw	a5,160(s1)
    800003dc:	09c4a703          	lw	a4,156(s1)
    800003e0:	fcf71ce3          	bne	a4,a5,800003b8 <consoleintr+0xea>
    800003e4:	b71d                	j	8000030a <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e6:	00011717          	auipc	a4,0x11
    800003ea:	41a70713          	addi	a4,a4,1050 # 80011800 <cons>
    800003ee:	0a072783          	lw	a5,160(a4)
    800003f2:	09c72703          	lw	a4,156(a4)
    800003f6:	f0f70ae3          	beq	a4,a5,8000030a <consoleintr+0x3c>
      cons.e--;
    800003fa:	37fd                	addiw	a5,a5,-1
    800003fc:	00011717          	auipc	a4,0x11
    80000400:	4af72223          	sw	a5,1188(a4) # 800118a0 <cons+0xa0>
      consputc(BACKSPACE);
    80000404:	10000513          	li	a0,256
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	df0080e7          	jalr	-528(ra) # 800001f8 <consputc>
    80000410:	bded                	j	8000030a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000412:	ee048ce3          	beqz	s1,8000030a <consoleintr+0x3c>
    80000416:	bf21                	j	8000032e <consoleintr+0x60>
      consputc(c);
    80000418:	4529                	li	a0,10
    8000041a:	00000097          	auipc	ra,0x0
    8000041e:	dde080e7          	jalr	-546(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	3de78793          	addi	a5,a5,990 # 80011800 <cons>
    8000042a:	0a07a703          	lw	a4,160(a5)
    8000042e:	0017069b          	addiw	a3,a4,1
    80000432:	0006861b          	sext.w	a2,a3
    80000436:	0ad7a023          	sw	a3,160(a5)
    8000043a:	07f77713          	andi	a4,a4,127
    8000043e:	97ba                	add	a5,a5,a4
    80000440:	4729                	li	a4,10
    80000442:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000446:	00011797          	auipc	a5,0x11
    8000044a:	44c7ab23          	sw	a2,1110(a5) # 8001189c <cons+0x9c>
        wakeup(&cons.r);
    8000044e:	00011517          	auipc	a0,0x11
    80000452:	44a50513          	addi	a0,a0,1098 # 80011898 <cons+0x98>
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	d30080e7          	jalr	-720(ra) # 80002186 <wakeup>
    8000045e:	b575                	j	8000030a <consoleintr+0x3c>

0000000080000460 <consoleinit>:

void
consoleinit(void)
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e406                	sd	ra,8(sp)
    80000464:	e022                	sd	s0,0(sp)
    80000466:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000468:	00007597          	auipc	a1,0x7
    8000046c:	cb058593          	addi	a1,a1,-848 # 80007118 <userret+0x88>
    80000470:	00011517          	auipc	a0,0x11
    80000474:	39050513          	addi	a0,a0,912 # 80011800 <cons>
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	548080e7          	jalr	1352(ra) # 800009c0 <initlock>

  uartinit();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	330080e7          	jalr	816(ra) # 800007b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000488:	00021797          	auipc	a5,0x21
    8000048c:	46078793          	addi	a5,a5,1120 # 800218e8 <devsw>
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c5070713          	addi	a4,a4,-944 # 800000e0 <consoleread>
    80000498:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000049a:	00000717          	auipc	a4,0x0
    8000049e:	dac70713          	addi	a4,a4,-596 # 80000246 <consolewrite>
    800004a2:	ef98                	sd	a4,24(a5)
}
    800004a4:	60a2                	ld	ra,8(sp)
    800004a6:	6402                	ld	s0,0(sp)
    800004a8:	0141                	addi	sp,sp,16
    800004aa:	8082                	ret

00000000800004ac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ac:	7179                	addi	sp,sp,-48
    800004ae:	f406                	sd	ra,40(sp)
    800004b0:	f022                	sd	s0,32(sp)
    800004b2:	ec26                	sd	s1,24(sp)
    800004b4:	e84a                	sd	s2,16(sp)
    800004b6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b8:	c219                	beqz	a2,800004be <printint+0x12>
    800004ba:	08054663          	bltz	a0,80000546 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004be:	2501                	sext.w	a0,a0
    800004c0:	4881                	li	a7,0
    800004c2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c8:	2581                	sext.w	a1,a1
    800004ca:	00007617          	auipc	a2,0x7
    800004ce:	3e660613          	addi	a2,a2,998 # 800078b0 <digits>
    800004d2:	883a                	mv	a6,a4
    800004d4:	2705                	addiw	a4,a4,1
    800004d6:	02b577bb          	remuw	a5,a0,a1
    800004da:	1782                	slli	a5,a5,0x20
    800004dc:	9381                	srli	a5,a5,0x20
    800004de:	97b2                	add	a5,a5,a2
    800004e0:	0007c783          	lbu	a5,0(a5)
    800004e4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e8:	0005079b          	sext.w	a5,a0
    800004ec:	02b5553b          	divuw	a0,a0,a1
    800004f0:	0685                	addi	a3,a3,1
    800004f2:	feb7f0e3          	bgeu	a5,a1,800004d2 <printint+0x26>

  if(sign)
    800004f6:	00088b63          	beqz	a7,8000050c <printint+0x60>
    buf[i++] = '-';
    800004fa:	fe040793          	addi	a5,s0,-32
    800004fe:	973e                	add	a4,a4,a5
    80000500:	02d00793          	li	a5,45
    80000504:	fef70823          	sb	a5,-16(a4)
    80000508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000050c:	02e05763          	blez	a4,8000053a <printint+0x8e>
    80000510:	fd040793          	addi	a5,s0,-48
    80000514:	00e784b3          	add	s1,a5,a4
    80000518:	fff78913          	addi	s2,a5,-1
    8000051c:	993a                	add	s2,s2,a4
    8000051e:	377d                	addiw	a4,a4,-1
    80000520:	1702                	slli	a4,a4,0x20
    80000522:	9301                	srli	a4,a4,0x20
    80000524:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000528:	fff4c503          	lbu	a0,-1(s1)
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	ccc080e7          	jalr	-820(ra) # 800001f8 <consputc>
  while(--i >= 0)
    80000534:	14fd                	addi	s1,s1,-1
    80000536:	ff2499e3          	bne	s1,s2,80000528 <printint+0x7c>
}
    8000053a:	70a2                	ld	ra,40(sp)
    8000053c:	7402                	ld	s0,32(sp)
    8000053e:	64e2                	ld	s1,24(sp)
    80000540:	6942                	ld	s2,16(sp)
    80000542:	6145                	addi	sp,sp,48
    80000544:	8082                	ret
    x = -xx;
    80000546:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000054a:	4885                	li	a7,1
    x = -xx;
    8000054c:	bf9d                	j	800004c2 <printint+0x16>

000000008000054e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000054e:	1101                	addi	sp,sp,-32
    80000550:	ec06                	sd	ra,24(sp)
    80000552:	e822                	sd	s0,16(sp)
    80000554:	e426                	sd	s1,8(sp)
    80000556:	1000                	addi	s0,sp,32
    80000558:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000055a:	00011797          	auipc	a5,0x11
    8000055e:	3607a323          	sw	zero,870(a5) # 800118c0 <pr+0x18>
  printf("panic: ");
    80000562:	00007517          	auipc	a0,0x7
    80000566:	bbe50513          	addi	a0,a0,-1090 # 80007120 <userret+0x90>
    8000056a:	00000097          	auipc	ra,0x0
    8000056e:	02e080e7          	jalr	46(ra) # 80000598 <printf>
  printf(s);
    80000572:	8526                	mv	a0,s1
    80000574:	00000097          	auipc	ra,0x0
    80000578:	024080e7          	jalr	36(ra) # 80000598 <printf>
  printf("\n");
    8000057c:	00007517          	auipc	a0,0x7
    80000580:	c3450513          	addi	a0,a0,-972 # 800071b0 <userret+0x120>
    80000584:	00000097          	auipc	ra,0x0
    80000588:	014080e7          	jalr	20(ra) # 80000598 <printf>
  panicked = 1; // freeze other CPUs
    8000058c:	4785                	li	a5,1
    8000058e:	00029717          	auipc	a4,0x29
    80000592:	a6f72923          	sw	a5,-1422(a4) # 80029000 <panicked>
  for(;;)
    80000596:	a001                	j	80000596 <panic+0x48>

0000000080000598 <printf>:
{
    80000598:	7131                	addi	sp,sp,-192
    8000059a:	fc86                	sd	ra,120(sp)
    8000059c:	f8a2                	sd	s0,112(sp)
    8000059e:	f4a6                	sd	s1,104(sp)
    800005a0:	f0ca                	sd	s2,96(sp)
    800005a2:	ecce                	sd	s3,88(sp)
    800005a4:	e8d2                	sd	s4,80(sp)
    800005a6:	e4d6                	sd	s5,72(sp)
    800005a8:	e0da                	sd	s6,64(sp)
    800005aa:	fc5e                	sd	s7,56(sp)
    800005ac:	f862                	sd	s8,48(sp)
    800005ae:	f466                	sd	s9,40(sp)
    800005b0:	f06a                	sd	s10,32(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00011d97          	auipc	s11,0x11
    800005ce:	2f6dad83          	lw	s11,758(s11) # 800118c0 <pr+0x18>
  if(locking)
    800005d2:	020d9b63          	bnez	s11,80000608 <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0263          	beqz	s4,8000061a <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	16050263          	beqz	a0,8000074a <printf+0x1b2>
    800005ea:	4481                	li	s1,0
    if(c != '%'){
    800005ec:	02500a93          	li	s5,37
    switch(c){
    800005f0:	07000b13          	li	s6,112
  consputc('x');
    800005f4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f6:	00007b97          	auipc	s7,0x7
    800005fa:	2bab8b93          	addi	s7,s7,698 # 800078b0 <digits>
    switch(c){
    800005fe:	07300c93          	li	s9,115
    80000602:	06400c13          	li	s8,100
    80000606:	a82d                	j	80000640 <printf+0xa8>
    acquire(&pr.lock);
    80000608:	00011517          	auipc	a0,0x11
    8000060c:	2a050513          	addi	a0,a0,672 # 800118a8 <pr>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	4c2080e7          	jalr	1218(ra) # 80000ad2 <acquire>
    80000618:	bf7d                	j	800005d6 <printf+0x3e>
    panic("null fmt");
    8000061a:	00007517          	auipc	a0,0x7
    8000061e:	b1650513          	addi	a0,a0,-1258 # 80007130 <userret+0xa0>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	f2c080e7          	jalr	-212(ra) # 8000054e <panic>
      consputc(c);
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	bce080e7          	jalr	-1074(ra) # 800001f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000632:	2485                	addiw	s1,s1,1
    80000634:	009a07b3          	add	a5,s4,s1
    80000638:	0007c503          	lbu	a0,0(a5)
    8000063c:	10050763          	beqz	a0,8000074a <printf+0x1b2>
    if(c != '%'){
    80000640:	ff5515e3          	bne	a0,s5,8000062a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000644:	2485                	addiw	s1,s1,1
    80000646:	009a07b3          	add	a5,s4,s1
    8000064a:	0007c783          	lbu	a5,0(a5)
    8000064e:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000652:	cfe5                	beqz	a5,8000074a <printf+0x1b2>
    switch(c){
    80000654:	05678a63          	beq	a5,s6,800006a8 <printf+0x110>
    80000658:	02fb7663          	bgeu	s6,a5,80000684 <printf+0xec>
    8000065c:	09978963          	beq	a5,s9,800006ee <printf+0x156>
    80000660:	07800713          	li	a4,120
    80000664:	0ce79863          	bne	a5,a4,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	85ea                	mv	a1,s10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e32080e7          	jalr	-462(ra) # 800004ac <printint>
      break;
    80000682:	bf45                	j	80000632 <printf+0x9a>
    switch(c){
    80000684:	0b578263          	beq	a5,s5,80000728 <printf+0x190>
    80000688:	0b879663          	bne	a5,s8,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	45a9                	li	a1,10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e0e080e7          	jalr	-498(ra) # 800004ac <printint>
      break;
    800006a6:	b771                	j	80000632 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b8:	03000513          	li	a0,48
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	b3c080e7          	jalr	-1220(ra) # 800001f8 <consputc>
  consputc('x');
    800006c4:	07800513          	li	a0,120
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	b30080e7          	jalr	-1232(ra) # 800001f8 <consputc>
    800006d0:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	03c9d793          	srli	a5,s3,0x3c
    800006d6:	97de                	add	a5,a5,s7
    800006d8:	0007c503          	lbu	a0,0(a5)
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	b1c080e7          	jalr	-1252(ra) # 800001f8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e4:	0992                	slli	s3,s3,0x4
    800006e6:	397d                	addiw	s2,s2,-1
    800006e8:	fe0915e3          	bnez	s2,800006d2 <printf+0x13a>
    800006ec:	b799                	j	80000632 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006ee:	f8843783          	ld	a5,-120(s0)
    800006f2:	00878713          	addi	a4,a5,8
    800006f6:	f8e43423          	sd	a4,-120(s0)
    800006fa:	0007b903          	ld	s2,0(a5)
    800006fe:	00090e63          	beqz	s2,8000071a <printf+0x182>
      for(; *s; s++)
    80000702:	00094503          	lbu	a0,0(s2)
    80000706:	d515                	beqz	a0,80000632 <printf+0x9a>
        consputc(*s);
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	af0080e7          	jalr	-1296(ra) # 800001f8 <consputc>
      for(; *s; s++)
    80000710:	0905                	addi	s2,s2,1
    80000712:	00094503          	lbu	a0,0(s2)
    80000716:	f96d                	bnez	a0,80000708 <printf+0x170>
    80000718:	bf29                	j	80000632 <printf+0x9a>
        s = "(null)";
    8000071a:	00007917          	auipc	s2,0x7
    8000071e:	a0e90913          	addi	s2,s2,-1522 # 80007128 <userret+0x98>
      for(; *s; s++)
    80000722:	02800513          	li	a0,40
    80000726:	b7cd                	j	80000708 <printf+0x170>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ace080e7          	jalr	-1330(ra) # 800001f8 <consputc>
      break;
    80000732:	b701                	j	80000632 <printf+0x9a>
      consputc('%');
    80000734:	8556                	mv	a0,s5
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	ac2080e7          	jalr	-1342(ra) # 800001f8 <consputc>
      consputc(c);
    8000073e:	854a                	mv	a0,s2
    80000740:	00000097          	auipc	ra,0x0
    80000744:	ab8080e7          	jalr	-1352(ra) # 800001f8 <consputc>
      break;
    80000748:	b5ed                	j	80000632 <printf+0x9a>
  if(locking)
    8000074a:	020d9163          	bnez	s11,8000076c <printf+0x1d4>
}
    8000074e:	70e6                	ld	ra,120(sp)
    80000750:	7446                	ld	s0,112(sp)
    80000752:	74a6                	ld	s1,104(sp)
    80000754:	7906                	ld	s2,96(sp)
    80000756:	69e6                	ld	s3,88(sp)
    80000758:	6a46                	ld	s4,80(sp)
    8000075a:	6aa6                	ld	s5,72(sp)
    8000075c:	6b06                	ld	s6,64(sp)
    8000075e:	7be2                	ld	s7,56(sp)
    80000760:	7c42                	ld	s8,48(sp)
    80000762:	7ca2                	ld	s9,40(sp)
    80000764:	7d02                	ld	s10,32(sp)
    80000766:	6de2                	ld	s11,24(sp)
    80000768:	6129                	addi	sp,sp,192
    8000076a:	8082                	ret
    release(&pr.lock);
    8000076c:	00011517          	auipc	a0,0x11
    80000770:	13c50513          	addi	a0,a0,316 # 800118a8 <pr>
    80000774:	00000097          	auipc	ra,0x0
    80000778:	3c6080e7          	jalr	966(ra) # 80000b3a <release>
}
    8000077c:	bfc9                	j	8000074e <printf+0x1b6>

000000008000077e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000077e:	1101                	addi	sp,sp,-32
    80000780:	ec06                	sd	ra,24(sp)
    80000782:	e822                	sd	s0,16(sp)
    80000784:	e426                	sd	s1,8(sp)
    80000786:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000788:	00011497          	auipc	s1,0x11
    8000078c:	12048493          	addi	s1,s1,288 # 800118a8 <pr>
    80000790:	00007597          	auipc	a1,0x7
    80000794:	9b058593          	addi	a1,a1,-1616 # 80007140 <userret+0xb0>
    80000798:	8526                	mv	a0,s1
    8000079a:	00000097          	auipc	ra,0x0
    8000079e:	226080e7          	jalr	550(ra) # 800009c0 <initlock>
  pr.locking = 1;
    800007a2:	4785                	li	a5,1
    800007a4:	cc9c                	sw	a5,24(s1)
}
    800007a6:	60e2                	ld	ra,24(sp)
    800007a8:	6442                	ld	s0,16(sp)
    800007aa:	64a2                	ld	s1,8(sp)
    800007ac:	6105                	addi	sp,sp,32
    800007ae:	8082                	ret

00000000800007b0 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007b0:	1141                	addi	sp,sp,-16
    800007b2:	e422                	sd	s0,8(sp)
    800007b4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b6:	100007b7          	lui	a5,0x10000
    800007ba:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007be:	f8000713          	li	a4,-128
    800007c2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c6:	470d                	li	a4,3
    800007c8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007d0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007d4:	471d                	li	a4,7
    800007d6:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007da:	4705                	li	a4,1
    800007dc:	00e780a3          	sb	a4,1(a5)
}
    800007e0:	6422                	ld	s0,8(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e422                	sd	s0,8(sp)
    800007ea:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007ec:	10000737          	lui	a4,0x10000
    800007f0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007f4:	0ff7f793          	andi	a5,a5,255
    800007f8:	0207f793          	andi	a5,a5,32
    800007fc:	dbf5                	beqz	a5,800007f0 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007fe:	0ff57513          	andi	a0,a0,255
    80000802:	100007b7          	lui	a5,0x10000
    80000806:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000080a:	6422                	ld	s0,8(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e422                	sd	s0,8(sp)
    80000814:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000816:	100007b7          	lui	a5,0x10000
    8000081a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000081e:	8b85                	andi	a5,a5,1
    80000820:	cb91                	beqz	a5,80000834 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000082a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000082e:	6422                	ld	s0,8(sp)
    80000830:	0141                	addi	sp,sp,16
    80000832:	8082                	ret
    return -1;
    80000834:	557d                	li	a0,-1
    80000836:	bfe5                	j	8000082e <uartgetc+0x1e>

0000000080000838 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000838:	1101                	addi	sp,sp,-32
    8000083a:	ec06                	sd	ra,24(sp)
    8000083c:	e822                	sd	s0,16(sp)
    8000083e:	e426                	sd	s1,8(sp)
    80000840:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000842:	54fd                	li	s1,-1
    int c = uartgetc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	fcc080e7          	jalr	-52(ra) # 80000810 <uartgetc>
    if(c == -1)
    8000084c:	00950763          	beq	a0,s1,8000085a <uartintr+0x22>
      break;
    consoleintr(c);
    80000850:	00000097          	auipc	ra,0x0
    80000854:	a7e080e7          	jalr	-1410(ra) # 800002ce <consoleintr>
  while(1){
    80000858:	b7f5                	j	80000844 <uartintr+0xc>
  }
}
    8000085a:	60e2                	ld	ra,24(sp)
    8000085c:	6442                	ld	s0,16(sp)
    8000085e:	64a2                	ld	s1,8(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	e04a                	sd	s2,0(sp)
    8000086e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000870:	03451793          	slli	a5,a0,0x34
    80000874:	ebb9                	bnez	a5,800008ca <kfree+0x66>
    80000876:	84aa                	mv	s1,a0
    80000878:	00028797          	auipc	a5,0x28
    8000087c:	78878793          	addi	a5,a5,1928 # 80029000 <panicked>
    80000880:	04f56563          	bltu	a0,a5,800008ca <kfree+0x66>
    80000884:	47c5                	li	a5,17
    80000886:	07ee                	slli	a5,a5,0x1b
    80000888:	04f57163          	bgeu	a0,a5,800008ca <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000088c:	6605                	lui	a2,0x1
    8000088e:	4585                	li	a1,1
    80000890:	00000097          	auipc	ra,0x0
    80000894:	306080e7          	jalr	774(ra) # 80000b96 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000898:	00011917          	auipc	s2,0x11
    8000089c:	03090913          	addi	s2,s2,48 # 800118c8 <kmem>
    800008a0:	854a                	mv	a0,s2
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	230080e7          	jalr	560(ra) # 80000ad2 <acquire>
  r->next = kmem.freelist;
    800008aa:	01893783          	ld	a5,24(s2)
    800008ae:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008b0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008b4:	854a                	mv	a0,s2
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	284080e7          	jalr	644(ra) # 80000b3a <release>
}
    800008be:	60e2                	ld	ra,24(sp)
    800008c0:	6442                	ld	s0,16(sp)
    800008c2:	64a2                	ld	s1,8(sp)
    800008c4:	6902                	ld	s2,0(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    panic("kfree");
    800008ca:	00007517          	auipc	a0,0x7
    800008ce:	87e50513          	addi	a0,a0,-1922 # 80007148 <userret+0xb8>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	c7c080e7          	jalr	-900(ra) # 8000054e <panic>

00000000800008da <freerange>:
{
    800008da:	7179                	addi	sp,sp,-48
    800008dc:	f406                	sd	ra,40(sp)
    800008de:	f022                	sd	s0,32(sp)
    800008e0:	ec26                	sd	s1,24(sp)
    800008e2:	e84a                	sd	s2,16(sp)
    800008e4:	e44e                	sd	s3,8(sp)
    800008e6:	e052                	sd	s4,0(sp)
    800008e8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008ea:	6485                	lui	s1,0x1
    800008ec:	14fd                	addi	s1,s1,-1
    800008ee:	94aa                	add	s1,s1,a0
    800008f0:	757d                	lui	a0,0xfffff
    800008f2:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008f4:	6789                	lui	a5,0x2
    800008f6:	94be                	add	s1,s1,a5
    800008f8:	0095ee63          	bltu	a1,s1,80000914 <freerange+0x3a>
    800008fc:	892e                	mv	s2,a1
    kfree(p);
    800008fe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000900:	6985                	lui	s3,0x1
    kfree(p);
    80000902:	01448533          	add	a0,s1,s4
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f5e080e7          	jalr	-162(ra) # 80000864 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000090e:	94ce                	add	s1,s1,s3
    80000910:	fe9979e3          	bgeu	s2,s1,80000902 <freerange+0x28>
}
    80000914:	70a2                	ld	ra,40(sp)
    80000916:	7402                	ld	s0,32(sp)
    80000918:	64e2                	ld	s1,24(sp)
    8000091a:	6942                	ld	s2,16(sp)
    8000091c:	69a2                	ld	s3,8(sp)
    8000091e:	6a02                	ld	s4,0(sp)
    80000920:	6145                	addi	sp,sp,48
    80000922:	8082                	ret

0000000080000924 <kinit>:
{
    80000924:	1141                	addi	sp,sp,-16
    80000926:	e406                	sd	ra,8(sp)
    80000928:	e022                	sd	s0,0(sp)
    8000092a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000092c:	00007597          	auipc	a1,0x7
    80000930:	82458593          	addi	a1,a1,-2012 # 80007150 <userret+0xc0>
    80000934:	00011517          	auipc	a0,0x11
    80000938:	f9450513          	addi	a0,a0,-108 # 800118c8 <kmem>
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	084080e7          	jalr	132(ra) # 800009c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000944:	45c5                	li	a1,17
    80000946:	05ee                	slli	a1,a1,0x1b
    80000948:	00028517          	auipc	a0,0x28
    8000094c:	6b850513          	addi	a0,a0,1720 # 80029000 <panicked>
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f8a080e7          	jalr	-118(ra) # 800008da <freerange>
}
    80000958:	60a2                	ld	ra,8(sp)
    8000095a:	6402                	ld	s0,0(sp)
    8000095c:	0141                	addi	sp,sp,16
    8000095e:	8082                	ret

0000000080000960 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000960:	1101                	addi	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000096a:	00011497          	auipc	s1,0x11
    8000096e:	f5e48493          	addi	s1,s1,-162 # 800118c8 <kmem>
    80000972:	8526                	mv	a0,s1
    80000974:	00000097          	auipc	ra,0x0
    80000978:	15e080e7          	jalr	350(ra) # 80000ad2 <acquire>
  r = kmem.freelist;
    8000097c:	6c84                	ld	s1,24(s1)
  if(r)
    8000097e:	c885                	beqz	s1,800009ae <kalloc+0x4e>
    kmem.freelist = r->next;
    80000980:	609c                	ld	a5,0(s1)
    80000982:	00011517          	auipc	a0,0x11
    80000986:	f4650513          	addi	a0,a0,-186 # 800118c8 <kmem>
    8000098a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	1ae080e7          	jalr	430(ra) # 80000b3a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000994:	6605                	lui	a2,0x1
    80000996:	4595                	li	a1,5
    80000998:	8526                	mv	a0,s1
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	1fc080e7          	jalr	508(ra) # 80000b96 <memset>
  return (void*)r;
}
    800009a2:	8526                	mv	a0,s1
    800009a4:	60e2                	ld	ra,24(sp)
    800009a6:	6442                	ld	s0,16(sp)
    800009a8:	64a2                	ld	s1,8(sp)
    800009aa:	6105                	addi	sp,sp,32
    800009ac:	8082                	ret
  release(&kmem.lock);
    800009ae:	00011517          	auipc	a0,0x11
    800009b2:	f1a50513          	addi	a0,a0,-230 # 800118c8 <kmem>
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	184080e7          	jalr	388(ra) # 80000b3a <release>
  if(r)
    800009be:	b7d5                	j	800009a2 <kalloc+0x42>

00000000800009c0 <initlock>:

uint64 ntest_and_set;

void
initlock(struct spinlock *lk, char *name)
{
    800009c0:	1141                	addi	sp,sp,-16
    800009c2:	e422                	sd	s0,8(sp)
    800009c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800009c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009cc:	00053823          	sd	zero,16(a0)
}
    800009d0:	6422                	ld	s0,8(sp)
    800009d2:	0141                	addi	sp,sp,16
    800009d4:	8082                	ret

00000000800009d6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009e0:	100024f3          	csrr	s1,sstatus
    800009e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800009e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800009ea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800009ee:	00001097          	auipc	ra,0x1
    800009f2:	e2a080e7          	jalr	-470(ra) # 80001818 <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	e1e080e7          	jalr	-482(ra) # 80001818 <mycpu>
    80000a02:	5d3c                	lw	a5,120(a0)
    80000a04:	2785                	addiw	a5,a5,1
    80000a06:	dd3c                	sw	a5,120(a0)
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret
    mycpu()->intena = old;
    80000a12:	00001097          	auipc	ra,0x1
    80000a16:	e06080e7          	jalr	-506(ra) # 80001818 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a1a:	8085                	srli	s1,s1,0x1
    80000a1c:	8885                	andi	s1,s1,1
    80000a1e:	dd64                	sw	s1,124(a0)
    80000a20:	bfe9                	j	800009fa <push_off+0x24>

0000000080000a22 <pop_off>:

void
pop_off(void)
{
    80000a22:	1141                	addi	sp,sp,-16
    80000a24:	e406                	sd	ra,8(sp)
    80000a26:	e022                	sd	s0,0(sp)
    80000a28:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a2a:	00001097          	auipc	ra,0x1
    80000a2e:	dee080e7          	jalr	-530(ra) # 80001818 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a32:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a36:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a38:	ef8d                	bnez	a5,80000a72 <pop_off+0x50>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a3a:	5d3c                	lw	a5,120(a0)
    80000a3c:	37fd                	addiw	a5,a5,-1
    80000a3e:	0007871b          	sext.w	a4,a5
    80000a42:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a44:	02079693          	slli	a3,a5,0x20
    80000a48:	0206cd63          	bltz	a3,80000a82 <pop_off+0x60>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a4c:	ef19                	bnez	a4,80000a6a <pop_off+0x48>
    80000a4e:	5d7c                	lw	a5,124(a0)
    80000a50:	cf89                	beqz	a5,80000a6a <pop_off+0x48>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a52:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a56:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a5a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a6a:	60a2                	ld	ra,8(sp)
    80000a6c:	6402                	ld	s0,0(sp)
    80000a6e:	0141                	addi	sp,sp,16
    80000a70:	8082                	ret
    panic("pop_off - interruptible");
    80000a72:	00006517          	auipc	a0,0x6
    80000a76:	6e650513          	addi	a0,a0,1766 # 80007158 <userret+0xc8>
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ad4080e7          	jalr	-1324(ra) # 8000054e <panic>
    panic("pop_off");
    80000a82:	00006517          	auipc	a0,0x6
    80000a86:	6ee50513          	addi	a0,a0,1774 # 80007170 <userret+0xe0>
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	ac4080e7          	jalr	-1340(ra) # 8000054e <panic>

0000000080000a92 <holding>:
{
    80000a92:	1101                	addi	sp,sp,-32
    80000a94:	ec06                	sd	ra,24(sp)
    80000a96:	e822                	sd	s0,16(sp)
    80000a98:	e426                	sd	s1,8(sp)
    80000a9a:	1000                	addi	s0,sp,32
    80000a9c:	84aa                	mv	s1,a0
  push_off();
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	f38080e7          	jalr	-200(ra) # 800009d6 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000aa6:	409c                	lw	a5,0(s1)
    80000aa8:	ef81                	bnez	a5,80000ac0 <holding+0x2e>
    80000aaa:	4481                	li	s1,0
  pop_off();
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	f76080e7          	jalr	-138(ra) # 80000a22 <pop_off>
}
    80000ab4:	8526                	mv	a0,s1
    80000ab6:	60e2                	ld	ra,24(sp)
    80000ab8:	6442                	ld	s0,16(sp)
    80000aba:	64a2                	ld	s1,8(sp)
    80000abc:	6105                	addi	sp,sp,32
    80000abe:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ac0:	6884                	ld	s1,16(s1)
    80000ac2:	00001097          	auipc	ra,0x1
    80000ac6:	d56080e7          	jalr	-682(ra) # 80001818 <mycpu>
    80000aca:	8c89                	sub	s1,s1,a0
    80000acc:	0014b493          	seqz	s1,s1
    80000ad0:	bff1                	j	80000aac <holding+0x1a>

0000000080000ad2 <acquire>:
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
    80000adc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	ef8080e7          	jalr	-264(ra) # 800009d6 <push_off>
  if(holding(lk))
    80000ae6:	8526                	mv	a0,s1
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	faa080e7          	jalr	-86(ra) # 80000a92 <holding>
    80000af0:	e901                	bnez	a0,80000b00 <acquire+0x2e>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000af2:	4685                	li	a3,1
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000af4:	00028717          	auipc	a4,0x28
    80000af8:	51470713          	addi	a4,a4,1300 # 80029008 <ntest_and_set>
    80000afc:	4605                	li	a2,1
    80000afe:	a829                	j	80000b18 <acquire+0x46>
    panic("acquire");
    80000b00:	00006517          	auipc	a0,0x6
    80000b04:	67850513          	addi	a0,a0,1656 # 80007178 <userret+0xe8>
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	a46080e7          	jalr	-1466(ra) # 8000054e <panic>
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000b10:	0f50000f          	fence	iorw,ow
    80000b14:	04c7302f          	amoadd.d.aq	zero,a2,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000b18:	87b6                	mv	a5,a3
    80000b1a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b1e:	2781                	sext.w	a5,a5
    80000b20:	fbe5                	bnez	a5,80000b10 <acquire+0x3e>
  __sync_synchronize();
    80000b22:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b26:	00001097          	auipc	ra,0x1
    80000b2a:	cf2080e7          	jalr	-782(ra) # 80001818 <mycpu>
    80000b2e:	e888                	sd	a0,16(s1)
}
    80000b30:	60e2                	ld	ra,24(sp)
    80000b32:	6442                	ld	s0,16(sp)
    80000b34:	64a2                	ld	s1,8(sp)
    80000b36:	6105                	addi	sp,sp,32
    80000b38:	8082                	ret

0000000080000b3a <release>:
{
    80000b3a:	1101                	addi	sp,sp,-32
    80000b3c:	ec06                	sd	ra,24(sp)
    80000b3e:	e822                	sd	s0,16(sp)
    80000b40:	e426                	sd	s1,8(sp)
    80000b42:	1000                	addi	s0,sp,32
    80000b44:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	f4c080e7          	jalr	-180(ra) # 80000a92 <holding>
    80000b4e:	c115                	beqz	a0,80000b72 <release+0x38>
  lk->cpu = 0;
    80000b50:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b54:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b58:	0f50000f          	fence	iorw,ow
    80000b5c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	ec2080e7          	jalr	-318(ra) # 80000a22 <pop_off>
}
    80000b68:	60e2                	ld	ra,24(sp)
    80000b6a:	6442                	ld	s0,16(sp)
    80000b6c:	64a2                	ld	s1,8(sp)
    80000b6e:	6105                	addi	sp,sp,32
    80000b70:	8082                	ret
    panic("release");
    80000b72:	00006517          	auipc	a0,0x6
    80000b76:	60e50513          	addi	a0,a0,1550 # 80007180 <userret+0xf0>
    80000b7a:	00000097          	auipc	ra,0x0
    80000b7e:	9d4080e7          	jalr	-1580(ra) # 8000054e <panic>

0000000080000b82 <sys_ntas>:

uint64
sys_ntas(void)
{
    80000b82:	1141                	addi	sp,sp,-16
    80000b84:	e422                	sd	s0,8(sp)
    80000b86:	0800                	addi	s0,sp,16
  return ntest_and_set;
}
    80000b88:	00028517          	auipc	a0,0x28
    80000b8c:	48053503          	ld	a0,1152(a0) # 80029008 <ntest_and_set>
    80000b90:	6422                	ld	s0,8(sp)
    80000b92:	0141                	addi	sp,sp,16
    80000b94:	8082                	ret

0000000080000b96 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000b96:	1141                	addi	sp,sp,-16
    80000b98:	e422                	sd	s0,8(sp)
    80000b9a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000b9c:	ce09                	beqz	a2,80000bb6 <memset+0x20>
    80000b9e:	87aa                	mv	a5,a0
    80000ba0:	fff6071b          	addiw	a4,a2,-1
    80000ba4:	1702                	slli	a4,a4,0x20
    80000ba6:	9301                	srli	a4,a4,0x20
    80000ba8:	0705                	addi	a4,a4,1
    80000baa:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000bac:	00b78023          	sb	a1,0(a5) # 2000 <_entry-0x7fffe000>
  for(i = 0; i < n; i++){
    80000bb0:	0785                	addi	a5,a5,1
    80000bb2:	fee79de3          	bne	a5,a4,80000bac <memset+0x16>
  }
  return dst;
}
    80000bb6:	6422                	ld	s0,8(sp)
    80000bb8:	0141                	addi	sp,sp,16
    80000bba:	8082                	ret

0000000080000bbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000bbc:	1141                	addi	sp,sp,-16
    80000bbe:	e422                	sd	s0,8(sp)
    80000bc0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000bc2:	ca05                	beqz	a2,80000bf2 <memcmp+0x36>
    80000bc4:	fff6069b          	addiw	a3,a2,-1
    80000bc8:	1682                	slli	a3,a3,0x20
    80000bca:	9281                	srli	a3,a3,0x20
    80000bcc:	0685                	addi	a3,a3,1
    80000bce:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000bd0:	00054783          	lbu	a5,0(a0)
    80000bd4:	0005c703          	lbu	a4,0(a1)
    80000bd8:	00e79863          	bne	a5,a4,80000be8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bdc:	0505                	addi	a0,a0,1
    80000bde:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000be0:	fed518e3          	bne	a0,a3,80000bd0 <memcmp+0x14>
  }

  return 0;
    80000be4:	4501                	li	a0,0
    80000be6:	a019                	j	80000bec <memcmp+0x30>
      return *s1 - *s2;
    80000be8:	40e7853b          	subw	a0,a5,a4
}
    80000bec:	6422                	ld	s0,8(sp)
    80000bee:	0141                	addi	sp,sp,16
    80000bf0:	8082                	ret
  return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	bfe5                	j	80000bec <memcmp+0x30>

0000000080000bf6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000bf6:	1141                	addi	sp,sp,-16
    80000bf8:	e422                	sd	s0,8(sp)
    80000bfa:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000bfc:	00a5f963          	bgeu	a1,a0,80000c0e <memmove+0x18>
    80000c00:	02061713          	slli	a4,a2,0x20
    80000c04:	9301                	srli	a4,a4,0x20
    80000c06:	00e587b3          	add	a5,a1,a4
    80000c0a:	02f56563          	bltu	a0,a5,80000c34 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000c0e:	fff6069b          	addiw	a3,a2,-1
    80000c12:	ce11                	beqz	a2,80000c2e <memmove+0x38>
    80000c14:	1682                	slli	a3,a3,0x20
    80000c16:	9281                	srli	a3,a3,0x20
    80000c18:	0685                	addi	a3,a3,1
    80000c1a:	96ae                	add	a3,a3,a1
    80000c1c:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000c1e:	0585                	addi	a1,a1,1
    80000c20:	0785                	addi	a5,a5,1
    80000c22:	fff5c703          	lbu	a4,-1(a1)
    80000c26:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000c2a:	fed59ae3          	bne	a1,a3,80000c1e <memmove+0x28>

  return dst;
}
    80000c2e:	6422                	ld	s0,8(sp)
    80000c30:	0141                	addi	sp,sp,16
    80000c32:	8082                	ret
    d += n;
    80000c34:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c36:	fff6069b          	addiw	a3,a2,-1
    80000c3a:	da75                	beqz	a2,80000c2e <memmove+0x38>
    80000c3c:	02069613          	slli	a2,a3,0x20
    80000c40:	9201                	srli	a2,a2,0x20
    80000c42:	fff64613          	not	a2,a2
    80000c46:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c48:	17fd                	addi	a5,a5,-1
    80000c4a:	177d                	addi	a4,a4,-1
    80000c4c:	0007c683          	lbu	a3,0(a5)
    80000c50:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c54:	fec79ae3          	bne	a5,a2,80000c48 <memmove+0x52>
    80000c58:	bfd9                	j	80000c2e <memmove+0x38>

0000000080000c5a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c5a:	1141                	addi	sp,sp,-16
    80000c5c:	e406                	sd	ra,8(sp)
    80000c5e:	e022                	sd	s0,0(sp)
    80000c60:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c62:	00000097          	auipc	ra,0x0
    80000c66:	f94080e7          	jalr	-108(ra) # 80000bf6 <memmove>
}
    80000c6a:	60a2                	ld	ra,8(sp)
    80000c6c:	6402                	ld	s0,0(sp)
    80000c6e:	0141                	addi	sp,sp,16
    80000c70:	8082                	ret

0000000080000c72 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c72:	1141                	addi	sp,sp,-16
    80000c74:	e422                	sd	s0,8(sp)
    80000c76:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c78:	ce11                	beqz	a2,80000c94 <strncmp+0x22>
    80000c7a:	00054783          	lbu	a5,0(a0)
    80000c7e:	cf89                	beqz	a5,80000c98 <strncmp+0x26>
    80000c80:	0005c703          	lbu	a4,0(a1)
    80000c84:	00f71a63          	bne	a4,a5,80000c98 <strncmp+0x26>
    n--, p++, q++;
    80000c88:	367d                	addiw	a2,a2,-1
    80000c8a:	0505                	addi	a0,a0,1
    80000c8c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000c8e:	f675                	bnez	a2,80000c7a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000c90:	4501                	li	a0,0
    80000c92:	a809                	j	80000ca4 <strncmp+0x32>
    80000c94:	4501                	li	a0,0
    80000c96:	a039                	j	80000ca4 <strncmp+0x32>
  if(n == 0)
    80000c98:	ca09                	beqz	a2,80000caa <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000c9a:	00054503          	lbu	a0,0(a0)
    80000c9e:	0005c783          	lbu	a5,0(a1)
    80000ca2:	9d1d                	subw	a0,a0,a5
}
    80000ca4:	6422                	ld	s0,8(sp)
    80000ca6:	0141                	addi	sp,sp,16
    80000ca8:	8082                	ret
    return 0;
    80000caa:	4501                	li	a0,0
    80000cac:	bfe5                	j	80000ca4 <strncmp+0x32>

0000000080000cae <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000cae:	1141                	addi	sp,sp,-16
    80000cb0:	e422                	sd	s0,8(sp)
    80000cb2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000cb4:	872a                	mv	a4,a0
    80000cb6:	8832                	mv	a6,a2
    80000cb8:	367d                	addiw	a2,a2,-1
    80000cba:	01005963          	blez	a6,80000ccc <strncpy+0x1e>
    80000cbe:	0705                	addi	a4,a4,1
    80000cc0:	0005c783          	lbu	a5,0(a1)
    80000cc4:	fef70fa3          	sb	a5,-1(a4)
    80000cc8:	0585                	addi	a1,a1,1
    80000cca:	f7f5                	bnez	a5,80000cb6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ccc:	00c05d63          	blez	a2,80000ce6 <strncpy+0x38>
    80000cd0:	86ba                	mv	a3,a4
    *s++ = 0;
    80000cd2:	0685                	addi	a3,a3,1
    80000cd4:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cd8:	fff6c793          	not	a5,a3
    80000cdc:	9fb9                	addw	a5,a5,a4
    80000cde:	010787bb          	addw	a5,a5,a6
    80000ce2:	fef048e3          	bgtz	a5,80000cd2 <strncpy+0x24>
  return os;
}
    80000ce6:	6422                	ld	s0,8(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret

0000000080000cec <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000cec:	1141                	addi	sp,sp,-16
    80000cee:	e422                	sd	s0,8(sp)
    80000cf0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000cf2:	02c05363          	blez	a2,80000d18 <safestrcpy+0x2c>
    80000cf6:	fff6069b          	addiw	a3,a2,-1
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	96ae                	add	a3,a3,a1
    80000d00:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000d02:	00d58963          	beq	a1,a3,80000d14 <safestrcpy+0x28>
    80000d06:	0585                	addi	a1,a1,1
    80000d08:	0785                	addi	a5,a5,1
    80000d0a:	fff5c703          	lbu	a4,-1(a1)
    80000d0e:	fee78fa3          	sb	a4,-1(a5)
    80000d12:	fb65                	bnez	a4,80000d02 <safestrcpy+0x16>
    ;
  *s = 0;
    80000d14:	00078023          	sb	zero,0(a5)
  return os;
}
    80000d18:	6422                	ld	s0,8(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <strlen>:

int
strlen(const char *s)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e422                	sd	s0,8(sp)
    80000d22:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000d24:	00054783          	lbu	a5,0(a0)
    80000d28:	cf91                	beqz	a5,80000d44 <strlen+0x26>
    80000d2a:	0505                	addi	a0,a0,1
    80000d2c:	87aa                	mv	a5,a0
    80000d2e:	4685                	li	a3,1
    80000d30:	9e89                	subw	a3,a3,a0
    80000d32:	00f6853b          	addw	a0,a3,a5
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff7c703          	lbu	a4,-1(a5)
    80000d3c:	fb7d                	bnez	a4,80000d32 <strlen+0x14>
    ;
  return n;
}
    80000d3e:	6422                	ld	s0,8(sp)
    80000d40:	0141                	addi	sp,sp,16
    80000d42:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d44:	4501                	li	a0,0
    80000d46:	bfe5                	j	80000d3e <strlen+0x20>

0000000080000d48 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d48:	1141                	addi	sp,sp,-16
    80000d4a:	e406                	sd	ra,8(sp)
    80000d4c:	e022                	sd	s0,0(sp)
    80000d4e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d50:	00001097          	auipc	ra,0x1
    80000d54:	ab8080e7          	jalr	-1352(ra) # 80001808 <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d58:	00028717          	auipc	a4,0x28
    80000d5c:	2b870713          	addi	a4,a4,696 # 80029010 <started>
  if(cpuid() == 0){
    80000d60:	c139                	beqz	a0,80000da6 <main+0x5e>
    while(started == 0)
    80000d62:	431c                	lw	a5,0(a4)
    80000d64:	2781                	sext.w	a5,a5
    80000d66:	dff5                	beqz	a5,80000d62 <main+0x1a>
      ;
    __sync_synchronize();
    80000d68:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d6c:	00001097          	auipc	ra,0x1
    80000d70:	a9c080e7          	jalr	-1380(ra) # 80001808 <cpuid>
    80000d74:	85aa                	mv	a1,a0
    80000d76:	00006517          	auipc	a0,0x6
    80000d7a:	42a50513          	addi	a0,a0,1066 # 800071a0 <userret+0x110>
    80000d7e:	00000097          	auipc	ra,0x0
    80000d82:	81a080e7          	jalr	-2022(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	1ea080e7          	jalr	490(ra) # 80000f70 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d8e:	00001097          	auipc	ra,0x1
    80000d92:	6c0080e7          	jalr	1728(ra) # 8000244e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	e9a080e7          	jalr	-358(ra) # 80005c30 <plicinithart>
  }

  scheduler();        
    80000d9e:	00001097          	auipc	ra,0x1
    80000da2:	fd4080e7          	jalr	-44(ra) # 80001d72 <scheduler>
    consoleinit();
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	6ba080e7          	jalr	1722(ra) # 80000460 <consoleinit>
    printfinit();
    80000dae:	00000097          	auipc	ra,0x0
    80000db2:	9d0080e7          	jalr	-1584(ra) # 8000077e <printfinit>
    printf("\n");
    80000db6:	00006517          	auipc	a0,0x6
    80000dba:	3fa50513          	addi	a0,a0,1018 # 800071b0 <userret+0x120>
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	7da080e7          	jalr	2010(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000dc6:	00006517          	auipc	a0,0x6
    80000dca:	3c250513          	addi	a0,a0,962 # 80007188 <userret+0xf8>
    80000dce:	fffff097          	auipc	ra,0xfffff
    80000dd2:	7ca080e7          	jalr	1994(ra) # 80000598 <printf>
    printf("\n");
    80000dd6:	00006517          	auipc	a0,0x6
    80000dda:	3da50513          	addi	a0,a0,986 # 800071b0 <userret+0x120>
    80000dde:	fffff097          	auipc	ra,0xfffff
    80000de2:	7ba080e7          	jalr	1978(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000de6:	00000097          	auipc	ra,0x0
    80000dea:	b3e080e7          	jalr	-1218(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000dee:	00000097          	auipc	ra,0x0
    80000df2:	300080e7          	jalr	768(ra) # 800010ee <kvminit>
    kvminithart();   // turn on paging
    80000df6:	00000097          	auipc	ra,0x0
    80000dfa:	17a080e7          	jalr	378(ra) # 80000f70 <kvminithart>
    procinit();      // process table
    80000dfe:	00001097          	auipc	ra,0x1
    80000e02:	93a080e7          	jalr	-1734(ra) # 80001738 <procinit>
    trapinit();      // trap vectors
    80000e06:	00001097          	auipc	ra,0x1
    80000e0a:	620080e7          	jalr	1568(ra) # 80002426 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e0e:	00001097          	auipc	ra,0x1
    80000e12:	640080e7          	jalr	1600(ra) # 8000244e <trapinithart>
    plicinit();      // set up interrupt controller
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	e04080e7          	jalr	-508(ra) # 80005c1a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e1e:	00005097          	auipc	ra,0x5
    80000e22:	e12080e7          	jalr	-494(ra) # 80005c30 <plicinithart>
    binit();         // buffer cache
    80000e26:	00002097          	auipc	ra,0x2
    80000e2a:	d2e080e7          	jalr	-722(ra) # 80002b54 <binit>
    iinit();         // inode cache
    80000e2e:	00002097          	auipc	ra,0x2
    80000e32:	3c2080e7          	jalr	962(ra) # 800031f0 <iinit>
    fileinit();      // file table
    80000e36:	00003097          	auipc	ra,0x3
    80000e3a:	59e080e7          	jalr	1438(ra) # 800043d4 <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80000e3e:	4501                	li	a0,0
    80000e40:	00005097          	auipc	ra,0x5
    80000e44:	f24080e7          	jalr	-220(ra) # 80005d64 <virtio_disk_init>
    userinit();      // first user process
    80000e48:	00001097          	auipc	ra,0x1
    80000e4c:	c5c080e7          	jalr	-932(ra) # 80001aa4 <userinit>
    __sync_synchronize();
    80000e50:	0ff0000f          	fence
    started = 1;
    80000e54:	4785                	li	a5,1
    80000e56:	00028717          	auipc	a4,0x28
    80000e5a:	1af72d23          	sw	a5,442(a4) # 80029010 <started>
    80000e5e:	b781                	j	80000d9e <main+0x56>

0000000080000e60 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000e60:	7139                	addi	sp,sp,-64
    80000e62:	fc06                	sd	ra,56(sp)
    80000e64:	f822                	sd	s0,48(sp)
    80000e66:	f426                	sd	s1,40(sp)
    80000e68:	f04a                	sd	s2,32(sp)
    80000e6a:	ec4e                	sd	s3,24(sp)
    80000e6c:	e852                	sd	s4,16(sp)
    80000e6e:	e456                	sd	s5,8(sp)
    80000e70:	e05a                	sd	s6,0(sp)
    80000e72:	0080                	addi	s0,sp,64
    80000e74:	84aa                	mv	s1,a0
    80000e76:	89ae                	mv	s3,a1
    80000e78:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000e7a:	57fd                	li	a5,-1
    80000e7c:	83e9                	srli	a5,a5,0x1a
    80000e7e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000e80:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000e82:	04b7f263          	bgeu	a5,a1,80000ec6 <walk+0x66>
    panic("walk");
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	33250513          	addi	a0,a0,818 # 800071b8 <userret+0x128>
    80000e8e:	fffff097          	auipc	ra,0xfffff
    80000e92:	6c0080e7          	jalr	1728(ra) # 8000054e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000e96:	060a8663          	beqz	s5,80000f02 <walk+0xa2>
    80000e9a:	00000097          	auipc	ra,0x0
    80000e9e:	ac6080e7          	jalr	-1338(ra) # 80000960 <kalloc>
    80000ea2:	84aa                	mv	s1,a0
    80000ea4:	c529                	beqz	a0,80000eee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ea6:	6605                	lui	a2,0x1
    80000ea8:	4581                	li	a1,0
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	cec080e7          	jalr	-788(ra) # 80000b96 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000eb2:	00c4d793          	srli	a5,s1,0xc
    80000eb6:	07aa                	slli	a5,a5,0xa
    80000eb8:	0017e793          	ori	a5,a5,1
    80000ebc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000ec0:	3a5d                	addiw	s4,s4,-9
    80000ec2:	036a0063          	beq	s4,s6,80000ee2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000ec6:	0149d933          	srl	s2,s3,s4
    80000eca:	1ff97913          	andi	s2,s2,511
    80000ece:	090e                	slli	s2,s2,0x3
    80000ed0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000ed2:	00093483          	ld	s1,0(s2)
    80000ed6:	0014f793          	andi	a5,s1,1
    80000eda:	dfd5                	beqz	a5,80000e96 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000edc:	80a9                	srli	s1,s1,0xa
    80000ede:	04b2                	slli	s1,s1,0xc
    80000ee0:	b7c5                	j	80000ec0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000ee2:	00c9d513          	srli	a0,s3,0xc
    80000ee6:	1ff57513          	andi	a0,a0,511
    80000eea:	050e                	slli	a0,a0,0x3
    80000eec:	9526                	add	a0,a0,s1
}
    80000eee:	70e2                	ld	ra,56(sp)
    80000ef0:	7442                	ld	s0,48(sp)
    80000ef2:	74a2                	ld	s1,40(sp)
    80000ef4:	7902                	ld	s2,32(sp)
    80000ef6:	69e2                	ld	s3,24(sp)
    80000ef8:	6a42                	ld	s4,16(sp)
    80000efa:	6aa2                	ld	s5,8(sp)
    80000efc:	6b02                	ld	s6,0(sp)
    80000efe:	6121                	addi	sp,sp,64
    80000f00:	8082                	ret
        return 0;
    80000f02:	4501                	li	a0,0
    80000f04:	b7ed                	j	80000eee <walk+0x8e>

0000000080000f06 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000f06:	7179                	addi	sp,sp,-48
    80000f08:	f406                	sd	ra,40(sp)
    80000f0a:	f022                	sd	s0,32(sp)
    80000f0c:	ec26                	sd	s1,24(sp)
    80000f0e:	e84a                	sd	s2,16(sp)
    80000f10:	e44e                	sd	s3,8(sp)
    80000f12:	e052                	sd	s4,0(sp)
    80000f14:	1800                	addi	s0,sp,48
    80000f16:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000f18:	84aa                	mv	s1,a0
    80000f1a:	6905                	lui	s2,0x1
    80000f1c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f1e:	4985                	li	s3,1
    80000f20:	a821                	j	80000f38 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000f22:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000f24:	0532                	slli	a0,a0,0xc
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	fe0080e7          	jalr	-32(ra) # 80000f06 <freewalk>
      pagetable[i] = 0;
    80000f2e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000f32:	04a1                	addi	s1,s1,8
    80000f34:	03248163          	beq	s1,s2,80000f56 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000f38:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f3a:	00f57793          	andi	a5,a0,15
    80000f3e:	ff3782e3          	beq	a5,s3,80000f22 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000f42:	8905                	andi	a0,a0,1
    80000f44:	d57d                	beqz	a0,80000f32 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000f46:	00006517          	auipc	a0,0x6
    80000f4a:	27a50513          	addi	a0,a0,634 # 800071c0 <userret+0x130>
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	600080e7          	jalr	1536(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000f56:	8552                	mv	a0,s4
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	90c080e7          	jalr	-1780(ra) # 80000864 <kfree>
}
    80000f60:	70a2                	ld	ra,40(sp)
    80000f62:	7402                	ld	s0,32(sp)
    80000f64:	64e2                	ld	s1,24(sp)
    80000f66:	6942                	ld	s2,16(sp)
    80000f68:	69a2                	ld	s3,8(sp)
    80000f6a:	6a02                	ld	s4,0(sp)
    80000f6c:	6145                	addi	sp,sp,48
    80000f6e:	8082                	ret

0000000080000f70 <kvminithart>:
{
    80000f70:	1141                	addi	sp,sp,-16
    80000f72:	e422                	sd	s0,8(sp)
    80000f74:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f76:	00028797          	auipc	a5,0x28
    80000f7a:	0a27b783          	ld	a5,162(a5) # 80029018 <kernel_pagetable>
    80000f7e:	83b1                	srli	a5,a5,0xc
    80000f80:	577d                	li	a4,-1
    80000f82:	177e                	slli	a4,a4,0x3f
    80000f84:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f86:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f8a:	12000073          	sfence.vma
}
    80000f8e:	6422                	ld	s0,8(sp)
    80000f90:	0141                	addi	sp,sp,16
    80000f92:	8082                	ret

0000000080000f94 <walkaddr>:
{
    80000f94:	1141                	addi	sp,sp,-16
    80000f96:	e406                	sd	ra,8(sp)
    80000f98:	e022                	sd	s0,0(sp)
    80000f9a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f9c:	4601                	li	a2,0
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	ec2080e7          	jalr	-318(ra) # 80000e60 <walk>
  if(pte == 0)
    80000fa6:	c105                	beqz	a0,80000fc6 <walkaddr+0x32>
  if((*pte & PTE_V) == 0)
    80000fa8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000faa:	0117f693          	andi	a3,a5,17
    80000fae:	4745                	li	a4,17
    return 0;
    80000fb0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fb2:	00e68663          	beq	a3,a4,80000fbe <walkaddr+0x2a>
}
    80000fb6:	60a2                	ld	ra,8(sp)
    80000fb8:	6402                	ld	s0,0(sp)
    80000fba:	0141                	addi	sp,sp,16
    80000fbc:	8082                	ret
  pa = PTE2PA(*pte);
    80000fbe:	83a9                	srli	a5,a5,0xa
    80000fc0:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fc4:	bfcd                	j	80000fb6 <walkaddr+0x22>
    return 0;
    80000fc6:	4501                	li	a0,0
    80000fc8:	b7fd                	j	80000fb6 <walkaddr+0x22>

0000000080000fca <kvmpa>:
{
    80000fca:	1101                	addi	sp,sp,-32
    80000fcc:	ec06                	sd	ra,24(sp)
    80000fce:	e822                	sd	s0,16(sp)
    80000fd0:	e426                	sd	s1,8(sp)
    80000fd2:	1000                	addi	s0,sp,32
    80000fd4:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fd6:	1552                	slli	a0,a0,0x34
    80000fd8:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fdc:	4601                	li	a2,0
    80000fde:	00028517          	auipc	a0,0x28
    80000fe2:	03a53503          	ld	a0,58(a0) # 80029018 <kernel_pagetable>
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	e7a080e7          	jalr	-390(ra) # 80000e60 <walk>
  if(pte == 0)
    80000fee:	cd09                	beqz	a0,80001008 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000ff0:	6108                	ld	a0,0(a0)
    80000ff2:	00157793          	andi	a5,a0,1
    80000ff6:	c38d                	beqz	a5,80001018 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000ff8:	8129                	srli	a0,a0,0xa
    80000ffa:	0532                	slli	a0,a0,0xc
}
    80000ffc:	9526                	add	a0,a0,s1
    80000ffe:	60e2                	ld	ra,24(sp)
    80001000:	6442                	ld	s0,16(sp)
    80001002:	64a2                	ld	s1,8(sp)
    80001004:	6105                	addi	sp,sp,32
    80001006:	8082                	ret
    panic("kvmpa");
    80001008:	00006517          	auipc	a0,0x6
    8000100c:	1c850513          	addi	a0,a0,456 # 800071d0 <userret+0x140>
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	53e080e7          	jalr	1342(ra) # 8000054e <panic>
    panic("kvmpa");
    80001018:	00006517          	auipc	a0,0x6
    8000101c:	1b850513          	addi	a0,a0,440 # 800071d0 <userret+0x140>
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	52e080e7          	jalr	1326(ra) # 8000054e <panic>

0000000080001028 <mappages>:
{
    80001028:	715d                	addi	sp,sp,-80
    8000102a:	e486                	sd	ra,72(sp)
    8000102c:	e0a2                	sd	s0,64(sp)
    8000102e:	fc26                	sd	s1,56(sp)
    80001030:	f84a                	sd	s2,48(sp)
    80001032:	f44e                	sd	s3,40(sp)
    80001034:	f052                	sd	s4,32(sp)
    80001036:	ec56                	sd	s5,24(sp)
    80001038:	e85a                	sd	s6,16(sp)
    8000103a:	e45e                	sd	s7,8(sp)
    8000103c:	0880                	addi	s0,sp,80
    8000103e:	8aaa                	mv	s5,a0
    80001040:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001042:	777d                	lui	a4,0xfffff
    80001044:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001048:	167d                	addi	a2,a2,-1
    8000104a:	00b609b3          	add	s3,a2,a1
    8000104e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001052:	893e                	mv	s2,a5
    80001054:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001058:	6b85                	lui	s7,0x1
    8000105a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000105e:	4605                	li	a2,1
    80001060:	85ca                	mv	a1,s2
    80001062:	8556                	mv	a0,s5
    80001064:	00000097          	auipc	ra,0x0
    80001068:	dfc080e7          	jalr	-516(ra) # 80000e60 <walk>
    8000106c:	c51d                	beqz	a0,8000109a <mappages+0x72>
    if(*pte & PTE_V)
    8000106e:	611c                	ld	a5,0(a0)
    80001070:	8b85                	andi	a5,a5,1
    80001072:	ef81                	bnez	a5,8000108a <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001074:	80b1                	srli	s1,s1,0xc
    80001076:	04aa                	slli	s1,s1,0xa
    80001078:	0164e4b3          	or	s1,s1,s6
    8000107c:	0014e493          	ori	s1,s1,1
    80001080:	e104                	sd	s1,0(a0)
    if(a == last)
    80001082:	03390863          	beq	s2,s3,800010b2 <mappages+0x8a>
    a += PGSIZE;
    80001086:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001088:	bfc9                	j	8000105a <mappages+0x32>
      panic("remap");
    8000108a:	00006517          	auipc	a0,0x6
    8000108e:	14e50513          	addi	a0,a0,334 # 800071d8 <userret+0x148>
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	4bc080e7          	jalr	1212(ra) # 8000054e <panic>
      return -1;
    8000109a:	557d                	li	a0,-1
}
    8000109c:	60a6                	ld	ra,72(sp)
    8000109e:	6406                	ld	s0,64(sp)
    800010a0:	74e2                	ld	s1,56(sp)
    800010a2:	7942                	ld	s2,48(sp)
    800010a4:	79a2                	ld	s3,40(sp)
    800010a6:	7a02                	ld	s4,32(sp)
    800010a8:	6ae2                	ld	s5,24(sp)
    800010aa:	6b42                	ld	s6,16(sp)
    800010ac:	6ba2                	ld	s7,8(sp)
    800010ae:	6161                	addi	sp,sp,80
    800010b0:	8082                	ret
  return 0;
    800010b2:	4501                	li	a0,0
    800010b4:	b7e5                	j	8000109c <mappages+0x74>

00000000800010b6 <kvmmap>:
{
    800010b6:	1141                	addi	sp,sp,-16
    800010b8:	e406                	sd	ra,8(sp)
    800010ba:	e022                	sd	s0,0(sp)
    800010bc:	0800                	addi	s0,sp,16
    800010be:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010c0:	86ae                	mv	a3,a1
    800010c2:	85aa                	mv	a1,a0
    800010c4:	00028517          	auipc	a0,0x28
    800010c8:	f5453503          	ld	a0,-172(a0) # 80029018 <kernel_pagetable>
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	f5c080e7          	jalr	-164(ra) # 80001028 <mappages>
    800010d4:	e509                	bnez	a0,800010de <kvmmap+0x28>
}
    800010d6:	60a2                	ld	ra,8(sp)
    800010d8:	6402                	ld	s0,0(sp)
    800010da:	0141                	addi	sp,sp,16
    800010dc:	8082                	ret
    panic("kvmmap");
    800010de:	00006517          	auipc	a0,0x6
    800010e2:	10250513          	addi	a0,a0,258 # 800071e0 <userret+0x150>
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	468080e7          	jalr	1128(ra) # 8000054e <panic>

00000000800010ee <kvminit>:
{
    800010ee:	1101                	addi	sp,sp,-32
    800010f0:	ec06                	sd	ra,24(sp)
    800010f2:	e822                	sd	s0,16(sp)
    800010f4:	e426                	sd	s1,8(sp)
    800010f6:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	868080e7          	jalr	-1944(ra) # 80000960 <kalloc>
    80001100:	00028797          	auipc	a5,0x28
    80001104:	f0a7bc23          	sd	a0,-232(a5) # 80029018 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001108:	6605                	lui	a2,0x1
    8000110a:	4581                	li	a1,0
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	a8a080e7          	jalr	-1398(ra) # 80000b96 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001114:	4699                	li	a3,6
    80001116:	6605                	lui	a2,0x1
    80001118:	100005b7          	lui	a1,0x10000
    8000111c:	10000537          	lui	a0,0x10000
    80001120:	00000097          	auipc	ra,0x0
    80001124:	f96080e7          	jalr	-106(ra) # 800010b6 <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    80001128:	4699                	li	a3,6
    8000112a:	6605                	lui	a2,0x1
    8000112c:	100015b7          	lui	a1,0x10001
    80001130:	10001537          	lui	a0,0x10001
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f82080e7          	jalr	-126(ra) # 800010b6 <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    8000113c:	4699                	li	a3,6
    8000113e:	6605                	lui	a2,0x1
    80001140:	100025b7          	lui	a1,0x10002
    80001144:	10002537          	lui	a0,0x10002
    80001148:	00000097          	auipc	ra,0x0
    8000114c:	f6e080e7          	jalr	-146(ra) # 800010b6 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001150:	4699                	li	a3,6
    80001152:	6641                	lui	a2,0x10
    80001154:	020005b7          	lui	a1,0x2000
    80001158:	02000537          	lui	a0,0x2000
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	f5a080e7          	jalr	-166(ra) # 800010b6 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001164:	4699                	li	a3,6
    80001166:	00400637          	lui	a2,0x400
    8000116a:	0c0005b7          	lui	a1,0xc000
    8000116e:	0c000537          	lui	a0,0xc000
    80001172:	00000097          	auipc	ra,0x0
    80001176:	f44080e7          	jalr	-188(ra) # 800010b6 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000117a:	00007497          	auipc	s1,0x7
    8000117e:	e8648493          	addi	s1,s1,-378 # 80008000 <initcode>
    80001182:	46a9                	li	a3,10
    80001184:	80007617          	auipc	a2,0x80007
    80001188:	e7c60613          	addi	a2,a2,-388 # 8000 <_entry-0x7fff8000>
    8000118c:	4585                	li	a1,1
    8000118e:	05fe                	slli	a1,a1,0x1f
    80001190:	852e                	mv	a0,a1
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f24080e7          	jalr	-220(ra) # 800010b6 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119a:	4699                	li	a3,6
    8000119c:	4645                	li	a2,17
    8000119e:	066e                	slli	a2,a2,0x1b
    800011a0:	8e05                	sub	a2,a2,s1
    800011a2:	85a6                	mv	a1,s1
    800011a4:	8526                	mv	a0,s1
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	f10080e7          	jalr	-240(ra) # 800010b6 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ae:	46a9                	li	a3,10
    800011b0:	6605                	lui	a2,0x1
    800011b2:	00006597          	auipc	a1,0x6
    800011b6:	e4e58593          	addi	a1,a1,-434 # 80007000 <trampoline>
    800011ba:	04000537          	lui	a0,0x4000
    800011be:	157d                	addi	a0,a0,-1
    800011c0:	0532                	slli	a0,a0,0xc
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	ef4080e7          	jalr	-268(ra) # 800010b6 <kvmmap>
}
    800011ca:	60e2                	ld	ra,24(sp)
    800011cc:	6442                	ld	s0,16(sp)
    800011ce:	64a2                	ld	s1,8(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <uvmunmap>:
{
    800011d4:	715d                	addi	sp,sp,-80
    800011d6:	e486                	sd	ra,72(sp)
    800011d8:	e0a2                	sd	s0,64(sp)
    800011da:	fc26                	sd	s1,56(sp)
    800011dc:	f84a                	sd	s2,48(sp)
    800011de:	f44e                	sd	s3,40(sp)
    800011e0:	f052                	sd	s4,32(sp)
    800011e2:	ec56                	sd	s5,24(sp)
    800011e4:	e85a                	sd	s6,16(sp)
    800011e6:	e45e                	sd	s7,8(sp)
    800011e8:	0880                	addi	s0,sp,80
    800011ea:	8a2a                	mv	s4,a0
    800011ec:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011ee:	77fd                	lui	a5,0xfffff
    800011f0:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011f4:	167d                	addi	a2,a2,-1
    800011f6:	00b609b3          	add	s3,a2,a1
    800011fa:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011fe:	4b05                	li	s6,1
    a += PGSIZE;
    80001200:	6b85                	lui	s7,0x1
    80001202:	a8b1                	j	8000125e <uvmunmap+0x8a>
      panic("uvmunmap: walk");
    80001204:	00006517          	auipc	a0,0x6
    80001208:	fe450513          	addi	a0,a0,-28 # 800071e8 <userret+0x158>
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	342080e7          	jalr	834(ra) # 8000054e <panic>
      printf("va=%p pte=%p\n", a, *pte);
    80001214:	862a                	mv	a2,a0
    80001216:	85ca                	mv	a1,s2
    80001218:	00006517          	auipc	a0,0x6
    8000121c:	fe050513          	addi	a0,a0,-32 # 800071f8 <userret+0x168>
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	378080e7          	jalr	888(ra) # 80000598 <printf>
      panic("uvmunmap: not mapped");
    80001228:	00006517          	auipc	a0,0x6
    8000122c:	fe050513          	addi	a0,a0,-32 # 80007208 <userret+0x178>
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	31e080e7          	jalr	798(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    80001238:	00006517          	auipc	a0,0x6
    8000123c:	fe850513          	addi	a0,a0,-24 # 80007220 <userret+0x190>
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	30e080e7          	jalr	782(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001248:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000124a:	0532                	slli	a0,a0,0xc
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	618080e7          	jalr	1560(ra) # 80000864 <kfree>
    *pte = 0;
    80001254:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001258:	03390763          	beq	s2,s3,80001286 <uvmunmap+0xb2>
    a += PGSIZE;
    8000125c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    8000125e:	4601                	li	a2,0
    80001260:	85ca                	mv	a1,s2
    80001262:	8552                	mv	a0,s4
    80001264:	00000097          	auipc	ra,0x0
    80001268:	bfc080e7          	jalr	-1028(ra) # 80000e60 <walk>
    8000126c:	84aa                	mv	s1,a0
    8000126e:	d959                	beqz	a0,80001204 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    80001270:	6108                	ld	a0,0(a0)
    80001272:	00157793          	andi	a5,a0,1
    80001276:	dfd9                	beqz	a5,80001214 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001278:	01f57793          	andi	a5,a0,31
    8000127c:	fb678ee3          	beq	a5,s6,80001238 <uvmunmap+0x64>
    if(do_free){
    80001280:	fc0a8ae3          	beqz	s5,80001254 <uvmunmap+0x80>
    80001284:	b7d1                	j	80001248 <uvmunmap+0x74>
}
    80001286:	60a6                	ld	ra,72(sp)
    80001288:	6406                	ld	s0,64(sp)
    8000128a:	74e2                	ld	s1,56(sp)
    8000128c:	7942                	ld	s2,48(sp)
    8000128e:	79a2                	ld	s3,40(sp)
    80001290:	7a02                	ld	s4,32(sp)
    80001292:	6ae2                	ld	s5,24(sp)
    80001294:	6b42                	ld	s6,16(sp)
    80001296:	6ba2                	ld	s7,8(sp)
    80001298:	6161                	addi	sp,sp,80
    8000129a:	8082                	ret

000000008000129c <uvmcreate>:
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    800012a6:	fffff097          	auipc	ra,0xfffff
    800012aa:	6ba080e7          	jalr	1722(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    800012ae:	cd11                	beqz	a0,800012ca <uvmcreate+0x2e>
    800012b0:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    800012b2:	6605                	lui	a2,0x1
    800012b4:	4581                	li	a1,0
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	8e0080e7          	jalr	-1824(ra) # 80000b96 <memset>
}
    800012be:	8526                	mv	a0,s1
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret
    panic("uvmcreate: out of memory");
    800012ca:	00006517          	auipc	a0,0x6
    800012ce:	f6e50513          	addi	a0,a0,-146 # 80007238 <userret+0x1a8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	27c080e7          	jalr	636(ra) # 8000054e <panic>

00000000800012da <uvminit>:
{
    800012da:	7179                	addi	sp,sp,-48
    800012dc:	f406                	sd	ra,40(sp)
    800012de:	f022                	sd	s0,32(sp)
    800012e0:	ec26                	sd	s1,24(sp)
    800012e2:	e84a                	sd	s2,16(sp)
    800012e4:	e44e                	sd	s3,8(sp)
    800012e6:	e052                	sd	s4,0(sp)
    800012e8:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012ea:	6785                	lui	a5,0x1
    800012ec:	04f67863          	bgeu	a2,a5,8000133c <uvminit+0x62>
    800012f0:	8a2a                	mv	s4,a0
    800012f2:	89ae                	mv	s3,a1
    800012f4:	84b2                	mv	s1,a2
  mem = kalloc();
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	66a080e7          	jalr	1642(ra) # 80000960 <kalloc>
    800012fe:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001300:	6605                	lui	a2,0x1
    80001302:	4581                	li	a1,0
    80001304:	00000097          	auipc	ra,0x0
    80001308:	892080e7          	jalr	-1902(ra) # 80000b96 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000130c:	4779                	li	a4,30
    8000130e:	86ca                	mv	a3,s2
    80001310:	6605                	lui	a2,0x1
    80001312:	4581                	li	a1,0
    80001314:	8552                	mv	a0,s4
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	d12080e7          	jalr	-750(ra) # 80001028 <mappages>
  memmove(mem, src, sz);
    8000131e:	8626                	mv	a2,s1
    80001320:	85ce                	mv	a1,s3
    80001322:	854a                	mv	a0,s2
    80001324:	00000097          	auipc	ra,0x0
    80001328:	8d2080e7          	jalr	-1838(ra) # 80000bf6 <memmove>
}
    8000132c:	70a2                	ld	ra,40(sp)
    8000132e:	7402                	ld	s0,32(sp)
    80001330:	64e2                	ld	s1,24(sp)
    80001332:	6942                	ld	s2,16(sp)
    80001334:	69a2                	ld	s3,8(sp)
    80001336:	6a02                	ld	s4,0(sp)
    80001338:	6145                	addi	sp,sp,48
    8000133a:	8082                	ret
    panic("inituvm: more than a page");
    8000133c:	00006517          	auipc	a0,0x6
    80001340:	f1c50513          	addi	a0,a0,-228 # 80007258 <userret+0x1c8>
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	20a080e7          	jalr	522(ra) # 8000054e <panic>

000000008000134c <uvmdealloc>:
{
    8000134c:	87aa                	mv	a5,a0
    8000134e:	852e                	mv	a0,a1
  if(newsz >= oldsz)
    80001350:	00b66363          	bltu	a2,a1,80001356 <uvmdealloc+0xa>
}
    80001354:	8082                	ret
{
    80001356:	1101                	addi	sp,sp,-32
    80001358:	ec06                	sd	ra,24(sp)
    8000135a:	e822                	sd	s0,16(sp)
    8000135c:	e426                	sd	s1,8(sp)
    8000135e:	1000                	addi	s0,sp,32
    80001360:	84b2                	mv	s1,a2
  uvmunmap(pagetable, newsz, oldsz - newsz, 1);
    80001362:	4685                	li	a3,1
    80001364:	40c58633          	sub	a2,a1,a2
    80001368:	85a6                	mv	a1,s1
    8000136a:	853e                	mv	a0,a5
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	e68080e7          	jalr	-408(ra) # 800011d4 <uvmunmap>
  return newsz;
    80001374:	8526                	mv	a0,s1
}
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	64a2                	ld	s1,8(sp)
    8000137c:	6105                	addi	sp,sp,32
    8000137e:	8082                	ret

0000000080001380 <uvmalloc>:
  if(newsz < oldsz)
    80001380:	0ab66163          	bltu	a2,a1,80001422 <uvmalloc+0xa2>
{
    80001384:	7139                	addi	sp,sp,-64
    80001386:	fc06                	sd	ra,56(sp)
    80001388:	f822                	sd	s0,48(sp)
    8000138a:	f426                	sd	s1,40(sp)
    8000138c:	f04a                	sd	s2,32(sp)
    8000138e:	ec4e                	sd	s3,24(sp)
    80001390:	e852                	sd	s4,16(sp)
    80001392:	e456                	sd	s5,8(sp)
    80001394:	0080                	addi	s0,sp,64
    80001396:	8aaa                	mv	s5,a0
    80001398:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000139a:	6985                	lui	s3,0x1
    8000139c:	19fd                	addi	s3,s3,-1
    8000139e:	95ce                	add	a1,a1,s3
    800013a0:	79fd                	lui	s3,0xfffff
    800013a2:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    800013a6:	08c9f063          	bgeu	s3,a2,80001426 <uvmalloc+0xa6>
  a = oldsz;
    800013aa:	894e                	mv	s2,s3
    mem = kalloc();
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	5b4080e7          	jalr	1460(ra) # 80000960 <kalloc>
    800013b4:	84aa                	mv	s1,a0
    if(mem == 0){
    800013b6:	c51d                	beqz	a0,800013e4 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013b8:	6605                	lui	a2,0x1
    800013ba:	4581                	li	a1,0
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	7da080e7          	jalr	2010(ra) # 80000b96 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800013c4:	4779                	li	a4,30
    800013c6:	86a6                	mv	a3,s1
    800013c8:	6605                	lui	a2,0x1
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	c5a080e7          	jalr	-934(ra) # 80001028 <mappages>
    800013d6:	e905                	bnez	a0,80001406 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013d8:	6785                	lui	a5,0x1
    800013da:	993e                	add	s2,s2,a5
    800013dc:	fd4968e3          	bltu	s2,s4,800013ac <uvmalloc+0x2c>
  return newsz;
    800013e0:	8552                	mv	a0,s4
    800013e2:	a809                	j	800013f4 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013e4:	864e                	mv	a2,s3
    800013e6:	85ca                	mv	a1,s2
    800013e8:	8556                	mv	a0,s5
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	f62080e7          	jalr	-158(ra) # 8000134c <uvmdealloc>
      return 0;
    800013f2:	4501                	li	a0,0
}
    800013f4:	70e2                	ld	ra,56(sp)
    800013f6:	7442                	ld	s0,48(sp)
    800013f8:	74a2                	ld	s1,40(sp)
    800013fa:	7902                	ld	s2,32(sp)
    800013fc:	69e2                	ld	s3,24(sp)
    800013fe:	6a42                	ld	s4,16(sp)
    80001400:	6aa2                	ld	s5,8(sp)
    80001402:	6121                	addi	sp,sp,64
    80001404:	8082                	ret
      kfree(mem);
    80001406:	8526                	mv	a0,s1
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	45c080e7          	jalr	1116(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001410:	864e                	mv	a2,s3
    80001412:	85ca                	mv	a1,s2
    80001414:	8556                	mv	a0,s5
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	f36080e7          	jalr	-202(ra) # 8000134c <uvmdealloc>
      return 0;
    8000141e:	4501                	li	a0,0
    80001420:	bfd1                	j	800013f4 <uvmalloc+0x74>
    return oldsz;
    80001422:	852e                	mv	a0,a1
}
    80001424:	8082                	ret
  return newsz;
    80001426:	8532                	mv	a0,a2
    80001428:	b7f1                	j	800013f4 <uvmalloc+0x74>

000000008000142a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000142a:	1101                	addi	sp,sp,-32
    8000142c:	ec06                	sd	ra,24(sp)
    8000142e:	e822                	sd	s0,16(sp)
    80001430:	e426                	sd	s1,8(sp)
    80001432:	1000                	addi	s0,sp,32
    80001434:	84aa                	mv	s1,a0
    80001436:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001438:	4685                	li	a3,1
    8000143a:	4581                	li	a1,0
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	d98080e7          	jalr	-616(ra) # 800011d4 <uvmunmap>
  freewalk(pagetable);
    80001444:	8526                	mv	a0,s1
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	ac0080e7          	jalr	-1344(ra) # 80000f06 <freewalk>
}
    8000144e:	60e2                	ld	ra,24(sp)
    80001450:	6442                	ld	s0,16(sp)
    80001452:	64a2                	ld	s1,8(sp)
    80001454:	6105                	addi	sp,sp,32
    80001456:	8082                	ret

0000000080001458 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001458:	c671                	beqz	a2,80001524 <uvmcopy+0xcc>
{
    8000145a:	715d                	addi	sp,sp,-80
    8000145c:	e486                	sd	ra,72(sp)
    8000145e:	e0a2                	sd	s0,64(sp)
    80001460:	fc26                	sd	s1,56(sp)
    80001462:	f84a                	sd	s2,48(sp)
    80001464:	f44e                	sd	s3,40(sp)
    80001466:	f052                	sd	s4,32(sp)
    80001468:	ec56                	sd	s5,24(sp)
    8000146a:	e85a                	sd	s6,16(sp)
    8000146c:	e45e                	sd	s7,8(sp)
    8000146e:	0880                	addi	s0,sp,80
    80001470:	8b2a                	mv	s6,a0
    80001472:	8aae                	mv	s5,a1
    80001474:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001476:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001478:	4601                	li	a2,0
    8000147a:	85ce                	mv	a1,s3
    8000147c:	855a                	mv	a0,s6
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	9e2080e7          	jalr	-1566(ra) # 80000e60 <walk>
    80001486:	c531                	beqz	a0,800014d2 <uvmcopy+0x7a>
      panic("copyuvm: pte should exist");
    if((*pte & PTE_V) == 0)
    80001488:	6118                	ld	a4,0(a0)
    8000148a:	00177793          	andi	a5,a4,1
    8000148e:	cbb1                	beqz	a5,800014e2 <uvmcopy+0x8a>
      panic("copyuvm: page not present");
    pa = PTE2PA(*pte);
    80001490:	00a75593          	srli	a1,a4,0xa
    80001494:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001498:	01f77493          	andi	s1,a4,31
    if((mem = kalloc()) == 0)
    8000149c:	fffff097          	auipc	ra,0xfffff
    800014a0:	4c4080e7          	jalr	1220(ra) # 80000960 <kalloc>
    800014a4:	892a                	mv	s2,a0
    800014a6:	c939                	beqz	a0,800014fc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014a8:	6605                	lui	a2,0x1
    800014aa:	85de                	mv	a1,s7
    800014ac:	fffff097          	auipc	ra,0xfffff
    800014b0:	74a080e7          	jalr	1866(ra) # 80000bf6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014b4:	8726                	mv	a4,s1
    800014b6:	86ca                	mv	a3,s2
    800014b8:	6605                	lui	a2,0x1
    800014ba:	85ce                	mv	a1,s3
    800014bc:	8556                	mv	a0,s5
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	b6a080e7          	jalr	-1174(ra) # 80001028 <mappages>
    800014c6:	e515                	bnez	a0,800014f2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014c8:	6785                	lui	a5,0x1
    800014ca:	99be                	add	s3,s3,a5
    800014cc:	fb49e6e3          	bltu	s3,s4,80001478 <uvmcopy+0x20>
    800014d0:	a83d                	j	8000150e <uvmcopy+0xb6>
      panic("copyuvm: pte should exist");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	da650513          	addi	a0,a0,-602 # 80007278 <userret+0x1e8>
    800014da:	fffff097          	auipc	ra,0xfffff
    800014de:	074080e7          	jalr	116(ra) # 8000054e <panic>
      panic("copyuvm: page not present");
    800014e2:	00006517          	auipc	a0,0x6
    800014e6:	db650513          	addi	a0,a0,-586 # 80007298 <userret+0x208>
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	064080e7          	jalr	100(ra) # 8000054e <panic>
      kfree(mem);
    800014f2:	854a                	mv	a0,s2
    800014f4:	fffff097          	auipc	ra,0xfffff
    800014f8:	370080e7          	jalr	880(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800014fc:	4685                	li	a3,1
    800014fe:	864e                	mv	a2,s3
    80001500:	4581                	li	a1,0
    80001502:	8556                	mv	a0,s5
    80001504:	00000097          	auipc	ra,0x0
    80001508:	cd0080e7          	jalr	-816(ra) # 800011d4 <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	00000097          	auipc	ra,0x0
    80001536:	92e080e7          	jalr	-1746(ra) # 80000e60 <walk>
  if(pte == 0)
    8000153a:	c901                	beqz	a0,8000154a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000153c:	611c                	ld	a5,0(a0)
    8000153e:	9bbd                	andi	a5,a5,-17
    80001540:	e11c                	sd	a5,0(a0)
}
    80001542:	60a2                	ld	ra,8(sp)
    80001544:	6402                	ld	s0,0(sp)
    80001546:	0141                	addi	sp,sp,16
    80001548:	8082                	ret
    panic("uvmclear");
    8000154a:	00006517          	auipc	a0,0x6
    8000154e:	d6e50513          	addi	a0,a0,-658 # 800072b8 <userret+0x228>
    80001552:	fffff097          	auipc	ra,0xfffff
    80001556:	ffc080e7          	jalr	-4(ra) # 8000054e <panic>

000000008000155a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000155a:	cab5                	beqz	a3,800015ce <copyout+0x74>
{
    8000155c:	715d                	addi	sp,sp,-80
    8000155e:	e486                	sd	ra,72(sp)
    80001560:	e0a2                	sd	s0,64(sp)
    80001562:	fc26                	sd	s1,56(sp)
    80001564:	f84a                	sd	s2,48(sp)
    80001566:	f44e                	sd	s3,40(sp)
    80001568:	f052                	sd	s4,32(sp)
    8000156a:	ec56                	sd	s5,24(sp)
    8000156c:	e85a                	sd	s6,16(sp)
    8000156e:	e45e                	sd	s7,8(sp)
    80001570:	e062                	sd	s8,0(sp)
    80001572:	0880                	addi	s0,sp,80
    80001574:	8baa                	mv	s7,a0
    80001576:	8c2e                	mv	s8,a1
    80001578:	8a32                	mv	s4,a2
    8000157a:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(dstva);
    8000157c:	00100b37          	lui	s6,0x100
    80001580:	1b7d                	addi	s6,s6,-1
    80001582:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001584:	6a85                	lui	s5,0x1
    80001586:	a015                	j	800015aa <copyout+0x50>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001588:	9562                	add	a0,a0,s8
    8000158a:	0004861b          	sext.w	a2,s1
    8000158e:	85d2                	mv	a1,s4
    80001590:	41250533          	sub	a0,a0,s2
    80001594:	fffff097          	auipc	ra,0xfffff
    80001598:	662080e7          	jalr	1634(ra) # 80000bf6 <memmove>

    len -= n;
    8000159c:	409989b3          	sub	s3,s3,s1
    src += n;
    800015a0:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800015a2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015a6:	02098263          	beqz	s3,800015ca <copyout+0x70>
    va0 = (uint)PGROUNDDOWN(dstva);
    800015aa:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    800015ae:	85ca                	mv	a1,s2
    800015b0:	855e                	mv	a0,s7
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	9e2080e7          	jalr	-1566(ra) # 80000f94 <walkaddr>
    if(pa0 == 0)
    800015ba:	cd01                	beqz	a0,800015d2 <copyout+0x78>
    n = PGSIZE - (dstva - va0);
    800015bc:	418904b3          	sub	s1,s2,s8
    800015c0:	94d6                	add	s1,s1,s5
    if(n > len)
    800015c2:	fc99f3e3          	bgeu	s3,s1,80001588 <copyout+0x2e>
    800015c6:	84ce                	mv	s1,s3
    800015c8:	b7c1                	j	80001588 <copyout+0x2e>
  }
  return 0;
    800015ca:	4501                	li	a0,0
    800015cc:	a021                	j	800015d4 <copyout+0x7a>
    800015ce:	4501                	li	a0,0
}
    800015d0:	8082                	ret
      return -1;
    800015d2:	557d                	li	a0,-1
}
    800015d4:	60a6                	ld	ra,72(sp)
    800015d6:	6406                	ld	s0,64(sp)
    800015d8:	74e2                	ld	s1,56(sp)
    800015da:	7942                	ld	s2,48(sp)
    800015dc:	79a2                	ld	s3,40(sp)
    800015de:	7a02                	ld	s4,32(sp)
    800015e0:	6ae2                	ld	s5,24(sp)
    800015e2:	6b42                	ld	s6,16(sp)
    800015e4:	6ba2                	ld	s7,8(sp)
    800015e6:	6c02                	ld	s8,0(sp)
    800015e8:	6161                	addi	sp,sp,80
    800015ea:	8082                	ret

00000000800015ec <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015ec:	cab5                	beqz	a3,80001660 <copyin+0x74>
{
    800015ee:	715d                	addi	sp,sp,-80
    800015f0:	e486                	sd	ra,72(sp)
    800015f2:	e0a2                	sd	s0,64(sp)
    800015f4:	fc26                	sd	s1,56(sp)
    800015f6:	f84a                	sd	s2,48(sp)
    800015f8:	f44e                	sd	s3,40(sp)
    800015fa:	f052                	sd	s4,32(sp)
    800015fc:	ec56                	sd	s5,24(sp)
    800015fe:	e85a                	sd	s6,16(sp)
    80001600:	e45e                	sd	s7,8(sp)
    80001602:	e062                	sd	s8,0(sp)
    80001604:	0880                	addi	s0,sp,80
    80001606:	8baa                	mv	s7,a0
    80001608:	8a2e                	mv	s4,a1
    8000160a:	8c32                	mv	s8,a2
    8000160c:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    8000160e:	00100b37          	lui	s6,0x100
    80001612:	1b7d                	addi	s6,s6,-1
    80001614:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001616:	6a85                	lui	s5,0x1
    80001618:	a015                	j	8000163c <copyin+0x50>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000161a:	9562                	add	a0,a0,s8
    8000161c:	0004861b          	sext.w	a2,s1
    80001620:	412505b3          	sub	a1,a0,s2
    80001624:	8552                	mv	a0,s4
    80001626:	fffff097          	auipc	ra,0xfffff
    8000162a:	5d0080e7          	jalr	1488(ra) # 80000bf6 <memmove>

    len -= n;
    8000162e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001632:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001634:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001638:	02098263          	beqz	s3,8000165c <copyin+0x70>
    va0 = (uint)PGROUNDDOWN(srcva);
    8000163c:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    80001640:	85ca                	mv	a1,s2
    80001642:	855e                	mv	a0,s7
    80001644:	00000097          	auipc	ra,0x0
    80001648:	950080e7          	jalr	-1712(ra) # 80000f94 <walkaddr>
    if(pa0 == 0)
    8000164c:	cd01                	beqz	a0,80001664 <copyin+0x78>
    n = PGSIZE - (srcva - va0);
    8000164e:	418904b3          	sub	s1,s2,s8
    80001652:	94d6                	add	s1,s1,s5
    if(n > len)
    80001654:	fc99f3e3          	bgeu	s3,s1,8000161a <copyin+0x2e>
    80001658:	84ce                	mv	s1,s3
    8000165a:	b7c1                	j	8000161a <copyin+0x2e>
  }
  return 0;
    8000165c:	4501                	li	a0,0
    8000165e:	a021                	j	80001666 <copyin+0x7a>
    80001660:	4501                	li	a0,0
}
    80001662:	8082                	ret
      return -1;
    80001664:	557d                	li	a0,-1
}
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6c02                	ld	s8,0(sp)
    8000167a:	6161                	addi	sp,sp,80
    8000167c:	8082                	ret

000000008000167e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000167e:	c6dd                	beqz	a3,8000172c <copyinstr+0xae>
{
    80001680:	715d                	addi	sp,sp,-80
    80001682:	e486                	sd	ra,72(sp)
    80001684:	e0a2                	sd	s0,64(sp)
    80001686:	fc26                	sd	s1,56(sp)
    80001688:	f84a                	sd	s2,48(sp)
    8000168a:	f44e                	sd	s3,40(sp)
    8000168c:	f052                	sd	s4,32(sp)
    8000168e:	ec56                	sd	s5,24(sp)
    80001690:	e85a                	sd	s6,16(sp)
    80001692:	e45e                	sd	s7,8(sp)
    80001694:	0880                	addi	s0,sp,80
    80001696:	8aaa                	mv	s5,a0
    80001698:	8b2e                	mv	s6,a1
    8000169a:	8bb2                	mv	s7,a2
    8000169c:	84b6                	mv	s1,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    8000169e:	00100a37          	lui	s4,0x100
    800016a2:	1a7d                	addi	s4,s4,-1
    800016a4:	0a32                	slli	s4,s4,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016a6:	6985                	lui	s3,0x1
    800016a8:	a035                	j	800016d4 <copyinstr+0x56>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016aa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016ae:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016b0:	0017b793          	seqz	a5,a5
    800016b4:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016b8:	60a6                	ld	ra,72(sp)
    800016ba:	6406                	ld	s0,64(sp)
    800016bc:	74e2                	ld	s1,56(sp)
    800016be:	7942                	ld	s2,48(sp)
    800016c0:	79a2                	ld	s3,40(sp)
    800016c2:	7a02                	ld	s4,32(sp)
    800016c4:	6ae2                	ld	s5,24(sp)
    800016c6:	6b42                	ld	s6,16(sp)
    800016c8:	6ba2                	ld	s7,8(sp)
    800016ca:	6161                	addi	sp,sp,80
    800016cc:	8082                	ret
    srcva = va0 + PGSIZE;
    800016ce:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800016d2:	c8a9                	beqz	s1,80001724 <copyinstr+0xa6>
    va0 = (uint)PGROUNDDOWN(srcva);
    800016d4:	014bf933          	and	s2,s7,s4
    pa0 = walkaddr(pagetable, va0);
    800016d8:	85ca                	mv	a1,s2
    800016da:	8556                	mv	a0,s5
    800016dc:	00000097          	auipc	ra,0x0
    800016e0:	8b8080e7          	jalr	-1864(ra) # 80000f94 <walkaddr>
    if(pa0 == 0)
    800016e4:	c131                	beqz	a0,80001728 <copyinstr+0xaa>
    n = PGSIZE - (srcva - va0);
    800016e6:	41790833          	sub	a6,s2,s7
    800016ea:	984e                	add	a6,a6,s3
    if(n > max)
    800016ec:	0104f363          	bgeu	s1,a6,800016f2 <copyinstr+0x74>
    800016f0:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016f2:	955e                	add	a0,a0,s7
    800016f4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016f8:	fc080be3          	beqz	a6,800016ce <copyinstr+0x50>
    800016fc:	985a                	add	a6,a6,s6
    800016fe:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001700:	41650633          	sub	a2,a0,s6
    80001704:	14fd                	addi	s1,s1,-1
    80001706:	9b26                	add	s6,s6,s1
    80001708:	00f60733          	add	a4,a2,a5
    8000170c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <ticks+0xffffffff7ffd5fd8>
    80001710:	df49                	beqz	a4,800016aa <copyinstr+0x2c>
        *dst = *p;
    80001712:	00e78023          	sb	a4,0(a5)
      --max;
    80001716:	40fb04b3          	sub	s1,s6,a5
      dst++;
    8000171a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000171c:	ff0796e3          	bne	a5,a6,80001708 <copyinstr+0x8a>
      dst++;
    80001720:	8b42                	mv	s6,a6
    80001722:	b775                	j	800016ce <copyinstr+0x50>
    80001724:	4781                	li	a5,0
    80001726:	b769                	j	800016b0 <copyinstr+0x32>
      return -1;
    80001728:	557d                	li	a0,-1
    8000172a:	b779                	j	800016b8 <copyinstr+0x3a>
  int got_null = 0;
    8000172c:	4781                	li	a5,0
  if(got_null){
    8000172e:	0017b793          	seqz	a5,a5
    80001732:	40f00533          	neg	a0,a5
}
    80001736:	8082                	ret

0000000080001738 <procinit>:

extern char trampoline[]; // trampoline.S

void
procinit(void)
{
    80001738:	715d                	addi	sp,sp,-80
    8000173a:	e486                	sd	ra,72(sp)
    8000173c:	e0a2                	sd	s0,64(sp)
    8000173e:	fc26                	sd	s1,56(sp)
    80001740:	f84a                	sd	s2,48(sp)
    80001742:	f44e                	sd	s3,40(sp)
    80001744:	f052                	sd	s4,32(sp)
    80001746:	ec56                	sd	s5,24(sp)
    80001748:	e85a                	sd	s6,16(sp)
    8000174a:	e45e                	sd	s7,8(sp)
    8000174c:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000174e:	00006597          	auipc	a1,0x6
    80001752:	b7a58593          	addi	a1,a1,-1158 # 800072c8 <userret+0x238>
    80001756:	00010517          	auipc	a0,0x10
    8000175a:	19250513          	addi	a0,a0,402 # 800118e8 <pid_lock>
    8000175e:	fffff097          	auipc	ra,0xfffff
    80001762:	262080e7          	jalr	610(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001766:	00010917          	auipc	s2,0x10
    8000176a:	59a90913          	addi	s2,s2,1434 # 80011d00 <proc>
      initlock(&p->lock, "proc");
    8000176e:	00006b97          	auipc	s7,0x6
    80001772:	b62b8b93          	addi	s7,s7,-1182 # 800072d0 <userret+0x240>
      // Map it high in memory, followed by an invalid
      // guard page.
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc));
    80001776:	8b4a                	mv	s6,s2
    80001778:	00006a97          	auipc	s5,0x6
    8000177c:	250a8a93          	addi	s5,s5,592 # 800079c8 <syscalls+0xc0>
    80001780:	040009b7          	lui	s3,0x4000
    80001784:	19fd                	addi	s3,s3,-1
    80001786:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001788:	00016a17          	auipc	s4,0x16
    8000178c:	d78a0a13          	addi	s4,s4,-648 # 80017500 <tickslock>
      initlock(&p->lock, "proc");
    80001790:	85de                	mv	a1,s7
    80001792:	854a                	mv	a0,s2
    80001794:	fffff097          	auipc	ra,0xfffff
    80001798:	22c080e7          	jalr	556(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    8000179c:	fffff097          	auipc	ra,0xfffff
    800017a0:	1c4080e7          	jalr	452(ra) # 80000960 <kalloc>
    800017a4:	85aa                	mv	a1,a0
      if(pa == 0)
    800017a6:	c929                	beqz	a0,800017f8 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800017a8:	416904b3          	sub	s1,s2,s6
    800017ac:	8495                	srai	s1,s1,0x5
    800017ae:	000ab783          	ld	a5,0(s5)
    800017b2:	02f484b3          	mul	s1,s1,a5
    800017b6:	2485                	addiw	s1,s1,1
    800017b8:	00d4949b          	slliw	s1,s1,0xd
    800017bc:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c0:	4699                	li	a3,6
    800017c2:	6605                	lui	a2,0x1
    800017c4:	8526                	mv	a0,s1
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	8f0080e7          	jalr	-1808(ra) # 800010b6 <kvmmap>
      p->kstack = va;
    800017ce:	02993c23          	sd	s1,56(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d2:	16090913          	addi	s2,s2,352
    800017d6:	fb491de3          	bne	s2,s4,80001790 <procinit+0x58>
  }
  kvminithart();
    800017da:	fffff097          	auipc	ra,0xfffff
    800017de:	796080e7          	jalr	1942(ra) # 80000f70 <kvminithart>
}
    800017e2:	60a6                	ld	ra,72(sp)
    800017e4:	6406                	ld	s0,64(sp)
    800017e6:	74e2                	ld	s1,56(sp)
    800017e8:	7942                	ld	s2,48(sp)
    800017ea:	79a2                	ld	s3,40(sp)
    800017ec:	7a02                	ld	s4,32(sp)
    800017ee:	6ae2                	ld	s5,24(sp)
    800017f0:	6b42                	ld	s6,16(sp)
    800017f2:	6ba2                	ld	s7,8(sp)
    800017f4:	6161                	addi	sp,sp,80
    800017f6:	8082                	ret
        panic("kalloc");
    800017f8:	00006517          	auipc	a0,0x6
    800017fc:	ae050513          	addi	a0,a0,-1312 # 800072d8 <userret+0x248>
    80001800:	fffff097          	auipc	ra,0xfffff
    80001804:	d4e080e7          	jalr	-690(ra) # 8000054e <panic>

0000000080001808 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001808:	1141                	addi	sp,sp,-16
    8000180a:	e422                	sd	s0,8(sp)
    8000180c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000180e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001810:	2501                	sext.w	a0,a0
    80001812:	6422                	ld	s0,8(sp)
    80001814:	0141                	addi	sp,sp,16
    80001816:	8082                	ret

0000000080001818 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001818:	1141                	addi	sp,sp,-16
    8000181a:	e422                	sd	s0,8(sp)
    8000181c:	0800                	addi	s0,sp,16
    8000181e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001820:	2781                	sext.w	a5,a5
    80001822:	079e                	slli	a5,a5,0x7
  return c;
}
    80001824:	00010517          	auipc	a0,0x10
    80001828:	0dc50513          	addi	a0,a0,220 # 80011900 <cpus>
    8000182c:	953e                	add	a0,a0,a5
    8000182e:	6422                	ld	s0,8(sp)
    80001830:	0141                	addi	sp,sp,16
    80001832:	8082                	ret

0000000080001834 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001834:	1101                	addi	sp,sp,-32
    80001836:	ec06                	sd	ra,24(sp)
    80001838:	e822                	sd	s0,16(sp)
    8000183a:	e426                	sd	s1,8(sp)
    8000183c:	1000                	addi	s0,sp,32
  push_off();
    8000183e:	fffff097          	auipc	ra,0xfffff
    80001842:	198080e7          	jalr	408(ra) # 800009d6 <push_off>
    80001846:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001848:	2781                	sext.w	a5,a5
    8000184a:	079e                	slli	a5,a5,0x7
    8000184c:	00010717          	auipc	a4,0x10
    80001850:	09c70713          	addi	a4,a4,156 # 800118e8 <pid_lock>
    80001854:	97ba                	add	a5,a5,a4
    80001856:	6f84                	ld	s1,24(a5)
  pop_off();
    80001858:	fffff097          	auipc	ra,0xfffff
    8000185c:	1ca080e7          	jalr	458(ra) # 80000a22 <pop_off>
  return p;
}
    80001860:	8526                	mv	a0,s1
    80001862:	60e2                	ld	ra,24(sp)
    80001864:	6442                	ld	s0,16(sp)
    80001866:	64a2                	ld	s1,8(sp)
    80001868:	6105                	addi	sp,sp,32
    8000186a:	8082                	ret

000000008000186c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000186c:	1141                	addi	sp,sp,-16
    8000186e:	e406                	sd	ra,8(sp)
    80001870:	e022                	sd	s0,0(sp)
    80001872:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001874:	00000097          	auipc	ra,0x0
    80001878:	fc0080e7          	jalr	-64(ra) # 80001834 <myproc>
    8000187c:	fffff097          	auipc	ra,0xfffff
    80001880:	2be080e7          	jalr	702(ra) # 80000b3a <release>

  if (first) {
    80001884:	00006797          	auipc	a5,0x6
    80001888:	7d47a783          	lw	a5,2004(a5) # 80008058 <first.1719>
    8000188c:	eb89                	bnez	a5,8000189e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(minor(ROOTDEV));
  }

  usertrapret();
    8000188e:	00001097          	auipc	ra,0x1
    80001892:	bd8080e7          	jalr	-1064(ra) # 80002466 <usertrapret>
}
    80001896:	60a2                	ld	ra,8(sp)
    80001898:	6402                	ld	s0,0(sp)
    8000189a:	0141                	addi	sp,sp,16
    8000189c:	8082                	ret
    first = 0;
    8000189e:	00006797          	auipc	a5,0x6
    800018a2:	7a07ad23          	sw	zero,1978(a5) # 80008058 <first.1719>
    fsinit(minor(ROOTDEV));
    800018a6:	4501                	li	a0,0
    800018a8:	00002097          	auipc	ra,0x2
    800018ac:	8c8080e7          	jalr	-1848(ra) # 80003170 <fsinit>
    800018b0:	bff9                	j	8000188e <forkret+0x22>

00000000800018b2 <allocpid>:
allocpid() {
    800018b2:	1101                	addi	sp,sp,-32
    800018b4:	ec06                	sd	ra,24(sp)
    800018b6:	e822                	sd	s0,16(sp)
    800018b8:	e426                	sd	s1,8(sp)
    800018ba:	e04a                	sd	s2,0(sp)
    800018bc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018be:	00010917          	auipc	s2,0x10
    800018c2:	02a90913          	addi	s2,s2,42 # 800118e8 <pid_lock>
    800018c6:	854a                	mv	a0,s2
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	20a080e7          	jalr	522(ra) # 80000ad2 <acquire>
  pid = nextpid;
    800018d0:	00006797          	auipc	a5,0x6
    800018d4:	78c78793          	addi	a5,a5,1932 # 8000805c <nextpid>
    800018d8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018da:	0014871b          	addiw	a4,s1,1
    800018de:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018e0:	854a                	mv	a0,s2
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	258080e7          	jalr	600(ra) # 80000b3a <release>
}
    800018ea:	8526                	mv	a0,s1
    800018ec:	60e2                	ld	ra,24(sp)
    800018ee:	6442                	ld	s0,16(sp)
    800018f0:	64a2                	ld	s1,8(sp)
    800018f2:	6902                	ld	s2,0(sp)
    800018f4:	6105                	addi	sp,sp,32
    800018f6:	8082                	ret

00000000800018f8 <proc_pagetable>:
{
    800018f8:	1101                	addi	sp,sp,-32
    800018fa:	ec06                	sd	ra,24(sp)
    800018fc:	e822                	sd	s0,16(sp)
    800018fe:	e426                	sd	s1,8(sp)
    80001900:	e04a                	sd	s2,0(sp)
    80001902:	1000                	addi	s0,sp,32
    80001904:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	996080e7          	jalr	-1642(ra) # 8000129c <uvmcreate>
    8000190e:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001910:	4729                	li	a4,10
    80001912:	00005697          	auipc	a3,0x5
    80001916:	6ee68693          	addi	a3,a3,1774 # 80007000 <trampoline>
    8000191a:	6605                	lui	a2,0x1
    8000191c:	040005b7          	lui	a1,0x4000
    80001920:	15fd                	addi	a1,a1,-1
    80001922:	05b2                	slli	a1,a1,0xc
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	704080e7          	jalr	1796(ra) # 80001028 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    8000192c:	4719                	li	a4,6
    8000192e:	05093683          	ld	a3,80(s2)
    80001932:	6605                	lui	a2,0x1
    80001934:	020005b7          	lui	a1,0x2000
    80001938:	15fd                	addi	a1,a1,-1
    8000193a:	05b6                	slli	a1,a1,0xd
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	6ea080e7          	jalr	1770(ra) # 80001028 <mappages>
}
    80001946:	8526                	mv	a0,s1
    80001948:	60e2                	ld	ra,24(sp)
    8000194a:	6442                	ld	s0,16(sp)
    8000194c:	64a2                	ld	s1,8(sp)
    8000194e:	6902                	ld	s2,0(sp)
    80001950:	6105                	addi	sp,sp,32
    80001952:	8082                	ret

0000000080001954 <allocproc>:
{
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	e426                	sd	s1,8(sp)
    8000195c:	e04a                	sd	s2,0(sp)
    8000195e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001960:	00010497          	auipc	s1,0x10
    80001964:	3a048493          	addi	s1,s1,928 # 80011d00 <proc>
    80001968:	00016917          	auipc	s2,0x16
    8000196c:	b9890913          	addi	s2,s2,-1128 # 80017500 <tickslock>
    acquire(&p->lock);
    80001970:	8526                	mv	a0,s1
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	160080e7          	jalr	352(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    8000197a:	4c9c                	lw	a5,24(s1)
    8000197c:	cf81                	beqz	a5,80001994 <allocproc+0x40>
      release(&p->lock);
    8000197e:	8526                	mv	a0,s1
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	1ba080e7          	jalr	442(ra) # 80000b3a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001988:	16048493          	addi	s1,s1,352
    8000198c:	ff2492e3          	bne	s1,s2,80001970 <allocproc+0x1c>
  return 0;
    80001990:	4481                	li	s1,0
    80001992:	a0a9                	j	800019dc <allocproc+0x88>
  p->pid = allocpid();
    80001994:	00000097          	auipc	ra,0x0
    80001998:	f1e080e7          	jalr	-226(ra) # 800018b2 <allocpid>
    8000199c:	d8c8                	sw	a0,52(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	fc2080e7          	jalr	-62(ra) # 80000960 <kalloc>
    800019a6:	892a                	mv	s2,a0
    800019a8:	e8a8                	sd	a0,80(s1)
    800019aa:	c121                	beqz	a0,800019ea <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00000097          	auipc	ra,0x0
    800019b2:	f4a080e7          	jalr	-182(ra) # 800018f8 <proc_pagetable>
    800019b6:	e4a8                	sd	a0,72(s1)
  memset(&p->context, 0, sizeof p->context);
    800019b8:	07000613          	li	a2,112
    800019bc:	4581                	li	a1,0
    800019be:	05848513          	addi	a0,s1,88
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	1d4080e7          	jalr	468(ra) # 80000b96 <memset>
  p->context.ra = (uint64)forkret;
    800019ca:	00000797          	auipc	a5,0x0
    800019ce:	ea278793          	addi	a5,a5,-350 # 8000186c <forkret>
    800019d2:	ecbc                	sd	a5,88(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019d4:	7c9c                	ld	a5,56(s1)
    800019d6:	6705                	lui	a4,0x1
    800019d8:	97ba                	add	a5,a5,a4
    800019da:	f0bc                	sd	a5,96(s1)
}
    800019dc:	8526                	mv	a0,s1
    800019de:	60e2                	ld	ra,24(sp)
    800019e0:	6442                	ld	s0,16(sp)
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	6902                	ld	s2,0(sp)
    800019e6:	6105                	addi	sp,sp,32
    800019e8:	8082                	ret
    release(&p->lock);
    800019ea:	8526                	mv	a0,s1
    800019ec:	fffff097          	auipc	ra,0xfffff
    800019f0:	14e080e7          	jalr	334(ra) # 80000b3a <release>
    return 0;
    800019f4:	84ca                	mv	s1,s2
    800019f6:	b7dd                	j	800019dc <allocproc+0x88>

00000000800019f8 <proc_freepagetable>:
{
    800019f8:	1101                	addi	sp,sp,-32
    800019fa:	ec06                	sd	ra,24(sp)
    800019fc:	e822                	sd	s0,16(sp)
    800019fe:	e426                	sd	s1,8(sp)
    80001a00:	e04a                	sd	s2,0(sp)
    80001a02:	1000                	addi	s0,sp,32
    80001a04:	84aa                	mv	s1,a0
    80001a06:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001a08:	4681                	li	a3,0
    80001a0a:	6605                	lui	a2,0x1
    80001a0c:	040005b7          	lui	a1,0x4000
    80001a10:	15fd                	addi	a1,a1,-1
    80001a12:	05b2                	slli	a1,a1,0xc
    80001a14:	fffff097          	auipc	ra,0xfffff
    80001a18:	7c0080e7          	jalr	1984(ra) # 800011d4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001a1c:	4681                	li	a3,0
    80001a1e:	6605                	lui	a2,0x1
    80001a20:	020005b7          	lui	a1,0x2000
    80001a24:	15fd                	addi	a1,a1,-1
    80001a26:	05b6                	slli	a1,a1,0xd
    80001a28:	8526                	mv	a0,s1
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	7aa080e7          	jalr	1962(ra) # 800011d4 <uvmunmap>
  if(sz > 0)
    80001a32:	00091863          	bnez	s2,80001a42 <proc_freepagetable+0x4a>
}
    80001a36:	60e2                	ld	ra,24(sp)
    80001a38:	6442                	ld	s0,16(sp)
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	6902                	ld	s2,0(sp)
    80001a3e:	6105                	addi	sp,sp,32
    80001a40:	8082                	ret
    uvmfree(pagetable, sz);
    80001a42:	85ca                	mv	a1,s2
    80001a44:	8526                	mv	a0,s1
    80001a46:	00000097          	auipc	ra,0x0
    80001a4a:	9e4080e7          	jalr	-1564(ra) # 8000142a <uvmfree>
}
    80001a4e:	b7e5                	j	80001a36 <proc_freepagetable+0x3e>

0000000080001a50 <freeproc>:
{
    80001a50:	1101                	addi	sp,sp,-32
    80001a52:	ec06                	sd	ra,24(sp)
    80001a54:	e822                	sd	s0,16(sp)
    80001a56:	e426                	sd	s1,8(sp)
    80001a58:	1000                	addi	s0,sp,32
    80001a5a:	84aa                	mv	s1,a0
  if(p->tf)
    80001a5c:	6928                	ld	a0,80(a0)
    80001a5e:	c509                	beqz	a0,80001a68 <freeproc+0x18>
    kfree((void*)p->tf);
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	e04080e7          	jalr	-508(ra) # 80000864 <kfree>
  p->tf = 0;
    80001a68:	0404b823          	sd	zero,80(s1)
  if(p->pagetable)
    80001a6c:	64a8                	ld	a0,72(s1)
    80001a6e:	c511                	beqz	a0,80001a7a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001a70:	60ac                	ld	a1,64(s1)
    80001a72:	00000097          	auipc	ra,0x0
    80001a76:	f86080e7          	jalr	-122(ra) # 800019f8 <proc_freepagetable>
  p->pagetable = 0;
    80001a7a:	0404b423          	sd	zero,72(s1)
  p->sz = 0;
    80001a7e:	0404b023          	sd	zero,64(s1)
  p->pid = 0;
    80001a82:	0204aa23          	sw	zero,52(s1)
  p->parent = 0;
    80001a86:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001a8a:	14048823          	sb	zero,336(s1)
  p->chan = 0;
    80001a8e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001a92:	0204a823          	sw	zero,48(s1)
  p->state = UNUSED;
    80001a96:	0004ac23          	sw	zero,24(s1)
}
    80001a9a:	60e2                	ld	ra,24(sp)
    80001a9c:	6442                	ld	s0,16(sp)
    80001a9e:	64a2                	ld	s1,8(sp)
    80001aa0:	6105                	addi	sp,sp,32
    80001aa2:	8082                	ret

0000000080001aa4 <userinit>:
{
    80001aa4:	1101                	addi	sp,sp,-32
    80001aa6:	ec06                	sd	ra,24(sp)
    80001aa8:	e822                	sd	s0,16(sp)
    80001aaa:	e426                	sd	s1,8(sp)
    80001aac:	1000                	addi	s0,sp,32
  p = allocproc();
    80001aae:	00000097          	auipc	ra,0x0
    80001ab2:	ea6080e7          	jalr	-346(ra) # 80001954 <allocproc>
    80001ab6:	84aa                	mv	s1,a0
  initproc = p;
    80001ab8:	00027797          	auipc	a5,0x27
    80001abc:	56a7b423          	sd	a0,1384(a5) # 80029020 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ac0:	03300613          	li	a2,51
    80001ac4:	00006597          	auipc	a1,0x6
    80001ac8:	53c58593          	addi	a1,a1,1340 # 80008000 <initcode>
    80001acc:	6528                	ld	a0,72(a0)
    80001ace:	00000097          	auipc	ra,0x0
    80001ad2:	80c080e7          	jalr	-2036(ra) # 800012da <uvminit>
  p->sz = PGSIZE;
    80001ad6:	6785                	lui	a5,0x1
    80001ad8:	e0bc                	sd	a5,64(s1)
  p->tf->epc = 0;      // user program counter
    80001ada:	68b8                	ld	a4,80(s1)
    80001adc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001ae0:	68b8                	ld	a4,80(s1)
    80001ae2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ae4:	4641                	li	a2,16
    80001ae6:	00005597          	auipc	a1,0x5
    80001aea:	7fa58593          	addi	a1,a1,2042 # 800072e0 <userret+0x250>
    80001aee:	15048513          	addi	a0,s1,336
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	1fa080e7          	jalr	506(ra) # 80000cec <safestrcpy>
  p->cwd = namei("/");
    80001afa:	00005517          	auipc	a0,0x5
    80001afe:	7f650513          	addi	a0,a0,2038 # 800072f0 <userret+0x260>
    80001b02:	00002097          	auipc	ra,0x2
    80001b06:	072080e7          	jalr	114(ra) # 80003b74 <namei>
    80001b0a:	14a4b423          	sd	a0,328(s1)
  p->state = RUNNABLE;
    80001b0e:	4789                	li	a5,2
    80001b10:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b12:	8526                	mv	a0,s1
    80001b14:	fffff097          	auipc	ra,0xfffff
    80001b18:	026080e7          	jalr	38(ra) # 80000b3a <release>
}
    80001b1c:	60e2                	ld	ra,24(sp)
    80001b1e:	6442                	ld	s0,16(sp)
    80001b20:	64a2                	ld	s1,8(sp)
    80001b22:	6105                	addi	sp,sp,32
    80001b24:	8082                	ret

0000000080001b26 <growproc>:
{
    80001b26:	1101                	addi	sp,sp,-32
    80001b28:	ec06                	sd	ra,24(sp)
    80001b2a:	e822                	sd	s0,16(sp)
    80001b2c:	e426                	sd	s1,8(sp)
    80001b2e:	e04a                	sd	s2,0(sp)
    80001b30:	1000                	addi	s0,sp,32
    80001b32:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b34:	00000097          	auipc	ra,0x0
    80001b38:	d00080e7          	jalr	-768(ra) # 80001834 <myproc>
    80001b3c:	892a                	mv	s2,a0
  sz = p->sz;
    80001b3e:	612c                	ld	a1,64(a0)
    80001b40:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001b44:	00904f63          	bgtz	s1,80001b62 <growproc+0x3c>
  } else if(n < 0){
    80001b48:	0204cc63          	bltz	s1,80001b80 <growproc+0x5a>
  p->sz = sz;
    80001b4c:	1602                	slli	a2,a2,0x20
    80001b4e:	9201                	srli	a2,a2,0x20
    80001b50:	04c93023          	sd	a2,64(s2)
  return 0;
    80001b54:	4501                	li	a0,0
}
    80001b56:	60e2                	ld	ra,24(sp)
    80001b58:	6442                	ld	s0,16(sp)
    80001b5a:	64a2                	ld	s1,8(sp)
    80001b5c:	6902                	ld	s2,0(sp)
    80001b5e:	6105                	addi	sp,sp,32
    80001b60:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001b62:	9e25                	addw	a2,a2,s1
    80001b64:	1602                	slli	a2,a2,0x20
    80001b66:	9201                	srli	a2,a2,0x20
    80001b68:	1582                	slli	a1,a1,0x20
    80001b6a:	9181                	srli	a1,a1,0x20
    80001b6c:	6528                	ld	a0,72(a0)
    80001b6e:	00000097          	auipc	ra,0x0
    80001b72:	812080e7          	jalr	-2030(ra) # 80001380 <uvmalloc>
    80001b76:	0005061b          	sext.w	a2,a0
    80001b7a:	fa69                	bnez	a2,80001b4c <growproc+0x26>
      return -1;
    80001b7c:	557d                	li	a0,-1
    80001b7e:	bfe1                	j	80001b56 <growproc+0x30>
    if((sz = uvmdealloc(p->pagetable, sz, sz + n)) == 0) {
    80001b80:	9e25                	addw	a2,a2,s1
    80001b82:	1602                	slli	a2,a2,0x20
    80001b84:	9201                	srli	a2,a2,0x20
    80001b86:	1582                	slli	a1,a1,0x20
    80001b88:	9181                	srli	a1,a1,0x20
    80001b8a:	6528                	ld	a0,72(a0)
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	7c0080e7          	jalr	1984(ra) # 8000134c <uvmdealloc>
    80001b94:	0005061b          	sext.w	a2,a0
    80001b98:	fa55                	bnez	a2,80001b4c <growproc+0x26>
      return -1;
    80001b9a:	557d                	li	a0,-1
    80001b9c:	bf6d                	j	80001b56 <growproc+0x30>

0000000080001b9e <fork>:
{
    80001b9e:	7179                	addi	sp,sp,-48
    80001ba0:	f406                	sd	ra,40(sp)
    80001ba2:	f022                	sd	s0,32(sp)
    80001ba4:	ec26                	sd	s1,24(sp)
    80001ba6:	e84a                	sd	s2,16(sp)
    80001ba8:	e44e                	sd	s3,8(sp)
    80001baa:	e052                	sd	s4,0(sp)
    80001bac:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	c86080e7          	jalr	-890(ra) # 80001834 <myproc>
    80001bb6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001bb8:	00000097          	auipc	ra,0x0
    80001bbc:	d9c080e7          	jalr	-612(ra) # 80001954 <allocproc>
    80001bc0:	c175                	beqz	a0,80001ca4 <fork+0x106>
    80001bc2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bc4:	04093603          	ld	a2,64(s2)
    80001bc8:	652c                	ld	a1,72(a0)
    80001bca:	04893503          	ld	a0,72(s2)
    80001bce:	00000097          	auipc	ra,0x0
    80001bd2:	88a080e7          	jalr	-1910(ra) # 80001458 <uvmcopy>
    80001bd6:	04054863          	bltz	a0,80001c26 <fork+0x88>
  np->sz = p->sz;
    80001bda:	04093783          	ld	a5,64(s2)
    80001bde:	04f9b023          	sd	a5,64(s3) # 4000040 <_entry-0x7bffffc0>
  np->parent = p;
    80001be2:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001be6:	05093683          	ld	a3,80(s2)
    80001bea:	87b6                	mv	a5,a3
    80001bec:	0509b703          	ld	a4,80(s3)
    80001bf0:	12068693          	addi	a3,a3,288
    80001bf4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001bf8:	6788                	ld	a0,8(a5)
    80001bfa:	6b8c                	ld	a1,16(a5)
    80001bfc:	6f90                	ld	a2,24(a5)
    80001bfe:	01073023          	sd	a6,0(a4)
    80001c02:	e708                	sd	a0,8(a4)
    80001c04:	eb0c                	sd	a1,16(a4)
    80001c06:	ef10                	sd	a2,24(a4)
    80001c08:	02078793          	addi	a5,a5,32
    80001c0c:	02070713          	addi	a4,a4,32
    80001c10:	fed792e3          	bne	a5,a3,80001bf4 <fork+0x56>
  np->tf->a0 = 0;
    80001c14:	0509b783          	ld	a5,80(s3)
    80001c18:	0607b823          	sd	zero,112(a5)
    80001c1c:	0c800493          	li	s1,200
  for(i = 0; i < NOFILE; i++)
    80001c20:	14800a13          	li	s4,328
    80001c24:	a03d                	j	80001c52 <fork+0xb4>
    freeproc(np);
    80001c26:	854e                	mv	a0,s3
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	e28080e7          	jalr	-472(ra) # 80001a50 <freeproc>
    release(&np->lock);
    80001c30:	854e                	mv	a0,s3
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	f08080e7          	jalr	-248(ra) # 80000b3a <release>
    return -1;
    80001c3a:	54fd                	li	s1,-1
    80001c3c:	a899                	j	80001c92 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c3e:	00003097          	auipc	ra,0x3
    80001c42:	828080e7          	jalr	-2008(ra) # 80004466 <filedup>
    80001c46:	009987b3          	add	a5,s3,s1
    80001c4a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001c4c:	04a1                	addi	s1,s1,8
    80001c4e:	01448763          	beq	s1,s4,80001c5c <fork+0xbe>
    if(p->ofile[i])
    80001c52:	009907b3          	add	a5,s2,s1
    80001c56:	6388                	ld	a0,0(a5)
    80001c58:	f17d                	bnez	a0,80001c3e <fork+0xa0>
    80001c5a:	bfcd                	j	80001c4c <fork+0xae>
  np->cwd = idup(p->cwd);
    80001c5c:	14893503          	ld	a0,328(s2)
    80001c60:	00001097          	auipc	ra,0x1
    80001c64:	74a080e7          	jalr	1866(ra) # 800033aa <idup>
    80001c68:	14a9b423          	sd	a0,328(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c6c:	4641                	li	a2,16
    80001c6e:	15090593          	addi	a1,s2,336
    80001c72:	15098513          	addi	a0,s3,336
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	076080e7          	jalr	118(ra) # 80000cec <safestrcpy>
  pid = np->pid;
    80001c7e:	0349a483          	lw	s1,52(s3)
  np->state = RUNNABLE;
    80001c82:	4789                	li	a5,2
    80001c84:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001c88:	854e                	mv	a0,s3
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	eb0080e7          	jalr	-336(ra) # 80000b3a <release>
}
    80001c92:	8526                	mv	a0,s1
    80001c94:	70a2                	ld	ra,40(sp)
    80001c96:	7402                	ld	s0,32(sp)
    80001c98:	64e2                	ld	s1,24(sp)
    80001c9a:	6942                	ld	s2,16(sp)
    80001c9c:	69a2                	ld	s3,8(sp)
    80001c9e:	6a02                	ld	s4,0(sp)
    80001ca0:	6145                	addi	sp,sp,48
    80001ca2:	8082                	ret
    return -1;
    80001ca4:	54fd                	li	s1,-1
    80001ca6:	b7f5                	j	80001c92 <fork+0xf4>

0000000080001ca8 <reparent>:
reparent(struct proc *p, struct proc *parent) {
    80001ca8:	711d                	addi	sp,sp,-96
    80001caa:	ec86                	sd	ra,88(sp)
    80001cac:	e8a2                	sd	s0,80(sp)
    80001cae:	e4a6                	sd	s1,72(sp)
    80001cb0:	e0ca                	sd	s2,64(sp)
    80001cb2:	fc4e                	sd	s3,56(sp)
    80001cb4:	f852                	sd	s4,48(sp)
    80001cb6:	f456                	sd	s5,40(sp)
    80001cb8:	f05a                	sd	s6,32(sp)
    80001cba:	ec5e                	sd	s7,24(sp)
    80001cbc:	e862                	sd	s8,16(sp)
    80001cbe:	e466                	sd	s9,8(sp)
    80001cc0:	1080                	addi	s0,sp,96
    80001cc2:	892a                	mv	s2,a0
  int child_of_init = (p->parent == initproc);
    80001cc4:	02053b83          	ld	s7,32(a0)
    80001cc8:	00027b17          	auipc	s6,0x27
    80001ccc:	358b3b03          	ld	s6,856(s6) # 80029020 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cd0:	00010497          	auipc	s1,0x10
    80001cd4:	03048493          	addi	s1,s1,48 # 80011d00 <proc>
      pp->parent = initproc;
    80001cd8:	00027a17          	auipc	s4,0x27
    80001cdc:	348a0a13          	addi	s4,s4,840 # 80029020 <initproc>
      if(pp->state == ZOMBIE) {
    80001ce0:	4a91                	li	s5,4
// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
  if(p->chan == p && p->state == SLEEPING) {
    80001ce2:	4c05                	li	s8,1
    p->state = RUNNABLE;
    80001ce4:	4c89                	li	s9,2
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ce6:	00016997          	auipc	s3,0x16
    80001cea:	81a98993          	addi	s3,s3,-2022 # 80017500 <tickslock>
    80001cee:	a805                	j	80001d1e <reparent+0x76>
  if(p->chan == p && p->state == SLEEPING) {
    80001cf0:	751c                	ld	a5,40(a0)
    80001cf2:	00f51d63          	bne	a0,a5,80001d0c <reparent+0x64>
    80001cf6:	4d1c                	lw	a5,24(a0)
    80001cf8:	01879a63          	bne	a5,s8,80001d0c <reparent+0x64>
    p->state = RUNNABLE;
    80001cfc:	01952c23          	sw	s9,24(a0)
        if(!child_of_init)
    80001d00:	016b8663          	beq	s7,s6,80001d0c <reparent+0x64>
          release(&initproc->lock);
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	e36080e7          	jalr	-458(ra) # 80000b3a <release>
      release(&pp->lock);
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	fffff097          	auipc	ra,0xfffff
    80001d12:	e2c080e7          	jalr	-468(ra) # 80000b3a <release>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d16:	16048493          	addi	s1,s1,352
    80001d1a:	03348f63          	beq	s1,s3,80001d58 <reparent+0xb0>
    if(pp->parent == p){
    80001d1e:	709c                	ld	a5,32(s1)
    80001d20:	ff279be3          	bne	a5,s2,80001d16 <reparent+0x6e>
      acquire(&pp->lock);
    80001d24:	8526                	mv	a0,s1
    80001d26:	fffff097          	auipc	ra,0xfffff
    80001d2a:	dac080e7          	jalr	-596(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    80001d2e:	000a3503          	ld	a0,0(s4)
    80001d32:	f088                	sd	a0,32(s1)
      if(pp->state == ZOMBIE) {
    80001d34:	4c9c                	lw	a5,24(s1)
    80001d36:	fd579be3          	bne	a5,s5,80001d0c <reparent+0x64>
        if(!child_of_init)
    80001d3a:	fb6b8be3          	beq	s7,s6,80001cf0 <reparent+0x48>
          acquire(&initproc->lock);
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	d94080e7          	jalr	-620(ra) # 80000ad2 <acquire>
        wakeup1(initproc);
    80001d46:	000a3503          	ld	a0,0(s4)
  if(p->chan == p && p->state == SLEEPING) {
    80001d4a:	751c                	ld	a5,40(a0)
    80001d4c:	faa79ce3          	bne	a5,a0,80001d04 <reparent+0x5c>
    80001d50:	4d1c                	lw	a5,24(a0)
    80001d52:	fb8799e3          	bne	a5,s8,80001d04 <reparent+0x5c>
    80001d56:	b75d                	j	80001cfc <reparent+0x54>
}
    80001d58:	60e6                	ld	ra,88(sp)
    80001d5a:	6446                	ld	s0,80(sp)
    80001d5c:	64a6                	ld	s1,72(sp)
    80001d5e:	6906                	ld	s2,64(sp)
    80001d60:	79e2                	ld	s3,56(sp)
    80001d62:	7a42                	ld	s4,48(sp)
    80001d64:	7aa2                	ld	s5,40(sp)
    80001d66:	7b02                	ld	s6,32(sp)
    80001d68:	6be2                	ld	s7,24(sp)
    80001d6a:	6c42                	ld	s8,16(sp)
    80001d6c:	6ca2                	ld	s9,8(sp)
    80001d6e:	6125                	addi	sp,sp,96
    80001d70:	8082                	ret

0000000080001d72 <scheduler>:
{
    80001d72:	715d                	addi	sp,sp,-80
    80001d74:	e486                	sd	ra,72(sp)
    80001d76:	e0a2                	sd	s0,64(sp)
    80001d78:	fc26                	sd	s1,56(sp)
    80001d7a:	f84a                	sd	s2,48(sp)
    80001d7c:	f44e                	sd	s3,40(sp)
    80001d7e:	f052                	sd	s4,32(sp)
    80001d80:	ec56                	sd	s5,24(sp)
    80001d82:	e85a                	sd	s6,16(sp)
    80001d84:	e45e                	sd	s7,8(sp)
    80001d86:	e062                	sd	s8,0(sp)
    80001d88:	0880                	addi	s0,sp,80
    80001d8a:	8792                	mv	a5,tp
  int id = r_tp();
    80001d8c:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d8e:	00779b13          	slli	s6,a5,0x7
    80001d92:	00010717          	auipc	a4,0x10
    80001d96:	b5670713          	addi	a4,a4,-1194 # 800118e8 <pid_lock>
    80001d9a:	975a                	add	a4,a4,s6
    80001d9c:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001da0:	00010717          	auipc	a4,0x10
    80001da4:	b6870713          	addi	a4,a4,-1176 # 80011908 <cpus+0x8>
    80001da8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001daa:	4c0d                	li	s8,3
        c->proc = p;
    80001dac:	079e                	slli	a5,a5,0x7
    80001dae:	00010a17          	auipc	s4,0x10
    80001db2:	b3aa0a13          	addi	s4,s4,-1222 # 800118e8 <pid_lock>
    80001db6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001db8:	00015997          	auipc	s3,0x15
    80001dbc:	74898993          	addi	s3,s3,1864 # 80017500 <tickslock>
        found = 1;
    80001dc0:	4b85                	li	s7,1
    80001dc2:	a08d                	j	80001e24 <scheduler+0xb2>
        p->state = RUNNING;
    80001dc4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dc8:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80001dcc:	05848593          	addi	a1,s1,88
    80001dd0:	855a                	mv	a0,s6
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	5ea080e7          	jalr	1514(ra) # 800023bc <swtch>
        c->proc = 0;
    80001dda:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001dde:	8ade                	mv	s5,s7
      release(&p->lock);
    80001de0:	8526                	mv	a0,s1
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	d58080e7          	jalr	-680(ra) # 80000b3a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dea:	16048493          	addi	s1,s1,352
    80001dee:	01348b63          	beq	s1,s3,80001e04 <scheduler+0x92>
      acquire(&p->lock);
    80001df2:	8526                	mv	a0,s1
    80001df4:	fffff097          	auipc	ra,0xfffff
    80001df8:	cde080e7          	jalr	-802(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE) {
    80001dfc:	4c9c                	lw	a5,24(s1)
    80001dfe:	ff2791e3          	bne	a5,s2,80001de0 <scheduler+0x6e>
    80001e02:	b7c9                	j	80001dc4 <scheduler+0x52>
    if(found == 0){
    80001e04:	020a9063          	bnez	s5,80001e24 <scheduler+0xb2>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e08:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e0c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e10:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e18:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e1c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e20:	10500073          	wfi
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e24:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e28:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e2c:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e30:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e34:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e38:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e3c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e3e:	00010497          	auipc	s1,0x10
    80001e42:	ec248493          	addi	s1,s1,-318 # 80011d00 <proc>
      if(p->state == RUNNABLE) {
    80001e46:	4909                	li	s2,2
    80001e48:	b76d                	j	80001df2 <scheduler+0x80>

0000000080001e4a <sched>:
{
    80001e4a:	7179                	addi	sp,sp,-48
    80001e4c:	f406                	sd	ra,40(sp)
    80001e4e:	f022                	sd	s0,32(sp)
    80001e50:	ec26                	sd	s1,24(sp)
    80001e52:	e84a                	sd	s2,16(sp)
    80001e54:	e44e                	sd	s3,8(sp)
    80001e56:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	9dc080e7          	jalr	-1572(ra) # 80001834 <myproc>
    80001e60:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	c30080e7          	jalr	-976(ra) # 80000a92 <holding>
    80001e6a:	c93d                	beqz	a0,80001ee0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e6c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e6e:	2781                	sext.w	a5,a5
    80001e70:	079e                	slli	a5,a5,0x7
    80001e72:	00010717          	auipc	a4,0x10
    80001e76:	a7670713          	addi	a4,a4,-1418 # 800118e8 <pid_lock>
    80001e7a:	97ba                	add	a5,a5,a4
    80001e7c:	0907a703          	lw	a4,144(a5)
    80001e80:	4785                	li	a5,1
    80001e82:	06f71763          	bne	a4,a5,80001ef0 <sched+0xa6>
  if(p->state == RUNNING)
    80001e86:	4c98                	lw	a4,24(s1)
    80001e88:	478d                	li	a5,3
    80001e8a:	06f70b63          	beq	a4,a5,80001f00 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e92:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e94:	efb5                	bnez	a5,80001f10 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e96:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e98:	00010917          	auipc	s2,0x10
    80001e9c:	a5090913          	addi	s2,s2,-1456 # 800118e8 <pid_lock>
    80001ea0:	2781                	sext.w	a5,a5
    80001ea2:	079e                	slli	a5,a5,0x7
    80001ea4:	97ca                	add	a5,a5,s2
    80001ea6:	0947a983          	lw	s3,148(a5)
    80001eaa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80001eac:	2781                	sext.w	a5,a5
    80001eae:	079e                	slli	a5,a5,0x7
    80001eb0:	00010597          	auipc	a1,0x10
    80001eb4:	a5858593          	addi	a1,a1,-1448 # 80011908 <cpus+0x8>
    80001eb8:	95be                	add	a1,a1,a5
    80001eba:	05848513          	addi	a0,s1,88
    80001ebe:	00000097          	auipc	ra,0x0
    80001ec2:	4fe080e7          	jalr	1278(ra) # 800023bc <swtch>
    80001ec6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ec8:	2781                	sext.w	a5,a5
    80001eca:	079e                	slli	a5,a5,0x7
    80001ecc:	97ca                	add	a5,a5,s2
    80001ece:	0937aa23          	sw	s3,148(a5)
}
    80001ed2:	70a2                	ld	ra,40(sp)
    80001ed4:	7402                	ld	s0,32(sp)
    80001ed6:	64e2                	ld	s1,24(sp)
    80001ed8:	6942                	ld	s2,16(sp)
    80001eda:	69a2                	ld	s3,8(sp)
    80001edc:	6145                	addi	sp,sp,48
    80001ede:	8082                	ret
    panic("sched p->lock");
    80001ee0:	00005517          	auipc	a0,0x5
    80001ee4:	41850513          	addi	a0,a0,1048 # 800072f8 <userret+0x268>
    80001ee8:	ffffe097          	auipc	ra,0xffffe
    80001eec:	666080e7          	jalr	1638(ra) # 8000054e <panic>
    panic("sched locks");
    80001ef0:	00005517          	auipc	a0,0x5
    80001ef4:	41850513          	addi	a0,a0,1048 # 80007308 <userret+0x278>
    80001ef8:	ffffe097          	auipc	ra,0xffffe
    80001efc:	656080e7          	jalr	1622(ra) # 8000054e <panic>
    panic("sched running");
    80001f00:	00005517          	auipc	a0,0x5
    80001f04:	41850513          	addi	a0,a0,1048 # 80007318 <userret+0x288>
    80001f08:	ffffe097          	auipc	ra,0xffffe
    80001f0c:	646080e7          	jalr	1606(ra) # 8000054e <panic>
    panic("sched interruptible");
    80001f10:	00005517          	auipc	a0,0x5
    80001f14:	41850513          	addi	a0,a0,1048 # 80007328 <userret+0x298>
    80001f18:	ffffe097          	auipc	ra,0xffffe
    80001f1c:	636080e7          	jalr	1590(ra) # 8000054e <panic>

0000000080001f20 <exit>:
{
    80001f20:	7179                	addi	sp,sp,-48
    80001f22:	f406                	sd	ra,40(sp)
    80001f24:	f022                	sd	s0,32(sp)
    80001f26:	ec26                	sd	s1,24(sp)
    80001f28:	e84a                	sd	s2,16(sp)
    80001f2a:	e44e                	sd	s3,8(sp)
    80001f2c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	906080e7          	jalr	-1786(ra) # 80001834 <myproc>
    80001f36:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f38:	00027797          	auipc	a5,0x27
    80001f3c:	0e87b783          	ld	a5,232(a5) # 80029020 <initproc>
    80001f40:	0c850493          	addi	s1,a0,200
    80001f44:	14850913          	addi	s2,a0,328
    80001f48:	02a79363          	bne	a5,a0,80001f6e <exit+0x4e>
    panic("init exiting");
    80001f4c:	00005517          	auipc	a0,0x5
    80001f50:	3f450513          	addi	a0,a0,1012 # 80007340 <userret+0x2b0>
    80001f54:	ffffe097          	auipc	ra,0xffffe
    80001f58:	5fa080e7          	jalr	1530(ra) # 8000054e <panic>
      fileclose(f);
    80001f5c:	00002097          	auipc	ra,0x2
    80001f60:	55c080e7          	jalr	1372(ra) # 800044b8 <fileclose>
      p->ofile[fd] = 0;
    80001f64:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f68:	04a1                	addi	s1,s1,8
    80001f6a:	01248563          	beq	s1,s2,80001f74 <exit+0x54>
    if(p->ofile[fd]){
    80001f6e:	6088                	ld	a0,0(s1)
    80001f70:	f575                	bnez	a0,80001f5c <exit+0x3c>
    80001f72:	bfdd                	j	80001f68 <exit+0x48>
  begin_op(ROOTDEV);
    80001f74:	4501                	li	a0,0
    80001f76:	00002097          	auipc	ra,0x2
    80001f7a:	f1a080e7          	jalr	-230(ra) # 80003e90 <begin_op>
  iput(p->cwd);
    80001f7e:	1489b503          	ld	a0,328(s3)
    80001f82:	00001097          	auipc	ra,0x1
    80001f86:	574080e7          	jalr	1396(ra) # 800034f6 <iput>
  end_op(ROOTDEV);
    80001f8a:	4501                	li	a0,0
    80001f8c:	00002097          	auipc	ra,0x2
    80001f90:	fae080e7          	jalr	-82(ra) # 80003f3a <end_op>
  p->cwd = 0;
    80001f94:	1409b423          	sd	zero,328(s3)
  acquire(&p->parent->lock);
    80001f98:	0209b503          	ld	a0,32(s3)
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	b36080e7          	jalr	-1226(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    80001fa4:	854e                	mv	a0,s3
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	b2c080e7          	jalr	-1236(ra) # 80000ad2 <acquire>
  reparent(p, p->parent);
    80001fae:	0209b583          	ld	a1,32(s3)
    80001fb2:	854e                	mv	a0,s3
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	cf4080e7          	jalr	-780(ra) # 80001ca8 <reparent>
  wakeup1(p->parent);
    80001fbc:	0209b783          	ld	a5,32(s3)
  if(p->chan == p && p->state == SLEEPING) {
    80001fc0:	7798                	ld	a4,40(a5)
    80001fc2:	02e78763          	beq	a5,a4,80001ff0 <exit+0xd0>
  p->state = ZOMBIE;
    80001fc6:	4791                	li	a5,4
    80001fc8:	00f9ac23          	sw	a5,24(s3)
  release(&p->parent->lock);
    80001fcc:	0209b503          	ld	a0,32(s3)
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	b6a080e7          	jalr	-1174(ra) # 80000b3a <release>
  sched();
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	e72080e7          	jalr	-398(ra) # 80001e4a <sched>
  panic("zombie exit");
    80001fe0:	00005517          	auipc	a0,0x5
    80001fe4:	37050513          	addi	a0,a0,880 # 80007350 <userret+0x2c0>
    80001fe8:	ffffe097          	auipc	ra,0xffffe
    80001fec:	566080e7          	jalr	1382(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001ff0:	4f94                	lw	a3,24(a5)
    80001ff2:	4705                	li	a4,1
    80001ff4:	fce699e3          	bne	a3,a4,80001fc6 <exit+0xa6>
    p->state = RUNNABLE;
    80001ff8:	4709                	li	a4,2
    80001ffa:	cf98                	sw	a4,24(a5)
    80001ffc:	b7e9                	j	80001fc6 <exit+0xa6>

0000000080001ffe <yield>:
{
    80001ffe:	1101                	addi	sp,sp,-32
    80002000:	ec06                	sd	ra,24(sp)
    80002002:	e822                	sd	s0,16(sp)
    80002004:	e426                	sd	s1,8(sp)
    80002006:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002008:	00000097          	auipc	ra,0x0
    8000200c:	82c080e7          	jalr	-2004(ra) # 80001834 <myproc>
    80002010:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	ac0080e7          	jalr	-1344(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    8000201a:	4789                	li	a5,2
    8000201c:	cc9c                	sw	a5,24(s1)
  sched();
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	e2c080e7          	jalr	-468(ra) # 80001e4a <sched>
  release(&p->lock);
    80002026:	8526                	mv	a0,s1
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	b12080e7          	jalr	-1262(ra) # 80000b3a <release>
}
    80002030:	60e2                	ld	ra,24(sp)
    80002032:	6442                	ld	s0,16(sp)
    80002034:	64a2                	ld	s1,8(sp)
    80002036:	6105                	addi	sp,sp,32
    80002038:	8082                	ret

000000008000203a <sleep>:
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	1800                	addi	s0,sp,48
    80002048:	89aa                	mv	s3,a0
    8000204a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	7e8080e7          	jalr	2024(ra) # 80001834 <myproc>
    80002054:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002056:	05250663          	beq	a0,s2,800020a2 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	a78080e7          	jalr	-1416(ra) # 80000ad2 <acquire>
    release(lk);
    80002062:	854a                	mv	a0,s2
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	ad6080e7          	jalr	-1322(ra) # 80000b3a <release>
  p->chan = chan;
    8000206c:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002070:	4785                	li	a5,1
    80002072:	cc9c                	sw	a5,24(s1)
  sched();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	dd6080e7          	jalr	-554(ra) # 80001e4a <sched>
  p->chan = 0;
    8000207c:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002080:	8526                	mv	a0,s1
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	ab8080e7          	jalr	-1352(ra) # 80000b3a <release>
    acquire(lk);
    8000208a:	854a                	mv	a0,s2
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	a46080e7          	jalr	-1466(ra) # 80000ad2 <acquire>
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret
  p->chan = chan;
    800020a2:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800020a6:	4785                	li	a5,1
    800020a8:	cd1c                	sw	a5,24(a0)
  sched();
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	da0080e7          	jalr	-608(ra) # 80001e4a <sched>
  p->chan = 0;
    800020b2:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800020b6:	bff9                	j	80002094 <sleep+0x5a>

00000000800020b8 <wait>:
{
    800020b8:	715d                	addi	sp,sp,-80
    800020ba:	e486                	sd	ra,72(sp)
    800020bc:	e0a2                	sd	s0,64(sp)
    800020be:	fc26                	sd	s1,56(sp)
    800020c0:	f84a                	sd	s2,48(sp)
    800020c2:	f44e                	sd	s3,40(sp)
    800020c4:	f052                	sd	s4,32(sp)
    800020c6:	ec56                	sd	s5,24(sp)
    800020c8:	e85a                	sd	s6,16(sp)
    800020ca:	e45e                	sd	s7,8(sp)
    800020cc:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	766080e7          	jalr	1894(ra) # 80001834 <myproc>
    800020d6:	892a                	mv	s2,a0
  acquire(&p->lock);
    800020d8:	8baa                	mv	s7,a0
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	9f8080e7          	jalr	-1544(ra) # 80000ad2 <acquire>
    havekids = 0;
    800020e2:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    800020e4:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    800020e6:	00015997          	auipc	s3,0x15
    800020ea:	41a98993          	addi	s3,s3,1050 # 80017500 <tickslock>
        havekids = 1;
    800020ee:	4a85                	li	s5,1
    havekids = 0;
    800020f0:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    800020f2:	00010497          	auipc	s1,0x10
    800020f6:	c0e48493          	addi	s1,s1,-1010 # 80011d00 <proc>
    800020fa:	a03d                	j	80002128 <wait+0x70>
          pid = np->pid;
    800020fc:	0344a983          	lw	s3,52(s1)
          freeproc(np);
    80002100:	8526                	mv	a0,s1
    80002102:	00000097          	auipc	ra,0x0
    80002106:	94e080e7          	jalr	-1714(ra) # 80001a50 <freeproc>
          release(&np->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	a2e080e7          	jalr	-1490(ra) # 80000b3a <release>
          release(&p->lock);
    80002114:	854a                	mv	a0,s2
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	a24080e7          	jalr	-1500(ra) # 80000b3a <release>
          return pid;
    8000211e:	a089                	j	80002160 <wait+0xa8>
    for(np = proc; np < &proc[NPROC]; np++){
    80002120:	16048493          	addi	s1,s1,352
    80002124:	03348463          	beq	s1,s3,8000214c <wait+0x94>
      if(np->parent == p){
    80002128:	709c                	ld	a5,32(s1)
    8000212a:	ff279be3          	bne	a5,s2,80002120 <wait+0x68>
        acquire(&np->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	9a2080e7          	jalr	-1630(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    80002138:	4c9c                	lw	a5,24(s1)
    8000213a:	fd4781e3          	beq	a5,s4,800020fc <wait+0x44>
        release(&np->lock);
    8000213e:	8526                	mv	a0,s1
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	9fa080e7          	jalr	-1542(ra) # 80000b3a <release>
        havekids = 1;
    80002148:	8756                	mv	a4,s5
    8000214a:	bfd9                	j	80002120 <wait+0x68>
    if(!havekids || p->killed){
    8000214c:	c701                	beqz	a4,80002154 <wait+0x9c>
    8000214e:	03092783          	lw	a5,48(s2)
    80002152:	c39d                	beqz	a5,80002178 <wait+0xc0>
      release(&p->lock);
    80002154:	854a                	mv	a0,s2
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	9e4080e7          	jalr	-1564(ra) # 80000b3a <release>
      return -1;
    8000215e:	59fd                	li	s3,-1
}
    80002160:	854e                	mv	a0,s3
    80002162:	60a6                	ld	ra,72(sp)
    80002164:	6406                	ld	s0,64(sp)
    80002166:	74e2                	ld	s1,56(sp)
    80002168:	7942                	ld	s2,48(sp)
    8000216a:	79a2                	ld	s3,40(sp)
    8000216c:	7a02                	ld	s4,32(sp)
    8000216e:	6ae2                	ld	s5,24(sp)
    80002170:	6b42                	ld	s6,16(sp)
    80002172:	6ba2                	ld	s7,8(sp)
    80002174:	6161                	addi	sp,sp,80
    80002176:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002178:	85de                	mv	a1,s7
    8000217a:	854a                	mv	a0,s2
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	ebe080e7          	jalr	-322(ra) # 8000203a <sleep>
    havekids = 0;
    80002184:	b7b5                	j	800020f0 <wait+0x38>

0000000080002186 <wakeup>:
{
    80002186:	7139                	addi	sp,sp,-64
    80002188:	fc06                	sd	ra,56(sp)
    8000218a:	f822                	sd	s0,48(sp)
    8000218c:	f426                	sd	s1,40(sp)
    8000218e:	f04a                	sd	s2,32(sp)
    80002190:	ec4e                	sd	s3,24(sp)
    80002192:	e852                	sd	s4,16(sp)
    80002194:	e456                	sd	s5,8(sp)
    80002196:	0080                	addi	s0,sp,64
    80002198:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000219a:	00010497          	auipc	s1,0x10
    8000219e:	b6648493          	addi	s1,s1,-1178 # 80011d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800021a2:	4985                	li	s3,1
      p->state = RUNNABLE;
    800021a4:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800021a6:	00015917          	auipc	s2,0x15
    800021aa:	35a90913          	addi	s2,s2,858 # 80017500 <tickslock>
    800021ae:	a821                	j	800021c6 <wakeup+0x40>
      p->state = RUNNABLE;
    800021b0:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    800021b4:	8526                	mv	a0,s1
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	984080e7          	jalr	-1660(ra) # 80000b3a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021be:	16048493          	addi	s1,s1,352
    800021c2:	01248e63          	beq	s1,s2,800021de <wakeup+0x58>
    acquire(&p->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	90a080e7          	jalr	-1782(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800021d0:	4c9c                	lw	a5,24(s1)
    800021d2:	ff3791e3          	bne	a5,s3,800021b4 <wakeup+0x2e>
    800021d6:	749c                	ld	a5,40(s1)
    800021d8:	fd479ee3          	bne	a5,s4,800021b4 <wakeup+0x2e>
    800021dc:	bfd1                	j	800021b0 <wakeup+0x2a>
}
    800021de:	70e2                	ld	ra,56(sp)
    800021e0:	7442                	ld	s0,48(sp)
    800021e2:	74a2                	ld	s1,40(sp)
    800021e4:	7902                	ld	s2,32(sp)
    800021e6:	69e2                	ld	s3,24(sp)
    800021e8:	6a42                	ld	s4,16(sp)
    800021ea:	6aa2                	ld	s5,8(sp)
    800021ec:	6121                	addi	sp,sp,64
    800021ee:	8082                	ret

00000000800021f0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800021f0:	7179                	addi	sp,sp,-48
    800021f2:	f406                	sd	ra,40(sp)
    800021f4:	f022                	sd	s0,32(sp)
    800021f6:	ec26                	sd	s1,24(sp)
    800021f8:	e84a                	sd	s2,16(sp)
    800021fa:	e44e                	sd	s3,8(sp)
    800021fc:	1800                	addi	s0,sp,48
    800021fe:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002200:	00010497          	auipc	s1,0x10
    80002204:	b0048493          	addi	s1,s1,-1280 # 80011d00 <proc>
    80002208:	00015997          	auipc	s3,0x15
    8000220c:	2f898993          	addi	s3,s3,760 # 80017500 <tickslock>
    acquire(&p->lock);
    80002210:	8526                	mv	a0,s1
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	8c0080e7          	jalr	-1856(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    8000221a:	58dc                	lw	a5,52(s1)
    8000221c:	01278d63          	beq	a5,s2,80002236 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002220:	8526                	mv	a0,s1
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	918080e7          	jalr	-1768(ra) # 80000b3a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000222a:	16048493          	addi	s1,s1,352
    8000222e:	ff3491e3          	bne	s1,s3,80002210 <kill+0x20>
  }
  return -1;
    80002232:	557d                	li	a0,-1
    80002234:	a829                	j	8000224e <kill+0x5e>
      p->killed = 1;
    80002236:	4785                	li	a5,1
    80002238:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000223a:	4c98                	lw	a4,24(s1)
    8000223c:	4785                	li	a5,1
    8000223e:	00f70f63          	beq	a4,a5,8000225c <kill+0x6c>
      release(&p->lock);
    80002242:	8526                	mv	a0,s1
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	8f6080e7          	jalr	-1802(ra) # 80000b3a <release>
      return 0;
    8000224c:	4501                	li	a0,0
}
    8000224e:	70a2                	ld	ra,40(sp)
    80002250:	7402                	ld	s0,32(sp)
    80002252:	64e2                	ld	s1,24(sp)
    80002254:	6942                	ld	s2,16(sp)
    80002256:	69a2                	ld	s3,8(sp)
    80002258:	6145                	addi	sp,sp,48
    8000225a:	8082                	ret
        p->state = RUNNABLE;
    8000225c:	4789                	li	a5,2
    8000225e:	cc9c                	sw	a5,24(s1)
    80002260:	b7cd                	j	80002242 <kill+0x52>

0000000080002262 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002262:	7179                	addi	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	e84a                	sd	s2,16(sp)
    8000226c:	e44e                	sd	s3,8(sp)
    8000226e:	e052                	sd	s4,0(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	84aa                	mv	s1,a0
    80002274:	892e                	mv	s2,a1
    80002276:	89b2                	mv	s3,a2
    80002278:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	5ba080e7          	jalr	1466(ra) # 80001834 <myproc>
  if(user_dst){
    80002282:	c08d                	beqz	s1,800022a4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002284:	86d2                	mv	a3,s4
    80002286:	864e                	mv	a2,s3
    80002288:	85ca                	mv	a1,s2
    8000228a:	6528                	ld	a0,72(a0)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	2ce080e7          	jalr	718(ra) # 8000155a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002294:	70a2                	ld	ra,40(sp)
    80002296:	7402                	ld	s0,32(sp)
    80002298:	64e2                	ld	s1,24(sp)
    8000229a:	6942                	ld	s2,16(sp)
    8000229c:	69a2                	ld	s3,8(sp)
    8000229e:	6a02                	ld	s4,0(sp)
    800022a0:	6145                	addi	sp,sp,48
    800022a2:	8082                	ret
    memmove((char *)dst, src, len);
    800022a4:	000a061b          	sext.w	a2,s4
    800022a8:	85ce                	mv	a1,s3
    800022aa:	854a                	mv	a0,s2
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	94a080e7          	jalr	-1718(ra) # 80000bf6 <memmove>
    return 0;
    800022b4:	8526                	mv	a0,s1
    800022b6:	bff9                	j	80002294 <either_copyout+0x32>

00000000800022b8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022b8:	7179                	addi	sp,sp,-48
    800022ba:	f406                	sd	ra,40(sp)
    800022bc:	f022                	sd	s0,32(sp)
    800022be:	ec26                	sd	s1,24(sp)
    800022c0:	e84a                	sd	s2,16(sp)
    800022c2:	e44e                	sd	s3,8(sp)
    800022c4:	e052                	sd	s4,0(sp)
    800022c6:	1800                	addi	s0,sp,48
    800022c8:	892a                	mv	s2,a0
    800022ca:	84ae                	mv	s1,a1
    800022cc:	89b2                	mv	s3,a2
    800022ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	564080e7          	jalr	1380(ra) # 80001834 <myproc>
  if(user_src){
    800022d8:	c08d                	beqz	s1,800022fa <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800022da:	86d2                	mv	a3,s4
    800022dc:	864e                	mv	a2,s3
    800022de:	85ca                	mv	a1,s2
    800022e0:	6528                	ld	a0,72(a0)
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	30a080e7          	jalr	778(ra) # 800015ec <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022ea:	70a2                	ld	ra,40(sp)
    800022ec:	7402                	ld	s0,32(sp)
    800022ee:	64e2                	ld	s1,24(sp)
    800022f0:	6942                	ld	s2,16(sp)
    800022f2:	69a2                	ld	s3,8(sp)
    800022f4:	6a02                	ld	s4,0(sp)
    800022f6:	6145                	addi	sp,sp,48
    800022f8:	8082                	ret
    memmove(dst, (char*)src, len);
    800022fa:	000a061b          	sext.w	a2,s4
    800022fe:	85ce                	mv	a1,s3
    80002300:	854a                	mv	a0,s2
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	8f4080e7          	jalr	-1804(ra) # 80000bf6 <memmove>
    return 0;
    8000230a:	8526                	mv	a0,s1
    8000230c:	bff9                	j	800022ea <either_copyin+0x32>

000000008000230e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000230e:	715d                	addi	sp,sp,-80
    80002310:	e486                	sd	ra,72(sp)
    80002312:	e0a2                	sd	s0,64(sp)
    80002314:	fc26                	sd	s1,56(sp)
    80002316:	f84a                	sd	s2,48(sp)
    80002318:	f44e                	sd	s3,40(sp)
    8000231a:	f052                	sd	s4,32(sp)
    8000231c:	ec56                	sd	s5,24(sp)
    8000231e:	e85a                	sd	s6,16(sp)
    80002320:	e45e                	sd	s7,8(sp)
    80002322:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002324:	00005517          	auipc	a0,0x5
    80002328:	e8c50513          	addi	a0,a0,-372 # 800071b0 <userret+0x120>
    8000232c:	ffffe097          	auipc	ra,0xffffe
    80002330:	26c080e7          	jalr	620(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002334:	00010497          	auipc	s1,0x10
    80002338:	b1c48493          	addi	s1,s1,-1252 # 80011e50 <proc+0x150>
    8000233c:	00015917          	auipc	s2,0x15
    80002340:	31490913          	addi	s2,s2,788 # 80017650 <bcache+0x138>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002344:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002346:	00005997          	auipc	s3,0x5
    8000234a:	01a98993          	addi	s3,s3,26 # 80007360 <userret+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    8000234e:	00005a97          	auipc	s5,0x5
    80002352:	01aa8a93          	addi	s5,s5,26 # 80007368 <userret+0x2d8>
    printf("\n");
    80002356:	00005a17          	auipc	s4,0x5
    8000235a:	e5aa0a13          	addi	s4,s4,-422 # 800071b0 <userret+0x120>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000235e:	00005b97          	auipc	s7,0x5
    80002362:	56ab8b93          	addi	s7,s7,1386 # 800078c8 <states.1759>
    80002366:	a00d                	j	80002388 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002368:	ee46a583          	lw	a1,-284(a3)
    8000236c:	8556                	mv	a0,s5
    8000236e:	ffffe097          	auipc	ra,0xffffe
    80002372:	22a080e7          	jalr	554(ra) # 80000598 <printf>
    printf("\n");
    80002376:	8552                	mv	a0,s4
    80002378:	ffffe097          	auipc	ra,0xffffe
    8000237c:	220080e7          	jalr	544(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002380:	16048493          	addi	s1,s1,352
    80002384:	03248163          	beq	s1,s2,800023a6 <procdump+0x98>
    if(p->state == UNUSED)
    80002388:	86a6                	mv	a3,s1
    8000238a:	ec84a783          	lw	a5,-312(s1)
    8000238e:	dbed                	beqz	a5,80002380 <procdump+0x72>
      state = "???";
    80002390:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002392:	fcfb6be3          	bltu	s6,a5,80002368 <procdump+0x5a>
    80002396:	1782                	slli	a5,a5,0x20
    80002398:	9381                	srli	a5,a5,0x20
    8000239a:	078e                	slli	a5,a5,0x3
    8000239c:	97de                	add	a5,a5,s7
    8000239e:	6390                	ld	a2,0(a5)
    800023a0:	f661                	bnez	a2,80002368 <procdump+0x5a>
      state = "???";
    800023a2:	864e                	mv	a2,s3
    800023a4:	b7d1                	j	80002368 <procdump+0x5a>
  }
}
    800023a6:	60a6                	ld	ra,72(sp)
    800023a8:	6406                	ld	s0,64(sp)
    800023aa:	74e2                	ld	s1,56(sp)
    800023ac:	7942                	ld	s2,48(sp)
    800023ae:	79a2                	ld	s3,40(sp)
    800023b0:	7a02                	ld	s4,32(sp)
    800023b2:	6ae2                	ld	s5,24(sp)
    800023b4:	6b42                	ld	s6,16(sp)
    800023b6:	6ba2                	ld	s7,8(sp)
    800023b8:	6161                	addi	sp,sp,80
    800023ba:	8082                	ret

00000000800023bc <swtch>:
    800023bc:	00153023          	sd	ra,0(a0)
    800023c0:	00253423          	sd	sp,8(a0)
    800023c4:	e900                	sd	s0,16(a0)
    800023c6:	ed04                	sd	s1,24(a0)
    800023c8:	03253023          	sd	s2,32(a0)
    800023cc:	03353423          	sd	s3,40(a0)
    800023d0:	03453823          	sd	s4,48(a0)
    800023d4:	03553c23          	sd	s5,56(a0)
    800023d8:	05653023          	sd	s6,64(a0)
    800023dc:	05753423          	sd	s7,72(a0)
    800023e0:	05853823          	sd	s8,80(a0)
    800023e4:	05953c23          	sd	s9,88(a0)
    800023e8:	07a53023          	sd	s10,96(a0)
    800023ec:	07b53423          	sd	s11,104(a0)
    800023f0:	0005b083          	ld	ra,0(a1)
    800023f4:	0085b103          	ld	sp,8(a1)
    800023f8:	6980                	ld	s0,16(a1)
    800023fa:	6d84                	ld	s1,24(a1)
    800023fc:	0205b903          	ld	s2,32(a1)
    80002400:	0285b983          	ld	s3,40(a1)
    80002404:	0305ba03          	ld	s4,48(a1)
    80002408:	0385ba83          	ld	s5,56(a1)
    8000240c:	0405bb03          	ld	s6,64(a1)
    80002410:	0485bb83          	ld	s7,72(a1)
    80002414:	0505bc03          	ld	s8,80(a1)
    80002418:	0585bc83          	ld	s9,88(a1)
    8000241c:	0605bd03          	ld	s10,96(a1)
    80002420:	0685bd83          	ld	s11,104(a1)
    80002424:	8082                	ret

0000000080002426 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002426:	1141                	addi	sp,sp,-16
    80002428:	e406                	sd	ra,8(sp)
    8000242a:	e022                	sd	s0,0(sp)
    8000242c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000242e:	00005597          	auipc	a1,0x5
    80002432:	f7258593          	addi	a1,a1,-142 # 800073a0 <userret+0x310>
    80002436:	00015517          	auipc	a0,0x15
    8000243a:	0ca50513          	addi	a0,a0,202 # 80017500 <tickslock>
    8000243e:	ffffe097          	auipc	ra,0xffffe
    80002442:	582080e7          	jalr	1410(ra) # 800009c0 <initlock>
}
    80002446:	60a2                	ld	ra,8(sp)
    80002448:	6402                	ld	s0,0(sp)
    8000244a:	0141                	addi	sp,sp,16
    8000244c:	8082                	ret

000000008000244e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000244e:	1141                	addi	sp,sp,-16
    80002450:	e422                	sd	s0,8(sp)
    80002452:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002454:	00003797          	auipc	a5,0x3
    80002458:	70c78793          	addi	a5,a5,1804 # 80005b60 <kernelvec>
    8000245c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002460:	6422                	ld	s0,8(sp)
    80002462:	0141                	addi	sp,sp,16
    80002464:	8082                	ret

0000000080002466 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002466:	1141                	addi	sp,sp,-16
    80002468:	e406                	sd	ra,8(sp)
    8000246a:	e022                	sd	s0,0(sp)
    8000246c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000246e:	fffff097          	auipc	ra,0xfffff
    80002472:	3c6080e7          	jalr	966(ra) # 80001834 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002476:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000247a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000247c:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send interrupts and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002480:	00005617          	auipc	a2,0x5
    80002484:	b8060613          	addi	a2,a2,-1152 # 80007000 <trampoline>
    80002488:	00005697          	auipc	a3,0x5
    8000248c:	b7868693          	addi	a3,a3,-1160 # 80007000 <trampoline>
    80002490:	8e91                	sub	a3,a3,a2
    80002492:	040007b7          	lui	a5,0x4000
    80002496:	17fd                	addi	a5,a5,-1
    80002498:	07b2                	slli	a5,a5,0xc
    8000249a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249c:	10569073          	csrw	stvec,a3

  // set up values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800024a0:	6938                	ld	a4,80(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024a2:	180026f3          	csrr	a3,satp
    800024a6:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024a8:	6938                	ld	a4,80(a0)
    800024aa:	7d14                	ld	a3,56(a0)
    800024ac:	6585                	lui	a1,0x1
    800024ae:	96ae                	add	a3,a3,a1
    800024b0:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    800024b2:	6938                	ld	a4,80(a0)
    800024b4:	00000697          	auipc	a3,0x0
    800024b8:	12868693          	addi	a3,a3,296 # 800025dc <usertrap>
    800024bc:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    800024be:	6938                	ld	a4,80(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024c0:	8692                	mv	a3,tp
    800024c2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024c4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024c8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024cc:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024d0:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    800024d4:	6938                	ld	a4,80(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024d6:	6f18                	ld	a4,24(a4)
    800024d8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024dc:	652c                	ld	a1,72(a0)
    800024de:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800024e0:	00005717          	auipc	a4,0x5
    800024e4:	bb070713          	addi	a4,a4,-1104 # 80007090 <userret>
    800024e8:	8f11                	sub	a4,a4,a2
    800024ea:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800024ec:	577d                	li	a4,-1
    800024ee:	177e                	slli	a4,a4,0x3f
    800024f0:	8dd9                	or	a1,a1,a4
    800024f2:	02000537          	lui	a0,0x2000
    800024f6:	157d                	addi	a0,a0,-1
    800024f8:	0536                	slli	a0,a0,0xd
    800024fa:	9782                	jalr	a5
}
    800024fc:	60a2                	ld	ra,8(sp)
    800024fe:	6402                	ld	s0,0(sp)
    80002500:	0141                	addi	sp,sp,16
    80002502:	8082                	ret

0000000080002504 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	e426                	sd	s1,8(sp)
    8000250c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    8000250e:	00015497          	auipc	s1,0x15
    80002512:	ff248493          	addi	s1,s1,-14 # 80017500 <tickslock>
    80002516:	8526                	mv	a0,s1
    80002518:	ffffe097          	auipc	ra,0xffffe
    8000251c:	5ba080e7          	jalr	1466(ra) # 80000ad2 <acquire>
  ticks++;
    80002520:	00027517          	auipc	a0,0x27
    80002524:	b0850513          	addi	a0,a0,-1272 # 80029028 <ticks>
    80002528:	411c                	lw	a5,0(a0)
    8000252a:	2785                	addiw	a5,a5,1
    8000252c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000252e:	00000097          	auipc	ra,0x0
    80002532:	c58080e7          	jalr	-936(ra) # 80002186 <wakeup>
  release(&tickslock);
    80002536:	8526                	mv	a0,s1
    80002538:	ffffe097          	auipc	ra,0xffffe
    8000253c:	602080e7          	jalr	1538(ra) # 80000b3a <release>
}
    80002540:	60e2                	ld	ra,24(sp)
    80002542:	6442                	ld	s0,16(sp)
    80002544:	64a2                	ld	s1,8(sp)
    80002546:	6105                	addi	sp,sp,32
    80002548:	8082                	ret

000000008000254a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000254a:	1101                	addi	sp,sp,-32
    8000254c:	ec06                	sd	ra,24(sp)
    8000254e:	e822                	sd	s0,16(sp)
    80002550:	e426                	sd	s1,8(sp)
    80002552:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002554:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002558:	00074d63          	bltz	a4,80002572 <devintr+0x28>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    8000255c:	57fd                	li	a5,-1
    8000255e:	17fe                	slli	a5,a5,0x3f
    80002560:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002562:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002564:	04f70b63          	beq	a4,a5,800025ba <devintr+0x70>
  }
}
    80002568:	60e2                	ld	ra,24(sp)
    8000256a:	6442                	ld	s0,16(sp)
    8000256c:	64a2                	ld	s1,8(sp)
    8000256e:	6105                	addi	sp,sp,32
    80002570:	8082                	ret
     (scause & 0xff) == 9){
    80002572:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002576:	46a5                	li	a3,9
    80002578:	fed792e3          	bne	a5,a3,8000255c <devintr+0x12>
    int irq = plic_claim();
    8000257c:	00003097          	auipc	ra,0x3
    80002580:	6fe080e7          	jalr	1790(ra) # 80005c7a <plic_claim>
    80002584:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002586:	47a9                	li	a5,10
    80002588:	00f50e63          	beq	a0,a5,800025a4 <devintr+0x5a>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    8000258c:	fff5079b          	addiw	a5,a0,-1
    80002590:	4705                	li	a4,1
    80002592:	00f77e63          	bgeu	a4,a5,800025ae <devintr+0x64>
    plic_complete(irq);
    80002596:	8526                	mv	a0,s1
    80002598:	00003097          	auipc	ra,0x3
    8000259c:	706080e7          	jalr	1798(ra) # 80005c9e <plic_complete>
    return 1;
    800025a0:	4505                	li	a0,1
    800025a2:	b7d9                	j	80002568 <devintr+0x1e>
      uartintr();
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	294080e7          	jalr	660(ra) # 80000838 <uartintr>
    800025ac:	b7ed                	j	80002596 <devintr+0x4c>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    800025ae:	853e                	mv	a0,a5
    800025b0:	00004097          	auipc	ra,0x4
    800025b4:	cb8080e7          	jalr	-840(ra) # 80006268 <virtio_disk_intr>
    800025b8:	bff9                	j	80002596 <devintr+0x4c>
    if(cpuid() == 0){
    800025ba:	fffff097          	auipc	ra,0xfffff
    800025be:	24e080e7          	jalr	590(ra) # 80001808 <cpuid>
    800025c2:	c901                	beqz	a0,800025d2 <devintr+0x88>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800025c4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800025c8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800025ca:	14479073          	csrw	sip,a5
    return 2;
    800025ce:	4509                	li	a0,2
    800025d0:	bf61                	j	80002568 <devintr+0x1e>
      clockintr();
    800025d2:	00000097          	auipc	ra,0x0
    800025d6:	f32080e7          	jalr	-206(ra) # 80002504 <clockintr>
    800025da:	b7ed                	j	800025c4 <devintr+0x7a>

00000000800025dc <usertrap>:
{
    800025dc:	1101                	addi	sp,sp,-32
    800025de:	ec06                	sd	ra,24(sp)
    800025e0:	e822                	sd	s0,16(sp)
    800025e2:	e426                	sd	s1,8(sp)
    800025e4:	e04a                	sd	s2,0(sp)
    800025e6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025e8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025ec:	1007f793          	andi	a5,a5,256
    800025f0:	e7bd                	bnez	a5,8000265e <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025f2:	00003797          	auipc	a5,0x3
    800025f6:	56e78793          	addi	a5,a5,1390 # 80005b60 <kernelvec>
    800025fa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025fe:	fffff097          	auipc	ra,0xfffff
    80002602:	236080e7          	jalr	566(ra) # 80001834 <myproc>
    80002606:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002608:	693c                	ld	a5,80(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000260a:	14102773          	csrr	a4,sepc
    8000260e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002610:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002614:	47a1                	li	a5,8
    80002616:	06f71163          	bne	a4,a5,80002678 <usertrap+0x9c>
    if(p->killed)
    8000261a:	591c                	lw	a5,48(a0)
    8000261c:	eba9                	bnez	a5,8000266e <usertrap+0x92>
    p->tf->epc += 4;
    8000261e:	68b8                	ld	a4,80(s1)
    80002620:	6f1c                	ld	a5,24(a4)
    80002622:	0791                	addi	a5,a5,4
    80002624:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002626:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000262a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000262e:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002632:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002636:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000263a:	10079073          	csrw	sstatus,a5
    syscall();
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	2dc080e7          	jalr	732(ra) # 8000291a <syscall>
  if(p->killed)
    80002646:	589c                	lw	a5,48(s1)
    80002648:	e7d1                	bnez	a5,800026d4 <usertrap+0xf8>
  usertrapret();
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	e1c080e7          	jalr	-484(ra) # 80002466 <usertrapret>
}
    80002652:	60e2                	ld	ra,24(sp)
    80002654:	6442                	ld	s0,16(sp)
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	6902                	ld	s2,0(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret
    panic("usertrap: not from user mode");
    8000265e:	00005517          	auipc	a0,0x5
    80002662:	d4a50513          	addi	a0,a0,-694 # 800073a8 <userret+0x318>
    80002666:	ffffe097          	auipc	ra,0xffffe
    8000266a:	ee8080e7          	jalr	-280(ra) # 8000054e <panic>
      exit();
    8000266e:	00000097          	auipc	ra,0x0
    80002672:	8b2080e7          	jalr	-1870(ra) # 80001f20 <exit>
    80002676:	b765                	j	8000261e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	ed2080e7          	jalr	-302(ra) # 8000254a <devintr>
    80002680:	892a                	mv	s2,a0
    80002682:	c501                	beqz	a0,8000268a <usertrap+0xae>
  if(p->killed)
    80002684:	589c                	lw	a5,48(s1)
    80002686:	cf9d                	beqz	a5,800026c4 <usertrap+0xe8>
    80002688:	a815                	j	800026bc <usertrap+0xe0>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000268a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000268e:	58d0                	lw	a2,52(s1)
    80002690:	00005517          	auipc	a0,0x5
    80002694:	d3850513          	addi	a0,a0,-712 # 800073c8 <userret+0x338>
    80002698:	ffffe097          	auipc	ra,0xffffe
    8000269c:	f00080e7          	jalr	-256(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026a0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026a4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800026a8:	00005517          	auipc	a0,0x5
    800026ac:	d5050513          	addi	a0,a0,-688 # 800073f8 <userret+0x368>
    800026b0:	ffffe097          	auipc	ra,0xffffe
    800026b4:	ee8080e7          	jalr	-280(ra) # 80000598 <printf>
    p->killed = 1;
    800026b8:	4785                	li	a5,1
    800026ba:	d89c                	sw	a5,48(s1)
    exit();
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	864080e7          	jalr	-1948(ra) # 80001f20 <exit>
  if(which_dev == 2)
    800026c4:	4789                	li	a5,2
    800026c6:	f8f912e3          	bne	s2,a5,8000264a <usertrap+0x6e>
    yield();
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	934080e7          	jalr	-1740(ra) # 80001ffe <yield>
    800026d2:	bfa5                	j	8000264a <usertrap+0x6e>
  int which_dev = 0;
    800026d4:	4901                	li	s2,0
    800026d6:	b7dd                	j	800026bc <usertrap+0xe0>

00000000800026d8 <kerneltrap>:
{
    800026d8:	7179                	addi	sp,sp,-48
    800026da:	f406                	sd	ra,40(sp)
    800026dc:	f022                	sd	s0,32(sp)
    800026de:	ec26                	sd	s1,24(sp)
    800026e0:	e84a                	sd	s2,16(sp)
    800026e2:	e44e                	sd	s3,8(sp)
    800026e4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026e6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ea:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026ee:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026f2:	1004f793          	andi	a5,s1,256
    800026f6:	cb85                	beqz	a5,80002726 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026f8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026fc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026fe:	ef85                	bnez	a5,80002736 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002700:	00000097          	auipc	ra,0x0
    80002704:	e4a080e7          	jalr	-438(ra) # 8000254a <devintr>
    80002708:	cd1d                	beqz	a0,80002746 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000270a:	4789                	li	a5,2
    8000270c:	06f50a63          	beq	a0,a5,80002780 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002710:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002714:	10049073          	csrw	sstatus,s1
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	addi	sp,sp,48
    80002724:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	cf250513          	addi	a0,a0,-782 # 80007418 <userret+0x388>
    8000272e:	ffffe097          	auipc	ra,0xffffe
    80002732:	e20080e7          	jalr	-480(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    80002736:	00005517          	auipc	a0,0x5
    8000273a:	d0a50513          	addi	a0,a0,-758 # 80007440 <userret+0x3b0>
    8000273e:	ffffe097          	auipc	ra,0xffffe
    80002742:	e10080e7          	jalr	-496(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    80002746:	85ce                	mv	a1,s3
    80002748:	00005517          	auipc	a0,0x5
    8000274c:	d1850513          	addi	a0,a0,-744 # 80007460 <userret+0x3d0>
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	e48080e7          	jalr	-440(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002758:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000275c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002760:	00005517          	auipc	a0,0x5
    80002764:	d1050513          	addi	a0,a0,-752 # 80007470 <userret+0x3e0>
    80002768:	ffffe097          	auipc	ra,0xffffe
    8000276c:	e30080e7          	jalr	-464(ra) # 80000598 <printf>
    panic("kerneltrap");
    80002770:	00005517          	auipc	a0,0x5
    80002774:	d1850513          	addi	a0,a0,-744 # 80007488 <userret+0x3f8>
    80002778:	ffffe097          	auipc	ra,0xffffe
    8000277c:	dd6080e7          	jalr	-554(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002780:	fffff097          	auipc	ra,0xfffff
    80002784:	0b4080e7          	jalr	180(ra) # 80001834 <myproc>
    80002788:	d541                	beqz	a0,80002710 <kerneltrap+0x38>
    8000278a:	fffff097          	auipc	ra,0xfffff
    8000278e:	0aa080e7          	jalr	170(ra) # 80001834 <myproc>
    80002792:	4d18                	lw	a4,24(a0)
    80002794:	478d                	li	a5,3
    80002796:	f6f71de3          	bne	a4,a5,80002710 <kerneltrap+0x38>
    yield();
    8000279a:	00000097          	auipc	ra,0x0
    8000279e:	864080e7          	jalr	-1948(ra) # 80001ffe <yield>
    800027a2:	b7bd                	j	80002710 <kerneltrap+0x38>

00000000800027a4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800027a4:	1101                	addi	sp,sp,-32
    800027a6:	ec06                	sd	ra,24(sp)
    800027a8:	e822                	sd	s0,16(sp)
    800027aa:	e426                	sd	s1,8(sp)
    800027ac:	1000                	addi	s0,sp,32
    800027ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027b0:	fffff097          	auipc	ra,0xfffff
    800027b4:	084080e7          	jalr	132(ra) # 80001834 <myproc>
  switch (n) {
    800027b8:	4795                	li	a5,5
    800027ba:	0497e163          	bltu	a5,s1,800027fc <argraw+0x58>
    800027be:	048a                	slli	s1,s1,0x2
    800027c0:	00005717          	auipc	a4,0x5
    800027c4:	13070713          	addi	a4,a4,304 # 800078f0 <states.1759+0x28>
    800027c8:	94ba                	add	s1,s1,a4
    800027ca:	409c                	lw	a5,0(s1)
    800027cc:	97ba                	add	a5,a5,a4
    800027ce:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    800027d0:	693c                	ld	a5,80(a0)
    800027d2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    800027d4:	60e2                	ld	ra,24(sp)
    800027d6:	6442                	ld	s0,16(sp)
    800027d8:	64a2                	ld	s1,8(sp)
    800027da:	6105                	addi	sp,sp,32
    800027dc:	8082                	ret
    return p->tf->a1;
    800027de:	693c                	ld	a5,80(a0)
    800027e0:	7fa8                	ld	a0,120(a5)
    800027e2:	bfcd                	j	800027d4 <argraw+0x30>
    return p->tf->a2;
    800027e4:	693c                	ld	a5,80(a0)
    800027e6:	63c8                	ld	a0,128(a5)
    800027e8:	b7f5                	j	800027d4 <argraw+0x30>
    return p->tf->a3;
    800027ea:	693c                	ld	a5,80(a0)
    800027ec:	67c8                	ld	a0,136(a5)
    800027ee:	b7dd                	j	800027d4 <argraw+0x30>
    return p->tf->a4;
    800027f0:	693c                	ld	a5,80(a0)
    800027f2:	6bc8                	ld	a0,144(a5)
    800027f4:	b7c5                	j	800027d4 <argraw+0x30>
    return p->tf->a5;
    800027f6:	693c                	ld	a5,80(a0)
    800027f8:	6fc8                	ld	a0,152(a5)
    800027fa:	bfe9                	j	800027d4 <argraw+0x30>
  panic("argraw");
    800027fc:	00005517          	auipc	a0,0x5
    80002800:	c9c50513          	addi	a0,a0,-868 # 80007498 <userret+0x408>
    80002804:	ffffe097          	auipc	ra,0xffffe
    80002808:	d4a080e7          	jalr	-694(ra) # 8000054e <panic>

000000008000280c <fetchaddr>:
{
    8000280c:	1101                	addi	sp,sp,-32
    8000280e:	ec06                	sd	ra,24(sp)
    80002810:	e822                	sd	s0,16(sp)
    80002812:	e426                	sd	s1,8(sp)
    80002814:	e04a                	sd	s2,0(sp)
    80002816:	1000                	addi	s0,sp,32
    80002818:	84aa                	mv	s1,a0
    8000281a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000281c:	fffff097          	auipc	ra,0xfffff
    80002820:	018080e7          	jalr	24(ra) # 80001834 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002824:	613c                	ld	a5,64(a0)
    80002826:	02f4f863          	bgeu	s1,a5,80002856 <fetchaddr+0x4a>
    8000282a:	00848713          	addi	a4,s1,8
    8000282e:	02e7e663          	bltu	a5,a4,8000285a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002832:	46a1                	li	a3,8
    80002834:	8626                	mv	a2,s1
    80002836:	85ca                	mv	a1,s2
    80002838:	6528                	ld	a0,72(a0)
    8000283a:	fffff097          	auipc	ra,0xfffff
    8000283e:	db2080e7          	jalr	-590(ra) # 800015ec <copyin>
    80002842:	00a03533          	snez	a0,a0
    80002846:	40a00533          	neg	a0,a0
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6902                	ld	s2,0(sp)
    80002852:	6105                	addi	sp,sp,32
    80002854:	8082                	ret
    return -1;
    80002856:	557d                	li	a0,-1
    80002858:	bfcd                	j	8000284a <fetchaddr+0x3e>
    8000285a:	557d                	li	a0,-1
    8000285c:	b7fd                	j	8000284a <fetchaddr+0x3e>

000000008000285e <fetchstr>:
{
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	1800                	addi	s0,sp,48
    8000286c:	892a                	mv	s2,a0
    8000286e:	84ae                	mv	s1,a1
    80002870:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	fc2080e7          	jalr	-62(ra) # 80001834 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000287a:	86ce                	mv	a3,s3
    8000287c:	864a                	mv	a2,s2
    8000287e:	85a6                	mv	a1,s1
    80002880:	6528                	ld	a0,72(a0)
    80002882:	fffff097          	auipc	ra,0xfffff
    80002886:	dfc080e7          	jalr	-516(ra) # 8000167e <copyinstr>
  if(err < 0)
    8000288a:	00054763          	bltz	a0,80002898 <fetchstr+0x3a>
  return strlen(buf);
    8000288e:	8526                	mv	a0,s1
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	48e080e7          	jalr	1166(ra) # 80000d1e <strlen>
}
    80002898:	70a2                	ld	ra,40(sp)
    8000289a:	7402                	ld	s0,32(sp)
    8000289c:	64e2                	ld	s1,24(sp)
    8000289e:	6942                	ld	s2,16(sp)
    800028a0:	69a2                	ld	s3,8(sp)
    800028a2:	6145                	addi	sp,sp,48
    800028a4:	8082                	ret

00000000800028a6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800028a6:	1101                	addi	sp,sp,-32
    800028a8:	ec06                	sd	ra,24(sp)
    800028aa:	e822                	sd	s0,16(sp)
    800028ac:	e426                	sd	s1,8(sp)
    800028ae:	1000                	addi	s0,sp,32
    800028b0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	ef2080e7          	jalr	-270(ra) # 800027a4 <argraw>
    800028ba:	c088                	sw	a0,0(s1)
  return 0;
}
    800028bc:	4501                	li	a0,0
    800028be:	60e2                	ld	ra,24(sp)
    800028c0:	6442                	ld	s0,16(sp)
    800028c2:	64a2                	ld	s1,8(sp)
    800028c4:	6105                	addi	sp,sp,32
    800028c6:	8082                	ret

00000000800028c8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800028c8:	1101                	addi	sp,sp,-32
    800028ca:	ec06                	sd	ra,24(sp)
    800028cc:	e822                	sd	s0,16(sp)
    800028ce:	e426                	sd	s1,8(sp)
    800028d0:	1000                	addi	s0,sp,32
    800028d2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	ed0080e7          	jalr	-304(ra) # 800027a4 <argraw>
    800028dc:	e088                	sd	a0,0(s1)
  return 0;
}
    800028de:	4501                	li	a0,0
    800028e0:	60e2                	ld	ra,24(sp)
    800028e2:	6442                	ld	s0,16(sp)
    800028e4:	64a2                	ld	s1,8(sp)
    800028e6:	6105                	addi	sp,sp,32
    800028e8:	8082                	ret

00000000800028ea <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028ea:	1101                	addi	sp,sp,-32
    800028ec:	ec06                	sd	ra,24(sp)
    800028ee:	e822                	sd	s0,16(sp)
    800028f0:	e426                	sd	s1,8(sp)
    800028f2:	e04a                	sd	s2,0(sp)
    800028f4:	1000                	addi	s0,sp,32
    800028f6:	84ae                	mv	s1,a1
    800028f8:	8932                	mv	s2,a2
  *ip = argraw(n);
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	eaa080e7          	jalr	-342(ra) # 800027a4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002902:	864a                	mv	a2,s2
    80002904:	85a6                	mv	a1,s1
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	f58080e7          	jalr	-168(ra) # 8000285e <fetchstr>
}
    8000290e:	60e2                	ld	ra,24(sp)
    80002910:	6442                	ld	s0,16(sp)
    80002912:	64a2                	ld	s1,8(sp)
    80002914:	6902                	ld	s2,0(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret

000000008000291a <syscall>:
[SYS_crash]   sys_crash,
};

void
syscall(void)
{
    8000291a:	1101                	addi	sp,sp,-32
    8000291c:	ec06                	sd	ra,24(sp)
    8000291e:	e822                	sd	s0,16(sp)
    80002920:	e426                	sd	s1,8(sp)
    80002922:	e04a                	sd	s2,0(sp)
    80002924:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002926:	fffff097          	auipc	ra,0xfffff
    8000292a:	f0e080e7          	jalr	-242(ra) # 80001834 <myproc>
    8000292e:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002930:	05053903          	ld	s2,80(a0)
    80002934:	0a893783          	ld	a5,168(s2)
    80002938:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000293c:	37fd                	addiw	a5,a5,-1
    8000293e:	4759                	li	a4,22
    80002940:	00f76f63          	bltu	a4,a5,8000295e <syscall+0x44>
    80002944:	00369713          	slli	a4,a3,0x3
    80002948:	00005797          	auipc	a5,0x5
    8000294c:	fc078793          	addi	a5,a5,-64 # 80007908 <syscalls>
    80002950:	97ba                	add	a5,a5,a4
    80002952:	639c                	ld	a5,0(a5)
    80002954:	c789                	beqz	a5,8000295e <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002956:	9782                	jalr	a5
    80002958:	06a93823          	sd	a0,112(s2)
    8000295c:	a839                	j	8000297a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000295e:	15048613          	addi	a2,s1,336
    80002962:	58cc                	lw	a1,52(s1)
    80002964:	00005517          	auipc	a0,0x5
    80002968:	b3c50513          	addi	a0,a0,-1220 # 800074a0 <userret+0x410>
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	c2c080e7          	jalr	-980(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002974:	68bc                	ld	a5,80(s1)
    80002976:	577d                	li	a4,-1
    80002978:	fbb8                	sd	a4,112(a5)
  }
}
    8000297a:	60e2                	ld	ra,24(sp)
    8000297c:	6442                	ld	s0,16(sp)
    8000297e:	64a2                	ld	s1,8(sp)
    80002980:	6902                	ld	s2,0(sp)
    80002982:	6105                	addi	sp,sp,32
    80002984:	8082                	ret

0000000080002986 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002986:	1141                	addi	sp,sp,-16
    80002988:	e406                	sd	ra,8(sp)
    8000298a:	e022                	sd	s0,0(sp)
    8000298c:	0800                	addi	s0,sp,16
  exit();
    8000298e:	fffff097          	auipc	ra,0xfffff
    80002992:	592080e7          	jalr	1426(ra) # 80001f20 <exit>
  return 0;  // not reached
}
    80002996:	4501                	li	a0,0
    80002998:	60a2                	ld	ra,8(sp)
    8000299a:	6402                	ld	s0,0(sp)
    8000299c:	0141                	addi	sp,sp,16
    8000299e:	8082                	ret

00000000800029a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800029a0:	1141                	addi	sp,sp,-16
    800029a2:	e406                	sd	ra,8(sp)
    800029a4:	e022                	sd	s0,0(sp)
    800029a6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800029a8:	fffff097          	auipc	ra,0xfffff
    800029ac:	e8c080e7          	jalr	-372(ra) # 80001834 <myproc>
}
    800029b0:	5948                	lw	a0,52(a0)
    800029b2:	60a2                	ld	ra,8(sp)
    800029b4:	6402                	ld	s0,0(sp)
    800029b6:	0141                	addi	sp,sp,16
    800029b8:	8082                	ret

00000000800029ba <sys_fork>:

uint64
sys_fork(void)
{
    800029ba:	1141                	addi	sp,sp,-16
    800029bc:	e406                	sd	ra,8(sp)
    800029be:	e022                	sd	s0,0(sp)
    800029c0:	0800                	addi	s0,sp,16
  return fork();
    800029c2:	fffff097          	auipc	ra,0xfffff
    800029c6:	1dc080e7          	jalr	476(ra) # 80001b9e <fork>
}
    800029ca:	60a2                	ld	ra,8(sp)
    800029cc:	6402                	ld	s0,0(sp)
    800029ce:	0141                	addi	sp,sp,16
    800029d0:	8082                	ret

00000000800029d2 <sys_wait>:

uint64
sys_wait(void)
{
    800029d2:	1141                	addi	sp,sp,-16
    800029d4:	e406                	sd	ra,8(sp)
    800029d6:	e022                	sd	s0,0(sp)
    800029d8:	0800                	addi	s0,sp,16
  return wait();
    800029da:	fffff097          	auipc	ra,0xfffff
    800029de:	6de080e7          	jalr	1758(ra) # 800020b8 <wait>
}
    800029e2:	60a2                	ld	ra,8(sp)
    800029e4:	6402                	ld	s0,0(sp)
    800029e6:	0141                	addi	sp,sp,16
    800029e8:	8082                	ret

00000000800029ea <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800029f4:	fdc40593          	addi	a1,s0,-36
    800029f8:	4501                	li	a0,0
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	eac080e7          	jalr	-340(ra) # 800028a6 <argint>
    80002a02:	87aa                	mv	a5,a0
    return -1;
    80002a04:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002a06:	0207c063          	bltz	a5,80002a26 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002a0a:	fffff097          	auipc	ra,0xfffff
    80002a0e:	e2a080e7          	jalr	-470(ra) # 80001834 <myproc>
    80002a12:	4124                	lw	s1,64(a0)
  if(growproc(n) < 0)
    80002a14:	fdc42503          	lw	a0,-36(s0)
    80002a18:	fffff097          	auipc	ra,0xfffff
    80002a1c:	10e080e7          	jalr	270(ra) # 80001b26 <growproc>
    80002a20:	00054863          	bltz	a0,80002a30 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002a24:	8526                	mv	a0,s1
}
    80002a26:	70a2                	ld	ra,40(sp)
    80002a28:	7402                	ld	s0,32(sp)
    80002a2a:	64e2                	ld	s1,24(sp)
    80002a2c:	6145                	addi	sp,sp,48
    80002a2e:	8082                	ret
    return -1;
    80002a30:	557d                	li	a0,-1
    80002a32:	bfd5                	j	80002a26 <sys_sbrk+0x3c>

0000000080002a34 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a34:	7139                	addi	sp,sp,-64
    80002a36:	fc06                	sd	ra,56(sp)
    80002a38:	f822                	sd	s0,48(sp)
    80002a3a:	f426                	sd	s1,40(sp)
    80002a3c:	f04a                	sd	s2,32(sp)
    80002a3e:	ec4e                	sd	s3,24(sp)
    80002a40:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002a42:	fcc40593          	addi	a1,s0,-52
    80002a46:	4501                	li	a0,0
    80002a48:	00000097          	auipc	ra,0x0
    80002a4c:	e5e080e7          	jalr	-418(ra) # 800028a6 <argint>
    return -1;
    80002a50:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002a52:	06054563          	bltz	a0,80002abc <sys_sleep+0x88>
  acquire(&tickslock);
    80002a56:	00015517          	auipc	a0,0x15
    80002a5a:	aaa50513          	addi	a0,a0,-1366 # 80017500 <tickslock>
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	074080e7          	jalr	116(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    80002a66:	00026917          	auipc	s2,0x26
    80002a6a:	5c292903          	lw	s2,1474(s2) # 80029028 <ticks>
  while(ticks - ticks0 < n){
    80002a6e:	fcc42783          	lw	a5,-52(s0)
    80002a72:	cf85                	beqz	a5,80002aaa <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a74:	00015997          	auipc	s3,0x15
    80002a78:	a8c98993          	addi	s3,s3,-1396 # 80017500 <tickslock>
    80002a7c:	00026497          	auipc	s1,0x26
    80002a80:	5ac48493          	addi	s1,s1,1452 # 80029028 <ticks>
    if(myproc()->killed){
    80002a84:	fffff097          	auipc	ra,0xfffff
    80002a88:	db0080e7          	jalr	-592(ra) # 80001834 <myproc>
    80002a8c:	591c                	lw	a5,48(a0)
    80002a8e:	ef9d                	bnez	a5,80002acc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002a90:	85ce                	mv	a1,s3
    80002a92:	8526                	mv	a0,s1
    80002a94:	fffff097          	auipc	ra,0xfffff
    80002a98:	5a6080e7          	jalr	1446(ra) # 8000203a <sleep>
  while(ticks - ticks0 < n){
    80002a9c:	409c                	lw	a5,0(s1)
    80002a9e:	412787bb          	subw	a5,a5,s2
    80002aa2:	fcc42703          	lw	a4,-52(s0)
    80002aa6:	fce7efe3          	bltu	a5,a4,80002a84 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002aaa:	00015517          	auipc	a0,0x15
    80002aae:	a5650513          	addi	a0,a0,-1450 # 80017500 <tickslock>
    80002ab2:	ffffe097          	auipc	ra,0xffffe
    80002ab6:	088080e7          	jalr	136(ra) # 80000b3a <release>
  return 0;
    80002aba:	4781                	li	a5,0
}
    80002abc:	853e                	mv	a0,a5
    80002abe:	70e2                	ld	ra,56(sp)
    80002ac0:	7442                	ld	s0,48(sp)
    80002ac2:	74a2                	ld	s1,40(sp)
    80002ac4:	7902                	ld	s2,32(sp)
    80002ac6:	69e2                	ld	s3,24(sp)
    80002ac8:	6121                	addi	sp,sp,64
    80002aca:	8082                	ret
      release(&tickslock);
    80002acc:	00015517          	auipc	a0,0x15
    80002ad0:	a3450513          	addi	a0,a0,-1484 # 80017500 <tickslock>
    80002ad4:	ffffe097          	auipc	ra,0xffffe
    80002ad8:	066080e7          	jalr	102(ra) # 80000b3a <release>
      return -1;
    80002adc:	57fd                	li	a5,-1
    80002ade:	bff9                	j	80002abc <sys_sleep+0x88>

0000000080002ae0 <sys_kill>:

uint64
sys_kill(void)
{
    80002ae0:	1101                	addi	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ae8:	fec40593          	addi	a1,s0,-20
    80002aec:	4501                	li	a0,0
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	db8080e7          	jalr	-584(ra) # 800028a6 <argint>
    80002af6:	87aa                	mv	a5,a0
    return -1;
    80002af8:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002afa:	0007c863          	bltz	a5,80002b0a <sys_kill+0x2a>
  return kill(pid);
    80002afe:	fec42503          	lw	a0,-20(s0)
    80002b02:	fffff097          	auipc	ra,0xfffff
    80002b06:	6ee080e7          	jalr	1774(ra) # 800021f0 <kill>
}
    80002b0a:	60e2                	ld	ra,24(sp)
    80002b0c:	6442                	ld	s0,16(sp)
    80002b0e:	6105                	addi	sp,sp,32
    80002b10:	8082                	ret

0000000080002b12 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b12:	1101                	addi	sp,sp,-32
    80002b14:	ec06                	sd	ra,24(sp)
    80002b16:	e822                	sd	s0,16(sp)
    80002b18:	e426                	sd	s1,8(sp)
    80002b1a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b1c:	00015517          	auipc	a0,0x15
    80002b20:	9e450513          	addi	a0,a0,-1564 # 80017500 <tickslock>
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	fae080e7          	jalr	-82(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80002b2c:	00026497          	auipc	s1,0x26
    80002b30:	4fc4a483          	lw	s1,1276(s1) # 80029028 <ticks>
  release(&tickslock);
    80002b34:	00015517          	auipc	a0,0x15
    80002b38:	9cc50513          	addi	a0,a0,-1588 # 80017500 <tickslock>
    80002b3c:	ffffe097          	auipc	ra,0xffffe
    80002b40:	ffe080e7          	jalr	-2(ra) # 80000b3a <release>
  return xticks;
}
    80002b44:	02049513          	slli	a0,s1,0x20
    80002b48:	9101                	srli	a0,a0,0x20
    80002b4a:	60e2                	ld	ra,24(sp)
    80002b4c:	6442                	ld	s0,16(sp)
    80002b4e:	64a2                	ld	s1,8(sp)
    80002b50:	6105                	addi	sp,sp,32
    80002b52:	8082                	ret

0000000080002b54 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b54:	7179                	addi	sp,sp,-48
    80002b56:	f406                	sd	ra,40(sp)
    80002b58:	f022                	sd	s0,32(sp)
    80002b5a:	ec26                	sd	s1,24(sp)
    80002b5c:	e84a                	sd	s2,16(sp)
    80002b5e:	e44e                	sd	s3,8(sp)
    80002b60:	e052                	sd	s4,0(sp)
    80002b62:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b64:	00005597          	auipc	a1,0x5
    80002b68:	95c58593          	addi	a1,a1,-1700 # 800074c0 <userret+0x430>
    80002b6c:	00015517          	auipc	a0,0x15
    80002b70:	9ac50513          	addi	a0,a0,-1620 # 80017518 <bcache>
    80002b74:	ffffe097          	auipc	ra,0xffffe
    80002b78:	e4c080e7          	jalr	-436(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b7c:	0001d797          	auipc	a5,0x1d
    80002b80:	99c78793          	addi	a5,a5,-1636 # 8001f518 <bcache+0x8000>
    80002b84:	0001d717          	auipc	a4,0x1d
    80002b88:	cec70713          	addi	a4,a4,-788 # 8001f870 <bcache+0x8358>
    80002b8c:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002b90:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b94:	00015497          	auipc	s1,0x15
    80002b98:	99c48493          	addi	s1,s1,-1636 # 80017530 <bcache+0x18>
    b->next = bcache.head.next;
    80002b9c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b9e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ba0:	00005a17          	auipc	s4,0x5
    80002ba4:	928a0a13          	addi	s4,s4,-1752 # 800074c8 <userret+0x438>
    b->next = bcache.head.next;
    80002ba8:	3a893783          	ld	a5,936(s2)
    80002bac:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bae:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bb2:	85d2                	mv	a1,s4
    80002bb4:	01048513          	addi	a0,s1,16
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	6f2080e7          	jalr	1778(ra) # 800042aa <initsleeplock>
    bcache.head.next->prev = b;
    80002bc0:	3a893783          	ld	a5,936(s2)
    80002bc4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bc6:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bca:	46048493          	addi	s1,s1,1120
    80002bce:	fd349de3          	bne	s1,s3,80002ba8 <binit+0x54>
  }
}
    80002bd2:	70a2                	ld	ra,40(sp)
    80002bd4:	7402                	ld	s0,32(sp)
    80002bd6:	64e2                	ld	s1,24(sp)
    80002bd8:	6942                	ld	s2,16(sp)
    80002bda:	69a2                	ld	s3,8(sp)
    80002bdc:	6a02                	ld	s4,0(sp)
    80002bde:	6145                	addi	sp,sp,48
    80002be0:	8082                	ret

0000000080002be2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002be2:	7179                	addi	sp,sp,-48
    80002be4:	f406                	sd	ra,40(sp)
    80002be6:	f022                	sd	s0,32(sp)
    80002be8:	ec26                	sd	s1,24(sp)
    80002bea:	e84a                	sd	s2,16(sp)
    80002bec:	e44e                	sd	s3,8(sp)
    80002bee:	1800                	addi	s0,sp,48
    80002bf0:	89aa                	mv	s3,a0
    80002bf2:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002bf4:	00015517          	auipc	a0,0x15
    80002bf8:	92450513          	addi	a0,a0,-1756 # 80017518 <bcache>
    80002bfc:	ffffe097          	auipc	ra,0xffffe
    80002c00:	ed6080e7          	jalr	-298(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c04:	0001d497          	auipc	s1,0x1d
    80002c08:	cbc4b483          	ld	s1,-836(s1) # 8001f8c0 <bcache+0x83a8>
    80002c0c:	0001d797          	auipc	a5,0x1d
    80002c10:	c6478793          	addi	a5,a5,-924 # 8001f870 <bcache+0x8358>
    80002c14:	02f48f63          	beq	s1,a5,80002c52 <bread+0x70>
    80002c18:	873e                	mv	a4,a5
    80002c1a:	a021                	j	80002c22 <bread+0x40>
    80002c1c:	68a4                	ld	s1,80(s1)
    80002c1e:	02e48a63          	beq	s1,a4,80002c52 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002c22:	449c                	lw	a5,8(s1)
    80002c24:	ff379ce3          	bne	a5,s3,80002c1c <bread+0x3a>
    80002c28:	44dc                	lw	a5,12(s1)
    80002c2a:	ff2799e3          	bne	a5,s2,80002c1c <bread+0x3a>
      b->refcnt++;
    80002c2e:	40bc                	lw	a5,64(s1)
    80002c30:	2785                	addiw	a5,a5,1
    80002c32:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c34:	00015517          	auipc	a0,0x15
    80002c38:	8e450513          	addi	a0,a0,-1820 # 80017518 <bcache>
    80002c3c:	ffffe097          	auipc	ra,0xffffe
    80002c40:	efe080e7          	jalr	-258(ra) # 80000b3a <release>
      acquiresleep(&b->lock);
    80002c44:	01048513          	addi	a0,s1,16
    80002c48:	00001097          	auipc	ra,0x1
    80002c4c:	69c080e7          	jalr	1692(ra) # 800042e4 <acquiresleep>
      return b;
    80002c50:	a8b9                	j	80002cae <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c52:	0001d497          	auipc	s1,0x1d
    80002c56:	c664b483          	ld	s1,-922(s1) # 8001f8b8 <bcache+0x83a0>
    80002c5a:	0001d797          	auipc	a5,0x1d
    80002c5e:	c1678793          	addi	a5,a5,-1002 # 8001f870 <bcache+0x8358>
    80002c62:	00f48863          	beq	s1,a5,80002c72 <bread+0x90>
    80002c66:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c68:	40bc                	lw	a5,64(s1)
    80002c6a:	cf81                	beqz	a5,80002c82 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c6c:	64a4                	ld	s1,72(s1)
    80002c6e:	fee49de3          	bne	s1,a4,80002c68 <bread+0x86>
  panic("bget: no buffers");
    80002c72:	00005517          	auipc	a0,0x5
    80002c76:	85e50513          	addi	a0,a0,-1954 # 800074d0 <userret+0x440>
    80002c7a:	ffffe097          	auipc	ra,0xffffe
    80002c7e:	8d4080e7          	jalr	-1836(ra) # 8000054e <panic>
      b->dev = dev;
    80002c82:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002c86:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002c8a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c8e:	4785                	li	a5,1
    80002c90:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c92:	00015517          	auipc	a0,0x15
    80002c96:	88650513          	addi	a0,a0,-1914 # 80017518 <bcache>
    80002c9a:	ffffe097          	auipc	ra,0xffffe
    80002c9e:	ea0080e7          	jalr	-352(ra) # 80000b3a <release>
      acquiresleep(&b->lock);
    80002ca2:	01048513          	addi	a0,s1,16
    80002ca6:	00001097          	auipc	ra,0x1
    80002caa:	63e080e7          	jalr	1598(ra) # 800042e4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cae:	409c                	lw	a5,0(s1)
    80002cb0:	cb89                	beqz	a5,80002cc2 <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	70a2                	ld	ra,40(sp)
    80002cb6:	7402                	ld	s0,32(sp)
    80002cb8:	64e2                	ld	s1,24(sp)
    80002cba:	6942                	ld	s2,16(sp)
    80002cbc:	69a2                	ld	s3,8(sp)
    80002cbe:	6145                	addi	sp,sp,48
    80002cc0:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    80002cc2:	4601                	li	a2,0
    80002cc4:	85a6                	mv	a1,s1
    80002cc6:	4488                	lw	a0,8(s1)
    80002cc8:	00003097          	auipc	ra,0x3
    80002ccc:	288080e7          	jalr	648(ra) # 80005f50 <virtio_disk_rw>
    b->valid = 1;
    80002cd0:	4785                	li	a5,1
    80002cd2:	c09c                	sw	a5,0(s1)
  return b;
    80002cd4:	bff9                	j	80002cb2 <bread+0xd0>

0000000080002cd6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	1000                	addi	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ce2:	0541                	addi	a0,a0,16
    80002ce4:	00001097          	auipc	ra,0x1
    80002ce8:	69a080e7          	jalr	1690(ra) # 8000437e <holdingsleep>
    80002cec:	cd09                	beqz	a0,80002d06 <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    80002cee:	4605                	li	a2,1
    80002cf0:	85a6                	mv	a1,s1
    80002cf2:	4488                	lw	a0,8(s1)
    80002cf4:	00003097          	auipc	ra,0x3
    80002cf8:	25c080e7          	jalr	604(ra) # 80005f50 <virtio_disk_rw>
}
    80002cfc:	60e2                	ld	ra,24(sp)
    80002cfe:	6442                	ld	s0,16(sp)
    80002d00:	64a2                	ld	s1,8(sp)
    80002d02:	6105                	addi	sp,sp,32
    80002d04:	8082                	ret
    panic("bwrite");
    80002d06:	00004517          	auipc	a0,0x4
    80002d0a:	7e250513          	addi	a0,a0,2018 # 800074e8 <userret+0x458>
    80002d0e:	ffffe097          	auipc	ra,0xffffe
    80002d12:	840080e7          	jalr	-1984(ra) # 8000054e <panic>

0000000080002d16 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002d16:	1101                	addi	sp,sp,-32
    80002d18:	ec06                	sd	ra,24(sp)
    80002d1a:	e822                	sd	s0,16(sp)
    80002d1c:	e426                	sd	s1,8(sp)
    80002d1e:	e04a                	sd	s2,0(sp)
    80002d20:	1000                	addi	s0,sp,32
    80002d22:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d24:	01050913          	addi	s2,a0,16
    80002d28:	854a                	mv	a0,s2
    80002d2a:	00001097          	auipc	ra,0x1
    80002d2e:	654080e7          	jalr	1620(ra) # 8000437e <holdingsleep>
    80002d32:	c92d                	beqz	a0,80002da4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00001097          	auipc	ra,0x1
    80002d3a:	604080e7          	jalr	1540(ra) # 8000433a <releasesleep>

  acquire(&bcache.lock);
    80002d3e:	00014517          	auipc	a0,0x14
    80002d42:	7da50513          	addi	a0,a0,2010 # 80017518 <bcache>
    80002d46:	ffffe097          	auipc	ra,0xffffe
    80002d4a:	d8c080e7          	jalr	-628(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80002d4e:	40bc                	lw	a5,64(s1)
    80002d50:	37fd                	addiw	a5,a5,-1
    80002d52:	0007871b          	sext.w	a4,a5
    80002d56:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d58:	eb05                	bnez	a4,80002d88 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d5a:	68bc                	ld	a5,80(s1)
    80002d5c:	64b8                	ld	a4,72(s1)
    80002d5e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002d60:	64bc                	ld	a5,72(s1)
    80002d62:	68b8                	ld	a4,80(s1)
    80002d64:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d66:	0001c797          	auipc	a5,0x1c
    80002d6a:	7b278793          	addi	a5,a5,1970 # 8001f518 <bcache+0x8000>
    80002d6e:	3a87b703          	ld	a4,936(a5)
    80002d72:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d74:	0001d717          	auipc	a4,0x1d
    80002d78:	afc70713          	addi	a4,a4,-1284 # 8001f870 <bcache+0x8358>
    80002d7c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d7e:	3a87b703          	ld	a4,936(a5)
    80002d82:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d84:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80002d88:	00014517          	auipc	a0,0x14
    80002d8c:	79050513          	addi	a0,a0,1936 # 80017518 <bcache>
    80002d90:	ffffe097          	auipc	ra,0xffffe
    80002d94:	daa080e7          	jalr	-598(ra) # 80000b3a <release>
}
    80002d98:	60e2                	ld	ra,24(sp)
    80002d9a:	6442                	ld	s0,16(sp)
    80002d9c:	64a2                	ld	s1,8(sp)
    80002d9e:	6902                	ld	s2,0(sp)
    80002da0:	6105                	addi	sp,sp,32
    80002da2:	8082                	ret
    panic("brelse");
    80002da4:	00004517          	auipc	a0,0x4
    80002da8:	74c50513          	addi	a0,a0,1868 # 800074f0 <userret+0x460>
    80002dac:	ffffd097          	auipc	ra,0xffffd
    80002db0:	7a2080e7          	jalr	1954(ra) # 8000054e <panic>

0000000080002db4 <bpin>:

void
bpin(struct buf *b) {
    80002db4:	1101                	addi	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	e426                	sd	s1,8(sp)
    80002dbc:	1000                	addi	s0,sp,32
    80002dbe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dc0:	00014517          	auipc	a0,0x14
    80002dc4:	75850513          	addi	a0,a0,1880 # 80017518 <bcache>
    80002dc8:	ffffe097          	auipc	ra,0xffffe
    80002dcc:	d0a080e7          	jalr	-758(ra) # 80000ad2 <acquire>
  b->refcnt++;
    80002dd0:	40bc                	lw	a5,64(s1)
    80002dd2:	2785                	addiw	a5,a5,1
    80002dd4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002dd6:	00014517          	auipc	a0,0x14
    80002dda:	74250513          	addi	a0,a0,1858 # 80017518 <bcache>
    80002dde:	ffffe097          	auipc	ra,0xffffe
    80002de2:	d5c080e7          	jalr	-676(ra) # 80000b3a <release>
}
    80002de6:	60e2                	ld	ra,24(sp)
    80002de8:	6442                	ld	s0,16(sp)
    80002dea:	64a2                	ld	s1,8(sp)
    80002dec:	6105                	addi	sp,sp,32
    80002dee:	8082                	ret

0000000080002df0 <bunpin>:

void
bunpin(struct buf *b) {
    80002df0:	1101                	addi	sp,sp,-32
    80002df2:	ec06                	sd	ra,24(sp)
    80002df4:	e822                	sd	s0,16(sp)
    80002df6:	e426                	sd	s1,8(sp)
    80002df8:	1000                	addi	s0,sp,32
    80002dfa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dfc:	00014517          	auipc	a0,0x14
    80002e00:	71c50513          	addi	a0,a0,1820 # 80017518 <bcache>
    80002e04:	ffffe097          	auipc	ra,0xffffe
    80002e08:	cce080e7          	jalr	-818(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80002e0c:	40bc                	lw	a5,64(s1)
    80002e0e:	37fd                	addiw	a5,a5,-1
    80002e10:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e12:	00014517          	auipc	a0,0x14
    80002e16:	70650513          	addi	a0,a0,1798 # 80017518 <bcache>
    80002e1a:	ffffe097          	auipc	ra,0xffffe
    80002e1e:	d20080e7          	jalr	-736(ra) # 80000b3a <release>
}
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6105                	addi	sp,sp,32
    80002e2a:	8082                	ret

0000000080002e2c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e2c:	1101                	addi	sp,sp,-32
    80002e2e:	ec06                	sd	ra,24(sp)
    80002e30:	e822                	sd	s0,16(sp)
    80002e32:	e426                	sd	s1,8(sp)
    80002e34:	e04a                	sd	s2,0(sp)
    80002e36:	1000                	addi	s0,sp,32
    80002e38:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e3a:	00d5d59b          	srliw	a1,a1,0xd
    80002e3e:	0001d797          	auipc	a5,0x1d
    80002e42:	eae7a783          	lw	a5,-338(a5) # 8001fcec <sb+0x1c>
    80002e46:	9dbd                	addw	a1,a1,a5
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	d9a080e7          	jalr	-614(ra) # 80002be2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e50:	0074f713          	andi	a4,s1,7
    80002e54:	4785                	li	a5,1
    80002e56:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e5a:	14ce                	slli	s1,s1,0x33
    80002e5c:	90d9                	srli	s1,s1,0x36
    80002e5e:	00950733          	add	a4,a0,s1
    80002e62:	06074703          	lbu	a4,96(a4)
    80002e66:	00e7f6b3          	and	a3,a5,a4
    80002e6a:	c69d                	beqz	a3,80002e98 <bfree+0x6c>
    80002e6c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e6e:	94aa                	add	s1,s1,a0
    80002e70:	fff7c793          	not	a5,a5
    80002e74:	8ff9                	and	a5,a5,a4
    80002e76:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002e7a:	00001097          	auipc	ra,0x1
    80002e7e:	1d2080e7          	jalr	466(ra) # 8000404c <log_write>
  brelse(bp);
    80002e82:	854a                	mv	a0,s2
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	e92080e7          	jalr	-366(ra) # 80002d16 <brelse>
}
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6902                	ld	s2,0(sp)
    80002e94:	6105                	addi	sp,sp,32
    80002e96:	8082                	ret
    panic("freeing free block");
    80002e98:	00004517          	auipc	a0,0x4
    80002e9c:	66050513          	addi	a0,a0,1632 # 800074f8 <userret+0x468>
    80002ea0:	ffffd097          	auipc	ra,0xffffd
    80002ea4:	6ae080e7          	jalr	1710(ra) # 8000054e <panic>

0000000080002ea8 <balloc>:
{
    80002ea8:	711d                	addi	sp,sp,-96
    80002eaa:	ec86                	sd	ra,88(sp)
    80002eac:	e8a2                	sd	s0,80(sp)
    80002eae:	e4a6                	sd	s1,72(sp)
    80002eb0:	e0ca                	sd	s2,64(sp)
    80002eb2:	fc4e                	sd	s3,56(sp)
    80002eb4:	f852                	sd	s4,48(sp)
    80002eb6:	f456                	sd	s5,40(sp)
    80002eb8:	f05a                	sd	s6,32(sp)
    80002eba:	ec5e                	sd	s7,24(sp)
    80002ebc:	e862                	sd	s8,16(sp)
    80002ebe:	e466                	sd	s9,8(sp)
    80002ec0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002ec2:	0001d797          	auipc	a5,0x1d
    80002ec6:	e127a783          	lw	a5,-494(a5) # 8001fcd4 <sb+0x4>
    80002eca:	cbd1                	beqz	a5,80002f5e <balloc+0xb6>
    80002ecc:	8baa                	mv	s7,a0
    80002ece:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ed0:	0001db17          	auipc	s6,0x1d
    80002ed4:	e00b0b13          	addi	s6,s6,-512 # 8001fcd0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ed8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002eda:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002edc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002ede:	6c89                	lui	s9,0x2
    80002ee0:	a831                	j	80002efc <balloc+0x54>
    brelse(bp);
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	00000097          	auipc	ra,0x0
    80002ee8:	e32080e7          	jalr	-462(ra) # 80002d16 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002eec:	015c87bb          	addw	a5,s9,s5
    80002ef0:	00078a9b          	sext.w	s5,a5
    80002ef4:	004b2703          	lw	a4,4(s6)
    80002ef8:	06eaf363          	bgeu	s5,a4,80002f5e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002efc:	41fad79b          	sraiw	a5,s5,0x1f
    80002f00:	0137d79b          	srliw	a5,a5,0x13
    80002f04:	015787bb          	addw	a5,a5,s5
    80002f08:	40d7d79b          	sraiw	a5,a5,0xd
    80002f0c:	01cb2583          	lw	a1,28(s6)
    80002f10:	9dbd                	addw	a1,a1,a5
    80002f12:	855e                	mv	a0,s7
    80002f14:	00000097          	auipc	ra,0x0
    80002f18:	cce080e7          	jalr	-818(ra) # 80002be2 <bread>
    80002f1c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f1e:	004b2503          	lw	a0,4(s6)
    80002f22:	000a849b          	sext.w	s1,s5
    80002f26:	8662                	mv	a2,s8
    80002f28:	faa4fde3          	bgeu	s1,a0,80002ee2 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002f2c:	41f6579b          	sraiw	a5,a2,0x1f
    80002f30:	01d7d69b          	srliw	a3,a5,0x1d
    80002f34:	00c6873b          	addw	a4,a3,a2
    80002f38:	00777793          	andi	a5,a4,7
    80002f3c:	9f95                	subw	a5,a5,a3
    80002f3e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f42:	4037571b          	sraiw	a4,a4,0x3
    80002f46:	00e906b3          	add	a3,s2,a4
    80002f4a:	0606c683          	lbu	a3,96(a3)
    80002f4e:	00d7f5b3          	and	a1,a5,a3
    80002f52:	cd91                	beqz	a1,80002f6e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f54:	2605                	addiw	a2,a2,1
    80002f56:	2485                	addiw	s1,s1,1
    80002f58:	fd4618e3          	bne	a2,s4,80002f28 <balloc+0x80>
    80002f5c:	b759                	j	80002ee2 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002f5e:	00004517          	auipc	a0,0x4
    80002f62:	5b250513          	addi	a0,a0,1458 # 80007510 <userret+0x480>
    80002f66:	ffffd097          	auipc	ra,0xffffd
    80002f6a:	5e8080e7          	jalr	1512(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f6e:	974a                	add	a4,a4,s2
    80002f70:	8fd5                	or	a5,a5,a3
    80002f72:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002f76:	854a                	mv	a0,s2
    80002f78:	00001097          	auipc	ra,0x1
    80002f7c:	0d4080e7          	jalr	212(ra) # 8000404c <log_write>
        brelse(bp);
    80002f80:	854a                	mv	a0,s2
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	d94080e7          	jalr	-620(ra) # 80002d16 <brelse>
  bp = bread(dev, bno);
    80002f8a:	85a6                	mv	a1,s1
    80002f8c:	855e                	mv	a0,s7
    80002f8e:	00000097          	auipc	ra,0x0
    80002f92:	c54080e7          	jalr	-940(ra) # 80002be2 <bread>
    80002f96:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f98:	40000613          	li	a2,1024
    80002f9c:	4581                	li	a1,0
    80002f9e:	06050513          	addi	a0,a0,96
    80002fa2:	ffffe097          	auipc	ra,0xffffe
    80002fa6:	bf4080e7          	jalr	-1036(ra) # 80000b96 <memset>
  log_write(bp);
    80002faa:	854a                	mv	a0,s2
    80002fac:	00001097          	auipc	ra,0x1
    80002fb0:	0a0080e7          	jalr	160(ra) # 8000404c <log_write>
  brelse(bp);
    80002fb4:	854a                	mv	a0,s2
    80002fb6:	00000097          	auipc	ra,0x0
    80002fba:	d60080e7          	jalr	-672(ra) # 80002d16 <brelse>
}
    80002fbe:	8526                	mv	a0,s1
    80002fc0:	60e6                	ld	ra,88(sp)
    80002fc2:	6446                	ld	s0,80(sp)
    80002fc4:	64a6                	ld	s1,72(sp)
    80002fc6:	6906                	ld	s2,64(sp)
    80002fc8:	79e2                	ld	s3,56(sp)
    80002fca:	7a42                	ld	s4,48(sp)
    80002fcc:	7aa2                	ld	s5,40(sp)
    80002fce:	7b02                	ld	s6,32(sp)
    80002fd0:	6be2                	ld	s7,24(sp)
    80002fd2:	6c42                	ld	s8,16(sp)
    80002fd4:	6ca2                	ld	s9,8(sp)
    80002fd6:	6125                	addi	sp,sp,96
    80002fd8:	8082                	ret

0000000080002fda <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fda:	7179                	addi	sp,sp,-48
    80002fdc:	f406                	sd	ra,40(sp)
    80002fde:	f022                	sd	s0,32(sp)
    80002fe0:	ec26                	sd	s1,24(sp)
    80002fe2:	e84a                	sd	s2,16(sp)
    80002fe4:	e44e                	sd	s3,8(sp)
    80002fe6:	e052                	sd	s4,0(sp)
    80002fe8:	1800                	addi	s0,sp,48
    80002fea:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002fec:	47ad                	li	a5,11
    80002fee:	04b7fe63          	bgeu	a5,a1,8000304a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002ff2:	ff45849b          	addiw	s1,a1,-12
    80002ff6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ffa:	0ff00793          	li	a5,255
    80002ffe:	0ae7e363          	bltu	a5,a4,800030a4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003002:	08052583          	lw	a1,128(a0)
    80003006:	c5ad                	beqz	a1,80003070 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003008:	00092503          	lw	a0,0(s2)
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	bd6080e7          	jalr	-1066(ra) # 80002be2 <bread>
    80003014:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003016:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    8000301a:	02049593          	slli	a1,s1,0x20
    8000301e:	9181                	srli	a1,a1,0x20
    80003020:	058a                	slli	a1,a1,0x2
    80003022:	00b784b3          	add	s1,a5,a1
    80003026:	0004a983          	lw	s3,0(s1)
    8000302a:	04098d63          	beqz	s3,80003084 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000302e:	8552                	mv	a0,s4
    80003030:	00000097          	auipc	ra,0x0
    80003034:	ce6080e7          	jalr	-794(ra) # 80002d16 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003038:	854e                	mv	a0,s3
    8000303a:	70a2                	ld	ra,40(sp)
    8000303c:	7402                	ld	s0,32(sp)
    8000303e:	64e2                	ld	s1,24(sp)
    80003040:	6942                	ld	s2,16(sp)
    80003042:	69a2                	ld	s3,8(sp)
    80003044:	6a02                	ld	s4,0(sp)
    80003046:	6145                	addi	sp,sp,48
    80003048:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000304a:	02059493          	slli	s1,a1,0x20
    8000304e:	9081                	srli	s1,s1,0x20
    80003050:	048a                	slli	s1,s1,0x2
    80003052:	94aa                	add	s1,s1,a0
    80003054:	0504a983          	lw	s3,80(s1)
    80003058:	fe0990e3          	bnez	s3,80003038 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000305c:	4108                	lw	a0,0(a0)
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	e4a080e7          	jalr	-438(ra) # 80002ea8 <balloc>
    80003066:	0005099b          	sext.w	s3,a0
    8000306a:	0534a823          	sw	s3,80(s1)
    8000306e:	b7e9                	j	80003038 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003070:	4108                	lw	a0,0(a0)
    80003072:	00000097          	auipc	ra,0x0
    80003076:	e36080e7          	jalr	-458(ra) # 80002ea8 <balloc>
    8000307a:	0005059b          	sext.w	a1,a0
    8000307e:	08b92023          	sw	a1,128(s2)
    80003082:	b759                	j	80003008 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003084:	00092503          	lw	a0,0(s2)
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	e20080e7          	jalr	-480(ra) # 80002ea8 <balloc>
    80003090:	0005099b          	sext.w	s3,a0
    80003094:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003098:	8552                	mv	a0,s4
    8000309a:	00001097          	auipc	ra,0x1
    8000309e:	fb2080e7          	jalr	-78(ra) # 8000404c <log_write>
    800030a2:	b771                	j	8000302e <bmap+0x54>
  panic("bmap: out of range");
    800030a4:	00004517          	auipc	a0,0x4
    800030a8:	48450513          	addi	a0,a0,1156 # 80007528 <userret+0x498>
    800030ac:	ffffd097          	auipc	ra,0xffffd
    800030b0:	4a2080e7          	jalr	1186(ra) # 8000054e <panic>

00000000800030b4 <iget>:
{
    800030b4:	7179                	addi	sp,sp,-48
    800030b6:	f406                	sd	ra,40(sp)
    800030b8:	f022                	sd	s0,32(sp)
    800030ba:	ec26                	sd	s1,24(sp)
    800030bc:	e84a                	sd	s2,16(sp)
    800030be:	e44e                	sd	s3,8(sp)
    800030c0:	e052                	sd	s4,0(sp)
    800030c2:	1800                	addi	s0,sp,48
    800030c4:	89aa                	mv	s3,a0
    800030c6:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800030c8:	0001d517          	auipc	a0,0x1d
    800030cc:	c2850513          	addi	a0,a0,-984 # 8001fcf0 <icache>
    800030d0:	ffffe097          	auipc	ra,0xffffe
    800030d4:	a02080e7          	jalr	-1534(ra) # 80000ad2 <acquire>
  empty = 0;
    800030d8:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800030da:	0001d497          	auipc	s1,0x1d
    800030de:	c2e48493          	addi	s1,s1,-978 # 8001fd08 <icache+0x18>
    800030e2:	0001e697          	auipc	a3,0x1e
    800030e6:	6b668693          	addi	a3,a3,1718 # 80021798 <log>
    800030ea:	a039                	j	800030f8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030ec:	02090b63          	beqz	s2,80003122 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800030f0:	08848493          	addi	s1,s1,136
    800030f4:	02d48a63          	beq	s1,a3,80003128 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800030f8:	449c                	lw	a5,8(s1)
    800030fa:	fef059e3          	blez	a5,800030ec <iget+0x38>
    800030fe:	4098                	lw	a4,0(s1)
    80003100:	ff3716e3          	bne	a4,s3,800030ec <iget+0x38>
    80003104:	40d8                	lw	a4,4(s1)
    80003106:	ff4713e3          	bne	a4,s4,800030ec <iget+0x38>
      ip->ref++;
    8000310a:	2785                	addiw	a5,a5,1
    8000310c:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000310e:	0001d517          	auipc	a0,0x1d
    80003112:	be250513          	addi	a0,a0,-1054 # 8001fcf0 <icache>
    80003116:	ffffe097          	auipc	ra,0xffffe
    8000311a:	a24080e7          	jalr	-1500(ra) # 80000b3a <release>
      return ip;
    8000311e:	8926                	mv	s2,s1
    80003120:	a03d                	j	8000314e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003122:	f7f9                	bnez	a5,800030f0 <iget+0x3c>
    80003124:	8926                	mv	s2,s1
    80003126:	b7e9                	j	800030f0 <iget+0x3c>
  if(empty == 0)
    80003128:	02090c63          	beqz	s2,80003160 <iget+0xac>
  ip->dev = dev;
    8000312c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003130:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003134:	4785                	li	a5,1
    80003136:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000313a:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000313e:	0001d517          	auipc	a0,0x1d
    80003142:	bb250513          	addi	a0,a0,-1102 # 8001fcf0 <icache>
    80003146:	ffffe097          	auipc	ra,0xffffe
    8000314a:	9f4080e7          	jalr	-1548(ra) # 80000b3a <release>
}
    8000314e:	854a                	mv	a0,s2
    80003150:	70a2                	ld	ra,40(sp)
    80003152:	7402                	ld	s0,32(sp)
    80003154:	64e2                	ld	s1,24(sp)
    80003156:	6942                	ld	s2,16(sp)
    80003158:	69a2                	ld	s3,8(sp)
    8000315a:	6a02                	ld	s4,0(sp)
    8000315c:	6145                	addi	sp,sp,48
    8000315e:	8082                	ret
    panic("iget: no inodes");
    80003160:	00004517          	auipc	a0,0x4
    80003164:	3e050513          	addi	a0,a0,992 # 80007540 <userret+0x4b0>
    80003168:	ffffd097          	auipc	ra,0xffffd
    8000316c:	3e6080e7          	jalr	998(ra) # 8000054e <panic>

0000000080003170 <fsinit>:
fsinit(int dev) {
    80003170:	7179                	addi	sp,sp,-48
    80003172:	f406                	sd	ra,40(sp)
    80003174:	f022                	sd	s0,32(sp)
    80003176:	ec26                	sd	s1,24(sp)
    80003178:	e84a                	sd	s2,16(sp)
    8000317a:	e44e                	sd	s3,8(sp)
    8000317c:	1800                	addi	s0,sp,48
    8000317e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003180:	4585                	li	a1,1
    80003182:	00000097          	auipc	ra,0x0
    80003186:	a60080e7          	jalr	-1440(ra) # 80002be2 <bread>
    8000318a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000318c:	0001d997          	auipc	s3,0x1d
    80003190:	b4498993          	addi	s3,s3,-1212 # 8001fcd0 <sb>
    80003194:	02000613          	li	a2,32
    80003198:	06050593          	addi	a1,a0,96
    8000319c:	854e                	mv	a0,s3
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	a58080e7          	jalr	-1448(ra) # 80000bf6 <memmove>
  brelse(bp);
    800031a6:	8526                	mv	a0,s1
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	b6e080e7          	jalr	-1170(ra) # 80002d16 <brelse>
  if(sb.magic != FSMAGIC)
    800031b0:	0009a703          	lw	a4,0(s3)
    800031b4:	102037b7          	lui	a5,0x10203
    800031b8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031bc:	02f71263          	bne	a4,a5,800031e0 <fsinit+0x70>
  initlog(dev, &sb);
    800031c0:	0001d597          	auipc	a1,0x1d
    800031c4:	b1058593          	addi	a1,a1,-1264 # 8001fcd0 <sb>
    800031c8:	854a                	mv	a0,s2
    800031ca:	00001097          	auipc	ra,0x1
    800031ce:	bfc080e7          	jalr	-1028(ra) # 80003dc6 <initlog>
}
    800031d2:	70a2                	ld	ra,40(sp)
    800031d4:	7402                	ld	s0,32(sp)
    800031d6:	64e2                	ld	s1,24(sp)
    800031d8:	6942                	ld	s2,16(sp)
    800031da:	69a2                	ld	s3,8(sp)
    800031dc:	6145                	addi	sp,sp,48
    800031de:	8082                	ret
    panic("invalid file system");
    800031e0:	00004517          	auipc	a0,0x4
    800031e4:	37050513          	addi	a0,a0,880 # 80007550 <userret+0x4c0>
    800031e8:	ffffd097          	auipc	ra,0xffffd
    800031ec:	366080e7          	jalr	870(ra) # 8000054e <panic>

00000000800031f0 <iinit>:
{
    800031f0:	7179                	addi	sp,sp,-48
    800031f2:	f406                	sd	ra,40(sp)
    800031f4:	f022                	sd	s0,32(sp)
    800031f6:	ec26                	sd	s1,24(sp)
    800031f8:	e84a                	sd	s2,16(sp)
    800031fa:	e44e                	sd	s3,8(sp)
    800031fc:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800031fe:	00004597          	auipc	a1,0x4
    80003202:	36a58593          	addi	a1,a1,874 # 80007568 <userret+0x4d8>
    80003206:	0001d517          	auipc	a0,0x1d
    8000320a:	aea50513          	addi	a0,a0,-1302 # 8001fcf0 <icache>
    8000320e:	ffffd097          	auipc	ra,0xffffd
    80003212:	7b2080e7          	jalr	1970(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003216:	0001d497          	auipc	s1,0x1d
    8000321a:	b0248493          	addi	s1,s1,-1278 # 8001fd18 <icache+0x28>
    8000321e:	0001e997          	auipc	s3,0x1e
    80003222:	58a98993          	addi	s3,s3,1418 # 800217a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003226:	00004917          	auipc	s2,0x4
    8000322a:	34a90913          	addi	s2,s2,842 # 80007570 <userret+0x4e0>
    8000322e:	85ca                	mv	a1,s2
    80003230:	8526                	mv	a0,s1
    80003232:	00001097          	auipc	ra,0x1
    80003236:	078080e7          	jalr	120(ra) # 800042aa <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000323a:	08848493          	addi	s1,s1,136
    8000323e:	ff3498e3          	bne	s1,s3,8000322e <iinit+0x3e>
}
    80003242:	70a2                	ld	ra,40(sp)
    80003244:	7402                	ld	s0,32(sp)
    80003246:	64e2                	ld	s1,24(sp)
    80003248:	6942                	ld	s2,16(sp)
    8000324a:	69a2                	ld	s3,8(sp)
    8000324c:	6145                	addi	sp,sp,48
    8000324e:	8082                	ret

0000000080003250 <ialloc>:
{
    80003250:	715d                	addi	sp,sp,-80
    80003252:	e486                	sd	ra,72(sp)
    80003254:	e0a2                	sd	s0,64(sp)
    80003256:	fc26                	sd	s1,56(sp)
    80003258:	f84a                	sd	s2,48(sp)
    8000325a:	f44e                	sd	s3,40(sp)
    8000325c:	f052                	sd	s4,32(sp)
    8000325e:	ec56                	sd	s5,24(sp)
    80003260:	e85a                	sd	s6,16(sp)
    80003262:	e45e                	sd	s7,8(sp)
    80003264:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003266:	0001d717          	auipc	a4,0x1d
    8000326a:	a7672703          	lw	a4,-1418(a4) # 8001fcdc <sb+0xc>
    8000326e:	4785                	li	a5,1
    80003270:	04e7fa63          	bgeu	a5,a4,800032c4 <ialloc+0x74>
    80003274:	8aaa                	mv	s5,a0
    80003276:	8bae                	mv	s7,a1
    80003278:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000327a:	0001da17          	auipc	s4,0x1d
    8000327e:	a56a0a13          	addi	s4,s4,-1450 # 8001fcd0 <sb>
    80003282:	00048b1b          	sext.w	s6,s1
    80003286:	0044d593          	srli	a1,s1,0x4
    8000328a:	018a2783          	lw	a5,24(s4)
    8000328e:	9dbd                	addw	a1,a1,a5
    80003290:	8556                	mv	a0,s5
    80003292:	00000097          	auipc	ra,0x0
    80003296:	950080e7          	jalr	-1712(ra) # 80002be2 <bread>
    8000329a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000329c:	06050993          	addi	s3,a0,96
    800032a0:	00f4f793          	andi	a5,s1,15
    800032a4:	079a                	slli	a5,a5,0x6
    800032a6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800032a8:	00099783          	lh	a5,0(s3)
    800032ac:	c785                	beqz	a5,800032d4 <ialloc+0x84>
    brelse(bp);
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	a68080e7          	jalr	-1432(ra) # 80002d16 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800032b6:	0485                	addi	s1,s1,1
    800032b8:	00ca2703          	lw	a4,12(s4)
    800032bc:	0004879b          	sext.w	a5,s1
    800032c0:	fce7e1e3          	bltu	a5,a4,80003282 <ialloc+0x32>
  panic("ialloc: no inodes");
    800032c4:	00004517          	auipc	a0,0x4
    800032c8:	2b450513          	addi	a0,a0,692 # 80007578 <userret+0x4e8>
    800032cc:	ffffd097          	auipc	ra,0xffffd
    800032d0:	282080e7          	jalr	642(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    800032d4:	04000613          	li	a2,64
    800032d8:	4581                	li	a1,0
    800032da:	854e                	mv	a0,s3
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	8ba080e7          	jalr	-1862(ra) # 80000b96 <memset>
      dip->type = type;
    800032e4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800032e8:	854a                	mv	a0,s2
    800032ea:	00001097          	auipc	ra,0x1
    800032ee:	d62080e7          	jalr	-670(ra) # 8000404c <log_write>
      brelse(bp);
    800032f2:	854a                	mv	a0,s2
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	a22080e7          	jalr	-1502(ra) # 80002d16 <brelse>
      return iget(dev, inum);
    800032fc:	85da                	mv	a1,s6
    800032fe:	8556                	mv	a0,s5
    80003300:	00000097          	auipc	ra,0x0
    80003304:	db4080e7          	jalr	-588(ra) # 800030b4 <iget>
}
    80003308:	60a6                	ld	ra,72(sp)
    8000330a:	6406                	ld	s0,64(sp)
    8000330c:	74e2                	ld	s1,56(sp)
    8000330e:	7942                	ld	s2,48(sp)
    80003310:	79a2                	ld	s3,40(sp)
    80003312:	7a02                	ld	s4,32(sp)
    80003314:	6ae2                	ld	s5,24(sp)
    80003316:	6b42                	ld	s6,16(sp)
    80003318:	6ba2                	ld	s7,8(sp)
    8000331a:	6161                	addi	sp,sp,80
    8000331c:	8082                	ret

000000008000331e <iupdate>:
{
    8000331e:	1101                	addi	sp,sp,-32
    80003320:	ec06                	sd	ra,24(sp)
    80003322:	e822                	sd	s0,16(sp)
    80003324:	e426                	sd	s1,8(sp)
    80003326:	e04a                	sd	s2,0(sp)
    80003328:	1000                	addi	s0,sp,32
    8000332a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000332c:	415c                	lw	a5,4(a0)
    8000332e:	0047d79b          	srliw	a5,a5,0x4
    80003332:	0001d597          	auipc	a1,0x1d
    80003336:	9b65a583          	lw	a1,-1610(a1) # 8001fce8 <sb+0x18>
    8000333a:	9dbd                	addw	a1,a1,a5
    8000333c:	4108                	lw	a0,0(a0)
    8000333e:	00000097          	auipc	ra,0x0
    80003342:	8a4080e7          	jalr	-1884(ra) # 80002be2 <bread>
    80003346:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003348:	06050793          	addi	a5,a0,96
    8000334c:	40c8                	lw	a0,4(s1)
    8000334e:	893d                	andi	a0,a0,15
    80003350:	051a                	slli	a0,a0,0x6
    80003352:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003354:	04449703          	lh	a4,68(s1)
    80003358:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000335c:	04649703          	lh	a4,70(s1)
    80003360:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003364:	04849703          	lh	a4,72(s1)
    80003368:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000336c:	04a49703          	lh	a4,74(s1)
    80003370:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003374:	44f8                	lw	a4,76(s1)
    80003376:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003378:	03400613          	li	a2,52
    8000337c:	05048593          	addi	a1,s1,80
    80003380:	0531                	addi	a0,a0,12
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	874080e7          	jalr	-1932(ra) # 80000bf6 <memmove>
  log_write(bp);
    8000338a:	854a                	mv	a0,s2
    8000338c:	00001097          	auipc	ra,0x1
    80003390:	cc0080e7          	jalr	-832(ra) # 8000404c <log_write>
  brelse(bp);
    80003394:	854a                	mv	a0,s2
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	980080e7          	jalr	-1664(ra) # 80002d16 <brelse>
}
    8000339e:	60e2                	ld	ra,24(sp)
    800033a0:	6442                	ld	s0,16(sp)
    800033a2:	64a2                	ld	s1,8(sp)
    800033a4:	6902                	ld	s2,0(sp)
    800033a6:	6105                	addi	sp,sp,32
    800033a8:	8082                	ret

00000000800033aa <idup>:
{
    800033aa:	1101                	addi	sp,sp,-32
    800033ac:	ec06                	sd	ra,24(sp)
    800033ae:	e822                	sd	s0,16(sp)
    800033b0:	e426                	sd	s1,8(sp)
    800033b2:	1000                	addi	s0,sp,32
    800033b4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800033b6:	0001d517          	auipc	a0,0x1d
    800033ba:	93a50513          	addi	a0,a0,-1734 # 8001fcf0 <icache>
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	714080e7          	jalr	1812(ra) # 80000ad2 <acquire>
  ip->ref++;
    800033c6:	449c                	lw	a5,8(s1)
    800033c8:	2785                	addiw	a5,a5,1
    800033ca:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800033cc:	0001d517          	auipc	a0,0x1d
    800033d0:	92450513          	addi	a0,a0,-1756 # 8001fcf0 <icache>
    800033d4:	ffffd097          	auipc	ra,0xffffd
    800033d8:	766080e7          	jalr	1894(ra) # 80000b3a <release>
}
    800033dc:	8526                	mv	a0,s1
    800033de:	60e2                	ld	ra,24(sp)
    800033e0:	6442                	ld	s0,16(sp)
    800033e2:	64a2                	ld	s1,8(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret

00000000800033e8 <ilock>:
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	e04a                	sd	s2,0(sp)
    800033f2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800033f4:	c115                	beqz	a0,80003418 <ilock+0x30>
    800033f6:	84aa                	mv	s1,a0
    800033f8:	451c                	lw	a5,8(a0)
    800033fa:	00f05f63          	blez	a5,80003418 <ilock+0x30>
  acquiresleep(&ip->lock);
    800033fe:	0541                	addi	a0,a0,16
    80003400:	00001097          	auipc	ra,0x1
    80003404:	ee4080e7          	jalr	-284(ra) # 800042e4 <acquiresleep>
  if(ip->valid == 0){
    80003408:	40bc                	lw	a5,64(s1)
    8000340a:	cf99                	beqz	a5,80003428 <ilock+0x40>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	64a2                	ld	s1,8(sp)
    80003412:	6902                	ld	s2,0(sp)
    80003414:	6105                	addi	sp,sp,32
    80003416:	8082                	ret
    panic("ilock");
    80003418:	00004517          	auipc	a0,0x4
    8000341c:	17850513          	addi	a0,a0,376 # 80007590 <userret+0x500>
    80003420:	ffffd097          	auipc	ra,0xffffd
    80003424:	12e080e7          	jalr	302(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003428:	40dc                	lw	a5,4(s1)
    8000342a:	0047d79b          	srliw	a5,a5,0x4
    8000342e:	0001d597          	auipc	a1,0x1d
    80003432:	8ba5a583          	lw	a1,-1862(a1) # 8001fce8 <sb+0x18>
    80003436:	9dbd                	addw	a1,a1,a5
    80003438:	4088                	lw	a0,0(s1)
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	7a8080e7          	jalr	1960(ra) # 80002be2 <bread>
    80003442:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003444:	06050593          	addi	a1,a0,96
    80003448:	40dc                	lw	a5,4(s1)
    8000344a:	8bbd                	andi	a5,a5,15
    8000344c:	079a                	slli	a5,a5,0x6
    8000344e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003450:	00059783          	lh	a5,0(a1)
    80003454:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003458:	00259783          	lh	a5,2(a1)
    8000345c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003460:	00459783          	lh	a5,4(a1)
    80003464:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003468:	00659783          	lh	a5,6(a1)
    8000346c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003470:	459c                	lw	a5,8(a1)
    80003472:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003474:	03400613          	li	a2,52
    80003478:	05b1                	addi	a1,a1,12
    8000347a:	05048513          	addi	a0,s1,80
    8000347e:	ffffd097          	auipc	ra,0xffffd
    80003482:	778080e7          	jalr	1912(ra) # 80000bf6 <memmove>
    brelse(bp);
    80003486:	854a                	mv	a0,s2
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	88e080e7          	jalr	-1906(ra) # 80002d16 <brelse>
    ip->valid = 1;
    80003490:	4785                	li	a5,1
    80003492:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003494:	04449783          	lh	a5,68(s1)
    80003498:	fbb5                	bnez	a5,8000340c <ilock+0x24>
      panic("ilock: no type");
    8000349a:	00004517          	auipc	a0,0x4
    8000349e:	0fe50513          	addi	a0,a0,254 # 80007598 <userret+0x508>
    800034a2:	ffffd097          	auipc	ra,0xffffd
    800034a6:	0ac080e7          	jalr	172(ra) # 8000054e <panic>

00000000800034aa <iunlock>:
{
    800034aa:	1101                	addi	sp,sp,-32
    800034ac:	ec06                	sd	ra,24(sp)
    800034ae:	e822                	sd	s0,16(sp)
    800034b0:	e426                	sd	s1,8(sp)
    800034b2:	e04a                	sd	s2,0(sp)
    800034b4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034b6:	c905                	beqz	a0,800034e6 <iunlock+0x3c>
    800034b8:	84aa                	mv	s1,a0
    800034ba:	01050913          	addi	s2,a0,16
    800034be:	854a                	mv	a0,s2
    800034c0:	00001097          	auipc	ra,0x1
    800034c4:	ebe080e7          	jalr	-322(ra) # 8000437e <holdingsleep>
    800034c8:	cd19                	beqz	a0,800034e6 <iunlock+0x3c>
    800034ca:	449c                	lw	a5,8(s1)
    800034cc:	00f05d63          	blez	a5,800034e6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800034d0:	854a                	mv	a0,s2
    800034d2:	00001097          	auipc	ra,0x1
    800034d6:	e68080e7          	jalr	-408(ra) # 8000433a <releasesleep>
}
    800034da:	60e2                	ld	ra,24(sp)
    800034dc:	6442                	ld	s0,16(sp)
    800034de:	64a2                	ld	s1,8(sp)
    800034e0:	6902                	ld	s2,0(sp)
    800034e2:	6105                	addi	sp,sp,32
    800034e4:	8082                	ret
    panic("iunlock");
    800034e6:	00004517          	auipc	a0,0x4
    800034ea:	0c250513          	addi	a0,a0,194 # 800075a8 <userret+0x518>
    800034ee:	ffffd097          	auipc	ra,0xffffd
    800034f2:	060080e7          	jalr	96(ra) # 8000054e <panic>

00000000800034f6 <iput>:
{
    800034f6:	7139                	addi	sp,sp,-64
    800034f8:	fc06                	sd	ra,56(sp)
    800034fa:	f822                	sd	s0,48(sp)
    800034fc:	f426                	sd	s1,40(sp)
    800034fe:	f04a                	sd	s2,32(sp)
    80003500:	ec4e                	sd	s3,24(sp)
    80003502:	e852                	sd	s4,16(sp)
    80003504:	e456                	sd	s5,8(sp)
    80003506:	0080                	addi	s0,sp,64
    80003508:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000350a:	0001c517          	auipc	a0,0x1c
    8000350e:	7e650513          	addi	a0,a0,2022 # 8001fcf0 <icache>
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	5c0080e7          	jalr	1472(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000351a:	4498                	lw	a4,8(s1)
    8000351c:	4785                	li	a5,1
    8000351e:	02f70663          	beq	a4,a5,8000354a <iput+0x54>
  ip->ref--;
    80003522:	449c                	lw	a5,8(s1)
    80003524:	37fd                	addiw	a5,a5,-1
    80003526:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003528:	0001c517          	auipc	a0,0x1c
    8000352c:	7c850513          	addi	a0,a0,1992 # 8001fcf0 <icache>
    80003530:	ffffd097          	auipc	ra,0xffffd
    80003534:	60a080e7          	jalr	1546(ra) # 80000b3a <release>
}
    80003538:	70e2                	ld	ra,56(sp)
    8000353a:	7442                	ld	s0,48(sp)
    8000353c:	74a2                	ld	s1,40(sp)
    8000353e:	7902                	ld	s2,32(sp)
    80003540:	69e2                	ld	s3,24(sp)
    80003542:	6a42                	ld	s4,16(sp)
    80003544:	6aa2                	ld	s5,8(sp)
    80003546:	6121                	addi	sp,sp,64
    80003548:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000354a:	40bc                	lw	a5,64(s1)
    8000354c:	dbf9                	beqz	a5,80003522 <iput+0x2c>
    8000354e:	04a49783          	lh	a5,74(s1)
    80003552:	fbe1                	bnez	a5,80003522 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003554:	01048a13          	addi	s4,s1,16
    80003558:	8552                	mv	a0,s4
    8000355a:	00001097          	auipc	ra,0x1
    8000355e:	d8a080e7          	jalr	-630(ra) # 800042e4 <acquiresleep>
    release(&icache.lock);
    80003562:	0001c517          	auipc	a0,0x1c
    80003566:	78e50513          	addi	a0,a0,1934 # 8001fcf0 <icache>
    8000356a:	ffffd097          	auipc	ra,0xffffd
    8000356e:	5d0080e7          	jalr	1488(ra) # 80000b3a <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003572:	05048913          	addi	s2,s1,80
    80003576:	08048993          	addi	s3,s1,128
    8000357a:	a819                	j	80003590 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    8000357c:	4088                	lw	a0,0(s1)
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	8ae080e7          	jalr	-1874(ra) # 80002e2c <bfree>
      ip->addrs[i] = 0;
    80003586:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    8000358a:	0911                	addi	s2,s2,4
    8000358c:	01390663          	beq	s2,s3,80003598 <iput+0xa2>
    if(ip->addrs[i]){
    80003590:	00092583          	lw	a1,0(s2)
    80003594:	d9fd                	beqz	a1,8000358a <iput+0x94>
    80003596:	b7dd                	j	8000357c <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003598:	0804a583          	lw	a1,128(s1)
    8000359c:	ed9d                	bnez	a1,800035da <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000359e:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    800035a2:	8526                	mv	a0,s1
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	d7a080e7          	jalr	-646(ra) # 8000331e <iupdate>
    ip->type = 0;
    800035ac:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800035b0:	8526                	mv	a0,s1
    800035b2:	00000097          	auipc	ra,0x0
    800035b6:	d6c080e7          	jalr	-660(ra) # 8000331e <iupdate>
    ip->valid = 0;
    800035ba:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800035be:	8552                	mv	a0,s4
    800035c0:	00001097          	auipc	ra,0x1
    800035c4:	d7a080e7          	jalr	-646(ra) # 8000433a <releasesleep>
    acquire(&icache.lock);
    800035c8:	0001c517          	auipc	a0,0x1c
    800035cc:	72850513          	addi	a0,a0,1832 # 8001fcf0 <icache>
    800035d0:	ffffd097          	auipc	ra,0xffffd
    800035d4:	502080e7          	jalr	1282(ra) # 80000ad2 <acquire>
    800035d8:	b7a9                	j	80003522 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800035da:	4088                	lw	a0,0(s1)
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	606080e7          	jalr	1542(ra) # 80002be2 <bread>
    800035e4:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    800035e6:	06050913          	addi	s2,a0,96
    800035ea:	46050993          	addi	s3,a0,1120
    800035ee:	a809                	j	80003600 <iput+0x10a>
        bfree(ip->dev, a[j]);
    800035f0:	4088                	lw	a0,0(s1)
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	83a080e7          	jalr	-1990(ra) # 80002e2c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800035fa:	0911                	addi	s2,s2,4
    800035fc:	01390663          	beq	s2,s3,80003608 <iput+0x112>
      if(a[j])
    80003600:	00092583          	lw	a1,0(s2)
    80003604:	d9fd                	beqz	a1,800035fa <iput+0x104>
    80003606:	b7ed                	j	800035f0 <iput+0xfa>
    brelse(bp);
    80003608:	8556                	mv	a0,s5
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	70c080e7          	jalr	1804(ra) # 80002d16 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003612:	0804a583          	lw	a1,128(s1)
    80003616:	4088                	lw	a0,0(s1)
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	814080e7          	jalr	-2028(ra) # 80002e2c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003620:	0804a023          	sw	zero,128(s1)
    80003624:	bfad                	j	8000359e <iput+0xa8>

0000000080003626 <iunlockput>:
{
    80003626:	1101                	addi	sp,sp,-32
    80003628:	ec06                	sd	ra,24(sp)
    8000362a:	e822                	sd	s0,16(sp)
    8000362c:	e426                	sd	s1,8(sp)
    8000362e:	1000                	addi	s0,sp,32
    80003630:	84aa                	mv	s1,a0
  iunlock(ip);
    80003632:	00000097          	auipc	ra,0x0
    80003636:	e78080e7          	jalr	-392(ra) # 800034aa <iunlock>
  iput(ip);
    8000363a:	8526                	mv	a0,s1
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	eba080e7          	jalr	-326(ra) # 800034f6 <iput>
}
    80003644:	60e2                	ld	ra,24(sp)
    80003646:	6442                	ld	s0,16(sp)
    80003648:	64a2                	ld	s1,8(sp)
    8000364a:	6105                	addi	sp,sp,32
    8000364c:	8082                	ret

000000008000364e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000364e:	1141                	addi	sp,sp,-16
    80003650:	e422                	sd	s0,8(sp)
    80003652:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003654:	411c                	lw	a5,0(a0)
    80003656:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003658:	415c                	lw	a5,4(a0)
    8000365a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000365c:	04451783          	lh	a5,68(a0)
    80003660:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003664:	04a51783          	lh	a5,74(a0)
    80003668:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000366c:	04c56783          	lwu	a5,76(a0)
    80003670:	e99c                	sd	a5,16(a1)
}
    80003672:	6422                	ld	s0,8(sp)
    80003674:	0141                	addi	sp,sp,16
    80003676:	8082                	ret

0000000080003678 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003678:	457c                	lw	a5,76(a0)
    8000367a:	0ed7e563          	bltu	a5,a3,80003764 <readi+0xec>
{
    8000367e:	7159                	addi	sp,sp,-112
    80003680:	f486                	sd	ra,104(sp)
    80003682:	f0a2                	sd	s0,96(sp)
    80003684:	eca6                	sd	s1,88(sp)
    80003686:	e8ca                	sd	s2,80(sp)
    80003688:	e4ce                	sd	s3,72(sp)
    8000368a:	e0d2                	sd	s4,64(sp)
    8000368c:	fc56                	sd	s5,56(sp)
    8000368e:	f85a                	sd	s6,48(sp)
    80003690:	f45e                	sd	s7,40(sp)
    80003692:	f062                	sd	s8,32(sp)
    80003694:	ec66                	sd	s9,24(sp)
    80003696:	e86a                	sd	s10,16(sp)
    80003698:	e46e                	sd	s11,8(sp)
    8000369a:	1880                	addi	s0,sp,112
    8000369c:	8baa                	mv	s7,a0
    8000369e:	8c2e                	mv	s8,a1
    800036a0:	8ab2                	mv	s5,a2
    800036a2:	8936                	mv	s2,a3
    800036a4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036a6:	9f35                	addw	a4,a4,a3
    800036a8:	0cd76063          	bltu	a4,a3,80003768 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    800036ac:	00e7f463          	bgeu	a5,a4,800036b4 <readi+0x3c>
    n = ip->size - off;
    800036b0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036b4:	080b0763          	beqz	s6,80003742 <readi+0xca>
    800036b8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800036ba:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036be:	5cfd                	li	s9,-1
    800036c0:	a82d                	j	800036fa <readi+0x82>
    800036c2:	02099d93          	slli	s11,s3,0x20
    800036c6:	020ddd93          	srli	s11,s11,0x20
    800036ca:	06048613          	addi	a2,s1,96
    800036ce:	86ee                	mv	a3,s11
    800036d0:	963a                	add	a2,a2,a4
    800036d2:	85d6                	mv	a1,s5
    800036d4:	8562                	mv	a0,s8
    800036d6:	fffff097          	auipc	ra,0xfffff
    800036da:	b8c080e7          	jalr	-1140(ra) # 80002262 <either_copyout>
    800036de:	05950d63          	beq	a0,s9,80003738 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    800036e2:	8526                	mv	a0,s1
    800036e4:	fffff097          	auipc	ra,0xfffff
    800036e8:	632080e7          	jalr	1586(ra) # 80002d16 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036ec:	01498a3b          	addw	s4,s3,s4
    800036f0:	0129893b          	addw	s2,s3,s2
    800036f4:	9aee                	add	s5,s5,s11
    800036f6:	056a7663          	bgeu	s4,s6,80003742 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800036fa:	000ba483          	lw	s1,0(s7)
    800036fe:	00a9559b          	srliw	a1,s2,0xa
    80003702:	855e                	mv	a0,s7
    80003704:	00000097          	auipc	ra,0x0
    80003708:	8d6080e7          	jalr	-1834(ra) # 80002fda <bmap>
    8000370c:	0005059b          	sext.w	a1,a0
    80003710:	8526                	mv	a0,s1
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	4d0080e7          	jalr	1232(ra) # 80002be2 <bread>
    8000371a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000371c:	3ff97713          	andi	a4,s2,1023
    80003720:	40ed07bb          	subw	a5,s10,a4
    80003724:	414b06bb          	subw	a3,s6,s4
    80003728:	89be                	mv	s3,a5
    8000372a:	2781                	sext.w	a5,a5
    8000372c:	0006861b          	sext.w	a2,a3
    80003730:	f8f679e3          	bgeu	a2,a5,800036c2 <readi+0x4a>
    80003734:	89b6                	mv	s3,a3
    80003736:	b771                	j	800036c2 <readi+0x4a>
      brelse(bp);
    80003738:	8526                	mv	a0,s1
    8000373a:	fffff097          	auipc	ra,0xfffff
    8000373e:	5dc080e7          	jalr	1500(ra) # 80002d16 <brelse>
  }
  return n;
    80003742:	000b051b          	sext.w	a0,s6
}
    80003746:	70a6                	ld	ra,104(sp)
    80003748:	7406                	ld	s0,96(sp)
    8000374a:	64e6                	ld	s1,88(sp)
    8000374c:	6946                	ld	s2,80(sp)
    8000374e:	69a6                	ld	s3,72(sp)
    80003750:	6a06                	ld	s4,64(sp)
    80003752:	7ae2                	ld	s5,56(sp)
    80003754:	7b42                	ld	s6,48(sp)
    80003756:	7ba2                	ld	s7,40(sp)
    80003758:	7c02                	ld	s8,32(sp)
    8000375a:	6ce2                	ld	s9,24(sp)
    8000375c:	6d42                	ld	s10,16(sp)
    8000375e:	6da2                	ld	s11,8(sp)
    80003760:	6165                	addi	sp,sp,112
    80003762:	8082                	ret
    return -1;
    80003764:	557d                	li	a0,-1
}
    80003766:	8082                	ret
    return -1;
    80003768:	557d                	li	a0,-1
    8000376a:	bff1                	j	80003746 <readi+0xce>

000000008000376c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000376c:	457c                	lw	a5,76(a0)
    8000376e:	10d7e763          	bltu	a5,a3,8000387c <writei+0x110>
{
    80003772:	7159                	addi	sp,sp,-112
    80003774:	f486                	sd	ra,104(sp)
    80003776:	f0a2                	sd	s0,96(sp)
    80003778:	eca6                	sd	s1,88(sp)
    8000377a:	e8ca                	sd	s2,80(sp)
    8000377c:	e4ce                	sd	s3,72(sp)
    8000377e:	e0d2                	sd	s4,64(sp)
    80003780:	fc56                	sd	s5,56(sp)
    80003782:	f85a                	sd	s6,48(sp)
    80003784:	f45e                	sd	s7,40(sp)
    80003786:	f062                	sd	s8,32(sp)
    80003788:	ec66                	sd	s9,24(sp)
    8000378a:	e86a                	sd	s10,16(sp)
    8000378c:	e46e                	sd	s11,8(sp)
    8000378e:	1880                	addi	s0,sp,112
    80003790:	8baa                	mv	s7,a0
    80003792:	8c2e                	mv	s8,a1
    80003794:	8ab2                	mv	s5,a2
    80003796:	8936                	mv	s2,a3
    80003798:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000379a:	00e687bb          	addw	a5,a3,a4
    8000379e:	0ed7e163          	bltu	a5,a3,80003880 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800037a2:	00043737          	lui	a4,0x43
    800037a6:	0cf76f63          	bltu	a4,a5,80003884 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037aa:	0a0b0063          	beqz	s6,8000384a <writei+0xde>
    800037ae:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800037b0:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037b4:	5cfd                	li	s9,-1
    800037b6:	a091                	j	800037fa <writei+0x8e>
    800037b8:	02099d93          	slli	s11,s3,0x20
    800037bc:	020ddd93          	srli	s11,s11,0x20
    800037c0:	06048513          	addi	a0,s1,96
    800037c4:	86ee                	mv	a3,s11
    800037c6:	8656                	mv	a2,s5
    800037c8:	85e2                	mv	a1,s8
    800037ca:	953a                	add	a0,a0,a4
    800037cc:	fffff097          	auipc	ra,0xfffff
    800037d0:	aec080e7          	jalr	-1300(ra) # 800022b8 <either_copyin>
    800037d4:	07950263          	beq	a0,s9,80003838 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800037d8:	8526                	mv	a0,s1
    800037da:	00001097          	auipc	ra,0x1
    800037de:	872080e7          	jalr	-1934(ra) # 8000404c <log_write>
    brelse(bp);
    800037e2:	8526                	mv	a0,s1
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	532080e7          	jalr	1330(ra) # 80002d16 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037ec:	01498a3b          	addw	s4,s3,s4
    800037f0:	0129893b          	addw	s2,s3,s2
    800037f4:	9aee                	add	s5,s5,s11
    800037f6:	056a7663          	bgeu	s4,s6,80003842 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800037fa:	000ba483          	lw	s1,0(s7)
    800037fe:	00a9559b          	srliw	a1,s2,0xa
    80003802:	855e                	mv	a0,s7
    80003804:	fffff097          	auipc	ra,0xfffff
    80003808:	7d6080e7          	jalr	2006(ra) # 80002fda <bmap>
    8000380c:	0005059b          	sext.w	a1,a0
    80003810:	8526                	mv	a0,s1
    80003812:	fffff097          	auipc	ra,0xfffff
    80003816:	3d0080e7          	jalr	976(ra) # 80002be2 <bread>
    8000381a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000381c:	3ff97713          	andi	a4,s2,1023
    80003820:	40ed07bb          	subw	a5,s10,a4
    80003824:	414b06bb          	subw	a3,s6,s4
    80003828:	89be                	mv	s3,a5
    8000382a:	2781                	sext.w	a5,a5
    8000382c:	0006861b          	sext.w	a2,a3
    80003830:	f8f674e3          	bgeu	a2,a5,800037b8 <writei+0x4c>
    80003834:	89b6                	mv	s3,a3
    80003836:	b749                	j	800037b8 <writei+0x4c>
      brelse(bp);
    80003838:	8526                	mv	a0,s1
    8000383a:	fffff097          	auipc	ra,0xfffff
    8000383e:	4dc080e7          	jalr	1244(ra) # 80002d16 <brelse>
  }

  if(n > 0 && off > ip->size){
    80003842:	04cba783          	lw	a5,76(s7)
    80003846:	0327e363          	bltu	a5,s2,8000386c <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
    8000384a:	000b051b          	sext.w	a0,s6
}
    8000384e:	70a6                	ld	ra,104(sp)
    80003850:	7406                	ld	s0,96(sp)
    80003852:	64e6                	ld	s1,88(sp)
    80003854:	6946                	ld	s2,80(sp)
    80003856:	69a6                	ld	s3,72(sp)
    80003858:	6a06                	ld	s4,64(sp)
    8000385a:	7ae2                	ld	s5,56(sp)
    8000385c:	7b42                	ld	s6,48(sp)
    8000385e:	7ba2                	ld	s7,40(sp)
    80003860:	7c02                	ld	s8,32(sp)
    80003862:	6ce2                	ld	s9,24(sp)
    80003864:	6d42                	ld	s10,16(sp)
    80003866:	6da2                	ld	s11,8(sp)
    80003868:	6165                	addi	sp,sp,112
    8000386a:	8082                	ret
    ip->size = off;
    8000386c:	052ba623          	sw	s2,76(s7)
    iupdate(ip);
    80003870:	855e                	mv	a0,s7
    80003872:	00000097          	auipc	ra,0x0
    80003876:	aac080e7          	jalr	-1364(ra) # 8000331e <iupdate>
    8000387a:	bfc1                	j	8000384a <writei+0xde>
    return -1;
    8000387c:	557d                	li	a0,-1
}
    8000387e:	8082                	ret
    return -1;
    80003880:	557d                	li	a0,-1
    80003882:	b7f1                	j	8000384e <writei+0xe2>
    return -1;
    80003884:	557d                	li	a0,-1
    80003886:	b7e1                	j	8000384e <writei+0xe2>

0000000080003888 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003888:	1141                	addi	sp,sp,-16
    8000388a:	e406                	sd	ra,8(sp)
    8000388c:	e022                	sd	s0,0(sp)
    8000388e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003890:	4639                	li	a2,14
    80003892:	ffffd097          	auipc	ra,0xffffd
    80003896:	3e0080e7          	jalr	992(ra) # 80000c72 <strncmp>
}
    8000389a:	60a2                	ld	ra,8(sp)
    8000389c:	6402                	ld	s0,0(sp)
    8000389e:	0141                	addi	sp,sp,16
    800038a0:	8082                	ret

00000000800038a2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038a2:	7139                	addi	sp,sp,-64
    800038a4:	fc06                	sd	ra,56(sp)
    800038a6:	f822                	sd	s0,48(sp)
    800038a8:	f426                	sd	s1,40(sp)
    800038aa:	f04a                	sd	s2,32(sp)
    800038ac:	ec4e                	sd	s3,24(sp)
    800038ae:	e852                	sd	s4,16(sp)
    800038b0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800038b2:	04451703          	lh	a4,68(a0)
    800038b6:	4785                	li	a5,1
    800038b8:	00f71a63          	bne	a4,a5,800038cc <dirlookup+0x2a>
    800038bc:	892a                	mv	s2,a0
    800038be:	89ae                	mv	s3,a1
    800038c0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800038c2:	457c                	lw	a5,76(a0)
    800038c4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038c6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038c8:	e79d                	bnez	a5,800038f6 <dirlookup+0x54>
    800038ca:	a8a5                	j	80003942 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800038cc:	00004517          	auipc	a0,0x4
    800038d0:	ce450513          	addi	a0,a0,-796 # 800075b0 <userret+0x520>
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	c7a080e7          	jalr	-902(ra) # 8000054e <panic>
      panic("dirlookup read");
    800038dc:	00004517          	auipc	a0,0x4
    800038e0:	cec50513          	addi	a0,a0,-788 # 800075c8 <userret+0x538>
    800038e4:	ffffd097          	auipc	ra,0xffffd
    800038e8:	c6a080e7          	jalr	-918(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038ec:	24c1                	addiw	s1,s1,16
    800038ee:	04c92783          	lw	a5,76(s2)
    800038f2:	04f4f763          	bgeu	s1,a5,80003940 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038f6:	4741                	li	a4,16
    800038f8:	86a6                	mv	a3,s1
    800038fa:	fc040613          	addi	a2,s0,-64
    800038fe:	4581                	li	a1,0
    80003900:	854a                	mv	a0,s2
    80003902:	00000097          	auipc	ra,0x0
    80003906:	d76080e7          	jalr	-650(ra) # 80003678 <readi>
    8000390a:	47c1                	li	a5,16
    8000390c:	fcf518e3          	bne	a0,a5,800038dc <dirlookup+0x3a>
    if(de.inum == 0)
    80003910:	fc045783          	lhu	a5,-64(s0)
    80003914:	dfe1                	beqz	a5,800038ec <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003916:	fc240593          	addi	a1,s0,-62
    8000391a:	854e                	mv	a0,s3
    8000391c:	00000097          	auipc	ra,0x0
    80003920:	f6c080e7          	jalr	-148(ra) # 80003888 <namecmp>
    80003924:	f561                	bnez	a0,800038ec <dirlookup+0x4a>
      if(poff)
    80003926:	000a0463          	beqz	s4,8000392e <dirlookup+0x8c>
        *poff = off;
    8000392a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000392e:	fc045583          	lhu	a1,-64(s0)
    80003932:	00092503          	lw	a0,0(s2)
    80003936:	fffff097          	auipc	ra,0xfffff
    8000393a:	77e080e7          	jalr	1918(ra) # 800030b4 <iget>
    8000393e:	a011                	j	80003942 <dirlookup+0xa0>
  return 0;
    80003940:	4501                	li	a0,0
}
    80003942:	70e2                	ld	ra,56(sp)
    80003944:	7442                	ld	s0,48(sp)
    80003946:	74a2                	ld	s1,40(sp)
    80003948:	7902                	ld	s2,32(sp)
    8000394a:	69e2                	ld	s3,24(sp)
    8000394c:	6a42                	ld	s4,16(sp)
    8000394e:	6121                	addi	sp,sp,64
    80003950:	8082                	ret

0000000080003952 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003952:	711d                	addi	sp,sp,-96
    80003954:	ec86                	sd	ra,88(sp)
    80003956:	e8a2                	sd	s0,80(sp)
    80003958:	e4a6                	sd	s1,72(sp)
    8000395a:	e0ca                	sd	s2,64(sp)
    8000395c:	fc4e                	sd	s3,56(sp)
    8000395e:	f852                	sd	s4,48(sp)
    80003960:	f456                	sd	s5,40(sp)
    80003962:	f05a                	sd	s6,32(sp)
    80003964:	ec5e                	sd	s7,24(sp)
    80003966:	e862                	sd	s8,16(sp)
    80003968:	e466                	sd	s9,8(sp)
    8000396a:	1080                	addi	s0,sp,96
    8000396c:	84aa                	mv	s1,a0
    8000396e:	8b2e                	mv	s6,a1
    80003970:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003972:	00054703          	lbu	a4,0(a0)
    80003976:	02f00793          	li	a5,47
    8000397a:	02f70363          	beq	a4,a5,800039a0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000397e:	ffffe097          	auipc	ra,0xffffe
    80003982:	eb6080e7          	jalr	-330(ra) # 80001834 <myproc>
    80003986:	14853503          	ld	a0,328(a0)
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	a20080e7          	jalr	-1504(ra) # 800033aa <idup>
    80003992:	89aa                	mv	s3,a0
  while(*path == '/')
    80003994:	02f00913          	li	s2,47
  len = path - s;
    80003998:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000399a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000399c:	4c05                	li	s8,1
    8000399e:	a865                	j	80003a56 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800039a0:	4585                	li	a1,1
    800039a2:	4501                	li	a0,0
    800039a4:	fffff097          	auipc	ra,0xfffff
    800039a8:	710080e7          	jalr	1808(ra) # 800030b4 <iget>
    800039ac:	89aa                	mv	s3,a0
    800039ae:	b7dd                	j	80003994 <namex+0x42>
      iunlockput(ip);
    800039b0:	854e                	mv	a0,s3
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	c74080e7          	jalr	-908(ra) # 80003626 <iunlockput>
      return 0;
    800039ba:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039bc:	854e                	mv	a0,s3
    800039be:	60e6                	ld	ra,88(sp)
    800039c0:	6446                	ld	s0,80(sp)
    800039c2:	64a6                	ld	s1,72(sp)
    800039c4:	6906                	ld	s2,64(sp)
    800039c6:	79e2                	ld	s3,56(sp)
    800039c8:	7a42                	ld	s4,48(sp)
    800039ca:	7aa2                	ld	s5,40(sp)
    800039cc:	7b02                	ld	s6,32(sp)
    800039ce:	6be2                	ld	s7,24(sp)
    800039d0:	6c42                	ld	s8,16(sp)
    800039d2:	6ca2                	ld	s9,8(sp)
    800039d4:	6125                	addi	sp,sp,96
    800039d6:	8082                	ret
      iunlock(ip);
    800039d8:	854e                	mv	a0,s3
    800039da:	00000097          	auipc	ra,0x0
    800039de:	ad0080e7          	jalr	-1328(ra) # 800034aa <iunlock>
      return ip;
    800039e2:	bfe9                	j	800039bc <namex+0x6a>
      iunlockput(ip);
    800039e4:	854e                	mv	a0,s3
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	c40080e7          	jalr	-960(ra) # 80003626 <iunlockput>
      return 0;
    800039ee:	89d2                	mv	s3,s4
    800039f0:	b7f1                	j	800039bc <namex+0x6a>
  len = path - s;
    800039f2:	40b48633          	sub	a2,s1,a1
    800039f6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800039fa:	094cd463          	bge	s9,s4,80003a82 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800039fe:	4639                	li	a2,14
    80003a00:	8556                	mv	a0,s5
    80003a02:	ffffd097          	auipc	ra,0xffffd
    80003a06:	1f4080e7          	jalr	500(ra) # 80000bf6 <memmove>
  while(*path == '/')
    80003a0a:	0004c783          	lbu	a5,0(s1)
    80003a0e:	01279763          	bne	a5,s2,80003a1c <namex+0xca>
    path++;
    80003a12:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a14:	0004c783          	lbu	a5,0(s1)
    80003a18:	ff278de3          	beq	a5,s2,80003a12 <namex+0xc0>
    ilock(ip);
    80003a1c:	854e                	mv	a0,s3
    80003a1e:	00000097          	auipc	ra,0x0
    80003a22:	9ca080e7          	jalr	-1590(ra) # 800033e8 <ilock>
    if(ip->type != T_DIR){
    80003a26:	04499783          	lh	a5,68(s3)
    80003a2a:	f98793e3          	bne	a5,s8,800039b0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003a2e:	000b0563          	beqz	s6,80003a38 <namex+0xe6>
    80003a32:	0004c783          	lbu	a5,0(s1)
    80003a36:	d3cd                	beqz	a5,800039d8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a38:	865e                	mv	a2,s7
    80003a3a:	85d6                	mv	a1,s5
    80003a3c:	854e                	mv	a0,s3
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	e64080e7          	jalr	-412(ra) # 800038a2 <dirlookup>
    80003a46:	8a2a                	mv	s4,a0
    80003a48:	dd51                	beqz	a0,800039e4 <namex+0x92>
    iunlockput(ip);
    80003a4a:	854e                	mv	a0,s3
    80003a4c:	00000097          	auipc	ra,0x0
    80003a50:	bda080e7          	jalr	-1062(ra) # 80003626 <iunlockput>
    ip = next;
    80003a54:	89d2                	mv	s3,s4
  while(*path == '/')
    80003a56:	0004c783          	lbu	a5,0(s1)
    80003a5a:	05279763          	bne	a5,s2,80003aa8 <namex+0x156>
    path++;
    80003a5e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a60:	0004c783          	lbu	a5,0(s1)
    80003a64:	ff278de3          	beq	a5,s2,80003a5e <namex+0x10c>
  if(*path == 0)
    80003a68:	c79d                	beqz	a5,80003a96 <namex+0x144>
    path++;
    80003a6a:	85a6                	mv	a1,s1
  len = path - s;
    80003a6c:	8a5e                	mv	s4,s7
    80003a6e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003a70:	01278963          	beq	a5,s2,80003a82 <namex+0x130>
    80003a74:	dfbd                	beqz	a5,800039f2 <namex+0xa0>
    path++;
    80003a76:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003a78:	0004c783          	lbu	a5,0(s1)
    80003a7c:	ff279ce3          	bne	a5,s2,80003a74 <namex+0x122>
    80003a80:	bf8d                	j	800039f2 <namex+0xa0>
    memmove(name, s, len);
    80003a82:	2601                	sext.w	a2,a2
    80003a84:	8556                	mv	a0,s5
    80003a86:	ffffd097          	auipc	ra,0xffffd
    80003a8a:	170080e7          	jalr	368(ra) # 80000bf6 <memmove>
    name[len] = 0;
    80003a8e:	9a56                	add	s4,s4,s5
    80003a90:	000a0023          	sb	zero,0(s4)
    80003a94:	bf9d                	j	80003a0a <namex+0xb8>
  if(nameiparent){
    80003a96:	f20b03e3          	beqz	s6,800039bc <namex+0x6a>
    iput(ip);
    80003a9a:	854e                	mv	a0,s3
    80003a9c:	00000097          	auipc	ra,0x0
    80003aa0:	a5a080e7          	jalr	-1446(ra) # 800034f6 <iput>
    return 0;
    80003aa4:	4981                	li	s3,0
    80003aa6:	bf19                	j	800039bc <namex+0x6a>
  if(*path == 0)
    80003aa8:	d7fd                	beqz	a5,80003a96 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003aaa:	0004c783          	lbu	a5,0(s1)
    80003aae:	85a6                	mv	a1,s1
    80003ab0:	b7d1                	j	80003a74 <namex+0x122>

0000000080003ab2 <dirlink>:
{
    80003ab2:	7139                	addi	sp,sp,-64
    80003ab4:	fc06                	sd	ra,56(sp)
    80003ab6:	f822                	sd	s0,48(sp)
    80003ab8:	f426                	sd	s1,40(sp)
    80003aba:	f04a                	sd	s2,32(sp)
    80003abc:	ec4e                	sd	s3,24(sp)
    80003abe:	e852                	sd	s4,16(sp)
    80003ac0:	0080                	addi	s0,sp,64
    80003ac2:	892a                	mv	s2,a0
    80003ac4:	8a2e                	mv	s4,a1
    80003ac6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ac8:	4601                	li	a2,0
    80003aca:	00000097          	auipc	ra,0x0
    80003ace:	dd8080e7          	jalr	-552(ra) # 800038a2 <dirlookup>
    80003ad2:	e93d                	bnez	a0,80003b48 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ad4:	04c92483          	lw	s1,76(s2)
    80003ad8:	c49d                	beqz	s1,80003b06 <dirlink+0x54>
    80003ada:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003adc:	4741                	li	a4,16
    80003ade:	86a6                	mv	a3,s1
    80003ae0:	fc040613          	addi	a2,s0,-64
    80003ae4:	4581                	li	a1,0
    80003ae6:	854a                	mv	a0,s2
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	b90080e7          	jalr	-1136(ra) # 80003678 <readi>
    80003af0:	47c1                	li	a5,16
    80003af2:	06f51163          	bne	a0,a5,80003b54 <dirlink+0xa2>
    if(de.inum == 0)
    80003af6:	fc045783          	lhu	a5,-64(s0)
    80003afa:	c791                	beqz	a5,80003b06 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003afc:	24c1                	addiw	s1,s1,16
    80003afe:	04c92783          	lw	a5,76(s2)
    80003b02:	fcf4ede3          	bltu	s1,a5,80003adc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003b06:	4639                	li	a2,14
    80003b08:	85d2                	mv	a1,s4
    80003b0a:	fc240513          	addi	a0,s0,-62
    80003b0e:	ffffd097          	auipc	ra,0xffffd
    80003b12:	1a0080e7          	jalr	416(ra) # 80000cae <strncpy>
  de.inum = inum;
    80003b16:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b1a:	4741                	li	a4,16
    80003b1c:	86a6                	mv	a3,s1
    80003b1e:	fc040613          	addi	a2,s0,-64
    80003b22:	4581                	li	a1,0
    80003b24:	854a                	mv	a0,s2
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	c46080e7          	jalr	-954(ra) # 8000376c <writei>
    80003b2e:	872a                	mv	a4,a0
    80003b30:	47c1                	li	a5,16
  return 0;
    80003b32:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b34:	02f71863          	bne	a4,a5,80003b64 <dirlink+0xb2>
}
    80003b38:	70e2                	ld	ra,56(sp)
    80003b3a:	7442                	ld	s0,48(sp)
    80003b3c:	74a2                	ld	s1,40(sp)
    80003b3e:	7902                	ld	s2,32(sp)
    80003b40:	69e2                	ld	s3,24(sp)
    80003b42:	6a42                	ld	s4,16(sp)
    80003b44:	6121                	addi	sp,sp,64
    80003b46:	8082                	ret
    iput(ip);
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	9ae080e7          	jalr	-1618(ra) # 800034f6 <iput>
    return -1;
    80003b50:	557d                	li	a0,-1
    80003b52:	b7dd                	j	80003b38 <dirlink+0x86>
      panic("dirlink read");
    80003b54:	00004517          	auipc	a0,0x4
    80003b58:	a8450513          	addi	a0,a0,-1404 # 800075d8 <userret+0x548>
    80003b5c:	ffffd097          	auipc	ra,0xffffd
    80003b60:	9f2080e7          	jalr	-1550(ra) # 8000054e <panic>
    panic("dirlink");
    80003b64:	00004517          	auipc	a0,0x4
    80003b68:	c2450513          	addi	a0,a0,-988 # 80007788 <userret+0x6f8>
    80003b6c:	ffffd097          	auipc	ra,0xffffd
    80003b70:	9e2080e7          	jalr	-1566(ra) # 8000054e <panic>

0000000080003b74 <namei>:

struct inode*
namei(char *path)
{
    80003b74:	1101                	addi	sp,sp,-32
    80003b76:	ec06                	sd	ra,24(sp)
    80003b78:	e822                	sd	s0,16(sp)
    80003b7a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b7c:	fe040613          	addi	a2,s0,-32
    80003b80:	4581                	li	a1,0
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	dd0080e7          	jalr	-560(ra) # 80003952 <namex>
}
    80003b8a:	60e2                	ld	ra,24(sp)
    80003b8c:	6442                	ld	s0,16(sp)
    80003b8e:	6105                	addi	sp,sp,32
    80003b90:	8082                	ret

0000000080003b92 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003b92:	1141                	addi	sp,sp,-16
    80003b94:	e406                	sd	ra,8(sp)
    80003b96:	e022                	sd	s0,0(sp)
    80003b98:	0800                	addi	s0,sp,16
    80003b9a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b9c:	4585                	li	a1,1
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	db4080e7          	jalr	-588(ra) # 80003952 <namex>
}
    80003ba6:	60a2                	ld	ra,8(sp)
    80003ba8:	6402                	ld	s0,0(sp)
    80003baa:	0141                	addi	sp,sp,16
    80003bac:	8082                	ret

0000000080003bae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80003bae:	7179                	addi	sp,sp,-48
    80003bb0:	f406                	sd	ra,40(sp)
    80003bb2:	f022                	sd	s0,32(sp)
    80003bb4:	ec26                	sd	s1,24(sp)
    80003bb6:	e84a                	sd	s2,16(sp)
    80003bb8:	e44e                	sd	s3,8(sp)
    80003bba:	1800                	addi	s0,sp,48
    80003bbc:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80003bbe:	0a800993          	li	s3,168
    80003bc2:	033507b3          	mul	a5,a0,s3
    80003bc6:	0001e997          	auipc	s3,0x1e
    80003bca:	bd298993          	addi	s3,s3,-1070 # 80021798 <log>
    80003bce:	99be                	add	s3,s3,a5
    80003bd0:	0189a583          	lw	a1,24(s3)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	00e080e7          	jalr	14(ra) # 80002be2 <bread>
    80003bdc:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80003bde:	02c9a783          	lw	a5,44(s3)
    80003be2:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003be4:	02c9a783          	lw	a5,44(s3)
    80003be8:	02f05763          	blez	a5,80003c16 <write_head+0x68>
    80003bec:	0a800793          	li	a5,168
    80003bf0:	02f487b3          	mul	a5,s1,a5
    80003bf4:	0001e717          	auipc	a4,0x1e
    80003bf8:	bd470713          	addi	a4,a4,-1068 # 800217c8 <log+0x30>
    80003bfc:	97ba                	add	a5,a5,a4
    80003bfe:	06450693          	addi	a3,a0,100
    80003c02:	4701                	li	a4,0
    80003c04:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    80003c06:	4390                	lw	a2,0(a5)
    80003c08:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003c0a:	2705                	addiw	a4,a4,1
    80003c0c:	0791                	addi	a5,a5,4
    80003c0e:	0691                	addi	a3,a3,4
    80003c10:	55d0                	lw	a2,44(a1)
    80003c12:	fec74ae3          	blt	a4,a2,80003c06 <write_head+0x58>
  }
  bwrite(buf);
    80003c16:	854a                	mv	a0,s2
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	0be080e7          	jalr	190(ra) # 80002cd6 <bwrite>
  brelse(buf);
    80003c20:	854a                	mv	a0,s2
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	0f4080e7          	jalr	244(ra) # 80002d16 <brelse>
}
    80003c2a:	70a2                	ld	ra,40(sp)
    80003c2c:	7402                	ld	s0,32(sp)
    80003c2e:	64e2                	ld	s1,24(sp)
    80003c30:	6942                	ld	s2,16(sp)
    80003c32:	69a2                	ld	s3,8(sp)
    80003c34:	6145                	addi	sp,sp,48
    80003c36:	8082                	ret

0000000080003c38 <write_log>:
static void
write_log(int dev)
{
  int tail;

  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003c38:	0a800793          	li	a5,168
    80003c3c:	02f50733          	mul	a4,a0,a5
    80003c40:	0001e797          	auipc	a5,0x1e
    80003c44:	b5878793          	addi	a5,a5,-1192 # 80021798 <log>
    80003c48:	97ba                	add	a5,a5,a4
    80003c4a:	57dc                	lw	a5,44(a5)
    80003c4c:	0af05663          	blez	a5,80003cf8 <write_log+0xc0>
{
    80003c50:	7139                	addi	sp,sp,-64
    80003c52:	fc06                	sd	ra,56(sp)
    80003c54:	f822                	sd	s0,48(sp)
    80003c56:	f426                	sd	s1,40(sp)
    80003c58:	f04a                	sd	s2,32(sp)
    80003c5a:	ec4e                	sd	s3,24(sp)
    80003c5c:	e852                	sd	s4,16(sp)
    80003c5e:	e456                	sd	s5,8(sp)
    80003c60:	e05a                	sd	s6,0(sp)
    80003c62:	0080                	addi	s0,sp,64
    80003c64:	0001e797          	auipc	a5,0x1e
    80003c68:	b6478793          	addi	a5,a5,-1180 # 800217c8 <log+0x30>
    80003c6c:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003c70:	4981                	li	s3,0
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80003c72:	00050b1b          	sext.w	s6,a0
    80003c76:	0001ea97          	auipc	s5,0x1e
    80003c7a:	b22a8a93          	addi	s5,s5,-1246 # 80021798 <log>
    80003c7e:	9aba                	add	s5,s5,a4
    80003c80:	018aa583          	lw	a1,24(s5)
    80003c84:	013585bb          	addw	a1,a1,s3
    80003c88:	2585                	addiw	a1,a1,1
    80003c8a:	855a                	mv	a0,s6
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	f56080e7          	jalr	-170(ra) # 80002be2 <bread>
    80003c94:	84aa                	mv	s1,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    80003c96:	000a2583          	lw	a1,0(s4)
    80003c9a:	855a                	mv	a0,s6
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	f46080e7          	jalr	-186(ra) # 80002be2 <bread>
    80003ca4:	892a                	mv	s2,a0
    memmove(to->data, from->data, BSIZE);
    80003ca6:	40000613          	li	a2,1024
    80003caa:	06050593          	addi	a1,a0,96
    80003cae:	06048513          	addi	a0,s1,96
    80003cb2:	ffffd097          	auipc	ra,0xffffd
    80003cb6:	f44080e7          	jalr	-188(ra) # 80000bf6 <memmove>
    bwrite(to);  // write the log
    80003cba:	8526                	mv	a0,s1
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	01a080e7          	jalr	26(ra) # 80002cd6 <bwrite>
    brelse(from);
    80003cc4:	854a                	mv	a0,s2
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	050080e7          	jalr	80(ra) # 80002d16 <brelse>
    brelse(to);
    80003cce:	8526                	mv	a0,s1
    80003cd0:	fffff097          	auipc	ra,0xfffff
    80003cd4:	046080e7          	jalr	70(ra) # 80002d16 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003cd8:	2985                	addiw	s3,s3,1
    80003cda:	0a11                	addi	s4,s4,4
    80003cdc:	02caa783          	lw	a5,44(s5)
    80003ce0:	faf9c0e3          	blt	s3,a5,80003c80 <write_log+0x48>
  }
}
    80003ce4:	70e2                	ld	ra,56(sp)
    80003ce6:	7442                	ld	s0,48(sp)
    80003ce8:	74a2                	ld	s1,40(sp)
    80003cea:	7902                	ld	s2,32(sp)
    80003cec:	69e2                	ld	s3,24(sp)
    80003cee:	6a42                	ld	s4,16(sp)
    80003cf0:	6aa2                	ld	s5,8(sp)
    80003cf2:	6b02                	ld	s6,0(sp)
    80003cf4:	6121                	addi	sp,sp,64
    80003cf6:	8082                	ret
    80003cf8:	8082                	ret

0000000080003cfa <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003cfa:	0a800793          	li	a5,168
    80003cfe:	02f50733          	mul	a4,a0,a5
    80003d02:	0001e797          	auipc	a5,0x1e
    80003d06:	a9678793          	addi	a5,a5,-1386 # 80021798 <log>
    80003d0a:	97ba                	add	a5,a5,a4
    80003d0c:	57dc                	lw	a5,44(a5)
    80003d0e:	0af05b63          	blez	a5,80003dc4 <install_trans+0xca>
{
    80003d12:	7139                	addi	sp,sp,-64
    80003d14:	fc06                	sd	ra,56(sp)
    80003d16:	f822                	sd	s0,48(sp)
    80003d18:	f426                	sd	s1,40(sp)
    80003d1a:	f04a                	sd	s2,32(sp)
    80003d1c:	ec4e                	sd	s3,24(sp)
    80003d1e:	e852                	sd	s4,16(sp)
    80003d20:	e456                	sd	s5,8(sp)
    80003d22:	e05a                	sd	s6,0(sp)
    80003d24:	0080                	addi	s0,sp,64
    80003d26:	0001e797          	auipc	a5,0x1e
    80003d2a:	aa278793          	addi	a5,a5,-1374 # 800217c8 <log+0x30>
    80003d2e:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d32:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80003d34:	00050b1b          	sext.w	s6,a0
    80003d38:	0001ea97          	auipc	s5,0x1e
    80003d3c:	a60a8a93          	addi	s5,s5,-1440 # 80021798 <log>
    80003d40:	9aba                	add	s5,s5,a4
    80003d42:	018aa583          	lw	a1,24(s5)
    80003d46:	013585bb          	addw	a1,a1,s3
    80003d4a:	2585                	addiw	a1,a1,1
    80003d4c:	855a                	mv	a0,s6
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	e94080e7          	jalr	-364(ra) # 80002be2 <bread>
    80003d56:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80003d58:	000a2583          	lw	a1,0(s4)
    80003d5c:	855a                	mv	a0,s6
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	e84080e7          	jalr	-380(ra) # 80002be2 <bread>
    80003d66:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d68:	40000613          	li	a2,1024
    80003d6c:	06090593          	addi	a1,s2,96
    80003d70:	06050513          	addi	a0,a0,96
    80003d74:	ffffd097          	auipc	ra,0xffffd
    80003d78:	e82080e7          	jalr	-382(ra) # 80000bf6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d7c:	8526                	mv	a0,s1
    80003d7e:	fffff097          	auipc	ra,0xfffff
    80003d82:	f58080e7          	jalr	-168(ra) # 80002cd6 <bwrite>
    bunpin(dbuf);
    80003d86:	8526                	mv	a0,s1
    80003d88:	fffff097          	auipc	ra,0xfffff
    80003d8c:	068080e7          	jalr	104(ra) # 80002df0 <bunpin>
    brelse(lbuf);
    80003d90:	854a                	mv	a0,s2
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	f84080e7          	jalr	-124(ra) # 80002d16 <brelse>
    brelse(dbuf);
    80003d9a:	8526                	mv	a0,s1
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	f7a080e7          	jalr	-134(ra) # 80002d16 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003da4:	2985                	addiw	s3,s3,1
    80003da6:	0a11                	addi	s4,s4,4
    80003da8:	02caa783          	lw	a5,44(s5)
    80003dac:	f8f9cbe3          	blt	s3,a5,80003d42 <install_trans+0x48>
}
    80003db0:	70e2                	ld	ra,56(sp)
    80003db2:	7442                	ld	s0,48(sp)
    80003db4:	74a2                	ld	s1,40(sp)
    80003db6:	7902                	ld	s2,32(sp)
    80003db8:	69e2                	ld	s3,24(sp)
    80003dba:	6a42                	ld	s4,16(sp)
    80003dbc:	6aa2                	ld	s5,8(sp)
    80003dbe:	6b02                	ld	s6,0(sp)
    80003dc0:	6121                	addi	sp,sp,64
    80003dc2:	8082                	ret
    80003dc4:	8082                	ret

0000000080003dc6 <initlog>:
{
    80003dc6:	7179                	addi	sp,sp,-48
    80003dc8:	f406                	sd	ra,40(sp)
    80003dca:	f022                	sd	s0,32(sp)
    80003dcc:	ec26                	sd	s1,24(sp)
    80003dce:	e84a                	sd	s2,16(sp)
    80003dd0:	e44e                	sd	s3,8(sp)
    80003dd2:	e052                	sd	s4,0(sp)
    80003dd4:	1800                	addi	s0,sp,48
    80003dd6:	84aa                	mv	s1,a0
    80003dd8:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    80003dda:	0a800713          	li	a4,168
    80003dde:	02e509b3          	mul	s3,a0,a4
    80003de2:	0001e917          	auipc	s2,0x1e
    80003de6:	9b690913          	addi	s2,s2,-1610 # 80021798 <log>
    80003dea:	994e                	add	s2,s2,s3
    80003dec:	00003597          	auipc	a1,0x3
    80003df0:	7fc58593          	addi	a1,a1,2044 # 800075e8 <userret+0x558>
    80003df4:	854a                	mv	a0,s2
    80003df6:	ffffd097          	auipc	ra,0xffffd
    80003dfa:	bca080e7          	jalr	-1078(ra) # 800009c0 <initlock>
  log[dev].start = sb->logstart;
    80003dfe:	014a2583          	lw	a1,20(s4)
    80003e02:	00b92c23          	sw	a1,24(s2)
  log[dev].size = sb->nlog;
    80003e06:	010a2783          	lw	a5,16(s4)
    80003e0a:	00f92e23          	sw	a5,28(s2)
  log[dev].dev = dev;
    80003e0e:	02992423          	sw	s1,40(s2)
  struct buf *buf = bread(dev, log[dev].start);
    80003e12:	8526                	mv	a0,s1
    80003e14:	fffff097          	auipc	ra,0xfffff
    80003e18:	dce080e7          	jalr	-562(ra) # 80002be2 <bread>
  log[dev].lh.n = lh->n;
    80003e1c:	513c                	lw	a5,96(a0)
    80003e1e:	02f92623          	sw	a5,44(s2)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003e22:	02f05663          	blez	a5,80003e4e <initlog+0x88>
    80003e26:	06450693          	addi	a3,a0,100
    80003e2a:	0001e717          	auipc	a4,0x1e
    80003e2e:	99e70713          	addi	a4,a4,-1634 # 800217c8 <log+0x30>
    80003e32:	974e                	add	a4,a4,s3
    80003e34:	37fd                	addiw	a5,a5,-1
    80003e36:	1782                	slli	a5,a5,0x20
    80003e38:	9381                	srli	a5,a5,0x20
    80003e3a:	078a                	slli	a5,a5,0x2
    80003e3c:	06850613          	addi	a2,a0,104
    80003e40:	97b2                	add	a5,a5,a2
    log[dev].lh.block[i] = lh->block[i];
    80003e42:	4290                	lw	a2,0(a3)
    80003e44:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003e46:	0691                	addi	a3,a3,4
    80003e48:	0711                	addi	a4,a4,4
    80003e4a:	fef69ce3          	bne	a3,a5,80003e42 <initlog+0x7c>
  brelse(buf);
    80003e4e:	fffff097          	auipc	ra,0xfffff
    80003e52:	ec8080e7          	jalr	-312(ra) # 80002d16 <brelse>
  install_trans(dev); // if committed, copy from log to disk
    80003e56:	8526                	mv	a0,s1
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	ea2080e7          	jalr	-350(ra) # 80003cfa <install_trans>
  log[dev].lh.n = 0;
    80003e60:	0a800793          	li	a5,168
    80003e64:	02f48733          	mul	a4,s1,a5
    80003e68:	0001e797          	auipc	a5,0x1e
    80003e6c:	93078793          	addi	a5,a5,-1744 # 80021798 <log>
    80003e70:	97ba                	add	a5,a5,a4
    80003e72:	0207a623          	sw	zero,44(a5)
  write_head(dev); // clear the log
    80003e76:	8526                	mv	a0,s1
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	d36080e7          	jalr	-714(ra) # 80003bae <write_head>
}
    80003e80:	70a2                	ld	ra,40(sp)
    80003e82:	7402                	ld	s0,32(sp)
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	69a2                	ld	s3,8(sp)
    80003e8a:	6a02                	ld	s4,0(sp)
    80003e8c:	6145                	addi	sp,sp,48
    80003e8e:	8082                	ret

0000000080003e90 <begin_op>:
{
    80003e90:	7139                	addi	sp,sp,-64
    80003e92:	fc06                	sd	ra,56(sp)
    80003e94:	f822                	sd	s0,48(sp)
    80003e96:	f426                	sd	s1,40(sp)
    80003e98:	f04a                	sd	s2,32(sp)
    80003e9a:	ec4e                	sd	s3,24(sp)
    80003e9c:	e852                	sd	s4,16(sp)
    80003e9e:	e456                	sd	s5,8(sp)
    80003ea0:	0080                	addi	s0,sp,64
    80003ea2:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    80003ea4:	0a800913          	li	s2,168
    80003ea8:	032507b3          	mul	a5,a0,s2
    80003eac:	0001e917          	auipc	s2,0x1e
    80003eb0:	8ec90913          	addi	s2,s2,-1812 # 80021798 <log>
    80003eb4:	993e                	add	s2,s2,a5
    80003eb6:	854a                	mv	a0,s2
    80003eb8:	ffffd097          	auipc	ra,0xffffd
    80003ebc:	c1a080e7          	jalr	-998(ra) # 80000ad2 <acquire>
    if(log[dev].committing){
    80003ec0:	0001e997          	auipc	s3,0x1e
    80003ec4:	8d898993          	addi	s3,s3,-1832 # 80021798 <log>
    80003ec8:	84ca                	mv	s1,s2
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003eca:	4a79                	li	s4,30
    80003ecc:	a039                	j	80003eda <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    80003ece:	85ca                	mv	a1,s2
    80003ed0:	854e                	mv	a0,s3
    80003ed2:	ffffe097          	auipc	ra,0xffffe
    80003ed6:	168080e7          	jalr	360(ra) # 8000203a <sleep>
    if(log[dev].committing){
    80003eda:	50dc                	lw	a5,36(s1)
    80003edc:	fbed                	bnez	a5,80003ece <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ede:	509c                	lw	a5,32(s1)
    80003ee0:	0017871b          	addiw	a4,a5,1
    80003ee4:	0007069b          	sext.w	a3,a4
    80003ee8:	0027179b          	slliw	a5,a4,0x2
    80003eec:	9fb9                	addw	a5,a5,a4
    80003eee:	0017979b          	slliw	a5,a5,0x1
    80003ef2:	54d8                	lw	a4,44(s1)
    80003ef4:	9fb9                	addw	a5,a5,a4
    80003ef6:	00fa5963          	bge	s4,a5,80003f08 <begin_op+0x78>
      sleep(&log, &log[dev].lock);
    80003efa:	85ca                	mv	a1,s2
    80003efc:	854e                	mv	a0,s3
    80003efe:	ffffe097          	auipc	ra,0xffffe
    80003f02:	13c080e7          	jalr	316(ra) # 8000203a <sleep>
    80003f06:	bfd1                	j	80003eda <begin_op+0x4a>
      log[dev].outstanding += 1;
    80003f08:	0a800513          	li	a0,168
    80003f0c:	02aa8ab3          	mul	s5,s5,a0
    80003f10:	0001e797          	auipc	a5,0x1e
    80003f14:	88878793          	addi	a5,a5,-1912 # 80021798 <log>
    80003f18:	9abe                	add	s5,s5,a5
    80003f1a:	02daa023          	sw	a3,32(s5)
      release(&log[dev].lock);
    80003f1e:	854a                	mv	a0,s2
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	c1a080e7          	jalr	-998(ra) # 80000b3a <release>
}
    80003f28:	70e2                	ld	ra,56(sp)
    80003f2a:	7442                	ld	s0,48(sp)
    80003f2c:	74a2                	ld	s1,40(sp)
    80003f2e:	7902                	ld	s2,32(sp)
    80003f30:	69e2                	ld	s3,24(sp)
    80003f32:	6a42                	ld	s4,16(sp)
    80003f34:	6aa2                	ld	s5,8(sp)
    80003f36:	6121                	addi	sp,sp,64
    80003f38:	8082                	ret

0000000080003f3a <end_op>:
{
    80003f3a:	7179                	addi	sp,sp,-48
    80003f3c:	f406                	sd	ra,40(sp)
    80003f3e:	f022                	sd	s0,32(sp)
    80003f40:	ec26                	sd	s1,24(sp)
    80003f42:	e84a                	sd	s2,16(sp)
    80003f44:	e44e                	sd	s3,8(sp)
    80003f46:	1800                	addi	s0,sp,48
    80003f48:	892a                	mv	s2,a0
  acquire(&log[dev].lock);
    80003f4a:	0a800493          	li	s1,168
    80003f4e:	029507b3          	mul	a5,a0,s1
    80003f52:	0001e497          	auipc	s1,0x1e
    80003f56:	84648493          	addi	s1,s1,-1978 # 80021798 <log>
    80003f5a:	94be                	add	s1,s1,a5
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	b74080e7          	jalr	-1164(ra) # 80000ad2 <acquire>
  log[dev].outstanding -= 1;
    80003f66:	509c                	lw	a5,32(s1)
    80003f68:	37fd                	addiw	a5,a5,-1
    80003f6a:	0007871b          	sext.w	a4,a5
    80003f6e:	d09c                	sw	a5,32(s1)
  if(log[dev].committing)
    80003f70:	50dc                	lw	a5,36(s1)
    80003f72:	e3ad                	bnez	a5,80003fd4 <end_op+0x9a>
  if(log[dev].outstanding == 0){
    80003f74:	eb25                	bnez	a4,80003fe4 <end_op+0xaa>
    log[dev].committing = 1;
    80003f76:	0a800993          	li	s3,168
    80003f7a:	033907b3          	mul	a5,s2,s3
    80003f7e:	0001e997          	auipc	s3,0x1e
    80003f82:	81a98993          	addi	s3,s3,-2022 # 80021798 <log>
    80003f86:	99be                	add	s3,s3,a5
    80003f88:	4785                	li	a5,1
    80003f8a:	02f9a223          	sw	a5,36(s3)
  release(&log[dev].lock);
    80003f8e:	8526                	mv	a0,s1
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	baa080e7          	jalr	-1110(ra) # 80000b3a <release>

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    80003f98:	02c9a783          	lw	a5,44(s3)
    80003f9c:	06f04863          	bgtz	a5,8000400c <end_op+0xd2>
    acquire(&log[dev].lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	b30080e7          	jalr	-1232(ra) # 80000ad2 <acquire>
    log[dev].committing = 0;
    80003faa:	0001d517          	auipc	a0,0x1d
    80003fae:	7ee50513          	addi	a0,a0,2030 # 80021798 <log>
    80003fb2:	0a800793          	li	a5,168
    80003fb6:	02f90933          	mul	s2,s2,a5
    80003fba:	992a                	add	s2,s2,a0
    80003fbc:	02092223          	sw	zero,36(s2)
    wakeup(&log);
    80003fc0:	ffffe097          	auipc	ra,0xffffe
    80003fc4:	1c6080e7          	jalr	454(ra) # 80002186 <wakeup>
    release(&log[dev].lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	ffffd097          	auipc	ra,0xffffd
    80003fce:	b70080e7          	jalr	-1168(ra) # 80000b3a <release>
}
    80003fd2:	a035                	j	80003ffe <end_op+0xc4>
    panic("log[dev].committing");
    80003fd4:	00003517          	auipc	a0,0x3
    80003fd8:	61c50513          	addi	a0,a0,1564 # 800075f0 <userret+0x560>
    80003fdc:	ffffc097          	auipc	ra,0xffffc
    80003fe0:	572080e7          	jalr	1394(ra) # 8000054e <panic>
    wakeup(&log);
    80003fe4:	0001d517          	auipc	a0,0x1d
    80003fe8:	7b450513          	addi	a0,a0,1972 # 80021798 <log>
    80003fec:	ffffe097          	auipc	ra,0xffffe
    80003ff0:	19a080e7          	jalr	410(ra) # 80002186 <wakeup>
  release(&log[dev].lock);
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	b44080e7          	jalr	-1212(ra) # 80000b3a <release>
}
    80003ffe:	70a2                	ld	ra,40(sp)
    80004000:	7402                	ld	s0,32(sp)
    80004002:	64e2                	ld	s1,24(sp)
    80004004:	6942                	ld	s2,16(sp)
    80004006:	69a2                	ld	s3,8(sp)
    80004008:	6145                	addi	sp,sp,48
    8000400a:	8082                	ret
    write_log(dev);     // Write modified blocks from cache to log
    8000400c:	854a                	mv	a0,s2
    8000400e:	00000097          	auipc	ra,0x0
    80004012:	c2a080e7          	jalr	-982(ra) # 80003c38 <write_log>
    write_head(dev);    // Write header to disk -- the real commit
    80004016:	854a                	mv	a0,s2
    80004018:	00000097          	auipc	ra,0x0
    8000401c:	b96080e7          	jalr	-1130(ra) # 80003bae <write_head>
    install_trans(dev); // Now install writes to home locations
    80004020:	854a                	mv	a0,s2
    80004022:	00000097          	auipc	ra,0x0
    80004026:	cd8080e7          	jalr	-808(ra) # 80003cfa <install_trans>
    log[dev].lh.n = 0;
    8000402a:	0a800793          	li	a5,168
    8000402e:	02f90733          	mul	a4,s2,a5
    80004032:	0001d797          	auipc	a5,0x1d
    80004036:	76678793          	addi	a5,a5,1894 # 80021798 <log>
    8000403a:	97ba                	add	a5,a5,a4
    8000403c:	0207a623          	sw	zero,44(a5)
    write_head(dev);    // Erase the transaction from the log
    80004040:	854a                	mv	a0,s2
    80004042:	00000097          	auipc	ra,0x0
    80004046:	b6c080e7          	jalr	-1172(ra) # 80003bae <write_head>
    8000404a:	bf99                	j	80003fa0 <end_op+0x66>

000000008000404c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000404c:	7179                	addi	sp,sp,-48
    8000404e:	f406                	sd	ra,40(sp)
    80004050:	f022                	sd	s0,32(sp)
    80004052:	ec26                	sd	s1,24(sp)
    80004054:	e84a                	sd	s2,16(sp)
    80004056:	e44e                	sd	s3,8(sp)
    80004058:	e052                	sd	s4,0(sp)
    8000405a:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    8000405c:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    80004060:	0a800793          	li	a5,168
    80004064:	02f90733          	mul	a4,s2,a5
    80004068:	0001d797          	auipc	a5,0x1d
    8000406c:	73078793          	addi	a5,a5,1840 # 80021798 <log>
    80004070:	97ba                	add	a5,a5,a4
    80004072:	57d4                	lw	a3,44(a5)
    80004074:	47f5                	li	a5,29
    80004076:	0ad7cc63          	blt	a5,a3,8000412e <log_write+0xe2>
    8000407a:	89aa                	mv	s3,a0
    8000407c:	0001d797          	auipc	a5,0x1d
    80004080:	71c78793          	addi	a5,a5,1820 # 80021798 <log>
    80004084:	97ba                	add	a5,a5,a4
    80004086:	4fdc                	lw	a5,28(a5)
    80004088:	37fd                	addiw	a5,a5,-1
    8000408a:	0af6d263          	bge	a3,a5,8000412e <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    8000408e:	0a800793          	li	a5,168
    80004092:	02f90733          	mul	a4,s2,a5
    80004096:	0001d797          	auipc	a5,0x1d
    8000409a:	70278793          	addi	a5,a5,1794 # 80021798 <log>
    8000409e:	97ba                	add	a5,a5,a4
    800040a0:	539c                	lw	a5,32(a5)
    800040a2:	08f05e63          	blez	a5,8000413e <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    800040a6:	0a800793          	li	a5,168
    800040aa:	02f904b3          	mul	s1,s2,a5
    800040ae:	0001da17          	auipc	s4,0x1d
    800040b2:	6eaa0a13          	addi	s4,s4,1770 # 80021798 <log>
    800040b6:	9a26                	add	s4,s4,s1
    800040b8:	8552                	mv	a0,s4
    800040ba:	ffffd097          	auipc	ra,0xffffd
    800040be:	a18080e7          	jalr	-1512(ra) # 80000ad2 <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    800040c2:	02ca2603          	lw	a2,44(s4)
    800040c6:	08c05463          	blez	a2,8000414e <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800040ca:	00c9a583          	lw	a1,12(s3)
    800040ce:	0001d797          	auipc	a5,0x1d
    800040d2:	6fa78793          	addi	a5,a5,1786 # 800217c8 <log+0x30>
    800040d6:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    800040d8:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800040da:	4394                	lw	a3,0(a5)
    800040dc:	06b68a63          	beq	a3,a1,80004150 <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    800040e0:	2705                	addiw	a4,a4,1
    800040e2:	0791                	addi	a5,a5,4
    800040e4:	fec71be3          	bne	a4,a2,800040da <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    800040e8:	02a00793          	li	a5,42
    800040ec:	02f907b3          	mul	a5,s2,a5
    800040f0:	97b2                	add	a5,a5,a2
    800040f2:	07a1                	addi	a5,a5,8
    800040f4:	078a                	slli	a5,a5,0x2
    800040f6:	0001d717          	auipc	a4,0x1d
    800040fa:	6a270713          	addi	a4,a4,1698 # 80021798 <log>
    800040fe:	97ba                	add	a5,a5,a4
    80004100:	00c9a703          	lw	a4,12(s3)
    80004104:	cb98                	sw	a4,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    80004106:	854e                	mv	a0,s3
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	cac080e7          	jalr	-852(ra) # 80002db4 <bpin>
    log[dev].lh.n++;
    80004110:	0a800793          	li	a5,168
    80004114:	02f90933          	mul	s2,s2,a5
    80004118:	0001d797          	auipc	a5,0x1d
    8000411c:	68078793          	addi	a5,a5,1664 # 80021798 <log>
    80004120:	993e                	add	s2,s2,a5
    80004122:	02c92783          	lw	a5,44(s2)
    80004126:	2785                	addiw	a5,a5,1
    80004128:	02f92623          	sw	a5,44(s2)
    8000412c:	a099                	j	80004172 <log_write+0x126>
    panic("too big a transaction");
    8000412e:	00003517          	auipc	a0,0x3
    80004132:	4da50513          	addi	a0,a0,1242 # 80007608 <userret+0x578>
    80004136:	ffffc097          	auipc	ra,0xffffc
    8000413a:	418080e7          	jalr	1048(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    8000413e:	00003517          	auipc	a0,0x3
    80004142:	4e250513          	addi	a0,a0,1250 # 80007620 <userret+0x590>
    80004146:	ffffc097          	auipc	ra,0xffffc
    8000414a:	408080e7          	jalr	1032(ra) # 8000054e <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    8000414e:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    80004150:	02a00793          	li	a5,42
    80004154:	02f907b3          	mul	a5,s2,a5
    80004158:	97ba                	add	a5,a5,a4
    8000415a:	07a1                	addi	a5,a5,8
    8000415c:	078a                	slli	a5,a5,0x2
    8000415e:	0001d697          	auipc	a3,0x1d
    80004162:	63a68693          	addi	a3,a3,1594 # 80021798 <log>
    80004166:	97b6                	add	a5,a5,a3
    80004168:	00c9a683          	lw	a3,12(s3)
    8000416c:	cb94                	sw	a3,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    8000416e:	f8e60ce3          	beq	a2,a4,80004106 <log_write+0xba>
  }
  release(&log[dev].lock);
    80004172:	8552                	mv	a0,s4
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	9c6080e7          	jalr	-1594(ra) # 80000b3a <release>
}
    8000417c:	70a2                	ld	ra,40(sp)
    8000417e:	7402                	ld	s0,32(sp)
    80004180:	64e2                	ld	s1,24(sp)
    80004182:	6942                	ld	s2,16(sp)
    80004184:	69a2                	ld	s3,8(sp)
    80004186:	6a02                	ld	s4,0(sp)
    80004188:	6145                	addi	sp,sp,48
    8000418a:	8082                	ret

000000008000418c <crash_op>:

// crash before commit or after commit
void
crash_op(int dev, int docommit)
{
    8000418c:	7179                	addi	sp,sp,-48
    8000418e:	f406                	sd	ra,40(sp)
    80004190:	f022                	sd	s0,32(sp)
    80004192:	ec26                	sd	s1,24(sp)
    80004194:	e84a                	sd	s2,16(sp)
    80004196:	e44e                	sd	s3,8(sp)
    80004198:	1800                	addi	s0,sp,48
    8000419a:	84aa                	mv	s1,a0
    8000419c:	89ae                	mv	s3,a1
  int do_commit = 0;
    
  acquire(&log[dev].lock);
    8000419e:	0a800913          	li	s2,168
    800041a2:	032507b3          	mul	a5,a0,s2
    800041a6:	0001d917          	auipc	s2,0x1d
    800041aa:	5f290913          	addi	s2,s2,1522 # 80021798 <log>
    800041ae:	993e                	add	s2,s2,a5
    800041b0:	854a                	mv	a0,s2
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	920080e7          	jalr	-1760(ra) # 80000ad2 <acquire>

  if (dev < 0 || dev >= NDISK)
    800041ba:	0004871b          	sext.w	a4,s1
    800041be:	4785                	li	a5,1
    800041c0:	0ae7e063          	bltu	a5,a4,80004260 <crash_op+0xd4>
    panic("end_op: invalid disk");
  if(log[dev].outstanding == 0)
    800041c4:	0a800793          	li	a5,168
    800041c8:	02f48733          	mul	a4,s1,a5
    800041cc:	0001d797          	auipc	a5,0x1d
    800041d0:	5cc78793          	addi	a5,a5,1484 # 80021798 <log>
    800041d4:	97ba                	add	a5,a5,a4
    800041d6:	539c                	lw	a5,32(a5)
    800041d8:	cfc1                	beqz	a5,80004270 <crash_op+0xe4>
    panic("end_op: already closed");
  log[dev].outstanding -= 1;
    800041da:	37fd                	addiw	a5,a5,-1
    800041dc:	0007861b          	sext.w	a2,a5
    800041e0:	0a800713          	li	a4,168
    800041e4:	02e486b3          	mul	a3,s1,a4
    800041e8:	0001d717          	auipc	a4,0x1d
    800041ec:	5b070713          	addi	a4,a4,1456 # 80021798 <log>
    800041f0:	9736                	add	a4,a4,a3
    800041f2:	d31c                	sw	a5,32(a4)
  if(log[dev].committing)
    800041f4:	535c                	lw	a5,36(a4)
    800041f6:	e7c9                	bnez	a5,80004280 <crash_op+0xf4>
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    800041f8:	ee41                	bnez	a2,80004290 <crash_op+0x104>
    do_commit = 1;
    log[dev].committing = 1;
    800041fa:	0a800793          	li	a5,168
    800041fe:	02f48733          	mul	a4,s1,a5
    80004202:	0001d797          	auipc	a5,0x1d
    80004206:	59678793          	addi	a5,a5,1430 # 80021798 <log>
    8000420a:	97ba                	add	a5,a5,a4
    8000420c:	4705                	li	a4,1
    8000420e:	d3d8                	sw	a4,36(a5)
  }
  
  release(&log[dev].lock);
    80004210:	854a                	mv	a0,s2
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	928080e7          	jalr	-1752(ra) # 80000b3a <release>

  if(docommit & do_commit){
    8000421a:	0019f993          	andi	s3,s3,1
    8000421e:	06098e63          	beqz	s3,8000429a <crash_op+0x10e>
    printf("crash_op: commit\n");
    80004222:	00003517          	auipc	a0,0x3
    80004226:	44e50513          	addi	a0,a0,1102 # 80007670 <userret+0x5e0>
    8000422a:	ffffc097          	auipc	ra,0xffffc
    8000422e:	36e080e7          	jalr	878(ra) # 80000598 <printf>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.

    if (log[dev].lh.n > 0) {
    80004232:	0a800793          	li	a5,168
    80004236:	02f48733          	mul	a4,s1,a5
    8000423a:	0001d797          	auipc	a5,0x1d
    8000423e:	55e78793          	addi	a5,a5,1374 # 80021798 <log>
    80004242:	97ba                	add	a5,a5,a4
    80004244:	57dc                	lw	a5,44(a5)
    80004246:	04f05a63          	blez	a5,8000429a <crash_op+0x10e>
      write_log(dev);     // Write modified blocks from cache to log
    8000424a:	8526                	mv	a0,s1
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	9ec080e7          	jalr	-1556(ra) # 80003c38 <write_log>
      write_head(dev);    // Write header to disk -- the real commit
    80004254:	8526                	mv	a0,s1
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	958080e7          	jalr	-1704(ra) # 80003bae <write_head>
    8000425e:	a835                	j	8000429a <crash_op+0x10e>
    panic("end_op: invalid disk");
    80004260:	00003517          	auipc	a0,0x3
    80004264:	3e050513          	addi	a0,a0,992 # 80007640 <userret+0x5b0>
    80004268:	ffffc097          	auipc	ra,0xffffc
    8000426c:	2e6080e7          	jalr	742(ra) # 8000054e <panic>
    panic("end_op: already closed");
    80004270:	00003517          	auipc	a0,0x3
    80004274:	3e850513          	addi	a0,a0,1000 # 80007658 <userret+0x5c8>
    80004278:	ffffc097          	auipc	ra,0xffffc
    8000427c:	2d6080e7          	jalr	726(ra) # 8000054e <panic>
    panic("log[dev].committing");
    80004280:	00003517          	auipc	a0,0x3
    80004284:	37050513          	addi	a0,a0,880 # 800075f0 <userret+0x560>
    80004288:	ffffc097          	auipc	ra,0xffffc
    8000428c:	2c6080e7          	jalr	710(ra) # 8000054e <panic>
  release(&log[dev].lock);
    80004290:	854a                	mv	a0,s2
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	8a8080e7          	jalr	-1880(ra) # 80000b3a <release>
    }
  }
  panic("crashed file system; please restart xv6 and run crashtest\n");
    8000429a:	00003517          	auipc	a0,0x3
    8000429e:	3ee50513          	addi	a0,a0,1006 # 80007688 <userret+0x5f8>
    800042a2:	ffffc097          	auipc	ra,0xffffc
    800042a6:	2ac080e7          	jalr	684(ra) # 8000054e <panic>

00000000800042aa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800042aa:	1101                	addi	sp,sp,-32
    800042ac:	ec06                	sd	ra,24(sp)
    800042ae:	e822                	sd	s0,16(sp)
    800042b0:	e426                	sd	s1,8(sp)
    800042b2:	e04a                	sd	s2,0(sp)
    800042b4:	1000                	addi	s0,sp,32
    800042b6:	84aa                	mv	s1,a0
    800042b8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800042ba:	00003597          	auipc	a1,0x3
    800042be:	40e58593          	addi	a1,a1,1038 # 800076c8 <userret+0x638>
    800042c2:	0521                	addi	a0,a0,8
    800042c4:	ffffc097          	auipc	ra,0xffffc
    800042c8:	6fc080e7          	jalr	1788(ra) # 800009c0 <initlock>
  lk->name = name;
    800042cc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800042d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042d4:	0204a423          	sw	zero,40(s1)
}
    800042d8:	60e2                	ld	ra,24(sp)
    800042da:	6442                	ld	s0,16(sp)
    800042dc:	64a2                	ld	s1,8(sp)
    800042de:	6902                	ld	s2,0(sp)
    800042e0:	6105                	addi	sp,sp,32
    800042e2:	8082                	ret

00000000800042e4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042e4:	1101                	addi	sp,sp,-32
    800042e6:	ec06                	sd	ra,24(sp)
    800042e8:	e822                	sd	s0,16(sp)
    800042ea:	e426                	sd	s1,8(sp)
    800042ec:	e04a                	sd	s2,0(sp)
    800042ee:	1000                	addi	s0,sp,32
    800042f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042f2:	00850913          	addi	s2,a0,8
    800042f6:	854a                	mv	a0,s2
    800042f8:	ffffc097          	auipc	ra,0xffffc
    800042fc:	7da080e7          	jalr	2010(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    80004300:	409c                	lw	a5,0(s1)
    80004302:	cb89                	beqz	a5,80004314 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004304:	85ca                	mv	a1,s2
    80004306:	8526                	mv	a0,s1
    80004308:	ffffe097          	auipc	ra,0xffffe
    8000430c:	d32080e7          	jalr	-718(ra) # 8000203a <sleep>
  while (lk->locked) {
    80004310:	409c                	lw	a5,0(s1)
    80004312:	fbed                	bnez	a5,80004304 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004314:	4785                	li	a5,1
    80004316:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	51c080e7          	jalr	1308(ra) # 80001834 <myproc>
    80004320:	595c                	lw	a5,52(a0)
    80004322:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004324:	854a                	mv	a0,s2
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	814080e7          	jalr	-2028(ra) # 80000b3a <release>
}
    8000432e:	60e2                	ld	ra,24(sp)
    80004330:	6442                	ld	s0,16(sp)
    80004332:	64a2                	ld	s1,8(sp)
    80004334:	6902                	ld	s2,0(sp)
    80004336:	6105                	addi	sp,sp,32
    80004338:	8082                	ret

000000008000433a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000433a:	1101                	addi	sp,sp,-32
    8000433c:	ec06                	sd	ra,24(sp)
    8000433e:	e822                	sd	s0,16(sp)
    80004340:	e426                	sd	s1,8(sp)
    80004342:	e04a                	sd	s2,0(sp)
    80004344:	1000                	addi	s0,sp,32
    80004346:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004348:	00850913          	addi	s2,a0,8
    8000434c:	854a                	mv	a0,s2
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	784080e7          	jalr	1924(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    80004356:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000435a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000435e:	8526                	mv	a0,s1
    80004360:	ffffe097          	auipc	ra,0xffffe
    80004364:	e26080e7          	jalr	-474(ra) # 80002186 <wakeup>
  release(&lk->lk);
    80004368:	854a                	mv	a0,s2
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	7d0080e7          	jalr	2000(ra) # 80000b3a <release>
}
    80004372:	60e2                	ld	ra,24(sp)
    80004374:	6442                	ld	s0,16(sp)
    80004376:	64a2                	ld	s1,8(sp)
    80004378:	6902                	ld	s2,0(sp)
    8000437a:	6105                	addi	sp,sp,32
    8000437c:	8082                	ret

000000008000437e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000437e:	7179                	addi	sp,sp,-48
    80004380:	f406                	sd	ra,40(sp)
    80004382:	f022                	sd	s0,32(sp)
    80004384:	ec26                	sd	s1,24(sp)
    80004386:	e84a                	sd	s2,16(sp)
    80004388:	e44e                	sd	s3,8(sp)
    8000438a:	1800                	addi	s0,sp,48
    8000438c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000438e:	00850913          	addi	s2,a0,8
    80004392:	854a                	mv	a0,s2
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	73e080e7          	jalr	1854(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000439c:	409c                	lw	a5,0(s1)
    8000439e:	ef99                	bnez	a5,800043bc <holdingsleep+0x3e>
    800043a0:	4481                	li	s1,0
  release(&lk->lk);
    800043a2:	854a                	mv	a0,s2
    800043a4:	ffffc097          	auipc	ra,0xffffc
    800043a8:	796080e7          	jalr	1942(ra) # 80000b3a <release>
  return r;
}
    800043ac:	8526                	mv	a0,s1
    800043ae:	70a2                	ld	ra,40(sp)
    800043b0:	7402                	ld	s0,32(sp)
    800043b2:	64e2                	ld	s1,24(sp)
    800043b4:	6942                	ld	s2,16(sp)
    800043b6:	69a2                	ld	s3,8(sp)
    800043b8:	6145                	addi	sp,sp,48
    800043ba:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800043bc:	0284a983          	lw	s3,40(s1)
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	474080e7          	jalr	1140(ra) # 80001834 <myproc>
    800043c8:	5944                	lw	s1,52(a0)
    800043ca:	413484b3          	sub	s1,s1,s3
    800043ce:	0014b493          	seqz	s1,s1
    800043d2:	bfc1                	j	800043a2 <holdingsleep+0x24>

00000000800043d4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043d4:	1141                	addi	sp,sp,-16
    800043d6:	e406                	sd	ra,8(sp)
    800043d8:	e022                	sd	s0,0(sp)
    800043da:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043dc:	00003597          	auipc	a1,0x3
    800043e0:	2fc58593          	addi	a1,a1,764 # 800076d8 <userret+0x648>
    800043e4:	0001d517          	auipc	a0,0x1d
    800043e8:	5a450513          	addi	a0,a0,1444 # 80021988 <ftable>
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	5d4080e7          	jalr	1492(ra) # 800009c0 <initlock>
}
    800043f4:	60a2                	ld	ra,8(sp)
    800043f6:	6402                	ld	s0,0(sp)
    800043f8:	0141                	addi	sp,sp,16
    800043fa:	8082                	ret

00000000800043fc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043fc:	1101                	addi	sp,sp,-32
    800043fe:	ec06                	sd	ra,24(sp)
    80004400:	e822                	sd	s0,16(sp)
    80004402:	e426                	sd	s1,8(sp)
    80004404:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004406:	0001d517          	auipc	a0,0x1d
    8000440a:	58250513          	addi	a0,a0,1410 # 80021988 <ftable>
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	6c4080e7          	jalr	1732(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004416:	0001d497          	auipc	s1,0x1d
    8000441a:	58a48493          	addi	s1,s1,1418 # 800219a0 <ftable+0x18>
    8000441e:	0001e717          	auipc	a4,0x1e
    80004422:	52270713          	addi	a4,a4,1314 # 80022940 <ftable+0xfb8>
    if(f->ref == 0){
    80004426:	40dc                	lw	a5,4(s1)
    80004428:	cf99                	beqz	a5,80004446 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000442a:	02848493          	addi	s1,s1,40
    8000442e:	fee49ce3          	bne	s1,a4,80004426 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004432:	0001d517          	auipc	a0,0x1d
    80004436:	55650513          	addi	a0,a0,1366 # 80021988 <ftable>
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	700080e7          	jalr	1792(ra) # 80000b3a <release>
  return 0;
    80004442:	4481                	li	s1,0
    80004444:	a819                	j	8000445a <filealloc+0x5e>
      f->ref = 1;
    80004446:	4785                	li	a5,1
    80004448:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000444a:	0001d517          	auipc	a0,0x1d
    8000444e:	53e50513          	addi	a0,a0,1342 # 80021988 <ftable>
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	6e8080e7          	jalr	1768(ra) # 80000b3a <release>
}
    8000445a:	8526                	mv	a0,s1
    8000445c:	60e2                	ld	ra,24(sp)
    8000445e:	6442                	ld	s0,16(sp)
    80004460:	64a2                	ld	s1,8(sp)
    80004462:	6105                	addi	sp,sp,32
    80004464:	8082                	ret

0000000080004466 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004466:	1101                	addi	sp,sp,-32
    80004468:	ec06                	sd	ra,24(sp)
    8000446a:	e822                	sd	s0,16(sp)
    8000446c:	e426                	sd	s1,8(sp)
    8000446e:	1000                	addi	s0,sp,32
    80004470:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004472:	0001d517          	auipc	a0,0x1d
    80004476:	51650513          	addi	a0,a0,1302 # 80021988 <ftable>
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	658080e7          	jalr	1624(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004482:	40dc                	lw	a5,4(s1)
    80004484:	02f05263          	blez	a5,800044a8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004488:	2785                	addiw	a5,a5,1
    8000448a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000448c:	0001d517          	auipc	a0,0x1d
    80004490:	4fc50513          	addi	a0,a0,1276 # 80021988 <ftable>
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	6a6080e7          	jalr	1702(ra) # 80000b3a <release>
  return f;
}
    8000449c:	8526                	mv	a0,s1
    8000449e:	60e2                	ld	ra,24(sp)
    800044a0:	6442                	ld	s0,16(sp)
    800044a2:	64a2                	ld	s1,8(sp)
    800044a4:	6105                	addi	sp,sp,32
    800044a6:	8082                	ret
    panic("filedup");
    800044a8:	00003517          	auipc	a0,0x3
    800044ac:	23850513          	addi	a0,a0,568 # 800076e0 <userret+0x650>
    800044b0:	ffffc097          	auipc	ra,0xffffc
    800044b4:	09e080e7          	jalr	158(ra) # 8000054e <panic>

00000000800044b8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044b8:	7139                	addi	sp,sp,-64
    800044ba:	fc06                	sd	ra,56(sp)
    800044bc:	f822                	sd	s0,48(sp)
    800044be:	f426                	sd	s1,40(sp)
    800044c0:	f04a                	sd	s2,32(sp)
    800044c2:	ec4e                	sd	s3,24(sp)
    800044c4:	e852                	sd	s4,16(sp)
    800044c6:	e456                	sd	s5,8(sp)
    800044c8:	0080                	addi	s0,sp,64
    800044ca:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044cc:	0001d517          	auipc	a0,0x1d
    800044d0:	4bc50513          	addi	a0,a0,1212 # 80021988 <ftable>
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	5fe080e7          	jalr	1534(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    800044dc:	40dc                	lw	a5,4(s1)
    800044de:	06f05563          	blez	a5,80004548 <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    800044e2:	37fd                	addiw	a5,a5,-1
    800044e4:	0007871b          	sext.w	a4,a5
    800044e8:	c0dc                	sw	a5,4(s1)
    800044ea:	06e04763          	bgtz	a4,80004558 <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044ee:	0004a903          	lw	s2,0(s1)
    800044f2:	0094ca83          	lbu	s5,9(s1)
    800044f6:	0104ba03          	ld	s4,16(s1)
    800044fa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044fe:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004502:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004506:	0001d517          	auipc	a0,0x1d
    8000450a:	48250513          	addi	a0,a0,1154 # 80021988 <ftable>
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	62c080e7          	jalr	1580(ra) # 80000b3a <release>

  if(ff.type == FD_PIPE){
    80004516:	4785                	li	a5,1
    80004518:	06f90163          	beq	s2,a5,8000457a <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000451c:	3979                	addiw	s2,s2,-2
    8000451e:	4785                	li	a5,1
    80004520:	0527e463          	bltu	a5,s2,80004568 <fileclose+0xb0>
    begin_op(ff.ip->dev);
    80004524:	0009a503          	lw	a0,0(s3)
    80004528:	00000097          	auipc	ra,0x0
    8000452c:	968080e7          	jalr	-1688(ra) # 80003e90 <begin_op>
    iput(ff.ip);
    80004530:	854e                	mv	a0,s3
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	fc4080e7          	jalr	-60(ra) # 800034f6 <iput>
    end_op(ff.ip->dev);
    8000453a:	0009a503          	lw	a0,0(s3)
    8000453e:	00000097          	auipc	ra,0x0
    80004542:	9fc080e7          	jalr	-1540(ra) # 80003f3a <end_op>
    80004546:	a00d                	j	80004568 <fileclose+0xb0>
    panic("fileclose");
    80004548:	00003517          	auipc	a0,0x3
    8000454c:	1a050513          	addi	a0,a0,416 # 800076e8 <userret+0x658>
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	ffe080e7          	jalr	-2(ra) # 8000054e <panic>
    release(&ftable.lock);
    80004558:	0001d517          	auipc	a0,0x1d
    8000455c:	43050513          	addi	a0,a0,1072 # 80021988 <ftable>
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	5da080e7          	jalr	1498(ra) # 80000b3a <release>
  }
}
    80004568:	70e2                	ld	ra,56(sp)
    8000456a:	7442                	ld	s0,48(sp)
    8000456c:	74a2                	ld	s1,40(sp)
    8000456e:	7902                	ld	s2,32(sp)
    80004570:	69e2                	ld	s3,24(sp)
    80004572:	6a42                	ld	s4,16(sp)
    80004574:	6aa2                	ld	s5,8(sp)
    80004576:	6121                	addi	sp,sp,64
    80004578:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000457a:	85d6                	mv	a1,s5
    8000457c:	8552                	mv	a0,s4
    8000457e:	00000097          	auipc	ra,0x0
    80004582:	348080e7          	jalr	840(ra) # 800048c6 <pipeclose>
    80004586:	b7cd                	j	80004568 <fileclose+0xb0>

0000000080004588 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004588:	715d                	addi	sp,sp,-80
    8000458a:	e486                	sd	ra,72(sp)
    8000458c:	e0a2                	sd	s0,64(sp)
    8000458e:	fc26                	sd	s1,56(sp)
    80004590:	f84a                	sd	s2,48(sp)
    80004592:	f44e                	sd	s3,40(sp)
    80004594:	0880                	addi	s0,sp,80
    80004596:	84aa                	mv	s1,a0
    80004598:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000459a:	ffffd097          	auipc	ra,0xffffd
    8000459e:	29a080e7          	jalr	666(ra) # 80001834 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800045a2:	409c                	lw	a5,0(s1)
    800045a4:	37f9                	addiw	a5,a5,-2
    800045a6:	4705                	li	a4,1
    800045a8:	04f76763          	bltu	a4,a5,800045f6 <filestat+0x6e>
    800045ac:	892a                	mv	s2,a0
    ilock(f->ip);
    800045ae:	6c88                	ld	a0,24(s1)
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	e38080e7          	jalr	-456(ra) # 800033e8 <ilock>
    stati(f->ip, &st);
    800045b8:	fb840593          	addi	a1,s0,-72
    800045bc:	6c88                	ld	a0,24(s1)
    800045be:	fffff097          	auipc	ra,0xfffff
    800045c2:	090080e7          	jalr	144(ra) # 8000364e <stati>
    iunlock(f->ip);
    800045c6:	6c88                	ld	a0,24(s1)
    800045c8:	fffff097          	auipc	ra,0xfffff
    800045cc:	ee2080e7          	jalr	-286(ra) # 800034aa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045d0:	46e1                	li	a3,24
    800045d2:	fb840613          	addi	a2,s0,-72
    800045d6:	85ce                	mv	a1,s3
    800045d8:	04893503          	ld	a0,72(s2)
    800045dc:	ffffd097          	auipc	ra,0xffffd
    800045e0:	f7e080e7          	jalr	-130(ra) # 8000155a <copyout>
    800045e4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800045e8:	60a6                	ld	ra,72(sp)
    800045ea:	6406                	ld	s0,64(sp)
    800045ec:	74e2                	ld	s1,56(sp)
    800045ee:	7942                	ld	s2,48(sp)
    800045f0:	79a2                	ld	s3,40(sp)
    800045f2:	6161                	addi	sp,sp,80
    800045f4:	8082                	ret
  return -1;
    800045f6:	557d                	li	a0,-1
    800045f8:	bfc5                	j	800045e8 <filestat+0x60>

00000000800045fa <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045fa:	7179                	addi	sp,sp,-48
    800045fc:	f406                	sd	ra,40(sp)
    800045fe:	f022                	sd	s0,32(sp)
    80004600:	ec26                	sd	s1,24(sp)
    80004602:	e84a                	sd	s2,16(sp)
    80004604:	e44e                	sd	s3,8(sp)
    80004606:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004608:	00854783          	lbu	a5,8(a0)
    8000460c:	cfc1                	beqz	a5,800046a4 <fileread+0xaa>
    8000460e:	84aa                	mv	s1,a0
    80004610:	89ae                	mv	s3,a1
    80004612:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004614:	411c                	lw	a5,0(a0)
    80004616:	4705                	li	a4,1
    80004618:	04e78963          	beq	a5,a4,8000466a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000461c:	470d                	li	a4,3
    8000461e:	04e78d63          	beq	a5,a4,80004678 <fileread+0x7e>
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004622:	4709                	li	a4,2
    80004624:	06e79863          	bne	a5,a4,80004694 <fileread+0x9a>
    ilock(f->ip);
    80004628:	6d08                	ld	a0,24(a0)
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	dbe080e7          	jalr	-578(ra) # 800033e8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004632:	874a                	mv	a4,s2
    80004634:	5094                	lw	a3,32(s1)
    80004636:	864e                	mv	a2,s3
    80004638:	4585                	li	a1,1
    8000463a:	6c88                	ld	a0,24(s1)
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	03c080e7          	jalr	60(ra) # 80003678 <readi>
    80004644:	892a                	mv	s2,a0
    80004646:	00a05563          	blez	a0,80004650 <fileread+0x56>
      f->off += r;
    8000464a:	509c                	lw	a5,32(s1)
    8000464c:	9fa9                	addw	a5,a5,a0
    8000464e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004650:	6c88                	ld	a0,24(s1)
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	e58080e7          	jalr	-424(ra) # 800034aa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000465a:	854a                	mv	a0,s2
    8000465c:	70a2                	ld	ra,40(sp)
    8000465e:	7402                	ld	s0,32(sp)
    80004660:	64e2                	ld	s1,24(sp)
    80004662:	6942                	ld	s2,16(sp)
    80004664:	69a2                	ld	s3,8(sp)
    80004666:	6145                	addi	sp,sp,48
    80004668:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000466a:	6908                	ld	a0,16(a0)
    8000466c:	00000097          	auipc	ra,0x0
    80004670:	3de080e7          	jalr	990(ra) # 80004a4a <piperead>
    80004674:	892a                	mv	s2,a0
    80004676:	b7d5                	j	8000465a <fileread+0x60>
    r = devsw[f->major].read(1, addr, n);
    80004678:	02451783          	lh	a5,36(a0)
    8000467c:	00479713          	slli	a4,a5,0x4
    80004680:	0001d797          	auipc	a5,0x1d
    80004684:	26878793          	addi	a5,a5,616 # 800218e8 <devsw>
    80004688:	97ba                	add	a5,a5,a4
    8000468a:	639c                	ld	a5,0(a5)
    8000468c:	4505                	li	a0,1
    8000468e:	9782                	jalr	a5
    80004690:	892a                	mv	s2,a0
    80004692:	b7e1                	j	8000465a <fileread+0x60>
    panic("fileread");
    80004694:	00003517          	auipc	a0,0x3
    80004698:	06450513          	addi	a0,a0,100 # 800076f8 <userret+0x668>
    8000469c:	ffffc097          	auipc	ra,0xffffc
    800046a0:	eb2080e7          	jalr	-334(ra) # 8000054e <panic>
    return -1;
    800046a4:	597d                	li	s2,-1
    800046a6:	bf55                	j	8000465a <fileread+0x60>

00000000800046a8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800046a8:	00954783          	lbu	a5,9(a0)
    800046ac:	12078e63          	beqz	a5,800047e8 <filewrite+0x140>
{
    800046b0:	715d                	addi	sp,sp,-80
    800046b2:	e486                	sd	ra,72(sp)
    800046b4:	e0a2                	sd	s0,64(sp)
    800046b6:	fc26                	sd	s1,56(sp)
    800046b8:	f84a                	sd	s2,48(sp)
    800046ba:	f44e                	sd	s3,40(sp)
    800046bc:	f052                	sd	s4,32(sp)
    800046be:	ec56                	sd	s5,24(sp)
    800046c0:	e85a                	sd	s6,16(sp)
    800046c2:	e45e                	sd	s7,8(sp)
    800046c4:	e062                	sd	s8,0(sp)
    800046c6:	0880                	addi	s0,sp,80
    800046c8:	84aa                	mv	s1,a0
    800046ca:	8aae                	mv	s5,a1
    800046cc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046ce:	411c                	lw	a5,0(a0)
    800046d0:	4705                	li	a4,1
    800046d2:	02e78263          	beq	a5,a4,800046f6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046d6:	470d                	li	a4,3
    800046d8:	02e78563          	beq	a5,a4,80004702 <filewrite+0x5a>
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046dc:	4709                	li	a4,2
    800046de:	0ee79d63          	bne	a5,a4,800047d8 <filewrite+0x130>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046e2:	0ec05763          	blez	a2,800047d0 <filewrite+0x128>
    int i = 0;
    800046e6:	4981                	li	s3,0
    800046e8:	6b05                	lui	s6,0x1
    800046ea:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800046ee:	6b85                	lui	s7,0x1
    800046f0:	c00b8b9b          	addiw	s7,s7,-1024
    800046f4:	a051                	j	80004778 <filewrite+0xd0>
    ret = pipewrite(f->pipe, addr, n);
    800046f6:	6908                	ld	a0,16(a0)
    800046f8:	00000097          	auipc	ra,0x0
    800046fc:	23e080e7          	jalr	574(ra) # 80004936 <pipewrite>
    80004700:	a065                	j	800047a8 <filewrite+0x100>
    ret = devsw[f->major].write(1, addr, n);
    80004702:	02451783          	lh	a5,36(a0)
    80004706:	00479713          	slli	a4,a5,0x4
    8000470a:	0001d797          	auipc	a5,0x1d
    8000470e:	1de78793          	addi	a5,a5,478 # 800218e8 <devsw>
    80004712:	97ba                	add	a5,a5,a4
    80004714:	679c                	ld	a5,8(a5)
    80004716:	4505                	li	a0,1
    80004718:	9782                	jalr	a5
    8000471a:	a079                	j	800047a8 <filewrite+0x100>
    8000471c:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    80004720:	6c9c                	ld	a5,24(s1)
    80004722:	4388                	lw	a0,0(a5)
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	76c080e7          	jalr	1900(ra) # 80003e90 <begin_op>
      ilock(f->ip);
    8000472c:	6c88                	ld	a0,24(s1)
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	cba080e7          	jalr	-838(ra) # 800033e8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004736:	8762                	mv	a4,s8
    80004738:	5094                	lw	a3,32(s1)
    8000473a:	01598633          	add	a2,s3,s5
    8000473e:	4585                	li	a1,1
    80004740:	6c88                	ld	a0,24(s1)
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	02a080e7          	jalr	42(ra) # 8000376c <writei>
    8000474a:	892a                	mv	s2,a0
    8000474c:	02a05e63          	blez	a0,80004788 <filewrite+0xe0>
        f->off += r;
    80004750:	509c                	lw	a5,32(s1)
    80004752:	9fa9                	addw	a5,a5,a0
    80004754:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004756:	6c88                	ld	a0,24(s1)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	d52080e7          	jalr	-686(ra) # 800034aa <iunlock>
      end_op(f->ip->dev);
    80004760:	6c9c                	ld	a5,24(s1)
    80004762:	4388                	lw	a0,0(a5)
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	7d6080e7          	jalr	2006(ra) # 80003f3a <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000476c:	052c1a63          	bne	s8,s2,800047c0 <filewrite+0x118>
        panic("short filewrite");
      i += r;
    80004770:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80004774:	0349d763          	bge	s3,s4,800047a2 <filewrite+0xfa>
      int n1 = n - i;
    80004778:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000477c:	893e                	mv	s2,a5
    8000477e:	2781                	sext.w	a5,a5
    80004780:	f8fb5ee3          	bge	s6,a5,8000471c <filewrite+0x74>
    80004784:	895e                	mv	s2,s7
    80004786:	bf59                	j	8000471c <filewrite+0x74>
      iunlock(f->ip);
    80004788:	6c88                	ld	a0,24(s1)
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	d20080e7          	jalr	-736(ra) # 800034aa <iunlock>
      end_op(f->ip->dev);
    80004792:	6c9c                	ld	a5,24(s1)
    80004794:	4388                	lw	a0,0(a5)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	7a4080e7          	jalr	1956(ra) # 80003f3a <end_op>
      if(r < 0)
    8000479e:	fc0957e3          	bgez	s2,8000476c <filewrite+0xc4>
    }
    ret = (i == n ? n : -1);
    800047a2:	8552                	mv	a0,s4
    800047a4:	033a1863          	bne	s4,s3,800047d4 <filewrite+0x12c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047a8:	60a6                	ld	ra,72(sp)
    800047aa:	6406                	ld	s0,64(sp)
    800047ac:	74e2                	ld	s1,56(sp)
    800047ae:	7942                	ld	s2,48(sp)
    800047b0:	79a2                	ld	s3,40(sp)
    800047b2:	7a02                	ld	s4,32(sp)
    800047b4:	6ae2                	ld	s5,24(sp)
    800047b6:	6b42                	ld	s6,16(sp)
    800047b8:	6ba2                	ld	s7,8(sp)
    800047ba:	6c02                	ld	s8,0(sp)
    800047bc:	6161                	addi	sp,sp,80
    800047be:	8082                	ret
        panic("short filewrite");
    800047c0:	00003517          	auipc	a0,0x3
    800047c4:	f4850513          	addi	a0,a0,-184 # 80007708 <userret+0x678>
    800047c8:	ffffc097          	auipc	ra,0xffffc
    800047cc:	d86080e7          	jalr	-634(ra) # 8000054e <panic>
    int i = 0;
    800047d0:	4981                	li	s3,0
    800047d2:	bfc1                	j	800047a2 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800047d4:	557d                	li	a0,-1
    800047d6:	bfc9                	j	800047a8 <filewrite+0x100>
    panic("filewrite");
    800047d8:	00003517          	auipc	a0,0x3
    800047dc:	f4050513          	addi	a0,a0,-192 # 80007718 <userret+0x688>
    800047e0:	ffffc097          	auipc	ra,0xffffc
    800047e4:	d6e080e7          	jalr	-658(ra) # 8000054e <panic>
    return -1;
    800047e8:	557d                	li	a0,-1
}
    800047ea:	8082                	ret

00000000800047ec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047ec:	7179                	addi	sp,sp,-48
    800047ee:	f406                	sd	ra,40(sp)
    800047f0:	f022                	sd	s0,32(sp)
    800047f2:	ec26                	sd	s1,24(sp)
    800047f4:	e84a                	sd	s2,16(sp)
    800047f6:	e44e                	sd	s3,8(sp)
    800047f8:	e052                	sd	s4,0(sp)
    800047fa:	1800                	addi	s0,sp,48
    800047fc:	84aa                	mv	s1,a0
    800047fe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004800:	0005b023          	sd	zero,0(a1)
    80004804:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004808:	00000097          	auipc	ra,0x0
    8000480c:	bf4080e7          	jalr	-1036(ra) # 800043fc <filealloc>
    80004810:	e088                	sd	a0,0(s1)
    80004812:	c551                	beqz	a0,8000489e <pipealloc+0xb2>
    80004814:	00000097          	auipc	ra,0x0
    80004818:	be8080e7          	jalr	-1048(ra) # 800043fc <filealloc>
    8000481c:	00aa3023          	sd	a0,0(s4)
    80004820:	c92d                	beqz	a0,80004892 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004822:	ffffc097          	auipc	ra,0xffffc
    80004826:	13e080e7          	jalr	318(ra) # 80000960 <kalloc>
    8000482a:	892a                	mv	s2,a0
    8000482c:	c125                	beqz	a0,8000488c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000482e:	4985                	li	s3,1
    80004830:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004834:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004838:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000483c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004840:	00003597          	auipc	a1,0x3
    80004844:	ee858593          	addi	a1,a1,-280 # 80007728 <userret+0x698>
    80004848:	ffffc097          	auipc	ra,0xffffc
    8000484c:	178080e7          	jalr	376(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    80004850:	609c                	ld	a5,0(s1)
    80004852:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004856:	609c                	ld	a5,0(s1)
    80004858:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000485c:	609c                	ld	a5,0(s1)
    8000485e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004862:	609c                	ld	a5,0(s1)
    80004864:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004868:	000a3783          	ld	a5,0(s4)
    8000486c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004870:	000a3783          	ld	a5,0(s4)
    80004874:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004878:	000a3783          	ld	a5,0(s4)
    8000487c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004880:	000a3783          	ld	a5,0(s4)
    80004884:	0127b823          	sd	s2,16(a5)
  return 0;
    80004888:	4501                	li	a0,0
    8000488a:	a025                	j	800048b2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000488c:	6088                	ld	a0,0(s1)
    8000488e:	e501                	bnez	a0,80004896 <pipealloc+0xaa>
    80004890:	a039                	j	8000489e <pipealloc+0xb2>
    80004892:	6088                	ld	a0,0(s1)
    80004894:	c51d                	beqz	a0,800048c2 <pipealloc+0xd6>
    fileclose(*f0);
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	c22080e7          	jalr	-990(ra) # 800044b8 <fileclose>
  if(*f1)
    8000489e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800048a2:	557d                	li	a0,-1
  if(*f1)
    800048a4:	c799                	beqz	a5,800048b2 <pipealloc+0xc6>
    fileclose(*f1);
    800048a6:	853e                	mv	a0,a5
    800048a8:	00000097          	auipc	ra,0x0
    800048ac:	c10080e7          	jalr	-1008(ra) # 800044b8 <fileclose>
  return -1;
    800048b0:	557d                	li	a0,-1
}
    800048b2:	70a2                	ld	ra,40(sp)
    800048b4:	7402                	ld	s0,32(sp)
    800048b6:	64e2                	ld	s1,24(sp)
    800048b8:	6942                	ld	s2,16(sp)
    800048ba:	69a2                	ld	s3,8(sp)
    800048bc:	6a02                	ld	s4,0(sp)
    800048be:	6145                	addi	sp,sp,48
    800048c0:	8082                	ret
  return -1;
    800048c2:	557d                	li	a0,-1
    800048c4:	b7fd                	j	800048b2 <pipealloc+0xc6>

00000000800048c6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048c6:	1101                	addi	sp,sp,-32
    800048c8:	ec06                	sd	ra,24(sp)
    800048ca:	e822                	sd	s0,16(sp)
    800048cc:	e426                	sd	s1,8(sp)
    800048ce:	e04a                	sd	s2,0(sp)
    800048d0:	1000                	addi	s0,sp,32
    800048d2:	84aa                	mv	s1,a0
    800048d4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048d6:	ffffc097          	auipc	ra,0xffffc
    800048da:	1fc080e7          	jalr	508(ra) # 80000ad2 <acquire>
  if(writable){
    800048de:	02090d63          	beqz	s2,80004918 <pipeclose+0x52>
    pi->writeopen = 0;
    800048e2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048e6:	21848513          	addi	a0,s1,536
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	89c080e7          	jalr	-1892(ra) # 80002186 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048f2:	2204b783          	ld	a5,544(s1)
    800048f6:	eb95                	bnez	a5,8000492a <pipeclose+0x64>
    release(&pi->lock);
    800048f8:	8526                	mv	a0,s1
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	240080e7          	jalr	576(ra) # 80000b3a <release>
    kfree((char*)pi);
    80004902:	8526                	mv	a0,s1
    80004904:	ffffc097          	auipc	ra,0xffffc
    80004908:	f60080e7          	jalr	-160(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    8000490c:	60e2                	ld	ra,24(sp)
    8000490e:	6442                	ld	s0,16(sp)
    80004910:	64a2                	ld	s1,8(sp)
    80004912:	6902                	ld	s2,0(sp)
    80004914:	6105                	addi	sp,sp,32
    80004916:	8082                	ret
    pi->readopen = 0;
    80004918:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000491c:	21c48513          	addi	a0,s1,540
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	866080e7          	jalr	-1946(ra) # 80002186 <wakeup>
    80004928:	b7e9                	j	800048f2 <pipeclose+0x2c>
    release(&pi->lock);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffc097          	auipc	ra,0xffffc
    80004930:	20e080e7          	jalr	526(ra) # 80000b3a <release>
}
    80004934:	bfe1                	j	8000490c <pipeclose+0x46>

0000000080004936 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004936:	7159                	addi	sp,sp,-112
    80004938:	f486                	sd	ra,104(sp)
    8000493a:	f0a2                	sd	s0,96(sp)
    8000493c:	eca6                	sd	s1,88(sp)
    8000493e:	e8ca                	sd	s2,80(sp)
    80004940:	e4ce                	sd	s3,72(sp)
    80004942:	e0d2                	sd	s4,64(sp)
    80004944:	fc56                	sd	s5,56(sp)
    80004946:	f85a                	sd	s6,48(sp)
    80004948:	f45e                	sd	s7,40(sp)
    8000494a:	f062                	sd	s8,32(sp)
    8000494c:	ec66                	sd	s9,24(sp)
    8000494e:	1880                	addi	s0,sp,112
    80004950:	84aa                	mv	s1,a0
    80004952:	8b2e                	mv	s6,a1
    80004954:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004956:	ffffd097          	auipc	ra,0xffffd
    8000495a:	ede080e7          	jalr	-290(ra) # 80001834 <myproc>
    8000495e:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	170080e7          	jalr	368(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    8000496a:	0b505063          	blez	s5,80004a0a <pipewrite+0xd4>
    8000496e:	8926                	mv	s2,s1
    80004970:	fffa8b9b          	addiw	s7,s5,-1
    80004974:	1b82                	slli	s7,s7,0x20
    80004976:	020bdb93          	srli	s7,s7,0x20
    8000497a:	001b0793          	addi	a5,s6,1
    8000497e:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004980:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004984:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004988:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000498a:	2184a783          	lw	a5,536(s1)
    8000498e:	21c4a703          	lw	a4,540(s1)
    80004992:	2007879b          	addiw	a5,a5,512
    80004996:	02f71e63          	bne	a4,a5,800049d2 <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    8000499a:	2204a783          	lw	a5,544(s1)
    8000499e:	c3d9                	beqz	a5,80004a24 <pipewrite+0xee>
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	e94080e7          	jalr	-364(ra) # 80001834 <myproc>
    800049a8:	591c                	lw	a5,48(a0)
    800049aa:	efad                	bnez	a5,80004a24 <pipewrite+0xee>
      wakeup(&pi->nread);
    800049ac:	8552                	mv	a0,s4
    800049ae:	ffffd097          	auipc	ra,0xffffd
    800049b2:	7d8080e7          	jalr	2008(ra) # 80002186 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800049b6:	85ca                	mv	a1,s2
    800049b8:	854e                	mv	a0,s3
    800049ba:	ffffd097          	auipc	ra,0xffffd
    800049be:	680080e7          	jalr	1664(ra) # 8000203a <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800049c2:	2184a783          	lw	a5,536(s1)
    800049c6:	21c4a703          	lw	a4,540(s1)
    800049ca:	2007879b          	addiw	a5,a5,512
    800049ce:	fcf706e3          	beq	a4,a5,8000499a <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049d2:	4685                	li	a3,1
    800049d4:	865a                	mv	a2,s6
    800049d6:	f9f40593          	addi	a1,s0,-97
    800049da:	048c3503          	ld	a0,72(s8)
    800049de:	ffffd097          	auipc	ra,0xffffd
    800049e2:	c0e080e7          	jalr	-1010(ra) # 800015ec <copyin>
    800049e6:	03950263          	beq	a0,s9,80004a0a <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049ea:	21c4a783          	lw	a5,540(s1)
    800049ee:	0017871b          	addiw	a4,a5,1
    800049f2:	20e4ae23          	sw	a4,540(s1)
    800049f6:	1ff7f793          	andi	a5,a5,511
    800049fa:	97a6                	add	a5,a5,s1
    800049fc:	f9f44703          	lbu	a4,-97(s0)
    80004a00:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004a04:	0b05                	addi	s6,s6,1
    80004a06:	f97b12e3          	bne	s6,s7,8000498a <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004a0a:	21848513          	addi	a0,s1,536
    80004a0e:	ffffd097          	auipc	ra,0xffffd
    80004a12:	778080e7          	jalr	1912(ra) # 80002186 <wakeup>
  release(&pi->lock);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	122080e7          	jalr	290(ra) # 80000b3a <release>
  return n;
    80004a20:	8556                	mv	a0,s5
    80004a22:	a039                	j	80004a30 <pipewrite+0xfa>
        release(&pi->lock);
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffc097          	auipc	ra,0xffffc
    80004a2a:	114080e7          	jalr	276(ra) # 80000b3a <release>
        return -1;
    80004a2e:	557d                	li	a0,-1
}
    80004a30:	70a6                	ld	ra,104(sp)
    80004a32:	7406                	ld	s0,96(sp)
    80004a34:	64e6                	ld	s1,88(sp)
    80004a36:	6946                	ld	s2,80(sp)
    80004a38:	69a6                	ld	s3,72(sp)
    80004a3a:	6a06                	ld	s4,64(sp)
    80004a3c:	7ae2                	ld	s5,56(sp)
    80004a3e:	7b42                	ld	s6,48(sp)
    80004a40:	7ba2                	ld	s7,40(sp)
    80004a42:	7c02                	ld	s8,32(sp)
    80004a44:	6ce2                	ld	s9,24(sp)
    80004a46:	6165                	addi	sp,sp,112
    80004a48:	8082                	ret

0000000080004a4a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a4a:	715d                	addi	sp,sp,-80
    80004a4c:	e486                	sd	ra,72(sp)
    80004a4e:	e0a2                	sd	s0,64(sp)
    80004a50:	fc26                	sd	s1,56(sp)
    80004a52:	f84a                	sd	s2,48(sp)
    80004a54:	f44e                	sd	s3,40(sp)
    80004a56:	f052                	sd	s4,32(sp)
    80004a58:	ec56                	sd	s5,24(sp)
    80004a5a:	e85a                	sd	s6,16(sp)
    80004a5c:	0880                	addi	s0,sp,80
    80004a5e:	84aa                	mv	s1,a0
    80004a60:	892e                	mv	s2,a1
    80004a62:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004a64:	ffffd097          	auipc	ra,0xffffd
    80004a68:	dd0080e7          	jalr	-560(ra) # 80001834 <myproc>
    80004a6c:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004a6e:	8b26                	mv	s6,s1
    80004a70:	8526                	mv	a0,s1
    80004a72:	ffffc097          	auipc	ra,0xffffc
    80004a76:	060080e7          	jalr	96(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a7a:	2184a703          	lw	a4,536(s1)
    80004a7e:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a82:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a86:	02f71763          	bne	a4,a5,80004ab4 <piperead+0x6a>
    80004a8a:	2244a783          	lw	a5,548(s1)
    80004a8e:	c39d                	beqz	a5,80004ab4 <piperead+0x6a>
    if(myproc()->killed){
    80004a90:	ffffd097          	auipc	ra,0xffffd
    80004a94:	da4080e7          	jalr	-604(ra) # 80001834 <myproc>
    80004a98:	591c                	lw	a5,48(a0)
    80004a9a:	ebc1                	bnez	a5,80004b2a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a9c:	85da                	mv	a1,s6
    80004a9e:	854e                	mv	a0,s3
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	59a080e7          	jalr	1434(ra) # 8000203a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004aa8:	2184a703          	lw	a4,536(s1)
    80004aac:	21c4a783          	lw	a5,540(s1)
    80004ab0:	fcf70de3          	beq	a4,a5,80004a8a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ab4:	09405263          	blez	s4,80004b38 <piperead+0xee>
    80004ab8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004aba:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004abc:	2184a783          	lw	a5,536(s1)
    80004ac0:	21c4a703          	lw	a4,540(s1)
    80004ac4:	02f70d63          	beq	a4,a5,80004afe <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ac8:	0017871b          	addiw	a4,a5,1
    80004acc:	20e4ac23          	sw	a4,536(s1)
    80004ad0:	1ff7f793          	andi	a5,a5,511
    80004ad4:	97a6                	add	a5,a5,s1
    80004ad6:	0187c783          	lbu	a5,24(a5)
    80004ada:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ade:	4685                	li	a3,1
    80004ae0:	fbf40613          	addi	a2,s0,-65
    80004ae4:	85ca                	mv	a1,s2
    80004ae6:	048ab503          	ld	a0,72(s5)
    80004aea:	ffffd097          	auipc	ra,0xffffd
    80004aee:	a70080e7          	jalr	-1424(ra) # 8000155a <copyout>
    80004af2:	01650663          	beq	a0,s6,80004afe <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004af6:	2985                	addiw	s3,s3,1
    80004af8:	0905                	addi	s2,s2,1
    80004afa:	fd3a11e3          	bne	s4,s3,80004abc <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004afe:	21c48513          	addi	a0,s1,540
    80004b02:	ffffd097          	auipc	ra,0xffffd
    80004b06:	684080e7          	jalr	1668(ra) # 80002186 <wakeup>
  release(&pi->lock);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffc097          	auipc	ra,0xffffc
    80004b10:	02e080e7          	jalr	46(ra) # 80000b3a <release>
  return i;
}
    80004b14:	854e                	mv	a0,s3
    80004b16:	60a6                	ld	ra,72(sp)
    80004b18:	6406                	ld	s0,64(sp)
    80004b1a:	74e2                	ld	s1,56(sp)
    80004b1c:	7942                	ld	s2,48(sp)
    80004b1e:	79a2                	ld	s3,40(sp)
    80004b20:	7a02                	ld	s4,32(sp)
    80004b22:	6ae2                	ld	s5,24(sp)
    80004b24:	6b42                	ld	s6,16(sp)
    80004b26:	6161                	addi	sp,sp,80
    80004b28:	8082                	ret
      release(&pi->lock);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	ffffc097          	auipc	ra,0xffffc
    80004b30:	00e080e7          	jalr	14(ra) # 80000b3a <release>
      return -1;
    80004b34:	59fd                	li	s3,-1
    80004b36:	bff9                	j	80004b14 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b38:	4981                	li	s3,0
    80004b3a:	b7d1                	j	80004afe <piperead+0xb4>

0000000080004b3c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004b3c:	df010113          	addi	sp,sp,-528
    80004b40:	20113423          	sd	ra,520(sp)
    80004b44:	20813023          	sd	s0,512(sp)
    80004b48:	ffa6                	sd	s1,504(sp)
    80004b4a:	fbca                	sd	s2,496(sp)
    80004b4c:	f7ce                	sd	s3,488(sp)
    80004b4e:	f3d2                	sd	s4,480(sp)
    80004b50:	efd6                	sd	s5,472(sp)
    80004b52:	ebda                	sd	s6,464(sp)
    80004b54:	e7de                	sd	s7,456(sp)
    80004b56:	e3e2                	sd	s8,448(sp)
    80004b58:	ff66                	sd	s9,440(sp)
    80004b5a:	fb6a                	sd	s10,432(sp)
    80004b5c:	f76e                	sd	s11,424(sp)
    80004b5e:	0c00                	addi	s0,sp,528
    80004b60:	84aa                	mv	s1,a0
    80004b62:	dea43c23          	sd	a0,-520(s0)
    80004b66:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b6a:	ffffd097          	auipc	ra,0xffffd
    80004b6e:	cca080e7          	jalr	-822(ra) # 80001834 <myproc>
    80004b72:	892a                	mv	s2,a0

  begin_op(ROOTDEV);
    80004b74:	4501                	li	a0,0
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	31a080e7          	jalr	794(ra) # 80003e90 <begin_op>

  if((ip = namei(path)) == 0){
    80004b7e:	8526                	mv	a0,s1
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	ff4080e7          	jalr	-12(ra) # 80003b74 <namei>
    80004b88:	c935                	beqz	a0,80004bfc <exec+0xc0>
    80004b8a:	84aa                	mv	s1,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	85c080e7          	jalr	-1956(ra) # 800033e8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b94:	04000713          	li	a4,64
    80004b98:	4681                	li	a3,0
    80004b9a:	e4840613          	addi	a2,s0,-440
    80004b9e:	4581                	li	a1,0
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	ad6080e7          	jalr	-1322(ra) # 80003678 <readi>
    80004baa:	04000793          	li	a5,64
    80004bae:	00f51a63          	bne	a0,a5,80004bc2 <exec+0x86>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004bb2:	e4842703          	lw	a4,-440(s0)
    80004bb6:	464c47b7          	lui	a5,0x464c4
    80004bba:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004bbe:	04f70663          	beq	a4,a5,80004c0a <exec+0xce>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004bc2:	8526                	mv	a0,s1
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	a62080e7          	jalr	-1438(ra) # 80003626 <iunlockput>
    end_op(ROOTDEV);
    80004bcc:	4501                	li	a0,0
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	36c080e7          	jalr	876(ra) # 80003f3a <end_op>
  }
  return -1;
    80004bd6:	557d                	li	a0,-1
}
    80004bd8:	20813083          	ld	ra,520(sp)
    80004bdc:	20013403          	ld	s0,512(sp)
    80004be0:	74fe                	ld	s1,504(sp)
    80004be2:	795e                	ld	s2,496(sp)
    80004be4:	79be                	ld	s3,488(sp)
    80004be6:	7a1e                	ld	s4,480(sp)
    80004be8:	6afe                	ld	s5,472(sp)
    80004bea:	6b5e                	ld	s6,464(sp)
    80004bec:	6bbe                	ld	s7,456(sp)
    80004bee:	6c1e                	ld	s8,448(sp)
    80004bf0:	7cfa                	ld	s9,440(sp)
    80004bf2:	7d5a                	ld	s10,432(sp)
    80004bf4:	7dba                	ld	s11,424(sp)
    80004bf6:	21010113          	addi	sp,sp,528
    80004bfa:	8082                	ret
    end_op(ROOTDEV);
    80004bfc:	4501                	li	a0,0
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	33c080e7          	jalr	828(ra) # 80003f3a <end_op>
    return -1;
    80004c06:	557d                	li	a0,-1
    80004c08:	bfc1                	j	80004bd8 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffd097          	auipc	ra,0xffffd
    80004c10:	cec080e7          	jalr	-788(ra) # 800018f8 <proc_pagetable>
    80004c14:	8c2a                	mv	s8,a0
    80004c16:	d555                	beqz	a0,80004bc2 <exec+0x86>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c18:	e6842983          	lw	s3,-408(s0)
    80004c1c:	e8045783          	lhu	a5,-384(s0)
    80004c20:	c7fd                	beqz	a5,80004d0e <exec+0x1d2>
  sz = 0;
    80004c22:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c26:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80004c28:	6b05                	lui	s6,0x1
    80004c2a:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004c2e:	def43823          	sd	a5,-528(s0)
    80004c32:	a0a5                	j	80004c9a <exec+0x15e>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004c34:	00003517          	auipc	a0,0x3
    80004c38:	afc50513          	addi	a0,a0,-1284 # 80007730 <userret+0x6a0>
    80004c3c:	ffffc097          	auipc	ra,0xffffc
    80004c40:	912080e7          	jalr	-1774(ra) # 8000054e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c44:	8756                	mv	a4,s5
    80004c46:	012d86bb          	addw	a3,s11,s2
    80004c4a:	4581                	li	a1,0
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	a2a080e7          	jalr	-1494(ra) # 80003678 <readi>
    80004c56:	2501                	sext.w	a0,a0
    80004c58:	10aa9263          	bne	s5,a0,80004d5c <exec+0x220>
  for(i = 0; i < sz; i += PGSIZE){
    80004c5c:	6785                	lui	a5,0x1
    80004c5e:	0127893b          	addw	s2,a5,s2
    80004c62:	77fd                	lui	a5,0xfffff
    80004c64:	01478a3b          	addw	s4,a5,s4
    80004c68:	03997263          	bgeu	s2,s9,80004c8c <exec+0x150>
    pa = walkaddr(pagetable, va + i);
    80004c6c:	02091593          	slli	a1,s2,0x20
    80004c70:	9181                	srli	a1,a1,0x20
    80004c72:	95ea                	add	a1,a1,s10
    80004c74:	8562                	mv	a0,s8
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	31e080e7          	jalr	798(ra) # 80000f94 <walkaddr>
    80004c7e:	862a                	mv	a2,a0
    if(pa == 0)
    80004c80:	d955                	beqz	a0,80004c34 <exec+0xf8>
      n = PGSIZE;
    80004c82:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    80004c84:	fd6a70e3          	bgeu	s4,s6,80004c44 <exec+0x108>
      n = sz - i;
    80004c88:	8ad2                	mv	s5,s4
    80004c8a:	bf6d                	j	80004c44 <exec+0x108>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c8c:	2b85                	addiw	s7,s7,1
    80004c8e:	0389899b          	addiw	s3,s3,56
    80004c92:	e8045783          	lhu	a5,-384(s0)
    80004c96:	06fbde63          	bge	s7,a5,80004d12 <exec+0x1d6>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c9a:	2981                	sext.w	s3,s3
    80004c9c:	03800713          	li	a4,56
    80004ca0:	86ce                	mv	a3,s3
    80004ca2:	e1040613          	addi	a2,s0,-496
    80004ca6:	4581                	li	a1,0
    80004ca8:	8526                	mv	a0,s1
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	9ce080e7          	jalr	-1586(ra) # 80003678 <readi>
    80004cb2:	03800793          	li	a5,56
    80004cb6:	0af51363          	bne	a0,a5,80004d5c <exec+0x220>
    if(ph.type != ELF_PROG_LOAD)
    80004cba:	e1042783          	lw	a5,-496(s0)
    80004cbe:	4705                	li	a4,1
    80004cc0:	fce796e3          	bne	a5,a4,80004c8c <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004cc4:	e3843603          	ld	a2,-456(s0)
    80004cc8:	e3043783          	ld	a5,-464(s0)
    80004ccc:	08f66863          	bltu	a2,a5,80004d5c <exec+0x220>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004cd0:	e2043783          	ld	a5,-480(s0)
    80004cd4:	963e                	add	a2,a2,a5
    80004cd6:	08f66363          	bltu	a2,a5,80004d5c <exec+0x220>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004cda:	e0843583          	ld	a1,-504(s0)
    80004cde:	8562                	mv	a0,s8
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	6a0080e7          	jalr	1696(ra) # 80001380 <uvmalloc>
    80004ce8:	e0a43423          	sd	a0,-504(s0)
    80004cec:	c925                	beqz	a0,80004d5c <exec+0x220>
    if(ph.vaddr % PGSIZE != 0)
    80004cee:	e2043d03          	ld	s10,-480(s0)
    80004cf2:	df043783          	ld	a5,-528(s0)
    80004cf6:	00fd77b3          	and	a5,s10,a5
    80004cfa:	e3ad                	bnez	a5,80004d5c <exec+0x220>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004cfc:	e1842d83          	lw	s11,-488(s0)
    80004d00:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004d04:	f80c84e3          	beqz	s9,80004c8c <exec+0x150>
    80004d08:	8a66                	mv	s4,s9
    80004d0a:	4901                	li	s2,0
    80004d0c:	b785                	j	80004c6c <exec+0x130>
  sz = 0;
    80004d0e:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80004d12:	8526                	mv	a0,s1
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	912080e7          	jalr	-1774(ra) # 80003626 <iunlockput>
  end_op(ROOTDEV);
    80004d1c:	4501                	li	a0,0
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	21c080e7          	jalr	540(ra) # 80003f3a <end_op>
  p = myproc();
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	b0e080e7          	jalr	-1266(ra) # 80001834 <myproc>
    80004d2e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004d30:	04053d03          	ld	s10,64(a0)
  sz = PGROUNDUP(sz);
    80004d34:	6585                	lui	a1,0x1
    80004d36:	15fd                	addi	a1,a1,-1
    80004d38:	e0843783          	ld	a5,-504(s0)
    80004d3c:	00b78b33          	add	s6,a5,a1
    80004d40:	75fd                	lui	a1,0xfffff
    80004d42:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004d46:	6609                	lui	a2,0x2
    80004d48:	962e                	add	a2,a2,a1
    80004d4a:	8562                	mv	a0,s8
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	634080e7          	jalr	1588(ra) # 80001380 <uvmalloc>
    80004d54:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004d58:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004d5a:	ed01                	bnez	a0,80004d72 <exec+0x236>
    proc_freepagetable(pagetable, sz);
    80004d5c:	e0843583          	ld	a1,-504(s0)
    80004d60:	8562                	mv	a0,s8
    80004d62:	ffffd097          	auipc	ra,0xffffd
    80004d66:	c96080e7          	jalr	-874(ra) # 800019f8 <proc_freepagetable>
  if(ip){
    80004d6a:	e4049ce3          	bnez	s1,80004bc2 <exec+0x86>
  return -1;
    80004d6e:	557d                	li	a0,-1
    80004d70:	b5a5                	j	80004bd8 <exec+0x9c>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004d72:	75f9                	lui	a1,0xffffe
    80004d74:	84aa                	mv	s1,a0
    80004d76:	95aa                	add	a1,a1,a0
    80004d78:	8562                	mv	a0,s8
    80004d7a:	ffffc097          	auipc	ra,0xffffc
    80004d7e:	7ae080e7          	jalr	1966(ra) # 80001528 <uvmclear>
  stackbase = sp - PGSIZE;
    80004d82:	7afd                	lui	s5,0xfffff
    80004d84:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004d86:	e0043783          	ld	a5,-512(s0)
    80004d8a:	6388                	ld	a0,0(a5)
    80004d8c:	c135                	beqz	a0,80004df0 <exec+0x2b4>
    80004d8e:	e8840993          	addi	s3,s0,-376
    80004d92:	f8840c93          	addi	s9,s0,-120
    80004d96:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	f86080e7          	jalr	-122(ra) # 80000d1e <strlen>
    80004da0:	2505                	addiw	a0,a0,1
    80004da2:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004da4:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80004da6:	0f54ea63          	bltu	s1,s5,80004e9a <exec+0x35e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004daa:	e0043b03          	ld	s6,-512(s0)
    80004dae:	000b3a03          	ld	s4,0(s6)
    80004db2:	8552                	mv	a0,s4
    80004db4:	ffffc097          	auipc	ra,0xffffc
    80004db8:	f6a080e7          	jalr	-150(ra) # 80000d1e <strlen>
    80004dbc:	0015069b          	addiw	a3,a0,1
    80004dc0:	8652                	mv	a2,s4
    80004dc2:	85a6                	mv	a1,s1
    80004dc4:	8562                	mv	a0,s8
    80004dc6:	ffffc097          	auipc	ra,0xffffc
    80004dca:	794080e7          	jalr	1940(ra) # 8000155a <copyout>
    80004dce:	0c054863          	bltz	a0,80004e9e <exec+0x362>
    ustack[argc] = sp;
    80004dd2:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004dd6:	0905                	addi	s2,s2,1
    80004dd8:	008b0793          	addi	a5,s6,8
    80004ddc:	e0f43023          	sd	a5,-512(s0)
    80004de0:	008b3503          	ld	a0,8(s6)
    80004de4:	c909                	beqz	a0,80004df6 <exec+0x2ba>
    if(argc >= MAXARG)
    80004de6:	09a1                	addi	s3,s3,8
    80004de8:	fb3c98e3          	bne	s9,s3,80004d98 <exec+0x25c>
  ip = 0;
    80004dec:	4481                	li	s1,0
    80004dee:	b7bd                	j	80004d5c <exec+0x220>
  sp = sz;
    80004df0:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004df4:	4901                	li	s2,0
  ustack[argc] = 0;
    80004df6:	00391793          	slli	a5,s2,0x3
    80004dfa:	f9040713          	addi	a4,s0,-112
    80004dfe:	97ba                	add	a5,a5,a4
    80004e00:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <ticks+0xffffffff7ffd5ed0>
  sp -= (argc+1) * sizeof(uint64);
    80004e04:	00190693          	addi	a3,s2,1
    80004e08:	068e                	slli	a3,a3,0x3
    80004e0a:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80004e0c:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80004e10:	4481                	li	s1,0
  if(sp < stackbase)
    80004e12:	f559e5e3          	bltu	s3,s5,80004d5c <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e16:	e8840613          	addi	a2,s0,-376
    80004e1a:	85ce                	mv	a1,s3
    80004e1c:	8562                	mv	a0,s8
    80004e1e:	ffffc097          	auipc	ra,0xffffc
    80004e22:	73c080e7          	jalr	1852(ra) # 8000155a <copyout>
    80004e26:	06054e63          	bltz	a0,80004ea2 <exec+0x366>
  p->tf->a1 = sp;
    80004e2a:	050bb783          	ld	a5,80(s7) # 1050 <_entry-0x7fffefb0>
    80004e2e:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80004e32:	df843783          	ld	a5,-520(s0)
    80004e36:	0007c703          	lbu	a4,0(a5)
    80004e3a:	cf11                	beqz	a4,80004e56 <exec+0x31a>
    80004e3c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e3e:	02f00693          	li	a3,47
    80004e42:	a029                	j	80004e4c <exec+0x310>
  for(last=s=path; *s; s++)
    80004e44:	0785                	addi	a5,a5,1
    80004e46:	fff7c703          	lbu	a4,-1(a5)
    80004e4a:	c711                	beqz	a4,80004e56 <exec+0x31a>
    if(*s == '/')
    80004e4c:	fed71ce3          	bne	a4,a3,80004e44 <exec+0x308>
      last = s+1;
    80004e50:	def43c23          	sd	a5,-520(s0)
    80004e54:	bfc5                	j	80004e44 <exec+0x308>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e56:	4641                	li	a2,16
    80004e58:	df843583          	ld	a1,-520(s0)
    80004e5c:	150b8513          	addi	a0,s7,336
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	e8c080e7          	jalr	-372(ra) # 80000cec <safestrcpy>
  oldpagetable = p->pagetable;
    80004e68:	048bb503          	ld	a0,72(s7)
  p->pagetable = pagetable;
    80004e6c:	058bb423          	sd	s8,72(s7)
  p->sz = sz;
    80004e70:	e0843783          	ld	a5,-504(s0)
    80004e74:	04fbb023          	sd	a5,64(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004e78:	050bb783          	ld	a5,80(s7)
    80004e7c:	e6043703          	ld	a4,-416(s0)
    80004e80:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004e82:	050bb783          	ld	a5,80(s7)
    80004e86:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e8a:	85ea                	mv	a1,s10
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	b6c080e7          	jalr	-1172(ra) # 800019f8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e94:	0009051b          	sext.w	a0,s2
    80004e98:	b381                	j	80004bd8 <exec+0x9c>
  ip = 0;
    80004e9a:	4481                	li	s1,0
    80004e9c:	b5c1                	j	80004d5c <exec+0x220>
    80004e9e:	4481                	li	s1,0
    80004ea0:	bd75                	j	80004d5c <exec+0x220>
    80004ea2:	4481                	li	s1,0
    80004ea4:	bd65                	j	80004d5c <exec+0x220>

0000000080004ea6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ea6:	7179                	addi	sp,sp,-48
    80004ea8:	f406                	sd	ra,40(sp)
    80004eaa:	f022                	sd	s0,32(sp)
    80004eac:	ec26                	sd	s1,24(sp)
    80004eae:	e84a                	sd	s2,16(sp)
    80004eb0:	1800                	addi	s0,sp,48
    80004eb2:	892e                	mv	s2,a1
    80004eb4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004eb6:	fdc40593          	addi	a1,s0,-36
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	9ec080e7          	jalr	-1556(ra) # 800028a6 <argint>
    80004ec2:	04054063          	bltz	a0,80004f02 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004ec6:	fdc42703          	lw	a4,-36(s0)
    80004eca:	47bd                	li	a5,15
    80004ecc:	02e7ed63          	bltu	a5,a4,80004f06 <argfd+0x60>
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	964080e7          	jalr	-1692(ra) # 80001834 <myproc>
    80004ed8:	fdc42703          	lw	a4,-36(s0)
    80004edc:	01870793          	addi	a5,a4,24
    80004ee0:	078e                	slli	a5,a5,0x3
    80004ee2:	953e                	add	a0,a0,a5
    80004ee4:	651c                	ld	a5,8(a0)
    80004ee6:	c395                	beqz	a5,80004f0a <argfd+0x64>
    return -1;
  if(pfd)
    80004ee8:	00090463          	beqz	s2,80004ef0 <argfd+0x4a>
    *pfd = fd;
    80004eec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ef0:	4501                	li	a0,0
  if(pf)
    80004ef2:	c091                	beqz	s1,80004ef6 <argfd+0x50>
    *pf = f;
    80004ef4:	e09c                	sd	a5,0(s1)
}
    80004ef6:	70a2                	ld	ra,40(sp)
    80004ef8:	7402                	ld	s0,32(sp)
    80004efa:	64e2                	ld	s1,24(sp)
    80004efc:	6942                	ld	s2,16(sp)
    80004efe:	6145                	addi	sp,sp,48
    80004f00:	8082                	ret
    return -1;
    80004f02:	557d                	li	a0,-1
    80004f04:	bfcd                	j	80004ef6 <argfd+0x50>
    return -1;
    80004f06:	557d                	li	a0,-1
    80004f08:	b7fd                	j	80004ef6 <argfd+0x50>
    80004f0a:	557d                	li	a0,-1
    80004f0c:	b7ed                	j	80004ef6 <argfd+0x50>

0000000080004f0e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f0e:	1101                	addi	sp,sp,-32
    80004f10:	ec06                	sd	ra,24(sp)
    80004f12:	e822                	sd	s0,16(sp)
    80004f14:	e426                	sd	s1,8(sp)
    80004f16:	1000                	addi	s0,sp,32
    80004f18:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	91a080e7          	jalr	-1766(ra) # 80001834 <myproc>
    80004f22:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f24:	0c850793          	addi	a5,a0,200
    80004f28:	4501                	li	a0,0
    80004f2a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f2c:	6398                	ld	a4,0(a5)
    80004f2e:	cb19                	beqz	a4,80004f44 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004f30:	2505                	addiw	a0,a0,1
    80004f32:	07a1                	addi	a5,a5,8
    80004f34:	fed51ce3          	bne	a0,a3,80004f2c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f38:	557d                	li	a0,-1
}
    80004f3a:	60e2                	ld	ra,24(sp)
    80004f3c:	6442                	ld	s0,16(sp)
    80004f3e:	64a2                	ld	s1,8(sp)
    80004f40:	6105                	addi	sp,sp,32
    80004f42:	8082                	ret
      p->ofile[fd] = f;
    80004f44:	01850793          	addi	a5,a0,24
    80004f48:	078e                	slli	a5,a5,0x3
    80004f4a:	963e                	add	a2,a2,a5
    80004f4c:	e604                	sd	s1,8(a2)
      return fd;
    80004f4e:	b7f5                	j	80004f3a <fdalloc+0x2c>

0000000080004f50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f50:	715d                	addi	sp,sp,-80
    80004f52:	e486                	sd	ra,72(sp)
    80004f54:	e0a2                	sd	s0,64(sp)
    80004f56:	fc26                	sd	s1,56(sp)
    80004f58:	f84a                	sd	s2,48(sp)
    80004f5a:	f44e                	sd	s3,40(sp)
    80004f5c:	f052                	sd	s4,32(sp)
    80004f5e:	ec56                	sd	s5,24(sp)
    80004f60:	0880                	addi	s0,sp,80
    80004f62:	89ae                	mv	s3,a1
    80004f64:	8ab2                	mv	s5,a2
    80004f66:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f68:	fb040593          	addi	a1,s0,-80
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	c26080e7          	jalr	-986(ra) # 80003b92 <nameiparent>
    80004f74:	892a                	mv	s2,a0
    80004f76:	12050f63          	beqz	a0,800050b4 <create+0x164>
    return 0;
  ilock(dp);
    80004f7a:	ffffe097          	auipc	ra,0xffffe
    80004f7e:	46e080e7          	jalr	1134(ra) # 800033e8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f82:	4601                	li	a2,0
    80004f84:	fb040593          	addi	a1,s0,-80
    80004f88:	854a                	mv	a0,s2
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	918080e7          	jalr	-1768(ra) # 800038a2 <dirlookup>
    80004f92:	84aa                	mv	s1,a0
    80004f94:	c921                	beqz	a0,80004fe4 <create+0x94>
    iunlockput(dp);
    80004f96:	854a                	mv	a0,s2
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	68e080e7          	jalr	1678(ra) # 80003626 <iunlockput>
    ilock(ip);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	446080e7          	jalr	1094(ra) # 800033e8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004faa:	2981                	sext.w	s3,s3
    80004fac:	4789                	li	a5,2
    80004fae:	02f99463          	bne	s3,a5,80004fd6 <create+0x86>
    80004fb2:	0444d783          	lhu	a5,68(s1)
    80004fb6:	37f9                	addiw	a5,a5,-2
    80004fb8:	17c2                	slli	a5,a5,0x30
    80004fba:	93c1                	srli	a5,a5,0x30
    80004fbc:	4705                	li	a4,1
    80004fbe:	00f76c63          	bltu	a4,a5,80004fd6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	60a6                	ld	ra,72(sp)
    80004fc6:	6406                	ld	s0,64(sp)
    80004fc8:	74e2                	ld	s1,56(sp)
    80004fca:	7942                	ld	s2,48(sp)
    80004fcc:	79a2                	ld	s3,40(sp)
    80004fce:	7a02                	ld	s4,32(sp)
    80004fd0:	6ae2                	ld	s5,24(sp)
    80004fd2:	6161                	addi	sp,sp,80
    80004fd4:	8082                	ret
    iunlockput(ip);
    80004fd6:	8526                	mv	a0,s1
    80004fd8:	ffffe097          	auipc	ra,0xffffe
    80004fdc:	64e080e7          	jalr	1614(ra) # 80003626 <iunlockput>
    return 0;
    80004fe0:	4481                	li	s1,0
    80004fe2:	b7c5                	j	80004fc2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004fe4:	85ce                	mv	a1,s3
    80004fe6:	00092503          	lw	a0,0(s2)
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	266080e7          	jalr	614(ra) # 80003250 <ialloc>
    80004ff2:	84aa                	mv	s1,a0
    80004ff4:	c529                	beqz	a0,8000503e <create+0xee>
  ilock(ip);
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	3f2080e7          	jalr	1010(ra) # 800033e8 <ilock>
  ip->major = major;
    80004ffe:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005002:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005006:	4785                	li	a5,1
    80005008:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000500c:	8526                	mv	a0,s1
    8000500e:	ffffe097          	auipc	ra,0xffffe
    80005012:	310080e7          	jalr	784(ra) # 8000331e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005016:	2981                	sext.w	s3,s3
    80005018:	4785                	li	a5,1
    8000501a:	02f98a63          	beq	s3,a5,8000504e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000501e:	40d0                	lw	a2,4(s1)
    80005020:	fb040593          	addi	a1,s0,-80
    80005024:	854a                	mv	a0,s2
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	a8c080e7          	jalr	-1396(ra) # 80003ab2 <dirlink>
    8000502e:	06054b63          	bltz	a0,800050a4 <create+0x154>
  iunlockput(dp);
    80005032:	854a                	mv	a0,s2
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	5f2080e7          	jalr	1522(ra) # 80003626 <iunlockput>
  return ip;
    8000503c:	b759                	j	80004fc2 <create+0x72>
    panic("create: ialloc");
    8000503e:	00002517          	auipc	a0,0x2
    80005042:	71250513          	addi	a0,a0,1810 # 80007750 <userret+0x6c0>
    80005046:	ffffb097          	auipc	ra,0xffffb
    8000504a:	508080e7          	jalr	1288(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    8000504e:	04a95783          	lhu	a5,74(s2)
    80005052:	2785                	addiw	a5,a5,1
    80005054:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005058:	854a                	mv	a0,s2
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	2c4080e7          	jalr	708(ra) # 8000331e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005062:	40d0                	lw	a2,4(s1)
    80005064:	00002597          	auipc	a1,0x2
    80005068:	6fc58593          	addi	a1,a1,1788 # 80007760 <userret+0x6d0>
    8000506c:	8526                	mv	a0,s1
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	a44080e7          	jalr	-1468(ra) # 80003ab2 <dirlink>
    80005076:	00054f63          	bltz	a0,80005094 <create+0x144>
    8000507a:	00492603          	lw	a2,4(s2)
    8000507e:	00002597          	auipc	a1,0x2
    80005082:	6ea58593          	addi	a1,a1,1770 # 80007768 <userret+0x6d8>
    80005086:	8526                	mv	a0,s1
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	a2a080e7          	jalr	-1494(ra) # 80003ab2 <dirlink>
    80005090:	f80557e3          	bgez	a0,8000501e <create+0xce>
      panic("create dots");
    80005094:	00002517          	auipc	a0,0x2
    80005098:	6dc50513          	addi	a0,a0,1756 # 80007770 <userret+0x6e0>
    8000509c:	ffffb097          	auipc	ra,0xffffb
    800050a0:	4b2080e7          	jalr	1202(ra) # 8000054e <panic>
    panic("create: dirlink");
    800050a4:	00002517          	auipc	a0,0x2
    800050a8:	6dc50513          	addi	a0,a0,1756 # 80007780 <userret+0x6f0>
    800050ac:	ffffb097          	auipc	ra,0xffffb
    800050b0:	4a2080e7          	jalr	1186(ra) # 8000054e <panic>
    return 0;
    800050b4:	84aa                	mv	s1,a0
    800050b6:	b731                	j	80004fc2 <create+0x72>

00000000800050b8 <sys_dup>:
{
    800050b8:	7179                	addi	sp,sp,-48
    800050ba:	f406                	sd	ra,40(sp)
    800050bc:	f022                	sd	s0,32(sp)
    800050be:	ec26                	sd	s1,24(sp)
    800050c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800050c2:	fd840613          	addi	a2,s0,-40
    800050c6:	4581                	li	a1,0
    800050c8:	4501                	li	a0,0
    800050ca:	00000097          	auipc	ra,0x0
    800050ce:	ddc080e7          	jalr	-548(ra) # 80004ea6 <argfd>
    return -1;
    800050d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800050d4:	02054363          	bltz	a0,800050fa <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800050d8:	fd843503          	ld	a0,-40(s0)
    800050dc:	00000097          	auipc	ra,0x0
    800050e0:	e32080e7          	jalr	-462(ra) # 80004f0e <fdalloc>
    800050e4:	84aa                	mv	s1,a0
    return -1;
    800050e6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800050e8:	00054963          	bltz	a0,800050fa <sys_dup+0x42>
  filedup(f);
    800050ec:	fd843503          	ld	a0,-40(s0)
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	376080e7          	jalr	886(ra) # 80004466 <filedup>
  return fd;
    800050f8:	87a6                	mv	a5,s1
}
    800050fa:	853e                	mv	a0,a5
    800050fc:	70a2                	ld	ra,40(sp)
    800050fe:	7402                	ld	s0,32(sp)
    80005100:	64e2                	ld	s1,24(sp)
    80005102:	6145                	addi	sp,sp,48
    80005104:	8082                	ret

0000000080005106 <sys_read>:
{
    80005106:	7179                	addi	sp,sp,-48
    80005108:	f406                	sd	ra,40(sp)
    8000510a:	f022                	sd	s0,32(sp)
    8000510c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000510e:	fe840613          	addi	a2,s0,-24
    80005112:	4581                	li	a1,0
    80005114:	4501                	li	a0,0
    80005116:	00000097          	auipc	ra,0x0
    8000511a:	d90080e7          	jalr	-624(ra) # 80004ea6 <argfd>
    return -1;
    8000511e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005120:	04054163          	bltz	a0,80005162 <sys_read+0x5c>
    80005124:	fe440593          	addi	a1,s0,-28
    80005128:	4509                	li	a0,2
    8000512a:	ffffd097          	auipc	ra,0xffffd
    8000512e:	77c080e7          	jalr	1916(ra) # 800028a6 <argint>
    return -1;
    80005132:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005134:	02054763          	bltz	a0,80005162 <sys_read+0x5c>
    80005138:	fd840593          	addi	a1,s0,-40
    8000513c:	4505                	li	a0,1
    8000513e:	ffffd097          	auipc	ra,0xffffd
    80005142:	78a080e7          	jalr	1930(ra) # 800028c8 <argaddr>
    return -1;
    80005146:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005148:	00054d63          	bltz	a0,80005162 <sys_read+0x5c>
  return fileread(f, p, n);
    8000514c:	fe442603          	lw	a2,-28(s0)
    80005150:	fd843583          	ld	a1,-40(s0)
    80005154:	fe843503          	ld	a0,-24(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	4a2080e7          	jalr	1186(ra) # 800045fa <fileread>
    80005160:	87aa                	mv	a5,a0
}
    80005162:	853e                	mv	a0,a5
    80005164:	70a2                	ld	ra,40(sp)
    80005166:	7402                	ld	s0,32(sp)
    80005168:	6145                	addi	sp,sp,48
    8000516a:	8082                	ret

000000008000516c <sys_write>:
{
    8000516c:	7179                	addi	sp,sp,-48
    8000516e:	f406                	sd	ra,40(sp)
    80005170:	f022                	sd	s0,32(sp)
    80005172:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005174:	fe840613          	addi	a2,s0,-24
    80005178:	4581                	li	a1,0
    8000517a:	4501                	li	a0,0
    8000517c:	00000097          	auipc	ra,0x0
    80005180:	d2a080e7          	jalr	-726(ra) # 80004ea6 <argfd>
    return -1;
    80005184:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005186:	04054163          	bltz	a0,800051c8 <sys_write+0x5c>
    8000518a:	fe440593          	addi	a1,s0,-28
    8000518e:	4509                	li	a0,2
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	716080e7          	jalr	1814(ra) # 800028a6 <argint>
    return -1;
    80005198:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000519a:	02054763          	bltz	a0,800051c8 <sys_write+0x5c>
    8000519e:	fd840593          	addi	a1,s0,-40
    800051a2:	4505                	li	a0,1
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	724080e7          	jalr	1828(ra) # 800028c8 <argaddr>
    return -1;
    800051ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051ae:	00054d63          	bltz	a0,800051c8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800051b2:	fe442603          	lw	a2,-28(s0)
    800051b6:	fd843583          	ld	a1,-40(s0)
    800051ba:	fe843503          	ld	a0,-24(s0)
    800051be:	fffff097          	auipc	ra,0xfffff
    800051c2:	4ea080e7          	jalr	1258(ra) # 800046a8 <filewrite>
    800051c6:	87aa                	mv	a5,a0
}
    800051c8:	853e                	mv	a0,a5
    800051ca:	70a2                	ld	ra,40(sp)
    800051cc:	7402                	ld	s0,32(sp)
    800051ce:	6145                	addi	sp,sp,48
    800051d0:	8082                	ret

00000000800051d2 <sys_close>:
{
    800051d2:	1101                	addi	sp,sp,-32
    800051d4:	ec06                	sd	ra,24(sp)
    800051d6:	e822                	sd	s0,16(sp)
    800051d8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051da:	fe040613          	addi	a2,s0,-32
    800051de:	fec40593          	addi	a1,s0,-20
    800051e2:	4501                	li	a0,0
    800051e4:	00000097          	auipc	ra,0x0
    800051e8:	cc2080e7          	jalr	-830(ra) # 80004ea6 <argfd>
    return -1;
    800051ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051ee:	02054463          	bltz	a0,80005216 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800051f2:	ffffc097          	auipc	ra,0xffffc
    800051f6:	642080e7          	jalr	1602(ra) # 80001834 <myproc>
    800051fa:	fec42783          	lw	a5,-20(s0)
    800051fe:	07e1                	addi	a5,a5,24
    80005200:	078e                	slli	a5,a5,0x3
    80005202:	97aa                	add	a5,a5,a0
    80005204:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005208:	fe043503          	ld	a0,-32(s0)
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	2ac080e7          	jalr	684(ra) # 800044b8 <fileclose>
  return 0;
    80005214:	4781                	li	a5,0
}
    80005216:	853e                	mv	a0,a5
    80005218:	60e2                	ld	ra,24(sp)
    8000521a:	6442                	ld	s0,16(sp)
    8000521c:	6105                	addi	sp,sp,32
    8000521e:	8082                	ret

0000000080005220 <sys_fstat>:
{
    80005220:	1101                	addi	sp,sp,-32
    80005222:	ec06                	sd	ra,24(sp)
    80005224:	e822                	sd	s0,16(sp)
    80005226:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005228:	fe840613          	addi	a2,s0,-24
    8000522c:	4581                	li	a1,0
    8000522e:	4501                	li	a0,0
    80005230:	00000097          	auipc	ra,0x0
    80005234:	c76080e7          	jalr	-906(ra) # 80004ea6 <argfd>
    return -1;
    80005238:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000523a:	02054563          	bltz	a0,80005264 <sys_fstat+0x44>
    8000523e:	fe040593          	addi	a1,s0,-32
    80005242:	4505                	li	a0,1
    80005244:	ffffd097          	auipc	ra,0xffffd
    80005248:	684080e7          	jalr	1668(ra) # 800028c8 <argaddr>
    return -1;
    8000524c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000524e:	00054b63          	bltz	a0,80005264 <sys_fstat+0x44>
  return filestat(f, st);
    80005252:	fe043583          	ld	a1,-32(s0)
    80005256:	fe843503          	ld	a0,-24(s0)
    8000525a:	fffff097          	auipc	ra,0xfffff
    8000525e:	32e080e7          	jalr	814(ra) # 80004588 <filestat>
    80005262:	87aa                	mv	a5,a0
}
    80005264:	853e                	mv	a0,a5
    80005266:	60e2                	ld	ra,24(sp)
    80005268:	6442                	ld	s0,16(sp)
    8000526a:	6105                	addi	sp,sp,32
    8000526c:	8082                	ret

000000008000526e <sys_link>:
{
    8000526e:	7169                	addi	sp,sp,-304
    80005270:	f606                	sd	ra,296(sp)
    80005272:	f222                	sd	s0,288(sp)
    80005274:	ee26                	sd	s1,280(sp)
    80005276:	ea4a                	sd	s2,272(sp)
    80005278:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000527a:	08000613          	li	a2,128
    8000527e:	ed040593          	addi	a1,s0,-304
    80005282:	4501                	li	a0,0
    80005284:	ffffd097          	auipc	ra,0xffffd
    80005288:	666080e7          	jalr	1638(ra) # 800028ea <argstr>
    return -1;
    8000528c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000528e:	12054363          	bltz	a0,800053b4 <sys_link+0x146>
    80005292:	08000613          	li	a2,128
    80005296:	f5040593          	addi	a1,s0,-176
    8000529a:	4505                	li	a0,1
    8000529c:	ffffd097          	auipc	ra,0xffffd
    800052a0:	64e080e7          	jalr	1614(ra) # 800028ea <argstr>
    return -1;
    800052a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052a6:	10054763          	bltz	a0,800053b4 <sys_link+0x146>
  begin_op(ROOTDEV);
    800052aa:	4501                	li	a0,0
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	be4080e7          	jalr	-1052(ra) # 80003e90 <begin_op>
  if((ip = namei(old)) == 0){
    800052b4:	ed040513          	addi	a0,s0,-304
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	8bc080e7          	jalr	-1860(ra) # 80003b74 <namei>
    800052c0:	84aa                	mv	s1,a0
    800052c2:	c559                	beqz	a0,80005350 <sys_link+0xe2>
  ilock(ip);
    800052c4:	ffffe097          	auipc	ra,0xffffe
    800052c8:	124080e7          	jalr	292(ra) # 800033e8 <ilock>
  if(ip->type == T_DIR){
    800052cc:	04449703          	lh	a4,68(s1)
    800052d0:	4785                	li	a5,1
    800052d2:	08f70663          	beq	a4,a5,8000535e <sys_link+0xf0>
  ip->nlink++;
    800052d6:	04a4d783          	lhu	a5,74(s1)
    800052da:	2785                	addiw	a5,a5,1
    800052dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052e0:	8526                	mv	a0,s1
    800052e2:	ffffe097          	auipc	ra,0xffffe
    800052e6:	03c080e7          	jalr	60(ra) # 8000331e <iupdate>
  iunlock(ip);
    800052ea:	8526                	mv	a0,s1
    800052ec:	ffffe097          	auipc	ra,0xffffe
    800052f0:	1be080e7          	jalr	446(ra) # 800034aa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052f4:	fd040593          	addi	a1,s0,-48
    800052f8:	f5040513          	addi	a0,s0,-176
    800052fc:	fffff097          	auipc	ra,0xfffff
    80005300:	896080e7          	jalr	-1898(ra) # 80003b92 <nameiparent>
    80005304:	892a                	mv	s2,a0
    80005306:	cd2d                	beqz	a0,80005380 <sys_link+0x112>
  ilock(dp);
    80005308:	ffffe097          	auipc	ra,0xffffe
    8000530c:	0e0080e7          	jalr	224(ra) # 800033e8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005310:	00092703          	lw	a4,0(s2)
    80005314:	409c                	lw	a5,0(s1)
    80005316:	06f71063          	bne	a4,a5,80005376 <sys_link+0x108>
    8000531a:	40d0                	lw	a2,4(s1)
    8000531c:	fd040593          	addi	a1,s0,-48
    80005320:	854a                	mv	a0,s2
    80005322:	ffffe097          	auipc	ra,0xffffe
    80005326:	790080e7          	jalr	1936(ra) # 80003ab2 <dirlink>
    8000532a:	04054663          	bltz	a0,80005376 <sys_link+0x108>
  iunlockput(dp);
    8000532e:	854a                	mv	a0,s2
    80005330:	ffffe097          	auipc	ra,0xffffe
    80005334:	2f6080e7          	jalr	758(ra) # 80003626 <iunlockput>
  iput(ip);
    80005338:	8526                	mv	a0,s1
    8000533a:	ffffe097          	auipc	ra,0xffffe
    8000533e:	1bc080e7          	jalr	444(ra) # 800034f6 <iput>
  end_op(ROOTDEV);
    80005342:	4501                	li	a0,0
    80005344:	fffff097          	auipc	ra,0xfffff
    80005348:	bf6080e7          	jalr	-1034(ra) # 80003f3a <end_op>
  return 0;
    8000534c:	4781                	li	a5,0
    8000534e:	a09d                	j	800053b4 <sys_link+0x146>
    end_op(ROOTDEV);
    80005350:	4501                	li	a0,0
    80005352:	fffff097          	auipc	ra,0xfffff
    80005356:	be8080e7          	jalr	-1048(ra) # 80003f3a <end_op>
    return -1;
    8000535a:	57fd                	li	a5,-1
    8000535c:	a8a1                	j	800053b4 <sys_link+0x146>
    iunlockput(ip);
    8000535e:	8526                	mv	a0,s1
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	2c6080e7          	jalr	710(ra) # 80003626 <iunlockput>
    end_op(ROOTDEV);
    80005368:	4501                	li	a0,0
    8000536a:	fffff097          	auipc	ra,0xfffff
    8000536e:	bd0080e7          	jalr	-1072(ra) # 80003f3a <end_op>
    return -1;
    80005372:	57fd                	li	a5,-1
    80005374:	a081                	j	800053b4 <sys_link+0x146>
    iunlockput(dp);
    80005376:	854a                	mv	a0,s2
    80005378:	ffffe097          	auipc	ra,0xffffe
    8000537c:	2ae080e7          	jalr	686(ra) # 80003626 <iunlockput>
  ilock(ip);
    80005380:	8526                	mv	a0,s1
    80005382:	ffffe097          	auipc	ra,0xffffe
    80005386:	066080e7          	jalr	102(ra) # 800033e8 <ilock>
  ip->nlink--;
    8000538a:	04a4d783          	lhu	a5,74(s1)
    8000538e:	37fd                	addiw	a5,a5,-1
    80005390:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005394:	8526                	mv	a0,s1
    80005396:	ffffe097          	auipc	ra,0xffffe
    8000539a:	f88080e7          	jalr	-120(ra) # 8000331e <iupdate>
  iunlockput(ip);
    8000539e:	8526                	mv	a0,s1
    800053a0:	ffffe097          	auipc	ra,0xffffe
    800053a4:	286080e7          	jalr	646(ra) # 80003626 <iunlockput>
  end_op(ROOTDEV);
    800053a8:	4501                	li	a0,0
    800053aa:	fffff097          	auipc	ra,0xfffff
    800053ae:	b90080e7          	jalr	-1136(ra) # 80003f3a <end_op>
  return -1;
    800053b2:	57fd                	li	a5,-1
}
    800053b4:	853e                	mv	a0,a5
    800053b6:	70b2                	ld	ra,296(sp)
    800053b8:	7412                	ld	s0,288(sp)
    800053ba:	64f2                	ld	s1,280(sp)
    800053bc:	6952                	ld	s2,272(sp)
    800053be:	6155                	addi	sp,sp,304
    800053c0:	8082                	ret

00000000800053c2 <sys_unlink>:
{
    800053c2:	7151                	addi	sp,sp,-240
    800053c4:	f586                	sd	ra,232(sp)
    800053c6:	f1a2                	sd	s0,224(sp)
    800053c8:	eda6                	sd	s1,216(sp)
    800053ca:	e9ca                	sd	s2,208(sp)
    800053cc:	e5ce                	sd	s3,200(sp)
    800053ce:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800053d0:	08000613          	li	a2,128
    800053d4:	f3040593          	addi	a1,s0,-208
    800053d8:	4501                	li	a0,0
    800053da:	ffffd097          	auipc	ra,0xffffd
    800053de:	510080e7          	jalr	1296(ra) # 800028ea <argstr>
    800053e2:	18054463          	bltz	a0,8000556a <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    800053e6:	4501                	li	a0,0
    800053e8:	fffff097          	auipc	ra,0xfffff
    800053ec:	aa8080e7          	jalr	-1368(ra) # 80003e90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800053f0:	fb040593          	addi	a1,s0,-80
    800053f4:	f3040513          	addi	a0,s0,-208
    800053f8:	ffffe097          	auipc	ra,0xffffe
    800053fc:	79a080e7          	jalr	1946(ra) # 80003b92 <nameiparent>
    80005400:	84aa                	mv	s1,a0
    80005402:	cd61                	beqz	a0,800054da <sys_unlink+0x118>
  ilock(dp);
    80005404:	ffffe097          	auipc	ra,0xffffe
    80005408:	fe4080e7          	jalr	-28(ra) # 800033e8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000540c:	00002597          	auipc	a1,0x2
    80005410:	35458593          	addi	a1,a1,852 # 80007760 <userret+0x6d0>
    80005414:	fb040513          	addi	a0,s0,-80
    80005418:	ffffe097          	auipc	ra,0xffffe
    8000541c:	470080e7          	jalr	1136(ra) # 80003888 <namecmp>
    80005420:	14050c63          	beqz	a0,80005578 <sys_unlink+0x1b6>
    80005424:	00002597          	auipc	a1,0x2
    80005428:	34458593          	addi	a1,a1,836 # 80007768 <userret+0x6d8>
    8000542c:	fb040513          	addi	a0,s0,-80
    80005430:	ffffe097          	auipc	ra,0xffffe
    80005434:	458080e7          	jalr	1112(ra) # 80003888 <namecmp>
    80005438:	14050063          	beqz	a0,80005578 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000543c:	f2c40613          	addi	a2,s0,-212
    80005440:	fb040593          	addi	a1,s0,-80
    80005444:	8526                	mv	a0,s1
    80005446:	ffffe097          	auipc	ra,0xffffe
    8000544a:	45c080e7          	jalr	1116(ra) # 800038a2 <dirlookup>
    8000544e:	892a                	mv	s2,a0
    80005450:	12050463          	beqz	a0,80005578 <sys_unlink+0x1b6>
  ilock(ip);
    80005454:	ffffe097          	auipc	ra,0xffffe
    80005458:	f94080e7          	jalr	-108(ra) # 800033e8 <ilock>
  if(ip->nlink < 1)
    8000545c:	04a91783          	lh	a5,74(s2)
    80005460:	08f05463          	blez	a5,800054e8 <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005464:	04491703          	lh	a4,68(s2)
    80005468:	4785                	li	a5,1
    8000546a:	08f70763          	beq	a4,a5,800054f8 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    8000546e:	4641                	li	a2,16
    80005470:	4581                	li	a1,0
    80005472:	fc040513          	addi	a0,s0,-64
    80005476:	ffffb097          	auipc	ra,0xffffb
    8000547a:	720080e7          	jalr	1824(ra) # 80000b96 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000547e:	4741                	li	a4,16
    80005480:	f2c42683          	lw	a3,-212(s0)
    80005484:	fc040613          	addi	a2,s0,-64
    80005488:	4581                	li	a1,0
    8000548a:	8526                	mv	a0,s1
    8000548c:	ffffe097          	auipc	ra,0xffffe
    80005490:	2e0080e7          	jalr	736(ra) # 8000376c <writei>
    80005494:	47c1                	li	a5,16
    80005496:	0af51763          	bne	a0,a5,80005544 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    8000549a:	04491703          	lh	a4,68(s2)
    8000549e:	4785                	li	a5,1
    800054a0:	0af70a63          	beq	a4,a5,80005554 <sys_unlink+0x192>
  iunlockput(dp);
    800054a4:	8526                	mv	a0,s1
    800054a6:	ffffe097          	auipc	ra,0xffffe
    800054aa:	180080e7          	jalr	384(ra) # 80003626 <iunlockput>
  ip->nlink--;
    800054ae:	04a95783          	lhu	a5,74(s2)
    800054b2:	37fd                	addiw	a5,a5,-1
    800054b4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800054b8:	854a                	mv	a0,s2
    800054ba:	ffffe097          	auipc	ra,0xffffe
    800054be:	e64080e7          	jalr	-412(ra) # 8000331e <iupdate>
  iunlockput(ip);
    800054c2:	854a                	mv	a0,s2
    800054c4:	ffffe097          	auipc	ra,0xffffe
    800054c8:	162080e7          	jalr	354(ra) # 80003626 <iunlockput>
  end_op(ROOTDEV);
    800054cc:	4501                	li	a0,0
    800054ce:	fffff097          	auipc	ra,0xfffff
    800054d2:	a6c080e7          	jalr	-1428(ra) # 80003f3a <end_op>
  return 0;
    800054d6:	4501                	li	a0,0
    800054d8:	a85d                	j	8000558e <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    800054da:	4501                	li	a0,0
    800054dc:	fffff097          	auipc	ra,0xfffff
    800054e0:	a5e080e7          	jalr	-1442(ra) # 80003f3a <end_op>
    return -1;
    800054e4:	557d                	li	a0,-1
    800054e6:	a065                	j	8000558e <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    800054e8:	00002517          	auipc	a0,0x2
    800054ec:	2a850513          	addi	a0,a0,680 # 80007790 <userret+0x700>
    800054f0:	ffffb097          	auipc	ra,0xffffb
    800054f4:	05e080e7          	jalr	94(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054f8:	04c92703          	lw	a4,76(s2)
    800054fc:	02000793          	li	a5,32
    80005500:	f6e7f7e3          	bgeu	a5,a4,8000546e <sys_unlink+0xac>
    80005504:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005508:	4741                	li	a4,16
    8000550a:	86ce                	mv	a3,s3
    8000550c:	f1840613          	addi	a2,s0,-232
    80005510:	4581                	li	a1,0
    80005512:	854a                	mv	a0,s2
    80005514:	ffffe097          	auipc	ra,0xffffe
    80005518:	164080e7          	jalr	356(ra) # 80003678 <readi>
    8000551c:	47c1                	li	a5,16
    8000551e:	00f51b63          	bne	a0,a5,80005534 <sys_unlink+0x172>
    if(de.inum != 0)
    80005522:	f1845783          	lhu	a5,-232(s0)
    80005526:	e7a1                	bnez	a5,8000556e <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005528:	29c1                	addiw	s3,s3,16
    8000552a:	04c92783          	lw	a5,76(s2)
    8000552e:	fcf9ede3          	bltu	s3,a5,80005508 <sys_unlink+0x146>
    80005532:	bf35                	j	8000546e <sys_unlink+0xac>
      panic("isdirempty: readi");
    80005534:	00002517          	auipc	a0,0x2
    80005538:	27450513          	addi	a0,a0,628 # 800077a8 <userret+0x718>
    8000553c:	ffffb097          	auipc	ra,0xffffb
    80005540:	012080e7          	jalr	18(ra) # 8000054e <panic>
    panic("unlink: writei");
    80005544:	00002517          	auipc	a0,0x2
    80005548:	27c50513          	addi	a0,a0,636 # 800077c0 <userret+0x730>
    8000554c:	ffffb097          	auipc	ra,0xffffb
    80005550:	002080e7          	jalr	2(ra) # 8000054e <panic>
    dp->nlink--;
    80005554:	04a4d783          	lhu	a5,74(s1)
    80005558:	37fd                	addiw	a5,a5,-1
    8000555a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000555e:	8526                	mv	a0,s1
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	dbe080e7          	jalr	-578(ra) # 8000331e <iupdate>
    80005568:	bf35                	j	800054a4 <sys_unlink+0xe2>
    return -1;
    8000556a:	557d                	li	a0,-1
    8000556c:	a00d                	j	8000558e <sys_unlink+0x1cc>
    iunlockput(ip);
    8000556e:	854a                	mv	a0,s2
    80005570:	ffffe097          	auipc	ra,0xffffe
    80005574:	0b6080e7          	jalr	182(ra) # 80003626 <iunlockput>
  iunlockput(dp);
    80005578:	8526                	mv	a0,s1
    8000557a:	ffffe097          	auipc	ra,0xffffe
    8000557e:	0ac080e7          	jalr	172(ra) # 80003626 <iunlockput>
  end_op(ROOTDEV);
    80005582:	4501                	li	a0,0
    80005584:	fffff097          	auipc	ra,0xfffff
    80005588:	9b6080e7          	jalr	-1610(ra) # 80003f3a <end_op>
  return -1;
    8000558c:	557d                	li	a0,-1
}
    8000558e:	70ae                	ld	ra,232(sp)
    80005590:	740e                	ld	s0,224(sp)
    80005592:	64ee                	ld	s1,216(sp)
    80005594:	694e                	ld	s2,208(sp)
    80005596:	69ae                	ld	s3,200(sp)
    80005598:	616d                	addi	sp,sp,240
    8000559a:	8082                	ret

000000008000559c <sys_open>:

uint64
sys_open(void)
{
    8000559c:	7131                	addi	sp,sp,-192
    8000559e:	fd06                	sd	ra,184(sp)
    800055a0:	f922                	sd	s0,176(sp)
    800055a2:	f526                	sd	s1,168(sp)
    800055a4:	f14a                	sd	s2,160(sp)
    800055a6:	ed4e                	sd	s3,152(sp)
    800055a8:	0180                	addi	s0,sp,192
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, path, MAXPATH) < 0 || argint(1, &omode) < 0)
    800055aa:	08000613          	li	a2,128
    800055ae:	f5040593          	addi	a1,s0,-176
    800055b2:	4501                	li	a0,0
    800055b4:	ffffd097          	auipc	ra,0xffffd
    800055b8:	336080e7          	jalr	822(ra) # 800028ea <argstr>
    return -1;
    800055bc:	54fd                	li	s1,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &omode) < 0)
    800055be:	0a054963          	bltz	a0,80005670 <sys_open+0xd4>
    800055c2:	f4c40593          	addi	a1,s0,-180
    800055c6:	4505                	li	a0,1
    800055c8:	ffffd097          	auipc	ra,0xffffd
    800055cc:	2de080e7          	jalr	734(ra) # 800028a6 <argint>
    800055d0:	0a054063          	bltz	a0,80005670 <sys_open+0xd4>

  begin_op(ROOTDEV);
    800055d4:	4501                	li	a0,0
    800055d6:	fffff097          	auipc	ra,0xfffff
    800055da:	8ba080e7          	jalr	-1862(ra) # 80003e90 <begin_op>

  if(omode & O_CREATE){
    800055de:	f4c42783          	lw	a5,-180(s0)
    800055e2:	2007f793          	andi	a5,a5,512
    800055e6:	c3dd                	beqz	a5,8000568c <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    800055e8:	4681                	li	a3,0
    800055ea:	4601                	li	a2,0
    800055ec:	4589                	li	a1,2
    800055ee:	f5040513          	addi	a0,s0,-176
    800055f2:	00000097          	auipc	ra,0x0
    800055f6:	95e080e7          	jalr	-1698(ra) # 80004f50 <create>
    800055fa:	892a                	mv	s2,a0
    if(ip == 0){
    800055fc:	c151                	beqz	a0,80005680 <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800055fe:	04491703          	lh	a4,68(s2)
    80005602:	478d                	li	a5,3
    80005604:	00f71763          	bne	a4,a5,80005612 <sys_open+0x76>
    80005608:	04695703          	lhu	a4,70(s2)
    8000560c:	47a5                	li	a5,9
    8000560e:	0ce7e663          	bltu	a5,a4,800056da <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005612:	fffff097          	auipc	ra,0xfffff
    80005616:	dea080e7          	jalr	-534(ra) # 800043fc <filealloc>
    8000561a:	89aa                	mv	s3,a0
    8000561c:	c57d                	beqz	a0,8000570a <sys_open+0x16e>
    8000561e:	00000097          	auipc	ra,0x0
    80005622:	8f0080e7          	jalr	-1808(ra) # 80004f0e <fdalloc>
    80005626:	84aa                	mv	s1,a0
    80005628:	0c054c63          	bltz	a0,80005700 <sys_open+0x164>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000562c:	04491703          	lh	a4,68(s2)
    80005630:	478d                	li	a5,3
    80005632:	0cf70063          	beq	a4,a5,800056f2 <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005636:	4789                	li	a5,2
    80005638:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000563c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005640:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005644:	f4c42783          	lw	a5,-180(s0)
    80005648:	0017c713          	xori	a4,a5,1
    8000564c:	8b05                	andi	a4,a4,1
    8000564e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005652:	8b8d                	andi	a5,a5,3
    80005654:	00f037b3          	snez	a5,a5
    80005658:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    8000565c:	854a                	mv	a0,s2
    8000565e:	ffffe097          	auipc	ra,0xffffe
    80005662:	e4c080e7          	jalr	-436(ra) # 800034aa <iunlock>
  end_op(ROOTDEV);
    80005666:	4501                	li	a0,0
    80005668:	fffff097          	auipc	ra,0xfffff
    8000566c:	8d2080e7          	jalr	-1838(ra) # 80003f3a <end_op>

  return fd;
}
    80005670:	8526                	mv	a0,s1
    80005672:	70ea                	ld	ra,184(sp)
    80005674:	744a                	ld	s0,176(sp)
    80005676:	74aa                	ld	s1,168(sp)
    80005678:	790a                	ld	s2,160(sp)
    8000567a:	69ea                	ld	s3,152(sp)
    8000567c:	6129                	addi	sp,sp,192
    8000567e:	8082                	ret
      end_op(ROOTDEV);
    80005680:	4501                	li	a0,0
    80005682:	fffff097          	auipc	ra,0xfffff
    80005686:	8b8080e7          	jalr	-1864(ra) # 80003f3a <end_op>
      return -1;
    8000568a:	b7dd                	j	80005670 <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    8000568c:	f5040513          	addi	a0,s0,-176
    80005690:	ffffe097          	auipc	ra,0xffffe
    80005694:	4e4080e7          	jalr	1252(ra) # 80003b74 <namei>
    80005698:	892a                	mv	s2,a0
    8000569a:	c90d                	beqz	a0,800056cc <sys_open+0x130>
    ilock(ip);
    8000569c:	ffffe097          	auipc	ra,0xffffe
    800056a0:	d4c080e7          	jalr	-692(ra) # 800033e8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800056a4:	04491703          	lh	a4,68(s2)
    800056a8:	4785                	li	a5,1
    800056aa:	f4f71ae3          	bne	a4,a5,800055fe <sys_open+0x62>
    800056ae:	f4c42783          	lw	a5,-180(s0)
    800056b2:	d3a5                	beqz	a5,80005612 <sys_open+0x76>
      iunlockput(ip);
    800056b4:	854a                	mv	a0,s2
    800056b6:	ffffe097          	auipc	ra,0xffffe
    800056ba:	f70080e7          	jalr	-144(ra) # 80003626 <iunlockput>
      end_op(ROOTDEV);
    800056be:	4501                	li	a0,0
    800056c0:	fffff097          	auipc	ra,0xfffff
    800056c4:	87a080e7          	jalr	-1926(ra) # 80003f3a <end_op>
      return -1;
    800056c8:	54fd                	li	s1,-1
    800056ca:	b75d                	j	80005670 <sys_open+0xd4>
      end_op(ROOTDEV);
    800056cc:	4501                	li	a0,0
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	86c080e7          	jalr	-1940(ra) # 80003f3a <end_op>
      return -1;
    800056d6:	54fd                	li	s1,-1
    800056d8:	bf61                	j	80005670 <sys_open+0xd4>
    iunlockput(ip);
    800056da:	854a                	mv	a0,s2
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	f4a080e7          	jalr	-182(ra) # 80003626 <iunlockput>
    end_op(ROOTDEV);
    800056e4:	4501                	li	a0,0
    800056e6:	fffff097          	auipc	ra,0xfffff
    800056ea:	854080e7          	jalr	-1964(ra) # 80003f3a <end_op>
    return -1;
    800056ee:	54fd                	li	s1,-1
    800056f0:	b741                	j	80005670 <sys_open+0xd4>
    f->type = FD_DEVICE;
    800056f2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800056f6:	04691783          	lh	a5,70(s2)
    800056fa:	02f99223          	sh	a5,36(s3)
    800056fe:	b789                	j	80005640 <sys_open+0xa4>
      fileclose(f);
    80005700:	854e                	mv	a0,s3
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	db6080e7          	jalr	-586(ra) # 800044b8 <fileclose>
    iunlockput(ip);
    8000570a:	854a                	mv	a0,s2
    8000570c:	ffffe097          	auipc	ra,0xffffe
    80005710:	f1a080e7          	jalr	-230(ra) # 80003626 <iunlockput>
    end_op(ROOTDEV);
    80005714:	4501                	li	a0,0
    80005716:	fffff097          	auipc	ra,0xfffff
    8000571a:	824080e7          	jalr	-2012(ra) # 80003f3a <end_op>
    return -1;
    8000571e:	54fd                	li	s1,-1
    80005720:	bf81                	j	80005670 <sys_open+0xd4>

0000000080005722 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005722:	7175                	addi	sp,sp,-144
    80005724:	e506                	sd	ra,136(sp)
    80005726:	e122                	sd	s0,128(sp)
    80005728:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    8000572a:	4501                	li	a0,0
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	764080e7          	jalr	1892(ra) # 80003e90 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005734:	08000613          	li	a2,128
    80005738:	f7040593          	addi	a1,s0,-144
    8000573c:	4501                	li	a0,0
    8000573e:	ffffd097          	auipc	ra,0xffffd
    80005742:	1ac080e7          	jalr	428(ra) # 800028ea <argstr>
    80005746:	02054a63          	bltz	a0,8000577a <sys_mkdir+0x58>
    8000574a:	4681                	li	a3,0
    8000574c:	4601                	li	a2,0
    8000574e:	4585                	li	a1,1
    80005750:	f7040513          	addi	a0,s0,-144
    80005754:	fffff097          	auipc	ra,0xfffff
    80005758:	7fc080e7          	jalr	2044(ra) # 80004f50 <create>
    8000575c:	cd19                	beqz	a0,8000577a <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    8000575e:	ffffe097          	auipc	ra,0xffffe
    80005762:	ec8080e7          	jalr	-312(ra) # 80003626 <iunlockput>
  end_op(ROOTDEV);
    80005766:	4501                	li	a0,0
    80005768:	ffffe097          	auipc	ra,0xffffe
    8000576c:	7d2080e7          	jalr	2002(ra) # 80003f3a <end_op>
  return 0;
    80005770:	4501                	li	a0,0
}
    80005772:	60aa                	ld	ra,136(sp)
    80005774:	640a                	ld	s0,128(sp)
    80005776:	6149                	addi	sp,sp,144
    80005778:	8082                	ret
    end_op(ROOTDEV);
    8000577a:	4501                	li	a0,0
    8000577c:	ffffe097          	auipc	ra,0xffffe
    80005780:	7be080e7          	jalr	1982(ra) # 80003f3a <end_op>
    return -1;
    80005784:	557d                	li	a0,-1
    80005786:	b7f5                	j	80005772 <sys_mkdir+0x50>

0000000080005788 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005788:	7135                	addi	sp,sp,-160
    8000578a:	ed06                	sd	ra,152(sp)
    8000578c:	e922                	sd	s0,144(sp)
    8000578e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    80005790:	4501                	li	a0,0
    80005792:	ffffe097          	auipc	ra,0xffffe
    80005796:	6fe080e7          	jalr	1790(ra) # 80003e90 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000579a:	08000613          	li	a2,128
    8000579e:	f7040593          	addi	a1,s0,-144
    800057a2:	4501                	li	a0,0
    800057a4:	ffffd097          	auipc	ra,0xffffd
    800057a8:	146080e7          	jalr	326(ra) # 800028ea <argstr>
    800057ac:	04054b63          	bltz	a0,80005802 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    800057b0:	f6c40593          	addi	a1,s0,-148
    800057b4:	4505                	li	a0,1
    800057b6:	ffffd097          	auipc	ra,0xffffd
    800057ba:	0f0080e7          	jalr	240(ra) # 800028a6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057be:	04054263          	bltz	a0,80005802 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    800057c2:	f6840593          	addi	a1,s0,-152
    800057c6:	4509                	li	a0,2
    800057c8:	ffffd097          	auipc	ra,0xffffd
    800057cc:	0de080e7          	jalr	222(ra) # 800028a6 <argint>
     argint(1, &major) < 0 ||
    800057d0:	02054963          	bltz	a0,80005802 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800057d4:	f6841683          	lh	a3,-152(s0)
    800057d8:	f6c41603          	lh	a2,-148(s0)
    800057dc:	458d                	li	a1,3
    800057de:	f7040513          	addi	a0,s0,-144
    800057e2:	fffff097          	auipc	ra,0xfffff
    800057e6:	76e080e7          	jalr	1902(ra) # 80004f50 <create>
     argint(2, &minor) < 0 ||
    800057ea:	cd01                	beqz	a0,80005802 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	e3a080e7          	jalr	-454(ra) # 80003626 <iunlockput>
  end_op(ROOTDEV);
    800057f4:	4501                	li	a0,0
    800057f6:	ffffe097          	auipc	ra,0xffffe
    800057fa:	744080e7          	jalr	1860(ra) # 80003f3a <end_op>
  return 0;
    800057fe:	4501                	li	a0,0
    80005800:	a039                	j	8000580e <sys_mknod+0x86>
    end_op(ROOTDEV);
    80005802:	4501                	li	a0,0
    80005804:	ffffe097          	auipc	ra,0xffffe
    80005808:	736080e7          	jalr	1846(ra) # 80003f3a <end_op>
    return -1;
    8000580c:	557d                	li	a0,-1
}
    8000580e:	60ea                	ld	ra,152(sp)
    80005810:	644a                	ld	s0,144(sp)
    80005812:	610d                	addi	sp,sp,160
    80005814:	8082                	ret

0000000080005816 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005816:	7135                	addi	sp,sp,-160
    80005818:	ed06                	sd	ra,152(sp)
    8000581a:	e922                	sd	s0,144(sp)
    8000581c:	e526                	sd	s1,136(sp)
    8000581e:	e14a                	sd	s2,128(sp)
    80005820:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	012080e7          	jalr	18(ra) # 80001834 <myproc>
    8000582a:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    8000582c:	4501                	li	a0,0
    8000582e:	ffffe097          	auipc	ra,0xffffe
    80005832:	662080e7          	jalr	1634(ra) # 80003e90 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005836:	08000613          	li	a2,128
    8000583a:	f6040593          	addi	a1,s0,-160
    8000583e:	4501                	li	a0,0
    80005840:	ffffd097          	auipc	ra,0xffffd
    80005844:	0aa080e7          	jalr	170(ra) # 800028ea <argstr>
    80005848:	04054c63          	bltz	a0,800058a0 <sys_chdir+0x8a>
    8000584c:	f6040513          	addi	a0,s0,-160
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	324080e7          	jalr	804(ra) # 80003b74 <namei>
    80005858:	84aa                	mv	s1,a0
    8000585a:	c139                	beqz	a0,800058a0 <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    8000585c:	ffffe097          	auipc	ra,0xffffe
    80005860:	b8c080e7          	jalr	-1140(ra) # 800033e8 <ilock>
  if(ip->type != T_DIR){
    80005864:	04449703          	lh	a4,68(s1)
    80005868:	4785                	li	a5,1
    8000586a:	04f71263          	bne	a4,a5,800058ae <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    8000586e:	8526                	mv	a0,s1
    80005870:	ffffe097          	auipc	ra,0xffffe
    80005874:	c3a080e7          	jalr	-966(ra) # 800034aa <iunlock>
  iput(p->cwd);
    80005878:	14893503          	ld	a0,328(s2)
    8000587c:	ffffe097          	auipc	ra,0xffffe
    80005880:	c7a080e7          	jalr	-902(ra) # 800034f6 <iput>
  end_op(ROOTDEV);
    80005884:	4501                	li	a0,0
    80005886:	ffffe097          	auipc	ra,0xffffe
    8000588a:	6b4080e7          	jalr	1716(ra) # 80003f3a <end_op>
  p->cwd = ip;
    8000588e:	14993423          	sd	s1,328(s2)
  return 0;
    80005892:	4501                	li	a0,0
}
    80005894:	60ea                	ld	ra,152(sp)
    80005896:	644a                	ld	s0,144(sp)
    80005898:	64aa                	ld	s1,136(sp)
    8000589a:	690a                	ld	s2,128(sp)
    8000589c:	610d                	addi	sp,sp,160
    8000589e:	8082                	ret
    end_op(ROOTDEV);
    800058a0:	4501                	li	a0,0
    800058a2:	ffffe097          	auipc	ra,0xffffe
    800058a6:	698080e7          	jalr	1688(ra) # 80003f3a <end_op>
    return -1;
    800058aa:	557d                	li	a0,-1
    800058ac:	b7e5                	j	80005894 <sys_chdir+0x7e>
    iunlockput(ip);
    800058ae:	8526                	mv	a0,s1
    800058b0:	ffffe097          	auipc	ra,0xffffe
    800058b4:	d76080e7          	jalr	-650(ra) # 80003626 <iunlockput>
    end_op(ROOTDEV);
    800058b8:	4501                	li	a0,0
    800058ba:	ffffe097          	auipc	ra,0xffffe
    800058be:	680080e7          	jalr	1664(ra) # 80003f3a <end_op>
    return -1;
    800058c2:	557d                	li	a0,-1
    800058c4:	bfc1                	j	80005894 <sys_chdir+0x7e>

00000000800058c6 <sys_exec>:

uint64
sys_exec(void)
{
    800058c6:	7145                	addi	sp,sp,-464
    800058c8:	e786                	sd	ra,456(sp)
    800058ca:	e3a2                	sd	s0,448(sp)
    800058cc:	ff26                	sd	s1,440(sp)
    800058ce:	fb4a                	sd	s2,432(sp)
    800058d0:	f74e                	sd	s3,424(sp)
    800058d2:	f352                	sd	s4,416(sp)
    800058d4:	ef56                	sd	s5,408(sp)
    800058d6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058d8:	08000613          	li	a2,128
    800058dc:	f4040593          	addi	a1,s0,-192
    800058e0:	4501                	li	a0,0
    800058e2:	ffffd097          	auipc	ra,0xffffd
    800058e6:	008080e7          	jalr	8(ra) # 800028ea <argstr>
    800058ea:	0c054863          	bltz	a0,800059ba <sys_exec+0xf4>
    800058ee:	e3840593          	addi	a1,s0,-456
    800058f2:	4505                	li	a0,1
    800058f4:	ffffd097          	auipc	ra,0xffffd
    800058f8:	fd4080e7          	jalr	-44(ra) # 800028c8 <argaddr>
    800058fc:	0c054963          	bltz	a0,800059ce <sys_exec+0x108>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005900:	10000613          	li	a2,256
    80005904:	4581                	li	a1,0
    80005906:	e4040513          	addi	a0,s0,-448
    8000590a:	ffffb097          	auipc	ra,0xffffb
    8000590e:	28c080e7          	jalr	652(ra) # 80000b96 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005912:	e4040993          	addi	s3,s0,-448
  memset(argv, 0, sizeof(argv));
    80005916:	894e                	mv	s2,s3
    80005918:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    8000591a:	02000a13          	li	s4,32
    8000591e:	00048a9b          	sext.w	s5,s1
      return -1;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005922:	00349513          	slli	a0,s1,0x3
    80005926:	e3040593          	addi	a1,s0,-464
    8000592a:	e3843783          	ld	a5,-456(s0)
    8000592e:	953e                	add	a0,a0,a5
    80005930:	ffffd097          	auipc	ra,0xffffd
    80005934:	edc080e7          	jalr	-292(ra) # 8000280c <fetchaddr>
    80005938:	08054d63          	bltz	a0,800059d2 <sys_exec+0x10c>
      return -1;
    }
    if(uarg == 0){
    8000593c:	e3043783          	ld	a5,-464(s0)
    80005940:	cb85                	beqz	a5,80005970 <sys_exec+0xaa>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005942:	ffffb097          	auipc	ra,0xffffb
    80005946:	01e080e7          	jalr	30(ra) # 80000960 <kalloc>
    8000594a:	85aa                	mv	a1,a0
    8000594c:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    80005950:	cd29                	beqz	a0,800059aa <sys_exec+0xe4>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005952:	6605                	lui	a2,0x1
    80005954:	e3043503          	ld	a0,-464(s0)
    80005958:	ffffd097          	auipc	ra,0xffffd
    8000595c:	f06080e7          	jalr	-250(ra) # 8000285e <fetchstr>
    80005960:	06054b63          	bltz	a0,800059d6 <sys_exec+0x110>
    if(i >= NELEM(argv)){
    80005964:	0485                	addi	s1,s1,1
    80005966:	0921                	addi	s2,s2,8
    80005968:	fb449be3          	bne	s1,s4,8000591e <sys_exec+0x58>
      return -1;
    8000596c:	557d                	li	a0,-1
    8000596e:	a0b9                	j	800059bc <sys_exec+0xf6>
      argv[i] = 0;
    80005970:	0a8e                	slli	s5,s5,0x3
    80005972:	fc040793          	addi	a5,s0,-64
    80005976:	9abe                	add	s5,s5,a5
    80005978:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <ticks+0xffffffff7ffd5e58>
      return -1;
    }
  }

  int ret = exec(path, argv);
    8000597c:	e4040593          	addi	a1,s0,-448
    80005980:	f4040513          	addi	a0,s0,-192
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	1b8080e7          	jalr	440(ra) # 80004b3c <exec>
    8000598c:	84aa                	mv	s1,a0

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000598e:	10098913          	addi	s2,s3,256
    80005992:	0009b503          	ld	a0,0(s3)
    80005996:	c901                	beqz	a0,800059a6 <sys_exec+0xe0>
    kfree(argv[i]);
    80005998:	ffffb097          	auipc	ra,0xffffb
    8000599c:	ecc080e7          	jalr	-308(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059a0:	09a1                	addi	s3,s3,8
    800059a2:	ff2998e3          	bne	s3,s2,80005992 <sys_exec+0xcc>

  return ret;
    800059a6:	8526                	mv	a0,s1
    800059a8:	a811                	j	800059bc <sys_exec+0xf6>
      panic("sys_exec kalloc");
    800059aa:	00002517          	auipc	a0,0x2
    800059ae:	e2650513          	addi	a0,a0,-474 # 800077d0 <userret+0x740>
    800059b2:	ffffb097          	auipc	ra,0xffffb
    800059b6:	b9c080e7          	jalr	-1124(ra) # 8000054e <panic>
    return -1;
    800059ba:	557d                	li	a0,-1
}
    800059bc:	60be                	ld	ra,456(sp)
    800059be:	641e                	ld	s0,448(sp)
    800059c0:	74fa                	ld	s1,440(sp)
    800059c2:	795a                	ld	s2,432(sp)
    800059c4:	79ba                	ld	s3,424(sp)
    800059c6:	7a1a                	ld	s4,416(sp)
    800059c8:	6afa                	ld	s5,408(sp)
    800059ca:	6179                	addi	sp,sp,464
    800059cc:	8082                	ret
    return -1;
    800059ce:	557d                	li	a0,-1
    800059d0:	b7f5                	j	800059bc <sys_exec+0xf6>
      return -1;
    800059d2:	557d                	li	a0,-1
    800059d4:	b7e5                	j	800059bc <sys_exec+0xf6>
      return -1;
    800059d6:	557d                	li	a0,-1
    800059d8:	b7d5                	j	800059bc <sys_exec+0xf6>

00000000800059da <sys_pipe>:

uint64
sys_pipe(void)
{
    800059da:	7139                	addi	sp,sp,-64
    800059dc:	fc06                	sd	ra,56(sp)
    800059de:	f822                	sd	s0,48(sp)
    800059e0:	f426                	sd	s1,40(sp)
    800059e2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800059e4:	ffffc097          	auipc	ra,0xffffc
    800059e8:	e50080e7          	jalr	-432(ra) # 80001834 <myproc>
    800059ec:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800059ee:	fd840593          	addi	a1,s0,-40
    800059f2:	4501                	li	a0,0
    800059f4:	ffffd097          	auipc	ra,0xffffd
    800059f8:	ed4080e7          	jalr	-300(ra) # 800028c8 <argaddr>
    return -1;
    800059fc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800059fe:	0e054063          	bltz	a0,80005ade <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a02:	fc840593          	addi	a1,s0,-56
    80005a06:	fd040513          	addi	a0,s0,-48
    80005a0a:	fffff097          	auipc	ra,0xfffff
    80005a0e:	de2080e7          	jalr	-542(ra) # 800047ec <pipealloc>
    return -1;
    80005a12:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a14:	0c054563          	bltz	a0,80005ade <sys_pipe+0x104>
  fd0 = -1;
    80005a18:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a1c:	fd043503          	ld	a0,-48(s0)
    80005a20:	fffff097          	auipc	ra,0xfffff
    80005a24:	4ee080e7          	jalr	1262(ra) # 80004f0e <fdalloc>
    80005a28:	fca42223          	sw	a0,-60(s0)
    80005a2c:	08054c63          	bltz	a0,80005ac4 <sys_pipe+0xea>
    80005a30:	fc843503          	ld	a0,-56(s0)
    80005a34:	fffff097          	auipc	ra,0xfffff
    80005a38:	4da080e7          	jalr	1242(ra) # 80004f0e <fdalloc>
    80005a3c:	fca42023          	sw	a0,-64(s0)
    80005a40:	06054863          	bltz	a0,80005ab0 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a44:	4691                	li	a3,4
    80005a46:	fc440613          	addi	a2,s0,-60
    80005a4a:	fd843583          	ld	a1,-40(s0)
    80005a4e:	64a8                	ld	a0,72(s1)
    80005a50:	ffffc097          	auipc	ra,0xffffc
    80005a54:	b0a080e7          	jalr	-1270(ra) # 8000155a <copyout>
    80005a58:	02054063          	bltz	a0,80005a78 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a5c:	4691                	li	a3,4
    80005a5e:	fc040613          	addi	a2,s0,-64
    80005a62:	fd843583          	ld	a1,-40(s0)
    80005a66:	0591                	addi	a1,a1,4
    80005a68:	64a8                	ld	a0,72(s1)
    80005a6a:	ffffc097          	auipc	ra,0xffffc
    80005a6e:	af0080e7          	jalr	-1296(ra) # 8000155a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a72:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a74:	06055563          	bgez	a0,80005ade <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a78:	fc442783          	lw	a5,-60(s0)
    80005a7c:	07e1                	addi	a5,a5,24
    80005a7e:	078e                	slli	a5,a5,0x3
    80005a80:	97a6                	add	a5,a5,s1
    80005a82:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005a86:	fc042503          	lw	a0,-64(s0)
    80005a8a:	0561                	addi	a0,a0,24
    80005a8c:	050e                	slli	a0,a0,0x3
    80005a8e:	9526                	add	a0,a0,s1
    80005a90:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005a94:	fd043503          	ld	a0,-48(s0)
    80005a98:	fffff097          	auipc	ra,0xfffff
    80005a9c:	a20080e7          	jalr	-1504(ra) # 800044b8 <fileclose>
    fileclose(wf);
    80005aa0:	fc843503          	ld	a0,-56(s0)
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	a14080e7          	jalr	-1516(ra) # 800044b8 <fileclose>
    return -1;
    80005aac:	57fd                	li	a5,-1
    80005aae:	a805                	j	80005ade <sys_pipe+0x104>
    if(fd0 >= 0)
    80005ab0:	fc442783          	lw	a5,-60(s0)
    80005ab4:	0007c863          	bltz	a5,80005ac4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005ab8:	01878513          	addi	a0,a5,24
    80005abc:	050e                	slli	a0,a0,0x3
    80005abe:	9526                	add	a0,a0,s1
    80005ac0:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005ac4:	fd043503          	ld	a0,-48(s0)
    80005ac8:	fffff097          	auipc	ra,0xfffff
    80005acc:	9f0080e7          	jalr	-1552(ra) # 800044b8 <fileclose>
    fileclose(wf);
    80005ad0:	fc843503          	ld	a0,-56(s0)
    80005ad4:	fffff097          	auipc	ra,0xfffff
    80005ad8:	9e4080e7          	jalr	-1564(ra) # 800044b8 <fileclose>
    return -1;
    80005adc:	57fd                	li	a5,-1
}
    80005ade:	853e                	mv	a0,a5
    80005ae0:	70e2                	ld	ra,56(sp)
    80005ae2:	7442                	ld	s0,48(sp)
    80005ae4:	74a2                	ld	s1,40(sp)
    80005ae6:	6121                	addi	sp,sp,64
    80005ae8:	8082                	ret

0000000080005aea <sys_crash>:

// system call to test crashes
uint64
sys_crash(void)
{
    80005aea:	7171                	addi	sp,sp,-176
    80005aec:	f506                	sd	ra,168(sp)
    80005aee:	f122                	sd	s0,160(sp)
    80005af0:	ed26                	sd	s1,152(sp)
    80005af2:	1900                	addi	s0,sp,176
  char path[MAXPATH];
  struct inode *ip;
  int crash;
  
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005af4:	08000613          	li	a2,128
    80005af8:	f6040593          	addi	a1,s0,-160
    80005afc:	4501                	li	a0,0
    80005afe:	ffffd097          	auipc	ra,0xffffd
    80005b02:	dec080e7          	jalr	-532(ra) # 800028ea <argstr>
    return -1;
    80005b06:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b08:	04054363          	bltz	a0,80005b4e <sys_crash+0x64>
    80005b0c:	f5c40593          	addi	a1,s0,-164
    80005b10:	4505                	li	a0,1
    80005b12:	ffffd097          	auipc	ra,0xffffd
    80005b16:	d94080e7          	jalr	-620(ra) # 800028a6 <argint>
    return -1;
    80005b1a:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b1c:	02054963          	bltz	a0,80005b4e <sys_crash+0x64>
  ip = create(path, T_FILE, 0, 0);
    80005b20:	4681                	li	a3,0
    80005b22:	4601                	li	a2,0
    80005b24:	4589                	li	a1,2
    80005b26:	f6040513          	addi	a0,s0,-160
    80005b2a:	fffff097          	auipc	ra,0xfffff
    80005b2e:	426080e7          	jalr	1062(ra) # 80004f50 <create>
    80005b32:	84aa                	mv	s1,a0
  if(ip == 0){
    80005b34:	c11d                	beqz	a0,80005b5a <sys_crash+0x70>
    return -1;
  }
  iunlockput(ip);
    80005b36:	ffffe097          	auipc	ra,0xffffe
    80005b3a:	af0080e7          	jalr	-1296(ra) # 80003626 <iunlockput>
  crash_op(ip->dev, crash);
    80005b3e:	f5c42583          	lw	a1,-164(s0)
    80005b42:	4088                	lw	a0,0(s1)
    80005b44:	ffffe097          	auipc	ra,0xffffe
    80005b48:	648080e7          	jalr	1608(ra) # 8000418c <crash_op>
  return 0;
    80005b4c:	4781                	li	a5,0
}
    80005b4e:	853e                	mv	a0,a5
    80005b50:	70aa                	ld	ra,168(sp)
    80005b52:	740a                	ld	s0,160(sp)
    80005b54:	64ea                	ld	s1,152(sp)
    80005b56:	614d                	addi	sp,sp,176
    80005b58:	8082                	ret
    return -1;
    80005b5a:	57fd                	li	a5,-1
    80005b5c:	bfcd                	j	80005b4e <sys_crash+0x64>
	...

0000000080005b60 <kernelvec>:
    80005b60:	7111                	addi	sp,sp,-256
    80005b62:	e006                	sd	ra,0(sp)
    80005b64:	e40a                	sd	sp,8(sp)
    80005b66:	e80e                	sd	gp,16(sp)
    80005b68:	ec12                	sd	tp,24(sp)
    80005b6a:	f016                	sd	t0,32(sp)
    80005b6c:	f41a                	sd	t1,40(sp)
    80005b6e:	f81e                	sd	t2,48(sp)
    80005b70:	fc22                	sd	s0,56(sp)
    80005b72:	e0a6                	sd	s1,64(sp)
    80005b74:	e4aa                	sd	a0,72(sp)
    80005b76:	e8ae                	sd	a1,80(sp)
    80005b78:	ecb2                	sd	a2,88(sp)
    80005b7a:	f0b6                	sd	a3,96(sp)
    80005b7c:	f4ba                	sd	a4,104(sp)
    80005b7e:	f8be                	sd	a5,112(sp)
    80005b80:	fcc2                	sd	a6,120(sp)
    80005b82:	e146                	sd	a7,128(sp)
    80005b84:	e54a                	sd	s2,136(sp)
    80005b86:	e94e                	sd	s3,144(sp)
    80005b88:	ed52                	sd	s4,152(sp)
    80005b8a:	f156                	sd	s5,160(sp)
    80005b8c:	f55a                	sd	s6,168(sp)
    80005b8e:	f95e                	sd	s7,176(sp)
    80005b90:	fd62                	sd	s8,184(sp)
    80005b92:	e1e6                	sd	s9,192(sp)
    80005b94:	e5ea                	sd	s10,200(sp)
    80005b96:	e9ee                	sd	s11,208(sp)
    80005b98:	edf2                	sd	t3,216(sp)
    80005b9a:	f1f6                	sd	t4,224(sp)
    80005b9c:	f5fa                	sd	t5,232(sp)
    80005b9e:	f9fe                	sd	t6,240(sp)
    80005ba0:	b39fc0ef          	jal	ra,800026d8 <kerneltrap>
    80005ba4:	6082                	ld	ra,0(sp)
    80005ba6:	6122                	ld	sp,8(sp)
    80005ba8:	61c2                	ld	gp,16(sp)
    80005baa:	7282                	ld	t0,32(sp)
    80005bac:	7322                	ld	t1,40(sp)
    80005bae:	73c2                	ld	t2,48(sp)
    80005bb0:	7462                	ld	s0,56(sp)
    80005bb2:	6486                	ld	s1,64(sp)
    80005bb4:	6526                	ld	a0,72(sp)
    80005bb6:	65c6                	ld	a1,80(sp)
    80005bb8:	6666                	ld	a2,88(sp)
    80005bba:	7686                	ld	a3,96(sp)
    80005bbc:	7726                	ld	a4,104(sp)
    80005bbe:	77c6                	ld	a5,112(sp)
    80005bc0:	7866                	ld	a6,120(sp)
    80005bc2:	688a                	ld	a7,128(sp)
    80005bc4:	692a                	ld	s2,136(sp)
    80005bc6:	69ca                	ld	s3,144(sp)
    80005bc8:	6a6a                	ld	s4,152(sp)
    80005bca:	7a8a                	ld	s5,160(sp)
    80005bcc:	7b2a                	ld	s6,168(sp)
    80005bce:	7bca                	ld	s7,176(sp)
    80005bd0:	7c6a                	ld	s8,184(sp)
    80005bd2:	6c8e                	ld	s9,192(sp)
    80005bd4:	6d2e                	ld	s10,200(sp)
    80005bd6:	6dce                	ld	s11,208(sp)
    80005bd8:	6e6e                	ld	t3,216(sp)
    80005bda:	7e8e                	ld	t4,224(sp)
    80005bdc:	7f2e                	ld	t5,232(sp)
    80005bde:	7fce                	ld	t6,240(sp)
    80005be0:	6111                	addi	sp,sp,256
    80005be2:	10200073          	sret
    80005be6:	00000013          	nop
    80005bea:	00000013          	nop
    80005bee:	0001                	nop

0000000080005bf0 <timervec>:
    80005bf0:	34051573          	csrrw	a0,mscratch,a0
    80005bf4:	e10c                	sd	a1,0(a0)
    80005bf6:	e510                	sd	a2,8(a0)
    80005bf8:	e914                	sd	a3,16(a0)
    80005bfa:	710c                	ld	a1,32(a0)
    80005bfc:	7510                	ld	a2,40(a0)
    80005bfe:	6194                	ld	a3,0(a1)
    80005c00:	96b2                	add	a3,a3,a2
    80005c02:	e194                	sd	a3,0(a1)
    80005c04:	4589                	li	a1,2
    80005c06:	14459073          	csrw	sip,a1
    80005c0a:	6914                	ld	a3,16(a0)
    80005c0c:	6510                	ld	a2,8(a0)
    80005c0e:	610c                	ld	a1,0(a0)
    80005c10:	34051573          	csrrw	a0,mscratch,a0
    80005c14:	30200073          	mret
	...

0000000080005c1a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c1a:	1141                	addi	sp,sp,-16
    80005c1c:	e422                	sd	s0,8(sp)
    80005c1e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c20:	0c0007b7          	lui	a5,0xc000
    80005c24:	4705                	li	a4,1
    80005c26:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c28:	c3d8                	sw	a4,4(a5)
}
    80005c2a:	6422                	ld	s0,8(sp)
    80005c2c:	0141                	addi	sp,sp,16
    80005c2e:	8082                	ret

0000000080005c30 <plicinithart>:

void
plicinithart(void)
{
    80005c30:	1141                	addi	sp,sp,-16
    80005c32:	e406                	sd	ra,8(sp)
    80005c34:	e022                	sd	s0,0(sp)
    80005c36:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c38:	ffffc097          	auipc	ra,0xffffc
    80005c3c:	bd0080e7          	jalr	-1072(ra) # 80001808 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005c40:	0085171b          	slliw	a4,a0,0x8
    80005c44:	0c0027b7          	lui	a5,0xc002
    80005c48:	97ba                	add	a5,a5,a4
    80005c4a:	40200713          	li	a4,1026
    80005c4e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005c52:	00d5151b          	slliw	a0,a0,0xd
    80005c56:	0c2017b7          	lui	a5,0xc201
    80005c5a:	953e                	add	a0,a0,a5
    80005c5c:	00052023          	sw	zero,0(a0)
}
    80005c60:	60a2                	ld	ra,8(sp)
    80005c62:	6402                	ld	s0,0(sp)
    80005c64:	0141                	addi	sp,sp,16
    80005c66:	8082                	ret

0000000080005c68 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005c68:	1141                	addi	sp,sp,-16
    80005c6a:	e422                	sd	s0,8(sp)
    80005c6c:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80005c6e:	0c0017b7          	lui	a5,0xc001
    80005c72:	6388                	ld	a0,0(a5)
    80005c74:	6422                	ld	s0,8(sp)
    80005c76:	0141                	addi	sp,sp,16
    80005c78:	8082                	ret

0000000080005c7a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005c7a:	1141                	addi	sp,sp,-16
    80005c7c:	e406                	sd	ra,8(sp)
    80005c7e:	e022                	sd	s0,0(sp)
    80005c80:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c82:	ffffc097          	auipc	ra,0xffffc
    80005c86:	b86080e7          	jalr	-1146(ra) # 80001808 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005c8a:	00d5179b          	slliw	a5,a0,0xd
    80005c8e:	0c201537          	lui	a0,0xc201
    80005c92:	953e                	add	a0,a0,a5
  return irq;
}
    80005c94:	4148                	lw	a0,4(a0)
    80005c96:	60a2                	ld	ra,8(sp)
    80005c98:	6402                	ld	s0,0(sp)
    80005c9a:	0141                	addi	sp,sp,16
    80005c9c:	8082                	ret

0000000080005c9e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005c9e:	1101                	addi	sp,sp,-32
    80005ca0:	ec06                	sd	ra,24(sp)
    80005ca2:	e822                	sd	s0,16(sp)
    80005ca4:	e426                	sd	s1,8(sp)
    80005ca6:	1000                	addi	s0,sp,32
    80005ca8:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005caa:	ffffc097          	auipc	ra,0xffffc
    80005cae:	b5e080e7          	jalr	-1186(ra) # 80001808 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005cb2:	00d5151b          	slliw	a0,a0,0xd
    80005cb6:	0c2017b7          	lui	a5,0xc201
    80005cba:	97aa                	add	a5,a5,a0
    80005cbc:	c3c4                	sw	s1,4(a5)
}
    80005cbe:	60e2                	ld	ra,24(sp)
    80005cc0:	6442                	ld	s0,16(sp)
    80005cc2:	64a2                	ld	s1,8(sp)
    80005cc4:	6105                	addi	sp,sp,32
    80005cc6:	8082                	ret

0000000080005cc8 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005cc8:	1141                	addi	sp,sp,-16
    80005cca:	e406                	sd	ra,8(sp)
    80005ccc:	e022                	sd	s0,0(sp)
    80005cce:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005cd0:	479d                	li	a5,7
    80005cd2:	06b7c963          	blt	a5,a1,80005d44 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005cd6:	00151793          	slli	a5,a0,0x1
    80005cda:	97aa                	add	a5,a5,a0
    80005cdc:	00c79713          	slli	a4,a5,0xc
    80005ce0:	0001d797          	auipc	a5,0x1d
    80005ce4:	32078793          	addi	a5,a5,800 # 80023000 <disk>
    80005ce8:	97ba                	add	a5,a5,a4
    80005cea:	97ae                	add	a5,a5,a1
    80005cec:	6709                	lui	a4,0x2
    80005cee:	97ba                	add	a5,a5,a4
    80005cf0:	0187c783          	lbu	a5,24(a5)
    80005cf4:	e3a5                	bnez	a5,80005d54 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80005cf6:	0001d817          	auipc	a6,0x1d
    80005cfa:	30a80813          	addi	a6,a6,778 # 80023000 <disk>
    80005cfe:	00151693          	slli	a3,a0,0x1
    80005d02:	00a68733          	add	a4,a3,a0
    80005d06:	0732                	slli	a4,a4,0xc
    80005d08:	00e807b3          	add	a5,a6,a4
    80005d0c:	6709                	lui	a4,0x2
    80005d0e:	00f70633          	add	a2,a4,a5
    80005d12:	6210                	ld	a2,0(a2)
    80005d14:	00459893          	slli	a7,a1,0x4
    80005d18:	9646                	add	a2,a2,a7
    80005d1a:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    80005d1e:	97ae                	add	a5,a5,a1
    80005d20:	97ba                	add	a5,a5,a4
    80005d22:	4605                	li	a2,1
    80005d24:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80005d28:	96aa                	add	a3,a3,a0
    80005d2a:	06b2                	slli	a3,a3,0xc
    80005d2c:	0761                	addi	a4,a4,24
    80005d2e:	96ba                	add	a3,a3,a4
    80005d30:	00d80533          	add	a0,a6,a3
    80005d34:	ffffc097          	auipc	ra,0xffffc
    80005d38:	452080e7          	jalr	1106(ra) # 80002186 <wakeup>
}
    80005d3c:	60a2                	ld	ra,8(sp)
    80005d3e:	6402                	ld	s0,0(sp)
    80005d40:	0141                	addi	sp,sp,16
    80005d42:	8082                	ret
    panic("virtio_disk_intr 1");
    80005d44:	00002517          	auipc	a0,0x2
    80005d48:	a9c50513          	addi	a0,a0,-1380 # 800077e0 <userret+0x750>
    80005d4c:	ffffb097          	auipc	ra,0xffffb
    80005d50:	802080e7          	jalr	-2046(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    80005d54:	00002517          	auipc	a0,0x2
    80005d58:	aa450513          	addi	a0,a0,-1372 # 800077f8 <userret+0x768>
    80005d5c:	ffffa097          	auipc	ra,0xffffa
    80005d60:	7f2080e7          	jalr	2034(ra) # 8000054e <panic>

0000000080005d64 <virtio_disk_init>:
  __sync_synchronize();
    80005d64:	0ff0000f          	fence
  if(disk[n].init)
    80005d68:	00151793          	slli	a5,a0,0x1
    80005d6c:	97aa                	add	a5,a5,a0
    80005d6e:	07b2                	slli	a5,a5,0xc
    80005d70:	0001d717          	auipc	a4,0x1d
    80005d74:	29070713          	addi	a4,a4,656 # 80023000 <disk>
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	6789                	lui	a5,0x2
    80005d7c:	97ba                	add	a5,a5,a4
    80005d7e:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80005d82:	c391                	beqz	a5,80005d86 <virtio_disk_init+0x22>
    80005d84:	8082                	ret
{
    80005d86:	7139                	addi	sp,sp,-64
    80005d88:	fc06                	sd	ra,56(sp)
    80005d8a:	f822                	sd	s0,48(sp)
    80005d8c:	f426                	sd	s1,40(sp)
    80005d8e:	f04a                	sd	s2,32(sp)
    80005d90:	ec4e                	sd	s3,24(sp)
    80005d92:	e852                	sd	s4,16(sp)
    80005d94:	e456                	sd	s5,8(sp)
    80005d96:	0080                	addi	s0,sp,64
    80005d98:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    80005d9a:	85aa                	mv	a1,a0
    80005d9c:	00002517          	auipc	a0,0x2
    80005da0:	a7450513          	addi	a0,a0,-1420 # 80007810 <userret+0x780>
    80005da4:	ffffa097          	auipc	ra,0xffffa
    80005da8:	7f4080e7          	jalr	2036(ra) # 80000598 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    80005dac:	00149993          	slli	s3,s1,0x1
    80005db0:	99a6                	add	s3,s3,s1
    80005db2:	09b2                	slli	s3,s3,0xc
    80005db4:	6789                	lui	a5,0x2
    80005db6:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    80005dba:	97ce                	add	a5,a5,s3
    80005dbc:	00002597          	auipc	a1,0x2
    80005dc0:	a6c58593          	addi	a1,a1,-1428 # 80007828 <userret+0x798>
    80005dc4:	0001d517          	auipc	a0,0x1d
    80005dc8:	23c50513          	addi	a0,a0,572 # 80023000 <disk>
    80005dcc:	953e                	add	a0,a0,a5
    80005dce:	ffffb097          	auipc	ra,0xffffb
    80005dd2:	bf2080e7          	jalr	-1038(ra) # 800009c0 <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dd6:	0014891b          	addiw	s2,s1,1
    80005dda:	00c9191b          	slliw	s2,s2,0xc
    80005dde:	100007b7          	lui	a5,0x10000
    80005de2:	97ca                	add	a5,a5,s2
    80005de4:	4398                	lw	a4,0(a5)
    80005de6:	2701                	sext.w	a4,a4
    80005de8:	747277b7          	lui	a5,0x74727
    80005dec:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005df0:	12f71863          	bne	a4,a5,80005f20 <virtio_disk_init+0x1bc>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005df4:	100007b7          	lui	a5,0x10000
    80005df8:	0791                	addi	a5,a5,4
    80005dfa:	97ca                	add	a5,a5,s2
    80005dfc:	439c                	lw	a5,0(a5)
    80005dfe:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e00:	4705                	li	a4,1
    80005e02:	10e79f63          	bne	a5,a4,80005f20 <virtio_disk_init+0x1bc>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e06:	100007b7          	lui	a5,0x10000
    80005e0a:	07a1                	addi	a5,a5,8
    80005e0c:	97ca                	add	a5,a5,s2
    80005e0e:	439c                	lw	a5,0(a5)
    80005e10:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005e12:	4709                	li	a4,2
    80005e14:	10e79663          	bne	a5,a4,80005f20 <virtio_disk_init+0x1bc>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e18:	100007b7          	lui	a5,0x10000
    80005e1c:	07b1                	addi	a5,a5,12
    80005e1e:	97ca                	add	a5,a5,s2
    80005e20:	4398                	lw	a4,0(a5)
    80005e22:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e24:	554d47b7          	lui	a5,0x554d4
    80005e28:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e2c:	0ef71a63          	bne	a4,a5,80005f20 <virtio_disk_init+0x1bc>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e30:	100007b7          	lui	a5,0x10000
    80005e34:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80005e38:	96ca                	add	a3,a3,s2
    80005e3a:	4705                	li	a4,1
    80005e3c:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e3e:	470d                	li	a4,3
    80005e40:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80005e42:	01078713          	addi	a4,a5,16
    80005e46:	974a                	add	a4,a4,s2
    80005e48:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e4a:	02078613          	addi	a2,a5,32
    80005e4e:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e50:	c7ffe737          	lui	a4,0xc7ffe
    80005e54:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <ticks+0xffffffff47fd5737>
    80005e58:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e5a:	2701                	sext.w	a4,a4
    80005e5c:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e5e:	472d                	li	a4,11
    80005e60:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005e62:	473d                	li	a4,15
    80005e64:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005e66:	02878713          	addi	a4,a5,40
    80005e6a:	974a                	add	a4,a4,s2
    80005e6c:	6685                	lui	a3,0x1
    80005e6e:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e70:	03078713          	addi	a4,a5,48
    80005e74:	974a                	add	a4,a4,s2
    80005e76:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e7a:	03478793          	addi	a5,a5,52
    80005e7e:	97ca                	add	a5,a5,s2
    80005e80:	439c                	lw	a5,0(a5)
    80005e82:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e84:	c7d5                	beqz	a5,80005f30 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80005e86:	471d                	li	a4,7
    80005e88:	0af77c63          	bgeu	a4,a5,80005f40 <virtio_disk_init+0x1dc>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e8c:	10000ab7          	lui	s5,0x10000
    80005e90:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    80005e94:	97ca                	add	a5,a5,s2
    80005e96:	4721                	li	a4,8
    80005e98:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    80005e9a:	0001da17          	auipc	s4,0x1d
    80005e9e:	166a0a13          	addi	s4,s4,358 # 80023000 <disk>
    80005ea2:	99d2                	add	s3,s3,s4
    80005ea4:	6609                	lui	a2,0x2
    80005ea6:	4581                	li	a1,0
    80005ea8:	854e                	mv	a0,s3
    80005eaa:	ffffb097          	auipc	ra,0xffffb
    80005eae:	cec080e7          	jalr	-788(ra) # 80000b96 <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    80005eb2:	040a8a93          	addi	s5,s5,64
    80005eb6:	9956                	add	s2,s2,s5
    80005eb8:	00c9d793          	srli	a5,s3,0xc
    80005ebc:	2781                	sext.w	a5,a5
    80005ebe:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    80005ec2:	00149513          	slli	a0,s1,0x1
    80005ec6:	009507b3          	add	a5,a0,s1
    80005eca:	07b2                	slli	a5,a5,0xc
    80005ecc:	97d2                	add	a5,a5,s4
    80005ece:	6689                	lui	a3,0x2
    80005ed0:	97b6                	add	a5,a5,a3
    80005ed2:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80005ed6:	08098713          	addi	a4,s3,128
    80005eda:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    80005edc:	6705                	lui	a4,0x1
    80005ede:	99ba                	add	s3,s3,a4
    80005ee0:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80005ee4:	4705                	li	a4,1
    80005ee6:	00e78c23          	sb	a4,24(a5)
    80005eea:	00e78ca3          	sb	a4,25(a5)
    80005eee:	00e78d23          	sb	a4,26(a5)
    80005ef2:	00e78da3          	sb	a4,27(a5)
    80005ef6:	00e78e23          	sb	a4,28(a5)
    80005efa:	00e78ea3          	sb	a4,29(a5)
    80005efe:	00e78f23          	sb	a4,30(a5)
    80005f02:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80005f06:	853e                	mv	a0,a5
    80005f08:	4785                	li	a5,1
    80005f0a:	0af52423          	sw	a5,168(a0)
}
    80005f0e:	70e2                	ld	ra,56(sp)
    80005f10:	7442                	ld	s0,48(sp)
    80005f12:	74a2                	ld	s1,40(sp)
    80005f14:	7902                	ld	s2,32(sp)
    80005f16:	69e2                	ld	s3,24(sp)
    80005f18:	6a42                	ld	s4,16(sp)
    80005f1a:	6aa2                	ld	s5,8(sp)
    80005f1c:	6121                	addi	sp,sp,64
    80005f1e:	8082                	ret
    panic("could not find virtio disk");
    80005f20:	00002517          	auipc	a0,0x2
    80005f24:	91850513          	addi	a0,a0,-1768 # 80007838 <userret+0x7a8>
    80005f28:	ffffa097          	auipc	ra,0xffffa
    80005f2c:	626080e7          	jalr	1574(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    80005f30:	00002517          	auipc	a0,0x2
    80005f34:	92850513          	addi	a0,a0,-1752 # 80007858 <userret+0x7c8>
    80005f38:	ffffa097          	auipc	ra,0xffffa
    80005f3c:	616080e7          	jalr	1558(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    80005f40:	00002517          	auipc	a0,0x2
    80005f44:	93850513          	addi	a0,a0,-1736 # 80007878 <userret+0x7e8>
    80005f48:	ffffa097          	auipc	ra,0xffffa
    80005f4c:	606080e7          	jalr	1542(ra) # 8000054e <panic>

0000000080005f50 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    80005f50:	7135                	addi	sp,sp,-160
    80005f52:	ed06                	sd	ra,152(sp)
    80005f54:	e922                	sd	s0,144(sp)
    80005f56:	e526                	sd	s1,136(sp)
    80005f58:	e14a                	sd	s2,128(sp)
    80005f5a:	fcce                	sd	s3,120(sp)
    80005f5c:	f8d2                	sd	s4,112(sp)
    80005f5e:	f4d6                	sd	s5,104(sp)
    80005f60:	f0da                	sd	s6,96(sp)
    80005f62:	ecde                	sd	s7,88(sp)
    80005f64:	e8e2                	sd	s8,80(sp)
    80005f66:	e4e6                	sd	s9,72(sp)
    80005f68:	e0ea                	sd	s10,64(sp)
    80005f6a:	fc6e                	sd	s11,56(sp)
    80005f6c:	1100                	addi	s0,sp,160
    80005f6e:	892a                	mv	s2,a0
    80005f70:	89ae                	mv	s3,a1
    80005f72:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f74:	45dc                	lw	a5,12(a1)
    80005f76:	0017979b          	slliw	a5,a5,0x1
    80005f7a:	1782                	slli	a5,a5,0x20
    80005f7c:	9381                	srli	a5,a5,0x20
    80005f7e:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    80005f82:	00151493          	slli	s1,a0,0x1
    80005f86:	94aa                	add	s1,s1,a0
    80005f88:	04b2                	slli	s1,s1,0xc
    80005f8a:	6a89                	lui	s5,0x2
    80005f8c:	0b0a8a13          	addi	s4,s5,176 # 20b0 <_entry-0x7fffdf50>
    80005f90:	9a26                	add	s4,s4,s1
    80005f92:	0001db97          	auipc	s7,0x1d
    80005f96:	06eb8b93          	addi	s7,s7,110 # 80023000 <disk>
    80005f9a:	9a5e                	add	s4,s4,s7
    80005f9c:	8552                	mv	a0,s4
    80005f9e:	ffffb097          	auipc	ra,0xffffb
    80005fa2:	b34080e7          	jalr	-1228(ra) # 80000ad2 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80005fa6:	0ae1                	addi	s5,s5,24
    80005fa8:	94d6                	add	s1,s1,s5
    80005faa:	01748ab3          	add	s5,s1,s7
    80005fae:	8d56                	mv	s10,s5
  for(int i = 0; i < 3; i++){
    80005fb0:	4b81                	li	s7,0
  for(int i = 0; i < NUM; i++){
    80005fb2:	4ca1                	li	s9,8
      disk[n].free[i] = 0;
    80005fb4:	00191b13          	slli	s6,s2,0x1
    80005fb8:	9b4a                	add	s6,s6,s2
    80005fba:	00cb1793          	slli	a5,s6,0xc
    80005fbe:	0001db17          	auipc	s6,0x1d
    80005fc2:	042b0b13          	addi	s6,s6,66 # 80023000 <disk>
    80005fc6:	9b3e                	add	s6,s6,a5
  for(int i = 0; i < NUM; i++){
    80005fc8:	8c5e                	mv	s8,s7
    80005fca:	a8ad                	j	80006044 <virtio_disk_rw+0xf4>
      disk[n].free[i] = 0;
    80005fcc:	00fb06b3          	add	a3,s6,a5
    80005fd0:	96aa                	add	a3,a3,a0
    80005fd2:	00068c23          	sb	zero,24(a3) # 2018 <_entry-0x7fffdfe8>
    idx[i] = alloc_desc(n);
    80005fd6:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005fd8:	0207c363          	bltz	a5,80005ffe <virtio_disk_rw+0xae>
  for(int i = 0; i < 3; i++){
    80005fdc:	2485                	addiw	s1,s1,1
    80005fde:	0711                	addi	a4,a4,4
    80005fe0:	26b48f63          	beq	s1,a1,8000625e <virtio_disk_rw+0x30e>
    idx[i] = alloc_desc(n);
    80005fe4:	863a                	mv	a2,a4
    80005fe6:	86ea                	mv	a3,s10
  for(int i = 0; i < NUM; i++){
    80005fe8:	87e2                	mv	a5,s8
    if(disk[n].free[i]){
    80005fea:	0006c803          	lbu	a6,0(a3)
    80005fee:	fc081fe3          	bnez	a6,80005fcc <virtio_disk_rw+0x7c>
  for(int i = 0; i < NUM; i++){
    80005ff2:	2785                	addiw	a5,a5,1
    80005ff4:	0685                	addi	a3,a3,1
    80005ff6:	ff979ae3          	bne	a5,s9,80005fea <virtio_disk_rw+0x9a>
    idx[i] = alloc_desc(n);
    80005ffa:	57fd                	li	a5,-1
    80005ffc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005ffe:	02905d63          	blez	s1,80006038 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    80006002:	f8042583          	lw	a1,-128(s0)
    80006006:	854a                	mv	a0,s2
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	cc0080e7          	jalr	-832(ra) # 80005cc8 <free_desc>
      for(int j = 0; j < i; j++)
    80006010:	4785                	li	a5,1
    80006012:	0297d363          	bge	a5,s1,80006038 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    80006016:	f8442583          	lw	a1,-124(s0)
    8000601a:	854a                	mv	a0,s2
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	cac080e7          	jalr	-852(ra) # 80005cc8 <free_desc>
      for(int j = 0; j < i; j++)
    80006024:	4789                	li	a5,2
    80006026:	0097d963          	bge	a5,s1,80006038 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    8000602a:	f8842583          	lw	a1,-120(s0)
    8000602e:	854a                	mv	a0,s2
    80006030:	00000097          	auipc	ra,0x0
    80006034:	c98080e7          	jalr	-872(ra) # 80005cc8 <free_desc>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80006038:	85d2                	mv	a1,s4
    8000603a:	8556                	mv	a0,s5
    8000603c:	ffffc097          	auipc	ra,0xffffc
    80006040:	ffe080e7          	jalr	-2(ra) # 8000203a <sleep>
  for(int i = 0; i < 3; i++){
    80006044:	f8040713          	addi	a4,s0,-128
    80006048:	84de                	mv	s1,s7
      disk[n].free[i] = 0;
    8000604a:	6509                	lui	a0,0x2
  for(int i = 0; i < 3; i++){
    8000604c:	458d                	li	a1,3
    8000604e:	bf59                	j	80005fe4 <virtio_disk_rw+0x94>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    80006050:	4785                	li	a5,1
    80006052:	f6f42823          	sw	a5,-144(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    80006056:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    8000605a:	f6843783          	ld	a5,-152(s0)
    8000605e:	f6f43c23          	sd	a5,-136(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006062:	f8042483          	lw	s1,-128(s0)
    80006066:	00449b13          	slli	s6,s1,0x4
    8000606a:	00191793          	slli	a5,s2,0x1
    8000606e:	97ca                	add	a5,a5,s2
    80006070:	07b2                	slli	a5,a5,0xc
    80006072:	0001da97          	auipc	s5,0x1d
    80006076:	f8ea8a93          	addi	s5,s5,-114 # 80023000 <disk>
    8000607a:	97d6                	add	a5,a5,s5
    8000607c:	6a89                	lui	s5,0x2
    8000607e:	9abe                	add	s5,s5,a5
    80006080:	000abb83          	ld	s7,0(s5) # 2000 <_entry-0x7fffe000>
    80006084:	9bda                	add	s7,s7,s6
    80006086:	f7040513          	addi	a0,s0,-144
    8000608a:	ffffb097          	auipc	ra,0xffffb
    8000608e:	f40080e7          	jalr	-192(ra) # 80000fca <kvmpa>
    80006092:	00abb023          	sd	a0,0(s7)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    80006096:	000ab783          	ld	a5,0(s5)
    8000609a:	97da                	add	a5,a5,s6
    8000609c:	4741                	li	a4,16
    8000609e:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800060a0:	000ab783          	ld	a5,0(s5)
    800060a4:	97da                	add	a5,a5,s6
    800060a6:	4705                	li	a4,1
    800060a8:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    800060ac:	f8442683          	lw	a3,-124(s0)
    800060b0:	000ab783          	ld	a5,0(s5)
    800060b4:	9b3e                	add	s6,s6,a5
    800060b6:	00db1723          	sh	a3,14(s6)

  disk[n].desc[idx[1]].addr = (uint64) b->data;
    800060ba:	0692                	slli	a3,a3,0x4
    800060bc:	000ab783          	ld	a5,0(s5)
    800060c0:	97b6                	add	a5,a5,a3
    800060c2:	06098713          	addi	a4,s3,96
    800060c6:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    800060c8:	000ab783          	ld	a5,0(s5)
    800060cc:	97b6                	add	a5,a5,a3
    800060ce:	40000713          	li	a4,1024
    800060d2:	c798                	sw	a4,8(a5)
  if(write)
    800060d4:	140d8063          	beqz	s11,80006214 <virtio_disk_rw+0x2c4>
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    800060d8:	000ab783          	ld	a5,0(s5)
    800060dc:	97b6                	add	a5,a5,a3
    800060de:	00079623          	sh	zero,12(a5)
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060e2:	0001d517          	auipc	a0,0x1d
    800060e6:	f1e50513          	addi	a0,a0,-226 # 80023000 <disk>
    800060ea:	00191793          	slli	a5,s2,0x1
    800060ee:	01278733          	add	a4,a5,s2
    800060f2:	0732                	slli	a4,a4,0xc
    800060f4:	972a                	add	a4,a4,a0
    800060f6:	6609                	lui	a2,0x2
    800060f8:	9732                	add	a4,a4,a2
    800060fa:	630c                	ld	a1,0(a4)
    800060fc:	95b6                	add	a1,a1,a3
    800060fe:	00c5d603          	lhu	a2,12(a1)
    80006102:	00166613          	ori	a2,a2,1
    80006106:	00c59623          	sh	a2,12(a1)
  disk[n].desc[idx[1]].next = idx[2];
    8000610a:	f8842603          	lw	a2,-120(s0)
    8000610e:	630c                	ld	a1,0(a4)
    80006110:	96ae                	add	a3,a3,a1
    80006112:	00c69723          	sh	a2,14(a3)

  disk[n].info[idx[0]].status = 0;
    80006116:	97ca                	add	a5,a5,s2
    80006118:	07a2                	slli	a5,a5,0x8
    8000611a:	97a6                	add	a5,a5,s1
    8000611c:	20078793          	addi	a5,a5,512
    80006120:	0792                	slli	a5,a5,0x4
    80006122:	97aa                	add	a5,a5,a0
    80006124:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    80006128:	00461693          	slli	a3,a2,0x4
    8000612c:	00073803          	ld	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80006130:	9836                	add	a6,a6,a3
    80006132:	20348613          	addi	a2,s1,515
    80006136:	00191593          	slli	a1,s2,0x1
    8000613a:	95ca                	add	a1,a1,s2
    8000613c:	05a2                	slli	a1,a1,0x8
    8000613e:	962e                	add	a2,a2,a1
    80006140:	0612                	slli	a2,a2,0x4
    80006142:	962a                	add	a2,a2,a0
    80006144:	00c83023          	sd	a2,0(a6)
  disk[n].desc[idx[2]].len = 1;
    80006148:	6310                	ld	a2,0(a4)
    8000614a:	9636                	add	a2,a2,a3
    8000614c:	4585                	li	a1,1
    8000614e:	c60c                	sw	a1,8(a2)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006150:	6310                	ld	a2,0(a4)
    80006152:	9636                	add	a2,a2,a3
    80006154:	4509                	li	a0,2
    80006156:	00a61623          	sh	a0,12(a2) # 200c <_entry-0x7fffdff4>
  disk[n].desc[idx[2]].next = 0;
    8000615a:	6310                	ld	a2,0(a4)
    8000615c:	96b2                	add	a3,a3,a2
    8000615e:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006162:	00b9a223          	sw	a1,4(s3)
  disk[n].info[idx[0]].b = b;
    80006166:	0337b423          	sd	s3,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    8000616a:	6714                	ld	a3,8(a4)
    8000616c:	0026d783          	lhu	a5,2(a3)
    80006170:	8b9d                	andi	a5,a5,7
    80006172:	2789                	addiw	a5,a5,2
    80006174:	0786                	slli	a5,a5,0x1
    80006176:	97b6                	add	a5,a5,a3
    80006178:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000617c:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    80006180:	6718                	ld	a4,8(a4)
    80006182:	00275783          	lhu	a5,2(a4)
    80006186:	2785                	addiw	a5,a5,1
    80006188:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000618c:	0019079b          	addiw	a5,s2,1
    80006190:	00c7979b          	slliw	a5,a5,0xc
    80006194:	10000737          	lui	a4,0x10000
    80006198:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    8000619c:	97ba                	add	a5,a5,a4
    8000619e:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800061a2:	0049a703          	lw	a4,4(s3)
    800061a6:	4785                	li	a5,1
    800061a8:	00f71d63          	bne	a4,a5,800061c2 <virtio_disk_rw+0x272>
    800061ac:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    800061ae:	85d2                	mv	a1,s4
    800061b0:	854e                	mv	a0,s3
    800061b2:	ffffc097          	auipc	ra,0xffffc
    800061b6:	e88080e7          	jalr	-376(ra) # 8000203a <sleep>
  while(b->disk == 1) {
    800061ba:	0049a783          	lw	a5,4(s3)
    800061be:	fe9788e3          	beq	a5,s1,800061ae <virtio_disk_rw+0x25e>
  }

  disk[n].info[idx[0]].b = 0;
    800061c2:	f8042483          	lw	s1,-128(s0)
    800061c6:	00191793          	slli	a5,s2,0x1
    800061ca:	97ca                	add	a5,a5,s2
    800061cc:	07a2                	slli	a5,a5,0x8
    800061ce:	97a6                	add	a5,a5,s1
    800061d0:	20078793          	addi	a5,a5,512
    800061d4:	0792                	slli	a5,a5,0x4
    800061d6:	0001d717          	auipc	a4,0x1d
    800061da:	e2a70713          	addi	a4,a4,-470 # 80023000 <disk>
    800061de:	97ba                	add	a5,a5,a4
    800061e0:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    800061e4:	00191793          	slli	a5,s2,0x1
    800061e8:	97ca                	add	a5,a5,s2
    800061ea:	07b2                	slli	a5,a5,0xc
    800061ec:	97ba                	add	a5,a5,a4
    800061ee:	6989                	lui	s3,0x2
    800061f0:	99be                	add	s3,s3,a5
    free_desc(n, i);
    800061f2:	85a6                	mv	a1,s1
    800061f4:	854a                	mv	a0,s2
    800061f6:	00000097          	auipc	ra,0x0
    800061fa:	ad2080e7          	jalr	-1326(ra) # 80005cc8 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    800061fe:	0492                	slli	s1,s1,0x4
    80006200:	0009b783          	ld	a5,0(s3) # 2000 <_entry-0x7fffe000>
    80006204:	94be                	add	s1,s1,a5
    80006206:	00c4d783          	lhu	a5,12(s1)
    8000620a:	8b85                	andi	a5,a5,1
    8000620c:	c78d                	beqz	a5,80006236 <virtio_disk_rw+0x2e6>
      i = disk[n].desc[i].next;
    8000620e:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    80006212:	b7c5                	j	800061f2 <virtio_disk_rw+0x2a2>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006214:	00191793          	slli	a5,s2,0x1
    80006218:	97ca                	add	a5,a5,s2
    8000621a:	07b2                	slli	a5,a5,0xc
    8000621c:	0001d717          	auipc	a4,0x1d
    80006220:	de470713          	addi	a4,a4,-540 # 80023000 <disk>
    80006224:	973e                	add	a4,a4,a5
    80006226:	6789                	lui	a5,0x2
    80006228:	97ba                	add	a5,a5,a4
    8000622a:	639c                	ld	a5,0(a5)
    8000622c:	97b6                	add	a5,a5,a3
    8000622e:	4709                	li	a4,2
    80006230:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    80006234:	b57d                	j	800060e2 <virtio_disk_rw+0x192>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    80006236:	8552                	mv	a0,s4
    80006238:	ffffb097          	auipc	ra,0xffffb
    8000623c:	902080e7          	jalr	-1790(ra) # 80000b3a <release>
}
    80006240:	60ea                	ld	ra,152(sp)
    80006242:	644a                	ld	s0,144(sp)
    80006244:	64aa                	ld	s1,136(sp)
    80006246:	690a                	ld	s2,128(sp)
    80006248:	79e6                	ld	s3,120(sp)
    8000624a:	7a46                	ld	s4,112(sp)
    8000624c:	7aa6                	ld	s5,104(sp)
    8000624e:	7b06                	ld	s6,96(sp)
    80006250:	6be6                	ld	s7,88(sp)
    80006252:	6c46                	ld	s8,80(sp)
    80006254:	6ca6                	ld	s9,72(sp)
    80006256:	6d06                	ld	s10,64(sp)
    80006258:	7de2                	ld	s11,56(sp)
    8000625a:	610d                	addi	sp,sp,160
    8000625c:	8082                	ret
  if(write)
    8000625e:	de0d99e3          	bnez	s11,80006050 <virtio_disk_rw+0x100>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    80006262:	f6042823          	sw	zero,-144(s0)
    80006266:	bbc5                	j	80006056 <virtio_disk_rw+0x106>

0000000080006268 <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    80006268:	7139                	addi	sp,sp,-64
    8000626a:	fc06                	sd	ra,56(sp)
    8000626c:	f822                	sd	s0,48(sp)
    8000626e:	f426                	sd	s1,40(sp)
    80006270:	f04a                	sd	s2,32(sp)
    80006272:	ec4e                	sd	s3,24(sp)
    80006274:	e852                	sd	s4,16(sp)
    80006276:	e456                	sd	s5,8(sp)
    80006278:	0080                	addi	s0,sp,64
    8000627a:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    8000627c:	00151913          	slli	s2,a0,0x1
    80006280:	00a90a33          	add	s4,s2,a0
    80006284:	0a32                	slli	s4,s4,0xc
    80006286:	6989                	lui	s3,0x2
    80006288:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    8000628c:	9a3e                	add	s4,s4,a5
    8000628e:	0001da97          	auipc	s5,0x1d
    80006292:	d72a8a93          	addi	s5,s5,-654 # 80023000 <disk>
    80006296:	9a56                	add	s4,s4,s5
    80006298:	8552                	mv	a0,s4
    8000629a:	ffffb097          	auipc	ra,0xffffb
    8000629e:	838080e7          	jalr	-1992(ra) # 80000ad2 <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    800062a2:	9926                	add	s2,s2,s1
    800062a4:	0932                	slli	s2,s2,0xc
    800062a6:	9956                	add	s2,s2,s5
    800062a8:	99ca                	add	s3,s3,s2
    800062aa:	0209d783          	lhu	a5,32(s3)
    800062ae:	0109b703          	ld	a4,16(s3)
    800062b2:	00275683          	lhu	a3,2(a4)
    800062b6:	8ebd                	xor	a3,a3,a5
    800062b8:	8a9d                	andi	a3,a3,7
    800062ba:	c2a5                	beqz	a3,8000631a <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    800062bc:	8956                	mv	s2,s5
    800062be:	00149693          	slli	a3,s1,0x1
    800062c2:	96a6                	add	a3,a3,s1
    800062c4:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    800062c8:	06b2                	slli	a3,a3,0xc
    800062ca:	96d6                	add	a3,a3,s5
    800062cc:	6489                	lui	s1,0x2
    800062ce:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    800062d0:	078e                	slli	a5,a5,0x3
    800062d2:	97ba                	add	a5,a5,a4
    800062d4:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    800062d6:	00f98733          	add	a4,s3,a5
    800062da:	20070713          	addi	a4,a4,512
    800062de:	0712                	slli	a4,a4,0x4
    800062e0:	974a                	add	a4,a4,s2
    800062e2:	03074703          	lbu	a4,48(a4)
    800062e6:	eb21                	bnez	a4,80006336 <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    800062e8:	97ce                	add	a5,a5,s3
    800062ea:	20078793          	addi	a5,a5,512
    800062ee:	0792                	slli	a5,a5,0x4
    800062f0:	97ca                	add	a5,a5,s2
    800062f2:	7798                	ld	a4,40(a5)
    800062f4:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    800062f8:	7788                	ld	a0,40(a5)
    800062fa:	ffffc097          	auipc	ra,0xffffc
    800062fe:	e8c080e7          	jalr	-372(ra) # 80002186 <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006302:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    80006306:	2785                	addiw	a5,a5,1
    80006308:	8b9d                	andi	a5,a5,7
    8000630a:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    8000630e:	6898                	ld	a4,16(s1)
    80006310:	00275683          	lhu	a3,2(a4)
    80006314:	8a9d                	andi	a3,a3,7
    80006316:	faf69de3          	bne	a3,a5,800062d0 <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    8000631a:	8552                	mv	a0,s4
    8000631c:	ffffb097          	auipc	ra,0xffffb
    80006320:	81e080e7          	jalr	-2018(ra) # 80000b3a <release>
}
    80006324:	70e2                	ld	ra,56(sp)
    80006326:	7442                	ld	s0,48(sp)
    80006328:	74a2                	ld	s1,40(sp)
    8000632a:	7902                	ld	s2,32(sp)
    8000632c:	69e2                	ld	s3,24(sp)
    8000632e:	6a42                	ld	s4,16(sp)
    80006330:	6aa2                	ld	s5,8(sp)
    80006332:	6121                	addi	sp,sp,64
    80006334:	8082                	ret
      panic("virtio_disk_intr status");
    80006336:	00001517          	auipc	a0,0x1
    8000633a:	56250513          	addi	a0,a0,1378 # 80007898 <userret+0x808>
    8000633e:	ffffa097          	auipc	ra,0xffffa
    80006342:	210080e7          	jalr	528(ra) # 8000054e <panic>
	...

0000000080007000 <trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
