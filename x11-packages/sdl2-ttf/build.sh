TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_ttf
TERMUX_PKG_DESCRIPTION="A library that allows you to use TrueType fonts in your SDL applications (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20.2
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_ttf/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9dc71ed93487521b107a2c4a9ca6bf43fb62f6bddd5c26b055e6b91418a22053
TERMUX_PKG_DEPENDS="freetype, opengl, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-freetype-builtin
--disable-harfbuzz
"
