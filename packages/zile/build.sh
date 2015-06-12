# NOTE: Segfaults on startup. Problem with libgc?
TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/zile/
TERMUX_PKG_DESCRIPTION="Lightweight Emacs clone"
TERMUX_PKG_VERSION=2.4.11
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/zile/zile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libgc, ncurses"
