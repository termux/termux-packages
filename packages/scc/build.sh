TERMUX_PKG_HOMEPAGE=https://github.com/boyter/scc
TERMUX_PKG_DESCRIPTION="Counts physical the lines of code, blank lines, comment lines, and physical lines of source code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.0"
TERMUX_PKG_SRCURL=https://github.com/boyter/scc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=161f5d9bb359c6440114b7d2e0f98d588c02aa66fbe474d7660b244687fefb70
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin scc
}
