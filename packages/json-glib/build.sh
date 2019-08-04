TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.4.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=720c5f4379513dc11fd97dc75336eb0c0d3338c53128044d9fabec4374f4bc47
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/json-glib/${TERMUX_PKG_VERSION:0:3}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BREAKS="json-glib-dev"
TERMUX_PKG_REPLACES="json-glib-dev"
TERMUX_PKG_RM_AFTER_INSTALL="
share/installed-tests
libexec/installed-tests
bin/
"

termux_step_pre_configure() {
	# Remove configure wrapper around meson build which prevents
	# meson setup in termux_step_configure.
	rm configure
}
