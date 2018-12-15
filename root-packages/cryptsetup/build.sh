TERMUX_PKG_HOMEPAGE=https://gitlab.com/cryptsetup/cryptsetup/
TERMUX_PKG_DESCRIPTION="Userspace setup tool for transparent encryption of block devices using dm-crypt"
TERMUX_PKG_VERSION=2.0.6
TERMUX_PKG_SRCURL=https://mirrors.edge.kernel.org/pub/linux/utils/cryptsetup/v{TERMUX_PKG_VERSION:0:2}/cryptsetup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7c51fae0f0e7ea9af0f515b2ac77009fb2969a6619ebab47d097dca38b083d30
TERMUX_PKG_DEPENDS="json-c, libdevmapper, libgcrypt, libpopt, libuuid, util-linux"

