TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.1.20190824
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1fadefea0ecdceb3e35bb5d901f0db880c826740e93148ddfb087b4b4389e165
TERMUX_PKG_BREAKS="miniupnpc-dev"
TERMUX_PKG_REPLACES="miniupnpc-dev"

termux_step_post_make_install() {
	install -Dm700 upnpc-static "$TERMUX_PREFIX/bin/upnpc"
}
