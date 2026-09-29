TERMUX_SUBPKG_DESCRIPTION="Mesa's Rusticl OpenCL ICD"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="clang (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION), libandroid-shmem, libc++, libclc, libdrm, libllvm (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION), zlib, zstd"
TERMUX_SUBPKG_INCLUDE="
etc/OpenCL/vendors/rusticl.icd
lib/libRusticlOpenCL.so
lib/libRusticlOpenCL.so.1
"
