TERMUX_PKG_HOMEPAGE=http://www.openimageio.org/
TERMUX_PKG_DESCRIPTION="A library for reading and writing images, including classes, utilities, and applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.6.2"
TERMUX_PKG_SRCURL="https://github.com/OpenImageIO/oiio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a1e515e6a6ea9925a70c23db21dda37f3ce2c24780a6bfedd8685fea063f698a
# configure-time error if ptex and ptex-static are not both installed
TERMUX_PKG_DEPENDS="boost, dcmtk, ffmpeg, fmt, freetype, glew, libc++, libhdf5, libheif, libjpeg-turbo, libjxl, libpng, libraw, libtbb, libtiff, libwebp, libyaml-cpp, opencolorio, opencv, openexr, openjpeg, openvdb, ptex, pybind11, python, qt6-qtbase"
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
