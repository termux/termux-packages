TERMUX_SUBPKG_DESCRIPTION="Rust std for target wasm32"
TERMUX_SUBPKG_DEPENDS="wasi-libc"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_INCLUDE="
lib/rustlib/wasm32-unknown-unknown
lib/rustlib/wasm32-wasi
"
