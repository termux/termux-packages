TERMUX_PKG_HOMEPAGE=https://www.open-mpi.org
TERMUX_PKG_DESCRIPTION="Open source Message Passing Interface implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=5.0.11
TERMUX_PKG_SRCURL=https://download.open-mpi.org/release/open-mpi/v${TERMUX_PKG_VERSION:0:3}/openmpi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=77a402c64c22f1bd8a504f76fd411df23e36e168eedce6c9bcd12c8c0cd0619a
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libandroid-shmem, libevent, zlib"
TERMUX_PKG_BREAKS="openmpi-dev"
TERMUX_PKG_REPLACES="openmpi-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pterm share/man/man1/pterm.1.gz"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-x
--disable-dlopen
--disable-mpi-fortran
--with-hwloc=internal
--with-pmix=internal
--with-prrte=internal
--without-cma
--enable-mca-no-build=btl-sm
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

}
