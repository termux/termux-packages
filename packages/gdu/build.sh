TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.32.0"
TERMUX_PKG_SRCURL=https://github.com/dundee/gdu/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2b647c3b222392fcf25583acd2411ec05635055ef7272c7ab4bd2885e53065e0
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
