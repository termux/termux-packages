TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Libpeas
TERMUX_PKG_DESCRIPTION="A GObject plugins library"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libpeas/${TERMUX_PKG_VERSION%.*}/libpeas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c2887233f084a69fabfc7fa0140d410491863d7050afb28677f9a553b2580ad9
TERMUX_PKG_DEPENDS="glib, gobject-introspection, pygobject"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, gettext"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgjs=false
-Dlua51=false
-Dgtk_doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
