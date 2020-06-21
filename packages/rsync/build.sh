TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Utility that provides fast incremental file transfer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90127fdfb1a0c5fa655f2577e5495a40907903ac98f346f225f867141424fa25
TERMUX_PKG_DEPENDS="libiconv, libpopt, openssh | dropbear, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf
--with-included-zlib=no
--disable-xattr-support
--disable-debug
--disable-xxhash
"
