TERMUX_PKG_HOMEPAGE=http://www.openimageio.org/
TERMUX_PKG_DESCRIPTION="A library for reading and writing images, including classes, utilities, and applications"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.9.0
TERMUX_PKG_SRCURL=https://github.com/OpenImageIO/oiio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d04c12575d63d13ed64fc037ea37da616224736213d785de9f50337f6eb5a9ed
TERMUX_PKG_DEPENDS="openexr, boost-headers, openjpeg, glew, libtiff, opencolorio, libwebp, libpng, libheif, libhdf5, freetype, python, ffmpeg, opencv, ptex-static, qt5-qtbase, pybind11, libraw"
TERMUX_PKG_BUILD_DEPENDS="mesa, fontconfig, libxrender, robin-map, fmt, libpugixml"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_PYTHON=ON
-DPYTHON_VERSION=3.11
"
