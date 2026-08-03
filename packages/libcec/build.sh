TERMUX_PKG_HOMEPAGE=https://libcec.pulse-eight.com/
TERMUX_PKG_DESCRIPTION="Provides support for Pulse-Eight's USB-CEC adapter and other CEC capable hardware"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.1.4"
TERMUX_PKG_SRCURL=https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=61302836cc21c610b6fe0c751e4f130296828f191ee2650f80f73a376fe8c90d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libp8-platform"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/debian/cec-client.1
}
