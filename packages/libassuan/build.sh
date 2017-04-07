TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/libassuan/
TERMUX_PKG_DESCRIPTION="Library implementing the Assuan IPC protocol used between most newer GnuPG components"
TERMUX_PKG_VERSION=2.4.3
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=22843a3bdb256f59be49842abf24da76700354293a066d82ade8134bb5aa2b71
TERMUX_PKG_RM_AFTER_INSTALL="bin/libassuan-config"
TERMUX_PKG_DEPENDS="libgpg-error"
