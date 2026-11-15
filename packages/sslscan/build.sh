TERMUX_PKG_HOMEPAGE=https://github.com/rbsec/sslscan
TERMUX_PKG_DESCRIPTION="Utility to discover supported cipher suites on SSL/TLS enabled servers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.4"
TERMUX_PKG_SRCURL=https://github.com/rbsec/sslscan/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93674469cfbfea7326e5236165b1824df5fbab32a9e0499f03edc10b36befff2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl (>= 3.5.0)"
TERMUX_PKG_BUILD_IN_SRC=true
