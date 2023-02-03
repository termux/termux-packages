TERMUX_PKG_HOMEPAGE=https://github.com/benhsm/minesweeper
TERMUX_PKG_DESCRIPTION="A simple terminal-based implementation of Minesweeper"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/benhsm/minesweeper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18d33713b0ab1d3ee40741ba712124fc973e8d6cffd6e5d5649c358a0cbf30b2
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go build -o minesweeper
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin minesweeper
}
