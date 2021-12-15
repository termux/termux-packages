TERMUX_SUBPKG_DESCRIPTION="Compiler runtime libraries for clang"
TERMUX_SUBPKG_INCLUDE="
lib/clang/*/bin/asan_device_setup
lib/clang/*/bin/hwasan_symbolize
lib/clang/*/include/fuzzer/FuzzedDataProvider.h
lib/clang/*/include/profile/InstrProfData.inc
lib/clang/*/include/sanitizer/
lib/clang/*/include/xray/
lib/clang/*/lib/android/
lib/clang/*/share/asan_ignorelist.txt
lib/clang/*/share/cfi_ignorelist.txt
lib/clang/*/share/hwasan_ignorelist.txt
"
