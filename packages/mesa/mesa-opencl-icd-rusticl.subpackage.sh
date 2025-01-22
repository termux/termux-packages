TERMUX_SUBPKG_DESCRIPTION="Mesa's Rusticl OpenCL ICD"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="clang (<< ${_LLVM_MAJOR_VERSION_NEXT}), libandroid-shmem, libc++, libclc, libdrm, libllvm (<< ${_LLVM_MAJOR_VERSION_NEXT}), zlib, zstd"
TERMUX_SUBPKG_INCLUDE="
etc/OpenCL/vendors/rusticl.icd
lib/libRusticlOpenCL.so
lib/libRusticlOpenCL.so.1
"
