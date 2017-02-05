TERMUX_PKG_HOMEPAGE=http://www.squid-cache.org
TERMUX_PKG_DESCRIPTION='Full-featured Web proxy cache server'
TERMUX_PKG_VERSION=3.5.24
TERMUX_PKG_DEPENDS="libcrypt, krb5, openssl, libnettle"
TERMUX_PKG_SRCURL=http://www.squid-cache.org/Versions/v3/3.5/squid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4fe29f582eef357faa541a53835b6885e24e6f28b80a3abcdf3b57f5393bbdb2
# disk-io requires shmem, msgctl and store-io requires disk-io
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-strict-error-checking --disable-auto-locale --disable-disk-io --disable-storeio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-openssl --enable-auth --with-nettle --disable-translation --with-size-optimizations"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --libexecdir=$TERMUX_PREFIX/libexec/squid --sysconfdir=$TERMUX_PREFIX/etc/squid --datarootdir=$TERMUX_PREFIX/share/squid"

termux_step_pre_configure () {
	#CPPFLAGS="$CPPFLAGS -DTERMUX_SHMEM_STUBS"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" squid_cv_gnu_atomics=yes"
	LDFLAGS="$LDFLAGS -llog"

	# needed for building cf_gen
	export BUILDCXX=g++
	# else it picks up our cross CXXFLAGS
	export BUILDCXXFLAGS=' '
}

