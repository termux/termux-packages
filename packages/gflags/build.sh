TERMUX_PKG_HOMEPAGE=https://github.com/gflags/gflags
TERMUX_PKG_DESCRIPTION="A C++ library that implements commandline flags processing"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL="https://github.com/gflags/gflags/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f619a51371f41c0ad6837b2a98af9d4643b3371015d873887f7e8d3237320b2f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="gflags-dev"
TERMUX_PKG_REPLACES="gflags-dev"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBUILD_STATIC_LIBS=ON
-DBUILD_gflags_LIBS=ON
-DINSTALL_HEADERS=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2.3

	local _MAJOR=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	local _MINOR=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 2)
	local v=${_MAJOR}
	if [ "${_MAJOR}" == 2 ]; then
		v+=".${_MINOR}"
	fi
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_make_install() {
	#Any old packages using the library name of libgflags
	ln -sfr "$TERMUX_PREFIX"/lib/pkgconfig/gflags.pc \
		"$TERMUX_PREFIX"/lib/pkgconfig/libgflags.pc
}
