TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="Hugo Wang <w@mitnk.com>"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8c037894ff9bb1225e1406ce2efbe14197441b920f91bbd6281e7553c3b322a0
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    rm -f Makefile
}
