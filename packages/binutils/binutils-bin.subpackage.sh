TERMUX_SUBPKG_INCLUDE="
bin/as
bin/elfedit
bin/gprof
bin/ld.bfd
libexec/binutils/
share/info/as.info
share/info/binutils.info
share/info/gprof.info
share/info/ld.info
share/man/
"
# The contents of this subpackage are specifically chosen to not conflict with binutils-is-llvm,
# to provide `as` in that collection since `llvm-as` behaves quite differently from GNU `as`.
TERMUX_SUBPKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_SUBPKG_DEPEND_ON_PARENT=true
TERMUX_SUBPKG_DEPENDS="libc++, zlib, zstd"
TERMUX_SUBPKG_BREAKS="binutils (<< 2.46)"
TERMUX_SUBPKG_REPLACES="binutils (<< 2.46)"
