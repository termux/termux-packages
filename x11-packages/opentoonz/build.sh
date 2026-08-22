TERMUX_PKG_HOMEPAGE=https://opentoonz.github.io
TERMUX_PKG_DESCRIPTION="OpenToonz - An open-source full-featured 2D animation creation software"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="../../LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/opentoonz/opentoonz/archive/refs/tags/v${TERMUX_PKG_VERSION}/opentoonz-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4bfcc012cac5f52358250ba5b6aaffb9311760377d4bfd6a542d4e2b71d1e05e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, freeglut, freetype, glew, glu, hicolor-icon-theme, libandroid-execinfo, libc++, libjpeg-turbo, liblz4, liblzma, liblzo, libmypaint, libopenblas, libpng, libtiff, libusb, mesa, opencv, qt5-qtbase, qt5-qtmultimedia, qt5-qtscript, qt5-qtserialport, qt5-qtsvg, qt5-qttools, superlu, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_SUGGESTS="rhubarb-lip-sync, iwawarper, kumoworks"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_SYSTEM_LZO=ON
-DWITH_SYSTEM_SUPERLU=ON
-DWITH_CANON=OFF
-DWITH_WINTAB=OFF
-DEXECINFO_LIBRARY=$TERMUX_PREFIX/lib/libandroid-execinfo.so
"

termux_step_pre_configure() {
	# based on https://gitlab.archlinux.org/archlinux/packaging/packages/opentoonz/-/blob/61cb4411cce181d760564b5021ed4abfb3778294/PKGBUILD#L76
	cd "$TERMUX_PKG_SRCDIR"
	pushd thirdparty
	rm -rf boost glew glut libjpeg-turbo libmypaint libpng-1.6.21 libusb lz4 superlu tiff-4.0.3 zlib-1.2.8 lzo
	popd

	TERMUX_PKG_SRCDIR+="/toonz/sources"
	CFLAGS+=" -DLINUX"
	CXXFLAGS+=" -DLINUX"

	# The libraries install to lib/opentoonz, but only the opentoonz wrapper
	# script exports LD_LIBRARY_PATH. tcomposer, tcleanup, tconverter,
	# tfarmcontroller and tfarmserver install as bare ELFs and cannot find
	# them, so put the directory in their RUNPATH.
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/opentoonz"
}
