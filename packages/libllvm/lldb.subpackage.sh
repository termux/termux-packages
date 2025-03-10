TERMUX_SUBPKG_INCLUDE="
bin/lldb*
include/lldb/
lib/liblldb.so
lib/python${TERMUX_PYTHON_VERSION}/site-packages
"
TERMUX_SUBPKG_DESCRIPTION="LLVM-based debugger"
TERMUX_SUBPKG_DEPENDS="clang, libandroid-spawn, libc++, libedit, libxml2, python, ncurses-ui-libs"
TERMUX_SUBPKG_BREAKS="lldb-dev, lldb-static"
TERMUX_SUBPKG_REPLACES="lldb-dev, lldb-static"

# https://github.com/termux/termux-packages/issues/8880
TERMUX_SUBPKG_EXCLUDED_ARCHES="arm, i686"
