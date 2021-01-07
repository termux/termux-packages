TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3a3167e57727bf1d2a7b4861f7c7b57a663f58b9cf68227762ed2fc64e8ea11f
TERMUX_PKG_BREAKS="miniupnpc-dev"
TERMUX_PKG_REPLACES="miniupnpc-dev"

termux_step_post_make_install() {
	install -Dm700 upnpc-static "$TERMUX_PREFIX/bin/upnpc"
}
