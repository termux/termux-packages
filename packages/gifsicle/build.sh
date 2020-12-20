TERMUX_PKG_HOMEPAGE=https://www.lcdf.org/gifsicle/
TERMUX_PKG_DESCRIPTION="Tool for creating, editing, and getting information about GIF images and animations"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.92
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.lcdf.org/gifsicle/gifsicle-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ab556c01d65fddf980749e3ccf50b7fd40de738b6df679999294cc5fabfce65
# for gifview
TERMUX_PKG_BUILD_DEPENDS="libx11"
TERMUX_PKG_SUGGESTS="libx11"
