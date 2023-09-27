TERMUX_PKG_HOMEPAGE=https://github.com/knipferrc/fm
TERMUX_PKG_DESCRIPTION="A terminal based file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.0"
TERMUX_PKG_SRCURL=https://github.com/knipferrc/fm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a07b783e1dbb98a12924beae4928e84069c5023ede8d16339409af613c02b666
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
