TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/
TERMUX_PKG_DESCRIPTION="A simple file transfer tools, similar to lrzsz ( rz / sz )"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=655ea46ff2b88c7a0530950165b9c005a2cd2afe1ad91516d38edb5fdc56ec2b
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
