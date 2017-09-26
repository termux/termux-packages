/**************************************************************************
* Implementation of crypt(3) using routines in libcrypto from openssl for
* use on Android in Termux.
*
*  https://www.freebsd.org/cgi/man.cgi?crypt(3)
*  http://man7.org/linux/man-pages/man3/crypt.3.html
*
* Relevant code is from FreeBSD with license given below.
**************************************************************************/

/*
 * Copyright (c) 2011 The FreeBSD Project. All rights reserved.
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
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <arpa/inet.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <openssl/sha.h>
#include <openssl/md5.h>

/* START: Freebsd compat */
typedef unsigned long u_long;
#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))
#define MD5_SIZE 16
#define	_PASSWORD_EFMT1		'_'
#define DES_SALT_ALPHABET \
	"./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define MD5Init MD5_Init
#define MD5Update MD5_Update
#define MD5Final MD5_Final
/* END: Freebsd compat */


/* START: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/misc.c */
static char itoa64[] =		/* 0 ... 63 => ascii - 64 */
	"./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

void
_crypt_to64(char *s, u_long v, int n)
{
	while (--n >= 0) {
		*s++ = itoa64[v&0x3f];
		v >>= 6;
	}
}

void
b64_from_24bit(uint8_t B2, uint8_t B1, uint8_t B0, int n, int *buflen, char **cp)
{
	uint32_t w;
	int i;

	w = (B2 << 16) | (B1 << 8) | B0;
	for (i = 0; i < n; i++) {
		**cp = itoa64[w&0x3f];
		(*cp)++;
		if ((*buflen)-- < 0)
			break;
		w >>= 6;
	}
}
/* END: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/misc.c */


/* START: https://github.com/freebsd/freebsd/blob/master/secure/lib/libcrypt/crypt-des.c */
#if	defined(__GNUC__) && !defined(lint)
#define INLINE inline
#else
#define INLINE
#endif

static u_char	IP[64] = {
	58, 50, 42, 34, 26, 18, 10,  2, 60, 52, 44, 36, 28, 20, 12,  4,
	62, 54, 46, 38, 30, 22, 14,  6, 64, 56, 48, 40, 32, 24, 16,  8,
	57, 49, 41, 33, 25, 17,  9,  1, 59, 51, 43, 35, 27, 19, 11,  3,
	61, 53, 45, 37, 29, 21, 13,  5, 63, 55, 47, 39, 31, 23, 15,  7
};

static u_char	inv_key_perm[64];
static u_char	key_perm[56] = {
	57, 49, 41, 33, 25, 17,  9,  1, 58, 50, 42, 34, 26, 18,
	10,  2, 59, 51, 43, 35, 27, 19, 11,  3, 60, 52, 44, 36,
	63, 55, 47, 39, 31, 23, 15,  7, 62, 54, 46, 38, 30, 22,
	14,  6, 61, 53, 45, 37, 29, 21, 13,  5, 28, 20, 12,  4
};

static u_char	key_shifts[16] = {
	1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1
};

static u_char	inv_comp_perm[56];
static u_char	comp_perm[48] = {
	14, 17, 11, 24,  1,  5,  3, 28, 15,  6, 21, 10,
	23, 19, 12,  4, 26,  8, 16,  7, 27, 20, 13,  2,
	41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48,
	44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32
};

/*
 *	No E box is used, as it's replaced by some ANDs, shifts, and ORs.
 */

static u_char	u_sbox[8][64];
static u_char	sbox[8][64] = {
	{
		14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
		 0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
		 4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
		15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13
	},
	{
		15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
		 3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
		 0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
		13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9
	},
	{
		10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
		13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
		13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
		 1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12
	},
	{
		 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
		13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
		10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
		 3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14
	},
	{
		 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
		14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
		 4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
		11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3
	},
	{
		12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
		10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
		 9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
		 4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13
	},
	{
		 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
		13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
		 1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
		 6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12
	},
	{
		13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
		 1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
		 7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
		 2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
	}
};

static u_char	un_pbox[32];
static u_char	pbox[32] = {
	16,  7, 20, 21, 29, 12, 28, 17,  1, 15, 23, 26,  5, 18, 31, 10,
	 2,  8, 24, 14, 32, 27,  3,  9, 19, 13, 30,  6, 22, 11,  4, 25
};

static u_int32_t	bits32[32] =
{
	0x80000000, 0x40000000, 0x20000000, 0x10000000,
	0x08000000, 0x04000000, 0x02000000, 0x01000000,
	0x00800000, 0x00400000, 0x00200000, 0x00100000,
	0x00080000, 0x00040000, 0x00020000, 0x00010000,
	0x00008000, 0x00004000, 0x00002000, 0x00001000,
	0x00000800, 0x00000400, 0x00000200, 0x00000100,
	0x00000080, 0x00000040, 0x00000020, 0x00000010,
	0x00000008, 0x00000004, 0x00000002, 0x00000001
};

static u_char	bits8[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };

static u_int32_t	saltbits;
static u_int32_t	old_salt;
static u_int32_t	*bits28, *bits24;
static u_char		init_perm[64], final_perm[64];
static u_int32_t	en_keysl[16], en_keysr[16];
static u_int32_t	de_keysl[16], de_keysr[16];
static int		des_initialised = 0;
static u_char		m_sbox[4][4096];
static u_int32_t	psbox[4][256];
static u_int32_t	ip_maskl[8][256], ip_maskr[8][256];
static u_int32_t	fp_maskl[8][256], fp_maskr[8][256];
static u_int32_t	key_perm_maskl[8][128], key_perm_maskr[8][128];
static u_int32_t	comp_maskl[8][128], comp_maskr[8][128];
static u_int32_t	old_rawkey0, old_rawkey1;

static u_char	ascii64[] =
	 "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
/*	  0000000000111111111122222222223333333333444444444455555555556666 */
/*	  0123456789012345678901234567890123456789012345678901234567890123 */

static INLINE int
ascii_to_bin(char ch)
{
	if (ch > 'z')
		return(0);
	if (ch >= 'a')
		return(ch - 'a' + 38);
	if (ch > 'Z')
		return(0);
	if (ch >= 'A')
		return(ch - 'A' + 12);
	if (ch > '9')
		return(0);
	if (ch >= '.')
		return(ch - '.');
	return(0);
}

static void
des_init(void)
{
	int	i, j, b, k, inbit, obit;
	u_int32_t	*p, *il, *ir, *fl, *fr;

	old_rawkey0 = old_rawkey1 = 0L;
	saltbits = 0L;
	old_salt = 0L;
	bits24 = (bits28 = bits32 + 4) + 4;

	/*
	 * Invert the S-boxes, reordering the input bits.
	 */
	for (i = 0; i < 8; i++)
		for (j = 0; j < 64; j++) {
			b = (j & 0x20) | ((j & 1) << 4) | ((j >> 1) & 0xf);
			u_sbox[i][j] = sbox[i][b];
		}

	/*
	 * Convert the inverted S-boxes into 4 arrays of 8 bits.
	 * Each will handle 12 bits of the S-box input.
	 */
	for (b = 0; b < 4; b++)
		for (i = 0; i < 64; i++)
			for (j = 0; j < 64; j++)
				m_sbox[b][(i << 6) | j] =
					(u_char)((u_sbox[(b << 1)][i] << 4) |
					u_sbox[(b << 1) + 1][j]);

	/*
	 * Set up the initial & final permutations into a useful form, and
	 * initialise the inverted key permutation.
	 */
	for (i = 0; i < 64; i++) {
		init_perm[final_perm[i] = IP[i] - 1] = (u_char)i;
		inv_key_perm[i] = 255;
	}

	/*
	 * Invert the key permutation and initialise the inverted key
	 * compression permutation.
	 */
	for (i = 0; i < 56; i++) {
		inv_key_perm[key_perm[i] - 1] = (u_char)i;
		inv_comp_perm[i] = 255;
	}

	/*
	 * Invert the key compression permutation.
	 */
	for (i = 0; i < 48; i++) {
		inv_comp_perm[comp_perm[i] - 1] = (u_char)i;
	}

	/*
	 * Set up the OR-mask arrays for the initial and final permutations,
	 * and for the key initial and compression permutations.
	 */
	for (k = 0; k < 8; k++) {
		for (i = 0; i < 256; i++) {
			*(il = &ip_maskl[k][i]) = 0L;
			*(ir = &ip_maskr[k][i]) = 0L;
			*(fl = &fp_maskl[k][i]) = 0L;
			*(fr = &fp_maskr[k][i]) = 0L;
			for (j = 0; j < 8; j++) {
				inbit = 8 * k + j;
				if (i & bits8[j]) {
					if ((obit = init_perm[inbit]) < 32)
						*il |= bits32[obit];
					else
						*ir |= bits32[obit-32];
					if ((obit = final_perm[inbit]) < 32)
						*fl |= bits32[obit];
					else
						*fr |= bits32[obit - 32];
				}
			}
		}
		for (i = 0; i < 128; i++) {
			*(il = &key_perm_maskl[k][i]) = 0L;
			*(ir = &key_perm_maskr[k][i]) = 0L;
			for (j = 0; j < 7; j++) {
				inbit = 8 * k + j;
				if (i & bits8[j + 1]) {
					if ((obit = inv_key_perm[inbit]) == 255)
						continue;
					if (obit < 28)
						*il |= bits28[obit];
					else
						*ir |= bits28[obit - 28];
				}
			}
			*(il = &comp_maskl[k][i]) = 0L;
			*(ir = &comp_maskr[k][i]) = 0L;
			for (j = 0; j < 7; j++) {
				inbit = 7 * k + j;
				if (i & bits8[j + 1]) {
					if ((obit=inv_comp_perm[inbit]) == 255)
						continue;
					if (obit < 24)
						*il |= bits24[obit];
					else
						*ir |= bits24[obit - 24];
				}
			}
		}
	}

	/*
	 * Invert the P-box permutation, and convert into OR-masks for
	 * handling the output of the S-box arrays setup above.
	 */
	for (i = 0; i < 32; i++)
		un_pbox[pbox[i] - 1] = (u_char)i;

	for (b = 0; b < 4; b++)
		for (i = 0; i < 256; i++) {
			*(p = &psbox[b][i]) = 0L;
			for (j = 0; j < 8; j++) {
				if (i & bits8[j])
					*p |= bits32[un_pbox[8 * b + j]];
			}
		}

	des_initialised = 1;
}

static void
setup_salt(u_int32_t salt)
{
	u_int32_t	obit, saltbit;
	int		i;

	if (salt == old_salt)
		return;
	old_salt = salt;

	saltbits = 0L;
	saltbit = 1;
	obit = 0x800000;
	for (i = 0; i < 24; i++) {
		if (salt & saltbit)
			saltbits |= obit;
		saltbit <<= 1;
		obit >>= 1;
	}
}

static int
des_setkey(const char *key)
{
	u_int32_t	k0, k1, rawkey0, rawkey1;
	int		shifts, round;

	if (!des_initialised)
		des_init();

	rawkey0 = ntohl(*(const u_int32_t *) key);
	rawkey1 = ntohl(*(const u_int32_t *) (key + 4));

	if ((rawkey0 | rawkey1)
	    && rawkey0 == old_rawkey0
	    && rawkey1 == old_rawkey1) {
		/*
		 * Already setup for this key.
		 * This optimisation fails on a zero key (which is weak and
		 * has bad parity anyway) in order to simplify the starting
		 * conditions.
		 */
		return(0);
	}
	old_rawkey0 = rawkey0;
	old_rawkey1 = rawkey1;

	/*
	 *	Do key permutation and split into two 28-bit subkeys.
	 */
	k0 = key_perm_maskl[0][rawkey0 >> 25]
	   | key_perm_maskl[1][(rawkey0 >> 17) & 0x7f]
	   | key_perm_maskl[2][(rawkey0 >> 9) & 0x7f]
	   | key_perm_maskl[3][(rawkey0 >> 1) & 0x7f]
	   | key_perm_maskl[4][rawkey1 >> 25]
	   | key_perm_maskl[5][(rawkey1 >> 17) & 0x7f]
	   | key_perm_maskl[6][(rawkey1 >> 9) & 0x7f]
	   | key_perm_maskl[7][(rawkey1 >> 1) & 0x7f];
	k1 = key_perm_maskr[0][rawkey0 >> 25]
	   | key_perm_maskr[1][(rawkey0 >> 17) & 0x7f]
	   | key_perm_maskr[2][(rawkey0 >> 9) & 0x7f]
	   | key_perm_maskr[3][(rawkey0 >> 1) & 0x7f]
	   | key_perm_maskr[4][rawkey1 >> 25]
	   | key_perm_maskr[5][(rawkey1 >> 17) & 0x7f]
	   | key_perm_maskr[6][(rawkey1 >> 9) & 0x7f]
	   | key_perm_maskr[7][(rawkey1 >> 1) & 0x7f];
	/*
	 *	Rotate subkeys and do compression permutation.
	 */
	shifts = 0;
	for (round = 0; round < 16; round++) {
		u_int32_t	t0, t1;

		shifts += key_shifts[round];

		t0 = (k0 << shifts) | (k0 >> (28 - shifts));
		t1 = (k1 << shifts) | (k1 >> (28 - shifts));

		de_keysl[15 - round] =
		en_keysl[round] = comp_maskl[0][(t0 >> 21) & 0x7f]
				| comp_maskl[1][(t0 >> 14) & 0x7f]
				| comp_maskl[2][(t0 >> 7) & 0x7f]
				| comp_maskl[3][t0 & 0x7f]
				| comp_maskl[4][(t1 >> 21) & 0x7f]
				| comp_maskl[5][(t1 >> 14) & 0x7f]
				| comp_maskl[6][(t1 >> 7) & 0x7f]
				| comp_maskl[7][t1 & 0x7f];

		de_keysr[15 - round] =
		en_keysr[round] = comp_maskr[0][(t0 >> 21) & 0x7f]
				| comp_maskr[1][(t0 >> 14) & 0x7f]
				| comp_maskr[2][(t0 >> 7) & 0x7f]
				| comp_maskr[3][t0 & 0x7f]
				| comp_maskr[4][(t1 >> 21) & 0x7f]
				| comp_maskr[5][(t1 >> 14) & 0x7f]
				| comp_maskr[6][(t1 >> 7) & 0x7f]
				| comp_maskr[7][t1 & 0x7f];
	}
	return(0);
}

static int
do_des(	u_int32_t l_in, u_int32_t r_in, u_int32_t *l_out, u_int32_t *r_out, int count)
{
	/*
	 *	l_in, r_in, l_out, and r_out are in pseudo-"big-endian" format.
	 */
	u_int32_t	l, r, *kl, *kr, *kl1, *kr1;
	u_int32_t	f, r48l, r48r;
	int		round;

	if (count == 0) {
		return(1);
	} else if (count > 0) {
		/*
		 * Encrypting
		 */
		kl1 = en_keysl;
		kr1 = en_keysr;
	} else {
		/*
		 * Decrypting
		 */
		count = -count;
		kl1 = de_keysl;
		kr1 = de_keysr;
	}

	/*
	 *	Do initial permutation (IP).
	 */
	l = ip_maskl[0][l_in >> 24]
	  | ip_maskl[1][(l_in >> 16) & 0xff]
	  | ip_maskl[2][(l_in >> 8) & 0xff]
	  | ip_maskl[3][l_in & 0xff]
	  | ip_maskl[4][r_in >> 24]
	  | ip_maskl[5][(r_in >> 16) & 0xff]
	  | ip_maskl[6][(r_in >> 8) & 0xff]
	  | ip_maskl[7][r_in & 0xff];
	r = ip_maskr[0][l_in >> 24]
	  | ip_maskr[1][(l_in >> 16) & 0xff]
	  | ip_maskr[2][(l_in >> 8) & 0xff]
	  | ip_maskr[3][l_in & 0xff]
	  | ip_maskr[4][r_in >> 24]
	  | ip_maskr[5][(r_in >> 16) & 0xff]
	  | ip_maskr[6][(r_in >> 8) & 0xff]
	  | ip_maskr[7][r_in & 0xff];

	while (count--) {
		/*
		 * Do each round.
		 */
		kl = kl1;
		kr = kr1;
		round = 16;
		while (round--) {
			/*
			 * Expand R to 48 bits (simulate the E-box).
			 */
			r48l	= ((r & 0x00000001) << 23)
				| ((r & 0xf8000000) >> 9)
				| ((r & 0x1f800000) >> 11)
				| ((r & 0x01f80000) >> 13)
				| ((r & 0x001f8000) >> 15);

			r48r	= ((r & 0x0001f800) << 7)
				| ((r & 0x00001f80) << 5)
				| ((r & 0x000001f8) << 3)
				| ((r & 0x0000001f) << 1)
				| ((r & 0x80000000) >> 31);
			/*
			 * Do salting for crypt() and friends, and
			 * XOR with the permuted key.
			 */
			f = (r48l ^ r48r) & saltbits;
			r48l ^= f ^ *kl++;
			r48r ^= f ^ *kr++;
			/*
			 * Do sbox lookups (which shrink it back to 32 bits)
			 * and do the pbox permutation at the same time.
			 */
			f = psbox[0][m_sbox[0][r48l >> 12]]
			  | psbox[1][m_sbox[1][r48l & 0xfff]]
			  | psbox[2][m_sbox[2][r48r >> 12]]
			  | psbox[3][m_sbox[3][r48r & 0xfff]];
			/*
			 * Now that we've permuted things, complete f().
			 */
			f ^= l;
			l = r;
			r = f;
		}
		r = l;
		l = f;
	}
	/*
	 * Do final permutation (inverse of IP).
	 */
	*l_out	= fp_maskl[0][l >> 24]
		| fp_maskl[1][(l >> 16) & 0xff]
		| fp_maskl[2][(l >> 8) & 0xff]
		| fp_maskl[3][l & 0xff]
		| fp_maskl[4][r >> 24]
		| fp_maskl[5][(r >> 16) & 0xff]
		| fp_maskl[6][(r >> 8) & 0xff]
		| fp_maskl[7][r & 0xff];
	*r_out	= fp_maskr[0][l >> 24]
		| fp_maskr[1][(l >> 16) & 0xff]
		| fp_maskr[2][(l >> 8) & 0xff]
		| fp_maskr[3][l & 0xff]
		| fp_maskr[4][r >> 24]
		| fp_maskr[5][(r >> 16) & 0xff]
		| fp_maskr[6][(r >> 8) & 0xff]
		| fp_maskr[7][r & 0xff];
	return(0);
}

static int
des_cipher(const char *in, char *out, u_long salt, int count)
{
	u_int32_t	l_out, r_out, rawl, rawr;
	int		retval;
	union {
		u_int32_t	*ui32;
		const char	*c;
	} trans;

	if (!des_initialised)
		des_init();

	setup_salt(salt);

	trans.c = in;
	rawl = ntohl(*trans.ui32++);
	rawr = ntohl(*trans.ui32);

	retval = do_des(rawl, rawr, &l_out, &r_out, count);

	trans.c = out;
	*trans.ui32++ = htonl(l_out);
	*trans.ui32 = htonl(r_out);
	return(retval);
}

char *
crypt_des(const char *key, const char *setting)
{
	int		i;
	u_int32_t	count, salt, l, r0, r1, keybuf[2];
	u_char		*p, *q;
	static char	output[21];

	if (!des_initialised)
		des_init();

	/*
	 * Copy the key, shifting each character up by one bit
	 * and padding with zeros.
	 */
	q = (u_char *)keybuf;
	while (q - (u_char *)keybuf - 8) {
		*q++ = *key << 1;
		if (*key != '\0')
			key++;
	}
	if (des_setkey((char *)keybuf))
		return(NULL);

	if (*setting == _PASSWORD_EFMT1) {
		/*
		 * "new"-style:
		 *	setting - underscore, 4 bytes of count, 4 bytes of salt
		 *	key - unlimited characters
		 */
		for (i = 1, count = 0L; i < 5; i++)
			count |= ascii_to_bin(setting[i]) << ((i - 1) * 6);

		for (i = 5, salt = 0L; i < 9; i++)
			salt |= ascii_to_bin(setting[i]) << ((i - 5) * 6);

		while (*key) {
			/*
			 * Encrypt the key with itself.
			 */
			if (des_cipher((char *)keybuf, (char *)keybuf, 0L, 1))
				return(NULL);
			/*
			 * And XOR with the next 8 characters of the key.
			 */
			q = (u_char *)keybuf;
			while (q - (u_char *)keybuf - 8 && *key)
				*q++ ^= *key++ << 1;

			if (des_setkey((char *)keybuf))
				return(NULL);
		}
		strncpy(output, setting, 9);

		/*
		 * Double check that we weren't given a short setting.
		 * If we were, the above code will probably have created
		 * wierd values for count and salt, but we don't really care.
		 * Just make sure the output string doesn't have an extra
		 * NUL in it.
		 */
		output[9] = '\0';
		p = (u_char *)output + strlen(output);
	} else {
		/*
		 * "old"-style:
		 *	setting - 2 bytes of salt
		 *	key - up to 8 characters
		 */
		count = 25;

		salt = (ascii_to_bin(setting[1]) << 6)
		     |  ascii_to_bin(setting[0]);

		output[0] = setting[0];
		/*
		 * If the encrypted password that the salt was extracted from
		 * is only 1 character long, the salt will be corrupted.  We
		 * need to ensure that the output string doesn't have an extra
		 * NUL in it!
		 */
		output[1] = setting[1] ? setting[1] : output[0];

		p = (u_char *)output + 2;
	}
	setup_salt(salt);
	/*
	 * Do it.
	 */
	if (do_des(0L, 0L, &r0, &r1, (int)count))
		return(NULL);
	/*
	 * Now encode the result...
	 */
	l = (r0 >> 8);
	*p++ = ascii64[(l >> 18) & 0x3f];
	*p++ = ascii64[(l >> 12) & 0x3f];
	*p++ = ascii64[(l >> 6) & 0x3f];
	*p++ = ascii64[l & 0x3f];

	l = (r0 << 16) | ((r1 >> 16) & 0xffff);
	*p++ = ascii64[(l >> 18) & 0x3f];
	*p++ = ascii64[(l >> 12) & 0x3f];
	*p++ = ascii64[(l >> 6) & 0x3f];
	*p++ = ascii64[l & 0x3f];

	l = r1 << 2;
	*p++ = ascii64[(l >> 12) & 0x3f];
	*p++ = ascii64[(l >> 6) & 0x3f];
	*p++ = ascii64[l & 0x3f];
	*p = 0;

	return(output);
}
/* END: https://github.com/freebsd/freebsd/blob/master/secure/lib/libcrypt/crypt-des.c */


/* START: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt-md5.c */
char *
crypt_md5(const char *pw, const char *salt)
{
	MD5_CTX	ctx,ctx1;
	unsigned long l;
	int sl, pl;
	u_int i;
	u_char final[MD5_SIZE];
	static const char *sp, *ep;
	static char passwd[120], *p;
	static const char *magic = "$1$";

	/* Refine the Salt first */
	sp = salt;

	/* If it starts with the magic string, then skip that */
	if(!strncmp(sp, magic, strlen(magic)))
		sp += strlen(magic);

	/* It stops at the first '$', max 8 chars */
	for(ep = sp; *ep && *ep != '$' && ep < (sp + 8); ep++)
		continue;

	/* get the length of the true salt */
	sl = ep - sp;

	MD5Init(&ctx);

	/* The password first, since that is what is most unknown */
	MD5Update(&ctx, (const u_char *)pw, strlen(pw));

	/* Then our magic string */
	MD5Update(&ctx, (const u_char *)magic, strlen(magic));

	/* Then the raw salt */
	MD5Update(&ctx, (const u_char *)sp, (u_int)sl);

	/* Then just as many characters of the MD5(pw,salt,pw) */
	MD5Init(&ctx1);
	MD5Update(&ctx1, (const u_char *)pw, strlen(pw));
	MD5Update(&ctx1, (const u_char *)sp, (u_int)sl);
	MD5Update(&ctx1, (const u_char *)pw, strlen(pw));
	MD5Final(final, &ctx1);
	for(pl = (int)strlen(pw); pl > 0; pl -= MD5_SIZE)
		MD5Update(&ctx, (const u_char *)final,
		    (u_int)(pl > MD5_SIZE ? MD5_SIZE : pl));

	/* Don't leave anything around in vm they could use. */
	memset(final, 0, sizeof(final));

	/* Then something really weird... */
	for (i = strlen(pw); i; i >>= 1)
		if(i & 1)
		    MD5Update(&ctx, (const u_char *)final, 1);
		else
		    MD5Update(&ctx, (const u_char *)pw, 1);

	/* Now make the output string */
	strcpy(passwd, magic);
	strncat(passwd, sp, (u_int)sl);
	strcat(passwd, "$");

	MD5Final(final, &ctx);

	/*
	 * and now, just to make sure things don't run too fast
	 * On a 60 Mhz Pentium this takes 34 msec, so you would
	 * need 30 seconds to build a 1000 entry dictionary...
	 */
	for(i = 0; i < 1000; i++) {
		MD5Init(&ctx1);
		if(i & 1)
			MD5Update(&ctx1, (const u_char *)pw, strlen(pw));
		else
			MD5Update(&ctx1, (const u_char *)final, MD5_SIZE);

		if(i % 3)
			MD5Update(&ctx1, (const u_char *)sp, (u_int)sl);

		if(i % 7)
			MD5Update(&ctx1, (const u_char *)pw, strlen(pw));

		if(i & 1)
			MD5Update(&ctx1, (const u_char *)final, MD5_SIZE);
		else
			MD5Update(&ctx1, (const u_char *)pw, strlen(pw));
		MD5Final(final, &ctx1);
	}

	p = passwd + strlen(passwd);

	l = (final[ 0]<<16) | (final[ 6]<<8) | final[12];
	_crypt_to64(p, l, 4); p += 4;
	l = (final[ 1]<<16) | (final[ 7]<<8) | final[13];
	_crypt_to64(p, l, 4); p += 4;
	l = (final[ 2]<<16) | (final[ 8]<<8) | final[14];
	_crypt_to64(p, l, 4); p += 4;
	l = (final[ 3]<<16) | (final[ 9]<<8) | final[15];
	_crypt_to64(p, l, 4); p += 4;
	l = (final[ 4]<<16) | (final[10]<<8) | final[ 5];
	_crypt_to64(p, l, 4); p += 4;
	l = final[11];
	_crypt_to64(p, l, 2); p += 2;
	*p = '\0';

	/* Don't leave anything around in vm they could use. */
	memset(final, 0, sizeof(final));

	return (passwd);
}
/* END: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt-md5.c */


/* START: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt-sha256.c */
static const char sha256_salt_prefix[] = "$5$";

/* Prefix for optional rounds specification. */
static const char sha256_rounds_prefix[] = "rounds=";

/* Maximum salt string length. */
#define SALT_LEN_MAX 16
/* Default number of rounds if not explicitly specified. */
#define ROUNDS_DEFAULT 5000
/* Minimum number of rounds. */
#define ROUNDS_MIN 1000
/* Maximum number of rounds. */
#define ROUNDS_MAX 999999999

static char *
crypt_sha256_r(const char *key, const char *salt, char *buffer, int buflen)
{
	u_long srounds;
	int n;
	uint8_t alt_result[32], temp_result[32];
	SHA256_CTX ctx, alt_ctx;
	size_t salt_len, key_len, cnt, rounds;
	char *cp, *copied_key, *copied_salt, *p_bytes, *s_bytes, *endp;
	const char *num;
	bool rounds_custom;

	copied_key = NULL;
	copied_salt = NULL;

	/* Default number of rounds. */
	rounds = ROUNDS_DEFAULT;
	rounds_custom = false;

	/* Find beginning of salt string. The prefix should normally always
	 * be present. Just in case it is not. */
	if (strncmp(sha256_salt_prefix, salt, sizeof(sha256_salt_prefix) - 1) == 0)
		/* Skip salt prefix. */
		salt += sizeof(sha256_salt_prefix) - 1;

	if (strncmp(salt, sha256_rounds_prefix, sizeof(sha256_rounds_prefix) - 1)
	    == 0) {
		num = salt + sizeof(sha256_rounds_prefix) - 1;
		srounds = strtoul(num, &endp, 10);

		if (*endp == '$') {
			salt = endp + 1;
			rounds = MAX(ROUNDS_MIN, MIN(srounds, ROUNDS_MAX));
			rounds_custom = true;
		}
	}

	salt_len = MIN(strcspn(salt, "$"), SALT_LEN_MAX);
	key_len = strlen(key);

	/* Prepare for the real work. */
	SHA256_Init(&ctx);

	/* Add the key string. */
	SHA256_Update(&ctx, key, key_len);

	/* The last part is the salt string. This must be at most 8
	 * characters and it ends at the first `$' character (for
	 * compatibility with existing implementations). */
	SHA256_Update(&ctx, salt, salt_len);

	/* Compute alternate SHA256 sum with input KEY, SALT, and KEY. The
	 * final result will be added to the first context. */
	SHA256_Init(&alt_ctx);

	/* Add key. */
	SHA256_Update(&alt_ctx, key, key_len);

	/* Add salt. */
	SHA256_Update(&alt_ctx, salt, salt_len);

	/* Add key again. */
	SHA256_Update(&alt_ctx, key, key_len);

	/* Now get result of this (32 bytes) and add it to the other context. */
	SHA256_Final(alt_result, &alt_ctx);

	/* Add for any character in the key one byte of the alternate sum. */
	for (cnt = key_len; cnt > 32; cnt -= 32)
		SHA256_Update(&ctx, alt_result, 32);
	SHA256_Update(&ctx, alt_result, cnt);

	/* Take the binary representation of the length of the key and for
	 * every 1 add the alternate sum, for every 0 the key. */
	for (cnt = key_len; cnt > 0; cnt >>= 1)
		if ((cnt & 1) != 0)
			SHA256_Update(&ctx, alt_result, 32);
		else
			SHA256_Update(&ctx, key, key_len);

	/* Create intermediate result. */
	SHA256_Final(alt_result, &ctx);

	/* Start computation of P byte sequence. */
	SHA256_Init(&alt_ctx);

	/* For every character in the password add the entire password. */
	for (cnt = 0; cnt < key_len; ++cnt)
		SHA256_Update(&alt_ctx, key, key_len);

	/* Finish the digest. */
	SHA256_Final(temp_result, &alt_ctx);

	/* Create byte sequence P. */
	cp = p_bytes = alloca(key_len);
	for (cnt = key_len; cnt >= 32; cnt -= 32) {
		memcpy(cp, temp_result, 32);
		cp += 32;
	}
	memcpy(cp, temp_result, cnt);

	/* Start computation of S byte sequence. */
	SHA256_Init(&alt_ctx);

	/* For every character in the password add the entire password. */
	for (cnt = 0; cnt < 16 + alt_result[0]; ++cnt)
		SHA256_Update(&alt_ctx, salt, salt_len);

	/* Finish the digest. */
	SHA256_Final(temp_result, &alt_ctx);

	/* Create byte sequence S. */
	cp = s_bytes = alloca(salt_len);
	for (cnt = salt_len; cnt >= 32; cnt -= 32) {
		memcpy(cp, temp_result, 32);
		cp += 32;
	}
	memcpy(cp, temp_result, cnt);

	/* Repeatedly run the collected hash value through SHA256 to burn CPU
	 * cycles. */
	for (cnt = 0; cnt < rounds; ++cnt) {
		/* New context. */
		SHA256_Init(&ctx);

		/* Add key or last result. */
		if ((cnt & 1) != 0)
			SHA256_Update(&ctx, p_bytes, key_len);
		else
			SHA256_Update(&ctx, alt_result, 32);

		/* Add salt for numbers not divisible by 3. */
		if (cnt % 3 != 0)
			SHA256_Update(&ctx, s_bytes, salt_len);

		/* Add key for numbers not divisible by 7. */
		if (cnt % 7 != 0)
			SHA256_Update(&ctx, p_bytes, key_len);

		/* Add key or last result. */
		if ((cnt & 1) != 0)
			SHA256_Update(&ctx, alt_result, 32);
		else
			SHA256_Update(&ctx, p_bytes, key_len);

		/* Create intermediate result. */
		SHA256_Final(alt_result, &ctx);
	}

	/* Now we can construct the result string. It consists of three
	 * parts. */
	cp = stpncpy(buffer, sha256_salt_prefix, MAX(0, buflen));
	buflen -= sizeof(sha256_salt_prefix) - 1;

	if (rounds_custom) {
		n = snprintf(cp, MAX(0, buflen), "%s%zu$",
			 sha256_rounds_prefix, rounds);

		cp += n;
		buflen -= n;
	}

	cp = stpncpy(cp, salt, MIN((size_t)MAX(0, buflen), salt_len));
	buflen -= MIN((size_t)MAX(0, buflen), salt_len);

	if (buflen > 0) {
		*cp++ = '$';
		--buflen;
	}

	b64_from_24bit(alt_result[0], alt_result[10], alt_result[20], 4, &buflen, &cp);
	b64_from_24bit(alt_result[21], alt_result[1], alt_result[11], 4, &buflen, &cp);
	b64_from_24bit(alt_result[12], alt_result[22], alt_result[2], 4, &buflen, &cp);
	b64_from_24bit(alt_result[3], alt_result[13], alt_result[23], 4, &buflen, &cp);
	b64_from_24bit(alt_result[24], alt_result[4], alt_result[14], 4, &buflen, &cp);
	b64_from_24bit(alt_result[15], alt_result[25], alt_result[5], 4, &buflen, &cp);
	b64_from_24bit(alt_result[6], alt_result[16], alt_result[26], 4, &buflen, &cp);
	b64_from_24bit(alt_result[27], alt_result[7], alt_result[17], 4, &buflen, &cp);
	b64_from_24bit(alt_result[18], alt_result[28], alt_result[8], 4, &buflen, &cp);
	b64_from_24bit(alt_result[9], alt_result[19], alt_result[29], 4, &buflen, &cp);
	b64_from_24bit(0, alt_result[31], alt_result[30], 3, &buflen, &cp);
	if (buflen <= 0) {
		errno = ERANGE;
		buffer = NULL;
	}
	else
		*cp = '\0';	/* Terminate the string. */

	/* Clear the buffer for the intermediate result so that people
	 * attaching to processes or reading core dumps cannot get any
	 * information. We do it in this way to clear correct_words[] inside
	 * the SHA256 implementation as well. */
	SHA256_Init(&ctx);
	SHA256_Final(alt_result, &ctx);
	memset(temp_result, '\0', sizeof(temp_result));
	memset(p_bytes, '\0', key_len);
	memset(s_bytes, '\0', salt_len);
	memset(&ctx, '\0', sizeof(ctx));
	memset(&alt_ctx, '\0', sizeof(alt_ctx));
	if (copied_key != NULL)
		memset(copied_key, '\0', key_len);
	if (copied_salt != NULL)
		memset(copied_salt, '\0', salt_len);

	return buffer;
}

/* This entry point is equivalent to crypt(3). */
char* crypt_sha256(const char *key, const char *salt)
{
	/* We don't want to have an arbitrary limit in the size of the
	 * password. We can compute an upper bound for the size of the
	 * result in advance and so we can prepare the buffer we pass to
	 * `crypt_sha256_r'. */
	static char *buffer;
	static int buflen;
	int needed;
	char *new_buffer;

	needed = (sizeof(sha256_salt_prefix) - 1
	      + sizeof(sha256_rounds_prefix) + 9 + 1
	      + strlen(salt) + 1 + 43 + 1);

	if (buflen < needed) {
		new_buffer = (char *)realloc(buffer, needed);

		if (new_buffer == NULL)
			return NULL;

		buffer = new_buffer;
		buflen = needed;
	}

	return crypt_sha256_r(key, salt, buffer, buflen);
}
/* END: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt-sha256.c */


/* START: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt-sha512.c */
/* Define our magic string to mark salt for SHA512 "encryption" replacement. */
static const char sha512_salt_prefix[] = "$6$";

/* Prefix for optional rounds specification. */
static const char sha512_rounds_prefix[] = "rounds=";

/* Maximum salt string length. */
#define SALT_LEN_MAX 16
/* Default number of rounds if not explicitly specified. */
#define ROUNDS_DEFAULT 5000
/* Minimum number of rounds. */
#define ROUNDS_MIN 1000
/* Maximum number of rounds. */
#define ROUNDS_MAX 999999999

static char *
crypt_sha512_r(const char *key, const char *salt, char *buffer, int buflen)
{
	u_long srounds;
	int n;
	uint8_t alt_result[64], temp_result[64];
	SHA512_CTX ctx, alt_ctx;
	size_t salt_len, key_len, cnt, rounds;
	char *cp, *copied_key, *copied_salt, *p_bytes, *s_bytes, *endp;
	const char *num;
	bool rounds_custom;

	copied_key = NULL;
	copied_salt = NULL;

	/* Default number of rounds. */
	rounds = ROUNDS_DEFAULT;
	rounds_custom = false;

	/* Find beginning of salt string. The prefix should normally always
	 * be present. Just in case it is not. */
	if (strncmp(sha512_salt_prefix, salt, sizeof(sha512_salt_prefix) - 1) == 0)
		/* Skip salt prefix. */
		salt += sizeof(sha512_salt_prefix) - 1;

	if (strncmp(salt, sha512_rounds_prefix, sizeof(sha512_rounds_prefix) - 1)
	    == 0) {
		num = salt + sizeof(sha512_rounds_prefix) - 1;
		srounds = strtoul(num, &endp, 10);

		if (*endp == '$') {
			salt = endp + 1;
			rounds = MAX(ROUNDS_MIN, MIN(srounds, ROUNDS_MAX));
			rounds_custom = true;
		}
	}

	salt_len = MIN(strcspn(salt, "$"), SALT_LEN_MAX);
	key_len = strlen(key);

	/* Prepare for the real work. */
	SHA512_Init(&ctx);

	/* Add the key string. */
	SHA512_Update(&ctx, key, key_len);

	/* The last part is the salt string. This must be at most 8
	 * characters and it ends at the first `$' character (for
	 * compatibility with existing implementations). */
	SHA512_Update(&ctx, salt, salt_len);

	/* Compute alternate SHA512 sum with input KEY, SALT, and KEY. The
	 * final result will be added to the first context. */
	SHA512_Init(&alt_ctx);

	/* Add key. */
	SHA512_Update(&alt_ctx, key, key_len);

	/* Add salt. */
	SHA512_Update(&alt_ctx, salt, salt_len);

	/* Add key again. */
	SHA512_Update(&alt_ctx, key, key_len);

	/* Now get result of this (64 bytes) and add it to the other context. */
	SHA512_Final(alt_result, &alt_ctx);

	/* Add for any character in the key one byte of the alternate sum. */
	for (cnt = key_len; cnt > 64; cnt -= 64)
		SHA512_Update(&ctx, alt_result, 64);
	SHA512_Update(&ctx, alt_result, cnt);

	/* Take the binary representation of the length of the key and for
	 * every 1 add the alternate sum, for every 0 the key. */
	for (cnt = key_len; cnt > 0; cnt >>= 1)
		if ((cnt & 1) != 0)
			SHA512_Update(&ctx, alt_result, 64);
		else
			SHA512_Update(&ctx, key, key_len);

	/* Create intermediate result. */
	SHA512_Final(alt_result, &ctx);

	/* Start computation of P byte sequence. */
	SHA512_Init(&alt_ctx);

	/* For every character in the password add the entire password. */
	for (cnt = 0; cnt < key_len; ++cnt)
		SHA512_Update(&alt_ctx, key, key_len);

	/* Finish the digest. */
	SHA512_Final(temp_result, &alt_ctx);

	/* Create byte sequence P. */
	cp = p_bytes = alloca(key_len);
	for (cnt = key_len; cnt >= 64; cnt -= 64) {
		memcpy(cp, temp_result, 64);
		cp += 64;
	}
	memcpy(cp, temp_result, cnt);

	/* Start computation of S byte sequence. */
	SHA512_Init(&alt_ctx);

	/* For every character in the password add the entire password. */
	for (cnt = 0; cnt < 16 + alt_result[0]; ++cnt)
		SHA512_Update(&alt_ctx, salt, salt_len);

	/* Finish the digest. */
	SHA512_Final(temp_result, &alt_ctx);

	/* Create byte sequence S. */
	cp = s_bytes = alloca(salt_len);
	for (cnt = salt_len; cnt >= 64; cnt -= 64) {
		memcpy(cp, temp_result, 64);
		cp += 64;
	}
	memcpy(cp, temp_result, cnt);

	/* Repeatedly run the collected hash value through SHA512 to burn CPU
	 * cycles. */
	for (cnt = 0; cnt < rounds; ++cnt) {
		/* New context. */
		SHA512_Init(&ctx);

		/* Add key or last result. */
		if ((cnt & 1) != 0)
			SHA512_Update(&ctx, p_bytes, key_len);
		else
			SHA512_Update(&ctx, alt_result, 64);

		/* Add salt for numbers not divisible by 3. */
		if (cnt % 3 != 0)
			SHA512_Update(&ctx, s_bytes, salt_len);

		/* Add key for numbers not divisible by 7. */
		if (cnt % 7 != 0)
			SHA512_Update(&ctx, p_bytes, key_len);

		/* Add key or last result. */
		if ((cnt & 1) != 0)
			SHA512_Update(&ctx, alt_result, 64);
		else
			SHA512_Update(&ctx, p_bytes, key_len);

		/* Create intermediate result. */
		SHA512_Final(alt_result, &ctx);
	}

	/* Now we can construct the result string. It consists of three
	 * parts. */
	cp = stpncpy(buffer, sha512_salt_prefix, MAX(0, buflen));
	buflen -= sizeof(sha512_salt_prefix) - 1;

	if (rounds_custom) {
		n = snprintf(cp, MAX(0, buflen), "%s%zu$",
			 sha512_rounds_prefix, rounds);

		cp += n;
		buflen -= n;
	}

	cp = stpncpy(cp, salt, MIN((size_t)MAX(0, buflen), salt_len));
	buflen -= MIN((size_t)MAX(0, buflen), salt_len);

	if (buflen > 0) {
		*cp++ = '$';
		--buflen;
	}

	b64_from_24bit(alt_result[0], alt_result[21], alt_result[42], 4, &buflen, &cp);
	b64_from_24bit(alt_result[22], alt_result[43], alt_result[1], 4, &buflen, &cp);
	b64_from_24bit(alt_result[44], alt_result[2], alt_result[23], 4, &buflen, &cp);
	b64_from_24bit(alt_result[3], alt_result[24], alt_result[45], 4, &buflen, &cp);
	b64_from_24bit(alt_result[25], alt_result[46], alt_result[4], 4, &buflen, &cp);
	b64_from_24bit(alt_result[47], alt_result[5], alt_result[26], 4, &buflen, &cp);
	b64_from_24bit(alt_result[6], alt_result[27], alt_result[48], 4, &buflen, &cp);
	b64_from_24bit(alt_result[28], alt_result[49], alt_result[7], 4, &buflen, &cp);
	b64_from_24bit(alt_result[50], alt_result[8], alt_result[29], 4, &buflen, &cp);
	b64_from_24bit(alt_result[9], alt_result[30], alt_result[51], 4, &buflen, &cp);
	b64_from_24bit(alt_result[31], alt_result[52], alt_result[10], 4, &buflen, &cp);
	b64_from_24bit(alt_result[53], alt_result[11], alt_result[32], 4, &buflen, &cp);
	b64_from_24bit(alt_result[12], alt_result[33], alt_result[54], 4, &buflen, &cp);
	b64_from_24bit(alt_result[34], alt_result[55], alt_result[13], 4, &buflen, &cp);
	b64_from_24bit(alt_result[56], alt_result[14], alt_result[35], 4, &buflen, &cp);
	b64_from_24bit(alt_result[15], alt_result[36], alt_result[57], 4, &buflen, &cp);
	b64_from_24bit(alt_result[37], alt_result[58], alt_result[16], 4, &buflen, &cp);
	b64_from_24bit(alt_result[59], alt_result[17], alt_result[38], 4, &buflen, &cp);
	b64_from_24bit(alt_result[18], alt_result[39], alt_result[60], 4, &buflen, &cp);
	b64_from_24bit(alt_result[40], alt_result[61], alt_result[19], 4, &buflen, &cp);
	b64_from_24bit(alt_result[62], alt_result[20], alt_result[41], 4, &buflen, &cp);
	b64_from_24bit(0, 0, alt_result[63], 2, &buflen, &cp);

	if (buflen <= 0) {
		errno = ERANGE;
		buffer = NULL;
	}
	else
		*cp = '\0';	/* Terminate the string. */

	/* Clear the buffer for the intermediate result so that people
	 * attaching to processes or reading core dumps cannot get any
	 * information. We do it in this way to clear correct_words[] inside
	 * the SHA512 implementation as well. */
	SHA512_Init(&ctx);
	SHA512_Final(alt_result, &ctx);
	memset(temp_result, '\0', sizeof(temp_result));
	memset(p_bytes, '\0', key_len);
	memset(s_bytes, '\0', salt_len);
	memset(&ctx, '\0', sizeof(ctx));
	memset(&alt_ctx, '\0', sizeof(alt_ctx));
	if (copied_key != NULL)
		memset(copied_key, '\0', key_len);
	if (copied_salt != NULL)
		memset(copied_salt, '\0', salt_len);

	return buffer;
}

/* This entry point is equivalent to crypt(3). */
char *
crypt_sha512(const char *key, const char *salt)
{
	/* We don't want to have an arbitrary limit in the size of the
	 * password. We can compute an upper bound for the size of the
	 * result in advance and so we can prepare the buffer we pass to
	 * `crypt_sha512_r'. */
	static char *buffer;
	static int buflen;
	int needed;
	char *new_buffer;

	needed = (sizeof(sha512_salt_prefix) - 1
	      + sizeof(sha512_rounds_prefix) + 9 + 1
	      + strlen(salt) + 1 + 86 + 1);

	if (buflen < needed) {
		new_buffer = (char *)realloc(buffer, needed);

		if (new_buffer == NULL)
			return NULL;

		buffer = new_buffer;
		buflen = needed;
	}

	return crypt_sha512_r(key, salt, buffer, buflen);
}
/* END: https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt-sha512.c */


/** From https://github.com/freebsd/freebsd/blob/master/lib/libcrypt/crypt.c */
static const struct crypt_format {
	const char* const name;
	const char* const magic;
	char* (*const func)(char const*, char const*);
} crypt_formats[] = {
	{ "des", "_", crypt_des },
	{ "md5", "$1$", crypt_md5 },
	{ "sha256", "$5$", crypt_sha256 },
	{ "sha512", "$6$", crypt_sha512 },
	{ NULL,	NULL, NULL }
};


char* crypt(const char* key, const char* salt)
{
	size_t len;
	const struct crypt_format *cf;

	for (cf = crypt_formats; cf->name != NULL; ++cf) {
		if (cf->magic != NULL && strstr(salt, cf->magic) == salt) {
			return cf->func(key, salt);
		}
	}

	len = strlen(salt);
	if ((len == 13 || len == 2) && strspn(salt, DES_SALT_ALPHABET) == len) {
		return (crypt_des(key, salt));
	}

	return crypt_formats[0].func(key, salt);
}
