TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.8.1
TERMUX_PKG_SRCURL=https://github.com/keybase/client/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=25539ff5b3bad939c9a481ccae89913c1d14aab7f2ac9756a4c231b01ce3fc61
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_REPLACES="kbfs"
TERMUX_PKG_CONFLICTS="kbfs"

termux_step_make() {
	termux_setup_golang

	cd $TERMUX_PKG_SRCDIR

	mkdir -p .gopath/src/github.com/keybase
	ln -sf "$PWD" .gopath/src/github.com/keybase/client
	export GOPATH="$PWD/.gopath"

	# https://github.com/keybase/client/issues/24479#issuecomment-803013019
	go env -w GO111MODULE=auto

	go build -v -tags 'production' -o keybase github.com/keybase/client/go/keybase
	go build -v -tags 'production' -o git-remote-keybase github.com/keybase/client/go/kbfs/kbfsgit/git-remote-keybase
	go build -v -tags 'production' -o kbfsfusebin github.com/keybase/client/go/kbfs/kbfsfuse
}

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/keybase $TERMUX_PREFIX/bin/keybase
	cp $TERMUX_PKG_SRCDIR/git-remote-keybase $TERMUX_PREFIX/bin/git-remote-keybase
	cp $TERMUX_PKG_SRCDIR/kbfsfusebin $TERMUX_PREFIX/bin/kbfsfuse
}
