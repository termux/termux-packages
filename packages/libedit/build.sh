TERMUX_PKG_HOMEPAGE=http://thrysoee.dk/editline/
TERMUX_PKG_DESCRIPTION="Library providing line editing, history, and tokenization functions"
TERMUX_PKG_VERSION=20170329-3.1
TERMUX_PKG_SRCURL=http://thrysoee.dk/editline/libedit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=91f2d90fbd2a048ff6dad7131d9a39e690fd8a8fd982a353f1333dd4017dd4be
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
	CFLAGS+=" -D__STDC_ISO_10646__=201103L -DNBBY=CHAR_BIT"
}
