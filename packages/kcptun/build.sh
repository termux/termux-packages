TERMUX_PKG_HOMEPAGE=https://github.com/xtaci/kcptun
TERMUX_PKG_DESCRIPTION="A Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20250612"
TERMUX_PKG_SRCURL=https://github.com/xtaci/kcptun/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4c4a3e6af72058174c5fe47c92cabea5b326a7cf1402248d6906d5f08cc6c5b9
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
