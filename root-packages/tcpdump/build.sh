TERMUX_PKG_HOMEPAGE=https://www.tcpdump.org/
TERMUX_PKG_DESCRIPTION="A powerful command-line packet analyzer"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.99.2
TERMUX_PKG_SRCURL=https://www.tcpdump.org/release/tcpdump-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4304357d34b79d46f4e17e654f1f91f9ce4e3d5608a1badbd53295a26fb44d5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_linux_vers=3.4"
TERMUX_PKG_RM_AFTER_INSTALL="bin/tcpdump.${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libcap-ng, libpcap, openssl"
