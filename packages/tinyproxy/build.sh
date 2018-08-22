TERMUX_PKG_HOMEPAGE=https://tinyproxy.github.io/
TERMUX_PKG_DESCRIPTION="A light-weight HTTP proxy daemon for POSIX operating systems."
TERMUX_PKG_VERSION=1.8.4
TERMUX_PKG_SHA256=a41f4ddf0243fc517469cf444c8400e1d2edc909794acda7839f1d644e8a5000
TERMUX_PKG_SRCURL=https://github.com/tinyproxy/tinyproxy/releases/download/${TERMUX_PKG_VERSION}/tinyproxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-regexcheck"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
