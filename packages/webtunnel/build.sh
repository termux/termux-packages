TERMUX_PKG_HOMEPAGE=https://torproject.org/
TERMUX_PKG_DESCRIPTION="Pluggable Transport based on HTTP Upgrade(HTTPT)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.5"
TERMUX_PKG_SRCURL="https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel/-/archive/v${TERMUX_PKG_VERSION}/webtunnel-v${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=51b444247d27400e298f4386e539f16631b2b5383216ac1552c2947f952846d2
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
