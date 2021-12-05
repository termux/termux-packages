TERMUX_PKG_HOMEPAGE=https://github.com/jkarns275/rpipes
TERMUX_PKG_DESCRIPTION="Cross platform port of a terminal screensaver which displays moving pipes "
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make_install() {
    termux_setup_rust
    cargo install \
        --jobs $TERMUX_MAKE_PROCESSES \
        rpipes \
        --force \
        --locked \
        --target $CARGO_TARGET_NAME \
        --root $TERMUX_PREFIX \
        $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
