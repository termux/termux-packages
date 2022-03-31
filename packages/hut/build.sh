TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~emersion/hut
TERMUX_PKG_DESCRIPTION="A CLI tool for sr.ht"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SRCURL=https://git.sr.ht/~emersion/hut/refs/download/v${TERMUX_PKG_VERSION}/hut-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b1ec695fa670f5df9594e4fdfc51b2e62f16797c5ef9ab27283310badd6f065
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
