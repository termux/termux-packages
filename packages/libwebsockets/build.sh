TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.3"
TERMUX_PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6fd33527b410a37ebc91bb64ca51bdabab12b076bc99d153d7c5dd405e4bdf90
TERMUX_PKG_DEPENDS="openssl, libcap, libuv, zlib"
TERMUX_PKG_BREAKS="libwebsockets-dev"
TERMUX_PKG_REPLACES="libwebsockets-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLWS_WITHOUT_TESTAPPS=ON
-DLWS_WITH_STATIC=OFF
-DLWS_WITH_LIBUV=ON
-DLWS_WITHOUT_EXTENSIONS=OFF
-DLWS_BUILD_HASH=no_hash
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=19

	local v=$(sed -En 's/^set\(SOVERSION\s+"?([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
