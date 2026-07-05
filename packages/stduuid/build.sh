TERMUX_PKG_HOMEPAGE=https://github.com/mariusbancila/stduuid
TERMUX_PKG_DESCRIPTION="C++17 cross-platform single-header library implementation for universally unique identifiers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.3"
TERMUX_PKG_SRCURL="https://github.com/mariusbancila/stduuid/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b1176597e789531c38481acbbed2a6894ad419aab0979c10410d59eb0ebf40d3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUUID_BUILD_TESTS=OFF
"
