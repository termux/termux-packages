TERMUX_PKG_HOMEPAGE=http://enet.bespin.org
TERMUX_PKG_DESCRIPTION="ENet reliable UDP networking library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ravener"
TERMUX_PKG_VERSION="1.3.18"
TERMUX_PKG_SRCURL=http://enet.bespin.org/download/enet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a8a0c5360d68bb4fcd11f2e4c47c69976e8d2c85b109dd7d60b1181a4f85d36

termux_step_pre_configure() {
	autoreconf -vfi
}
