TERMUX_SUBPKG_DESCRIPTION="ASP.NET Core 8.0 Runtime Managed Debug Symbols"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="aspnetcore-runtime-8.0"
TERMUX_SUBPKG_INCLUDE=$(cat "${TERMUX_PKG_TMPDIR}"/aspnetcore-runtime-dbg.txt)
