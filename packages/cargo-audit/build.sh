TERMUX_PKG_HOMEPAGE=https://rustsec.org
TERMUX_PKG_DESCRIPTION="Audit Cargo.lock for crates with security vulnerabilities reported to the RustSec Advisory Database"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="cargo-audit/LICENSE-MIT, cargo-audit/LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.22.2"
TERMUX_PKG_SRCURL=https://github.com/rustsec/rustsec/archive/refs/tags/cargo-audit/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85c368a4d166b2cc4972108d50abc5fad605013b65098929a06122439488beb5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="cargo-audit/v\K[0-9]+\.[0-9]+\.[0-9]+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build \
		--release \
		--target "${CARGO_TARGET_NAME}" \
		--manifest-path cargo-audit/Cargo.toml
}

termux_step_make_install() {
	install -Dm755 \
		"target/${CARGO_TARGET_NAME}/release/cargo-audit" \
		"$TERMUX_PREFIX/bin/cargo-audit"
}
