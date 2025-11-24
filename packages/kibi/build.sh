TERMUX_PKG_HOMEPAGE=https://github.com/ilai-deutel/kibi
TERMUX_PKG_DESCRIPTION="A tiny terminal text editor, written in Rust"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.2"
TERMUX_PKG_SRCURL=https://github.com/ilai-deutel/kibi/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=150fde4664ebe47a4c588cf8ff2583392c76038339982a7180ee9282ce6c3cf2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	install -Dm644 "config_example.ini" "$TERMUX_PREFIX/etc/kibi/config.ini"
	install -Dm644 syntax.d/* -t "$TERMUX_PREFIX/share/kibi/syntax.d"
}
