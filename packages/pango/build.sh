TERMUX_PKG_HOMEPAGE=https://www.gtk.org/docs/architecture/pango
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.56.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pango/${TERMUX_PKG_VERSION%.*}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2606252bc25cd8d24e1b7f7e92c3a272b37acd6734347b73b47a482834ba2491
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, fribidi, glib, harfbuzz, libcairo, libx11, libxft, libxrender"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="pango-dev"
TERMUX_PKG_REPLACES="pango-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-testsuite=false
-Dintrospection=enabled
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
		'lib/libpango-1.0.so.0'
		'lib/libpangocairo-1.0.so.0'
		'lib/libpangoft2-1.0.so.0'
		'lib/libpangoxft-1.0.so.0'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/pango-view.1 \
		$TERMUX_PREFIX/share/man/man1/pango-view.1
}
