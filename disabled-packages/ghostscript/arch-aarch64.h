/* Parameters derived from machine and compiler architecture. */
/* This file is generated mechanically by genarch.c. */

	 /* ---------------- Scalar alignments ---------------- */

#define ARCH_ALIGN_SHORT_MOD 2
#define ARCH_ALIGN_INT_MOD 4
#define ARCH_ALIGN_LONG_MOD 8
#define ARCH_ALIGN_PTR_MOD 8
#define ARCH_ALIGN_FLOAT_MOD 4
#define ARCH_ALIGN_DOUBLE_MOD 8

	 /* ---------------- Scalar sizes ---------------- */

#define ARCH_LOG2_SIZEOF_CHAR 0
#define ARCH_LOG2_SIZEOF_SHORT 1
#define ARCH_LOG2_SIZEOF_INT 2
#define ARCH_LOG2_SIZEOF_LONG 3
#define ARCH_LOG2_SIZEOF_LONG_LONG 3
#define ARCH_SIZEOF_GX_COLOR_INDEX 8
#define ARCH_SIZEOF_PTR 8
#define ARCH_SIZEOF_FLOAT 4
#define ARCH_SIZEOF_DOUBLE 8
#define ARCH_FLOAT_MANTISSA_BITS 24
#define ARCH_DOUBLE_MANTISSA_BITS 53

	 /* ---------------- Unsigned max values ---------------- */

#define ARCH_MAX_UCHAR ((unsigned char)0xff + (unsigned char)0)
#define ARCH_MAX_USHORT ((unsigned short)0xffff + (unsigned short)0)
#define ARCH_MAX_UINT ((unsigned int)~0 + (unsigned int)0)
#define ARCH_MAX_ULONG ((unsigned long)~0L + (unsigned long)0)

	 /* ---------------- Miscellaneous ---------------- */

#define ARCH_IS_BIG_ENDIAN 0
#define ARCH_PTRS_ARE_SIGNED 0
#define ARCH_FLOATS_ARE_IEEE 1
#define ARCH_ARITH_RSHIFT 2
#define ARCH_DIV_NEG_POS_TRUNCATES 1
