TERMUX_PKG_HOMEPAGE=https://taplo.tamasfe.dev/
TERMUX_PKG_DESCRIPTION="A TOML LSP and toolkit"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eaec8435bfb5ccd89f7b4dd09385b6be25c2ff00aa25417cb82c88a59d4ccde0
TERMUX_PKG_BUILD_DEPENDS='openssl'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='release-taplo-cli-\d+\.\d+\.\d+'

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--all-features
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX"/bin target/"$CARGO_TARGET_NAME"/release/taplo
	# shell completions
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	cargo run -- completions    zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	cargo run -- completions   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	cargo run -- completions   fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	cargo run -- completions elvish > "${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
}
