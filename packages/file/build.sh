TERMUX_PKG_HOMEPAGE=https://darwinsys.com/file/
TERMUX_PKG_DESCRIPTION="Command-line tool that tells you in words what kind of data a file contains"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=5.38
TERMUX_PKG_SRCURL=ftp://ftp.astron.com/pub/file/file-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=593c2ffc2ab349c5aea0f55fedfe4d681737b6b62376a9b3ad1e77b2cc19fa34
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BREAKS="file-dev"
TERMUX_PKG_REPLACES="file-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_mmap_fixed_mapped=yes"
TERMUX_PKG_EXTRA_MAKE_ARGS="FILE_COMPILE=$TERMUX_PKG_HOSTBUILD_DIR/src/file"
TERMUX_PKG_HOSTBUILD=true
