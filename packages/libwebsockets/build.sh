TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.0"
TERMUX_PKG_SRCURL="https://github.com/warmcat/libwebsockets/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9acbba00aaa9e6178ae09c6f920d95449b527c1417e81d2cdd4103bc6d64d13f
TERMUX_PKG_DEPENDS="openssl, libcap, libuv, zlib"
TERMUX_PKG_BREAKS="libwebsockets-dev"
TERMUX_PKG_REPLACES="libwebsockets-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DDISABLE_WERROR=ON
-DLWS_WITHOUT_TESTAPPS=ON
-DLWS_WITH_HTTP3=OFF
-DLWS_WITH_SOCKS5=ON
-DLWS_WITH_STATIC=OFF
-DLWS_WITH_LIBUV=ON
-DLWS_WITH_SYS_ASYNC_DNS=OFF
-DLWS_WITHOUT_EXTENSIONS=OFF
-DLWS_BUILD_HASH=no_hash
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"
TERMUX_PKG_AUTO_UPDATE=true
# Upstream started making a ton of tags with non-standard versions like:
# `sai-9e1c70ac4` this messes with the regex update method, so use repology.
TERMUX_PKG_UPDATE_METHOD="repology"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=23

	local v
	v="$(sed -En 's/^set\(SOVERSION\s+"?([0-9]+).*/\1/p' CMakeLists.txt)"
	if [[ "${v}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed. Expected ${_SOVERSION}, got ${v}."
	fi
}
