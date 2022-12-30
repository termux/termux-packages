TERMUX_PKG_HOMEPAGE=https://github.com/akavel/up
TERMUX_PKG_DESCRIPTION="Helps interactively and incrementally explore textual data in Linux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SRCURL=git+https://github.com/akavel/up
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin up
}
