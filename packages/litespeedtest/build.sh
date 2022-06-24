TERMUX_PKG_HOMEPAGE=https://github.com/xxf098/LiteSpeedTest
TERMUX_PKG_DESCRIPTION="A simple tool for batch test ss/ssr/v2ray/trojan servers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL=https://github.com/xxf098/LiteSpeedTest/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b2be435da12b48d8cd5dbace489f2497586ded1957377a8ceb4ea44883510c5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="VERSION=$TERMUX_PKG_VERSION"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/lite
}
