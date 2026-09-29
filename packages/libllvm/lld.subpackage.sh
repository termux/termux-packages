TERMUX_SUBPKG_INCLUDE="
bin/ld
bin/ld.lld
bin/ld64.lld
bin/lld
bin/lld-link
bin/wasm-ld
bin/*-linux-android*-ld
include/lld/
lib/cmake/lld/
lib/liblld*.a
share/man/man1/ld.1.gz
share/man/man1/ld.lld.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="LLVM-based linker"
TERMUX_SUBPKG_BREAKS="binutils (<< 2.46.0-3), binutils-is-llvm"
TERMUX_SUBPKG_CONFLICTS="binutils (<< 2.46.0-3), binutils-is-llvm"
TERMUX_SUBPKG_REPLACES="binutils-is-llvm"
