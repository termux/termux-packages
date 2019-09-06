TERMUX_PKG_HOMEPAGE=https://libjpeg-turbo.virtualgl.org
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.0.3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libjpeg-turbo/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4246de500544d4ee408ee57048aa4aadc6f165fc17f141da87669f20ed3241b7
TERMUX_PKG_BREAKS="libjpeg-turbo-dev"
TERMUX_PKG_REPLACES="libjpeg-turbo-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_JPEG8=1"
