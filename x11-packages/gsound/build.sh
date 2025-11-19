TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gsound
TERMUX_PKG_DESCRIPTION="Small gobject library for playing system sounds"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.3"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gsound/${TERMUX_PKG_VERSION%.*}/gsound-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ca2d039e1ebd148647017a7f548862350bc9af01986d39f10cfdc8e95f07881a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libcanberra, gobject-introspection"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Denable_vala=true
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_gir
}
