TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/libassuan/
TERMUX_PKG_DESCRIPTION="Library implementing the Assuan IPC protocol used between most newer GnuPG components"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.5.3
TERMUX_PKG_SHA256=91bcb0403866b4e7c4bc1cc52ed4c364a9b5414b3994f718c70303f7f765e702
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libassuan-config"
TERMUX_PKG_DEPENDS="libgpg-error"
