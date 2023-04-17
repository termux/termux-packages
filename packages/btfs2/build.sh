TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="Simbad Marino <cctechmx@gmail.com>"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=620b372fad23688ccd8941bd41e695586d0ea977b77b5dea0d1321f08ea39494
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="btfs"
TERMUX_PKG_REPLACES="btfs"
TERMUX_PKG_GO_USE_OLDER=true

termux_step_pre_configure() {
	termux_setup_golang
	go mod init || :
	go mod tidy
}

termux_step_make() {
	make build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/cmd/btfs/btfs
	ln -sfT btfs $TERMUX_PREFIX/bin/btfs2
}
