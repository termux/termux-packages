TERMUX_PKG_HOMEPAGE=https://github.com/fatedier/frp
TERMUX_PKG_DESCRIPTION="A fast reverse proxy to expose a local server behind a NAT or firewall to the internet"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.59.0"
TERMUX_PKG_SRCURL=https://github.com/fatedier/frp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eb4848119a9684b7762171d7633aa5ee29d195e63f53e89e7b549096bdf4a5a9
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
