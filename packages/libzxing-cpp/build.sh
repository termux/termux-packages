TERMUX_PKG_HOMEPAGE=https://github.com/zxing-cpp/zxing-cpp
TERMUX_PKG_DESCRIPTION="An open-source, multi-format 1D/2D barcode image processing library implemented in C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL="https://github.com/zxing-cpp/zxing-cpp/releases/download/v${TERMUX_PKG_VERSION}/zxing-cpp-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a3eb825154f05242283e7d94d8ebdcf95beb3a534eba393cce504e91c9b215bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DZXING_EXAMPLES=ON
-DZXING_BLACKBOX_TESTS=OFF
-DZXING_WRITERS=BOTH
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local _ver=$(sed -En 's/^set \(ZXING_SONAME\s+([0-9]+).*/\1/p' "$TERMUX_PKG_SRCDIR"/core/CMakeLists.txt)

	if [[ ! "${_ver}" ]] || [[ "${_ver}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
