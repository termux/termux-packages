TERMUX_PKG_HOMEPAGE=http://www.linux-mtd.infradead.org/
TERMUX_PKG_DESCRIPTION="Utilities for dealing with MTD devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.6"
TERMUX_PKG_SRCURL=ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=c1d853bc4adf83bcabd2792fc95af33bdd8643c97e8f7b3f0180af36af76f0e5
TERMUX_PKG_DEPENDS="liblzo, libuuid, openssl, zlib, zstd, libandroid-execinfo"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
