TERMUX_PKG_HOMEPAGE=https://github.com/webmproject/libwebp
TERMUX_PKG_DESCRIPTION="Library to encode and decode images in WebP format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=082d114bcb18a0e2aafc3148d43367c39304f86bf18ba0b2e766447e111a4a91
TERMUX_PKG_BREAKS="libwebp-dev"
TERMUX_PKG_REPLACES="libwebp-dev"
TERMUX_PKG_SRCURL=https://github.com/webmproject/libwebp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gif
--disable-jpeg
--disable-libwebpdemux
--disable-png
--disable-tiff
--disable-wic
"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1"

termux_step_pre_configure() {
	./autogen.sh
}
