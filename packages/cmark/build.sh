TERMUX_PKG_HOMEPAGE=https://github.com/github/cmark
TERMUX_PKG_DESCRIPTION="CommonMark parsing and rendering program"
TERMUX_PKG_VERSION=0.28.3.gfm.19
TERMUX_PKG_SHA256=d2c8cb255e227d07533a32cfd4a052e189f697e2a9681d8b17d15654259e2e4b
TERMUX_PKG_SRCURL=https://github.com/github/cmark/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_LIBDIR=$TERMUX_PREFIX/lib"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="lib/cmake-gfm-extensions"

termux_step_post_make_install() {
    cd $TERMUX_PREFIX/bin
    ln -f -s cmark-gfm cmark

    cd $TERMUX_PREFIX/share/man/man1
    ln -f -s cmark-gfm.1 cmark.1
}
