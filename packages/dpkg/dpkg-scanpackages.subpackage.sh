TERMUX_SUBPKG_DESCRIPTION="Creates Packages index files"
TERMUX_SUBPKG_INCLUDE="
bin/dpkg-scanpackages
share/man/man1/dpkg-scanpackages.1.gz
"
TERMUX_SUBPKG_DEPENDS="dpkg-perl"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
