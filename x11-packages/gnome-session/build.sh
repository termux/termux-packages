TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-session/
TERMUX_PKG_DESCRIPTION="The GNOME session manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.0"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-session/${TERMUX_PKG_VERSION%%.*}/gnome-session-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=dd909fbc5b22cdbdb2fc4df1a47d78d1b5943ccc5e61e6a20a1846246347c417
TERMUX_PKG_DEPENDS="glib, gnome-desktop3, gtk3, json-glib, libice, libsm, libx11"
TERMUX_PKG_RECOMMENDS="gnome-shell"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
# Should be bumped with gnome-shell
TERMUX_PKG_AUTO_UPDATE=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=false
-Dsystemduserunitdir=$TERMUX_PKG_TMPDIR
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
