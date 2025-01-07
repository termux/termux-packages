TERMUX_PKG_HOMEPAGE=https://thrysoee.dk/editline/
TERMUX_PKG_DESCRIPTION="Library providing line editing, history, and tokenization functions"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20240517-3.1
TERMUX_PKG_SRCURL=https://thrysoee.dk/editline/libedit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a489097bb4115495f3bd85ae782852b7097c556d9500088d74b6fa38dbd12ff
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BREAKS="libedit-dev"
TERMUX_PKG_REPLACES="libedit-dev"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man7/editline.7 share/man/man3/history.3"

termux_step_pre_configure() {
	CFLAGS+=" -D__STDC_ISO_10646__=201103L -DNBBY=CHAR_BIT"
}
