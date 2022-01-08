TERMUX_PKG_HOMEPAGE=http://libcec.pulse-eight.com/
TERMUX_PKG_DESCRIPTION="Provides support for Pulse-Eight's USB-CEC adapter and other CEC capable hardware"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.2
TERMUX_PKG_SRCURL=https://github.com/Pulse-Eight/libcec/archive/libcec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=090696d7a4fb772d7acebbb06f91ab92e025531c7c91824046b9e4e71ecb3377
TERMUX_PKG_DEPENDS="libc++, libp8-platform"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/debian/cec-client.1
}
