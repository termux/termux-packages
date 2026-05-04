TERMUX_PKG_HOMEPAGE=http://www.linux-mtd.infradead.org/
TERMUX_PKG_DESCRIPTION="Utilities for dealing with MTD devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.1"
TERMUX_PKG_SRCURL=ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=03d9dc58ad10ea3549d9528f6b17a44d8944e18e96c0f31474f9f977078b83dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="liblzo, libuuid, openssl, zlib, zstd, libandroid-execinfo"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-tests
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
