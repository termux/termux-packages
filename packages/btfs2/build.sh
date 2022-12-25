TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="Simbad Marino <cctechmx@gmail.com>"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b2184c3102864b7dd642d28bc6b012641e6178f7acb39fabf2bf485ecce9f72a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="btfs"
TERMUX_PKG_REPLACES="btfs"

termux_step_pre_configure() {
	termux_setup_golang
	go mod init || :
	go mod tidy

	# Please do not ever disable CGO:
	# https://github.com/termux/termux-packages/issues/9094
	local _GOPATH=$(go env GOPATH)
	pushd $_GOPATH/pkg/mod/github.com/karalabe/usb@*
	local target=hidapi/libusb/hid.c
	chmod 0755 $(dirname $target)
	chmod 0644 $target
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/karalabe-usb-pthread_barrier.patch.diff || :
	popd
}

termux_step_make() {
	make build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/cmd/btfs/btfs
	ln -sfT btfs $TERMUX_PREFIX/bin/btfs2
}
