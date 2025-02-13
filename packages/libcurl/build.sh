TERMUX_PKG_HOMEPAGE=https://curl.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.12.1"
TERMUX_PKG_SRCURL=https://github.com/curl/curl/releases/download/curl-${TERMUX_PKG_VERSION//./_}/curl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0341f1ed97a26c811abaebd37d62b833956792b7607ea3f15d001613c76de202
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="libnghttp2, libnghttp3, libssh2, openssl (>= 1:3.2.1-1), zlib"
TERMUX_PKG_BREAKS="libcurl-dev"
TERMUX_PKG_REPLACES="libcurl-dev"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$TERMUX_PREFIX/bin/ntlm_auth
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-ca-path=$TERMUX_PREFIX/etc/tls/certs
--with-nghttp2
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--without-libpsl
--with-libssh2
--with-ssl
--with-openssl
--with-openssl-quic
--with-nghttp3
--disable-ares
"

# https://github.com/termux/termux-packages/issues/15889
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getpwuid=yes"

# Starting with version 7.62 curl started enabling http/2 by default.
# Support for http/2 as added in version 1.4.8-8 of the apt package, so we
# conflict with previous versions to avoid broken installations.
TERMUX_PKG_CONFLICTS="apt (<< 1.4.8-8)"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local a
	for a in VERSIONCHANGE VERSIONDEL; do
		local _${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				lib/Makefile.soname)
	done
	local v=$(( _VERSIONCHANGE - _VERSIONDEL ))
	if [ ! "${_VERSIONCHANGE}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,-z,nodelete"
}
