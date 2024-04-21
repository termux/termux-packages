TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.28.0"
TERMUX_PKG_SRCURL=https://github.com/dundee/gdu/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b184046e76a97f4205b745d431655b7910f8c7b41a8592d68c4cbf61e3b14125
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	make build
	make gdu.1
}

termux_step_make_install() {
	install -D dist/gdu -t $TERMUX_PREFIX/bin
	install -Dm644 gdu.1 -t $TERMUX_PREFIX/share/man/man1
}
