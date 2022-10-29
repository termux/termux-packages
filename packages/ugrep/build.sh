TERMUX_PKG_HOMEPAGE="https://github.com/Genivia/ugrep"
TERMUX_PKG_DESCRIPTION="A faster, user-friendly and compatible grep replacement"
TERMUX_PKG_GROUPS="util-linux"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@AndVer2"
TERMUX_PKG_VERSION="3.9.2"
TERMUX_PKG_SRCURL=https://github.com/Genivia/ugrep/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SHA256=3416267ac5a4dd2938ca91e7bd91db958d65510c9fd33b221f067bd3c6b3fc6a
TERMUX_PKG_SKIP_SRC_EXTRACT=true
# TERMUX_PKG_DEPENDS=""

termux_step_get_source() {

}

termux_step_make() {
        cd "$TERMUX_PKG_SRCDIR/ugrep"
        ./build.sh
}

termux_step_make_install() {
        cd "$TERMUX_PKG_SRCDIR/ugrep"                                                                                                                
        install -Dm755 "bin/ugrep" "$TERMUX_PREFIX/bin"
}
