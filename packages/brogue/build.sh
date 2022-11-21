TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/broguegame/
TERMUX_PKG_DESCRIPTION="Roguelike dungeon crawling game (community edition)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.1
TERMUX_PKG_SRCURL=https://github.com/tmewett/BrogueCE/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc562cf774f88b12b6aeebdac5a00e62e8598b3f84da2130a54a67a60c5debf2
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure () {
	CFLAGS+=" -fcommon"
	CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS"
}

termux_step_make_install () {
	install -m700 bin/brogue $TERMUX_PREFIX/bin
}
