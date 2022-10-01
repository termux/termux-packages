TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.19.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dundee/gdu/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=69c47eaedd0fc1e664d5a08c91e7b107961145aa307d1fd11cf208dfec573f0c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	return
}

termux_step_make_install() {
	termux_setup_golang

	make build
	install -D dist/gdu -t $TERMUX_PREFIX/bin
	make gdu.1
	install -Dm644 gdu.1 -t $TERMUX_PREFIX/share/man/man1
}
