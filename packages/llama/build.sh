TERMUX_PKG_HOMEPAGE=https://github.com/antonmedv/llama
TERMUX_PKG_DESCRIPTION="A terminal file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_SRCURL=https://github.com/antonmedv/llama.git
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin llama
}
