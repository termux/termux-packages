TERMUX_PKG_HOMEPAGE=https://libjpeg-turbo.virtualgl.org
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libjpeg-turbo/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=acb8599fe5399af114287ee5907aea4456f8f2c1cc96d26c28aebfdf5ee82fed
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_JPEG8=1"
