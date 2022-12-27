TERMUX_PKG_HOMEPAGE=https://github.com/martinh/libconfuse
TERMUX_PKG_DESCRIPTION="Small configuration file parser library for C"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3
TERMUX_PKG_SRCURL=https://github.com/martinh/libconfuse/releases/download/v$TERMUX_PKG_VERSION/confuse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3a59ded20bc652eaa8e6261ab46f7e483bc13dad79263c15af42ecbb329707b8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libconfuse-dev"
TERMUX_PKG_REPLACES="libconfuse-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local e=$(sed -En 's/^libconfuse_la_LDFLAGS\s*=.*\s+-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			src/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
