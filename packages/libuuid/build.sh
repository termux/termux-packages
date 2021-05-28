TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/libuuid/
TERMUX_PKG_DESCRIPTION="Portable uuid C library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libuuid/libuuid-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=46af3275291091009ad7f1b899de3d0cea0252737550e7919d17237997db5644
TERMUX_PKG_BREAKS="libuuid-dev"
TERMUX_PKG_REPLACES="libuuid-dev"

termux_step_pre_configure() {
	autoreconf -vfi
}