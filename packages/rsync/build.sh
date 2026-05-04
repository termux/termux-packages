TERMUX_PKG_HOMEPAGE=https://rsync.samba.org/
TERMUX_PKG_DESCRIPTION="Fast incremental file transfer utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="3.4.2"
TERMUX_PKG_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff10aa2c151cd4b2dbbe6135126dbc854046113d2dfb49572a348233267eb315
TERMUX_PKG_DEPENDS="libiconv, liblz4, libpopt, openssh | dropbear, openssl, openssl-tool, xxhash, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$TERMUX_PREFIX/etc/rsyncd.conf
--with-included-popt=no
--with-included-zlib=no
--enable-ipv6=yes
--disable-debug
--disable-simd
--disable-xattr-support
--enable-xxhash
"
