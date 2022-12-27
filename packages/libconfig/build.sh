TERMUX_PKG_HOMEPAGE=https://github.com/hyperrealm/libconfig
TERMUX_PKG_DESCRIPTION="C/C++ Configuration File Library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/hyperrealm/libconfig/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68757e37c567fd026330c8a8449aa5f9cac08a642f213f2687186b903bd7e94e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libconfig-dev"
TERMUX_PKG_REPLACES="libconfig-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=11

	local e=$(sed -En 's/^VERINFO\s*=\s*-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			lib/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}
