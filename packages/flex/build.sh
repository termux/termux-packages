TERMUX_PKG_HOMEPAGE=http://flex.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Fast lexical analyser generator"
TERMUX_PKG_VERSION=2.5.39
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/flex/flex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
