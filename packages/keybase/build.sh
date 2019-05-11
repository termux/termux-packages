TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=503e068e7e89a57c497e40cee5b161704c23919bc59846a6507dfc5ecd418091
TERMUX_PKG_SRCURL=https://github.com/keybase/client/archive/v${TERMUX_PKG_VERSION}.tar.gz
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

	mkdir -p $TERMUX_PREFIX/etc/profile.d/
	echo "export KEYBASE_SECRET_STORE_FILE=1" > $TERMUX_PREFIX/etc/profile.d/keybase.sh
}

termux_step_create_debscripts() {
    {
	echo "#!$TERMUX_PREFIX/bin/sh"
	echo "echo Before using keybase restart the termux session. Otherwise,"
	echo "echo keybase will throw an error about a not functional secret store"
	echo "exit 0"
    } > postinst
    chmod 0755 postinst
}
