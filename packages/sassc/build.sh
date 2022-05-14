TERMUX_PKG_HOMEPAGE=https://github.com/sass/sassc
TERMUX_PKG_DESCRIPTION="libsass command line driver"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Jesus Chapman (@Yisus7u7) <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=3.6.2
TERMUX_PKG_SRCURL=https://github.com/sass/sassc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=608dc9002b45a91d11ed59e352469ecc05e4f58fc1259fc9a9f5b8f0f8348a03
TERMUX_PKG_DEPENDS="libsass, libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	autoreconf -fi
}
