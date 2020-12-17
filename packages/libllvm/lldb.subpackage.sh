TERMUX_SUBPKG_INCLUDE="
bin/lldb*
include/lldb/
lib/liblldb.so
share/man/man1/lldb.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="LLVM-based debugger"
TERMUX_SUBPKG_DEPENDS="libc++, libedit, libllvm, libxml2, ncurses-ui-libs"
TERMUX_SUBPKG_BREAKS="lldb-dev, lldb-static"
TERMUX_SUBPKG_REPLACES="lldb-dev, lldb-static"
