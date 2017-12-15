TERMUX_PKG_HOMEPAGE=https://jonas.github.io/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SHA256=4ba555a23475946aa1c51b7f4d70beeb4a5a535cdf9d1f06978d24e2003e9201
TERMUX_PKG_SRCURL=https://github.com/jonas/tig/releases/download/tig-$TERMUX_PKG_VERSION/tig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="ncurses, git, libandroid-support"

termux_step_post_make_install () {
        make -j 1 install-doc
}
