TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="Simbad Marino <cctechmx@gmail.com>"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5960a0dbf57c7867cc76189b66a4867f7da899f222bd32c53d226f3090c600e5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
	export CGO_ENABLED=0
}

termux_step_make() {
	make build
}

termux_step_make_install() {
	install -m700 cmd/btfs/btfs $TERMUX_PREFIX/bin/btfs2
}
