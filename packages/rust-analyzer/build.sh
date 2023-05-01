TERMUX_PKG_HOMEPAGE=https://github.com/rust-analyzer/rust-analyzer
TERMUX_PKG_DESCRIPTION="A Rust compiler front-end for IDEs"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=2023-05-01
TERMUX_PKG_VERSION=${_VERSION//-/}
TERMUX_PKG_SRCURL=https://github.com/rust-analyzer/rust-analyzer/archive/refs/tags/${_VERSION}.tar.gz
TERMUX_PKG_SHA256=26b484e8af818a660c17dfd9c4bd0f27cf694b96150b8f2d08a5c1c64b1aa602
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rust-analyzer
}
