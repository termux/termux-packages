TERMUX_PKG_HOMEPAGE=https://github.com/bttger/markdown-flashcards
TERMUX_PKG_DESCRIPTION="Small CLI app to learn with flashcards and spaced repetition"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.1"
TERMUX_PKG_SRCURL=https://github.com/bttger/markdown-flashcards/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90126b1f1a3e5f84a796123c42d0cbb8824e55d0d859220fe4fe049620f7c065
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o mdfc ./cmd
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin mdfc
}
