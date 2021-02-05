TERMUX_PKG_HOMEPAGE=https://github.com/webmproject/libwebp
TERMUX_PKG_DESCRIPTION="Library to encode and decode images in WebP format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/webmproject/libwebp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d60608c45682fa1e5d41c3c26c199be5d0184084cd8a971a6fc54035f76487d3
TERMUX_PKG_DEPENDS="giflib, libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_BREAKS="libwebp-dev"
TERMUX_PKG_REPLACES="libwebp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libwebpmux
--enable-libwebpdemux
--enable-libwebpdecoder
--enable-libwebpextras
--enable-swap-16bit-csp
--enable-gif
--enable-jpeg
--enable-png
--enable-tiff
--disable-wic
"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1"

termux_step_pre_configure() {
	./autogen.sh
}
