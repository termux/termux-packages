TERMUX_PKG_HOMEPAGE=http://www.digip.org/jansson/
TERMUX_PKG_DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/akheron/jansson/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=979210eaffdffbcf54cfc34d047fccde13f21b529a381df26db871d886f729a4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libjansson-dev"
TERMUX_PKG_REPLACES="libjansson-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local e=$(sed -n '/^libjansson_la_LDFLAGS/,/^[^\t]/p' src/Makefile.am | \
			sed -En 's/\s*-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p')
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}
