TERMUX_PKG_HOMEPAGE=https://github.com/void-linux/musl-fts
TERMUX_PKG_DESCRIPTION="Implementation of fts(3) for musl libc"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
TERMUX_PKG_VERSION="1.2.7"
TERMUX_PKG_SRCURL=https://github.com/void-linux/musl-fts/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=49ae567a96dbab22823d045ffebe0d6b14b9b799925e9ca9274d47d26ff482a6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="musl"

# Use musl toolchain installation paths
MUSL_TOOLCHAIN_ROOT="$TERMUX_PREFIX/opt/musl-toolchain"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_configure() {
	"$TERMUX_PKG_SRCDIR/configure" \
		--host="$TERMUX_HOST_PLATFORM" \
		--prefix="$MUSL_SYSROOT/usr" \
		--libdir="$MUSL_SYSROOT/usr/lib" \
		--includedir="$MUSL_SYSROOT/usr/include"
}
