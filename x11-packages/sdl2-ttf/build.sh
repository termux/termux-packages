TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_ttf
TERMUX_PKG_DESCRIPTION="A library that allows you to use TrueType fonts in your SDL applications (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20.1
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_ttf/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=78cdad51f3cc3ada6932b1bb6e914b33798ab970a1e817763f22ddbfd97d0c57
TERMUX_PKG_DEPENDS="freetype, opengl, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-freetype-builtin
--disable-harfbuzz
"
