TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="Simbad Marino <cctechmx@gmail.com>"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85a12f42339b41de4b0cd3096df93f654053836b164a4f92f482d315a4a353b2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	make build || :
	local _GOPATH=$(go env GOPATH)
	pushd $_GOPATH/pkg/mod/github.com/karalabe/usb@*
	local target=hidapi/libusb/hid.c
	chmod 0755 $(dirname $target)
	chmod 0644 $target
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/karalabe-usb-pthread_barrier.patch.diff
	popd
	make build
	mv $TERMUX_PKG_SRCDIR/cmd/btfs/btfs $TERMUX_PKG_SRCDIR/cmd/btfs/btfs2
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/cmd/btfs/btfs2
}
