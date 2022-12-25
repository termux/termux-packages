TERMUX_PKG_HOMEPAGE=https://github.com/libfuse/libfuse
TERMUX_PKG_DESCRIPTION="FUSE (Filesystem in Userspace) is an interface for userspace programs to export a filesystem to the Linux kernel"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.9.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libfuse/libfuse/archive/fuse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e57a24721177c3b3dd71cb9239ca46b4dee283db9388d48f7ccd256184982194
TERMUX_PKG_DEPENDS="libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-example
--disable-mtab
"

TERMUX_PKG_RM_AFTER_INSTALL="
etc/init.d
etc/udev
"

termux_step_pre_configure() {
	export MOUNT_FUSE_PATH=$TERMUX_PREFIX/bin
	export UDEV_RULES_PATH=$TERMUX_PREFIX/etc/udev/rules.d
	export INIT_D_PATH=$TERMUX_PREFIX/etc/init.d
	./makeconf.sh
}
