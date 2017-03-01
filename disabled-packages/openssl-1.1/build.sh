TERMUX_PKG_HOMEPAGE=https://www.openssl.org/
TERMUX_PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
TERMUX_PKG_DEPENDS="ca-certificates"
TERMUX_PKG_VERSION=1.1.0e
TERMUX_PKG_SRCURL=https://www.openssl.org/source/openssl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=57be8618979d80c910728cfc99369bf97b2a1abd8f366ab6ebdee8975ad3874c
TERMUX_PKG_RM_AFTER_INSTALL="bin/c_rehash etc/ssl/misc"
TERMUX_PKG_BUILD_IN_SRC=yes
# Avoid assembly errors, see
# https://github.com/android-ndk/ndk/issues/144
# https://github.com/openssl/openssl/issues/1498
# May be fixed in later openssl version.
TERMUX_PKG_CLANG=no

# Information about compilation and installation of openssl:
# http://wiki.openssl.org/index.php/Compilation_and_Installation

termux_step_configure () {
	#perl -p -i -e "s@TERMUX_CFLAGS@$CFLAGS@g" Configure
	rm -Rf $TERMUX_PREFIX/lib/libcrypto.* $TERMUX_PREFIX/lib/libssl.*

	# See Configurations/10-main.conf
	export CROSS_SYSROOT=$TERMUX_STANDALONE_TOOLCHAIN/sysroot
	#export CROSS_COMPILE=${TERMUX_HOST_PLATFORM}-

	test $TERMUX_ARCH = "arm" && TERMUX_OPENSSL_PLATFORM="android-armeabi"
	test $TERMUX_ARCH = "aarch64" && TERMUX_OPENSSL_PLATFORM="android64-aarch64"
	test $TERMUX_ARCH = "i686" && TERMUX_OPENSSL_PLATFORM="android-x86"
	test $TERMUX_ARCH = "x86_64" && TERMUX_OPENSSL_PLATFORM="android64"

	# If enabling zlib-dynamic we need "zlib-dynamic" instead of "no-comp no-dso":
	./Configure $TERMUX_OPENSSL_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		--openssldir=$TERMUX_PREFIX/etc/tls \
		shared \
		no-comp \
		no-dso \
		no-ssl2 \
		no-hw \
		no-engine \
		no-psk \
		no-srp
}

termux_step_make () {
	make depend
	make -j 1 all
}

termux_step_make_install () {
	# "install_sw" instead of "install" to not install man pages:
	make -j 1 install_sw MANDIR=$TERMUX_PREFIX/share/man MANSUFFIX=.ssl
}
