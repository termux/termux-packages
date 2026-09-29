TERMUX_PKG_HOMEPAGE=https://openimageio.org
TERMUX_PKG_DESCRIPTION="A library for reading and writing images, including classes, utilities, and applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.1.1"
TERMUX_PKG_SRCURL="https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3a959f90e80b866580e77c1c8577d12e54c8988264941eb5bbb1f3a7221020f0
# configure-time error if ptex and ptex-static are not both installed
TERMUX_PKG_DEPENDS="boost, dcmtk, ffmpeg, fmt, freetype, imath, libc++, libhdf5, libheif, libjpeg-turbo, libjxl, libpng, libraw, libtbb, libtiff, libwebp, libyaml-cpp, opencolorio, opencv, openexr, openjpeg, openvdb, ptex, pybind11, python, qt6-qtbase, libpugixml, dbus"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, fontconfig, libjpeg-turbo-static, libxrender, mesa, ptex-static, robin-map"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_CXX_STANDARD=17
-DUSE_PYTHON=ON
-DOIIO_PYTHON_BINDINGS_BACKEND=pybind11
-DINTERNALIZE_FMT=OFF
-DOIIO_BUILD_TOOLS=ON
-DOIIO_BUILD_TESTS=OFF
-DUSE_EXTERNAL_PUGIXML=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=32

	local v=$(sed -En 's/^set \(OpenImageIO_VERSION "([0-9]+.[0-9]+).*/\1/p' "$TERMUX_PKG_SRCDIR"/CMakeLists.txt)
	v="${v//./}"

	if [[ "${v}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	CXXFLAGS+=" -DFLT_MAX=__FLT_MAX__ -DDBL_MAX=__DBL_MAX__ -DFLT_EPSILON=__FLT_EPSILON__ -DDBL_EPSILON=__DBL_EPSILON__"
	# for code in openjph, which is downloaded by CMakeLists.txt of openexr at build-time
	if [[ "$TERMUX_PKG_API_LEVEL" -lt 28 ]]; then
		CPPFLAGS+=" -Daligned_alloc=memalign"
	fi
}

termux_step_post_make_install() {
	# OpenImageIO 3.2 preserves the 3.1 ABI despite changing SONAME.
	ln -s libOpenImageIO.so.3.2 "$TERMUX_PREFIX/lib/libOpenImageIO.so.3.1"
	ln -s libOpenImageIO_Util.so.3.2 "$TERMUX_PREFIX/lib/libOpenImageIO_Util.so.3.1"
}
