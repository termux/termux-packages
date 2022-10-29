TERMUX_PKG_HOMEPAGE="https://github.com/Genivia/ugrep"
TERMUX_PKG_DESCRIPTION="A faster, user-friendly and compatible grep replacement"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="@Genivia"
TERMUX_PKG_VERSION="v3.9.2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
# TERMUX_PKG_DEPENDS=""

termux_step_get_source() {
        mkdir -p "$TERMUX_PKG_SRCDIR"
        cd "$TERMUX_PKG_SRCDIR"
        git clone "https://github.com/Genivia/ugrep"
}

termux_step_make() {
        termux_setup_clang
        termux_setup_binutils
        cd "$TERMUX_PKG_SRCDIR/ugrep"
        ./configure
}

termux_step_make_install() {
        cd "$TERMUX_PKG_SRCDIR/ugrep"
        install -Dm755 "bin/ugrep" "$TERMUX_PREFIX/bin"
}
