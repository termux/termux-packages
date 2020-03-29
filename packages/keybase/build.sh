TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=5.3.1
TERMUX_PKG_SRCURL=https://github.com/keybase/client/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6bff8f3e892bcfda21a608ae1c38f8d5428882b517f61e2dc429259ff07e30cb
TERMUX_PKG_REPLACES="kbfs"
TERMUX_PKG_CONFLICTS="kbfs"

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/keybase
	ln -sf "$PWD" .gopath/src/github.com/keybase/client
	export GOPATH="$PWD/.gopath"

	go build -v -tags 'production' -o keybase github.com/keybase/client/go/keybase
	go build -v -tags 'production' -o git-remote-keybase github.com/keybase/client/go/kbfs/kbfsgit/git-remote-keybase
	go build -v -tags 'production' -o kbfsfusebin github.com/keybase/client/go/kbfs/kbfsfuse

	cp keybase $TERMUX_PREFIX/bin/keybase
	cp git-remote-keybase $TERMUX_PREFIX/bin/git-remote-keybase
	cp kbfsfusebin $TERMUX_PREFIX/bin/kbfsfuse
}
