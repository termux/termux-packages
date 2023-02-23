TERMUX_PKG_HOMEPAGE=https://github.com/bttger/markdown-flashcards
TERMUX_PKG_DESCRIPTION="Small CLI app to learn with flashcards and spaced repetition"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL=https://github.com/bttger/markdown-flashcards/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0548f87b67b5421fadf1c83533e7ee98506df26b6a529be7b042747248ab201
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
