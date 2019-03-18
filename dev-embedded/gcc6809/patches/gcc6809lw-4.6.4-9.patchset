diff -urN gcc-4.6.4-clean/config.sub gcc-4.6.4/config.sub
--- gcc-4.6.4-clean/config.sub	2010-05-25 07:22:07.000000000 -0600
+++ gcc-4.6.4/config.sub	2017-11-28 21:12:11.136911706 -0700
@@ -313,7 +313,7 @@
 	c6x)
 		basic_machine=tic6x-unknown
 		;;
-	m6811 | m68hc11 | m6812 | m68hc12 | picochip)
+	m6809 | m6811 | m68hc11 | m6812 | m68hc12 | picochip)
 		# Motorola 68HC11/12.
 		basic_machine=$basic_machine-unknown
 		os=-none
@@ -354,7 +354,7 @@
 	| i*86-* | i860-* | i960-* | ia64-* \
 	| ip2k-* | iq2000-* \
 	| lm32-* \
-	| m32c-* | m32r-* | m32rle-* \
+	| m32c-* | m32r-* | m32rle-* | m6809-* \
 	| m68000-* | m680[012346]0-* | m68360-* | m683?2-* | m68k-* \
 	| m88110-* | m88k-* | maxq-* | mcore-* | metag-* | microblaze-* \
 	| mips-* | mipsbe-* | mipseb-* | mipsel-* | mipsle-* \
@@ -509,6 +509,10 @@
 		basic_machine=arm-unknown
 		os=-cegcc
 		;;
+	coco)
+		basic_machine=coco
+		os=-none
+		;;
 	convex-c1)
 		basic_machine=c1-convex
 		os=-bsd
diff -urN gcc-4.6.4-clean/configure gcc-4.6.4/configure
--- gcc-4.6.4-clean/configure	2011-12-18 03:03:44.000000000 -0700
+++ gcc-4.6.4/configure	2017-11-28 21:12:11.136911706 -0700
@@ -3439,6 +3439,9 @@
   m32r-*-*)
     noconfigdirs="$noconfigdirs ${libgcj}"
     ;;
+  m6809*)
+    noconfigdirs="$noconfigdirs target-libiberty target-libstdc++-v3 target-libgloss ${libgcj}"
+    ;;
   m68hc11-*-*|m6811-*-*|m68hc12-*-*|m6812-*-*)
     noconfigdirs="$noconfigdirs target-libstdc++-v3 ${libgcj}"
     libgloss_dir=m68hc11
diff -urN gcc-4.6.4-clean/configure.ac gcc-4.6.4/configure.ac
--- gcc-4.6.4-clean/configure.ac	2011-11-18 04:45:44.000000000 -0700
+++ gcc-4.6.4/configure.ac	2017-11-28 21:12:11.140911685 -0700
@@ -885,6 +885,9 @@
   m32r-*-*)
     noconfigdirs="$noconfigdirs ${libgcj}"
     ;;
+  m6809*)
+    noconfigdirs="$noconfigdirs target-libiberty target-libstdc++-v3 target-libgloss ${libgcj}"
+    ;;
   m68hc11-*-*|m6811-*-*|m68hc12-*-*|m6812-*-*)
     noconfigdirs="$noconfigdirs target-libstdc++-v3 ${libgcj}"
     libgloss_dir=m68hc11
diff -urN gcc-4.6.4-clean/gcc/calls.c gcc-4.6.4/gcc/calls.c
--- gcc-4.6.4-clean/gcc/calls.c	2012-02-09 10:27:25.000000000 -0700
+++ gcc-4.6.4/gcc/calls.c	2017-11-28 21:12:11.140911685 -0700
@@ -2561,7 +2561,7 @@
 	 call sequence.
 	 Also do the adjustments before a throwing call, otherwise
 	 exception handling can fail; PR 19225. */
-      if (pending_stack_adjust >= 32
+      if (pending_stack_adjust >= 8
 	  || (pending_stack_adjust > 0
 	      && (flags & ECF_MAY_BE_ALLOCA))
 	  || (pending_stack_adjust > 0
diff -urN gcc-4.6.4-clean/gcc/config/m6809/crt0.S gcc-4.6.4/gcc/config/m6809/crt0.S
--- gcc-4.6.4-clean/gcc/config/m6809/crt0.S	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/crt0.S	2017-11-29 17:11:09.221248469 -0700
@@ -0,0 +1,182 @@
+;;;
+;;; Copyright 2006, 2007, 2008, 2009 by Brian Dominy <brian@oddchange.com>
+;;;
+;;; This file is part of GCC.
+;;;
+;;; GCC is free software; you can redistribute it and/or modify
+;;; it under the terms of the GNU General Public License as published by
+;;; the Free Software Foundation; either version 3, or (at your option)
+;;; any later version.
+;;;
+;;; GCC is distributed in the hope that it will be useful,
+;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;;; GNU General Public License for more details.
+
+;;; You should have received a copy of the GNU General Public License
+;;; along with GCC; see the file COPYING3.  If not see
+;;; <http://www.gnu.org/licenses/>.
+
+	/* Declare external for main() */
+	.globl	_main
+
+/* The startup is heavily dependent on the type of machine and
+OS environment that is available at the start point.
+For the most part, the general idea is the same across machines,
+but the implementation is vastly different.  This is managed via
+conditional compiles throughout the startup code for each of the
+supported machines. */
+
+#if defined(TARGET_COCO) /* CoCo memory map */
+
+#define COCO_RAMROM_MODE 0xFFDE
+#define COCO_ALLRAM_MODE 0xFFDF
+#define COCO_PAGE1 0xFFD5
+
+/* SAM M1 and M0 adjusts the memory size */
+
+#define BASIC_WARMSTART_FLAG 0x0071
+#define BASIC_START 0xA027
+
+#define __STACK_TOP 0x6800
+
+#elif defined(TARGET_PROTO) /* Prototype hardware. Customisation of this section is expected! */
+
+#define __STACK_TOP 0x8000
+
+#else /* Simulator (default) memory map */
+
+#define SIM_EXIT_REG 0xFF01
+
+#define __STACK_TOP 0xFE00
+
+#endif
+
+	.area	.data
+	.area	.ctors
+	.area	.dtors
+	.area	.bss
+
+	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	;;;
+	;;; __exit : Exit point from the program
+	;;; For simulation, this writes to a special I/O register that
+	;;; the simulator interprets as end-of-program.
+	;;;
+	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area	.text
+ 	.globl	__exit
+__exit:
+#if defined(TARGET_COCO)
+	;; Go back to ROM/RAM mode
+	sta	COCO_RAMROM_MODE
+	clr	BASIC_WARMSTART_FLAG
+	jmp	BASIC_START
+#elif defined(TARGET_PROTO) /* Prototype hardware. Customisation of this section is expected! */
+	tfr	x,d
+__ex@0	bra	__ex@0
+#else /* Simulator */
+	tfr	x,d
+	stb	SIM_EXIT_REG
+	bra	__exit
+#endif
+
+	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	;;;
+	;;; __start : Entry point to the program
+	;;;
+	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area	.text
+	.globl	__start
+__start:
+
+#if defined(HAVE_DIRECT)
+	;; Initialize the direct page pointer
+	lda	#<s_.direct
+	tfr	a,dp
+#endif
+
+#if defined(TARGET_COCO)
+	;; Turn off interrupts
+	orcc #(0x10|0x40)
+
+	;; Setup All RAM Mode
+	sta COCO_ALLRAM_MODE
+#endif
+
+	;; Initialize the stack. NMI works after this point.
+	lds	#__STACK_TOP - 2
+
+	;; Set up hardware; console device, video etc
+#if defined(TARGET_PROTO) /* Prototype hardware. Customisation of this section is expected! */
+	lbsr	_initialise_hardware
+#endif
+
+	;; Call any constructors that may be present
+	ldu	#s_.ctors
+__ctors_loop:
+	ldy	,u++
+	cmpy	#0
+	beq	__ctors_done
+	jsr	,y
+	bra	__ctors_loop
+__ctors_done:
+
+	;; Enable interrupts if not on COCO
+#if !defined(TARGET_COCO)
+	andcc	#~(0x10|0x40)
+#endif
+
+	;; Set up the environment
+	ldu	#s_.bss
+
+	;; Set up argc/argv arrays
+
+	;; Call the main function.  The exit code will
+	;; be returned in the X register, unless compiled
+	;; with -mdret, in which case it comes back in D.
+	jsr	_main
+
+	;; Call any destructors
+	ldu	#s_.dtors
+__dtors_loop:
+	ldy	,u++
+	cmpy	#0
+	beq	__dtors_done
+	jsr	,y
+	bra	__dtors_loop
+__dtors_done:
+
+	;; If main returns, then invoke _*exit() to stop the program
+	;; The C library doesn't support -mdret yet, so move the
+	;; argument first.
+#if defined(__DRET__)
+	tfr	d,x
+#endif
+	;; The newlib exit() is an absolute pig. In calling __call_exitprocs(), it brings with
+	;; it the kitchen sink, notably malloc() and friends which are *enormous*.
+	jmp	__exit
+
+	;;;
+	;;; __crt0_vector : Default handler for interrupts
+	;;;
+	.area	.text
+___crt0_vector:
+	;; The default behavior is to simply ignore all
+	;; non-reset interrupts.
+	rti
+
+	;;;
+	;;; vector : The interrupt vector table
+	;;; The linker will ensure that this gets loaded at address 0xFFF0.
+	;;;
+	.area	vector
+vectors:
+	.word	___crt0_vector
+	.word	___crt0_vector
+	.word	___crt0_vector
+	.word	___crt0_vector
+	.word	___crt0_vector
+	.word	___crt0_vector
+	.word	___crt0_vector
+	.word	__start
diff -urN gcc-4.6.4-clean/gcc/config/m6809/libgcc1.s gcc-4.6.4/gcc/config/m6809/libgcc1.s
--- gcc-4.6.4-clean/gcc/config/m6809/libgcc1.s	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/libgcc1.s	2017-11-28 21:12:11.152911619 -0700
@@ -0,0 +1,511 @@
+/* libgcc routines for m6809
+   Copyright (C) 2006 Free Software Foundation, Inc.
+
+This file is part of GCC.
+
+GCC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 3, or (at your option)
+any later version.
+
+GCC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with GCC; see the file COPYING3.  If not see
+<http://www.gnu.org/licenses/>.  */
+
+/* As a special exception, if you link this library with other files,
+   some of which are compiled with GCC, to produce an executable,
+   this library does not by itself cause the resulting executable
+   to be covered by the GNU General Public License.
+   This exception does not however invalidate any other reasons why
+   the executable file might be covered by the GNU General Public License.  */
+
+
+#define SIGFPE jmp _abort
+
+
+	; Shift functions
+	; On input, D is value to be shifted, and X has shift count.
+	; Result is also in D.
+
+#ifdef L_ashlhi3
+	.area .text
+	.globl _ashlhi3
+_ashlhi3:
+	pshs	x
+1$:
+	leax	-1,x
+	cmpx	#-1
+	beq	2$
+	aslb
+	rola
+	bra	1$
+2$:
+	puls	x,pc
+#endif
+
+#ifdef L_ashrhi3
+	.area .text
+	.globl _ashrhi3
+_ashrhi3:
+	pshs	x
+1$:
+	leax	-1,x
+	cmpx	#-1
+	beq	2$
+	asra
+	rorb
+	bra	1$
+2$:
+	puls	x,pc
+#endif
+
+
+#ifdef L_lshrhi3
+	.area .text
+	.globl _lshrhi3
+_lshrhi3:
+	pshs	x
+1$:
+	leax	-1,x
+	cmpx	#-1
+	beq	2$
+	lsra
+	rorb
+	bra	1$
+2$:
+	puls	x,pc
+#endif
+
+
+
+#ifdef L_softregs
+	.area		direct
+	.globl	m0, m1, m2, m3, m4, m5, m6, m7
+	.globl	m8, m9, m10, m11, m12, m13, m14, m15
+m0: .blkb 1
+m1: .blkb 1
+m2: .blkb 1
+m3: .blkb 1
+m4: .blkb 1
+m5: .blkb 1
+m6: .blkb 1
+m7: .blkb 1
+m8: .blkb 1
+m9: .blkb 1
+m10: .blkb 1
+m11: .blkb 1
+m12: .blkb 1
+m13: .blkb 1
+m14: .blkb 1
+m15: .blkb 1
+#endif
+
+
+#ifdef L_ashlsi3_one
+	.area		.text
+	.globl	_ashlsi3_one
+_ashlsi3_one:
+	asl	3,x
+	rol	2,x
+	rol	1,x
+	rol	,x
+	rts
+#endif
+
+#ifdef L_ashlsi3
+	/* X points to the SImode (source/dest)
+		B is the count */
+_ashlsi3:
+	pshs	u
+	cmpb	#16
+	blt	try8
+	subb	#16
+	; Shift by 16
+	ldu	2,x
+	stu	,x
+try8:
+	cmpb	#8
+	blt	try_rest
+	subb	#8
+	; Shift by 8
+
+try_rest:
+	tstb
+	beq	done
+do_rest:
+	; Shift by 1
+	asl	3,x
+	rol	2,x
+	rol	1,x
+	rol	,x
+	decb
+	bne	do_rest
+done:
+	puls	u,pc
+#endif
+
+#ifdef L_ashrsi3_one
+	.area		.text
+	.globl	_ashlsi3_one
+_ashrsi3_one:
+	asr	,x
+	ror	1,x
+	ror	2,x
+	ror	3,x
+	rts
+#endif
+
+
+#ifdef L_lshrsi3_one
+	.area		.text
+	.globl	_lshrsi3_one
+_lshrsi3_one:
+	lsr	,x
+	ror	1,x
+	ror	2,x
+	ror	3,x
+	rts
+#endif
+
+
+#ifdef L_clzsi2
+	.area .text
+	.globl ___clzhi2
+	; Input: X = 16-bit unsigned integer
+	; Output: X = number of leading zeros
+	; This function destroys the value in D.
+___clzhi2:
+	pshs	x
+	; Find the offset of the leftmost '1' bit in
+	; the left half of the word.
+	;
+	; Bits are numbered in the table with 1 meaning the
+	; LSB and 8 meaning the MSB.
+	;
+	; If nonzero, then clz is 8-a.
+	tfr	x,d
+	ldx	#___clz_tab
+	tfr	a,b
+	clra
+	ldb	d,x
+	bne	upper_bit_set
+
+lower_bit_set:
+	; If the upper byte is zero, then check the lower
+	; half of the word.  Return 16-a.
+	puls	d
+	clra
+	ldb	d,x
+	negb
+	addb	#16
+	bra	done
+
+upper_bit_set:
+	negb
+	addb	#8
+	puls	x
+
+done:
+	tfr	d,x
+	puls	pc
+#endif
+
+#ifdef L_clzdi2
+	.area .text
+	.globl ___clzsi2
+	; Input: 32-bit unsigned integer is on the stack, just
+	; above the return address
+	; Output: X = number of leading zeros
+___clzsi2:
+	; Check the upper 16-bit word
+	; If it is not zero, then return clzhi2(X).
+	; A branch can be used instead of a call since no
+	; postprocessing is needed.  Use long branch form
+	; though since functions may not be near each other.
+	ldx	2,s
+	lbne	___clzhi2
+	ldx	4,s
+	jsr	___clzhi2
+	leax	16,x
+	rts
+#endif
+
+#ifdef L_ctzsi2
+	.area .text
+	.globl ___ctzhi2
+	; Input: X = 16-bit unsigned integer
+	; Output: X = number of trailing zeros
+	; F(x) = 15 - clzhi2(X & -x)
+	; This function destroys the value in D.
+___ctzhi2:
+	tfr	x,d
+	coma
+	comb
+	addd	#1
+	pshs	a
+	pshs	b
+	tfr	x,d
+	andb	,s+
+	anda	,s+
+	tfr	d,x
+	jsr	___clzhi2
+	tfr	x,d
+	subd	#16
+	coma
+	comb
+	tfr	d,x
+	rts
+#endif
+
+
+#ifdef L_ctzdi2
+	.area .text
+	.globl ___ctzsi2
+	; Input: 32-bit unsigned integer is on the stack, just
+	; above the return address
+	; Output: X = number of leading zeros
+___ctzsi2:
+	; Check the lower 16-bit word
+	; If it is not zero, then return ctzhi2(X).
+	; A branch can be used instead of a call since no
+	; postprocessing is needed.  Use long branch form
+	; though since functions may not be near each other.
+	ldx	4,s
+	lbne	___ctzhi2
+	ldx	2,s
+	jsr	___ctzhi2
+	leax	16,x
+	rts
+#endif
+
+
+#ifdef L_mulhi3
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+;;; ___mulhi3 - signed/unsigned multiply
+;;; Called by GCC to implement 16x16 multiplication
+;;; Arguments: Two 16-bit values, one in stack, one in X.
+;;; Result: 16-bit result in X
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area .text
+	.globl _mulhi3
+_mulhi3:
+	pshs	x
+	lda   5,s   ; left msb * right lsb * 256
+	ldb   ,s
+	mul
+	tfr   b,a
+	clrb
+	tfr   d,x
+	ldb   1,s   ; left lsb * right msb * 256
+	lda   4,s
+	mul
+	tfr   b,a
+	clrb
+	leax  d,x
+	ldb   1,s   ; left lsb * right lsb
+	lda   5,s
+	mul
+	leax  d,x
+	puls	d,pc  ; kill D to remove initial push
+#endif
+
+
+#ifdef L_divhi3
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+;;; ___divhi3 - signed division
+;;; Arguments: Dividend in X, divisor on the stack
+;;; Returns result in X.
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area .text
+	.globl _divhi3
+_divhi3:
+	ldd	2,s
+	bne	do_div		; check dividend
+	SIGFPE
+do_div:
+	pshs	x
+	jsr	_seuclid
+	puls	x,pc
+#endif
+
+
+#ifdef L_modhi3
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+;;; ___modhi3 - signed modulo
+;;; Arguments: Dividend in X, divisor on the stack
+;;; Returns result in X.
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area .text
+	.globl _modhi3
+_modhi3:
+	ldd	2,s
+	bne	do_mod		; check dividend
+	SIGFPE
+do_mod:
+	pshs	x
+	jsr	_seuclid
+	leas	2,s
+	tfr	d,x
+	rts
+#endif
+
+
+
+#ifdef L_udivhi3
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+;;; ___udivhi3 - unsigned division
+;;; Arguments: Dividend in X, divisor on the stack
+;;; Returns result in X.
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area .text
+	.globl _udivhi3
+_udivhi3:
+	ldd	2,s
+	bne	do_udiv		; check dividend
+	SIGFPE
+do_udiv:
+	pshs	x
+	jsr	_euclid
+	puls	x,pc
+#endif
+
+
+#ifdef L_umodhi3
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+;;; ___umodhi3 - unsigned modulo
+;;; Arguments: Dividend in X, divisor on the stack
+;;; Returns result in X.
+;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+	.area .text
+	.globl _umodhi3
+_umodhi3:
+	ldd	2,s
+	bne	do_umod		; check dividend
+	SIGFPE
+do_umod:
+	pshs	x
+	jsr	_euclid
+	leas	2,s
+	tfr	d,x
+	rts
+#endif
+
+
+#ifdef L_euclid
+;	unsigned euclidean division
+;	calling: (left / right)
+;		push left
+;		ldd right
+;		jsr _euclid
+;	quotient on the stack (left)
+;	modulus in d
+
+	.area	.text
+	.globl	_euclid
+	left=5
+	right=1			; word
+	count=0			; byte
+	CARRY=1			; alias
+_euclid:
+	leas	-3,s		; 2 local variables
+	clr	count,s		; prescale divisor
+	inc	count,s
+	tsta
+presc:
+	bmi	presc_done
+	inc	count,s
+	aslb
+	rola
+	bra	presc
+presc_done:
+	std	right,s
+	ldd	left,s
+	clr	left,s		; quotient = 0
+	clr	left+1,s
+mod1:
+	subd	right,s		; check subtract
+	bcc	mod2
+	addd	right,s
+	andcc	#~CARRY
+	bra	mod3
+mod2:
+	orcc	#CARRY
+mod3:
+	rol	left+1,s	; roll in carry
+	rol	left,s
+	lsr	right,s
+	ror	right+1,s
+	dec	count,s
+	bne	mod1
+	leas	3,s
+	rts
+#endif
+
+#ifdef L_seuclid
+;	signed euclidean division
+;	calling: (left / right)
+;		push left
+;		ldd right
+;		jsr _seuclid
+;	quotient on the stack (left)
+;	modulus in d
+	.area	.text
+	.globl	_seuclid
+	left=6
+	right=2
+	quot_sign=1
+	mod_sign=0
+_seuclid:
+	leas	-4,s		; 3 local variables
+	std	right,s
+	clr	mod_sign,s
+	clr	quot_sign,s
+	ldd	left,s
+	bge	mod_abs
+	inc	mod_sign,s	; sign(mod) = sign(left)
+	inc	quot_sign,s
+	bsr	negd		; abs(left) -> D
+mod_abs:
+	pshs	b,a		; push abs(left)
+	ldd	right+2,s	; all references shifted by 2
+	bge	quot_abs
+	dec	quot_sign+2,s	; sign(quot) = sign(left) XOR sign(right)
+	bsr	negd		; abs(right) -> D
+quot_abs:
+	jsr	_euclid		; call (unsigned) euclidean division
+	std	right+2,s
+	puls	a,b		; quot -> D
+	tst	quot_sign,s	; all references no longer shifted
+	beq	quot_done
+	bsr	negd
+quot_done:
+	std	left,s		; quot -> left
+	ldd	right,s
+	tst	mod_sign,s
+	beq	mod_done
+	bsr	negd
+mod_done:
+	leas	4,s		; destroy stack frame
+	rts
+
+negd:				; self-explanatory !
+	nega
+	negb
+	sbca	#0
+	rts
+#endif
+
+
+
+#ifdef L_pending_addsi3
+_addsi3:
+	rts
+#endif /* L_pending_addsi3 */
+
+
+
diff -urN gcc-4.6.4-clean/gcc/config/m6809/m6809.c gcc-4.6.4/gcc/config/m6809/m6809.c
--- gcc-4.6.4-clean/gcc/config/m6809/m6809.c	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/m6809.c	2017-11-29 17:11:09.221248469 -0700
@@ -0,0 +1,3027 @@
+/*-------------------------------------------------------------------
+	FILE: m6809.c
+-------------------------------------------------------------------*/
+/* Subroutines for insn-output.c for MC6809.
+   Copyright (C) 1989-2007 Free Software Foundation, Inc.
+
+ MC6809 Version by Tom Jones (jones@sal.wisc.edu)
+ Space Astronomy Laboratory
+ University of Wisconsin at Madison
+
+ minor changes to adapt it to gcc-2.5.8 by Matthias Doerfel
+ ( msdoerfe@informatik.uni-erlangen.de )
+ also added #pragma interrupt (inspired by gcc-6811)
+
+ minor changes to adapt it to gcc-2.8.0 by Eric Botcazou
+ (ebotcazou@multimania.com)
+
+ minor changes to adapt it to gcc-2.95.3 by Eric Botcazou
+ (ebotcazou@multimania.com)
+
+ major cleanup, improvements, and upgrade to gcc 3.4 by Brian Dominy
+ (brian@oddchange.com)
+
+ additional adjustments, etc., for gcc 4.6.1 by William Astle (lost@l-w.ca)
+
+This file is part of GCC.
+
+GCC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 3, or (at your option)
+any later version.
+
+GCC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with GCC; see the file COPYING3.  If not see
+<http://www.gnu.org/licenses/>.  */
+
+#include <string.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/timeb.h>
+#include <stdio.h>
+#include "config.h"
+#include "system.h"
+#include "coretypes.h"
+#include "tm.h"
+#include "tree.h"
+#include "rtl.h"
+#include "tm_p.h"
+#include "regs.h"
+#include "flags.h"
+#include "hard-reg-set.h"
+#include "real.h"
+#include "tree.h"
+#include "insn-config.h"
+#include "conditions.h"
+#include "insn-flags.h"
+#include "output.h"
+#include "insn-attr.h"
+#include "function.h"
+#include "target.h"
+#include "target-def.h"
+#include "expr.h"
+#include "recog.h"
+#include "cpplib.h"
+#include "c-family/c-pragma.h"
+#include "c-family/c-common.h"
+#include "toplev.h"
+#include "optabs.h"
+#include "version.h"
+#include "df.h"
+#include "rtlhooks-def.h"
+
+/* macro to return TRUE if length of operand mode is one byte */
+#define BYTE_MODE(X) ((GET_MODE_SIZE (GET_MODE (X))) == 1)
+
+
+/* REAL_REG_P(x) is a true if the rtx 'x' represents a real CPU
+register and not a fake one that is emulated in software. */
+#define REAL_REG_P(x) (REG_P(x) && !M_REG_P(x))
+
+/*-------------------------------------------------------------------
+    Target hooks, moved from target.h
+-------------------------------------------------------------------*/
+static void m6809_encode_section_info (tree decl, rtx rtl, int new_decl_p ATTRIBUTE_UNUSED);
+
+#undef TARGET_ENCODE_SECTION_INFO
+#define TARGET_ENCODE_SECTION_INFO m6809_encode_section_info
+
+#undef TARGET_ASM_FILE_START
+#define TARGET_ASM_FILE_START m6809_asm_file_start
+
+#undef TARGET_ASM_ALIGNED_HI_OP
+#define TARGET_ASM_ALIGNED_HI_OP "\t.word\t"
+
+#undef TARGET_ASM_ALIGNED_SI_OP
+#define TARGET_ASM_ALIGNED_SI_OP NULL
+
+#undef TARGET_ASM_UNALIGNED_HI_OP
+#define TARGET_ASM_UNALIGNED_HI_OP "\t.word\t"
+
+#undef TARGET_ASM_UNALIGNED_SI_OP
+#define TARGET_ASM_UNALIGNED_SI_OP NULL
+
+#undef TARGET_RTX_COSTS
+#define TARGET_RTX_COSTS m6809_rtx_costs
+
+#undef TARGET_ATTRIBUTE_TABLE
+#define TARGET_ATTRIBUTE_TABLE m6809_attribute_table
+
+#undef TARGET_INIT_BUILTINS
+#define TARGET_INIT_BUILTINS m6809_init_builtins
+
+#undef TARGET_EXPAND_BUILTIN
+#define TARGET_EXPAND_BUILTIN m6809_expand_builtin
+
+#undef TARGET_DEFAULT_TARGET_FLAGS
+#define TARGET_DEFAULT_TARGET_FLAGS (MASK_REG_ARGS | MASK_DIRECT)
+
+#undef TARGET_FUNCTION_OK_FOR_SIBCALL
+#define TARGET_FUNCTION_OK_FOR_SIBCALL m6809_function_ok_for_sibcall
+
+#undef TARGET_ASM_TRAMPOLINE_TEMPLATE
+#define TARGET_ASM_TRAMPOLINE_TEMPLATE m6809_asm_trampoline_template
+
+#undef TARGET_TRAMPOLINE_INIT
+#define TARGET_TRAMPOLINE_INIT m6809_initialize_trampoline
+
+#undef TARGET_FRAME_POINTER_REQUIRED
+#define TARGET_FRAME_POINTER_REQUIRED m6809_frame_pointer_required
+
+#undef TARGET_OPTION_OVERRIDE
+#define TARGET_OPTION_OVERRIDE m6809_override_options
+
+/* External variables used */
+extern int reload_completed;   /* set in toplev.c */
+extern FILE *asm_out_file;
+
+static int last_mem_size;   /* operand size (bytes) */
+
+/* True if the section was recently changed and another .area
+ * directive needs to be output before emitting the next label. */
+int section_changed = 0;
+
+/* Section names.  The defaults here are used until an
+ * __attribute__((section)) is seen that changes it. */
+char code_section_op[128] = "\n\t.area\t.text";
+char data_section_op[128] = "\n\t.area\t.data";
+char bss_section_op[128] = "\n\t.area\t.bss";
+const char *code_bank_option = 0;
+
+/* TRUE if the direct mode prefix might be valid in this context.
+ * This is set by 'print_address' prior to calling output_addr_const,
+ * which performs into 'print_direct_prefix' to do the final checks. */
+static int check_direct_prefix_flag;
+
+/* Nonzero if an address is being printed in a context which does not
+ * permit any PIC modifications to the address */
+static int pic_ok_for_addr_p = 1;
+
+/* Current code page.  This supports machines which can do bank
+ * switching to allow for more than 64KB of code/data. */
+char far_code_page[64];
+
+/* Current bank name */
+static char current_bank_name[8] = "-1";
+
+/* Default bank name */
+static char default_code_bank_name[8] = "-1";
+
+/* Direct memory reserved as soft registers */
+unsigned int m6809_soft_regs = 0;
+
+/* ABI version */
+unsigned int m6809_abi_version = M6809_ABI_VERSION_REGS;
+
+
+/**
+ * Called after options have been parsed.
+ * If overrides have been specified on the command-line, then
+ * these values are copied into the main storage variables.
+ */
+void
+m6809_override_options (void)
+{
+	/* Handle -mfar-code-page */
+	if (far_code_page_option == 0)
+		far_code_page_option = "__default_code_page";
+	strcpy (far_code_page, far_code_page_option);
+
+	/* Handle -mcode-section, -mdata-section, and -mbss-section */
+	if (code_section_ptr != 0)
+		sprintf (code_section_op, "\t.area\t%s", code_section_ptr);
+	if (data_section_ptr != 0)
+		sprintf (data_section_op, "\t.area\t%s", data_section_ptr);
+	if (bss_section_ptr != 0)
+		sprintf (bss_section_op, "\t.area\t%s", bss_section_ptr);
+
+	/* Handle -mcode-bank */
+	if (code_bank_option != 0)
+		sprintf (default_code_bank_name, "%s", code_bank_option);
+
+	/* Handle -mabi-version or -mno-reg-args */
+	if (m6809_abi_version_ptr != 0)
+	{
+		if (!strcmp (m6809_abi_version_ptr, "stack"))
+			m6809_abi_version = M6809_ABI_VERSION_STACK;
+		else if (!strcmp (m6809_abi_version_ptr, "regs"))
+			m6809_abi_version = M6809_ABI_VERSION_REGS;
+		else if (!strcmp (m6809_abi_version_ptr, "bx"))
+			m6809_abi_version = M6809_ABI_VERSION_BX;
+		else if (!strcmp (m6809_abi_version_ptr, "latest"))
+			m6809_abi_version = M6809_ABI_VERSION_LATEST;
+		else
+			m6809_abi_version = atoi (m6809_abi_version_ptr);
+	}
+
+	/* The older -mno-reg-args option is deprecated, and treated
+	as -mabi=stack. */
+	if (!TARGET_REG_ARGS)
+   {
+      warning (WARNING_OPT "-mno-reg-args deprecated; use -mabi=stack instead.");
+      m6809_abi_version = M6809_ABI_VERSION_STACK;
+   }
+
+	/* -fexceptions is unsupported */
+	flag_exceptions = 0;
+	flag_non_call_exceptions = 0;
+	flag_unwind_tables = 0;
+}
+
+
+/**
+ * Output prefix that directs the assembler to use a direct-mode
+ * instruction if globally enabled, address is a symbol, and symbol
+ * has been marked as in direct page.  Also, never do this if
+ * using the indirect mode. */
+void
+print_direct_prefix (FILE * file, rtx addr)
+{
+	if (TARGET_DIRECT &&
+       (GET_CODE (addr) == SYMBOL_REF) && 
+       SYMBOL_REF_FLAG (addr) &&
+       check_direct_prefix_flag)
+   {
+      putc ('*', file);
+   }
+}
+
+
+/** Prints an operand (that is not an address) in assembly from RTL. */
+void
+print_operand (FILE * file, rtx x, int code)
+{
+	if (REG_P (x)) {
+		/* gcc currently allocates the entire 16-bit 'd' register
+		 * even when it only needs an 8-bit value.  So here it
+		 * is tricked into printing only the lower 8-bit 'b'
+		 * register into the assembly output.
+		 *
+		 * Eventually gcc should be modified to allocate a/b
+		 * independently and this hack can be removed.
+		 *
+		 * Occasionally, we may want to do an operation using
+		 * the 'a' register instead of 'b'; use the 'A' code
+		 * to specify that.
+		 */
+		if (code == 'A')
+			fputs ("a", file);
+		else if ((BYTE_MODE (x)) && (REGNO (x) == HARD_D_REGNUM))
+			fputs ("b", file);
+		else if (M_REG_P (x) && code == 'L')
+			/* Soft registers can be treated like memory and accessed
+			 * at a particular offset. TODO : handle 'W' */
+			fputs (reg_names[REGNO (x)+1], file);
+		else
+			fputs (reg_names[REGNO (x)], file);
+	}
+
+	else if (MEM_P (x)) {
+		last_mem_size = GET_MODE_SIZE (GET_MODE (x));
+		if (code == 'L') {	/* LSH of word address */
+			if (GET_CODE (XEXP (x, 0)) == MEM)
+			{
+				/* Offseting an indirect addressing mode is not supported */
+				error ("expression too complex for 6809 (offset indirect mode)");
+				debug_rtx (x);
+			}
+			else
+				x = adjust_address (x, QImode, 1);
+		}
+		else if (code == 'M') { /* MSH of word address */
+			if (GET_CODE (XEXP (x, 0)) == MEM)
+			{
+				/* Offseting an indirect addressing mode is not supported */
+				error ("expression too complex for 6809 (offset indirect mode)");
+				debug_rtx (x);
+			}
+			else
+				x = adjust_address (x, QImode, 0);
+		}
+		else if (code == 'W') { /* least significant half of 32-bit */
+			x = adjust_address (x, HImode, 2);
+		}
+
+		pic_ok_for_addr_p = (code != 'C');
+		output_address (XEXP (x, 0));
+	}
+
+	else if (GET_CODE (x) == CONST_DOUBLE && GET_MODE (x) != DImode) {
+		union { double d; int i[2]; } u;
+		u.i[0] = CONST_DOUBLE_LOW (x);
+		u.i[1] = CONST_DOUBLE_HIGH (x);
+		fprintf (file, "#%#9.9g", u.d);
+	}
+
+	else if (code == 'R') {
+		fprintf (file, "%s", 
+			m6809_get_regs_printable (INTVAL (x)));
+	}
+
+	else {
+		if (code == 'L') {	/* LSH of word address */
+			x = gen_rtx_CONST_INT (VOIDmode, (INTVAL(x) & 0xff));
+		}
+		else if (code == 'M') {	/* MSH of word address */
+			x = gen_rtx_CONST_INT (VOIDmode, ((INTVAL(x) >> 8) & 0xff));
+		}
+
+		putc ('#', file);
+		output_addr_const (file, x);
+	}
+}
+
+
+/** Prints an address operand to assembler from its RTL representation. */
+void
+print_operand_address (FILE *file, rtx addr)
+{
+	register rtx base = 0;
+	register rtx offset = 0;
+	int regno;
+	int indirect_flag = 0;
+
+	check_direct_prefix_flag = 0;
+
+	/*** check for indirect addressing ***/
+	if (MEM_P (addr)) {
+		last_mem_size = GET_MODE_SIZE (GET_MODE (addr));
+		addr = XEXP (addr, 0);
+		if (pic_ok_for_addr_p)
+		{
+			indirect_flag = 1;
+			fprintf (file, "[");
+		}
+	}
+
+
+	switch (GET_CODE (addr)) {
+		case REG:
+			regno = REGNO (addr);
+			fprintf (file, ",%s", reg_names[regno]);
+			break;
+
+		case PRE_DEC:
+			regno = REGNO (XEXP (addr, 0));
+			fputs (((last_mem_size == 1) ? ",-" : ",--"), file);
+			fprintf (file, "%s", reg_names[regno]);
+			break;
+
+		case POST_INC:
+			regno = REGNO (XEXP (addr, 0));
+			fprintf (file, ",%s", reg_names[regno]);
+			fputs (((last_mem_size == 1) ? "+" : "++"), file);
+			break;
+
+		case PLUS:
+			base = XEXP (addr, 0);
+			if (MEM_P (base))
+				base = XEXP (base, 0);
+
+			offset = XEXP (addr, 1);
+			if (MEM_P (offset))
+				offset = XEXP (offset, 0);
+
+			if ((CONSTANT_ADDRESS_P (base)) && (CONSTANT_ADDRESS_P (offset))) {
+				if (!indirect_flag)
+					check_direct_prefix_flag = 1;
+				output_addr_const (file, base);
+				check_direct_prefix_flag = 0;
+				fputs ("+", file);
+				output_addr_const (file, offset);
+			}
+
+			else if ((CONSTANT_ADDRESS_P (base)) && (A_REG_P (offset))) {
+				output_addr_const (file, base);
+				fprintf (file, ",%s", reg_names[REGNO (offset)]);
+			}
+
+			else if ((CONSTANT_ADDRESS_P (offset)) && (A_REG_P (base))) {
+				output_addr_const (file, offset);
+				fprintf (file, ",%s", reg_names[REGNO (base)]);
+			}
+
+			/*** accumulator offset ***/
+			else if (((D_REG_P (offset)) || (Q_REG_P (offset)))
+			&& (A_REG_P (base))) {
+				fprintf (file, "%s,%s",
+				reg_names[REGNO (offset)], reg_names[REGNO (base)]);
+			}
+
+			else if (((D_REG_P (base)) || (Q_REG_P (base)))
+			&& (A_REG_P (offset))) {
+				fprintf (file, "%s,%s",
+				reg_names[REGNO (base)], reg_names[REGNO (offset)]);
+			}
+
+			else if (GET_CODE (base) == PRE_DEC) {
+				regno = REGNO (XEXP (base, 0));
+				fputs (((last_mem_size == 1) ? ",-" : ",--"), file);
+				fprintf (file, "%s", reg_names[regno]);
+			}
+
+			else
+				abort ();
+
+			break;
+
+   default:
+		/* Set this global before calling output_addr_const() */
+		if (!indirect_flag)
+			check_direct_prefix_flag = 1;
+
+		/* When printing a SYMBOL_REF in PIC mode, do not print the leading
+		 * '#' and follow it by ',pcr' to enable relative addressing. */
+		if (flag_pic && pic_ok_for_addr_p && GET_CODE (addr) == SYMBOL_REF)
+		{
+			ASM_OUTPUT_SYMBOL_REF (file, addr);
+			fputs (",pcr", file);
+			pic_ok_for_addr_p = 1;
+		}
+		else
+		{
+      	output_addr_const (file, addr);
+		}
+
+		check_direct_prefix_flag = 0;
+      break;
+	}
+
+	if (indirect_flag)
+		fprintf (file, "]");
+}
+
+/*-------------------------------------------------------------------
+    Update the CC Status
+---------------------------------------------------------------------
+   Set the cc_status for the results of an insn whose pattern is EXP.
+   We assume that jumps don't affect the condition codes.
+   All else, clobbers the condition codes, by assumption.
+
+   We assume that ALL add, minus, etc. instructions effect the condition
+   codes.
+-------------------------------------------------------------------*/
+void
+notice_update_cc (rtx exp, rtx insn ATTRIBUTE_UNUSED)
+{
+	int src_code;
+	int dst_code;
+
+	/*** recognize SET insn's ***/
+	if (GET_CODE (exp) == SET)
+	{
+		src_code = GET_CODE (SET_SRC (exp));
+		dst_code = GET_CODE (SET_DEST (exp));
+
+		/* Jumps do not alter the cc's.  */
+		if (SET_DEST (exp) == pc_rtx)
+			return;
+
+		/* Moving one register into another register (tfr):
+		Doesn't alter the cc's.  */
+		if (REG_P (SET_DEST (exp)) && (REG_P (SET_SRC (exp))))
+			return;
+
+		/* Moving memory into a register (load): Sets cc's. */
+		if (REG_P (SET_DEST (exp)) && src_code == MEM) {
+			cc_status.value1 = SET_SRC (exp);
+			cc_status.value2 = SET_DEST (exp);
+			cc_status.flags |= CC_NO_OVERFLOW;
+			return;
+		}
+
+		/* Moving register into memory (store): Sets cc's. */
+		if (dst_code == MEM && REG_P (SET_SRC (exp))) {
+			cc_status.value1 = SET_SRC (exp);
+			cc_status.value2 = SET_DEST (exp);
+			cc_status.flags |= CC_NO_OVERFLOW;
+			return;
+		}
+
+		/* Function calls clobber the cc's.  */
+		else if (GET_CODE (SET_SRC (exp)) == CALL) {
+			CC_STATUS_INIT;
+			return;
+		}
+
+		/* Tests and compares set the cc's in predictable ways.  */
+		else if (SET_DEST (exp) == cc0_rtx)
+		{
+			cc_status.flags = 0;
+			cc_status.value1 = SET_SRC (exp);
+			cc_status.value2 = SET_DEST (exp);
+			return;
+		}
+
+		else if (A_REG_P (SET_DEST (exp)))
+		{
+			CC_STATUS_INIT;
+			return;
+		}
+
+		else
+		{
+			/* Certain instructions affect the condition codes. */
+			switch (src_code)
+			{
+				case PLUS:
+				case MINUS:
+				case NEG:
+				case ASHIFT:
+					/* These instructions set the condition codes,
+					 * and may modify the V bit. */
+					cc_status.flags |= CC_NO_OVERFLOW;
+					/* FALLTHRU */
+
+				case AND:
+				case IOR:
+				case XOR:
+				case ASHIFTRT:
+				case LSHIFTRT:
+					/* These instructions set the condition codes,
+					 * but cannot overflow (V=0). */
+					cc_status.value1 = SET_SRC (exp);
+					cc_status.value2 = SET_DEST (exp);
+					break;
+
+				default:
+					/* Everything else is clobbered */
+					CC_STATUS_INIT;
+			}
+			return;
+		}
+	} /* SET */
+
+	else if (GET_CODE (exp) == PARALLEL
+		&& GET_CODE (XVECEXP (exp, 0, 0)) == SET)
+	{
+		if (SET_DEST (XVECEXP (exp, 0, 0)) == pc_rtx)
+			return;
+		if (SET_DEST (XVECEXP (exp, 0, 0)) == cc0_rtx)
+		{
+			CC_STATUS_INIT;
+			cc_status.value1 = SET_SRC (XVECEXP (exp, 0, 0));
+			return;
+		}
+	}
+
+	/*** default action if we haven't recognized something
+	and returned earlier ***/
+	CC_STATUS_INIT;
+}
+
+
+/** Returns nonzero if the expression EXP can be implemented using one
+ * of the 6809's single operand instructions. */
+int
+m6809_single_operand_operator (rtx exp)
+{
+	rtx op1;
+	HOST_WIDE_INT val;
+	enum rtx_code code;
+
+	debug_rtx(exp);
+
+	code = GET_CODE (exp);
+
+	/* Unary operators always qualify */
+	switch (code)
+	{
+		case NEG:
+		case NOT:
+			return 1;
+
+		default:
+			break;
+	}
+
+	/* Binary operators can only qualify if the second
+	 * argument is a CONST_INT of certain value. */
+	op1 = XEXP (exp, 1);
+	if (GET_CODE (op1) != CONST_INT)
+		return 0;
+	val = INTVAL (op1);
+	switch (code)
+	{
+		case PLUS:
+		case MINUS:
+			if (val == -1 || val == 1)
+				return 1;
+			break;
+
+		case ASHIFT:
+		case ASHIFTRT:
+		case LSHIFTRT:
+		case ROTATE:
+		case ROTATERT:
+			if (val == 1)
+				return 1;
+			break;
+
+		default:
+			break;
+	}
+
+	return 0;
+}
+
+
+/** Return a bitarray of the hard registers which are used by a function. */
+unsigned int
+m6809_get_live_regs (void)
+{
+	unsigned int regs = 0;
+	int regno;
+
+	if (frame_pointer_needed)
+		regs |= (1 << HARD_FRAME_POINTER_REGNUM);
+
+	for (regno = HARD_X_REGNUM; regno <= HARD_U_REGNUM; regno++)
+		if (df_regs_ever_live_p (regno) && ! call_used_regs[regno])
+			regs |= (1 << regno);
+
+	return regs;
+}
+
+
+/** Return a printable version of a list of hard registers, suitable
+ * for use in a PSHx or PULx insn. */
+const char *
+m6809_get_regs_printable (unsigned int regs)
+{
+	static char list[64];
+	char *listp = list;
+	unsigned int regno;
+
+	for (regno=0; regno < FIRST_PSEUDO_REGISTER; regno++)
+		if ((regs & (1 << regno)) && !S_REGNO_P (regno))
+			listp += sprintf (listp,
+				(listp == list) ? "%s" : ",%s", reg_names[regno]);
+
+	return list;
+}
+
+
+/** Return the total number of bytes covered by a set of hard registers. */
+unsigned int
+m6809_get_regs_size (unsigned int regs)
+{
+	unsigned int regno;
+	unsigned int size = 0;
+
+	for (regno=0; regno < FIRST_PSEUDO_REGISTER; regno++)
+	{
+		/* Only count register in the given register set */
+		if (REGSET_CONTAINS_P (regno, regs))
+		{
+			/* Add 1 or 2 byte, depending on the size of the register.
+			 * Since 'D' may be in both sets, check for WORD_REGSET first. */
+			if (REGSET_CONTAINS_P(regno, WORD_REGSET))
+				size += 2;
+			else if (REGSET_CONTAINS_P(regno, BYTE_REGSET))
+				size++;
+		}
+	}
+	return size;
+}
+
+
+/* Given the target of call instruction in X,
+ * return the tree node that contains the function declaration for
+ * that target.
+ *
+ * If the rtx or the tree do not appear valid for any reason,
+ * then return NULL_TREE.
+ */
+static tree call_target_decl (rtx x)
+{
+   tree decl;
+
+	/* Make sure the target is really a MEM. */
+	if (!x || !MEM_P (x))
+		return NULL_TREE;
+
+	/* Make sure the address is a SYMBOL_REF. */
+	x = XEXP (x, 0);
+	if (!x || (GET_CODE (x) != SYMBOL_REF))
+		return NULL_TREE;
+
+	/* Get the declaration of this symbol */
+	decl = SYMBOL_REF_DECL (x);
+
+	/* Make sure the declaration is really a function. */
+	if (!decl || (TREE_CODE(decl) != FUNCTION_DECL))
+		return NULL_TREE;
+
+   return decl;
+}
+
+
+/** Returns nonzero if a function, whose declaration is in DECL,
+ * was declared to have the attribute given by ATTR_NAME. */
+int
+m6809_function_has_type_attr_p (tree decl, const char *attr_name)
+{
+	tree type;
+
+	type = TREE_TYPE (decl);
+	return lookup_attribute (attr_name, TYPE_ATTRIBUTES (type)) != NULL;
+}
+
+
+
+/** Returns nonzero if the current function was declared to have the
+ * attribute given by ATTR_NAME. */
+int
+m6809_current_function_has_type_attr_p (const char *attr_name)
+{
+	return m6809_function_has_type_attr_p (current_function_decl, attr_name);
+}
+
+
+/** Return nonzero if the current function has no return value. */
+int
+m6809_current_function_is_void (void)
+{
+   return (VOID_TYPE_P (TREE_TYPE (TREE_TYPE (current_function_decl))));
+}
+
+
+/** Get the value of a declaration's 'bank', as set by the 'bank'
+ * attribute.  If no bank was declared, it returns NULL by default. */
+const char *
+m6809_get_decl_bank (tree decl)
+{
+	tree attr;
+
+	/* Lookup the 'bank' attribute.  If it does not exist, then
+	 * return NULL */
+	attr = lookup_attribute ("bank", DECL_ATTRIBUTES (decl));
+	if (attr == NULL_TREE)
+		return NULL;
+
+	/* Make sure it has a value assigned to it */
+	attr = TREE_VALUE (attr);
+	if (attr == NULL_TREE)
+	{
+		warning (WARNING_OPT "banked function did not declare a bank number");
+		return NULL;
+	}
+
+	/* Return the bank name */
+	attr = TREE_VALUE (attr);
+	return TREE_STRING_POINTER (attr);
+}
+
+
+void
+m6809_declare_function_name (FILE *asm_out_file, const char *name, tree decl)
+{
+	/* Check the function declaration for special properties.
+	 *
+	 * If the function was declare with __attribute__((bank)), output
+	 * assembler definitions to force the function to go into the named
+	 * bank.
+	 */
+	const char *bank_name = m6809_get_decl_bank (decl);
+	if (bank_name != NULL)
+	{
+		fprintf (asm_out_file, "\n");
+
+		/* Declare __self_bank as a local assembler value that denotes
+		 * which bank the current function is in.  This is required only
+		 * when the bank actually changes. */
+		if (strcmp (bank_name, current_bank_name))
+		{
+			fprintf (asm_out_file, "__self_bank\t.equ\t%s\n", bank_name);
+			strcpy (current_bank_name, bank_name);
+		}
+
+		/* Declare a global assembler value that denotes which bank the
+		 * named function is in. */
+		fprintf (asm_out_file, "__%s_bank\t.gblequ\t%s\n", name, bank_name);
+
+		/* Force the current function into a new area */
+		fprintf (asm_out_file, "\t.bank\tbank_%s (FSFX=_%s)\n",
+			bank_name, bank_name);
+		fprintf (asm_out_file, "\t.area\tbank_%s (BANK=bank_%s)\n",
+			bank_name, bank_name);
+	}
+
+	/* Emit the label for the function's name */
+	ASM_OUTPUT_LABEL (asm_out_file, name);
+}
+
+#if 0
+/**
+ * Handle pragmas.  Note that only the last branch pragma seen in the 
+ * source has any affect on code generation.  
+ */
+
+#define BAD_PRAGMA(msgid, arg) \
+	do { warning (WARNING_OPT msgid, arg); return -1; } while (0)
+
+static int
+pragma_parse (const char *name, tree *sect)
+{
+  tree s, x;
+
+  if (pragma_lex (&x) != CPP_OPEN_PAREN)
+    BAD_PRAGMA ("missing '(' after '#pragma %s' - ignored", name);
+
+  if (pragma_lex (&s) != CPP_STRING)
+    BAD_PRAGMA ("missing section name in '#pragma %s' - ignored", name);
+
+  if (pragma_lex (&x) != CPP_CLOSE_PAREN)
+    BAD_PRAGMA ("missing ')' for '#pragma %s' - ignored", name);
+
+  if (pragma_lex (&x) != CPP_EOF)
+    warning (WARNING_OPT "junk at end of '#pragma %s'", name);
+
+  *sect = s;
+  return 0;
+}
+
+
+/*
+ * Handle #pragma section.
+ * This is deprecated; code should use __attribute__(section("name"))
+ * instead.
+ */
+void pragma_section (cpp_reader *pfile ATTRIBUTE_UNUSED)
+{
+	tree sect;
+
+	if (pragma_parse ("section", &sect))
+		return;
+
+	snprintf (code_section_op, 6+TREE_STRING_LENGTH (sect),
+		".area\t%s", TREE_STRING_POINTER (sect));
+	snprintf (data_section_op, 6+TREE_STRING_LENGTH (sect),
+		".area\t%s", TREE_STRING_POINTER (sect));
+
+	/* Mark a flag that sections have changed.  Upon emitting another
+	 * declaration, the new .area directive will be written. */
+	section_changed++;
+}
+#endif
+
+/**
+ * Check a `double' value for validity for a particular machine mode.
+ * Called by the CHECK_FLOAT_VALUE() machine-dependent macro.
+ */
+int
+check_float_value (enum machine_mode mode, double *d, int overflow)
+{
+	if (mode == SFmode) {
+		if (*d > 1.7014117331926443e+38) {
+			error("magnitude of constant too large for `float'");
+			*d = 1.7014117331926443e+38;
+		}
+		else if (*d < -1.7014117331926443e+38) {
+			error("magnitude of constant too large for `float'");
+			*d = -1.7014117331926443e+38;
+		}
+		else if ((*d > 0) && (*d < 2.9387358770557188e-39)) {
+			warning(WARNING_OPT "`float' constant truncated to zero");
+			*d = 0.0;
+		}
+		else if ((*d < 0) && (*d > -2.9387358770557188e-39)) {
+			warning(WARNING_OPT "`float' constant truncated to zero");
+			*d = 0.0;
+		}
+	}
+	return overflow;
+}
+
+
+
+/** Declare that the target supports named output sections. */
+bool m6809_have_named_section = (bool)1;
+
+
+/** Write to the assembler file a directive to place
+ * subsequent objects to a different section in the
+ * object file.  ASxxxx uses the "area" directive for
+ * this purpose.  It does not however support generalized
+ * alignment, and can only place items on an odd/even
+ * boundary. */
+void
+m6809_asm_named_section (
+	const char *name, 
+	unsigned int flags ATTRIBUTE_UNUSED,
+	tree decl)
+{
+	fprintf (asm_out_file, "\n\t.area\t%s\n", name);
+}
+
+
+enum reg_class
+m6809_preferred_reload_class (rtx x, enum reg_class regclass)
+{
+	/* Check cases based on type code of rtx */
+	switch (GET_CODE(x))
+	{
+		/*
+		 * Observation, 2015-07-19, William Astle
+		 *
+		 * The original comparison for range for 16 bits was wrong, adding 0x80
+		 * instead of 0x8000. Replaced both 8 bit and 16 bit comparisions with
+		 * a more straight forward range comparison - excessive cleverness isn't
+		 * really required here.
+		 */    
+		case CONST_INT:
+		   /* Constants that can fit into 1 byte should be
+			 * loaded into a Q_REGS reg */
+			if ((INTVAL(x) >= -128 && INTVAL(x) <= 127) &&
+//			if (((unsigned) (INTVAL(x) + 0x80) < 0x100) && 
+  				 (regclass > A_REGS))
+      		return Q_REGS;
+
+			/* 16-bit constants should be loaded into A_REGS
+			 * when possible.  gcc may already require A_REGS
+			 * or D_REGS for certain types of instructions.
+			 * This case applies mostly to simple copy operations
+			 * to/from memory when any register will do, but
+			 * it's best to avoid using D register since it is
+			 * needed for other things.
+			 */
+			else if ((INTVAL(x) >= -32768 && INTVAL(x) <= 32767) &&
+//			else if (((unsigned) (INTVAL(x) + 0x80) < 0x10000) &&
+  				 (regclass > A_REGS))
+      		return A_REGS;
+			break;
+
+		case SYMBOL_REF:
+		case LABEL_REF:
+			/* Addresses should always be loaded into A_REGS */
+			if (regclass >= A_REGS)
+				return (A_REGS);
+
+		default:
+			break;
+	}
+
+	/* Check cases based on mode of rtx */
+   if ((GET_MODE(x) == QImode) && (regclass != A_REGS))
+      return Q_REGS;
+
+	/* Default: return whatever class reload suggested */
+   return regclass;
+}
+
+
+/**
+ * Check a new declaration for the "section" attribute.
+ * If it exists, and the target section is "direct", then mark
+ * the declaration (in RTL) to indicate special treatment.
+ * When the variable is referenced later, we test for this flag
+ * and can emit special asm text to force the assembler to use
+ * short instructions.
+ */
+static void
+m6809_encode_section_info (tree decl, rtx rtl, int new_decl_p ATTRIBUTE_UNUSED)
+{
+   tree attr, id;
+   const char *name;
+   const char *decl_name;
+
+   /* We only care about variable declarations, not functions */
+   if (TREE_CODE (decl) != VAR_DECL)
+      return;
+
+	/* For debugging purposes only; grab the decl's name */
+   decl_name = IDENTIFIER_POINTER (DECL_NAME (decl));
+
+	/* Give up if the decl doesn't have any RTL */
+   if (!DECL_RTL (decl))
+      return;
+
+	/* See if it has a section attribute */
+   attr = lookup_attribute ("section", DECL_ATTRIBUTES (decl));
+   if (!attr)
+      return;
+
+	/* See if the section attribute has a value */
+   id = TREE_VALUE (TREE_VALUE (attr));
+   if (!id)
+      return;
+   name = TREE_STRING_POINTER (id);
+   if (!name)
+      return;
+
+	/* See if the value is 'direct'.  If so, mark it. */
+   if (!strcmp (name, "direct"))
+      SYMBOL_REF_FLAG (XEXP (DECL_RTL (decl), 0)) = 1;
+}
+
+
+/**
+ * Output code to perform a complex shift, for which there is no
+ * direct support in the instruction set.
+ *
+ * shift1 is an instruction pattern for performing a 1-bit modification.
+ * This code wraps that pattern in a loop to perform the shift N times,
+ * where N is given by the address register in operands[2].
+ *
+ * To support 16-bit shifts, shift2 can also be provided: it is
+ * a second instruction to be included in the loop.  8-bit shift
+ * insns will pass NULL here.
+ *
+ * The insn length of shift1/shift2 is assumed to be 1 byte,
+ * which works in all of the cases it is needed so far.
+ */
+static void
+m6809_gen_register_shift (
+		rtx *operands,
+		const char *shift1,
+		const char *shift2 )
+{
+	char beq_pattern[32];
+   char bra_pattern[32];
+
+	int shiftlen = (shift1 && shift2) ? 2 : 1;
+	int cmplen = (REGNO (operands[2]) == HARD_X_REGNUM) ? 3 : 4;
+
+	int beq_offset = 2 + shiftlen + 2;
+	int bra_offset = shiftlen + 2 + cmplen + 2;
+
+	sprintf (beq_pattern, "beq\t.+%d", beq_offset);
+	sprintf (bra_pattern, "bra\t.-%d", bra_offset);
+
+	output_asm_insn ("pshs\t%2", operands);
+	output_asm_insn ("lea%2\t-1,%2", operands);
+   output_asm_insn ("cmp%2\t#-1", operands);
+   output_asm_insn (beq_pattern, operands);
+	if (shift1)
+		output_asm_insn (shift1, operands);
+	if (shift2)
+		output_asm_insn (shift2, operands);
+	output_asm_insn (bra_pattern, operands);
+	output_asm_insn ("puls\t%2", operands);
+}
+
+
+/** Generate RTL for the upper 8-bits of a 16-bit constant. */
+rtx
+gen_rtx_const_high (rtx r)
+{
+   unsigned char v = (INTVAL (r) >> 8) & 0xFF;
+	signed char s = (signed char)v;
+   return gen_int_mode (s, QImode);
+}
+
+
+/** Generate RTL for the lower 8-bits of a 16-bit constant. */
+rtx
+gen_rtx_const_low (rtx r)
+{
+   unsigned char v = INTVAL (r) & 0xFF;
+	signed char s = (signed char)v;
+   return gen_int_mode (s, QImode);
+}
+
+
+/** Generate RTL to allocate/free bytes on the stack.
+ * CODE is given as MINUS when allocating and PLUS when freeing,
+ * to match the semantics of a downward-growing stack.  SIZE
+ * is always given as a positive integer.
+ */
+static rtx
+gen_rtx_stack_adjust (enum rtx_code code, int size)
+{
+	if (size <= 0)
+		return NULL_RTX;
+
+	if (code == MINUS)
+		size = -size;
+
+	return gen_rtx_SET (Pmode, stack_pointer_rtx, 
+		gen_rtx_PLUS (Pmode, stack_pointer_rtx,
+			gen_int_mode (size, HImode)));
+}
+
+
+/** Generate RTL to push/pop a set of registers. */
+rtx
+gen_rtx_register_pushpop (int op, int regs)
+{
+	rtx nregs = gen_int_mode (regs, QImode);
+	
+	if (op == UNSPEC_PUSH_RS)
+		return gen_register_push (nregs);
+	else
+		return gen_register_pop (nregs);
+}
+
+
+/* Given a register set REGS, where the bit positions correspond to
+ * hard register numbers, return another bitmask that represents the
+ * order in which those registers would be pushed/popped.
+ * Registers that are pushed first have higher bit positions.
+ * The pop order is just the reverse bitmask.
+ * These values are the same as the bitmasks actually used in the
+ * machine instructions. */
+static unsigned int
+register_push_order (int regs)
+{
+	unsigned int order = 0;
+
+	if (REGSET_CONTAINS_P (HARD_PC_REGNUM, regs))
+		order |= 0x80;
+	if (REGSET_CONTAINS_P (HARD_U_REGNUM, regs))
+		order |= 0x40;
+	if (REGSET_CONTAINS_P (HARD_Y_REGNUM, regs))
+		order |= 0x20;
+	if (REGSET_CONTAINS_P (HARD_X_REGNUM, regs))
+		order |= 0x10;
+	if (REGSET_CONTAINS_P (HARD_DP_REGNUM, regs))
+		order |= 0x8;
+	if (REGSET_CONTAINS_P (HARD_B_REGNUM, regs))
+		order |= 0x4;
+	if (REGSET_CONTAINS_P (HARD_A_REGNUM, regs))
+		order |= 0x2;
+	if (REGSET_CONTAINS_P (HARD_CC_REGNUM, regs))
+		order |= 0x1;
+
+	if (REGSET_CONTAINS_P (HARD_D_REGNUM, regs))
+		order |= (0x4 | 0x2);
+	return order;
+}
+
+
+/* Returns nonzero if two consecutive push or pop instructions,
+ * as determined by the OP, can be merged into a single instruction.
+ * The first instruction in the sequence pushes/pops REGS1; the
+ * second applies to REGS2.
+ *
+ * If true, the resulting instruction can use (regs1 | regs2)
+ * safely.
+ */
+int
+m6809_can_merge_pushpop_p (int op, int regs1, int regs2)
+{
+	/* Register sets must not overlap */
+	if (regs1 & regs2)
+		return 0;
+
+	if (op == UNSPEC_PUSH_RS)
+		return (register_push_order (regs1) > register_push_order (regs2));
+	else if (op == UNSPEC_POP_RS)
+		return (register_push_order (regs1) < register_push_order (regs2));
+	else
+		return 0;
+}
+
+
+/** Emit instructions for making a library call.
+ * MODE is the mode of the operation.
+ * NAME is the library function name.
+ * OPERANDS is the rtx array provided by the recognizer.
+ * COUNT is the number of input operands to the call, and
+ * should be 1 for a unary op or 2 for a binary op.
+ */
+void
+emit_libcall_insns (enum machine_mode mode, 
+	const char *name, 
+	rtx *operands,
+	int count)
+{
+	/* Generate an rtx for the call target. */
+	rtx symbol = gen_rtx_SYMBOL_REF (Pmode, name);
+
+	/* Emit the library call.  Slightly different based
+	on the number of operands */
+	if (count == 2)
+		emit_library_call (symbol, LCT_NORMAL, mode,
+			2, operands[1], mode, operands[2], mode);
+	else
+		emit_library_call (symbol, LCT_NORMAL, mode,
+			1, operands[1], mode);
+
+	/* The library call is expected to put its result
+	in LIBCALL_VALUE, so need to copy it into the destination. */
+	emit_move_insn (operands[0], LIBCALL_VALUE(mode));
+}
+
+
+/**
+ * A small helper function that writes out a single branch instruction.
+ * OPCODE is the short name, e.g. "ble".
+ * OPERANDS has the rtx for the target label.
+ * LONG_P is nonzero if we are emitting a long branch, and need to
+ * prepend an 'l' to the opcode name.
+ */
+void output_branch_insn1 (const char *opcode, rtx *operands, int long_p)
+{
+	char pattern[64];
+	sprintf (pattern, "%s%s\t%%l0", long_p ? "l" : "", opcode);
+	output_asm_insn (pattern, operands);
+}
+
+/**
+ * Output a branch/conditional branch insn of the proper
+ * length.  code identifies the particular branch insn.
+ * operands holds the branch target in operands[0].
+ * length says what the size of this insn should be.
+ * Based on the length, we know whether it should be a
+ * short (8-bit) or long (16-bit) branch.
+ */
+const char *
+output_branch_insn (enum rtx_code code, rtx *operands, int length)
+{
+	int shortform; 
+
+	/* Decide whether or not to use the long or short form.
+	 * Calculate automatically based on insn lengths. */
+   shortform = ((length > 2) ? 0 : 1);
+
+	/* Determine the proper opcode.
+	 * Use the short (2-byte) opcode if the target is within
+	 * reach.  Otherwise, use jmp (3-byte opcode), unless
+	 * compiling with -fpic, in which case we'll need to use
+	 * lbra (4-byte opcode).
+	 */
+	switch (code)
+	{
+		case LABEL_REF: 
+			if (shortform)
+				output_branch_insn1 ("bra", operands, 0);
+			else if (flag_pic)
+				output_branch_insn1 ("bra", operands, 1);
+			else
+				output_branch_insn1 ("jmp", operands, 0);
+			break;
+		case EQ:
+			output_branch_insn1 ("beq", operands, !shortform);
+			break;
+		case NE:
+			output_branch_insn1 ("bne", operands, !shortform);
+			break;
+		case GT:
+			output_branch_insn1 ("bgt", operands, !shortform);
+			break;
+		case GTU:
+			output_branch_insn1 ("bhi", operands, !shortform);
+			break;
+		case LT:
+			if (cc_prev_status.flags & CC_NO_OVERFLOW)
+			{
+				output_branch_insn1 ("bmi", operands, !shortform);
+			}
+			else
+			{
+				output_branch_insn1 ("blt", operands, !shortform);
+			}
+			break;
+		case LTU:
+			output_branch_insn1 ("blo", operands, !shortform);
+			break;
+		case GE:
+			if (cc_prev_status.flags & CC_NO_OVERFLOW)
+			{
+				output_branch_insn1 ("bpl", operands, !shortform);
+			}
+			else
+			{
+				output_branch_insn1 ("bge", operands, !shortform);
+			}
+			break;
+		case GEU:
+			output_branch_insn1 ("bhs", operands, !shortform);
+			break;
+		case LE:
+			if (cc_prev_status.flags & CC_NO_OVERFLOW)
+			{
+				output_branch_insn1 ("bmi", operands, !shortform);
+				output_branch_insn1 ("beq", operands, !shortform);
+			}
+			else
+			{
+				output_branch_insn1 ("ble", operands, !shortform);
+			}
+			break;
+		case LEU:
+			output_branch_insn1 ("bls", operands, !shortform);
+			break;
+		default:
+			abort();
+			break;
+	}
+	return "";
+}
+
+
+/** Returns the "cost" of an RTL expression.
+ * In general, the expression "COSTS_N_INSNS(1)" is used to represent
+ * the cost of a fast 8-bit arithmetic instruction that operates on
+ * a reg/mem or a reg/immed.  Other costs are relative to this.
+ *
+ * Notes:
+ * - The cost of a REG is always zero; this cannot be changed.
+ *
+ * - On the 6809, instructions on two registers will nearly always take
+ *   longer than those that operate on a register and a constant/memory,
+ *   because of the way the instruction set is structured.
+ *
+ * TODO: multiply HImode by 2 should be done via shifts, instead of add.
+ */
+static bool
+m6809_rtx_costs (rtx X, int code, int outer_code ATTRIBUTE_UNUSED,
+	int *total, bool speed)
+{
+	int has_const_arg = 0;
+	HOST_WIDE_INT const_arg;
+	enum machine_mode mode;
+	int nargs = 1;
+	rtx op0, op1;
+
+	/* Data RTXs return a value between 0-3, depending on complexity.
+	All of these are less than COSTS_N_INSNS(1). */
+	switch (code)
+	{
+		case CC0:
+		case PC:
+			*total = 0;
+			return true;
+
+ 		case CONST_INT:
+    		if (X == const0_rtx)
+			{
+				*total = 0;
+				return true;
+			}
+			else if ((unsigned) INTVAL (X) < 077) 
+			{
+				*total = 1;
+				return true;
+			}
+			else
+			{
+				*total = 2;
+				return true;
+			}
+
+ 		case LABEL_REF: case CONST:
+   		*total = 2;
+			return true;
+
+ 		case SYMBOL_REF:
+			/* References to memory are made cheaper if they have
+			 * the 'direct' mode attribute set */
+			*total = (SYMBOL_REF_FLAG (X)) ? 1 : 2;
+			return true;
+
+		case MEM:
+			/* See what form of address was given */
+			X = XEXP (X, 0);
+			switch (GET_CODE (X))
+			{
+ 				case SYMBOL_REF:
+					*total = (SYMBOL_REF_FLAG (X)) ? 1 : 2;
+					break;
+
+				case CONST_INT:
+					*total = 2;
+					break;
+
+				case MEM:
+					*total = COSTS_N_INSNS (1) + 2;
+					break;
+
+				default:
+					break;
+			}
+			return true;
+
+ 		case CONST_DOUBLE:
+			/* TODO : not sure about this value. */
+   		*total = 3;
+			return true;
+
+		default:
+			break;
+	}
+
+	/* Decode the rtx */
+	mode = GET_MODE (X);
+	op0 = XEXP (X, 0);
+	op1 = XEXP (X, 1);
+
+	/* We don't implement anything in SImode or greater. */
+	if (GET_MODE_SIZE (mode) >= GET_MODE_SIZE (SImode))
+	{
+		*total = COSTS_N_INSNS (100);
+		return true;
+	}
+
+	/* Figure out if there is a constant argument, and its value. */
+	if (GET_RTX_CLASS (code) == RTX_BIN_ARITH
+		|| GET_RTX_CLASS (code) == RTX_COMM_ARITH)
+	{
+		nargs = 2;
+		if (GET_CODE (op1) == CONST_INT)
+		{
+			has_const_arg = 1;
+			const_arg = INTVAL (op1);
+		}
+	}
+
+	/* Penalize a reg/reg operation by adding MEMORY_MOVE_COST,
+	 * Ignore soft registers, since these are really in memory.
+	 *
+	 * TODO: penalize HImode reg/reg for most operations, except maybe
+	 * additions since index registers allow for that.
+	 *
+	 * TODO: shifts by constant N do not always require N instructions;
+	 * some of this can be done cheaper.  The number of actual insns can be
+	 * predicted well.
+	 */
+	if (nargs == 2 && REAL_REG_P (op0) && REAL_REG_P (op1))
+	{
+		*total = MEMORY_MOVE_COST (mode, Q_REGS, 0);
+	}
+	else
+	{
+		*total = 0;
+	}
+
+	/* Operator RTXs are counted as COSTS_N_INSNS(N), where N is
+	the estimated number of actual machine instructions needed to
+	perform the computation.  Some small adjustments are made since
+	some "instructions" are more complex than others. */
+	switch (code)
+	{
+		case PLUS: case MINUS: case COMPARE:
+			/* 6809 handles these natively in QImode, and in HImode as long
+			 * as operand 1 is constant. */
+			if (mode == QImode || (mode == HImode && has_const_arg))
+				*total += COSTS_N_INSNS (1);
+			else 
+				*total += COSTS_N_INSNS (GET_MODE_SIZE (mode));
+
+			/* -1, 0, and 1 can be done using inherent instructions
+			 * for PLUS and MINUS in QImode, so don't add extra cost. */
+  			if (has_const_arg
+				&& (mode == QImode || mode == HImode)
+				&& (const_arg == -1 || const_arg == 0 || const_arg == 1)
+				&& (code == PLUS || code == MINUS))
+			{
+				return true;
+			}
+			break;
+
+		case AND: case IOR: case XOR:
+		case NEG: case NOT:
+			/* 6809 handles these natively in QImode, but requires
+			 * splitting in HImode.   Treat these as 2 insns. */
+			*total += COSTS_N_INSNS (1) * GET_MODE_SIZE (mode);
+			break;
+
+  		case ASHIFT: case ASHIFTRT: case LSHIFTRT:
+  		case ROTATE: case ROTATERT:
+			/* 6809 can do shift/rotates of a QImode by a constant in
+			 * 1 insn times the shift count, or in HImode by a constant 
+			 * by splitting to 2 insns.
+			 *
+			 * Shift by a nonconstant will take significantly longer
+			 * than any of these. */
+  			if (has_const_arg)
+			{
+				const_arg %= (GET_MODE_SIZE (mode) * 8);
+				if (const_arg == 0)
+				{
+					*total += COSTS_N_INSNS(1);
+					return true;
+				}
+
+				/* HImode shifts greater than 8 get optimized due
+				 * to register transfer from b to a; this cuts down the
+				 * cost. */
+				if (const_arg >= 8)
+				{
+					*total += COSTS_N_INSNS (1);
+					const_arg -= 8;
+				}
+
+				/* The computed cost is 'const_arg' 1-bit shifts, doubled
+				if in HImode, minus the cost of the constant itself which
+				will be added in later but really shouldn't be. */
+				*total += COSTS_N_INSNS (const_arg) * GET_MODE_SIZE (mode) - 1;
+				return true;
+			}
+			else
+			{
+				/* It may take up to 7 iterations of about 6-7 real
+				 * instructions, so make this expensive. */
+				*total += COSTS_N_INSNS (50);
+			}
+  			break;
+
+		case MULT:
+ 		{
+ 			/* Multiply is cheap when both arguments are 8-bits.  They
+ 			could be QImode, or QImode widened to HImode, or a constant
+ 			that fits into 8-bits.  As long as both operands qualify,
+ 			we can use a single mul instruction.
+  
+ 			Assume that fast multiply can be used, and change this if we find
+ 			differently... */
+ 			int ok_for_qihi3 = 1;
+  
+ 			/* Check the first operand */	
+ 			switch (GET_MODE (op0))
+ 			{
+ 				case QImode:
+ 					break;
+ 				case HImode:
+ 					if (GET_CODE (op0) != SIGN_EXTEND && GET_CODE (op0) != ZERO_EXTEND)
+  						ok_for_qihi3 = 0;
+ 					break;
+ 				default:
+ 					ok_for_qihi3 = 0;
+ 					break;
+  			}
+ 
+			/* Likewise, check the second operand.  This is where constants may appear. */
+ 			switch (GET_MODE (op1))
+ 			{
+ 				case QImode:
+ 					break;
+ 				case HImode:
+					if (GET_CODE (op1) != SIGN_EXTEND && GET_CODE (op1) != ZERO_EXTEND)
+ 						ok_for_qihi3 = 0;
+ 					break;
+ 				case VOIDmode:
+					if (!CONST_OK_FOR_LETTER_P (const_arg, 'K'))
+ 						ok_for_qihi3 = 0;
+					break;
+ 				default:
+ 					ok_for_qihi3 = 0;
+ 					break;
+ 			}
+ 
+ 			/* Fast multiply takes about 4 times as many cycles as a normal
+ 			arithmetic operation.  Otherwise, it will take an expensive libcall. */
+ 			if (ok_for_qihi3)
+ 				*total += COSTS_N_INSNS (4);
+ 			else
+ 				*total = COSTS_N_INSNS (50);
+  	  		break;
+ 		}
+
+		case DIV: case UDIV: case MOD: case UMOD:
+			/* These all require more expensive libcalls. */
+			*total += COSTS_N_INSNS (100);
+  			break;
+
+		/* TODO : TRUNCATE, SIGN_EXTEND, and ZERO_EXTEND */
+
+		/* These can normally be done with autoincrement, etc., so
+		 * don't charge for them. */
+		case PRE_DEC:
+		case PRE_INC:
+		case POST_DEC:
+		case POST_INC:
+			break;
+
+		default:
+			break;
+	}
+
+	/* Always return false, and let the caller gather the costs
+	 * of the operands */
+	return false;
+}
+
+
+static tree
+m6809_handle_fntype_attribute (tree *node, tree name,
+	tree args ATTRIBUTE_UNUSED,
+	int flags ATTRIBUTE_UNUSED,
+	bool *no_add_attrs)
+{
+	if (TREE_CODE (*node) != FUNCTION_TYPE)
+	{
+		warning (WARNING_OPT "'%s' only valid for functions", 
+			IDENTIFIER_POINTER (name));
+		*no_add_attrs = TRUE;
+	}
+
+	return NULL_TREE;
+}
+
+
+static tree
+m6809_handle_data_type_attribute (tree *node ATTRIBUTE_UNUSED,
+	tree name ATTRIBUTE_UNUSED,
+	tree args ATTRIBUTE_UNUSED,
+	int flags ATTRIBUTE_UNUSED,
+	bool *no_add_attrs ATTRIBUTE_UNUSED)
+{
+	return NULL_TREE;
+}
+
+
+
+static tree
+m6809_handle_default_attribute (tree *node ATTRIBUTE_UNUSED, 
+	tree name ATTRIBUTE_UNUSED,
+	tree args ATTRIBUTE_UNUSED,
+	int flags ATTRIBUTE_UNUSED,
+	bool *no_add_attrs ATTRIBUTE_UNUSED )
+{
+	return NULL_TREE;
+}
+
+
+/* Table of valid machine attributes */
+const struct attribute_spec m6809_attribute_table[] = { /*
+{ name,        min, max, decl,  type, fntype, handler } */
+{ "interrupt", 0,   0,   false, true,  true,  m6809_handle_fntype_attribute },
+{ "naked",     0,   0,   false, true,  true,  m6809_handle_fntype_attribute },
+{ "far",       0,   1,   false, true,  true,  m6809_handle_fntype_attribute },
+{ "bank",      0,   1,   true,  false, false, m6809_handle_default_attribute },
+{ "boolean",   0,   0,   false, true,  false, m6809_handle_data_type_attribute },
+{ NULL,        0,   0,   false, true,  false, NULL },
+};
+
+
+/** Initialize builtin routines for the 6809. */
+void
+m6809_init_builtins (void)
+{
+	/* Create type trees for each function signature required.
+	 *
+	 * void_ftype_void = void f(void)
+	 * void_ftype_uchar = void f(unsigned char)
+	 * uchar_ftype_uchar2 = unsigned char f (unsigned char, unsigned char)
+	 */
+	tree void_ftype_void = 
+		build_function_type (void_type_node, void_list_node);
+
+	tree void_ftype_uchar =
+		build_function_type (void_type_node,
+			tree_cons (NULL_TREE, unsigned_char_type_node, void_list_node));
+
+	tree uchar_ftype_uchar2 =
+		build_function_type (unsigned_char_type_node,
+			tree_cons (NULL_TREE, unsigned_char_type_node, 
+				tree_cons (NULL_TREE, unsigned_char_type_node, void_list_node)));
+
+	/* Register each builtin function. */
+	add_builtin_function ("__builtin_swi", void_ftype_void,
+		M6809_SWI, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_swi2", void_ftype_void,
+		M6809_SWI2, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_swi3", void_ftype_void,
+		M6809_SWI3, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_cwai", void_ftype_uchar,
+		M6809_CWAI, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_sync", void_ftype_void,
+		M6809_SYNC, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_nop", void_ftype_void,
+		M6809_NOP, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_blockage", void_ftype_void,
+		M6809_BLOCKAGE, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_add_decimal", uchar_ftype_uchar2,
+		M6809_ADD_DECIMAL, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_add_carry", uchar_ftype_uchar2,
+		M6809_ADD_CARRY, BUILT_IN_MD, NULL, NULL_TREE);
+
+	add_builtin_function ("__builtin_sub_carry", uchar_ftype_uchar2,
+		M6809_SUB_CARRY, BUILT_IN_MD, NULL, NULL_TREE);
+}
+
+
+/** Used by m6809_expand_builtin, given a tree ARGLIST which
+ * refers to the operands of a builtin call, return an rtx
+ * that represents the nth operand, as denoted by OPNUM, which
+ * is a zero-based integer.  MODE gives the expected mode
+ * of the operand.
+ *
+ * This rtx is suitable for use in the emitted RTL for the
+ * builtin instruction. */
+rtx
+m6809_builtin_operand (tree arglist, enum machine_mode mode, int opnum)
+{
+	tree arg;
+	rtx r;
+
+	arg = CALL_EXPR_ARG (arglist, opnum);
+
+	/* Convert the tree to RTL */
+	r = expand_expr (arg, NULL_RTX, mode, EXPAND_NORMAL);
+	if (r == NULL_RTX)
+		return NULL_RTX;
+	return r;
+}
+
+
+/** Expand a builtin that was registered in init_builtins into
+ * RTL.  */
+rtx
+m6809_expand_builtin (tree exp, 
+	rtx target, 
+	rtx subtarget ATTRIBUTE_UNUSED,
+	enum machine_mode mode ATTRIBUTE_UNUSED,
+	int ignore ATTRIBUTE_UNUSED )
+{
+   tree fndecl = TREE_OPERAND (CALL_EXPR_FN (exp), 0);
+	tree arglist = exp;
+	unsigned int fcode = DECL_FUNCTION_CODE (fndecl);
+	rtx r0, r1;
+
+	switch (fcode)
+	{
+		case M6809_SWI:
+			r0 = gen_rtx_CONST_INT (VOIDmode, 1);
+			emit_insn (target = gen_m6809_swi (r0));
+			return target;
+
+		case M6809_SWI2:
+			r0 = gen_rtx_CONST_INT (VOIDmode, 2);
+			emit_insn (target = gen_m6809_swi (r0));
+			return target;
+
+		case M6809_SWI3:
+			r0 = gen_rtx_CONST_INT (VOIDmode, 3);
+			emit_insn (target = gen_m6809_swi (r0));
+			return target;
+
+		case M6809_CWAI:
+			r0 = m6809_builtin_operand (arglist, QImode, 0);
+			emit_insn (target = gen_m6809_cwai (r0));
+			return target;
+
+		case M6809_SYNC:
+			emit_insn (target = gen_m6809_sync ());
+			return target;
+
+		case M6809_ADD_CARRY:
+			r0 = m6809_builtin_operand (arglist, QImode, 0);
+			r1 = m6809_builtin_operand (arglist, QImode, 1);
+			if (!target)
+				target = gen_reg_rtx (QImode);
+			emit_insn (gen_addqi3_carry (target, r0, r1));
+			return target;
+
+		case M6809_SUB_CARRY:
+			r0 = m6809_builtin_operand (arglist, QImode, 0);
+			r1 = m6809_builtin_operand (arglist, QImode, 1);
+			if (!target)
+				target = gen_reg_rtx (QImode);
+			emit_insn (gen_subqi3_carry (target, r0, r1));
+			return target;
+
+		case M6809_NOP:
+			emit_insn (target = gen_nop ());
+			return target;
+
+		case M6809_BLOCKAGE:
+			emit_insn (target = gen_blockage ());
+			return target;
+
+		case M6809_ADD_DECIMAL:
+			r0 = m6809_builtin_operand (arglist, QImode, 0);
+			r1 = m6809_builtin_operand (arglist, QImode, 1);
+			if (!target)
+				target = gen_reg_rtx (QImode);
+			emit_insn (gen_addqi3_decimal (target, r0, r1));
+			return target;
+
+		default:
+			warning (WARNING_OPT "unknown builtin expansion ignored");
+			return NULL_RTX;
+	}
+}
+
+
+
+/* Returns nonzero if 'x' represents a function that was declared
+ * as __noreturn__. */
+int
+noreturn_functionp (rtx x)
+{
+	tree decl = call_target_decl (x);
+
+	if (decl == NULL_TREE)
+		return 0;
+	else
+		return TREE_THIS_VOLATILE (decl);
+}
+
+
+const char *
+far_function_type_p (tree type)
+{
+	tree attr;
+	const char *page;
+
+	/* Return whether or not this decl has the far attribute */
+	attr = lookup_attribute ("far", TYPE_ATTRIBUTES (type));
+	if (attr == NULL_TREE)
+		return NULL;
+
+	/* If it is far, check for a value */
+	attr = TREE_VALUE (attr);
+	if (attr == NULL_TREE)
+	{
+		warning (WARNING_OPT "far code page not specified, using local value");
+		return far_code_page;
+	}
+
+	/* We have a TREE_LIST of attribute values, get the first one.
+	 * It should be an INTEGER_CST. */
+	attr = TREE_VALUE (attr);
+	page = TREE_STRING_POINTER (attr);
+	return page;
+}
+
+
+/* For a far function, returns the identifier that states which page
+ * it resides in.  Otherwise, returns NULL for ordinary functions. */
+const char *
+far_functionp (rtx x)
+{
+	tree decl, decl_type;
+	const char *page;
+
+	/* Find the FUNCTION_DECL corresponding to the rtx being called. */
+	decl = call_target_decl (x);
+	if (decl == NULL_TREE)
+		return NULL;
+
+	/* See if the function has the new 'banked' attribute.  These
+	 * are numeric instead of text */
+	page = m6809_get_decl_bank (decl);
+	if (page)
+		return page;
+
+	/* No, lookup the type of the function and see if the type
+	 * specifies far or not. */
+	decl_type = TREE_TYPE (decl);
+	if (decl_type == NULL_TREE)
+		return NULL;
+	return far_function_type_p (decl_type);
+}
+
+
+
+/** Outputs the assembly language for a far call. */
+void
+output_far_call_insn (rtx *operands, int has_return)
+{
+	static char page_data[64];
+	const char *called_page;
+
+  /* The logic is the same for functions whether or not there
+	* is a return value.  Skip over the return value in this
+	* case, so that the call location is always operands[0].  */
+  if (has_return)
+	  operands++;
+
+  /* Get the name of the page being called */
+  called_page = far_functionp (operands[0]);
+
+#if 0 /* TODO : broken logic */
+  /* See if the called page name is a 'bank' */
+  if (isdigit (*called_page))
+  {
+    /* New style banking */
+	 if (!strcmp (called_page, current_bank_name))
+	 {
+	 	/* Same page */
+  	  	output_asm_insn ("jsr\t%0", operands);
+	 }
+	 else
+	 {
+	 	/* Different page */
+		output_asm_insn ("jsr\t__far_call_handler\t;new style", operands);
+  	  	output_asm_insn ("\t.dw\t%0", operands);
+		sprintf (page_data, "\t.db\t%s", called_page);
+	 	output_asm_insn (page_data, operands);
+	 }
+	 return;
+  }
+#endif
+
+  /* Are we calling a different page than we are running in? */
+  if (!strcmp (called_page, far_code_page))
+  {
+    /* Same page : no need to execute a far call */
+		if (flag_pic)
+			output_asm_insn ("lbsr\t%C0", operands);
+		else
+			output_asm_insn ("jsr\t%0", operands);
+  }
+  else
+  {
+    /* Different page : need to emit far call thunk */
+
+    /* First output a call to the thunk for making far calls. */
+		if (flag_pic)
+			output_asm_insn ("lbsr\t__far_call_handler", operands);
+		else
+			output_asm_insn ("jsr\t__far_call_handler\t;old style", operands);
+  
+    /* Now output the name of the call site */
+    output_asm_insn ("\t.dw\t%C0", operands);
+  
+    /* Finally output the page number */
+    sprintf (page_data, "\t.db\t%s", far_functionp (operands[0]));
+    output_asm_insn (page_data, operands);
+  }
+}
+
+
+int
+m6809_init_cumulative_args (CUMULATIVE_ARGS cum ATTRIBUTE_UNUSED,
+     tree fntype,
+     rtx libname ATTRIBUTE_UNUSED)
+{
+	cum = 0;
+
+	/* For far functions, the current implementation does not allow for
+	 * stack parameters.  So note whenever the called function is far
+	 * and in a different page than the current one; such a function
+	 * should give an error if a stack parameter is generated. */
+	if (fntype)
+	{
+		const char *called_page = far_function_type_p (fntype);
+		if (called_page && strcmp (called_page, far_code_page) && !TARGET_FAR_STACK_PARAM)
+			cum |= CUM_STACK_INVALID;
+	}
+
+	if (fntype && TYPE_ARG_TYPES (fntype) != 0 &&
+		(TREE_VALUE (tree_last (TYPE_ARG_TYPES (fntype))) != void_type_node))
+	{
+		/* has variable arguments, cannot use registers */
+		cum |= (CUM_X_MASK | CUM_B_MASK | CUM_STACK_ONLY);
+	}
+
+	if (m6809_abi_version == M6809_ABI_VERSION_STACK)
+	{
+		/* cannot use registers ; only use the stack */
+		cum |= (CUM_STACK_ONLY | CUM_X_MASK | CUM_B_MASK);
+	}
+
+	return cum;
+}
+
+
+rtx
+m6809_function_arg_on_stack (CUMULATIVE_ARGS *cump)
+{
+	if (*cump & CUM_STACK_INVALID)
+	{
+		*cump &= ~CUM_STACK_INVALID;
+		error ("far function needs stack, will not work");
+	}
+	return NULL_RTX;
+}
+
+void m6809_asm_trampoline_template(FILE *f)
+{
+	fprintf(f, "ldy #0000\n");
+	fprintf(f, "jmp 0x0000\n");
+}
+
+/*
+ * Trampoline output:
+ *
+ * ldu #&cxt      4 bytes   --LDY- ?? ??
+ * jmp fnaddr     3 bytes   JMP ?? ??
+ */
+void
+m6809_initialize_trampoline (rtx tramp, tree fndecl, rtx cxt)
+{
+	rtx fnaddr = XEXP (DECL_RTL (fndecl), 0);
+	/* TODO - optimize by generating the entire trampoline code here,
+	 * and removing the template altogether, since there are only two
+	 * bytes there that matter. */
+	emit_move_insn (gen_rtx_MEM (HImode, plus_constant (tramp, 2)), cxt);
+	emit_move_insn (gen_rtx_MEM (HImode, plus_constant (tramp, 5)), fnaddr);
+}
+
+
+/** Echo the version of the compiler and the name of the source file
+ * at the beginning of each assembler output file.  asm_out_file
+ * is a global FILE * pointing to the output stream. */
+void
+m6809_asm_file_start (void)
+{
+	const char *module_name;
+
+	fprintf (asm_out_file, "\n;;; gcc for m6809 : %s %s\n",
+		__DATE__, __TIME__);
+	fprintf (asm_out_file, ";;; %s\n", version_string);
+
+	fprintf (asm_out_file, ";;; ABI version %d\n", m6809_abi_version);
+	fprintf (asm_out_file, ";;; %s\n",
+		(TARGET_BYTE_INT ? "-mint8" : "-mint16"));
+	if (TARGET_EXPERIMENT)
+		fprintf (asm_out_file, ";;; -mexperiment\n");
+	if (TARGET_WPC)
+		fprintf (asm_out_file, ";;; -mwpc\n");
+	if (TARGET_6309)
+		fprintf (asm_out_file, ";;; -m6309\n");
+
+	/* Print the name of the module, which is taken as the base name
+	 * of the input file.
+	 * See the 'User-Defined Symbols' section of the assembler
+	 * documentation for the rules on valid symbols.
+	 */
+	module_name = lbasename (main_input_filename);
+
+	fprintf (asm_out_file, "\t.module\t");
+
+	if (*module_name >= '0' && *module_name <= '9')
+		fprintf (asm_out_file, "_");
+
+	while (*module_name)
+	{
+		if ((*module_name >= '0' && *module_name <= '9')
+			|| (*module_name >= 'A' && *module_name <= 'Z')
+			|| (*module_name >= 'a' && *module_name <= 'z')
+			|| *module_name == '$'
+			|| *module_name == '.'
+			|| *module_name == '_')
+		{
+			fprintf (asm_out_file, "%c", *module_name);
+		}
+		else
+		{
+			fprintf (asm_out_file, "_");
+		}
+		module_name++;
+	}
+
+	fprintf (asm_out_file, "\n");
+}
+
+
+/** Returns true if prologue/epilogue code is required for the
+ * current function being compiled.
+ *
+ * This is just the inverse of whether the function is declared as
+ * 'naked'.
+ */
+int
+prologue_epilogue_required (void)
+{
+	return !m6809_current_function_has_type_attr_p ("naked")
+		&& !m6809_current_function_has_type_attr_p ("noreturn");
+}
+
+
+/** Expand RTL for function entry */
+void
+emit_prologue_insns (void)
+{
+  rtx insn;
+  unsigned int live_regs = m6809_get_live_regs ();
+  unsigned int frame_size = get_frame_size ();
+
+  /* Save all registers used, including the frame pointer */
+  if (live_regs && !m6809_current_function_has_type_attr_p ("interrupt"))
+  {
+    insn = emit_insn (
+      gen_rtx_register_pushpop (UNSPEC_PUSH_RS, live_regs));
+    RTX_FRAME_RELATED_P (insn) = 1;
+  }
+
+  /* Allocate space for local variables */
+  if (frame_size != 0)
+  {
+    insn = emit_insn (gen_rtx_stack_adjust (MINUS, frame_size));
+    RTX_FRAME_RELATED_P (insn) = 1;
+  }
+
+  /* Set the frame pointer if it is needed */
+  if (frame_pointer_needed)
+  {
+    insn = emit_move_insn (hard_frame_pointer_rtx, stack_pointer_rtx);
+    RTX_FRAME_RELATED_P (insn) = 1;
+  }
+}
+
+
+/** Expand RTL for function exit */
+void
+emit_epilogue_insns (bool sibcall_p)
+{
+  unsigned int live_regs = m6809_get_live_regs ();
+  unsigned int frame_size = get_frame_size ();
+
+  if (frame_size != 0)
+    emit_insn (gen_rtx_stack_adjust (PLUS, frame_size));
+
+  if (sibcall_p)
+  {
+    if (live_regs)
+      emit_insn (gen_rtx_register_pushpop (UNSPEC_POP_RS, live_regs));
+  }
+  else
+  {
+    if (live_regs && !m6809_current_function_has_type_attr_p ("interrupt"))
+        emit_insn (
+          gen_rtx_register_pushpop (UNSPEC_POP_RS, PC_REGBIT | live_regs));
+  
+    if (m6809_current_function_has_type_attr_p ("interrupt"))
+      emit_jump_insn (gen_return_rti ());
+    else
+      emit_jump_insn (gen_return_rts ());
+  }
+}
+
+#if 0
+/** Predefine some preprocessor names according to the currently
+ * selected compiler options */
+void
+m6809_cpu_cpp_builtins (void)
+{
+	if (TARGET_6309)
+	{
+		builtin_define_std ("__M6309__");
+		builtin_define_std ("__m6309__");
+	}
+	else
+	{
+		builtin_define_std ("__M6809__");
+		builtin_define_std ("__m6809__");
+	}
+
+	if (TARGET_BYTE_INT)
+		builtin_define_std ("__int8__");
+	else
+		builtin_define_std ("__int16__");
+
+	switch (m6809_abi_version)
+	{
+		case M6809_ABI_VERSION_STACK:
+			builtin_define_std ("__regargs__");
+			builtin_define_std ("__ABI_STACK__");
+			break;
+		case M6809_ABI_VERSION_REGS:
+			builtin_define_std ("__ABI_REGS__");
+			break;
+		case M6809_ABI_VERSION_BX:
+			builtin_define_std ("__ABI_BX__");
+			break;
+		default:
+			break;
+	}
+
+	if (TARGET_WPC)
+		builtin_define_std ("__WPC__");
+
+	if (TARGET_DRET)
+		builtin_define_std ("__DRET__");
+}
+#endif
+
+#define MAX_ASM_ASCII_STRING 48
+
+void
+m6809_output_ascii (FILE *fp, const char *str, unsigned long size)
+{
+	unsigned long i;
+	bool use_ascii = true;
+
+	/* If the size is too large, then break this up into multiple
+	outputs.  The assembler can only output roughly 48 bytes at a
+	time.  Note that if there are lots of escape sequences in
+	the string, this may fail. */
+	if (size > MAX_ASM_ASCII_STRING)
+	{
+		m6809_output_ascii (fp, str, MAX_ASM_ASCII_STRING);
+		m6809_output_ascii (fp, str + MAX_ASM_ASCII_STRING, 
+			size - MAX_ASM_ASCII_STRING);
+		return;
+	}
+
+	/* Check for 8-bit codes, which cannot be embedded in an .ascii */
+	for (i = 0; i < size; i++)
+	{
+		int c = str[i] & 0377;
+		if (c >= 0x80)
+		{
+			use_ascii = false;
+			break;
+		}
+	}
+
+	if (use_ascii)
+		fprintf (fp, "\t.ascii \"");
+
+	for (i = 0; i < size; i++)
+	{
+		int c = str[i] & 0377;
+
+		if (use_ascii)
+		{
+		/* Just output the plain character if it is printable,
+		otherwise output the escape code for the character.
+		The assembler recognizes the same C-style octal escape sequences,
+		except that it only supports 7-bit codes. */
+		if (c >= ' ' && c < 0177 && c != '\\' && c != '"')
+  			putc (c, fp);
+		else switch (c) 
+		{
+			case '\n':
+#ifndef TARGET_COCO
+				fputs ("\\n", fp);
+				break;
+#endif
+				/* On the CoCo, we fallthrough and treat '\n' like '\r'. */
+			case '\r':
+				fputs ("\\r", fp);
+				break;
+			case '\t':
+				fputs ("\\t", fp);
+				break;
+			case '\f':
+				fputs ("\\f", fp);
+				break;
+			case 0:
+				fputs ("\\0", fp);
+				break;
+			default:
+				fprintf (fp, "\\%03o", c);
+				break;
+		}
+		}
+		else
+		{
+			fprintf (fp, "\t.byte\t0x%02X\n", c);
+		}
+	}
+
+	if (use_ascii)
+		fprintf (fp, "\"\n");
+}
+
+
+void
+m6809_output_quoted_string (FILE *asm_file, const char *string)
+{
+	char c;
+
+	if (strlen (string) > MAX_ASM_ASCII_STRING)
+	{
+		/* The string length is too large.  We'll have to truncate it.
+		This is only called from debugging functions, so it's usually
+		not critical. */
+
+		char truncated_string[MAX_ASM_ASCII_STRING+1];
+
+		/* Copy as many characters as we can. */
+		strncpy (truncated_string, string, MAX_ASM_ASCII_STRING);
+		truncated_string[MAX_ASM_ASCII_STRING] = '\0';
+		string = truncated_string;
+	}
+
+	/* Copied from toplev.c */
+
+	putc ('\"', asm_file);
+	while ((c = *string++) != 0) {
+		if (ISPRINT (c)) {
+			if (c == '\"' || c == '\\')
+				putc ('\\', asm_file);
+			putc (c, asm_file);
+		}
+      else
+			fprintf (asm_file, "\\%03o", (unsigned char) c);
+	}
+	putc ('\"', asm_file);
+}
+
+
+/** Output the assembly code for a shift instruction where the
+ * shift count is not constant. */
+void
+m6809_output_shift_insn (int rtx_code, rtx *operands)
+{
+	struct shift_opcode *op;
+
+	if (GET_CODE (operands[2]) == CONST_INT)
+		abort ();
+
+	if (optimize_size && GET_MODE (operands[0]) == HImode)
+	{
+		switch (rtx_code)
+		{
+			case ASHIFT:
+				output_asm_insn ("jsr\t_ashlhi3", operands);
+				break;
+			case ASHIFTRT:
+				output_asm_insn ("jsr\t_ashrhi3", operands);
+				break;
+			case LSHIFTRT:
+				output_asm_insn ("jsr\t_lshrhi3", operands);
+				break;
+		}
+	}
+	else if (GET_MODE (operands[0]) == HImode)
+	{
+		switch (rtx_code)
+		{
+			case ASHIFT:
+				m6809_gen_register_shift (operands, "aslb", "rola");
+				break;
+			case ASHIFTRT:
+				m6809_gen_register_shift (operands, "asra", "rorb");
+				break;
+			case LSHIFTRT:
+				m6809_gen_register_shift (operands, "lsra", "rorb");
+				break;
+		}
+	}
+	else
+	{
+		switch (rtx_code)
+		{
+			case ASHIFT:
+				m6809_gen_register_shift (operands, "aslb", NULL);
+				break;
+			case ASHIFTRT:
+				m6809_gen_register_shift (operands, "asrb", NULL);
+				break;
+			case LSHIFTRT:
+				m6809_gen_register_shift (operands, "lsrb", NULL);
+				break;
+		}
+	}
+}
+
+
+void
+m6809_emit_move_insn (rtx dst, rtx src)
+{
+	emit_insn (gen_rtx_SET (VOIDmode, dst, src));
+	if (ACC_A_REG_P (dst))
+		emit_insn (gen_rtx_USE (VOIDmode, dst));
+}
+
+
+/** Split a complex shift instruction into multiple CPU
+ * shift instructions. */
+void
+m6809_split_shift (enum rtx_code code, rtx *operands)
+{
+	enum machine_mode mode;
+	int count;
+
+	mode = GET_MODE (operands[0]);
+	count = INTVAL (operands[2]);
+	
+	/* Handle a shift count outside the range of 0 .. N-1, where
+	 * N is the mode size in bits.  We normalize the count, and
+	 * for negative counts we also invert the direction of the
+	 * shift. */
+	if ((count < 0) || (count >= 8 * GET_MODE_SIZE (mode)))
+	{
+		if (count < 0)
+		{
+			count = -count;
+			code = (code == ASHIFT) ? ASHIFTRT : ASHIFT;
+		}
+		count %= (8 * GET_MODE_SIZE (mode));
+		m6809_emit_move_insn (operands[0],
+			gen_rtx_fmt_ee (code, mode, operands[1],
+				gen_rtx_CONST_INT (VOIDmode, count)));
+	}
+
+	/* Handle shift by zero explicitly as a no-op. */
+	if (count == 0)
+	{
+		emit_insn (gen_nop ());
+		return;
+	}
+
+	/* Decompose the shift by a constant N > 8 into two
+	 * shifts, first by 8 and then by N-8.
+	 * This "speeds up" the process for large shifts that would be
+	 * handled below, but allows for some optimization.
+	 * In some cases shift by 8 can be implemented fast.  If an
+	 * instruction to shift by 8 is defined, it will be used here;
+	 * otherwise it will be further decomposed as below. */
+	if (mode == HImode && count > 8)
+	{
+		rtx output = operands[0];
+
+		m6809_emit_move_insn (operands[0],
+			gen_rtx_fmt_ee (code, mode, operands[1],
+				gen_rtx_CONST_INT (VOIDmode, 8)));
+
+		/* Unsigned shifts always produce a zero in either the
+		 * upper or lower half of the output; then, that part
+		 * does not need to be shifted anymore.  We modify the
+		 * output and the subsequent instructions to operate in
+		 * QImode only on the relevant part. */
+		if (REG_P (output))
+		{
+			if (code == ASHIFT)
+			{
+				output = gen_rtx_REG (QImode, HARD_A_REGNUM);
+				mode = QImode;
+			}
+			else
+			{
+				output = gen_rtx_REG (QImode, HARD_D_REGNUM);
+				mode = QImode;
+			}
+		}
+
+		m6809_emit_move_insn (output,
+			gen_rtx_fmt_ee (code, mode, copy_rtx (output), 
+				gen_rtx_CONST_INT (VOIDmode, count-8)));
+		return;
+	}
+
+	/* Rewrite the unsigned shift of an 8-bit register by a large constant N
+	 * (near to the maximum of 8) as a rotate and mask. */
+	if (mode == QImode && REG_P (operands[0]) && count >= ((code == ASHIFTRT) ? 7 : 6))
+	{
+		unsigned int mask;
+		unsigned int was_signed = (code == ASHIFTRT);
+
+		code = (code == ASHIFT) ? ROTATERT : ROTATE;
+		if (code == ROTATE)
+			mask = (count == 6) ? 0x03 : 0x01;
+		else
+			mask = (count == 6) ? 0xC0 - 0x100 : 0x80 - 0x100;
+		count = 9 - count;
+
+		do {
+			m6809_emit_move_insn (operands[0],
+				gen_rtx_fmt_ee (code, QImode, operands[1], const1_rtx));
+		} while (--count != 0);
+
+		m6809_emit_move_insn (operands[0],
+			gen_rtx_fmt_ee (AND, QImode, operands[1],
+				gen_rtx_CONST_INT (VOIDmode, mask)));
+
+		if (was_signed)
+		{
+			emit_insn (gen_negqi2 (operands[0], copy_rtx (operands[0])));
+			if (ACC_A_REG_P (operands[0]))
+				emit_insn (gen_rtx_USE (VOIDmode, operands[0]));
+		}
+		return;
+	}
+
+	/* Decompose the shift by any constant N > 1 into a sequence
+	 * of N shifts.
+	 * This is done recursively, by creating a shift by 1 and a
+	 * shift by N-1, as long as N>1. */
+	if (count > 1)
+	{
+		m6809_emit_move_insn (operands[0],
+			gen_rtx_fmt_ee (code, mode, operands[1], const1_rtx));
+	
+		m6809_emit_move_insn (operands[0],
+			gen_rtx_fmt_ee (code, mode, operands[1], 
+				gen_rtx_CONST_INT (VOIDmode, count-1)));
+		return;
+	}
+	
+	/* Decompose the single shift of a 16-bit quantity into two
+	 * CPU instructions, one for each 8-bit half.
+	 */
+	if (mode == HImode && count == 1)
+	{
+		rtx first, second;
+		enum rtx_code rotate_code;
+
+		rotate_code = (code == ASHIFT) ? ROTATE : ROTATERT;
+
+		/* Split the operand into two 8-bit entities.
+		 * FIRST is the one that will get shifted via a regular CPU
+		 * instruction.
+		 * SECOND is the one that will have the result of the first shift
+		 * rotated in.
+		 *
+		 * We initialize first and second as if we are doing a left shift,
+		 * then swap the operands if it's a right shift.
+		 */
+		if (REG_P (operands[0]))
+		{
+			first = gen_rtx_REG (QImode, HARD_D_REGNUM); /* HARD_B_REGNUM? */
+			second = gen_rtx_REG (QImode, HARD_A_REGNUM);
+		}
+		else
+		{
+			first = adjust_address (operands[0], QImode, 1);
+			second = adjust_address (operands[0], QImode, 0);
+		}
+
+		if (rotate_code == ROTATERT)
+		{
+			rtx tmp; tmp = first; first = second; second = tmp;
+		}
+
+		/* Decompose into a shift and a rotate instruction. */
+		m6809_emit_move_insn (first,
+			gen_rtx_fmt_ee (code, QImode, copy_rtx (first), const1_rtx));
+		m6809_emit_move_insn (second,
+			gen_rtx_fmt_ee (rotate_code, QImode, copy_rtx (second), const1_rtx));
+		return;
+	}
+}
+
+
+/** Adjust register usage based on compile-time flags. */
+void
+m6809_conditional_register_usage (void)
+{
+	unsigned int soft_regno;
+
+#ifdef CONFIG_SOFT_REGS_ALWAYS
+	m6809_soft_regs = CONFIG_SOFT_REGS_ALWAYS;
+#else
+	if (!m6809_soft_reg_count)
+		return;
+	m6809_soft_regs = atoi (m6809_soft_reg_count);
+#endif
+
+	if (m6809_soft_regs == 0)
+		return;
+
+	if (m6809_soft_regs > NUM_M_REGS)
+		m6809_soft_regs = NUM_M_REGS;
+
+	/* Registers are marked FIXED by default.  Free up if
+	the user wishes. */
+	for (soft_regno = 1; soft_regno < m6809_soft_regs; soft_regno++)
+	{
+		fixed_regs[SOFT_M0_REGNUM + soft_regno] = 0;
+
+		/* Mark the softregs as call-clobbered, so that they need
+		 * not be saved/restored on function entry/exit. */
+		call_used_regs[SOFT_M0_REGNUM + soft_regno] = 1;
+	}
+}
+
+
+/** Return a RTX representing how to return a value from a function.
+  VALTYPE gives the type of the value, FUNC identifies the function
+  itself.
+
+  In general, we only care about the width of the result. */
+rtx
+m6809_function_value (const tree valtype, const tree func ATTRIBUTE_UNUSED)
+{
+   unsigned int regno;
+	enum machine_mode mode;
+
+	/* Get the mode (i.e. width) of the result. */
+	mode = TYPE_MODE (valtype);
+
+	if (lookup_attribute ("boolean", TYPE_ATTRIBUTES (valtype)))
+      regno = HARD_Z_REGNUM;
+   else if (mode == QImode || (TARGET_DRET && mode == HImode))
+      regno = HARD_D_REGNUM;
+   else
+      regno = HARD_X_REGNUM;
+   return gen_rtx_REG (mode, regno);
+}
+
+
+/** Return 1 if REGNO is possibly needed to return the result
+of a function, 0 otherwise. */
+int
+m6809_function_value_regno_p (unsigned int regno)
+{
+	if (regno == HARD_Z_REGNUM)
+		return 1;
+	else if ((TARGET_BYTE_INT || TARGET_DRET) && regno == HARD_D_REGNUM)
+		return 1;
+	else if (!TARGET_DRET && regno == HARD_X_REGNUM)
+		return 1;
+	else
+		return 0;
+}
+
+
+#ifdef TRACE_PEEPHOLE
+int
+m6809_match_peephole2 (unsigned int peephole_id, unsigned int stage)
+{
+	if (stage == PEEP_END)
+	{
+		printf ("%s: peephole %d pattern and predicate matched\n",
+			main_input_filename, peephole_id);
+		fflush (stdout);
+	}
+	else if (stage == PEEP_COND)
+	{
+		printf ("%s: peephole %d? at least pattern matched\n",
+			main_input_filename, peephole_id);
+		fflush (stdout);
+	}
+	return 1;
+}
+#else
+int
+m6809_match_peephole2 (unsigned int peephole_id ATTRIBUTE_UNUSED,
+	unsigned int stage ATTRIBUTE_UNUSED)
+{
+	return 1;
+}
+#endif /* TRACE_PEEPHOLE */
+
+
+/** Return 1 if it is OK to store a value of MODE in REGNO. */
+int
+m6809_hard_regno_mode_ok (unsigned int regno, enum machine_mode mode)
+{
+   /* Soft registers, as they are just memory, can really hold
+   values of any type.  However we restrict them to values of
+   size HImode or QImode to prevent exhausting them for larger
+   values.
+      Word values cannot be placed into the first soft register,
+   as it is the low byte that is being placed there, which
+   corrupts the (non-soft) register before it. */
+   if (M_REGNO_P (regno))
+   {
+      switch (GET_MODE_SIZE (mode))
+      {
+         case 1:
+            return 1;
+         case 2:
+            return regno != SOFT_M0_REGNUM;
+         default:
+            return 0;
+      }
+   }
+
+   /* VOIDmode can be stored anywhere */
+   else if (mode == VOIDmode)
+      return 1;
+
+   /* Zero is a reserved register, but problems occur if we don't
+   say yes here??? */
+   else if (regno == 0)
+      return 1;
+
+   /* For other registers, return true only if the requested size
+   exactly matches the hardware size. */
+   else if ((G_REGNO_P (regno)) && (GET_MODE_SIZE (mode) == 2))
+      return 1;
+   else if ((BYTE_REGNO_P (regno)) && (GET_MODE_SIZE (mode) == 1))
+      return 1;
+   else
+      return 0;
+}
+
+
+/* exp is the call expression.  DECL is the called function,
+ * or NULL for an indirect call */
+bool
+m6809_function_ok_for_sibcall (tree decl, tree exp ATTRIBUTE_UNUSED)
+{
+	tree type, arg;
+   const char *name;
+	bool result = 0;
+	int argcount = 0;
+	int step = 1;
+
+	/* If there is no DECL, it is an indirect call.
+	 * Never optimize this??? */
+	if (decl == NULL)
+		goto done;
+
+	/* Never allow an interrupt handler to be optimized this way. */
+	if (m6809_function_has_type_attr_p (decl, "interrupt"))
+		goto done;
+
+	/* Skip sibcall if the type can't be found for
+	 * some reason */
+	step++;
+	name = IDENTIFIER_POINTER (DECL_NAME (decl));
+	type = TREE_TYPE (decl);
+	if (type == NULL)
+		goto done;
+
+	/* Skip sibcall if the target is a far function */
+	step++;
+	if (far_function_type_p (type) != NULL)
+		goto done;
+
+	/* Skip sibcall if the called function's arguments are
+	 * variable */
+	step++;
+	if (TYPE_ARG_TYPES (type) == NULL)
+		goto done;
+
+	/* Allow sibcalls in other cases. */
+	result = 1;
+done:
+	/* printf ("%s ok for sibcall? %s, step %d, args %d\n", name, result ? "yes" : "no", step, argcount); */
+	return result;
+}
+
+
+/** Emit code for the 'casesi' pattern.
+ * This pattern is only used in 8-bit mode, and can be disabled
+ * with -mold-case there as well.  The rationale for this is to
+ * do a better job than the simpler but well-tested 'tablejump'
+ * method.
+ *
+ * For small jumptables, where the switch expression is an
+ * 8-bit value, the lookup can be done more efficiently
+ * using the "B,X" style index mode. */
+void
+m6809_do_casesi (rtx index, rtx lower_bound, rtx range,
+	rtx table_label, rtx default_label)
+{
+	enum machine_mode mode;
+	rtx scaled;
+	rtx table_in_reg;
+
+	/* expr.c has to be patched so that it does not promote
+	 * the expression to SImode, but rather to HImode.
+	 * Fail now if that isn't the case. */
+	if (GET_MODE_SIZE (GET_MODE (index)) > GET_MODE_SIZE (HImode))
+		error ("try_casesi promotion bug");
+
+	/* Determine whether or not we are going to work primarily in
+	 * QImode or HImode.  This depends on the size of the index
+	 * into the lookup table.  QImode can only be used when the
+	 * index is less than 0x40, since it will be doubled but
+	 * must remain unsigned. */
+	if ((GET_CODE (range) == CONST_INT) && (INTVAL (range) < 0x40))
+		mode = QImode;
+	else
+		mode = HImode;
+
+	/* Convert to QImode if necessary */
+	if (mode == QImode)
+	{
+		index = gen_lowpart_general (mode, index);
+		lower_bound = gen_lowpart_general (mode, lower_bound);
+	}
+
+	/* Translate from case value to table index by subtraction */
+	if (lower_bound != const0_rtx)
+		index = expand_binop (mode, sub_optab, index, lower_bound,
+			NULL_RTX, 0, OPTAB_LIB_WIDEN);
+
+	/* Emit compare-and-jump to test for index out-of-range */
+	emit_cmp_and_jump_insns (index, range, GTU, NULL_RTX, mode, 1,
+		default_label);
+
+	/* Put the table address is in a register */
+	table_in_reg = gen_reg_rtx (Pmode);
+	emit_move_insn (table_in_reg, gen_rtx_LABEL_REF (Pmode, table_label));
+
+	/* Emit table lookup and jump */
+	if (mode == QImode)
+	{
+		/* Scale the index */
+		scaled = gen_reg_rtx (QImode);
+		emit_insn (gen_ashlqi3 (scaled, index, const1_rtx));
+
+		/* Emit the jump */
+		emit_jump_insn (gen_tablejump_short_offset (scaled, table_in_reg));
+	}
+	else
+	{
+		/* Scale the index */
+		emit_insn (gen_ashlhi3 (index, index, const1_rtx));
+
+		/* Emit the jump */
+		emit_jump_insn (gen_tablejump_long_offset (index, table_in_reg));
+	}
+
+	/* Copied from expr.c */
+	if (!CASE_VECTOR_PC_RELATIVE && !flag_pic)
+		emit_barrier ();
+}
+
+
+/** Output the assembly code for a 32-bit add/subtract. */
+void
+m6809_output_addsi3 (int rtx_code, rtx *operands)
+{
+	rtx xoperands[8];
+	rtx dst = operands[0];
+
+	/* Prepare the operands by splitting each SImode into two HImodes
+	that can be operated independently.  The high word of operand 1
+	is further divided into two QImode components for use with 'adc'
+	style instructions. */
+	xoperands[7] = operands[3];
+
+	xoperands[0] = adjust_address (dst, HImode, 2);
+	xoperands[3] = adjust_address (dst, HImode, 0);
+
+#if 1
+	xoperands[2] = adjust_address (operands[1], HImode, 2);
+	xoperands[6] = adjust_address (operands[1], HImode, 0);
+
+	/* Operand 2 may be a MEM or a CONST_INT */
+	if (GET_CODE (operands[2]) == CONST_INT)
+	{
+		xoperands[1] = gen_int_mode (INTVAL (operands[2]) & 0xFFFF, HImode);
+		xoperands[4] = gen_int_mode ((INTVAL (operands[2]) >> 24) & 0xFF, QImode);
+		xoperands[5] = gen_int_mode ((INTVAL (operands[2]) >> 16) & 0xFF, QImode);
+	}
+	else
+	{
+		xoperands[1] = adjust_address (operands[2], HImode, 2);
+		xoperands[4] = adjust_address (operands[2], QImode, 0);
+		xoperands[5] = adjust_address (operands[2], QImode, 1);
+	}
+
+#endif
+
+#if 0
+	xoperands[1] = adjust_address (operands[1], HImode, 2);
+	xoperands[4] = adjust_address (operands[1], QImode, 0);
+	xoperands[5] = adjust_address (operands[1], QImode, 1);
+
+	/* Operand 2 may be a MEM or a CONST_INT */
+	if (GET_CODE (operands[2]) == CONST_INT)
+	{
+		xoperands[2] = gen_int_mode ((INTVAL (operands[2])) & 0xFFFF, HImode);
+		xoperands[6] = gen_int_mode ((INTVAL (operands[2]) >> 16) & 0xFFFF, HImode);
+	}
+	else
+	{
+		xoperands[2] = adjust_address (operands[2], HImode, 2);
+		xoperands[6] = adjust_address (operands[2], HImode, 0);
+	}
+#endif
+
+	/* Output the assembly code. */
+	if (rtx_code == PLUS)
+	{
+		output_asm_insn ("ld%7\t%2", xoperands);
+		output_asm_insn ("add%7\t%1", xoperands);
+		output_asm_insn ("st%7\t%0", xoperands);
+		output_asm_insn ("ld%7\t%6", xoperands);
+		output_asm_insn ("adcb\t%5", xoperands);
+		output_asm_insn ("adca\t%4", xoperands);
+		output_asm_insn ("st%7\t%3", xoperands);
+	}
+	else
+	{
+		output_asm_insn ("ld%7\t%2", xoperands);
+		output_asm_insn ("sub%7\t%1", xoperands);
+		output_asm_insn ("st%7\t%0", xoperands);
+		output_asm_insn ("ld%7\t%6", xoperands);
+		output_asm_insn ("sbcb\t%5", xoperands);
+		output_asm_insn ("sbca\t%4", xoperands);
+		output_asm_insn ("st%7\t%3", xoperands);
+	}
+}
+
+
+#if 0
+/** Output the assembly code for a 32-bit shift.
+Operands 0 and 1 must be the same rtx, forced by a matching
+constraint.  Operand 2 must be a CONST_INT.  Operand 3 is
+"d" in case a temporary reg is needed. */
+void
+m6809_output_shiftsi3 (int rtx_code, rtx *operands)
+{
+	unsigned int count = INTVAL (operands[2]) % 32;
+	unsigned int size = 4; /* sizeof (SImode) */
+	int s;
+	rtx xoperands[4];
+	int op;
+	int start, end, step;
+
+	/* Initialize */
+	if (rtx_code == ASHIFT)
+	{
+		start = size-1;
+		end = -1;
+		step = -1;
+	}
+	else
+	{
+		start = 0;
+		end = size;
+		step = 1;
+	}
+
+	xoperands[2] = operands[2];
+	xoperands[3] = operands[3];
+
+	if (count <= 0)
+		abort ();
+	if (rtx_code == ROTATE || rtx_code == ROTATERT)
+		abort ();
+
+	/* Extract bit shifts over 16 bits by HImode moves. */
+	if (count >= 16)
+	{
+	}
+
+	/* Extract bit shifts over 8 bits by QImode moves. */
+	if (count >= 8)
+	{
+	}
+
+	/* Iterate over the number of bits to be shifted. */
+	while (count > 0)
+	{
+		/* Each bit to be shifted requires 1 proper bit shift
+		and 3 rotates. */
+
+		/* First, do the arithmetic/logical shift.  Left shifts
+		start from the LSB; right shifts start from the MSB. */
+		xoperands[0] = adjust_address (operands[0], QImode, start);
+		switch (rtx_code)
+		{
+			case ASHIFT:
+				output_asm_insn ("asl\t%0", xoperands);
+				start--;
+				break;
+			case ASHIFTRT:
+				output_asm_insn ("asr\t%0", xoperands);
+				start++;
+				break;
+			case LSHIFTRT:
+				output_asm_insn ("lsr\t%0", xoperands);
+				start++;
+				break;
+		}
+
+		/* Next, rotate the other bytes */
+		for (s = start; s != end; s += step)
+		{
+			xoperands[0] = adjust_address (operands[0], QImode, s);
+			switch (rtx_code)
+			{
+				case ASHIFT:
+					output_asm_insn ("rol\t%0", xoperands);
+					break;
+				case ASHIFTRT:
+				case LSHIFTRT:
+					output_asm_insn ("ror\t%0", xoperands);
+					break;
+			}
+		}
+		count--;
+	}
+}
+#endif
+
+int
+power_of_two_p (unsigned int n)
+{
+	return (n & (n-1)) == 0;
+}
+
+
+int
+m6809_can_eliminate (int from, int to)
+{
+	if (from == ARG_POINTER_REGNUM && to == STACK_POINTER_REGNUM)
+		return !frame_pointer_needed;
+	return 1;
+}
+
+
+int
+m6809_initial_elimination_offset (int from, int to)
+{
+	switch (from)
+	{
+		case ARG_POINTER_REGNUM:
+			return get_frame_size () + m6809_get_regs_size (m6809_get_live_regs ());
+		case FRAME_POINTER_REGNUM:
+			return get_frame_size ();
+		default:
+			gcc_unreachable ();
+	}
+}
+
+
+bool
+m6809_frame_pointer_required (void)
+{
+	return false;
+}
+
+
+/* Defines the target-specific hooks structure. */
+struct gcc_target targetm = TARGET_INITIALIZER;
diff -urN gcc-4.6.4-clean/gcc/config/m6809/m6809.h gcc-4.6.4/gcc/config/m6809/m6809.h
--- gcc-4.6.4-clean/gcc/config/m6809/m6809.h	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/m6809.h	2017-11-29 17:11:09.221248469 -0700
@@ -0,0 +1,1336 @@
+/* Definitions of target machine for GNU compiler.  MC6809 version.
+
+ MC6809 Version by Tom Jones (jones@sal.wisc.edu)
+ Space Astronomy Laboratory
+ University of Wisconsin at Madison
+
+ minor changes to adapt it to gcc-2.5.8 by Matthias Doerfel
+ ( msdoerfe@informatik.uni-erlangen.de )
+ also added #pragma interrupt (inspired by gcc-6811)
+
+ minor changes to adapt it to gcc-2.8.0 by Eric Botcazou
+ (ebotcazou@multimania.com)
+
+ minor changes to adapt it to egcs-1.1.2 by Eric Botcazou
+ (ebotcazou@multimania.com)
+
+ minor changes to adapt it to gcc-2.95.3 by Eric Botcazou
+ (ebotcazou@multimania.com)
+
+ changes for gcc-3.1.1 by ???
+
+ further changes for gcc-3.1.1 and beyond by Brian Dominy
+ (brian@oddchange.com)
+
+ even more changes for gcc-4.6.1 by William Astle (lost@l-w.ca)
+
+This file is part of GCC.
+
+GCC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 3, or (at your option)
+any later version.
+
+GCC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with GCC; see the file COPYING3.  If not see
+<http://www.gnu.org/licenses/>.  */
+
+
+/* Helper macros for creating strings with macros */
+#define C_STRING(x) C_STR(x)
+#define C_STR(x) #x
+
+/* Certain parts of GCC include host-side includes, which is bad.
+ * Some things that get pulled in need to be undone.
+ */
+#undef HAVE_GAS_HIDDEN
+
+/* Names to predefine in the preprocessor for this target machine.  */
+/*#define TARGET_CPU_CPP_BUILTINS() m6809_cpu_cpp_builtins () */
+#define TARGET_CPU_CPP_BUILTINS() do \
+	{ \
+		if (TARGET_6309) \
+		{ \
+			builtin_define_std ("__M6309__"); \
+			builtin_define_std ("__m6309__"); \
+		} \
+		else \
+		{ \
+			builtin_define_std ("__M6809__"); \
+			builtin_define_std ("__m6809__"); \
+		} \
+ \
+		if (TARGET_BYTE_INT) \
+			builtin_define_std ("__int8__"); \
+		else \
+			builtin_define_std ("__int16__"); \
+ \
+		switch (m6809_abi_version) \
+		{ \
+			case M6809_ABI_VERSION_STACK: \
+				builtin_define_std ("__regargs__"); \
+				builtin_define_std ("__ABI_STACK__"); \
+				break; \
+			case M6809_ABI_VERSION_REGS: \
+				builtin_define_std ("__ABI_REGS__"); \
+				break; \
+			case M6809_ABI_VERSION_BX: \
+				builtin_define_std ("__ABI_BX__"); \
+				break; \
+			default: \
+				break; \
+		} \
+ \
+		if (TARGET_WPC) \
+			builtin_define_std ("__WPC__"); \
+ \
+		if (TARGET_DRET) \
+			builtin_define_std ("__DRET__"); \
+	} while (0)
+
+/* As an embedded target, we have no libc.  */
+#ifndef inhibit_libc
+#define inhibit_libc
+#endif
+
+/* Print subsidiary information on the compiler version in use.  */
+#define TARGET_VERSION fprintf (stderr, " (MC6809)");
+
+/* Run-time compilation parameters selecting different hardware subsets.  */
+/*extern int target_flags; */
+extern short *reg_renumber;	/* def in local_alloc.c */
+
+/* Runtime current values of section names */
+extern int section_changed;
+extern char code_section_op[], data_section_op[], bss_section_op[];
+
+#define WARNING_OPT 0,
+/*extern const char *m6809_abi_version_ptr; */
+extern unsigned int m6809_soft_regs;
+extern unsigned int m6809_abi_version;
+
+/* ABI versions */
+
+#define M6809_ABI_VERSION_STACK 0
+#define M6809_ABI_VERSION_REGS 1
+#define M6809_ABI_VERSION_BX 2
+#define M6809_ABI_VERSION_LATEST  (M6809_ABI_VERSION_BX)
+
+/* Allow $ in identifiers */
+#define DOLLARS_IN_IDENTIFIERS 1
+
+/*--------------------------------------------------------------
+	Target machine storage layout
+--------------------------------------------------------------*/
+
+/* Define this if most significant bit is lowest numbered
+   in instructions that operate on numbered bit-fields.  */
+#define BITS_BIG_ENDIAN 0
+
+/* Define to 1 if most significant byte of a word is the lowest numbered. */
+#define BYTES_BIG_ENDIAN 1
+
+/* Define to 1 if most significant word of a multiword value is the lowest numbered. */
+#define WORDS_BIG_ENDIAN 1
+
+/* Number of bits in an addressible storage unit */
+#define BITS_PER_UNIT 8
+
+/* Width in bits of a "word", or the contents of a machine register.
+ * Although the 6809 has a few byte registers, define this to 16-bits
+ * since this is the natural size of most registers. */
+#define BITS_PER_WORD 16
+
+/* Width of a word, in units (bytes).  */
+#define UNITS_PER_WORD (BITS_PER_WORD/8)
+
+/* Width in bits of a pointer.  See also the macro `Pmode' defined below.  */
+#define POINTER_SIZE 16
+
+/* Allocation boundary (bits) for storing pointers in memory.  */
+#define POINTER_BOUNDARY 8
+
+/* Allocation boundary (bits) for storing arguments in argument list.  */
+/* PARM_BOUNDARY is divided by BITS_PER_WORD in expr.c -- tej */
+#define PARM_BOUNDARY 8
+
+/* Boundary (bits) on which stack pointer should be aligned.  */
+#define STACK_BOUNDARY 8
+
+/* Allocation boundary (bits) for the code of a function.  */
+#define FUNCTION_BOUNDARY 8
+
+/* Alignment of field after `int : 0' in a structure.  */
+#define EMPTY_FIELD_BOUNDARY 8
+
+/* Every structure's size must be a multiple of this.  */
+#define STRUCTURE_SIZE_BOUNDARY 8
+
+/* Largest mode size to use when putting an object, including
+ * a structure, into a register.  By limiting this to 16, no
+ * 32-bit objects will ever be allocated to a pair of hard
+ * registers.  This is a good thing, since there aren't that
+ * many of them.  32-bit objects are only needed for floats
+ * and "long long"s.  Larger values have been tried and did not
+ * work. */
+#define MAX_FIXED_MODE_SIZE 16
+
+/* No data type wants to be aligned rounder than this.  */
+#define BIGGEST_ALIGNMENT 8
+
+/* Define this if move instructions will actually fail to work
+   when given unaligned data.  */
+#define STRICT_ALIGNMENT 0
+
+/*--------------------------------------------------------------
+	 Standard register usage.
+--------------------------------------------------------------*/
+
+/* Register values as bitmasks.
+ * TODO : merge D_REGBIT and B_REGBIT, and treat this as the same
+ * register. */
+#define RSVD1_REGBIT    (1 << HARD_RSVD1_REGNUM)
+#define D_REGBIT			(1 << HARD_D_REGNUM)
+#define X_REGBIT			(1 << HARD_X_REGNUM)
+#define Y_REGBIT			(1 << HARD_Y_REGNUM)
+#define U_REGBIT			(1 << HARD_U_REGNUM)
+#define S_REGBIT			(1 << HARD_S_REGNUM)
+#define PC_REGBIT			(1 << HARD_PC_REGNUM)
+#define Z_REGBIT        (1 << HARD_Z_REGNUM)
+#define A_REGBIT			(1 << HARD_A_REGNUM)
+#define B_REGBIT			(1 << HARD_B_REGNUM)
+#define CC_REGBIT			(1 << HARD_CC_REGNUM)
+#define DP_REGBIT			(1 << HARD_DP_REGNUM)
+#define SOFT_FP_REGBIT  (1 << SOFT_FP_REGNUM)
+#define SOFT_AP_REGBIT  (1 << SOFT_AP_REGNUM)
+#define M_REGBIT(n)		(1 << (SOFT_M0_REGNUM + n))
+
+/* Macros for dealing with set of registers.
+ * A register set is just a bitwise-OR of all the register
+ * bitmask values. */
+
+/* Which registers can hold 8-bits */
+#define BYTE_REGSET \
+	(Z_REGBIT | A_REGBIT | D_REGBIT | CC_REGBIT | DP_REGBIT)
+
+/* Which registers can hold 16-bits.
+ * Note: D_REGBIT is defined as both an 8-bit and 16-bit register */
+#define WORD_REGSET \
+	(D_REGBIT | X_REGBIT | Y_REGBIT | U_REGBIT | S_REGBIT | PC_REGBIT | SOFT_FP_REGBIT | SOFT_AP_REGBIT | RSVD1_REGBIT)
+
+/* Returns nonzero if a given REGNO is in the REGSET. */
+#define REGSET_CONTAINS_P(regno, regset)  (((1 << (regno)) & (regset)) != 0)
+
+/* Defines related to the number of soft registers supported.
+ * The actual number used may be less depending on -msoft-reg-count.
+ * If you change one of these, you should change them all. */
+#define NUM_M_REGS 8
+#define M_REGS_FIXED 1, 1, 1, 1, 1, 1, 1, 1
+#define M_REGS_CALL_USED 1, 1, 1, 1, 1, 1, 1, 1
+#define HARD_M_REGNUMS \
+   SOFT_M0_REGNUM+0, SOFT_M0_REGNUM+1, SOFT_M0_REGNUM+2, SOFT_M0_REGNUM+3, \
+   SOFT_M0_REGNUM+4, SOFT_M0_REGNUM+5, SOFT_M0_REGNUM+6, SOFT_M0_REGNUM+7
+
+#define SOFT_M_REGBITS  (((1UL << NUM_M_REGS) - 1) << (SOFT_M0_REGNUM))
+
+/* Number of actual hardware registers.
+   The hardware registers are assigned numbers for the compiler
+   from 0 to just below FIRST_PSEUDO_REGISTER.
+   All registers that the compiler knows about must be given numbers,
+   even those that are not normally considered general registers.
+   Make sure the constant below matches the value of SOFT_M0_REGNUM;
+   for some reason, GCC won't compile if that name is used here directly. */
+#ifdef SOFT_M0_REGNUM
+#if (SOFT_M0_REGNUM != 14)
+#error "bad register numbering"
+#endif
+#endif
+#define FIRST_PSEUDO_REGISTER (14 + NUM_M_REGS)
+
+/* 1 for registers that have pervasive standard uses
+   and are not available for the register allocator.
+   The psuedoregisters (M_REGS) are declared fixed here, but
+   will be unfixed if -msoft-reg-count is seen later.  */
+#define FIXED_REGISTERS \
+    {1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, M_REGS_FIXED, }
+  /* -, X, Y, U, S, PC,D, Z, A, B, C, DP,FP,AP,M... */
+
+/* 1 for registers not available across function calls.
+   These must include the FIXED_REGISTERS and also any
+   registers that can be used without being saved.
+   The latter must include the registers where values are returned
+   and the register where structure-value addresses are passed.
+   Aside from that, you can include as many other registers as you like.  */
+#define CALL_USED_REGISTERS \
+    {1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, M_REGS_CALL_USED, }
+  /* -, X, Y, U, S, PC,D, Z, A, B, C, DP,FP,AP,M... */
+
+/* Return number of consecutive hard regs needed starting at reg REGNO
+   to hold something of mode MODE.
+	For the 6809, we distinguish between word-length and byte-length
+	registers. */
+#define HARD_REGNO_NREGS(REGNO, MODE) \
+   (REGSET_CONTAINS_P (REGNO, WORD_REGSET) ? \
+		((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD) : \
+      (GET_MODE_SIZE (MODE)))
+
+
+/* Value is 1 if hard register REGNO can hold a value
+of machine-mode MODE. */
+#define HARD_REGNO_MODE_OK(REGNO, MODE) m6809_hard_regno_mode_ok (REGNO, MODE)
+
+/* Value is 1 if it is a good idea to tie two pseudo registers
+   when one has mode MODE1 and one has mode MODE2.
+   If HARD_REGNO_MODE_OK could produce different values for MODE1 and MODE2,
+   for any hard reg, then this must be 0 for correct output.  */
+#define MODES_TIEABLE_P(MODE1, MODE2) 0
+
+/* Specify the registers used for certain standard purposes.
+   The values of these macros are register numbers.  */
+
+/* program counter if referenced as a register */
+#define PC_REGNUM HARD_PC_REGNUM
+
+/* Register to use for pushing function arguments.  */
+#define STACK_POINTER_REGNUM HARD_S_REGNUM
+
+/* Base register for access to local variables of the function.
+ * Before reload, FRAME_POINTER_REGNUM will be used.  Later,
+ * the elimination pass will convert these to STACK_POINTER_REGNUM
+ * if possible, or else HARD_FRAME_POINTER_REGNUM.  The idea is to
+ * avoid tying up a hard register (U) for the frame pointer if
+ * it can be eliminated entirely, making it available for use as
+ * a general register. */
+#define FRAME_POINTER_REGNUM       SOFT_FP_REGNUM
+#define HARD_FRAME_POINTER_REGNUM  HARD_U_REGNUM
+
+/* Define a table of possible eliminations.
+ * The idea is to try to avoid using hard registers for the argument
+ * and frame pointers if they can be derived from the stack pointer
+ * instead, which already has a hard register reserved for it.
+ *
+ * The order of entries in this table will try to convert
+ * ARG_POINTER_REGNUM and FRAME_POINTER_REGNUM into stack pointer
+ * references first, but if that fails, they will be converted to use
+ * HARD_FRAME_POINTER_REGNUM.
+ */
+#define ELIMINABLE_REGS \
+{{ ARG_POINTER_REGNUM, STACK_POINTER_REGNUM }, \
+ { ARG_POINTER_REGNUM, HARD_FRAME_POINTER_REGNUM }, \
+ { FRAME_POINTER_REGNUM, STACK_POINTER_REGNUM }, \
+ { FRAME_POINTER_REGNUM, HARD_FRAME_POINTER_REGNUM }}
+
+/* #define CAN_ELIMINATE(FROM, TO) m6809_can_eliminate (FROM, TO) */
+
+/* Define how to offset the frame or argument pointer to turn it
+ * into a stack pointer reference.  This is based on the way that
+ * the frame is constructed in the function prologue. */
+#define INITIAL_ELIMINATION_OFFSET(FROM, TO, OFFSET) \
+	(OFFSET) = m6809_initial_elimination_offset (FROM, TO)
+
+/* Base register for access to arguments of the function.
+ * This is only used prior to reload; no instructions will ever
+ * be output referring to this register. */
+#define ARG_POINTER_REGNUM SOFT_AP_REGNUM
+
+/* Register in which static-chain is passed to a function.  */
+#define STATIC_CHAIN_REGNUM HARD_Y_REGNUM
+
+/* #define CONDITIONAL_REGISTER_USAGE (m6809_conditional_register_usage ()) */
+
+/* Order in which hard registers are allocated to pseudos.
+ *
+ * Since the D register is the only valid reg for 8-bit values
+ * now, avoid using it for 16-bit values by putting it after all
+ * other 16-bits.
+ *
+ * Prefer X first since the first 16-bit function argument goes
+ * there.  We may be able to pass in to a subroutine without
+ * a copy.
+ *
+ * Prefer U over Y since instructions using Y take one extra
+ * byte, and thus one extra cycle to execute.
+ */
+#define REG_ALLOC_ORDER \
+   {  HARD_X_REGNUM, HARD_U_REGNUM, HARD_Y_REGNUM, HARD_D_REGNUM, \
+	   HARD_M_REGNUMS, HARD_S_REGNUM, HARD_PC_REGNUM, \
+		HARD_B_REGNUM, HARD_A_REGNUM, HARD_CC_REGNUM, \
+		HARD_DP_REGNUM, SOFT_FP_REGNUM, SOFT_AP_REGNUM, \
+		6, HARD_Z_REGNUM }
+
+/*--------------------------------------------------------------
+	classes of registers
+--------------------------------------------------------------*/
+
+/* Define the classes of registers for register constraints in the
+   machine description.  Also define ranges of constants.
+
+   One of the classes must always be named ALL_REGS and include all hard regs.
+   If there is more than one class, another class must be named NO_REGS
+   and contain no registers.
+
+   The name GENERAL_REGS must be the name of a class (or an alias for
+   another name such as ALL_REGS).  This is the class of registers
+   that is allowed by "g" or "r" in a register constraint.
+   Also, registers outside this class are allocated only when
+   instructions express preferences for them.
+
+   The classes must be numbered in nondecreasing order; that is,
+   a larger-numbered class must never be contained completely
+   in a smaller-numbered class.
+
+   For any two classes, it is very desirable that there be another
+   class that represents their union.  */
+   
+enum reg_class {
+    NO_REGS,    /* The trivial class with no registers in it */
+    D_REGS,     /* 16-bit (word (HI)) data (D) */
+    ACC_A_REGS, /* The A register */
+    ACC_B_REGS, /* The B register */
+	 X_REGS,     /* The X register */
+	 Z_REGS,     /* The Z (zero-bit) register */
+    Q_REGS,     /* 8-bit (byte (QI)) data (A,B) */
+    M_REGS,     /* 8-bit (byte (QI)) soft registers */
+	 CC_REGS,    /* 8-bit condition code register */
+    I_REGS,     /* An index register (A,B,D) */
+    T_REGS,     /* 16-bit addresses, not including stack or PC (X,Y,U) */
+    A_REGS,     /* 16-bit addresses (X,Y,U,S,PC) */
+	 S_REGS,     /* 16-bit soft registers (FP, AP) */
+	 P_REGS,     /* 16-bit pushable registers (D,X,Y,U); omit PC and S */
+    G_REGS,     /* 16-bit data and address (D,X,Y,U,S,PC) */
+    ALL_REGS,   /* All registers */
+    LIM_REG_CLASSES
+};
+
+#define N_REG_CLASSES (int) LIM_REG_CLASSES
+
+/* Since GENERAL_REGS is a smaller class than ALL_REGS,
+   it is not an alias to ALL_REGS, but to G_REGS. */
+#define GENERAL_REGS G_REGS
+
+/* Give names of register classes as strings for dump file.   */
+#define REG_CLASS_NAMES \
+ {  "NO_REGS", "D_REGS", "ACC_A_REGS", "ACC_B_REGS", "X_REGS", "Z_REGS", "Q_REGS", "M_REGS", \
+	 "CC_REGS", "I_REGS", "T_REGS", "A_REGS", "S_REGS", "P_REGS", "G_REGS", \
+	 "ALL_REGS" }
+
+/* Define which registers fit in which classes.
+   This is an initializer for a vector of HARD_REG_SET
+   of length N_REG_CLASSES.  */
+
+#define D_REGSET	(D_REGBIT)
+#define ACC_A_REGSET (A_REGBIT)
+#define ACC_B_REGSET (D_REGBIT)
+#define X_REGSET (X_REGBIT)
+#define Z_REGSET (Z_REGBIT)
+#define Q_REGSET (D_REGBIT | A_REGBIT)
+#define M_REGSET (SOFT_M_REGBITS)
+#define CC_REGSET (CC_REGBIT)
+#define I_REGSET (A_REGBIT | B_REGBIT | D_REGBIT)
+#define T_REGSET (X_REGBIT | Y_REGBIT | U_REGBIT)
+#define A_REGSET (X_REGBIT | Y_REGBIT | U_REGBIT | S_REGBIT | PC_REGBIT)
+#define S_REGSET (SOFT_FP_REGBIT | SOFT_AP_REGBIT)
+#define P_REGSET (D_REGBIT | X_REGBIT | Y_REGBIT | U_REGBIT)
+#define G_REGSET \
+   (D_REGSET | Q_REGSET | I_REGSET | A_REGSET | M_REGSET | S_REGSET)
+#define ALL_REGSET (G_REGSET)
+
+#define REG_CLASS_CONTENTS { \
+	{0}, \
+	{D_REGSET}, \
+   {ACC_A_REGSET}, \
+   {ACC_B_REGSET}, \
+   {X_REGSET}, \
+   {Z_REGSET}, \
+	{Q_REGSET}, \
+	{M_REGSET}, \
+   {CC_REGSET}, \
+	{I_REGSET}, \
+	{T_REGSET}, \
+	{A_REGSET}, \
+	{S_REGSET}, \
+	{P_REGSET}, \
+	{G_REGSET}, \
+	{ALL_REGSET}, \
+}
+
+/* The same information, inverted.
+ * This is defined to use the REG_CLASS_CONTENTS defines above, so that
+ * these two sets of definitions are always consistent. */
+
+#define REGNO_REG_CLASS(REGNO) \
+  (D_REGNO_P (REGNO) ? D_REGS : \
+  (Z_REGNO_P (REGNO) ? Z_REGS : \
+  (ACC_A_REGNO_P (REGNO) ? ACC_A_REGS : \
+  (ACC_B_REGNO_P (REGNO) ? ACC_B_REGS : \
+  (X_REGNO_P (REGNO) ? X_REGS : \
+  (Q_REGNO_P (REGNO) ? Q_REGS : \
+  (M_REGNO_P (REGNO) ? M_REGS : \
+  (CC_REGNO_P (REGNO) ? CC_REGS : \
+  (I_REGNO_P (REGNO) ? I_REGS : \
+  (T_REGNO_P (REGNO) ? T_REGS : \
+  (A_REGNO_P (REGNO) ? A_REGS : \
+  (S_REGNO_P (REGNO) ? S_REGS : \
+  (P_REGNO_P (REGNO) ? P_REGS : \
+  (G_REGNO_P (REGNO) ? G_REGS : ALL_REGS))))))))))))))
+
+#define D_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, D_REGSET))
+#define ACC_A_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, ACC_A_REGSET))
+#define ACC_B_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, ACC_B_REGSET))
+#define X_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, X_REGSET))
+#define Z_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, Z_REGSET))
+#define Q_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, Q_REGSET))
+#define M_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, M_REGSET))
+#define CC_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, CC_REGSET))
+#define I_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, I_REGSET))
+#define T_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, T_REGSET))
+#define A_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, A_REGSET))
+#define S_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, S_REGSET))
+#define P_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, P_REGSET))
+#define G_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, G_REGSET))
+
+/* Macros that test an rtx 'X' to see if it's in a particular
+ * register class.  'X' need not be a REG necessarily. */
+
+#define D_REG_P(X) (REG_P (X) && D_REGNO_P (REGNO (X)))
+#define ACC_A_REG_P(X) (REG_P (X) && ACC_A_REGNO_P (REGNO (X)))
+#define ACC_B_REG_P(X) (REG_P (X) && ACC_B_REGNO_P (REGNO (X)))
+#define X_REG_P(X) (REG_P (X) && X_REGNO_P (REGNO (X)))
+#define Z_REG_P(X) (REG_P (X) && Z_REGNO_P (REGNO (X)))
+#define I_REG_P(X) (REG_P (X) && I_REGNO_P (REGNO (X)))
+#define T_REG_P(X) (REG_P (X) && T_REGNO_P (REGNO (X)))
+#define A_REG_P(X) (REG_P (X) && A_REGNO_P (REGNO (X)))
+#define S_REG_P(X) (REG_P (X) && S_REGNO_P (REGNO (X)))
+#define P_REG_P(X) (REG_P (X) && P_REGNO_P (REGNO (X)))
+#define Q_REG_P(X) (REG_P (X) && Q_REGNO_P (REGNO (X)))
+#define M_REG_P(X) (REG_P (X) && M_REGNO_P (REGNO (X)))
+#define CC_REG_P(X) (REG_P (X) && CC_REGNO_P (REGNO (X)))
+
+/* Redefine this in terms of BYTE_REGSET */
+#define BYTE_REGNO_P(REGNO) (REGSET_CONTAINS_P (REGNO, BYTE_REGSET))
+
+/* The class value for index registers, and the one for base regs.  */
+#define INDEX_REG_CLASS I_REGS
+#define BASE_REG_CLASS A_REGS
+
+/* Get reg_class from a letter in the machine description.  */
+#define REG_CLASS_FROM_LETTER(C) \
+  (((C) == 'a' ? A_REGS : \
+   ((C) == 'd' ? D_REGS : \
+	((C) == 'x' ? I_REGS : \
+	((C) == 't' ? M_REGS : \
+	((C) == 'c' ? CC_REGS : \
+	((C) == 'A' ? ACC_A_REGS : \
+	((C) == 'B' ? ACC_B_REGS : \
+	((C) == 'v' ? X_REGS : \
+	((C) == 'u' ? S_REGS : \
+	((C) == 'U' ? P_REGS : \
+	((C) == 'T' ? T_REGS : \
+	((C) == 'z' ? Z_REGS : \
+   ((C) == 'q' ? Q_REGS : NO_REGS))))))))))))))
+
+/*--------------------------------------------------------------
+   The letters I through O in a register constraint string
+   can be used to stand for particular ranges of immediate operands.
+   This macro defines what the ranges are.
+   C is the letter, and VALUE is a constant value.
+   Return 1 if VALUE is in the range specified by C.
+
+   For the 6809, J, K, L are used for indexed addressing.
+   `I' is used for the constant 1.
+   `J' is used for the 5-bit offsets.
+   `K' is used for the 8-bit offsets.
+   `L' is used for the range of signed numbers that fit in 16 bits.
+   `M' is used for the exact value '8'.
+   `N' is used for the constant -1.
+   `O' is used for the constant 0.
+--------------------------------------------------------------*/
+
+#define CONST_OK_FOR_LETTER_P(VALUE, C) \
+  ((C) == 'I' ? ((VALUE) == 1) : \
+   (C) == 'J' ? ((VALUE) >= -16 && (VALUE) <= 15) : \
+   (C) == 'K' ? ((VALUE) >= -128 && (VALUE) <= 127) : \
+   (C) == 'L' ? ((VALUE) >= -32768 && (VALUE) <= 32767) : \
+   (C) == 'M' ? ((VALUE) == 8) : \
+   (C) == 'N' ? ((VALUE) == -1) : \
+   (C) == 'O' ? ((VALUE) == 0) : 0)
+
+/* Similar, but for floating constants, and defining letters G and H.
+   No floating-point constants are valid on MC6809.  */
+#define CONST_DOUBLE_OK_FOR_LETTER_P(VALUE, C) \
+   ((C) == 'G' ? (GET_MODE_CLASS (GET_MODE (VALUE)) == MODE_FLOAT \
+     && VALUE == CONST0_RTX (GET_MODE (VALUE))) : 0)
+
+/* Given an rtx X being reloaded into a reg required to be
+   in class CLASS, return the class of reg to actually use.
+   In general this is just CLASS; but on some machines
+   in some cases it is preferable to use a more restrictive class.  */
+#define PREFERRED_RELOAD_CLASS(X,CLASS) m6809_preferred_reload_class(X,CLASS)
+
+#define SMALL_REGISTER_CLASSES  1
+
+/* Return the maximum number of consecutive registers
+   needed to represent mode MODE in a register of class CLASS.  */
+#define CLASS_MAX_NREGS(CLASS, MODE) \
+    ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD)
+
+/*--------------------------------------------------------------
+	Stack layout; function entry, exit and calling.
+--------------------------------------------------------------*/
+
+/* Define this if pushing a word on the stack
+   makes the stack pointer a smaller address.  */
+#define STACK_GROWS_DOWNWARD
+
+
+/* Define this if the nominal address of the stack frame
+   is at the high-address end of the local variables;
+   that is, each additional local variable allocated
+   goes at a more negative offset in the frame.  */
+#define FRAME_GROWS_DOWNWARD 1
+
+
+/* Offset within stack frame to start allocating local variables at.
+   If FRAME_GROWS_DOWNWARD, this is the offset to the END of the
+   first local allocated.  Otherwise, it is the offset to the BEGINNING
+   of the first local allocated.  */
+#define STARTING_FRAME_OFFSET 0
+
+
+/* Always push stack arguments for now.  Accumulation is not yet working. */
+#define PUSH_ROUNDING(BYTES) (BYTES)
+
+
+/* Offset of first parameter from the argument pointer register value.
+ * ARG_POINTER_REGNUM is defined to point to the return address pushed
+ * onto the stack, so we must offset by 2 bytes to get to the arguments. */
+#define FIRST_PARM_OFFSET(FNDECL) 2
+
+/* Value is 1 if returning from a function call automatically
+   pops the arguments described by the number-of-args field in the call.
+   FUNTYPE is the data type of the function (as a tree),
+   or for a library call it is an identifier node for the subroutine name. */
+/* #define RETURN_POPS_ARGS(FUNDECL,FUNTYPE,SIZE) 0 */
+
+/* Define how to find the value returned by a function.
+   VALTYPE is the data type of the value (as a tree).
+   If the precise function being called is known, FUNC is its FUNCTION_DECL;
+   otherwise, FUNC is 0.  */
+#define FUNCTION_VALUE(VALTYPE, FUNC) m6809_function_value (VALTYPE, FUNC)
+
+/* Define how to find the value returned by a library function
+   assuming the value has mode MODE.  */
+
+/* All return values are in the X-register. */
+#define LIBCALL_VALUE(MODE)  gen_rtx_REG (MODE, HARD_X_REGNUM)
+
+/* Define this if using the nonreentrant convention for returning
+   structure and union values.  No; it is inefficient and buggy. */
+#undef PCC_STATIC_STRUCT_RETURN
+
+/* 1 if N is a possible register number for a function value. */
+#define FUNCTION_VALUE_REGNO_P(N) m6809_function_value_regno_p (N)
+
+/* Define this to be true when FUNCTION_VALUE_REGNO_P is true for
+   more than one register.  */
+#define NEEDS_UNTYPED_CALL 1
+
+/* 1 if N is a possible register number for function argument passing. */
+#define FUNCTION_ARG_REGNO_P(N) \
+	((m6809_abi_version != M6809_ABI_VERSION_STACK) ? \
+   	(((N) == HARD_D_REGNUM) || ((N) == HARD_X_REGNUM)) : \
+		0)
+
+/*--------------------------------------------------------------
+	Argument Lists
+--------------------------------------------------------------*/
+
+/* Cumulative arguments are tracked in a single integer, 
+ * which is the number of bytes of arguments scanned so far,
+ * plus which registers have already been used.  The register
+ * info is kept in some of the upper bits */
+#define CUMULATIVE_ARGS unsigned int
+
+#define CUM_STACK_ONLY 0x80000000
+#define CUM_X_MASK     0x40000000
+#define CUM_B_MASK     0x20000000
+#define CUM_STACK_INVALID 0x10000000
+#define CUM_STACK_MASK 0xFFFFFFF
+
+#define CUM_ADVANCE_8BIT(cum) \
+	(((cum) & CUM_B_MASK) ? (cum)++ : ((cum) |= CUM_B_MASK))
+
+#define CUM_ADVANCE_16BIT(cum) \
+	(((cum) & CUM_X_MASK) ? (cum) += 2 : ((cum) |= CUM_X_MASK))
+
+/* Initialize a variable CUM of type CUMULATIVE_ARGS
+   for a call to a function whose data type is FNTYPE.
+   For a library call, FNTYPE is 0.
+	N_NAMED was added in gcc 3.4 and is not used currently. */
+#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE,LIBNAME,INDIRECT,N_NAMED) \
+	((CUM) = m6809_init_cumulative_args (CUM, FNTYPE, LIBNAME))
+
+#define FUNCTION_ARG_SIZE(MODE, TYPE)	\
+  ((MODE) != BLKmode ? GET_MODE_SIZE (MODE)	\
+   : (unsigned) int_size_in_bytes (TYPE))
+
+/* Update the data in CUM to advance over an argument
+   of mode MODE and data type TYPE.
+   (TYPE is null for libcalls where that information may not be available.)  */
+#define FUNCTION_ARG_ADVANCE(CUM, MODE, TYPE, NAMED) \
+	 (((MODE == QImode) && !((CUM) & CUM_STACK_ONLY)) ? \
+		CUM_ADVANCE_8BIT (CUM) : \
+	  ((MODE == HImode) && !((CUM) & CUM_STACK_ONLY)) ? \
+		CUM_ADVANCE_16BIT (CUM) : \
+	  ((CUM) = ((CUM) + (TYPE ? int_size_in_bytes (TYPE) : 2))))
+
+/* Define where to put the arguments to a function.
+   Value is zero to push the argument on the stack,
+   or a hard register rtx in which to store the argument.
+	This macro is used _before_ FUNCTION_ARG_ADVANCE.
+
+	For the 6809, the first 8-bit function argument can be placed into B,
+	and the first 16-bit arg can go into X.  All other arguments
+	will be pushed onto the stack.
+
+	Command-line options can adjust this behavior somewhat.
+ */
+#define FUNCTION_ARG(CUM, MODE, TYPE, NAMED) \
+	((MODE == VOIDmode) ? NULL_RTX : \
+	((MODE == BLKmode) || (GET_MODE_SIZE (MODE) > 2)) ? NULL_RTX : \
+	((MODE == QImode) && !((CUM) & (CUM_STACK_ONLY | CUM_B_MASK))) ? \
+		gen_rtx_REG (QImode, HARD_D_REGNUM) : \
+	((MODE == HImode) && !((CUM) & (CUM_STACK_ONLY | CUM_X_MASK))) ?  \
+		gen_rtx_REG (HImode, HARD_X_REGNUM) : m6809_function_arg_on_stack (&CUM))
+
+/* Output assembler code to FILE to increment profiler label # LABELNO
+   for profiling a function entry.  */
+#define FUNCTION_PROFILER(FILE, LABELNO) \
+   fprintf (FILE, "\tldd\t#LP%u\n\tjsr\tmcount\n", (LABELNO));
+
+/* Stack pointer must be correct on function exit */
+#define EXIT_IGNORE_STACK 0
+
+/*****************************************************************************
+**
+** Trampolines for Nested Functions
+**
+*****************************************************************************/
+
+/* Length in units of the trampoline for entering a nested function.  */
+#define TRAMPOLINE_SIZE 7
+
+/*--------------------------------------------------------------
+	Addressing modes,
+	and classification of registers for them.
+--------------------------------------------------------------*/
+
+/* 6809 has postincrement and predecrement addressing modes */
+#define HAVE_POST_INCREMENT  1
+#define HAVE_PRE_DECREMENT  1
+
+/* Whether or not to use index registers is configurable.
+ * Experiments show that things work better when this is off, so
+ * that's the way it is for now. */
+#undef USE_INDEX_REGISTERS
+
+
+/* Macros to check register numbers against specific register classes.  */
+#define REG_VALID_FOR_BASE_P(REGNO) \
+	(((REGNO) < FIRST_PSEUDO_REGISTER) && A_REGNO_P (REGNO))
+
+/* MC6809 index registers do not allow scaling, */
+/* but there is "accumulator-offset" mode. */
+#ifdef USE_INDEX_REGISTERS
+#define REG_VALID_FOR_INDEX_P(REGNO) \
+	(((REGNO) < FIRST_PSEUDO_REGISTER) && I_REGNO_P (REGNO))
+#else
+#define REG_VALID_FOR_INDEX_P(REGNO) 0
+#endif
+
+/* Internal macro, the nonstrict definition for REGNO_OK_FOR_BASE_P */
+#define REGNO_OK_FOR_BASE_NONSTRICT_P(REGNO) \
+   ((REGNO) >= FIRST_PSEUDO_REGISTER \
+	|| REG_VALID_FOR_BASE_P (REGNO) \
+	|| (REGNO) == FRAME_POINTER_REGNUM \
+	|| (REGNO) == HARD_FRAME_POINTER_REGNUM \
+	|| (REGNO) == ARG_POINTER_REGNUM \
+	|| (reg_renumber && REG_VALID_FOR_BASE_P (reg_renumber[REGNO])))
+
+/* Internal macro, the nonstrict definition for REGNO_OK_FOR_INDEX_P */
+#define REGNO_OK_FOR_INDEX_NONSTRICT_P(REGNO) \
+   ((REGNO) >= FIRST_PSEUDO_REGISTER \
+	|| REG_VALID_FOR_INDEX_P (REGNO) \
+	|| (reg_renumber && REG_VALID_FOR_INDEX_P (reg_renumber[REGNO])))
+
+
+/* Internal macro, the strict definition for REGNO_OK_FOR_BASE_P */
+#define REGNO_OK_FOR_BASE_STRICT_P(REGNO) \
+	((REGNO) < FIRST_PSEUDO_REGISTER ? REG_VALID_FOR_BASE_P (REGNO) \
+	: (reg_renumber && REG_VALID_FOR_BASE_P (reg_renumber[REGNO])))
+
+
+/* Internal macro, the strict definition for REGNO_OK_FOR_INDEX_P */
+#define REGNO_OK_FOR_INDEX_STRICT_P(REGNO) \
+	((REGNO) < FIRST_PSEUDO_REGISTER ? REG_VALID_FOR_INDEX_P (REGNO) \
+	: (reg_renumber && REG_VALID_FOR_INDEX_P (reg_renumber[REGNO])))
+
+
+#define REGNO_OK_FOR_BASE_P(REGNO) REGNO_OK_FOR_BASE_STRICT_P (REGNO)
+
+#define REGNO_OK_FOR_INDEX_P(REGNO) REGNO_OK_FOR_INDEX_STRICT_P (REGNO)
+
+#define REG_OK_FOR_BASE_STRICT_P(X)     REGNO_OK_FOR_BASE_STRICT_P (REGNO (X))
+#define REG_OK_FOR_BASE_NONSTRICT_P(X)  REGNO_OK_FOR_BASE_NONSTRICT_P (REGNO (X))
+#define REG_OK_FOR_INDEX_STRICT_P(X)    REGNO_OK_FOR_INDEX_STRICT_P (REGNO (X))
+#define REG_OK_FOR_INDEX_NONSTRICT_P(X) REGNO_OK_FOR_INDEX_NONSTRICT_P (REGNO (X))
+
+#ifndef REG_OK_STRICT
+#define REG_OK_FOR_BASE_P(X)     REG_OK_FOR_BASE_NONSTRICT_P(X)
+#ifdef USE_INDEX_REGISTERS
+#define REG_OK_FOR_INDEX_P(X)    REG_OK_FOR_INDEX_NONSTRICT_P(X)
+#else
+#define REG_OK_FOR_INDEX_P(X)    0
+#endif
+#else
+#define REG_OK_FOR_BASE_P(X)     REG_OK_FOR_BASE_STRICT_P (X)
+#ifdef USE_INDEX_REGISTERS
+#define REG_OK_FOR_INDEX_P(X)    REG_OK_FOR_INDEX_STRICT_P (X)
+#else
+#define REG_OK_FOR_INDEX_P(X)    0
+#endif
+#endif
+
+/* Maximum number of registers that can appear in a valid memory address */
+#ifdef USE_INDEX_REGISTERS
+#define MAX_REGS_PER_ADDRESS 2
+#else
+#define MAX_REGS_PER_ADDRESS 1
+#endif
+
+/* 1 if X is an rtx for a constant that is a valid address.
+ * We allow any constant, plus the sum of any two constants (this allows
+ * offsetting a symbol ref) */
+#define CONSTANT_ADDRESS_P(X) \
+	((CONSTANT_P (X)) \
+	|| ((GET_CODE (X) == PLUS) \
+	      && (CONSTANT_P (XEXP (X, 0))) && (CONSTANT_P (XEXP (X, 1)))))
+
+/* Nonzero if the constant value X is a legitimate general operand.
+   It is given that X satisfies CONSTANT_P or is a CONST_DOUBLE.  */
+/* Any single-word constant is ok; the only contexts
+   allowing general_operand of mode DI or DF are movdi and movdf. */
+#define LEGITIMATE_CONSTANT_P(X) (GET_CODE (X) != CONST_DOUBLE)
+
+/* Nonzero if the X is a legitimate immediate operand in PIC mode. */
+#define LEGITIMATE_PIC_OPERAND_P(X)	!symbolic_operand (X, VOIDmode)
+
+/*--------------------------------------------------------------
+	Test for valid memory addresses
+--------------------------------------------------------------*/
+/* GO_IF_LEGITIMATE_ADDRESS recognizes an RTL expression
+   that is a valid memory address for an instruction.
+   The MODE argument is the machine mode for the MEM expression
+   that wants to use this address. */
+
+/*--------------------------------------------------------------
+   Valid addresses are either direct or indirect (MEM) versions
+   of the following forms.
+	constant		N
+	register		,X
+	constant indexed	N,X
+	accumulator indexed	D,X
+	auto_increment		,X++
+	auto_decrement		,--X
+--------------------------------------------------------------*/
+
+#define REGISTER_ADDRESS_P(X) \
+  (REG_P (X) && REG_OK_FOR_BASE_P (X))
+
+#define EXTENDED_ADDRESS_P(X) \
+    CONSTANT_ADDRESS_P (X) \
+
+#define LEGITIMATE_BASE_P(X) \
+  ((REG_P (X) && REG_OK_FOR_BASE_P (X))	\
+   || (GET_CODE (X) == SIGN_EXTEND			\
+       && GET_CODE (XEXP (X, 0)) == REG			\
+       && GET_MODE (XEXP (X, 0)) == HImode		\
+       && REG_OK_FOR_BASE_P (XEXP (X, 0))))
+
+#define LEGITIMATE_OFFSET_P(X) \
+    (CONSTANT_ADDRESS_P (X) || (REG_P (X) && REG_OK_FOR_INDEX_P (X)))
+
+/* 1 if X is the sum of a base register and an offset. */
+#define INDEXED_ADDRESS(X) \
+   ((GET_CODE (X) == PLUS \
+       && LEGITIMATE_BASE_P (XEXP (X, 0)) \
+       && LEGITIMATE_OFFSET_P (XEXP (X, 1))) \
+   || (GET_CODE (X) == PLUS \
+       && LEGITIMATE_BASE_P (XEXP (X, 1)) \
+       && LEGITIMATE_OFFSET_P (XEXP (X, 0))))
+
+#define STACK_REG_P(X) (REG_P(X) && REGNO(X) == HARD_S_REGNUM)
+
+#define STACK_PUSH_P(X) \
+   (MEM_P (X) && GET_CODE (XEXP (X, 0)) == PRE_DEC && STACK_REG_P (XEXP (XEXP (X, 0), 0)))
+
+#define STACK_POP_P(X) \
+   (MEM_P (X) && GET_CODE (XEXP (X, 0)) == POST_INC && STACK_REG_P (XEXP (XEXP (X, 0), 0)))
+
+#define PUSH_POP_ADDRESS_P(X) \
+    (((GET_CODE (X) == PRE_DEC) || (GET_CODE (X) == POST_INC)) \
+	&& (LEGITIMATE_BASE_P (XEXP (X, 0))))
+
+/* Go to ADDR if X is a valid address. */
+#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, ADDR) \
+{ \
+  if (REGISTER_ADDRESS_P(X)) goto ADDR; \
+  if (PUSH_POP_ADDRESS_P (X)) goto ADDR; \
+  if (EXTENDED_ADDRESS_P (X)) goto ADDR; \
+  if (INDEXED_ADDRESS (X)) goto ADDR; \
+  if (MEM_P (X) && REGISTER_ADDRESS_P(XEXP (X, 0))) goto ADDR; \
+  if (MEM_P (X) && PUSH_POP_ADDRESS_P (XEXP (X, 0))) goto ADDR; \
+  if (MEM_P (X) && EXTENDED_ADDRESS_P (XEXP (X, 0))) goto ADDR; \
+  if (MEM_P (X) && INDEXED_ADDRESS (XEXP (X, 0))) goto ADDR; \
+}
+
+/*--------------------------------------------------------------
+	Address Fix-up
+--------------------------------------------------------------*/
+/* Go to LABEL if ADDR (a legitimate address expression)
+   has an effect that depends on the machine mode it is used for.
+	In the latest GCC, this case is already handled by the core code
+	so no action is required here. */
+#define GO_IF_MODE_DEPENDENT_ADDRESS(ADDR,LABEL) {}
+
+
+/*--------------------------------------------------------------
+	Miscellaneous Parameters
+--------------------------------------------------------------*/
+/* Specify the machine mode that this machine uses
+   for the index in the tablejump instruction.  */
+#define CASE_VECTOR_MODE Pmode
+
+/* Define this as 1 if `char' should by default be signed; else as 0.  */
+#define DEFAULT_SIGNED_CHAR 0
+
+/* This flag, if defined, says the same insns that convert to a signed fixnum
+   also convert validly to an unsigned one.  */
+#define FIXUNS_TRUNC_LIKE_FIX_TRUNC
+
+/* Max number of bytes we can move from memory to memory/register
+   in one reasonably fast instruction.  */
+#define MOVE_MAX 2
+
+/* Int can be 8 or 16 bits (default is 16) */
+#define INT_TYPE_SIZE (TARGET_BYTE_INT ? 8 : 16)
+
+/* Short is always 16 bits */
+#define SHORT_TYPE_SIZE (TARGET_BYTE_INT ? 8 : 16)
+
+/* Size (bits) of the type "long" on target machine */
+#define LONG_TYPE_SIZE (TARGET_BYTE_INT ? 16 : 32)
+
+/* Size (bits) of the type "long long" on target machine */
+#define LONG_LONG_TYPE_SIZE 32
+
+/* Size (bits) of the type "char" on target machine */
+#define CHAR_TYPE_SIZE 8
+
+/* Size (bits) of the type "float" on target machine */
+#define FLOAT_TYPE_SIZE 32
+
+/* Size (bits) of the type "double" on target machine.
+ * Note that the C standard does not require that doubles
+ * hold any more bits than float.  Since the 6809 has so few
+ * registers, we cannot really support more than 32-bits. */
+#define DOUBLE_TYPE_SIZE 32 
+
+/* Size (bits) of the type "long double" on target machine */
+#define LONG_DOUBLE_TYPE_SIZE 32
+
+/* Define the type used for "size_t".  With a 64KB address space,
+ * only a 16-bit value here makes sense. */
+#define SIZE_TYPE (TARGET_BYTE_INT ? "long unsigned int" : "unsigned int")
+
+/* Likewise, the difference between two pointers is also a 16-bit
+ * signed value. */
+#define PTRDIFF_TYPE (TARGET_BYTE_INT ? "long int" : "int")
+
+/* Nonzero if access to memory by bytes is slow and undesirable.  */
+#define SLOW_BYTE_ACCESS 0
+
+/* Define if shifts truncate the shift count
+   which implies one can omit a sign-extension or zero-extension
+   of a shift count.  */
+#define SHIFT_COUNT_TRUNCATED 0
+
+/* Value is 1 if truncating an integer of INPREC bits to OUTPREC bits
+   is done just by pretending it is already truncated.  */
+#define TRULY_NOOP_TRUNCATION(OUTPREC, INPREC) 1
+
+/* It is as good to call a constant function address as to
+   call an address kept in a register. */
+#define NO_FUNCTION_CSE
+
+/* Specify the machine mode that pointers have.
+   After generation of rtl, the compiler makes no further distinction
+   between pointers and any other objects of this machine mode.  */
+#define Pmode HImode
+
+/* A function address in a call instruction
+   is a byte address (for indexing purposes)
+   so give the MEM rtx a byte's mode.  */
+#define FUNCTION_MODE HImode
+
+/* Define the cost of moving a value from a register in CLASS1
+ * to CLASS2, of a given MODE.
+ *
+ * On the 6809, hard register transfers are all basically equivalent.
+ * But soft register moves are treated more like memory moves. */
+#define REGISTER_MOVE_COST(MODE, CLASS1, CLASS2) \
+	(((CLASS1 == M_REGS) || (CLASS2 == M_REGS)) ? 4 : 7)
+
+/* Define the cost of moving a value between a register and memory. */
+#define MEMORY_MOVE_COST(MODE, CLASS, IN) 5
+
+/* Check a `double' value for validity for a particular machine mode.  */
+
+#define CHECK_FLOAT_VALUE(MODE, D, OVERFLOW) \
+  ((OVERFLOW) = check_float_value (MODE, &D, OVERFLOW))
+
+
+/*--------------------------------------------------------------
+	machine-dependent
+--------------------------------------------------------------*/
+/* Tell final.c how to eliminate redundant test instructions.  */
+
+/* Here we define machine-dependent flags and fields in cc_status
+   (see `conditions.h').  */
+
+/* Store in cc_status the expressions
+   that the condition codes will describe
+   after execution of an instruction whose pattern is EXP.
+   Do not alter them if the instruction would not alter the cc's.  */
+
+/* On the 6809, most of the insns to store in an address register
+   fail to set the cc's.  However, in some cases these instructions
+   can make it possibly invalid to use the saved cc's.  In those
+   cases we clear out some or all of the saved cc's so they won't be used.  */
+
+#define NOTICE_UPDATE_CC(EXP, INSN) \
+  notice_update_cc((EXP), (INSN))
+
+/*****************************************************************************
+**
+** pragma support
+**
+*****************************************************************************/
+
+#if 0
+#define REGISTER_TARGET_PRAGMAS() \
+do { \
+	extern void pragma_section PARAMS ((cpp_reader *)); \
+	c_register_pragma (0, "section", pragma_section); \
+} while (0)
+
+#endif
+
+/*--------------------------------------------------------------
+	ASSEMBLER FORMAT
+--------------------------------------------------------------*/
+
+#define FMT_HOST_WIDE_INT "%ld"
+
+/* Output to assembler file text saying following lines
+   may contain character constants, extra white space, comments, etc.  */
+#define ASM_APP_ON ";----- asm -----\n"
+
+/* Output to assembler file text saying following lines
+   no longer contain unusual constructs.  */
+#define ASM_APP_OFF ";--- end asm ---\n"
+
+/* Use a semicolon to begin a comment. */
+#define ASM_COMMENT_START "; "
+
+/* Output assembly directives to switch to section 'name' */
+#undef TARGET_ASM_NAMED_SECTION
+#define TARGET_ASM_NAMED_SECTION	m6809_asm_named_section
+
+#undef TARGET_HAVE_NAMED_SECTION
+#define TARGET_HAVE_NAMED_SECTION m6809_have_named_section
+
+/* Output before read-only data.  */
+#define TEXT_SECTION_ASM_OP (code_section_op)
+
+/* Output before writable data.  */
+#define DATA_SECTION_ASM_OP (data_section_op)
+
+/* Output before uninitialized data.  */
+#define BSS_SECTION_ASM_OP (bss_section_op)
+
+/* Support the ctors and dtors sections for g++.  */
+ 
+#undef CTORS_SECTION_ASM_OP
+#define CTORS_SECTION_ASM_OP    "\t.area\t.ctors"
+#undef DTORS_SECTION_ASM_OP
+#define DTORS_SECTION_ASM_OP    "\t.area\t.dtors"
+
+
+#undef DO_GLOBAL_CTORS_BODY
+#undef DO_GLOBAL_DTORS_BODY
+
+#define HAS_INIT_SECTION
+
+/* This is how to output an assembler line
+   that says to advance the location counter
+   to a multiple of 2**LOG bytes.  */
+
+#define ASM_OUTPUT_ALIGN(FILE,LOG) \
+  if ((LOG) > 1) \
+    fprintf (FILE, "\t.bndry\t%u\n", 1 << (LOG))
+
+/* The .set foo,bar construct doesn't work by default */
+#undef SET_ASM_OP
+#define ASM_OUTPUT_DEF(FILE, LABEL1, LABEL2) \
+  do { \
+      assemble_name (FILE, LABEL1); \
+      fputs ("\tequ\t", FILE); \
+      assemble_name (FILE, LABEL2); \
+      fputc ('\n', FILE); \
+  } while (0)
+
+/* How to refer to registers in assembler output.
+   This sequence is indexed by compiler's hard-register-number (see above).  */
+#define MNAME(x) [SOFT_M0_REGNUM+(x)] = "*m" C_STRING(x) ,
+
+#define REGISTER_NAMES { \
+	[HARD_D_REGNUM]= "d", \
+	[HARD_X_REGNUM]= "x", \
+	[HARD_Y_REGNUM]= "y", \
+	[HARD_U_REGNUM]= "u", \
+	[HARD_S_REGNUM]= "s", \
+	[HARD_PC_REGNUM]= "pc", \
+	[HARD_A_REGNUM]= "a", \
+	[HARD_B_REGNUM]= "b", \
+	[HARD_CC_REGNUM]= "cc",\
+	[HARD_DP_REGNUM]= "dp", \
+	[SOFT_FP_REGNUM]= "soft_fp", \
+	[SOFT_AP_REGNUM]= "soft_ap", \
+	MNAME(0) MNAME(1) MNAME(2) MNAME(3) \
+	MNAME(4) MNAME(5) MNAME(6) MNAME(7) \
+	[HARD_RSVD1_REGNUM] = "-", \
+	[HARD_Z_REGNUM] = "z" /* bit 2 of CC */ }
+
+/*****************************************************************************
+**
+** Debug Support
+**
+*****************************************************************************/
+
+/* Default to DBX-style debugging */
+#define PREFERRED_DEBUGGING_TYPE DBX_DEBUG
+
+#define DBX_DEBUGGING_INFO
+
+#define DEFAULT_GDB_EXTENSIONS 0
+
+#define ASM_STABS_OP ";\t.stabs\t"
+#define ASM_STABD_OP ";\t.stabd\t"
+#define ASM_STABN_OP ";\t.stabn\t"
+
+#define DBX_CONTIN_LENGTH 54
+
+#define DBX_OUTPUT_MAIN_SOURCE_FILENAME(ASMFILE, FILENAME) \
+do { \
+	const char *p = FILENAME; \
+	while ((p = strchr (p, '/')) != NULL) { \
+		p = FILENAME = p+1; \
+	} \
+  fprintf (ASMFILE, "%s", ASM_STABS_OP); \
+  output_quoted_string (ASMFILE, FILENAME); \
+  fprintf (ASMFILE, ",%d,0,0,", N_SO); \
+  assemble_name (ASMFILE, ltext_label_name); \
+  fputc ('\n', ASMFILE); \
+  switch_to_section (text_section); \
+  (*targetm.asm_out.internal_label) (ASMFILE, "Ltext", 0); \
+} while (0)
+
+/* With -g, GCC sometimes outputs string literals that are longer than
+ * the assembler can handle.  Without actual debug support, these are
+ * not really required.  Redefine the function to output strings to
+ * output as much as possible. */
+#define OUTPUT_QUOTED_STRING(FILE, STR) m6809_output_quoted_string (FILE, STR)
+
+/*****************************************************************************
+**
+** Output and Generation of Labels
+**
+*****************************************************************************/
+
+/* Prefixes for various assembly-time objects */
+
+#define REGISTER_PREFIX ""
+
+#define LOCAL_LABEL_PREFIX ""
+
+#define USER_LABEL_PREFIX "_"
+
+#define IMMEDIATE_PREFIX "#"
+
+/* This is how to output the definition of a user-level label named NAME,
+   such as the label on a static function or variable NAME.  */
+
+#define ASM_OUTPUT_LABEL(FILE,NAME) \
+do { \
+  if (section_changed) { \
+	  fprintf (FILE, "\n%s\n\n", code_section_op); \
+     section_changed = 0; \
+  } \
+  assemble_name (FILE, NAME); \
+  fputs (":\n", FILE); \
+} while (0)
+
+/* This is how to output the label for a function definition.  It
+   invokes ASM_OUTPUT_LABEL, but may examine the DECL tree node for
+	other properties. */
+#define ASM_DECLARE_FUNCTION_NAME(FILE,NAME,DECL) \
+  m6809_declare_function_name (FILE,NAME,DECL)
+
+/* This is how to output a command to make the user-level label
+    named NAME defined for reference from other files.  */
+
+#define GLOBAL_ASM_OP "\n\t.globl\t"
+
+/* This is how to output a reference to a user label named NAME. */
+#define ASM_OUTPUT_LABELREF(FILE,NAME) \
+  fprintf (FILE, "_%s", NAME)
+
+/* This is how to output a reference to a symbol ref
+ * Check to see if the symbol is in the direct page */
+#define ASM_OUTPUT_SYMBOL_REF(FILE,sym) \
+{ \
+	print_direct_prefix (FILE, sym); \
+	assemble_name (FILE, XSTR (sym, 0)); \
+}
+
+/* External references aren't necessary, so don't emit anything */
+#define ASM_OUTPUT_EXTERNAL(FILE,DECL,NAME)
+
+/* This is how to store into the string LABEL
+   the symbol_ref name of an internal numbered label where
+   PREFIX is the class of label and NUM is the number within the class.
+   This is suitable for output with `assemble_name'.  */
+#define ASM_GENERATE_INTERNAL_LABEL(LABEL,PREFIX,NUM) \
+  sprintf (LABEL, "*%s%lu", PREFIX, (unsigned long int)NUM)
+
+/* This is how to output an assembler line defining an `int' constant.  */
+#define ASM_OUTPUT_INT(FILE,VALUE) \
+( fprintf (FILE, "\t.word\t"), \
+  output_addr_const (FILE, (VALUE)), \
+  fprintf (FILE, "\n"))
+
+/* Likewise for `char' and `short' constants.  */
+#define ASM_OUTPUT_SHORT(FILE,VALUE) \
+( fprintf (FILE, "\t.word\t"), \
+  output_addr_const (FILE, (VALUE)), \
+  fprintf (FILE, "\n"))
+
+/* This is how to output a string. */ 
+#define ASM_OUTPUT_ASCII(FILE,STR,SIZE) m6809_output_ascii (FILE, STR, SIZE)
+
+/* This is how to output an insn to push a register on the stack.
+   It need not be very fast code.  */
+
+#define ASM_OUTPUT_REG_PUSH(FILE,REGNO) \
+   fprintf (FILE, "\tpshs\t%s\n", reg_names[REGNO])
+
+/* This is how to output an insn to pop a register from the stack.
+   It need not be very fast code.  */
+
+#define ASM_OUTPUT_REG_POP(FILE,REGNO) \
+   fprintf (FILE, "\tpuls\t%s\n", reg_names[REGNO])
+
+/* This is how to output an element of a case-vector that is absolute. */
+
+#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE) \
+  fprintf (FILE, "\t.word\tL%u\n", VALUE)
+
+/* This is how to output an element of a case-vector that is relative. */
+
+#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, BODY, VALUE, REL) \
+  fprintf (FILE, "\t.word\tL%u-L%u\n", VALUE, REL)
+
+
+/*****************************************************************************
+**
+** Assembler Commands for Alignment
+**
+*****************************************************************************/
+
+/* ASM_OUTPUT_SKIP is supposed to zero initialize the data. */
+#define ASM_OUTPUT_SKIP(FILE,SIZE) \
+  do { \
+    fprintf (FILE, "\tzmb\t%d\t;skip space\n", SIZE); \
+  } while (0)
+
+/* This says how to output an assembler line
+   to define a global common symbol.  */
+
+#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ROUNDED) \
+  do { \
+  switch_to_section (bss_section); \
+  fputs ("\n\t.globl\t", FILE); \
+  assemble_name ((FILE), (NAME)); \
+  fputs ("\n", FILE); \
+  assemble_name ((FILE), (NAME)); \
+  fprintf ((FILE), ":\t.blkb\t" FMT_HOST_WIDE_INT "\n", (ROUNDED));} while(0)
+
+/* This says how to output an assembler line
+   to define a local common symbol.  */
+
+#define ASM_OUTPUT_LOCAL(FILE, NAME, SIZE, ROUNDED) \
+do { \
+  switch_to_section (bss_section); \
+  assemble_name ((FILE), (NAME)); \
+  fprintf ((FILE), ":\t.blkb\t" FMT_HOST_WIDE_INT "\n", (ROUNDED));} while(0)
+
+/* Store in OUTPUT a string (made with alloca) containing
+   an assembler-name for a local static variable named NAME.
+   LABELNO is an integer which is different for each call.  */
+
+#define ASM_FORMAT_PRIVATE_NAME(OUTPUT, NAME, LABELNO) \
+( (OUTPUT) = (char *) alloca (strlen ((NAME)) + 10), \
+  sprintf ((OUTPUT), "%s.%lu", (NAME), (unsigned long int)(LABELNO)))
+
+/* Print an instruction operand X on file FILE.
+   CODE is the code from the %-spec for printing this operand.
+   If `%z3' was used to print operand 3, then CODE is 'z'. */
+#define PRINT_OPERAND(FILE, X, CODE) print_operand (FILE, X, CODE)
+
+/* Print a memory operand whose address is X, on file FILE. */
+#define PRINT_OPERAND_ADDRESS(FILE, ADDR) print_operand_address (FILE, ADDR)
+
+/* Don't let stack pushes build up too much. */
+#define MAX_PENDING_STACK 8
+
+/* Define values for builtin operations */
+enum m6809_builtins
+{
+	M6809_SWI,
+	M6809_SWI2,
+	M6809_SWI3,
+	M6809_CWAI,
+	M6809_SYNC,
+	M6809_ADD_CARRY,
+	M6809_SUB_CARRY,
+	M6809_ADD_DECIMAL,
+	M6809_NOP,
+	M6809_BLOCKAGE
+};
+
diff -urN gcc-4.6.4-clean/gcc/config/m6809/m6809.md gcc-4.6.4/gcc/config/m6809/m6809.md
--- gcc-4.6.4-clean/gcc/config/m6809/m6809.md	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/m6809.md	2017-11-29 17:11:09.221248469 -0700
@@ -0,0 +1,2358 @@
+;; GCC machine description for Motorola 6809
+;; Copyright (C) 1989, 2005, 2006, 2007, 2008,
+;; 2009 Free Software Foundation, Inc.
+;;
+;; Mostly by Brian Dominy (brian@oddchange.com) with substantial renovations
+;; by William Astle (lost@l-w.ca).
+;;
+;; Based on earlier work by Tom Jones (jones@sal.wisc.edu) and
+;; Matthias Doerfel (msdoerfe@informatik.uni-erlangen.de)
+;;
+;; This file is part of GCC.
+;;
+;; GCC is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 3, or (at your option)
+;; any later version.
+;;
+;; GCC is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with GCC; see the file COPYING3.  If not see
+;; <http://www.gnu.org/licenses/>.
+;;
+;; General information:
+;; --------------------
+;; * This backend is mostly a rewrite from earlier (3.1.1 and before)
+;; versions.
+;;
+;; * The 'A' and 'B' registers are treated as a single register by the
+;; register allocator; hence, the instruction templates assume that
+;; both can be modified if either one is available for use.  No
+;; attempt is made to split instructions to refer to a particular half
+;; of the register.  It is always referred to as the 'D' register, even
+;; in QImode (when it will be displayed as 'B').
+;;
+;; * There is full support for proper branch instruction generation,
+;; based on instruction lengths.  However, many instruction patterns
+;; are still overloaded to emit lots of real instructions, which can
+;; make the length calculation difficult; in those cases, I've tried
+;; to be pessimistic and assume the worst-case.
+;;
+;; * The instruction type attributes are only defined for branch
+;; vs. non branch instructions for now, since there is seemingly no
+;; reason to define these for other types anyway.
+;;
+;; * The limited number of total registers presents the greatest
+;; challenge.  There are 'soft registers' -- memory locations
+;; used to simulate real regs -- which can be helpful.
+;;
+;; * Position-independent code (PIC) is supported and has been tested
+;; but not to the extent of absolute code generation.
+;;
+;; * All of the 6809 special opcodes, e.g. SWI and SYNC, are defined
+;; as UNSPEC instructions, and can be accessed from C code using
+;; __builtin_xxxx() style functions.
+;;
+;; What still needs to be done:
+;; ----------------------------
+;; * Replace remaining instances of (define_peephole) with
+;; (define_peephole2), or remove them completely if they are not
+;; matching anyway.  Add more peepholes for things actually encountered.
+;;
+;; * Indexing addressing can lead to crashes in complex functions when
+;; register pressure is high.  Only the 'D' register can actually be
+;; used as an index register, and its demand by other instructions
+;; can sometimes mean that it is impossible to satisfy constraints.
+;; Currently, indexing is completely disabled to avoid these types
+;; of problems, although code is slightly more inefficient in some
+;; working cases.
+;;
+;; * 32-bit math is terribly inefficient.
+;;
+
+
+;;--------------------------------------------------------------------
+;;-  Constants
+;;--------------------------------------------------------------------
+
+;
+; Define constants for hard register numbers.
+;
+(define_constants [
+  (HARD_RSVD1_REGNUM 0)
+  (HARD_X_REGNUM 1) (HARD_Y_REGNUM 2) (HARD_U_REGNUM 3)
+  (HARD_S_REGNUM 4) (HARD_PC_REGNUM 5) (HARD_D_REGNUM 6)
+  (HARD_Z_REGNUM 7)
+  (HARD_A_REGNUM 8) (HARD_B_REGNUM 9)
+  (HARD_CC_REGNUM 10) (HARD_DP_REGNUM 11)
+  (SOFT_FP_REGNUM 12) (SOFT_AP_REGNUM 13)
+  (SOFT_M0_REGNUM 14) (SOFT_M1_REGNUM 15)
+  (SOFT_M2_REGNUM 16) (SOFT_M3_REGNUM 17)
+])
+
+
+;
+; The range in which a short branch insn can be used.
+;
+(define_constants [
+  (MIN_SHORT_BRANCH_OFFSET -127)
+  (MAX_SHORT_BRANCH_OFFSET 128)
+])
+
+
+;
+; The lengths of various types of real 6809 instructions.
+;
+; By default, ordinary insns are 4 bytes long.  This is often not
+; right, and the insn patterns below will redefine this to the
+; correct value.
+;
+; Branch instruction lengths (conditional and unconditionals) are
+; well known and declared here.  The short insns are used when the
+; offset is within the range declared above (between MIN_SHORT
+; and MAX_SHORT) ; otherwise the long form is used.
+;
+(define_constants [
+  (DEFAULT_INSN_LENGTH 4)
+  (SHORT_CBRANCH_LENGTH 2)
+  (LONG_CBRANCH_LENGTH 4)
+  (SHORT_BRANCH_LENGTH 2)
+  (LONG_BRANCH_LENGTH 3)
+])
+
+
+;
+; Constants for insn cycle counts.
+; Note that these counts all assume 1-byte opcodes.  2-byte
+; opcodes require 1 extra cycles for fetching the extra byte.
+;
+(define_constants [
+  ;; The default insn length, when it cannot be calculated.
+  ;; Take a conservative approach and estimate high.
+  (DEFAULT_INSN_CYCLES 10)
+
+  ;; Cycle counts for ALU and load operations.
+  (ALU_INHERENT_CYCLES 2)
+  (ALU_IMMED_CYCLES 2)
+  (ALU_DIRECT_CYCLES 4)
+  (ALU_INDEXED_BASE_CYCLES 4)
+  (ALU_EXTENDED_CYCLES 5)
+
+  ;; If an ALU operation is on a 16-bit register (D), then
+  ;; add this number of cycles to the total count.
+  (ALU_16BIT_CYCLES 2)
+
+  ;; A load of a 16-bit register incurs this extra amount.
+  (LOAD_16BIT_CYCLES 1)
+
+  ;; Cycle counts for memory-only operations (bit shifts, clear, test)
+  (MEM_DIRECT_CYCLES 6)
+  (MEM_INDEXED_BASE_CYCLES 6)
+  (MEM_EXTENDED_CYCLES 7)
+
+  ;; Cycle count for any reg-reg transfer (regardless of size)
+  (EXG_CYCLES 8)
+  (TFR_CYCLES 6)
+
+  ;; Cycle count for a condition code update (andcc/orcc)
+  (CC_CYCLES 3)
+
+  (JMP_DIRECT_CYCLES 3)
+  (JMP_INDEXED_BASE_CYCLES 3)
+  (JMP_EXTENDED_CYCLES 4)
+
+  (JSR_DIRECT_CYCLES 7)
+  (JSR_INDEXED_BASE_CYCLES 7)
+  (JSR_EXTENDED_CYCLES 8)
+
+  (LEA_BASE_CYCLES 4)
+
+  ;; Cycle count for a psh/pul operations.  Add to this the
+  ;; total number of bytes moved for the correct count.
+  (PSH_PUL_CYCLES 5)
+
+  ;; Miscellaneous cycle counts
+  (CWAI_CYCLES 20)
+  (MUL_CYCLES 11)
+  (NOP_CYCLES 2)
+  (RTI_CYCLES 15)
+  (RTS_CYCLES 5)
+  (SWI_CYCLES 20)
+  (SYNC_CYCLES 4)
+])
+
+
+;
+; An enumeration of values for each "unspec"; i.e. unspecified
+; instruction.  These represent insns that are meaningful on the
+; 6809 but which have no intrinsic meaning to GCC itself.
+; These insns can be generated explicitly using the __builtin_xxx
+; syntax; they are also implicitly generated by the backend
+; as needed to implement other insns.
+;
+(define_constants [
+  (UNSPEC_BLOCKAGE 0)
+  (UNSPEC_PUSH_RS 1)
+  (UNSPEC_POP_RS 2)
+  (UNSPEC_SWI 3)
+  (UNSPEC_CWAI 4)
+  (UNSPEC_ADD_CARRY 5)
+  (UNSPEC_SUB_CARRY 6)
+  (UNSPEC_SYNC 7)
+  (UNSPEC_ADD_DECIMAL 8)
+])
+
+
+;;--------------------------------------------------------------------
+;;-  Predicates
+;;--------------------------------------------------------------------
+
+(include "predicates.md")
+
+;;--------------------------------------------------------------------
+;;-  Attributes
+;;--------------------------------------------------------------------
+
+;;
+;; The type attribute is used to distinguish between different
+;; types of branch instructions, so that their lengths can be
+;; calculated correctly.
+;;
+(define_attr "type" "branch,cbranch,unknown" (const_string "unknown"))
+
+;;
+;; The length of a branch instruction is calculated based on how
+;; far away the branch target is.  Lengths of other insns default
+;; to 4.  set_attr is used in instruction templates to specify
+;; the length when it is known exactly.  When not sure, err on
+;; the high side to avoid compile errors.
+;;
+(define_attr "length" ""
+  (cond [
+    (eq_attr "type" "branch")
+    (if_then_else (lt (minus (match_dup 0) (pc))
+                      (const_int MIN_SHORT_BRANCH_OFFSET))
+      (const_int LONG_BRANCH_LENGTH)
+        (if_then_else (gt (minus (match_dup 0) (pc))
+                          (const_int MAX_SHORT_BRANCH_OFFSET))
+          (const_int LONG_BRANCH_LENGTH)
+          (const_int SHORT_BRANCH_LENGTH)))
+    (eq_attr "type" "cbranch")
+    (if_then_else (lt (minus (match_dup 0) (pc))
+                      (const_int MIN_SHORT_BRANCH_OFFSET))
+      (const_int LONG_CBRANCH_LENGTH)
+        (if_then_else (gt (minus (match_dup 0) (pc))
+                          (const_int MAX_SHORT_BRANCH_OFFSET))
+          (const_int LONG_CBRANCH_LENGTH)
+          (const_int SHORT_CBRANCH_LENGTH)))
+  ] (const_int DEFAULT_INSN_LENGTH)))
+
+
+;;
+;; The default attributes for 'asm' statements.
+;; The default length is the longest possible single 6809 instruction,
+;; which is 5 bytes.  GCC will automatically multiply this by the
+;; number of real insns contained in an asm statement.
+;;
+(define_asm_attributes
+  [(set_attr "length" "5")
+   (set_attr "type" "unknown")])
+
+;;
+;; An attribute for the number of cycles that it takes an instruction
+;; to execute.
+;;
+(define_attr "cycles" "" (const_int DEFAULT_INSN_CYCLES))
+
+
+;;--------------------------------------------------------------------
+;;- Instruction patterns.  When multiple patterns apply,
+;;- the first one in the file is chosen.
+;;-
+;;- See file "rtl.def" for documentation on define_insn, match_*, et. al.
+;;-
+;;- Note: NOTICE_UPDATE_CC in m6809.h handles condition code updates
+;;- for most instructions.
+;;--------------------------------------------------------------------
+
+;;--------------------------------------------------------------------
+;;-  Test
+;;--------------------------------------------------------------------
+
+;; cmpx is 3 bytes, not 4
+(define_insn "*tsthi_x"
+  [(set (cc0) (match_operand:HI 0 "register_operand_x" "v"))]
+  ""
+  "cmpx\t#0"
+  [(set_attr "length" "3")])
+
+;; subd #0 is 3 bytes, better than cmpd #0 which is 4 bytes
+(define_insn "*tsthi_d"
+  [(set (cc0) (match_operand:HI 0 "register_operand_d" "d"))]
+  ""
+  "subd\t#0"
+  [(set_attr "length" "3")])
+
+(define_insn "*tsthi"
+  [(set (cc0) (match_operand:HI 0 "register_operand" "a"))]
+  ""
+  "cmp%0\t#0"
+   [(set_attr "length" "4")])
+
+(define_insn "*bitqi3"
+  [(set (cc0)
+    (and:QI (match_operand:QI 0 "register_operand" "%q")
+      (match_operand:QI 1 "general_operand" "mi")))]
+  ""
+  "bit%0\t%1"
+  [(set_attr "length" "3")])
+
+
+(define_insn "tstqi"
+  [(set (cc0) (match_operand:QI 0 "nonimmediate_operand" "q,mt"))]
+  ""
+  "@
+   tst%0
+   tst\t%0"
+   [(set_attr "length" "1,3")])
+
+;;--------------------------------------------------------------------
+;;- Compare instructions
+;;--------------------------------------------------------------------
+
+;; - cmphi for register to memory or register compares
+(define_insn "cmphi"
+  [(set (cc0)
+    (compare
+      (match_operand:HI 0 "general_operand" "da, mi, ??Ud")
+      (match_operand:HI 1 "general_operand" "mi, da,  dU")))]
+  ""
+{
+  if ((REG_P (operands[0])) && (REG_P (operands[1]))) {
+    output_asm_insn ("pshs\t%1\t;cmphi: R:%1 with R:%0", operands);
+    return "cmp%0\t,s++\t;cmphi:";
+  }
+  if (GET_CODE (operands[0]) == REG)
+    return "cmp%0\t%1\t;cmphi:";
+  else {
+    cc_status.flags |= CC_REVERSED;
+    return "cmp%1\t%0\t;cmphi:(R)";
+  }
+}
+  [(set_attr "length" "5,5,7")])
+
+
+(define_insn "cmpqi"
+  [(set (cc0)
+    (compare (match_operand:QI 0 "whole_general_operand" "q,q, q,O,mt,K")
+    (match_operand:QI 1 "whole_general_operand"          "O,mt,K,q,q, q")))]
+  ""
+{
+    if (REG_P (operands[0]) && !M_REG_P (operands[0]))
+    {
+      if (operands[1] == const0_rtx)
+        return "tst%0\t;cmpqi:(ZERO)";
+      else
+        return "cmp%0\t%1\t;cmpqi:";
+    }
+    else
+    {
+      cc_status.flags |= CC_REVERSED;
+
+      if (operands[0] == const0_rtx)
+        return "tst%1\t;cmpqi:(RZERO)";
+      else
+        return "cmp%1\t%0\t;cmpqi:(R)";
+    }
+}
+   [(set_attr "length" "1,3,2,1,3,2")])
+
+
+;;--------------------------------------------------------------------
+;;- Compare/branch pattern
+;;--------------------------------------------------------------------
+
+(define_expand "cbranchhi4"
+  [(set (cc0)
+    (compare
+      (match_operand:HI 1 "general_operand" "da, mi, ??Ud")
+      (match_operand:HI 2 "general_operand" "mi, da,  dU")))
+   (set (pc)
+     (if_then_else
+        (match_operator 0 "ordered_comparison_operator" [(cc0) (const_int 0)])
+        (label_ref (match_operand 3 "" ""))
+        (pc)))]
+   ""
+   ""
+)
+
+(define_expand "cbranchqi4"
+  [(set (cc0)
+    (compare
+      (match_operand:QI 1 "whole_general_operand" "q,q, q,O,mt,K")
+      (match_operand:QI 2 "whole_general_operand" "O,mt,K,q,q, q")))
+   (set (pc)
+     (if_then_else
+        (match_operator 0 "ordered_comparison_operator" [(cc0) (const_int 0)])
+        (label_ref (match_operand 3 "" ""))
+        (pc)))]
+   ""
+   ""
+)
+
+;;--------------------------------------------------------------------
+;;-  Move
+;;--------------------------------------------------------------------
+
+; this looks good (obviously not finished) but I still see 'movsi'
+; places in udivsi3 where it's broken
+; (define_insn "pushsi1"
+;   [(set (mem:SI (pre_dec (reg:HI HARD_S_REGNUM)))
+;         (match_operand:SI 0 "general_operand" "o"))
+;    (set (reg:HI HARD_S_REGNUM)
+;         (plus:HI (reg:HI HARD_S_REGNUM) (const_int -4))) ]
+;   ""
+;   "; pushsi %0"
+;    [(set_attr "length" "12")])
+;
+; (define_insn "popsi1"
+;   [(set (match_operand:SI 0 "general_operand" "=o")
+;         (mem:SI (post_inc (reg:HI HARD_S_REGNUM))))
+;    (set (reg:HI HARD_S_REGNUM)
+;         (plus:HI (reg:HI HARD_S_REGNUM) (const_int 4))) ]
+;   ""
+;   "; popsi %0"
+;    [(set_attr "length" "12")])
+
+; (define_insn "movsi"
+;   [(set (match_operand:SI 0 "nonimmediate_operand" "=o")
+;         (match_operand:SI 1 "general_operand"      " oi"))]
+;   ""
+;   "; movsi %0 <- %1"
+;    [(set_attr "length" "1")])
+
+; this doesn't work
+; (define_expand "movsi"
+;   [(parallel [
+;      (set (match_operand:SI 0 "nonimmediate_operand" "")
+;           (match_operand:SI 1 "general_operand" ""))
+;      (clobber (match_scratch:HI 2 ""))])]
+;   ""
+; {
+;   rtx insn;
+;   if (STACK_PUSH_P (operands[0]) || STACK_POP_P (operands[1]))
+;   {
+;     REG_NOTES (insn) = alloc_EXPR_LIST (REG_INC, stack_pointer_rtx, REG_NOTES (insn));
+;   }
+;   insn = emit_move_multi_word (SImode, operands[0], operands[1]);
+;   DONE;
+; })
+
+
+(define_expand "movhi"
+  [(set (match_operand:HI 0 "nonimmediate_operand" "")
+    (match_operand:HI 1 "general_operand" ""))]
+  ""
+{
+  /* One of the ops has to be in a register prior to reload */
+  if (!register_operand (operand0, HImode) &&
+      !register_operand (operand1, HImode))
+    operands[1] = copy_to_mode_reg (HImode, operand1);
+})
+
+;;; Try a splitter to handle failure cases where we try to move
+;;; an immediate constant (zero usually) directly to memory.
+;;; This absolutely requires an intermediate register.
+(define_split
+  [(set (match_operand:HI 0 "memory_operand" "")
+    (match_operand:HI 1 "immediate_operand"  ""))
+   (clobber (match_operand:HI 2 "register_operand" ""))]
+  ""
+  [(set (match_dup 2) (match_dup 1))
+   (set (match_dup 0) (match_dup 2))]
+  "")
+
+
+;;; This would be a nice method for loading from a word array,
+;;; but it is never generated because the combiner cannot merge
+;;; more than 3 instructions (there are four here).  This is
+;;; perhaps better done via a peephole.
+(define_insn "*movhi_array_load"
+  [(set (match_operand:HI 0 "nonimmediate_operand" "=da")
+    (mem:HI (plus:HI (ashift:HI (zero_extend:HI (match_operand:QI 1 "register_operand" "%B")) (const_int 1))
+                     (match_operand:HI 2 "immediate_operand" "i"))))
+   (clobber (match_scratch:HI 3 "=X"))]
+  ""
+  "ldx\t%2\;abx\;abx\;ld%0\t,x"
+   [(set_attr "length" "7")])
+
+
+;;; Optimize the move of a byte to the stack using the pshs instruction
+;;; instead of a store with pre-increment.
+(define_insn "movhi_push"
+  [(set (match_operand:HI 0 "push_operand" "=m")
+    (match_operand:HI 1 "register_operand" "U"))]
+  ""
+  "pshs\t%1"
+  [(set_attr "length" "2")])
+
+
+(define_insn "*movhi_pic_symbolref"
+  [(set (match_operand:HI 0 "register_operand" "=a")
+    (match_operand:HI 1 "symbolic_operand" ""))]
+  "flag_pic"
+  "lea%0\t%c1,pcr"
+   [(set_attr "length" "4")])
+
+
+(define_insn "*movhi_1"
+  [(set (match_operand:HI 0 "nonimmediate_operand" "=a,d,a,ad,mu")
+    (match_operand:HI 1 "general_operand"          " a,a,d,miu,ad"))]
+  ""
+  "@
+   lea%0\t,%1
+   tfr\t%1,%0
+   tfr\t%1,%0
+   ld%0\t%1
+   st%1\t%0"
+   [(set_attr "length" "2,2,2,*,*")])
+
+
+;;; Generated by the combiner to merge an address calculation with
+;;; a byte load.  We can use the 'abx' instruction here.
+(define_insn "*movqi_array_load"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=q")
+    (mem:QI (plus:HI (zero_extend:HI (match_operand:QI 1 "register_operand" "%B"))
+                     (match_operand:HI 2 "immediate_operand" "i"))))
+   (clobber (match_scratch:HI 3 "=X"))]
+  ""
+  "ldx\t%2\;abx\;ld%0\t,x"
+   [(set_attr "length" "6")])
+
+
+;;; Optimize the move of a byte to the stack using the pshs instruction
+;;; instead of a store with pre-increment.
+(define_insn "movqi_push"
+  [(set (match_operand:QI 0 "push_operand" "=m")
+    (match_operand:QI 1 "register_operand" " q"))]
+  ""
+  "pshs\t%1"
+  [(set_attr "length" "2")])
+
+
+;;; Optimize the move of a byte from the stack using the puls instruction
+;;; instead of a store with post-decrement.
+(define_insn "movqi_pop"
+  [(set (match_operand:QI 0 "register_operand" "=q")
+    (match_operand:QI 1 "pop_operand" "m"))]
+  ""
+  "puls\t%0"
+  [(set_attr "length" "2")])
+
+
+;;- load low byte of 16-bit data into 8-bit register/memory
+(define_insn "*mov_lsb"
+  [(set (match_operand:QI 0 "nonimmediate_operand"    "=q,q,q,m,!q")
+      (subreg:QI (match_operand:HI 1 "general_operand" "d,m,a,d, U") 1))]
+  ""
+  "@
+   \t;movlsbqihi: D->B
+   ld%0\t%L1\t;movlsbqihi: msb:%1 -> R:%0
+   tfr\t%1,d\t;movlsbqihi: R:%1 -> R:%0
+   stb\t%0\t;movlsbqihi: R:%1 -> %0
+   pshs\t%1\t;movlsbqihi: R:%1 -> R:%0\;leas\t1,s\;puls\t%0"
+   [(set_attr "length" "0,*,2,*,6")])
+
+
+;;- load high byte of 16-bit data into 8-bit register/memory
+(define_insn "*mov_msb"
+  [(set (match_operand:QI 0 "nonimmediate_operand"    "=q,q,q,q,m,!q")
+      (subreg:QI (match_operand:HI 1 "general_operand" "d,O,a,m,d, U") 0))]
+  ""
+  "@
+   tfr\ta,b\t;movmsbqihi: D->B
+   clr%0\t\t;movmsbqihi: ZERO -> R:%0
+   tfr\t%1,d\t;movmsbqihi: R:%1 -> R:%0\;tfr\ta,b
+   ld%0\t%L1\t;movmsbqihi: lsb:%1 -> R:%0
+   sta\t%0\t;movmsbqihi: R:%1 -> %0
+   pshs\t%1\t;movmsbqihi: R:%1 -> R:%0\;puls\t%0\;leas\t1,s"
+  [(set_attr "length" "2,1,4,*,*,6")])
+
+
+(define_insn "*movqi_boolean"
+  [(set (reg:QI HARD_Z_REGNUM)
+    (match_operand:QI 0 "general_operand" "q,O,i,m"))]
+  ""
+  "@
+   tst%0
+   andcc\t#~4
+   orcc\t#4
+   tst\t%0")
+
+
+(define_insn "movqi"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=q,q,m,q,m,q,z")
+    (match_operand:QI 1 "general_operand"          " q,O,O,mi,q,z,q"))]
+  ""
+  "@
+   tfr\t%1,%0
+   clr%0
+   clr\t%0
+   ld%0\t%1
+   st%1\t%0
+   tfr\tcc,%0\;and%0\t#4
+   tst%0"
+   [(set_attr "length" "2,1,3,*,*,4,1")])
+
+
+;;--------------------------------------------------------------------
+;;-  Swap registers
+;;--------------------------------------------------------------------
+
+; Note: 8-bit swap is never needed so it is not defined.
+
+(define_insn "swaphi"
+  [(set (match_operand:HI 0 "register_operand" "+r")
+    (match_operand:HI 1 "register_operand" "+r"))
+   (set (match_dup 1) (match_dup 0))]
+  ""
+  "exg\t%1,%0"
+  [(set_attr "length" "2")
+   (set (attr "cycles") (const_int EXG_CYCLES))])
+
+
+(define_insn "bswaphi2"
+  [(set (match_operand:HI 0 "register_operand" "=d")
+    (bswap:HI (match_operand:HI 1 "register_operand" "0")))]
+  ""
+  "exg\ta,b"
+  [(set_attr "length" "2")])
+
+
+;;--------------------------------------------------------------------
+;;-  Extension and truncation insns.
+;;--------------------------------------------------------------------
+
+(define_insn "extendqihi2"
+  [(set (match_operand:HI 0 "register_operand" "=d")
+        (sign_extend:HI (match_operand:QI 1 "general_operand" "B")))]
+  ""
+  "sex\t\t;extendqihi2: R:%1 -> R:%0"
+  [(set_attr "length" "1")])
+
+
+(define_insn "zero_extendqihi2"
+  [(set (match_operand:HI 0 "register_operand" "=d")
+        (zero_extend:HI (match_operand:QI 1 "general_operand" "B")))]
+  ""
+  "clra\t\t;zero_extendqihi: R:%1 -> R:%0"
+  [(set_attr "length" "1")])
+
+
+;;--------------------------------------------------------------------
+;;- All kinds of add instructions.
+;;--------------------------------------------------------------------
+
+
+;;
+;; gcc's automatic version of addsi3 doesn't know about adcb,adca
+;; so it is MUCH less efficient.  Define this one ourselves.
+;;
+;; TODO - can't always get 'd' for the clobber... allow other registers
+;; as well and use exg d,R ... exg R,d around the code sequence to
+;; use others, at a price.  Also consider libcall for this when
+;; optimizing for size.
+;;
+(define_insn "addsi3"
+  [(set (match_operand:SI 0 "nonimmediate_operand"  "=o")
+     (plus:SI (match_operand:SI 1 "general_operand" "%o")
+        (match_operand:SI 2 "general_operand"       " oi")))
+   (clobber (match_scratch:HI 3 "=d"))]
+  ""
+{
+  m6809_output_addsi3 (PLUS, operands);
+  return "";
+}
+  [(set_attr "length" "21")])
+
+
+; Increment of a 16-bit MEM by 1 can be done without a register.
+(define_insn "*addhi_mem_1"
+  [(set (match_operand:HI 0 "memory_operand" "=m")
+        (plus:HI (match_dup 0) (const_int 1)))]
+   "GET_CODE (XEXP (operands[0], 0)) == SYMBOL_REF"
+{
+  rtx xoperands[2];
+
+  xoperands[0] = operands[0];
+  xoperands[1] = adjust_address (operands[0], QImode, 1);
+
+  output_asm_insn ("inc\t%1", xoperands);
+  output_asm_insn ("bne\t__IL%=", xoperands);
+  output_asm_insn ("inc\t%0\;__IL%=:", xoperands);
+  return "";
+}
+  [(set_attr "length" "7")])
+
+
+; Decrement of a 16-bit MEM by 1 can be done without a register.
+(define_insn "*addhi_mem_minus1"
+  [(set (match_operand:HI 0 "memory_operand" "=m")
+        (plus:HI (match_dup 0) (const_int -1)))]
+   "GET_CODE (XEXP (operands[0], 0)) == SYMBOL_REF"
+{
+  rtx xoperands[2];
+
+  xoperands[0] = operands[0];
+  xoperands[1] = adjust_address (operands[0], QImode, 1);
+
+  output_asm_insn ("tst\t%1", xoperands);
+  output_asm_insn ("bne\t__IL%=", xoperands);
+  output_asm_insn ("dec\t%0", xoperands);
+  output_asm_insn ("__IL%=:", xoperands);
+  output_asm_insn ("dec\t%1", xoperands);
+  return "";
+}
+  [(set_attr "length" "7")])
+
+
+; Allow the addition of an 8-bit quantity to a 16-bit quantity
+; using the LEAX B,Y addressing mode, where X and Y are both
+; index registers.  This will only get generated via the peephole
+; which removes a sign extension.
+(define_insn "*addhi_b"
+  [(set (match_operand:HI 0 "index_register_operand"       "=a")
+    (plus:HI(match_operand:HI 1 "index_register_operand"   "%a")
+    (match_operand:QI 2 "register_operand"                  "q")
+  ))]
+  ""
+  "lea%0\t%2,%1\t;addhi_b: R:%0 = R:%2 + R:%1"
+  [(set_attr "length" "*")])
+
+
+; Splitter for addhi pattern #5 below
+(define_split
+  [(set (match_operand:HI 0 "index_register_operand" "")
+    (plus:HI (match_dup 0) (match_operand:HI 1 "memory_operand" "")))]
+  "reload_completed"
+  [
+   (parallel [(set (match_dup 0) (reg:HI HARD_D_REGNUM))
+              (set (reg:HI HARD_D_REGNUM) (match_dup 0))])
+   (set (reg:HI HARD_D_REGNUM)
+        (plus:HI (reg:HI HARD_D_REGNUM) (match_dup 1)))
+   (parallel [(set (match_dup 0) (reg:HI HARD_D_REGNUM))
+              (set (reg:HI HARD_D_REGNUM) (match_dup 0))])
+   ]
+{
+})
+
+
+; Splitter for addhi pattern #7 below
+(define_split
+  [(set (match_operand:HI 0 "index_register_operand" "")
+    (plus:HI (match_dup 0) (match_operand:HI 1 "index_register_operand" "")))]
+  "reload_completed"
+  [
+   (parallel [(set (match_dup 1) (reg:HI HARD_D_REGNUM))
+              (set (reg:HI HARD_D_REGNUM) (match_dup 1))])
+   (set (match_dup 0)
+        (plus:HI (reg:HI HARD_D_REGNUM) (match_dup 0)))
+   (parallel [(set (match_dup 1) (reg:HI HARD_D_REGNUM))
+              (set (reg:HI HARD_D_REGNUM) (match_dup 1))])
+   ]
+{
+})
+
+
+; TODO - this is ugly.  During RTL generation, we don't know what registers
+; are available, so the multiple-insn sequences can only be solved
+; via 'define_split's during matching.  See andhi3 for an example.
+; Keep the constraints with ? modifiers to help reload pick the right
+; registers.
+;
+; The forms are:
+; 1. D += D, expand this into a shift instead. (rtx costs should be corrected
+; to avoid this even happening...)
+; 2. D += U, require U to be pushed to memory.  (Lots of patterns do this
+; now, is this a better way?)
+; 3. Best choice: 'addd'
+; 4. Next best choice: 'lea'
+; 5. Hybrid of 3 and 4
+; 6. Same as 4, not bad
+; 7. BAD, no D register at all
+; 8. 'lea', as good as 4.
+(define_insn "addhi3"
+  [(set (match_operand:HI 0 "nonimmediate_operand"      "=d, d,  d,  a,?a, a,???T,a")
+    (plus:HI(match_operand:HI 1 "add_general_operand"   "%0, 0,  0,  d, 0, a, 0, a")
+    (match_operand:HI 2 "general_operand"               " 0, !U, mi, a, m, d, T, i")
+  ))]
+  ""
+  "@
+   lslb\t\t;addhi: R:%0 += R:%2\;rola\t\t;also R:%0 *= 2
+   pshs\t%2\t;addhi: R:%0 += R:%2\;add%0\t,s++
+   add%0\t%2
+   lea%0\t%1,%2
+   #
+   lea%0\t%2,%1
+   #
+   lea%0\t%a2,%1"
+   [(set_attr "length" "2,6,*,*,7,*,7,*")])
+
+
+(define_insn "addqi3_carry"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=q")
+    (unspec:QI [
+      (match_operand:QI 1 "whole_general_operand" "%0")
+      (match_operand:QI 2 "whole_general_operand" "tmi")] UNSPEC_ADD_CARRY))]
+  ""
+  "adc%0\t%2\t;addqi_carry: R:%0 += %2"
+  [(set_attr "length" "*")])
+
+
+; TODO: specifying 'A' for the first constraint, to force into the A register
+; is not working because of the way registers are currently set up.  This will
+; take some work to get right.  Thus the second alternative as a backup.
+(define_insn "addqi3_decimal"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=A,?q")
+    (unspec:QI [
+      (match_operand:QI 1 "general_operand"        "%0,0")
+      (match_operand:QI 2 "general_operand"        "mi,mi")] UNSPEC_ADD_DECIMAL))]
+  ""
+  "@
+   adda\t%2\;daa
+   tfr\t%0,a\;adda\t%2\;daa\;tfr\ta,%0"
+  [(set_attr "length" "5,9")])
+
+
+(define_insn "addqi3"
+  [(set (match_operand:QI 0 "nonimmediate_operand"       "=q,q,q,m,m,q")
+    (plus:QI (match_operand:QI 1 "whole_general_operand" "%0,0,0,0,0,0")
+    (match_operand:QI 2 "whole_general_operand"          " 0,I,N,I,N,mi")))]
+  ""
+  "@
+   asl%0\t\t;addqi: R:%0 = R:%0 + R:%0
+   inc%0
+   dec%0
+   inc\t%0
+   dec\t%0
+   add%0\t%2"
+  [(set_attr "length" "1,1,1,3,3,*")])
+
+
+;;--------------------------------------------------------------------
+;;- Subtract instructions.
+;;--------------------------------------------------------------------
+
+(define_insn "subsi3"
+  [(set (match_operand:SI 0 "nonimmediate_operand"  "=o")
+     (minus:SI (match_operand:SI 1 "general_operand" " o")
+        (match_operand:SI 2 "general_operand"       " oi")))
+   (clobber (match_scratch:HI 3 "=d"))]
+  ""
+{
+  m6809_output_addsi3 (MINUS, operands);
+  return "";
+}
+  [(set_attr "length" "21")])
+
+
+(define_insn "subhi3"
+  [(set (match_operand:HI 0 "register_operand"      "=d,  d, a")
+    (minus:HI (match_operand:HI 1 "register_operand" "0,  0, 0")
+    (match_operand:HI 2 "general_operand"            "mi, ?U,n")))]
+  ""
+  "@
+   sub%0\t%2\t;subhi: R:%0 -= %2
+   pshs\t%2\t;subhi: R:%0 -= R:%2\;sub%0\t,s++
+   lea%0\t%n2,%1\t;subhi: R:%0 = R:%1 + %n2"
+   [(set_attr "length" "*,5,3")])
+
+
+(define_insn "subqi3_carry"
+  [(set (match_operand:QI 0 "register_operand" "=q")
+    (unspec:QI [
+      (match_operand:QI 1 "whole_general_operand" "%0")
+      (match_operand:QI 2 "whole_general_operand" "tmi")] UNSPEC_SUB_CARRY))]
+  ""
+  "sbc%0\t%2\t;subqi_carry: R:%0 += %2"
+  [(set_attr "length" "*")])
+
+
+(define_insn "subqi3"
+  [(set (match_operand:QI 0 "register_operand"            "=q, q, !q, q")
+    (minus:QI (match_operand:QI 1 "whole_register_operand" "0, 0,  I, 0")
+    (match_operand:QI 2 "whole_general_operand"            "I, mi, 0, t")))]
+  ""
+  "@
+   dec%0
+   sub%0\t%2
+   dec%0\;neg%0
+   sub%0\t%2"
+   [(set_attr "length" "1,3,2,3")])
+
+
+;;--------------------------------------------------------------------
+;;- Multiply instructions.
+;;--------------------------------------------------------------------
+
+; TODO - merge these two instructions, using 'extend_operator' to match
+; either signed or zero extension.  Everything else is the same.
+(define_insn "mulqihi3"
+   [(set (match_operand:HI 0 "register_operand" "=d")
+      (mult:HI (sign_extend:HI (match_operand:QI 1 "general_operand" "%q"))
+      (match_operand:QI 2 "general_operand" "tmK")))]
+  ""
+  "lda\t%2\t;mulqihi3\;mul"
+  [(set_attr "length" "3")])
+
+
+(define_insn "umulqihi3"
+   [(set (match_operand:HI 0 "register_operand" "=d")
+    (mult:HI (zero_extend:HI (match_operand:QI 1 "general_operand" "%q"))
+    (match_operand:QI 2 "general_operand" "tmK")))]
+  ""
+  "lda\t%2\t;umulqihi3\;mul"
+  [(set_attr "length" "3")])
+
+
+; Expand a 16x16 multiplication into either a libcall or a shift.
+; If the second operand is a small constant, use the above form.
+; Otherwise, do a libcall.
+(define_expand "mulhi3"
+  [(set (match_operand:HI 0 "nonimmediate_operand" "")
+    (mult:HI (match_operand:HI 1 "general_operand" "")
+    (match_operand:HI 2 "nonmemory_operand" "")))]
+  ""
+{
+  emit_libcall_insns (HImode, "mulhi3", operands, 2);
+  DONE;
+})
+
+
+;;--------------------------------------------------------------------
+;;- Divide instructions.
+;;--------------------------------------------------------------------
+
+(define_expand "divhi3"
+  [(set (match_operand:HI 0 "register_operand" "")
+    (div:HI (match_operand:HI 1 "register_operand" "")
+    (match_operand:HI 2 "register_operand" "")))]
+  ""
+{
+  emit_libcall_insns (HImode, "divhi3", operands, 2);
+  DONE;
+})
+
+
+(define_expand "divqi3"
+  [(set (match_operand:QI 0 "register_operand" "")
+    (div:QI (match_operand:QI 1 "register_operand" "")
+    (match_operand:QI 2 "register_operand" "")))]
+  ""
+{
+  emit_libcall_insns (QImode, "divqi3", operands, 2);
+  DONE;
+})
+
+
+(define_expand "udivhi3"
+  [(set (match_operand:HI 0 "register_operand" "")
+     (udiv:HI (match_operand:HI 1 "register_operand" "")
+              (match_operand:HI 2 "register_operand" "")))]
+  ""
+{
+  emit_libcall_insns (HImode, "udivhi3", operands, 2);
+  DONE;
+})
+
+
+;;--------------------------------------------------------------------
+;;- mod
+;;--------------------------------------------------------------------
+
+(define_expand "modhi3"
+  [(set (match_operand:HI 0 "register_operand" "")
+    (mod:HI (match_operand:HI 1 "register_operand" "")
+    (match_operand:HI 2 "register_operand" "")))]
+  ""
+{
+  emit_libcall_insns (HImode, "modhi3", operands, 2);
+  DONE;
+})
+
+
+(define_expand "modqi3"
+  [(set (match_operand:QI 0 "register_operand" "")
+    (mod:QI (match_operand:QI 1 "register_operand" "")
+    (match_operand:QI 2 "register_operand" "")))]
+  ""
+{
+  emit_libcall_insns (QImode, "modqi3", operands, 2);
+  DONE;
+})
+
+
+(define_expand "umodhi3"
+  [(set (match_operand:HI 0 "register_operand" "")
+    (umod:HI (match_operand:HI 1 "register_operand" "")
+    (match_operand:HI 2 "register_operand" "")))]
+  ""
+{
+  emit_libcall_insns (HImode, "umodhi3", operands, 2);
+  DONE;
+})
+
+
+
+;;--------------------------------------------------------------------
+;;- and, or, xor common patterns
+;;--------------------------------------------------------------------
+
+; Split a bitwise HImode into two QImode instructions, with one of
+; the sources in a pushable register.  The register is pushed onto
+; the stack and memory pop operands (,s+) are used in the QI forms.
+(define_split
+  [(set (match_operand:HI 0 "register_operand" "")
+    (match_operator:HI 3 "logical_bit_operator"
+      [(match_operand:HI 1 "register_operand" "")
+       (match_operand:HI 2 "register_operand" "")]))]
+  "reload_completed"
+  [(set (mem:HI (pre_dec:HI (reg:HI HARD_S_REGNUM))) (match_dup 2))
+   (set (reg:QI HARD_A_REGNUM) (match_op_dup:QI 3
+         [(reg:QI HARD_A_REGNUM)
+          (mem:QI (post_inc:QI (reg:HI HARD_S_REGNUM)))]))
+   (set (reg:QI HARD_D_REGNUM) (match_op_dup:QI 3
+         [(reg:QI HARD_D_REGNUM)
+          (mem:QI (post_inc:QI (reg:HI HARD_S_REGNUM)))]))
+   (use (reg:QI HARD_A_REGNUM))]
+{
+})
+
+; Split a bitwise HImode into two QImode instructions, with one
+; of the sources being a (MEM (MEM (...)); i.e. an indirect memory
+; reference.  This requires dereferencing the pointer into a
+; temporary register (X), which must be saved/restored around the
+; compute instructions.
+(define_split 
+  [(set (match_operand:HI 0 "register_operand" "")
+    (match_operator:HI 3 "logical_bit_operator"
+      [(match_operand:HI 1 "register_operand" "")
+       (mem:HI (match_operand:HI 2 "memory_operand" ""))]))]
+  "reload_completed"
+  [
+   (set (mem:HI (pre_dec:HI (reg:HI HARD_S_REGNUM))) (match_dup 4))
+   (set (match_dup 4) (match_dup 2))
+   (set (match_dup 4) (mem:HI (match_dup 4)))
+   (set (reg:QI HARD_A_REGNUM) (match_op_dup:QI 3
+         [(reg:QI HARD_A_REGNUM)
+          (mem:QI (post_inc:QI (match_dup 4)))]))
+   (set (reg:QI HARD_D_REGNUM) (match_op_dup:QI 3
+         [(reg:QI HARD_D_REGNUM)
+          (mem:QI (post_inc:QI (match_dup 4)))]))
+   (use (reg:QI HARD_A_REGNUM))
+   (set (match_dup 4) (mem:HI (post_inc:HI (reg:HI HARD_S_REGNUM))))
+   ]
+{
+  /* Use X for a temporary index register */
+  operands[4] = gen_rtx_REG (HImode, HARD_X_REGNUM);
+})
+
+
+; Split a bitwise HImode into two QImode instructions.  This is
+; the common case.  This handles splitting when neither of the
+; above two cases applies.
+(define_split 
+  [(set (match_operand:HI 0 "register_operand" "")
+    (match_operator:HI 3 "logical_bit_operator"
+      [(match_operand:HI 1 "register_operand" "")
+       (match_operand:HI 2 "general_operand" "")]))]
+  "reload_completed"
+  [(set (reg:QI HARD_A_REGNUM) (match_op_dup:QI 3
+      [(reg:QI HARD_A_REGNUM) (match_dup 4)]))
+   (set (reg:QI HARD_D_REGNUM) (match_op_dup:QI 3
+      [(reg:QI HARD_D_REGNUM) (match_dup 5)]))
+   (use (reg:QI HARD_A_REGNUM))]
+{
+  if (GET_CODE (operands[2]) == CONST_INT)
+  {
+    operands[4] = gen_rtx_const_high (operands[2]);
+    operands[5] = gen_rtx_const_low (operands[2]);
+  }
+  else if ((GET_CODE (operands[2]) == MEM)
+    && (GET_CODE (XEXP (operands[2], 0)) == MEM))
+  {
+    FAIL;
+  }
+  else
+  {
+    operands[4] = gen_highpart (QImode, operands[2]);
+    operands[5] = gen_lowpart (QImode, operands[2]);
+  }
+})
+
+; Below are the specific cases for each of the operators.
+; The QImode versions are the simplest and can be implemented
+; directly on the hardware.  The HImode cases are all output
+; using one of the above splitting techniques.
+
+;;--------------------------------------------------------------------
+;;- and
+;;--------------------------------------------------------------------
+
+(define_insn "andhi3"
+  [(set (match_operand:HI 0 "register_operand" "=d")
+    (and:HI (match_operand:HI 1 "register_operand" "%0")
+    (match_operand:HI 2 "general_operand" "mnU")))]
+  ""
+  "#")
+
+;; it is not clear that this is correct
+(define_insn "*andqi_2"
+  [(set
+   (match_operand:QI 0 "register_operand" "=q")
+   (and:QI (match_operand:QI 1 "register_operand" "q")
+     (match_operand 2 "const_int_operand" "i")))]
+  ""
+{
+  if (GET_CODE (operands[2]) == CONST_INT)
+  {
+    operands[3] = GEN_INT(INTVAL(operands[2]) & 0xff);
+    return "and%0\t%3";
+  }
+
+  return "and%0\t%2";
+}
+  [(set_attr "length" "2")])
+
+(define_insn "andqi3"
+  [(set (match_operand:QI 0 "register_operand"           "=q,q,q,qc")
+    (and:QI (match_operand:QI 1 "whole_register_operand" "%0,0,0,0")
+    (match_operand:QI 2 "whole_general_operand"          " O,N,m,i")))]
+  ""
+  "@
+   clr%0\t;andqi(ZERO)
+   \t;andqi(-1)
+   and%0\t%2
+   and%0\t%2"
+   [(set_attr "length" "1,0,3,2")])
+
+
+;;--------------------------------------------------------------------
+;;- or
+;;--------------------------------------------------------------------
+
+(define_insn "iorhi3"
+  [(set (match_operand:HI 0 "register_operand" "=d")
+    (ior:HI (match_operand:HI 1 "register_operand" "%0")
+    (match_operand:HI 2 "general_operand" "mnU")))]
+  ""
+  "#")
+
+
+(define_insn "iorqi3"
+  [(set (match_operand:QI 0 "register_operand"           "=q,q, qc")
+    (ior:QI (match_operand:QI 1 "whole_register_operand" "%0,0, 0")
+    (match_operand:QI 2 "whole_general_operand"          " O,m,i")))]
+  ""
+  "@
+   \t;iorqi(ZERO)
+   or%0\t%2
+   or%0\t%2"
+   [(set_attr "length" "0,3,2")])
+
+;;--------------------------------------------------------------------
+;;- xor
+;;--------------------------------------------------------------------
+
+(define_insn "xorhi3"
+  [(set (match_operand:HI 0 "register_operand" "=d")
+    (xor:HI (match_operand:HI 1 "register_operand" "%0")
+    (match_operand:HI 2 "general_operand" "mnU")))]
+  ""
+  "#")
+
+
+(define_insn "xorqi3"
+  [(set (match_operand:QI 0 "register_operand"           "=q,q,q,q")
+    (xor:QI (match_operand:QI 1 "whole_register_operand" "%0,0,0,0")
+    (match_operand:QI 2 "whole_general_operand"          " O,N,m,i")))]
+  ""
+  "@
+   \t;xorqi(ZERO)
+   com%0\t;xorqi(-1)
+   eor%0\t%2
+   eor%0\t%2"
+   [(set_attr "length" "0,1,3,2")])
+
+;;--------------------------------------------------------------------
+;;-  Two's Complements
+;;--------------------------------------------------------------------
+
+(define_insn "neghi2"
+  [(set (match_operand:HI 0 "nonimmediate_operand" "=d,!a")
+    (neg:HI (match_operand:HI 1 "general_operand"   "0, 0")))]
+  ""
+  "@
+   nega\;negb\;sbca\t#0
+   exg\td,%0\;nega\;negb\;sbca\t#0\;exg\td,%0"
+  [(set_attr "length" "5,9")])
+
+
+(define_insn "negqi2"
+  [(set (match_operand:QI 0 "nonimmediate_operand"    "=q,m")
+    (neg:QI (match_operand:QI 1 "nonimmediate_operand" "0,0")))]
+  ""
+  "@
+   neg%0
+   neg\t%0"
+  [(set_attr "length" "1,3")])
+
+
+;;--------------------------------------------------------------------
+;;-  One's Complements
+;;--------------------------------------------------------------------
+
+(define_insn "one_cmplhi2"
+  [(set (match_operand:HI 0 "nonimmediate_operand" "=d,?tm,???a")
+    (not:HI (match_operand:HI 1 "general_operand"   "0,  0,   0")))]
+  ""
+  "@
+   coma\;comb
+   com\t%0\;com\t%L0
+   exg\td,%0\;coma\;comb\;exg\td,%0"
+  [(set_attr "length" "2,6,6")])
+
+
+(define_insn "one_cmplqi2"
+  [(set (match_operand:QI 0 "nonimmediate_operand"    "=q,m")
+    (not:QI (match_operand:QI 1 "nonimmediate_operand" "0,0")))]
+  ""
+  "@
+   com%0
+   com\t%0"
+  [(set_attr "length" "1,3")])
+
+;;--------------------------------------------------------------------
+;;- Shifts/rotates
+;;--------------------------------------------------------------------
+
+(define_code_iterator bit_code [ashift ashiftrt lshiftrt])
+(define_code_attr bit_code_name [(ashift "ashl") (ashiftrt "ashr") (lshiftrt "lshr")])
+
+(define_mode_iterator bit_mode [QI HI])
+(define_mode_attr bit_mode_name [(QI "qi3") (HI "hi3")])
+
+;; Emit RTL for any shift (handles all 3 opcodes and 2 mode sizes)
+
+(define_expand "<bit_code:bit_code_name><bit_mode:bit_mode_name>"
+  [(set (match_operand:bit_mode 0 "nonimmediate_operand" "")
+    (bit_code:bit_mode (match_operand:bit_mode 1 "general_operand" "")
+    (match_operand:bit_mode 2 "nonmemory_operand" "")))]
+  ""
+{
+})
+
+; Individual instructions implemented in the CPU.
+
+
+(define_insn "*ashift1"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=m,q")
+    (ashift:QI (match_operand:QI 1 "general_operand" "0,0") (const_int 1)))]
+  ""
+  "@
+   asl\t%0
+   asl%0"
+  [(set_attr "length" "3,1")])
+
+(define_insn "*lshiftrt1"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=m,q")
+    (lshiftrt:QI (match_operand:QI 1 "general_operand" "0,0") (const_int 1)))]
+  ""
+  "@
+   lsr\t%0
+   lsr%0"
+  [(set_attr "length" "3,1")])
+
+(define_insn "*ashiftrt1"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=m,q")
+    (ashiftrt:QI (match_operand:QI 1 "general_operand" "0,0") (const_int 1)))]
+  ""
+  "@
+   asr\t%0
+   asr%0"
+  [(set_attr "length" "3,1")])
+
+(define_insn "*rotate1"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=m,q")
+    (rotate:QI (match_operand:QI 1 "general_operand" "0,0") (const_int 1)))]
+  ""
+  "@
+   rol\t%0
+   rol%0"
+  [(set_attr "length" "3,1")])
+
+
+(define_insn "*rotatert1"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=m,q")
+    (rotatert:QI (match_operand:QI 1 "general_operand" "0,0") (const_int 1)))]
+  ""
+  "@
+   ror\t%0
+   ror%0"
+  [(set_attr "length" "3,1")])
+
+
+; A shift by 8 for D reg can be optimized by just moving
+; between the A/B halves, and then zero/sign extending or
+; filling in zeroes.
+; Because GCC does not understand that 'A' and 'D' refer to
+; the same storage location, we must use 'USE' throughout
+; to prevent deletion of 'unnecessary' instructions.
+; Similar optimization for MEM would require a scratch register
+; so is not done here.
+
+(define_split
+  [(set (reg:HI HARD_D_REGNUM) (ashift:HI (reg:HI HARD_D_REGNUM) (const_int 8)))]
+  "reload_completed"
+  [
+   (use (reg:HI HARD_D_REGNUM))
+   (set (reg:QI HARD_A_REGNUM) (reg:QI HARD_D_REGNUM))
+   (use (reg:QI HARD_A_REGNUM))
+   (set (reg:QI HARD_D_REGNUM) (const_int 0))
+   ]
+  "")
+
+(define_split
+  [(set (reg:HI HARD_D_REGNUM) (lshiftrt:HI (reg:HI HARD_D_REGNUM) (const_int 8)))]
+  "reload_completed"
+  [
+   (use (reg:HI HARD_D_REGNUM))
+   (set (reg:QI HARD_D_REGNUM) (reg:QI HARD_A_REGNUM))
+   (use (reg:QI HARD_D_REGNUM))
+   (set (reg:HI HARD_D_REGNUM) (zero_extend:HI (reg:QI HARD_D_REGNUM)))
+   ]
+  "")
+
+(define_split
+  [(set (reg:HI HARD_D_REGNUM) (ashiftrt:HI (reg:HI HARD_D_REGNUM) (const_int 8)))]
+  "reload_completed"
+  [
+   (use (reg:HI HARD_D_REGNUM))
+   (set (reg:QI HARD_D_REGNUM) (reg:QI HARD_A_REGNUM))
+   (use (reg:QI HARD_D_REGNUM))
+   (set (reg:HI HARD_D_REGNUM) (sign_extend:HI (reg:QI HARD_D_REGNUM)))
+   ]
+  "")
+
+
+; On the WPC hardware, there is a shift register that can be used
+; to compute (1<<n) efficiently in two instructions.  Note that this
+; form only works when using -mint8 though, because C will promote
+; to 'int' when doing this operation.  TODO : we need a 16-bit form too.
+(define_insn "ashlqi3_wpc"
+  [(set (match_operand:QI 0 "nonimmediate_operand" "=q")
+    (ashift:QI (match_operand:QI 1 "immediate_operand" "I")
+    (match_operand:QI 2 "general_operand" "q")))]
+  "TARGET_WPC"
+  "st%2\t0x3FF7\;ld%0\t0x3FF7"
+  [(set_attr "length" "6")])
+
+
+; Internal instructions for shifting by a constant.
+; Two forms are provided, one for QImode, one for HImode.
+; These are always split into the above instructions
+; (except for QImode forms that directly match one of the
+; above instructions, in which the condition will not
+; allow the splitter to match).
+
+(define_insn_and_split "<bit_code:bit_code_name>hi3_const"
+  [(set (match_operand:HI 0 "nonimmediate_operand"     "=dm")
+    (bit_code:HI (match_operand:HI 1 "general_operand" "0")
+    (match_operand:HI 2 "immediate_operand"            "n")))]
+  ""
+  "#"
+  "reload_completed"
+  [(const_int 0)]
+{
+  m6809_split_shift (<bit_code:CODE>, operands);
+  DONE;
+})
+
+
+(define_insn_and_split "<bit_code:bit_code_name>qi3_const"
+  [(set (match_operand:QI 0 "nonimmediate_operand"     "=qm")
+    (bit_code:QI (match_operand:QI 1 "general_operand" "0")
+    (match_operand:QI 2 "immediate_operand"            "n")))]
+  "INTVAL (operands[2]) > 1"
+  "#"
+  "&& reload_completed"
+  [(const_int 0)]
+{
+  m6809_split_shift (<bit_code:CODE>, operands);
+  DONE;
+})
+
+; Internal instructions for shifting by a nonconstant.
+; These expand into complex assembly.
+
+(define_insn "<bit_code:bit_code_name>hi3_reg"
+  [(set (match_operand:HI 0 "nonimmediate_operand"     "=d")
+    (bit_code:HI (match_operand:HI 1 "general_operand" "0")
+    (match_operand:HI 2 "nonimmediate_operand"         "v")))]
+  ""
+{
+  m6809_output_shift_insn (<bit_code:CODE>, operands);
+  return "";
+}
+  [(set_attr "length" "20")])
+
+
+(define_insn "<bit_code:bit_code_name>qi3_reg"
+  [(set (match_operand:QI 0 "nonimmediate_operand"    "=q")
+    (bit_code:QI (match_operand:QI 1 "general_operand" "0")
+    (match_operand:QI 2 "nonimmediate_operand"         "v")))]
+  ""
+{
+  m6809_output_shift_insn (<bit_code:CODE>, operands);
+  return "";
+}
+  [(set_attr "length" "16")])
+
+
+
+;;--------------------------------------------------------------------
+;;-  Jumps and transfers
+;;--------------------------------------------------------------------
+
+;;; The casesi pattern is normally *not* defined; see 'tablejump' instead.
+(define_expand "casesi"
+  [(match_operand:HI 0 "register_operand" "")   ; index to jump on
+   (match_operand:HI 1 "immediate_operand" "")   ; lower bound
+   (match_operand:HI 2 "immediate_operand" "")   ; total range
+   (match_operand 3 "" "")   ; table label
+   (match_operand 4 "" "")]  ; out of range label
+  "TARGET_BYTE_INT && TARGET_CASESI"
+{
+  m6809_do_casesi (operands[0], operands[1], operands[2],
+                   operands[3], operands[4]);
+  DONE;
+})
+
+(define_insn "tablejump_short_offset"
+  [(set (pc)
+       (mem:HI (plus:HI (match_operand:HI 1 "register_operand" "U")
+                (zero_extend:HI (match_operand:QI 0 "register_operand" "q")))))]
+  ""
+  "jmp\t[b,x]\t;tablejump_short_offset"
+  [(set_attr "length" "3")])
+
+(define_insn "tablejump_long_offset"
+  [(set (pc)
+       (mem:HI (plus:HI (match_operand:HI 1 "register_operand" "U")
+                (match_operand:HI 0 "register_operand" "d"))))]
+  ""
+  "jmp\t[d,x]\t;tablejump_long_offset"
+  [(set_attr "length" "3")])
+
+
+ ;; A tablejump operation gives the address in operand 0, with the
+ ;; CODE_LABEL for the table in operand 1.  The 'define_expand'
+ ;; shows the arguments as GCC presents them.  For a register
+ ;; operand, the assembly code is straightforward.  For a MEM,
+ ;; assumed to be a SYMBOL_REF, two forms are given, one normal
+ ;; and one for PIC mode.
+ (define_expand "tablejump"
+    [(parallel [
+     (set (pc) (match_operand:HI 0 "" ""))
+     (use (label_ref (match_operand 1 "" "")))
+     (clobber (match_scratch:HI 2 ""))
+     ])]
+    ""
+ {
+ })
+
+
+(define_insn "*tablejump_reg"
+   [(parallel [
+      (set (pc)
+         (match_operand:HI 0 "register_operand" "a"))
+      (use (label_ref (match_operand 1 "" "")))
+      (clobber (match_scratch:HI 2 ""))
+      ])]
+   ""
+   "jmp\t,%0"
+   [(set_attr "length" "3")])
+
+
+(define_insn "*tablejump_symbol"
+  [(parallel [
+     (set (pc)
+        (mem:HI
+           (plus:HI (match_operand:HI 0 "register_operand" "a")
+                    (label_ref (match_operand 1 "" "")))))
+     (use (label_ref (match_dup 1)))
+     (clobber (match_scratch:HI 2 ""))
+     ])]
+  "!flag_pic"
+{
+  output_asm_insn ("jmp\t[%a1,%0]", operands);
+  return "";
+}
+  [(set_attr "length" "4")])
+
+
+(define_insn "*tablejump_symbol_pic"
+  [(parallel [
+     (set (pc)
+        (mem:HI
+           (plus:HI (match_operand:HI 0 "register_operand" "d")
+                    (label_ref (match_operand 1 "" "")))))
+     (use (label_ref (match_dup 1)))
+     (clobber (match_scratch:HI 2 "=&a"))
+     ])]
+  "flag_pic"
+{
+  output_asm_insn ("lea%2\t%a1,pcr", operands);
+  output_asm_insn ("ld%0\t%0,%2", operands);
+  output_asm_insn ("jmp\t%0,%2", operands);
+  return "";
+}
+  [(set_attr "length" "8")])
+
+
+(define_insn "indirect_jump"
+  [(set (pc)
+    (match_operand:HI 0 "register_operand" "a"))]
+  ""
+  "jmp\t,%0"
+  [(set_attr "length" "3")])
+
+
+(define_insn "jump"
+  [(set (pc) (label_ref (match_operand 0 "" "")))]
+  ""
+{
+  return output_branch_insn ( LABEL_REF, operands, get_attr_length (insn));
+}
+  [(set (attr "type") (const_string "branch"))])
+
+; Output assembly for a condition branch instruction.
+(define_insn "*cond_branch"
+  [(set (pc)
+    (if_then_else
+      (match_operator 1 "comparison_operator" [(cc0) (const_int 0)])
+        (label_ref (match_operand 0 "" "")) (pc)))]
+  ""
+{
+  return output_branch_insn ( GET_CODE(operands[1]),
+    operands, get_attr_length (insn));
+}
+  [(set (attr "type") (const_string "cbranch"))])
+
+
+; Similar to above, but for a condition branch instruction that
+; had its operands reversed at some point.
+(define_insn "*cond_branch_reverse"
+  [(set (pc)
+    (if_then_else
+      (match_operator 1 "comparison_operator" [(cc0) (const_int 0)])
+      (pc) (label_ref (match_operand 0 "" ""))))]
+  ""
+{
+  return output_branch_insn ( reverse_condition (GET_CODE(operands[1])),
+    operands, get_attr_length (insn));
+}
+  [(set (attr "type") (const_string "cbranch"))])
+
+
+
+;;--------------------------------------------------------------------
+;;-  Calls
+;;--------------------------------------------------------------------
+
+;; Generate a call instruction for a function that does not
+;; return a value.  The expander is used during RTL generation.
+;; The instructions below are used during matching; only one
+;; of them will be used, depending on the type of function
+;; being called.  The different conditions are:
+;;
+;;    1) far_functionp - is this a far function?  Those need
+;;    to be output as indirect calls through a far-function
+;;    handler.
+;;
+;;    2) noreturn_functionp - if the function does not return,
+;;    we can use a 'jmp' instead of a 'jsr' to call it.
+;;
+;;    3) is PIC mode enabled?  If so, we'll always use
+;;    relative calls (lbsr or lbra).
+;;
+;; Note: not all combinations are fully supported, especially
+;; relating to PIC.
+;;
+;; The 'bsr' instruction is never generated.
+
+(define_expand "call"
+  [(call (match_operand:HI 0 "memory_operand" "")
+    (match_operand:HI 1 "general_operand" ""))]
+  ""
+  "")
+
+(define_insn "*call_nopic_far"
+  [(call (match_operand:HI 0 "memory_operand" "m")
+    (match_operand:HI 1 "general_operand" "g"))]
+  "far_functionp (operands[0])"
+{
+  output_far_call_insn (operands, 0);
+  return "";
+}
+  [(set_attr "length" "6")])
+
+
+; PIC forms come first, and should only match
+; (MEM (SYMBOL_REF)).  Other MEM forms are treated as usual.
+(define_insn "*call_pic"
+  [(call (mem:HI (match_operand:HI 0 "symbolic_operand" ""))
+    (match_operand:HI 1 "general_operand" "g"))]
+  "flag_pic && !noreturn_functionp (operands[0])"
+  "lbsr\t%C0"
+  [(set_attr "length" "4")])
+
+
+(define_insn "*call_nopic"
+  [(call (match_operand:HI 0 "memory_operand" "m")
+    (match_operand:HI 1 "general_operand" "g"))]
+  "!noreturn_functionp (operands[0])"
+  "jsr\t%0"
+  [(set_attr "length" "3")
+   (set (attr "cycles") (const_int JSR_EXTENDED_CYCLES))])
+
+
+(define_insn "*call_noreturn_pic"
+  [(call (mem:HI (match_operand:HI 0 "symbolic_operand" ""))
+    (match_operand:HI 1 "general_operand" "g"))]
+  "flag_pic && noreturn_functionp (operands[0])"
+  "lbra\t%C0"
+  [(set_attr "length" "4")])
+
+
+(define_insn "*call_noreturn_nopic"
+  [(call (match_operand:HI 0 "memory_operand" "m")
+    (match_operand:HI 1 "general_operand" "g"))]
+  "noreturn_functionp (operands[0])"
+  "jmp\t%0"
+  [(set_attr "length" "3")])
+
+
+;;
+;; Same as above, but for functions that do return a value.
+;;
+(define_expand "call_value"
+  [(set (match_operand 0 "" "")
+    (call (match_operand:HI 1 "memory_operand" "")
+    (match_operand:HI 2 "general_operand" "")))]
+  ""
+  "")
+
+
+(define_insn "*call_value_far"
+  [(set (match_operand 0 "" "=gz")
+    (call (match_operand:HI 1 "memory_operand" "m")
+    (match_operand:HI 2 "general_operand" "g")))]
+  "far_functionp (operands[1])"
+{
+  output_far_call_insn (operands, 1);
+  return "";
+}
+  [(set_attr "length" "6")])
+
+
+(define_insn "*call_value_pic"
+  [(set (match_operand 0 "" "=gz")
+    (call (mem:HI (match_operand:HI 1 "symbolic_operand" ""))
+    (match_operand:HI 2 "general_operand" "g")))]
+  "flag_pic"
+  "lbsr\t%C1"
+  [(set_attr "length" "4")])
+
+
+(define_insn "*call_value_nopic"
+  [(set (match_operand 0 "" "=gz")
+    (call (match_operand:HI 1 "memory_operand" "m")
+    (match_operand:HI 2 "general_operand" "g")))]
+  ""
+  "jsr\t%1"
+  [(set_attr "length" "3")
+   (set (attr "cycles") (const_int JSR_EXTENDED_CYCLES))])
+
+
+
+;;
+;; How to generate an untyped call.
+;;
+(define_expand "untyped_call"
+  [(parallel [(call (match_operand 0 "" "")
+        (const_int 0))
+      (match_operand 1 "" "")
+      (match_operand 2 "" "")])]
+  ""
+{
+  int i;
+
+  emit_call_insn (GEN_CALL (operands[0], const0_rtx, NULL, const0_rtx));
+  for (i=0; i < XVECLEN (operands[2], 0); i++)
+  {
+    rtx set = XVECEXP (operands[2], 0, i);
+    emit_move_insn (SET_DEST (set), SET_SRC (set));
+  }
+  emit_insn (gen_blockage ());
+  DONE;
+})
+
+
+(define_expand "sibcall"
+  [(parallel
+     [(call (match_operand:HI 0 "memory_operand" "")
+            (match_operand:HI 1 "immediate_operand" ""))
+      (use (reg:HI HARD_PC_REGNUM))])]
+  ""
+  "")
+
+(define_insn "*sibcall_1"
+  [(parallel
+     [(call (match_operand:HI 0 "memory_operand" "m")
+            (match_operand:HI 1 "immediate_operand" "i"))
+      (use (reg:HI HARD_PC_REGNUM))])]
+  "SIBLING_CALL_P(insn)"
+  "jmp\t%0"
+  [(set_attr "length" "4")])
+
+
+(define_expand "sibcall_value"
+  [(parallel
+     [(set (match_operand 0 "" "")
+         (call (match_operand:HI 1 "memory_operand" "")
+               (match_operand:HI 2 "immediate_operand" "")))
+      (use (reg:HI HARD_PC_REGNUM))])]
+  ""
+  "")
+
+(define_insn "*sibcall_value_1"
+  [(parallel
+     [(set (match_operand 0 "" "=gz")
+         (call (match_operand:HI 1 "memory_operand" "m")
+               (match_operand:HI 2 "immediate_operand" "i")))
+      (use (reg:HI HARD_PC_REGNUM))])]
+  "SIBLING_CALL_P(insn)"
+  "jmp\t%1"
+  [(set_attr "length" "4")])
+
+
+;;--------------------------------------------------------------------
+;;-  Function Entry and Exit
+;;--------------------------------------------------------------------
+
+;; On entry to a function, the stack frame looks as follows:
+;; - return address (pushed by the caller)
+;; - saved registers
+;; - local variable storage
+;;
+;; If the function does not modify the stack after that, then
+;; any of these can be accessed directly as an offset from
+;; STACK_POINTER_REGNUM.  Otherwise, a frame pointer is required.
+;; In that case, the prologue must also initialize HARD_FRAME_POINTER_REGNUM
+;; and all references to the stack frame will use that as a base instead.
+;;
+(define_expand "prologue"
+  [(const_int 0)]
+  "prologue_epilogue_required ()"
+{
+  emit_prologue_insns ();
+  DONE;
+})
+
+
+;; The function epilogue does exactly the reverse of the prologue,
+;; deallocating local variable space, restoring saved registers,
+;; and returning.
+;;
+;; For the 6809, the return may be 'rti' if the function was
+;; declared as an interrupt function, but is normally 'rts'.
+;;
+;; Also, as an optimization, the register restore and the 'rts'
+;; can be combined into a single instruction, by adding 'PC' to the
+;; list of registers to be restored.  This is only done if there are
+;; any saved registers, as 'rts' is more efficient by itself.
+;;
+(define_expand "epilogue"
+  [(const_int 0)]
+  "prologue_epilogue_required ()"
+{
+  emit_epilogue_insns (false);
+  DONE;
+})
+
+
+(define_expand "sibcall_epilogue"
+  [(const_int 0)]
+  "prologue_epilogue_required ()"
+{
+  emit_epilogue_insns (true);
+  DONE;
+})
+
+
+;; The RTS instruction
+(define_insn "return_rts"
+  [(return)
+   (use (reg:HI HARD_PC_REGNUM))]
+  "!m6809_current_function_has_type_attr_p (\"interrupt\")
+   && m6809_get_live_regs () == 0"
+  "rts"
+  [(set_attr "length" "1")
+   (set (attr "cycles") (const_int RTS_CYCLES))])
+
+(define_insn "return_puls_pc"
+  [(return)
+   (use (reg:HI HARD_PC_REGNUM))]
+  "!m6809_current_function_has_type_attr_p (\"interrupt\")
+   && m6809_get_live_regs () != 0"
+  ""
+  [(set_attr "length" "1")
+   (set (attr "cycles") (const_int RTS_CYCLES))])
+
+;; The RTI instruction
+(define_insn "return_rti"
+  [(return)
+   (use (reg:HI HARD_PC_REGNUM))]
+  "m6809_current_function_has_type_attr_p (\"interrupt\")"
+  "rti"
+  [(set_attr "length" "1")
+   (set (attr "cycles") (const_int RTI_CYCLES))])
+
+
+;;--------------------------------------------------------------------
+;;-  Unspecified instructions
+;;--------------------------------------------------------------------
+
+;; An instruction that has the effect of an unspec_volatile, but
+;; which doesn't require emitting any assembly code.
+(define_insn "blockage"
+  [(unspec_volatile [(const_int 0)] UNSPEC_BLOCKAGE)]
+  ""
+  ""
+  [(set_attr "length" "0")
+   (set (attr "cycles") (const_int 0))])
+
+
+;; Say how to push multiple registers onto the stack, using
+;; the 6809 'pshs' instruction.  The operand is a regset
+;; specifying which registers to push.
+;;
+;; The operand mode is not given intentionally, so as to allow
+;; any possible integer mode for the regset.
+;;
+;; See below for a peephole that can combine consecutive push
+;; instructions that qualify for merging.
+(define_insn "register_push"
+  [(use (reg:HI HARD_S_REGNUM))
+    (unspec_volatile
+      [(match_operand 0 "immediate_operand" "")] UNSPEC_PUSH_RS)
+    (clobber (reg:HI HARD_S_REGNUM))]
+  ""
+  "pshs\t%R0"
+  [(set_attr "length" "2")
+   (set (attr "cycles") (const_int PSH_PUL_CYCLES))])
+
+
+;; Say how to pop multiple registers from the stack, using
+;; the 6809 'puls' instruction.  The operand is the register
+;; bitset value.
+(define_insn "register_pop"
+  [(use (reg:HI HARD_S_REGNUM))
+    (unspec_volatile
+      [(match_operand 0 "immediate_operand" "")] UNSPEC_POP_RS)
+    (clobber (reg:HI HARD_S_REGNUM))]
+  ""
+  "puls\t%R0"
+  [(set_attr "length" "2")
+   (set (attr "cycles") (const_int PSH_PUL_CYCLES))])
+
+
+(define_insn "m6809_swi"
+  [(unspec_volatile
+    [(match_operand:QI 0 "immediate_operand" "I,n")] UNSPEC_SWI)]
+  ""
+  "@
+   swi
+   swi%c0"
+  [(set_attr "length" "1,2")
+   (set (attr "cycles") (const_int SWI_CYCLES))])
+
+
+;; Generate the CWAI instruction
+(define_insn "m6809_cwai"
+  [(unspec_volatile
+    [(match_operand:QI 0 "immediate_operand" "")] UNSPEC_CWAI)]
+  ""
+  "cwai\t%0"
+  [(set_attr "length" "2")
+   (set (attr "cycles") (const_int CWAI_CYCLES))])
+
+
+;; Generate the SYNC instruction
+(define_insn "m6809_sync"
+  [(unspec_volatile [(const_int 0)] UNSPEC_SYNC)]
+  ""
+  "sync"
+  [(set_attr "length" "1")
+   (set (attr "cycles") (const_int SYNC_CYCLES))])
+
+
+;; Generate the NOP instruction
+(define_insn "nop"
+  [(const_int 0)]
+  ""
+  "nop"
+   [(set_attr "length" "1")
+   (set (attr "cycles") (const_int NOP_CYCLES))])
+
+
+;;--------------------------------------------------------------------
+;;- Peepholes
+;;--------------------------------------------------------------------
+
+;;; Each peephole has an ID that is used for debugging.
+;;; Each peephole condition is bracketed by calls to
+;;; m6809_match_peephole2() also for debugging.
+(define_constants [
+  (PEEP_END 0)
+  (PEEP_COND 1)
+
+  (PEEP_STACK_STORE_INC 0)
+  (PEEP_STACK_CLEAR_INC 1)
+  (PEEP_LSRB_ADCB 2)
+  (PEEP_ABX 3)
+  (PEEP_ABX2 4)
+  (PEEP_INDEXED_INC 5)
+  (PEEP_MEM_DEC 6)
+  (PEEP_MEM_INC 7)
+  (PEEP_MEM_DEC_CMP 8)
+  (PEEP_PUSH2 9)
+  (PEEP_STORE_IMPLIES_CC 10)
+  (PEEP_DEC_IMPLIES_CC 11)
+  (PEEP_LEAB 12)
+  (PEEP_LDX_INDIRECT 13)
+  (PEEP_POP_JUNK 14)
+])
+
+
+;;; Optimize 'leas -1,s' followed by 'stb ,s'.  This can happen if the
+;;; function prologue needs to allocate stack space and 'b' is placed
+;;; into that local right away.  Combine the stack allocation with the
+;;; store using preincrement mode.
+(define_peephole2
+  [(set (reg:HI HARD_S_REGNUM)
+        (plus:HI (reg:HI HARD_S_REGNUM) (const_int -1)))
+   (set (mem:QI (reg:HI HARD_S_REGNUM))
+        (match_operand:QI 0 "register_operand" ""))]
+  "m6809_match_peephole2 (PEEP_STACK_STORE_INC, PEEP_END)"
+  [(set (mem:QI (pre_dec:HI (reg:HI HARD_S_REGNUM))) (match_dup 0))]
+  "")
+
+
+;;; Same as above, but for a 'clr ,s' that follows the prologue.
+(define_peephole2
+  [(set (reg:HI HARD_S_REGNUM) (plus:HI (reg:HI HARD_S_REGNUM) (const_int -1)))
+   (set (mem:QI (reg:HI HARD_S_REGNUM)) (const_int 0))]
+  "m6809_match_peephole2 (PEEP_STACK_CLEAR_INC, PEEP_END)"
+  [(set (mem:QI (pre_dec:HI (reg:HI HARD_S_REGNUM))) (const_int 0))]
+  "")
+
+
+;;; Merge two consecutive push instructions into a single register_push.
+(define_peephole2
+  [(set (match_operand 0 "push_operand" "")
+    (match_operand 1 "register_operand" ""))
+   (set (match_operand 2 "push_operand" "")
+    (match_operand 3 "register_operand" ""))]
+  "m6809_match_peephole2 (PEEP_PUSH2, PEEP_COND)
+   && reload_completed
+   && GET_MODE (operands[1]) == GET_MODE (operands[3])
+   && m6809_can_merge_pushpop_p (UNSPEC_PUSH_RS, 1 << REGNO (operands[1]), 1 << REGNO (operands[3]))
+   && m6809_match_peephole2 (PEEP_PUSH2, PEEP_END)"
+  [(parallel [
+    (use (reg:HI HARD_S_REGNUM))
+    (unspec_volatile [(match_dup 4)] UNSPEC_PUSH_RS)
+    (clobber (reg:HI HARD_S_REGNUM))])
+   (use (match_dup 1))
+   (use (match_dup 3))]
+{
+  operands[4] = gen_rtx_CONST_INT (QImode,
+    (1 << REGNO (operands[1])) | (1 << REGNO (operands[3])));
+})
+
+
+;;; Convert 'stX ,--s' into a push instruction.  Use the regset
+;;; notation, so that it may be combined with an adjacent regset.
+;;; TBD - this doesn't compile some code cleanly.
+;(define_peephole2
+;  [(set (mem:HI (pre_dec:HI (reg:HI HARD_S_REGNUM)))
+;        (reg:HI HARD_X_REGNUM))]
+;  "reload_completed"
+;  [(parallel [
+;    (use (reg:HI HARD_S_REGNUM))
+;    (unspec_volatile [(match_dup 0)] UNSPEC_PUSH_RS)
+;    (clobber (reg:HI HARD_S_REGNUM))])]
+;{
+;  operands[0] = gen_rtx_CONST_INT (HImode, X_REGBIT);
+;})
+
+
+;;;
+;;; q = (q+1)/2 can be optimized as "lsrb; adcb".  This also
+;;; won't overflow when q=0xFF.
+;;; TODO : this form isn't accounting for promotion when
+;;; using 16-bit ints.
+;;;
+(define_peephole
+  [(set (reg:QI HARD_D_REGNUM)
+    (lshiftrt:QI (plus:HI (match_dup 0) (const_int 1)) (const_int 1)))]
+  "m6809_match_peephole2 (PEEP_LSRB_ADCB, PEEP_END)"
+  "lsrb\;adcb\t#0; peephole"
+  [(set_attr "length" "2")])
+
+
+;;
+;; Optimize the case of following a register store with a test
+;; of reg or mem just moved.
+;;
+(define_peephole
+  [(set (match_operand:HI 0 "memory_operand" "=m")
+  (match_operand:HI 1 "register_operand" "r"))
+   (set (cc0) (match_operand:HI 2 "general_operand" "g"))]
+  "m6809_match_peephole2 (PEEP_STORE_IMPLIES_CC, PEEP_COND)
+   && (operands[2] == operands[0] || operands[2] == operands[1])
+   && m6809_match_peephole2 (PEEP_STORE_IMPLIES_CC, PEEP_END)"
+  "st%1\t%0\t;movhi: R:%1 -> %0 w/ implied test of %2"
+  [(set_attr "length" "4")])
+
+
+;; Optimize a pair of SET instructions in which the second insn
+;; is the reverse of the first one.  I.e.
+;;
+;; A = B
+;;        ---->  A = B
+;; B = A
+;;
+;; The second insn is redundant.  Define two patterns, one for QI, one for HI.
+;; But don't do this if either is a VOLATILE MEM.
+(define_peephole2
+  [(set (match_operand:HI 0 "nonimmediate_operand" "")
+        (match_operand:HI 1 "nonimmediate_operand" ""))
+  (set (match_dup 1) (match_dup 0))]
+  "!MEM_P (operands[0]) || !MEM_P (operands[1]) || (!MEM_VOLATILE_P (operands[0]) && !MEM_VOLATILE_P (operands[1]))"
+  [(set (match_dup 0) (match_dup 1))]
+  "")
+
+(define_peephole2
+  [(set (match_operand:QI 0 "nonimmediate_operand" "")
+        (match_operand:QI 1 "nonimmediate_operand" ""))
+  (set (match_dup 1) (match_dup 0))]
+  "!MEM_P (operands[0]) || !MEM_P (operands[1]) || (!MEM_VOLATILE_P (operands[0]) && !MEM_VOLATILE_P (operands[1]))"
+  [(set (match_dup 0) (match_dup 1))]
+  "")
+
+
+;;
+;; Optimize the sum of an 8-bit and 16-bit using the 'abx' instruction
+;; if B and X can be used.  Two patterns are provided to catch both
+;; X=X+D and X=D+X.
+;;
+(define_peephole
+  [(set (reg:HI HARD_D_REGNUM)
+    (zero_extend:HI (match_operand:QI 0 "general_operand" "q")))
+   (set (reg:HI HARD_X_REGNUM)
+    (plus:HI (reg:HI HARD_D_REGNUM) (reg:HI HARD_X_REGNUM)))]
+  "m6809_match_peephole2 (PEEP_ABX, PEEP_END)"
+  "abx"
+  [(set_attr "length" "1")])
+
+(define_peephole
+  [(set (reg:HI HARD_D_REGNUM)
+    (zero_extend:HI (match_operand:QI 0 "general_operand" "q")))
+   (set (reg:HI HARD_X_REGNUM)
+    (plus:HI (reg:HI HARD_X_REGNUM) (reg:HI HARD_D_REGNUM)))]
+  "m6809_match_peephole2 (PEEP_ABX, PEEP_END)"
+  "abx"
+  [(set_attr "length" "1")])
+
+;;; Likewise, handle when B is scaled by 2 prior to the add.
+;;; Instead of shifting B in 4 cycles, just do the ABX a second
+;;; time, in only 3 cycles.
+
+(define_peephole
+  [(set (reg:HI HARD_D_REGNUM)
+    (zero_extend:HI (match_operand:QI 0 "general_operand" "q")))
+   (set (reg:HI HARD_D_REGNUM)
+    (ashift:HI (reg:HI HARD_D_REGNUM) (const_int 1)))
+   (set (reg:HI HARD_X_REGNUM)
+    (plus:HI (reg:HI HARD_D_REGNUM) (reg:HI HARD_X_REGNUM)))]
+  "m6809_match_peephole2 (PEEP_ABX2, PEEP_END)"
+  "abx\;abx"
+  [(set_attr "length" "2")])
+
+(define_peephole
+  [(set (reg:HI HARD_D_REGNUM)
+    (zero_extend:HI (match_operand:QI 0 "general_operand" "q")))
+   (set (reg:HI HARD_D_REGNUM)
+    (ashift:HI (reg:HI HARD_D_REGNUM) (const_int 1)))
+   (set (reg:HI HARD_X_REGNUM)
+    (plus:HI (reg:HI HARD_X_REGNUM) (reg:HI HARD_D_REGNUM)))]
+  "m6809_match_peephole2 (PEEP_ABX2, PEEP_END)"
+  "abx\;abx"
+  [(set_attr "length" "2")])
+
+
+;;
+;; Work around a compiler bug that generates bad code when copying
+;; between 32-bit memory addresses after a libcall.  The problem seen is
+;; that the source is MEM (REG X), but X is used as the reload register.
+;; The second half of the copy therefore fails.
+;;
+;; The solution is to switch the reload register to D, since that is guaranteed
+;; not to be in use right after a libcall.
+;;
+(define_peephole2
+  [(set (reg:HI HARD_X_REGNUM) (mem:HI (reg:HI HARD_X_REGNUM)))
+   (set (match_operand:HI 0 "nonimmediate_operand" "") (reg:HI HARD_X_REGNUM))
+   (set (reg:HI HARD_X_REGNUM)
+      (mem:HI (plus:HI (reg:HI HARD_X_REGNUM) (const_int 2))))
+   (set (match_operand:HI 1 "nonimmediate_operand" "") (reg:HI HARD_X_REGNUM))]
+  "reload_completed"
+  [(set (reg:HI HARD_D_REGNUM) (mem:HI (reg:HI HARD_X_REGNUM)))
+   (set (match_dup 0) (reg:HI HARD_D_REGNUM))
+   (set (reg:HI HARD_X_REGNUM)
+      (mem:HI (plus:HI (reg:HI HARD_X_REGNUM) (const_int 2))))
+   (set (match_dup 1) (reg:HI HARD_X_REGNUM))]
+  "")
+
+
+;; Turn "and then test" into a "bit test" operation.
+;; Provide variants for immediate and memory sources
+;; This is the most used peephople.
+; (define_peephole
+;   [(set (match_operand:QI 0 "register_operand" "=q")
+;     (and:QI (match_operand:QI 1 "register_operand" "0")
+;       (match_operand:QI 2 "immediate_operand" "i")))
+;    (set (cc0) (match_dup 0))]
+;   ""
+;   "bit%0\t%2"
+;   [(set_attr "length" "3")])
+; 
+; (define_peephole
+;   [(set (match_operand:QI 0 "register_operand" "=q")
+;     (and:QI (match_operand:QI 1 "register_operand" "0")
+;       (match_operand:QI 2 "memory_operand" "m")))
+;    (set (cc0) (match_dup 0))]
+;   ""
+;   "bit%0\t%2"
+;   [(set_attr "length" "4")])
+
+
+;; Turn a "decrement, then test" sequence into just a "decrement".
+;; The test can be omitted, since it is implicitly done.
+(define_peephole2
+  [(set (match_operand:QI 0 "nonimmediate_operand" "")
+    (plus:QI (match_operand:QI 1 "whole_general_operand" "")
+    (match_operand:QI 2 "immediate_operand" "")))
+   (set (cc0) (match_dup 0))]
+  "m6809_match_peephole2 (PEEP_DEC_IMPLIES_CC, PEEP_END)"
+  [(set (match_dup 0) (plus:QI (match_dup 1) (match_dup 2)))]
+  "")
+
+
+;; Merge an indexed register increment with a previous usage.
+;; This is usually done automatically, but not always
+;; The 'use' should be optional; in all cases where this has been
+;; seen, it is required though.
+(define_peephole2
+  [(set (match_operand:QI 0 "register_operand" "")
+     (mem:QI (match_operand:HI 1 "index_register_operand" "")))
+   (use (match_dup 0))
+   (set (match_dup 1) (plus:HI (match_dup 1) (const_int 1)))]
+  "m6809_match_peephole2 (PEEP_INDEXED_INC, PEEP_END)"
+  [(set (match_dup 0) (mem:QI (post_inc:HI (match_dup 1))))
+   (use (match_dup 0))]
+  "")
+
+
+;;; Merge "ldX MEM; ldX ,X" into a single instruction using
+;;; the indirect mode.
+(define_peephole2
+  [(set (reg:HI HARD_X_REGNUM)
+    (mem:HI (match_operand:HI 0 "general_operand" "")))
+   (set (reg:HI HARD_X_REGNUM) (mem:HI (reg:HI HARD_X_REGNUM)))]
+  "reload_completed && m6809_match_peephole2 (PEEP_LDX_INDIRECT, PEEP_END)"
+  [(set (reg:HI HARD_X_REGNUM)
+    (mem:HI (mem:HI (match_dup 0))))]
+  "")
+
+
+;;; Reorder a store followed by a unary operation on that memory
+;;; so that the unary is performed and then the store.  Consider
+;;; a binary shift operation, which will be decomposed into
+;;; identical single shifts, also.
+;;; TODO - recognize more than just 'ashift' here.
+(define_peephole2
+  [(set (match_operand:QI 0 "memory_operand" "")
+        (match_operand:QI 1 "register_operand" ""))
+   (set (match_dup 0)
+        (ashift:QI (match_dup 0) (match_operand:QI 2 "immediate_operand")))]
+  "reload_completed"
+  [(set (match_dup 1)
+        (ashift:QI (match_dup 1) (match_operand:QI 2 "immediate_operand")))
+   (set (match_dup 0) (match_dup 1))]
+  "")
+
+;;; Likewise, reorder a unary MEM followed by a load, so that the load
+;;; is done first, then use the REG instead of the MEM.
+;;;(define_peephole2
+;;;  [(set (match_dup 0)
+;;;        (ashift:QI (match_dup 0) (match_operand:QI 2 "immediate_operand")))
+;;;   (set (match_operand:QI 0 "register_operand" "")
+;;;        (match_operand:QI 1 "memory_operand" ""))]
+;;;  "reload_completed"
+;;;  [(set (match_dup 0) (match_dup 1))
+;;;   (set (match_dup 0)
+;;;        (ashift:QI (match_dup 0) (match_operand:QI 2 "immediate_operand")))]
+;;;  "")
+
+
+;;; Replace sex; leaX d,Y with leaX b,Y.
+;;;
+(define_peephole2
+  [(set (reg:HI HARD_D_REGNUM) (sign_extend:HI (reg:QI HARD_D_REGNUM)))
+   (set (match_operand:HI 0 "index_register_operand" "")
+        (plus:HI (match_operand:HI 1 "index_register_operand" "")
+                 (reg:HI HARD_D_REGNUM)))]
+  "reload_completed && m6809_match_peephole2 (PEEP_LEAB, PEEP_END)"
+  [(set (match_dup 0)
+        (plus:HI (match_dup 1) (reg:QI HARD_D_REGNUM)))]
+  "")
+
+(define_peephole2
+  [(set (reg:HI HARD_D_REGNUM) (sign_extend:HI (reg:QI HARD_D_REGNUM)))
+   (set (match_operand:HI 0 "index_register_operand" "")
+        (plus:HI (reg:HI HARD_D_REGNUM)
+          (match_operand:HI 1 "index_register_operand" "")))]
+  "reload_completed && m6809_match_peephole2 (PEEP_LEAB, PEEP_END)"
+  [(set (match_dup 0)
+        (plus:HI (match_dup 1) (reg:QI HARD_D_REGNUM)))]
+  "")
+
+
+;;; Replace ldb; decb; stb; tstb with dec(mem).  If the
+;;; register is not needed, then the load will get deleted
+;;; automatically, but it may be needed for comparisons.
+;;; Same for incb/inc.
+(define_peephole2
+  [(set (match_operand:QI 0 "register_operand" "")
+        (match_operand:QI 1 "nonimmediate_operand" ""))
+   (set (match_dup 0) (plus:QI (match_dup 0) (const_int -1)))
+   (set (match_dup 1) (match_dup 0))
+   (set (cc0) (match_dup 0))]
+  "m6809_match_peephole2 (PEEP_MEM_DEC_CMP, PEEP_END)"
+  [(set (match_dup 1) (plus:QI (match_dup 1) (const_int -1)))]
+  "")
+
+
+;;; Replace ldb; decb; stb with dec(mem); ldb.  If the
+;;; register is not needed, then the load will get deleted
+;;; automatically, but it may be needed for comparisons.
+;;; Same for incb/inc.
+(define_peephole2
+  [(set (match_operand:QI 0 "register_operand" "")
+        (match_operand:QI 1 "nonimmediate_operand" ""))
+   (set (match_dup 0) (plus:QI (match_dup 0) (const_int -1)))
+   (set (match_dup 1) (match_dup 0))]
+  "m6809_match_peephole2 (PEEP_MEM_DEC, PEEP_END)"
+  [(set (match_dup 1) (plus:QI (match_dup 1) (const_int -1)))
+   (set (match_dup 0) (match_dup 1))]
+  "")
+
+(define_peephole2
+  [(set (match_operand:QI 0 "register_operand" "")
+        (match_operand:QI 1 "nonimmediate_operand" ""))
+   (set (match_dup 0) (plus:QI (match_dup 0) (const_int 1)))
+   (set (match_dup 1) (match_dup 0))]
+  "m6809_match_peephole2 (PEEP_MEM_INC, PEEP_END)"
+  [(set (match_dup 1) (plus:QI (match_dup 1) (const_int 1)))
+   (set (match_dup 0) (match_dup 1))]
+  "")
+
+
+;;; Replace "andb #N; cmpb #N; bhi" with "andb #N", if it can be proven
+;;; that the branch can never occur because of the limited range of B.
+;;; N must be a power of two for this to make sense.  This helps with
+;;; the default cases of switch statements on a value (x & N).
+(define_peephole2
+  [(set (match_operand:QI 0 "register_operand" "")
+    (and:QI (match_dup 0) (match_operand:QI 1 "immediate_operand" "")))
+   (set (cc0)
+    (compare (match_dup 0) (match_dup 1)))
+   (set (pc) (if_then_else (gtu (cc0) (const_int 0)) (match_operand 2 "" "") (match_operand 3 "" "")))
+   ]
+  "reload_completed && power_of_two_p (INTVAL (operands[1]) + 1)"
+  [(set (match_dup 0) (and:QI (match_dup 0) (match_dup 1)))]
+  "")
+
+;;; Replace ldd <mem>; addd #1; std <mem> with 16-bit increment
+;;; of the mem, but only if D is dead.  Same for 16-bit decrement.
+;;; <mem> must be offsettable for the instruction to match.
+(define_peephole2
+  [(set (match_operand:HI 0 "register_operand" "") (match_operand:HI 1 "memory_operand" ""))
+   (set (match_dup 0) (plus:HI (match_dup 0) (const_int 1)))
+   (set (match_dup 1) (match_dup 0))]
+   "reload_completed
+    && GET_CODE (XEXP (operands[1], 0)) == SYMBOL_REF
+    && peep2_reg_dead_p (3, operands[0])"
+  [(set (match_dup 1) (plus:HI (match_dup 1) (const_int 1)))]
+  "")
+
+(define_peephole2
+  [(set (match_operand:HI 0 "register_operand" "") (match_operand:HI 1 "memory_operand" ""))
+   (set (match_dup 0) (plus:HI (match_dup 0) (const_int -1)))
+   (set (match_dup 1) (match_dup 0))]
+   "reload_completed
+    && GET_CODE (XEXP (operands[1], 0)) == SYMBOL_REF
+    && peep2_reg_dead_p (3, operands[0])"
+  [(set (match_dup 1) (plus:HI (match_dup 1) (const_int -1)))]
+  "")
+
+
+;;; Replace a load or store using an indexed register, followed by an increment of that
+;;; register, with the combined form using autoincrement.
+(define_peephole2
+  [(set (match_operand:QI 0 "register_operand" "")
+        (mem:QI (match_operand:HI 1 "index_register_operand" "")))
+   (set (match_dup 1) (plus:HI (match_dup 1) (const_int 1)))]
+   "reload_completed"
+  [(set (match_dup 0) (mem:QI (post_inc (match_dup 1))))]
+  "")
+
+
+;;- mode:emacs-lisp
+;;- comment-start: ";;- "
+;;- eval: (set-syntax-table (copy-sequence (syntax-table)))
+;;- eval: (modify-syntax-entry ?[ "(]")
+;;- eval: (modify-syntax-entry ?] ")[")
+;;- eval: (modify-syntax-entry ?{ "(}")
+;;- eval: (modify-syntax-entry ?} "){")
+;-; vim: set ts=2:
+;-; vim: set expandtab:
+;-; vim: set filetype=lisp:
+;;- End:
diff -urN gcc-4.6.4-clean/gcc/config/m6809/m6809.opt gcc-4.6.4/gcc/config/m6809/m6809.opt
--- gcc-4.6.4-clean/gcc/config/m6809/m6809.opt	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/m6809.opt	2017-11-28 21:12:11.156911596 -0700
@@ -0,0 +1,98 @@
+; Options for the M6809 port of the compiler
+;
+; Copyright (C) 2005 Free Software Foundation, Inc.
+;
+; This file is part of GCC.
+;
+; GCC is free software; you can redistribute it and/or modify it under
+; the terms of the GNU General Public License as published by the Free
+; Software Foundation; either version 2, or (at your option) any later
+; version.
+;
+; GCC is distributed in the hope that it will be useful, but WITHOUT
+; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
+; License for more details.
+;
+; You should have received a copy of the GNU General Public License
+; along with GCC; see the file COPYING.  If not, write to the Free
+; Software Foundation, 51 Franklin Street, Fifth Floor, Boston, MA
+; 02110-1301, USA.
+
+margcount
+Target Mask(ARGCOUNT)
+Push argument count
+
+mint8
+Target RejectNegative Mask(BYTE_INT)
+Use 8-bit integers
+
+mint16
+Target RejectNegative
+Use 16-bit integers InverseMask(BYTE_INT)
+
+mreg-args
+Target Mask(REG_ARGS)
+Use registers for function arguments
+
+mshort_size 
+Target RejectNegative Mask(SMALL_SIZE_T)
+Use 8-bit size_t
+
+mlong_size
+Target RejectNegative InverseMask(SMALL_SIZE_T)
+Use 16-bit size_t
+
+mdirect
+Target Mask(DIRECT)
+Enable direct addressing
+
+mwpc
+Target RejectNegative Mask(WPC)
+Enable WPC platform extensions
+
+mexperiment
+Target RejectNegative Mask(EXPERIMENT)
+Enable current experimental feature
+
+m6309
+Target RejectNegative Mask(6309)
+Enable Hitachi 6309 extensions
+
+mcasesi
+Target RejectNegative Mask(CASESI)
+Enable the casesi pattern
+
+mfar-code-page=
+Target RejectNegative Joined Var(far_code_page_option)
+Sets the far code page value for this compilation unit
+
+mcode-section=
+Target RejectNegative Joined Var(code_section_ptr)
+Sets the name of the section for code
+
+mdata-section=
+Target RejectNegative Joined Var(data_section_ptr)
+Sets the name of the section for initialized data
+
+mbss-section=
+Target RejectNegative Joined Var(bss_section_ptr)
+Sets the name of the section for uninitialized data
+
+mabi_version=
+Target RejectNegative Joined Var(m6809_abi_version_ptr)
+Sets the calling convention
+
+msoft-reg-count=
+Target RejectNegative Joined Var(m6809_soft_reg_count)
+Sets the number of soft registers that can be used
+
+mdret
+Target RejectNegative Mask(DRET)
+Put function call results in D, not X
+
+mfar-stack-param
+Target Mask(FAR_STACK_PARAM)
+Enable stack parameters to a farcall
+
+
diff -urN gcc-4.6.4-clean/gcc/config/m6809/m6809-protos.h gcc-4.6.4/gcc/config/m6809/m6809-protos.h
--- gcc-4.6.4-clean/gcc/config/m6809/m6809-protos.h	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/m6809-protos.h	2017-11-28 21:12:11.156911596 -0700
@@ -0,0 +1,94 @@
+/* GCC for 6809 : machine-specific function prototypes
+
+This file is part of GCC.
+
+GCC is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 3, or (at your option)
+any later version.
+
+GCC is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with GCC; see the file COPYING3.  If not see
+<http://www.gnu.org/licenses/>.  */
+
+#ifndef __M6809_PROTOS_H__
+#define __M6809_PROTOS_H__
+
+void 					print_options (FILE *file);
+void 					m6809_cpu_cpp_builtins (void);
+void 					m6809_override_options (void);
+void 					m6809_init_builtins (void);
+unsigned int 		m6809_get_live_regs (void);
+const char * 		m6809_get_regs_printable (unsigned int regs);
+unsigned int 		m6809_get_regs_size (unsigned int regs);
+int 					m6809_function_has_type_attr_p (tree decl, const char *);
+int 					m6809_current_function_has_type_attr_p (const char *);
+int 					prologue_epilogue_required (void);
+int 					noreturn_functionp (rtx x);
+void 					output_function_prologue (FILE *file, int size);
+void 					output_function_epilogue (FILE *file, int size);
+int 					check_float_value (enum machine_mode mode, double *d, int overflow);
+void 					m6809_asm_named_section (const char *name, unsigned int flags, tree decl);
+void 					m6809_asm_file_start (void);
+void              m6809_output_ascii (FILE *fp, const char *str, unsigned long size);
+void              m6809_declare_function_name (FILE *asm_out_file, const char *name, tree decl);
+void              m6809_reorg (void);
+int               m6809_current_function_is_void (void);
+int               m6809_can_merge_pushpop_p (int op, int regs1, int regs2);
+int               m6809_function_value_regno_p (unsigned int regno);
+void              emit_prologue_insns (void);
+void              emit_epilogue_insns (bool);
+void              m6809_conditional_register_usage (void);
+void              m6809_output_quoted_string (FILE *asm_file, const char *string);
+int               m6809_match_peephole2 (unsigned int peephole_id, unsigned int stage);
+int               m6809_hard_regno_mode_ok (unsigned int regno, enum machine_mode mode);
+int               power_of_two_p (unsigned int n);
+void              m6809_do_casesi (rtx index, rtx lower_bound, rtx range, rtx table_label, rtx default_label);
+void              m6809_output_addsi3 (int rtx_code, rtx *operands);
+rtx               m6809_function_arg_on_stack (CUMULATIVE_ARGS *cump);
+void              expand_constant_shift (int code, rtx dst, rtx src, rtx count);
+int               m6809_single_operand_operator (rtx exp);
+
+#ifdef TREE_CODE
+int m6809_init_cumulative_args (CUMULATIVE_ARGS cum, tree fntype, rtx libname);
+#endif /* TREE_CODE */
+
+#ifdef RTX_CODE
+void 					print_direct_prefix (FILE *file, rtx addr);
+void 					print_operand (FILE *file, rtx x, int code);
+void 					print_operand_address (FILE *file, rtx addr);
+void 					notice_update_cc (rtx exp, rtx insn);
+enum 					reg_class m6809_preferred_reload_class (rtx x, enum reg_class regclass);
+rtx 					gen_rtx_const_high (rtx r);
+rtx 					gen_rtx_const_low (rtx r);
+rtx 					gen_rtx_register_pushpop (int pop_flag, int regs);
+void 					emit_libcall_insns (enum machine_mode mode, const char *name, rtx *operands, int count);
+const char *		output_branch_insn (enum rtx_code code, rtx *operands, int length);
+void 					output_far_call_insn (rtx *operands, int has_return);
+void 					m6809_initialize_trampoline (rtx tramp, tree fndecl, rtx cxt);
+rtx 					m6809_expand_builtin (tree exp, rtx target, rtx subtarget, enum machine_mode mode, int ignore);
+const char *      far_functionp (rtx x);
+rtx               m6809_function_value (const tree valtype, const tree func);
+void              m6809_output_shift_insn (int rtx_code, rtx *operands);
+
+const char * m6809_get_decl_bank (tree decl);
+void output_branch_insn1 (const char *opcode, rtx *operands, int long_p);
+rtx m6809_builtin_operand (tree arglist, enum machine_mode mode, int opnum);
+const char * far_function_type_p (tree type);
+void m6809_asm_trampoline_template(FILE *f);
+bool m6809_frame_pointer_required (void);
+int m6809_can_eliminate (int from, int to);
+int m6809_initial_elimination_offset (int from, int to);
+void m6809_emit_move_insn (rtx dst, rtx src);
+void m6809_split_shift (enum rtx_code code, rtx *operands);
+bool m6809_function_ok_for_sibcall (tree decl, tree exp ATTRIBUTE_UNUSED);
+
+
+#endif /* RTX_CODE */
+
+#endif /* __M6809_PROTOS_H__ */
diff -urN gcc-4.6.4-clean/gcc/config/m6809/predicates.md gcc-4.6.4/gcc/config/m6809/predicates.md
--- gcc-4.6.4-clean/gcc/config/m6809/predicates.md	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/predicates.md	2017-11-28 21:12:11.156911596 -0700
@@ -0,0 +1,78 @@
+;; Predicate definitions for Motorola 6809
+;; Copyright (C) 2006, 2007, 2008, 2009 Free Software Foundation, Inc.
+;;
+;; This file is part of GCC.
+;;
+;; GCC is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 3, or (at your option)
+;; any later version.
+;;
+;; GCC is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with GCC; see the file COPYING3.  If not see
+;; <http://www.gnu.org/licenses/>.
+
+;; whole_register_operand is like register_operand, but it
+;; does not allow SUBREGs.
+(define_predicate "whole_register_operand"
+  (and (match_code "reg")
+       (match_operand 0 "register_operand")))
+
+
+;; A predicate that matches any index register.  This can be used in nameless
+;; patterns and peepholes which need a 16-bit reg, but not D.
+(define_predicate "index_register_operand"
+  (and (match_code "reg")
+       (match_test "REGNO (op) == HARD_X_REGNUM || REGNO (op) == HARD_Y_REGNUM || REGNO (op) == HARD_U_REGNUM")))
+
+
+;; match only X
+(define_predicate "register_operand_x"
+  (and (match_code "reg")
+       (match_test "REGNO (op) == HARD_X_REGNUM")))
+
+;; match only D
+(define_predicate "register_operand_d"
+  (and (match_code "reg")
+       (match_test "REGNO (op) == HARD_D_REGNUM")))
+
+
+;; Likwise, a replacement for general_operand which excludes
+;; SUBREGs.
+(define_predicate "whole_general_operand"
+  (and (match_code "const_int,const_double,const,symbol_ref,label_ref,reg,mem")
+       (match_operand 0 "general_operand")))
+
+
+(define_predicate "add_general_operand"
+  (and (match_code "const_int,const_double,const,symbol_ref,label_ref,reg,mem")
+       (match_operand 0 "general_operand")
+		 (match_test "REGNO (op) != SOFT_AP_REGNUM")))
+
+
+(define_predicate "shift_count_operand"
+  (and (match_code "const_int")
+     (and (match_operand 0 "const_int_operand")
+       (match_test "INTVAL (op) == 1 || INTVAL (op) == 8"))))
+
+
+;; A predicate that matches any bitwise logical operator.  This
+;; allows for a single RTL pattern to be used for multiple operations.
+(define_predicate "logical_bit_operator"
+	(ior (match_code "and") (match_code "ior") (match_code "xor")))
+
+
+;; A predicate that matches any shift or rotate operator.  This
+;; allows for a single RTL pattern to be used for multiple operations.
+(define_predicate "shift_rotate_operator"
+	(ior (match_code "ashift") (match_code "ashiftrt") (match_code "lshiftrt")
+	     (match_code "rotate") (match_code "rotatert")))
+
+
+(define_predicate "symbolic_operand" (match_code "symbol_ref"))
+
diff -urN gcc-4.6.4-clean/gcc/config/m6809/t-coco gcc-4.6.4/gcc/config/m6809/t-coco
--- gcc-4.6.4-clean/gcc/config/m6809/t-coco	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/t-coco	2017-11-29 17:11:09.221248469 -0700
@@ -0,0 +1,6 @@
+# For a few minor differences in code generation on the CoCo...
+T_CFLAGS = -DTARGET_COCO
+
+# For doing the startup differently on the CoCo...
+CRT0STUFF_T_CFLAGS += -DTARGET_COCO
+# vim: set filetype=make:
diff -urN gcc-4.6.4-clean/gcc/config/m6809/t-m6809 gcc-4.6.4/gcc/config/m6809/t-m6809
--- gcc-4.6.4-clean/gcc/config/m6809/t-m6809	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/t-m6809	2017-11-28 21:12:11.156911596 -0700
@@ -0,0 +1,64 @@
+
+# ranlib doesn't exist, so define it to 'true' to make it a no-op
+RANLIB_FOR_TARGET = true
+
+# Stubs for libgcc defined by m6809 are here
+LIB1ASMSRC = m6809/libgcc1.s
+
+# Here are the functions that are implemented within libgcc1.s
+LIB1ASMFUNCS = _mulhi3 _divhi3 _modhi3 _udivhi3 _umodhi3 \
+	_euclid _seuclid _clzsi2 _clzdi2 _ctzsi2 _ctzdi2 _softregs \
+	_ashlhi3 _ashrhi3 _lshrhi3
+
+# Flags to use when building libgcc.  IN_GCC does not seem necessary,
+# although the compile breaks without it.  -DDF=SF is required to set
+# the size of "double" to the same as the size of a "float".
+TARGET_LIBGCC2_CFLAGS =-DIN_GCC -Dinhibit_libc -DDF=SF -DLIBGCC2_HAS_SF_MODE=0 -DLIBGCC2_HAS_DF_MODE=0
+
+LIB2ADDEH =
+LIB2ADDEHSTATIC =
+LIB2ADDEHSHARED =
+
+LIBGCC2_DEBUG_CFLAGS =
+LIBGCC2_CFLAGS = -Os $(LIBGCC2_INCLUDES) $(TARGET_LIBGCC2_CFLAGS) $(LIBGCC2_DEBUG_CFLAGS) $(GTHREAD_FLAGS) -DIN_LIBGCC2
+
+# Multilib information
+# This creates multiple versions of libgcc.a for each set of incompatible
+# -mxxx options.
+MULTILIB_OPTIONS  = fpic mdret
+MULTILIB_DIRNAMES =
+MULTILIB_MATCHES  =
+MULTILIB_EXCEPTIONS =
+EXTRA_MULTILIB_PARTS = crt0.o
+
+LIBGCC = stmp-multilib
+INSTALL_LIBGCC = install-multilib
+
+# We want fine grained libraries, so use the new code to build the
+# floating point emulation libraries.
+FPBIT = fp-bit.c
+
+fp-bit.c: $(srcdir)/config/fp-bit.c
+	echo '#define FLOAT' > fp-bit.c
+	echo '#define FLOAT_ONLY' >> fp-bit.c
+	echo '#define CMPtype HItype' >> fp-bit.c
+	echo '#define SMALL_MACHINE' >> fp-bit.c
+	echo '#ifdef __LITTLE_ENDIAN__' >> fp-bit.c
+	echo '#define FLOAT_BIT_ORDER_MISMATCH' >>fp-bit.c
+	echo '#endif' 		>> fp-bit.c
+	echo '#define DI SI'	>> fp-bit.c
+	cat $(srcdir)/config/fp-bit.c >> fp-bit.c
+
+# crt0.o is built from the following source file
+CRT0_S = $(srcdir)/config/m6809/crt0.S
+MCRT0_S = $(srcdir)/config/m6809/crt0.S
+
+# Flags to use when building crt0.o
+CRT0STUFF_T_CFLAGS += -fno-builtin -nostartfiles -nostdlib
+
+# Assemble startup files.
+$(T)crt0.o: $(CRT0_S) $(GCC_PASSES)
+	$(GCC_FOR_TARGET) $(CRT0STUFF_T_CFLAGS) $(MULTILIB_CFLAGS) -c -o $(T)crt0.o -x assembler-with-cpp $(CRT0_S)
+
+$(T)mcrt0.o: $(MCRT0_S) $(GCC_PASSES)
+	$(GCC_FOR_TARGET) $(CRT0STUFF_T_CFLAGS) $(MULTILIB_CFLAGS) -c -o $(T)mcrt0.o -x assembler-with-cpp $(MCRT0_S)
diff -urN gcc-4.6.4-clean/gcc/config/m6809/t-proto gcc-4.6.4/gcc/config/m6809/t-proto
--- gcc-4.6.4-clean/gcc/config/m6809/t-proto	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/t-proto	2017-11-29 17:11:09.221248469 -0700
@@ -0,0 +1,6 @@
+# For a few minor differences in code generation on a custom prototype.
+T_CFLAGS = -DTARGET_PROTO
+
+# For doing the startup differently on a custom prototype.
+CRT0STUFF_T_CFLAGS += -DTARGET_PROTO
+# vim: set filetype=make:
diff -urN gcc-4.6.4-clean/gcc/config/m6809/t-sim gcc-4.6.4/gcc/config/m6809/t-sim
--- gcc-4.6.4-clean/gcc/config/m6809/t-sim	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/gcc/config/m6809/t-sim	2017-11-28 21:12:11.156911596 -0700
@@ -0,0 +1 @@
+CRT0STUFF_T_CFLAGS += -DTARGET_SIM
diff -urN gcc-4.6.4-clean/gcc/config.gcc gcc-4.6.4/gcc/config.gcc
--- gcc-4.6.4-clean/gcc/config.gcc	2013-03-06 10:40:07.000000000 -0700
+++ gcc-4.6.4/gcc/config.gcc	2017-11-29 17:11:09.229248437 -0700
@@ -375,6 +375,9 @@
         cpu_type=m32r
 	extra_options="${extra_options} g.opt"
         ;;
+m6809-*-*)
+        cpu_type=m6809
+        ;;
 m68k-*-*)
 	extra_headers=math-68881.h
 	;;
@@ -1706,6 +1709,15 @@
 		thread_file='posix'
 	fi
 	;;
+m6809-coco-*)
+	tmake_file="${tmake_file} m6809/t-m6809 m6809/t-coco"
+	;;
+m6809-proto-*)
+	tmake_file="${tmake_file} m6809/t-m6809 m6809/t-proto"
+	;;
+m6809-*-*)
+	tmake_file="${tmake_file} m6809/t-m6809 m6809/t-sim"
+	;;
 # m68hc11 and m68hc12 share the same machine description.
 m68hc11-*-*|m6811-*-*)
 	tm_file="dbxelf.h elfos.h usegas.h newlib-stdint.h m68hc11/m68hc11.h"
diff -urN gcc-4.6.4-clean/gcc/gcse.c gcc-4.6.4/gcc/gcse.c
--- gcc-4.6.4-clean/gcc/gcse.c	2011-02-02 23:04:04.000000000 -0700
+++ gcc-4.6.4/gcc/gcse.c	2017-11-28 21:12:11.156911596 -0700
@@ -833,7 +833,6 @@
 	      max_distance = (GCSE_COST_DISTANCE_RATIO * cost) / 10;
 	      if (max_distance == 0)
 		return 0;
-
 	      gcc_assert (max_distance > 0);
 	    }
 	  else
diff -urN gcc-4.6.4-clean/gcc/libgcc2.c gcc-4.6.4/gcc/libgcc2.c
--- gcc-4.6.4-clean/gcc/libgcc2.c	2011-01-03 13:52:22.000000000 -0700
+++ gcc-4.6.4/gcc/libgcc2.c	2017-11-28 21:12:11.156911596 -0700
@@ -485,6 +485,7 @@
 #endif
 
 #ifdef L_bswapsi2
+#if MIN_UNITS_PER_WORD > 1
 SItype
 __bswapsi2 (SItype u)
 {
@@ -494,7 +495,9 @@
 	  | (((u) & 0x000000ff) << 24));
 }
 #endif
+#endif
 #ifdef L_bswapdi2
+#if LONG_LONG_TYPE_SIZE > 32
 DItype
 __bswapdi2 (DItype u)
 {
@@ -508,6 +511,7 @@
 	  | (((u) & 0x00000000000000ffull) << 56));
 }
 #endif
+#endif
 #ifdef L_ffssi2
 #undef int
 int
@@ -1280,7 +1284,7 @@
 UDWtype
 __fixunssfDI (SFtype a)
 {
-#if LIBGCC2_HAS_DF_MODE
+#if LIBGCC2_HAS_DF_MODE || (FLT_MANT_DIG >= W_TYPE_SIZE)
   /* Convert the SFtype to a DFtype, because that is surely not going
      to lose any bits.  Some day someone else can write a faster version
      that avoids converting to DFtype, and verify it really works right.  */
@@ -1298,7 +1302,7 @@
 
   /* Assemble result from the two parts.  */
   return ((UDWtype) hi << W_TYPE_SIZE) | lo;
-#elif FLT_MANT_DIG < W_TYPE_SIZE
+#else
   if (a < 1)
     return 0;
   if (a < Wtype_MAXp1_F)
@@ -1334,8 +1338,6 @@
       return (DWtype)counter << shift;
     }
   return -1;
-#else
-# error
 #endif
 }
 #endif
diff -urN gcc-4.6.4-clean/gcc/longlong.h gcc-4.6.4/gcc/longlong.h
--- gcc-4.6.4-clean/gcc/longlong.h	2011-10-04 01:28:50.000000000 -0600
+++ gcc-4.6.4/gcc/longlong.h	2017-11-28 21:12:11.160911575 -0700
@@ -528,6 +528,11 @@
 	   : "cbit")
 #endif /* __M32R__ */
 
+#if defined (__m6309__) || defined (__m6809__)
+#define count_leading_zeros(COUNT,X)	((COUNT) = __builtin_clz (X))
+#define count_trailing_zeros(COUNT,X)	((COUNT) = __builtin_ctz (X))
+#endif
+
 #if defined (__mc68000__) && W_TYPE_SIZE == 32
 #define add_ssaaaa(sh, sl, ah, al, bh, bl) \
   __asm__ ("add%.l %5,%1\n\taddx%.l %3,%0"				\
diff -urN gcc-4.6.4-clean/gcc/Makefile.in gcc-4.6.4/gcc/Makefile.in
--- gcc-4.6.4-clean/gcc/Makefile.in	2013-04-01 02:32:34.000000000 -0600
+++ gcc-4.6.4/gcc/Makefile.in	2017-11-28 21:12:11.160911575 -0700
@@ -2003,14 +2003,14 @@
 
 # Compile the start modules crt0.o and mcrt0.o that are linked with
 # every program
-$(T)crt0.o: s-crt0 ; @true
-$(T)mcrt0.o: s-crt0; @true
+crt0.o: s-crt0 ; @true
+mcrt0.o: s-crt0; @true
 
 s-crt0:	$(CRT0_S) $(MCRT0_S) $(GCC_PASSES) $(CONFIG_H)
 	$(GCC_FOR_TARGET) $(GCC_CFLAGS) $(CRT0STUFF_T_CFLAGS) \
-	  -o $(T)crt0.o -c $(CRT0_S)
+	  -o crt0.o -c $(CRT0_S)
 	$(GCC_FOR_TARGET) $(GCC_CFLAGS) $(CRT0STUFF_T_CFLAGS) \
-	  -o $(T)mcrt0.o -c $(MCRT0_S)
+	  -o mcrt0.o -c $(MCRT0_S)
 	$(STAMP) s-crt0
 #
 # Compiling object files from source files.
diff -urN gcc-4.6.4-clean/gcc/opth-gen.awk gcc-4.6.4/gcc/opth-gen.awk
--- gcc-4.6.4-clean/gcc/opth-gen.awk	2011-02-08 10:41:00.000000000 -0700
+++ gcc-4.6.4/gcc/opth-gen.awk	2017-11-28 21:12:11.160911575 -0700
@@ -121,7 +121,7 @@
 END {
 print "/* This file is auto-generated by opth-gen.awk.  */"
 print ""
-print "#ifndef OPTIONS_H"
+print "#if !defined(OPTIONS_H) && !defined(IN_LIBGCC2)"
 print "#define OPTIONS_H"
 print ""
 print "#include \"flag-types.h\""
@@ -432,18 +432,9 @@
 
 for (i = 0; i < n_opts; i++) {
 	opt = opt_args("InverseMask", flags[i])
-	if (opt ~ ",") {
-		vname = var_name(flags[i])
-		macro = "OPTION_"
-		mask = "OPTION_MASK_"
-		if (vname == "") {
-			vname = "target_flags"
-			macro = "TARGET_"
-			mask = "MASK_"
-		}
-		print "#define " macro nth_arg(1, opt) \
-		      " ((" vname " & " mask nth_arg(0, opt) ") == 0)"
-	}
+	if (opt ~ ",")
+		print "#define TARGET_" nth_arg(1, opt) \
+		      " ((target_flags & MASK_" nth_arg(0, opt) ") == 0)"
 }
 print ""
 
diff -urN gcc-4.6.4-clean/gcc/tree.h gcc-4.6.4/gcc/tree.h
--- gcc-4.6.4-clean/gcc/tree.h	2011-10-06 13:57:52.000000000 -0600
+++ gcc-4.6.4/gcc/tree.h	2017-11-28 21:12:11.160911575 -0700
@@ -3563,6 +3563,8 @@
   TI_UINTDI_TYPE,
   TI_UINTTI_TYPE,
 
+  TI_UINT8_TYPE,
+  TI_UINT16_TYPE,
   TI_UINT32_TYPE,
   TI_UINT64_TYPE,
 
diff -urN gcc-4.6.4-clean/gcc/version.c gcc-4.6.4/gcc/version.c
--- gcc-4.6.4-clean/gcc/version.c	2009-04-21 13:03:23.000000000 -0600
+++ gcc-4.6.4/gcc/version.c	2017-11-29 17:11:34.133149157 -0700
@@ -21,16 +21,16 @@
 
 /* This is the location of the online document giving instructions for
    reporting bugs.  If you distribute a modified version of GCC,
-   please configure with --with-bugurl pointing to a document giving
-   instructions for reporting bugs to you, not us.  (You are of course
-   welcome to forward us bugs reported to you, if you determine that
-   they are not bugs in your modifications.)  */
+   please change this to refer to a document giving instructions for
+   reporting bugs to you, not us.  (You are of course welcome to
+   forward us bugs reported to you, if you determine that they are
+   not bugs in your modifications.)  */
 
-const char bug_report_url[] = BUGURL;
+const char bug_report_url[] = "<URL:http://lost.l-w.ca/coco/lwtools/>";
 
 /* The complete version string, assembled from several pieces.
    BASEVER, DATESTAMP, DEVPHASE, and REVISION are defined by the
    Makefile.  */
 
-const char version_string[] = BASEVER DATESTAMP DEVPHASE REVISION;
+const char version_string[] = BASEVER DATESTAMP DEVPHASE REVISION " (gcc6809lw pl9)";
 const char pkgversion_string[] = PKGVERSION;
diff -urN gcc-4.6.4-clean/libgcc/config.host gcc-4.6.4/libgcc/config.host
--- gcc-4.6.4-clean/libgcc/config.host	2011-11-23 15:15:54.000000000 -0700
+++ gcc-4.6.4/libgcc/config.host	2017-11-28 21:12:11.160911575 -0700
@@ -371,6 +371,8 @@
  	;;
 m32rle-*-linux*)
 	;;
+m6809*)
+	;;
 m68hc11-*-*|m6811-*-*)
         ;;
 m68hc12-*-*|m6812-*-*)
diff -urN gcc-4.6.4-clean/libgcc/fixed-obj.mk gcc-4.6.4/libgcc/fixed-obj.mk
--- gcc-4.6.4-clean/libgcc/fixed-obj.mk	2007-09-17 16:18:13.000000000 -0600
+++ gcc-4.6.4/libgcc/fixed-obj.mk	2017-11-28 21:12:11.160911575 -0700
@@ -23,7 +23,7 @@
 #$(info $o$(objext): -DL$($o-label) $($o-opt))
 
 $o$(objext): %$(objext): $(gcc_srcdir)/config/fixed-bit.c
-	$(gcc_compile) -DL$($*-label) $($*-opt) -c $(gcc_srcdir)/config/fixed-bit.c $(vis_hide)
+	$(gcc_compile) -DL$($*-label) $($*-opt) -c $(gcc_srcdir)/config/fixed-bit.c $(vis_hide) -save-temps
 
 ifeq ($(enable_shared),yes)
 $(o)_s$(objext): %_s$(objext): $(gcc_srcdir)/config/fixed-bit.c
diff -urN gcc-4.6.4-clean/libgcc/Makefile.in gcc-4.6.4/libgcc/Makefile.in
--- gcc-4.6.4-clean/libgcc/Makefile.in	2012-12-04 12:11:33.000000000 -0700
+++ gcc-4.6.4/libgcc/Makefile.in	2017-11-28 21:12:11.160911575 -0700
@@ -374,8 +374,8 @@
 # Build lib2funcs.  For the static library also include LIB2FUNCS_ST.
 lib2funcs-o = $(patsubst %,%$(objext),$(lib2funcs) $(LIB2FUNCS_ST))
 $(lib2funcs-o): %$(objext): $(gcc_srcdir)/libgcc2.c
-	$(gcc_compile) -DL$* -c $(gcc_srcdir)/libgcc2.c \
-	  $(vis_hide)
+	ln -sf $(gcc_srcdir)/libgcc2.c $*.c && \
+	$(gcc_compile) -DL$* -c $*.c $(vis_hide) -save-temps
 libgcc-objects += $(lib2funcs-o)
 
 ifeq ($(enable_shared),yes)
@@ -410,8 +410,9 @@
 # Build LIB2_DIVMOD_FUNCS.
 lib2-divmod-o = $(patsubst %,%$(objext),$(LIB2_DIVMOD_FUNCS))
 $(lib2-divmod-o): %$(objext): $(gcc_srcdir)/libgcc2.c
-	$(gcc_compile) -DL$* -c $(gcc_srcdir)/libgcc2.c \
-	  -fexceptions -fnon-call-exceptions $(vis_hide)
+	ln -sf $(gcc_srcdir)/libgcc2.c $*.c && \
+	$(gcc_compile) -DL$* -c $*.c \
+	  -fexceptions -fnon-call-exceptions $(vis_hide) -save-temps
 libgcc-objects += $(lib2-divmod-o)
 
 ifeq ($(enable_shared),yes)
@@ -443,7 +444,8 @@
 ifneq ($(FPBIT),)
 fpbit-o = $(patsubst %,%$(objext),$(FPBIT_FUNCS))
 $(fpbit-o): %$(objext): $(FPBIT)
-	$(gcc_compile) -DFINE_GRAINED_LIBRARIES -DL$* -c $(FPBIT) $(vis_hide)
+	ln -sf $(FPBIT) $*.c && \
+	$(gcc_compile) -DFINE_GRAINED_LIBRARIES -DL$* -c $*.c $(vis_hide) -save-temps
 libgcc-objects += $(fpbit-o)
 
 ifeq ($(enable_shared),yes)
@@ -458,7 +460,8 @@
 ifneq ($(DPBIT),)
 dpbit-o = $(patsubst %,%$(objext),$(DPBIT_FUNCS))
 $(dpbit-o): %$(objext): $(DPBIT)
-	$(gcc_compile) -DFINE_GRAINED_LIBRARIES -DL$* -c $(DPBIT) $(vis_hide)
+	ln -sf $(DPBIT) $*.c && \
+	$(gcc_compile) -DFINE_GRAINED_LIBRARIES -DL$* -c $*.c $(vis_hide) -save-temps
 libgcc-objects += $(dpbit-o)
 
 ifeq ($(enable_shared),yes)
diff -urN gcc-4.6.4-clean/README.LW gcc-4.6.4/README.LW
--- gcc-4.6.4-clean/README.LW	1969-12-31 17:00:00.000000000 -0700
+++ gcc-4.6.4/README.LW	2017-11-29 17:11:09.189248596 -0700
@@ -0,0 +1,14 @@
+This is a port of gcc6809 which is designed to work with the lwtools
+cross-assembler and linker package.  You will need several scripts from that
+package, available at http://lost.l-w.ca/coco/lwtools/, in order to use
+this.  Instructions for building are present in the lwtools package.
+
+This work is based extensively on the gcc6809 4.3.4-3 release by Brian
+Dominy (brian@oddchange.com) with some significant renovations to make it
+work with gcc 4.6.4.
+
+There is no guarantee that it will work for any particular purpose you
+choose to put it to.
+
+If you run into any problems, contact William Astle (lost@l-w.ca). DO NOT
+contact the main GCC developers!
