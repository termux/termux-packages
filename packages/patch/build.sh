TERMUX_PKG_HOMEPAGE=https://savannah.gnu.org/projects/patch/
TERMUX_PKG_DESCRIPTION="GNU patch which applies diff files to create patched files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.6
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/patch/patch-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-xattr ac_cv_path_ED=$TERMUX_PREFIX/bin/ed"
TERMUX_PKG_GROUPS="base-devel"
