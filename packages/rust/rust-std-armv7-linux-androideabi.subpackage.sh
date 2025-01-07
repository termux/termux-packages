TERMUX_SUBPKG_DESCRIPTION="Rust std for target armv7-linux-androideabi"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_BREAKS="rust (<< 1.74.1-1)"
TERMUX_SUBPKG_REPLACES="rust (<< 1.74.1-1)"
TERMUX_SUBPKG_INCLUDE="
lib/rustlib/armv7-linux-androideabi/lib/*.rlib
lib/rustlib/armv7-linux-androideabi/lib/libstd-*.so
"
