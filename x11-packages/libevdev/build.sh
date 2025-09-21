TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/libevdev/
TERMUX_PKG_DESCRIPTION="Wrapper library for evdev devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/libevdev/libevdev-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f00ab8d42ad8b905296fab67e13b871f1a424839331516642100f82ad88127cd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-test-run"
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man1/
"

termux_step_pre_configure() {
	autoreconf -i
}
