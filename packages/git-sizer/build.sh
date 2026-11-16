TERMUX_PKG_HOMEPAGE=https://github.com/github/git-sizer
TERMUX_PKG_DESCRIPTION="Compute various size metrics for a Git repository"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/github/git-sizer/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2c6355a9ccdaa6bbe03fa309e087483961afefcfbf354491a419e1d5e6c1bbd1
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
