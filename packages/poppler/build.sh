TERMUX_PKG_HOMEPAGE=http://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_VERSION=0.47.0
TERMUX_PKG_SRCURL=http://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-poppler-glib"
