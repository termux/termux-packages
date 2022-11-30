TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/skate
TERMUX_PKG_DESCRIPTION="A personal key-value store"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.1
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/skate/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a8ae0daeaae71462b8b50b042c428074eb0a69cdcfcb37b508f4f0617901d697
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
	install -Dm700 -t $TERMUX_PREFIX/bin skate
}
