TERMUX_PKG_HOMEPAGE=https://github.com/petervanderdoes/gitflow/
TERMUX_PKG_DESCRIPTION="Extend git with Vincent Driessen's branching model. The AVH Edition adds more functionality."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.12.3
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://github.com/petervanderdoes/gitflow/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=54e9fd81aa1aa8215c865503dc6377da205653c784d6c97baad3dafd20728e06
TERMUX_PKG_DEPENDS="dash, git"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
