TERMUX_PKG_HOMEPAGE=https://github.com/rbsec/sslscan
TERMUX_PKG_DESCRIPTION="Utility to discover supported cipher suites on SSL/TLS enabled servers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL=https://github.com/rbsec/sslscan/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17c6fe4a7822e1949bc8975feea59fcf042c4a46d62d9f5acffe59afc466cc1c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl (>= 3.5.0)"
TERMUX_PKG_BUILD_IN_SRC=true
