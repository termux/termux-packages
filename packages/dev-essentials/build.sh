TERMUX_PKG_HOMEPAGE=https://github.com/Dess-Services/dev-essentials
TERMUX_PKG_DESCRIPTION="Unified development suite for APK building, Web, and Native coding. Includes D8, DX, JQ, and full compilers for Termux beginners."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Dess-Services <dessservicesofc@gmail.com>"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/Dess-Services/dev-essentials/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=720dc8725fdca377a847e4708576093e544250558870c34c2e641369f13f9198
TERMUX_PKG_DEPENDS="python, openjdk-17, clang, binutils, coreutils, nano, php, git, jq, aapt2, dx, ecj, zlib, libandroid-support, p7zip, zstd, lz4, xz-utils, apksigner, make, cmake, gdb, tar, unzip, zip, curl, wget"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
build.sh install -m 755 "$TERMUX_PKG_SRCDIR/bin/dev-help" "$TERMUX_PREFIX/bin/"
build.sh install -m 755 "$TERMUX_PKG_SRCDIR/bin/dev-dx-help" "$TERMUX_PREFIX/bin/"
build.sh install -m 755 "$TERMUX_PKG_SRCDIR/bin/dev-aapt2-help" "$TERMUX_PREFIX/bin/"
build.sh install -m 755 "$TERMUX_PKG_SRCDIR/bin/dev-sign-help" "$TERMUX_PREFIX/bin/"
build.sh install -m 755 "$TERMUX_PKG_SRCDIR/bin/d-compact" "$TERMUX_PREFIX/bin/"
build.sh install -m 755 "$TERMUX_PKG_SRCDIR/bin/d-archive-test" "$TERMUX_PREFIX/bin/"
}
