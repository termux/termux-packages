TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=e7e18a64264f2dea19b6c50a481f8c062529d42919ccda0bc861495bce28eb9e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"

termux_step_pre_configure() {
	autoreconf -i
}
