TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libsecret
TERMUX_PKG_DESCRIPTION="A GObject-based library for accessing the Secret Service API"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION="0.21.7"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsecret/${TERMUX_PKG_VERSION%.*}/libsecret-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6b452e4750590a2b5617adc40026f28d2f4903de15f1250e1d1c40bfd68ed55e
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
