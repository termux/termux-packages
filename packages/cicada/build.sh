TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="Hugo Wang <w@mitnk.com>"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9.11
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a3755aab5c60887587e2e98d0786e7cbf03b9871e931d2a6a177aa093427253d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    rm -f Makefile
}
