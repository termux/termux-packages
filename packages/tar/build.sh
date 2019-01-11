TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/tar/
TERMUX_PKG_DESCRIPTION="GNU tar for manipulating tar archives"
TERMUX_PKG_VERSION=1.31
TERMUX_PKG_SHA256=37f3ef1ceebd8b7e1ebf5b8cc6c65bb8ebf002c7d049032bf456860f25ec2dc1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/tar/tar-${TERMUX_PKG_VERSION}.tar.xz
# Allow xz compression (busybox only provides xz decompression):
TERMUX_PKG_DEPENDS="xz-utils, libandroid-glob"
# When cross-compiling configure guesses that d_ino in struct dirent only exists
# if triplet matches linux*-gnu*, so we force set it explicitly:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="gl_cv_struct_dirent_d_ino=yes"
# this needed to disable tar's implementation of mkfifoat() so it is possible
# to use own implementation (see patch 'mkfifoat.patch').
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mkfifoat=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
	LDFLAGS+=" -landroid-glob"
}
