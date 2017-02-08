TERMUX_PKG_VERSION=1.5.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="apr, libexpat"
TERMUX_PKG_HOMEPAGE=https://apr.apache.org/
TERMUX_PKG_DESCRIPTION="Apache Portable Runtime - library providing a predictable and consistent interface to underlying platform-specific implementations"
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/apr/apr-util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-apr=$TERMUX_PREFIX --without-sqlite3"
TERMUX_PKG_RM_AFTER_INSTALL="bin/apu-1-config lib/aprutil.exp"
