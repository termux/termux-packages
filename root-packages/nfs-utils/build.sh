TERMUX_PKG_HOMEPAGE=https://linux-nfs.org/
TERMUX_PKG_DESCRIPTION="Linux NFS userland utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/nfs/nfs-utils-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c0ae376ac056011ed0954deba2362d7d8193c653b500b68a543aec512cd2ecfa
TERMUX_PKG_DEPENDS="keyutils, libblkid, libcap, libdevmapper, libevent, libmount, libsqlite, libtirpc, libuuid, openldap"
TERMUX_PKG_BUILD_DEPENDS="libxml2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_resolv___res_querydomain=yes
libsqlite3_cv_is_recent=yes
--disable-gss
--disable-sbin-override
--with-modprobedir=$TERMUX_PREFIX/lib/modprobe.d
--with-mountfile=$TERMUX_PREFIX/etc/nfsmounts.conf
--with-nfsconfig=$TERMUX_PREFIX/etc/nfs.conf
--with-start-statd=$TERMUX_PREFIX/bin/start-statd
--with-statedir=$TERMUX_PREFIX/var/lib/nfs
"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/udev
"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -D__USE_GNU"

	local _lib="$TERMUX_PKG_BUILDDIR/_lib"
	rm -rf "${_lib}"
	mkdir -p "${_lib}"
	pushd "${_lib}"
	local f
	for f in strverscmp versionsort; do
		$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_BUILDER_DIR/${f}.c" \
			-fvisibility=hidden -c -o "./${f}.o"
	done
	$AR cru libversionsort.a strverscmp.o versionsort.o
	echo '!<arch>' > libresolv.a
	popd

	LDFLAGS+=" -L${_lib} -l:libversionsort.a"
}
