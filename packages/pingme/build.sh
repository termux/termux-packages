TERMUX_PKG_HOMEPAGE=https://github.com/kha7iq/pingme
TERMUX_PKG_DESCRIPTION="A small utility which can be called from anywhere to send a message with particular information"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.6"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/kha7iq/pingme/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a199ddee57685593efb7ada85b4ff6534098dbab9c67eb1023c1d9416f50de3
TERMUX_PKG_AUTO_UPDATE=true
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
