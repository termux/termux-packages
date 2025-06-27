TERMUX_PKG_HOMEPAGE=https://git-lfs.github.com/
TERMUX_PKG_DESCRIPTION="Git extension for versioning large files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.7.0"
TERMUX_PKG_SRCURL=https://github.com/git-lfs/git-lfs/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ab173702840627feb5f8a408dd5406fa322f3eadaa69938d9226b183d5be25a6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	! $TERMUX_ON_DEVICE_BUILD && GOOS=linux GOARCH=amd64 CC=gcc LD=gcc go generate ./commands
	go build git-lfs.go
}

termux_step_make_install() {
	install -Dm700 git-lfs "$TERMUX_PREFIX"/bin/git-lfs
}
