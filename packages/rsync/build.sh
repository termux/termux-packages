TERMUX_PKG_HOMEPAGE=http://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Utility that provides fast incremental file transfer"
TERMUX_PKG_VERSION=3.1.1
TERMUX_PKG_SRCURL=http://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf --with-included-zlib=no --disable-debug"
CFLAGS="$CFLAGS -llog" # for syslog
