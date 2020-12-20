TERMUX_PKG_HOMEPAGE=https://github.com/ilai-deutel/kibi
TERMUX_PKG_DESCRIPTION="A tiny terminal text editor, written in Rust"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.1
TERMUX_PKG_SRCURL=https://github.com/ilai-deutel/kibi/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f6171a2c1be66aa52814b736d6c06ad9ad50b71869e4447196e16ecf951eb494
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
    install -Dm644 "config_example.ini" "$TERMUX_PREFIX/etc/kibi/config.ini"
    install -Dm644 syntax.d/* -t "$TERMUX_PREFIX/share/kibi/syntax.d"
}
