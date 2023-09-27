TERMUX_SUBPKG_INCLUDE="
include/libdbusmenu-gtk3*
lib/libdbusmenu-gtk3*.so
lib/libdbusmenu-gtk3*.so.*
**/dbusmenu-gtk3*
**/DbusmenuGtk3*
"
TERMUX_SUBPKG_DESCRIPTION="GTK+3 support for libdbusmenu"
TERMUX_SUBPKG_DEPENDS="atk, gdk-pixbuf, gtk3, harfbuzz, libcairo, pango, zlib"
