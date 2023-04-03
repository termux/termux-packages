TERMUX_PKG_HOMEPAGE=https://github.com/libnet/libnet
TERMUX_PKG_DESCRIPTION="A library which provides API for commonly used low-level net functions"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libnet/libnet/releases/download/v$TERMUX_PKG_VERSION/libnet-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=caa4868157d9e5f32e9c7eac9461efeff30cb28357f7f6bf07e73933fb4edaa7
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
