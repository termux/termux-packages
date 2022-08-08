TERMUX_SUBPKG_DESCRIPTION="Library for manipulating disk partition tables"
TERMUX_SUBPKG_DEPENDS="libblkid, libuuid (>> 2.38.1)"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
lib/pkgconfig/fdisk.pc
lib/libfdisk.so
include/libfdisk/libfdisk.h
"
