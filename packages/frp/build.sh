TERMUX_PKG_HOMEPAGE=https://gofrp.org/doc
TERMUX_PKG_DESCRIPTION="A fast reverse proxy to expose a local server behind a NAT or firewall to the internet"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.52.1"
TERMUX_PKG_SRCURL=https://github.com/fatedier/frp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f614142a7d87a8ff71b310041c3c5b8bc08a1813ab1dae90cc433bdeb040d30a
TERMUX_PKG_REPLACES="frpc, frps"
TERMUX_PKG_BREAKS="frpc, frps"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	make frpc
	make frps
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/frpc
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/frps
}
