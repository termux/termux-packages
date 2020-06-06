TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=6.2.7
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e536675a61abe82e61b919f6b786755441d9fcd4c21e1c82fb9e5340dd229846
TERMUX_PKG_DEPENDS="libc++, ncurses, readline"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
