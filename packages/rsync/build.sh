TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Utility that provides fast incremental file transfer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f761838d08052b0b6579cf7f6737d93e47f01f4da04c5d24d3447b7f2a5fad1
TERMUX_PKG_DEPENDS="libiconv, liblz4, libpopt, openssh | dropbear, openssl, openssl-tool, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf
--with-included-popt=no
--with-included-zlib=no
--enable-ipv6=yes
--disable-debug
--disable-simd
--disable-xattr-support
--disable-xxhash
"
