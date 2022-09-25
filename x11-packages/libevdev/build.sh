TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13.0
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=9edf2006cc86a5055279647c38ec923d11a821ee4dc2c3033e8d20e8ee237cd9
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man1/
"

termux_step_pre_configure() {
	autoreconf -i
}
