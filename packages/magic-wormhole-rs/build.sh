TERMUX_PKG_HOMEPAGE="https://github.com/magic-wormhole/magic-wormhole.rs"
TERMUX_PKG_DESCRIPTION=" Rust implementation of Magic Wormhole, with new features and enhancements"
TERMUX_PKG_LICENSE="EUPL-1.2"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=1d76e80108291f0a31e1a0e2e1d6199decb55bec73bc725baacb93ea0ae06e5e
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release \
		--no-default-features --features "magic-wormhole/default,magic-wormhole/forwarding"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/wormhole-rs"
}
