TERMUX_PKG_HOMEPAGE=https://libcec.pulse-eight.com/
TERMUX_PKG_DESCRIPTION="Provides support for Pulse-Eight's USB-CEC adapter and other CEC capable hardware"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.0"
TERMUX_PKG_SRCURL=https://github.com/Pulse-Eight/libcec/archive/libcec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f9e57ae9fad37649adb6749b8f1310a71ccf3e92ae8b2d1cc9e8ae2d1da83f8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libp8-platform"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/debian/cec-client.1
}
