TERMUX_PKG_HOMEPAGE=https://cairographics.org
TERMUX_PKG_DESCRIPTION="Cairo 2D vector graphics library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/cairo-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, libpixman, fontconfig, freetype, libpng"
TERMUX_PKG_BREAKS="libcairo-dev"
TERMUX_PKG_REPLACES="libcairo-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_lzo2_lzo2a_decompress=no
--disable-gtk-doc-html
--enable-xlib=no
--enable-xcb=no
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/html"
