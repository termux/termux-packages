TERMUX_PKG_MAINTINER="Henrik Grimler @Grimler91"
TERMUX_PKG_HOMEPAGE=https://github.com/libfuse/libfuse
TERMUX_PKG_DESCRIPTION="FUSE (Filesystem in Userspace) is an interface for userspace programs to export a filesystem to the Linux kernel"
TERMUX_PKG_VERSION=3.2.6
TERMUX_PKG_SHA256=686b98afac4ca322498f68d37d598ae3d07919fe21a4700c76572fae59a6256b
TERMUX_PKG_SRCURL=https://github.com/libfuse/libfuse/archive/fuse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dudevrulesdir=$TERMUX_PREFIX/etc/udev"
# Code uses telldir() and seekdir():
TERMUX_PKG_API_LEVEL=23
# Requires 64bit off_t, we use super-ugly probably none-functioning patch to work around that for now
