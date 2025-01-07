TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/
TERMUX_PKG_DESCRIPTION="A simple file transfer tools, similar to lrzsz ( rz / sz )"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.8"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ff477c98081ffccecdd61b1bb51d573a0b67c7d205ecfc9d50b20dd4b54f3f1
TERMUX_PKG_RECOMMENDS='trzsz-ssh'
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
