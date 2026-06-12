TERMUX_PKG_HOMEPAGE=https://github.com/bytecodealliance/wasm-component-ld
TERMUX_PKG_DESCRIPTION="Command line linker for creating WebAssembly components"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-Apache-2.0_WITH_LLVM-exception, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.23"
TERMUX_PKG_SRCURL=https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=31f45a590d03fe83e0857d421e492a37e640b5dc31fd1a8c34fb805192631868
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/wasm-component-ld"
}
