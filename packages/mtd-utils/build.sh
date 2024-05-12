TERMUX_PKG_HOMEPAGE=http://www.linux-mtd.infradead.org/
TERMUX_PKG_DESCRIPTION="Utilities for dealing with MTD devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL=ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=250d082f67375ca8451b5fcfc9a23a53ced3ebebd8312c288daf2507bbab1324
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="liblzo, libuuid, openssl, zlib, zstd, libandroid-execinfo"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
