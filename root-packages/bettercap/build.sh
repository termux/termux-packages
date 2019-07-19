TERMUX_PKG_HOMEPAGE=https://www.bettercap.org
TERMUX_PKG_DESCRIPTION="The Swiss Army knife for 802.11, BLE and Ethernet networks reconnaissance and MITM attacks"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.24.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/bettercap/bettercap/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=590cef2b2b24fd9f67c57c8cb19ab8ff08b11d43bfc23b468013ddad907bb8b8
TERMUX_PKG_DEPENDS="libpcap, libusb"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	termux_setup_golang
}

termux_step_make() {
	make build
}

termux_step_make_install() {
	install bettercap $TERMUX_PREFIX/bin/
}
