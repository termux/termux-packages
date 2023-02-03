TERMUX_PKG_HOMEPAGE=https://github.com/0l1v3rr/cli-file-manager
TERMUX_PKG_DESCRIPTION="A basic file manager that runs inside a terminal, designed for Linux. It's fully responsive and incredibly fast."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/0l1v3rr/cli-file-manager/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1a955225a72e822b9a1a1e13edbb460770e7102206050560919de4420cb1474a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	make build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/cfm
}
