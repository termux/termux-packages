TERMUX_PKG_HOMEPAGE=http://www.linux-mtd.infradead.org/
TERMUX_PKG_DESCRIPTION="Utilities for dealing with MTD devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=8ad4c5f34716d40646aa28724a2f5616d325a6f119254f914e26976f1f76e9d6
TERMUX_PKG_DEPENDS="openssl, liblzo, libuuid, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
# only removed because it calls getrandom, which comes in API 28
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-ubifs"
