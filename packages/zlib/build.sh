TERMUX_PKG_HOMEPAGE=https://www.zlib.net/
TERMUX_PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.13
TERMUX_PKG_SRCURL=https://www.zlib.net/zlib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d14c38e313afc35a9a8760dadf26042f51ea0f5d154b0630a31da0540107fb98
TERMUX_PKG_BREAKS="ndk-sysroot (<< 19b-3), zlib-dev"
TERMUX_PKG_REPLACES="ndk-sysroot (<< 19b-3), zlib-dev"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a+crc"
		CXXFLAGS+=" -march=armv8-a+crc"
	fi
}

termux_step_configure() {
	"$TERMUX_PKG_SRCDIR/configure" --prefix=$TERMUX_PREFIX
}
