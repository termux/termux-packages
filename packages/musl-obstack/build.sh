TERMUX_PKG_HOMEPAGE=https://github.com/void-linux/musl-obstack
TERMUX_PKG_DESCRIPTION="Standalone obstack implementation for musl libc"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
TERMUX_PKG_VERSION="1.2.3"
TERMUX_PKG_SRCURL=https://github.com/void-linux/musl-obstack/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ffb3479b15df0170eba4480e51723c3961dbe0b461ec289744622db03a69395
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
