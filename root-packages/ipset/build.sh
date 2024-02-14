TERMUX_PKG_HOMEPAGE=https://ipset.netfilter.org
TERMUX_PKG_DESCRIPTION="Administration tool for kernel IP sets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION="7.21"
TERMUX_PKG_SRCURL=https://ipset.netfilter.org/ipset-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e2c6ce4fcf3acb3893ca5d35c86935f80ad76fc5ccae601185842df760e0bc69
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
