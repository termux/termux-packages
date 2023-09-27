/* $NetBSD: cephes_subrl.c,v 1.2 2014/10/10 14:06:40 christos Exp $ */

/*-
 * Copyright (c) 2007 The NetBSD Foundation, Inc.
 * All rights reserved.
 *
 * This code is derived from software written by Stephen L. Moshier.
 * It is redistributed by the NetBSD Foundation by permission of the author.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include "../src/namespace.h"
#include <complex.h>
#include <math.h>
#include "cephes_subrl.h"

/* calculate cosh and sinh */

void
_cchshl(long double x, long double *c, long double *s)
{
	long double e, ei;

	if (fabsl(x) <= 0.5L) {
		*c = coshl(x);
		*s = sinhl(x);
	} else {
		e = expl(x);
		ei = 0.5L / e;
		e = 0.5L * e;
		*s = e - ei;
		*c = e + ei;
	}
}

/* Program to subtract nearest integer multiple of PI */

/* extended precision value of PI: */
static const long double DP1 = 3.14159265358979323829596852490908531763125L;
static const long double DP2 = 1.6667485837041756656403424829301998703007e-19L;
#ifndef __vax__
static const long double DP3 = 1.8830410776607851167459095484560349402753e-39L;
#define MACHEPL 1.1e-38L
#else
static const long double DP3 = 0L;
#define MACHEPL 1.1e-19L
#endif

long double
_redupil(long double x)
{
	long double t;
	long long i;

	t = x / M_PIL;
	if (t >= 0.0L)
		t += 0.5L;
	else
		t -= 0.5L;

	i = t;	/* the multiple */
	t = i;
	t = ((x - t * DP1) - t * DP2) - t * DP3;
	return t;
}

/* Taylor series expansion for cosh(2y) - cos(2x) */

long double
_ctansl(long double complex z)
{
	long double f, x, x2, y, y2, rn, t;
	long double d;

	x = fabsl(2.0L * creall(z));
	y = fabsl(2.0L * cimagl(z));

	x = _redupil(x);

	x = x * x;
	y = y * y;
	x2 = 1.0;
	y2 = 1.0;
	f = 1.0;
	rn = 0.0;
	d = 0.0;
	do {
		rn += 1.0L;
		f *= rn;
		rn += 1.0L;
		f *= rn;
		x2 *= x;
		y2 *= y;
		t = y2 + x2;
		t /= f;
		d += t;

		rn += 1.0L;
		f *= rn;
		rn += 1.0L;
		f *= rn;
		x2 *= x;
		y2 *= y;
		t = y2 - x2;
		t /= f;
		d += t;
	} while (fabsl(t/d) > MACHEPL);
	return d;
}
