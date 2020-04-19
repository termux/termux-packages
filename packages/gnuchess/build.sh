TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=6.2.6
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d617f875d6411378c6ce521663ebda42db9006a5eb5706bcd821a918c06eb04f
TERMUX_PKG_DEPENDS="libc++, ncurses, readline"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
