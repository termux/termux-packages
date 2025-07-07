TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.0"
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c8dfb0f61eceee7d187f26780edeeaac604b2d34eeea6f64cd7da253684c633f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="btfs"
TERMUX_PKG_REPLACES="btfs"

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
