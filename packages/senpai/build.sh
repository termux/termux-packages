TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~taiite/senpai
TERMUX_PKG_DESCRIPTION="An IRC client that works best with bouncers"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.1.0
TERMUX_PKG_SRCURL=https://git.sr.ht/~taiite/senpai/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=98e1f16ed97433e1e8c8bdabac1cac1920ddcab90e6cef36d8817a41b45a94ff
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
