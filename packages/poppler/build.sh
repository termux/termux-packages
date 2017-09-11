TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_VERSION=0.59.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SHA256=b808ebbfb794a900828baa9b93d3eaea5671d1be03104d12a98d8d0c9f3658d3
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-poppler-glib  --enable-xpdf-headers"
