TERMUX_SUBPKG_INCLUDE="
bin/g-ir-scanner
lib/gobject-introspection/giscanner/
share/man/man1/g-ir-scanner.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="A tool which generates GIR XML files"
TERMUX_SUBPKG_DEPENDS="ldd, python"
TERMUX_SUBPKG_BREAKS="gobject-introspection (<< 1.74.0-1)"
TERMUX_SUBPKG_REPLACES="gobject-introspection (<< 1.74.0-1)"
