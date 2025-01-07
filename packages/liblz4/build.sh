TERMUX_PKG_HOMEPAGE=https://lz4.github.io/lz4/
TERMUX_PKG_DESCRIPTION="Fast LZ compression algorithm library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_SRCURL=https://github.com/lz4/lz4/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="liblz4-dev"
TERMUX_PKG_REPLACES="liblz4-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local v=$(sed -En 's/^#define LZ4_VERSION_MAJOR +([0-9]+) +.*$/\1/p' \
			lib/lz4.h)
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=/build/cmake
}
