TERMUX_PKG_HOMEPAGE=https://thrysoee.dk/editline/
TERMUX_PKG_DESCRIPTION="Library providing line editing, history, and tokenization functions"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=20190324-3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=ac8f0f51c1cf65492e4d1e3ed2be360bda41e54633444666422fbf393bba1bae
TERMUX_PKG_SRCURL=https://thrysoee.dk/editline/libedit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="libedit-dev"
TERMUX_PKG_REPLACES="libedit-dev"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man7/editline.7 share/man/man3/history.3"

termux_step_pre_configure() {
	CFLAGS+=" -D__STDC_ISO_10646__=201103L -DNBBY=CHAR_BIT"
}
