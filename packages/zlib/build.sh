TERMUX_PKG_HOMEPAGE=https://www.zlib.net/
TERMUX_PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.12
TERMUX_PKG_SRCURL=https://www.zlib.net/zlib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=7db46b8d7726232a621befaab4a1c870f00a90805511c0e0090441dac57def18
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
	sed -n '/Copyright (C) 1995-/,/madler@alumni.caltech.edu/p' "$TERMUX_PKG_SRCDIR/zlib.h" > "$TERMUX_PKG_SRCDIR/LICENSE"
}
