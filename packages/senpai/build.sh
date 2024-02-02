TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~taiite/senpai
TERMUX_PKG_DESCRIPTION="An IRC client that works best with bouncers"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.3.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://git.sr.ht/~taiite/senpai/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=c02f63a7d76ae13ed888fc0de17fa9fd5117dcb3c9edc5670341bf2bf3b88718
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
