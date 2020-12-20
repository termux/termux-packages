TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ff56bec3e5a3aec41f4decb43cb0b925231d6ab4cdfd7a74caa5c7c1043c4ef0
TERMUX_PKG_BREAKS="miniupnpc-dev"
TERMUX_PKG_REPLACES="miniupnpc-dev"

termux_step_post_make_install() {
	install -Dm700 upnpc-static "$TERMUX_PREFIX/bin/upnpc"
}
