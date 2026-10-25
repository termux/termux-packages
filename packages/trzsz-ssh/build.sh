TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/ssh
TERMUX_PKG_DESCRIPTION="An openssh client alternative"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.27"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8655411ebe865b8d91463bc9ab336c14f8ff3eecf4889c3b2547e26559796b6f
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
