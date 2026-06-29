TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.36.1"
TERMUX_PKG_SRCURL="https://github.com/dundee/gdu/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=dd31ea9afd848edf734143aabd5fdf66236ce2c866dc09f9dededb61d39fe63c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_make() {
	termux_setup_golang
	sed -i 's|CGO_ENABLED=0|CGO_ENABLED=1|g' Makefile

	make build VERSION="$TERMUX_PKG_VERSION"
	make gdu.1
}

termux_step_make_install() {
	install -D dist/gdu -t "$TERMUX_PREFIX/bin"
	install -Dm644 gdu.1 -t "$TERMUX_PREFIX/share/man/man1"
}
