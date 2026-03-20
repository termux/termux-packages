TERMUX_PKG_HOMEPAGE=https://github.com/fatedier/frp
TERMUX_PKG_DESCRIPTION="A fast reverse proxy to expose a local server behind a NAT or firewall to the internet"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.68.0"
TERMUX_PKG_SRCURL=https://github.com/fatedier/frp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f7678f5c9d3934687976e493a8c5ce9e0d6da39fdea4c7a2fa03a2c289866ac3
TERMUX_PKG_REPLACES="frpc, frps"
TERMUX_PKG_BREAKS="frpc, frps"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	(
		termux_setup_nodejs
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP PREFIX PKGCONFIG PKG_CONFIG PKG_CONFIG_DIR PKG_CONFIG_LIBDIR
		pushd web/frpc
		npm install
		npm run build
		popd # web/frpc
		pushd web/frps
		npm install
		npm run build
		popd # web/frps
	)

	termux_setup_golang
	make frpc
	make frps
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/frpc
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/frps
}
