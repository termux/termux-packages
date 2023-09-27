TERMUX_PKG_HOMEPAGE=https://github.com/silnrsi/graphite
TERMUX_PKG_DESCRIPTION="Font system for multiple languages"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.14
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/silnrsi/graphite/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a3b342c5681921ce2e0c2496509d30b5b078399d5a7bd2358f95166d57d91df
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libgraphite-dev"
TERMUX_PKG_REPLACES="libgraphite-dev"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gr2fonttest"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=3

	local v=$(sed -En 's/^set\(GRAPHITE_API_CURRENT\s+([0-9]+).*/\1/p' \
			src/CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
