TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_HOMEPAGE=https://github.com/libfuse/libfuse
TERMUX_PKG_DESCRIPTION="FUSE (Filesystem in Userspace) is an interface for userspace programs to export a filesystem to the Linux kernel"
TERMUX_PKG_VERSION=2.9.8 #3.3.0
TERMUX_PKG_SHA256=ceadc28f033b29d7aa1d7c3a5a267d51c2b572ed4e7346e0f9e24f4f5889debb
TERMUX_PKG_SRCURL=https://github.com/libfuse/libfuse/archive/fuse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-mtab 
MOUNT_FUSE_PATH=$TERMUX_PREFIX/bin
UDEV_RULES_PATH=$TERMUX_PREFIX/etc/udev/rules.d
INIT_D_PATH=$TERMUX_PREFIX/etc/init.d
"
# Code uses telldir() and seekdir():
TERMUX_PKG_API_LEVEL=23
# Requires 64bit off_t, we use super-ugly probably none-functioning patch to work around that for now
termux_step_pre_configure () {
	./makeconf.sh
}
