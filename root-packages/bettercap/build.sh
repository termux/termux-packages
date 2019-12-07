TERMUX_PKG_HOMEPAGE=https://www.bettercap.org
TERMUX_PKG_DESCRIPTION="The Swiss Army knife for 802.11, BLE and Ethernet networks reconnaissance and MITM attacks"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.26.1
TERMUX_PKG_SRCURL=https://github.com/bettercap/bettercap/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=75530015ee27e5ba05faff0295486ca85489ecd9de3161ca398a9b577522c578
TERMUX_PKG_DEPENDS="libpcap, libusb"
# x86_64 seem to depend on libnetfilter_queue
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

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
