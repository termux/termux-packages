TERMUX_PKG_HOMEPAGE=https://trzsz.github.io/ssh
TERMUX_PKG_DESCRIPTION="An openssh client alternative"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.22"
TERMUX_PKG_SRCURL=https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ccf5a113d68156b409d89fead784256b4fd6a6bbae6a2d70df1e4403d383a962
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
