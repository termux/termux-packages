TERMUX_PKG_HOMEPAGE="https://github.com/magic-wormhole/magic-wormhole.rs"
TERMUX_PKG_DESCRIPTION=" Rust implementation of Magic Wormhole, with new features and enhancements"
TERMUX_PKG_LICENSE="EUPL-1.2"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL="https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=cfa72215b1b0f519b9986523d0c41d6b3e562c41668f28ee80c23ce0aa3fe685
TERMUX_PKG_BUILD_IN_SRC=true
# disable auto-update since 'remove-clipboard' patch was maually crafted for v0.6.0
TERMUX_PKG_AUTO_UPDATE=false

termux_step_make() {
	termux_setup_rust
	cargo build --jobs "$TERMUX_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/wormhole-rs"
}
