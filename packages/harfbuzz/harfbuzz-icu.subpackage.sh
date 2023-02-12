TERMUX_SUBPKG_INCLUDE="
include/harfbuzz/hb-icu.h
lib/libharfbuzz-icu*
lib/pkgconfig/harfbuzz-icu.pc
"
TERMUX_SUBPKG_DESCRIPTION="OpenType text shaping engine ICU backend"
TERMUX_SUBPKG_DEPENDS="libicu"
TERMUX_SUBPKG_BREAKS="harfbuzz (<< 7.0.0)"
TERMUX_SUBPKG_REPLACES="harfbuzz (<< 7.0.0)"
