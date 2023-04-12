TERMUX_PKG_HOMEPAGE=https://github.com/ntop/n2n
TERMUX_PKG_DESCRIPTION="A light VPN software"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.1
TERMUX_PKG_SRCURL=https://github.com/ntop/n2n/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=311f89d147558ae4dfb0d8f8698f5429c05a3e19a9d25cb8c85bd73d02aff834
TERMUX_PKG_DEPENDS="libcap, libpcap, openssl, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_FORCE_CMAKE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-miniupnp
--disable-natpmp
--enable-pcap
--enable-cap
--disable-pthread
--with-zstd
--with-openssl
"
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	autoreconf -fi
}
