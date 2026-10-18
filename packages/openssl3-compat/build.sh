TERMUX_PKG_HOMEPAGE=https://www.openssl.org/
TERMUX_PKG_DESCRIPTION="OpenSSL 3.x shared libraries for programs not yet rebuilt against OpenSSL 4"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.5
TERMUX_PKG_SRCURL=https://github.com/openssl/openssl/releases/download/openssl-${TERMUX_PKG_VERSION}/openssl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a2157c2830efdec3788939b00c9b0638306d3f0bbb76dc4832ee503bb397df98
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="ca-certificates, zlib"
TERMUX_PKG_CONFFILES="etc/tls-3/openssl.cnf"
TERMUX_PKG_REPLACES="openssl (<< 1:4.0.3)"
TERMUX_PKG_RM_AFTER_INSTALL="
bin
include
lib/cmake
lib/libcrypto.a
lib/libcrypto.so
lib/libssl.a
lib/libssl.so
lib/pkgconfig
etc/ssl
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == 'true' ]]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	CFLAGS+=" -DNO_SYSLOG"

	sed -i "s@TERMUX_CFLAGS@$CFLAGS@g" Configure
	rm -rf "$TERMUX_PREFIX/lib"/libcrypto.* "$TERMUX_PREFIX/lib"/libssl.*

	local TERMUX_OPENSSL_PLATFORM="android-${TERMUX_ARCH}"
	case "$TERMUX_ARCH" in
		"arm"|"x86_64");;
		"aarch64") TERMUX_OPENSSL_PLATFORM="android-arm64";;
		"i686") TERMUX_OPENSSL_PLATFORM="android-x86";;
		*) termux_error_exit "Unsupported architecture: '$TERMUX_ARCH'"
	esac

	./Configure "$TERMUX_OPENSSL_PLATFORM" \
		--prefix="$TERMUX_PREFIX" \
		--openssldir="$TERMUX_PREFIX/etc/tls-3" \
		shared \
		zlib-dynamic \
		no-ssl \
		no-hw \
		no-srp \
		no-tests \
		enable-tls1_3
}

termux_step_make() {
	make depend
	make -j"$TERMUX_PKG_MAKE_PROCESSES" all MODULESDIR="$TERMUX_PREFIX/lib/ossl-modules-3"
}

termux_step_make_install() {
	make -j1 install_sw MODULESDIR="$TERMUX_PREFIX/lib/ossl-modules-3" MANDIR="$TERMUX_PREFIX/share/man" MANSUFFIX=.ssl

	mkdir -p "$TERMUX_PREFIX/etc/tls-3"
	cp apps/openssl.cnf "$TERMUX_PREFIX/etc/tls-3/openssl.cnf"
	ln -sf ../tls/cert.pem "$TERMUX_PREFIX/etc/tls-3/cert.pem"
	ln -sfn ../tls/certs "$TERMUX_PREFIX/etc/tls-3/certs"
}
