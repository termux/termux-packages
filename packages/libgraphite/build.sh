TERMUX_PKG_HOMEPAGE=https://github.com/silnrsi/graphite
TERMUX_PKG_DESCRIPTION="Font system for multiple languages"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.15"
TERMUX_PKG_SRCURL="https://github.com/silnrsi/graphite/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ad47ac120d0fbd80dbc93669afd1074fbbf68af8d1bedf936cf1a433c170f565
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
