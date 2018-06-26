TERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/hunspell/hunspell/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3cd9ceb062fe5814f668e4f22b2fa6e3ba0b339b921739541ce180cac4d6f4c4
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ui --with-readline"
TERMUX_PKG_DEPENDS="ncurses, readline, hunspell-en-us"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	autoreconf -vfi
}
