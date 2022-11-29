TERMUX_PKG_HOMEPAGE=https://github.com/antonmedv/llama
TERMUX_PKG_DESCRIPTION="A terminal file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/antonmedv/llama/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf6fe219f2554c90aadbe4d0ebb961b53fe3296873addab1a3af941646e19ca2
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
