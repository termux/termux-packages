TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/rp-pppoe/
TERMUX_PKG_DESCRIPTION="A PPP-over-Ethernet redirector for pppd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.15
#TERMUX_PKG_SRCURL=https://dianne.skoll.ca/projects/rp-pppoe/download/rp-pppoe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/rp-pppoe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1f318bc7e4e5b0fd8a8e23e8803f5e6e43165245a5a10a7162a92a6cf17829a
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
}
