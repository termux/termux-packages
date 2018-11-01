TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="keybase"
TERMUX_PKG_VERSION=2.8.0
TERMUX_PKG_SHA256=7123d041682ee7958c408b63d6d6ae488d0cc7994249cda5f35c8cf12b348400
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
