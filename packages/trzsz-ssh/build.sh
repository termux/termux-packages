TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/ssh
TERMUX_PKG_DESCRIPTION="An openssh client alternative"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.26"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=67c9082543e1785ece3f5ab09f6299cd655e3657593d55cc85751c097c1bb381
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
