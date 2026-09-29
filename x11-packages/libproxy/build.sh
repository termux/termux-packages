TERMUX_PKG_HOMEPAGE="https://libproxy.github.io/"
TERMUX_PKG_DESCRIPTION="Automatic proxy configuration management library"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.12"
TERMUX_PKG_SRCURL="https://github.com/libproxy/libproxy/archive/refs/tags/${TERMUX_PKG_VERSION}/libproxy-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="a1fa55991998b80a567450a9e84382421a7176a84446c95caaa8b72cf09fa86f"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="curl, duktape, glib"
TERMUX_PKG_BUILD_DEPENDS="gsettings-desktop-schemas, g-ir-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dvapi=false
-Ddocs=false
-Dintrospection=false
"
