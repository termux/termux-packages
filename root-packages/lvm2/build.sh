TERMUX_PKG_HOMEPAGE=https://sourceware.org/lvm2/
TERMUX_PKG_DESCRIPTION="A device-mapper library from LVM2 package"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.BSD, COPYING.LIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.03.28"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/sourceware/lvm2/releases/LVM2.${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=b822baff6b62df36382c717ceba98a2688ebb31bf2b768f3ffa2b6d5e2557242
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaio, libandroid-support, libblkid, readline"
TERMUX_PKG_BREAKS="libdevmapper-dev"
TERMUX_PKG_REPLACES="libdevmapper-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-pkgconfig
--disable-selinux
--with-default-system-dir=$TERMUX_PREFIX/etc/lvm
--with-default-pid-dir=$TERMUX_PREFIX/var/run
--with-default-profile-subdir=profile.d
--with-default-run-dir=$TERMUX_PREFIX/var/run
--with-default-locking-dir=$TERMUX_PREFIX/var/run/lock/lvm
--with-confdir=$TERMUX_PREFIX/etc
--with-symvers=no
"

termux_step_pre_configure() {
	export CFLAGS="$CFLAGS $CPPFLAGS"
	export CLDFLAGS="$LDFLAGS"

	find "$TERMUX_PKG_SRCDIR" -name '*.[ch]' | xargs -n 1 \
		sed -i 's/\([^A-Za-z0-9_]\)\(stack[^A-Za-z0-9_]\)/\1log_\2/g'
}
