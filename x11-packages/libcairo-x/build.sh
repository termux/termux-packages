TERMUX_PKG_HOMEPAGE=https://cairographics.org
TERMUX_PKG_DESCRIPTION="Cairo 2D vector graphics library (with X)"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SHA256=5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331
TERMUX_PKG_SRCURL=https://cairographics.org/releases/cairo-${TERMUX_PKG_VERSION}.tar.xz

TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, libandroid-shmem, liblzo, libpixman, libpng, librsvg, libx11, libxcb, libxext, libxrender, poppler, zlib"
TERMUX_PKG_PROVIDES="libcairo, libcairo-gobject"
TERMUX_PKG_REPLACES="${TERMUX_PKG_PROVIDES}"
TERMUX_PKG_CONFLICTS="${TERMUX_PKG_PROVIDES}, libcairo-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gtk-doc-html
--disable-gl
--enable-gobject
--enable-pdf
--enable-svg
--enable-ps
LIBS=-landroid-shmem
"

TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/html"
