TERMUX_PKG_HOMEPAGE=https://dystroy.org/bacon
TERMUX_PKG_DESCRIPTION="A background code checker for Rust, designed for minimal interaction"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.26.0"
TERMUX_PKG_SRCURL="https://github.com/Canop/bacon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d86249d01175f83ce30c7d52d36ed3422855c7eef00907161e673d490955702d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build \
		--release \
		--target "${CARGO_TARGET_NAME}"
}

termux_step_make_install() {
	install -Dm755 \
		"target/${CARGO_TARGET_NAME}/release/bacon" \
		"$TERMUX_PREFIX/bin/bacon"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	COMPLETE=bash cargo run --release > "${TERMUX_PREFIX}/share/bash-completion/completions/bacon"
	COMPLETE=zsh  cargo run --release > "${TERMUX_PREFIX}/share/zsh/site-functions/_bacon"
	COMPLETE=fish cargo run --release > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/bacon.fish"
}
