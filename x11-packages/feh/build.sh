TERMUX_PKG_HOMEPAGE=https://feh.finalrewind.org/
TERMUX_PKG_DESCRIPTION="Fast and light imlib2-based image viewer"
# License: MIT-feh
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.10.2"
TERMUX_PKG_SRCURL=https://feh.finalrewind.org/feh-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5f94a77de25c5398876f0cf431612d782b842f4db154d2139b778c8f196e8969
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="imlib2, libcurl, libexif, libpng, libx11, libxinerama"
TERMUX_PKG_BUILD_DEPENDS="libxt"
TERMUX_PKG_RECOMMENDS="libjpeg-turbo-progs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="exif=1 help=1 verscmp=0"

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include"
}
