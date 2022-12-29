TERMUX_PKG_HOMEPAGE=https://github.com/lipnitsk/libcue/
TERMUX_PKG_DESCRIPTION="CUE Sheet Parser Library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lipnitsk/libcue/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f27bc3ebb2e892cd9d32a7bee6d84576a60f955f29f748b9b487b173712f1200
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libcue-dev"
TERMUX_PKG_REPLACES="libcue-dev"
# To avoid picking up cross-compiled flex and bison:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=$(command -v bison)
-DFLEX_EXECUTABLE=$(command -v flex)
-DBUILD_SHARED_LIBS=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local v=$(sed -En 's/^SET\(PACKAGE_SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
