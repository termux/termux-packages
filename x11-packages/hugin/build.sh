TERMUX_PKG_HOMEPAGE=http://hugin.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Toolchain to create panoramic images for every occasion"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2021.0.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/hugin/hugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=047aea8a7fa47844b34ef27c19d3b697e84939dcb1fdbbeb2c204621b66eead9
TERMUX_PKG_DEPENDS="boost, enblend, exiftool, exiv2, fftw, glew, glu, libc++, libflann, libjpeg-turbo, liblz4, libpano13, libpng, libsqlite, libtiff, libvigra, libx11, littlecms, mesa, openexr, wxwidgets, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DwxWidgets_CONFIG_EXECUTABLE=$TERMUX_PREFIX/bin/wx-config
-DDISABLE_DPKG=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/hugin"
}
