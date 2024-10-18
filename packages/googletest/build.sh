TERMUX_PKG_HOMEPAGE=https://github.com/google/googletest
TERMUX_PKG_DESCRIPTION="Google C++ testing framework"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.15.2"
TERMUX_PKG_SRCURL=https://github.com/google/googletest/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7b42b4d6ed48810c5362c265a17faebe90dc2373c885e5216439d37927f02926
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="libgtest"
TERMUX_PKG_REPLACES="libgtest"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1.15.2

	local v=$(sed -En 's/^set\(GOOGLETEST_VERSION\s+([0-9.]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
