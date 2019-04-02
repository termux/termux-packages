TERMUX_PKG_HOMEPAGE=https://www.open-mpi.org
TERMUX_PKG_DESCRIPTION="The Open MPI Project is an open source Message Passing Interface implementation that is developed and maintained by a consortium of academic, research, and industry partners"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_SRCURL=https://download.open-mpi.org/release/open-mpi/v${TERMUX_PKG_VERSION:0:3}/openmpi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e55e213fe09a214ab9f2c722acfd8bf7b39bbc1800e4b7a464d38df15e707f59
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-x
ac_cv_header_ifaddrs_h=no
--disable-dlopen
--disable-mpi-fortran
ac_cv_member_struct_ifreq_ifr_hwaddr=no
"

termux_step_pre_configure () {
	# rindex is an obsolete version of strrchr which is not available in Android:
	CFLAGS+=" -Drindex=strrchr -Dbcmp=memcmp"
	LDFLAGS+=" -llog"
	if [ $TERMUX_ARCH == "i686" ]; then
		# fails with "undefined reference to __atomic..."
		LDFLAGS+=" -latomic"
	fi
}
