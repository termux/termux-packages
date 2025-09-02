TERMUX_PKG_HOMEPAGE=https://github.com/JuliaLang/utf8proc
TERMUX_PKG_DESCRIPTION="Library for processing UTF-8 Unicode data"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/JuliaLang/utf8proc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f4f1b639daa6dca9f80bc5db1233e9cbaa31a67790887106160b33ef743f136
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
