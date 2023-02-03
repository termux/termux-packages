TERMUX_PKG_HOMEPAGE=https://github.com/tomnomnom/gron
TERMUX_PKG_DESCRIPTION="Transforms JSON into discrete assignments"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/tomnomnom/gron
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin gron
}
