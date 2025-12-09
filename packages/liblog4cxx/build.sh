TERMUX_PKG_HOMEPAGE="https://logging.apache.org/log4cxx/latest_stable/index.html"
TERMUX_PKG_DESCRIPTION="A logging framework for C++ patterned after Apache log4j"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/apache/logging-log4cxx/archive/refs/tags/rel/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c948a462fd0e04635ffee20527943e84ce4320e8389c3bbf298819a48134b321
TERMUX_PKG_DEPENDS="apr, apr-util, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBUILD_TESTING=OFF
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="rel/v\K\d+\.\d+\.\d+$"
