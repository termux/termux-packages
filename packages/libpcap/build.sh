TERMUX_PKG_HOMEPAGE=https://www.tcpdump.org
TERMUX_PKG_DESCRIPTION="Library for network traffic capture"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=b4f87ce52bba24111faf048d3f6450f116b42fe849bc1b997e494f605b3d2735
TERMUX_PKG_BREAKS="libpcap-dev"
TERMUX_PKG_REPLACES="libpcap-dev"
# The main tcpdump.org was down 2017-04-12, so we're using a mirror:
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpcap-${TERMUX_PKG_VERSION}.tar.xz
# ac_cv_lib_nl_3_nl_socket_alloc=no to avoid linking against libnl:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_nl_3_nl_socket_alloc=no --with-pcap=linux"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcap-config share/man/man1/pcap-config.1"
TERMUX_PKG_BUILD_IN_SRC=true
