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
TERMUX_SUBPKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_SUBPKG_DEPEND_ON_PARENT=true # TODO: subpkg of specific needed?
TERMUX_SUBPKG_DEPENDS="libc++"
TERMUX_SUBPKG_BREAKS="binutils (<< 2.39-3)"
TERMUX_SUBPKG_REPLACES="binutils (<< 2.39-3)"
