TERMUX_PKG_HOMEPAGE=https://github.com/flamegraph-rs/flamegraph
TERMUX_PKG_DESCRIPTION="Simple cargo subcommand for generating flamegraphs, using inferno under the hood"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=0.6.14
TERMUX_PKG_SRCURL=https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c379e26dfacd4c7439456e488457b7f1cb651687c0eb596f4acd1964c6ffbd82
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/cargo-flamegraph" \
		"$TERMUX_PREFIX/bin/cargo-flamegraph"
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/flamegraph" \
		"$TERMUX_PREFIX/bin/flamegraph"
}
