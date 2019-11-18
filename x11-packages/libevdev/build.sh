TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=20d3cae4efd277f485abdf8f2a7c46588e539998b5a08c2c4d368218379d4211
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"

termux_step_pre_configure() {
	autoreconf -i
}
