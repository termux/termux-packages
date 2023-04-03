TERMUX_PKG_HOMEPAGE=https://github.com/rockdaboot/libpsl
TERMUX_PKG_DESCRIPTION="Public Suffix List library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.2"
TERMUX_PKG_SRCURL=https://github.com/rockdaboot/libpsl/releases/download/${TERMUX_PKG_VERSION}/libpsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e35991b6e17001afa2c0ca3b10c357650602b92596209b7492802f3768a6285f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libidn2, libunistring"
TERMUX_PKG_BREAKS="libpsl-dev"
TERMUX_PKG_REPLACES="libpsl-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local e=$(sed -En 's/^([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			libtool_version_info.txt)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fiv
}
