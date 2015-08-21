TERMUX_PKG_HOMEPAGE=http://www.tcpdump.org/
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_SRCURL=http://www.tcpdump.org/release/libpcap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-pcap=linux"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
TERMUX_PKG_BUILD_IN_SRC="yes"
