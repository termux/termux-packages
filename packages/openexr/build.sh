TERMUX_PKG_HOMEPAGE=https://www.openexr.com/
TERMUX_PKG_DESCRIPTION="Provides the specification and reference implementation of the EXR file format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.5"
TERMUX_PKG_SRCURL="https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c31d62f76cec06f738d4521f4062b51977e3cf6fb2644a1d505de3d291d78e2d
TERMUX_PKG_DEPENDS="imath, libc++, zlib"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=34
	local v=$(sed -En 's/^set\(OPENEXR_LIB_SOVERSION\s+([0-9]+).*/\1/p' CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	# for code in openjph, which is downloaded by CMakeLists.txt of openexr at build-time
	if [[ "$TERMUX_PKG_API_LEVEL" -lt 28 ]]; then
		CPPFLAGS+=" -Daligned_alloc=memalign"
	fi
}

termux_step_post_massage() {
	shopt -s nullglob
	local f
	for f in lib/libImath*; do
		termux_error_exit "File ${f} should not be contained in this package."
	done
	shopt -u nullglob
}
