TERMUX_PKG_HOMEPAGE=https://github.com/any1/aml
TERMUX_PKG_DESCRIPTION="Andri's Main Loop library"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/any1/aml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b2b8f743213af39f40e8bc611147d69e2ea9e010b9b19cb65246582338f28d96
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
