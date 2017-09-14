TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
# Do not update before pdflatex is fixed to work with newer poppler versions:
TERMUX_PKG_VERSION=0.59.0.1
local _REAL_VERSION=0.57.0
TERMUX_PKG_SHA256=0ea37de71b7db78212ebc79df59f99b66409a29c2eac4d882dae9f2397fe44d8
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${_REAL_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-poppler-glib  --enable-xpdf-headers"
