TERMUX_PKG_HOMEPAGE=https://www.zlib.net/
TERMUX_PKG_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_VERSION=1.2.11
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066
TERMUX_PKG_SRCURL=https://www.zlib.net/zlib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEVPACKAGE_BREAKS="ndk-sysroot (<< 19b-3)"

termux_step_configure() {
     "$TERMUX_PKG_SRCDIR/configure" --prefix=$TERMUX_PREFIX
}
