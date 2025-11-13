TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gspell
TERMUX_PKG_DESCRIPTION="Spell-checking for GTK applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.1"
TERMUX_PKG_REVISION=1
# https://download.gnome.org/sources/gspell/${TERMUX_PKG_VERSION%.*}/gspell-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gspell/-/archive/${TERMUX_PKG_VERSION}/gspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ecdc789e4f798e63cf49fc1718541e7974e5f67034ce152ae052a2b8f337e8e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="enchant, glib, gtk3, libicu, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgobject_introspection=true
-Dgtk_doc=false
-Dinstall_tests=false
-Dtests=false
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
