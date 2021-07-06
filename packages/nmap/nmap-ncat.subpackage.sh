# FIXME: unsplit and use update-alternatives to provide symlinks and avoid
# the conflict with netcat-openbsd? We do not split nping from nmap package.

TERMUX_SUBPKG_INCLUDE="bin/ncat share/man/man1/ncat.1.gz"
TERMUX_SUBPKG_DESCRIPTION="Feature-packed networking utility which reads and writes data across networks from the command line"
TERMUX_SUBPKG_DEPENDS="libpcap, openssl, liblua53"
TERMUX_SUBPKG_BREAKS="netcat"
TERMUX_SUBPKG_REPLACES="netcat"
