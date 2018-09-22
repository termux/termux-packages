TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e19fb5e01ea5a707e2a8cb96f537fbd9f3a913d53d804a3265e3aeab3d2064c6

termux_step_post_make_install() {
	install -Dm700 upnpc-static "${TERMUX_PREFIX}/bin/upnpc"
}
