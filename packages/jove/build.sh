TERMUX_PKG_HOMEPAGE=https://directory.fsf.org/wiki/Jove
TERMUX_PKG_DESCRIPTION="Jove is a compact, powerful, Emacs-style text-editor."
TERMUX_PKG_LICENSE="GPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.3.7
TERMUX_PKG_SRCURL=https://github.com/jonmacs/jove/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b3918b94cc7fa973c7ebaf17cae25bf9643281ed4129265155abc3837ddf22bf
TERMUX_PKG_DEPENDS="ncurses, ncurses-utils"
TERMUX_PKG_BUILD_IN_SRC=true

#termux_step_make() {
#	make JOVEHOME=${TERMUX_PREFIX}  LOCALCC=clang LDFLAGS=@LDFLAGS@ SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500" TERMCAPLIB=" -L$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib -lncurses"
#}

#termux_step_make_install() {
#	make SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500" JOVEHOME=${TERMUX_PREFIX} MANDIR=${TERMUX_PREFIX}/share/man/man1 TERMCAPLIB=-lncurses install
#}
