TERMUX_PKG_HOMEPAGE=https://myriad-dreamin.github.io/tinymist
TERMUX_PKG_DESCRIPTION="An integrated language service for Typst"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.14.18"
TERMUX_PKG_SRCURL="https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=92491d5bcd7ba2a5fe66c3c5e4c3728c2dce19a01a7f755010a905d31ccd0d04
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="typst-lsp"
TERMUX_PKG_REPLACES="typst-lsp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d*[02468](?!-)' # https://github.com/Myriad-Dreamin/tinymist#versioning-and-release-cycle


termux_step_pre_configure() {
	# We're not shipping the VS Code plugin
	rm -rf .vscode

	# tinymist-viewer tries to open an android native window to show preview but fails
	rm -rf ./crates/tinymist-viewer

	termux_setup_rust
	unset CFLAGS # clash with rust host build

	export OPENSSL_NO_VENDOR=1
	export PKG_CONFIG_ALL_DYNAMIC=1

	cargo fetch --target "$CARGO_TARGET_NAME"
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" target/"${CARGO_TARGET_NAME}"/release/tinymist
	install -Dm700 -t "$TERMUX_PREFIX/bin" target/"${CARGO_TARGET_NAME}"/release/typlite

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
