TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04244efb7a6438c8c6bfc79b21214db5950f72c9cf57e980af57ca321aae87b2
TERMUX_PKG_DEPENDS="openssl, libcap, libuv, zlib"
TERMUX_PKG_BREAKS="libwebsockets-dev"
TERMUX_PKG_REPLACES="libwebsockets-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
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
	local _SOVERSION=21

	local v=$(sed -En 's/^set\(SOVERSION\s+"?([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed. Expected ${_SOVERSION}, got ${v}."
	fi
}
