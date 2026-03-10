TERMUX_PKG_HOMEPAGE=https://snowflake.torproject.org/
TERMUX_PKG_DESCRIPTION="Pluggable Transport using WebRTC, inspired by Flashproxy"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.12.1"
TERMUX_PKG_SRCURL=https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v${TERMUX_PKG_VERSION}/snowflake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=655f1daa9af141264c159ce0fe79070d7a4ca46ce43e94af2218a67f826d22d5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	# https://github.com/termux/termux-packages/issues/22236
	# https://github.com/wlynxg/anet?tab=readme-ov-file#how-to-build-with-go-1230-or-later
	go build -ldflags=-checklinkname=0 -o snowflake-client $TERMUX_PKG_SRCDIR/client/
	go build -ldflags=-checklinkname=0 -o snowflake-proxy $TERMUX_PKG_SRCDIR/proxy/
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin snowflake-client
	install -Dm700 -t $TERMUX_PREFIX/bin snowflake-proxy
}
