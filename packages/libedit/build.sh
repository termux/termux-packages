TERMUX_PKG_HOMEPAGE=http://thrysoee.dk/editline/
TERMUX_PKG_DESCRIPTION="Command line editor library provides generic line editing, history, and tokenization functions."
TERMUX_PKG_VERSION=20160903-3.1
TERMUX_PKG_SRCURL=http://thrysoee.dk/editline/libedit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0ccbd2e7d46097f136fcb1aaa0d5bc24e23bb73f57d25bee5a852a683eaa7567
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
    CFLAGS+=" -D__STDC_ISO_10646__=201103L -DNBBY=CHAR_BIT"
}
