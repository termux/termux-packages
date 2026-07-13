TERMUX_PKG_HOMEPAGE=https://github.com/rockdaboot/libpsl
TERMUX_PKG_DESCRIPTION="Public Suffix List library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.23.0"
TERMUX_PKG_SRCURL=https://github.com/rockdaboot/libpsl/releases/download/${TERMUX_PKG_VERSION}/libpsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f39b9631b3d369a21259ea4654f8875c0ec6995ce9551c0eb5d423e4c011f911
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
