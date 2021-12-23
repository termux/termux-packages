TERMUX_PKG_HOMEPAGE=https://github.com/freedesktop/xorg-lib-libXv
TERMUX_PKG_DESCRIPTION="Xvideo extension library"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_LICENSE_FILE=COPYING
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.11
TERMUX_PKG_SRCURL=https://github.com/freedesktop/xorg-lib-libXv/archive/refs/tags/libXv-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d608436370d85230a176aca25aa27d98861ac49c59e88ca4e2fb6a6759bedf1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--build=aarch64-unknown-linux-gnu"
termux_step_pre_configure() {
	${TERMUX_PKG_SRDIR}/autogen.sh
}
