TERMUX_PKG_HOMEPAGE=https://github.com/RasmusLindroth/tut
TERMUX_PKG_DESCRIPTION="A TUI for Mastodon with vim inspired keys"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL=https://github.com/RasmusLindroth/tut/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0deeaf923c05b713a72a338684c54159a433952475656f8b46be6bc0d4489ca
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
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME config.example.toml
}
