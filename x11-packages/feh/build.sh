TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://feh.finalrewind.org/
TERMUX_PKG_DESCRIPTION="Fast and light imlib2-based image viewer"
TERMUX_PKG_VERSION=2.28
TERMUX_PKG_SRCURL=https://feh.finalrewind.org/feh-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=13d22d7c5fe5057612ce3df88857aee89fcab9c8cd6fd4f95a42fe6bf851d3d9
TERMUX_PKG_DEPENDS="imlib2, libandroid-shmem, libcurl, libexif, libxinerama, libxt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="exif=1 help=1 verscmp=0"

termux_step_pre_configure() {
    CFLAGS+=" -I${TERMUX_PREFIX}/include"
}
