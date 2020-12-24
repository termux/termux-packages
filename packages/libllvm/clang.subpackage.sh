TERMUX_SUBPKG_INCLUDE="
bin/c++
bin/cc
bin/*clang*
bin/*cpp
bin/diagtool
bin/find-all-symbols
bin/*g++
bin/*gcc
bin/git-clang-format
bin/hmaptool
bin/modularize
bin/pp-trace
bin/scan-*
include/clang*
include/omp*.h
lib/clang/*/include/*.h
lib/clang/*/include/*.modulemap
lib/clang/*/include/openmp_wrappers/
lib/clang/*/include/ppc_wrappers/
lib/clang/*/include/cuda_wrappers/
lib/cmake/clang
lib/libclang*so
lib/libomp.a
libexec/
share/clang
share/scan-*
share/man/man1/clang.1.gz
share/man/man1/scan-*
"
TERMUX_SUBPKG_DESCRIPTION="C language frontend for LLVM"
TERMUX_SUBPKG_BREAKS="libllvm (<< 11.0.0-1), clangd"
TERMUX_SUBPKG_REPLACES="libllvm (<< 11.0.0-1), clangd"
