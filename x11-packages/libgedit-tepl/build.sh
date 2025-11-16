TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/World/gedit/libgedit-tepl
TERMUX_PKG_DESCRIPTION="Library that eases the development of GtkSourceView-based text editors and IDEs"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/$TERMUX_PKG_VERSION/libgedit-tepl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=39d97a69c6f75a1e86f72976159a4ec3f51996971d1cc5b7289df1315a7d6bab
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gsettings-desktop-schemas, gtk3, libcairo, libgedit-amtk, libgedit-gfls, libgedit-gtksourceview, libhandy, libicu, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgobject_introspection=true
-Dgtk_doc=false
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _GUARD_FILE="lib/libgedit-tepl-6.so.3"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
