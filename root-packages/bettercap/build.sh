TERMUX_PKG_HOMEPAGE=https://www.bettercap.org
TERMUX_PKG_DESCRIPTION="The Swiss Army knife for 802.11, BLE and Ethernet networks reconnaissance and MITM attacks"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.24.1
TERMUX_PKG_SRCURL=https://github.com/bettercap/bettercap/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=590cef2b2b24fd9f67c57c8cb19ab8ff08b11d43bfc23b468013ddad907bb8b8
TERMUX_PKG_DEPENDS="libpcap, libusb"

termux_step_configure() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR	
	export CGO_CFLAGS="-I$TERMUX_PREFIX/include"

	mkdir -p "$GOPATH"/src/github.com/bettercap/
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/bettercap/bettercap
        go get github.com/bettercap/recording
}

termux_step_make() {
	cd src/github.com/bettercap/bettercap
	make build
}

termux_step_make_install() {
	cd src/github.com/bettercap/bettercap
	make install
}
