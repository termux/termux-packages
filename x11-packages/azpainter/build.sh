TERMUX_PKG_HOMEPAGE=https://gitlab.com/azelpg/azpainter
TERMUX_PKG_DESCRIPTION="Full color painting software for Unix-like systems for illustration drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:3.0.10"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://gitlab.com/azelpg/azpainter/-/archive/v${TERMUX_PKG_VERSION:2}/azpainter-${TERMUX_PKG_VERSION:2}.tar.bz2
TERMUX_PKG_SHA256=3bb0735333f16e233c8f5a85b619cd4e6aff132d3510c9a1d4f01166a6dc4b29
TERMUX_PKG_DEPENDS="fontconfig, freetype, libandroid-shmem, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, libx11, libxcursor, libxext, libxi, zlib"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS="-I$TERMUX_PKG_SRCDIR/src/include $CPPFLAGS"
}

termux_step_configure() {
	termux_setup_ninja
	./configure --prefix="$TERMUX_PREFIX" \
		CC="$CC" \
		CFLAGS="$CPPFLAGS $CFLAGS" \
		LDFLAGS="$LDFLAGS" \
		LIBS="-liconv -landroid-shmem -lz"
}

termux_step_make() {
	cd build
	ninja
}

termux_step_make_install() {
	cd build
	ninja install
}
