TERMUX_PKG_HOMEPAGE=https://github.com/github/git-sizer
TERMUX_PKG_DESCRIPTION="Compute various size metrics for a Git repository"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=https://github.com/github/git-sizer/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5dafc4014d6bfae40e678d72c0a67a29cd9ac7b38a0894fc75ab8c05a9064a4b
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_CACHEDIR/go
	make
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin bin/git-sizer
}
