TERMUX_PKG_HOMEPAGE=https://github.com/webmproject/libwebp
TERMUX_PKG_DESCRIPTION="Library to encode and decode images in WebP format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_SHA256=347cf85ddc3497832b5fa9eee62164a37b249c83adae0ba583093e039bf4881f
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
