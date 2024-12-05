TERMUX_PKG_HOMEPAGE=https://gedit-technology.github.io/apps/gedit/
TERMUX_PKG_DESCRIPTION="GNOME Text Editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gedit/${TERMUX_PKG_VERSION%.*}/gedit-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fe0fef9b7b0799120db86ae893a060036a13445352ded9169bab28d38acf0e80
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gobject-introspection, gsettings-desktop-schemas, gspell, gtk3, libcairo, libgedit-amtk, libgedit-gfls, libgedit-gtksourceview, libgedit-tepl, libpeas, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="gedit-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
