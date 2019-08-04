TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.79.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f985a4608fe592d2546d9d37d4182e502ff6b4c42f8db4be0a021a1c369528c8
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="libc++, libiconv, fontconfig, glib, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg, freetype, libcurl"
TERMUX_PKG_BREAKS="poppler-dev"
TERMUX_PKG_REPLACES="poppler-dev"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=OFF
-DFONT_CONFIGURATION=fontconfig
"
