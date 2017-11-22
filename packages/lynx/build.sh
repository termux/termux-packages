TERMUX_PKG_HOMEPAGE=http://lynx.browser.org/
TERMUX_PKG_DESCRIPTION="The text web browser"
TERMUX_PKG_VERSION=2.8.9dev.16
TERMUX_PKG_SHA256=04318a100b052d079d0018fa371aa28cfb41ab68db3a959f3b75c2170eea1bc8
TERMUX_PKG_SRCURL=http://invisible-mirror.net/archives/lynx/tarballs/lynx${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="ncurses, openssl, libbz2, libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-screen=ncursesw --enable-widec --enable-scrollbar --enable-nested-tables --enable-htmlized-cfg --with-ssl --with-zlib --with-bzlib --enable-cjk --enable-japanese-utf8 --enable-progressbar --enable-prettysrc --enable-forms-options --enable-8bit-toupper --enable-ascii-ctypes --disable-font-switch"

termux_step_pre_configure() {
	CC+=" $LDFLAGS"
	unset LDFLAGS
}

termux_step_make_install () {
	make uninstall
	make install
}
