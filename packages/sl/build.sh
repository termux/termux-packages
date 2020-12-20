TERMUX_PKG_HOMEPAGE=https://github.com/mtoyoda/sl
TERMUX_PKG_DESCRIPTION="Tool curing your bad habit of mistyping"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_VERSION=5.02
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mtoyoda/sl/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e5996757f879c81f202a18ad8e982195cf51c41727d3fea4af01fdcbbb5563a
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install sl $TERMUX_PREFIX/bin/
	cp sl.1 $TERMUX_PREFIX/share/man/man1
}
