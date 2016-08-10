TERMUX_PKG_HOMEPAGE=http://hisham.hm/htop/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
TERMUX_PKG_DEPENDS="ncurses, libandroid-support"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SRCURL=http://hisham.hm/htop/releases/${TERMUX_PKG_VERSION}/htop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_ncursesw6_addnwstr=yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
export CPPFLAGS="$CPPFLAGS -isystem $TERMUX_PREFIX/include/libandroid-support"
export LDFLAGS="$LDFLAGS -landroid-support"
