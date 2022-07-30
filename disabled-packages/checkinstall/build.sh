# NOTE: Currently segfaults when running.
TERMUX_PKG_HOMEPAGE=http://checkinstall.izto.org/
TERMUX_PKG_DESCRIPTION="Installation tracker creating a package from a local install"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=http://checkinstall.izto.org/files/source/checkinstall-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256="dc61192cf7b8286d42c44abae6cf594ee52eafc08bfad0bea9d434b73dd593f4"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="file, make"
TERMUX_PKG_RM_AFTER_INSTALL="lib/checkinstall/locale/"

termux_step_pre_configure() {
	CFLAGS+=" -D__off64_t=off64_t"
	CFLAGS+=" -D_STAT_VER=3"
	CFLAGS+=" -D_MKNOD_VER=1"
	CFLAGS+=" -DS_IREAD=S_IRUSR"
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/checkinstall/checkinstallrc-dist \
	   $TERMUX_PREFIX/lib/checkinstall/checkinstallrc
}
