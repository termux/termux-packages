TERMUX_PKG_HOMEPAGE=https://www.gtk.org/docs/architecture/pango
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.56.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pango/${TERMUX_PKG_VERSION%.*}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1fb98b338ee6f7cf8ef96153b7d242f4568fe60f9b7434524eca630a57bd538b
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
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/pango-view.1 \
		$TERMUX_PREFIX/share/man/man1/pango-view.1
}
