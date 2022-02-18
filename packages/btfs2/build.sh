TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="Simbad Marino <cctechmx@gmail.com>"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81a80a66d4a328ea0a355a0f10e32c0821c6f79c7a39e310410de6c77ece5683
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
