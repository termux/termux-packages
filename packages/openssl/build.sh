TERMUX_PKG_HOMEPAGE=https://www.openssl.org/
TERMUX_PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.6.1
TERMUX_PKG_SRCURL=https://github.com/openssl/openssl/releases/download/openssl-${TERMUX_PKG_VERSION:2}/openssl-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=b1bfedcd5b289ff22aee87c9d600f515767ebf45f77168cb6d64f231f518a82e
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="ca-certificates, zlib"
TERMUX_PKG_CONFFILES="etc/tls/openssl.cnf"
TERMUX_PKG_RM_AFTER_INSTALL="bin/c_rehash etc/ssl/misc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="libcurl (<< 7.61.0-1)"
TERMUX_PKG_BREAKS="openssl-tool (<< 1.1.1b-1), openssl-dev"
TERMUX_PKG_REPLACES="openssl-tool (<< 1.1.1b-1), openssl-dev"

termux_step_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
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
		--openssldir="$TERMUX_PREFIX/etc/tls" \
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
	make -j"$TERMUX_PKG_MAKE_PROCESSES" all
}

termux_step_make_install() {
	# "install_sw" instead of "install" to not install man pages:
	make -j1 install_sw MANDIR="$TERMUX_PREFIX/share/man" MANSUFFIX=.ssl

	mkdir -p "$TERMUX_PREFIX/etc/tls/"

	cp apps/openssl.cnf "$TERMUX_PREFIX/etc/tls/openssl.cnf"

	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/add-trusted-certificate" \
		> "$TERMUX_PREFIX/bin/add-trusted-certificate"
	chmod 700 "$TERMUX_PREFIX/bin/add-trusted-certificate"
}
