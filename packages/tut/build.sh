TERMUX_PKG_HOMEPAGE=https://github.com/RasmusLindroth/tut
TERMUX_PKG_DESCRIPTION="A TUI for Mastodon with vim inspired keys"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.29"
TERMUX_PKG_SRCURL=https://github.com/RasmusLindroth/tut/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4c9ba33d999924689eebad055b512308ac3aaf03167b3ec50a5a420ae0645f0
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
