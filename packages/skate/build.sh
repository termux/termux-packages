TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/skate
TERMUX_PKG_DESCRIPTION="A personal key-value store"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/skate/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f844fd980e1337be0f1bc321e58e48680fe3855e17c6c334ed8b22b9059949d2
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
	install -Dm700 -t $TERMUX_PREFIX/bin skate
}
