TERMUX_PKG_HOMEPAGE=http://www.tcpdump.org/
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_VERSION=1.8.1
TERMUX_PKG_SRCURL=http://www.tcpdump.org/release/libpcap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-pcap=linux"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
TERMUX_PKG_BUILD_IN_SRC="yes"
