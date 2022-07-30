TERMUX_PKG_HOMEPAGE=https://github.com/libsdl-org/SDL_ttf
TERMUX_PKG_DESCRIPTION="A library that allows you to use TrueType fonts in your SDL applications (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL_ttf/releases/download/release-${TERMUX_PKG_VERSION}/SDL2_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=874680232b72839555a558b48d71666b562e280f379e673b6f0c7445ea3b9b8a
TERMUX_PKG_DEPENDS="freetype, mesa, sdl2"

termux_step_pre_configure() {
	./autogen.sh
}
