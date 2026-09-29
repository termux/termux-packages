TERMUX_PKG_HOMEPAGE=https://zsync.moria.org.uk/
TERMUX_PKG_DESCRIPTION="A file transfer program to download files from remote web servers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://zsync.moria.org.uk/download/zsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=58b02f27e14326b62b7fdd6ed431a3e243b1c5a3ea9e3c1678e136dbf00c238d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
}

termux_step_make() {
	export GOPATH="$TERMUX_PKG_SRCDIR/go"
	go build -o zsync ./cmd/zsync
	go build -o zsyncmake ./cmd/zsyncmake
}

termux_step_make_install() {
	install zsync zsyncmake "$TERMUX_PREFIX/bin"
	install -Dm644 man/zsync.1 "$TERMUX_PREFIX/share/man/man1/zync.1"
	install -Dm644 man/zsyncmake.1 "$TERMUX_PREFIX/share/man/man1/zsyncmake.1"
}
