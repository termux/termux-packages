TERMUX_PKG_HOMEPAGE=https://directory.fsf.org/wiki/Jove
TERMUX_PKG_DESCRIPTION="Jove is a compact, powerful, Emacs-style text-editor."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.5.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jonmacs/jove/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ca5a5fcf71009c7389d655d1f1ae8139710f6cc531be95581e4b375e67f098d2
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
JOVEHOME=$TERMUX_PREFIX
SYSDEFS=-DLinux
LDLIBS=-lncursesw
"

termux_step_post_massage() {
	mkdir -p ./var/lib/jove/preserve
}
