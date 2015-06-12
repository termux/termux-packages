TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/bison/
TERMUX_PKG_DESCRIPTION="General-purpose parser generator"
TERMUX_PKG_VERSION=3.0.4
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/bison/bison-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
TERMUX_PKG_HOSTBUILD=true
