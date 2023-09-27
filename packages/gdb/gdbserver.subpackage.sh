TERMUX_SUBPKG_INCLUDE="
bin/gdbserver
share/man/man1/gdbserver.*
"
TERMUX_SUBPKG_DESCRIPTION="The gdbserver program"
TERMUX_SUBPKG_DEPENDS="libc++, libthread-db"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no
TERMUX_SUBPKG_BREAKS="gdb (<< 13.1)"
TERMUX_SUBPKG_REPLACES="gdb (<< 13.1)"
