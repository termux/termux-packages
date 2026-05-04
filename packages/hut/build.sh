TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~xenrox/hut
TERMUX_PKG_DESCRIPTION="A CLI tool for sr.ht"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://git.sr.ht/~xenrox/hut/refs/download/v${TERMUX_PKG_VERSION}/hut-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b7ebc3618603df2e72635cdb2358e5ca2db2e92ce257fa78a72e8de7b25e9ae7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
