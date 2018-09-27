TERMUX_PKG_HOMEPAGE=https://github.com/jarun/nnn
TERMUX_PKG_DESCRIPTION="The fastest terminal file manager ever written."
TERMUX_PKG_VERSION=1.9
TERMUX_PKG_SHA256=7ba298a55a579640fe0ae37f553be739957da0c826f532beac46acfb56e2d726
TERMUX_PKG_SRCURL=https://github.com/jarun/nnn/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    # nnn always rebuilds on "make install", so doing "make" is unneccessary
    return
}

termux_step_make_install() {
    make CFLAGS="-O3 -I$TERMUX_PREFIX/include -Dushort=uint32_t" install
}
