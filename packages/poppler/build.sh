TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_VERSION=0.62.0
TERMUX_PKG_SHA256=5b9a73dfd4d6f61d165ada1e4f0abd2d420494bf9d0b1c15d0db3f7b83a729c6
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg, freetype, libcurl"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=OFF
-DENABLE_XPDF_HEADERS=ON
-DENABLE_MULTITHREAD=OFF
"
