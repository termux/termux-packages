TERMUX_PKG_HOMEPAGE=https://mirrors.edge.kernel.org/pub/software/network/ethtool/
TERMUX_PKG_DESCRIPTION="standard Linux utility for controlling network drivers and hardware, particularly for wired Ethernet devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/snapshot/ethtool-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=fb4b77f1e915e14a94f289bd1429ef5a68fe5e8eaaa28212d4f220eda5321b5e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmnl"

termux_step_pre_configure() {
	autoreconf -fi
}
