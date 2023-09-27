TERMUX_SUBPKG_DESCRIPTION="Library for (un)mounting filesystems"
TERMUX_SUBPKG_DEPENDS="libblkid, libsmartcols"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
include/libmount/libmount.h
lib/libmount.so
lib/pkgconfig/mount.pc
"
