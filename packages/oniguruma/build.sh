TERMUX_PKG_HOMEPAGE=https://github.com/kkos/oniguruma
TERMUX_PKG_DESCRIPTION="Regular expressions library"
TERMUX_PKG_VERSION="6.9.8"
TERMUX_PKG_SRCURL=https://github.com/kkos/oniguruma/releases/download/v$TERMUX_PKG_VERSION/onig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=28cd62c1464623c7910565fb1ccaaa0104b2fe8b12bcd646e81f73b47535213e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local e=$(sed -En 's/^LTVERSION="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
