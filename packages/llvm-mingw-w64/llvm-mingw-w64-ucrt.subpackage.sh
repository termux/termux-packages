TERMUX_SUBPKG_DESCRIPTION="MinGW-w64 runtime for LLVM-MinGW"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_RECOMMENDS="llvm-mingw-w64"
TERMUX_SUBPKG_INCLUDE="
opt/llvm-mingw-w64/aarch64-w64-mingw32
opt/llvm-mingw-w64/armv7-w64-mingw32
opt/llvm-mingw-w64/i686-w64-mingw32
opt/llvm-mingw-w64/x86_64-w64-mingw32
opt/llvm-mingw-w64/generic-w64-mingw32
share/doc/llvm-mingw-w64-ucrt
"
