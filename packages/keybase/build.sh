TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.7.1
TERMUX_PKG_SRCURL=https://github.com/keybase/client/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b51262582db59c0f9b3b63f488632f4cad2b769aded0aaaa8a4e5c85988e5bb
TERMUX_PKG_REPLACES="kbfs"
TERMUX_PKG_CONFLICTS="kbfs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/keybase
	ln -sf "$PWD" .gopath/src/github.com/keybase/client
	export GOPATH="$PWD/.gopath"
	
	# TODO: Cache Golang dependencies
	go build -v -tags 'production' -o keybase ./keybase/client/go/keybase/main.go
	go build -v -tags 'production' -o git-remote-keybase ./keybase/client/go/kbfs/kbfsgit/git-remote-keybase/main.go
	go build -v -tags 'production' -o kbfsfusebin ./keybase/client/go/kbfs/kbfsfuse/main.go

	cp keybase $TERMUX_PREFIX/bin/keybase
	cp git-remote-keybase $TERMUX_PREFIX/bin/git-remote-keybase
	cp kbfsfusebin $TERMUX_PREFIX/bin/kbfsfuse
}
