TERMUX_PKG_HOMEPAGE=https://github.com/tgraf/bmon
TERMUX_PKG_DESCRIPTION="Bandwidth monitor and rate estimator"
TERMUX_PKG_VERSION=4.0
TERMUX_PKG_SRCURL=https://github.com/tgraf/bmon/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_FOLDERNAME=bmon-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libconfuse, libnl3, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    cd $TERMUX_PKG_SRCDIR
    ./autogen.sh
}