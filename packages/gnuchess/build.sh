TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_VERSION=6.2.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c425c0264f253fc5cc2ba969abe667d77703c728770bd4b23c456cbe5e082ef
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
