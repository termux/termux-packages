TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Libpeas
TERMUX_PKG_DESCRIPTION="A gobject-based plugins engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.38.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libpeas/${TERMUX_PKG_VERSION%.*}/libpeas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e82fd328adcac1aba34b64136bdfcbbacf2b3258a8bc4e5f480a72502a611ae9
TERMUX_PKG_DEPENDS="glib, gobject-introspection, gtk3"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlua51=false
-Dpython3=false
-Dintrospection=true
-Ddemos=false
-Dgtk_doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		'lib/libpeas-1.0.so.1'
		'lib/libpeas-gtk-1.0.so.1'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}
