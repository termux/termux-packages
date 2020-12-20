TERMUX_PKG_HOMEPAGE=https://cairographics.org
TERMUX_PKG_DESCRIPTION="Cairo 2D vector graphics library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/cairo-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331
TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, liblzo, libpixman, libpng, libx11, libxcb, libxext, libxrender, zlib"
TERMUX_PKG_BREAKS="libcairo-dev, libcairo-gobject"
TERMUX_PKG_REPLACES="libcairo-dev, libcairo-gobject"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gtk-doc-html
--disable-gl
--enable-gobject
--enable-pdf
--enable-svg
--enable-ps
"

TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/html"

termux_step_pre_configure() {
	autoreconf -fi
}
