TERMUX_PKG_HOMEPAGE=https://github.com/RasmusLindroth/tut
TERMUX_PKG_DESCRIPTION="A TUI for Mastodon with vim inspired keys"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.28"
TERMUX_PKG_SRCURL=https://github.com/RasmusLindroth/tut/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6dbc41e0615e1e2a2e1d56ecf2a3a9f555bb39ab16fabc8f4a0cdc35735188bf
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
	install -Dm700 -t $TERMUX_PREFIX/bin tut
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME config.example.ini
}
