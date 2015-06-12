TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/teseq/
TERMUX_PKG_DESCRIPTION="Tool for analyzing control characters and terminal control sequences"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/teseq/teseq-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="teseq_cv_vsnprintf_works=yes ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
