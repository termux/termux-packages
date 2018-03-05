TERMUX_PKG_HOMEPAGE=http://hisham.hm/htop/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
TERMUX_PKG_DEPENDS="ncurses, libandroid-support"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=http://hisham.hm/htop/releases/${TERMUX_PKG_VERSION}/htop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3260be990d26e25b6b49fc9d96dbc935ad46e61083c0b7f6df413e513bf80748
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_ncursesw6_addnwstr=yes
LIBS=-landroid-support
"
