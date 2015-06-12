TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_VERSION=6.2.1
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
