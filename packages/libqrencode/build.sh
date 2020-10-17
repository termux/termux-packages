TERMUX_PKG_HOMEPAGE=https://fukuchi.org/works/qrencode/
TERMUX_PKG_DESCRIPTION="Fast and compact library for encoding data in a QR Code symbol"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.1.1
TERMUX_PKG_SRCURL=https://github.com/fukuchi/libqrencode/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5385bc1b8c2f20f3b91d258bf8ccc8cf62023935df2d2676b5b67049f31a049c
TERMUX_PKG_DEPENDS="libandroid-support, libpng, zlib"
TERMUX_PKG_BREAKS="libqrencode-dev"
TERMUX_PKG_REPLACES="libqrencode-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"
