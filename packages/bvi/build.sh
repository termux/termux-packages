TERMUX_PKG_HOMEPAGE=http://bvi.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Binary file editor based on vi"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SRCURL=http://sourceforge.net/projects/bvi/files/bvi/${TERMUX_PKG_VERSION}/bvi-${TERMUX_PKG_VERSION}.src.tar.gz
TERMUX_PKG_SHA256=4bba16c2b496963a9b939336c0abcc8d488664492080ae43a86da18cf4ce94f2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_ncursesw6_addnwstr=yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"
