TERMUX_PKG_HOMEPAGE=http://hisham.hm/htop/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
TERMUX_PKG_DEPENDS="ncurses, libandroid-support"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://hisham.hm/htop/releases/${TERMUX_PKG_VERSION}/htop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=179be9dccb80cee0c5e1a1f58c8f72ce7b2328ede30fb71dcdf336539be2f487
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_ncursesw6_addnwstr=yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"
