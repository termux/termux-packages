TERMUX_PKG_HOMEPAGE=http://bvi.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Binary file editor based on vi"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=http://sourceforge.net/projects/bvi/files/bvi/${TERMUX_PKG_VERSION}/bvi-${TERMUX_PKG_VERSION}.src.tar.gz
TERMUX_PKG_SHA256=3035255ca79e0464567d255baa5544f7794e2b7eb791dcc60cc339cf1aa01e28
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_ncursesw6_addnwstr=yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"
