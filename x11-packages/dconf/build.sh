TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/dconf
TERMUX_PKG_DESCRIPTION="dconf is a simple key/value storage system that is heavily optimised for reading"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.40.0"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/dconf/-/archive/${TERMUX_PKG_VERSION}/dconf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c144c314a5ab1b0e2c2e5cb381658d19b9577511b62db5df3fac463028b61bca
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbash_completion=false
-Dvapi=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
