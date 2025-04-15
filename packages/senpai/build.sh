TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~delthas/senpai
TERMUX_PKG_DESCRIPTION="An IRC client that works best with bouncers"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.4.1"
TERMUX_PKG_SRCURL=https://git.sr.ht/~delthas/senpai/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=ab786b7b3cffce69d080c3b58061e14792d9065ba8831f745838c850acfeab24
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
