TERMUX_PKG_HOMEPAGE=https://libjpeg-turbo.virtualgl.org
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.6
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libjpeg-turbo/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d74b92ac33b0e3657123ddcf6728788c90dc84dcb6a52013d758af3c4af481bb
TERMUX_PKG_BREAKS="libjpeg-turbo-dev"
TERMUX_PKG_REPLACES="libjpeg-turbo-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_JPEG8=1"
