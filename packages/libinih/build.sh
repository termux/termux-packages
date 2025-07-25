TERMUX_PKG_HOMEPAGE=https://github.com/benhoyt/inih
TERMUX_PKG_DESCRIPTION="A simple .INI file parser written in C"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="61"
TERMUX_PKG_SRCURL=https://github.com/benhoyt/inih/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7caf26a2202a4ca689df3fe4175dfa74e0faa18fcca07331bba934fd0ecb8f12
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(sed -n "/library('inih'/,/)\s*$/p" meson.build | \
			sed -En "s/\s*soversion\s*:\s*'?([0-9]+).*/\1/p")
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
