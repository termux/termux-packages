TERMUX_PKG_HOMEPAGE=https://www.tcpdump.org
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.4
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpcap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bc6fa883db17cf8846de620e591ebc1af2a82fcc5bf7b3d1671d25ef61d9513c
TERMUX_PKG_BREAKS="libpcap-dev"
TERMUX_PKG_REPLACES="libpcap-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-pcap=linux --without-libnl"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
