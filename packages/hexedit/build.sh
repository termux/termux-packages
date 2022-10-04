TERMUX_PKG_HOMEPAGE=http://rigaux.org/hexedit.html
TERMUX_PKG_DESCRIPTION="view and edit files in hexadecimal or in ASCII"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6
TERMUX_PKG_SRCURL=https://github.com/pixel/hexedit/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=598906131934f88003a6a937fab10542686ce5f661134bc336053e978c4baae3
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
