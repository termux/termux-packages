TERMUX_SUBPKG_INCLUDE="bin/clang* bin/scan-build bin/scan-view bin/git-clang-format lib/libclang* "
TERMUX_SUBPKG_INCLUDE+="libexec/ccc-analyzer libexec++-analyzer share/scan-view "
TERMUX_SUBPKG_INCLUDE+="share/clang share/man/man1/scan-build.1 share/scan-build"
TERMUX_SUBPKG_DESCRIPTION='C language family frontend for LLVM'
TERMUX_SUBPKG_DEPENDS="llvm"
