TERMUX_PKG_HOMEPAGE="https://github.com/danfis/libccd"
TERMUX_PKG_DESCRIPTION="Library for collision detection between two convex shapes"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="BSD-LICENSE"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="2.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/danfis/libccd/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=542b6c47f522d581fbf39e51df32c7d1256ac0c626e7c2b41f1040d4b9d50d1e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag" # As of 2022-09-01T00:37:36 no github releases are available.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_DOCUMENTATION=ON
-DBUILD_SHARED_LIBS=ON
-DBUILD_TESTING=OFF
-DCMAKE_BUILD_TYPE=Release
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local v=$(sed -En 's/^set\(CCD_SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	# Use double-precision for 64-bit archs, otherwise use single-precision
	case "$TERMUX_ARCH" in
		"aarch64" |  "x86_64")
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DOUBLE_PRECISION=ON'
			;;
		"arm" | "i686")
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DOUBLE_PRECISION=OFF'
			;;
		*)
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DOUBLE_PRECISION=OFF'
			;;
	esac
}
