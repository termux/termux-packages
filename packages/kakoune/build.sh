TERMUX_PKG_HOMEPAGE=https://github.com/mawww/kakoune
TERMUX_PKG_DESCRIPTION="Code editor heavily inspired by Vim"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_VERSION=2019.07.01
TERMUX_PKG_SHA256=8cf978499000bd71a78736eaee5663bd996f53c4e610c62a9bd97502a3ed6fd3
TERMUX_PKG_SRCURL=https://github.com/mawww/kakoune/releases/download/v$TERMUX_PKG_VERSION/kakoune-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src debug=no"
