TERMUX_PKG_HOMEPAGE=https://www.openssl.org/
TERMUX_PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_DEPENDS="ca-certificates"
TERMUX_PKG_VERSION=1.1.1b
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=5c557b023230413dfb0756f3137a13e6d726838ccd1430888ad15bfb2b43ea4b
TERMUX_PKG_SRCURL=https://www.openssl.org/source/openssl-${TERMUX_PKG_VERSION/\~/-}.tar.gz
TERMUX_PKG_CONFFILES="etc/tls/openssl.cnf"
TERMUX_PKG_RM_AFTER_INSTALL="bin/c_rehash etc/ssl/misc"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS="libcurl (<< 7.61.0-1)"
TERMUX_PKG_BREAKS="openssl-tool (<< 1.1.1b-1)"
TERMUX_PKG_REPLACES="openssl-tool (<< 1.1.1b-1)"

termux_step_configure() {
	CFLAGS+=" -DNO_SYSLOG"
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi

	perl -p -i -e "s@TERMUX_CFLAGS@$CFLAGS@g" Configure
	rm -Rf $TERMUX_PREFIX/lib/libcrypto.* $TERMUX_PREFIX/lib/libssl.*
	test $TERMUX_ARCH = "arm" && TERMUX_OPENSSL_PLATFORM="android-arm"
	test $TERMUX_ARCH = "aarch64" && TERMUX_OPENSSL_PLATFORM="android-arm64"
	test $TERMUX_ARCH = "i686" && TERMUX_OPENSSL_PLATFORM="android-x86"
	test $TERMUX_ARCH = "x86_64" && TERMUX_OPENSSL_PLATFORM="android-x86_64"
	# If enabling zlib-dynamic we need "zlib-dynamic" instead of "no-comp no-dso":
	./Configure $TERMUX_OPENSSL_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		--openssldir=$TERMUX_PREFIX/etc/tls \
		shared \
		no-ssl \
		no-comp \
		no-dso \
		no-hw \
		no-srp \
		no-tests
}

termux_step_make() {
	make depend
	make -j $TERMUX_MAKE_PROCESSES all
}

termux_step_make_install() {
	# "install_sw" instead of "install" to not install man pages:
	make -j 1 install_sw MANDIR=$TERMUX_PREFIX/share/man MANSUFFIX=.ssl

	mkdir -p $TERMUX_PREFIX/etc/tls/
	cp apps/openssl.cnf $TERMUX_PREFIX/etc/tls/openssl.cnf
}
