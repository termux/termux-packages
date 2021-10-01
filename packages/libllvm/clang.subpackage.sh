TERMUX_SUBPKG_INCLUDE="
bin/analyze-build
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
bin/intercept-build
bin/modularize
bin/pp-trace
bin/scan-*
include/clang*
include/omp*.h
lib/clang/*/include/*.h
lib/clang/*/include/*.modulemap
lib/clang/*/include/cuda_wrappers/
lib/clang/*/include/openmp_wrappers/
lib/clang/*/include/ppc_wrappers/
lib/cmake/clang
lib/cmake/openmp
lib/libclang*so
lib/libear/
lib/libomp.a
lib/libscanbuild/
libexec/
share/clang
share/man/man1/clang.1.gz
share/man/man1/scan-*
share/scan-*
"
TERMUX_SUBPKG_DESCRIPTION="C language frontend for LLVM"
TERMUX_SUBPKG_DEPENDS="lld, ndk-sysroot, libcompiler-rt"
TERMUX_SUBPKG_BREAKS="libllvm (<< 11.0.0-1), clangd"
TERMUX_SUBPKG_REPLACES="libllvm (<< 11.0.0-1), clangd"
TERMUX_SUBPKG_GROUPS="base-devel"
