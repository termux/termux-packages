TERMUX_PKG_HOMEPAGE=https://sass-lang.com/libsass
TERMUX_PKG_DESCRIPTION="A C/C++ implementation of a Sass compiler"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Jesus Chapman (@Yisus7u7) <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=3.6.5
TERMUX_PKG_SRCURL=https://github.com/sass/libsass/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89d8f2c46ae2b1b826b58ce7dde966a176bac41975b82e84ad46b01a55080582
TERMUX_PKG_DEPENDS="libc"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	autoreconf -fi
}
