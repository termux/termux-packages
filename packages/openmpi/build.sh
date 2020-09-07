TERMUX_PKG_HOMEPAGE=https://www.open-mpi.org
TERMUX_PKG_DESCRIPTION="Open source Message Passing Interface implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.0.5
TERMUX_PKG_SRCURL=https://download.open-mpi.org/release/open-mpi/v${TERMUX_PKG_VERSION:0:3}/openmpi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=572e777441fd47d7f06f1b8a166e7f44b8ea01b8b2e79d1e299d509725d1bd05
TERMUX_PKG_DEPENDS="libandroid-shmem"
TERMUX_PKG_BREAKS="openmpi-dev"
TERMUX_PKG_REPLACES="openmpi-dev"
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
	LDFLAGS="${LDFLAGS/-Wl,--as-needed/}"
	LDFLAGS+=" -landroid-shmem"
	if [ $TERMUX_ARCH == "i686" ]; then
		# fails with "undefined reference to __atomic..."
		LDFLAGS+=" -latomic"
	fi
}
