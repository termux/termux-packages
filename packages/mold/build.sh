TERMUX_PKG_HOMEPAGE=https://github.com/rui314/mold
TERMUX_PKG_DESCRIPTION="mold: A Modern Linker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.42.1"
TERMUX_PKG_SRCURL=https://github.com/rui314/mold/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0580221bfdad7148ceeafd0ad3c1c7b3ca9e66b45950405230cc3f81a205c816
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, openssl, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true

# dont depend on system libtbb, xxhash
# https://github.com/rui314/mold/commit/add94b86266b40bc66789e26358675da9d603919#commitcomment-80494077
