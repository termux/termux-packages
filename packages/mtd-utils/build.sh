TERMUX_PKG_HOMEPAGE=http://www.linux-mtd.infradead.org/
TERMUX_PKG_DESCRIPTION="Utilities for dealing with MTD devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=11305a5daf6fc6ed85120695c8593290b577effb039adbfa63d35b4418ff5630
TERMUX_PKG_DEPENDS="openssl, liblzo, libuuid, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
# only removed because it calls getrandom, which comes in API 28
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-ubifs"
