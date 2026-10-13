TERMUX_PKG_HOMEPAGE=https://imath.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Library for vector/matrix and math operations, plus the half type"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.3"
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e10c12b3f21f45bf08e09d4215d9c7691368d747beebd840de0b6fefed2df9f8
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="openexr2"
TERMUX_PKG_REPLACES="openexr2"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=30

	local v=$(sed -En 's/^set\(IMATH_LIB_SOVERSION ([0-9]+)\)/\1/p' \
		"$TERMUX_PKG_SRCDIR"/CMakeLists.txt)

	if [[ "${v}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
