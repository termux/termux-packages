TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.7"
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=0caf824971108f15bb2ad356433bae198d7d3bf1e82d43f63626e069e060bfa6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man1/
"

termux_step_pre_configure() {
	autoreconf -i
}
