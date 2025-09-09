TERMUX_PKG_HOMEPAGE=https://www.lcdf.org/gifsicle/
TERMUX_PKG_DESCRIPTION="Tool for creating, editing, and getting information about GIF images and animations"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.96"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.lcdf.org/gifsicle/gifsicle-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd23d279681a6dfe3c15264e33f344045b3ba473da4d19f49e67a50994b077fb
TERMUX_PKG_AUTO_UPDATE=true
# for gifview
TERMUX_PKG_BUILD_DEPENDS="libx11"
TERMUX_PKG_SUGGESTS="libx11"
