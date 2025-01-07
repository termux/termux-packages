TERMUX_PKG_HOMEPAGE=https://github.com/mtoyoda/sl
TERMUX_PKG_DESCRIPTION="Tool curing your bad habit of mistyping"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_VERSION=5.05
TERMUX_PKG_SRCURL=https://github.com/eyJhb/sl/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c941b526e3d01be7f91a3af4ae20a89d1e5d66b3b2d804c80123b1b1be96384
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install sl $TERMUX_PREFIX/bin/
	cp sl.1 $TERMUX_PREFIX/share/man/man1
}
