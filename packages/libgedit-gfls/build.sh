TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/World/gedit/libgedit-gfls
TERMUX_PKG_DESCRIPTION="A module dedicated to file loading and saving"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgedit-gfls/${TERMUX_PKG_VERSION%.*}/libgedit-gfls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c88bc2bbf1ec1155b61766f372ac44a7f272792234b86e8ad5ea4f7365171acb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
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
	local _GUARD_FILE="lib/libgedit-gfls-1.so.0"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
