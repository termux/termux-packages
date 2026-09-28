TERMUX_PKG_HOMEPAGE=https://github.com/owenrumney/make-ls
TERMUX_PKG_DESCRIPTION="Makefile language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.25"
TERMUX_PKG_SRCURL="https://github.com/owenrumney/make-ls/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="69080ba66e8c4dbe050912cbffc2d2f5cec7b38e4b7a0141679c184a652ef0e7"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build ./cmd/make-ls
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" make-ls
}
