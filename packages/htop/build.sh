TERMUX_PKG_HOMEPAGE=https://hisham.hm/htop/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=d9d6826f10ce3887950d709b53ee1d8c1849a70fa38e91d5896ad8cbc6ba3c57
TERMUX_PKG_SRCURL=http://hisham.hm/htop/releases/${TERMUX_PKG_VERSION}/htop-${TERMUX_PKG_VERSION}.tar.gz
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
TERMUX_PKG_DEPENDS="ncurses, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_ncursesw6_addnwstr=yes
LIBS=-landroid-support
"
