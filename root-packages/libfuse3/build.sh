TERMUX_PKG_HOMEPAGE=https://github.com/libfuse/libfuse
TERMUX_PKG_DESCRIPTION="FUSE (Filesystem in Userspace) is an interface for userspace programs to export a filesystem to the Linux kernel"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=3.9.3
TERMUX_PKG_SRCURL=https://github.com/libfuse/libfuse/archive/fuse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f8f7ad9cc6667c6751efa425dd0a665dcc9d75f0b7fc0cb5b85141a514110e9

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddisable-mtab=true
-Dexamples=false
-Dsbindir=bin
-Dmandir=share/man
-Dudevrulesdir=$TERMUX_PREFIX/etc/udev/rules.d
-Duseroot=false
"
