TERMUX_SUBPKG_DESCRIPTION="tcl bindings for SQLite"
TERMUX_SUBPKG_DEPENDS="tcl"
TERMUX_SUBPKG_BREAKS="sqlcipher (<< 4.4.2-1), tcl (<< 8.6.10-4)"
TERMUX_SUBPKG_INCLUDE="lib/sqlite3/libtclsqlite3.so lib/sqlite3/pkgIndex.tcl"
