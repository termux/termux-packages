TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_VERSION=0.60.7-20131207
TERMUX_PKG_SRCURL=ftp://alpha.gnu.org/gnu/aspell/aspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=319787085a34840cfef5d9a258d10d8ba7a7d47899faf5f107ac66a0b53f4e83
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-32-bit-hash-fun"
TERMUX_PKG_DEPENDS="ncurses, readline, aspell-en"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	autoreconf -vfi
}
