TERMUX_PKG_HOMEPAGE=http://www.squid-cache.org
TERMUX_PKG_DESCRIPTION="Full-featured Web proxy cache server"
TERMUX_PKG_VERSION=3.5.26
TERMUX_PKG_DEPENDS="libcrypt, openssl, libnettle, libltdl"
TERMUX_PKG_SRCURL=http://www.squid-cache.org/Versions/v3/3.5/squid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=baa1eecb7d6e18881f4455060d80ee7cb95ae7e2695fdccf7e21ccc8f879a982
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
# disk-io requires msgctl and store-io requires disk-io
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_sasl2_sasl_errstring=no
--disable-strict-error-checking
--disable-disk-io
--disable-storeio
--without-mit-krb5
--with-dl
--with-openssl
--disable-forw-via-db
--enable-auth
--without-libnettle
--enable-translation
--with-size-optimizations
--without-libxml2
--without-gnutls
--libexecdir=$TERMUX_PREFIX/libexec/squid
--sysconfdir=$TERMUX_PREFIX/etc/squid
--datarootdir=$TERMUX_PREFIX/share/squid
--mandir=$TERMUX_PREFIX/share/man
squid_cv_gnu_atomics=yes
"

termux_step_pre_configure () {
	LDFLAGS="$LDFLAGS -llog"

	# needed for building cf_gen
	export BUILDCXX=g++
	# else it picks up our cross CXXFLAGS
	export BUILDCXXFLAGS=' '
}

