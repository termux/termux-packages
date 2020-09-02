TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/json-glib/${TERMUX_PKG_VERSION:0:3}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ad08438327b6106dc040c0581477bdf1cd3daaa5d285920cc768b8627f746666
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BREAKS="json-glib-dev"
TERMUX_PKG_REPLACES="json-glib-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false"
TERMUX_PKG_RM_AFTER_INSTALL="
share/installed-tests
libexec/installed-tests
bin/
"

termux_step_pre_configure() {
	#Remove configure wrapper around meson build which prevents
	# meson setup in termux_step_configure.
	rm configure
}
