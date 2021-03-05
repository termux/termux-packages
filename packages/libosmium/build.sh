TERMUX_PKG_HOMEPAGE=https://osmcode.org/libosmium/
TERMUX_PKG_DESCRIPTION="Library for reading from and writing to OSM files in XML and PBF formats"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.16.0
TERMUX_PKG_SRCURL=https://github.com/osmcode/libosmium/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42bbef97226d7db7ce3eeb474603e5b1f2f0f86cec85498868e9416e7cdf5bd5
TERMUX_PKG_DEPENDS="libprotobuf, libosmpbf, libprotozero, libexpat, zlib, libbz2, boost, gdal, proj, liblz4"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DINSTALL_UTFCPP=ON -DBUILD_EXAMPLES=OFF -DBUILD_DATA_TESTS=OFF"
