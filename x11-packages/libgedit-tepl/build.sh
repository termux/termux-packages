TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/World/gedit/libgedit-tepl
TERMUX_PKG_DESCRIPTION="Library that eases the development of GtkSourceView-based text editors and IDEs"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.14.0"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/$TERMUX_PKG_VERSION/libgedit-tepl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9ddd8653a673a80a4184efa822578e3f8abdd00a85ec40e3851dee56ff47450c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
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
	local _GUARD_FILE="lib/libgedit-tepl-6.so.4"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
