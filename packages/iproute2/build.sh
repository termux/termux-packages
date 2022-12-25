TERMUX_PKG_HOMEPAGE=https://wiki.linuxfoundation.org/networking/iproute2
TERMUX_PKG_DESCRIPTION="Utilities for controlling networking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.1.0
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b58b95f34c5b6e8171d1833ccfcf43c86aaa064c99419bd1b2a2eb7ee741f089
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
	LDFLAGS+=" -landroid-glob"
}
