TERMUX_PKG_HOMEPAGE=https://www.openttd.org/
TERMUX_PKG_DESCRIPTION="An engine for running Transport Tycoon Deluxe"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.9.1
TERMUX_PKG_SRCURL=https://github.com/OpenTTD/OpenTTD/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=af80c06e98ea8c96f74d188647f9dd04595ae34be92bd28823d4094ce0fc29e7
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
