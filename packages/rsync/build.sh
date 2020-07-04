TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Utility that provides fast incremental file transfer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95f2dd62979b500a99b34c1a6453a0787ada0330e4bec7fcffad37b9062d58d3
TERMUX_PKG_DEPENDS="libiconv, liblz4, libpopt, openssh | dropbear, openssl-tool, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf
--with-included-popt=no
--with-included-zlib=no
--disable-debug
--disable-simd
--disable-xattr-support
--disable-xxhash
"
