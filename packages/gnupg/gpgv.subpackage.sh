TERMUX_SUBPKG_INCLUDE="bin/gpgv share/man/man1/gpgv.1.gz"
TERMUX_SUBPKG_DESCRIPTION="GNU privacy guard - signature verification tool"
# Conflict with older gnupg package before splitting out gpgv:
TERMUX_SUBPKG_CONFLICTS="gnupg (<= 1.4.21)"
TERMUX_SUBPKG_DEPENDS="libbz2, libgcrypt, libgpg-error,zlib"
