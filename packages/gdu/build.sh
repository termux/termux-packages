TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.25.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/dundee/gdu/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=83fe876d953b4f2f7a856552e758aae4aa0cd9569dcf1aded61bdc834b834275
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
