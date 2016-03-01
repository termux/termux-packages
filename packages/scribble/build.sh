TERMUX_PKG_HOMEPAGE=http://packages.debian.org/unstable/games/scribble
TERMUX_PKG_DESCRIPTION="Popular crossword game, similar to Scrabble(R)"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_VERSION=1.11-1
TERMUX_PKG_SRCURL=http://ftp.de.debian.org/debian/pool/main/s/scribble/scribble_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=scribble
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
    make prefix=$TERMUX_PREFIX bindir=$TERMUX_PREFIX/bin
}

termux_step_make_install () {
    return
}
