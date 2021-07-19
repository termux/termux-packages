TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="Hugo Wang <w@mitnk.com>"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9.21
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad1d3f9b954e73516fc8031c1b35cd28f14ce26fe3ee0468ec9c5eaace257fc3
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
    rm -f Makefile
}
