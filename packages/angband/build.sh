TERMUX_PKG_HOMEPAGE=http://rephial.org/
TERMUX_PKG_DESCRIPTION="Dungeon exploration adventure game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.2
TERMUX_PKG_SHA256=433efe76a4a2741439542235316c098740aa4a72e4245523eb4781345a112d70
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

termux_step_pre_configure () {
	./autogen.sh
	perl -p -i -e 's|ncursesw5-config|ncursesw6-config|g' configure
}
