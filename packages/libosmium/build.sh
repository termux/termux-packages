TERMUX_PKG_HOMEPAGE=https://osmcode.org/libosmium/
TERMUX_PKG_DESCRIPTION="Library for reading from and writing to OSM files in XML and PBF formats"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.17.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/osmcode/libosmium/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a7672d7caf4da3bc68619912b298462370c423c697871a0be6273c6686e10d6
TERMUX_PKG_DEPENDS="libprotobuf, libosmpbf, libprotozero, libexpat, zlib, libbz2, boost, gdal, proj, liblz4"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DINSTALL_UTFCPP=ON -DBUILD_EXAMPLES=OFF -DBUILD_DATA_TESTS=OFF"
