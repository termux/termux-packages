TERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/hunspell/hunspell/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=30f593733c50b794016bb03d31fd2a2071e4610c6fa4708e33edad2335102c49
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ui --with-readline"
TERMUX_PKG_DEPENDS="ncurses, readline, hunspell-en-us"
TERMUX_PKG_FOLDERNAME=hunspell-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	autoreconf -vfi
}
