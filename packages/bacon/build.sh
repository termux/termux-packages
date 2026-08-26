TERMUX_PKG_HOMEPAGE=https://dystroy.org/bacon
TERMUX_PKG_DESCRIPTION="A background code checker for Rust, designed for minimal interaction"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.25.0"
TERMUX_PKG_SRCURL=https://github.com/Canop/bacon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6657e968d189dd5c165dd6c9b97f667140baea87d126d765a2d5f1e97b007b26
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
}
