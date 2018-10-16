TERMUX_PKG_HOMEPAGE=https://github.com/mawww/kakoune
TERMUX_PKG_DESCRIPTION="Code editor heavily inspired by Vim"
TERMUX_PKG_VERSION=2018.09.04
TERMUX_PKG_SRCURL=https://github.com/mawww/kakoune/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c143cae27cbd692627aeb81c1de8344e8891e47fafb0f67a02cb8ba9ad8de41
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src debug=no"
