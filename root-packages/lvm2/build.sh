TERMUX_PKG_HOMEPAGE=https://sourceware.org/lvm2/
TERMUX_PKG_DESCRIPTION="A device-mapper library from LVM2 package"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.03.16
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/sourceware/lvm2/releases/LVM2.${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=e661ece15b5d88d8abe39a4c1e1db2f43e1896f019948bb98b0e15d777680786
TERMUX_PKG_DEPENDS="libandroid-support, libaio, readline"
TERMUX_PKG_BREAKS="libdevmapper-dev"
TERMUX_PKG_REPLACES="libdevmapper-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-pkgconfig
--disable-selinux
--with-default-system-dir=$TERMUX_PREFIX/etc/lvm
--with-default-pid-dir=$TERMUX_PREFIX/var/run
--with-default-profile-subdir=profile.d
--with-default-run-dir=$TERMUX_PREFIX/var/run
--with-default-locking-dir=$TERMUX_PREFIX/var/run/lock/lvm
--with-confdir=$TERMUX_PREFIX/etc
"

termux_step_pre_configure() {
	export CFLAGS="$CFLAGS $CPPFLAGS"
}
