TERMUX_PKG_HOMEPAGE=https://fukuchi.org/works/qrencode/
TERMUX_PKG_DESCRIPTION="Libqrencode is a fast and compact library for encoding data in a QR Code symbol, a 2D symbology that can be scanned by handy terminals"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.0.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=43091fea4752101f0fe61a957310ead10a7cb4b81e170ce61e5baa73a6291ac2
TERMUX_PKG_SRCURL=https://github.com/fukuchi/libqrencode/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libpng, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"
