TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/
TERMUX_PKG_DESCRIPTION="A simple file transfer tools, similar to lrzsz ( rz / sz )"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.6"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df407875150a602d4869d9ac8d1ece690fe4cae5a95bc481fc546085ff8969c8
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
