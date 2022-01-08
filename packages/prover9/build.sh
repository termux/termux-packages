TERMUX_PKG_HOMEPAGE=https://www.cs.unm.edu/~mccune/prover9/
TERMUX_PKG_DESCRIPTION="An automated theorem prover for first-order and equational logic"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2009-11A
TERMUX_PKG_SRCURL=https://www.cs.unm.edu/~mccune/mace4/download/LADR-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c32bed5807000c0b7161c276e50d9ca0af0cb248df2c1affb2f6fc02471b51d0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-e all"
TERMUX_MAKE_PROCESSES=1

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
}
