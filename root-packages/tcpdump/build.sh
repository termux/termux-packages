TERMUX_PKG_HOMEPAGE=https://www.tcpdump.org/
TERMUX_PKG_DESCRIPTION="A powerful command-line packet analyzer"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.99.7
TERMUX_PKG_SRCURL=https://www.tcpdump.org/release/tcpdump-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8be364e28d3b745ef1459b385cd2f4bc0e1ebad7a5d2ebdf70071d6c9b5b9a54
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_linux_vers=3.4"
TERMUX_PKG_RM_AFTER_INSTALL="bin/tcpdump.${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libcap-ng, libpcap, openssl"
TERMUX_PKG_AUTO_UPDATE=true
