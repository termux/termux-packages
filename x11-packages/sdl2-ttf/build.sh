TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_ttf
TERMUX_PKG_DESCRIPTION="A library that allows you to use TrueType fonts in your SDL applications (version 2)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0.14
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276
TERMUX_PKG_DEPENDS="freetype, mesa, sdl2"

termux_step_pre_configure() {
	./autogen.sh
}
