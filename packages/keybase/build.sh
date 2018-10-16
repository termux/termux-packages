TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="keybase"
TERMUX_PKG_VERSION=2.7.3
TERMUX_PKG_SHA256=cc14d469dd3c174c89d16c3ff5bf794f359b1c177af45a5c838f6dbbbcadf569
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
