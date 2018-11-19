TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_VERSION=6.2.5
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a99e963355706cab32099d140b698eda9de164ebce40a5420b1b9772dd04802
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
