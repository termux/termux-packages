TERMUX_PKG_HOMEPAGE=https://github.com/mawww/kakoune
TERMUX_PKG_DESCRIPTION="Code editor heavily inspired by Vim"
TERMUX_PKG_VERSION=2018.04.13
TERMUX_PKG_SRCURL=https://github.com/mawww/kakoune/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dfbaf87479ae30fd87426ae1b5f6cbe4382d6fe17b64a0c58d9475bf038e50dc
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src debug=no"
