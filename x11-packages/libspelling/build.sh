TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/chergert/libspelling/
TERMUX_PKG_DESCRIPTION="Spellcheck library for GTK 4"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.4"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libspelling/${TERMUX_PKG_VERSION%.*}/libspelling-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ac9132c634bb9df911e35b52345aa12126f7ec95e5f07179a980861819787150
TERMUX_PKG_DEPENDS="enchant, glib, gtk4, gtksourceview5, libicu, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Denchant=enabled
-Dintrospection=enabled
-Dsysprof=false
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
