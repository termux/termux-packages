TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="Hugo Wang <w@mitnk.com>"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9.15
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ac0b2ece296817a6eda3b835bf0479ce38c7d12e35f7a023a57fcbd9901a97ca
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    rm -f Makefile
}
