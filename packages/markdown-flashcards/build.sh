TERMUX_PKG_HOMEPAGE=https://github.com/bttger/markdown-flashcards
TERMUX_PKG_DESCRIPTION="Small CLI app to learn with flashcards and spaced repetition"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/bttger/markdown-flashcards/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=984235b2d9777f0d03f229b591348af747af8f5f2e7094544a84ca43b0dca095
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
