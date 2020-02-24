TERMUX_PKG_HOMEPAGE=https://www.openttd.org/
TERMUX_PKG_DESCRIPTION="An engine for running Transport Tycoon Deluxe"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.9.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/OpenTTD/OpenTTD/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1bbbc65c226d9beaf7aa68d36593152c39563a4802c823eee4faec2cd07e2bc2
TERMUX_PKG_DEPENDS="desktop-file-utils, fontconfig, hicolor-icon-theme, libicu, liblzma, liblzo, libpng, openttd-gfx, openttd-msx, openttd-sfx, sdl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	CXXFLAGS+=" -DU_USING_ICU_NAMESPACE=1"

	./configure \
		--prefix-dir="$TERMUX_PREFIX" \
		--binary-name=openttd \
		--binary-dir=bin \
		--data-dir=share/openttd \
		--doc-dir=share/doc/openttd \
		--menu-name=OpenTTD
}
