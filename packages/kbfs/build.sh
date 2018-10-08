TERMUX_PKG_HOMEPAGE=https://keybase.io/docs/kbfs
TERMUX_PKG_DESCRIPTION="Keybase Filesystem"
TERMUX_PKG_VERSION=2.6.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=acdb89f07d6523bb3112f9105ffd10419ab8a3d08db1cb8d5507cfb8202d85cf
TERMUX_PKG_SRCURL=https://github.com/keybase/kbfs/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="keybase"

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/keybase
	ln -sf "$PWD" .gopath/src/github.com/keybase/kbfs
	export GOPATH="$PWD/.gopath"

	go build -v -tags 'production' -o git-remote-keybase github.com/keybase/kbfs/kbfsgit/git-remote-keybase
	go build -v -tags 'production' -o kbfsfusebin github.com/keybase/kbfs/kbfsfuse

	cp git-remote-keybase $TERMUX_PREFIX/bin/git-remote-keybase
	cp kbfsfusebin $TERMUX_PREFIX/bin/kbfsfuse
}
