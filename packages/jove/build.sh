TERMUX_PKG_HOMEPAGE=https://directory.fsf.org/wiki/Jove
TERMUX_PKG_DESCRIPTION="Jove is a compact, powerful, Emacs-style text-editor."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.4.7
TERMUX_PKG_SRCURL=https://github.com/jonmacs/jove/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ca852dee892fb3f135ecfcd5fd94810b38581431aa474721c147941af7684ca5
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
SYSDEFS=-DLinux
LDLIBS=-lncursesw
"

termux_step_post_massage() {
	mkdir -p ./var/lib/jove/preserve
}
