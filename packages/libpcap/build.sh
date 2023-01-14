TERMUX_PKG_HOMEPAGE=https://www.tcpdump.org
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpcap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e87410af2d2a0c8c0ab29685571006286d680829149378a6de2fe75bfbd6b2e7
TERMUX_PKG_BREAKS="libpcap-dev"
TERMUX_PKG_REPLACES="libpcap-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-pcap=linux --without-libnl"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
