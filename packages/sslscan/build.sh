TERMUX_PKG_HOMEPAGE=https://github.com/rbsec/sslscan
TERMUX_PKG_DESCRIPTION="Utility to discover supported cipher suites on SSL/TLS enabled servers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_SRCURL=https://github.com/rbsec/sslscan/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=188b94d99072727e8abd1439359611c18ea6983c2c535eaef726bbc2144c933d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl (>= 3.5.0)"
TERMUX_PKG_BUILD_IN_SRC=true
