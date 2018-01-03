TERMUX_PKG_HOMEPAGE=https://jonas.github.io/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SHA256=6410e51c6149d76eac3510d04f9a736139f85e7c881646937d009caacf98cff1
TERMUX_PKG_SRCURL=https://github.com/jonas/tig/releases/download/tig-$TERMUX_PKG_VERSION/tig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="ncurses, git, libandroid-support"

termux_step_post_make_install () {
        make -j 1 install-doc
}
