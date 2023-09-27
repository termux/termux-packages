TERMUX_PKG_HOMEPAGE=https://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration adventure game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.4
TERMUX_PKG_SHA256=8cf30b0f5c4d096e18a2896b81e5a8fa82215ebdcd3037502673fb70a6c30779
TERMUX_PKG_SRCURL=https://github.com/angband/angband/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-x11
--bindir=$TERMUX_PREFIX/bin
--sysconfdir=$TERMUX_PREFIX/share/angband
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/angband/fonts
share/angband/icons
share/angband/sounds
share/angband/xtra
"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure () {
	./autogen.sh
	perl -p -i -e 's|ncursesw5-config|ncursesw6-config|g' configure
}
