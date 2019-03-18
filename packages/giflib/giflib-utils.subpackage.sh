TERMUX_SUBPKG_DESCRIPTION="A set of utilities that comes with giflib package"
TERMUX_SUBPKG_DEPENDS="giflib"
TERMUX_SUBPKG_CONFLICTS="giflib (<< 5.1.4-4)"

TERMUX_SUBPKG_INCLUDE="
bin/
share/man/"
