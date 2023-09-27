TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/broguegame/
TERMUX_PKG_DESCRIPTION="Roguelike dungeon crawling game (community edition)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12
TERMUX_PKG_SRCURL=https://github.com/tmewett/BrogueCE/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aeed3f6ca0f4e352137b0196e9dddbdce542a9e99dda9effd915e018923cd428
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
