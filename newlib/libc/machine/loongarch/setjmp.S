#include "machine/asm.h"

#define GPR_COUNT 13
/* Align up for FPR to avoid unaligned access on grlen == 32 & frlen == 64.
 * ALIGN_UP requires power-of-two align values.
 */
#define ALIGN_UP(x, align) (((x) + (align) - 1) & ~((align) - 1))
#ifdef __loongarch_soft_float
#define FR_OFFSET (GPR_COUNT * SZREG)
#else
#define FR_OFFSET ALIGN_UP((GPR_COUNT * SZREG), SZFREG)
#endif
#define GPR_LAYOUT			\
	GPR_OFFSET (ra, 0);		\
	GPR_OFFSET (sp, 1);		\
	GPR_OFFSET (x, 2);		\
	GPR_OFFSET (fp, 3);		\
	GPR_OFFSET (s0, 4);		\
	GPR_OFFSET (s1, 5);		\
	GPR_OFFSET (s2, 6);		\
	GPR_OFFSET (s3, 7);		\
	GPR_OFFSET (s4, 8);		\
	GPR_OFFSET (s5, 9);		\
	GPR_OFFSET (s6, 10);		\
	GPR_OFFSET (s7, 11);		\
	GPR_OFFSET (s8, 12);

#define FPR_LAYOUT			\
	FPR_OFFSET (fs0, 0);		\
	FPR_OFFSET (fs1, 1);		\
	FPR_OFFSET (fs2, 2);		\
	FPR_OFFSET (fs3, 3);		\
	FPR_OFFSET (fs4, 4);		\
	FPR_OFFSET (fs5, 5);		\
	FPR_OFFSET (fs6, 6);		\
	FPR_OFFSET (fs7, 7);

/* int setjmp (jmp_buf);  */
LEAF_NO_ALIGN(setjmp)
#define GPR_OFFSET(NAME, OFFS) REG_S NAME, a0, OFFS * SZREG
#ifndef __loongarch_soft_float
#define FPR_OFFSET(NAME, OFFS) FREG_S NAME, a0, FR_OFFSET + OFFS * SZFREG
#else
#define FPR_OFFSET(NAME, OFFS)
#endif
	GPR_LAYOUT
#ifndef __loongarch_soft_float
	FPR_LAYOUT
#endif
#undef  GPR_OFFSET
#undef  FPR_OFFSET
	move     a0, zero
	jr       ra
END(setjmp)

LEAF_NO_ALIGN(longjmp)
#define GPR_OFFSET(NAME, OFFS) REG_L NAME, a0, OFFS * SZREG
#ifndef __loongarch_soft_float
#define FPR_OFFSET(NAME, OFFS) FREG_L NAME, a0, FR_OFFSET + OFFS * SZFREG
#else
#define FPR_OFFSET(NAME, OFFS)
#endif
	GPR_LAYOUT
#ifndef __loongarch_soft_float
	FPR_LAYOUT
#endif
#undef  GPR_OFFSET
#undef  FPR_OFFSET
	sltui	a0, a1, 1
	ADD	a0, a0, a1   # return (a1 == 0) ? 1 : a1
	jr      ra
END(longjmp)
