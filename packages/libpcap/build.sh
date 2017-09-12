TERMUX_PKG_HOMEPAGE=http://www.tcpdump.org/
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_VERSION=1.8.1
TERMUX_PKG_REVISION=1
# The main tcpdump.org was down 2017-04-12, so we're using a mirror:
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpcap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8360a05884fc03d1acb8ae40f92eabacf30ef18a4fb4662ac4bc50eab8c37eb0
# ac_cv_lib_nl_3_nl_socket_alloc=no to avoid linking against libnl:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_nl_3_nl_socket_alloc=no --with-pcap=linux"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
TERMUX_PKG_BUILD_IN_SRC="yes"
