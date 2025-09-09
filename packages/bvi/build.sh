TERMUX_PKG_HOMEPAGE=https://bvi.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Binary file editor based on vi"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION="1.5.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://sourceforge.net/projects/bvi/files/bvi/${TERMUX_PKG_VERSION}/bvi-${TERMUX_PKG_VERSION}.src.tar.gz
TERMUX_PKG_SHA256=6540716a1a3b2b9711635108da14b26baea488881d4a682121c0bddbba6b74cb
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_ncursesw6_addnwstr=yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"
