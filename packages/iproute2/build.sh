TERMUX_PKG_HOMEPAGE=https://wiki.linuxfoundation.org/networking/iproute2
TERMUX_PKG_DESCRIPTION="Utilities for controlling networking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.2.0
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4d72730200ec5b2aabaa1a2f20553c6748292f065d9a154c7d5e22559df9fd62
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
	LDFLAGS+=" -landroid-glob"
}
