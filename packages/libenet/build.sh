TERMUX_PKG_HOMEPAGE=http://enet.bespin.org
TERMUX_PKG_DESCRIPTION="ENet reliable UDP networking library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ravener"
TERMUX_PKG_VERSION=1.3.17
TERMUX_PKG_SRCURL=http://enet.bespin.org/download/enet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a38f0f194555d558533b8b15c0c478e946310022d0ec7b34334e19e4574dcedc

termux_step_pre_configure() {
	autoreconf -vfi
}
