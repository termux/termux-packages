TERMUX_PKG_HOMEPAGE=https://libjpeg-turbo.virtualgl.org
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_LICENSE="IJG, BSD 3-Clause, ZLIB"
TERMUX_PKG_LICENSE_FILE="README.ijg, LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.5.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libjpeg-turbo/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2fdc3feb6e9deb17adec9bafa3321419aa19f8f4e5dea7bf8486844ca22207bf
TERMUX_PKG_BREAKS="libjpeg-turbo-dev"
TERMUX_PKG_REPLACES="libjpeg-turbo-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_JPEG8=1"
