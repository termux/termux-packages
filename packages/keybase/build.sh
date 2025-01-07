TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.0"
TERMUX_PKG_SRCURL=https://github.com/keybase/client/releases/download/v$TERMUX_PKG_VERSION/keybase-v$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=506916263f71a3ac8385228b3855d6ddb3f3168574179a0b10ab9867d18b0e3d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_REPLACES="kbfs"
TERMUX_PKG_CONFLICTS="kbfs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	cd go
	go mod init || :
	go mod tidy -compat=1.17
	mkdir .bin
	go build -v -tags 'production' -o ./.bin/keybase ./keybase
	go build -v -tags 'production' -o ./.bin/git-remote-keybase \
		./kbfs/kbfsgit/git-remote-keybase
	go build -v -tags 'production' -o ./.bin/kbfsfuse ./kbfs/kbfsfuse
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin \
		./go/.bin/{keybase,git-remote-keybase,kbfsfuse}
}
