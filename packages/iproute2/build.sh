TERMUX_PKG_HOMEPAGE=https://wiki.linuxfoundation.org/networking/iproute2
TERMUX_PKG_DESCRIPTION="Utilities for controlling networking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13.0"
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a43aa43338d882b44d01e549f3f105a92ae9feea32a82fae45a88e7a49302819
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
	LDFLAGS+=" -landroid-glob"
}
