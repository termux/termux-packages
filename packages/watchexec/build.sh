TERMUX_PKG_HOMEPAGE=https://github.com/watchexec/watchexec
TERMUX_PKG_DESCRIPTION="Executes commands in response to file modifications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.3
TERMUX_PKG_SRCURL=https://github.com/watchexec/watchexec/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=698ed1dc178279594542f325b23f321c888c9c12c1960fe11c0ca48ba6edad76
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust
	cargo install \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--path crates/cli \
		--force \
		--locked \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	# https://github.com/rust-lang/cargo/issues/3316:
	rm -f $TERMUX_PREFIX/.crates.toml
	rm -f $TERMUX_PREFIX/.crates2.json
}

termux_step_post_make_install() {
	local f
	for f in doc/watchexec.1.{md,pdf}; do
		install -Dm600 -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME" \
			"$TERMUX_PKG_SRCDIR/${f}"
	done
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1" \
		"$TERMUX_PKG_SRCDIR"/doc/watchexec.1
	install -Dm600 -T "completions/bash" \
		"$TERMUX_PREFIX/share/bash-completion/completions/watchexec"
	install -Dm600 -T "completions/zsh" \
		"$TERMUX_PREFIX/share/zsh/site-functions/_watchexec"
	install -Dm600 -T "completions/fish" \
		"$TERMUX_PREFIX/share/fish/vendor_completions.d/watchexec.fish"
}
