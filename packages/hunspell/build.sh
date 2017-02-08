TTERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/hunspell/hunspell/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=512e7d2ee69dad0b35ca011076405e56e0f10963a02d4859dbcc4faf53ca68e2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ui --with-readline"
TERMUX_PKG_DEPENDS="ncurses, readline, hunspell-en-us"
TERMUX_PKG_FOLDERNAME=hunspell-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	autoreconf -vfi
}
