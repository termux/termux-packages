TERMUX_PKG_HOMEPAGE=https://tealdeer-rs.github.io/tealdeer/
TERMUX_PKG_DESCRIPTION="A very fast implementation of tldr in Rust"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b9ea7ef8dd594d6fb8b452733b0c883a68153cec266b23564ce185bdf22fcfa
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tldr

	install -Dm644 completion/zsh_tealdeer "$TERMUX_PREFIX/share/zsh/site-functions/_tldr"
	install -Dm644 completion/bash_tealdeer "$TERMUX_PREFIX/share/bash-completion/completions/tldr"
	install -Dm644 completion/fish_tealdeer "$TERMUX_PREFIX/share/fish/vendor_completions.d/tldr.fish"
}
