TERMUX_PKG_HOMEPAGE=https://github.com/lnslbrty/ptunnel-ng
TERMUX_PKG_DESCRIPTION="Tunnel TCP connections through ICMP"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.43"
TERMUX_PKG_SRCURL=https://github.com/lnslbrty/ptunnel-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f16acc94b5387e8d88f510971a82ce25dcf2d0d599718e7eefb0ee26494dd665
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fi
}
