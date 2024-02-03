TERMUX_PKG_HOMEPAGE=https://ipset.netfilter.org
TERMUX_PKG_DESCRIPTION="Administration tool for kernel IP sets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION="7.20"
TERMUX_PKG_SRCURL=https://ipset.netfilter.org/ipset-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6ae85b1d81832c2b67df7330d3671a3462e39ec98328056a18a29d44c27709e5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmnl"
TERMUX_PKG_BREAKS="ipset-dev"
TERMUX_PKG_REPLACES="ipset-dev"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-kmod=no
"

termux_step_pre_configure() {
	# Workaround for version script error
	LDFLAGS+=" -Wl,--undefined-version"
}
