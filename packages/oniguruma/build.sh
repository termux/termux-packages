TERMUX_PKG_HOMEPAGE=https://github.com/kkos/oniguruma
TERMUX_PKG_DESCRIPTION="Regular expressions library"
TERMUX_PKG_VERSION="6.9.10"
TERMUX_PKG_SRCURL=https://github.com/kkos/oniguruma/releases/download/v$TERMUX_PKG_VERSION/onig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2a5cfc5ae259e4e97f86b68dfffc152cdaffe94e2060b770cb827238d769fc05
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
