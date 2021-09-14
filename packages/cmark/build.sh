TERMUX_PKG_HOMEPAGE=https://github.com/github/cmark
TERMUX_PKG_DESCRIPTION="CommonMark parsing and rendering program"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.29.0.gfm.1
TERMUX_PKG_SRCURL=https://github.com/github/cmark/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ebfa3608b3de94f179cbbbeab36df703e3161ae027719f46ab750a7eccf5aa70
TERMUX_PKG_BREAKS="cmark-dev"
TERMUX_PKG_REPLACES="cmark-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_INSTALL_LIBDIR=$TERMUX_PREFIX/lib"

termux_step_post_make_install() {
    cd $TERMUX_PREFIX/bin
    ln -f -s cmark-gfm cmark

    cd $TERMUX_PREFIX/share/man/man1
    ln -f -s cmark-gfm.1 cmark.1
}
