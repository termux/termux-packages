TERMUX_PKG_HOMEPAGE=http://qalculate.sourceforge.net
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=0.9.9
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v${TERMUX_PKG_VERSION}/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="glib, gnuplot, libcln, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes