TERMUX_PKG_HOMEPAGE=https://github.com/webmproject/libwebp
TERMUX_PKG_DESCRIPTION="Library to encode and decode images in WebP format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/webmproject/libwebp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=dfe7bff3390cd4958da11e760b65318f0a48c32913e4d5bc5e8d55abaaa2d32e
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
