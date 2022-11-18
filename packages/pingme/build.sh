TERMUX_PKG_HOMEPAGE=https://github.com/kha7iq/pingme
TERMUX_PKG_DESCRIPTION="A small utility which can be called from anywhere to send a message with particular information"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.5
TERMUX_PKG_SRCURL=https://github.com/kha7iq/pingme/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5496d13630ae5988fbc6b2353bfed7eba7c5658875e019d72faa217be2fa8a61
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
