TERMUX_PKG_HOMEPAGE=https://github.com/watchexec/watchexec
TERMUX_PKG_DESCRIPTION="Executes commands in response to file modifications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.0
TERMUX_PKG_SRCURL=https://github.com/watchexec/watchexec/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff835eed2be68de97b08eaa2177d9cdcb721f6d727c6803a642ca94d11eec5fa
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust
	cargo install \
		--jobs $TERMUX_MAKE_PROCESSES \
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
	install -Dm644 -t "$TERMUX_PREFIX"/share/doc/watchexec/watchexec.1.html \
		"$TERMUX_PKG_SRCDIR"/doc/watchexec.1.html
	install -Dm644 -t "$TERMUX_PREFIX"/share/man/man1/watchexec.1 \
		"$TERMUX_PKG_SRCDIR"/doc/watchexec.1
	install -Dm644 "completions/zsh" \
		"$TERMUX_PREFIX/share/zsh/site-functions/_watchexec"
	install -Dm644 LICENSE "$TERMUX_PREFIX/share/licenses/watchexec/LICENSE"
}
