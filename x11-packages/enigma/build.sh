TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/enigma/
TERMUX_PKG_DESCRIPTION="Puzzle game inspired by Oxyd and Rock'n'Bolt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION=1.30
TERMUX_PKG_SRCURL="https://github.com/Enigma-Game/Enigma/releases/download/${TERMUX_PKG_VERSION}/Enigma-${TERMUX_PKG_VERSION}-src.tar.gz"
TERMUX_PKG_SHA256=ae64b91fbc2b10970071d0d78ed5b4ede9ee3868de2e6e9569546fc58437f8af
TERMUX_PKG_DEPENDS="enigma-data, gettext, libcurl, libenet, libiconv, sdl2 | sdl2-compat, sdl2-image, sdl2-mixer, sdl2-ttf, xerces-c, zlib"
TERMUX_PKG_BUILD_DEPENDS="pkg-config"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-enet"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -fi
	LDFLAGS+=" -liconv"
}
