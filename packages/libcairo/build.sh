TERMUX_PKG_HOMEPAGE=http://cairographics.org/
TERMUX_PKG_DESCRIPTION="Cairo 2D vector graphics library"
TERMUX_PKG_VERSION=1.14.6
TERMUX_PKG_BUILD_REVISION=3
TERMUX_PKG_SRCURL=http://cairographics.org/releases/cairo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, libpixman, fontconfig, freetype"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk-doc-html --enable-xlib=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/html"
