TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-keyring
TERMUX_PKG_DESCRIPTION="a collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="51.1"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gnome-keyring/-/archive/$TERMUX_PKG_VERSION/gnome-keyring-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9270758f0c9a335c5ab6639f513dc1f47df8e5d098c0e16281433b78be2f9b32
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gcr"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=disabled
-Dpam=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
