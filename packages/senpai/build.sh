TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~taiite/senpai
TERMUX_PKG_DESCRIPTION="An IRC client that works best with bouncers"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.2.0
TERMUX_PKG_SRCURL=https://git.sr.ht/~taiite/senpai/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=9786fd83f3e1067549c3c88455a1f66ec66d993fe597cee334d217a5d1cf4803
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
