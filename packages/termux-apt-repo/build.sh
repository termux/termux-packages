TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-apt-repo
TERMUX_PKG_DESCRIPTION="Script to create Termux apt repositories"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_SRCURL=https://github.com/termux/termux-apt-repo/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22c2ad46e548a9b73179da072b798cbbe6767f2dcc99cc476fa88641f8595434
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# binutils for ar:
TERMUX_PKG_DEPENDS="binutils-is-llvm | binutils, python, tar"
