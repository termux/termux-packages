TERMUX_PKG_HOMEPAGE=http://rigaux.org/hexedit.html
TERMUX_PKG_DESCRIPTION="view and edit files in hexadecimal or in ASCII"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_SRCURL=https://github.com/pixel/hexedit/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=27a2349f659e995d7731ad672450f61a2e950330049a6fb59b77490c5e0015ac
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
