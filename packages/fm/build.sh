TERMUX_PKG_HOMEPAGE=https://github.com/knipferrc/fm
TERMUX_PKG_DESCRIPTION="A terminal based file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.15.10
TERMUX_PKG_SRCURL=https://github.com/knipferrc/fm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=30b71aa278a321053c32279ef9b7c891391b433e978502d0bbc1b4a1758cca7f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin fm
}
