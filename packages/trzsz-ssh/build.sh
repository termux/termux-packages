TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/ssh
TERMUX_PKG_DESCRIPTION="An openssh client alternative"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.24"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8c7ef4ace4c7aed564f447f3f91142367f782eef87b58a95f587480ca1ae08ba
TERMUX_PKG_RECOMMENDS='trzsz-go'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
BIN_DST=$TERMUX_PREFIX/bin
"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
