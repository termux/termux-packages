TERMUX_PKG_HOMEPAGE=https://libnice.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GLib ICE implementation (STUN/TURN)"
TERMUX_PKG_LICENSE="Mozilla-1.1, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING.MPL, COPYING.LGPL"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.1.24"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/libnice/libnice/-/archive/${TERMUX_PKG_VERSION}/libnice-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1da5ac13ed5d4e175e0d2d46ad3748c6635244f8f3eb2b8e31578ef59aa2ddce
TERMUX_PKG_DEPENDS="glib, openssl"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
# gupnp-igd is not packaged: UPnP discovery stays off, STUN/TURN unaffected.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcrypto-library=openssl
-Dexamples=disabled
-Dgstreamer=enabled
-Dgupnp=disabled
-Dintrospection=enabled
-Dtests=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
