TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_VERSION=6.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=77774b3f4a06c20705cc2ef1c804864422e3cf95235e965b1f00a46df7da5f62
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="ncurses, perl, gawk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-perl-xs"
