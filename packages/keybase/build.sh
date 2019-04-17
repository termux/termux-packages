TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=ed977c45f3a888d291aaf46afc1e1e32e4851d44b26a39854f00a0003b7556b5
TERMUX_PKG_SRCURL=https://github.com/keybase/client/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/keybase
	ln -sf "$PWD" .gopath/src/github.com/keybase/client
	export GOPATH="$PWD/.gopath"

	go build -v -tags 'production' -o keybase github.com/keybase/client/go/keybase

	cp keybase $TERMUX_PREFIX/bin/keybase
}
