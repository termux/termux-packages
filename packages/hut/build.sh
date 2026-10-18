TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~xenrox/hut
TERMUX_PKG_DESCRIPTION="A CLI tool for sr.ht"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL="https://git.sr.ht/~xenrox/hut/refs/download/v${TERMUX_PKG_VERSION}/hut-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f21ad1e0f93e961a087a446e7433dc8cd3451034c20dd1dc832aeec480de62cd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
