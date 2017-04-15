TERMUX_PKG_HOMEPAGE=http://www.squid-cache.org
TERMUX_PKG_DESCRIPTION="Full-featured Web proxy cache server"
TERMUX_PKG_VERSION=3.5.25
TERMUX_PKG_DEPENDS="libcrypt, openssl"
TERMUX_PKG_SRCURL=http://www.squid-cache.org/Versions/v3/3.5/squid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=28959254c32b8cd87e9599b6beb97352cf0638524e0f5ac3e1754f08462f3585
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
# disk-io requires msgctl and store-io requires disk-io
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-strict-error-checking --disable-disk-io --disable-storeio --without-mit-krb5 --with-dl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-openssl --enable-auth --without-libnettle --enable-translation --with-size-optimizations --without-libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --libexecdir=$TERMUX_PREFIX/libexec/squid --sysconfdir=$TERMUX_PREFIX/etc/squid --datarootdir=$TERMUX_PREFIX/share/squid"

termux_step_pre_configure () {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" squid_cv_gnu_atomics=yes"
	LDFLAGS="$LDFLAGS -llog"

	# needed for building cf_gen
	export BUILDCXX=g++
	# else it picks up our cross CXXFLAGS
	export BUILDCXXFLAGS=' '
}

