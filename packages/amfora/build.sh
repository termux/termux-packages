TERMUX_PKG_HOMEPAGE=https://github.com/makew0rld/amfora
TERMUX_PKG_DESCRIPTION="Aims to be the best looking Gemini client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/makew0rld/amfora/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=76ae120bdae9a1882acbb2b07a873a52e40265b3ef4c8291de0934c1e9b5982c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX VERSION=$TERMUX_PKG_VERSION"

termux_step_pre_configure() {
	termux_setup_golang
	sed -i 's|CGO_ENABLED=0|CGO_ENABLED=1|g' Makefile

	go mod init || :
	go mod tidy
}
