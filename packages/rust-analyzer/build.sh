TERMUX_PKG_HOMEPAGE=https://github.com/rust-analyzer/rust-analyzer
TERMUX_PKG_DESCRIPTION="A Rust compiler front-end for IDEs"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20210607
TERMUX_PKG_SRCURL=https://github.com/rust-analyzer/rust-analyzer/archive/refs/tags/${TERMUX_PKG_VERSION:0:4}-${TERMUX_PKG_VERSION:4:2}-${TERMUX_PKG_VERSION:6:2}.tar.gz
TERMUX_PKG_SHA256=55bdc9e0c3945c565892efbcb34551ec14e21f11336f5c8d862296b658bb7296
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rust-analyzer
}
