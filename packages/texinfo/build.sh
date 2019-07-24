TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=6.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=9bb9ca00da53f26a7e5725eee49689cd4a1e18d25d5b061ac8b2053018d93d66
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="libiconv, ncurses, perl, gawk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-perl-xs"
