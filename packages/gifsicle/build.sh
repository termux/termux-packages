TERMUX_PKG_HOMEPAGE=https://www.lcdf.org/gifsicle/
TERMUX_PKG_DESCRIPTION="Tool for creating, editing, and getting information about GIF images and animations"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.95"
TERMUX_PKG_SRCURL=https://www.lcdf.org/gifsicle/gifsicle-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b2711647009fd2a13130f3be160532ed46538e762bfc0f020dea50618a7dc950
TERMUX_PKG_AUTO_UPDATE=true
# for gifview
TERMUX_PKG_BUILD_DEPENDS="libx11"
TERMUX_PKG_SUGGESTS="libx11"
