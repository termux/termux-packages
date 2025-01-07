TERMUX_PKG_HOMEPAGE=https://gitlab.com/cryptsetup/cryptsetup/
TERMUX_PKG_DESCRIPTION="Userspace setup tool for transparent encryption of block devices using dm-crypt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.5
TERMUX_PKG_SRCURL=https://mirrors.edge.kernel.org/pub/linux/utils/cryptsetup/v${TERMUX_PKG_VERSION:0:3}/cryptsetup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d2be4395b8f503b0ebf4b2d81db90c35a97050a358ee21fe62a0dfb66e5d5522
TERMUX_PKG_DEPENDS="json-c, libblkid, libdevmapper, libgcrypt, libuuid, openssl, libiconv, argon2"
TERMUX_PKG_BREAKS="cryptsetup-dev, cryptsetup (<< 2.4.3-1)"
TERMUX_PKG_REPLACES="cryptsetup-dev, cryptsetup (<< 2.4.3-1)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-luks2-lock-path=$TERMUX_PREFIX/var/run
--enable-libargon2
--disable-ssh-token
"

termux_step_pre_configure() {
	export LDFLAGS+=" -liconv"
}
