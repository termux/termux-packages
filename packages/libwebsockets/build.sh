TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SHA256=cb0cdd8d0954fcfd97a689077568f286cdbb44111883e0a85d29860449c47cbf
TERMUX_PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLWS_WITHOUT_TESTAPPS=ON -DLWS_WITH_STATIC=OFF"
TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"

termux_step_pre_configure() {
	# For syslog():
	LDFLAGS+=" -llog"
}
