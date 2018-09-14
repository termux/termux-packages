TERMUX_PKG_HOMEPAGE=https://www.open-mpi.org
TERMUX_PKG_DESCRIPTION="The Open MPI Project is an open source Message Passing Interface implementation that is developed and maintained by a consortium of academic, research, and industry partners"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=3.1.2
TERMUX_PKG_SRCURL=https://download.open-mpi.org/release/open-mpi/v${TERMUX_PKG_VERSION:0:3}/openmpi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=363c8a1258d12df28657e9b13bfe41e30fc129a4cfb89fcf53ff68bbe1bd65b3
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x
ac_cv_header_ifaddrs_h=no
--disable-dlopen
--disable-mpi-fortran
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
