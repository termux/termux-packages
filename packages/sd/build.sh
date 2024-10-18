TERMUX_PKG_HOMEPAGE=https://github.com/chmln/sd
TERMUX_PKG_DESCRIPTION="An intuitive find & replace CLI"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/chmln/sd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/sd

	install -Dm644 gen/sd.1 "$TERMUX_PREFIX/share/man/man1/sd.1"

	install -Dm644 gen/completions/sd.bash "$TERMUX_PREFIX/share/bash-completion/completions/sd"
	install -Dm644 gen/completions/_sd "$TERMUX_PREFIX/share/zsh/site-functions/_sd"
	install -Dm644 gen/completions/sd.fish "$TERMUX_PREFIX/share/fish/vendor_completions.d/sd.fish"
	install -Dm644 gen/completions/sd.elv "$TERMUX_PREFIX/share/elvish/lib/sd.elv"
}
