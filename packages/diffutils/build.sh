TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/diffutils/
TERMUX_PKG_DESCRIPTION="Programs (cmp, diff, diff3 and sdiff) related to finding differences between files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=b3a7a6221c3dc916085f0d205abf6b8e1ba443d4dd965118da364a1dc1cb3a26
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/diffutils/diffutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_PR_PROGRAM=${TERMUX_PREFIX}/bin/pr"
