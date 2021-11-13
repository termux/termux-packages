TERMUX_PKG_HOMEPAGE=https://wapm.io
TERMUX_PKG_DESCRIPTION="The WebAssembly Package Manager CLI"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_SRCURL=https://github.com/wasmerio/wapm-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e01dcf040cfa32cfcd1ad7aa18a0cb40a7b8040fb34a58de8ebce2c47ad154a5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="wasmer"

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
    install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/wapm
}
