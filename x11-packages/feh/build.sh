TERMUX_PKG_HOMEPAGE=https://feh.finalrewind.org/
TERMUX_PKG_DESCRIPTION="Fast and light imlib2-based image viewer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=3.6.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://feh.finalrewind.org/feh-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=437420f37f11614e008d066e2a3bdefcfc78144c8212998b2bacdd5d21ea23b4
TERMUX_PKG_DEPENDS="imlib2, libandroid-shmem, libcurl, libexif, libpng, libx11, libxinerama"
TERMUX_PKG_BUILD_DEPENDS="libxt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="exif=1 help=1 verscmp=0"

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include"
}
