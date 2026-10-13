TERMUX_PKG_HOMEPAGE=https://www.lcdf.org/gifsicle/
TERMUX_PKG_DESCRIPTION="Tool for creating, editing, and getting information about GIF images and animations"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.97"
TERMUX_PKG_SRCURL=https://www.lcdf.org/gifsicle/gifsicle-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17d98f305372e8c6c47c3fa7c75a9ebd9a8dea0b47c739d0b3be6c30a1c1da7a
TERMUX_PKG_AUTO_UPDATE=true
# for gifview
TERMUX_PKG_BUILD_DEPENDS="libx11"
TERMUX_PKG_SUGGESTS="libx11"
