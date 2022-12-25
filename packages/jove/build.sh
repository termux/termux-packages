TERMUX_PKG_HOMEPAGE=https://directory.fsf.org/wiki/Jove
TERMUX_PKG_DESCRIPTION="Jove is a compact, powerful, Emacs-style text-editor."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.4.9
TERMUX_PKG_SRCURL=https://github.com/jonmacs/jove/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6d9aeb85c04fedac7e3df2a1716e014dc53d6938f665fc32a9facd40c117102d
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
SYSDEFS=-DLinux
LDLIBS=-lncursesw
"

termux_step_post_massage() {
	mkdir -p ./var/lib/jove/preserve
}
