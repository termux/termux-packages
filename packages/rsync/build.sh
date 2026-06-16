TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Fast incremental file transfer utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="3.4.4"
TERMUX_PKG_SRCURL="https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=bd88cf82fa653da32314fb229136407c5c90f80d1758d8f4b091767877d8fa96
TERMUX_PKG_DEPENDS="libiconv, liblz4, libpopt, openssh | dropbear, openssl, openssl-tool, xxhash, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf
--with-included-popt=no
--with-included-zlib=no
--enable-ipv6=yes
--disable-debug
--disable-xattr-support
--enable-xxhash
"
