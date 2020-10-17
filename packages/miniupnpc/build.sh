TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.1.20201016
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=69f72fe355f911b807915f78dcfc0af772c0f22bc7ab1157e70f334e37db7d39
TERMUX_PKG_BREAKS="miniupnpc-dev"
TERMUX_PKG_REPLACES="miniupnpc-dev"

termux_step_post_make_install() {
	install -Dm700 upnpc-static "$TERMUX_PREFIX/bin/upnpc"
}
