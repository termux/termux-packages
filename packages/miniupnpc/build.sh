TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="Small UPnP client library and tool to access Internet Gateway Devices"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/miniupnpc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=05b929679091b9921b6b6c1f25e39e4c8d1f4d46c8feb55a412aa697aee03a93
# The miniupnp project breaks API and ABI compatibility even in minor releases
# (see https://github.com/miniupnp/miniupnp/issues/758), so do not auto update
# - the changelog needs to be checked for ABI and/or API breakage:
TERMUX_PKG_AUTO_UPDATE=false
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
