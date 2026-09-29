TERMUX_PKG_HOMEPAGE=https://github.com/kha7iq/pingme
TERMUX_PKG_DESCRIPTION="A small utility which can be called from anywhere to send a message with particular information"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.7"
TERMUX_PKG_SRCURL=https://github.com/kha7iq/pingme/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=054750be7085c5dfcaae2cea17119b39041beef4577dfdfaf8011804c0836e9d
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
