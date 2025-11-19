TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-keyring
TERMUX_PKG_DESCRIPTION="a collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.0"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gnome-keyring/-/archive/$TERMUX_PKG_VERSION/gnome-keyring-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=484ac615042be599ab34fc0ddc49a77ce790de628c2003805cf581cf0c3e7fd0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gcr"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=disabled
-Dpam=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
