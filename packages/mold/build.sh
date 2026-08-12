TERMUX_PKG_HOMEPAGE=https://github.com/rui314/mold
TERMUX_PKG_DESCRIPTION="mold: A Modern Linker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.42.0"
TERMUX_PKG_SRCURL=https://github.com/rui314/mold/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c0f3308c5b3159a369202d970922ad819bab1bfcb5a3b3c06a723d19f65373e
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, openssl, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true

# dont depend on system libtbb, xxhash
# https://github.com/rui314/mold/commit/add94b86266b40bc66789e26358675da9d603919#commitcomment-80494077
