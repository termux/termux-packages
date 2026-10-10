TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/dconf
TERMUX_PKG_DESCRIPTION="dconf is a simple key/value storage system that is heavily optimised for reading"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="51.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/dconf/${TERMUX_PKG_VERSION%.*}/dconf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e65c1b7867f836faad9f9ee04acf5c5a6cae2bbc784833fe093207e0cb590248
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, valac"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbash_completion=false
"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/systemd
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
