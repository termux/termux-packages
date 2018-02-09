TERMUX_PKG_HOMEPAGE=http://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Termcap is a library and data base that enables programs to use display terminals in a terminal-independent manner."
TERMUX_PKG_DEPENDS="termcap"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/termcap/termcap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=91a0e22e5387ca4467b5bcb18edf1c51b930262fd466d5fda396dd9d26719100
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
/--libexecdir=/
--prefix=$TERMUX_PREFIX
"
