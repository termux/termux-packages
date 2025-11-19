TERMUX_SUBPKG_INCLUDE="
lib/libform*.so*
lib/libmenu*.so*
lib/libpanel*.so*
lib/pkgconfig/form*.pc
lib/pkgconfig/menu*.pc
lib/pkgconfig/panel*.pc
"
TERMUX_SUBPKG_DESCRIPTION="Libraries for terminal user interfaces based on ncurses"
TERMUX_SUBPKG_BREAKS="ncurses (<< 6.4)"
TERMUX_SUBPKG_REPLACES="ncurses (<< 6.4)"
