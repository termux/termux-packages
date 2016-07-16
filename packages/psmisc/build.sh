TERMUX_PKG_HOMEPAGE=http://psmisc.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Some small useful utilities that use the proc filesystem"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=22.21
TERMUX_PKG_SRCURL=http://heanet.dl.sourceforge.net/project/psmisc/psmisc/psmisc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_RM_AFTER_INSTALL="bin/pstree.x11"

CFLAGS+=" -DTERMUX_EXPOSE_MEMPCPY=1"
