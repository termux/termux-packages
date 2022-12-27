TERMUX_SUBPKG_DESCRIPTION="A device-mapper library"
TERMUX_SUBPKG_DEPENDS="libandroid-support"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no
TERMUX_SUBPKG_INCLUDE="
include/libdevmapper.h
bin/dmstats
bin/dmsetup
lib/libdevmapper.so*
lib/pkgconfig/devmapper.pc
"
