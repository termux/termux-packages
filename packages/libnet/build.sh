TERMUX_PKG_HOMEPAGE=https://github.com/libnet/libnet
TERMUX_PKG_DESCRIPTION="A library which provides API for commonly used low-level net functions"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libnet/libnet/releases/download/v$TERMUX_PKG_VERSION/libnet-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad1e2dd9b500c58ee462acd839d0a0ea9a2b9248a1287840bc601e774fb6b28f
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=9

	local e=$(sed -En 's/^libnet_la_LDFLAGS\s*=.*\s+-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			src/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
