TERMUX_PKG_HOMEPAGE=https://github.com/boyter/scc
TERMUX_PKG_DESCRIPTION="Counts physical the lines of code, blank lines, comment lines, and physical lines of source code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/boyter/scc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69cce0b57e66c736169bd07943cdbe70891bc2ff3ada1f4482acbd1335adbfad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin scc
}
