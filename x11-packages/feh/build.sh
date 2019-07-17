TERMUX_PKG_HOMEPAGE=https://feh.finalrewind.org/
TERMUX_PKG_DESCRIPTION="Fast and light imlib2-based image viewer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_SRCURL=https://feh.finalrewind.org/feh-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c0182312a1b686bfbc2d1a7c2f8f28b9cdeacec06cf08dadf201007afb559b00
TERMUX_PKG_DEPENDS="imlib2, libandroid-shmem, libcurl, libexif, libpng, libx11, libxinerama"
TERMUX_PKG_BUILD_DEPENDS="libxt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="exif=1 help=1 verscmp=0"

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include"
}
