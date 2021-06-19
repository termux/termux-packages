TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_ttf
TERMUX_PKG_DESCRIPTION="A library that allows you to use TrueType fonts in your SDL applications (version 2)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING.txt"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.0.15
TERMUX_PKG_REVISION=22
TERMUX_PKG_SRCURL=https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a9eceb1ad88c1f1545cd7bd28e7cbc0b2c14191d40238f531a15b01b1b22cd33
TERMUX_PKG_DEPENDS="freetype, mesa, sdl2"

termux_step_pre_configure() {
	./autogen.sh
}
