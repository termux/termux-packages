TERMUX_PKG_HOMEPAGE=http://www.openimageio.org/
TERMUX_PKG_DESCRIPTION="A library for reading and writing images, including classes, utilities, and applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.9.0"
TERMUX_PKG_SRCURL="https://github.com/OpenImageIO/oiio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2618f024d33b03fd003ce272e9a2a78d3bffd4c78cf8a1a058a9def715bb8bc9
# configure-time error if ptex and ptex-static are not both installed
TERMUX_PKG_DEPENDS="boost, dcmtk, ffmpeg, fmt, freetype, glew, libc++, libhdf5, libheif, libjpeg-turbo, libjxl, libpng, libraw, libtbb, libtiff, libwebp, libyaml-cpp, opencolorio, opencv, openexr, openjpeg, openvdb, ptex, pybind11, python, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, fontconfig, libjpeg-turbo-static, libpugixml, libxrender, mesa, ptex-static, robin-map"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_STANDARD=17
-DUSE_PYTHON=ON
-DINTERNALIZE_FMT=OFF
-DOIIO_BUILD_TOOLS=ON
-DOIIO_BUILD_TESTS=OFF
-DUSE_EXTERNAL_PUGIXML=ON
"
