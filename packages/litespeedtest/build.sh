TERMUX_PKG_HOMEPAGE=https://github.com/xxf098/LiteSpeedTest
TERMUX_PKG_DESCRIPTION="A simple tool for batch test ss/ssr/v2ray/trojan servers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL=https://github.com/xxf098/LiteSpeedTest/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=efdd0c791c323533dcb10be0a03888c2834b16419c1cf4dbc1e600e8453d2c04
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="VERSION=$TERMUX_PKG_VERSION"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/lite
}
