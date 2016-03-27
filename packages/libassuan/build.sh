TERMUX_PKG_HOMEPAGE=http://www.gnupg.org/related_software/libassuan/
TERMUX_PKG_DESCRIPTION="Library implementing the Assuan IPC protocol used between most newer GnuPG components"
TERMUX_PKG_VERSION=2.4.2
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_RM_AFTER_INSTALL="bin/libassuan-config"
TERMUX_PKG_DEPENDS="libgpg-error"
