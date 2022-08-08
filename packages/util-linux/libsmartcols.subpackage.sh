TERMUX_SUBPKG_DESCRIPTION="Library for smart adaptive formatting of tabular data"
TERMUX_SUBPKG_BREAKS="util-linux (<< 2.38.1-1)"
TERMUX_SUBPKG_REPLACES="util-linux (<< 2.38.1-1)"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
lib/libsmartcols.so
lib/pkgconfig/smartcols.pc
include/libsmartcols/libsmartcols.h
"
