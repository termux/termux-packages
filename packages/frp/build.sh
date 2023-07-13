TERMUX_PKG_HOMEPAGE=https://gofrp.org/doc
TERMUX_PKG_DESCRIPTION="A fast reverse proxy to expose a local server behind a NAT or firewall to the internet"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.51.0"
TERMUX_PKG_SRCURL=https://github.com/fatedier/frp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=80ccfa40c4e25309ddb48818f6342bc59f7639be83ab6ef59ffab5caeedc37e8
# Depend on its subpackages.
TERMUX_PKG_DEPENDS="frpc, frps"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	make frpc
	make frps
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/bin bin/frpc
	install -Dm700 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/bin bin/frps
}
