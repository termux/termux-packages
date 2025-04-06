TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.24.49"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gtk/-/archive/$TERMUX_PKG_VERSION/gtk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a2958d82986c81794e953a3762335fa7c78948706d23cced421f7245ca544cbc
TERMUX_PKG_DEPENDS="adwaita-icon-theme, at-spi2-core, coreutils, desktop-file-utils, fontconfig, fribidi, gdk-pixbuf, glib, glib-bin, gtk-update-icon-cache, harfbuzz, libcairo, libepoxy, libwayland, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxinerama, libxkbcommon, libxrandr, pango, shared-mime-info, ttf-dejavu"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, libwayland-protocols, xorgproto"
TERMUX_PKG_CONFLICTS="libgtk3"
TERMUX_PKG_REPLACES="libgtk3"
# Prevent updating to unstable branch or gtk4
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbroadway_backend=true
-Dexamples=false
-Dintrospection=true
-Dman=true
-Dprint_backends=file,lpr
-Dtests=false
-Dwayland_backend=true
-Dx11_backend=true
-Dxinerama=yes
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_gir
	termux_setup_ninja
	termux_setup_pkg_config_wrapper "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		'lib/libgailutil-3.so.0'
		'lib/libgdk-3.so.0'
		'lib/libgtk-3.so.0'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
