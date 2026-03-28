#ifndef _LOONGARCH_ASM_H
#define _LOONGARCH_ASM_H

#include <machine/regdef.h>

#if __loongarch_grlen == 64
# define SZREG  8
# define REG_L ld.d
# define REG_S st.d
# define ADDI  addi.d
# define ADD   add.d
# define SUB   sub.d
# define LI    li.d
# define BSTRINS bstrins.d
#elif __loongarch_grlen == 32
# define SZREG  4
# define REG_L ld.w
# define REG_S st.w
# define ADDI  addi.w
# define ADD   add.w
# define SUB   sub.w
# define LI    li.w
# define BSTRINS bstrins.w
#else
# error __loongarch_grlen must equal 32 or 64
#endif

#ifndef __loongarch_soft_float
# if defined(__loongarch_single_float)
#  define SZFREG 4
#  define FREG_L fld.s
#  define FREG_S fst.s
# elif defined(__loongarch_double_float)
#  define SZFREG 8
#  define FREG_L fld.d
#  define FREG_S fst.d
# else
#  error unsupported __loongarch_frlen
# endif
#endif

/* Declare leaf routine.  */
#define LEAF_NO_ALIGN(symbol)           \
        .text;                          \
        .globl  symbol;                 \
        .type   symbol, @function;      \
symbol:

/* Mark end of function.  */
#undef END
#define END(function)                   \
        .size   function,.-function;

#endif
