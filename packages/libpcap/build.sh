TERMUX_PKG_HOMEPAGE=https://www.tcpdump.org
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpcap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d12b42623eeefee872f123bd0dc85d535b00df4d42e865f993c40f7bfc92b1e
TERMUX_PKG_BREAKS="libpcap-dev"
TERMUX_PKG_REPLACES="libpcap-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-pcap=linux --without-libnl"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
