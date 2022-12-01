TERMUX_PKG_HOMEPAGE=https://github.com/google/re2
TERMUX_PKG_DESCRIPTION="A regular expression library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.12.01
TERMUX_PKG_SRCURL=https://github.com/google/re2/archive/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=665b65b6668156db2b46dddd33405cd422bd611352c5052ab3dae6a5fbac5506
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=10

	local v=$(sed -E -n 's/^SONAME=([0-9]+)$/\1/p' Makefile)
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "Error: SOVERSION guard check failed."
	fi
}
