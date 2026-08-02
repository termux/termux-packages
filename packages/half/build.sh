TERMUX_PKG_HOMEPAGE=https://half.sourceforge.net/
TERMUX_PKG_DESCRIPTION="C++ header-only library for IEEE 754 half-precision floating-point format"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/half/half/${TERMUX_PKG_VERSION}/half-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=76ddbf406e9d9b772ec73af2bf925b38b290b4390cc4064720a08d4b4bca0aa9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	install -Dm644 include/half.hpp "$TERMUX_PREFIX/include/half/half.hpp"
}
