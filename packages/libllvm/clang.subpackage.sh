TERMUX_SUBPKG_INCLUDE="
bin/amdgpu-arch
bin/analyze-build
bin/c++
bin/cc
bin/clang*
bin/cpp
bin/diagtool
bin/find-all-symbols
bin/g++
bin/gcc
bin/git-clang-format
bin/hmaptool
bin/intercept-build
bin/*-linux-android*
bin/modularize
bin/nvptx-arch
bin/pp-trace
bin/run-clang-tidy
bin/scan-*
include/clang*
lib/clang/*/include/*.h
lib/clang/*/include/module.modulemap
lib/clang/*/include/cuda_wrappers/
lib/clang/*/include/openmp_wrappers/
lib/clang/*/include/orc/
lib/clang/*/include/ppc_wrappers/
lib/cmake/clang
lib/cmake/openmp
lib/libarcher.so
lib/libclang*so
lib/libear/
lib/libomp.a
lib/libscanbuild/
libexec/
share/clang
share/man/man1/clang.1.gz
share/man/man1/diagtool.1.gz
share/man/man1/scan-build.1.gz
share/scan-*
"
TERMUX_SUBPKG_DESCRIPTION="C language frontend for LLVM"
TERMUX_SUBPKG_DEPENDS="libcompiler-rt, binutils-is-llvm, ndk-sysroot"
TERMUX_SUBPKG_BREAKS="libllvm (<< 16.0.0), clangd"
TERMUX_SUBPKG_REPLACES="libllvm (<< 16.0.0), clangd"
TERMUX_SUBPKG_GROUPS="base-devel"
