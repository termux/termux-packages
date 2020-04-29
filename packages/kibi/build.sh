TERMUX_PKG_HOMEPAGE=https://github.com/ilai-deutel/kibi
TERMUX_PKG_DESCRIPTION="A tiny terminal text editor, written in Rust"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=0.2.0
TERMUX_PKG_SRCURL=https://github.com/ilai-deutel/kibi/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7af69657ce50816e45e9111138cf9e050f74289bba3ceaa2a52e4715951c8885
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
    install -Dm644 "config_example.ini" "$TERMUX_PREFIX/etc/kibi/config.ini"
    install -Dm644 syntax.d/* -t "$TERMUX_PREFIX/share/kibi/syntax.d"
}
