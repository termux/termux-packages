TERMUX_PKG_HOMEPAGE=https://torproject.org/
TERMUX_PKG_DESCRIPTION="Pluggable Transport based on HTTP Upgrade(HTTPT)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.3"
TERMUX_PKG_SRCURL="https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel/-/archive/v${TERMUX_PKG_VERSION}/webtunnel-v${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=b1cda89f7ea5f5535774805eb9f8ae56f3a2be5f7f0a7b4f88fe3f5dc6c274c1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go build -ldflags=-checklinkname=0 -o webtunnel-client "$TERMUX_PKG_SRCDIR/main/client/"
	go build -ldflags=-checklinkname=0 -o webtunnel-server "$TERMUX_PKG_SRCDIR/main/server/"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" webtunnel-client
	install -Dm700 -t "$TERMUX_PREFIX/bin" webtunnel-server
}
