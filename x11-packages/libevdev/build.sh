TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=11dbe1f2b1d03a51f3e9a196757a75c3a999042ce34cf1fdc00a2363e5a2e369
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"

termux_step_pre_configure() {
	autoreconf -i
}
