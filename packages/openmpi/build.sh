TERMUX_PKG_HOMEPAGE=https://www.open-mpi.org
TERMUX_PKG_DESCRIPTION="The Open MPI Project is an open source Message Passing Interface implementation that is developed and maintained by a consortium of academic, research, and industry partners"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="2.1.1"
TERMUX_PKG_SRCURL=https://www.open-mpi.org/software/ompi/v${TERMUX_PKG_VERSION:0:3}/downloads/openmpi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=afe4bef3c4378bc76eea96c623d5aa4c1c98b9e057d281c646e68869292a77dc
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x
ac_cv_header_ifaddrs_h=no
ac_cv_header_stdint_h=no
ac_cv_header_stdlib_h=no
--disable-dlopen"

termux_step_pre_configure () {
	# rindex is an obsolete version of strrchr which is not available in Android:
	CFLAGS+=" -Drindex=strrchr"
	LDFLAGS+=" -llog"
}
