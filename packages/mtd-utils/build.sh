TERMUX_PKG_HOMEPAGE=http://www.linux-mtd.infradead.org/
TERMUX_PKG_DESCRIPTION="Utilities for dealing with MTD devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_SRCURL=ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=8d15e8b70f036d6af1a66011f8ca0e048e9675fa7983d33bea92c24313a232d2
TERMUX_PKG_DEPENDS="openssl, liblzo, libuuid, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
