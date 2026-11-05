TERMUX_PKG_HOMEPAGE=https://github.com/benhoyt/inih
TERMUX_PKG_DESCRIPTION="A simple .INI file parser written in C"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="63"
TERMUX_PKG_SRCURL=https://github.com/benhoyt/inih/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d7967de62c5bfdc4f9f5ab06ce44c9e498bae021c7dac5792c0696e76aa9963
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(sed -En "s/.*'soversion'\s*:\s*'?([0-9]+).*/\1/p" meson.build)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
