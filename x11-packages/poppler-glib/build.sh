TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library based on xpdf 3.0 (with glib bindings)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=0.72.0
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c1747eb8f26e9e753c4001ed951db2896edc1021b6d0f547a0bd2a27c30ada51

TERMUX_PKG_DEPENDS="fontconfig, glib, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg, freetype, libcurl"
TERMUX_PKG_CONFLICTS="poppler"
TERMUX_PKG_PROVIDES="poppler"
TERMUX_PKG_REPLACES="poppler"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_XPDF_HEADERS=ON
-DENABLE_QT5=OFF
-DFONT_CONFIGURATION=fontconfig
"

TERMUX_PKG_RM_AFTER_INSTALL="bin/poppler-glib-demo"

## TODO: Enable glib bindings in main repo ?
