TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_VERSION=9.6.1
TERMUX_PKG_HOMEPAGE=https://www.postgresql.org
TERMUX_PKG_SRCURL=https://ftp.postgresql.org/pub/source/v$TERMUX_PKG_VERSION/postgresql-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="openssl, libcrypt, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --without-gssapi --with-readline --with-openssl --with-system-tzdata=/system/usr/share/zoneinfo"
TERMUX_PKG_EXTRA_MAKE_ARGS=" -s"

termux_step_pre_configure () {
	# to use shmem and sem stubs
	#CPPFLAGS="$CPPFLAGS -DTERMUX_SHMEM_STUBS -DTERMUX_SEMOPS_STUBS -DEXEC_BACKEND"
	CFLAGS="$CFLAGS -DTERMUX_SHMEM_STUBS=1 -DTERMUX_SEMOPS_STUBS=1"
	LDFLAGS="$LDFLAGS -llog"
}

