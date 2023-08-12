TERMUX_PKG_HOMEPAGE=https://keybase.io
TERMUX_PKG_DESCRIPTION="Key directory that maps social media identities to encryption keys"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/keybase/client/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=27bec1e7819a56618fbb13ada02930c09569bafe725513c400899d6a8c9b41d3
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
