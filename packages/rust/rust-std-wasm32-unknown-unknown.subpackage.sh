TERMUX_SUBPKG_DESCRIPTION="Rust std for target wasm32-unknown-unknown"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_BREAKS="rust-std-wasm32 (<< 1.74.1-1)"
TERMUX_SUBPKG_REPLACES="rust-std-wasm32 (<< 1.74.1-1)"
TERMUX_SUBPKG_INCLUDE="
lib/rustlib/wasm32-unknown-unknown
"
