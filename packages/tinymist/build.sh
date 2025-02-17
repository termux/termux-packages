TERMUX_PKG_HOMEPAGE=https://myriad-dreamin.github.io/tinymist
TERMUX_PKG_DESCRIPTION="An integrated language service for Typst"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.12.19"
TERMUX_PKG_SRCURL=https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=09f6a239f334bfd9a1900ea59ed39a265e409c5e23efa2584949d5226eb67762
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="typst-lsp"
TERMUX_PKG_REPLACES="typst-lsp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+'


termux_step_pre_configure() {
	# We're not shipping the VS Code plugin
	rm -rf .vscode
	termux_setup_rust
	unset CFLAGS # clash with rust host build

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME
	export OPENSSL_NO_VENDOR=1
	export PKG_CONFIG_ALL_DYNAMIC=1

	cargo fetch --locked --target "$CARGO_TARGET_NAME"
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" target/"${CARGO_TARGET_NAME}"/release/tinymist

	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/nushell/vendor/autoload"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	cargo run --bin tinymist -- completion     zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_tinymist"
	cargo run --bin tinymist -- completion    bash > "${TERMUX_PREFIX}/share/bash-completion/completions/tinymist"
	cargo run --bin tinymist -- completion    fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/tinymist.fish"
	cargo run --bin tinymist -- completion  elvish > "${TERMUX_PREFIX}/share/elvish/lib/tinymist.elv"
	cargo run --bin tinymist -- completion nushell > "${TERMUX_PREFIX}/share/nushell/vendor/autoload/tinymist.nu"
	# there are currently no completions for typlite
	# and despite `clap_mangen` being present there is currently no manpages
}
