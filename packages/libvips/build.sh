TERMUX_PKG_HOMEPAGE=https://libvips.github.io/libvips/
TERMUX_PKG_DESCRIPTION="A fast image processing library with low memory needs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Thibault Meyer <meyer.thibault@gmail.com>"
TERMUX_PKG_VERSION="8.13.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libvips/libvips/releases/download/v${TERMUX_PKG_VERSION}/vips-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4eff5cdc8dbe1a05a926290a99014e20ba386f5dcca38d9774bef61413435d4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, fontconfig, freetype, giflib, glib, harfbuzz, imagemagick, libc++, libcairo, libexif, libexpat, libheif, libjpeg-turbo, libjxl, libpng, librsvg, libtiff, libwebp, littlecms, openexr, openjpeg, pango, poppler"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
