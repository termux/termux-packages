TERMUX_PKG_HOMEPAGE="https://libproxy.github.io/"
TERMUX_PKG_DESCRIPTION="Automatic proxy configuration management library"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.11"
TERMUX_PKG_SRCURL="https://github.com/libproxy/libproxy/archive/${TERMUX_PKG_VERSION}/libproxy-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="b364f4dbbffc5bdf196330cb76b48abcb489f38b1543e67595ca6cb7ec45d265"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="curl, duktape, glib"
TERMUX_PKG_BUILD_DEPENDS="gsettings-desktop-schemas, g-ir-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dvapi=false
-Ddocs=false
-Dintrospection=false
"
