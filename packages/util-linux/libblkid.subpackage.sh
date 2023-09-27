TERMUX_SUBPKG_DESCRIPTION="Block device identification library"
TERMUX_SUBPKG_BREAKS="util-linux (<< 2.38.1-1)"
TERMUX_SUBPKG_REPLACES="util-linux (<< 2.38.1-1)"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
include/blkid/blkid.h
lib/libblkid.so
lib/pkgconfig/blkid.pc
share/man/man3/libblkid.3.gz
"
