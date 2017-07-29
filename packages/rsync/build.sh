TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Utility that provides fast incremental file transfer"
TERMUX_PKG_VERSION=3.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf --with-included-zlib=no --disable-debug"
TERMUX_PKG_DEPENDS="libpopt, openssh"

termux_step_pre_configure () {
	CFLAGS="$CFLAGS -llog" # for syslog
}
