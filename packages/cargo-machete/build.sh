TERMUX_PKG_HOMEPAGE=https://github.com/bnjbvr/cargo-machete
TERMUX_PKG_DESCRIPTION="Find unused dependencies in Rust projects"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/bnjbvr/cargo-machete/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a87108967c369a73100d71cad56a5ad9ffd1c544ce8b5793c6a22a687dadb2a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build \
		--release \
		--target ${CARGO_TARGET_NAME}
}

termux_step_make_install() {
	install -Dm755 \
		target/${CARGO_TARGET_NAME}/release/cargo-machete \
		"$TERMUX_PREFIX/bin/cargo-machete"
}
