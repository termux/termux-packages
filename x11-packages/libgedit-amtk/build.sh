TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/World/gedit/libgedit-amtk
TERMUX_PKG_DESCRIPTION="Actions, Menus and Toolbars Kit for GTK applications"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.9.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/${TERMUX_PKG_VERSION}/libgedit-amtk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=185c960789b7b448f3c6b7d0e15da5785906930a2bb5fddb45dfc0bd3d1b0798
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3"
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
	local _GUARD_FILE="lib/libgedit-amtk-5.so.0"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
