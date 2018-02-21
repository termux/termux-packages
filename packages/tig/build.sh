TERMUX_PKG_HOMEPAGE=https://jonas.github.io/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SHA256=d39d10c5a6db7b7663d51eff8ac2eaf075e319f5edabe09cb63a2b1b24846bea
TERMUX_PKG_SRCURL=https://github.com/jonas/tig/releases/download/tig-$TERMUX_PKG_VERSION/tig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="ncurses, git, libandroid-support"

termux_step_post_make_install () {
        make -j 1 install-doc
}
