TERMUX_PKG_HOMEPAGE=https://github.com/go-task/task
TERMUX_PKG_DESCRIPTION="A task runner / simpler Make alternative written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.53.1"
TERMUX_PKG_SRCURL=https://github.com/go-task/task/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dd22395f4548ba58bc3adf83cb9ce33f1c5fad7e7c5f0a229bb2709af439fa9a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o task \
		./cmd/task
}

termux_step_make_install() {
	install -Dm755 task "$TERMUX_PREFIX/bin/go-task"
}
