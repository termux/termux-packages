TERMUX_PKG_HOMEPAGE=http://hugin.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Toolchain to create panoramic images for every occasion"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.0.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/hugin/hugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=97c8562a0ba9a743e0b955a43dfde048b1c60cd9e5f2ee2b69de1a81646e05a7
TERMUX_PKG_DEPENDS="boost, enblend, exiftool, exiv2, fftw, glew, glu, imath, libc++, libflann, libjpeg-turbo, liblz4, libpano13, libpng, libsqlite, libtiff, libvigra, libx11, littlecms, mesa, openexr, wxwidgets, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DwxWidgets_CONFIG_EXECUTABLE=$TERMUX_PREFIX/bin/wx-config
-DDISABLE_DPKG=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/hugin"
}
