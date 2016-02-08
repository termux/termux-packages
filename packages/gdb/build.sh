TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gdb/
TERMUX_PKG_DESCRIPTION="The standard GNU Debugger that runs on many Unix-like systems and works for many programming languages"
TERMUX_PKG_DEPENDS="liblzma, libexpat, readline"
TERMUX_PKG_VERSION=7.10.1
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/gdb/gdb-${TERMUX_PKG_VERSION}.tar.xz
# gdb can not build with our normal --disable-static: https://sourceware.org/bugzilla/show_bug.cgi?id=15916
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-readline --with-curses --enable-static ac_cv_func_getpwent=no ac_cv_func_getpwnam=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/gdb/python share/gdb/syscalls share/gdb/system-gdbinit"

TERMUX_PKG_MAKE_INSTALL_TARGET="-C gdb install"
TERMUX_PKG_BUILD_IN_SRC="yes"

# For frexp(3) usage:
LDFLAGS+=" -lm"
