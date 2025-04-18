TERMUX_PKG_HOMEPAGE=https://github.com/hon4/hTorrentCreatorCLI
TERMUX_PKG_DESCRIPTION="A simple command line torrent creator."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION="0.0.1"
TERMUX_PKG_SRCURL=https://github.com/hon4/hTorrentCreatorCLI/releases/download/v${TERMUX_PKG_VERSION}/hTorrentCreatorCLI-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f088ce58cc34efdd0d2d8ca0fb5c7c68b564dac03511faee80882ac427ce489d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="clang, openssl"
TERMUX_PKG_SRCDIR=$TERMUX_PKG_BUILDDIR/hTorrentCreatorCLI-${TERMUX_PKG_VERSION}

termux_step_make() {
	make -C $TERMUX_PKG_SRCDIR
}

termux_step_make_install() {
	make -C $TERMUX_PKG_SRCDIR BINDIR="$TERMUX_PREFIX/bin" install
}
