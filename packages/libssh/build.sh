TERMUX_PKG_HOMEPAGE=https://www.libssh.org/
TERMUX_PKG_DESCRIPTION="Tiny C SSH library"
TERMUX_PKG_LICENSE="LGPL-2.1, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="BSD, COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL=https://www.libssh.org/files/${TERMUX_PKG_VERSION%.*}/libssh-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=1a6af424d8327e5eedef4e5fe7f5b924226dd617ac9f3de80f217d82a36a7121
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_BREAKS="libssh-dev"
TERMUX_PKG_REPLACES="libssh-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAVE_ARGP_H=OFF
-DWITH_GSSAPI=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local _ver=$(sed -En 's/^set\(LIBRARY_SOVERSION "([0-9]+)".*/\1/p' "$TERMUX_PKG_SRCDIR"/CMakeLists.txt)

	if [[ ! "${_ver}" ]] || [[ "${_ver}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
}
