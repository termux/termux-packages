TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_VERSION=0.55.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=537f2bc60d796525705ad9ca8e46899dcc99c2e9480b80051808bae265cdc658
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-poppler-glib  --enable-xpdf-headers"
