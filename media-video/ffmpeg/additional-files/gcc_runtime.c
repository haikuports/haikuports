// Functions here copied from gcc/libgcc/libgcc2.c unless otherwise noted.

/* Copyright (C) 1989-2018 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

#if __GNUC__ == 2
#define __CHAR_BIT__ 8
#endif

// from gcc/config/i386/i386.h
#define MIN_UNITS_PER_WORD	4


#if MIN_UNITS_PER_WORD > 4
# define LIBGCC2_MAX_UNITS_PER_WORD 8
#elif (MIN_UNITS_PER_WORD > 2 \
       || (MIN_UNITS_PER_WORD > 1 && __SIZEOF_LONG_LONG__ > 4))
# define LIBGCC2_MAX_UNITS_PER_WORD 4
#else
# define LIBGCC2_MAX_UNITS_PER_WORD MIN_UNITS_PER_WORD
#endif

#ifndef LIBGCC2_UNITS_PER_WORD
#define LIBGCC2_UNITS_PER_WORD LIBGCC2_MAX_UNITS_PER_WORD
#endif

#if LIBGCC2_UNITS_PER_WORD == 8
#define W_TYPE_SIZE (8 * __CHAR_BIT__)
#define Wtype	DItype
#define UWtype	UDItype
#define HWtype	DItype
#define UHWtype	UDItype
#define DWtype	TItype
#define UDWtype	UTItype
#define COMPAT_SIMODE_TRAPPING_ARITHMETIC
#elif LIBGCC2_UNITS_PER_WORD == 4
#define W_TYPE_SIZE (4 * __CHAR_BIT__)
#define Wtype	SItype
#define UWtype	USItype
#define HWtype	SItype
#define UHWtype	USItype
#define DWtype	DItype
#define UDWtype	UDItype
#elif LIBGCC2_UNITS_PER_WORD == 2
#define W_TYPE_SIZE (2 * __CHAR_BIT__)
#define Wtype	HItype
#define UWtype	UHItype
#define HWtype	HItype
#define UHWtype	UHItype
#define DWtype	SItype
#define UDWtype	USItype
#else
#define W_TYPE_SIZE __CHAR_BIT__
#define Wtype	QItype
#define UWtype  UQItype
#define HWtype	QItype
#define UHWtype	UQItype
#define DWtype	HItype
#define UDWtype	UHItype
#endif

typedef		 int QItype	__attribute__ ((mode (QI)));
typedef unsigned int UQItype	__attribute__ ((mode (QI)));
typedef		 int HItype	__attribute__ ((mode (HI)));
typedef unsigned int UHItype	__attribute__ ((mode (HI)));
#if MIN_UNITS_PER_WORD > 1
/* These typedefs are usually forbidden on dsp's with UNITS_PER_WORD 1.  */
typedef 	 int SItype	__attribute__ ((mode (SI)));
typedef unsigned int USItype	__attribute__ ((mode (SI)));
#if __SIZEOF_LONG_LONG__ > 4
/* These typedefs are usually forbidden on archs with UNITS_PER_WORD 2.  */
typedef		 int DItype	__attribute__ ((mode (DI)));
typedef unsigned int UDItype	__attribute__ ((mode (DI)));
#if MIN_UNITS_PER_WORD > 4
/* These typedefs are usually forbidden on archs with UNITS_PER_WORD 4.  */
typedef		 int TItype	__attribute__ ((mode (TI)));
typedef unsigned int UTItype	__attribute__ ((mode (TI)));
#endif
#endif
#endif

#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
  struct DWstruct {Wtype high, low;};
#else
  struct DWstruct {Wtype low, high;};
#endif

typedef union
{
  struct DWstruct s;
  DWtype ll;
} DWunion;

#if (defined (__i386__) || defined (__i486__)) && W_TYPE_SIZE == 32
#define add_ssaaaa(sh, sl, ah, al, bh, bl) \
  __asm__ ("add{l} {%5,%1|%1,%5}\n\tadc{l} {%3,%0|%0,%3}"		\
	   : "=r" ((USItype) (sh)),					\
	     "=&r" ((USItype) (sl))					\
	   : "%0" ((USItype) (ah)),					\
	     "g" ((USItype) (bh)),					\
	     "%1" ((USItype) (al)),					\
	     "g" ((USItype) (bl)))
#define sub_ddmmss(sh, sl, ah, al, bh, bl) \
  __asm__ ("sub{l} {%5,%1|%1,%5}\n\tsbb{l} {%3,%0|%0,%3}"		\
	   : "=r" ((USItype) (sh)),					\
	     "=&r" ((USItype) (sl))					\
	   : "0" ((USItype) (ah)),					\
	     "g" ((USItype) (bh)),					\
	     "1" ((USItype) (al)),					\
	     "g" ((USItype) (bl)))
#define umul_ppmm(w1, w0, u, v) \
  __asm__ ("mul{l} %3"							\
	   : "=a" ((USItype) (w0)),					\
	     "=d" ((USItype) (w1))					\
	   : "%0" ((USItype) (u)),					\
	     "rm" ((USItype) (v)))
#define udiv_qrnnd(q, r, n1, n0, dv) \
  __asm__ ("div{l} %4"							\
	   : "=a" ((USItype) (q)),					\
	     "=d" ((USItype) (r))					\
	   : "0" ((USItype) (n0)),					\
	     "1" ((USItype) (n1)),					\
	     "rm" ((USItype) (dv)))
#define count_leading_zeros(count, x)	((count) = __builtin_clz (x))
#define count_trailing_zeros(count, x)	((count) = __builtin_ctz (x))
#define UMUL_TIME 40
#define UDIV_TIME 40
#endif /* 80x86 */

#define UDIV_NEEDS_NORMALIZATION 0


UDWtype
__udivmoddi4 (UDWtype n, UDWtype d, UDWtype *rp)
{
  const DWunion nn = {.ll = n};
  const DWunion dd = {.ll = d};
  DWunion rr;
  UWtype d0, d1, n0, n1, n2;
  UWtype q0, q1;
  UWtype b, bm;

  d0 = dd.s.low;
  d1 = dd.s.high;
  n0 = nn.s.low;
  n1 = nn.s.high;

#if !UDIV_NEEDS_NORMALIZATION
  if (d1 == 0)
    {
      if (d0 > n1)
	{
	  /* 0q = nn / 0D */

	  udiv_qrnnd (q0, n0, n1, n0, d0);
	  q1 = 0;

	  /* Remainder in n0.  */
	}
      else
	{
	  /* qq = NN / 0d */

	  if (d0 == 0)
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */

	  udiv_qrnnd (q1, n1, 0, n1, d0);
	  udiv_qrnnd (q0, n0, n1, n0, d0);

	  /* Remainder in n0.  */
	}

      if (rp != 0)
	{
	  rr.s.low = n0;
	  rr.s.high = 0;
	  *rp = rr.ll;
	}
    }

#else /* UDIV_NEEDS_NORMALIZATION */

  if (d1 == 0)
    {
      if (d0 > n1)
	{
	  /* 0q = nn / 0D */

	  count_leading_zeros (bm, d0);

	  if (bm != 0)
	    {
	      /* Normalize, i.e. make the most significant bit of the
		 denominator set.  */

	      d0 = d0 << bm;
	      n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
	      n0 = n0 << bm;
	    }

	  udiv_qrnnd (q0, n0, n1, n0, d0);
	  q1 = 0;

	  /* Remainder in n0 >> bm.  */
	}
      else
	{
	  /* qq = NN / 0d */

	  if (d0 == 0)
	    d0 = 1 / d0;	/* Divide intentionally by zero.  */

	  count_leading_zeros (bm, d0);

	  if (bm == 0)
	    {
	      /* From (n1 >= d0) /\ (the most significant bit of d0 is set),
		 conclude (the most significant bit of n1 is set) /\ (the
		 leading quotient digit q1 = 1).
		 This special case is necessary, not an optimization.
		 (Shifts counts of W_TYPE_SIZE are undefined.)  */

	      n1 -= d0;
	      q1 = 1;
	    }
	  else
	    {
	      /* Normalize.  */

	      b = W_TYPE_SIZE - bm;

	      d0 = d0 << bm;
	      n2 = n1 >> b;
	      n1 = (n1 << bm) | (n0 >> b);
	      n0 = n0 << bm;

	      udiv_qrnnd (q1, n1, n2, n1, d0);
	    }

	  /* n1 != d0...  */

	  udiv_qrnnd (q0, n0, n1, n0, d0);

	  /* Remainder in n0 >> bm.  */
	}

      if (rp != 0)
	{
	  rr.s.low = n0 >> bm;
	  rr.s.high = 0;
	  *rp = rr.ll;
	}
    }
#endif /* UDIV_NEEDS_NORMALIZATION */

  else
    {
      if (d1 > n1)
	{
	  /* 00 = nn / DD */

	  q0 = 0;
	  q1 = 0;

	  /* Remainder in n1n0.  */
	  if (rp != 0)
	    {
	      rr.s.low = n0;
	      rr.s.high = n1;
	      *rp = rr.ll;
	    }
	}
      else
	{
	  /* 0q = NN / dd */

	  count_leading_zeros (bm, d1);
	  if (bm == 0)
	    {
	      /* From (n1 >= d1) /\ (the most significant bit of d1 is set),
		 conclude (the most significant bit of n1 is set) /\ (the
		 quotient digit q0 = 0 or 1).
		 This special case is necessary, not an optimization.  */

	      /* The condition on the next line takes advantage of that
		 n1 >= d1 (true due to program flow).  */
	      if (n1 > d1 || n0 >= d0)
		{
		  q0 = 1;
		  sub_ddmmss (n1, n0, n1, n0, d1, d0);
		}
	      else
		q0 = 0;

	      q1 = 0;

	      if (rp != 0)
		{
		  rr.s.low = n0;
		  rr.s.high = n1;
		  *rp = rr.ll;
		}
	    }
	  else
	    {
	      UWtype m1, m0;
	      /* Normalize.  */

	      b = W_TYPE_SIZE - bm;

	      d1 = (d1 << bm) | (d0 >> b);
	      d0 = d0 << bm;
	      n2 = n1 >> b;
	      n1 = (n1 << bm) | (n0 >> b);
	      n0 = n0 << bm;

	      udiv_qrnnd (q0, n1, n2, n1, d1);
	      umul_ppmm (m1, m0, q0, d0);

	      if (m1 > n1 || (m1 == n1 && m0 > n0))
		{
		  q0--;
		  sub_ddmmss (m1, m0, m1, m0, d1, d0);
		}

	      q1 = 0;

	      /* Remainder in (n1n0 - m1m0) >> bm.  */
	      if (rp != 0)
		{
		  sub_ddmmss (n1, n0, n1, n0, m1, m0);
		  rr.s.low = (n1 << b) | (n0 >> bm);
		  rr.s.high = n1 >> bm;
		  *rp = rr.ll;
		}
	    }
	}
    }

  const DWunion ww = {{.low = q0, .high = q1}};
  return ww.ll;
}

DWtype
__divmoddi4 (DWtype u, DWtype v, DWtype *rp)
{
  Wtype c1 = 0, c2 = 0;
  DWunion uu = {.ll = u};
  DWunion vv = {.ll = v};
  DWtype w;
  DWtype r;

  if (uu.s.high < 0)
    c1 = ~c1, c2 = ~c2,
    uu.ll = -uu.ll;
  if (vv.s.high < 0)
    c1 = ~c1,
    vv.ll = -vv.ll;

  w = __udivmoddi4 (uu.ll, vv.ll, (UDWtype*)&r);
  if (c1)
    w = -w;
  if (c2)
    r = -r;

  *rp = r;
  return w;
}

int
__ctzdi2 (UDWtype x)
{
  const DWunion uu = {.ll = x};
  UWtype word;
  Wtype ret, add;

  if (uu.s.low)
    word = uu.s.low, add = 0;
  else
    word = uu.s.high, add = W_TYPE_SIZE;

  count_trailing_zeros (ret, word);
  return ret + add;
}
