TERMUX_PKG_HOMEPAGE=http://hunspell.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://github.com/hunspell/hunspell/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ui --with-readline"
TERMUX_PKG_DEPENDS="ncurses, readline, hunspell-en-us"
TERMUX_PKG_FOLDERNAME=hunspell-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes
