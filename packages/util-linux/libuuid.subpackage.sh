TERMUX_SUBPKG_DESCRIPTION="Library for handling universally unique identifiers"
TERMUX_SUBPKG_BREAKS="libuuid-dev"
TERMUX_SUBPKG_REPLACES="libuuid-dev"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
lib/pkgconfig/uuid.pc
lib/libuuid.so
include/uuid/uuid.h
"
