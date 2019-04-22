TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=db948be74c78fc13f1f1a55e76707d7baae3a1c8f62b625f639e8f2736298324
TERMUX_PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLWS_WITHOUT_TESTAPPS=ON -DLWS_WITH_STATIC=OFF"
TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"

termux_step_pre_configure() {
	# For syslog():
	LDFLAGS+=" -llog"
}
