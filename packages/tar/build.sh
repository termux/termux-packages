TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/tar/
TERMUX_PKG_DESCRIPTION="GNU tar for manipulating tar archives"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.34
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/tar/tar-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=63bebd26879c5e1eea4352f0d03c991f966aeb3ddeb3c7445c902568d5411d28
TERMUX_PKG_DEPENDS="libandroid-glob, libiconv"
TERMUX_PKG_ESSENTIAL=true

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
