TERMUX_PKG_HOMEPAGE=https://github.com/watchexec/watchexec
TERMUX_PKG_DESCRIPTION="Executes commands in response to file modifications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_SRCURL="https://github.com/watchexec/watchexec/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8d897bc79d6e6a381ad9b3abf2a4967b58bc376bdc0aa418bb99829660d74aff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/notify-rust \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/notify-rust-bump-zbus.diff"
	local dir="vendor/notify-rust"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "${patch}"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'notify-rust = { path = "./vendor/notify-rust" }' >> Cargo.toml
}

termux_step_make_install() {
	cargo install \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--path crates/cli \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_make_install() {
	local f
	install -Dm600 -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME" \
		"$TERMUX_PKG_SRCDIR/doc/watchexec.1.md"
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1" \
		"$TERMUX_PKG_SRCDIR"/doc/watchexec.1
	install -Dm600 -T "completions/bash" \
		"$TERMUX_PREFIX/share/bash-completion/completions/watchexec"
	install -Dm600 -T "completions/zsh" \
		"$TERMUX_PREFIX/share/zsh/site-functions/_watchexec"
	install -Dm600 -T "completions/fish" \
		"$TERMUX_PREFIX/share/fish/vendor_completions.d/watchexec.fish"
}
