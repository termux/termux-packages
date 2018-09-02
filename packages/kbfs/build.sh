TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="keybase kbfs"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_SHA256=0f9f785dfa95f4b93a24d18dff4d6a0a8e637139873370eb3f2a8c8d67505dd4
TERMUX_PKG_SRCURL=https://github.com/keybase/kbfs/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/keybase
	ln -sf "$PWD" .gopath/src/github.com/keybase/kbfs
	export GOPATH="$PWD/.gopath"

	go build -v -o git-remote-keybase github.com/keybase/kbfs/kbfsgit/git-remote-keybase

	cp git-remote-keybase $TERMUX_PREFIX/bin/git-remote-keybase
}
