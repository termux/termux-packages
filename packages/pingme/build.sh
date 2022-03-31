TERMUX_PKG_HOMEPAGE=https://github.com/kha7iq/pingme
TERMUX_PKG_DESCRIPTION="A small utility which can be called from anywhere to send a message with particular information"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.4
TERMUX_PKG_SRCURL=https://github.com/kha7iq/pingme/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f65858f7b44d9c4a327128ef020d34c4e8294244bece5f8867a08c6da81bc62
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin pingme
}
