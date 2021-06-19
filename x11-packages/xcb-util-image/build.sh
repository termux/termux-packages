TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Utility libraries for XC Binding - Port of Xlib's XImage and XShmImage functions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=24
TERMUX_PKG_SRCURL=https://xcb.freedesktop.org/dist/xcb-util-image-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2db96a37d78831d643538dd1b595d7d712e04bdccf8896a5e18ce0f398ea2ffc
TERMUX_PKG_DEPENDS="libandroid-shmem, libxcb, xcb-util"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
