TERMUX_PKG_HOMEPAGE=https://keybase.io/docs/kbfs
TERMUX_PKG_DESCRIPTION="Keybase Filesystem"
TERMUX_PKG_VERSION=2.5.0.001
TERMUX_PKG_SHA256=792dfdfb6c944e86aa02454742d33c2984f58fafa5ea1a919403a0b38e286fb6
#TERMUX_PKG_SRCURL=https://github.com/keybase/kbfs/archive/v${TERMUX_PKG_VERSION}.tar.gz
# Temporary tag to get everything working on Android
TERMUX_PKG_SRCURL=https://github.com/keybase/kbfs/archive/initial-git-on-android.tar.gz

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
