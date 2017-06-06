TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="GNU Aspell is a spell-checker which can be used either as a standalone application or embedded in other programs"
TERMUX_PKG_VERSION=0.60.6.1
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/aspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="iconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-compile-in-filters"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
    cp $TERMUX_PKG_BUILDER_DIR/aspell-install-dict.sh $TERMUX_PREFIX/bin/aspell-install-dict
    sed -i -e "s%/bin%$TERMUX_PREFIX/bin%" $TERMUX_PREFIX/bin/aspell-install-dict
}