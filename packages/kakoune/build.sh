TERMUX_PKG_HOMEPAGE=https://github.com/mawww/kakoune
TERMUX_PKG_DESCRIPTION="Code editor heavily inspired by Vim"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_VERSION=2019.01.20
TERMUX_PKG_SHA256=0d116e7990134a6dba5cad47c5cded39b86eb8c5e061dc43a42c279ec71b9765
TERMUX_PKG_SRCURL=https://github.com/mawww/kakoune/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src debug=no"
