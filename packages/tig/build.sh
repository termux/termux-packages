TERMUX_PKG_HOMEPAGE=http://jonas.nitro.dk/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://jonas.nitro.dk/tig/releases/tig-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="ncurses, git, libandroid-support"

termux_step_post_make_install () {
        make -j 1 install-doc
}
