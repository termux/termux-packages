TERMUX_SUBPKG_INCLUDE="
bin/c++
bin/cc
bin/*clang*
bin/*cpp
bin/*g++
bin/*gcc
bin/git-clang-format
bin/scan-*
include/clang*
include/omp.h
lib/clang/*/include/*.h
lib/clang/*/include/openmp_wrappers/
lib/clang/*/include/ppc_wrappers/
lib/clang/*/include/cuda_wrappers/
lib/cmake/clang
lib/libclang*so
lib/libomp.a
libexec/
share/clang
share/scan-*
share/man/man1/scan-*
"
TERMUX_SUBPKG_DESCRIPTION="C language frontend for LLVM"
TERMUX_SUBPKG_BREAKS="libllvm (<< 10.0.0), clangd"
TERMUX_SUBPKG_REPLACES="clangd"
