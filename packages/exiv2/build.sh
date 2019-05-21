TERMUX_PKG_HOMEPAGE=https://exiv2.org/
TERMUX_PKG_DESCRIPTION="Exif, Iptc and XMP metadata manipulation library and tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.27.1
TERMUX_PKG_SRCURL=https://github.com/Exiv2/exiv2/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1b3766b2c203ce213a4195de14d61694017ec1a69d15d4575bccecef130990fe
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libexpat, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DEXIV2_ENABLE_VIDEO=ON
-DEXIV2_ENABLE_BUILD_SAMPLES=OFF"
