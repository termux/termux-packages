TERMUX_PKG_HOMEPAGE=http://miniupnp.free.fr/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.7"
TERMUX_PKG_SRCURL=http://miniupnp.free.fr/files/miniupnpc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0c3a27056840fd0ec9328a5a9bac3dc5e0ec6d2e8733349cf577b0aa1e70ac1
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
