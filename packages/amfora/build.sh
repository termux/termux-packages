TERMUX_PKG_HOMEPAGE=https://github.com/makeworld-the-better-one/amfora
TERMUX_PKG_DESCRIPTION="Aims to be the best looking Gemini client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.2
TERMUX_PKG_SRCURL=https://github.com/makeworld-the-better-one/amfora/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81bb4605920955ddbeb0e7236be4f89979ab543fd41b34ea4a4846ac947147e2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
