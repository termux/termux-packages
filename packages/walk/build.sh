TERMUX_PKG_HOMEPAGE=https://github.com/antonmedv/walk
TERMUX_PKG_DESCRIPTION="A terminal file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.0"
TERMUX_PKG_SRCURL=https://github.com/antonmedv/walk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f62377438908757fcb2210bd08bf346391858f21d0ef664d7998abf635880cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# Package was previously named as "llama".
TERMUX_PKG_BREAKS="llama (<< 1.4.0-2)"
TERMUX_PKG_REPLACES="llama (<< 1.4.0-2)"

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin walk
}
