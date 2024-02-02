TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~emersion/hut
TERMUX_PKG_DESCRIPTION="A CLI tool for sr.ht"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_SRCURL=https://git.sr.ht/~emersion/hut/refs/download/v${TERMUX_PKG_VERSION}/hut-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=866c02f89e2597355dd10a445b3fbec826fbb47657bcdc6014d50084f23d88ee
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
