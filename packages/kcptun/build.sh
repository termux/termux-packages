TERMUX_PKG_HOMEPAGE=https://github.com/xtaci/kcptun
TERMUX_PKG_DESCRIPTION="A Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20241119"
TERMUX_PKG_SRCURL=https://github.com/xtaci/kcptun/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a591b539e6a0d2a3b652fa5825fc81b4c3b087412d8692403b0b831fd11014b2
TERMUX_PKG_REPLACES="kcptun-client, kcptun-server"
TERMUX_PKG_BREAKS="kcptun-client, kcptun-server"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	LDFLAGS="-X main.VERSION=${TERMUX_PKG_VERSION#*:} -s -w"
	GCFLAGS=""

	go build -mod=vendor -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcptun-client github.com/xtaci/kcptun/client
	go build -mod=vendor -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcptun-server github.com/xtaci/kcptun/server
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin kcptun-client
	install -Dm700 -t "${TERMUX_PREFIX}"/bin kcptun-server

}
