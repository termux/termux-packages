TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Ghex
TERMUX_PKG_DESCRIPTION="A simple binary editor for the Gnome desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="46.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/ghex/${TERMUX_PKG_VERSION%.*}/ghex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a1c46f3020cb358b8323025db3a539c97d994a4c46f701f48edc6357f7fbcbd1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, libadwaita, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
