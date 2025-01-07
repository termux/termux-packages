TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/rp-pppoe/
TERMUX_PKG_DESCRIPTION="A PPP-over-Ethernet redirector for pppd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0
#TERMUX_PKG_SRCURL=https://dianne.skoll.ca/projects/rp-pppoe/download/rp-pppoe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/rp-pppoe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41ac34e5db4482f7a558780d3b897bdbb21fae3fef4645d2852c3c0c19d81cea
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
}
