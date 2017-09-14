TERMUX_PKG_HOMEPAGE=https://gitlab.com/psmisc/psmisc
TERMUX_PKG_DESCRIPTION="Some small useful utilities that use the proc filesystem"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=22.21
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/psmisc/psmisc/psmisc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=97323cad619210845b696d7d722c383852b2acb5c49b5b0852c4f29c77a8145a
TERMUX_PKG_RM_AFTER_INSTALL="bin/pstree.x11"
