TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview
TERMUX_PKG_DESCRIPTION="A source code editing widget"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="299.6.0"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/${TERMUX_PKG_VERSION}/libgedit-gtksourceview-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=694543a50a5204daf057d6ec23babf050d2662309b5139b7b56f88c19a96a6b8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libxml2, pango"
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
	local _GUARD_FILE="lib/libgedit-gtksourceview-300.so.4"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
