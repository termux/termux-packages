TERMUX_PKG_HOMEPAGE=http://sourceforge.net/projects/strace/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor the system calls used by a program and all the signals it receives"
TERMUX_PKG_VERSION=4.14
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/strace/strace/${TERMUX_PKG_VERSION}/strace-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5bed5110b243dce6864bedba269446c18c8c63f553cdd7fd4f808d89a764712f
TERMUX_PKG_RM_AFTER_INSTALL=bin/strace-graph # This is a perl script

termux_step_pre_configure () {
	if [ $TERMUX_ARCH_BITS = "64" ]; then
		# The strace configure script only looks for struct flock64 in <linux/fcntl.h>,
		# but we actually have it in <fcntl.h> here:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_type_struct_flock64=yes"
	fi

	CFLAGS+=" -DIOV_MAX=1024"
}

