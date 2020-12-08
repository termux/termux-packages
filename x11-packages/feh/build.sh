TERMUX_PKG_HOMEPAGE=https://feh.finalrewind.org/
TERMUX_PKG_DESCRIPTION="Fast and light imlib2-based image viewer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=3.6.1
TERMUX_PKG_SRCURL=https://feh.finalrewind.org/feh-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9b1edec52cbae97b17530cb5db10666abfb9983f51a5d820c89added6f7b1ea8
TERMUX_PKG_DEPENDS="imlib2, libandroid-shmem, libcurl, libexif, libpng, libx11, libxinerama"
TERMUX_PKG_BUILD_DEPENDS="libxt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="exif=1 help=1 verscmp=0"

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include"
}
