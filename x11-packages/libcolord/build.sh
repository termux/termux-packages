TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/software/colord
TERMUX_PKG_DESCRIPTION="Client library of the daemon for managing color devices"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.7"
TERMUX_PKG_SRCURL="https://github.com/hughsie/colord/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=09a2c35c2cf6afd28b9a107dd48090ee7a376c20008a7fd7b2eb576a46ee057e
TERMUX_PKG_DEPENDS="glib, gobject-introspection, hwdata, libsqlite, littlecms"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpnp_ids=$TERMUX_PREFIX/share/hwdata/pnp.ids
-Dintrospection=true
-Ddaemon=false
-Dsystemd=false
-Dudev_rules=false
-Dargyllcms_sensor=false
-Dtests=false
-Dbash_completion=false
-Dman=false
-Ddocs=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libcolord.so.2
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
