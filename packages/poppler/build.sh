TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.02.0
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c14759c99891e6e472aced6d5f0ff1dacf85d80cd9026d365c55c653edf792c
TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, libc++, libcairo, libcurl, libiconv, libjpeg-turbo, libpng, libtiff, littlecms, openjpeg, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost"
TERMUX_PKG_BREAKS="poppler-dev"
TERMUX_PKG_REPLACES="poppler-dev"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=OFF
-DFONT_CONFIGURATION=fontconfig
"
