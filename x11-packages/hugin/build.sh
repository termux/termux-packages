TERMUX_PKG_HOMEPAGE=http://hugin.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Toolchain to create panoramic images for every occasion"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.0.1"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/hugin/hugin-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=7cf8eb33a6a8848cc7f816faf4bc88389228883d5513136dccb5cb243912ab79
TERMUX_PKG_DEPENDS="boost, enblend, exiftool, exiv2, fftw, glew, glu, imath, libc++, libflann, liblz4, libpano13, libsqlite, libtiff, libvigra, libx11, littlecms, openexr, opengl, wxwidgets"
# libjpeg-turbo, libpng and zlib are detected but not linked against
TERMUX_PKG_BUILD_DEPENDS="boost-headers, libjpeg-turbo, libpng, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DwxWidgets_CONFIG_EXECUTABLE=$TERMUX_PREFIX/bin/wx-config
-DDISABLE_DPKG=ON
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_GNU_SOURCE -Wno-deprecated-register -Wno-deprecated-declarations"
	LDFLAGS+=" -fopenmp -static-openmp -Wl,-rpath=$TERMUX_PREFIX/lib/hugin"
}
