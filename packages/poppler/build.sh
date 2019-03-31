TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.75.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=3bbaedb0fa2797cac933a0659d144303e4d09eec6892c65600da987d8707199a
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, glib, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, openjpeg, freetype, libcurl"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=OFF
-DFONT_CONFIGURATION=fontconfig
"

termux_step_pre_configure() {
	sed -i '1 i\#!/usr/bin/python' /data/data/com.termux/files/usr/bin/glib-mkenums
}
