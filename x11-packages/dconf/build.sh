TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/dconf
TERMUX_PKG_DESCRIPTION="dconf is a simple key/value storage system that is heavily optimised for reading"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.49.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/dconf/${TERMUX_PKG_VERSION%.*}/dconf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=16a47e49a58156dbb96578e1708325299e4c19eea9be128d5bd12fd0963d6c36
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
