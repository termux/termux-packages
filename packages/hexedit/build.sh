TERMUX_PKG_HOMEPAGE=http://rigaux.org/hexedit.html
TERMUX_PKG_DESCRIPTION="view and edit files in hexadecimal or in ASCII"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SHA256=c81ffb36af9243aefc0887e33dd8e41c4b22d091f1f27d413cbda443b0440d66
TERMUX_PKG_SRCURL=https://github.com/pixel/hexedit/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	./autogen.sh
}
