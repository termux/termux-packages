TERMUX_PKG_HOMEPAGE=https://github.com/bnjbvr/cargo-machete
TERMUX_PKG_DESCRIPTION="Find unused dependencies in Rust projects"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_SRCURL="https://github.com/bnjbvr/cargo-machete/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=913be6da330551aa322d75aa3ccb8229b95902ce4098d6bedba66238b77a7e37
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
