TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_VERSION=2.11.7
TERMUX_PKG_SHA256=0ca09a1f253b264e5aab8477b7f0e3cde51d9f88ed668b38ae057ced24076bda
TERMUX_PKG_SRCURL=https://github.com/pornel/pngquant/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sse"

termux_step_post_extract_package () {
	local LIBIMAGEQUANT_SRC_FOLDER=libimagequant-$TERMUX_PKG_VERSION
	termux_download \
		https://github.com/ImageOptim/libimagequant/archive/$TERMUX_PKG_VERSION.tar.gz \
		$TERMUX_PKG_CACHEDIR/$LIBIMAGEQUANT_SRC_FOLDER.tar.gz \
		aa5c9ae93f245f6703ca3f15c0ffe1ba647f66aac87bbfea0b58ebae9a4e37b5

	tar -xf $TERMUX_PKG_CACHEDIR/$LIBIMAGEQUANT_SRC_FOLDER.tar.gz -C $TERMUX_PKG_SRCDIR
	rmdir $TERMUX_PKG_SRCDIR/lib
	mv $TERMUX_PKG_SRCDIR/$LIBIMAGEQUANT_SRC_FOLDER $TERMUX_PKG_SRCDIR/lib
}
