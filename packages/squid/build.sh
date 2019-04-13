TERMUX_PKG_HOMEPAGE=http://www.squid-cache.org
TERMUX_PKG_DESCRIPTION="Full-featured Web proxy cache server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=4.6
TERMUX_PKG_SHA256=015bade5d3a4905142c4c605df5c4216471e3d8338079955e0e44b0ae0303d41
TERMUX_PKG_SRCURL=http://www.squid-cache.org/Versions/v4/squid-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libcrypt, openssl, libnettle, libltdl"
# disk-io requires msgctl and store-io requires disk-io
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_sasl2_sasl_errstring=no
ac_cv_dbopen_libdb=no
squid_cv_gnu_atomics=yes
--disable-external-acl-helpers
--disable-strict-error-checking
--disable-disk-io
--disable-esi
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
--enable-delay-pools
--libexecdir=$TERMUX_PREFIX/libexec/squid
--sysconfdir=$TERMUX_PREFIX/etc/squid
--datarootdir=$TERMUX_PREFIX/share/squid
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	LDFLAGS="$LDFLAGS -llog"

	# needed for building cf_gen
	export BUILDCXX=g++
	# else it picks up our cross CXXFLAGS
	export BUILDCXXFLAGS=' '
}

