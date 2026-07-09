TERMUX_PKG_HOMEPAGE=https://mirrors.edge.kernel.org/pub/software/network/ethtool/
TERMUX_PKG_DESCRIPTION="standard Linux utility for controlling network drivers and hardware, particularly for wired Ethernet devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.1"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/snapshot/ethtool-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=a9828b70956d3c6c042cf9d4ad477b1efb851e72579f78a31545dcf5133beea5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmnl"

termux_step_pre_configure() {
	autoreconf -fi
}
