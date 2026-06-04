TERMUX_SUBPKG_DESCRIPTION="tcl bindings for SQLite"
TERMUX_SUBPKG_DEPENDS="tcl"
TERMUX_SUBPKG_BREAKS="libsqlite-tcl, sqlcipher (<< 4.4.2-1), tcl (<< 8.6.10-4)"
TERMUX_PKG_REPLACES="libsqlite-tcl"

TERMUX_SUBPKG_INCLUDE="lib/sqlite3/libtclsqlite3.so lib/sqlite3/pkgIndex.tcl"
