TERMUX_PKG_HOMEPAGE=https://www.lcdf.org/gifsicle/
TERMUX_PKG_DESCRIPTION="Tool for creating, editing, and getting information about GIF images and animations"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.93
TERMUX_PKG_SRCURL=https://www.lcdf.org/gifsicle/gifsicle-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92f67079732bf4c1da087e6ae0905205846e5ac777ba5caa66d12a73aa943447
# for gifview
TERMUX_PKG_BUILD_DEPENDS="libx11"
TERMUX_PKG_SUGGESTS="libx11"
