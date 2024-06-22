TERMUX_PKG_HOMEPAGE=https://www.open-mpi.org
TERMUX_PKG_DESCRIPTION="Open source Message Passing Interface implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.1.5
TERMUX_PKG_SRCURL=https://download.open-mpi.org/release/open-mpi/v${TERMUX_PKG_VERSION:0:3}/openmpi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c018b127619d2a2a30c1931f316fc8a245926d0f5b4ebed4711f9695e7f70925
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libandroid-shmem, libevent, zlib"
TERMUX_PKG_BREAKS="openmpi-dev"
TERMUX_PKG_REPLACES="openmpi-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-x
--disable-dlopen
--disable-mpi-fortran
ac_cv_header_ifaddrs_h=no
ac_cv_member_struct_ifreq_ifr_hwaddr=no
"

termux_step_pre_configure () {
	# rindex is an obsolete version of strrchr which is not available in Android:
	CFLAGS+=" -Drindex=strrchr -Dbcmp=memcmp"
	LDFLAGS+=" -landroid-posix-semaphore -landroid-shmem"
	if [ $TERMUX_ARCH == "i686" ]; then
		# fails with "undefined reference to __atomic..."
		LDFLAGS+=" -latomic"
	fi

	./autogen.pl --force
}
