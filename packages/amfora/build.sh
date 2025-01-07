TERMUX_PKG_HOMEPAGE=https://github.com/makeworld-the-better-one/amfora
TERMUX_PKG_DESCRIPTION="Aims to be the best looking Gemini client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/makeworld-the-better-one/amfora/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0bc9964ccefb3ea0d66944231492f66c3b0009ab0040e19cc115d0b4cd9b8078
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX VERSION=$TERMUX_PKG_VERSION"

termux_step_pre_configure() {
	termux_setup_golang
	sed -i 's|CGO_ENABLED=0|CGO_ENABLED=1|g' Makefile

	go mod init || :
	go mod tidy
}
