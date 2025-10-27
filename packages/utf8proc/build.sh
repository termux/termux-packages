TERMUX_PKG_HOMEPAGE=https://github.com/JuliaLang/utf8proc
TERMUX_PKG_DESCRIPTION="Library for processing UTF-8 Unicode data"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL=https://github.com/JuliaLang/utf8proc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c24379b5fa0a429a1f9a3fc23b44a75f2b141a34c09146a529a55d20a5808070
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="utf8proc-dev"
TERMUX_PKG_REPLACES="utf8proc-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=3

	local v=$(sed -En 's/^MAJOR=([0-9]+).*/\1/p' Makefile)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/CMakeLists.txt
}
