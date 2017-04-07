TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/tar/
TERMUX_PKG_DESCRIPTION="GNU tar for manipulating tar archives"
TERMUX_PKG_VERSION=1.29
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/tar/tar-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=402dcfd0022fd7a1f2c5611f5c61af1cd84910a760a44a688e18ddbff4e9f024
# Allow xz compression (busybox only provides xz decompression):
TERMUX_PKG_DEPENDS="xz-utils"
# When cross-compiling configure guesses that d_ino in struct dirent only exists
# if triplet matches linux*-gnu*, so we force set it explicitly:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="gl_cv_struct_dirent_d_ino=yes"
