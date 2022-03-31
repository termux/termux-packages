TERMUX_PKG_HOMEPAGE=https://github.com/xxf098/LiteSpeedTest
TERMUX_PKG_DESCRIPTION="A simple tool for batch test ss/ssr/v2ray/trojan servers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://github.com/xxf098/LiteSpeedTest/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b89db315ea3645c9e8e0464fa4276f53ba3c55e07d496d150bc6acfbe66d5259
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
