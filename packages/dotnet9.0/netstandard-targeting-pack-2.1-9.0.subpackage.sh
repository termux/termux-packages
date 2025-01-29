TERMUX_SUBPKG_DESCRIPTION="NETStandard.Library 2.1 Targeting Pack (.NET 9.0)"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="dotnet-host"
TERMUX_SUBPKG_CONFLICTS="netstandard-targeting-pack-2.1-8.0"
TERMUX_SUBPKG_INCLUDE=$(cat "${TERMUX_PKG_TMPDIR}"/netstandard-targeting-pack-2.1.txt)
