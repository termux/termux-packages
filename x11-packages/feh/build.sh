TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://feh.finalrewind.org/
TERMUX_PKG_DESCRIPTION="Fast and light imlib2-based image viewer"
TERMUX_PKG_VERSION=2.27.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://feh.finalrewind.org/feh-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6ec338f80c3f4c30d715f44780f1a09ebfbb99e92a1bb43316428744a839f383
TERMUX_PKG_DEPENDS="imlib2, libandroid-shmem, libcurl, libexif, libxinerama, libxt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="exif=1 help=1 verscmp=0"

termux_step_pre_configure()
{
    CFLAGS+=" -I${TERMUX_PREFIX}/include"
}
