TERMUX_PKG_HOMEPAGE=https://libwebsockets.org
TERMUX_PKG_DESCRIPTION="Lightweight C websockets library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=3.2.99.1
TERMUX_PKG_SHA256=c0964b19cdd0311834352235216226298685b3bdf80b337c63db53fca686c284
TERMUX_PKG_SRCURL=https://github.com/warmcat/libwebsockets/archive/216abea32c4f281632c2e45800acc26c1483c4a0.zip
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="libwebsockets-dev"
TERMUX_PKG_REPLACES="libwebsockets-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLWS_WITHOUT_TESTAPPS=ON -DLWS_WITH_STATIC=OFF"
TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"

termux_step_pre_configure() {
	# For syslog():
	LDFLAGS+=" -llog"
}
