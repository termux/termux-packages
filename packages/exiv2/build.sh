TERMUX_PKG_HOMEPAGE=https://exiv2.org/
TERMUX_PKG_DESCRIPTION="Exif, Iptc and XMP metadata manipulation library and tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2:0.28.3
TERMUX_PKG_SRCURL=https://github.com/Exiv2/exiv2/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=1315e17d454bf4da3cc0edb857b1d2c143670f3485b537d0f946d9ed31d87b70
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="brotli, libandroid-support, libc++, libexpat, libiconv, libinih, zlib"
TERMUX_PKG_BREAKS="exiv2-dev"
TERMUX_PKG_REPLACES="exiv2-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXIV2_BUILD_SAMPLES=ON
"
