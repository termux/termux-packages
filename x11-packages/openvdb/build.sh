TERMUX_PKG_HOMEPAGE=https://www.openvdb.org/
TERMUX_PKG_DESCRIPTION="Sparse volume data structure and tools"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="14.0.0"
TERMUX_PKG_SRCURL="https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2c38592a42a9dc1f3e9749418cc9d286d88ed912232dafee954ce5156174e5b0
TERMUX_PKG_DEPENDS="boost, imath, libblosc, libtbb, zlib"
TERMUX_PKG_BUILD_DEPENDS="mesa, glfw, glu"
TERMUX_PKG_AUTO_UPDATE=true
# Numpy support requires nanobind which is not packaged at time of writing
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DUSE_IMATH_HALF=ON
-DUSE_NUMPY=OFF
-DUSE_LOG4CPLUS=OFF
-DOPENVDB_BUILD_PYTHON_MODULE=OFF
-DOPENVDB_BUILD_DOCS=OFF
-DOPENVDB_BUILD_UNITTESTS=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=140

	local major_ver=$(sed -En 's/^set\(OpenVDB_MAJOR_VERSION\s+([0-9]+).*/\1/p' "$TERMUX_PKG_SRCDIR"/CMakeLists.txt)
	local minor_ver=$(sed -En 's/^set\(OpenVDB_MINOR_VERSION\s+([0-9]+).*/\1/p' "$TERMUX_PKG_SRCDIR"/CMakeLists.txt)

	if [[ "${major_ver}${minor_ver}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
