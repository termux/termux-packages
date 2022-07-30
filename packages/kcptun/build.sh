TERMUX_PKG_HOMEPAGE=https://github.com/xtaci/kcptun
TERMUX_PKG_DESCRIPTION="A Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20220628
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/xtaci/kcptun/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a63facc902594b4ca5f0456e58196cf7b2a2451594fe2f69b55ac712ceb85e8
# Depend on its subpackages.
TERMUX_PKG_DEPENDS="kcptun-client, kcptun-server"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	VERSION=`date -u +%Y%m%d`
	LDFLAGS="-X main.VERSION=$VERSION -s -w"
	GCFLAGS=""

	go build -mod=vendor -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcptun-client github.com/xtaci/kcptun/client
	go build -mod=vendor -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o kcptun-server github.com/xtaci/kcptun/server
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin kcptun-client
	install -Dm700 -t "${TERMUX_PREFIX}"/bin kcptun-server

}
