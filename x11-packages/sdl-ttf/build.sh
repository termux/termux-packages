TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_ttf
TERMUX_PKG_DESCRIPTION="A companion library to SDL for working with TrueType (tm) fonts"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@Yonle"
TERMUX_PKG_VERSION=2.0.11
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7
TERMUX_PKG_DEPENDS="freetype, sdl"

termux_step_pre_configure() {
	LDFLAGS="${LDFLAGS/-Wl,--as-needed/} -lm"
}
