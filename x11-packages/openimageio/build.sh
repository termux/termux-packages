TERMUX_PKG_HOMEPAGE=http://www.openimageio.org/
TERMUX_PKG_DESCRIPTION="A library for reading and writing images, including classes, utilities, and applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/OpenImageIO/oiio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6b62ceb83c8131ec49a999e0008750b52d98162d79265af47430cf83ed03ec0b
# configure-time error if ptex and ptex-static are not both installed
TERMUX_PKG_DEPENDS="boost, dcmtk, ffmpeg, fmt, freetype, glew, imath, libc++, libhdf5, libheif, libjpeg-turbo, libjxl, libpng, libraw, libtbb, libtiff, libwebp, libyaml-cpp, opencolorio, opencv, openexr, openjpeg, openvdb, ptex, pybind11, python, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, fontconfig, libjpeg-turbo-static, libpugixml, libxrender, mesa, ptex-static, robin-map"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_CXX_STANDARD=17
-DUSE_PYTHON=ON
-DINTERNALIZE_FMT=OFF
-DOIIO_BUILD_TOOLS=ON
-DOIIO_BUILD_TESTS=OFF
-DUSE_EXTERNAL_PUGIXML=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=31

	local v=$(sed -En 's/^set \(OpenImageIO_VERSION "([0-9]+.[0-9]+).*/\1/p' "$TERMUX_PKG_SRCDIR"/CMakeLists.txt)
	v="${v//./}"

	if [[ "${v}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
