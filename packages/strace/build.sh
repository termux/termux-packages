TERMUX_PKG_HOMEPAGE=https://strace.io/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor the system calls used by a program and all the signals it receives"
TERMUX_PKG_VERSION=4.22
TERMUX_PKG_SHA256=068cd09264c95e4d591bbcd3ea08f99a693ed8663cd5169b0fdad72eb5bdb39d
TERMUX_PKG_SRCURL=https://strace.io/files/$TERMUX_PKG_VERSION/strace-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL=bin/strace-graph # This is a perl script
# Without st_cv_m32_mpers=no the build fails if gawk is installed.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
st_cv_m32_mpers=no
--enable-mpers=no
"

termux_step_pre_configure () {
	if [ $TERMUX_ARCH_BITS = "64" ]; then
		# The strace configure script only looks for struct flock64 in <linux/fcntl.h>,
		# but we actually have it in <fcntl.h> here:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_type_struct_flock64=yes"
	fi

	CFLAGS+=" -DIOV_MAX=1024"
}

