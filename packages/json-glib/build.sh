TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=2d7709a44749c7318599a6829322e081915bdc73f5be5045882ed120bb686dc8
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/json-glib/${TERMUX_PKG_VERSION:0:3}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_DEVPACKAGE_DEPENDS="glib-dev"
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
