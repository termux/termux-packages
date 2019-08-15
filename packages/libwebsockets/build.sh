TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SHA256=5e731c536a20d9c03ae611631db073f05cd77bf0906a8c30d2a13638d4c8c667
TERMUX_PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="libwebsockets-dev"
TERMUX_PKG_REPLACES="libwebsockets-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLWS_WITHOUT_TESTAPPS=ON -DLWS_WITH_STATIC=OFF"
TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"

termux_step_pre_configure() {
	# For syslog():
	LDFLAGS+=" -llog"
}
