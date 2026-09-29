TERMUX_SUBPKG_INCLUDE="
libexec/sftp-server
share/man/man1/sftp.1.gz
share/man/man8/sftp-server.8.gz
"
TERMUX_SUBPKG_DESCRIPTION="OpenSSH SFTP server subsystem"
TERMUX_SUBPKG_DEPENDS="libandroid-support"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_REPLACES="openssh (<= 9.9p2-1)"
TERMUX_SUBPKG_BREAKS="openssh (<= 9.9p2-1)"
