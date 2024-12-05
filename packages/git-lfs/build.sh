TERMUX_PKG_HOMEPAGE=https://git-lfs.github.com/
TERMUX_PKG_DESCRIPTION="Git extension for versioning large files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.0"
TERMUX_PKG_SRCURL=https://github.com/git-lfs/git-lfs/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=329173f2b543f554d2a8f90ffd655e26430c61d4ab1811dbeea9dd4640e3e076
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
