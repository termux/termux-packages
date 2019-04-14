TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Utility that provides fast incremental file transfer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.1.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55cc554efec5fdaad70de921cd5a5eeb6c29a95524c715f3bbf849235b0800c0
TERMUX_PKG_DEPENDS="libpopt, openssh | dropbear, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf
--with-included-zlib=no
--disable-xattr-support
--disable-debug
"

termux_step_pre_configure() {
	CFLAGS="$CFLAGS -llog" # for syslog
}
