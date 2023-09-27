TERMUX_PKG_HOMEPAGE=https://openzim.org
TERMUX_PKG_DESCRIPTION="The ZIM library is the reference implementation for the ZIM file format."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.2.1"
TERMUX_PKG_SRCURL=https://github.com/openzim/libzim/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b8296644b04b02c04d2ff1458fed829df39b54e8fd1bcd23c10440e160819f13
TERMUX_PKG_DEPENDS="libc++, libicu, liblzma, libxapian, zstd"
TERMUX_PKG_BUILD_DEPENDS="googletest, libuuid"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=8

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
