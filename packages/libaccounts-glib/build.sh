TERMUX_PKG_HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-glib"
TERMUX_PKG_DESCRIPTION="Glib-based client library for accessing the online accounts database"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.27"
TERMUX_PKG_SRCURL="https://gitlab.com/accounts-sso/libaccounts-glib/-/archive/VERSION_${TERMUX_PKG_VERSION}/libaccounts-glib-VERSION_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="a8407a5897a2e425ea1aa955ecf88485dd2fd417919de275b27c781a5d0637a5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="VERSION_\d+.\d+"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/VERSION_//"
TERMUX_PKG_DEPENDS="glib, libc++, libxml2, sqlite"
TERMUX_PKG_BUILD_DEPENDS="check, g-ir-scanner, glib, gobject-introspection, valac"

termux_step_pre_configure() {
	termux_setup_gir
}
