TERMUX_PKG_HOMEPAGE=https://jonas.github.io/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/jonas/tig/releases/download/tig-$TERMUX_PKG_VERSION/tig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=686f0386927904dc6410f0b1a712cb8bd7fff3303f688d7dc43162f4ad16c0ed
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="ncurses, git, libandroid-support"

termux_step_post_make_install () {
        make -j 1 install-doc
}
