TERMUX_PKG_HOMEPAGE=https://github.com/mitnk/cicada
TERMUX_PKG_DESCRIPTION="A bash like Unix shell"
TERMUX_PKG_MAINTAINER="Hugo Wang <w@mitnk.com>"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9.12
TERMUX_PKG_SRCURL=https://github.com/mitnk/cicada/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6ae7063d586618ebf11d54bd45ffc27dc62933e7a58258c6ed1bfa3d16aa8508
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    rm -f Makefile
}
