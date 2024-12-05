TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/World/gedit/libgedit-tepl
TERMUX_PKG_DESCRIPTION="Library that eases the development of GtkSourceView-based text editors and IDEs"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgedit-tepl/${TERMUX_PKG_VERSION%.*}/libgedit-tepl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=30814663de8324acbbdce623ead4690ed75a9ff7c90023a04997d67e2c0121aa
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
	local _GUARD_FILE="lib/libgedit-tepl-6.so.1"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
