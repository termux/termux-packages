TERMUX_PKG_HOMEPAGE=https://libvips.github.io/libvips/
TERMUX_PKG_DESCRIPTION="A fast image processing library with low memory needs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.15.5"
TERMUX_PKG_SRCURL=https://github.com/libvips/libvips/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf11abb23da9152241ba52621efe418995c7f315fd0baf2e125323d28efd8780
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cgif, fftw, fontconfig, glib, imagemagick, libc++, libcairo, libexif, libexpat, libheif, libimagequant, libjpeg-turbo, libjxl, libpng, librsvg, libtiff, libwebp, littlecms, openexr, openjpeg, pango, poppler, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dorc=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
