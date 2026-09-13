TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libsecret
TERMUX_PKG_DESCRIPTION="A GObject-based library for accessing the Secret Service API"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION="0.21.8.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsecret/${TERMUX_PKG_VERSION:0:4}/libsecret-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=142948339c5b971d8f6a8c7099521f6fd319b6fe73d2694b4e6d3310ed28b6e6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libgcrypt"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	# https://gitlab.gnome.org/GNOME/vala/-/issues/1413
	CPPFLAGS+=" -Wno-incompatible-function-pointer-types"
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libsecret-1.so.0"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}
