TERMUX_PKG_HOMEPAGE=https://cairographics.org
TERMUX_PKG_DESCRIPTION="Cairo 2D vector graphics library"
TERMUX_PKG_VERSION=1.14.10
TERMUX_PKG_SRCURL=https://cairographics.org/releases/cairo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7e87878658f2c9951a14fc64114d4958c0e65ac47530b8ac3078b2ce41b66a09
TERMUX_PKG_DEPENDS="libandroid-support, libpixman, fontconfig, freetype"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk-doc-html --enable-xlib=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/html"
