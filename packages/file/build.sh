TERMUX_PKG_HOMEPAGE=https://darwinsys.com/file/
TERMUX_PKG_DESCRIPTION="Command-line tool that tells you in words what kind of data a file contains"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=5.37
TERMUX_PKG_SRCURL=ftp://ftp.astron.com/pub/file/file-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9c13967f7dd339a3c241b7710ba093560b9a33013491318e88e6b8b57bae07f
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_mmap_fixed_mapped=yes"
TERMUX_PKG_EXTRA_MAKE_ARGS="FILE_COMPILE=$TERMUX_PKG_HOSTBUILD_DIR/src/file"
TERMUX_PKG_HOSTBUILD="yes"
