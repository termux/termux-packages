TERMUX_PKG_HOMEPAGE=https://github.com/martanne/dvtm
TERMUX_PKG_DESCRIPTION="Terminal tiling window manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.15
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/martanne/dvtm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=496eada13d8abaa8d772279746f78b0c6fed11b560599490f3e70ebc21197bf0
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -ltinfow"
}
