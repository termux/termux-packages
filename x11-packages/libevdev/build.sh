TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=63f4ea1489858a109080e0b40bd43e4e0903a1e12ea888d581db8c495747c2d0
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"

termux_step_pre_configure() {
	autoreconf -i
}
