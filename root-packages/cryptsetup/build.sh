TERMUX_PKG_HOMEPAGE=https://gitlab.com/cryptsetup/cryptsetup/
TERMUX_PKG_DESCRIPTION="Userspace setup tool for transparent encryption of block devices using dm-crypt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=https://mirrors.edge.kernel.org/pub/linux/utils/cryptsetup/v${TERMUX_PKG_VERSION:0:3}/cryptsetup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a3eeb2741f8f3376d16585191f3c60e067dd987e096c3c4b073fab7748b1c897
TERMUX_PKG_DEPENDS="json-c, libdevmapper, libgcrypt, libpopt, libuuid, util-linux, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-luks2-lock-path=$PREFIX/var/run
"
