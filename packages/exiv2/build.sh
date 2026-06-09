TERMUX_PKG_HOMEPAGE=https://exiv2.org/
TERMUX_PKG_DESCRIPTION="Exif, Iptc and XMP metadata manipulation library and tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:0.28.8"
TERMUX_PKG_SRCURL=https://github.com/Exiv2/exiv2/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=ea51b0609f58a9afa063b60daa1539948b62247721e154f4fff0ad3aec9f9756
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="brotli, libandroid-support, libc++, libexpat, libiconv, libinih, zlib"
TERMUX_PKG_BREAKS="exiv2-dev"
TERMUX_PKG_REPLACES="exiv2-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXIV2_BUILD_SAMPLES=ON
"
