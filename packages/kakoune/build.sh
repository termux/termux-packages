TERMUX_PKG_HOMEPAGE=https://github.com/mawww/kakoune
TERMUX_PKG_DESCRIPTION="Code editor heavily inspired by Vim"
TERMUX_PKG_VERSION=2018.10.27
TERMUX_PKG_SHA256=6b34292c46e2176fdfc3c232a0111ee58229e101f4e37aabe729a0190ddc4641
TERMUX_PKG_SRCURL=https://github.com/mawww/kakoune/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src debug=no"
