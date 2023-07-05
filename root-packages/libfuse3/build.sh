TERMUX_PKG_HOMEPAGE=https://github.com/libfuse/libfuse
TERMUX_PKG_DESCRIPTION="FUSE (Filesystem in Userspace) is an interface for userspace programs to export a filesystem to the Linux kernel"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=3.15.1
TERMUX_PKG_SRCURL=https://github.com/libfuse/libfuse/archive/fuse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cb93e170288804d2e83da9b69925d968655ed75883476773ba5268d08bb1d335

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddisable-mtab=true
-Dexamples=false
-Dtests=false
-Dsbindir=bin
-Dmandir=share/man
-Dudevrulesdir=$TERMUX_PREFIX/etc/udev/rules.d
-Duseroot=false
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__off64_t=off64_t"
}
