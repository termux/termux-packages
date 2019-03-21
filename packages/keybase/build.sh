TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="keybase"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=2.13.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=9b78ddee9c51f58ea7039a4220f4bccfcbd27ef85a1342e88d726876fc41782b
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
