TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d52a0afa614ad6c088cc9ddff1ae7d29c8c595ac5fdd321170a05f41e634bd1a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="miniupnpc-dev"
TERMUX_PKG_REPLACES="miniupnpc-dev"

termux_step_post_make_install() {
	ln -sfT upnpc-static "$TERMUX_PREFIX/bin/upnpc"
}

termux_step_post_massage() {
	local _EXTERNAL_IP="bin/external-ip.sh"
	if [ -f "${_EXTERNAL_IP}" ]; then
		chmod 0700 "${_EXTERNAL_IP}"
	fi
}
