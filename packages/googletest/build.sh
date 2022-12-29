TERMUX_PKG_HOMEPAGE=https://github.com/google/googletest
TERMUX_PKG_DESCRIPTION="Google C++ testing framework"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/google/googletest/archive/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81964fe578e9bd7c94dfdb09c8e4d6e6759e19967e397dbea48d1c10e45d0df2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="libgtest"
TERMUX_PKG_REPLACES="libgtest"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1.12.1

	local v=$(sed -En 's/^set\(GOOGLETEST_VERSION\s+([0-9.]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
