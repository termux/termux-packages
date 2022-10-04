TERMUX_SUBPKG_INCLUDE="
include/
lib/
share/info/bfd.info
share/info/ctf-spec.info
"
TERMUX_SUBPKG_DESCRIPTION="Binutils libraries"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no
TERMUX_SUBPKG_DEPENDS="zlib"
TERMUX_SUBPKG_REPLACES="binutils (<< 2.39)"
TERMUX_SUBPKG_BREAKS="binutils (<< ${TERMUX_PKG_VERSION})"
