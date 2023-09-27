TERMUX_PKG_HOMEPAGE=https://github.com/astrand/xclip
TERMUX_PKG_DESCRIPTION="Command line interface to the X11 clipboard"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=0.13
TERMUX_PKG_SRCURL=https://github.com/astrand/xclip/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ca5b8804e3c910a66423a882d79bf3c9450b875ac8528791fb60ec9de667f758
TERMUX_PKG_DEPENDS="libx11, libxmu"
TERMUX_PKG_BUILD_DEPENDS="libxt"
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_pre_configure(){
	CFLAGS+=" $CPPFLAGS"
	./bootstrap
}
