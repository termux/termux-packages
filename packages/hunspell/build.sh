TERMUX_PKG_HOMEPAGE=http://hunspell.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/hunspell/Hunspell/${TERMUX_PKG_VERSION}/hunspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ui --with-readline"
TERMUX_PKG_DEPENDS="ncurses, readline, hunspell-en-us"
