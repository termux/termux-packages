TERMUX_SUBPKG_DESCRIPTION="Rust std for target i686-linux-android"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_BREAKS="rust (<< 1.74.1-1)"
TERMUX_SUBPKG_REPLACES="rust (<< 1.74.1-1)"
TERMUX_SUBPKG_INCLUDE="
lib/rustlib/i686-linux-android/lib/*.rlib
lib/rustlib/i686-linux-android/lib/libstd-*.so
"
