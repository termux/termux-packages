TERMUX_PKG_HOMEPAGE=https://mirrors.edge.kernel.org/pub/software/network/ethtool/
TERMUX_PKG_DESCRIPTION="standard Linux utility for controlling network drivers and hardware, particularly for wired Ethernet devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.2"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/snapshot/ethtool-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=dfb3b8a273fbcb414dfdfb38398e48f987238ff9b89abf902fe24e1c039997ce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmnl"

termux_step_pre_configure() {
	autoreconf -fi
}
