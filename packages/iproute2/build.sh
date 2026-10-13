TERMUX_PKG_HOMEPAGE=https://wiki.linuxfoundation.org/networking/iproute2
TERMUX_PKG_DESCRIPTION="Utilities for controlling networking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.2.0"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/snapshot/iproute2-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=30700923d57f05fa633065f89291ee49c6a8911a9578478c62eaf125470fbd22
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--color=auto"

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
	LDFLAGS+=" -landroid-glob"
}
