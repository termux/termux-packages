TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GdkPixbuf
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.44.5"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gdk-pixbuf/${TERMUX_PKG_VERSION%.*}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=69b93e09139b80c0ee661503d60deb5a5874a31772b5184b9cd5462a4100ab68
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo, zstd"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="gdk-pixbuf-dev"
TERMUX_PKG_REPLACES="gdk-pixbuf-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dandroid=disabled
-Dgtk_doc=false
-Dintrospection=enabled
-Dgio_sniffing=false
-Dothers=enabled
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
	local _SOVERSION_GUARD_FILES="lib/libgdk_pixbuf-2.0.so.0"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}

termux_step_create_debscripts() {
	for i in $(test "$TERMUX_PACKAGE_FORMAT" != "pacman" && echo postinst) prerm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
