TERMUX_PKG_HOMEPAGE=https://github.com/fatedier/frp
TERMUX_PKG_DESCRIPTION="A fast reverse proxy to expose a local server behind a NAT or firewall to the internet"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.62.1"
TERMUX_PKG_SRCURL=https://github.com/fatedier/frp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0513f1c08f7a6b31f91ddeca64ccdec43726c20d20103de5220055daa04b903
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
