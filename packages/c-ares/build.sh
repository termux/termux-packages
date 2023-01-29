TERMUX_PKG_HOMEPAGE=https://c-ares.haxx.se
TERMUX_PKG_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.19.0
TERMUX_PKG_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=948016368481b6c5063b849b6dec2a7fd659eee2174b7f3db22ff1b22055ed2a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BREAKS="c-ares-dev"
TERMUX_PKG_REPLACES="c-ares-dev"
# Build with cmake to install cmake/c-ares/*.cmake files:
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local e=$(sed -En 's/^\s*SET\s*\(CARES_LIB_VERSIONINFO\s+"?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			CMakeLists.txt)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
