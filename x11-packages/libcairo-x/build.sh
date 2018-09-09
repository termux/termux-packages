TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://cairographics.org
TERMUX_PKG_DESCRIPTION="Cairo 2D vector graphics library (with X)"
TERMUX_PKG_VERSION=1.14.12
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=8c90f00c500b2299c0a323dd9beead2a00353752b2092ead558139bd67f7bf16
TERMUX_PKG_SRCURL=https://cairographics.org/releases/cairo-${TERMUX_PKG_VERSION}.tar.xz

TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, libandroid-shmem, libandroid-support, liblzo, libpixman, libpng, librsvg, libx11, libxcb, libxext, libxrender, poppler"
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
