TERMUX_SUBPKG_DESCRIPTION="Compiler runtime libraries for LLVM-MinGW"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_RECOMMENDS="llvm-mingw-w64"
TERMUX_SUBPKG_INCLUDE="
lib/clang/$TERMUX_LLVM_MAJOR_VERSION/lib/windows
share/doc/llvm-mingw-w64-libcompiler-rt
"
