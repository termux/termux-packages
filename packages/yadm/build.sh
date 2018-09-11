TERMUX_PKG_HOMEPAGE=https://github.com/TheLocehiliosan/yadm
TERMUX_PKG_DESCRIPTION="Yet Another Dotfiles Manager"
TERMUX_PKG_VERSION=1.12.0
TERMUX_PKG_SHA256=c3d612d01e2027d5f457e0f7d120bc67251b716c373d99fe70638bd86edf107f
TERMUX_PKG_SRCURL=https://github.com/TheLocehiliosan/yadm/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="git"

termux_step_make() {
    :
}

termux_step_make_install () {
    cp $TERMUX_PKG_SRCDIR/yadm $TERMUX_PREFIX/bin/yadm

    # Install the yadm.1 man page:
    mkdir -p $TERMUX_PREFIX/share/man/man1/
    cp $TERMUX_PKG_SRCDIR/yadm.1 $TERMUX_PREFIX/share/man/man1/
}
