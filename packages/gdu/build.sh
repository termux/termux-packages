TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.31.0"
TERMUX_PKG_SRCURL=https://github.com/dundee/gdu/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e3727680ea346ce86e63d4c97841cbc5e17c6d8e58fac8b8e9886e3339214e9d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	sed -i 's|CGO_ENABLED=0|CGO_ENABLED=1|g' Makefile

	make build VERSION=$TERMUX_PKG_VERSION
	make gdu.1
}

termux_step_make_install() {
	install -D dist/gdu -t $TERMUX_PREFIX/bin
	install -Dm644 gdu.1 -t $TERMUX_PREFIX/share/man/man1
}
